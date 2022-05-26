Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFEEB534C3D
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 11:06:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346809AbiEZJGG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 05:06:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346817AbiEZJF7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 05:05:59 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B99EC6E4C
        for <netdev@vger.kernel.org>; Thu, 26 May 2022 02:05:56 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id f9so1898037ejc.0
        for <netdev@vger.kernel.org>; Thu, 26 May 2022 02:05:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZVTxrpQfdIQ4koNEw+o5P1bv5QW3EM7YT0ULdcbf29s=;
        b=jUhTbvTIobEv9yQHQL9IhUPb0JjegeMBEm7V9kBehwko7FEU+KGmBjuczBSk96ElOe
         mdPkpBAtAaQEXnlKTjZi+6kAegx1ccnQm1sDJHjZB38cEa8LulyC6gcjMr78jivnfVCS
         uaqH5iHqeJI1O30We+Yycpo0DUdDcXrtMJ51NDgSAenIDoRkaNJy+pmouUyG3jkqJWRy
         fpvn3CTU17JYqjXGbvjlxNj054cn7qRgO+1nH3b8Qx+ztSLvRKADA73JedMoZYzH5pHu
         nuOukSi1+KFqfD134h/oUD49kmwi+O05NkT0ABOxobo72iUSR8d6Dwb1LuZtIjXnA5IP
         aoyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZVTxrpQfdIQ4koNEw+o5P1bv5QW3EM7YT0ULdcbf29s=;
        b=TnTJMhvvL/P/hb1FBT06v53pk5D1ysKlDtW/HNM8fC+yLNC3nRtCEGlM0SwcacYyvQ
         pHzs2yKOYD2qT6zjxaw5FasAFYN1R4ySpShWFoWJi1fYjacF/6Qru2ynuf7qD/D40Ul1
         esl6dzetBch30l9a8R/dXxL2gAyS72Eif+/yMdMWMMVjFuOQXHJxnOeGHry9O0NpmFiw
         aF1DKLU+ulZETq2h5Usmw+LzgCQE4RlJLWG8lUzNAyTC+mWcQDUbzgw8IeSXf3w+opZu
         NSa3VhLEAjZ2W4jcOQjChhcC2gT+aR+W5HrgF16Le4bs9Hk5seHfnDnTUxKAyOikGazx
         9EhA==
X-Gm-Message-State: AOAM533bPoL+Bm0xTMLIXTSTpAJ3C2qUJZPesIAM8Ge6nYEPLAEhxorC
        sYiJm3+/1AjixT1Ir/n5P3Jv7A==
X-Google-Smtp-Source: ABdhPJzs5SvzC6vOXq3jClZb+8xkj0+W24GgrRDRTgD49n8YHx7Nxz0gcjYKMme5Y/1klm/KRRiF1g==
X-Received: by 2002:a17:907:6e11:b0:6fe:feaa:bb04 with SMTP id sd17-20020a1709076e1100b006fefeaabb04mr13476382ejc.187.1653555955079;
        Thu, 26 May 2022 02:05:55 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id 18-20020a508e12000000b0042617ba63c8sm512985edw.82.2022.05.26.02.05.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 May 2022 02:05:54 -0700 (PDT)
Date:   Thu, 26 May 2022 11:05:53 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Ido Schimmel <idosch@idosch.org>, Ido Schimmel <idosch@nvidia.com>,
        netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        jiri@nvidia.com, petrm@nvidia.com, dsahern@gmail.com,
        andrew@lunn.ch, mlxsw@nvidia.com
Subject: Re: [PATCH net-next 00/11] mlxsw: extend line card model by devices
 and info
Message-ID: <Yo9C8aKhTuqsQW1q@nanopsycho>
References: <20220429153845.5d833979@kernel.org>
 <YmzW12YL15hAFZRV@nanopsycho>
 <20220502073933.5699595c@kernel.org>
 <YotW74GJWt0glDnE@nanopsycho>
 <20220523105640.36d1e4b3@kernel.org>
 <Yox/TkxkTUtd0RMM@nanopsycho>
 <YozsUWj8TQPi7OkM@nanopsycho>
 <20220524110057.38f3ca0d@kernel.org>
 <Yo3KvfgTVTFM/JHL@nanopsycho>
 <20220525085054.70f297ac@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220525085054.70f297ac@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, May 25, 2022 at 05:50:54PM CEST, kuba@kernel.org wrote:
>On Wed, 25 May 2022 08:20:45 +0200 Jiri Pirko wrote:
>> >We talked about this earlier in the thread, I think. If you need both
>> >info and flash per LC just make them a separate devlink instance and
>> >let them have all the objects they need. Then just put the instance
>> >name under lc info.  
>> 
>> I don't follow :/ What do you mean be "separate devlink instance" here?
>> Could you draw me an example?
>
>Separate instance:
>
>	for (i = 0; i < sw->num_lcs; i++) {
>		devlink_register(&sw->lc_dl[i]);
>		devlink_line_card_link(&sw->lc[i], &sw->lc_dl[i]);
>	}
>
>then report that under the linecard
>
>	nla_nest_start(msg, DEVLINK_SUBORDINATE_INSTANCE);
>	devlink_nl_put_handle(msg, lc->devlink);
>	nla_nest_end(msg...)
>
>then user can update the linecard like any devlink instance, switch,
>NIC etc. It's better code reuse and I don't see any downside, TBH.

I think you already suggested something like that. What you mean is that
linecard would be modeled as any other devlink instance. Sorry, but that
does not make any sense to me at all :/ Should devlink port not be
devlink port and rather modeled as a separate devlink instance too? Same
to the rest of the objects we already have. Should we have a tree of
same devlink objects each overloaded to some specific type. If yes, that
is completely changing the devlink modelling.

The handle of the devlink object is bus_name/dev_name. In other words,
there is a device on a bus and for each you can create devlink instance.
Linecards is not on a any bus, is is not modeled in /sys. What would be
the handle?

What you suggest seems to me like completely broken :/

I don't understand the motivation :/ The only I can think of that you
will have the same "devlink dev flash" mechanism, but that's it.
I'm not sure I understand why we cannot resolve the flashing otherwise,
for example as I suggested with "devlink lc info" and "devlink lc
flash". What is wrong with that?
