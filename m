Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66160313B84
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 18:51:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234961AbhBHRvF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 12:51:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234962AbhBHRtE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 12:49:04 -0500
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1944C0617AB
        for <netdev@vger.kernel.org>; Mon,  8 Feb 2021 09:48:24 -0800 (PST)
Received: by mail-oi1-x236.google.com with SMTP id i3so5609233oif.1
        for <netdev@vger.kernel.org>; Mon, 08 Feb 2021 09:48:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hqIt/UwNUJoQOM09qoHwRbtdcgdq4vD+X81GKl6pUvg=;
        b=dIROg9GEeJLWJ7XzvQzbHYvDvby5DZSA5wtm0HUz+hH2dGsD3gA6Kmiit0wOe4THHY
         PFGw2biv/f4Jt3Pmu2/yyyDY6LEptMbHzdQ093MuxDa5rv4qROkzjHFekTzKF0PccSag
         v3r7b0aWCGMpeHb+QlgQX8AjF6YRATpuqzJPQFniDXHWE5/CII87sM/T9ni8CoMBw341
         RejS20ewHvzHs7IB9RLQzcF872UhB3z273h10F15S/qg96XUWfScRkkdo8oNT36Yr0Vq
         Z7et1TtnD0QGfzFZPQny/zxIOrbUVuzRjznOwu0qz/L39S1XAGXn9/iDbEdrbU1gQ/hb
         SzaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hqIt/UwNUJoQOM09qoHwRbtdcgdq4vD+X81GKl6pUvg=;
        b=ERn0XWutDn9dKgcQ6bEu85CyGF2q61WuOE7oqJ1GTVV442xP7/wwvC+vzTtldprIqz
         5ywH2O6H5FtBGGWZEN9aNLmmWr1TJbet4dTJh5BWt1rEpEqIHB5woR1U1yAR0tVWk1U3
         Nniuv0GSijGgXw3qG/W/CANURpIm2lv43WK4yLFvrfY8vLiXKZxkzok56wljNEj9uhf/
         BvKwrFKZJykXSeHV6bYKtv46b95EMN+ZLxX8JumzX/YesrDCSjgXjTXvcnSjGnpGr+oN
         WhBS4fFQOslvmMz+ZbHoBzQshGbIoV4F20ZoDQj0G1PteFlR/4K+Lil7ic5lCfcLVPYs
         VAjQ==
X-Gm-Message-State: AOAM533d46aOVlPXQkWdMvk00NvknNik7nuLbsc+DbvJyk/Zs9byyUYA
        FvMJfwHfaWWHS35ukOz+pxSVTE8CsWLizQ==
X-Google-Smtp-Source: ABdhPJyqiIARYiS9Nx6R2dRAOu7L9fFAY66xYQB52vNM3asD8uPvwfyxjaG4SWOx1mRUBpZwO/soKA==
X-Received: by 2002:a54:4689:: with SMTP id k9mr12050417oic.149.1612806503972;
        Mon, 08 Feb 2021 09:48:23 -0800 (PST)
Received: from builder.lan (104-57-184-186.lightspeed.austtx.sbcglobal.net. [104.57.184.186])
        by smtp.gmail.com with ESMTPSA id c17sm853063otp.58.2021.02.08.09.48.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Feb 2021 09:48:22 -0800 (PST)
Date:   Mon, 8 Feb 2021 11:48:20 -0600
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Amit Pundir <amit.pundir@linaro.org>,
        Rob Herring <robh@kernel.org>, dt <devicetree@vger.kernel.org>,
        netdev@vger.kernel.org, Jeffrey Hugo <jeffrey.l.hugo@gmail.com>,
        linux-wireless@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        ath10k <ath10k@lists.infradead.org>,
        John Stultz <john.stultz@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Konrad Dybcio <konradybcio@gmail.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        David S Miller <davem@davemloft.net>
Subject: Re: [PATCH] ath10k: Introduce a devicetree quirk to skip host cap
 QMI requests
Message-ID: <YCF5ZC/WMRefTRcQ@builder.lan>
References: <1601058581-19461-1-git-send-email-amit.pundir@linaro.org>
 <20200929190817.GA968845@bogus>
 <20201029134017.GA807@yoga>
 <CAMi1Hd20UpNhZm6z5t5Kcy8eTABiAj7X_Gm66QnJspZWSio0Ew@mail.gmail.com>
 <20201124175146.GG185852@builder.lan>
 <87sg8heeta.fsf@codeaurora.org>
 <CAMi1Hd2FN6QQzbKHooVyqQfH1NFTNLt4RwxyVXRf+5DwTc9ojg@mail.gmail.com>
 <87czxa4grv.fsf@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87czxa4grv.fsf@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon 08 Feb 11:21 CST 2021, Kalle Valo wrote:

> Amit Pundir <amit.pundir@linaro.org> writes:
> 
> > Hi Kalle,
> >
> > On Mon, 7 Dec 2020 at 22:25, Kalle Valo <kvalo@codeaurora.org> wrote:
> >>
> >> This is firmware version specific, right? There's also enum
> >> ath10k_fw_features which is embedded within firmware-N.bin, we could add
> >> a new flag there. But that means that a correct firmware-N.bin is needed
> >> for each firmware version, not sure if that would work out. Just
> >> throwing out ideas here.
> >
> > Apologies for this late reply. I was out for a while.
> 
> No worries.
> 
> > If by that (the firmware version) you mean "QC_IMAGE_VERSION_STRING",
> > then that may be a bit tricky. Pocophone F1 use the same firmware
> > family version (WLAN.HL.2.0.XXX), used by Dragonboard 845c (which has
> > Wi-Fi working upstream).
> 
> I'm meaning the ath10k firmware meta data we have in firmware-N.bin
> (N=2,3,4...) file. A quick summary:
> 
> Every ath10k firmware release should have firmware-N.bin. The file is
> created with this tool:
> 
> https://github.com/qca/qca-swiss-army-knife/blob/master/tools/scripts/ath10k/ath10k-fwencoder
> 
> firmware-N.bin contains various metadata, one of those being firmware
> feature flags:
> 
> enum ath10k_fw_features {
> 	/* wmi_mgmt_rx_hdr contains extra RSSI information */
> 	ATH10K_FW_FEATURE_EXT_WMI_MGMT_RX = 0,
> 
> 	/* Firmware from 10X branch. Deprecated, don't use in new code. */
> 	ATH10K_FW_FEATURE_WMI_10X = 1,
> 
>         [...]
> 
> So what you could is add a new flag enum ath10k_fw_features, create a
> new firmware-N.bin for your device and enable the flag on the firmware
> releases for your device only.
> 
> I don't know if this is usable, but one solution which came to my mind.

It sounds quite reasonable to pass this using firmawre-N.bin instead of
DT, however that would imply that we need to find firmware-N.bin in the
device-specific directory, where we keep the wlanmdsp.mbn as well - and
not under /lib/firmware/ath10k


For other devices (e.g. ADSP, modem or wlanmdsp.mbn) we're putting these
in e.g. /lib/firmware/qcom/LENOVO/81JL/ and specifies the location using
a firmware-name property in DT.

Regards,
Bjorn

> 
> -- 
> https://patchwork.kernel.org/project/linux-wireless/list/
> 
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
