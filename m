Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68C47F94C9
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 16:54:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727249AbfKLPyD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 10:54:03 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:46880 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726659AbfKLPyD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 10:54:03 -0500
Received: by mail-io1-f65.google.com with SMTP id i11so2414931iol.13;
        Tue, 12 Nov 2019 07:54:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+1IEojNQRKaJ8R6eORbksbI7U86NwchAf1hHUgJqjpo=;
        b=vYzeDsKt+LCERvwGBGKTwYAcLMKlX8aTKqabbg0JK21GrAPQcAhDLvykQYDpYPAfJD
         YSLYQ/FE+wZZfSIQTQ/Yfl7Kw7kSvXi9QyWB6LnGZyemMZ6LiHXsf8SBT7XwYboj2/fu
         Kc+wpOunu+fXCe3b7ri344w3kI5J9edQYl1tiVytFiYlbAwhRtaT0WXT5jCSWw716too
         Q02zA9iTCBInKENJ51YRMfMNNCjJ5PauBVoxh0PBk6wdYk9bDhvS9ZKW0ilYrVAtX7W1
         Yn6Rx7f6IU9i++q919E5gjvTNU0yqQ0AZ4FGOiMGZB4HJ2Iq9ooJBWBWz0aO7yYrfqu8
         BgbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+1IEojNQRKaJ8R6eORbksbI7U86NwchAf1hHUgJqjpo=;
        b=QTH5g4tuxBVRrZyQR9e/hMRksN/4FDMzP0nsD+QejUdrhd1IZzNYTpiuTd83qDUcMB
         2UT7cLVIumxDlyMeqdxvNGioSMfa9TOzpQmL0EDh/kQ2ih1izIguMEn5pd13P+5qBLzu
         FyAVkXkMpDfVb/nwpRLAlReWPVR+MmB3y7srJQsU/EuYJLe8FBFIWxNJ4amCfCTUw07N
         Kd/9sVs+CY6IdOyS9YMTEQoCVGJihNsMZ6sGy1Cw9fwHAoCEDy8PbCJ9t/BmIt8cyxHu
         AabGWzFDdU5j3ZS1SCu0pWkeiSG7p3L2QZxyFl8oOTCWbaSJtm06Sz2PucvEoq70Gay/
         ysXg==
X-Gm-Message-State: APjAAAV+LjByOepCchutb13qyGV+oEtaN8y1UQ11Pr91dDaZ4ZwTwknO
        9+5caMrzhypTUZdc7+XjVRV3iNm8Z4dU8LLgrAw=
X-Google-Smtp-Source: APXvYqynO/p313AXOl/WdxEoymEYNA7twP36L4Z5wcKFago9vMAZVo1EBJvr39aEvnOSMtl/ae0Wh7uuhz+Vh0aPrHg=
X-Received: by 2002:a5e:8a04:: with SMTP id d4mr31139489iok.42.1573574042003;
 Tue, 12 Nov 2019 07:54:02 -0800 (PST)
MIME-Version: 1.0
References: <20191106234712.2380-1-jeffrey.l.hugo@gmail.com> <20191112090444.ak2xu67eawfgpdgb@netronome.com>
In-Reply-To: <20191112090444.ak2xu67eawfgpdgb@netronome.com>
From:   Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
Date:   Tue, 12 Nov 2019 08:53:51 -0700
Message-ID: <CAOCk7NoXv2-8GO=VYS8dNPJF6sj=S3RbkfqQGW0kvvVmR8V1kw@mail.gmail.com>
Subject: Re: [PATCH] ath10k: Handle "invalid" BDFs for msm8998 devices
To:     Simon Horman <simon.horman@netronome.com>
Cc:     kvalo@codeaurora.org, davem@davemloft.net,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, MSM <linux-arm-msm@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 12, 2019 at 2:04 AM Simon Horman <simon.horman@netronome.com> wrote:
>
> On Wed, Nov 06, 2019 at 03:47:12PM -0800, Jeffrey Hugo wrote:
> > When the BDF download QMI message has the end field set to 1, it signals
> > the end of the transfer, and triggers the firmware to do a CRC check.  The
> > BDFs for msm8998 devices fail this check, yet the firmware is happy to
> > still use the BDF.  It appears that this error is not caught by the
> > downstream drive by concidence, therefore there are production devices
> > in the field where this issue needs to be handled otherwise we cannot
> > support wifi on them.  So, attempt to detect this scenario as best we can
> > and treat it as non-fatal.
> >
> > Signed-off-by: Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
> > ---
> >  drivers/net/wireless/ath/ath10k/qmi.c | 11 +++++++----
> >  1 file changed, 7 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/net/wireless/ath/ath10k/qmi.c b/drivers/net/wireless/ath/ath10k/qmi.c
> > index eb618a2652db..5ff8cfc93778 100644
> > --- a/drivers/net/wireless/ath/ath10k/qmi.c
> > +++ b/drivers/net/wireless/ath/ath10k/qmi.c
> > @@ -265,10 +265,13 @@ static int ath10k_qmi_bdf_dnld_send_sync(struct ath10k_qmi *qmi)
> >                       goto out;
> >
> >               if (resp.resp.result != QMI_RESULT_SUCCESS_V01) {
> > -                     ath10k_err(ar, "failed to download board data file: %d\n",
> > -                                resp.resp.error);
> > -                     ret = -EINVAL;
> > -                     goto out;
> > +                     if (!(req->end == 1 &&
> > +                           resp.resp.result == QMI_ERR_MALFORMED_MSG_V01)) {
>
> Would it make sense to combine the inner and outer condition,
> something like this (completely untested) ?

I guess, make sense from what perspective?  Looks like the assembly
ends up being the same, so it would be down to "readability" which is
subjective - I personally don't see a major advantage to one way or
the other.  It does look like Kalle already picked up this patch, so
I'm guessing that if folks feel your suggestion is superior, then it
would need to be a follow on.

>
>                 if (resp.resp.result != QMI_RESULT_SUCCESS_V01 &&
>                     !(req->end == 1 &&
>                       resp.resp.result == QMI_ERR_MALFORMED_MSG_V01)) {
>
> > +                             ath10k_err(ar, "failed to download board data file: %d\n",
> > +                                        resp.resp.error);
> > +                             ret = -EINVAL;
> > +                             goto out;
> > +                     }
> >               }
> >
> >               remaining -= req->data_len;
> > --
> > 2.17.1
> >
