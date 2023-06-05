Return-Path: <netdev+bounces-7909-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 49FD97220F3
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 10:25:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 047D12811DD
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 08:25:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F4B5125DF;
	Mon,  5 Jun 2023 08:25:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B29C17E8
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 08:25:50 +0000 (UTC)
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD545C7
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 01:25:47 -0700 (PDT)
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 30F243F592
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 08:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1685953546;
	bh=w/vz4qy3Kc7GOpDb+K0VZMneVYxuO4mipxqG9LguKK8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type;
	b=C9C+jzJWn3VQlOLWcKKQC5noy2dPLaxAYs5r5A/oHB5fX+epllJDKV6J8L24p7Q7q
	 eCN2GcQS9xk0+dM3amZlstyJNnp3lHo+QYMT+ou5qblCkYa6OWZrm2siPHxVsuETxG
	 GGTgtP4UES9ZpJBy2FH2NbPUCZnppkXYOEw7zHR/aSL3AVMffoh1q6uHEQNrisKyCJ
	 40Lq11uaJr0sTXfS5lhvxFkJt9LKg6GPanwz6NocWqLptSTVic3SLHPxuPcgqoIS74
	 q039cGRbS2U73L/hHSQa54j1lGTY2lQFjxxsVYUtJ9lh9VVOQ9x6o8nLCPsdgoVEXh
	 +LJ4OxrMkcJ1g==
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-75d53bab5a9so124317985a.2
        for <netdev@vger.kernel.org>; Mon, 05 Jun 2023 01:25:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685953544; x=1688545544;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w/vz4qy3Kc7GOpDb+K0VZMneVYxuO4mipxqG9LguKK8=;
        b=CMxpl5O/csD0/a4FTIqs0WgCONbj+cWf06TGEHr1bzQ8+m0p1bRApluDennOdla6K+
         ipKQ6HRDhyd1XRIA2qmB9s9tYo7D/uDOUZi/KSRSCqbRRY8M6DSvJND8Ubzucmm5pI1G
         4yaI/pgMhYVO4PG1yCDvfAobKNPkoZ+qxj+se368wf7aZrOQbhDmMHcflFF0x98aV8V6
         4ui+FSRKR1aEWaDetTqu62dBCKSWMm4ybNW6ZeQWgbzedywdcwbSX9iZxVSm+F6glryB
         90jxkah3TiwSROyJpbfT/6P8ST9BbQhFEp8LZBUGBKh86PlPqpQIjJ+MfN/Lw0jISH69
         lRfA==
X-Gm-Message-State: AC+VfDwNCPrPpiiyX3Qysdw2kcD0RiMPQHymMxRi6MKzbMbKwXglwdhd
	4jAxDWJELmWZ+tPTre6tPd9P0qBW9AMAwqIOEawUv343lP8rGV0zZ1tNcFeyXKTCUng2059JPfd
	e2k32o6VqM7TC5QGHDWonuQLN4jDfOtKKomauEGNcfsR2xfjq8A==
X-Received: by 2002:a05:620a:678b:b0:75e:b9b8:ab57 with SMTP id rr11-20020a05620a678b00b0075eb9b8ab57mr1321521qkn.70.1685953544343;
        Mon, 05 Jun 2023 01:25:44 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4AgPS6tYIm8uNjvjRnd4X/dKtb3kpAGwevuMacOVrV0JiWen9kzqyAmGft2GuHieBV9kyujChRhnQqQi4e9Po=
X-Received: by 2002:a05:620a:678b:b0:75e:b9b8:ab57 with SMTP id
 rr11-20020a05620a678b00b0075eb9b8ab57mr1321510qkn.70.1685953544065; Mon, 05
 Jun 2023 01:25:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230601162537.1163270-1-kai.heng.feng@canonical.com>
 <269262acfcce8eb1b85ee1fe3424a5ef2991f481.camel@gmail.com>
 <CAAd53p7c6eEqxd3jecfgvpxuYO3nmmmovcqD=3PgbqSVCWFfxA@mail.gmail.com> <577f38ed-8532-c32e-07bd-4a3b384d5fe8@molgen.mpg.de>
In-Reply-To: <577f38ed-8532-c32e-07bd-4a3b384d5fe8@molgen.mpg.de>
From: Kai-Heng Feng <kai.heng.feng@canonical.com>
Date: Mon, 5 Jun 2023 16:25:32 +0800
Message-ID: <CAAd53p6TNFLrwJZaR5OJKnbDn6ggidOLgeaFSn8JVf4oXZUBcQ@mail.gmail.com>
Subject: Re: [Intel-wired-lan] [PATCH] e1000e: Use PME poll to circumvent
 unreliable ACPI wake
To: Paul Menzel <pmenzel@molgen.mpg.de>
Cc: Alexander H Duyck <alexander.duyck@gmail.com>, linux-pm@vger.kernel.org, 
	intel-wired-lan@lists.osuosl.org, linux-kernel@vger.kernel.org, 
	Eric Dumazet <edumazet@google.com>, Jesse Brandeburg <jesse.brandeburg@intel.com>, 
	Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	"David S. Miller" <davem@davemloft.net>, linux-pci@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Paul,

