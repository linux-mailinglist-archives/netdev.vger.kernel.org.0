Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4A3925F5B5
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 10:52:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728202AbgIGIws (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 04:52:48 -0400
Received: from a27-56.smtp-out.us-west-2.amazonses.com ([54.240.27.56]:35842
        "EHLO a27-56.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727122AbgIGIwp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 04:52:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1599468764;
        h=Content-Type:MIME-Version:Content-Transfer-Encoding:Subject:From:In-Reply-To:References:To:Cc:Message-Id:Date;
        bh=kiE5N7xdS+rLmJWgRX00IfpwqEON5REUjDKthNcC2KU=;
        b=g2U8yefQnDuE/1nsrNd1b9L0c/UydYwcUYqE//bjWq2ANJ7eajM46s6OWx+Tg2Us
        25MyGHyrpCOW+Z+6aqAxzYorc+7JpFINOJlFe/JUUVs4e95SvxAQ0wuGSXe+UrIPyLf
        LNh/K9GUc+/EHkoWX1MSJ4vv7jR+aobk+iivbsqo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=hsbnp7p3ensaochzwyq5wwmceodymuwv; d=amazonses.com; t=1599468764;
        h=Content-Type:MIME-Version:Content-Transfer-Encoding:Subject:From:In-Reply-To:References:To:Cc:Message-Id:Date:Feedback-ID;
        bh=kiE5N7xdS+rLmJWgRX00IfpwqEON5REUjDKthNcC2KU=;
        b=bRX4/u4oqoNsL8HDjPGqMJ5twUNf74DvlFoFvEDQ0MfPkSPdiCk+rcSf9pXwOsul
        Pwx2HIjGGnYuQkgN5EU0yk5p/4bgrfMPj0eG7i2dYVrK/A+gpfz0FXiJpEpUxvNg0JE
        gqm2LIawawDdk9f7RYrIFPfhe403hnNQqFfyhb+s=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL autolearn=no autolearn_force=no
        version=3.4.0
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C5E8AC35A16
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3 1/3] brcmfmac: increase F2 watermark for BCM4329
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200830191439.10017-2-digetx@gmail.com>
References: <20200830191439.10017-2-digetx@gmail.com>
To:     Dmitry Osipenko <digetx@gmail.com>
Cc:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-ID: <0101017467c47c8b-3be0f076-452b-4e42-933f-c40f7c2dc3fb-000000@us-west-2.amazonses.com>
Date:   Mon, 7 Sep 2020 08:52:44 +0000
X-SES-Outgoing: 2020.09.07-54.240.27.56
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dmitry Osipenko <digetx@gmail.com> wrote:

> This patch fixes SDHCI CRC errors during of RX throughput testing on
> BCM4329 chip if SDIO BUS is clocked above 25MHz. In particular the
> checksum problem is observed on NVIDIA Tegra20 SoCs. The good watermark
> value is borrowed from downstream BCMDHD driver and it's matching to the
> value that is already used for the BCM4339 chip, hence let's re-use it
> for BCM4329.
> 
> Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Dmitry Osipenko <digetx@gmail.com>

3 patches applied to wireless-drivers-next.git, thanks.

317da69d10b0 brcmfmac: increase F2 watermark for BCM4329
1a867a6230db brcmfmac: drop chip id from debug messages
cc95fa81524a brcmfmac: set F2 SDIO block size to 128 bytes for BCM4329

-- 
https://patchwork.kernel.org/patch/11745283/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

