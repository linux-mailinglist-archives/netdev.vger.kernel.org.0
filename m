Return-Path: <netdev+bounces-5973-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E21C6713C23
	for <lists+netdev@lfdr.de>; Sun, 28 May 2023 21:05:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 86B24280E74
	for <lists+netdev@lfdr.de>; Sun, 28 May 2023 19:05:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABD185699;
	Sun, 28 May 2023 19:05:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A3B85696
	for <netdev@vger.kernel.org>; Sun, 28 May 2023 19:05:15 +0000 (UTC)
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A2CBC9
	for <netdev@vger.kernel.org>; Sun, 28 May 2023 12:05:14 -0700 (PDT)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-561f23dc55aso39178797b3.3
        for <netdev@vger.kernel.org>; Sun, 28 May 2023 12:05:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1685300713; x=1687892713;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xdghAdi3T00Kyft9s8svVIapNYRXJXXdM2p7L+1Zh+g=;
        b=vW4JkseMOGONzO2QvFuM6Yr4sZuVkY1nTLSuyUhAewgcuK6BrbVTMKQHm0oWoHJPta
         HFTIzoA1JZCzvA2upmqtX/0x7hEdIZq6QZWeDR93fNuvZ5Mndv541pS6ui5rZJTcdIRj
         7yR5hZRuSbeoabcBeC1T8G78J33mCsyVGKRo4MY2JA5R6DS5QBR2Ows7f21kH3s4VVB3
         RzACRVQdyZXFRkTgKvVfYjcIBCrdAy57zgSQFuDNzjuZAzIYB+3L4jfVgD/lJXzKyJ0+
         BxgmEBBNSxOHcIE+3+YEGFP0g8Rld743rEfXsPbLCNOZ42xDPy1fuSYrtsUzg3U40dOW
         j16g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685300713; x=1687892713;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xdghAdi3T00Kyft9s8svVIapNYRXJXXdM2p7L+1Zh+g=;
        b=YQ/XCN+DqEp40wwWz8VC4YMkHKLnzCB755m0r4sS28ppU1qld7uoZyF0/Rx7J6g1SR
         Hb8I3SmTZqxd7LSsfXnOlMg3z311q86CSkAUwZPeQFaL2kyYQQNtLaOmtTUGqWskm2K/
         lXzRb/Vg6AcVCr8eP5abbzwOfD4SPx4x8RLK2icmCED8kTIiKKijS38KrRTKoplhcZCp
         tVi2o0pfKQgYpIvk4tyE3d/EiS4IjMRFMtbK9vIA+n0JjaX8/0syYe2zVcOfu4VE1x6+
         5h5riD7/fuSUoynkRQE0nKlkVRux4qSrqbB1ZFxjIpJek03EZfVbfNqziv14HWj2P1xw
         PTEQ==
X-Gm-Message-State: AC+VfDwgfxm/CWZEXVkjjAerQyv766yqC/REAzfWgi61j3VonAp/txBr
	pgofK15xwgqjE7hQOFkF6uoAajM8nP4GaaFcDmST+A==
X-Google-Smtp-Source: ACHHUZ7mJ3U8udBPelnR8eZ0EsF8dckqgaldgwd97zdtbEwmc1QjlCgRRAKrwiJUiTLeyR0CZ4lU0wlDGxA7Np4nn/s=
X-Received: by 2002:a0d:d750:0:b0:561:e819:f5a9 with SMTP id
 z77-20020a0dd750000000b00561e819f5a9mr8895208ywd.33.1685300713253; Sun, 28
 May 2023 12:05:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230527093747.3583502-1-shaozhengchao@huawei.com>
In-Reply-To: <20230527093747.3583502-1-shaozhengchao@huawei.com>
From: Jamal Hadi Salim <jhs@mojatatu.com>
Date: Sun, 28 May 2023 15:05:02 -0400
Message-ID: <CAM0EoMkrpShprVbWSFN3FpFWtK9494Hyo+mOSNOJmXCFoieN7Q@mail.gmail.com>
Subject: Re: [PATCH net] net: sched: fix NULL pointer dereference in mq_attach
To: Zhengchao Shao <shaozhengchao@huawei.com>
Cc: netdev@vger.kernel.org, xiyou.wangcong@gmail.com, jiri@resnulli.us, 
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, 
	weiyongjun1@huawei.com, yuehaibing@huawei.com, wanghai38@huawei.com, 
	Peilin Ye <yepeilin.cs@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sat, May 27, 2023 at 5:30=E2=80=AFAM Zhengchao Shao <shaozhengchao@huawe=
