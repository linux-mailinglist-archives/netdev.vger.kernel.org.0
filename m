Return-Path: <netdev+bounces-2288-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F33F700FFC
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 22:53:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EF2141C211C3
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 20:53:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D837C138F;
	Fri, 12 May 2023 20:53:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C60F963B3
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 20:53:45 +0000 (UTC)
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 938331FE5;
	Fri, 12 May 2023 13:53:42 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id 2adb3069b0e04-4f00d41df22so55366219e87.1;
        Fri, 12 May 2023 13:53:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683924821; x=1686516821;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dK9pTU3dCszxfhakIo6H9xZVLUDy3fIcZSz6A27TG8M=;
        b=FD/zAsysSg3L3OXq9M6zoEHXlfE7Zfisk0oebJg9PxeK9WD3m7uBHxhWl00zt77u+z
         0tUZ4noCfxhvkE0k3KBAqdr6hd/MIfK7l6RCJC5VXN0uA6dKVGWFLnIKdlHEpNsfYARY
         N5BPheqRnYf8SWrvmYRPSDLSWEVrx6KNGuVl0Sm7yzG5k+XyxctahUO6aWQyG6j3WcHL
         TjFAnpxP8mTK2AVe9C1aOf7iAXfQg9+e2lfBpBFMX1bD2A2DQAzihjZRhv1n+/q20MbV
         iQxoBV3Z5SgOkCWqzEhXleobkJpZw1Wxo2FgVZky9NuWoS5Sf6gx3O6rYux5izXhmZPy
         w9EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683924821; x=1686516821;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dK9pTU3dCszxfhakIo6H9xZVLUDy3fIcZSz6A27TG8M=;
        b=fRVTNlfiLiDtne+VJahvV2rIQ7nmma2LiYl5cTXIG22FRgxQ/IPx8hw23fLylYBS1l
         /GITN6Pus8wX1xGrB76kCqh4n/UB/fLzFWZlNOJ61wWJs8UxNTumf0swVVAlmV+BHFZi
         +/+GKzFEklpAFyo/oMjm4jsVT/wJa6UlHpkYnYf+yskTefnp6/g8wwzNuHi3z77Fx9R6
         lwpVqd2skXDq7Nm8uf4dcuw42K/OcIOdR8REumbWZwr0bHpEXtjcw9DwM7En3XjoC2ma
         dgvQ4TsJtPfrPbh3XsZIFpBe4riGuXSve7CsBEICJ/Xpw2aNuFs7VVIge72O2craF4C2
         CUMw==
X-Gm-Message-State: AC+VfDxUUvj234Hr65zNvhku1e6pctP9DyuQvzqMHCl1DlhYo1F/Dsai
	H942MTRdPnLc6R6GeX9cWTSuUTrR6EdghdvcQfk=
X-Google-Smtp-Source: ACHHUZ4QVh0Plexs1KGYcEgkQrE+RKTmMsf2h41mEIoiKb7iyK0IcQzM41HYhHzu7YrAE3Za0Omy3humMqCta3K95Ik=
X-Received: by 2002:a2e:9355:0:b0:293:4b60:419c with SMTP id
 m21-20020a2e9355000000b002934b60419cmr3647191ljh.18.1683924820549; Fri, 12
 May 2023 13:53:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230421-fp4-bluetooth-v2-0-3de840d5483e@fairphone.com>
In-Reply-To: <20230421-fp4-bluetooth-v2-0-3de840d5483e@fairphone.com>
From: Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date: Fri, 12 May 2023 13:53:28 -0700
Message-ID: <CABBYNZJPw=Oxi+J2oA=6aosEZjCBK=u=8HEJywzRJCCrmGnkGA@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] Add WCN3988 Bluetooth support for Fairphone 4
To: Luca Weiss <luca.weiss@fairphone.com>
Cc: "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Rob Herring <robh+dt@kernel.org>, 
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, Marcel Holtmann <marcel@holtmann.org>, 
	Johan Hedberg <johan.hedberg@gmail.com>, Andy Gross <agross@kernel.org>, 
	Bjorn Andersson <andersson@kernel.org>, Konrad Dybcio <konrad.dybcio@linaro.org>, 
	Conor Dooley <conor+dt@kernel.org>, ~postmarketos/upstreaming@lists.sr.ht, 
	phone-devel@vger.kernel.org, netdev@vger.kernel.org, 
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-bluetooth@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Luca,

On Fri, May 12, 2023 at 6:58=E2=80=AFAM Luca Weiss <luca.weiss@fairphone.co=
m> wrote:
>
> Add support in the btqca/hci_qca driver for the WCN3988 and add it to
> the sm7225 Fairphone 4 devicetree.
>
> Devicetree patches go via Qualcomm tree, the rest via their respective
> trees.

Just to be sure, patches 1-2 shall be applied to bluetooth-next the
remaining are going to be handled elsewhere?

> --
> Previously with the RFC version I've had problems before with Bluetooth
> scanning failing like the following:
>
>   [bluetooth]# scan on
>   Failed to start discovery: org.bluez.Error.InProgress
>
>   [  202.371374] Bluetooth: hci0: Opcode 0x200b failed: -16
>
> This appears to only happen with driver built-in (=3Dy) when the supporte=
d
> local commands list doesn't get updated in the Bluetooth core and
> use_ext_scan() returning false. I'll try to submit this separately since
> this now works well enough with =3Dm. But in both cases (=3Dy, =3Dm) it's
> behaving a bit weirdly before (re-)setting the MAC address with "sudo
> btmgmt public-addr fo:oo:ba:ar"
>
> Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
> ---
> Changes in v2:
> - Add pinctrl & 'tlmm 64' irq to uart node
> - Pick up tags
> - Link to v1: https://lore.kernel.org/r/20230421-fp4-bluetooth-v1-0-0430e=
3a7e0a2@fairphone.com
>
> ---
> Luca Weiss (4):
>       dt-bindings: net: qualcomm: Add WCN3988
>       Bluetooth: btqca: Add WCN3988 support
>       arm64: dts: qcom: sm6350: add uart1 node
>       arm64: dts: qcom: sm7225-fairphone-fp4: Add Bluetooth
>
>  .../bindings/net/bluetooth/qualcomm-bluetooth.yaml |   2 +
>  arch/arm64/boot/dts/qcom/sm6350.dtsi               |  63 +++++++++++++
>  arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts  | 103 +++++++++++++++=
++++++
>  drivers/bluetooth/btqca.c                          |  13 ++-
>  drivers/bluetooth/btqca.h                          |  12 ++-
>  drivers/bluetooth/hci_qca.c                        |  12 +++
>  6 files changed, 201 insertions(+), 4 deletions(-)
> ---
> base-commit: f2fe50eb7ca6b7bc6c63745f5c26f7c6022fcd4a
> change-id: 20230421-fp4-bluetooth-b36a0e87b9c8
>
> Best regards,
> --
> Luca Weiss <luca.weiss@fairphone.com>
>


--=20
Luiz Augusto von Dentz

