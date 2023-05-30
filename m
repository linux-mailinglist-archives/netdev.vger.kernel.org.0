Return-Path: <netdev+bounces-6187-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D52AD715287
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 02:17:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8EDC7280FA8
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 00:17:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 104AA628;
	Tue, 30 May 2023 00:17:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 044A2623
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 00:17:35 +0000 (UTC)
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4E18DC
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 17:17:33 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id af79cd13be357-75b17aa343dso222078385a.3
        for <netdev@vger.kernel.org>; Mon, 29 May 2023 17:17:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685405853; x=1687997853;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ABttb00rgI2ahJbeWRRrLylgDZeiDTjCvMmD0B3IZSk=;
        b=W8lgVewnLOvK9TWSMbsnfevfZlJYkL3Wxvpi8b/zqYDTPJuFDX8l9VaP91h8gThTCt
         7j6TOrxPBdQNSQvZP5QgnV92TP9OT2xMmeWKtjN/9lq0PQ9pVH7/CiJV1C6PoAovMmBZ
         4KV/yNA8++qETg7NTDx3asm2yUn1SQ8Nhh/aXnYdYrQGu+RR7F7gS+UJL6PgaQgHCSzw
         NOwBzuTuuAQ/UjWgOA32PRyrwJCLYKcucZm+rwsC92Ft9zRZQt94jgyeyVxUL4VfiPX5
         kf55Ocqn8JxABF9iAxR6pqcdfTw3MdirnzDUYFrF9nJlX5GIDNAkmlkNU4DxU1jvoI1p
         Qg8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685405853; x=1687997853;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ABttb00rgI2ahJbeWRRrLylgDZeiDTjCvMmD0B3IZSk=;
        b=QGpWSxMkVnkdx3sY3Ztqphkp/V3Lr0CfSVOG7ol8sNzPP1c/tA9O+L/RJxpzMZXEgi
         kBy2ETaac5upgs74fTqIcYu73K9e1YCK5OXkvAmD7054zr2+unETYPYP131DEXrnrl+Y
         0iUfSYM2WSoKe1tJPi4zaajFniS4Ptn2ALT6Jil56scopvxF+zg1UpDUcIHRyy1JsaaN
         eU3hjHd+fa8xjBsLrrH3MDzIsFPF+tIbKKnpHsOzUqP3MaVHwqQmk2tTEXYtqFmTajfd
         szDAiAB/hhZbjQX/VXLIeifYrWykZwSD7snl7L2pNa+ip6xrz4LC986V9CuuC9R2reEc
         5B2Q==
X-Gm-Message-State: AC+VfDyi7s0nBFjGlaB0mn2fjWJQ69ogXnhSAtrgLQHWxXl8CKj4/22G
	A5UuSfvMaXAPWMm76Tc4mmu87W9+bw==
X-Google-Smtp-Source: ACHHUZ4H4pln1zpOVlee7sYRehZv8pfWSk7LLDSUa84tH7yESsZXuVk/VfMfnDPMJ5NG8P+cOBNHlA==
X-Received: by 2002:a05:620a:1a05:b0:75b:23a1:834a with SMTP id bk5-20020a05620a1a0500b0075b23a1834amr540048qkb.69.1685405852849;
        Mon, 29 May 2023 17:17:32 -0700 (PDT)
Received: from C02FL77VMD6R.googleapis.com ([2600:1700:d860:12b0:e554:e6:7140:9e6b])
        by smtp.gmail.com with ESMTPSA id e15-20020a0cd64f000000b005dd8b9345b4sm4126470qvj.76.2023.05.29.17.17.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 May 2023 17:17:32 -0700 (PDT)
Date: Mon, 29 May 2023 17:17:24 -0700
From: Peilin Ye <yepeilin.cs@gmail.com>
To: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: shaozhengchao <shaozhengchao@huawei.com>, netdev@vger.kernel.org,
	xiyou.wangcong@gmail.com, jiri@resnulli.us, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	weiyongjun1@huawei.com, yuehaibing@huawei.com, wanghai38@huawei.com,
	peilin.ye@bytedance.com, cong.wang@bytedance.com
