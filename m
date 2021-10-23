Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2977D43822B
	for <lists+netdev@lfdr.de>; Sat, 23 Oct 2021 09:14:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbhJWHRK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Oct 2021 03:17:10 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:14899 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbhJWHRI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Oct 2021 03:17:08 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1634973290; h=Content-Transfer-Encoding: Content-Type:
 MIME-Version: Message-ID: In-Reply-To: Date: References: Subject: Cc:
 To: From: Sender; bh=mAuL/BSiQQczF13AmItJEQmcoPdP9iOgXP4EYSDbF6o=; b=Jfz/mv9ZgKHGBU/XX78B0wDb/5WNuLh4dXmLgnPdxIHtSST3H1PLmjbnHQ3AKnR2KnlgPEX+
 4kAuJiz5t3B334wZ49SJ3vijqUaU51N+BawPNNj/sHRD8xqWcdRqOcFnursw16iWWUBxkghL
 eDI89p4SZ9N8LLPqzMXGvHkaJQo=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-east-1.postgun.com with SMTP id
 6173b666e29a872c21cedb63 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 23 Oct 2021 07:14:46
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 0FF1FC4338F; Sat, 23 Oct 2021 07:14:46 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from tykki (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 13553C4338F;
        Sat, 23 Oct 2021 07:14:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 13553C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     netdev@vger.kernel.org, Sean Wang <sean.wang@mediatek.com>,
        linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Ryder Lee <ryder.lee@mediatek.com>
Subject: Re: [PATCH net] wireless: mediatek: mt7921: fix Wformat build warning
References: <20211022233251.29987-1-rdunlap@infradead.org>
Date:   Sat, 23 Oct 2021 10:14:40 +0300
In-Reply-To: <20211022233251.29987-1-rdunlap@infradead.org> (Randy Dunlap's
        message of "Fri, 22 Oct 2021 16:32:51 -0700")
Message-ID: <87pmrwdxgf.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Randy Dunlap <rdunlap@infradead.org> writes:

> ARRAY_SIZE() is of type size_t, so the format specfier should
> be %zu instead of %lu.
>
> Fixes this build warning:
>
> ../drivers/net/wireless/mediatek/mt76/mt7921/main.c: In function =E2=80=
=98mt7921_get_et_stats=E2=80=99:
> ../drivers/net/wireless/mediatek/mt76/mt7921/main.c:1024:26: warning: for=
mat =E2=80=98%lu=E2=80=99 expects argument of type =E2=80=98long unsigned i=
nt=E2=80=99, but argument 4 has type =E2=80=98unsigned int=E2=80=99 [-Wform=
at=3D]
>    dev_err(dev->mt76.dev, "ei: %d  SSTATS_LEN: %lu",
>
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Sean Wang <sean.wang@mediatek.com>
> Cc: linux-wireless@vger.kernel.org
> Cc: Felix Fietkau <nbd@nbd.name>
> Cc: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
> Cc: Ryder Lee <ryder.lee@mediatek.com>
> Cc: Kalle Valo <kvalo@codeaurora.org>

The subject prefix should be "mt76: mt7921:", I'll fix it during commit.

Felix, I'll take this directly to wireless-drivers-next. Please drop it
from your tree.

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
