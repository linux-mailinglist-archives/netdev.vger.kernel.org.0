Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E4161A9BAF
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 13:08:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2896716AbgDOLEr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 07:04:47 -0400
Received: from mail.fudan.edu.cn ([202.120.224.73]:56524 "EHLO fudan.edu.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2408845AbgDOLEO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Apr 2020 07:04:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fudan.edu.cn; s=dkim; h=Received:Date:From:To:Cc:Subject:
        Message-ID:References:MIME-Version:Content-Type:
        Content-Disposition:In-Reply-To; bh=EQJkaChu07Wb5zNeSc4Q2eAuqN9B
        /MkelX8i1XndZjM=; b=jMjJteDBHiV26NRygYKv2+f1aO25a/Jmf6v70ZNRfyIS
        RM7fBjQAWWEGsDc9XBZsKpD4JAncQ9ifL5l0Lh/GjMIox6KkO3MYIXTPAPKCb2BU
        +9pQXiV0CcNDjI7YTfJtW1Inm0s2X79JIiKsMWvE+O34ugmSLtsi8HoPB2zhQv4=
Received: from localhost (unknown [61.129.42.58])
        by app2 (Coremail) with SMTP id XQUFCgC3mV4D6pZe0LRaAA--.5091S2;
        Wed, 15 Apr 2020 19:03:31 +0800 (CST)
Date:   Wed, 15 Apr 2020 19:03:30 +0800
From:   Xiyu Yang <xiyuyang19@fudan.edu.cn>
To:     Sven Eckelmann <sven@narfation.org>
Cc:     Marek Lindner <mareklindner@neomailbox.ch>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Antonio Quartulli <a@unstable.cc>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        b.a.t.m.a.n@lists.open-mesh.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, yuanxzhang@fudan.edu.cn,
        kjlu@umn.edu, Xin Tan <tanxin.ctf@gmail.com>
Subject: Re: [PATCH] batman-adv: Fix refcnt leak in
 batadv_show_throughput_override
Message-ID: <20200415110330.GA71449@sherlly>
References: <1586939510-69461-1-git-send-email-xiyuyang19@fudan.edu.cn>
 <28340414.QPzbqP6r4N@bentobox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <28340414.QPzbqP6r4N@bentobox>
X-CM-TRANSID: XQUFCgC3mV4D6pZe0LRaAA--.5091S2
X-Coremail-Antispam: 1UD129KBjvdXoWrurW7Xw1UGr17tw4UZF47urg_yoW3KFbE9F
        s3urykKa4vkF4UA398WFWrJF43GayrXr17Jw10vry3JF95ur15uF93CFn7GF1FyFZ2q3Z8
        ArnrZ3s8Jwna9jkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUb-8YjsxI4VWxJwAYFVCjjxCrM7AC8VAFwI0_Gr0_Xr1l1xkIjI8I
        6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM2
        8CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0
        cI8IcVCY1x0267AKxVWxJr0_GcWl84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4
        A2jsIEc7CjxVAFwI0_GcCE3s1lnxkEFVAIw20F6cxK64vIFxWle2I262IYc4CY6c8Ij28I
        cVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx
        0Ex4A2jsIE14v26r4j6F4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwACI402
        YVCY1x02628vn2kIc2xKxwCY02Avz4vE14v_Gw4l42xK82IYc2Ij64vIr41l4I8I3I0E4I
        kC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWU
        WwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr
        0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWr
        Zr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr
        1UYxBIdaVFxhVjvjDU0xZFpf9x07jzbyZUUUUU=
X-CM-SenderInfo: irzsiiysuqikmy6i3vldqovvfxof0/
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 15, 2020 at 11:04:02AM +0200, Sven Eckelmann wrote:
> On Wednesday, 15 April 2020 10:31:50 CEST Xiyu Yang wrote:
> [...]
> > Fix this issue by calling batadv_hardif_put() before the
> [...]
> 
> Thanks, fixes for batadv_store_throughput_override [1] and 
> batadv_show_throughput_override [2] were applied. I've also added the missing 
> Fixes: line to both patches.
> 
> May I ask whether you are still a user of the deprecated sysfs interface or 
> did you find this in an automated fashion?
> 
> Thanks,
> 	Sven
> 
> [1] https://git.open-mesh.org/linux-merge.git/commit/cd339d8b14cd895d8333d94d832b05f67f00eefc
> [2] https://git.open-mesh.org/linux-merge.git/commit/3d3e548f74fe51aee9a3c9e297518a2655dbc642

Thanks for your confirmation! We are looking for some automated ways to find this kind of bug.

