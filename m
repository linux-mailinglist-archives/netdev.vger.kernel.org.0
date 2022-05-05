Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68B2151C20C
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 16:13:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379723AbiEEORC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 10:17:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240196AbiEEORB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 10:17:01 -0400
Received: from us-smtp-delivery-74.mimecast.com (us-smtp-delivery-74.mimecast.com [170.10.133.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9899D58E7E
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 07:13:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651760000;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wwN1e1whsjkmkC6akXsxdIb77WoDE8GhtrvHHrY3wb8=;
        b=KBJCoI8yTCmsyqIdIApZpGab5Lm03JAsAco3+y+hPrgqQrIyieio18rD1Wzha152Lal+1C
        9mVQ+VmgWR23x18AFjQa9E+SuNXvI+0FymEmwQuAPOyEwPtZMY35kaHwqLJ3A9bKscBcAR
        4PBPw5k3+aoOx3xx7c5TiXQjYxX85rM=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-50-3NRd_O2ZP_So7oUQhLU6OA-1; Thu, 05 May 2022 10:13:19 -0400
X-MC-Unique: 3NRd_O2ZP_So7oUQhLU6OA-1
Received: by mail-wr1-f70.google.com with SMTP id k29-20020adfb35d000000b0020adc94662dso1508982wrd.12
        for <netdev@vger.kernel.org>; Thu, 05 May 2022 07:13:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=wwN1e1whsjkmkC6akXsxdIb77WoDE8GhtrvHHrY3wb8=;
        b=4TZNUlnZ4y7HzdZQUGDxMVAU9AFwIYLR4Q1crgkR3yMyXGTtuCEDErjc53YhWDEWfN
         oCZBm+CQTiAXOZcF/K3mjWvhrS3hDn8X93Uekz+DVZCPM2fwxfQOHY31lSaNPM04ZluN
         jCBmca1WTw9vQi717vgxmiYnQDPsFpRRtlrtNvTYX6dwJPgCydEGfAgJrVMITsiPC4cC
         0/f5dgLoNRdcM2MfWECTN9FUV0PbrxFuMtiHpbenxJ33oq6VD3XHcSDBYG6pVLwIiFun
         c3rlADm1iAd00Es8dQTD7w5acLce1NrvPourdgD+iBfkRQhHdbeplsGxU0vBt+jZ6FB6
         cjEA==
X-Gm-Message-State: AOAM531S584pcvCvCviE0swTERf3ZZBJBvULqRSYkjW+1sxD9hsR2vvJ
        3gLPIDABZE0tSrCo+rrvqb5Jzwl1gzbF3J8BGW3vpHjbSyVnpMcKlE1DOTAD+FSBloQ3jjbzIhC
        Qi3MKblevtpD+6g3c
X-Received: by 2002:adf:fb10:0:b0:207:af88:1eb9 with SMTP id c16-20020adffb10000000b00207af881eb9mr21489680wrr.238.1651759998160;
        Thu, 05 May 2022 07:13:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwrPJ9I7u1mKvPT7YngJT3m0Chu04BdovJaqHP58RYcGGFavejzg8lGB/tWPPNfWfm+nZiElQ==
X-Received: by 2002:adf:fb10:0:b0:207:af88:1eb9 with SMTP id c16-20020adffb10000000b00207af881eb9mr21489650wrr.238.1651759997828;
        Thu, 05 May 2022 07:13:17 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-115-66.dyn.eolo.it. [146.241.115.66])
        by smtp.gmail.com with ESMTPSA id o23-20020a5d58d7000000b0020c635ca28bsm1309507wrf.87.2022.05.05.07.13.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 May 2022 07:13:17 -0700 (PDT)
Message-ID: <f4f5e03ebfda9ff04a25eef0d0ed1cd05804247c.camel@redhat.com>
Subject: Re: [PATCH net] net/sched: act_pedit: really ensure the skb is
 writable
From:   Paolo Abeni <pabeni@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Date:   Thu, 05 May 2022 16:13:15 +0200
In-Reply-To: <20220504200432.47205429@kernel.org>
References: <6c1230ee0f348230a833f92063ff2f5fbae58b94.1651584976.git.pabeni@redhat.com>
         <20220504200432.47205429@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-05-04 at 20:04 -0700, Jakub Kicinski wrote:
> On Tue,  3 May 2022 16:05:42 +0200 Paolo Abeni wrote:
> > Currently pedit tries to ensure that the accessed skb offset
> > is writeble via skb_unclone(). The action potentially allows
> > touching any skb bytes, so it may end-up modifying shared data.
> > 
> > The above causes some sporadic MPTCP self-test failures.
> > 
> > Address the issue keeping track of a rough over-estimate highest skb
> > offset accessed by the action and ensure such offset is really
> > writable.
> > 
> > Note that this may cause performance regressions in some scenario,
> > but hopefully pedit is not critical path.
> > 
> > Fixes: db2c24175d14 ("act_pedit: access skb->data safely")
> > Acked-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
> > Tested-by: Geliang Tang <geliang.tang@suse.com>
> > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> > ---
> > Note: AFAICS the issue is present since 1da177e4c3f4
> > ("Linux-2.6.12-rc2"), but before the "Fixes" commit this change
> > is irrelevant, because accessing any data out of the skb head
> > will cause an oops.
> > ---
> >  include/net/tc_act/tc_pedit.h |  1 +
> >  net/sched/act_pedit.c         | 23 +++++++++++++++++++++--
> >  2 files changed, 22 insertions(+), 2 deletions(-)
> > 
> > diff --git a/include/net/tc_act/tc_pedit.h b/include/net/tc_act/tc_pedit.h
> > index 748cf87a4d7e..3e02709a1df6 100644
> > --- a/include/net/tc_act/tc_pedit.h
> > +++ b/include/net/tc_act/tc_pedit.h
> > @@ -14,6 +14,7 @@ struct tcf_pedit {
> >  	struct tc_action	common;
> >  	unsigned char		tcfp_nkeys;
> >  	unsigned char		tcfp_flags;
> > +	u32			tcfp_off_max_hint;
> >  	struct tc_pedit_key	*tcfp_keys;
> >  	struct tcf_pedit_key_ex	*tcfp_keys_ex;
> >  };
> > diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
> > index 31fcd279c177..a8ab6c3f1ea2 100644
> > --- a/net/sched/act_pedit.c
> > +++ b/net/sched/act_pedit.c
> > @@ -149,7 +149,7 @@ static int tcf_pedit_init(struct net *net, struct nlattr *nla,
> >  	struct nlattr *pattr;
> >  	struct tcf_pedit *p;
> >  	int ret = 0, err;
> > -	int ksize;
> > +	int i, ksize;
> >  	u32 index;
> >  
> >  	if (!nla) {
> > @@ -228,6 +228,20 @@ static int tcf_pedit_init(struct net *net, struct nlattr *nla,
> >  		p->tcfp_nkeys = parm->nkeys;
> >  	}
> >  	memcpy(p->tcfp_keys, parm->keys, ksize);
> > +	p->tcfp_off_max_hint = 0;
> 
> This gets zeroed here... [1]
> 
> > +	for (i = 0; i < p->tcfp_nkeys; ++i) {
> > +		u32 cur = p->tcfp_keys[i].off;
> > +
> > +		/* The AT option can read a single byte, we can bound the actual
> > +		 * value with uchar max. Each key touches 4 bytes starting from
> > +		 * the computed offset
> > +		 */
> > +		if (p->tcfp_keys[i].offmask) {
> > +			cur += 255 >> p->tcfp_keys[i].shift;
> 
> Could be written as:
> 
> 		cur += (0xff & p->tcfp_keys[i].offmask) >>
> 			p->tcfp_keys[i].shift;
> 
> without the if? That would be closer to the:
> 
> 		offset += (*d & tkey->offmask) >> tkey->shift;
> 
> which ends up getting executed.
> 
> > +			cur = max(p->tcfp_keys[i].at, cur);
> 
> We never write under ->at, tho, so this shouldn't be needed?

Every thing you mentioned looks correct, I'll take care in v2.

> 
> > +		}
> > +		p->tcfp_off_max_hint = max(p->tcfp_off_max_hint, cur + 4);
> > +	}
> >  
> >  	p->tcfp_flags = parm->flags;
> >  	goto_ch = tcf_action_set_ctrlact(*a, parm->action, goto_ch);
> > @@ -308,9 +322,14 @@ static int tcf_pedit_act(struct sk_buff *skb, const struct tc_action *a,
> >  			 struct tcf_result *res)
> >  {
> >  	struct tcf_pedit *p = to_pedit(a);
> > +	u32 max_offset;
> >  	int i;
> >  
> > -	if (skb_unclone(skb, GFP_ATOMIC))
> > +	max_offset = (skb_transport_header_was_set(skb) ?
> > +		      skb_transport_offset(skb) :
> > +		      skb_network_offset(skb)) +
> > +		     p->tcfp_off_max_hint;
> 
> [1] ... and used here outside of the lock. Isn't it racy?

Indeed it is. I'll fix in v2 extending the lock over here (including
the allocation, sigh).

Later, for net-next I think we could refactor the code to avoid the
lock in the data path with something alike c749cdda9089 ("net/sched:
act_skbedit: don't use spinlock in the data path")


Thanks!

Paolo

