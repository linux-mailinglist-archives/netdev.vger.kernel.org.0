Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AAC527E331
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 10:01:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728423AbgI3IBp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 04:01:45 -0400
Received: from z5.mailgun.us ([104.130.96.5]:11492 "EHLO z5.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728321AbgI3IBm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 04:01:42 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1601452902; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=tlskTQ+EyYvIXFMiKIZ4RubO/8MhQ+hgxykvwjXt5W0=; b=BqSh27stKZXW0oYyxesuvNRFaQqIIf6bBxRNMoEx8owjS3QgidY9hPSFgleFhci25vxSnjUo
 T4GMgp6hYqG7TpBK2br3RY/x+NOgrKEohM6x7VqlMNpGQo4rZPoWa8KYV5hQ4K842XShvjET
 12NtLXslirpmBbEH9dwi1qse7J4=
X-Mailgun-Sending-Ip: 104.130.96.5
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-west-2.postgun.com with SMTP id
 5f743b5c767da8a9bbc7b2fa (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 30 Sep 2020 08:01:32
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 79705C433F1; Wed, 30 Sep 2020 08:01:32 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B9F2AC433CA;
        Wed, 30 Sep 2020 08:01:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B9F2AC433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Srinivasan Raju <srini.raju@purelifi.com>,
        mostafa.afgani@purelifi.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Rob Herring <robh@kernel.org>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] [v2] wireless: Initial driver submission for pureLiFi devices
References: <20200924151910.21693-1-srini.raju@purelifi.com>
        <20200928102008.32568-1-srini.raju@purelifi.com>
        <20200930051602.GJ3094@unreal>
Date:   Wed, 30 Sep 2020 11:01:27 +0300
In-Reply-To: <20200930051602.GJ3094@unreal> (Leon Romanovsky's message of
        "Wed, 30 Sep 2020 08:16:02 +0300")
Message-ID: <87d023elrc.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Leon Romanovsky <leon@kernel.org> writes:

>> diff --git a/drivers/net/wireless/purelifi/Kconfig
> b/drivers/net/wireless/purelifi/Kconfig
>> new file mode 100644
>> index 000000000000..ff05eaf0a8d4
>> --- /dev/null
>> +++ b/drivers/net/wireless/purelifi/Kconfig
>> @@ -0,0 +1,38 @@
>> +# SPDX-License-Identifier: GPL-2.0
>> +config WLAN_VENDOR_PURELIFI
>> +	bool "pureLiFi devices"
>> +	default y
>
> "N" is preferred default.

In most cases that's true, but for WLAN_VENDOR_ configs 'default y'
should be used. It's the same as with NET_VENDOR_.


-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
