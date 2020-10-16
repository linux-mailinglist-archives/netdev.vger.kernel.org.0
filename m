Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1364828FDF4
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 08:01:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391033AbgJPGB1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 02:01:27 -0400
Received: from m42-4.mailgun.net ([69.72.42.4]:17134 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390989AbgJPGBZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Oct 2020 02:01:25 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1602828084; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=3RniiqB+zkqxMCvtU+f3tA/AMpl7AoAO184Gvby039w=; b=bF7B3ZcR7jXoPn1gADvZvWmogIgBuvaTVYRr4ZH8uepHO9lmKgkVcDVWeZ0aU/Tsuu67nB6F
 HZu1AOTBlVpHyNJuMI/WBUpSd7XUM8B8rSfTInymR2yt7Mf11utAUqfUYqqxOe+1qIFh6vjt
 63CQ8JNMFerXzUQbz+sI5Ga1/PU=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-west-2.postgun.com with SMTP id
 5f893722a03b63d67333a025 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 16 Oct 2020 06:01:06
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id E8865C433CB; Fri, 16 Oct 2020 06:01:05 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id CCF45C433C9;
        Fri, 16 Oct 2020 06:01:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org CCF45C433C9
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     Wireless <linux-wireless@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Ido Schimmel <idosch@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Michael Jeanson <mjeanson@efficios.com>
Subject: Re: linux-next: manual merge of the wireless-drivers tree with the net tree
References: <20201016084419.3c6e048a@canb.auug.org.au>
Date:   Fri, 16 Oct 2020 09:01:00 +0300
In-Reply-To: <20201016084419.3c6e048a@canb.auug.org.au> (Stephen Rothwell's
        message of "Fri, 16 Oct 2020 08:44:19 +1100")
Message-ID: <87imbazp43.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> writes:

> Hi all,
>
> Today's linux-next merge of the wireless-drivers tree got a conflict in:
>
>   tools/testing/selftests/net/Makefile
>
> between commit:
>
>   1a01727676a8 ("selftests: Add VRF route leaking tests")
>
> from the net tree and commit:
>
>   b7cc6d3c5c91 ("selftests: net: Add drop monitor test")
>
> from the wireless-drivers (presumably because it has merged part of the
> net-next tree) tree.

Correct, I fast forwarded wireless-drivers from net-next to prepare for
sending bug fixes in the end of the merge window. But I didn't realise
that it might break linux-next build, so wireless-drivers should always
follow net tree and not net-next. Sorry about that.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
