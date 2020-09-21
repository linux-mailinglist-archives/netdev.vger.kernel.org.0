Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4541F272596
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 15:32:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727301AbgIUNcA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 09:32:00 -0400
Received: from m42-4.mailgun.net ([69.72.42.4]:50730 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726436AbgIUNcA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Sep 2020 09:32:00 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1600695119; h=Content-Transfer-Encoding: Content-Type:
 MIME-Version: Message-ID: In-Reply-To: Date: References: Subject: Cc:
 To: From: Sender; bh=hfH7g19V4OeykMHRuFocSmUsqeHtErYNJtK0snxwKvA=; b=YHk8Pan3ULTrynGMO9l/cNL6c9igdwHS5scUnIIakUZ8T9qUdvFzn5v/eu2xaS7iAzukoNT+
 IS8ss9SYwrYaluUnwaNuAZlIA5kn5lxta9O2/MBK4oAMV6+rVw/kcCerIr9J16yC0NWgSSUI
 X9H/0mF9l8WG2ylq8RjLxPlV+eQ=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-west-2.postgun.com with SMTP id
 5f68ab414ab73023a7d50265 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 21 Sep 2020 13:31:45
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id F3D4EC433FE; Mon, 21 Sep 2020 13:31:44 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 22A68C433CB;
        Mon, 21 Sep 2020 13:31:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 22A68C433CB
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     <davem@davemloft.net>, <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, ath11k@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ath11k: Mark two variables as __maybe_unused
References: <20200901035603.25180-1-yuehaibing@huawei.com>
Date:   Mon, 21 Sep 2020 16:31:40 +0300
In-Reply-To: <20200901035603.25180-1-yuehaibing@huawei.com>
        (yuehaibing@huawei.com's message of "Tue, 1 Sep 2020 11:56:03 +0800")
Message-ID: <87zh5j45oj.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

YueHaibing <yuehaibing@huawei.com> writes:

> Fix -Wunused-variable warnings:
>
> drivers/net/wireless/ath/ath11k/debug.c:36:20: warning: =E2=80=98htt_bp_l=
mac_ring=E2=80=99 defined but not used [-Wunused-variable]
> drivers/net/wireless/ath/ath11k/debug.c:15:20: warning: =E2=80=98htt_bp_u=
mac_ring=E2=80=99 defined but not used [-Wunused-variable]
>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

I don't like __maybe_unused so I decided to fix this with some refactoring:

[1/4] ath11k: refactor debugfs code into debugfs.c
https://patchwork.kernel.org/patch/11781017/

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
