Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A177FB33E
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 16:11:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727968AbfKMPLz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 10:11:55 -0500
Received: from mail-il1-f195.google.com ([209.85.166.195]:46147 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727550AbfKMPLy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 10:11:54 -0500
Received: by mail-il1-f195.google.com with SMTP id q1so2072361ile.13;
        Wed, 13 Nov 2019 07:11:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Oet7iN8luRIwm2cG0enPN1WO0bfm28VO//v3gW2hBng=;
        b=GQ3XKwp2AaghEayclfUYMtj06s+kNJ3pPo2qy6o3BVVu+8If5uf39XUbSZkODmmU33
         WDeAJ8hMYpRvi0cUuO/9lrc5XrrtCMRY0onKyQX+VhaWxmTI+Lz9TJj1GRzi3MxLdt04
         tekoOYGqFXTHSJzb8/GuwS7hRrbPZtwG2eVfgxdjpZDVr/iJ7aDlFDftc6szgU1vzaZZ
         WeINd1UMXpiaoHmo3QdKl8f0o0Ow/3SUmeyIp8xIT1lRCsIZfWVSQ879lYWJ+YbUDZFI
         II3F90tO59YT4Nw3DJh9VTEt4ev51KZP3sH1tQ8GQslbwz1aAb4/uPva7x6OjUoSOp5j
         K0/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Oet7iN8luRIwm2cG0enPN1WO0bfm28VO//v3gW2hBng=;
        b=Em66xhI7iZmT7T/LPeWqOybGO8xX7y921lsnGQIplIt7UXDqLcwhSWXWW3A2PFTdDp
         NdI07XtacRO9E02E1F671F71fgkCBB4QY4MPOgrMNPttUqk0+YcSKRU7o6zHKI11lEKQ
         0Y/2wERkDV137dSeG1E6PylhdAo+gx1HWHE2KkKJUlpGwa8kVZXTWvrCiuYdLE7Ohq+d
         Q7UDdGk88mjfNQAf0s+iSemnK3E9kF4Qh8UlO3pSIupl52kDkYgDjWoMaT5hXOFjQa5N
         bTP547L7khkGVIUqu1guJ+eMTjQ1qoYsX6pz5c+RV4iCrHpVCnm/MjYgkTt6Y8vjCaGW
         Itmg==
X-Gm-Message-State: APjAAAUwwKznI1dOHVP9MtBLPCI29yxtfKU9x8i4EDTN7qdEFeRJ69gN
        fW+pAlV0H4DH0Bp/pSySPEkt8KcwS0s1I0a28NaNIA==
X-Google-Smtp-Source: APXvYqzJ6RcpW1AKYY64DcFg31Q3abj110+k7vsmWtJerlFCp+aLmBxLTxWeV9e9dqahFbq36N/70b0ruDZgONRDz9Y=
X-Received: by 2002:a92:831d:: with SMTP id f29mr4564735ild.263.1573657912726;
 Wed, 13 Nov 2019 07:11:52 -0800 (PST)
MIME-Version: 1.0
References: <20191106231650.1580-1-jeffrey.l.hugo@gmail.com>
 <20191112084225.casuncbo7z54vu4g@netronome.com> <CAOCk7NpNgtTSus2KtBMe=jGLFyBumVfRVxKxtHoEDUEt2-6tqQ@mail.gmail.com>
 <87d0dws79m.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87d0dws79m.fsf@kamboji.qca.qualcomm.com>
From:   Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
Date:   Wed, 13 Nov 2019 08:11:41 -0700
Message-ID: <CAOCk7NpGm7jLH-z9CdJaYAGkg_WuiBxtxgwby+BJef=asFbavw@mail.gmail.com>
Subject: Re: [PATCH] ath10k: Fix qmi init error handling
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Simon Horman <simon.horman@netronome.com>, davem@davemloft.net,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, MSM <linux-arm-msm@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 12, 2019 at 9:57 PM Kalle Valo <kvalo@codeaurora.org> wrote:
>
> Jeffrey Hugo <jeffrey.l.hugo@gmail.com> writes:
>
> > On Tue, Nov 12, 2019 at 1:42 AM Simon Horman <simon.horman@netronome.com> wrote:
> >>
> >> On Wed, Nov 06, 2019 at 03:16:50PM -0800, Jeffrey Hugo wrote:
> >> > When ath10k_qmi_init() fails, the error handling does not free the irq
> >> > resources, which causes an issue if we EPROBE_DEFER as we'll attempt to
> >> > (re-)register irqs which are already registered.
> >> >
> >> > Fixes: ba94c753ccb4 ("ath10k: add QMI message handshake for wcn3990 client")
> >> > Signed-off-by: Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
> >> > ---
> >> >  drivers/net/wireless/ath/ath10k/snoc.c | 2 +-
> >> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >> >
> >> > diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wireless/ath/ath10k/snoc.c
> >> > index fc15a0037f0e..f2a0b7aaad3b 100644
> >> > --- a/drivers/net/wireless/ath/ath10k/snoc.c
> >> > +++ b/drivers/net/wireless/ath/ath10k/snoc.c
> >> > @@ -1729,7 +1729,7 @@ static int ath10k_snoc_probe(struct platform_device *pdev)
> >> >       ret = ath10k_qmi_init(ar, msa_size);
> >> >       if (ret) {
> >> >               ath10k_warn(ar, "failed to register wlfw qmi client: %d\n", ret);
> >> > -             goto err_core_destroy;
> >> > +             goto err_free_irq;
> >> >       }
> >>
> >> From a casual examination of the code this seems like a step in the right
> >> direction. But does this error path also need to call ath10k_hw_power_off() ?
> >
> > It probably should.  I don't see any fatal errors from the step being
> > skipped, although it might silence some regulator warnings about being
> > left on.  Unlikely to be observed by most folks as I was initing the
> > driver pretty early to debug some things.  Looks like Kalle already
> > picked up this patch though, so I guess your suggestion would need to
> > be a follow up.
>
> Actually it's only in the pending branch, which means that the patch can
> be changed or a new version can be submitted:

Thats an interesting flow.  Ok.

>
> https://wireless.wiki.kernel.org/en/users/drivers/ath10k/submittingpatches#patch_flow
>
> The easiest way to check the state of a wireless patch is from
> patchwork:
>
> https://patchwork.kernel.org/patch/11231325/
>
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#checking_state_of_patches_from_patchwork
>
> --
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
