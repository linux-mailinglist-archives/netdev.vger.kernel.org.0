Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33CEF2A3DFA
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 08:48:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727933AbgKCHsv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 02:48:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbgKCHsu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 02:48:50 -0500
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26A39C061A48
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 23:48:50 -0800 (PST)
Received: by mail-wm1-x344.google.com with SMTP id p22so11701963wmg.3
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 23:48:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tUGaeM8Mnf/FUCVI3KiAYmAdi9a2oLtRodyvcvLcqLs=;
        b=bFV6uczOZdEu2X41lTzQJm8V8VQDTE3pWtlE6Tp8MD+Nx1HjP+D0YYsHs6nPAeXR3/
         hRKLZ+vkcnx+33fPceH+Pb7Mx0POz4pZcWqJK3Q98k/EetyMA/zmuhdTOj5fQ38nOc5H
         VxljblMI5DlEMaC4kAeMupEG0zY8ou1YC5IzarsvlUUxKbiti0So65SEtAU919xrb+f6
         fH9E4L6M9i84V4XY5ZxvvvfMeac+k7afWr50fOGholdPzvlvcT9OSwnwsMdbZEgaN2U0
         4uEBqi5UHHJy/lU4bBSTxyD6EWEqNjfMuhoM+5esqzhxazSYNm8QagucDMUPJRKEIz+s
         /EqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tUGaeM8Mnf/FUCVI3KiAYmAdi9a2oLtRodyvcvLcqLs=;
        b=tYD4NDtw7XSLN2erSlnwq4dJ3ITTs9dN3K8pfHDPKe5XDXw6fE+jMGzdeaDAiLzb1F
         QLrc2Kd87x6piHhJnBbkyZzCFZ1j7xUdSMsSVgMh/ZQgGiGGCcQGeJul1yd6JvFXfEVe
         vSEl+ceAT6StWxSpfDPGrhhNvAonKVsOBTESCYhSN+K77jhDVV9Algv7yt6OvfTotWHb
         8oivL/7EjBP7dNZFphWWKIX6WOMWIjQiDCWHZrsgxRnb/PqdREMl85NGK41g1xIUn5Xg
         Jti98Ih04fn/vVICCEK4+KT+4Eq9V5LXYlxOHF+kxm69VohgTpSKGGfmgwvL94vbPllP
         Wrgw==
X-Gm-Message-State: AOAM532vWsTZNt4UIKT9vbj+LRxtLTnCX1FLZb8G10O8ZPURFGblHmev
        cpocEa07vAIn8qnftsE7t5/QwZXerweTFpUo+8Gu1A==
X-Google-Smtp-Source: ABdhPJx9ZcceuRnyasRN+tUhLDlW5agjweOQW/eO5nyTUhbn2MvXHT0gzlFn4Oww3KesuquyOtjOc0SLjijnLxJ94tE=
X-Received: by 2002:a1c:1c1:: with SMTP id 184mr2149519wmb.16.1604389728675;
 Mon, 02 Nov 2020 23:48:48 -0800 (PST)
MIME-Version: 1.0
References: <1601058581-19461-1-git-send-email-amit.pundir@linaro.org>
 <20200929190817.GA968845@bogus> <20201029134017.GA807@yoga>
In-Reply-To: <20201029134017.GA807@yoga>
From:   Amit Pundir <amit.pundir@linaro.org>
Date:   Tue, 3 Nov 2020 13:18:12 +0530
Message-ID: <CAMi1Hd20UpNhZm6z5t5Kcy8eTABiAj7X_Gm66QnJspZWSio0Ew@mail.gmail.com>
Subject: Re: [PATCH] ath10k: Introduce a devicetree quirk to skip host cap QMI requests
To:     Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     Rob Herring <robh@kernel.org>, Kalle Valo <kvalo@codeaurora.org>,
        David S Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jeffrey Hugo <jeffrey.l.hugo@gmail.com>,
        John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Konrad Dybcio <konradybcio@gmail.com>,
        ath10k <ath10k@lists.infradead.org>,
        dt <devicetree@vger.kernel.org>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rob, Bjorn, Kalle,

On Thu, 29 Oct 2020 at 19:10, Bjorn Andersson
<bjorn.andersson@linaro.org> wrote:
>
> On Tue 29 Sep 14:08 CDT 2020, Rob Herring wrote:
>
> > On Fri, Sep 25, 2020 at 11:59:41PM +0530, Amit Pundir wrote:
> > > There are firmware versions which do not support host capability
> > > QMI request. We suspect either the host cap is not implemented or
> > > there may be firmware specific issues, but apparently there seem
> > > to be a generation of firmware that has this particular behavior.
> > >
> > > For example, firmware build on Xiaomi Poco F1 (sdm845) phone:
> > > "QC_IMAGE_VERSION_STRING=WLAN.HL.2.0.c3-00257-QCAHLSWMTPLZ-1"
> > >
> > > If we do not skip the host cap QMI request on Poco F1, then we
> > > get a QMI_ERR_MALFORMED_MSG_V01 error message in the
> > > ath10k_qmi_host_cap_send_sync(). But this error message is not
> > > fatal to the firmware nor to the ath10k driver and we can still
> > > bring up the WiFi services successfully if we just ignore it.
> > >
> > > Hence introducing this DeviceTree quirk to skip host capability
> > > QMI request for the firmware versions which do not support this
> > > feature.
> >
> > So if you change the WiFi firmware, you may force a DT change too. Those
> > are pretty independent things otherwise.
> >
>
> Yes and that's not good. But I looked at somehow derive this from
> firmware version numbers etc and it's not working out, so I'm out of
> ideas for alternatives.
>
> > Why can't you just always ignore this error? If you can't deal with this
> > entirely in the driver, then it should be part of the WiFi firmware so
> > it's always in sync.
> >
>
> Unfortunately the firmware versions I've hit this problem on has gone
> belly up when receiving this request, that's why I asked Amit to add a
> flag to skip it.

So what is next for this DT quirk?

I'm OK to go back to my previous of_machine_is_compatible()
device specific hack, for now,
https://patchwork.kernel.org/project/linux-wireless/patch/1600328501-8832-1-git-send-email-amit.pundir@linaro.org/
till we have a reasonable fix in place or receive a vendor firmware
drop which fixes this problem (which I believe is highly unlikely
though, for this 2+ years old device).

Regards,
Amit Pundir

>
> That said, in the devices I've hit this I've managed to get newer
> firmware working, which doesn't have either problem.
>
> Regards,
> Bjorn
