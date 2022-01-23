Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EA39497451
	for <lists+netdev@lfdr.de>; Sun, 23 Jan 2022 19:34:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239522AbiAWSeh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jan 2022 13:34:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239319AbiAWSee (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jan 2022 13:34:34 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD294C06173B;
        Sun, 23 Jan 2022 10:34:30 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id ka4so15296828ejc.11;
        Sun, 23 Jan 2022 10:34:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hos1FHw0FfVSOnWTAZTOMeKBiPpS+1hs6X6GnfavR3I=;
        b=VcDBWhFVFdAXo3yBT3IExhMhF6Lu6CCaaiOrI81TBUCA5w0/04xnIcTNesNv8JZqUe
         x3Y+IPcd+SCIX0jfqh5w5dhdPM3BaCUzBBP9HC1BjczB2nV239/6vtzcD+WmPTn9ClJd
         WnWP/6nCQMj0+ioHHZSPSQbBChh+wYzHlmbmgVZt6fD/T6tQT+JJ8bpeiYEzxQ3+ibwV
         5bfJxVERBx8kHjFcJvy6Sp224JXO3K2XERBukRKK6ixd4oX89QCXHQqo64Vmo8gVIeId
         6p5bLOaxgC3Nv4np5bRU4iSjrQ24DfvKKEVsnB6nSPxkd1Vg3KKNwcURDuuhBq71vtU3
         O2qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hos1FHw0FfVSOnWTAZTOMeKBiPpS+1hs6X6GnfavR3I=;
        b=wiDHIUTTn+XzLFgOuFvCOwYzmvEC7gescOfIHaKTghNpiAftG0OrXhWxJB7vpy0NT9
         IzArzGIPiCNN6rvXsR+r25kz8r8BlmYml83Guc354JqdI24Du0w/NXx0+py8xgw80FHu
         mGEH4u8RkX9huuJ1gOccKjx7Dt6wMdvYMyWILIEppKgRUdqJGJXkSciuXOadywuZuqky
         TnwBFOAt6yxUlObTeYI1b8ybgoZ6IUQktEbJ7p3+RMW/Yq1jgGJx+Bo5EBFIhkUCflBa
         fEugrSPf2HEswlIDUALdcLCigQ+0+HQHDOXzRKJMr0NG2EA0FG4OkLsA3eSxTAImWCpq
         1o9g==
X-Gm-Message-State: AOAM533Lr+ItYFrPJlkUuPb/HtDvfJqlar9pBaVS3SivaFRCKoNbFy5o
        mTeun3p1GmZgL8O5tQUsjxdITJFAPiKH5UTzac8=
X-Google-Smtp-Source: ABdhPJyXQfUUefxElP+l1ZKl79hTu4kdPoE0Kpjp2SdsI+j6n8REMdCBhH3Ring3+mUH9BD7qSoEQ/MCjtkB9S08Mc8=
X-Received: by 2002:a17:907:6e18:: with SMTP id sd24mr10280596ejc.649.1642962869128;
 Sun, 23 Jan 2022 10:34:29 -0800 (PST)
MIME-Version: 1.0
References: <20220114234825.110502-1-martin.blumenstingl@googlemail.com>
 <20220114234825.110502-4-martin.blumenstingl@googlemail.com>
 <b2bf2bc5f04b488487797aa21c50a130@realtek.com> <87czkogsc4.fsf@kernel.org>
In-Reply-To: <87czkogsc4.fsf@kernel.org>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Sun, 23 Jan 2022 19:34:18 +0100
Message-ID: <CAFBinCCeCoRmqApeeAD534dKrhgbnh4wSBF88oLLXqL-TYv5+w@mail.gmail.com>
Subject: Re: [PATCH 3/4] rtw88: Move enum rtw_tx_queue_type mapping code to tx.{c,h}
To:     Kalle Valo <kvalo@kernel.org>
Cc:     Pkshih <pkshih@realtek.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "tony0620emma@gmail.com" <tony0620emma@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kalle,

On Wed, Jan 19, 2022 at 7:20 AM Kalle Valo <kvalo@kernel.org> wrote:
[...]
> I was about to answer that with a helper function it's easier to catch
> out of bands access, but then noticed the helper doesn't have a check
> for that. Should it have one?
you mean something like:
    if (ac >= IEEE80211_NUM_ACS)
        return RTW_TX_QUEUE_BE;

Possibly also with a WARN_ON/WARN_ON_ONCE


Best regards,
Martin
