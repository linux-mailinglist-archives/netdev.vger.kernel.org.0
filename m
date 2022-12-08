Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC9FD6474C3
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 17:58:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbiLHQ6S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 11:58:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiLHQ6R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 11:58:17 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D728663B98;
        Thu,  8 Dec 2022 08:58:16 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id m18so5481290eji.5;
        Thu, 08 Dec 2022 08:58:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lPLRL5gwJEQOFI/RlQ2X9VqdPMQiEmvD0BQv4ldHs6I=;
        b=NTmeL9B2b5fZYhYlyjdsyilV73ZiVRhHX2/vnt1k0Bw6XMP8Gu1MHBf7O/eE3mu/6E
         xFLUx/7XDUz8hffxzTlEpBdRjgPOvrFm9eVxlOBkNeGZoUuMoU0YHULLy80WsM3ZvO5L
         KUr5vy4Ky9SGbOKYv1zjZ4PMQoMJ375dm6Ay1Gq26J5sIYiwDTizBHl37iOB4RP+70jK
         7Wi7/VjuPPBfacs7ACoWcGWJBG8OPsNQS9Mf/U1SysSUdo7guKUB/L8lKHMGDaXeDk6O
         pfnzNoA5QMsUFNuAczTOFKaBgegkJODm3/yxTkH72l6jUVrtPQQpAKIqOlrcdI1Vfvil
         95cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lPLRL5gwJEQOFI/RlQ2X9VqdPMQiEmvD0BQv4ldHs6I=;
        b=qRR5UebC68X+TjcifrdXHsWQcZEp33pxPgod/Ujy5cN+kllHjD0Abf94Np71qXKtQ8
         LAmQW5howk1kB70dE4iw/DVgIpytGunwck1r8MGucw3klhBCa2blKrRdIQvndIAkoMWK
         X8dw3dKeV24/MjUAoX+yay+SY5IaU6T95V8cLIlEGsImn93bO7klLZGhitiM/qKYNQZv
         ZazON/uSWdOBnIjWr6ZR02zdtwZuIBt/KJ/JR6bwl9PHSKOm/3cAWGajFvyMATWBRkxz
         iTzIrWmzKKSQ7fi1eysvS7iwrdw6uBMDsPb+gm233GzHDXv4ywPjI829YoamYVyz0L7v
         jsRw==
X-Gm-Message-State: ANoB5pkmlrq8Y3uSurhRNjvnA3Nrds88RsKKzdX7afqBelGYsFQ1Alo7
        +B+ejBADh0wuNjq+/e1BegWaVcTb5uHGgw==
X-Google-Smtp-Source: AA0mqf5BoeKc+gMAWWNdxGO/pvag1LPjeDgBQRkYtTUj4vd+g3fbUKVzJCdawe+cirZysFzkLegTNg==
X-Received: by 2002:a17:906:564d:b0:7c0:d609:6f9b with SMTP id v13-20020a170906564d00b007c0d6096f9bmr2632281ejr.27.1670518695354;
        Thu, 08 Dec 2022 08:58:15 -0800 (PST)
Received: from skbuf ([188.26.185.87])
        by smtp.gmail.com with ESMTPSA id n11-20020a170906118b00b007be696512ecsm9784427eja.187.2022.12.08.08.58.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 08:58:14 -0800 (PST)
Date:   Thu, 8 Dec 2022 18:58:12 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     David Laight <David.Laight@ACULAB.COM>
Cc:     'Dan Carpenter' <error27@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH net] lib: packing: fix shift wrapping in bit_reverse()
Message-ID: <20221208165812.gnmyjkwijoieymb3@skbuf>
References: <Y5B3sAcS6qKSt+lS@kili>
 <Y5B3sAcS6qKSt+lS@kili>
 <20221207121936.bajyi5igz2kum4v3@skbuf>
 <Y5CFMIGsZmB1TRni@kadam>
 <731cbeda249d4aadbcc3d1cbeaaea750@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <731cbeda249d4aadbcc3d1cbeaaea750@AcuMS.aculab.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 07, 2022 at 07:41:28PM +0000, David Laight wrote:
> From: Dan Carpenter
> > Sent: 07 December 2022 12:21
> ....
> > > > -		new_val |= (bit << (width - i - 1));
> > > > +		if (val & BIT_ULL(1))
> > >
> > > hmm, why 1 and not i?
> > 
> > Because I'm a moron.  Let me resend.
> 
> Since we're not writing FORTRAN-IV why not use a variable
> name that is harder to confuse with 1?

How about 'k'?
