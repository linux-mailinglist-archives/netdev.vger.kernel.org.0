Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03F043F993B
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 14:53:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245147AbhH0MyM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 08:54:12 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:60888 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231627AbhH0MyL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Aug 2021 08:54:11 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1630068803; h=Content-Transfer-Encoding: Content-Type:
 MIME-Version: Message-ID: In-Reply-To: Date: References: Subject: Cc:
 To: From: Sender; bh=023YrzZ8LpsSoMj53i6JFFETaout/dUogNgKAIVS0TE=; b=BBMjHAYoZ3BqvPk/vd/jf7dBBRc9J2mZ0CPdHS/kO7ENtWq9UHPNrqFTmNV1iimdFdVBtz7c
 V+eKerNwcZevkuJUVNgMKKO7QEO/CnzhTTiSRrgpah5lM4F4PFGQ+s6wWdyHU2ASudowK/NI
 7/mEzxan19/JwPOt7rcRFhEZx0k=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-east-1.postgun.com with SMTP id
 6128e039e0fcecca1941bc06 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 27 Aug 2021 12:53:13
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id EF854C43618; Fri, 27 Aug 2021 12:53:11 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from tykki (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D9B0AC43460;
        Fri, 27 Aug 2021 12:53:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org D9B0AC43460
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Stephan Gerhold <stephan@gerhold.net>,
        Bryan O'Donoghue <bryan.odonoghue@linaro.org>,
        =?utf-8?B?QW7DrWJhbCBM?= =?utf-8?B?aW3Ds24=?= 
        <anibal.limon@linaro.org>
Subject: Re: [RESEND PATCH] wcn36xx: Allow firmware name to be overridden by DT
References: <20210824171225.686683-1-bjorn.andersson@linaro.org>
Date:   Fri, 27 Aug 2021 15:53:04 +0300
In-Reply-To: <20210824171225.686683-1-bjorn.andersson@linaro.org> (Bjorn
        Andersson's message of "Tue, 24 Aug 2021 10:12:25 -0700")
Message-ID: <87fsuv59sf.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bjorn Andersson <bjorn.andersson@linaro.org> writes:

> The WLAN NV firmware blob differs between platforms, and possibly
> devices, so add support in the wcn36xx driver for reading the path of
> this file from DT in order to allow these files to live in a generic
> file system (or linux-firmware).
>
> For some reason the parent (wcnss_ctrl) also needs to upload this blob,
> so rather than specifying the same information in both nodes wcn36xx
> reads the string from the parent's of_node.
>
> Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> Tested-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
> Tested-by: An=C3=ADbal Lim=C3=B3n <anibal.limon@linaro.org>

[...]

> --- a/drivers/net/wireless/ath/wcn36xx/main.c
> +++ b/drivers/net/wireless/ath/wcn36xx/main.c
> @@ -1500,6 +1500,13 @@ static int wcn36xx_probe(struct platform_device *p=
dev)
>  		goto out_wq;
>  	}
>=20=20
> +	wcn->nv_file =3D WLAN_NV_FILE;
> +	ret =3D of_property_read_string(wcn->dev->parent->of_node, "firmware-na=
me", &wcn->nv_file);
> +	if (ret < 0 && ret !=3D -EINVAL) {
> +		wcn36xx_err("failed to read \"firmware-name\" property\n");

I included the value of ret to the error print to ease debugging.
Modified patch is soon in the pending branch, please take a look.

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
