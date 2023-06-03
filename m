Return-Path: <netdev+bounces-7657-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 54645721022
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 15:10:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 96A0E1C20BCF
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 13:10:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08474C8C2;
	Sat,  3 Jun 2023 13:10:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECBFB2904
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 13:10:21 +0000 (UTC)
Received: from mail-yw1-x1136.google.com (mail-yw1-x1136.google.com [IPv6:2607:f8b0:4864:20::1136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A233180
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 06:10:20 -0700 (PDT)
Received: by mail-yw1-x1136.google.com with SMTP id 00721157ae682-565de553de1so48121397b3.0
        for <netdev@vger.kernel.org>; Sat, 03 Jun 2023 06:10:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1685797820; x=1688389820;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OXcuj+bOxs7NmQto40UZY/i8j8enPnrsh+Jnw1g/qM4=;
        b=m4IOzUkZ+RrZfG56pztg9413fuKUCRk656Lp3sAVX+4C8S31Z7L1vZ97ihoBlJAgzo
         0U0EB4TG2XAwiXLBgB4//qm+8xKoEOlGnOCo9tGtXeiafpUVfFh3mbskwsJYTeGNAIcm
         70//8fCqqMl4W5mfW5X3OeT0ecxdsscyW9VqrQ+Z/g7Rkdrg0KE7X95Gc1o1U3hFGxRG
         hF2daNFHWFjYPi9VisOFAA8rXfKy6umUbz2MGf9Ob79IFf4zDTC/+6Jrm6lQJ/xx6IqM
         JMzQ7Edz0NrbBKyABND+FBfyAdQH/NogpbnfSOwEzJ8quzMiQgm026wtlBrA8FWPmQuy
         LcjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685797820; x=1688389820;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OXcuj+bOxs7NmQto40UZY/i8j8enPnrsh+Jnw1g/qM4=;
        b=Xik1ROoBaQfJLRDjRhe9vPRRk8kgRZCHiUJnHL/52ifH5POVixFpEKlPHXFwOyubc3
         YwKikE9vZmabqPJjwO6DCr/5e5uBSkaTt7ILmwUvhKmatcUomIFcy27EqhON5DJBzRHl
         dBLMk8qEdg50jF5FWA8X9Co8uzKWsTXvwcOTL1pPEvryf+ueVb399tvtWADzSxpgMJdv
         sRG108uYe57PBVl0r1W7eHNf97vfqoL89+8Nxq0Nq4z7RX6g6zmVwIQdy8SKJdkWtJH/
         3Ap/8SPa5bJCz1WxRe6sDBM/IJJrUA7omR8u3J4JtnLzvCBg4vnfNim8Rocqev4ax1ZY
         KzkA==
X-Gm-Message-State: AC+VfDx0XjPaIDF3tWyZ2LmqZtRINARHZWPJzKyC6vJC48BYTNCz4sR6
	BeoTDwCnTIEa6fIQ1JIR09kbfw+BXt8eQs0hcqx/PQ==
X-Google-Smtp-Source: ACHHUZ63Zb3fiS8E9+vLtgnNe9U7zcFiEIr6uhaHy0qt2YTVioIPSVV/HQab4y45yZuZ1ccO5cDQ5ZMkHCGeIjerVVc=
X-Received: by 2002:a81:4943:0:b0:55d:626e:3dcf with SMTP id
 w64-20020a814943000000b0055d626e3dcfmr2986435ywa.12.1685797819819; Sat, 03
 Jun 2023 06:10:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230517110232.29349-1-jhs@mojatatu.com> <20230517110232.29349-5-jhs@mojatatu.com>
 <CALnP8ZYDriSnxVtdUD5_hcvop_ojuTHWoK8DpQ+x4KgBqRTD2w@mail.gmail.com>
In-Reply-To: <CALnP8ZYDriSnxVtdUD5_hcvop_ojuTHWoK8DpQ+x4KgBqRTD2w@mail.gmail.com>
From: Jamal Hadi Salim <jhs@mojatatu.com>
Date: Sat, 3 Jun 2023 09:10:08 -0400
Message-ID: <CAM0EoMk0sk0+O43wN_zAnUhCYNPNYG=2s+Hb9JFeLWVCTJibNw@mail.gmail.com>
Subject: Re: [PATCH RFC v2 net-next 05/28] net/sched: act_api: introduce tc_lookup_action_byid()
To: Marcelo Ricardo Leitner <mleitner@redhat.com>
Cc: netdev@vger.kernel.org, deb.chatterjee@intel.com, anjali.singhai@intel.com, 
	namrata.limaye@intel.com, tom@sipanda.io, p4tc-discussions@netdevconf.info, 
	Mahesh.Shirshyad@amd.com, Vipin.Jain@amd.com, tomasz.osinski@intel.com, 
	jiri@resnulli.us, xiyou.wangcong@gmail.com, davem@davemloft.net, 
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, vladbu@nvidia.com, 
	simon.horman@corigine.com, khalidm@nvidia.com, toke@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 2, 2023 at 3:36=E2=80=AFPM Marcelo Ricardo Leitner
<mleitner@redhat.com> wrote:
>
> On Wed, May 17, 2023 at 07:02:09AM -0400, Jamal Hadi Salim wrote:
> > +/* lookup by ID */
> > +struct tc_action_ops *tc_lookup_action_byid(struct net *net, u32 act_i=
d)
> > +{
> > +     struct tcf_dyn_act_net *base_net;
> > +     struct tc_action_ops *a, *res =3D NULL;
> > +
> > +     if (!act_id)
> > +             return NULL;
> > +
> > +     read_lock(&act_mod_lock);
> > +
> > +     list_for_each_entry(a, &act_base, head) {
> > +             if (a->id =3D=3D act_id) {
> > +                     if (try_module_get(a->owner)) {
> > +                             read_unlock(&act_mod_lock);
> > +                             return a;
> > +                     }
> > +                     break;
>
> It shouldn't call break here but instead already return NULL:
> if id matched, it cannot be present on the dyn list.
>
> Moreover, the search be optimized: now that TCA_ID_ is split between
> fixed and dynamic ranges (patch #3), it could jump directly into the
> right list. Control path performance is also important..
>

Good catch again. This is actually a bug we missed in our code review.
We'll fix it in the next update.

cheers,
jamal


> > +             }
> > +     }
> > +     read_unlock(&act_mod_lock);
> > +
> > +     read_lock(&base_net->act_mod_lock);
> > +
> > +     base_net =3D net_generic(net, dyn_act_net_id);
> > +     a =3D idr_find(&base_net->act_base, act_id);
> > +     if (a && try_module_get(a->owner))
> > +             res =3D a;
> > +
> > +     read_unlock(&base_net->act_mod_lock);
> > +
> > +     return res;
> > +}
> > +EXPORT_SYMBOL(tc_lookup_action_byid);
>

