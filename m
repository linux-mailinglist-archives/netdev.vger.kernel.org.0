Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 044FF1CDACD
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 15:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730026AbgEKNKd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 09:10:33 -0400
Received: from mail26.static.mailgun.info ([104.130.122.26]:50045 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729930AbgEKNKc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 09:10:32 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1589202631; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=gPnsrzs+plOHL0uPC+T4fD59p+rrJ4NE3BaJG3QXpe8=; b=mN1gyD1tQKrpt3IDASQwBnWdWZg/P4o8jPmxejkMACkJL86IXjsNLK5R1QXyTxCvS4uFsrSu
 RSVt0agbxhjfMsLdzZ6FH+8mI77hkbkBLN+b/6xrmO94K4sDzor37InG9Fks1Jh+MG99gG/C
 z/PK01dXOqh/bczMXInfS4ipafM=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5eb94eac.7f11264556f8-smtp-out-n02;
 Mon, 11 May 2020 13:10:04 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id A0B62C44788; Mon, 11 May 2020 13:10:02 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 64B36C433F2;
        Mon, 11 May 2020 13:09:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 64B36C433F2
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Michal Kazior <michal.kazior@tieto.com>,
        "David S. Miller" <davem@davemloft.net>,
        Wen Gong <wgong@codeaurora.org>,
        Erik Stromdahl <erik.stromdahl@gmail.com>,
        ath10k@lists.infradead.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 1/2] ath10k: fix gcc-10 zero-length-bounds warnings
References: <20200509120707.188595-1-arnd@arndb.de>
        <20200509154818.GB27779@embeddedor>
        <87zhae4r35.fsf@kamboji.qca.qualcomm.com>
        <CAK8P3a2i-jqY8FnY_Tu41VDxQGqHHKRCyJ5U-GQbNmrqa=n0GQ@mail.gmail.com>
Date:   Mon, 11 May 2020 16:09:57 +0300
In-Reply-To: <CAK8P3a2i-jqY8FnY_Tu41VDxQGqHHKRCyJ5U-GQbNmrqa=n0GQ@mail.gmail.com>
        (Arnd Bergmann's message of "Mon, 11 May 2020 14:46:00 +0200")
Message-ID: <87mu6e4nyy.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Arnd Bergmann <arnd@arndb.de> writes:

> On Mon, May 11, 2020 at 2:03 PM Kalle Valo <kvalo@codeaurora.org> wrote:
>> "Gustavo A. R. Silva" <gustavoars@kernel.org> writes:
>
>> >
>> > This treewide patch no longer contains changes for ath10k. I removed them
>> > since Monday (05/04/2020). So, this "Fixes" tag does not apply.
>
> Oops, I forgot to update the changelog trext when rebasing.
>
>> Ok, I'll remove it. Also I'll take these to my ath.git tree, not to
>> net-next.
>
> Thanks a lot!

Weird, I had a conflict with this patch but couldn't figure out why.
Anyway, I fixed it in my pending branch and please double check:

https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/commit/?h=pending&id=c3e5221f3c3ddabc76a33ff08440ff1dc664998d

At least GCC-10 is happy now.

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
