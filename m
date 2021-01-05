Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBBB92EA9D7
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 12:27:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729592AbhAEL0I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 06:26:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729318AbhAELZy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 06:25:54 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FBE7C0617A0;
        Tue,  5 Jan 2021 03:24:46 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id o19so71804616lfo.1;
        Tue, 05 Jan 2021 03:24:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=d4x4cvcMmgFsYUGoF/1+2lvoQxmLVCLHQ/4xBidGdsM=;
        b=s8plLUX0b1QAEl7yX2FujREg4nf3efVcgX2KaUa5RfSFArQL2X5xo9M4He1knpXyS3
         BiwTQdKUaYvGVtem/nVvkQ4eXatNxB7G43aRo6WC2lXa36/zE2UYMpKgDPD9elEgmv+P
         apwz7dbiRKb6ANajJE8PtBBNRZZeN2ppDea2p2dJwEtZ+ETOA+WAXLBEIkcgG45rk9Nk
         oIHDCtUWiqkoDuAKcbzxnLLrj01n4a7RyGFo4eGVBLmkzSbEKnHZAU7CTVN77Ss1hldg
         1mu9zHE3ngL2G4P6D0Pd7Yv4axOsRnLmD7TPN3CmhL8icokJQneHZs8Z/BX3dvCSDZH+
         scQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=d4x4cvcMmgFsYUGoF/1+2lvoQxmLVCLHQ/4xBidGdsM=;
        b=FVaNkaIYSokKAfvd0rNyYbXXLABoN5oyRROXtVsInzJKcZ51MQtcR0GNlI+c1pKbBh
         3GksdB1okEzEo0wGkxMzZrva01B6lMeKtDUW5Eo6/gTQc0T8ZUs4xYVt/tqJN0d27QQj
         4wjqqFJhsFKyNe3ARBRF1lo+fSi/X10mN4N2GYj78OE3k5QX2EHusZh/GHbQh1g/yE5h
         LQxKVaLwTSMZc7Fy4GeeFyQ3jdYcatunjbkDDNMRzUHzwWrI7JqOLeepwb2q1vE1fKWd
         vyA6sWAYq9oAbFwPh3jnhGdjUa59JlmeCkUnYPyzSPUwKyTHnWkR6IhtqgGDjU0MwSts
         jskw==
X-Gm-Message-State: AOAM5334SRK2p4z9Vf81zBHVuPGp8MLcZ0zmFaiRT7ucN+tZ0RyoJEsr
        N1MYNnvfhLOmxq4Mcp+DfBaZSPEHXS6gDfjZs4Q=
X-Google-Smtp-Source: ABdhPJzk5ZjwofTobePg/2X4lwegr74UEMdarc1pgxyms8aCO1/VljAkPrb4AMb8BnsxbmrWTdB/9qlmxwaw755Zjpw=
X-Received: by 2002:a05:651c:1102:: with SMTP id d2mr35861266ljo.398.1609845884842;
 Tue, 05 Jan 2021 03:24:44 -0800 (PST)
MIME-Version: 1.0
References: <20210105101738.13072-1-unixbhaskar@gmail.com> <CAGRGNgX-JSPW8LSmAUbm=2jkx+K4EYdntCq6P2i8td0TUk7Nww@mail.gmail.com>
 <X/RD/pll4UoRJG0w@Gentoo>
In-Reply-To: <X/RD/pll4UoRJG0w@Gentoo>
From:   Julian Calaby <julian.calaby@gmail.com>
Date:   Tue, 5 Jan 2021 22:24:32 +1100
Message-ID: <CAGRGNgVHcOjt4at+tzgrPxn=04_Y3b16pihDw6xucg4Eh1GFSA@mail.gmail.com>
Subject: Re: [PATCH] drivers: net: wireless: realtek: Fix the word association
 defautly de-faulty
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>,
        Julian Calaby <julian.calaby@gmail.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        zhengbin13@huawei.com, baijiaju1990@gmail.com,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Bhaskar,

On Tue, Jan 5, 2021 at 9:48 PM Bhaskar Chowdhury <unixbhaskar@gmail.com> wrote:
>
> On 21:33 Tue 05 Jan 2021, Julian Calaby wrote:
> >Hi Bhaskar,
> >
> >On Tue, Jan 5, 2021 at 9:19 PM Bhaskar Chowdhury <unixbhaskar@gmail.com> wrote:
> >>
> >> s/defautly/de-faulty/p
> >>
> >>
> >> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
> >> ---
> >>  drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c
> >> index c948dafa0c80..7d02d8abb4eb 100644
> >> --- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c
> >> +++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c
> >> @@ -814,7 +814,7 @@ bool rtl88ee_is_tx_desc_closed(struct ieee80211_hw *hw, u8 hw_queue, u16 index)
> >>         u8 own = (u8)rtl88ee_get_desc(hw, entry, true, HW_DESC_OWN);
> >>
> >>         /*beacon packet will only use the first
> >> -        *descriptor defautly,and the own may not
> >> +        *descriptor de-faulty,and the own may not
> >
> >Really? "de-faultly" isn't any better than "defaultly" and in fact
> >it's even worse as it breaks up the word "default".
> >
> hey, it was written as "defautly" ...and that was simple spelling mistake ..
> so,corrected it.

Er, no, that isn't the correct replacement. They're using "default" as
a verb and mean "by default".

The sentence makes no sense with "de-faulty" there instead.

Ultimately though the entire comment barely makes sense, so the best
way to fix this spelling mistake is to re-write the entire comment so
it does. I would have suggested a new wording for it, but I don't know
enough about what's going on here to parse the rest of it.

So therefore someone who knows what's going on here needs to fix this
and your change is just making this comment worse.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
