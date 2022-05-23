Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39047531C05
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 22:57:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232198AbiEWTjj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 15:39:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232214AbiEWTja (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 15:39:30 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBCE719C0D
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 12:31:25 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id a9so12487491pgv.12
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 12:31:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=FKFLi5eR+9ADBi0m67qxvJspJKDBK02KPYVUQgWhwdU=;
        b=bk2wnF89Qnk1g4FnbKaT/xUuQcZYOE7D1wXYxXO4tsnccW4y0mg+mIIaq97gWYI+JP
         Rw7MD1/xWR3DylhMcEBn6eBmOctrIp/3qLz8kz57GSuzj6VyFLXJkfGEy1tU6V/bEUYj
         ey+6dpe0IhzDdBvH1xY7t/MuBDZdLHvsXDw+o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=FKFLi5eR+9ADBi0m67qxvJspJKDBK02KPYVUQgWhwdU=;
        b=H0Vh0RMn7Xg17TV24Tl+lIm9Mr2WJyXzoSlXnWTaJa+UhwQigSPKD1FaEPIjZijkiI
         VSlSSPYm51WA6DbUY6fNGlFmGHyBZ+ijcTnvR0W+hrOSeodcLvWwHCosAmzwYTfray7e
         v1um8GwOmW3ufKZspcCNkSMW1QK6jaFseb1i6pWw6WqvubeqJxMp5refeV6YUJiZziv+
         ZBCO1bZ/URTI0DiiX9oQRO5hPBl5g6bWOJHIKizrRFM0ONoM03rIg7qiZzyq4HXdxQyA
         CTIGz32JbExslyWcc+F4Jjzpux8NWFOR24dpLDx98XOPa+/NNDbMpEjgYQfNbV3B/ein
         Vw7A==
X-Gm-Message-State: AOAM533cYDHWZZXs2FLlcVqIfvW+ph6Fbq+0dhid7EIF/8IO4xWa79lr
        ZoJAA7p2ClaO2BwTdRMIEeqiDA==
X-Google-Smtp-Source: ABdhPJzKKYu0Xv/n3Lqd1yoYZi5SWqXwQaobVSCNaZMgB1u7uqTQj93OsbPsO1asNtbmbx3XsvmB6Q==
X-Received: by 2002:a63:f813:0:b0:3f6:475:6389 with SMTP id n19-20020a63f813000000b003f604756389mr21741558pgh.127.1653334285295;
        Mon, 23 May 2022 12:31:25 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id t2-20020a170902e84200b001618fee3900sm5587826plg.196.2022.05.23.12.31.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 May 2022 12:31:25 -0700 (PDT)
Date:   Mon, 23 May 2022 12:31:23 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, johannes@sipsolutions.net,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        toke@toke.dk, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH net-next 2/8] wifi: ath9k: silence array-bounds warning
 on GCC 12
Message-ID: <202205231229.CF6B8471@keescook>
References: <20220520194320.2356236-1-kuba@kernel.org>
 <20220520194320.2356236-3-kuba@kernel.org>
 <87h75j1iej.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87h75j1iej.fsf@kernel.org>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 21, 2022 at 09:58:28AM +0300, Kalle Valo wrote:
> + arnd, kees, lkml
> 
> Jakub Kicinski <kuba@kernel.org> writes:
> 
> > GCC 12 says:
> >
> > drivers/net/wireless/ath/ath9k/mac.c: In function ‘ath9k_hw_resettxqueue’:
> > drivers/net/wireless/ath/ath9k/mac.c:373:22: warning: array subscript
> > 32 is above array bounds of ‘struct ath9k_tx_queue_info[10]’
> > [-Warray-bounds]
> >   373 |         qi = &ah->txq[q];
> >       |               ~~~~~~~^~~
> >
> > I don't know where it got the 32 from, relegate the warning to W=1+.
> >
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > ---
> > CC: toke@toke.dk
> > CC: kvalo@kernel.org
> > CC: linux-wireless@vger.kernel.org
> > ---
> >  drivers/net/wireless/ath/ath9k/Makefile | 5 +++++
> >  1 file changed, 5 insertions(+)
> >
> > diff --git a/drivers/net/wireless/ath/ath9k/Makefile b/drivers/net/wireless/ath/ath9k/Makefile
> > index eff94bcd1f0a..9bdfcee2f448 100644
> > --- a/drivers/net/wireless/ath/ath9k/Makefile
> > +++ b/drivers/net/wireless/ath/ath9k/Makefile
> > @@ -45,6 +45,11 @@ ath9k_hw-y:=	\
> >  		ar9003_eeprom.o \
> >  		ar9003_paprd.o
> >  
> > +# FIXME: temporarily silence -Warray-bounds on non W=1+ builds
> > +ifndef KBUILD_EXTRA_WARN
> > +CFLAGS_mac.o += -Wno-array-bounds
> > +endif
> 
> There are now four wireless drivers which need this hack. Wouldn't it be
> easier to add -Wno-array-bounds for GCC 12 globally instead of adding
> the same hack to multiple drivers?

I finally tracked this down to a GCC 12 bug related to -fsanitize=shift:
https://gcc.gnu.org/bugzilla/show_bug.cgi?id=105679

Basically all the "32" stuff comes from the index being used in a shift,
and the resulting internal GCC logic blowing up.

I was going to do a before/after build with and without -fsanitize=shift
to see how many of these false positives originate from that bug...

-- 
Kees Cook
