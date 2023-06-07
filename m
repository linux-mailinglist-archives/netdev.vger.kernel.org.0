Return-Path: <netdev+bounces-8652-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CC2172514B
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 02:57:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 25943281148
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 00:57:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E641620;
	Wed,  7 Jun 2023 00:57:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 404C37C
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 00:57:19 +0000 (UTC)
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3399919AC
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 17:57:18 -0700 (PDT)
Received: by mail-qk1-x72e.google.com with SMTP id af79cd13be357-75d4dd6f012so480931785a.2
        for <netdev@vger.kernel.org>; Tue, 06 Jun 2023 17:57:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686099437; x=1688691437;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=I5TDBlJmRu77ewZOtX5/KWHfzgX+9F2Jklmj6FIBCZ0=;
        b=pdpFVqhVe8CTVVvyVefmVoMiEq9CLLhcJflyxZzcvM1otyckEd0GrPwULG1BW0iIVW
         ADbLVnhPXEhh6pBneKL5Jw8Jicgza/evXU7AlP2yyeQFefTO7bvuikc6oVF6TRXheoY/
         mWs1tkD+y6fIfw6b3CcOBRaUBktuVHNecxcno36t4kWw7xQGVnabcmSyixJxd1CcW9Pl
         9u80zRMmqkrGLML7kZBE1lO/Gu1k0y1PPd9IPOEDZRpXh/ZWAdH2rXzu265oEnUiduEM
         SZvCQSpaqn5BdoewiTA4O/aJ9ALTAyYhxm0t07hE2lGggIs/eRMf/NP8ymh7ksBFUFaj
         +Siw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686099437; x=1688691437;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I5TDBlJmRu77ewZOtX5/KWHfzgX+9F2Jklmj6FIBCZ0=;
        b=L8KCKMFGWcB/on9jMp7EFZ/T7aQGMywVzYctR+qB5DxmyUXwEzNg0D2naPU1b1kmjN
         +M4pjg4A1T6mnT7nezf3UWIneoYo/fyqvnWagmqqbBYhkc9WAGDr3PUHDhFCVqTSKrBr
         7ASWyxLmuIogPSIGqzAkirvpbN1WsPlyzM4C2VZBTcBwtANijZLwnl3Es8+SnUcr3Dff
         SYHHytjo7xD6g8B8g6RVJfkWauJ/hYzTbBZ5Dr0HZg/nSr8EiYe78apNJ+aBGQq2ec6K
         DzT/7eS6d0es/BNeVd1/OugLIMlClod7KXtZxAH0oDS8eiH9LdvWjZK5mSZ0oJkB/lPG
         RCeA==
X-Gm-Message-State: AC+VfDyohygwFqvIZXGdt0p6dhsi5xXTQXkwy8W8+S5fTJKN7w4O2Jg1
	atDckUuidJVMTGe/HM0Xpg==
X-Google-Smtp-Source: ACHHUZ42hecNzQlBCBW6GO24Nr0woa8Wwk/W/9EVbRQEFZZwwzNxeY8jSIa89BEgT1b095dVHK1n0w==
X-Received: by 2002:a05:620a:f10:b0:75b:23a0:de91 with SMTP id v16-20020a05620a0f1000b0075b23a0de91mr592466qkl.15.1686099437156;
        Tue, 06 Jun 2023 17:57:17 -0700 (PDT)
Received: from C02FL77VMD6R.googleapis.com ([2600:1700:d860:12b0:6c60:5e57:914a:4abf])
        by smtp.gmail.com with ESMTPSA id b10-20020a05620a118a00b0074ca7c33b79sm5343757qkk.23.2023.06.06.17.57.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jun 2023 17:57:16 -0700 (PDT)
Date: Tue, 6 Jun 2023 17:57:10 -0700
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
Message-ID: <ZH/V5gf+YjKuC0bn@C02FL77VMD6R.googleapis.com>
References: <ZHE8P9Bi6FlKz4US@C02FL77VMD6R.googleapis.com>
 <20230526193324.41dfafc8@kernel.org>
 <ZHG+AR8qgpJ6/Zhx@C02FL77VMD6R.googleapis.com>
 <CAM0EoM=xLkAr5EF7bty+ETmZ3GXnmB9De3fYSCrQjKPb8qDy7Q@mail.gmail.com>
 <87jzwrxrz8.fsf@nvidia.com>
 <87fs7fxov6.fsf@nvidia.com>
 <ZHW9tMw5oCkratfs@C02FL77VMD6R.googleapis.com>
 <87bki2xb3d.fsf@nvidia.com>
 <ZHgXL+Bsm2M+ZMiM@C02FL77VMD6R.googleapis.com>
 <877csny9rd.fsf@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877csny9rd.fsf@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 01, 2023 at 09:20:39AM +0300, Vlad Buslov wrote:
> On Wed 31 May 2023 at 20:57, Peilin Ye <yepeilin.cs@gmail.com> wrote:
> > +static inline bool qdisc_is_destroying(const struct Qdisc *qdisc)
> > +{
> > +       return qdisc->flags & TCQ_F_DESTROYING;
> 
> Hmm, do we need at least some kind of {READ|WRITE}_ONCE() for accessing
> flags since they are now used in unlocked filter code path?

Thanks, after taking another look at cls_api.c, I noticed this code in
tc_new_tfilter():

	err = tp->ops->change(net, skb, tp, cl, t->tcm_handle, tca, &fh,
			      flags, extack);
	if (err == 0) {
		tfilter_notify(net, skb, n, tp, block, q, parent, fh,
			       RTM_NEWTFILTER, false, rtnl_held, extack);
		tfilter_put(tp, fh);
		/* q pointer is NULL for shared blocks */
		if (q)
			q->flags &= ~TCQ_F_CAN_BYPASS;
	}               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

TCQ_F_CAN_BYPASS is cleared after e.g. adding a filter to the Qdisc, and it
isn't atomic [1].

We also have this:

  ->dequeue()
    htb_dequeue()
      htb_dequeue_tree()
        qdisc_warn_nonwc():

  void qdisc_warn_nonwc(const char *txt, struct Qdisc *qdisc)
  {
          if (!(qdisc->flags & TCQ_F_WARN_NONWC)) {
                  pr_warn("%s: %s qdisc %X: is non-work-conserving?\n",
                          txt, qdisc->ops->id, qdisc->handle >> 16);
                  qdisc->flags |= TCQ_F_WARN_NONWC;
          }       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  }
  EXPORT_SYMBOL(qdisc_warn_nonwc);

Also non-atomic; isn't it possible for the above 2 underlined statements to
race with each other?  If true, I think we need to change Qdisc::flags to
use atomic bitops, just like what we're doing for Qdisc::state and
::state2.  It feels like a separate TODO, however.

I also thought about adding the new DELETED-REJECT-NEW-FILTERS flag to
::state2, but not sure if it's okay to extend it for our purpose.

Thanks,
Peilin Ye

[1] Compiled to this on my Intel 64:

   0x0000000000017788 <+6472>:	83 62 10 fb        	andl   $0xfffffffb,0x10(%rdx)


