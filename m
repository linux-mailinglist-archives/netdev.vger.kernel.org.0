Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3BC6534D87
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 12:47:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238675AbiEZKr5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 06:47:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235728AbiEZKr5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 06:47:57 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AC22C8BF4
        for <netdev@vger.kernel.org>; Thu, 26 May 2022 03:47:55 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id h11so1315013eda.8
        for <netdev@vger.kernel.org>; Thu, 26 May 2022 03:47:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KXjfdPuHpqxmYEyt4I3sT2GftqGU0zvugDIqxWRgmYk=;
        b=IMXaRT6IR2+6bdsYIDN4HUMQKtk2ggHwxgpmmxQZIz0XTenRksdvtCIaek9xZdCPJV
         tjA8Znvd5W/TaInun0yoNmwTdLZUnRi47yCqfGMxo5J0fj/mE9ByohsOjkd7OPphRtC2
         vFDYa9mAxUnMzRxiayPBFtrNOJ6J9nvxEiJBi6Mo4BXYKBhjS8RClAsbzW92d81q1r9r
         p9M5H/0QCoeP1kf3ae+wKk1628aigdld7VfhxxXHraQ+midLytOcVW+ULow1W5nzAAyG
         2NZ3oUeiY5jNmWJbzXVRcjpG+lPV9cWE5yWdgw0nGs03wthN1ZCifMX088AmBeoB8rOo
         Q/dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KXjfdPuHpqxmYEyt4I3sT2GftqGU0zvugDIqxWRgmYk=;
        b=ZXWErbZ+iQGyH5MZB/MpYQdInz1ux/UHWySIbBhPbfnorJIvEwgBLkEZ1tP/GpPVPW
         MzIH32WJfcVz+uBqLfMZvGNlPlljnEavi3TaDgNDvQc4J7NTNfXsOVoixaTtdrV5I1pV
         O/SnMetA3UHIiGaWOa/ciQ9pry3rorYRvLQaJ+3S7/neW8HiRzi/gYGNttB2ujOf3UbM
         qym2KoN6pgmkbaEeC+U7ARL3GjEsAnfzirGVW+SMv7cxazflFIH9LOtfprrO2TB/Xd9D
         +FnlJQWoUJJQi2U1d9q8rxmHJQn7i39UNQ2FHliugoE2p/sOFMMX76AfBCLDKEEw52PE
         tsDA==
X-Gm-Message-State: AOAM530Jtbb7cJPZqiZAZ8qRJuQ/chbqeoGhljUS4J6TN2ByC0KEGley
        taOGmZWCs/RrhdRmATUfHXAIXQ==
X-Google-Smtp-Source: ABdhPJwMC6R1wF3rW+goRvRQr1cqrma/jxpc592CbJbAgE1dKrK0NOKnNsm4ynQNsfu48pv7Q9jhJg==
X-Received: by 2002:a05:6402:741:b0:42a:8fad:8f67 with SMTP id p1-20020a056402074100b0042a8fad8f67mr38996081edy.285.1653562073589;
        Thu, 26 May 2022 03:47:53 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id hp17-20020a1709073e1100b006fecb577060sm404345ejc.119.2022.05.26.03.47.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 May 2022 03:47:52 -0700 (PDT)
Date:   Thu, 26 May 2022 12:47:51 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Ido Schimmel <idosch@idosch.org>, Ido Schimmel <idosch@nvidia.com>,
        netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        jiri@nvidia.com, petrm@nvidia.com, dsahern@gmail.com,
        andrew@lunn.ch, mlxsw@nvidia.com
Subject: Re: [PATCH net-next 00/11] mlxsw: extend line card model by devices
 and info
Message-ID: <Yo9a10HFPo/yd9RY@nanopsycho>
References: <YmzW12YL15hAFZRV@nanopsycho>
 <20220502073933.5699595c@kernel.org>
 <YotW74GJWt0glDnE@nanopsycho>
 <20220523105640.36d1e4b3@kernel.org>
 <Yox/TkxkTUtd0RMM@nanopsycho>
 <YozsUWj8TQPi7OkM@nanopsycho>
 <20220524110057.38f3ca0d@kernel.org>
 <Yo3KvfgTVTFM/JHL@nanopsycho>
 <20220525085054.70f297ac@kernel.org>
 <Yo9C8aKhTuqsQW1q@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yo9C8aKhTuqsQW1q@nanopsycho>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, May 26, 2022 at 11:05:53AM CEST, jiri@resnulli.us wrote:
>Wed, May 25, 2022 at 05:50:54PM CEST, kuba@kernel.org wrote:
>>On Wed, 25 May 2022 08:20:45 +0200 Jiri Pirko wrote:
>>> >We talked about this earlier in the thread, I think. If you need both
>>> >info and flash per LC just make them a separate devlink instance and
>>> >let them have all the objects they need. Then just put the instance
>>> >name under lc info.  
>>> 
>>> I don't follow :/ What do you mean be "separate devlink instance" here?
>>> Could you draw me an example?
>>
>>Separate instance:
>>
>>	for (i = 0; i < sw->num_lcs; i++) {
>>		devlink_register(&sw->lc_dl[i]);
>>		devlink_line_card_link(&sw->lc[i], &sw->lc_dl[i]);
>>	}
>>
>>then report that under the linecard
>>
>>	nla_nest_start(msg, DEVLINK_SUBORDINATE_INSTANCE);
>>	devlink_nl_put_handle(msg, lc->devlink);
>>	nla_nest_end(msg...)
>>
>>then user can update the linecard like any devlink instance, switch,
>>NIC etc. It's better code reuse and I don't see any downside, TBH.
>
>I think you already suggested something like that. What you mean is that
>linecard would be modeled as any other devlink instance. Sorry, but that
>does not make any sense to me at all :/ Should devlink port not be
>devlink port and rather modeled as a separate devlink instance too? Same
>to the rest of the objects we already have. Should we have a tree of
>same devlink objects each overloaded to some specific type. If yes, that
>is completely changing the devlink modelling.
>
>The handle of the devlink object is bus_name/dev_name. In other words,
>there is a device on a bus and for each you can create devlink instance.
>Linecards is not on a any bus, is is not modeled in /sys. What would be
>the handle?
>
>What you suggest seems to me like completely broken :/

After some thinking I think I understand why you suggest this.
The versions in dev info and dev flash is there on devlink instance level,
so you would like to reuse it.

But it does not click. Having devlink instance just for this feels very
artificial, unfitting and heavy. IDK.


>
>I don't understand the motivation :/ The only I can think of that you
>will have the same "devlink dev flash" mechanism, but that's it.
>I'm not sure I understand why we cannot resolve the flashing otherwise,
>for example as I suggested with "devlink lc info" and "devlink lc
>flash". What is wrong with that?