On Fri, Jun 2, 2023 at 4:43=E2=80=AFPM Paul Menzel <pmenzel@molgen.mpg.de> =
wrote:
>
> [Cc: linux-pci@vger.kernel.org]
>
> Dear Kai,
>
>
> Thank you for your patch.
>
> Am 02.06.23 um 03:46 schrieb Kai-Heng Feng:
> > On Fri, Jun 2, 2023 at 4:24=E2=80=AFAM Alexander H Duyck wrote:
> >>
> >> On Fri, 2023-06-02 at 00:25 +0800, Kai-Heng Feng wrote:
> >>> On some I219 devices, ethernet cable plugging detection only works on=
ce
> >>> from PCI D3 state. Subsequent cable plugging does set PME bit correct=
ly,
> >>> but device still doesn't get woken up.
>
> Could you please add the list of all the devices with the firmware
> version, you know this problem exists on? Please also add the URLs of
> the bug reports at the end of the commit message.

Firmware do you mean the firmware on I219 device, or BIOS?

>
> Is that problem logged somehow? Could a log message be added first?

There's nothing gets logged. When this happens the ACPI GPE is dead silent.

>
> >> Do we have a root cause on why things don't get woken up? This seems
> >> like an issue where something isn't getting reset after the first
> >> wakeup and so future ones are blocked.
> >
> > No we don't know the root cause.
> > I guess the D3 wake isn't really tested under Windows because I219
> > doesn't use runtime D3 on Windows.
>
> How do you know? Where you able to look at the Microsoft Windows driver
> source code?

Device Manager shows the current PCI state.

>
> >>> Since I219 connects to the root complex directly, it relies on platfo=
rm
> >>> firmware (ACPI) to wake it up. In this case, the GPE from _PRW only
> >>> works for first cable plugging but fails to notify the driver for
> >>> subsequent plugging events.
> >>>
> >>> The issue was originally found on CNP, but the same issue can be foun=
d
> >>> on ADL too. So workaround the issue by continuing use PME poll after
>
> The verb is spelled with a space: work around.

Sure, will change it.

>
> >>> first ACPI wake. As PME poll is always used, the runtime suspend
> >>> restriction for CNP can also be removed.
>
> When was that restriction for CNP added?

The restriction for CNP+ was introduced by commit 459d69c407f9
("e1000e: Disable runtime PM on CNP+") and modified by 3335369bad99
("e1000e: Remove the runtime suspend restriction on CNP+").

>
> >>> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> >>> ---
> >>>   drivers/net/ethernet/intel/e1000e/netdev.c | 4 +++-
> >>>   1 file changed, 3 insertions(+), 1 deletion(-)
> >>>
> >>> diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net=
/ethernet/intel/e1000e/netdev.c
> >>> index bd7ef59b1f2e..f0e48f2bc3a2 100644
> >>> --- a/drivers/net/ethernet/intel/e1000e/netdev.c
> >>> +++ b/drivers/net/ethernet/intel/e1000e/netdev.c
> >>> @@ -7021,6 +7021,8 @@ static __maybe_unused int e1000e_pm_runtime_res=
ume(struct device *dev)
> >>>        struct e1000_adapter *adapter =3D netdev_priv(netdev);
> >>>        int rc;
> >>>
> >>> +     pdev->pme_poll =3D true;
> >>> +
> >>>        rc =3D __e1000_resume(pdev);
> >>>        if (rc)
> >>>                return rc;
> >>
> >> Doesn't this enable this too broadly. I know there are a number of
> >> devices that run under the e1000e and I would imagine that we don't
> >> want them all running with "pme_poll =3D true" do we?
> >
> > Whack a mole isn't scaling, either.
> > The generation between CNP and ADL are probably affected too.
> >
> >> It seems like at a minimum we should only be setting this for specific
> >> platofrms or devices instead of on all of them.
> >>
> >> Also this seems like something we should be setting on the suspend sid=
e
> >> since it seems to be cleared in the wakeup calls.
> >
> > pme_poll gets cleared on wakeup, and once it's cleared the device will
> > be removed from pci_pme_list.
> >
> > To prevent that, reset pme_poll to true immediately on runtime resume.
> >
> >> Lastly I am not sure the first one is necessarily succeeding. You migh=
t
> >> want to check the status of pme_poll before you run your first test.
> >> From what I can tell it looks like the initial state is true in
> >> pci_pm_init. If so it might be getting cleared after the first wakeup
> >> which is what causes your issues.
> >
> > That's by design. pme_poll gets cleared when the hardware is capable
> > to signal wakeup via PME# or ACPI GPE. For detected hardwares, the
> > pme_poll will never be cleared.
> > So this becomes tricky for the issue, since the ACPI GPE works for
> > just one time, but never again.
> >
> >>> @@ -7682,7 +7684,7 @@ static int e1000_probe(struct pci_dev *pdev, co=
nst struct pci_device_id *ent)
> >>>
> >>>        dev_pm_set_driver_flags(&pdev->dev, DPM_FLAG_SMART_PREPARE);
> >>>
> >>> -     if (pci_dev_run_wake(pdev) && hw->mac.type !=3D e1000_pch_cnp)
> >>> +     if (pci_dev_run_wake(pdev))
> >>>                pm_runtime_put_noidle(&pdev->dev);
> >>>
> >>>        return 0;
> >>
> >> I assume this is the original workaround that was put in to address
> >> this issue. Perhaps you should add a Fixes tag to this to identify
> >> which workaround this patch is meant to be replacing.
> >
> > Another possibility is to remove runtime power management completely.
> > I wonder why Windows keep the device at D0 all the time?
>
> Who knows how to contact Intel=E2=80=99s driver developers for Microsoft =
Windows?

Probably this mailing list?

>
> > Can Linux align with Windows?
>
> Before deciding this, the power usage in the different states should be
> measured.

The power usage doesn't matter if the device can't function properly.

Kai-Heng

>
>
> Kind regards,
>
> Paul

