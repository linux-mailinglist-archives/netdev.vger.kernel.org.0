Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0A6564B735
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 15:21:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235692AbiLMOVH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 09:21:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234673AbiLMOVG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 09:21:06 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB0E115A2D
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 06:20:58 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id n3so2266364pfq.10
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 06:20:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=yonsei-ac-kr.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rhdCATGaNa4PelTkR0mXXomKyQ8iesE1Yvm1J+BFYZc=;
        b=phpZz2+Z+s/gRkVILEQsjV00v3WIme8/mR0LswBWh5F2pUjSKW7kh8rS+qvMVQ6kMo
         Qy0yFTiiqjp/bJm6R+f+M1wsolK3SPJ0QJvuXoHog7IBtVZ/lWWoGCdpWGEYhJxGz0KZ
         ym4AUzI9sziWOFZsIOVKlWTD48lX/gtzzqNFOeGXrKH3G1T8eBDqFncQAwhvo+jZEfjq
         pE/CibRhxwgfU2qUIpc/+4b8CUHLpooNCLPTHFqw6mWTo8Dy8B+OwNVyprAnrcJ/sMjP
         r+UvGCeRLM2806bvQ3/SxA8YebpgQwKKXlyYgg8hRmXlNusZkF2MM4Rbrv50FzwoZpLM
         eGFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rhdCATGaNa4PelTkR0mXXomKyQ8iesE1Yvm1J+BFYZc=;
        b=sMW5qW2uSnDB1SchWsMMZ/xkbzgSvrg9OQpMXZbkugogcuZwf587bb9ONj+Dhw38s3
         Q9pk6xOLWzcnlmHUHDq2Lz8a9QuFfaPLtjK+JcszWP9DNu8kQjtpAN0voDaDGMJBBM0t
         T8sc1y5VKpStzGCTohud9PMLPpASdzerU72y0Ubqv/jnLl04rpywPZgT63d4EUp7cAjz
         ZmzoypGRayHWSee0uesbEhWJO+pQJYd9bFe+QClDjA2pNZ7TPUedqFdsljPtIqpl5PJp
         Yzk+SemYd7KvqQI85DjZPWSoezePPdQPjqSMtjP6iDqU8pMi/piQd02lZGuIYM8EVxtH
         qZ+g==
X-Gm-Message-State: ANoB5plAmo30EWyJBR/kTde6RXhnOPijpjQYj63OvwszADP6yPWgl6b+
        RCpTx2zAs4r996wZb91R9CsrEg==
X-Google-Smtp-Source: AA0mqf44qqA52u29eg06LrWn8VjRle8akEcpRMJijnKAqF1/cz77YkUU2Wje5YqivZQmoRikOiRt9A==
X-Received: by 2002:a05:6a00:324b:b0:574:3cde:385a with SMTP id bn11-20020a056a00324b00b005743cde385amr18504287pfb.32.1670941258370;
        Tue, 13 Dec 2022 06:20:58 -0800 (PST)
Received: from medve-MS-7D32 ([165.132.118.52])
        by smtp.gmail.com with ESMTPSA id g204-20020a6252d5000000b00561d79f1064sm7733063pfb.57.2022.12.13.06.20.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Dec 2022 06:20:57 -0800 (PST)
Date:   Tue, 13 Dec 2022 23:20:53 +0900
From:   Minsuk Kang <linuxlovemin@yonsei.ac.kr>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        netdev@vger.kernel.org
Cc:     linma@zju.edu.cn, davem@davemloft.net, sameo@linux.intel.com,
        dokyungs@yonsei.ac.kr, jisoo.jang@yonsei.ac.kr,
        Minsuk Kang <linuxlovemin@yonsei.ac.kr>
Subject: Re: Re: [PATCH net] nfc: pn533: Clear nfc_target in
 pn533_poll_dep_complete() before being used
Message-ID: <20221213142053.GA107908@medve-MS-7D32>
References: <20221213014120.969-1-linuxlovemin@yonsei.ac.kr>
 <15aba5c2-1f22-cb8a-742e-8bb8b1e8f0a0@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15aba5c2-1f22-cb8a-742e-8bb8b1e8f0a0@linaro.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 13, 2022 at 11:45:53AM +0100, Krzysztof Kozlowski wrote:
> > This patch fixes a slab-out-of-bounds read in pn533 that occurs in
> 
> Do not use "This commit/patch".
> https://elixir.bootlin.com/linux/v5.17.1/source/Documentation/process/submitting-patches.rst#L95
> 
> > nla_put() called from nfc_genl_send_target() when target->sensb_res_len,
> > which is duplicated from nfc_target in pn533_poll_dep_complete(), is
> > too large as the nfc_target is not properly initialized and retains
> > garbage values. The patch clears the nfc_target before it is used.
> 
> Same here
> 
> > 
> > Found by a modified version of syzkaller.
> > 
> > ==================================================================
> > BUG: KASAN: slab-out-of-bounds in nla_put+0xe0/0x120
> > Read of size 94 at addr ffff888109d1dfa0 by task syz-executor/4367
> > 
> > CPU: 0 PID: 4367 Comm: syz-executor Not tainted 5.14.0+ #171

[snip]

> > Memory state around the buggy address:
> >  ffff888109d1de80: fa fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
> >  ffff888109d1df00: 00 00 00 00 00 00 00 00 00 00 00 00 fc fc fc fc
> >> ffff888109d1df80: 00 00 00 00 00 00 00 00 00 00 00 00 fc fc fc fc
> >                                                        ^
> >  ffff888109d1e000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> >  ffff888109d1e080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 
> Drop unrelated pieces of OOPS and keep only things which are relevant.
>

Thank you for the comments. I will update the commit message as advised
in v2.

> > ==================================================================
> > 
> > Fixes: 673088fb42d0 ("NFC: pn533: Send ATR_REQ directly for active device detection")
> > Reported-by: Dokyung Song <dokyungs@yonsei.ac.kr>
> > Reported-by: Jisoo Jang <jisoo.jang@yonsei.ac.kr>
> > Reported-by: Minsuk Kang <linuxlovemin@yonsei.ac.kr>
> 
> Reported-by is for crediting other people, not crediting yourself.
> Otherwise all my patches would be reported-by, right? Please drop this
> one and keep only credit for other people who actually reported it. It's
> anyway weird to see three people reporting one bug.
> 
> Additionally I really dislike private reports because they sometimes
> cannot be trusted (see all the fake report credits from running
> coccinelle by Hulk Robot and others)... Care to provide link to the
> reports of this bug?
> 

My intention was to credit all the people contributed to the
modification of syzkaller that led to this bug. But I will drop them in
v2.

> > Signed-off-by: Minsuk Kang <linuxlovemin@yonsei.ac.kr>
> > ---
> >  drivers/nfc/pn533/pn533.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/drivers/nfc/pn533/pn533.c b/drivers/nfc/pn533/pn533.c
> > index d9f6367b9993..c6a611622668 100644
> > --- a/drivers/nfc/pn533/pn533.c
> > +++ b/drivers/nfc/pn533/pn533.c
> > @@ -1295,6 +1295,8 @@ static int pn533_poll_dep_complete(struct pn533 *dev, void *arg,
> >  	if (IS_ERR(resp))
> >  		return PTR_ERR(resp);
> > 
> > +	memset(&nfc_target, 0, sizeof(struct nfc_target));
> 
> There is one more place to fix in pn533_in_dep_link_up_complete()

Thank you. I will add a fix for it in v2.

Best regards,
Minsuk
