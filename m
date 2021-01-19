Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8376E2FB3C8
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 09:12:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731482AbhASIKs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 03:10:48 -0500
Received: from m42-8.mailgun.net ([69.72.42.8]:23918 "EHLO m42-8.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725983AbhASIK1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 03:10:27 -0500
X-Greylist: delayed 358 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Jan 2021 03:10:27 EST
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1611043799; h=Content-Transfer-Encoding: Content-Type:
 MIME-Version: Message-ID: In-Reply-To: Date: References: Subject: Cc:
 To: From: Sender; bh=G6CrMrwkBlH/hAife+o1/KscQx/5H1OEZNAP7AT9sBg=; b=QhCDmWVYdqEcxQh/So1peytCDrkb2p+t7kZh2hCawsJKgQ70ekNeuufzFvZaoweU8SK1UvtA
 EYpcXP+QbbVIxO6c6XhFjC575DQKf0L5j6bNp/t1XK+7MaaUQ/yxc83stY24qtiN92hUd3c6
 CcRYUNnr1WL8d8w1VNECvJMlJ98=
X-Mailgun-Sending-Ip: 69.72.42.8
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-west-2.postgun.com with SMTP id
 6006925d75e5c01cba0b46ae (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 19 Jan 2021 08:03:41
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id D376FC43463; Tue, 19 Jan 2021 08:03:41 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from x230.qca.qualcomm.com (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A6F62C433CA;
        Tue, 19 Jan 2021 08:03:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A6F62C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Pkshih <pkshih@realtek.com>
Cc:     "abaci-bugfix\@linux.alibaba.com" <abaci-bugfix@linux.alibaba.com>,
        "Larry.Finger\@lwfinger.net" <Larry.Finger@lwfinger.net>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "chiu\@endlessos.org" <chiu@endlessos.org>,
        "kuba\@kernel.org" <kuba@kernel.org>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem\@davemloft.net" <davem@davemloft.net>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] rtlwifi: rtl8192se: Simplify bool comparison.
References: <1611037955-105333-1-git-send-email-abaci-bugfix@linux.alibaba.com>
        <1611041680.9785.1.camel@realtek.com>
Date:   Tue, 19 Jan 2021 10:03:36 +0200
In-Reply-To: <1611041680.9785.1.camel@realtek.com> (pkshih@realtek.com's
        message of "Tue, 19 Jan 2021 07:35:19 +0000")
Message-ID: <87v9btqron.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pkshih <pkshih@realtek.com> writes:

> On Tue, 2021-01-19 at 14:32 +0800, Jiapeng Zhong wrote:
>> Fix the follow coccicheck warnings:
>>=20
>> ./drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c:2305:6-27:
>> WARNING: Comparison of 0/1 to bool variable.
>>=20
>> ./drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c:1376:5-26:
>> WARNING: Comparison of 0/1 to bool variable.
>>=20
>> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
>> Signed-off-by: Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
>> ---
>> Changes in v2:
>> =C2=A0 -Modified subject.
>>=20
>
> You forget to remove the period at the end of subject.
> i.e.
> "rtlwifi: rtl8192se: Simplify bool comparison"

I can fix that during commit.

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
