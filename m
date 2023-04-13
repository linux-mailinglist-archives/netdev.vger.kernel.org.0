Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C5826E160F
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 22:47:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbjDMUrY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 16:47:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbjDMUrX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 16:47:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3C0983EA;
        Thu, 13 Apr 2023 13:47:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 365AE6154E;
        Thu, 13 Apr 2023 20:47:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E52BC433EF;
        Thu, 13 Apr 2023 20:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681418841;
        bh=eNkJ7JXtUjbJ08nvkPN/451rZa7srlocFwkzzV23g40=;
        h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
        b=EiYBlnUmkCU3fJzbH5GQaw3HV0PHs2jhP28bx0b7zcHWSyGzudZYiPdiwwmhwru+n
         Y2QzEGvgHZ35cRqmiDg0pFPpz2RYXcDGkOgk4EBdh5N6Vcw7xIipTV3Xyp7wdBor1x
         VGAqO3EYsCcaz7smLDkv1bQ3KZEpMeW8f00I+iHiCRlC2F31G0SA48eKgn4Al5Uz+7
         eAJ36kvRNY9E6BaKtzL5UANXigDVSYQLsyXBtu4h1t/Vz6LJCtwzgMdRG7Q3z5AAIA
         neYOAOcEcYmQii3l9HA3CrQXHIuJ1Lo7wCVBH+fGL43GXU+VLEVaTCWDXPOSld2sEz
         rL3fAZgPm0fng==
Message-ID: <a295939f0058373d1caf956749820c0d.sboyd@kernel.org>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230413191541.1073027-4-ahalaney@redhat.com>
References: <20230413191541.1073027-1-ahalaney@redhat.com> <20230413191541.1073027-4-ahalaney@redhat.com>
Subject: Re: [PATCH v5 3/3] arm64: dts: qcom: sa8540p-ride: Add ethernet nodes
From:   Stephen Boyd <sboyd@kernel.org>
Cc:     agross@kernel.org, andersson@kernel.org, konrad.dybcio@linaro.org,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        mturquette@baylibre.com, richardcochran@gmail.com,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-clk@vger.kernel.org, netdev@vger.kernel.org,
        bmasney@redhat.com, echanude@redhat.com, ncai@quicinc.com,
        jsuraj@qti.qualcomm.com, hisunil@quicinc.com,
        Andrew Halaney <ahalaney@redhat.com>
To:     Andrew Halaney <ahalaney@redhat.com>, linux-kernel@vger.kernel.org
Date:   Thu, 13 Apr 2023 13:47:19 -0700
User-Agent: alot/0.10
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting Andrew Halaney (2023-04-13 12:15:41)
>  arch/arm64/boot/dts/qcom/sa8540p-ride.dts | 179 ++++++++++++++++++++++
>  1 file changed, 179 insertions(+)
>=20
> diff --git a/arch/arm64/boot/dts/qcom/sa8540p-ride.dts b/arch/arm64/boot/=
dts/qcom/sa8540p-ride.dts
> index 40db5aa0803c..650cd54f418e 100644
> --- a/arch/arm64/boot/dts/qcom/sa8540p-ride.dts
> +++ b/arch/arm64/boot/dts/qcom/sa8540p-ride.dts
> @@ -28,6 +28,65 @@ aliases {
>         chosen {
>                 stdout-path =3D "serial0:115200n8";
>         };
> +
> +       mtl_rx_setup: rx-queues-config {

Is there a reason why this isn't a child of an ethernet node?

> +               snps,rx-queues-to-use =3D <1>;
> +               snps,rx-sched-sp;
> +
