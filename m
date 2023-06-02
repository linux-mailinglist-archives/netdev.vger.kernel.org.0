Return-Path: <netdev+bounces-7278-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F210271F82C
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 03:47:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 687201C21175
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 01:47:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09D7310FA;
	Fri,  2 Jun 2023 01:47:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC9BF10E3
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 01:47:04 +0000 (UTC)
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A23B136
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 18:47:01 -0700 (PDT)
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id EB40D3F555
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 01:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1685670419;
	bh=UvcW3/oxllU4v9bNRlCwfieMvWC94LEr0WbgkYqHZrE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type;
	b=eaYaM7ZhoHiFOeAGUn9Ufr1LZYyRoINHfUaC2ishdyUcwVVW8LpGgW5sTu7ROslCb
	 boN3n4KHl5Gu7KX6oSHaWDt1Dl5CqYaEDhF1wpm0dJFW2gEInOEldzlWZkhIN31zh1
	 BjwyvHCD5tcdR2nOJwhcMF4M8hQpI64BovX8Tq3cZIwkhrVljTzm/wzPa02aiihzMb
	 FXtkXu/VVDuWALLvCFYbk68Df9WmK/yhTgxXZzQdBo/lpzCFRxRbF30czWuEzXVTAL
	 oMXfjikKs0RrN3vxXAF7XxidvlN7K19Lt5Uw/Fv7ein60yn032E3aAQbIfj+W/Cg1F
	 6zyn47aI5Y3lw==
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-6af7f790e8aso1396726a34.1
        for <netdev@vger.kernel.org>; Thu, 01 Jun 2023 18:46:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685670417; x=1688262417;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UvcW3/oxllU4v9bNRlCwfieMvWC94LEr0WbgkYqHZrE=;
        b=EvRy5b3KK2SNoCnr9TQk34nh2DuoduS2xkfJmZnFY1YevvCUDRMNRQ/5yhx4eprpQR
         vfsISBtYl8ZhxGxWQpn6XMDUAFY2k5mrBcDbo3WTNpFEEABPW6XkCIvwACwubygko3oz
         E38JItCMVrT7TpXD4rY7IAgYM8VMKX6YZEbBk1kLgbiNhXwcxzTuEGsaIbj+xaxL+Knb
         DHtyls5yjVgaiIeaLZRzn3xVGcNmI/6JGzBFU+uIhpHcXKGlvL8ITecTJIz4EXa4ZPgo
         jNQSIsVVzgsmhMz89JjoEpxi4rVbv5wNlrq8f630zIM4K3DWaeoZEkYL/OPxOje1hbN7
         2ykQ==
X-Gm-Message-State: AC+VfDyl+nlXBM6u9GsOlsax7q9zbyPZbja9anYWIFMVLU5B982+BU2w
	JO6piJo66CwCElU7zY5iMHTZDu/mky6o+oiNlbwYqalUWi3EarInktWCUSjHB1lj01fFOXBxYqk
	PHD5Kc3gh4sGXC9TMQ+V9AvEgz3IoR5Wgf3RpwhXo+k3vzN8mDQ==
X-Received: by 2002:a05:6830:18f5:b0:69f:8d0f:9a1e with SMTP id d21-20020a05683018f500b0069f8d0f9a1emr1044247otf.7.1685670416927;
        Thu, 01 Jun 2023 18:46:56 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7Ob63GyqsSmQy65eOFF419RTf7y37mI7toGOwfBx9WOe2fk4Qy+6OOxHIGuMFGXuFjH7IT3lMSnLX6qXYRCt4=
X-Received: by 2002:a05:6830:18f5:b0:69f:8d0f:9a1e with SMTP id
 d21-20020a05683018f500b0069f8d0f9a1emr1044234otf.7.1685670416684; Thu, 01 Jun
 2023 18:46:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230601162537.1163270-1-kai.heng.feng@canonical.com> <269262acfcce8eb1b85ee1fe3424a5ef2991f481.camel@gmail.com>
