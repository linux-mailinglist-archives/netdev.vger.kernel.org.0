Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1CE33AD816
	for <lists+netdev@lfdr.de>; Sat, 19 Jun 2021 08:27:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233118AbhFSG3z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Jun 2021 02:29:55 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:28703 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232206AbhFSG3x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Jun 2021 02:29:53 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1624084059; h=Content-Transfer-Encoding: Content-Type:
 MIME-Version: Message-ID: In-Reply-To: Date: References: Subject: Cc:
 To: From: Sender; bh=ReeHdDtZ1CGVXKaLf4XclDol0SUyu66O157eCXFCbig=; b=EqXe0fnU8UOq8QafoXMtwhVDPo+jhXzycMY+W8eiNKmjEr4Ivq8RQOGpgFxa7MMIP2VR5IBV
 2n4SE9sp8nDk4Kk3jADDYSVMo9NEcsT/Bnf73uF6odKrHrpiV9rKOV1KK9DKb/1V0Rbdqvo1
 uFw528SqEJqpCie+70Eov6GmPFU=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-east-1.postgun.com with SMTP id
 60cd8e42e27c0cc77fa6dbc5 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 19 Jun 2021 06:27:14
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 9E741C43460; Sat, 19 Jun 2021 06:27:13 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from tykki (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B6D88C433F1;
        Sat, 19 Jun 2021 06:27:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B6D88C433F1
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Dmitry Osipenko <digetx@gmail.com>
Cc:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Franky Lin <franky.lin@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Wright Feng <wright.feng@cypress.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH v2 1/2] cfg80211: Add wiphy_info_once()
References: <20210511211549.30571-1-digetx@gmail.com>
        <e7495304-d62c-fd20-fab3-3930735f2076@gmail.com>
Date:   Sat, 19 Jun 2021 09:27:06 +0300
In-Reply-To: <e7495304-d62c-fd20-fab3-3930735f2076@gmail.com> (Dmitry
        Osipenko's message of "Fri, 18 Jun 2021 23:44:50 +0300")
Message-ID: <87r1gyid39.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dmitry Osipenko <digetx@gmail.com> writes:

> 12.05.2021 00:15, Dmitry Osipenko =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
>> Add wiphy_info_once() helper that prints info message only once.
>>=20
>> Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
>> ---
>>=20
>> Changelog:
>>=20
>> v2: - New patch added in v2.
>>=20
>>  include/net/cfg80211.h | 2 ++
>>  1 file changed, 2 insertions(+)
>>=20
>> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
>> index 5224f885a99a..3b19e03509b3 100644
>> --- a/include/net/cfg80211.h
>> +++ b/include/net/cfg80211.h
>> @@ -8154,6 +8154,8 @@ bool cfg80211_iftype_allowed(struct wiphy *wiphy, =
enum nl80211_iftype iftype,
>>  	dev_notice(&(wiphy)->dev, format, ##args)
>>  #define wiphy_info(wiphy, format, args...)			\
>>  	dev_info(&(wiphy)->dev, format, ##args)
>> +#define wiphy_info_once(wiphy, format, args...)			\
>> +	dev_info_once(&(wiphy)->dev, format, ##args)
>>=20=20
>>  #define wiphy_err_ratelimited(wiphy, format, args...)		\
>>  	dev_err_ratelimited(&(wiphy)->dev, format, ##args)
>>=20
>
> Ping?
>
> Arend, is this series good to you? I assume Kalle could pick it up if
> you'll give ack. Thanks in advance.

Normally cfg80211 changes go via Johannes' tree though I guess small
changes I could take it via my tree, but then I need an ack from
Johannes.

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
