Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E1F264132F
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 03:17:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234309AbiLCCRe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 21:17:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234481AbiLCCRc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 21:17:32 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55989DCBF8
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 18:17:31 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id 62so5795861pgb.13
        for <netdev@vger.kernel.org>; Fri, 02 Dec 2022 18:17:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KslJTB66xKixbMkJwqpVpZSA0E9W1pT9X9b2hTanY44=;
        b=FdRPAwVZYUKWI0GixKt1/Mt+MzbcNPYjYP0eTaKVlj9agMe+JiJxyY5avV9WtorCm+
         EK+OYvzUfadggHErH3DkUit8KsSW1LwHMxmJnXE6B74hzYeyVOXZyI2rEJGSVj+Q7E1e
         1/TvPb0HpDfja1G3IDLH+2UgTDmiIMikYkJLc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KslJTB66xKixbMkJwqpVpZSA0E9W1pT9X9b2hTanY44=;
        b=QF3RruwB531e27l7MSHwkZf8Tv0Pku0E88kdeXRPA/Rkfbo2NTGDySw8xyONxFC3xF
         XAzkaBDTtzwqVLNNYD73xvKACIgOdCh3R45jfO9lWnA0Q0XIICakOdPzwYH2IFtmY4ew
         F0nQUONrWEJE39U9ld5aaKVkt8NSv1D+Fjhtpru7yZcHU9walevTvqvahfx8ExWzxY3Q
         ddiMbalVydb7iL5W95DAthByuJVdOVRaHHkOSRJ1aKiC1BxbTumoOe6xSt8XXQMgzUxX
         mrGBcrdQYAGtVs7vYJBHuXgj1qIxz1aVPMdUrpYhaLN4BX5UKEkS7RJ43asulTM6FL2V
         zZ7Q==
X-Gm-Message-State: ANoB5pm2gwv0c6vXeyhvFDXZJ99WDw4BZkUesNcQc1SYqGCFeaby5Mrh
        Lwk5kcq+pKUffOXeJ6r3XuSFZA==
X-Google-Smtp-Source: AA0mqf5Xy39Vb8BDohYQdotTcroYHHMKN0SWFeCLIULcJFfsg4B5WlYx3CbASMwsZUX/N56aaa5Rzw==
X-Received: by 2002:a05:6a00:1409:b0:56b:e1d8:e7a1 with SMTP id l9-20020a056a00140900b0056be1d8e7a1mr54566551pfu.28.1670033850672;
        Fri, 02 Dec 2022 18:17:30 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id y69-20020a62ce48000000b00571bdf45888sm2157422pfg.154.2022.12.02.18.17.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Dec 2022 18:17:29 -0800 (PST)
Date:   Fri, 2 Dec 2022 18:17:28 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Ryder Lee <Ryder.Lee@mediatek.com>
Cc:     MeiChia Chiu =?utf-8?B?KOmCsee+juWYiSk=?= 
        <MeiChia.Chiu@mediatek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gustavo@embeddedor.com" <gustavo@embeddedor.com>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>,
        Shayne Chen =?utf-8?B?KOmZs+i7kuS4nik=?= 
        <Shayne.Chen@mediatek.com>, "nbd@nbd.name" <nbd@nbd.name>,
        "lorenzo@kernel.org" <lorenzo@kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Sean Wang <Sean.Wang@mediatek.com>,
        "kvalo@kernel.org" <kvalo@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        Sujuan Chen =?utf-8?B?KOmZiOe0oOWonyk=?= 
        <Sujuan.Chen@mediatek.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Bo Jiao =?utf-8?B?KOeEpuazoik=?= <Bo.Jiao@mediatek.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Coverity: mt7915_mcu_get_chan_mib_info(): Memory - illegal
 accesses
Message-ID: <202212021817.E35115E1@keescook>
References: <202212021424.34C0F695E4@keescook>
 <1a16599dd5e4eed86bae112a232a3599af43a5f2.camel@mediatek.com>
 <202212021504.A1942911@keescook>
 <6285b967a37d7f641b13ba73c10033450ee8ea7f.camel@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6285b967a37d7f641b13ba73c10033450ee8ea7f.camel@mediatek.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 02, 2022 at 11:42:36PM +0000, Ryder Lee wrote:
