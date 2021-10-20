Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A37B34353C4
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 21:25:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231596AbhJTT1P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 15:27:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231360AbhJTT1O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 15:27:14 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB2ACC061749
        for <netdev@vger.kernel.org>; Wed, 20 Oct 2021 12:24:59 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id x1so26007989iof.7
        for <netdev@vger.kernel.org>; Wed, 20 Oct 2021 12:24:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sargun.me; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=j4BWqaRoOXX4hAkcrJT/f3tGF68yRFTv/w2sc+SKXvc=;
        b=RN81ylp+B4t8iEpsk9tiQvrF24QGy5e9a5pZLGwVNNMKGg7b3HVBLX59XxW5NImwFP
         791CDv6JKUIqiyv/vyHwBfX1MQufRqPh6ihcZ2CWBZkuBrVduB1AbRUKe7L0hJgMuNZC
         wuemNqtS7LxxgAxfS68999eM5pD5/4GE3AaZ0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=j4BWqaRoOXX4hAkcrJT/f3tGF68yRFTv/w2sc+SKXvc=;
        b=DkvzzgK59k0GtKia2PscZi1oosmgza/rNulA5Fm4Rwy1R681GuD6XbPsTbz5zpbxpY
         QOTxs9MEil97CfmFmHINyHHLWXZSzIyUvgScXtMe8TLr3K1Itl3LRWtL6z8uYnPjk1bL
         Kwt6SBv4+vgO49xLKRbecLsbX4ydAJV6z08rm0yxtuJiYZxUQWWBNAkA4N0/O5TdbK2a
         LhRI+1ytjtqsNfhuIQ+bsrEBFamhFDviqDaYlQO5DG6E8jeno2l98K74w3FL8b+qC0W5
         LIMhkC2yuX07RAH5CacBufwc7r1TFUxAASRYFqqiCTVvjXnL+Y/rM+OHv0fd+HnYCvww
         8M7g==
X-Gm-Message-State: AOAM530Os1RxXF42UVbArAPrgvXZE/tMy/RZDvKV3d/F3VdslCZjEUOK
        VD7MpAPUSLs+rzVA4w/FJARMWwSH4icVzg==
X-Google-Smtp-Source: ABdhPJzPNmXj9qRz5w/z9fK91UgdGlWjPFSGN7oeQcyao7shhiGtU2yE/U6Xo7KpRncRXCvIs+rGlQ==
X-Received: by 2002:a05:6602:1799:: with SMTP id y25mr776711iox.38.1634757899128;
        Wed, 20 Oct 2021 12:24:59 -0700 (PDT)
Received: from ircssh-2.c.rugged-nimbus-611.internal (80.60.198.104.bc.googleusercontent.com. [104.198.60.80])
        by smtp.gmail.com with ESMTPSA id m7sm1559987iov.30.2021.10.20.12.24.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 20 Oct 2021 12:24:58 -0700 (PDT)
Date:   Wed, 20 Oct 2021 19:24:57 +0000
From:   Sargun Dhillon <sargun@sargun.me>
To:     Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: Re: Retrieving the network namespace of a socket
Message-ID: <20211020192456.GA23489@ircssh-2.c.rugged-nimbus-611.internal>
References: <20211020095707.GA16295@ircssh-2.c.rugged-nimbus-611.internal>
 <CAHNKnsRFah6MRxECTLNwu+maN0o9jS9ENzSAiWS4v1247BqYdg@mail.gmail.com>
 <20211020163417.GA21040@ircssh-2.c.rugged-nimbus-611.internal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211020163417.GA21040@ircssh-2.c.rugged-nimbus-611.internal>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 20, 2021 at 04:34:18PM +0000, Sargun Dhillon wrote:
