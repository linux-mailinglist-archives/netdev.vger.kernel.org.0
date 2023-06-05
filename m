Return-Path: <netdev+bounces-8081-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F2EF6722A15
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 16:58:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5CECB1C20946
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 14:58:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 175531F19E;
	Mon,  5 Jun 2023 14:57:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AF256FDE
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 14:57:45 +0000 (UTC)
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 614AF102
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 07:57:43 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id 5b1f17b1804b1-3f61530506aso50146375e9.1
        for <netdev@vger.kernel.org>; Mon, 05 Jun 2023 07:57:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1685977061; x=1688569061;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=NOiTurV+9/j9WH0zl7JK7NK6JZlk+eL5Fboua9hUWbA=;
        b=QmxfxJHJKyVacHeKf1StM8z2s7TP2GOEHH+qmW3l8nmMaLj6ofXPPAk1UgpzYbu3PE
         9I6yu3OqFkDUnt529oF0Y/6aqaZPJde7dyf8pljKHJFq2M+aBkGFuSoALm3oTYPxVKf2
         QdnqGumb4DXMyy8uC6qDajKuQ5d7ZQOXYLr5siLmncrtKATaymhUqWZwWfJkmAoeiBgu
         Jlh4+za62XM6qR09sHVRkEMK9ueWTIF+CL3BNXRUrII5BNo8cX4OZy1IqFJIoGz8/j2W
         r0bt0VjclZc6gR6oqirMLUCzbEg0RNwygxMKQxWKmaJigmgC1Wml2f6JXNlGvS5juLwi
         QleA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685977061; x=1688569061;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NOiTurV+9/j9WH0zl7JK7NK6JZlk+eL5Fboua9hUWbA=;
        b=YgRvzEDz3pUzvQSvixDM2DYa8YDT01O6B/4x5SRdZd0Fy8rRMWi75tikByKsj3e7bU
         d4LQOLqQI+wFaJhgqxBhhkOkvBvyL4D6Kmy2l3NrmEL1HT5iY/tD2ehATU1xUqfvorBY
         Qv/vFUKI9KmpROsOC12Gzw7J+YUdF/dWElBOmyC+FxWj04An6etM6M4PCFh2kAkvrhD0
         nMRMj/NGqVrGZhWSRU1cJxAJDSjOwvpOagXM3g7Pe5httUhPN4pI/L98+odDxxw7Mli+
         sNKfuVrhA8oq2BRpERYAMaLEVyzXlbFfZRMLe2R9ZbmH8/u1m0+7bTpS0G90BmWGxLe3
         l7JQ==
X-Gm-Message-State: AC+VfDxmFXY0VufISvXLMha3qfaHRG6Uf0N/8o6gC4SF+JceFBt3/yCc
	Sa0w2boM8OapZ1z9gSs0gM8Cvg==
X-Google-Smtp-Source: ACHHUZ6IadM6n9JWVUs0E/DDY5ObdvqJ6VMmPQHMuuxwz4bbQ1K/lhDXxqHo+hYsD1c/Lkz3wujKhg==
X-Received: by 2002:a05:600c:3781:b0:3f7:e536:8f0f with SMTP id o1-20020a05600c378100b003f7e5368f0fmr1779539wmr.21.1685977061591;
        Mon, 05 Jun 2023 07:57:41 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id g26-20020a7bc4da000000b003f50e88ffc1sm14772340wmk.0.2023.06.05.07.57.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jun 2023 07:57:40 -0700 (PDT)
Date: Mon, 5 Jun 2023 17:57:36 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Jamal Hadi Salim <hadi@mojatatu.com>
Cc: Simon Horman <simon.horman@corigine.com>, netdev@vger.kernel.org,
	deb.chatterjee@intel.com, tom@sipanda.io,
	p4tc-discussions@netdevconf.info, Mahesh.Shirshyad@amd.com,
	Vipin.Jain@amd.com, tomasz.osinski@intel.com,
	xiyou.wangcong@gmail.com, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, khalidm@nvidia.com,
	toke@redhat.com
Subject: Re: [p4tc-discussions] Re: [PATCH RFC v2 net-next 04/28] net/sched:
 act_api: add init_ops to struct tc_action_op
Message-ID: <9ae2fc87-40a4-4ca8-afcd-a85392f01181@kadam.mountain>
References: <20230517110232.29349-1-jhs@mojatatu.com>
 <20230517110232.29349-4-jhs@mojatatu.com>
 <ZH2wEocXqLEjiaqc@corigine.com>
 <9a777d0b-b212-4487-b5ac-9a05fafac6c7@kadam.mountain>
 <CAAFAkD-N4qeYpPMOf7WFORjnt0CDztBzHF2aF2iD+qRNLdCqbA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAFAkD-N4qeYpPMOf7WFORjnt0CDztBzHF2aF2iD+qRNLdCqbA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 05, 2023 at 10:01:44AM -0400, Jamal Hadi Salim wrote:
> On Mon, Jun 5, 2023 at 7:39 AM Dan Carpenter via p4tc-discussions
> <p4tc-discussions@netdevconf.info> wrote:
> >
> > On Mon, Jun 05, 2023 at 11:51:14AM +0200, Simon Horman wrote:
> > > > @@ -1494,8 +1494,13 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
> > > >                     }
> > > >             }
> > > >
> > > > -           err = a_o->init(net, tb[TCA_ACT_OPTIONS], est, &a, tp,
> > > > -                           userflags.value | flags, extack);
> > > > +           if (a_o->init)
> > > > +                   err = a_o->init(net, tb[TCA_ACT_OPTIONS], est, &a, tp,
> > > > +                                   userflags.value | flags, extack);
> > > > +           else if (a_o->init_ops)
> > > > +                   err = a_o->init_ops(net, tb[TCA_ACT_OPTIONS], est, &a,
> > > > +                                       tp, a_o, userflags.value | flags,
> > > > +                                       extack);
> > >
> > > By my reading the initialisation of a occurs here.
> > > Which is now conditional.
> > >
> >
> > Right.  Presumably the author knows that one (and only one) of the
> > ->init or ->init_ops pointers is set.
> 
> Yes, this is correct and the code above checks i.e
>  -     if (!act->act || !act->dump || !act->init)
>  +     if (!act->act || !act->dump || (!act->init && !act->init_ops))
>                return -EINVAL;
> 

Ah.  Right.

> > This kind of relationship between
> > two variables is something that Smatch tries to track inside a function
> > but outside of functions, like here, then Smatch doesn't track it.
> > I can't really think of a scalable way to track this.
> 
> Could you have used the statement i referred to above as part of the state?
> 

If the if statement were in the same function then Smatch would be able
to parse this but that relationship information doesn't carry across the
function boundary.  It's actually quite a bit more complicated than just
the function boundary even...  I don't know if this is even possible but
if it were then it would be like a 5-7 year time frame to make it work...

regards,
dan carpenter