i.com> wrote:
>
> When use the following command to test:
> 1)ip link add bond0 type bond
> 2)ip link set bond0 up
> 3)tc qdisc add dev bond0 root handle ffff: mq
> 4)tc qdisc replace dev bond0 parent ffff:fff1 handle ffff: mq
>

This is fixed by Peilin in this ongoing discussion:
https://lore.kernel.org/netdev/cover.1684887977.git.peilin.ye@bytedance.com=
/

cheers,
jamal



> The kernel reports NULL pointer dereference issue. The stack information
> is as follows:
> Unable to handle kernel NULL pointer dereference at virtual address 00000=
00000000000
> Internal error: Oops: 0000000096000006 [#1] SMP
> Modules linked in:
> pstate: 20000005 (nzCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=3D--)
> pc : mq_attach+0x44/0xa0
> lr : qdisc_graft+0x20c/0x5cc
> sp : ffff80000e2236a0
> x29: ffff80000e2236a0 x28: ffff0000c0e59d80 x27: ffff0000c0be19c0
> x26: ffff0000cae3e800 x25: 0000000000000010 x24: 00000000fffffff1
> x23: 0000000000000000 x22: ffff0000cae3e800 x21: ffff0000c9df4000
> x20: ffff0000c9df4000 x19: 0000000000000000 x18: ffff80000a934000
> x17: ffff8000f5b56000 x16: ffff80000bb08000 x15: 0000000000000000
> x14: 0000000000000000 x13: 6b6b6b6b6b6b6b6b x12: 6b6b6b6b00000001
> x11: 0000000000000000 x10: 0000000000000000 x9 : 0000000000000000
> x8 : ffff0000c0be0730 x7 : bbbbbbbbbbbbbbbb x6 : 0000000000000008
> x5 : ffff0000cae3e864 x4 : 0000000000000000 x3 : 0000000000000001
> x2 : 0000000000000001 x1 : ffff8000090bc23c x0 : 0000000000000000
> Call trace:
> mq_attach+0x44/0xa0
> qdisc_graft+0x20c/0x5cc
> tc_modify_qdisc+0x1c4/0x664
> rtnetlink_rcv_msg+0x354/0x440
> netlink_rcv_skb+0x64/0x144
> rtnetlink_rcv+0x28/0x34
> netlink_unicast+0x1e8/0x2a4
> netlink_sendmsg+0x308/0x4a0
> sock_sendmsg+0x64/0xac
> ____sys_sendmsg+0x29c/0x358
> ___sys_sendmsg+0x90/0xd0
> __sys_sendmsg+0x7c/0xd0
> __arm64_sys_sendmsg+0x2c/0x38
> invoke_syscall+0x54/0x114
> el0_svc_common.constprop.1+0x90/0x174
> do_el0_svc+0x3c/0xb0
> el0_svc+0x24/0xec
> el0t_64_sync_handler+0x90/0xb4
> el0t_64_sync+0x174/0x178
>
> This is because when mq is added for the first time, qdiscs in mq is set
> to NULL in mq_attach(). Therefore, when replacing mq after adding mq, we
> need to initialize qdiscs in the mq before continuing to graft. Otherwise=
,
> it will couse NULL pointer dereference issue in mq_attach(). And the same
> issue will occur in the attach functions of mqprio, taprio and htb.
> ffff:fff1 means that the repalce qdisc is ingress. Ingress does not allow
> any qdisc to be attached. Therefore, ffff:fff1 is incorrectly used, and
> the command should be dropped.
>
> Fixes: 6ec1c69a8f64 ("net_sched: add classful multiqueue dummy scheduler"=
)
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> ---
>  net/sched/sch_api.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
> index fdb8f429333d..dbc9cf5eea89 100644
> --- a/net/sched/sch_api.c
> +++ b/net/sched/sch_api.c
> @@ -1596,6 +1596,10 @@ static int tc_modify_qdisc(struct sk_buff *skb, st=
ruct nlmsghdr *n,
>                                         NL_SET_ERR_MSG(extack, "Qdisc par=
ent/child loop detected");
>                                         return -ELOOP;
>                                 }
> +                               if (clid =3D=3D TC_H_INGRESS) {
> +                                       NL_SET_ERR_MSG(extack, "Ingress c=
annot graft directly");
> +                                       return -EINVAL;
> +                               }
>                                 qdisc_refcount_inc(q);
>                                 goto graft;
>                         } else {
> --
> 2.34.1
>
>

