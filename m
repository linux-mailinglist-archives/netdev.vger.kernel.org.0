Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CA621E8543
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 19:40:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727930AbgE2RkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 13:40:23 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:52948 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727004AbgE2RkW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 13:40:22 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1590774021; h=Content-Transfer-Encoding: Content-Type:
 MIME-Version: Message-ID: In-Reply-To: Date: References: Subject: Cc:
 To: From: Sender; bh=kTdSjBnmUHE6a+/LCLe8XhWTibwfO24CX+6sF3cHX9U=; b=RpSpJ63K+IbyRxXrktWQOb+qiX6z5ECUd2Q5MxQya1BM7chzijuLNcBpTCWZ/qgk1roLxYsw
 QNNDRCuXw5kwZ12c5DmYEPy4KhQZIpKddX076CjbojVZCkSBgOTEGiDFwwgGwhczJTty9OBS
 69Qhr1D6su6xTNHoBjcGGO6pytU=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-west-2.postgun.com with SMTP id
 5ed146594776d1da6d03d724 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 29 May 2020 17:28:57
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 8389DC43395; Fri, 29 May 2020 17:28:57 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C47CAC433C9;
        Fri, 29 May 2020 17:28:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C47CAC433C9
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Pali =?utf-8?Q?Roh=C3=A1r?= <pali@kernel.org>
Cc:     Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Marek =?utf-8?Q?Beh=C3=BAn?= <marek.behun@nic.cz>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mwifiex: Add support for NL80211_ATTR_MAX_AP_ASSOC_STA
References: <20200521123559.29028-1-pali@kernel.org>
        <20200529171902.wwikyr4mmqin7ce2@pali>
Date:   Fri, 29 May 2020 20:28:52 +0300
In-Reply-To: <20200529171902.wwikyr4mmqin7ce2@pali> ("Pali \=\?utf-8\?Q\?Roh\?\=
 \=\?utf-8\?Q\?\=C3\=A1r\=22's\?\= message of
        "Fri, 29 May 2020 19:19:02 +0200")
Message-ID: <87blm6sl9n.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pali Roh=C3=A1r <pali@kernel.org> writes:

> On Thursday 21 May 2020 14:35:59 Pali Roh=C3=A1r wrote:
>> SD8997 firmware sends TLV_TYPE_MAX_CONN with struct hw_spec_max_conn to
>> inform kernel about maximum number of p2p connections and stations in AP
>> mode.
>>=20
>> During initialization of SD8997 wifi chip kernel prints warning:
>>=20
>>   mwifiex_sdio mmc0:0001:1: Unknown GET_HW_SPEC TLV type: 0x217
>>=20
>> This patch adds support for parsing TLV_TYPE_MAX_CONN (0x217) and sets
>> appropriate cfg80211 member 'max_ap_assoc_sta' from retrieved structure.
>>=20
>> It allows userspace to retrieve NL80211_ATTR_MAX_AP_ASSOC_STA attribute.
>>=20
>> Signed-off-by: Pali Roh=C3=A1r <pali@kernel.org>
>
> Hello Kalle and Ganapathi, could you please review this patch?

To reduce email please first check the status from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes#checking_state_of_patches_from_patchwork

--=20
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
