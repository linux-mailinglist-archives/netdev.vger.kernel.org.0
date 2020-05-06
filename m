Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBA351C6C18
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 10:44:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728929AbgEFIoD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 04:44:03 -0400
Received: from mail27.static.mailgun.info ([104.130.122.27]:42405 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728410AbgEFIoC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 04:44:02 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1588754641; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=4zil7m4BIbiPEajht61/E+qHAdulL8Sl3UPj8uL2qSs=;
 b=M+dKpmRCmADcB2HGFtbolPvhpgaaaeMqEg3znFY5wDXmrjojme2ldaaKzPJ+ZeQbNNgfV+by
 ZNwerwHyXLenaz0xGX4W1QegKhuu+aBpFTAvlNcvK+uyRzHsPQysFiFsyqVb3zwOlXqljczX
 CAJKDPd/zsycqthGeVyu2LTUI3Y=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5eb278be.7feb23bf6fb8-smtp-out-n02;
 Wed, 06 May 2020 08:43:42 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 3E297C43636; Wed,  6 May 2020 08:43:42 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 877CFC433BA;
        Wed,  6 May 2020 08:43:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 877CFC433BA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 03/15] mwifiex: avoid -Wstringop-overflow warning
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200430213101.135134-4-arnd@arndb.de>
References: <20200430213101.135134-4-arnd@arndb.de>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     linux-kernel@vger.kernel.org,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Bing Zhao <bzhao@marvell.com>,
        Marc Yang <yangyang@marvell.com>,
        Ramesh Radhakrishnan <rramesh@marvell.com>,
        Kiran Divekar <dkiran@marvell.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>,
        Yogesh Ashok Powar <yogeshp@marvell.com>,
        Frank Huang <frankh@marvell.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Cathy Luo <xiaohua.luo@nxp.com>, James Cao <zheng.cao@nxp.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200506084342.3E297C43636@smtp.codeaurora.org>
Date:   Wed,  6 May 2020 08:43:42 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Arnd Bergmann <arnd@arndb.de> wrote:

> gcc-10 reports a warning for mwifiex_cmd_802_11_key_material_v1:
> 
> drivers/net/wireless/marvell/mwifiex/sta_cmd.c: In function 'mwifiex_cmd_802_11_key_material_v1':
> cc1: warning: writing 16 bytes into a region of size 0 [-Wstringop-overflow=]
> In file included from drivers/net/wireless/marvell/mwifiex/sta_cmd.c:23:
> drivers/net/wireless/marvell/mwifiex/fw.h:993:9: note: at offset 0 to object 'action' with size 2 declared here
>   993 |  __le16 action;
>       |         ^~~~~~
> 
> As the warning makes no sense, I reported it as a bug for gcc. In the
> meantime using a temporary pointer for the key data makes the code easier
> to read and stops the warning.
> 
> Fixes: 5e6e3a92b9a4 ("wireless: mwifiex: initial commit for Marvell mwifiex driver")
> Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=94881
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Patch applied to wireless-drivers-next.git, thanks.

08afb432c996 mwifiex: avoid -Wstringop-overflow warning

-- 
https://patchwork.kernel.org/patch/11521661/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
