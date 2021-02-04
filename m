Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CFA530FDEE
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 21:19:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239759AbhBDUQz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 15:16:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:35466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239501AbhBDUQp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 15:16:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA41A64F76;
        Thu,  4 Feb 2021 20:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612469764;
        bh=qMrutQxO+Z/C0k8d27aJb5W8HB66kXAyfkyYodI63uY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=n8BaZ83CtAMxsnAvOKu3tEcOb+uoxgh7WKGPi+OtNYNU/NeiQphx3fwXAwToH/hV2
         1zZOFeRm3KX8YG2xuRgkArm6NciUgiCr4QtESgSqkoxBR6fYRpj2EBc2hpWzH10eib
         R5foL6tH9mFTmLoUGIQRqTfCJdprOrPgkhGpPxnMjUsmENrl3sG5+Dzoli24wa0tbQ
         u+M8R2S8YiC0A/Yu4mVwu8+MuZEUpjXoX6fXoBLcdZaKvkf5qVgmSSs6gaf4xAZkcv
         Bf1kyVRKR7Ve0uZ7nFo1l9HcAPNmEjqvVZibN/OQSUwhdroOhqH1sE3z+Asr+XuOZT
         WgqSC9a4hefdg==
Date:   Thu, 4 Feb 2021 12:16:02 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andreas Roeseler <andreas.a.roeseler@gmail.com>
Cc:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH V2 net-next 5/5] icmp: add response to RFC 8335 PROBE
 messages
Message-ID: <20210204121602.18e998bd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <7af3da33a7aa540f7878cfcbf5076dcf61d201ef.1612393368.git.andreas.a.roeseler@gmail.com>
References: <cover.1612393368.git.andreas.a.roeseler@gmail.com>
        <7af3da33a7aa540f7878cfcbf5076dcf61d201ef.1612393368.git.andreas.a.roeseler@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  3 Feb 2021 15:24:55 -0800 Andreas Roeseler wrote:
> Modify the icmp_rcv function to check for PROBE messages and call
> icmp_echo if a PROBE request is detected.
> 
> Modify the existing icmp_echo function to respond to both ping and PROBE
> requests.
> 
> This was tested using a custom modification of the iputils package and
> wireshark. It supports IPV4 probing by name, ifindex, and probing by both IPV4 and IPV6
> addresses. It currently does not support responding to probes off the proxy node
> (See RFC 8335 Section 2). 
> 
> 
> Signed-off-by: Andreas Roeseler <andreas.a.roeseler@gmail.com>

make allmodconfig && make W=1 C=1 says:

../net/ipv4/icmp.c: note: in included file (through ../include/linux/spinlock.h, ../include/linux/mmzone.h, ../include/linux/gfp.h, ../include/linux/umh.h, ../include/linux/kmod.h, ../include/linux/module.h):
../include/linux/bottom_half.h:32:30: warning: context imbalance in 'icmp_reply' - different lock contexts for basic block
../include/linux/bottom_half.h:32:30: warning: context imbalance in '__icmp_send' - different lock contexts for basic block
../net/ipv4/icmp.c:1024:45: warning: cast to restricted __be32
../net/ipv4/icmp.c:1024:45: warning: cast to restricted __be32
../net/ipv4/icmp.c:1024:45: warning: cast to restricted __be32
../net/ipv4/icmp.c:1024:45: warning: cast to restricted __be32
../net/ipv4/icmp.c:1024:45: warning: cast to restricted __be32
../net/ipv4/icmp.c:1024:45: warning: cast to restricted __be32
../net/ipv4/icmp.c:1027:25: warning: cast to restricted __be16
../net/ipv4/icmp.c:1027:25: warning: cast to restricted __be16
../net/ipv4/icmp.c:1027:25: warning: cast to restricted __be16
../net/ipv4/icmp.c:1027:25: warning: cast to restricted __be16
../net/ipv4/icmp.c:1058:29: warning: incorrect type in argument 1 (different address spaces)
../net/ipv4/icmp.c:1058:29:    expected struct list_head const *head
../net/ipv4/icmp.c:1058:29:    got struct list_head [noderef] __rcu *
../net/ipv4/icmp.c: note: in included file (through ../include/linux/spinlock.h, ../include/linux/mmzone.h, ../include/linux/gfp.h, ../include/linux/umh.h, ../include/linux/kmod.h, ../include/linux/module.h):
../include/linux/bottom_half.h:32:30: warning: context imbalance in 'icmp_reply' - different lock contexts for basic block
../include/linux/bottom_half.h:32:30: warning: context imbalance in '__icmp_send' - different lock contexts for basic block
../net/ipv4/icmp.c:1056:16: warning: dereference of noderef expression
net/ipv4/icmp.o: In function `icmp_echo':
icmp.c:(.text+0x123a): undefined reference to `ipv6_dev_find'
make[1]: *** [vmlinux] Error 1
make: *** [__sub-make] Error 2
New errors added
