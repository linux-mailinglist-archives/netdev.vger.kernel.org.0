Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 735CF8C9ED
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 05:43:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727102AbfHNDnL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 23:43:11 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:34741 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726692AbfHNDnL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 23:43:11 -0400
Received: by mail-pl1-f194.google.com with SMTP id i2so50170488plt.1
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 20:43:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=uHyegi3jrd9MtFDSnJbhlxAAg+E7pSvJVHEwbO+kAGc=;
        b=DW4hxyto+unsxHvr79SpNdoq15vUkIn6cpk6JoJo9G09AKJD3krG62BYYAvEYgv33n
         BHAFLYeuGmgPDxl3tYok/EMHedz6LcYZk0jFQ4xrRWjQYTk1kNux3mXjWl5W4868ZGdN
         HETtULp+jb272i+c6w7VvuDoqixG+zwneD8tC5SLvLi769nGFzzVroAt448DmvQRlqu3
         VCstHdxLF74K5gzsSJnBKqE2AJ6xwVvWck0dlrWjKyD3fg5jbOC7hzMzRmoj7tP5LIli
         N5d8sviAxyH42gHIZ5ZrkxzFU3NZfDpiSWzw8cZ8Q6gqPy5ESL3motpJssHMT+gde6fn
         hySw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=uHyegi3jrd9MtFDSnJbhlxAAg+E7pSvJVHEwbO+kAGc=;
        b=m/cR8HaywllSDC82aNdArCqr2ezoKGRVnmIwx0b8uPrXpt5D7Sm8fItZV/g8Pzk9dq
         r/8AGfFvxDFE9c6sHHnC29x+xi3e3aaR2sdKl0qC2biCc0ZZANuhy41epJfsEivIs7Mf
         4AwfzpfxlA3B2yTu9DiCbv5LDCkrSNQ8NNEEe6jMVCMww8DhFayGe8Zsm1LtABrEftNK
         4A3L2PjZ/AA51yNN7B15Z1wyomTXe519IxvCRu0ME1CkMMFYgW4ieNm5UkFic9bWdcjN
         CCmkWvs+fnfUKqcfNvW7waHY9TxR5gD9HOBCHh5hy930AnRBAHll2M7OlkcQjK0ZN89e
         c5/A==
X-Gm-Message-State: APjAAAXrR0EBWFUKzZcYQWZCf5owt9ZXs+pkyfyzxURVkOuGUxKinoX5
        iFi2EUYaICENl3RkBaOxhi2aaQ==
X-Google-Smtp-Source: APXvYqzfJEF3xFZ5/rqq5W8UFzu+pnUcYDfYX8jpC+6n82Z9f26Uy3hmCFlpfe/NoX/zoYVgExNOmQ==
X-Received: by 2002:a17:902:f30e:: with SMTP id gb14mr7669992plb.32.1565754190678;
        Tue, 13 Aug 2019 20:43:10 -0700 (PDT)
Received: from cakuba.netronome.com (c-71-204-185-212.hsd1.ca.comcast.net. [71.204.185.212])
        by smtp.gmail.com with ESMTPSA id m145sm13257607pfd.68.2019.08.13.20.43.10
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 13 Aug 2019 20:43:10 -0700 (PDT)
Date:   Tue, 13 Aug 2019 20:43:00 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     David Ahern <dsahern@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        johannes.berg@intel.com, edumazet@google.com,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH net] netlink: Fix nlmsg_parse as a wrapper for strict
 message parsing
Message-ID: <20190813204300.1d5abc20@cakuba.netronome.com>
In-Reply-To: <20190812200707.25587-1-dsahern@kernel.org>
References: <20190812200707.25587-1-dsahern@kernel.org>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 12 Aug 2019 13:07:07 -0700, David Ahern wrote:
> From: David Ahern <dsahern@gmail.com>
> 
> Eric reported a syzbot warning:
> 
> BUG: KMSAN: uninit-value in nh_valid_get_del_req+0x6f1/0x8c0 net/ipv4/nexthop.c:1510
> CPU: 0 PID: 11812 Comm: syz-executor444 Not tainted 5.3.0-rc3+ #17
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x191/0x1f0 lib/dump_stack.c:113
>  kmsan_report+0x162/0x2d0 mm/kmsan/kmsan_report.c:109
>  __msan_warning+0x75/0xe0 mm/kmsan/kmsan_instr.c:294
>  nh_valid_get_del_req+0x6f1/0x8c0 net/ipv4/nexthop.c:1510
>  rtm_del_nexthop+0x1b1/0x610 net/ipv4/nexthop.c:1543
>  rtnetlink_rcv_msg+0x115a/0x1580 net/core/rtnetlink.c:5223
>  netlink_rcv_skb+0x431/0x620 net/netlink/af_netlink.c:2477
>  rtnetlink_rcv+0x50/0x60 net/core/rtnetlink.c:5241
>  netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
>  netlink_unicast+0xf6c/0x1050 net/netlink/af_netlink.c:1328
>  netlink_sendmsg+0x110f/0x1330 net/netlink/af_netlink.c:1917
>  sock_sendmsg_nosec net/socket.c:637 [inline]
>  sock_sendmsg net/socket.c:657 [inline]
>  ___sys_sendmsg+0x14ff/0x1590 net/socket.c:2311
>  __sys_sendmmsg+0x53a/0xae0 net/socket.c:2413
>  __do_sys_sendmmsg net/socket.c:2442 [inline]
>  __se_sys_sendmmsg+0xbd/0xe0 net/socket.c:2439
>  __x64_sys_sendmmsg+0x56/0x70 net/socket.c:2439
>  do_syscall_64+0xbc/0xf0 arch/x86/entry/common.c:297
>  entry_SYSCALL_64_after_hwframe+0x63/0xe7
> 
> The root cause is nlmsg_parse calling __nla_parse which means the
> header struct size is not checked.
> 
> nlmsg_parse should be a wrapper around __nlmsg_parse with
> NL_VALIDATE_STRICT for the validate argument very much like
> nlmsg_parse_deprecated is for NL_VALIDATE_LIBERAL.
> 
> Fixes: 3de6440354465 ("netlink: re-add parse/validate functions in strict mode")
> Reported-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Signed-off-by: David Ahern <dsahern@gmail.com>

Applied, thank you!