In-Reply-To: <269262acfcce8eb1b85ee1fe3424a5ef2991f481.camel@gmail.com>
From: Kai-Heng Feng <kai.heng.feng@canonical.com>
Date: Fri, 2 Jun 2023 09:46:45 +0800
Message-ID: <CAAd53p7c6eEqxd3jecfgvpxuYO3nmmmovcqD=3PgbqSVCWFfxA@mail.gmail.com>
Subject: Re: [PATCH] e1000e: Use PME poll to circumvent unreliable ACPI wake
To: Alexander H Duyck <alexander.duyck@gmail.com>
Cc: jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com, 
	linux-pm@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 2, 2023 at 4:24=E2=80=AFAM Alexander H Duyck
<alexander.duyck@gmail.com> wrote:
>
> On Fri, 2023-06-02 at 00:25 +0800, Kai-Heng Feng wrote:
> > On some I219 devices, ethernet cable plugging detection only works once
> > from PCI D3 state. Subsequent cable plugging does set PME bit correctly=
,
> > but device still doesn't get woken up.
>
> Do we have a root cause on why things don't get woken up? This seems
> like an issue where something isn't getting reset after the first
> wakeup and so future ones are blocked.

No we don't know the root cause.
I guess the D3 wake isn't really tested under Windows because I219
doesn't use runtime D3 on Windows.

>
> > Since I219 connects to the root complex directly, it relies on platform
> > firmware (ACPI) to wake it up. In this case, the GPE from _PRW only
> > works for first cable plugging but fails to notify the driver for
> > subsequent plugging events.
> >
> > The issue was originally found on CNP, but the same issue can be found
> > on ADL too. So workaround the issue by continuing use PME poll after
> > first ACPI wake. As PME poll is always used, the runtime suspend
> > restriction for CNP can also be removed.
> >
> > Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> > ---
> >  drivers/net/ethernet/intel/e1000e/netdev.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/e=
thernet/intel/e1000e/netdev.c
> > index bd7ef59b1f2e..f0e48f2bc3a2 100644
> > --- a/drivers/net/ethernet/intel/e1000e/netdev.c
> > +++ b/drivers/net/ethernet/intel/e1000e/netdev.c
> > @@ -7021,6 +7021,8 @@ static __maybe_unused int e1000e_pm_runtime_resum=
e(struct device *dev)
> >       struct e1000_adapter *adapter =3D netdev_priv(netdev);
> >       int rc;
> >
> > +     pdev->pme_poll =3D true;
> > +
> >       rc =3D __e1000_resume(pdev);
> >       if (rc)
> >               return rc;
>
> Doesn't this enable this too broadly. I know there are a number of
> devices that run under the e1000e and I would imagine that we don't
> want them all running with "pme_poll =3D true" do we?

Whack a mole isn't scaling, either.
The generation between CNP and ADL are probably affected too.

>
> It seems like at a minimum we should only be setting this for specific
> platofrms or devices instead of on all of them.
>
> Also this seems like something we should be setting on the suspend side
> since it seems to be clared in the wakeup calls.

pme_poll gets cleared on wakeup, and once it's cleared the device will
be removed from pci_pme_list.

To prevent that, reset pme_poll to true immediately on runtime resume.

>
> Lastly I am not sure the first one is necessarily succeding. You might
> want to check the status of pme_poll before you run your first test.
> From what I can tell it looks like the initial state is true in
> pci_pm_init. If so it might be getting cleared after the first wakeup
> which is what causes your issues.

That's by design. pme_poll gets cleared when the hardware is capable
to signal wakeup via PME# or ACPI GPE. For detected hardwares, the
pme_poll will never be cleared.
So this becomes tricky for the issue, since the ACPI GPE works for
just one time, but never again.

>
> > @@ -7682,7 +7684,7 @@ static int e1000_probe(struct pci_dev *pdev, cons=
t struct pci_device_id *ent)
> >
> >       dev_pm_set_driver_flags(&pdev->dev, DPM_FLAG_SMART_PREPARE);
> >
> > -     if (pci_dev_run_wake(pdev) && hw->mac.type !=3D e1000_pch_cnp)
> > +     if (pci_dev_run_wake(pdev))
> >               pm_runtime_put_noidle(&pdev->dev);
> >
> >       return 0;
>
> I assume this is the original workaround that was put in to address
> this issue. Perhaps you should add a Fixes tag to this to identify
> which workaround this patch is meant to be replacing.

Another possibility is to remove runtime power management completely.
I wonder why Windows keep the device at D0 all the time? Can Linux
align with Windows?

Kai-Heng

