Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 148F1D09A4
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 10:26:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730080AbfJIIZn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 04:25:43 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:58354 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725953AbfJIIZn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 04:25:43 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 4B81161C5D; Wed,  9 Oct 2019 08:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1570609542;
        bh=Kx0bVNOBSolPHCyjdM0sqtylnPBGneXIUGf8WvRiSSs=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=nxwaNTe+ib8qB+Ry3j8KTwtcJmtNyB8xjQfiZLXXKeht8xL39ycTvmVKBYlu6UywY
         GaoEEG+WLT1//u0c61clAfE2nrnEeGqJzk/VILnbrzId9PrXFLusByVIkm6MYJodL/
         +HkRuDp6P5KS6DfaNsbhgoWvvW/lkDKItIG2/qlk=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2A16361AB3;
        Wed,  9 Oct 2019 08:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1570609541;
        bh=Kx0bVNOBSolPHCyjdM0sqtylnPBGneXIUGf8WvRiSSs=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=KBYHnFylTWy/rx7gvQY8tG78KRLJtf0EAmuU72dZKyp6gnOjVmU3Hnyx2C2cc7so5
         LXMB5pCchVOpQk1S4652y2LJQsyDBUCyurAodHsXQaqQcMD7+VlB6DH/nXuldSrq7M
         NUkPs7QdWd+7jMPAAtbrOrF2wm0SLiVmy1LaHeSk=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 2A16361AB3
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] mwifiex: pcie: Fix memory leak in
 mwifiex_pcie_init_evt_ring
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20191004201649.25087-1-navid.emamdoost@gmail.com>
References: <20191004201649.25087-1-navid.emamdoost@gmail.com>
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
Message-Id: <20191009082542.4B81161C5D@smtp.codeaurora.org>
Date:   Wed,  9 Oct 2019 08:25:42 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Navid Emamdoost <navid.emamdoost@gmail.com> wrote:

> In mwifiex_pcie_init_evt_ring, a new skb is allocated which should be
> released if mwifiex_map_pci_memory() fails. The release for skb and
> card->evtbd_ring_vbase is added.
> 
> Fixes: 0732484b47b5 ("mwifiex: separate ring initialization and ring creation routines")
> Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
> Acked-by: Ganapathi Bhat <gbhat@marvell.com>

Patch applied to wireless-drivers-next.git, thanks.

d10dcb615c8e mwifiex: pcie: Fix memory leak in mwifiex_pcie_init_evt_ring

-- 
https://patchwork.kernel.org/patch/11175265/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

