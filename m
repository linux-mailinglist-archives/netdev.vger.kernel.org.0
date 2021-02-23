Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C06B7322627
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 08:09:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231384AbhBWHJa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 02:09:30 -0500
Received: from z11.mailgun.us ([104.130.96.11]:32660 "EHLO z11.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229949AbhBWHJ1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Feb 2021 02:09:27 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1614064155; h=Content-Transfer-Encoding: Content-Type:
 MIME-Version: Message-ID: In-Reply-To: Date: References: Subject: Cc:
 To: From: Sender; bh=pTEQghgVkfDvWMsdEuAjG7tlCrXlwH0AYTvKRDuVXFI=; b=XudHFTjYm4lFfUON1N16QCD+H7916owXlXg8ekx9t1+5K1q+izM1gqv75FDz/N1sd3p0KhN3
 I6+ik9iMwSkcf6H3H/fL5j7T3rrPfLpOJcw2kKprA4h0d1fQ5twa8BWYQJcAT4AGIRf6/4XY
 mvJYaXjztt7Z8Fve61uptQdgl5A=
X-Mailgun-Sending-Ip: 104.130.96.11
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-west-2.postgun.com with SMTP id
 6034a9f9ba086638301f0699 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 23 Feb 2021 07:08:40
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id A2487C43464; Tue, 23 Feb 2021 07:08:40 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 037B3C433CA;
        Tue, 23 Feb 2021 07:08:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 037B3C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Pkshih <pkshih@realtek.com>
Cc:     "chenhaoa\@uniontech.com" <chenhaoa@uniontech.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tony0620emma\@gmail.com" <tony0620emma@gmail.com>,
        Timlee <timlee@realtek.com>,
        "zhanjun\@uniontech.com" <zhanjun@uniontech.com>,
        "kuba\@kernel.org" <kuba@kernel.org>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem\@davemloft.net" <davem@davemloft.net>,
        "arnd\@arndb.de" <arnd@arndb.de>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] rtw88: 8822ce: fix wifi disconnect after S3/S4 on HONOR laptop
References: <20210222094638.18392-1-chenhaoa@uniontech.com>
        <87h7m4iefe.fsf@codeaurora.org> <1613993809.2331.12.camel@realtek.com>
Date:   Tue, 23 Feb 2021 09:08:34 +0200
In-Reply-To: <1613993809.2331.12.camel@realtek.com> (pkshih@realtek.com's
        message of "Mon, 22 Feb 2021 11:36:51 +0000")
Message-ID: <878s7fi7m5.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pkshih <pkshih@realtek.com> writes:

>> > --- a/drivers/net/wireless/realtek/rtw88/rtw8822ce.c
>> > +++ b/drivers/net/wireless/realtek/rtw88/rtw8822ce.c
>> > @@ -25,7 +25,6 @@ static struct pci_driver rtw_8822ce_driver =3D {
>> >=C2=A0=C2=A0	.id_table =3D rtw_8822ce_id_table,
>> >=C2=A0=C2=A0	.probe =3D rtw_pci_probe,
>> >=C2=A0=C2=A0	.remove =3D rtw_pci_remove,
>> > -	.driver.pm =3D &rtw_pm_ops,
>>=20
>> Why just 8822ce? Why not remove rtw_pm_ops entirely if it just creates
>> problems?
>
> I think we can't remove rtw_pm_ops, because wowlan will not work.

Ah. A comment code in the code stating that would be nice.

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
