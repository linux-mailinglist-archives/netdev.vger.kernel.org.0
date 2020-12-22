Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 392E02E0CE3
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 16:46:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727749AbgLVPpE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 10:45:04 -0500
Received: from so254-31.mailgun.net ([198.61.254.31]:31565 "EHLO
        so254-31.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727621AbgLVPpE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Dec 2020 10:45:04 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1608651880; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=V3is/KP9X3iODvQMYSfeCfbe4PwUmMc4FyAr6uEgGbc=; b=rYwX2QVCsBhZgg2K4ovCC9pAzCIT8OxGcYh5lQxVaD0zkqCCmsf0Z2YmpE/HI5xvUGIP/sMh
 pC/g5ZzLGt2j/b7+tligsQPXtqW93D+xb3jIJGbpzywG6rDSyKa7bJFq+jd4ivOQ/69mAWLO
 lxP81y9ukJS/WsVkPsSkbSgryg4=
X-Mailgun-Sending-Ip: 198.61.254.31
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-east-1.postgun.com with SMTP id
 5fe2144cb00c0d7ad4391caf (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 22 Dec 2020 15:44:12
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 88A61C43466; Tue, 22 Dec 2020 15:44:11 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from x230.qca.qualcomm.com (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id DEE1FC433C6;
        Tue, 22 Dec 2020 15:44:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org DEE1FC433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
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
Subject: Re: [PATCH v3 05/24] wfx: add main.c/main.h
References: <20201104155207.128076-1-Jerome.Pouiller@silabs.com>
        <20201104155207.128076-6-Jerome.Pouiller@silabs.com>
Date:   Tue, 22 Dec 2020 17:44:05 +0200
In-Reply-To: <20201104155207.128076-6-Jerome.Pouiller@silabs.com> (Jerome
        Pouiller's message of "Wed, 4 Nov 2020 16:51:48 +0100")
Message-ID: <87a6u57smy.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jerome Pouiller <Jerome.Pouiller@silabs.com> writes:

> +/* NOTE: wfx_send_pds() destroy buf */
> +int wfx_send_pds(struct wfx_dev *wdev, u8 *buf, size_t len)
> +{
> +	int ret;
> +	int start, brace_level, i;
> +
> +	start = 0;
> +	brace_level = 0;
> +	if (buf[0] != '{') {
> + dev_err(wdev->dev, "valid PDS start with '{'. Did you forget to
> compress it?\n");
> +		return -EINVAL;
> +	}
> +	for (i = 1; i < len - 1; i++) {
> +		if (buf[i] == '{')
> +			brace_level++;
> +		if (buf[i] == '}')
> +			brace_level--;
> +		if (buf[i] == '}' && !brace_level) {
> +			i++;
> +			if (i - start + 1 > WFX_PDS_MAX_SIZE)
> +				return -EFBIG;
> +			buf[start] = '{';
> +			buf[i] = 0;
> +			dev_dbg(wdev->dev, "send PDS '%s}'\n", buf + start);
> +			buf[i] = '}';
> +			ret = hif_configuration(wdev, buf + start,
> +						i - start + 1);
> +			if (ret > 0) {
> + dev_err(wdev->dev, "PDS bytes %d to %d: invalid data (unsupported
> options?)\n",
> +					start, i);
> +				return -EINVAL;
> +			}
> +			if (ret == -ETIMEDOUT) {
> + dev_err(wdev->dev, "PDS bytes %d to %d: chip didn't reply (corrupted
> file?)\n",
> +					start, i);
> +				return ret;
> +			}
> +			if (ret) {
> + dev_err(wdev->dev, "PDS bytes %d to %d: chip returned an unknown
> error\n",
> +					start, i);
> +				return -EIO;
> +			}
> +			buf[i] = ',';
> +			start = i;
> +		}
> +	}
> +	return 0;
> +}

What does this function do? Looks very strange.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
