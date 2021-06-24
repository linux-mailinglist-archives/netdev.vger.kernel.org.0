Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E031F3B3411
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 18:42:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232046AbhFXQoX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 12:44:23 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:26815 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbhFXQoW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 12:44:22 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1624552923; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=p4AyN0IckVIgEF0pepUMRnDVIZkiIMMxD6qEertwOF4=; b=OS9RASep1LWlOdjXglvgZntUaWpJjtyblapgBWVD7si4dbfoP4YXS0DEs7ST0TWmzL/d/E/g
 r8sDqhZb6Gg2XnbfTtwd/tdvq8Cg92vakb9rmsEfZWLz4Pny0JUCxHz2rjnpoZKgCxZorPFq
 HOYRrcs4Fw8RLesXrAYiTnKnII8=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-east-1.postgun.com with SMTP id
 60d4b54c0090905e166fdc9e (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 24 Jun 2021 16:39:40
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 3F4A6C43146; Thu, 24 Jun 2021 16:39:39 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from tynnyri.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 19ED2C433D3;
        Thu, 24 Jun 2021 16:39:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 19ED2C433D3
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Mikhail Rudenko <mike.rudenko@gmail.com>
Cc:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Dmitry Osipenko <digetx@gmail.com>,
        Double Lo <double.lo@cypress.com>,
        Remi Depommier <rde@setrix.com>,
        Amar Shankar <amsr@cypress.com>,
        Saravanan Shanmugham <saravanan.shanmugham@cypress.com>,
        Frank Kao <frank.kao@cypress.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] brcmfmac: use separate firmware for 43430 revision 2
References: <20210509233010.2477973-1-mike.rudenko@gmail.com>
        <d1bac6c3-aa52-5d76-1f2a-4af9edef71c5@broadcom.com>
        <87a6oxpsn8.fsf@gmail.com>
Date:   Thu, 24 Jun 2021 19:39:31 +0300
In-Reply-To: <87a6oxpsn8.fsf@gmail.com> (Mikhail Rudenko's message of "Fri, 14
        May 2021 12:41:08 +0300")
Message-ID: <87o8bvgqt8.fsf@tynnyri.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mikhail Rudenko <mike.rudenko@gmail.com> writes:

> On 2021-05-10 at 11:06 MSK, Arend van Spriel <arend.vanspriel@broadcom.com> wrote:
>> On 5/10/2021 1:30 AM, Mikhail Rudenko wrote:
>>> A separate firmware is needed for Broadcom 43430 revision 2.  This
>>> chip can be found in e.g. certain revisions of Ampak AP6212 wireless
>>> IC. Original firmware file from IC vendor is named
>>> 'fw_bcm43436b0.bin', but brcmfmac and also btbcm drivers report chip
>>
>> That is bad naming. There already is a 43436 USB device.
>>
>>> id 43430, so requested firmware file name is
>>> 'brcmfmac43430b0-sdio.bin' in line with other 43430 revisions.
>>
>> As always there is the question about who will be publishing this
>> particular firmware file to linux-firmware.
>
> The above mentioned file can be easily found by web search. Also, the
> corresponding patch for the bluetooth part has just been accepted
> [1]. Is it strictly necessary to have firmware file in linux-firmware in
> order to have this patch accepted?

This patch is a bit in the gray area. We have a rule that firmware
images should be in linux-firmware, but as the vendor won't submit one
and I assume the license doesn't approve the community submit it either,
there is not really any solution for the firmware problem.

On the other hand some community members have access to the firmware
somehow so this patch is useful to the community, and I think taking an
exception to the rule in this case is justified. So I am inclined
towards applying the patch.

Thoughts? I also have another similar patch in the queue:

https://patchwork.kernel.org/project/linux-wireless/patch/20210307113550.7720-1-konrad.dybcio@somainline.org/

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
