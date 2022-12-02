Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A4D264114B
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 00:04:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233308AbiLBXEx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 18:04:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233742AbiLBXEw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 18:04:52 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B321DA7D1
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 15:04:51 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id f9so5547523pgf.7
        for <netdev@vger.kernel.org>; Fri, 02 Dec 2022 15:04:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=3eWdYeAABAMnoEoSZbvIqfAvjGuNN+NLL8O7DVcc5tw=;
        b=LPDjcXKRkJF0ChWSvwqdMs4z+WaNIJwO0yY5Q59nGeM3pDMHVwIb6cPYLQgWVJguAB
         ciAtCM4G0YFdDjeGOSSxDSrCrEHGWnroQqTT/uQy4yjM39FpLTUwFW+H4Sr88a8juay4
         4lauU6rk4+hFPwNW6zqanjTHmoMbiFkIJBgIM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3eWdYeAABAMnoEoSZbvIqfAvjGuNN+NLL8O7DVcc5tw=;
        b=i9W7Tcm+oR4gFG+j0AYoKYiNu+H2rRKWNOGnFAsBHNnAOwTAKNgvcyC1HXGP+/Yh3t
         MMTI5RahtcWC7uzz2j/e7I49SA99267JOwOT4aTZMKCh0XW+eE+31evQoC4l3EZhRTbM
         3A02vLA0IPJoxYhlfES7ju1EGp2VK92DKx31Vkvc2CMwST1dKy/2oj389FN3Oo/ldjhy
         uKmrpDRkxPBHg5eJ/wVjJIkAHtKIAYCjr7CS1pf8IlMFbEPd1fUiV5trmep60PeY+Yfx
         X3LoORw83sLeE8HNP8tA0V8kbgqNw1jHJp+jfLN7eMjEa6V3hPL9ryv9nDpmCpNwxCh3
         kxtg==
X-Gm-Message-State: ANoB5plFf/9BzbgVUDQbqR4Jh0hylECyb1lTf0tZEZ2DVW2M3KfSwyec
        HdvE0fsceJFF5GfsXnVoctkqnQ==
X-Google-Smtp-Source: AA0mqf6wCldb+aTkXQCqBjXUJrvffCgFhxrhyXTrWtI0GxUZ1d4eeeVzDPxJ8FdEPH3kPGZuS+RPDw==
X-Received: by 2002:a63:e34b:0:b0:477:de0a:3233 with SMTP id o11-20020a63e34b000000b00477de0a3233mr34109179pgj.467.1670022291026;
        Fri, 02 Dec 2022 15:04:51 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id c3-20020a17090a4d0300b00218998eb828sm7058622pjg.45.2022.12.02.15.04.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Dec 2022 15:04:50 -0800 (PST)
Date:   Fri, 2 Dec 2022 15:04:49 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Ryder Lee <Ryder.Lee@mediatek.com>
Cc:     Bo Jiao =?utf-8?B?KOeEpuazoik=?= <Bo.Jiao@mediatek.com>,
        MeiChia Chiu =?utf-8?B?KOmCsee+juWYiSk=?= 
        <MeiChia.Chiu@mediatek.com>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gustavo@embeddedor.com" <gustavo@embeddedor.com>,
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
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Coverity: mt7915_mcu_get_chan_mib_info(): Memory - illegal
 accesses
Message-ID: <202212021504.A1942911@keescook>
References: <202212021424.34C0F695E4@keescook>
 <1a16599dd5e4eed86bae112a232a3599af43a5f2.camel@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1a16599dd5e4eed86bae112a232a3599af43a5f2.camel@mediatek.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 02, 2022 at 10:56:19PM +0000, Ryder Lee wrote:
> On Fri, 2022-12-02 at 14:24 -0800, coverity-bot wrote:
> > Hello!
> > 
> > This is an experimental semi-automated report about issues detected
> > by
> > Coverity from a scan of next-20221202 as part of the linux-next scan
> > project:
> > 
> https://urldefense.com/v3/__https://scan.coverity.com/projects/linux-next-weekly-scan__;!!CTRNKA9wMg0ARbw!j7j_C0KpO4VD2yMOodvpeIexTGq4fhy2yq6nokNua9u4LToiUOLk4ou8JFFNrXkrh80d5BK2k44faRQstHE9$ 
> >  
> > 
> > You're getting this email because you were associated with the
> > identified
> > lines of code (noted below) that were touched by commits:
> > 
> >   Thu Feb 3 13:57:56 2022 +0100
> >     417a4534d223 ("mt76: mt7915: update mt7915_chan_mib_offs for
> > mt7916")
> > 
> > Coverity reported the following:
> > 
> > *** CID 1527801:  Memory - illegal accesses  (OVERRUN)
> > drivers/net/wireless/mediatek/mt76/mt7915/mcu.c:3005 in
> > mt7915_mcu_get_chan_mib_info()
> > 2999     		start = 5;
> > 3000     		ofs = 0;
> > 3001     	}
> > 3002
> > 3003     	for (i = 0; i < 5; i++) {
> > 3004     		req[i].band = cpu_to_le32(phy->mt76->band_idx);
> > vvv     CID 1527801:  Memory - illegal accesses  (OVERRUN)
> > vvv     Overrunning array "offs" of 9 4-byte elements at element
> > index 9 (byte offset 39) using index "i + start" (which evaluates to
> > 9).
> > 3005     		req[i].offs = cpu_to_le32(offs[i + start]);
> > 3006
> > 3007     		if (!is_mt7915(&dev->mt76) && i == 3)
> > 3008     			break;
> > 3009     	}
> > 3010
> > 
> > If this is a false positive, please let us know so we can mark it as
> > such, or teach the Coverity rules to be smarter. If not, please make
> > sure fixes get into linux-next. :) For patches fixing this, please
> > include these lines (but double-check the "Fixes" first):
> > 
> 
> I think this is a false postive as the subsequent check 'if
> (!is_mt7915(&dev->mt76) && i == 3)' should break array "offs" of 8.

Ah, okay. What if is_mt7915(&dev->mt76) is always true?

-Kees

> 
> Ryder
> 
> > Reported-by: coverity-bot <keescook+coverity-bot@chromium.org>
> > Addresses-Coverity-ID: 1527801 ("Memory - illegal accesses")
> > Fixes: 417a4534d223 ("mt76: mt7915: update mt7915_chan_mib_offs for
> > mt7916")
> > 
> > Thanks for your attention!
> > 

-- 
Kees Cook
