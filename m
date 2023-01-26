Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0658167D02E
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 16:29:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231823AbjAZP3G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 10:29:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230423AbjAZP3D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 10:29:03 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F4034170D
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 07:29:00 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id y69so709439iof.3
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 07:29:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Vhzd9mVvtO9xrnQSd81VID3Vc5urJ1mPS6Ug9FWKZf0=;
        b=k/TecLWDx07q77nyq7OuBS5KAnBsIY/ZtA2eGLgf5uf0h1F5YSP+8J+34/iLNp4cIx
         87zpIQLFr2Mr1sq9n3TDfhByi4kHevLc5Vx+S3kOQxXLArXh7omkXLXYPhMFTrbbzyn5
         dMwe6TjimTa9L+BivvuR74siz4GA+Ukivy4KaX64krRwVqWlLZLrAv5zGGAeMYEwPVIa
         v+w1yyX7LyxGVU5iFjgoFdn5DsFHQoO+ug1l4q0j/LIDAUMomZXCQTmQsxViyt+X1yXE
         Vo+PD80R3ivibAIC4f5xzXcczoueRpykydvLIyaa30+1ZEL09/Z9jhcWiSpFXxo6wCWh
         6SGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Vhzd9mVvtO9xrnQSd81VID3Vc5urJ1mPS6Ug9FWKZf0=;
        b=44opS0qDBglksz0vUy0A3T+cHPQTJH472k9ygA5TRrY30ymM76FRC6Xs9k6YvIMnQm
         /r5YzYZ3W3UJeEiTZyayIZM8u8JF3KbaDbjlZjXqSlrjvSWCLZ/u6/q1mSht8XGPVUIt
         iitNArGhc93sMdgBCJtakhGaFNycqoZpzGIsyt3WJxXYIfyMIl4OTOjgEBUax3w7SCgd
         JHSMI2W8eWthZH4a55MpZiP47b8HZqC0Bi0dGqI3yIhIgw5U9i3rVzGy2BM14mVH4o9o
         EXRpMq+ucU+xtCHPzqKyQR7QJE0wBNxu8vOBX0zXh+ZXfRstkJ8OyQYQrLOpVGAYlrBe
         a7sA==
X-Gm-Message-State: AFqh2kroUvB4QbWKrX7DZGueZzfAAcKmTW945Y65SeHpsfJFIsv1mfyV
        lkSa1mpOsy3qip0bew04AZWGm8tKdSvLjubg8sYSDQ==
X-Google-Smtp-Source: AMrXdXvzYzEz/Q8kINSnWz0o8VxWlMXtjv2r/TVd+6w0UTP9/e/9F2m39XCFE0sEDZy+Los0KygfEvumv03/yyKnLAE=
X-Received: by 2002:a02:cc96:0:b0:39e:5dc6:eba5 with SMTP id
 s22-20020a02cc96000000b0039e5dc6eba5mr4046674jap.115.1674746940333; Thu, 26
 Jan 2023 07:29:00 -0800 (PST)
MIME-Version: 1.0
References: <20230124170510.316970-1-jhs@mojatatu.com> <20230124170510.316970-15-jhs@mojatatu.com>
 <87fsbyco43.fsf@nvidia.com>
In-Reply-To: <87fsbyco43.fsf@nvidia.com>
From:   Jamal Hadi Salim <hadi@mojatatu.com>
Date:   Thu, 26 Jan 2023 10:28:49 -0500
Message-ID: <CAAFAkD8CYey6inOuxv7doWBaro-rpwcLXyDjbte=VMKb-YRKcg@mail.gmail.com>
Subject: Re: [PATCH net-next RFC 15/20] p4tc: add action template create,
 update, delete, get, flush and dump
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, netdev@vger.kernel.org,
        kernel@mojatatu.com, deb.chatterjee@intel.com,
        anjali.singhai@intel.com, namrata.limaye@intel.com,
        khalidm@nvidia.com, tom@sipanda.io, pratyush@sipanda.io,
        jiri@resnulli.us, xiyou.wangcong@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        simon.horman@corigine.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 25, 2023 at 4:15 PM 'Vlad Buslov' via kernel issues
<kernel@mojatatu.com> wrote:
>
> On Tue 24 Jan 2023 at 12:05, Jamal Hadi Salim <jhs@mojatatu.com> wrote:
> > index fd012270d..e4a6d7da6 100644
> > +                     bool miss;

[..]

> > +static int __tcf_p4_dyna_init(struct net *net, struct nlattr *est,
> > +                           struct p4tc_act *act, struct tc_act_dyna *parm,
> > +                           struct tc_action **a, struct tcf_proto *tp,
> > +                           struct tc_action_ops *a_o,
> > +                           struct tcf_chain **goto_ch, u32 flags,
> > +                           struct netlink_ext_ack *extack)
> > +{
> > +     bool bind = flags & TCA_ACT_FLAGS_BIND;
> > +     bool exists = false;
> > +     int ret = 0;
> > +     struct p4tc_pipeline *pipeline;
> > +     u32 index;
> > +     int err;
> > +
> > +     index = parm->index;
> > +
> > +     err = tcf_idr_check_alloc(act->tn, &index, a, bind);
> > +     if (err < 0)
> > +             return err;
> > +
> > +     exists = err;
> > +     if (!exists) {
> > +             struct tcf_p4act *p;
> > +
> > +             ret = tcf_idr_create(act->tn, index, est, a, a_o, bind, false,
> > +                                  flags);
> > +             if (ret) {
> > +                     tcf_idr_cleanup(act->tn, index);
> > +                     return ret;
> > +             }
> > +
> > +             /* dyn_ref here should never be 0, because if we are here, it
> > +              * means that a template action of this kind was created. Thus
> > +              * dyn_ref should be at least 1. Also since this operation and
> > +              * others that add or delete action templates run with
> > +              * rtnl_lock held, we cannot do this op and a deletion op in
> > +              * parallel.
> > +              */
>
> I'm not getting why you need atomic refcount here if according to the
> comment it is used with rtnl lock protection anyway...
>

> > +             WARN_ON(!refcount_inc_not_zero(&a_o->dyn_ref));
> > +
> > +             pipeline = act->pipeline;
> > +
> > +             p = to_p4act(*a);
> > +             p->p_id = pipeline->common.p_id;
> > +             p->act_id = act->a_id;
> > +             INIT_LIST_HEAD(&p->cmd_operations);

[..]

> > +
> > +     params = rcu_dereference_protected(m->params, 1);
> > +
> > +     if (refcount_read(&ops->dyn_ref) > 1)
> > +             refcount_dec(&ops->dyn_ref);
>
> ...especially since usage like this is definitely not concurrency-safe
> without some external protection.
>

I think you may be right - we'll take a closer look. Initially our
goal was to avoid
rtnl lock then we decided to use rtnl only for templates and this may have been
a leftover.

> > +
> > +     spin_lock_bh(&m->tcf_lock);
> > +     if (params)
> > +             call_rcu(&params->rcu, tcf_p4_act_params_destroy_rcu);
> > +     spin_unlock_bh(&m->tcf_lock);
>
> Why take tcf_lock for scheduling a rcu callback?
>

Seems like a leftover.. Thanks for catching this.

cheers,
jamal
