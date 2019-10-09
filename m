Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A50ED09A1
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 10:25:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730059AbfJIIZQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 04:25:16 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:57928 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725440AbfJIIZQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 04:25:16 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 3401561C42; Wed,  9 Oct 2019 08:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1570609515;
        bh=UWKLarL+SemxD6See7MSRBpgzzZ99aleBFBC4/D/1to=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=I3YRHK22LBXq33oBjyp+rnx9Ko/3P0DbXoSRhb0t7U8hv9JSjLuFdnnUtUSyqueJq
         vEEIeGVYvcr9XKlEDLDHri0mOdjAadg3f1LO7tSHV74tGOSnUsW/Y4muCo/sLc9Ys1
         jjWKcUIGTrfaS4boDJhPi7WqIja1DoyKm5A6IKdY=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,MISSING_DATE,MISSING_MID,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B9E9661C0E;
        Wed,  9 Oct 2019 08:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1570609512;
        bh=UWKLarL+SemxD6See7MSRBpgzzZ99aleBFBC4/D/1to=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=CyqY23mnIEllfOoivKbUCvLH7zw/oP2uy4Tg0TaOP4kDOfe98dc/RO0MvBQZN6+lU
         o9kpBRFDT4Cn43wokteavpLf1W/jfDpLpStfcYhwPdMxAyhAymv/5IJA0JGS+jHdGF
         /3OTtlFcuF/7o8KXWJYmTegzz4h2wW+Hw1XP4P78=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B9E9661C0E
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] mwifiex: pcie: Fix memory leak in
 mwifiex_pcie_alloc_cmdrsp_buf
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20191004200853.23353-1-navid.emamdoost@gmail.com>
References: <20191004200853.23353-1-navid.emamdoost@gmail.com>
To:     Navid Emamdoost <navid.emamdoost@gmail.com>
Cc:     unlisted-recipients:; (no To-header on input) emamd001@umn.edu,
        kjlu@umn.edu, smccaman@umn.edu,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Xinming Hu <huxinming820@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Illegal-Object: Syntax error in Cc: address found on vger.kernel.org:
        Cc:     unlisted-recipients:; (no To-header on input)emamd001@umn.edu
                                                                     ^-missing end of address
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20191009082515.3401561C42@smtp.codeaurora.org>
Date:   Wed,  9 Oct 2019 08:25:13 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Navid Emamdoost <navid.emamdoost@gmail.com> wrote:

> In mwifiex_pcie_alloc_cmdrsp_buf, a new skb is allocated which should be
> released if mwifiex_map_pci_memory() fails. The release is added.
> 
> Fixes: fc3314609047 ("mwifiex: use pci_alloc/free_consistent APIs for PCIe")
> Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
> Acked-by: Ganapathi Bhat <gbhat@marvell.com>

Patch applied to wireless-drivers-next.git, thanks.

db8fd2cde932 mwifiex: pcie: Fix memory leak in mwifiex_pcie_alloc_cmdrsp_buf

-- 
https://patchwork.kernel.org/patch/11175263/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

