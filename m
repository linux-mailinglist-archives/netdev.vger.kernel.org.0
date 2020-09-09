Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC8FA2628C2
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 09:32:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727087AbgIIHcs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 03:32:48 -0400
Received: from a27-10.smtp-out.us-west-2.amazonses.com ([54.240.27.10]:33348
        "EHLO a27-10.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725864AbgIIHcs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 03:32:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1599636767;
        h=Content-Type:MIME-Version:Content-Transfer-Encoding:Subject:From:In-Reply-To:References:To:Cc:Message-Id:Date;
        bh=ET7FgPkRWgZUD0pQCf4g5M9uCcqpNbuZNq4ME2uq3JI=;
        b=S0fgPqJDItDcMZ/Kk/DNu3p8E7jiUyKRg4lttV68ZCFmwx9MAHriKy8WdHAAHqyT
        JX+wjy9rgMtPP8zSg95aWAoLA9vilLtlqFDBxkrQAknaUElV1cq2KCXIsTdLAGuvNbw
        vnIbv2c8bKdjQKjH81UHE3vfZ+F1gXNzOAWq9lqc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=hsbnp7p3ensaochzwyq5wwmceodymuwv; d=amazonses.com; t=1599636767;
        h=Content-Type:MIME-Version:Content-Transfer-Encoding:Subject:From:In-Reply-To:References:To:Cc:Message-Id:Date:Feedback-ID;
        bh=ET7FgPkRWgZUD0pQCf4g5M9uCcqpNbuZNq4ME2uq3JI=;
        b=PPBch/EcDcefxPL3C8fVjcnk6/VkiNuI8nU3FpTVJTzqoAQ1/+/CKlrjHkBH2scZ
        gzzvCeAsmI7zXdWjxNmv2km9KlHLbrf/1Ovue6ICsdx0NM6U0VpHewmy/BwiC66pRpb
        V/XJcZTsZ/JM2aQR+wCFxclHWFDqbGSJrbc5Sot4=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.0
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org AB729C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] brcmsmac: fix memory leak in wlc_phy_attach_lcnphy
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200908121743.23108-1-keitasuzuki.park@sslab.ics.keio.ac.jp>
References: <20200908121743.23108-1-keitasuzuki.park@sslab.ics.keio.ac.jp>
To:     Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>
Cc:     unlisted-recipients:; (no To-header on input)
        keitasuzuki.park@sslab.ics.keio.ac.jp,
        takafumi@sslab.ics.keio.ac.jp,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Illegal-Object: Syntax error in Cc: address found on vger.kernel.org:
        Cc:     unlisted-recipients:; (no To-header on input)keitasuzuki.park@sslab.ics.keio.ac.jp
                                                                     ^-missing end of address
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-ID: <0101017471c8011a-8c36c26e-bef6-438b-b4d7-3e423983ac30-000000@us-west-2.amazonses.com>
Date:   Wed, 9 Sep 2020 07:32:47 +0000
X-SES-Outgoing: 2020.09.09-54.240.27.10
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp> wrote:

> When wlc_phy_txpwr_srom_read_lcnphy fails in wlc_phy_attach_lcnphy,
> the allocated pi->u.pi_lcnphy is leaked, since struct brcms_phy will be
> freed in the caller function.
> 
> Fix this by calling wlc_phy_detach_lcnphy in the error handler of
> wlc_phy_txpwr_srom_read_lcnphy before returning.
> 
> Signed-off-by: Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>

Patch applied to wireless-drivers-next.git, thanks.

f4443293d741 brcmsmac: fix memory leak in wlc_phy_attach_lcnphy

-- 
https://patchwork.kernel.org/patch/11763749/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

