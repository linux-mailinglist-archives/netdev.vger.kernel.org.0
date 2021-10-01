Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A78A241EAB8
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 12:10:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353439AbhJAKMD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 06:12:03 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:10363 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353273AbhJAKMB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 06:12:01 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1633083018; h=Content-Transfer-Encoding: Content-Type:
 MIME-Version: Message-ID: In-Reply-To: Date: References: Subject: Cc:
 To: From: Sender; bh=ZetgfVAwbJoN4AAZzEvqpEj2r1iuIB1GedGi9+QD1zc=; b=J+pZ7xDrLdY0NDgYzAI0lsR4rHSWoe7BW09qMe9TvGFV/p97/4x9LJAsMRQZ8Eka+lZX8K+8
 DxUdp7XskpDsxawPyeDuQ62hOPwkgeEuBPKxrAVkfH4UC/5twVn518dR0Zb5TXXkFYUSFCHu
 EvBuUSOpfx7CgtrOsC37SzT6QUg=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-west-2.postgun.com with SMTP id
 6156de72605ecf100b5be9e6 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 01 Oct 2021 10:09:54
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 9D619C4360D; Fri,  1 Oct 2021 10:09:54 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from tykki (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0E305C43460;
        Fri,  1 Oct 2021 10:09:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 0E305C43460
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Jerome Pouiller <Jerome.Pouiller@silabs.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        linux-mmc@vger.kernel.org,
        Pali =?utf-8?Q?Roh?= =?utf-8?Q?=C3=A1r?= <pali@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH v7 15/24] wfx: add hif_rx.c/hif_rx.h
References: <20210920161136.2398632-1-Jerome.Pouiller@silabs.com>
        <20210920161136.2398632-16-Jerome.Pouiller@silabs.com>
Date:   Fri, 01 Oct 2021 13:09:48 +0300
In-Reply-To: <20210920161136.2398632-16-Jerome.Pouiller@silabs.com> (Jerome
        Pouiller's message of "Mon, 20 Sep 2021 18:11:27 +0200")
Message-ID: <87a6jtkqdv.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jerome Pouiller <Jerome.Pouiller@silabs.com> writes:

> From: J=C3=A9r=C3=B4me Pouiller <jerome.pouiller@silabs.com>
>
> Signed-off-by: J=C3=A9r=C3=B4me Pouiller <jerome.pouiller@silabs.com>

[...]

> +static int hif_startup_indication(struct wfx_dev *wdev,
> +				  const struct hif_msg *hif, const void *buf)
> +{
> +	const struct hif_ind_startup *body =3D buf;
> +
> +	if (body->status || body->firmware_type > 4) {
> +		dev_err(wdev->dev, "received invalid startup indication");
> +		return -EINVAL;
> +	}
> +	memcpy(&wdev->hw_caps, body, sizeof(struct hif_ind_startup));
> +	le16_to_cpus((__le16 *)&wdev->hw_caps.hardware_id);
> +	le16_to_cpus((__le16 *)&wdev->hw_caps.num_inp_ch_bufs);
> +	le16_to_cpus((__le16 *)&wdev->hw_caps.size_inp_ch_buf);
> +	le32_to_cpus((__le32 *)&wdev->hw_caps.supported_rate_mask);

I don't really like the casts here, and not really reliable either if
there's ever more fields. I would just store values as little endian in
hw_caps, I doubt it's performance critical.

And why does struct hif_ind_startup use both u32 and __le32? If it's in
little endian it should always use __le types.

[...]

> +	if (hif_id & 0x80)
> +		dev_err(wdev->dev, "unsupported HIF indication: ID %02x\n",
> +			hif_id);
> +	else
> +		dev_err(wdev->dev, "unexpected HIF confirmation: ID %02x\n",
> +			hif_id);

No magic values, please. A proper define for bit 0x80 would be nice.

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