> On Wed, Oct 20, 2021 at 05:03:56PM +0300, Sergey Ryazanov wrote:
> > Hello Sargun,
> > 
> > On Wed, Oct 20, 2021 at 12:57 PM Sargun Dhillon <sargun@sargun.me> wrote:
> > > I'm working on a problem where I need to determine which network namespace a
> > > given socket is in. I can currently bruteforce this by using INET_DIAG, and
> > > enumerating namespaces and working backwards.
> > 
> > Namespace is not a per-socket, but a per-process attribute. So each
> > socket of a process belongs to the same namespace.
> > 
> > Could you elaborate what kind of problem you are trying to solve?
> > Maybe there is a more simple solution. for it.
> > 
> > -- 
> > Sergey
> 
> That's not entirely true. See the folowing code:
> 
> int main() {
> 	int fd1, fd2;
> 	fd1 = socket(AF_INET, SOCK_STREAM, 0);
> 	assert(fd1 >= 0);
> 	assert(unshare(CLONE_NEWNET) == 0);
> 	fd2 = socket(AF_INET, SOCK_STREAM, 0);
> 	assert(fd2 >= 0);
> }
> 
> fd1 and fd2 have different sock_net.
> 
> The context for this is:
> https://linuxplumbersconf.org/event/11/contributions/932/
> 
> We need to figure out, for a given socket, if it has reachability to a given IP.

So, I was lazy / misread documentation. It turns out SIOCGSKNS does exactly
what I need.

Nonetheless, it's a little weird and awkward that it is exists. I was wondering
if this functionality made sense as part of kcmp. I wrote up a quick patch
to see if anyone was interested:

diff --git a/include/uapi/linux/kcmp.h b/include/uapi/linux/kcmp.h
index ef1305010925..d6b9c3923d20 100644
--- a/include/uapi/linux/kcmp.h
+++ b/include/uapi/linux/kcmp.h
@@ -14,6 +14,7 @@ enum kcmp_type {
 	KCMP_IO,
 	KCMP_SYSVSEM,
 	KCMP_EPOLL_TFD,
+	KCMP_NETNS,
 
 	KCMP_TYPES,
 };
diff --git a/kernel/kcmp.c b/kernel/kcmp.c
index 5353edfad8e1..8fadae4b588f 100644
--- a/kernel/kcmp.c
+++ b/kernel/kcmp.c
@@ -18,6 +18,8 @@
 #include <linux/file.h>
 
 #include <asm/unistd.h>
+#include <net/net_namespace.h>
+#include <net/sock.h>
 
 /*
  * We don't expose the real in-memory order of objects for security reasons.
@@ -132,6 +134,58 @@ static int kcmp_epoll_target(struct task_struct *task1,
 }
 #endif
 
+#ifdef CONFIG_NET
+static int __kcmp_netns_target(struct task_struct *task1,
+			       struct task_struct *task2,
+			       struct file *filp1,
+			       struct file *filp2)
+{
+	struct socket *sock1, *sock2;
+	struct net *net1, *net2;
+
+	sock1 = sock_from_file(filp1);
+	sock2 = sock_from_file(filp1);
+	if (!sock1 || !sock2)
+		return -ENOTSOCK;
+
+	net1 = sock_net(sock1->sk);
+	net2 = sock_net(sock2->sk);
+
+	return kcmp_ptr(net1, net2, KCMP_NETNS);
+}
+
+static int kcmp_netns_target(struct task_struct *task1,
+			     struct task_struct *task2,
+			     unsigned long idx1,
+			     unsigned long idx2)
+{
+	struct file *filp1, *filp2;
+
+	int ret = -EBADF;
+
+	filp1 = fget_task(task1, idx1);
+	if (filp1) {
+		filp2 = fget_task(task2, idx2);
+		if (filp2) {
+			ret = __kcmp_netns_target(task1, task2, filp1, filp2);
+			fput(filp2);
+		}
+
+		fput(filp1);
+	}
+
+	return ret;
+}
+#else
+static int kcmp_netns_target(struct task_struct *task1,
+			     struct task_struct *task2,
+			     unsigned long idx1,
+			     unsigned long idx2)
+{
+	return -EOPNOTSUPP;
+}
+#endif
+
 SYSCALL_DEFINE5(kcmp, pid_t, pid1, pid_t, pid2, int, type,
 		unsigned long, idx1, unsigned long, idx2)
 {
@@ -206,6 +260,9 @@ SYSCALL_DEFINE5(kcmp, pid_t, pid1, pid_t, pid2, int, type,
 	case KCMP_EPOLL_TFD:
 		ret = kcmp_epoll_target(task1, task2, idx1, (void *)idx2);
 		break;
+	case KCMP_NETNS:
+		ret = kcmp_netns_target(task1, task2, idx1, idx2);
+		break;
 	default:
 		ret = -EINVAL;
 		break;

