Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8237C63AB48
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 15:41:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232419AbiK1Oky (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 09:40:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232593AbiK1Okm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 09:40:42 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 047622182A;
        Mon, 28 Nov 2022 06:40:40 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id ha10so26387126ejb.3;
        Mon, 28 Nov 2022 06:40:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5gVpZoIcGzhQvJrBd72tFluMZzAXososa0NIa3yIeww=;
        b=HGxnq78O0ylf3Z/QIR752ISXM6JxXW8pyS4nmT0j/g5RAnLNiI9PiIHky8CTBCzeb8
         qOnVERJiAs3qfDHF2swRjb5doPU6F+tjmaCyd7aVBN8jcb/hexmNQvShNn2eNmIRBwL9
         jL6cL1r/F+7MZugkrtARLSrszjUbdK4zOUiiipWD3IA4ngmpMsIMvqC2aA9asswE8cBE
         ZQQrs3DSn+d/BqGA0FqICwUKhhDfuE2wmGuDhW+uGFPv1LiYSJEBVbJLTCgeIcBZeQil
         f+y4kTHuapeWeFo4aJLcc0Iyb1QzRI1layd0U0vUj0MlgiCdZN9cIYJykQ8lvo2UwjJ7
         52og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5gVpZoIcGzhQvJrBd72tFluMZzAXososa0NIa3yIeww=;
        b=1xZaP2ekNjeEV7XViEK14MQ4CN5Fu2hmxdLCJ+LocwBMYZWhj+fy5ekPbbnzxhbDhC
         DhNpUCm1b+Pq7JsNes5wu0cEbu6JF5ge+/k+Lhdoco128J7C4yQ9WxJM+tslJZ4ITvhf
         txRjDkP2OLY338pa3q6f7nVdkifbu1PEsbdY7Z2+U4C8bzUq/wnLl69A6QSdyMGvkeml
         0Vjp7TB9ceBemVnR3je+3qiMkoAQ+Nd8X1H5w46IRKu3bMFhJSH/mx6CrAMG4vQamgXv
         Xn8bbtJO78ADkUGWaIf2RD9kmqKVzYu6ncYwvkdsJQkNSgoxWiLTolgMZZonq6rIiaie
         pByw==
X-Gm-Message-State: ANoB5pkPrnfS7QtZwRSKJqOfqQZCHfJsgHH5ESc2JVWwYro/v3iNQAyE
        Yb6Fyju9KpmVtliNtQjyZ4A=
X-Google-Smtp-Source: AA0mqf7w/3u9b/oG77g/S/1w96g1gNRDWPHsRK05PycFQ953Yv7FWkqgPjUwwIAnv7RdCAEG6RiLJQ==
X-Received: by 2002:a17:906:3505:b0:7c0:390:d35b with SMTP id r5-20020a170906350500b007c00390d35bmr3947742eja.570.1669646439085;
        Mon, 28 Nov 2022 06:40:39 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id er12-20020a056402448c00b0045bd14e241csm4043471edb.76.2022.11.28.06.40.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Nov 2022 06:40:38 -0800 (PST)
Date:   Mon, 28 Nov 2022 17:40:35 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     Pavan Chebbi <pavan.chebbi@broadcom.com>
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next v2] bonding: uninitialized variable in
 bond_miimon_inspect()
Message-ID: <Y4TIYx37CiNGDSc5@kadam>
References: <Y4SWJlh3ohJ6EPTL@kili>
 <CALs4sv3xJXJvWwcGk8N_s1mW9Y7GpEz6Bqv-DJO_q7hPi2yTLA@mail.gmail.com>
 <Y4THeSrc0lOJP/AJ@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4THeSrc0lOJP/AJ@kadam>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 28, 2022 at 05:36:41PM +0300, Dan Carpenter wrote:
> On Mon, Nov 28, 2022 at 07:15:39PM +0530, Pavan Chebbi wrote:
> > On Mon, Nov 28, 2022 at 4:36 PM Dan Carpenter <error27@gmail.com> wrote:
> > >
> > > The "ignore_updelay" variable needs to be initialized to false.
> > >
> > > Fixes: f8a65ab2f3ff ("bonding: fix link recovery in mode 2 when updelay is nonzero")
> > > Signed-off-by: Dan Carpenter <error27@gmail.com>
> > > ---
> > > v2: Re-order so the declarations are in reverse Christmas tree order
> > >
> > Thanks,
> > Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
> > 
> > > Don't forget about:
> > > drivers/net/bonding/bond_main.c:5071 bond_update_slave_arr() warn: missing error code here? 'bond_3ad_get_active_agg_info()' failed. 'ret' = '0'
> > >
> > 
> > I think that warning can be ignored, as bond_update_slave_arr() does
> > consider the return value of bond_3ad_get_active_agg_info() but
> > chooses to not bubble it up. Though the author of the function is the
> > best person to answer it, at this point, it looks OK to me. Maybe a
> > separate patch to address it would help to get the attention of the
> > author.
> 
> Heh...  That's slightly vague.
> 
> You're wrong to say that none of the callers care about the error code.
> It is checked in bond_slave_arr_handler().

If you don't know that's fine also...  All the maintainers are CC'd.  If
they really care they can take a look otherwise there are so many other
obvious bugs to care about and this is very minor.

regards,
dan carpenter

