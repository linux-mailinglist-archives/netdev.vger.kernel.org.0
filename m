Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33D033F3A23
	for <lists+netdev@lfdr.de>; Sat, 21 Aug 2021 12:12:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234293AbhHUKMk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Aug 2021 06:12:40 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:64250 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233966AbhHUKMi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Aug 2021 06:12:38 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1629540719; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=DtreSWuXzdy5PnILjEf5ZoEUDjROdOZk8ywtPP/mAQM=; b=ISkg44BvWqCq3AotnjTL36E71xC/srW2ZgMkzdvzJwgVFBRcJr3VGuJXp9mu1bz0Y/s4aVeo
 GBtjAGI1TQaTcUZbWDoTMxRBi/IgU9YkgQgYHluse33ccLyQFl9MML3ciEqsDzfWRlYQNwZF
 cZ/x3ciQiqlK2NVscCB5q924BLs=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-east-1.postgun.com with SMTP id
 6120d16aa2d1fbf62b011a69 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 21 Aug 2021 10:11:54
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 9DAB4C4360C; Sat, 21 Aug 2021 10:11:53 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from tykki (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8F2BAC4338F;
        Sat, 21 Aug 2021 10:11:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 8F2BAC4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Kees Cook <keescook@chromium.org>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Leon Romanovsky <leon@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-rdma@vger.kernel.org,
        bpf@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH 0/3] net: Cleanups for FORTIFY_SOURCE
References: <20210819202825.3545692-1-keescook@chromium.org>
        <20210820100151.25f7ccd4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Date:   Sat, 21 Aug 2021 13:11:46 +0300
In-Reply-To: <20210820100151.25f7ccd4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        (Jakub Kicinski's message of "Fri, 20 Aug 2021 10:01:51 -0700")
Message-ID: <87tujjt8d9.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:

> On Thu, 19 Aug 2021 13:28:22 -0700 Kees Cook wrote:
>> Hi,
>> 
>> In preparation for FORTIFY_SOURCE performing compile-time and run-time
>> field bounds checking for memcpy(), memmove(), and memset(), avoid
>> intentionally writing across neighboring fields.
>> 
>> These three changes have been living in my memcpy() series[1], but have
>> no external dependencies. It's probably better to have these go via
>> netdev.
>
> Thanks.
>
> Kalle, Saeed - would you like to take the relevant changes? Presumably
> they would get into net-next anyway by the time the merge window opens.

Ok, I'll take patch 1 to wireless-drivers-next.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
