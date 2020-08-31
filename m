Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8108B257AEF
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 15:56:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727824AbgHaN4Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 09:56:16 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:16472 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727066AbgHaN4N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 09:56:13 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1598882172; h=Content-Transfer-Encoding: Content-Type:
 MIME-Version: Message-ID: In-Reply-To: Date: References: Subject: Cc:
 To: From: Sender; bh=l4ktEq8o7WvDy0rk/XyMBx2xUqUH9rI3Uw2PKVTyEv8=; b=MCF3J+G1JND01Xp1rhd52teXi7wTm1Moh8d24de21jCgWBcEdSbE+t7TFEl+Exf2Z9Ya87KW
 FBqFtVSueYu0CzhdEx/kGdMBNHJ9FLmDweJyejBEc2iD/oAAASfpnXPqzxuofIqHthsZ6gNH
 ksapzB0IZj/TsyWoIsg7ahi6A5E=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-east-1.postgun.com with SMTP id
 5f4d017c73afa3417e6b8d0c (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 31 Aug 2020 13:56:12
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 76E16C433CA; Mon, 31 Aug 2020 13:56:11 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B9EE8C433CA;
        Mon, 31 Aug 2020 13:56:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B9EE8C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Christian Lamparter <chunkeey@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 08/30] net: wireless: ath: carl9170: Convert 'ar9170_qmap' to inline function
References: <20200814113933.1903438-1-lee.jones@linaro.org>
        <20200814113933.1903438-9-lee.jones@linaro.org>
        <20200827093351.GA1627017@dell> <5498132.V4cn31ggaO@debian64>
Date:   Mon, 31 Aug 2020 16:56:06 +0300
In-Reply-To: <5498132.V4cn31ggaO@debian64> (Christian Lamparter's message of
        "Fri, 28 Aug 2020 22:28:20 +0200")
Message-ID: <877dte7wcp.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christian Lamparter <chunkeey@gmail.com> writes:

> On Thursday, 27 August 2020 11:33:51 CEST Lee Jones wrote:
>> 'ar9170_qmap' is used in some source files which include carl9170.h,
>> but not all of them.  A 'defined but not used' warning is thrown when
>> compiling the ones which do not use it.
>>=20
>> Fixes the following W=3D1 kernel build warning(s)
>>=20
>>  from drivers/net/wireless/ath/carl9170/carl9170.h:57,
>>  In file included from drivers/net/wireless/ath/carl9170/carl9170.h:57,
>>  drivers/net/wireless/ath/carl9170/carl9170.h:71:17: warning:
>> =E2=80=98ar9170_qmap=E2=80=99 defined but not used [-Wunused-const-varia=
ble=3D]
>>=20
>>  NB: Snipped - lots of these repeat
>>=20
>> Cc: Christian Lamparter <chunkeey@googlemail.com>
>> Cc: Kalle Valo <kvalo@codeaurora.org>
>> Cc: "David S. Miller" <davem@davemloft.net>
>> Cc: Jakub Kicinski <kuba@kernel.org>
>> Cc: Johannes Berg <johannes@sipsolutions.net>
>> Cc: linux-wireless@vger.kernel.org
>> Cc: netdev@vger.kernel.org
>> Suggested-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
>> Signed-off-by: Lee Jones <lee.jones@linaro.org>
>> ---
>
> For what it's worth:
> Acked-by: Christian Lamparter <chunkeey@gmail.com>

BTW for me Acked-by tags from the maintainer are very useful. Patchwork
even collects them automatically and shows the statistics so I can
quickly see what patches are ready to be applied. So please do send them
if you can :)

--=20
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
