Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88B0364F93F
	for <lists+netdev@lfdr.de>; Sat, 17 Dec 2022 15:19:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230343AbiLQOTg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Dec 2022 09:19:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230105AbiLQOTe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Dec 2022 09:19:34 -0500
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1F646438;
        Sat, 17 Dec 2022 06:19:32 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 54B9E5C009C;
        Sat, 17 Dec 2022 09:19:29 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Sat, 17 Dec 2022 09:19:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; t=1671286769; x=1671373169; bh=FhCm8HxPLDjln42vlN0H+PXDjQBE
        kxweI1NmExq07h0=; b=JTQRYHw4XwWOMoWtXWz9oMwwL3UHDZzT9gsEfWhTUFQB
        +sM2VWD8X9U5/mepCIrHcetWS4DkjkyNPeI0mNx4C4sy/mBJsPE3P9yqovjpC1kM
        ikJhztHTm5h5M2eutP+/tQlDZ6pPnLEXQehE9p7Cv31OrfdpZQsfm5VsIRwDE5yi
        sXgjmgg43wMEh2JvCwI+5fe3hyQPDuDende0J8+2C4QmCUjeXHFRuA30cUNbRiTF
        CqMUkf8/7/gMPy4+mTGaCqK0N39ZpXCbV+tk/jvTuGpvo43RMBjxx6cecxgjjNrZ
        Mi5PSCwgISzXdwZam5ns/+0AAU8xzShvdtPKS2kTVw==
X-ME-Sender: <xms:8c-dY0Q543_ZI6zw1X00c_9zaIEvxHrzAP1JFh8kjLcuEQ7J3Vd7rg>
    <xme:8c-dYxyW2KPNIU841xJw9XeWwdFdAtyZVe7tV7VZ8SrEpxNZu1rlBNUPnEjnxHi2G
    XlE511G1pKwsiU>
X-ME-Received: <xmr:8c-dYx1qRfsLj45Zl2jOQyV9iV5ixnpF0fHRT1EI7XkCq8ZljocSX2w1U9MOBrFphO_t-0KjPcKBRhRyO9xZqWoQBPk>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeelgdeivdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenog
    fuuhhsphgvtghtffhomhgrihhnucdlgeelmdenucfjughrpeffhffvvefukfhfgggtuggj
    sehttdertddttddvnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthh
    esihguohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeeufeehteefgfdukeelhfeg
    leeuteehhfelueegveeiveejvdegtdeihfevhfdvgfenucffohhmrghinhepshihiihkrg
    hllhgvrhdrrghpphhsphhothdrtghomhdpkhgvrhhnvghlrdhorhhgpdhgohhoghhlvgdr
    tghomhdpqhgvmhhurdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:8c-dY4Cog5fj-ylcZIrl-5iVwv7vlZSyGfwRzfjEoKd008p2kh-VDg>
    <xmx:8c-dY9iCtV7JziG6K9qD59TaxJ9AYlyyv2SsacVmF62ueCc6FMkMcw>
    <xmx:8c-dY0pi3dbPKaLkQbq3z85fA7Z7xadoVeZjW0ifIU1czUYCTxoZHw>
    <xmx:8c-dY1jfQ8KQM8kx4PbQuIm5LFSVv4W7pD7wFZbK_uFFo_RSghT3QA>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 17 Dec 2022 09:19:28 -0500 (EST)
