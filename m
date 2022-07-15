Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14B6D575C4E
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 09:29:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231812AbiGOH2t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 03:28:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231747AbiGOH2n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 03:28:43 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B848ACE37
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 00:28:41 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id h17so5624804wrx.0
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 00:28:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=oUPyocyhF7nsNR51kTPtLMQc/jcxuy3IheUiifeVadI=;
        b=Zo/f+IERnanGjW/jcCBYYsWVzVNHcqxkmzie5QKs/55VpMB5E7v9wskDI02ABdYNa8
         dJliXL+kaCHDoS0oujrgXPn6GUO+6cfTrfIiHTP+wcSbDZo3zokCN8C0oWksaLuKYtk+
         eOKHd5Z709HeoN8wBpnp1qg7OQFLM9z0ZYMzKfzcUVZGkBUQ37nomelobYoAdKALBQwx
         JKfkYM2a+2jQvagiBmvxREuBhFL82yYX3fxuDEeCEIwHr7QLAvCXdGfkoQBpN/SkNnqm
         oztcKOzHO0Dl/sZ5VS6W7NuZACHPvLD/Rml68/f+lWhkJKCUIs1cwusM6XxxdVyGdv6e
         cGJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=oUPyocyhF7nsNR51kTPtLMQc/jcxuy3IheUiifeVadI=;
        b=Yj4C/VbxCthJELzbCwahtCTNyewY9DmVf+kY4JIA5y73/GWpoVg/wPyjoRgOk3QCiD
         lRkKdCfZTcbOMQ3GntG9oEomRv+l9cedf4Wytb1Z+M5Dzr8q7r9qdBoPGClTPD0pBP8L
         cTF6UMEZ5FWzy2+I2obN5mSL0HtjNVXytD/MKARxWchEsjBNsiiNNhH4GaaWBCKqo/Jl
         xJ4Bnvg6H6rPkzj8n+fu84ZEeeEwJcTv15P+TdVZpXrefTb2S71/bP4jkHUG88HBEHwZ
         ho6KZJJYxoXBTgVbejIj/4JPflPMkceEaVfDkIcH9VXFpxQznkceJCHigD68eWm3DJdP
         FH5Q==
X-Gm-Message-State: AJIora/xZywXZt6tdB1xveuzSquhMbl92SotsFz9A91ypH2jh7wuf3Xl
        aHJUzBXd/WXsPxyaB0Ce0D2zNw==
X-Google-Smtp-Source: AGRyM1vHH32zvSkvS4Mr4+dOJdgonHSMCGgCq4dttb1qQVeMugXCYAY6gbmndZ8xKiLXkKPuRWKbQA==
X-Received: by 2002:a5d:414b:0:b0:21d:6e93:59c8 with SMTP id c11-20020a5d414b000000b0021d6e9359c8mr11686011wrq.290.1657870120167;
        Fri, 15 Jul 2022 00:28:40 -0700 (PDT)
Received: from google.com (cpc155339-bagu17-2-0-cust87.1-3.cable.virginm.net. [86.27.177.88])
        by smtp.gmail.com with ESMTPSA id g6-20020a056000118600b0021d7050ace4sm3212357wrx.77.2022.07.15.00.28.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jul 2022 00:28:39 -0700 (PDT)
Date:   Fri, 15 Jul 2022 08:28:37 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        LKML <linux-kernel@vger.kernel.org>, stable@kernel.org,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [RESEND 1/1] Bluetooth: Use chan_list_lock to protect the whole
 put/destroy invokation
Message-ID: <YtEXJRpOx9kADVcs@google.com>
References: <20220622082716.478486-1-lee.jones@linaro.org>
 <CANn89iK-uFP6Swgc0ZeEC38UsuywJ3wbybSNouH202Wa7X7Tzg@mail.gmail.com>
 <CABBYNZ+C=MQ7577Fr5_W8tQ4iWRSDBSiC4fkRBY3x=9ph+YAzA@mail.gmail.com>
 <CABBYNZLysdh3NFK+G8=NUQ=G=hvS8X0PdMp=bVqiwPDPCAokmg@mail.gmail.com>
 <YrxvgIiWuFVlXBaQ@google.com>
 <CABBYNZJFSxk9=3Gj7jOj__s=iJGmhrZ=CA7Mb74_-Y0sg+N40g@mail.gmail.com>
 <YsVptCjpzHjR8Scv@google.com>
 <CABBYNZKvVKRRdWnX3uFWdTXJ_S+oAj6z72zgyV148VmFtUnPpA@mail.gmail.com>
 <CABBYNZLTzW3afEPVfg=uS=xsPP-JpW6UBp6W=Urhhab+ai+dcA@mail.gmail.com>
 <CABBYNZJXiGHB+pyKq3uPaGfP29VdauevrBPeXbcU0LEHcEf_hg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABBYNZJXiGHB+pyKq3uPaGfP29VdauevrBPeXbcU0LEHcEf_hg@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Hi Lee,
> > > > > > I'm struggling to apply this for test:
> > > > > >
> > > > > >   "error: corrupt patch at line 6"
> > > > >
> > > > > Check with the attached patch.
> > > >
> > > > With the patch applied:
> > > >
> > > > [  188.825418][   T75] refcount_t: addition on 0; use-after-free.
> > > > [  188.825418][   T75] refcount_t: addition on 0; use-after-free.
> > >
> > > Looks like the changes just make the issue more visible since we are
> > > trying to add a refcount when it is already 0 so this proves the
> > > design is not quite right since it is removing the object from the
> > > list only when destroying it while we probably need to do it before.
> > >
> > > How about we use kref_get_unless_zero as it appears it was introduced
> > > exactly for such cases (patch attached.)
> >
> > Looks like I missed a few places like l2cap_global_chan_by_psm so here
> > is another version.
> 
> Any feedback regarding these changes?

Not yet.  I'll have time to test this next week.

Things really stacked up this week, apologies.

-- 
Lee Jones [李琼斯]
Principal Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
