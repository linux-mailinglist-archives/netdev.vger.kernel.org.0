Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C95AE3F3A27
	for <lists+netdev@lfdr.de>; Sat, 21 Aug 2021 12:14:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233759AbhHUKO4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Aug 2021 06:14:56 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:55174 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233660AbhHUKOy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 21 Aug 2021 06:14:54 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1629540855; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=Ny6XszXW7Z2ZbJ4W8vGu4YWMEB4nBB7dDkoYqIpT+uE=; b=aEr3Eux6qlgZLDBCwXjo177GrMmrHXpgJ1lHP4FDPAcd3pZ0ZYdSLs4uHeoHXKi5LTDR79Xo
 C2KLHD1ubgj9nzANHaU8iGMnn4+pemKIR9kGYtjkwdFw6GTOFfUSPxk2NZY9gQmgAbSEzG2V
 Avde6y+x1t+A7I7pOJ/DPP4ASYc=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-east-1.postgun.com with SMTP id
 6120d1dd89fbdf3ffece3fab (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 21 Aug 2021 10:13:49
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 6D092C4361B; Sat, 21 Aug 2021 10:13:48 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from tynnyri.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 82EA8C4338F;
        Sat, 21 Aug 2021 10:13:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 82EA8C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Kees Cook <keescook@chromium.org>,
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
        <87tujjt8d9.fsf@codeaurora.org>
Date:   Sat, 21 Aug 2021 13:13:37 +0300
In-Reply-To: <87tujjt8d9.fsf@codeaurora.org> (Kalle Valo's message of "Sat, 21
        Aug 2021 13:11:46 +0300")
Message-ID: <87eean9kby.fsf@tynnyri.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kalle Valo <kvalo@codeaurora.org> writes:

> Jakub Kicinski <kuba@kernel.org> writes:
>
>> On Thu, 19 Aug 2021 13:28:22 -0700 Kees Cook wrote:
>>> Hi,
>>> 
>>> In preparation for FORTIFY_SOURCE performing compile-time and run-time
>>> field bounds checking for memcpy(), memmove(), and memset(), avoid
>>> intentionally writing across neighboring fields.
>>> 
>>> These three changes have been living in my memcpy() series[1], but have
>>> no external dependencies. It's probably better to have these go via
>>> netdev.
>>
>> Thanks.
>>
>> Kalle, Saeed - would you like to take the relevant changes? Presumably
>> they would get into net-next anyway by the time the merge window opens.
>
> Ok, I'll take patch 1 to wireless-drivers-next.

Correction: I'll take patches 1 and 3 to wireless-drivers-next.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