> On Fri, 2022-12-02 at 15:04 -0800, Kees Cook wrote:
> > > 
> > On Fri, Dec 02, 2022 at 10:56:19PM +0000, Ryder Lee wrote:
> > > On Fri, 2022-12-02 at 14:24 -0800, coverity-bot wrote:
> > > > Hello!
> > > > 
> > > > This is an experimental semi-automated report about issues
> > > > detected
> > > > by
> > > > Coverity from a scan of next-20221202 as part of the linux-next
> > > > scan
> > > > project:
> > > > 
> > > 
> > > 
> https://urldefense.com/v3/__https://scan.coverity.com/projects/linux-next-weekly-scan__;!!CTRNKA9wMg0ARbw!j7j_C0KpO4VD2yMOodvpeIexTGq4fhy2yq6nokNua9u4LToiUOLk4ou8JFFNrXkrh80d5BK2k44faRQstHE9$
> > >  
> > > >  
> > > > 
> > > > You're getting this email because you were associated with the
> > > > identified
> > > > lines of code (noted below) that were touched by commits:
> > > > 
> > > >   Thu Feb 3 13:57:56 2022 +0100
> > > >     417a4534d223 ("mt76: mt7915: update mt7915_chan_mib_offs for
> > > > mt7916")
> > > > 
> > > > Coverity reported the following:
> > > > 
> > > > *** CID 1527801:  Memory - illegal accesses  (OVERRUN)
> > > > drivers/net/wireless/mediatek/mt76/mt7915/mcu.c:3005 in
> > > > mt7915_mcu_get_chan_mib_info()
> > > > 2999     		start = 5;
> > > > 3000     		ofs = 0;
> > > > 3001     	}
> > > > 3002
> > > > 3003     	for (i = 0; i < 5; i++) {
> > > > 3004     		req[i].band = cpu_to_le32(phy->mt76->band_idx);
> > > > vvv     CID 1527801:  Memory - illegal accesses  (OVERRUN)
> > > > vvv     Overrunning array "offs" of 9 4-byte elements at element
> > > > index 9 (byte offset 39) using index "i + start" (which evaluates
> > > > to
> > > > 9).
> > > > 3005     		req[i].offs = cpu_to_le32(offs[i + start]);
> > > > 3006
> > > > 3007     		if (!is_mt7915(&dev->mt76) && i == 3)
> > > > 3008     			break;
> > > > 3009     	}
> > > > 3010
> > > > 
> > > > If this is a false positive, please let us know so we can mark it
> > > > as
> > > > such, or teach the Coverity rules to be smarter. If not, please
> > > > make
> > > > sure fixes get into linux-next. :) For patches fixing this,
> > > > please
> > > > include these lines (but double-check the "Fixes" first):
> > > > 
> > > 
> > > I think this is a false postive as the subsequent check 'if
> > > (!is_mt7915(&dev->mt76) && i == 3)' should break array "offs" of 8.
> > 
> > Ah, okay. What if is_mt7915(&dev->mt76) is always true?
> > 
> > -Kees
> 
> 	int start = 0;
> 
> 	if (!is_mt7915(&dev->mt76)) {
> 		start = 5;
> 		ofs = 0;
> 	}
> 
> 	for (i = 0; i < 5; i++) {
> 		req[i].band = cpu_to_le32(phy->band_idx);
> 		req[i].offs = cpu_to_le32(offs[i + start]);
> 
> 		if (!is_mt7915(&dev->mt76) && i == 3) //
> 			break;
> 	}
> 
> For 'is_mt7915' case, start:0 and i: 0 1 2 3 4, whereas !is_mt7915'
> case, start:5 and i: 0 1 2 3 (then break).
> 
> I know it's a bit tricky. This is used to differentiate chipset
> revision.

Ah-ha! Gotcha now. Thanks for the details and sorry for the noise! :)

-Kees

-- 
Kees Cook
