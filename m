Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6342B1E4263
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 14:34:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730025AbgE0Meu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 08:34:50 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:31342 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728143AbgE0Mes (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 May 2020 08:34:48 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1590582887; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=+mQNVzce+4+RLoIQRxILi9XM/m92f1kvOextGxb68/E=; b=Q4bDhs1ZaNLV4wvZzLGIeVd0/uaDwXXKkwtXUjhwK+yNdjcVm6YQ5RDIcr4a2sRDe1Xcp5Nv
 RDSvYUnCEvRG3WPGMaRz3CHMg9LaUdi8+9C9B0/8xovTrIprjNTe/VlB7MNO2iJtnWWHW1kN
 NS32XqZtfxuO4Og74RhTyQIpeqw=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-west-2.postgun.com with SMTP id
 5ece5e62b4f0a9ae220406ba (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 27 May 2020 12:34:42
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 52CF1C43391; Wed, 27 May 2020 12:34:42 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D435FC433C9;
        Wed, 27 May 2020 12:34:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org D435FC433C9
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Jerome Pouiller <Jerome.Pouiller@silabs.com>
Cc:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH 00/10] staging: wfx: introduce nl80211 vendor extensions
References: <20200526171821.934581-1-Jerome.Pouiller@silabs.com>
Date:   Wed, 27 May 2020 15:34:37 +0300
In-Reply-To: <20200526171821.934581-1-Jerome.Pouiller@silabs.com> (Jerome
        Pouiller's message of "Tue, 26 May 2020 19:18:11 +0200")
Message-ID: <87imghv9nm.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jerome Pouiller <Jerome.Pouiller@silabs.com> writes:

> This series introduces some nl80211 vendor extensions to the wfx driver.
>
> This series may lead to some discussions:
>
>   1. Patch 7 allows to change the dynamic PS timeout. I have found
>      an API in wext (cfg80211_wext_siwpower()) that do more or less the
>      same thing. However, I have not found any equivalent in nl80211. Is it
>      expected or this API should be ported to nl80211?

struct wireless_dev::ps_timeout doesn't work for you?

>
>   2. The device The device allows to do Packet Traffic Arbitration (PTA or
>      also Coex). This feature allows the device to communicate with another
>      RF device in order to share the access to the RF. The patch 9 provides
>      a way to configure that. However, I think that this chip is not the
>      only one to provide this feature. Maybe a standard way to change
>      these parameters should be provided?
>
>   3. For these vendor extensions, I have used the new policy introduced by
>      the commit 901bb989185516 ("nl80211: require and validate vendor
>      command policy"). However, it seems that my version of 'iw' is not
>      able to follow this new policy (it does not pack the netlink
>      attributes into a NLA_NESTED). I could develop a tool specifically for
>      that API, but it is not very handy. So, in patch 10, I have also
>      introduced an API for compatibility with iw. Any comments about this?

If you want the driver out of staging I recommend not adding any vendor
commands until the driver is moved to drivers/net/wireless. Also do note
that we have special rules for nl80211 vendor commands:

https://wireless.wiki.kernel.org/en/developers/documentation/nl80211#vendor-specific_api

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
