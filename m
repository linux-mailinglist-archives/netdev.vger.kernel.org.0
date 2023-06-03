Return-Path: <netdev+bounces-7675-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4000B721082
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 16:43:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6B3401C209CF
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 14:42:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0959D2E2;
	Sat,  3 Jun 2023 14:42:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D469720EB
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 14:42:57 +0000 (UTC)
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E31ECE
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 07:42:55 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id 3f1490d57ef6-bacfa9fa329so3345604276.0
        for <netdev@vger.kernel.org>; Sat, 03 Jun 2023 07:42:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1685803374; x=1688395374;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dXVJ8h9BHAxoyLU0Iu/Vy0fwwo8XoxBQJEzY1xOAGI8=;
        b=ZBuotOTWN7fpibWAWZn+dOZ24HVFg3Rbl2Y3ohkMsLHDmkJE2Mw2pzaTaxXMKVlYo4
         5hexsDV420ym9U+hHbNgbF9iq24+BT0BtyQNNBtlikfnAQnmIw9GDNZ49sKZwQzSEPH5
         yq/zs6kaI9X4AMfkt5jv3wmWUoX2N4Cu0sTy/W/NdPoTBmKzP82WQbUYJSwNF/jdwdah
         mn3Nw+jXaEGtOkfKFLPN8zUuZTqaO6d8y612fnir8nmes16W0EZqWhPXn5JnrWyQTYRH
         05zM8qr6r/zUPes2s9wjuFRfmIBHm+j/1mq7DFO23ouGReTx+x0aCKDEEMaV6OJISnHL
         NfxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685803374; x=1688395374;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dXVJ8h9BHAxoyLU0Iu/Vy0fwwo8XoxBQJEzY1xOAGI8=;
        b=UdYq6mOgdRJoPCci6Q386S+SCsigOuMOM4ITTsd+lUx4+yA1bSQnhoJzmUxV9LsKT6
         3n6Otg4Tj5Wj8/OTlEWhND4/6/e3NjPwQ3dyTq8tN+fCX8FVZoOBc/i36LfBA7e0+CXV
         ORViG65zYgVHU8k1cZLbAUpP15f9hq7udPspdC0NcA49UW6Xiksoewo3gYtIowot+8cg
         kOK1F2Mi1Qd9Xg8FNHQaCqsXgSZ6nDPRC7IwR1Ni4eWuW4PQGhGiazihCcqZLjDjc3VK
         Nf3d8qQ7OTz8C5VIqAyFWKY4cc9mmm4oaDl7SYXIr33qVdwCNVmhuhFFiUI4uEuhmXJn
         jMyg==
X-Gm-Message-State: AC+VfDxTl0AV3wLZU2mz1stENUIpmNX4iTz29t+JJdFsqobBZqzxZpRa
	KkIRb7W6CIopeeIP3LOKH1yMPxkVc2bxqqTFzWpQ0Q==
X-Google-Smtp-Source: ACHHUZ6VRvYbHTGThmCmnqi6nEG7UNcNhxbu8ixGmw12mYVxTfqCLDgciGz+Do5P5d/g2w+kV0TDBic/+p2XeoftZnk=
X-Received: by 2002:a81:6707:0:b0:561:9051:d2d3 with SMTP id
 b7-20020a816707000000b005619051d2d3mr3578838ywc.11.1685803374285; Sat, 03 Jun
 2023 07:42:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230517110225.29327-1-jhs@mojatatu.com> <CALnP8ZZps_VJNEMsZm07fK4DjPR1iCQkyH4_tpbZVr+N8KS+ug@mail.gmail.com>
