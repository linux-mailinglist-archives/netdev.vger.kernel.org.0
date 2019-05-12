Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66C5F1AE1A
	for <lists+netdev@lfdr.de>; Sun, 12 May 2019 22:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727037AbfELUUI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 May 2019 16:20:08 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56740 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726664AbfELUUH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 May 2019 16:20:07 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3CDBD14BFCB58;
        Sun, 12 May 2019 13:20:06 -0700 (PDT)
Date:   Sun, 12 May 2019 13:20:03 -0700 (PDT)
Message-Id: <20190512.132003.2243755455260411368.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        netdev@vger.kernel.org
Subject: Re: [PATCH net 0/3] Fix a bug and avoid dangerous usage patterns
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190511201447.15662-1-olteanv@gmail.com>
References: <20190511201447.15662-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 12 May 2019 13:20:06 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Sat, 11 May 2019 23:14:44 +0300

> Making DSA use the sk_buff control block was my idea during the
> 'Traffic-support-for-SJA1105-DSA-driver' patchset, and I had also
> introduced a series of macro helpers that turned out to not be so
> helpful:
> 
> 1. DSA_SKB_ZERO() zeroizes the 48-byte skb->cb area, but due to the high
>    performance impact in the hotpath it was only intended to be called
>    from the timestamping path. But it turns out that not zeroizing it
>    has uncovered the reading of an uninitialized member field of
>    DSA_SKB_CB, so in the future just be careful about what needs
>    initialization and remove this macro.
> 2. DSA_SKB_CLONE() contains a flaw in its body definition (originally
>    put there to silence checkpatch.pl) and is unusable at this point
>    (will only cause NPE's when used). So remove it.
> 3. For DSA_SKB_COPY() the same performance considerations apply as above
>    and therefore it's best to prune this function before it reaches a
>    stable kernel and potentially any users.

Series applied, thank you.