Subject: Re: [PATCH net] net: sched: fix NULL pointer dereference in mq_attach
Message-ID: <ZHVAlCtzFeJrwKvc@C02FL77VMD6R.googleapis.com>
References: <20230527093747.3583502-1-shaozhengchao@huawei.com>
 <CAM0EoMkrpShprVbWSFN3FpFWtK9494Hyo+mOSNOJmXCFoieN7Q@mail.gmail.com>
 <c135ae5a-37ff-aa89-a3f7-976799181a04@huawei.com>
 <ZHRpfB2NatdM6fHJ@C02FL77VMD6R.googleapis.com>
 <CAM0EoMk+zO0RcnJ4Uie7jU+MNdFz7Mc37W223jVZip62QMRdzQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAM0EoMk+zO0RcnJ4Uie7jU+MNdFz7Mc37W223jVZip62QMRdzQ@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 29, 2023 at 09:53:28AM -0400, Jamal Hadi Salim wrote:
> On Mon, May 29, 2023 at 4:59 AM Peilin Ye <yepeilin.cs@gmail.com> wrote:
> > On Mon, May 29, 2023 at 09:10:23AM +0800, shaozhengchao wrote:
> > > On 2023/5/29 3:05, Jamal Hadi Salim wrote:
> > > > On Sat, May 27, 2023 at 5:30 AM Zhengchao Shao <shaozhengchao@huawei.com> wrote:
> > > > > When use the following command to test:
> > > > > 1)ip link add bond0 type bond
> > > > > 2)ip link set bond0 up
> > > > > 3)tc qdisc add dev bond0 root handle ffff: mq
> > > > > 4)tc qdisc replace dev bond0 parent ffff:fff1 handle ffff: mq
> > > >
> > > > This is fixed by Peilin in this ongoing discussion:
> > > > https://lore.kernel.org/netdev/cover.1684887977.git.peilin.ye@bytedance.com/
> > > >
> > >       Thank you for your reply. I have notice Peilin's patches before,
> > > and test after the patch is incorporated in local host. But it still
> > > triggers the problem.
> > >       Peilin's patches can be filtered out when the query result of
> > > qdisc_lookup is of the ingress type. Here is 4/6 patch in his patches.
> > > +if (q->flags & TCQ_F_INGRESS) {
> > > +     NL_SET_ERR_MSG(extack,
> > > +                    "Cannot regraft ingress or clsact Qdiscs");
> > > +     return -EINVAL;
> > > +}
> > >       However, the query result of my test case in qdisc_lookup is mq.
> > > Therefore, the patch cannot solve my problem.
> >
> > Ack, they are different: patch [4/6] prevents ingress (clsact) Qdiscs
> > from being regrafted (to elsewhere), and Zhengchao's patch prevents other
> > Qdiscs from being regrafted to ffff:fff1.
> 
> Ok, at first glance it was not obvious.
> Do we catch all combinations? for egress (0xffffffff) allowed minor is
> 0xfff3 (clsact::) and 0xffff. For ingress (0xfffffff1) allowed minor
> is 0xfff1 and 0xfff2(clsact).

ffff:fff1 is special in tc_modify_qdisc(); if minor isn't fff1,
tc_modify_qdisc() thinks user wants to graft a Qdisc under existing ingress
or clsact Qdisc:

	if (clid != TC_H_INGRESS) {	/* ffff:fff1 */
		p = qdisc_lookup(dev, TC_H_MAJ(clid));
		if (!p) {
			NL_SET_ERR_MSG(extack, "Failed to find specified qdisc");
			return -ENOENT;
		}
		q = qdisc_leaf(p, clid);
	} else if (dev_ingress_queue_create(dev)) {
		q = dev_ingress_queue(dev)->qdisc_sleeping;
	}

This will go to the "parent != NULL" path in qdisc_graft(), and
sch_{ingress,clsact} doesn't implement cl_ops->graft(), so -EOPNOTSUPP will
be returned.

In short, yes, I think ffff:fff1 is the only case should be fixed.

By the way I just noticed that currently it is possible to create a e.g.
HTB class with a class ID of ffff:fff1...

  $ tc qdisc add dev eth0 root handle ffff: htb default fff1
  $ tc class add dev eth0 \
            parent ffff: classid ffff:fff1 htb rate 100%

Regrafting a Qdisc to such classes won't work as intended at all.  It's a
separate issue though.

Thanks,
Peilin Ye


