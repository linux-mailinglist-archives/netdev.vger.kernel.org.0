Return-Path: <netdev+bounces-6198-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DF7437152D2
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 03:07:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 991DE280FF3
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 01:07:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83C98802;
	Tue, 30 May 2023 01:07:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72C28636
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 01:07:20 +0000 (UTC)
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6BFE9D
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 18:07:18 -0700 (PDT)
Received: by mail-qt1-x836.google.com with SMTP id d75a77b69052e-3f6b20ad49dso20695901cf.2
        for <netdev@vger.kernel.org>; Mon, 29 May 2023 18:07:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685408838; x=1688000838;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PoJBaff3peUbCldP9t/dhi1yxO4Hc9aEHcWsA/KdA/w=;
        b=DncmR/y/H5Rxr/oG3ncZkmAsVPhUbm3d0cDCmU/0Q9D97d8NkOszy3WKyEO1ZiYCWs
         2NzI6kVodOFjGfBm9X8Wvsp4+lhCNFdRHErA/FvAhT54SgvQ9RNWDD6VStC7j+Dp/bG7
         1T492m4oHaXssOOJ3PBcoV2KT2TnaSnlx86sjS2u4aB4cDMlVPc+73Rikor4QfBk6lcw
         dWgLUqjRcEBNRT5w+87Db1K3SizjBLYlLlGqGA2l+Swx91L+KA+w3jqrhMOseqiTE4NH
         O3pOeSSxrMbYd+BNdbSddiyGaNuidFILAPjkn6ZoFWS8/hk8JgJkZlv36nwx6Q7WWuUJ
         fjRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685408838; x=1688000838;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PoJBaff3peUbCldP9t/dhi1yxO4Hc9aEHcWsA/KdA/w=;
        b=X4rK0PlrUh7ky5s2k4n/jGGkndlxFRu5h1HKE7OkEnf//dqj+r7/Rc4bE/mzuIB/Um
         cCHUSBvuZR3MayliomdZhkG5NYGypxx25zpd1jH0DLkxg7KcDAy8J6gvD6uSDLdS75fd
         HGCV81xVYKjXqOvEHrmJNQKeNSgg1CBpAtjpsCF0f3+xjawsDIrfcNnLwpLRR5afRwvj
         9hU23YfggBXVHp0ZJLTI+n2w2hULhTyBdABp9RTmoBC16TbPn7/m1TF5zYrAlfdIqBaJ
         m69XCOR22qeq2cLJlAPFzUii4NAiiOkPGSgotygquPo5aLdoroOUbjJBSHxGuNprmUWj
         sZ6Q==
X-Gm-Message-State: AC+VfDz8EyY80C0iGjL84382nmXb4AoVJp7YoX996jJbTWFnaY+YAL1K
	yY5JOtY4vc+nTaYXx98R/g==
X-Google-Smtp-Source: ACHHUZ7Tr2GwGZwWobzyPXqSnpu9f50eRRjpEZMxWuPHg4I4ErLigGu5B2W67RRcZbP6oNLgIZNLfw==
X-Received: by 2002:a05:6214:cc1:b0:626:265b:4708 with SMTP id 1-20020a0562140cc100b00626265b4708mr692347qvx.29.1685408838001;
        Mon, 29 May 2023 18:07:18 -0700 (PDT)
Received: from C02FL77VMD6R.googleapis.com ([2600:1700:d860:12b0:e554:e6:7140:9e6b])
        by smtp.gmail.com with ESMTPSA id l9-20020ad44249000000b00623819de804sm4194588qvq.127.2023.05.29.18.07.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 May 2023 18:07:17 -0700 (PDT)
Date: Mon, 29 May 2023 18:07:11 -0700
From: Peilin Ye <yepeilin.cs@gmail.com>
To: Zhengchao Shao <shaozhengchao@huawei.com>
Cc: netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
	jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, weiyongjun1@huawei.com,
	yuehaibing@huawei.com, wanghai38@huawei.com
Subject: Re: [PATCH net] net: sched: fix NULL pointer dereference in mq_attach
Message-ID: <ZHVMP/ljXbmn4IqB@C02FL77VMD6R.googleapis.com>
References: <20230527093747.3583502-1-shaozhengchao@huawei.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230527093747.3583502-1-shaozhengchao@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sat, May 27, 2023 at 05:37:47PM +0800, Zhengchao Shao wrote:
> When use the following command to test:
> 1)ip link add bond0 type bond
> 2)ip link set bond0 up
> 3)tc qdisc add dev bond0 root handle ffff: mq
> 4)tc qdisc replace dev bond0 parent ffff:fff1 handle ffff: mq
> 
> The kernel reports NULL pointer dereference issue. The stack information
> is as follows:
> Unable to handle kernel NULL pointer dereference at virtual address 0000000000000000
> Internal error: Oops: 0000000096000006 [#1] SMP
> Modules linked in:
> pstate: 20000005 (nzCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
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
> need to initialize qdiscs in the mq before continuing to graft. Otherwise,
> it will couse NULL pointer dereference issue in mq_attach(). And the same
> issue will occur in the attach functions of mqprio, taprio and htb.
> ffff:fff1 means that the repalce qdisc is ingress. Ingress does not allow
> any qdisc to be attached. Therefore, ffff:fff1 is incorrectly used, and
> the command should be dropped.
> 
> Fixes: 6ec1c69a8f64 ("net_sched: add classful multiqueue dummy scheduler")
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>

Tested-by: Peilin Ye <peilin.ye@bytedance.com>

Thanks,
Peilin Ye


