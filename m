Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9DF8125157
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 20:08:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727454AbfLRTIy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 14:08:54 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:23818 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727031AbfLRTIy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 14:08:54 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1576696133; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=I7sr0p2h1GDESQSfvlGUoaTooHwZol4WaUIyco24ybA=;
 b=rGg3qKqGTlJcRiLxNbT1GXyImMTcIWbkS3IKv4kGUQKOZ7NUPTH+gci49WWR0PpRiF+euqzG
 N0aVAndL8tP115pbjKXf/Hs24uPztbl3pQDzPWBFwiBVEW/oeLwfE/WrXleRLDo9TdDUL+zt
 hbWaKD8741QaChDqacGogdP++kA=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5dfa7941.7f8b49369ce0-smtp-out-n01;
 Wed, 18 Dec 2019 19:08:49 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 7F5CBC4479C; Wed, 18 Dec 2019 19:08:48 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5E58FC433CB;
        Wed, 18 Dec 2019 19:08:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 5E58FC433CB
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] brcmfmac: Fix memory leak in brcmf_usbdev_qinit
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20191215015117.21801-1-navid.emamdoost@gmail.com>
References: <20191215015117.21801-1-navid.emamdoost@gmail.com>
To:     Navid Emamdoost <navid.emamdoost@gmail.com>
Cc:     Arend van Spriel <arend@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alwin Beukers <alwin@broadcom.com>,
        Pieter-Paul Giesberts <pieterpg@broadcom.com>,
        Kan Yan <kanyan@broadcom.com>,
        "Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
        Piotr Figiel <p.figiel@camlintechnologies.com>,
        =?utf-8?b?UmFmYcWCIE1pxYJl?==?utf-8?b?Y2tp?= <rafal@milecki.pl>,
        YueHaibing <yuehaibing@huawei.com>, Kangjie Lu <kjlu@umn.edu>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, emamd001@umn.edu,
        Navid Emamdoost <navid.emamdoost@gmail.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20191218190848.7F5CBC4479C@smtp.codeaurora.org>
Date:   Wed, 18 Dec 2019 19:08:48 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Navid Emamdoost <navid.emamdoost@gmail.com> wrote:

> In the implementation of brcmf_usbdev_qinit() the allocated memory for
> reqs is leaking if usb_alloc_urb() fails. Release reqs in the error
> handling path.
> 
> Fixes: 71bb244ba2fd ("brcm80211: fmac: add USB support for bcm43235/6/8 chipsets")
> Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>

Patch applied to wireless-drivers-next.git, thanks.

4282dc057d75 brcmfmac: Fix memory leak in brcmf_usbdev_qinit

-- 
https://patchwork.kernel.org/patch/11292553/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
