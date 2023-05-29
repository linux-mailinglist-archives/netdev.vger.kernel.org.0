Return-Path: <netdev+bounces-6028-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 74D2B7146C5
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 10:59:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1B5281C20909
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 08:59:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D17723A0;
	Mon, 29 May 2023 08:59:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 614DE7C
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 08:59:48 +0000 (UTC)
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFDFE9C
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 01:59:46 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id af79cd13be357-75b08ceddd1so373974085a.1
        for <netdev@vger.kernel.org>; Mon, 29 May 2023 01:59:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685350786; x=1687942786;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=3GUM4Yf5dcEGbqpnvmogHymzYR7RsTWu6vZbXtV/7GI=;
        b=YizKYhVb0HvcCWlR7ah77IibzEFQ7RTDZbZxKlMOAUeBReYUltTI5qYoo/Cctq/2FD
         afAOiJF7jaIih4SdhGLkA3I8fzd2m9AjdH5JLHH2ikFIZpCMuTSWJqbLYOkzHIi+Qs5u
         27bMyaVri4eNM4Brh56JRelemstK6NAEpZ16JXJUIioJOu+Jn5TcUi8rxlO1NCugitLm
         4LgcB3EFYSNjOgoOyjMfT1Geq1+SUxdaLGX9z5A2XaDkTm54jkOgc6XyVZ7GBs6AY2+P
         kvIQWChZSgRWhYFY4tTTsc6YY3pYD26yuKSdRlU/zyOlA30fW0dkG95nNfnmGtHvFPQU
         uW8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685350786; x=1687942786;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3GUM4Yf5dcEGbqpnvmogHymzYR7RsTWu6vZbXtV/7GI=;
        b=OpAe4goffeBuQdak37FnIP88Ezi9V2lI2tPdUfKMhk16MtaVsDs4tEzhoiOD1ssto8
         mdkSe60IShdP4j1S1j53NTpk8bt3bjln3jK4oyDAUc4pXOPOWxONdRCnMV5PHsbpIHCI
         wRInI6Z+fE7l9ILEppHmUgivvc3YIi63IJKV2JH5992upChAwYUQwER/WsfqJhzrozB2
         XH026ffJMBCpmPL7+7ty/79vtA8M9iqfVhY5eRUc0e8Z0J478+AETMHjSmNK3YFpYwzj
         /m8ZlzAJKDTtcj+D5jXxCDE1xxFH/t9BIdwIUJvRG7Ak9yL5Hg549aciIjP90NMRsDv4
         BTxA==
X-Gm-Message-State: AC+VfDzSD8e/AQAQa02riL/xhDu2rk9KouIpBoGgOdm9u0WB4oQSW6G6
	QuorOP6HCXkKWYbsJ1TVYQwgCrFoxQ==
X-Google-Smtp-Source: ACHHUZ4qekhPjvL1nmFGmMl6HQ0psjsz2dXnqnhDsQdQy8P3WoRU/ywtPPDYgibqSrHQrMjhGsCIlA==
X-Received: by 2002:a05:620a:26a8:b0:75b:23a0:de91 with SMTP id c40-20020a05620a26a800b0075b23a0de91mr6540853qkp.15.1685350785929;
        Mon, 29 May 2023 01:59:45 -0700 (PDT)
Received: from C02FL77VMD6R.googleapis.com ([2600:1700:d860:12b0:bdba:517e:b53b:f5c8])
        by smtp.gmail.com with ESMTPSA id d15-20020a05620a136f00b0075b00e52e3asm3219357qkl.70.2023.05.29.01.59.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 May 2023 01:59:45 -0700 (PDT)
Date: Mon, 29 May 2023 01:59:40 -0700
From: Peilin Ye <yepeilin.cs@gmail.com>
To: shaozhengchao <shaozhengchao@huawei.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>, netdev@vger.kernel.org,
	xiyou.wangcong@gmail.com, jiri@resnulli.us, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	weiyongjun1@huawei.com, yuehaibing@huawei.com, wanghai38@huawei.com
Subject: Re: [PATCH net] net: sched: fix NULL pointer dereference in mq_attach
Message-ID: <ZHRpfB2NatdM6fHJ@C02FL77VMD6R.googleapis.com>
References: <20230527093747.3583502-1-shaozhengchao@huawei.com>
 <CAM0EoMkrpShprVbWSFN3FpFWtK9494Hyo+mOSNOJmXCFoieN7Q@mail.gmail.com>
 <c135ae5a-37ff-aa89-a3f7-976799181a04@huawei.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c135ae5a-37ff-aa89-a3f7-976799181a04@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 29, 2023 at 09:10:23AM +0800, shaozhengchao wrote:
> On 2023/5/29 3:05, Jamal Hadi Salim wrote:
> > On Sat, May 27, 2023 at 5:30 AM Zhengchao Shao <shaozhengchao@huawei.com> wrote:
> > > When use the following command to test:
> > > 1)ip link add bond0 type bond
> > > 2)ip link set bond0 up
> > > 3)tc qdisc add dev bond0 root handle ffff: mq
> > > 4)tc qdisc replace dev bond0 parent ffff:fff1 handle ffff: mq
> >
> > This is fixed by Peilin in this ongoing discussion:
> > https://lore.kernel.org/netdev/cover.1684887977.git.peilin.ye@bytedance.com/
> >
>       Thank you for your reply. I have notice Peilin's patches before,
> and test after the patch is incorporated in local host. But it still
> triggers the problem.
>       Peilin's patches can be filtered out when the query result of
> qdisc_lookup is of the ingress type. Here is 4/6 patch in his patches.
> +if (q->flags & TCQ_F_INGRESS) {
> +     NL_SET_ERR_MSG(extack,
> +                    "Cannot regraft ingress or clsact Qdiscs");
> +     return -EINVAL;
> +}
>       However, the query result of my test case in qdisc_lookup is mq.
> Therefore, the patch cannot solve my problem.

Ack, they are different: patch [4/6] prevents ingress (clsact) Qdiscs
from being regrafted (to elsewhere), and Zhengchao's patch prevents other
Qdiscs from being regrafted to ffff:fff1.

Thanks,
Peilin Ye