In-Reply-To: <CALnP8ZZps_VJNEMsZm07fK4DjPR1iCQkyH4_tpbZVr+N8KS+ug@mail.gmail.com>
From: Jamal Hadi Salim <jhs@mojatatu.com>
Date: Sat, 3 Jun 2023 10:42:42 -0400
Message-ID: <CAM0EoMkiN7oXVcQo8WEY_ddFr2X-Fzb9+cU2VaLFJ4aXZgZJbA@mail.gmail.com>
Subject: Re: [PATCH RFC net-next 00/28 v2] Introducing P4TC
To: Marcelo Ricardo Leitner <mleitner@redhat.com>
Cc: netdev@vger.kernel.org, deb.chatterjee@intel.com, anjali.singhai@intel.com, 
	namrata.limaye@intel.com, jiri@resnulli.us, xiyou.wangcong@gmail.com, 
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, 
	tom@sipanda.io, p4tc-discussions@netdevconf.info, vladbu@nvidia.com, 
	simon.horman@corigine.com, khalidm@nvidia.com, toke@redhat.com, 
	Mahesh.Shirshyad@amd.com, Vipin.Jain@amd.com, tomasz.osinski@intel.com, 
	mattyk@nvidia.com, dan.daly@intel.com, john.andy.fingerhut@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 2, 2023 at 6:48=E2=80=AFPM Marcelo Ricardo Leitner
<mleitner@redhat.com> wrote:
>
> On Wed, May 17, 2023 at 07:02:25AM -0400, Jamal Hadi Salim wrote:
> > We are seeking community feedback on P4TC patches.
>
> This was the first time I read these patches. I don't have much to
> comment on it overall yet.

Thanks for all the effort you put in - those were excellent comments.

> >
> > Apologies, I know this is a large number of patches but it is the best =
we could
> > do so as not to miss the essence of the work.
> > Please do note that > 50% of LOC are testcases. I should have emphasize=
d
> > this last time to improve the quality of the discussions, but mea culpa=
.
>
> And much of the LOC that are not testcases, are for the CRUD
> implementations. P4 is not simpe and allowing such simple
> manipulations of all those types to the user comes at a cost and I
> don't see a way around that.

Yes, the core is much less code. Note: Our goal is to _never_ make any
kernel code changes (or user space for that matter), sans bugs. So
CRUD where you have <CMD> <NOUN/PATH> [Optional data] semantics is a
major part of that architecture and netlink helps us a lot so we dont
have to reinvent the infrastructure. So that code is needed to ensure
that.

> The scripts seem long and complex, but they can be structured and are
> human readable. I like how one is able to inspect the datapath no
> matter how it was configured (from a p4 program or manually built).
> This helps a lot with the supportability of solutions based on it.

Yeah, that is part of the dilemma we have with adding ebpf support -
loosing that simpler operational approach. In mode 1 (where only the
parser is ebpf) it is still there and i think this is what you mean by
the scripts being long and complex. A human should still be able to
create them even though in this case they are generated by a compiler.
In mode 2 the template scripts get simpler but the dependency on ebpf
and loss of operational simplicity is stronger.
See for example
https://github.com/p4tc-dev/p4tc-v2-examples/blob/main/model1/1table/exact/=
redirect_l2_pna_1t_exact.template
vs https://github.com/p4tc-dev/p4tc-v2-examples/blob/main/model2/1table/exa=
ct/redirect_l2_pna_1t_exact.template
I really like the scriptable version we posted in the first RFC for
the operational simplicity (honestly still conflicted on whether we
should totally remove it but we are trying to meet the ebpf people in
the middle).

> One thing that I hate about u32 is that it is like perl^W^Wwrite-only.
> It is as flexible as u32, but making sense out of those matches is a
> nightmare.

We are doing much much better than u32 or pedit despite taking the
inspiration from them ;-> Usability for sure is highly improved in
comparison to those two.

> The approach here keeps the flexibility, while not
> becoming as complex and slow moving as flower and yet, understandable
> by humans. A promising in between the two extreme approaches that we
> have in tc today.

yes. This is in many ways a big improvement over the flower approach
and builds on the lessons from flower deployment.

Thanks again Marcelo for taking the time.

cheers,
jamal

