Return-Path: <netdev+bounces-6300-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 38B52715996
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 11:11:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E8C03280EC8
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 09:11:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D84B134AF;
	Tue, 30 May 2023 09:11:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F78113AC8
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 09:11:23 +0000 (UTC)
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 604ABBE
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 02:11:21 -0700 (PDT)
Received: by mail-qk1-x730.google.com with SMTP id af79cd13be357-75b01271ad4so241756585a.1
        for <netdev@vger.kernel.org>; Tue, 30 May 2023 02:11:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685437880; x=1688029880;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=d4O15BpMMDRpIzKMhSjHC9Um++U3PCJaF3BQ84z1P4k=;
        b=TbUzfG4HrrLtNQpTrAe6MB2sZwMxMSNvEG3zwY3NQ+sdRIWqFlEI2/2G1mCRKO7qvE
         r1+hrBxiGrd7C/2HkGoEMyifUMfleQu4L3nB7ulYHIxk4XjpBBGcaRpbZ2Pe8rDPLg47
         +l4OAMAvbO+WqrIUpSZs3T7hHLUcOvnzrUcKntH07zzwHb+RzvZKZDQaneDm/4UAfwcZ
         cb38APT1B8ySqWLHnvvQFmIzM2X8UE9iFA1EFzuUKG90dj5CzB9kZSuSwZv35W+eneKN
         wmKKxisfUKViGHtJ6lZQ3bIP5TiaD+uCUeNoFhDix2IFPWBHEJk1a31SBT3vkWIk0Si0
         SUoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685437880; x=1688029880;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d4O15BpMMDRpIzKMhSjHC9Um++U3PCJaF3BQ84z1P4k=;
        b=E+8n2HJy/QKdhytZrbgpn4iKGKgyehwP33Mdb05pQn28iCpCRLOJoreJl84+w3JpBi
         hX53BozIWfRK8CuvFKJbIRt9J6B74CbvLi0ppUMxnFn/l4m4n92P5AK0XuYdx2715Ij6
         6c0+WBkSn49WW0MvWOxQPCtqlNal3LAKbdWn5s6ongSXbTWzKHYnra2pXdZeUsuZjxw1
         +8dCjsuSDzyICBB6OGzkHDMm2vRq4ahwZ4VmNhitDkDSlQh95cj9FfWFTT0GIb9BXRLw
         /KzG7hC22fEMvIaFauJCd+9jtooJpceLiR/Q6xfCL9BYyiI3mza2d0pvv/zv4vpv4r1F
         fiWQ==
X-Gm-Message-State: AC+VfDxVKuXCWscQ3/3v1Yxps+TXDR1wogNND5t42okYRm/j+l8B3au3
	yw9NvNbm2Tel4M2wbmukdQ==
X-Google-Smtp-Source: ACHHUZ4XuHjsrucxT2YzKIPZ4lREZAM1saxLpLkuhcj6f+XxHmLLcB1Hz2NmKmJhqB8bEuYKvIHG4w==
X-Received: by 2002:a05:620a:47af:b0:75b:23a1:8318 with SMTP id dt47-20020a05620a47af00b0075b23a18318mr1284538qkb.19.1685437880451;
        Tue, 30 May 2023 02:11:20 -0700 (PDT)
Received: from C02FL77VMD6R.googleapis.com ([2600:1700:65a5:6400:18f6:3c71:9d3b:6d02])
        by smtp.gmail.com with ESMTPSA id f25-20020a05620a15b900b0074df70197a6sm3931122qkk.109.2023.05.30.02.11.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 May 2023 02:11:20 -0700 (PDT)
Date: Tue, 30 May 2023 02:11:16 -0700
From: Peilin Ye <yepeilin.cs@gmail.com>
To: Vlad Buslov <vladbu@nvidia.com>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>, Jakub Kicinski <kuba@kernel.org>,
	Pedro Tammela <pctammela@mojatatu.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Cong Wang <xiyou.wangcong@gmail.com>, Jiri Pirko <jiri@resnulli.us>,
	Peilin Ye <peilin.ye@bytedance.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	John Fastabend <john.fastabend@gmail.com>,
	Hillf Danton <hdanton@sina.com>, netdev@vger.kernel.org,
	Cong Wang <cong.wang@bytedance.com>
Subject: Re: [PATCH v5 net 6/6] net/sched: qdisc_destroy() old ingress and
 clsact Qdiscs before grafting
Message-ID: <ZHW9tMw5oCkratfs@C02FL77VMD6R.googleapis.com>
References: <faaeb0b0-8538-9dfa-4c1e-8a225e3534f4@mojatatu.com>
 <CAM0EoM=3iYmmLjnifx_FDcJfRbN31tRnCE0ZvqQs5xSBPzaqXQ@mail.gmail.com>
 <CAM0EoM=FS2arxv0__aQXF1a7ViJnM0hST=TL9dcnJpkf-ipjvA@mail.gmail.com>
 <7879f218-c712-e9cc-57ba-665990f5f4c9@mojatatu.com>
 <ZHE8P9Bi6FlKz4US@C02FL77VMD6R.googleapis.com>
 <20230526193324.41dfafc8@kernel.org>
 <ZHG+AR8qgpJ6/Zhx@C02FL77VMD6R.googleapis.com>
 <CAM0EoM=xLkAr5EF7bty+ETmZ3GXnmB9De3fYSCrQjKPb8qDy7Q@mail.gmail.com>
 <87jzwrxrz8.fsf@nvidia.com>
 <87fs7fxov6.fsf@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87fs7fxov6.fsf@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 29, 2023 at 02:50:26PM +0300, Vlad Buslov wrote:
> After looking very carefully at the code I think I know what the issue
> might be:
>
>    Task 1 graft Qdisc   Task 2 new filter
>            +                    +
>            |                    |
>            v                    v
>         rtnl_lock()       take  q->refcnt
>            +                    +
>            |                    |
>            v                    v
> Spin while q->refcnt!=1   Block on rtnl_lock() indefinitely due to -EAGAIN
>
> This will cause a real deadlock with the proposed patch. I'll try to
> come up with a better approach. Sorry for not seeing it earlier.

Thanks a lot for pointing this out!  The reproducers add flower filters to
ingress Qdiscs so I didn't think of rtnl_lock()'ed filter requests...

On Mon, May 29, 2023 at 03:58:50PM +0300, Vlad Buslov wrote:
> - Account for such cls_api behavior in sch_api by dropping and
>   re-tacking the lock before replaying. This actually seems to be quite
>   straightforward since 'replay' functionality that we are reusing for
>   this is designed for similar behavior - it releases rtnl lock before
>   loading a sch module, takes the lock again and safely replays the
>   function by re-obtaining all the necessary data.

Yes, I've tested this using that reproducer Pedro posted.

On Mon, May 29, 2023 at 03:58:50PM +0300, Vlad Buslov wrote:
> If livelock with concurrent filters insertion is an issue, then it can
> be remedied by setting a new Qdisc->flags bit
> "DELETED-REJECT-NEW-FILTERS" and checking for it together with
> QDISC_CLASS_OPS_DOIT_UNLOCKED in order to force any concurrent filter
> insertion coming after the flag is set to synchronize on rtnl lock.

Thanks for the suggestion!  I'll try this approach.

Currently QDISC_CLASS_OPS_DOIT_UNLOCKED is checked after taking a refcnt of
the "being-deleted" Qdisc.  I'll try forcing "late" requests (that arrive
later than Qdisc is flagged as being-deleted) sync on RTNL lock without
(before) taking the Qdisc refcnt (otherwise I think Task 1 will replay for
even longer?).

Thanks,
Peilin Ye


