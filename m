Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56C343DDE5A
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 19:21:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230169AbhHBRVM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 13:21:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:34980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229593AbhHBRVL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 13:21:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 68AB260F58;
        Mon,  2 Aug 2021 17:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627924861;
        bh=ggRngNHSSAss9GqeQqhYBpnDVCqYEfbvF4AwpCkBQmg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Sh6U3LdRshnPTaG4zGADE9rz5HK2nMu92L5xYhu119iuegIriFZ6PO5bFhy3BlzRS
         NLtV5tRMZ48kSvKbVlpicLk65JGOvP1mbwoLQ7JMkVq9WrPEj6sU0EwQt9CDENRMlN
         bddwzyDt/cY3G6sSYcgVPINb6vuWXPISxVntJoIahWDTbnSv4xRE+tP2j99tE95lUe
         qYmWjbdoMbz+W339cuxuzrMxi+ZUbjXd07NwLHI2aoEBOvbBJG0xtJr5Qatf8t7cEL
         RlN1KuHU+iMFKSbApRZTBur1iCoX8YNfdd8LXbj3+XWjbNuN1ZrTm+EfSKT4yGGUvU
         1lKFv48yLcSMQ==
Date:   Mon, 2 Aug 2021 10:21:00 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Nicholas Richardson <richardsonnick@google.com>
Cc:     davem@davemloft.net, nrrichar@ncsu.edu, arunkaly@google.com,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Leesoo Ahn <dev@ooseel.net>, Di Zhu <zhudi21@huawei.com>,
        Yejune Deng <yejune.deng@gmail.com>,
        Ye Bin <yebin10@huawei.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] pktgen: Fix invalid clone_skb override
Message-ID: <20210802102100.5292367a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210802171210.2191096-1-richardsonnick@google.com>
References: <20210802071126.3b311638@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210802171210.2191096-1-richardsonnick@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  2 Aug 2021 17:12:07 +0000 Nicholas Richardson wrote:
> From: Nick Richardson <richardsonnick@google.com>
> 
> When the netif_receive xmit_mode is set, a line is supposed to set
> clone_skb to a default 0 value. This line is not reached due to a line
> that checks if clone_skb is more than zero and returns -ENOTSUPP.
> 
> Removes line that defaults clone_skb to zero.

s/Removes/Remove/
s/defaults/sets/

> -ENOTSUPP is returned
> if clone_skb is more than zero. 

That's already mentioned in the previous paragraph.

> If clone_skb is equal to zero then the
> xmit_mode is set to netif_receive as usual and no error is returned.

Please add the explanation why clone_skb can't be negative to the
commit message.
