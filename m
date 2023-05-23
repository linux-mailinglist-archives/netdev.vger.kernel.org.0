Return-Path: <netdev+bounces-4551-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9567B70D35B
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 07:50:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5A7E7281215
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 05:50:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81E331B8FF;
	Tue, 23 May 2023 05:50:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75D5016421
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 05:50:36 +0000 (UTC)
X-Greylist: delayed 12271 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 22 May 2023 22:50:34 PDT
Received: from out-36.mta1.migadu.com (out-36.mta1.migadu.com [IPv6:2001:41d0:203:375::24])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6644109
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 22:50:34 -0700 (PDT)
Message-ID: <63b9f740-3762-2ec0-9750-eb8709c886a5@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1684821033;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sWQQ4vHFSx81IsrwOaPXPuxPrCLnal4sepgxbBwQ8sE=;
	b=X4v13ZuHk71ppTTAsYsbfcnKr+4NIS5dakIz8nas2xl2y9SHvYVY/TwlmB096XUNSxO8l5
	fsAL2xUAi1eRr+PEQ/kVA5+xtVPBeY3jXdqcUf9ekorVADt9NWpHdD5vQKd0yYzn185HTW
	z8WTXlxk8DeCGeny8xPZ/iyx1U2K8Kw=
Date: Tue, 23 May 2023 13:50:28 +0800
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [syzbot] [rdma?] INFO: trying to register non-static key in
 skb_dequeue (2)
Content-Language: en-US
To: Zhu Yanjun <zyjzyj2000@gmail.com>
Cc: syzbot <syzbot+eba589d8f49c73d356da@syzkaller.appspotmail.com>,
 jgg@ziepe.ca, leon@kernel.org, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
 syzkaller-bugs@googlegroups.com
References: <000000000000a589d005fc52ee2d@google.com>
 <13528f21-0f36-4fa2-d34f-eecee6720bc1@linux.dev>
 <CAD=hENeCo=-Pk9TWnqxOWP9Pg-JXWk6n6J19gvPo9_h7drROGg@mail.gmail.com>
 <CAD=hENdoyBZaRz7aTy4mX5Kq1OYmWabx2vx8vPH0gQfHO1grzw@mail.gmail.com>
 <0d515e17-5386-61ba-8278-500620969497@linux.dev>
 <CAD=hENcqa0jQvLjuXw9bMtivCkKpQ9=1e0-y-1oxL23OLjutuw@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Guoqing Jiang <guoqing.jiang@linux.dev>
In-Reply-To: <CAD=hENcqa0jQvLjuXw9bMtivCkKpQ9=1e0-y-1oxL23OLjutuw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 5/23/23 12:29, Zhu Yanjun wrote:
> On Tue, May 23, 2023 at 12:10 PM Guoqing Jiang <guoqing.jiang@linux.dev> wrote:
>>
>>
>> On 5/23/23 12:02, Zhu Yanjun wrote:
>>> On Tue, May 23, 2023 at 11:47 AM Zhu Yanjun <zyjzyj2000@gmail.com> wrote:
>>>> On Tue, May 23, 2023 at 10:26 AM Guoqing Jiang <guoqing.jiang@linux.dev> wrote:
>>>>>
>>>>> On 5/23/23 10:13, syzbot wrote:
>>>>>> Hello,
>>>>>>
>>>>>> syzbot tried to test the proposed patch but the build/boot failed:
>>>>>>
>>>>>> failed to apply patch:
>>>>>> checking file drivers/infiniband/sw/rxe/rxe_qp.c
>>>>>> patch: **** unexpected end of file in patch
>>>> This is not the root cause. The fix is not good.
>>> This problem is about "INFO: trying to register non-static key. The
>>> code is fine but needs lockdep annotation, or maybe"
> This warning is from "lock is not initialized". This is a
> use-before-initialized problem.

Right, and it also applies to qp->sq.queue which is set to NULL while do 
cleanup
still de-reference it.

> The correct fix is to initialize the lock that is complained before it is used.

The thing is it can't be initialized due to error, so I guess you want 
to always init them
even for error cases.

Guoqing

