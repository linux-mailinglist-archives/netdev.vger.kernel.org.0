Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD10167CAFE
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 13:37:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236057AbjAZMhv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 07:37:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237060AbjAZMht (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 07:37:49 -0500
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E35083D3
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 04:37:46 -0800 (PST)
Received: by mail-yb1-xb30.google.com with SMTP id 129so1827467ybb.0
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 04:37:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=wuq36lFbveBHbQXzx8e5U3JeAOTtLA4/Yd8LmkN3B84=;
        b=lroEO/UnCKY8qAlgEJFEd21oW/nxkzsJBYBHtFRPC0hLhU5RLhPJ4a5ZCjUogDs2TQ
         35OhXwZVMKp2DytPSbuKQxyaB3ageuWHE+AwmzA61NInu3FOKqY2AVO1FZPbOQrSa0vD
         OjUdxXRRFCev01oKKuwLUaB342IA0zcix76IMPCpd5H8CG1rb8M/GLIzZL/WWSRgjxI2
         +TuPvyV1jPkBdlhilxEttOEZY6XACLkZtkI5o8iiLCiZHkCg5qqfewjWOeWKYnC89oUP
         ioE0XjAtmR3LSj1eeO6QRrQfyO2VVFl47PVkEbFt/1lYBQE4cebYT/tVOLjcbVAxRc18
         jAOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wuq36lFbveBHbQXzx8e5U3JeAOTtLA4/Yd8LmkN3B84=;
        b=ozGw5qNW9CDfqEUa3iXolTIS9cjwhqDNGbKo4RNTb4jR9lCDCFvXNWzfsxXoBGn1KV
         7mBlocd8Eb+kaowi7Pa9839jMqMVyua43RaMUh/tM6z1WV49O9u2A8ajxD9Ripu5rVc9
         2wN6bM7s+x9fVN0H5QTQd+LuDxXh9ZxoLvj2+1YS+Ur56/Gfgmod85nQXvfCAa9/Q3Px
         eegpybXUPySl46HdIW2c/PT/ZQvpA++08QOm2rVR/pb2YDYLaujA7jAwkNevQwMcQUIM
         xyZu/ZB2y9mMXAVTzPqiJLMOcmedM26amKGBdtPTDMiEm9Kio5z2XcUESUdx3UjDZuqG
         eySg==
X-Gm-Message-State: AO0yUKUTO4sjPYRxaIVW/J5fzexGkZvEdUT/5xp8JpmQh2GGrmhbpq+Q
        WSNFfbpXHBpWpnFg8jGVdPcOPJDqGhB6MInslsIHnw==
X-Google-Smtp-Source: AK7set/Z6XIZnNj0ZH9Wate1wfC6VBLlFefvQUYTvBLLA8mN6jU47HyVNBLy+dOJZKHZLIWstSp7oo1xpD0tV0hUuL4=
X-Received: by 2002:a25:b98d:0:b0:80b:cdc5:edf with SMTP id
 r13-20020a25b98d000000b0080bcdc50edfmr273764ybg.259.1674736665679; Thu, 26
 Jan 2023 04:37:45 -0800 (PST)
MIME-Version: 1.0
References: <20230124170510.316970-1-jhs@mojatatu.com> <87k01ad01q.fsf@nvidia.com>
In-Reply-To: <87k01ad01q.fsf@nvidia.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Thu, 26 Jan 2023 07:37:34 -0500
Message-ID: <CAM0EoMkqZmyUR6cRBu5vP46ik66iLaZZhJU-bEj7BaGfRaYbAA@mail.gmail.com>
Subject: Re: [PATCH net-next RFC 01/20] net/sched: act_api: change act_base
 into an IDR
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     netdev@vger.kernel.org, kernel@mojatatu.com,
        deb.chatterjee@intel.com, anjali.singhai@intel.com,
        namrata.limaye@intel.com, khalidm@nvidia.com, tom@sipanda.io,
        pratyush@sipanda.io, jiri@resnulli.us, xiyou.wangcong@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, simon.horman@corigine.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Good catch Vlad. Maybe we can pick 256 to be safe.

cheers,
jamal

On Wed, Jan 25, 2023 at 11:57 AM Vlad Buslov <vladbu@nvidia.com> wrote:
>
>
> On Tue 24 Jan 2023 at 12:04, Jamal Hadi Salim <jhs@mojatatu.com> wrote:
> > Convert act_base from a list to an IDR.
> >
> > With the introduction of P4TC action templates, we introduce the concept of
> > dynamically creating actions on the fly. Dynamic action IDs are not statically
> > defined (as was the case previously) and are therefore harder to manage within
> > existing linked list approach. We convert to IDR because it has built in ID
> > management which we would have to re-invent with linked lists.
> >
> > Co-developed-by: Victor Nogueira <victor@mojatatu.com>
> > Signed-off-by: Victor Nogueira <victor@mojatatu.com>
> > Co-developed-by: Pedro Tammela <pctammela@mojatatu.com>
> > Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
> > Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
> > ---
> >  include/uapi/linux/pkt_cls.h |  1 +
> >  net/sched/act_api.c          | 39 +++++++++++++++++++++---------------
> >  2 files changed, 24 insertions(+), 16 deletions(-)
> >
> > diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
> > index 648a82f32..4d716841c 100644
> > --- a/include/uapi/linux/pkt_cls.h
> > +++ b/include/uapi/linux/pkt_cls.h
> > @@ -139,6 +139,7 @@ enum tca_id {
> >       TCA_ID_MPLS,
> >       TCA_ID_CT,
> >       TCA_ID_GATE,
> > +     TCA_ID_DYN,
> >       /* other actions go here */
> >       __TCA_ID_MAX = 255
> >  };
> > diff --git a/net/sched/act_api.c b/net/sched/act_api.c
> > index cd09ef49d..811dddc3b 100644
> > --- a/net/sched/act_api.c
> > +++ b/net/sched/act_api.c
> > @@ -890,7 +890,7 @@ void tcf_idrinfo_destroy(const struct tc_action_ops *ops,
> >  }
> >  EXPORT_SYMBOL(tcf_idrinfo_destroy);
> >
> > -static LIST_HEAD(act_base);
> > +static DEFINE_IDR(act_base);
> >  static DEFINE_RWLOCK(act_mod_lock);
> >  /* since act ops id is stored in pernet subsystem list,
> >   * then there is no way to walk through only all the action
> > @@ -949,7 +949,6 @@ static void tcf_pernet_del_id_list(unsigned int id)
> >  int tcf_register_action(struct tc_action_ops *act,
> >                       struct pernet_operations *ops)
> >  {
> > -     struct tc_action_ops *a;
> >       int ret;
> >
> >       if (!act->act || !act->dump || !act->init)
> > @@ -970,13 +969,24 @@ int tcf_register_action(struct tc_action_ops *act,
> >       }
> >
> >       write_lock(&act_mod_lock);
> > -     list_for_each_entry(a, &act_base, head) {
> > -             if (act->id == a->id || (strcmp(act->kind, a->kind) == 0)) {
> > +     if (act->id) {
> > +             if (idr_find(&act_base, act->id)) {
> >                       ret = -EEXIST;
> >                       goto err_out;
> >               }
> > +             ret = idr_alloc_u32(&act_base, act, &act->id, act->id,
> > +                                 GFP_ATOMIC);
> > +             if (ret < 0)
> > +                     goto err_out;
> > +     } else {
> > +             /* Only dynamic actions will require ID generation */
> > +             act->id = TCA_ID_DYN;
>
> Hi Jamal,
>
> Since TCA_ID_DYN is exposed to userspace and this code expects to use
> the whole range of [TCA_ID_DYN, TCA_ID_MAX] for dynamic actions any new
> action added after that will have two choices:
>
> - Insert future TCA_ID_*NEW_ACTION* before TCA_ID_DYN in the enum tca_id
> in order for this code to continue to work (probably breaking userspace
> code compiled for previous kernels).
>
> - Modify this code to allocate dynamic action id from empty range
> following new action enum value, which is not ideal.
>
> Maybe consider defining TCA_ID_DYN=128 in order to leave some space for
> new actions to be added before it without affecting the userspace?
>
> > +
> > +             ret = idr_alloc_u32(&act_base, act, &act->id, TCA_ID_MAX,
> > +                                 GFP_ATOMIC);
> > +             if (ret < 0)
> > +                     goto err_out;
> >       }
> > -     list_add_tail(&act->head, &act_base);
> >       write_unlock(&act_mod_lock);
> >
> >       return 0;
> > @@ -994,17 +1004,12 @@ EXPORT_SYMBOL(tcf_register_action);
> >  int tcf_unregister_action(struct tc_action_ops *act,
> >                         struct pernet_operations *ops)
> >  {
> > -     struct tc_action_ops *a;
> > -     int err = -ENOENT;
> > +     int err = 0;
> >
> >       write_lock(&act_mod_lock);
> > -     list_for_each_entry(a, &act_base, head) {
> > -             if (a == act) {
> > -                     list_del(&act->head);
> > -                     err = 0;
> > -                     break;
> > -             }
> > -     }
> > +     if (!idr_remove(&act_base, act->id))
> > +             err = -EINVAL;
> > +
> >       write_unlock(&act_mod_lock);
> >       if (!err) {
> >               unregister_pernet_subsys(ops);
> > @@ -1019,10 +1024,11 @@ EXPORT_SYMBOL(tcf_unregister_action);
> >  static struct tc_action_ops *tc_lookup_action_n(char *kind)
> >  {
> >       struct tc_action_ops *a, *res = NULL;
> > +     unsigned long tmp, id;
> >
> >       if (kind) {
> >               read_lock(&act_mod_lock);
> > -             list_for_each_entry(a, &act_base, head) {
> > +             idr_for_each_entry_ul(&act_base, a, tmp, id) {
> >                       if (strcmp(kind, a->kind) == 0) {
> >                               if (try_module_get(a->owner))
> >                                       res = a;
> > @@ -1038,10 +1044,11 @@ static struct tc_action_ops *tc_lookup_action_n(char *kind)
> >  static struct tc_action_ops *tc_lookup_action(struct nlattr *kind)
> >  {
> >       struct tc_action_ops *a, *res = NULL;
> > +     unsigned long tmp, id;
> >
> >       if (kind) {
> >               read_lock(&act_mod_lock);
> > -             list_for_each_entry(a, &act_base, head) {
> > +             idr_for_each_entry_ul(&act_base, a, tmp, id) {
> >                       if (nla_strcmp(kind, a->kind) == 0) {
> >                               if (try_module_get(a->owner))
> >                                       res = a;
>
