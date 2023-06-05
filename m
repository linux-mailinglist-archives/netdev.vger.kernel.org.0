Return-Path: <netdev+bounces-7970-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AD596722434
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 13:09:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 268791C20A34
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 11:09:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AE9D168CA;
	Mon,  5 Jun 2023 11:09:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CF0C525E
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 11:09:42 +0000 (UTC)
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3265EA
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 04:09:40 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id ffacd0b85a97d-307d58b3efbso4052585f8f.0
        for <netdev@vger.kernel.org>; Mon, 05 Jun 2023 04:09:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1685963379; x=1688555379;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=AFYjsG2ADeG/Hnb5HRqfQRl/DjCBoXvjMmf5GZ+DDDU=;
        b=zS9ZNcCWqwj4tVrDWiJD4VskPa5v6OcV5jb117mCrt2KMp0LSEr1gmokNBXxGzzJWq
         cXmt9OfqpqCaBPEYxs3bFyqvUM1985wmtV//VGeUKj12aXWqpgLa5z/8tXIr48aaosy4
         ooiZUsv/cEKNNwmZJ+j2YcAcPhm+j2MtA1oQN/tn4Ok0sHkSqruQPgvU3vjozkz4naa/
         vpVokcj8NY6zlfTazvrnZLNljQllxjtAyclrmRs1nsIbL+ls774N6bqb0ypr6CdFULqe
         W5uxblhEOx4Lp1cWdPcosS/C7VRUGbTltxZnWR5fQCq6eUZ/OPrydNmbrDFQwQwWCzhA
         CFpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685963379; x=1688555379;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AFYjsG2ADeG/Hnb5HRqfQRl/DjCBoXvjMmf5GZ+DDDU=;
        b=Oo0T2NpefpL1NloFzNTND0xqd5Jhfb3WfI9WPK381thNRjMZTpAxVtEjk/7i76vRox
         9R+Z59i+AH94qD+imxLTMcChb8WRrZyMmsswwPm+h5G2hj588KbN+oCr6nFX2TSWKA2p
         u/2w5rn0171tacsN7M5AdOrm1gJlc8yFgKceok+MYFnOMae0pg/aaRSoj6qk39bL83ja
         uzw6n0IDiNkY9B4goaDWW6GJngAOJXVUdf+NAT15jdTfMt/Gce5VexfDTeQ1/7NBwHDd
         j4lkdU8PjONEbHZJk/+8iQFTpWCnr9uX6qDfbaunHRyU94LnU8ijv3cQGclpl0Xi3PeF
         zgcg==
X-Gm-Message-State: AC+VfDx/+DyNLFJBj2j5LbIUiOWq68E3wuwUUlNDHn8t0GFxDD7Fl6n6
	M6zgrA2vibPWaGDnvkb6EJQkNsV1hl9uMKynKjo=
X-Google-Smtp-Source: ACHHUZ5U4Bo8KRcxutfCVTlubgXmGZghqSwEMHExv3vZEN+D3B2jTHXhFZ+GUCOuSsQM9E98raVL8g==
X-Received: by 2002:a5d:4346:0:b0:30c:5535:77a7 with SMTP id u6-20020a5d4346000000b0030c553577a7mr4681518wrr.56.1685963379162;
        Mon, 05 Jun 2023 04:09:39 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id w16-20020adfd4d0000000b0030aefa3a957sm9480713wrk.28.2023.06.05.04.09.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jun 2023 04:09:37 -0700 (PDT)
Date: Mon, 5 Jun 2023 14:09:32 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Simon Horman <simon.horman@corigine.com>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>, netdev@vger.kernel.org,
	deb.chatterjee@intel.com, anjali.singhai@intel.com,
	namrata.limaye@intel.com, tom@sipanda.io,
	p4tc-discussions@netdevconf.info, mleitner@redhat.com,
	Mahesh.Shirshyad@amd.com, Vipin.Jain@amd.com,
	tomasz.osinski@intel.com, jiri@resnulli.us,
	xiyou.wangcong@gmail.com, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, vladbu@nvidia.com,
	khalidm@nvidia.com, toke@redhat.com
Subject: Re: [PATCH RFC v2 net-next 04/28] net/sched: act_api: add init_ops
 to struct tc_action_op
Message-ID: <9a777d0b-b212-4487-b5ac-9a05fafac6c7@kadam.mountain>
References: <20230517110232.29349-1-jhs@mojatatu.com>
 <20230517110232.29349-4-jhs@mojatatu.com>
 <ZH2wEocXqLEjiaqc@corigine.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZH2wEocXqLEjiaqc@corigine.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 05, 2023 at 11:51:14AM +0200, Simon Horman wrote:
> > @@ -1494,8 +1494,13 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
> >  			}
> >  		}
> >  
> > -		err = a_o->init(net, tb[TCA_ACT_OPTIONS], est, &a, tp,
> > -				userflags.value | flags, extack);
> > +		if (a_o->init)
> > +			err = a_o->init(net, tb[TCA_ACT_OPTIONS], est, &a, tp,
> > +					userflags.value | flags, extack);
> > +		else if (a_o->init_ops)
> > +			err = a_o->init_ops(net, tb[TCA_ACT_OPTIONS], est, &a,
> > +					    tp, a_o, userflags.value | flags,
> > +					    extack);
> 
> By my reading the initialisation of a occurs here.
> Which is now conditional.
> 

Right.  Presumably the author knows that one (and only one) of the
->init or ->init_ops pointers is set.  This kind of relationship between
two variables is something that Smatch tries to track inside a function
but outside of functions, like here, then Smatch doesn't track it.
I can't really think of a scalable way to track this.

So there are a couple options:

1) Ignore the warning.
2) Remove the second if.

	if (a_o->init)
		err = a_o->init();
	else
		err = a_o->init_ops();

I kind of like this, because I think it communicates the if ->init()
isn't set then ->init_ops() must be.

3) Add a return.

	if (a_o->init) {
		err = a_o->init();
	} else if (a_o->init_ops) {
		err = a_o->init_ops();
	} else {
		WARN_ON(1);
		return ERR_PTR(-EINVAL);
	}

4) Add an unreachable.  But the last time I suggested this it led to
link errors and I didn't get a chance to investigate so probably don't
do this:

	if (a_o->init) {
		err = a_o->init();
	} else if (a_o->init_ops) {
		err = a_o->init_ops();
	} else {
		unreachable();
	}

regards,
dan carpenter


