Return-Path: <netdev+bounces-40-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 170106F4DAF
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 01:38:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 574EC1C209C8
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 23:38:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 954E0BA2D;
	Tue,  2 May 2023 23:38:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88E69947F
	for <netdev@vger.kernel.org>; Tue,  2 May 2023 23:38:08 +0000 (UTC)
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1C4F3591;
	Tue,  2 May 2023 16:38:06 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id 2adb3069b0e04-4f00d41df22so722671e87.1;
        Tue, 02 May 2023 16:38:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683070685; x=1685662685;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6OQxInFdspH8goMZiAQFIMKvayrdCwcSWW5RpkKMAVs=;
        b=rxwYpimfPHfiaLUYvMZSGzeu4lLfKnxa5lLprs1ayA/SCOBpxHk76Z9C11I8IEn3dk
         bvKtFzBQjuaO7sSg7VoB/a66Yx4qUm7oNzsQZg+NYWiHvaWHJzELhwr8BjrxRDuQYS5s
         3vyaGyN4Cs+yK1CHUTrjIbxgiQKJuWLU9SLTAcYz7AESzItR112/2AAGDOxZkjLt+O1p
         QYs0Y+oemevj0PRP29NY3VH7oUI25qZHohWrIHDxASGXkng+oLUCTGSksk6HINPZFBg8
         PdWRd9bakYmdTgmieZUgVFLievAojX48jBlp21kqCQ6tAFERmuvgNGt/+57haHzg9mJ0
         J+dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683070685; x=1685662685;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6OQxInFdspH8goMZiAQFIMKvayrdCwcSWW5RpkKMAVs=;
        b=S9knXRWL64xvtEmtjf12waDRPwOCTmfoiFZkJwmurL6pdr1SM2Xsm+lsx1/eu1veIl
         liWa2ieaCUJUosXPsgDmWydWCJHcpTcqAczyjk38M7nSfddWymLrc0onF+oPwTG1k5sH
         Wv1kA8G5IE/BpCKti2g3hQRewtwKkHcuxz8G4/x707/kwoJrHk0/gIGuLigx2IQX1Wda
         PTkNplfkUd1S28qyLztEe1pZLiJId3vny3+xMkUjxjz2CdtQ11DUk8QhFys1HF1zai5H
         m/ntE/OOEMJm/HuaOb5c1RApeTzM4w2qMXJCcLdv6t92YZOs92jrmdpc+Wacm0grFWe6
         OpFg==
X-Gm-Message-State: AC+VfDx/PQPZrQdK/L6JbzcKq1sbABQsfVMpyhI5hB9laajdaPjZm/6O
	dodklSFPRKYheJ2yiAaQQryCluRfLGi6bcPCs/Q=
X-Google-Smtp-Source: ACHHUZ4Su0H7dh/63X/8lI+nOZziTVVMVxrq4qKi72IDv95LwiyE0a3aXRPOPr3H8pU/DCEKRH1kU/UtdNkbvhmMJNw=
X-Received: by 2002:a05:6512:3f1c:b0:4ec:9d13:9d09 with SMTP id
 y28-20020a0565123f1c00b004ec9d139d09mr51247lfa.34.1683070684774; Tue, 02 May
 2023 16:38:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230424124852.12625-1-johan+linaro@kernel.org> <20230424124852.12625-2-johan+linaro@kernel.org>
In-Reply-To: <20230424124852.12625-2-johan+linaro@kernel.org>
From: Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date: Tue, 2 May 2023 16:37:51 -0700
Message-ID: <CABBYNZLBQjWVb=z8mffi4RmeKS-+RDLV+XF8bR2MiJ-ZOaFVHA@mail.gmail.com>
Subject: Re: [PATCH 1/2] Bluetooth: fix debugfs registration
To: Johan Hovold <johan+linaro@kernel.org>
Cc: Marcel Holtmann <marcel@holtmann.org>, Johan Hedberg <johan.hedberg@gmail.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, linux-bluetooth@vger.kernel.org, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Johan,

On Mon, Apr 24, 2023 at 5:50=E2=80=AFAM Johan Hovold <johan+linaro@kernel.o=
rg> wrote:
>
> Since commit ec6cef9cd98d ("Bluetooth: Fix SMP channel registration for
> unconfigured controllers") the debugfs interface for unconfigured
> controllers will be created when the controller is configured.
>
> There is however currently nothing preventing a controller from being
> configured multiple time (e.g. setting the device address using btmgmt)
> which results in failed attempts to register the already registered
> debugfs entries:
>
>         debugfs: File 'features' in directory 'hci0' already present!
>         debugfs: File 'manufacturer' in directory 'hci0' already present!
>         debugfs: File 'hci_version' in directory 'hci0' already present!
>         ...
>         debugfs: File 'quirk_simultaneous_discovery' in directory 'hci0' =
already present!
>
> Add a controller flag to avoid trying to register the debugfs interface
> more than once.
>
> Fixes: ec6cef9cd98d ("Bluetooth: Fix SMP channel registration for unconfi=
gured controllers")
> Cc: stable@vger.kernel.org      # 4.0
> Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
> ---
>  include/net/bluetooth/hci.h | 1 +
>  net/bluetooth/hci_sync.c    | 3 +++
>  2 files changed, 4 insertions(+)
>
> diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
> index 400f8a7d0c3f..b8bca65bcd79 100644
> --- a/include/net/bluetooth/hci.h
> +++ b/include/net/bluetooth/hci.h
> @@ -335,6 +335,7 @@ enum {
>  enum {
>         HCI_SETUP,
>         HCI_CONFIG,
> +       HCI_DEBUGFS_CREATED,
>         HCI_AUTO_OFF,
>         HCI_RFKILLED,
>         HCI_MGMT,
> diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
> index 632be1267288..a8785126df75 100644
> --- a/net/bluetooth/hci_sync.c
> +++ b/net/bluetooth/hci_sync.c
> @@ -4501,6 +4501,9 @@ static int hci_init_sync(struct hci_dev *hdev)
>             !hci_dev_test_flag(hdev, HCI_CONFIG))
>                 return 0;
>
> +       if (hci_dev_test_and_set_flag(hdev, HCI_DEBUGFS_CREATED))
> +               return 0;

Can't we just use HCI_SETUP like we do with in create_basic:

    if (hci_dev_test_flag(hdev, HCI_SETUP))
        hci_debugfs_create_basic(hdev);

Actually we might as well move these checks directly inside the
hci_debugfs function to make sure these only take effect during the
setup/first init.

>         hci_debugfs_create_common(hdev);
>
>         if (lmp_bredr_capable(hdev))
> --
> 2.39.2
>


--=20
Luiz Augusto von Dentz

