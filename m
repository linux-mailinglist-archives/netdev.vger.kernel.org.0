Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 191EF31FB7F
	for <lists+netdev@lfdr.de>; Fri, 19 Feb 2021 15:58:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbhBSO6a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Feb 2021 09:58:30 -0500
Received: from m42-2.mailgun.net ([69.72.42.2]:15309 "EHLO m42-2.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229553AbhBSO61 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Feb 2021 09:58:27 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1613746682; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=xF5d0AE+xCt+zGgDt1pFO1QgGtL9JnfLXGOvSzH34zc=; b=YRQNkqt0Lp2ze77HcZIhq8eQ/NTz7GLjtdvtzng1Eo5H7FsUGBc6mhscopRRZ8kYnJmB06So
 f7c/WljS0/H1t52fZHp60VHSa/NcFXwA2NIE2cZY7KBzj3zWuBKVaBcz5PgyeRs+/aarPtGv
 cGi38ucxyO/4kgPZ+cDseUGfrEA=
X-Mailgun-Sending-Ip: 69.72.42.2
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-east-1.postgun.com with SMTP id
 602fd1efe87943df30d1ad91 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 19 Feb 2021 14:57:51
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 25331C43464; Fri, 19 Feb 2021 14:57:51 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from tynnyri.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 51166C433CA;
        Fri, 19 Feb 2021 14:57:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 51166C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Brendan Jackman <jackmanb@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: build warnings after merge of the net-next tree
References: <20210219075256.7af60fb0@canb.auug.org.au>
        <20210219194416.3376050f@canb.auug.org.au>
Date:   Fri, 19 Feb 2021 16:57:44 +0200
In-Reply-To: <20210219194416.3376050f@canb.auug.org.au> (Stephen Rothwell's
        message of "Fri, 19 Feb 2021 19:44:16 +1100")
Message-ID: <87czwwf6l3.fsf@tynnyri.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> writes:

> Hi all,
>
> On Fri, 19 Feb 2021 07:52:56 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>>
>> After merging the net-next tree, today's linux-next build (htmldocs)
>> produced these warnings:
>> 
>> Documentation/networking/filter.rst:1053: WARNING: Inline emphasis start-string without end-string.
>> Documentation/networking/filter.rst:1053: WARNING: Inline emphasis start-string without end-string.
>> Documentation/networking/filter.rst:1053: WARNING: Inline emphasis start-string without end-string.
>> Documentation/networking/filter.rst:1053: WARNING: Inline emphasis start-string without end-string.
>> 
>> Introduced by commit
>> 
>>   91c960b00566 ("bpf: Rename BPF_XADD and prepare to encode other atomics in .imm")
>> 
>> Sorry that I missed these earlier.
>
> These have been fixed in the net-next tree, actually.  I was fooled
> because an earlier part of the net-next tree has been included in the
> wireless-drivers (not -next) tree today so these warnings popped up
> earlier, but are gone one the rest of the net-next tree is merged.
>
> Sorry for the noise.

Argh, sorry about that Stephen. I was preparing wireless-drivers for
followup fixes sent during the merge window, but didn't realise that it
will mess up your tree building. I need to avoid this in the future and
wireless-drivers should only follow the net tree.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