Date:   Sat, 17 Dec 2022 16:19:24 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Wei Chen <harperchen1110@gmail.com>, johannes.berg@intel.com
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        syzbot <syzkaller@googlegroups.com>
Subject: Re: WARNING in nla_get_range_unsigned
Message-ID: <Y53P7I8Pye41ZDWT@shredder>
References: <CAO4mrffa_3PhjfA9hxTq_U9GjC++0suGnme9oNcKE=Gn+g1iRg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAO4mrffa_3PhjfA9hxTq_U9GjC++0suGnme9oNcKE=Gn+g1iRg@mail.gmail.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 17, 2022 at 05:21:24PM +0800, Wei Chen wrote:
> Dear Linux Developers,
> 
> Recently, when using our tool to fuzz kernel, the following crash was
> triggered. Although this crash has been reported by syzbot
> https://syzkaller.appspot.com/bug?id=32e20c07949c6d6006f26466022469e33ae69108
> and fixed in commit netlink: policy: correct validation type check
> <https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=c30a3c957c885e618ddffc065f888be4f8d5a9bd>,
> it still happens in the latest kernel version.
> 
> HEAD commit:  76dcd734eca
> git tree: linux-next
> compiler: clang 12.0.0
> console output:
> https://drive.google.com/file/d/1reeOfFkfJp4-GUz_uMTh-uWXPLBJDcA6/view?usp=share_link
> kernel config:
> https://drive.google.com/file/d/1jH4qV5XblPADvMDUlvS7DwtW0FroMoVB/view?usp=share_link
> syz repro:
> https://drive.google.com/file/d/1Ong8vQn675RFU7R1O5HfiwWxp4UhnaIF/view?usp=share_link

Can be reproduced with:

# tc action add mpls push label 3

Assuming you patch iproute2 to encode a wrong label length. For example:

