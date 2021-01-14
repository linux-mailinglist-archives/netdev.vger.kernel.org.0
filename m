Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1303F2F5F26
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 11:46:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728563AbhANKpF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 05:45:05 -0500
Received: from so254-31.mailgun.net ([198.61.254.31]:16003 "EHLO
        so254-31.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728623AbhANKpE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 05:45:04 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1610621085; h=Content-Transfer-Encoding: Content-Type:
 MIME-Version: Message-ID: In-Reply-To: Date: References: Subject: Cc:
 To: From: Sender; bh=OjjfXZal6B47GNRAOFXmbhnpHD2u3Oq2qC6Px4eVK1Q=; b=XUALIEs8n4JHSqxkRQi+yQFbBIEMEafKEDnWY6djppdkJzR9Kz4sRw3LTlu+6J00drfs7ZPT
 fnzckf4eJ6vuy6NTWPhP32GljSLxyX1DoKrKrs79t81IQp6Q21nRx3QEp6o4RAkvuPGq5+AT
 oHcL4HLt8vAJjkRPU14Z1japAWU=
X-Mailgun-Sending-Ip: 198.61.254.31
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n09.prod.us-east-1.postgun.com with SMTP id
 600020978fb3cda82f3ce0c7 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 14 Jan 2021 10:44:39
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 47896C43464; Thu, 14 Jan 2021 10:44:38 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E11AFC433CA;
        Thu, 14 Jan 2021 10:44:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org E11AFC433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Petr =?utf-8?Q?=C5=A0tetiar?= <ynezz@true.cz>
Cc:     Arnd Bergmann <arnd@kernel.org>, Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Ryder Lee <ryder.lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Shayne Chen <shayne.chen@mediatek.com>,
        Yiwei Chung <yiwei.chung@mediatek.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mt76: mt7915: fix misplaced #ifdef
References: <20210103135811.3749775-1-arnd@kernel.org>
        <20210106135801.GA27377@meh.true.cz>
Date:   Thu, 14 Jan 2021 12:44:31 +0200
In-Reply-To: <20210106135801.GA27377@meh.true.cz> ("Petr \=\?utf-8\?Q\?\=C5\=A0t\?\=
 \=\?utf-8\?Q\?etiar\=22's\?\= message of
        "Wed, 6 Jan 2021 14:58:01 +0100")
Message-ID: <87r1mnhk6o.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Petr =C5=A0tetiar <ynezz@true.cz> writes:

> Arnd Bergmann <arnd@kernel.org> [2021-01-03 14:57:55]:
>
> Hi,
>
> just a small nitpick,
>
>> From: Arnd Bergmann <arnd@arndb.de>
>>=20
>> The lone '|' at the end of a line causes a build failure:
>>=20
>> drivers/net/wireless/mediatek/mt76/mt7915/init.c:47:2: error:
>> expected expression before '}' token
>>=20
>> Replace the #ifdef with an equivalent IS_ENABLED() check.
>>=20
>> Fixes: af901eb4ab80 ("mt76: mt7915: get rid of dbdc debugfs knob")
>
> I think, that the correct fixes tag is following:
>
>  Fixes: 8aa2c6f4714e ("mt76: mt7915: support 32 station interfaces")
>
> I've used the af901eb4ab80 as well first in
> https://github.com/openwrt/mt76/pull/490 but then looked at it once more =
and
> actually found the probably correct 8aa2c6f4714e.

Ok, I'll change that during commit.

Felix, I'm planning to apply this to wireless-drivers and assigned this
to me in patchwork.

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
