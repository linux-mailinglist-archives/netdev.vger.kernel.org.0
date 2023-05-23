Return-Path: <netdev+bounces-4522-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3181070D2CB
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 06:29:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DDBC728119E
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 04:29:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E2618BEC;
	Tue, 23 May 2023 04:29:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3BB16FC7
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 04:29:48 +0000 (UTC)
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D4EBFA;
	Mon, 22 May 2023 21:29:47 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id 4fb4d7f45d1cf-510ddeab704so595961a12.3;
        Mon, 22 May 2023 21:29:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684816186; x=1687408186;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=53F7nqwqQEhqsr+wrxJIasUQcBALYUEWV178mBfizlk=;
        b=mXWaKofF+P7YXx9mx6Iha/Royl4mFZDvYnnSjPTO2lbPB/HOrkgGkPivIos4HyZC1P
         McYXQvdn9zT+1IXuxt98SkvBKh/YH0jxKYSba+tJxUmVkEkghtQeNXVlBDZKlajwS476
         b3ZQiYndgLu5/VwJRugLFbETdL0HyPUZeB0EEtks0pjnxMwUvPDMXyUc1JUtDReLLh4K
         n70kO8VAR2Lwl+ImWjxTX6n8aDGrJFAbMDkULYlbhXFRPmz07veNg0gUL4un5ZO185iU
         JlWchEhPkhHxTtBZe1DcaSdW+fsb6xQV6NpZH5ymE+4e1jDavV/+PCCOvIEP2PPnjARk
         d+qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684816186; x=1687408186;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=53F7nqwqQEhqsr+wrxJIasUQcBALYUEWV178mBfizlk=;
        b=T/91hPptw8JLAP+2wsxOKd4Nqj7rJ1TlObaGfD00jbSM7HH/PIqCq6WysfdmAKgKPp
         jkZJOdI8vPYkI22hBAzqA/vRXi4K2vFGHhA4zQc0pedAyv3ByOD/hTod2jb4GkTTdMRX
         E17GisO5PsQCc0QdgjpHDqC55IN3Dbm91xFNVdGqKL1vePJnimdn8ZUAWhD0FhKP5Q0X
         qOgZqvkxxUUNdYJrk92wF+IqTiHQYJY0zLwoB6Eq+927DjsFLi7FC7Bjbvi3VeaoEq8J
         6wghJKjTQgLqsZGexC+mgLvrd/JnbUZvJ0820HJ11zmSeF6nssEP2aHubSGKnfun73Pw
         LxKA==
X-Gm-Message-State: AC+VfDyCgsuXIpcAIHN2ozoEfTsyLaHI7k74I+GdihAkOC3YjEOjU1Xv
	OcaqrebrSWLpVepsXtZJRh3vN+swLHNHUr7g1O0=
X-Google-Smtp-Source: ACHHUZ7dVojBJEzxlc7n6PZs/RU6pQT5Zh3lWMe/BsWCAK4ykUBeokawONhnXtSWvLqERwKzfl/SYvJmpOaDP0578s0=
X-Received: by 2002:a17:907:a4c:b0:94e:e30e:7245 with SMTP id
 be12-20020a1709070a4c00b0094ee30e7245mr9463484ejc.8.1684816185754; Mon, 22
 May 2023 21:29:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <000000000000a589d005fc52ee2d@google.com> <13528f21-0f36-4fa2-d34f-eecee6720bc1@linux.dev>
 <CAD=hENeCo=-Pk9TWnqxOWP9Pg-JXWk6n6J19gvPo9_h7drROGg@mail.gmail.com>
 <CAD=hENdoyBZaRz7aTy4mX5Kq1OYmWabx2vx8vPH0gQfHO1grzw@mail.gmail.com> <0d515e17-5386-61ba-8278-500620969497@linux.dev>
In-Reply-To: <0d515e17-5386-61ba-8278-500620969497@linux.dev>
From: Zhu Yanjun <zyjzyj2000@gmail.com>
Date: Tue, 23 May 2023 12:29:33 +0800
Message-ID: <CAD=hENcqa0jQvLjuXw9bMtivCkKpQ9=1e0-y-1oxL23OLjutuw@mail.gmail.com>
Subject: Re: [syzbot] [rdma?] INFO: trying to register non-static key in
 skb_dequeue (2)
To: Guoqing Jiang <guoqing.jiang@linux.dev>
Cc: syzbot <syzbot+eba589d8f49c73d356da@syzkaller.appspotmail.com>, jgg@ziepe.ca, 
	leon@kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, 
	netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
	FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 23, 2023 at 12:10=E2=80=AFPM Guoqing Jiang <guoqing.jiang@linux=
.dev> wrote:
>
>
>
> On 5/23/23 12:02, Zhu Yanjun wrote:
> > On Tue, May 23, 2023 at 11:47=E2=80=AFAM Zhu Yanjun <zyjzyj2000@gmail.c=
om> wrote:
> >> On Tue, May 23, 2023 at 10:26=E2=80=AFAM Guoqing Jiang <guoqing.jiang@=
linux.dev> wrote:
> >>>
> >>>
> >>> On 5/23/23 10:13, syzbot wrote:
> >>>> Hello,
> >>>>
> >>>> syzbot tried to test the proposed patch but the build/boot failed:
> >>>>
> >>>> failed to apply patch:
> >>>> checking file drivers/infiniband/sw/rxe/rxe_qp.c
> >>>> patch: **** unexpected end of file in patch
> >> This is not the root cause. The fix is not good.
> > This problem is about "INFO: trying to register non-static key. The
> > code is fine but needs lockdep annotation, or maybe"

This warning is from "lock is not initialized". This is a
use-before-initialized problem.
The correct fix is to initialize the lock that is complained before it is u=
sed.

Zhu Yanjun
>
> Which is caused by  "skb_queue_head_init(&qp->resp_pkts)" is not called
> given rxe_qp_init_resp returns error, but the cleanup still trigger the
> chain.
>
> rxe_qp_do_cleanup -> rxe_completer -> drain_resp_pkts ->
> skb_dequeue(&qp->resp_pkts)
>
> But I might misunderstood it ...
>
> Thanks,
> Guoqing

