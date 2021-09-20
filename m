Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0350411543
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 15:05:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239132AbhITNHD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 09:07:03 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:47722 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239147AbhITNGu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Sep 2021 09:06:50 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1632143124; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=rYP9XQ7w+We4iygmsl6D0285+JXJr7eMTLl25yCtN+Q=; b=orxv/jfiHEXS4VoKH8HQt+l+LC3rqbWwSPEoCU8NqSgZzcMmjXK9vtnLNf3dQCGrKdbyCVkQ
 1r3XNPSPA2RXU4jbYjh0Z7IINyVKHDIEIeUcBKq0YP3pfBV4lGdH63x3oa6Ibxyo40Xs/Deu
 RwpyQdgIyGkG4EN4ncEuU0LMW48=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-east-1.postgun.com with SMTP id
 61488708bd6681d8edfb0eb6 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 20 Sep 2021 13:05:12
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 82EB8C43616; Mon, 20 Sep 2021 13:05:11 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from tykki (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0B6FBC4338F;
        Mon, 20 Sep 2021 13:05:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 0B6FBC4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Srinivasan Raju <srini.raju@purelifi.com>
Cc:     mostafa.afgani@purelifi.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-kernel@vger.kernel.org (open list),
        linux-wireless@vger.kernel.org (open list:NETWORKING DRIVERS (WIRELESS)),
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS)
Subject: Re: [PATCH] [v15] wireless: Initial driver submission for pureLiFi STA devices
References: <20210226130810.119216-1-srini.raju@purelifi.com>
        <20210818141343.7833-1-srini.raju@purelifi.com>
Date:   Mon, 20 Sep 2021 16:05:03 +0300
In-Reply-To: <20210818141343.7833-1-srini.raju@purelifi.com> (Srinivasan
        Raju's message of "Wed, 18 Aug 2021 15:13:00 +0100")
Message-ID: <87o88nwg74.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

(big picture comments first)

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

You should describe in the commit log what LiFi means, not everyone know
the term and might mistake this as a regular Wi-Fi device (which it's
not).

> +	hw->wiphy->bands[NL80211_BAND_2GHZ] = &mac->band;

Johannes comment about piggy-backing NL80211_BAND_2GHZ is not yet addressed:

https://patchwork.kernel.org/project/linux-wireless/patch/20210212115030.124490-1-srini.raju@purelifi.com/

I agree with Johannes, a Li-Fi driver should not claim to be a regular
2.4 GHz Wi-Fi device.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
