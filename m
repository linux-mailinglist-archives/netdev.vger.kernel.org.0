Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 063E7FAA8F
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 08:00:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726474AbfKMHAg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 02:00:36 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42103 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726160AbfKMHAf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 02:00:35 -0500
Received: by mail-wr1-f67.google.com with SMTP id a15so975665wrf.9
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 23:00:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=rugrYaxZCiP2gM4hsS0PmTY/T9FiVMFS6xWRRwp7Uks=;
        b=iLRBNzKe3Ty81HmbP7CV1b8+p7WvR524FmbkGbeQglx6vlgdPRIEtlT5aQ667wL1tT
         fa5Jk+lPWh5Aba5vbf7Qv0SxdNsfarPP+m89qaVpdBD6q1y1SSlKcVdKojOZpKOD6o6d
         jEoXGrwvFyn1VDH2BV6jkMVVKdGisEZ2TLc3U1/71aFYAsETXJS68fekfL7x/wRPQzTg
         d/pWhoDmZkQTwAmliusnRed7o+iNesnwRFxbNsvtQbpgkOmFNOCfJIHBwFSiHBHwIe+b
         t9EiLrDZ3+fQ7fkIi/BH3hCQgdP8zNfLg+akdBk7LMt23LTHtzUqpviZYkD8Uxx8o59Z
         8yWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=rugrYaxZCiP2gM4hsS0PmTY/T9FiVMFS6xWRRwp7Uks=;
        b=Gt4jWqchYrz1lrD5k28fG1ZSNnEzJaQbwKpNPMlS4kgownhyCS0Drv2/56oEuXiGVE
         Gf9uvD3VeF9zUuty6iAoIW42lxV+G072N90pVwwoRsvK02bPDU9eYBqFlUDCkgbVbWjl
         K3/XehNBLa4sctp3RXRR/xAMoPXx0E/BvQ/lAqQc8/vsiWRKHx+a/8lGRp9bpRWS9+FF
         kVdPAIugfQQ/lgy6Q2mX/x6RJo1MtK3do3DmYndIIVuRnqRMgEPYd6LFKM0Boe7ryQbj
         bkhZ5nRWMP2igZsNCXBWsfrVwhcSjrqWO9n5cPtCygvpiFsnkpF59QMO1PX1xLYmq0OO
         t67Q==
X-Gm-Message-State: APjAAAWLxQUOK5rnGRf7vxjHAQycKkl2anwYoXoyqZQVNj1oDaRth+02
        Oqk+5CAnnEwSkRjYF7lvgZ80Ow==
X-Google-Smtp-Source: APXvYqzxXo5+THKRrJBHRbmsw/q0KRwfVf5UnS3F6vDui9Ylkubka0wc+vrYEI1WSLZkHjvVSA2Odw==
X-Received: by 2002:adf:e8ce:: with SMTP id k14mr1149133wrn.393.1573628432175;
        Tue, 12 Nov 2019 23:00:32 -0800 (PST)
Received: from netronome.com ([2001:982:756:703:d63d:7eff:fe99:ac9d])
        by smtp.gmail.com with ESMTPSA id 4sm1292022wmd.33.2019.11.12.23.00.31
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 12 Nov 2019 23:00:32 -0800 (PST)
Date:   Wed, 13 Nov 2019 08:00:31 +0100
From:   Simon Horman <simon.horman@netronome.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Jeffrey Hugo <jeffrey.l.hugo@gmail.com>, davem@davemloft.net,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, MSM <linux-arm-msm@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ath10k: Handle "invalid" BDFs for msm8998 devices
Message-ID: <20191113070031.qlikjctfnoxtald5@netronome.com>
References: <20191106234712.2380-1-jeffrey.l.hugo@gmail.com>
 <20191112090444.ak2xu67eawfgpdgb@netronome.com>
 <CAOCk7NoXv2-8GO=VYS8dNPJF6sj=S3RbkfqQGW0kvvVmR8V1kw@mail.gmail.com>
 <878soks77y.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878soks77y.fsf@kamboji.qca.qualcomm.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 13, 2019 at 06:58:25AM +0200, Kalle Valo wrote:
> Jeffrey Hugo <jeffrey.l.hugo@gmail.com> writes:
> 
> > On Tue, Nov 12, 2019 at 2:04 AM Simon Horman <simon.horman@netronome.com> wrote:
> >>
> >> On Wed, Nov 06, 2019 at 03:47:12PM -0800, Jeffrey Hugo wrote:
> >> > When the BDF download QMI message has the end field set to 1, it signals
> >> > the end of the transfer, and triggers the firmware to do a CRC check.  The
> >> > BDFs for msm8998 devices fail this check, yet the firmware is happy to
> >> > still use the BDF.  It appears that this error is not caught by the
> >> > downstream drive by concidence, therefore there are production devices
> >> > in the field where this issue needs to be handled otherwise we cannot
> >> > support wifi on them.  So, attempt to detect this scenario as best we can
> >> > and treat it as non-fatal.
> >> >
> >> > Signed-off-by: Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
> >> > ---
> >> >  drivers/net/wireless/ath/ath10k/qmi.c | 11 +++++++----
> >> >  1 file changed, 7 insertions(+), 4 deletions(-)
> >> >
> >> > diff --git a/drivers/net/wireless/ath/ath10k/qmi.c b/drivers/net/wireless/ath/ath10k/qmi.c
> >> > index eb618a2652db..5ff8cfc93778 100644
> >> > --- a/drivers/net/wireless/ath/ath10k/qmi.c
> >> > +++ b/drivers/net/wireless/ath/ath10k/qmi.c
> >> > @@ -265,10 +265,13 @@ static int ath10k_qmi_bdf_dnld_send_sync(struct ath10k_qmi *qmi)
> >> >                       goto out;
> >> >
> >> >               if (resp.resp.result != QMI_RESULT_SUCCESS_V01) {
> >> > -                     ath10k_err(ar, "failed to download board data file: %d\n",
> >> > -                                resp.resp.error);
> >> > -                     ret = -EINVAL;
> >> > -                     goto out;
> >> > +                     if (!(req->end == 1 &&
> >> > +                           resp.resp.result == QMI_ERR_MALFORMED_MSG_V01)) {
> >>
> >> Would it make sense to combine the inner and outer condition,
> >> something like this (completely untested) ?
> >
> > I guess, make sense from what perspective?  Looks like the assembly
> > ends up being the same, so it would be down to "readability" which is
> > subjective - I personally don't see a major advantage to one way or
> > the other.  It does look like Kalle already picked up this patch, so
> > I'm guessing that if folks feel your suggestion is superior, then it
> > would need to be a follow on.

My feeling is that it would reduce the churn in the patch making the
patch more readable and likewise improving the readability of the code.
But I do agree this does not affect run-time and I am ambivalent about
updating the patch if it has already been (semi-)accepted.

> 
> Same here, it's only on the pending branch so changes are still
> possible.
> 
> -- 
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
