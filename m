Return-Path: <netdev+bounces-7235-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2560371F3CD
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 22:25:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A3F071C21118
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 20:24:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35F7F42519;
	Thu,  1 Jun 2023 20:24:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F6D423DF
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 20:24:58 +0000 (UTC)
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83E63E77;
	Thu,  1 Jun 2023 13:24:27 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id d9443c01a7336-1b02d0942caso7154285ad.1;
        Thu, 01 Jun 2023 13:24:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685651067; x=1688243067;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=jr4QoGMO1QTzHP9BeseO541cUPfP+RsuPOsza+Ci6zg=;
        b=dxhgsvLIy1s+XWMQCTe4+xlGB+vnb45lA6Lh/e+U/FPOFMSsIYKCAlmWKHZKA7o+ou
         xEdJ04wbVmkLV9mo8/IKkR9sGGVHQ/yYrheMbzknJhogN3Ld8SKhDk7g1Mc4HLpoXIJI
         huZVxAOXQ8yZkB5UTEIC/aSV86GrtltiamEuPf7ZrZTCLWyrTd/kXDDwSOpqFiOUHvuj
         bv+Smf92g/THGIV2uuKEIdAwkcH/C/9VQJ2msvWja1E2BT139RiUMFAbf0T25JEnAhE/
         /xwYwEqwGdieHB7zYcQHYH8UXIHJj4/7c1ooecRq3eOi9BkWY0+4JfxLSyp6P33DHXIo
         t/IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685651067; x=1688243067;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jr4QoGMO1QTzHP9BeseO541cUPfP+RsuPOsza+Ci6zg=;
        b=KIFM7kSt7IZ6sZtvPpYDsULHOV6/jPPNiJNU0yLsbk7VyAUI/zRzZsVq2CnzOjd/Xm
         5NVimHb2KtSEWnOuBF/RtyPILMd5zgl+bU7dxo3GCVPcjPwGNi0HfslVXIu0Vlr+LtrC
         RLM+JL+6u8NvtGCxkE08L+SZFcUuhyFOlaQmGCN84BFzRINPf7M8i65P2EWYyFB/Ef0Z
         EPKy2zbg4Tfs+Pwk6WsA/y5vgQcn7QzdYr8g77HAUcoOCOIWKh4nuoPPTSVkTCSw+Wvy
         4XoEP5HbpRTlK0xn1WRXLV9BL5o/T3vnjvEDL8vq/ZEEpe7HL1k00c/7p7u4EUCYc0I4
         oMlg==
X-Gm-Message-State: AC+VfDxKWCwfbTTm597tbWHX8MeUjQQ5bwLCcs2u2nawpFeGkE1SNJa+
	AgZn9fo3jPDVadbEPknopTI=
X-Google-Smtp-Source: ACHHUZ73Ubusk/S2VWgqOC4SdykzigIl9jroTRyTqEbZOYA6hn4V9gHTTznzcAG0r1MhWfSay382ug==
X-Received: by 2002:a17:903:2603:b0:1b1:bcc1:bcdb with SMTP id jd3-20020a170903260300b001b1bcc1bcdbmr23072plb.53.1685651066747;
        Thu, 01 Jun 2023 13:24:26 -0700 (PDT)
Received: from ?IPv6:2605:59c8:448:b800:82ee:73ff:fe41:9a02? ([2605:59c8:448:b800:82ee:73ff:fe41:9a02])
        by smtp.googlemail.com with ESMTPSA id t14-20020a1709028c8e00b001b052483e9csm3898254plo.231.2023.06.01.13.24.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jun 2023 13:24:26 -0700 (PDT)
Message-ID: <269262acfcce8eb1b85ee1fe3424a5ef2991f481.camel@gmail.com>
Subject: Re: [PATCH] e1000e: Use PME poll to circumvent unreliable ACPI wake
From: Alexander H Duyck <alexander.duyck@gmail.com>
To: Kai-Heng Feng <kai.heng.feng@canonical.com>, jesse.brandeburg@intel.com,
  anthony.l.nguyen@intel.com
Cc: linux-pm@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo
 Abeni <pabeni@redhat.com>,  intel-wired-lan@lists.osuosl.org,
 netdev@vger.kernel.org,  linux-kernel@vger.kernel.org
Date: Thu, 01 Jun 2023 13:24:24 -0700
In-Reply-To: <20230601162537.1163270-1-kai.heng.feng@canonical.com>
References: <20230601162537.1163270-1-kai.heng.feng@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-3.fc36) 
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, 2023-06-02 at 00:25 +0800, Kai-Heng Feng wrote:
> On some I219 devices, ethernet cable plugging detection only works once
> from PCI D3 state. Subsequent cable plugging does set PME bit correctly,
> but device still doesn't get woken up.

Do we have a root cause on why things don't get woken up? This seems
like an issue where something isn't getting reset after the first
wakeup and so future ones are blocked.

> Since I219 connects to the root complex directly, it relies on platform
> firmware (ACPI) to wake it up. In this case, the GPE from _PRW only
> works for first cable plugging but fails to notify the driver for
> subsequent plugging events.
>=20
> The issue was originally found on CNP, but the same issue can be found
> on ADL too. So workaround the issue by continuing use PME poll after
> first ACPI wake. As PME poll is always used, the runtime suspend
> restriction for CNP can also be removed.
>=20
> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> ---
>  drivers/net/ethernet/intel/e1000e/netdev.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/eth=
ernet/intel/e1000e/netdev.c
> index bd7ef59b1f2e..f0e48f2bc3a2 100644
> --- a/drivers/net/ethernet/intel/e1000e/netdev.c
> +++ b/drivers/net/ethernet/intel/e1000e/netdev.c
> @@ -7021,6 +7021,8 @@ static __maybe_unused int e1000e_pm_runtime_resume(=
struct device *dev)
>  	struct e1000_adapter *adapter =3D netdev_priv(netdev);
>  	int rc;
> =20
> +	pdev->pme_poll =3D true;
> +
>  	rc =3D __e1000_resume(pdev);
>  	if (rc)
>  		return rc;

Doesn't this enable this too broadly. I know there are a number of
devices that run under the e1000e and I would imagine that we don't
want them all running with "pme_poll =3D true" do we?

It seems like at a minimum we should only be setting this for specific
platofrms or devices instead of on all of them.

Also this seems like something we should be setting on the suspend side
since it seems to be clared in the wakeup calls.

Lastly I am not sure the first one is necessarily succeding. You might
want to check the status of pme_poll before you run your first test.
From what I can tell it looks like the initial state is true in
pci_pm_init. If so it might be getting cleared after the first wakeup
which is what causes your issues.

> @@ -7682,7 +7684,7 @@ static int e1000_probe(struct pci_dev *pdev, const =
struct pci_device_id *ent)
> =20
>  	dev_pm_set_driver_flags(&pdev->dev, DPM_FLAG_SMART_PREPARE);
> =20
> -	if (pci_dev_run_wake(pdev) && hw->mac.type !=3D e1000_pch_cnp)
> +	if (pci_dev_run_wake(pdev))
>  		pm_runtime_put_noidle(&pdev->dev);
> =20
>  	return 0;

I assume this is the original workaround that was put in to address
this issue. Perhaps you should add a Fixes tag to this to identify
which workaround this patch is meant to be replacing.