diff --git a/tc/m_mpls.c b/tc/m_mpls.c
index 9b39d8533c21..2a43ca6c4dd3 100644
--- a/tc/m_mpls.c
+++ b/tc/m_mpls.c
@@ -191,7 +191,7 @@ static int parse_mpls(struct action_util *a, int *argc_p, char ***argv_p,
 	tail = addattr_nest(n, MAX_MSG, tca_id | NLA_F_NESTED);
 	addattr_l(n, MAX_MSG, TCA_MPLS_PARMS, &parm, sizeof(parm));
 	if (label != 0xffffffff)
-		addattr_l(n, MAX_MSG, TCA_MPLS_LABEL, &label, sizeof(label));
+		addattr_l(n, MAX_MSG, TCA_MPLS_LABEL, &label, 8);
 	if (proto)
 		addattr_l(n, MAX_MSG, TCA_MPLS_PROTO, &proto, sizeof(proto));
 	if (tc != 0xff)

It does not seem valid to use NLA_POLICY_VALIDATE_FN() without
NLA_BINARY. Fixed for me by:

diff --git a/net/sched/act_mpls.c b/net/sched/act_mpls.c
index ff47ce4d3968..6b26bdb999d7 100644
--- a/net/sched/act_mpls.c
+++ b/net/sched/act_mpls.c
@@ -134,6 +134,11 @@ static int valid_label(const struct nlattr *attr,
 {
 	const u32 *label = nla_data(attr);
 
+	if (nla_len(attr) != sizeof(*label)) {
+		NL_SET_ERR_MSG_MOD(extack, "Invalid MPLS label length");
+		return -EINVAL;
+	}
+
 	if (*label & ~MPLS_LABEL_MASK || *label == MPLS_LABEL_IMPLNULL) {
 		NL_SET_ERR_MSG_MOD(extack, "MPLS label out of range");
 		return -EINVAL;
@@ -145,7 +150,8 @@ static int valid_label(const struct nlattr *attr,
 static const struct nla_policy mpls_policy[TCA_MPLS_MAX + 1] = {
 	[TCA_MPLS_PARMS]	= NLA_POLICY_EXACT_LEN(sizeof(struct tc_mpls)),
 	[TCA_MPLS_PROTO]	= { .type = NLA_U16 },
-	[TCA_MPLS_LABEL]	= NLA_POLICY_VALIDATE_FN(NLA_U32, valid_label),
+	[TCA_MPLS_LABEL]	= NLA_POLICY_VALIDATE_FN(NLA_BINARY,
+							 valid_label),
 	[TCA_MPLS_TC]		= NLA_POLICY_RANGE(NLA_U8, 0, 7),
 	[TCA_MPLS_TTL]		= NLA_POLICY_MIN(NLA_U8, 1),
 	[TCA_MPLS_BOS]		= NLA_POLICY_RANGE(NLA_U8, 0, 1),

But please test with your reproducer as well.

For net-next we can try to remove the first argument from
NLA_POLICY_VALIDATE_FN() and set NLA_BINARY which is what everyone is
passing anyway.

Adding Johannes in case he has a better idea.

> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: Wei Chen <harperchen1110@gmail.com>
> 
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 17743 at lib/nlattr.c:118
> nla_get_range_unsigned+0x1d8/0x1e0 lib/nlattr.c:117
> Modules linked in:
> CPU: 0 PID: 17743 Comm: syz-executor.0 Not tainted 6.1.0-rc8 #3
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
> rel-1.13.0-48-gd9c812dda519-prebuilt.qemu.org 04/01/2014
> RIP: 0010:nla_get_range_unsigned+0x1d8/0x1e0 lib/nlattr.c:117
> Code: 8d ff 49 8b 75 08 ba 10 00 00 00 4c 89 f7 e8 0f d8 f8 02 5b 41 5c 41
> 5d 41 5e 41 5f 5d c3 e8 0f 57 7a ff eb 05 e8 08 57 7a ff <0f> 0b e9 a9 fe
> ff ff 90 55 41 57 41 56 41 54 53 49 89 f6 49 89 fc
> RSP: 0018:ffffc90002df39b8 EFLAGS: 00010287
> RAX: ffffffff81ad2f51 RBX: ffffffff85364d28 RCX: 0000000000040000
> RDX: ffffc90000add000 RSI: 0000000000000268 RDI: 0000000000000269
> RBP: 000000000000f940 R08: ffffffff81ad2dd8 R09: 0000000000000000
> R10: 0001ffffffffffff R11: ffff888045136780 R12: ffff88803e174000
> R13: ffffffff85364d20 R14: ffffc90002df3a30 R15: ffffffff85364d21
> FS:  00007fab1e5c8700(0000) GS:ffff88807dc00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000000000073f8d0 CR3: 000000004a789000 CR4: 00000000003506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
> Call Trace:
>  <TASK>
>  __netlink_policy_dump_write_attr+0x23d/0x990 net/netlink/policy.c:310
>  netlink_policy_dump_write_attr+0x22/0x30 net/netlink/policy.c:411
>  netlink_ack_tlv_fill net/netlink/af_netlink.c:2454 [inline]
>  netlink_ack+0x546/0x760 net/netlink/af_netlink.c:2506
>  netlink_rcv_skb+0x1b7/0x240 net/netlink/af_netlink.c:2546
>  rtnetlink_rcv+0x18/0x20 net/core/rtnetlink.c:6109
>  netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
>  netlink_unicast+0x5e9/0x6b0 net/netlink/af_netlink.c:1345
>  netlink_sendmsg+0x739/0x860 net/netlink/af_netlink.c:1921
>  sock_sendmsg_nosec net/socket.c:714 [inline]
>  sock_sendmsg net/socket.c:734 [inline]
>  ____sys_sendmsg+0x38f/0x500 net/socket.c:2482
>  ___sys_sendmsg net/socket.c:2536 [inline]
>  __sys_sendmsg+0x197/0x230 net/socket.c:2565
>  __do_sys_sendmsg net/socket.c:2574 [inline]
>  __se_sys_sendmsg net/socket.c:2572 [inline]
>  __x64_sys_sendmsg+0x42/0x50 net/socket.c:2572
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x2b/0x70 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> RIP: 0033:0x4697f9
> Code: f7 d8 64 89 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 48 89 f8 48 89 f7
> 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff
> ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fab1e5c7c48 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 000000000077bf80 RCX: 00000000004697f9
> RDX: 0000000000000000 RSI: 0000000020000000 RDI: 0000000000000003
> RBP: 00000000004d29e9 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 000000000077bf80
> R13: 0000000000000000 R14: 000000000077bf80 R15: 00007ffd7c0e6920
>  </TASK>
> ---[ end trace 0000000000000000 ]---
> 
> Best,
> Wei
> 
> -- 
> You received this message because you are subscribed to the Google Groups "syzkaller" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller/CAO4mrffa_3PhjfA9hxTq_U9GjC%2B%2B0suGnme9oNcKE%3DGn%2Bg1iRg%40mail.gmail.com.
