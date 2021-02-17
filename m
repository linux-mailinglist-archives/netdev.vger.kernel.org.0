Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C881731D775
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 11:21:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232331AbhBQKVD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 05:21:03 -0500
Received: from m42-2.mailgun.net ([69.72.42.2]:18768 "EHLO m42-2.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229767AbhBQKUZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Feb 2021 05:20:25 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1613557201; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=xBjCJOudzj2V+2ThwO+IgdmM8L5gUNhT/itjqSi1NVQ=; b=YlRHX2SD6aYKU9u05HGrEc8rYBJ7xK4BQ6rT6nlixQNSYgewO4Z/7zlmEDms7iU35ORtKXeH
 qxQIdR1IaNAQI/36W8BGZbVXNdRLtyI6+I2hWqF9ueffOuDkC7ig+3mtjFdxgy9kMpLiPblE
 bT9GkQvMGhu+NN227uX/cLsdF80=
X-Mailgun-Sending-Ip: 69.72.42.2
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-east-1.postgun.com with SMTP id
 602cedb3d2def62f1ede7407 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 17 Feb 2021 10:19:31
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 58457C43461; Wed, 17 Feb 2021 10:19:30 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 13DE3C433CA;
        Wed, 17 Feb 2021 10:19:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 13DE3C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Srinivasan Raju <srini.raju@purelifi.com>
Cc:     mostafa.afgani@purelifi.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-kernel@vger.kernel.org (open list),
        linux-wireless@vger.kernel.org (open list:NETWORKING DRIVERS (WIRELESS)),
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS)
Subject: Re: [PATCH] [v13] wireless: Initial driver submission for pureLiFi STA devices
References: <20200928102008.32568-1-srini.raju@purelifi.com>
        <20210212115030.124490-1-srini.raju@purelifi.com>
Date:   Wed, 17 Feb 2021 12:19:25 +0200
In-Reply-To: <20210212115030.124490-1-srini.raju@purelifi.com> (Srinivasan
        Raju's message of "Fri, 12 Feb 2021 17:19:39 +0530")
Message-ID: <87im6rov2q.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Srinivasan Raju <srini.raju@purelifi.com> writes:

> This introduces the pureLiFi LiFi driver for LiFi-X, LiFi-XC
> and LiFi-XL USB devices.
>
> This driver implementation has been based on the zd1211rw driver.
>
> Driver is based on 802.11 softMAC Architecture and uses
> native 802.11 for configuration and management.
>
> The driver is compiled and tested in ARM, x86 architectures and
> compiled in powerpc architecture.
>
> Signed-off-by: Srinivasan Raju <srini.raju@purelifi.com>

[...]

> +	if ((le16_to_cpu(udev->descriptor.idVendor) ==
> +				PURELIFI_X_VENDOR_ID_0) &&
> +	    (le16_to_cpu(udev->descriptor.idProduct) ==
> +				PURELIFI_X_PRODUCT_ID_0)) {
> +		fw_name = "plfxlc/LiFi-X.bin";
> +		dev_dbg(&intf->dev, "bin file for X selected\n");
> +
> +	} else if ((le16_to_cpu(udev->descriptor.idVendor)) ==
> +					PURELIFI_XC_VENDOR_ID_0 &&
> +		   (le16_to_cpu(udev->descriptor.idProduct) ==
> +					PURELIFI_XC_PRODUCT_ID_0)) {
> +		fw_name = "plfxlc/LiFi-XC.bin";
> +		dev_dbg(&intf->dev, "bin file for XC selected\n");
> +
> +	} else {
> +		r = -EINVAL;
> +		goto error;
> +	}
> +
> +	r = request_firmware((const struct firmware **)&fw, fw_name,
> +			     &intf->dev);
> +	if (r) {
> +		dev_err(&intf->dev, "request_firmware failed (%d)\n", r);
> +		goto error;
> +	}

[...]

> +	/* Code for single pack file download */
> +
> +	fw_pack = "plfxlc/LiFi-XL.bin";
> +
> +	r = request_firmware((const struct firmware **)&fw_packed, fw_pack,
> +			     &intf->dev);
> +	if (r) {
> +		dev_err(&intf->dev, "request_firmware failed (%d)\n", r);
> +		goto error;
> +	}

Having the firmware files under plfxlc/ directory looks good to me. But
I'm not really a fan of upper case filenames, is there a reason for
that? I would prefer have all lowercase filenames.

Also the cast (const struct firmware **) looks very wrong, but I didn't
investigate why you do it. I'm sure there is a proper way to implement
whatever you need here, without the cast.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
