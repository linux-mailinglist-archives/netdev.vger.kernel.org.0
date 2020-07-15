Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6915221633
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 22:27:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727787AbgGOU1C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 16:27:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:33572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727037AbgGOU1B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jul 2020 16:27:01 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 49ED220672;
        Wed, 15 Jul 2020 20:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594844821;
        bh=Pp8UvZbpzEoLiSxnR7HhTqdL2JabHToZeJceQvZNvFI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=srIkbJEMEv9tUrgK3P9cRDD5YGT3p6kHaoDAuGMcTS9xRDMgdpPWWOe4h+a0osETL
         hQl62ZmZKpvbPhBl9go0ZxUK5Ln+xRgy8aG/+jV6l7QWWbvpusWT0oeFKt5Hunt2O3
         26JtYXv3DA7bcSb65J0fAKryJIIdL1AT1kHDLgHc=
Date:   Wed, 15 Jul 2020 13:26:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     wenxu@ucloud.cn
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        fw@strlen.de, Cong Wang <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH net-next v2 0/3] make nf_ct_frag/6_gather elide the skb
 CB clear
Message-ID: <20200715132659.34fa0e14@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1594097711-9365-1-git-send-email-wenxu@ucloud.cn>
References: <1594097711-9365-1-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  7 Jul 2020 12:55:08 +0800 wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> Add nf_ct_frag_gather and Make nf_ct_frag6_gather elide the CB clear 
> when packets are defragmented by connection tracking. This can make
> each subsystem such as br_netfilter, openvswitch, act_ct do defrag
> without restore the CB. 
> This also avoid serious crashes and problems in  ct subsystem.
> Because Some packet schedulers store pointers in the qdisc CB private
> area and parallel accesses to the SKB.
> 
> This series following up
> http://patchwork.ozlabs.org/project/netdev/patch/1593422178-26949-1-git-send-email-wenxu@ucloud.cn/
> 
> patch1: add nf_ct_frag_gather elide the CB clear
> patch2: make nf_ct_frag6_gather elide the CB clear
> patch3: fix clobber qdisc_skb_cb in act_ct with defrag
> 
> v2: resue some ip_defrag function in patch1

Florian, Cong - are you willing to venture an ack on these? Anyone?
