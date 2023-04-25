Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D87026EE1AD
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 14:13:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233721AbjDYMNf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 08:13:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbjDYMNe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 08:13:34 -0400
Received: from wout4-smtp.messagingengine.com (wout4-smtp.messagingengine.com [64.147.123.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF5624EF1
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 05:13:32 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 5E18C3200910;
        Tue, 25 Apr 2023 08:13:31 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 25 Apr 2023 08:13:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1682424810; x=1682511210; bh=9BZvCK4G0sRH0
        g3gsHX2zmFTCGlmLB+kLxoaW26S71g=; b=B1pdybHdRtqlZNGVxRIfoXWtCJvwI
        uABjj2dfbmq2+ZhkG6sQULgj6zUpvoHFM+SY/2bcJU0Xh3/6Dop2ZtYZ4WpSA027
        s4M48TejLbq6AAw8/4jlpEUxBYVSLVYC5cXVlwOykikWV3cg0UhlvQ6Llsix/VqM
        +DkKhmtRwI/XzTZncr6FB0rOlcXCdJUBgpvOY8RI+kBDzeATEUlWaYHBirixcVeS
        tO37mBOxwtHNm3QQWFYgNF6B/m9SA2LGfvVi8bxmdX2ZRpE6MRhCtrYnGq31WZKH
        6M7pfKoMg0EIUQaPWaZibROHizEP0vEBLSwiobUXjpnu9Mvma/ZV0FQRg==
X-ME-Sender: <xms:6sNHZCHv6_u8T2lkmriq7lZK8WD0EtWXIlELTUNsorWusq87-i6EEA>
    <xme:6sNHZDWTrpSc_ac8H2l26Pmj3v_CsVttiZiNb5pVG7xufQmNp8QcPEs02KBfd2ZXM
    0ysHbv9dYhDBRw>
X-ME-Received: <xmr:6sNHZMKj0si05cqjSPJxsF54l5v1gw1xseQOTPupSGQXZl8_PyV0QC5WRZabGOHDhEg26jTNZqKsICNA8lNDOFR74zc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeduvddggeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnhephfffjeeghfejheejveehvefhteevveefgfeuudeuiedvieejiefhgeehleej
    gfeunecuffhomhgrihhnpehgihhthhhusgdrtghomhenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:6sNHZMFxizjZtB4bc5VRYUWpJjrsohF8ZkLoWNXuSmqTOStX8RfAYA>
    <xmx:6sNHZIWZwtOiP6pdItMmfILVBmd9zKML5GRkl3cpzX7veRsqL1ZMWA>
    <xmx:6sNHZPN3S11osEudzUlpjqPF92b8kJ6ylK48t-iUlZUnc6lCDyMlng>
    <xmx:6sNHZLFU56M0lGiYC6jBKgj9DYlGP1I6Vc1mQlbA5FGl3JkFjFB-jw>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 25 Apr 2023 08:13:29 -0400 (EDT)
Date:   Tue, 25 Apr 2023 15:13:25 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Pedro Tammela <pctammela@mojatatu.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, simon.horman@corigine.com
Subject: Re: [PATCH net-next v5 3/5] net/sched: act_pedit: check static
 offsets a priori
Message-ID: <ZEfD5e1MI+LUZVau@shredder>
References: <20230421212516.406726-1-pctammela@mojatatu.com>
 <20230421212516.406726-4-pctammela@mojatatu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230421212516.406726-4-pctammela@mojatatu.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 21, 2023 at 06:25:15PM -0300, Pedro Tammela wrote:
> diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
> index 24976cd4e4a2..cc4dfb01c6c7 100644
> --- a/net/sched/act_pedit.c
> +++ b/net/sched/act_pedit.c
> @@ -251,8 +251,16 @@ static int tcf_pedit_init(struct net *net, struct nlattr *nla,
>  	memcpy(nparms->tcfp_keys, parm->keys, ksize);
>  
>  	for (i = 0; i < nparms->tcfp_nkeys; ++i) {
> +		u32 offmask = nparms->tcfp_keys[i].offmask;
>  		u32 cur = nparms->tcfp_keys[i].off;
>  
> +		/* The AT option can be added to static offsets in the datapath */
> +		if (!offmask && cur % 4) {
> +			NL_SET_ERR_MSG_MOD(extack, "Offsets must be on 32bit boundaries");
> +			ret = -EINVAL;
> +			goto put_chain;

I think this leaks 'nparms->tcfp_keys'. See full syzkaller report here
[1].

> +		}
> +
>  		/* sanitize the shift value for any later use */
>  		nparms->tcfp_keys[i].shift = min_t(size_t,
>  						   BITS_PER_TYPE(int) - 1,

[1]
Syzkaller hit 'memory leak in tcf_pedit_init' bug.

BUG: memory leak
unreferenced object 0xffff88803d45e400 (size 1024):
  comm "syz-executor292", pid 563, jiffies 4295025223 (age 51.781s)
  hex dump (first 32 bytes):
    28 bd 70 00 fb db df 25 02 00 14 1f ff 02 00 02  (.p....%........
    00 32 00 00 1f 00 00 00 ac 14 14 3e 08 00 07 00  .2.........>....
  backtrace:
    [<ffffffff81bd0f2c>] kmemleak_alloc_recursive include/linux/kmemleak.h:42 [inline]
    [<ffffffff81bd0f2c>] slab_post_alloc_hook mm/slab.h:772 [inline]
    [<ffffffff81bd0f2c>] slab_alloc_node mm/slub.c:3452 [inline]
    [<ffffffff81bd0f2c>] __kmem_cache_alloc_node+0x25c/0x320 mm/slub.c:3491
    [<ffffffff81a865d9>] __do_kmalloc_node mm/slab_common.c:966 [inline]
    [<ffffffff81a865d9>] __kmalloc+0x59/0x1a0 mm/slab_common.c:980
    [<ffffffff83aa85c3>] kmalloc include/linux/slab.h:584 [inline]
    [<ffffffff83aa85c3>] tcf_pedit_init+0x793/0x1ae0 net/sched/act_pedit.c:245
    [<ffffffff83a90623>] tcf_action_init_1+0x453/0x6e0 net/sched/act_api.c:1394
    [<ffffffff83a90e58>] tcf_action_init+0x5a8/0x950 net/sched/act_api.c:1459
    [<ffffffff83a96258>] tcf_action_add+0x118/0x4e0 net/sched/act_api.c:1985
    [<ffffffff83a96997>] tc_ctl_action+0x377/0x490 net/sched/act_api.c:2044
    [<ffffffff83920a8d>] rtnetlink_rcv_msg+0x46d/0xd70 net/core/rtnetlink.c:6395
    [<ffffffff83b24305>] netlink_rcv_skb+0x185/0x490 net/netlink/af_netlink.c:2575
    [<ffffffff83901806>] rtnetlink_rcv+0x26/0x30 net/core/rtnetlink.c:6413
    [<ffffffff83b21cae>] netlink_unicast_kernel net/netlink/af_netlink.c:1339 [inline]
    [<ffffffff83b21cae>] netlink_unicast+0x5be/0x8a0 net/netlink/af_netlink.c:1365
    [<ffffffff83b2293f>] netlink_sendmsg+0x9af/0xed0 net/netlink/af_netlink.c:1942
    [<ffffffff8380c39f>] sock_sendmsg_nosec net/socket.c:724 [inline]
    [<ffffffff8380c39f>] sock_sendmsg net/socket.c:747 [inline]
    [<ffffffff8380c39f>] ____sys_sendmsg+0x3ef/0xaa0 net/socket.c:2503
    [<ffffffff838156d2>] ___sys_sendmsg+0x122/0x1c0 net/socket.c:2557
    [<ffffffff8381594f>] __sys_sendmsg+0x11f/0x200 net/socket.c:2586
    [<ffffffff83815ab0>] __do_sys_sendmsg net/socket.c:2595 [inline]
    [<ffffffff83815ab0>] __se_sys_sendmsg net/socket.c:2593 [inline]
    [<ffffffff83815ab0>] __x64_sys_sendmsg+0x80/0xc0 net/socket.c:2593



Syzkaller reproducer:
# {Threaded:false Repeat:true RepeatTimes:0 Procs:1 Slowdown:1 Sandbox: SandboxArg:0 Leak:true NetInjection:false NetDevices:false NetReset:false Cgroups:false BinfmtMisc:false CloseFDs:false KCSAN:false DevlinkPCI:false NicVF:false USB:false VhciInjection:false Wifi:false IEEE802154:false Sysctl:false UseTmpDir:false HandleSegv:false Repro:false Trace:false LegacyOptions:{Collide:false Fault:false FaultCall:0 FaultNth:0}}
r0 = socket$nl_route(0x10, 0x3, 0x0)
sendmsg$nl_route(r0, &(0x7f0000000200)={0x0, 0x0, &(0x7f00000001c0)={&(0x7f0000000100)=@ipv4_delroute={0x58, 0x19, 0x300, 0x70bd28, 0x25dfdbfb, {0x2, 0x0, 0x14, 0x1f, 0xff, 0x2, 0x0, 0x2, 0x3200}, [@RTA_PREFSRC={0x8, 0x7, @dev={0xac, 0x14, 0x14, 0x3e}}, @RTA_PREFSRC={0x8, 0x7, @initdev={0xac, 0x1e, 0x0, 0x0}}, @RTA_SPORT={0x6, 0x1c, 0x4e20}, @RTA_TABLE={0x8, 0xf, 0x368}, @RTA_PREFSRC={0x8, 0x7, @remote}, @RTA_TABLE={0x8, 0xf, 0xa2}, @RTA_METRICS={0x4}, @RTA_IIF={0x8}]}, 0x58}, 0x1, 0x0, 0x0, 0x4000040}, 0x80)
sendmsg$nl_route_sched(r0, &(0x7f0000000040)={0x0, 0x0, &(0x7f0000000080)={&(0x7f00000000c0)=ANY=[@ANYBLOB="601d0000300009000000000000000000000000004c1d0100481d01000a00010070656469740000001c1d0280c80e04"], 0x1d60}}, 0x0)


C reproducer:
// autogenerated by syzkaller (https://github.com/google/syzkaller)

#define _GNU_SOURCE 

#include <dirent.h>
#include <endian.h>
#include <errno.h>
#include <fcntl.h>
#include <signal.h>
#include <stdarg.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/prctl.h>
#include <sys/stat.h>
#include <sys/syscall.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <time.h>
#include <unistd.h>

static void sleep_ms(uint64_t ms)
{
	usleep(ms * 1000);
}

static uint64_t current_time_ms(void)
{
	struct timespec ts;
	if (clock_gettime(CLOCK_MONOTONIC, &ts))
	exit(1);
	return (uint64_t)ts.tv_sec * 1000 + (uint64_t)ts.tv_nsec / 1000000;
}

#define BITMASK(bf_off,bf_len) (((1ull << (bf_len)) - 1) << (bf_off))
#define STORE_BY_BITMASK(type,htobe,addr,val,bf_off,bf_len) *(type*)(addr) = htobe((htobe(*(type*)(addr)) & ~BITMASK((bf_off), (bf_len))) | (((type)(val) << (bf_off)) & BITMASK((bf_off), (bf_len))))

static bool write_file(const char* file, const char* what, ...)
{
	char buf[1024];
	va_list args;
	va_start(args, what);
	vsnprintf(buf, sizeof(buf), what, args);
	va_end(args);
	buf[sizeof(buf) - 1] = 0;
	int len = strlen(buf);
	int fd = open(file, O_WRONLY | O_CLOEXEC);
	if (fd == -1)
		return false;
	if (write(fd, buf, len) != len) {
		int err = errno;
		close(fd);
		errno = err;
		return false;
	}
	close(fd);
	return true;
}

static void kill_and_wait(int pid, int* status)
{
	kill(-pid, SIGKILL);
	kill(pid, SIGKILL);
	for (int i = 0; i < 100; i++) {
		if (waitpid(-1, status, WNOHANG | __WALL) == pid)
			return;
		usleep(1000);
	}
	DIR* dir = opendir("/sys/fs/fuse/connections");
	if (dir) {
		for (;;) {
			struct dirent* ent = readdir(dir);
			if (!ent)
				break;
			if (strcmp(ent->d_name, ".") == 0 || strcmp(ent->d_name, "..") == 0)
				continue;
			char abort[300];
			snprintf(abort, sizeof(abort), "/sys/fs/fuse/connections/%s/abort", ent->d_name);
			int fd = open(abort, O_WRONLY);
			if (fd == -1) {
				continue;
			}
			if (write(fd, abort, 1) < 0) {
			}
			close(fd);
		}
		closedir(dir);
	} else {
	}
	while (waitpid(-1, status, __WALL) != pid) {
	}
}

static void setup_test()
{
	prctl(PR_SET_PDEATHSIG, SIGKILL, 0, 0, 0);
	setpgrp();
	write_file("/proc/self/oom_score_adj", "1000");
}

#define KMEMLEAK_FILE "/sys/kernel/debug/kmemleak"

static void setup_leak()
{
	if (!write_file(KMEMLEAK_FILE, "scan"))
	exit(1);
	sleep(5);
	if (!write_file(KMEMLEAK_FILE, "scan"))
	exit(1);
	if (!write_file(KMEMLEAK_FILE, "clear"))
	exit(1);
}

static void check_leaks(void)
{
	int fd = open(KMEMLEAK_FILE, O_RDWR);
	if (fd == -1)
	exit(1);
	uint64_t start = current_time_ms();
	if (write(fd, "scan", 4) != 4)
	exit(1);
	sleep(1);
	while (current_time_ms() - start < 4 * 1000)
		sleep(1);
	if (write(fd, "scan", 4) != 4)
	exit(1);
	static char buf[128 << 10];
	ssize_t n = read(fd, buf, sizeof(buf) - 1);
	if (n < 0)
	exit(1);
	int nleaks = 0;
	if (n != 0) {
		sleep(1);
		if (write(fd, "scan", 4) != 4)
	exit(1);
		if (lseek(fd, 0, SEEK_SET) < 0)
	exit(1);
		n = read(fd, buf, sizeof(buf) - 1);
		if (n < 0)
	exit(1);
		buf[n] = 0;
		char* pos = buf;
		char* end = buf + n;
		while (pos < end) {
			char* next = strstr(pos + 1, "unreferenced object");
			if (!next)
				next = end;
			char prev = *next;
			*next = 0;
			fprintf(stderr, "BUG: memory leak\n%s\n", pos);
			*next = prev;
			pos = next;
			nleaks++;
		}
	}
	if (write(fd, "clear", 5) != 5)
	exit(1);
	close(fd);
	if (nleaks)
		exit(1);
}

static void execute_one(void);

#define WAIT_FLAGS __WALL

static void loop(void)
{
	int iter = 0;
	for (;; iter++) {
		int pid = fork();
		if (pid < 0)
	exit(1);
		if (pid == 0) {
			setup_test();
			execute_one();
			exit(0);
		}
		int status = 0;
		uint64_t start = current_time_ms();
		for (;;) {
			if (waitpid(-1, &status, WNOHANG | WAIT_FLAGS) == pid)
				break;
			sleep_ms(1);
			if (current_time_ms() - start < 5000)
				continue;
			kill_and_wait(pid, &status);
			break;
		}
		check_leaks();
	}
}

uint64_t r[1] = {0xffffffffffffffff};

void execute_one(void)
{
		intptr_t res = 0;
	res = syscall(__NR_socket, 0x10ul, 3ul, 0);
	if (res != -1)
		r[0] = res;
*(uint64_t*)0x20000200 = 0;
*(uint32_t*)0x20000208 = 0;
*(uint64_t*)0x20000210 = 0x200001c0;
*(uint64_t*)0x200001c0 = 0x20000100;
*(uint32_t*)0x20000100 = 0x58;
*(uint16_t*)0x20000104 = 0x19;
*(uint16_t*)0x20000106 = 0x300;
*(uint32_t*)0x20000108 = 0x70bd28;
*(uint32_t*)0x2000010c = 0x25dfdbfb;
*(uint8_t*)0x20000110 = 2;
*(uint8_t*)0x20000111 = 0;
*(uint8_t*)0x20000112 = 0x14;
*(uint8_t*)0x20000113 = 0x1f;
*(uint8_t*)0x20000114 = -1;
*(uint8_t*)0x20000115 = 2;
*(uint8_t*)0x20000116 = 0;
*(uint8_t*)0x20000117 = 2;
*(uint32_t*)0x20000118 = 0x3200;
*(uint16_t*)0x2000011c = 8;
*(uint16_t*)0x2000011e = 7;
*(uint8_t*)0x20000120 = 0xac;
*(uint8_t*)0x20000121 = 0x14;
*(uint8_t*)0x20000122 = 0x14;
*(uint8_t*)0x20000123 = 0x3e;
*(uint16_t*)0x20000124 = 8;
*(uint16_t*)0x20000126 = 7;
*(uint8_t*)0x20000128 = 0xac;
*(uint8_t*)0x20000129 = 0x1e;
*(uint8_t*)0x2000012a = 0;
*(uint8_t*)0x2000012b = 1;
*(uint16_t*)0x2000012c = 6;
*(uint16_t*)0x2000012e = 0x1c;
*(uint16_t*)0x20000130 = htobe16(0x4e20);
*(uint16_t*)0x20000134 = 8;
*(uint16_t*)0x20000136 = 0xf;
*(uint32_t*)0x20000138 = 0x368;
*(uint16_t*)0x2000013c = 8;
*(uint16_t*)0x2000013e = 7;
*(uint8_t*)0x20000140 = 0xac;
*(uint8_t*)0x20000141 = 0x14;
*(uint8_t*)0x20000142 = 0x14;
*(uint8_t*)0x20000143 = 0xbb;
*(uint16_t*)0x20000144 = 8;
*(uint16_t*)0x20000146 = 0xf;
*(uint32_t*)0x20000148 = 0xa2;
*(uint16_t*)0x2000014c = 4;
STORE_BY_BITMASK(uint16_t, , 0x2000014e, 8, 0, 14);
STORE_BY_BITMASK(uint16_t, , 0x2000014f, 0, 6, 1);
STORE_BY_BITMASK(uint16_t, , 0x2000014f, 1, 7, 1);
*(uint16_t*)0x20000150 = 8;
*(uint16_t*)0x20000152 = 3;
*(uint32_t*)0x20000154 = 0;
*(uint64_t*)0x200001c8 = 0x58;
*(uint64_t*)0x20000218 = 1;
*(uint64_t*)0x20000220 = 0;
*(uint64_t*)0x20000228 = 0;
*(uint32_t*)0x20000230 = 0x4000040;
	syscall(__NR_sendmsg, r[0], 0x20000200ul, 0x80ul);
*(uint64_t*)0x20000040 = 0;
*(uint32_t*)0x20000048 = 0;
*(uint64_t*)0x20000050 = 0x20000080;
*(uint64_t*)0x20000080 = 0x200000c0;
memcpy((void*)0x200000c0, "\x60\x1d\x00\x00\x30\x00\x09\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x4c\x1d\x01\x00\x48\x1d\x01\x00\x0a\x00\x01\x00\x70\x65\x64\x69\x74\x00\x00\x00\x1c\x1d\x02\x80\xc8\x0e\x04", 47);
*(uint64_t*)0x20000088 = 0x1d60;
*(uint64_t*)0x20000058 = 1;
*(uint64_t*)0x20000060 = 0;
*(uint64_t*)0x20000068 = 0;
*(uint32_t*)0x20000070 = 0;
	syscall(__NR_sendmsg, r[0], 0x20000040ul, 0ul);

}
int main(void)
{
		syscall(__NR_mmap, 0x1ffff000ul, 0x1000ul, 0ul, 0x32ul, -1, 0ul);
	syscall(__NR_mmap, 0x20000000ul, 0x1000000ul, 7ul, 0x32ul, -1, 0ul);
	syscall(__NR_mmap, 0x21000000ul, 0x1000ul, 0ul, 0x32ul, -1, 0ul);
	setup_leak();
			loop();
	return 0;
}
