Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2193C67CF01
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 15:54:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232346AbjAZOyg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 09:54:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231879AbjAZOyd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 09:54:33 -0500
Received: from mail-yw1-x112e.google.com (mail-yw1-x112e.google.com [IPv6:2607:f8b0:4864:20::112e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FEBC10D6
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 06:54:31 -0800 (PST)
Received: by mail-yw1-x112e.google.com with SMTP id 00721157ae682-4ff1fa82bbbso25818077b3.10
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 06:54:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=aJgaF5rM8OkqmKIErLjr0GNCE/k/i71l4Cp39vtTqC4=;
        b=U5lIIAdxxr576FSxh96IzQ6jE2YwWzHhfNbYQr+oTSBpPNAxPE3LxadNyypWMZPSlH
         NOdDKGG2YaIbb7WvIeesKMIuxjJ8CjVD6x1gdeiZn1gHWUhKpruPOAy/eAQTVN03c3dC
         f2D9g4CGRgFjSD2riqHcVUiTLYJHyyQxFv19bKXZVWIYCgLmhYlOCbZr+kUpaRoS42jT
         MX1D+KvSAGtkTqe09lGuq0rxaMiwSiYXbjak4MDwzFRdg449cIlGXei+6Kvpgd5OzNXe
         aqCHuuJRVuNcUB4+fFKiNY27VszLGKKa0nKjRA2k4K8GCPhT4135SXL6DpdDUKun+Xer
         Thkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aJgaF5rM8OkqmKIErLjr0GNCE/k/i71l4Cp39vtTqC4=;
        b=P6i5a7W8cv70CNayOMRZLyUeitQf2eIP1JcPYCtfDIlP1nich1NyNzb3FRioXpvMta
         M5S3VJvONJG3/SUA0XwBlKibrLtr+9IO++qt4+6fa7wtgWRYXWswGPUij0vYGRiZU4eh
         G8AhhpFSmuxU1pGw3E7ixgFlr05tg7JcSQbG8K0DRsCIH+iA0G7BwG2OUxZB8xIJ9BoK
         5lg46GGvNgsSS9ipT5W2P4d1wE4/Y9AdPx0xYU22RgZm+33ifWeLI0nLEwaE6C3hI+0h
         wE8SF/SgbXglvygMCcswbrnhC8dOhxPfLjQDfkKuyM2Lf6OP49R0I0rFZG+rxPzSy4UD
         4B1w==
X-Gm-Message-State: AO0yUKUQ4HeOKv+Ke3nYQTpBCk8Shi1c1eSTHpmi6CuiwMWwXyZpZYNs
        oIb192jTGdLmFyFWo4/tG/vAbdnTOqdfe2vAMwgwFw==
X-Google-Smtp-Source: AK7set8YxYZQ8wL3wSfk916rDmEkVS3Bjp8TcF3Ktnb6To/6iJTsny1G9ymiyndgTuhM0yMoaHjNl054QSQvkgjx6Y4=
X-Received: by 2002:a81:ab53:0:b0:506:3a16:693d with SMTP id
 d19-20020a81ab53000000b005063a16693dmr1453703ywk.360.1674744870645; Thu, 26
 Jan 2023 06:54:30 -0800 (PST)
MIME-Version: 1.0
References: <20230124170510.316970-1-jhs@mojatatu.com> <20230124170510.316970-14-jhs@mojatatu.com>
 <87357ycms6.fsf@nvidia.com>
In-Reply-To: <87357ycms6.fsf@nvidia.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Thu, 26 Jan 2023 09:54:19 -0500
Message-ID: <CAM0EoM=ZKcJXN4Y-wr0ip=eVkbRNv95SbYG5TQamFDimxWsG1Q@mail.gmail.com>
Subject: Re: [PATCH net-next RFC 14/20] p4tc: add header field create, get,
 delete, flush and dump
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

On Wed, Jan 25, 2023 at 4:44 PM Vlad Buslov <vladbu@nvidia.com> wrote:
>

[..]

> > +                                    struct netlink_ext_ack *extack)
> > +{
> > +     struct p4tc_hdrfield *hdrfield;
> > +
> > +     hdrfield = tcf_hdrfield_find_byany(parser, hdrfield_name, hdrfield_id,
> > +                                        extack);
> > +     if (IS_ERR(hdrfield))
> > +             return hdrfield;
> > +
> > +     /* Should never happen */
> > +     WARN_ON(!refcount_inc_not_zero(&hdrfield->hdrfield_ref));
>
> I think regular refcount_inc() already generates a warning when
> reference value is 0.

The thought here was we wanted to ensure ordering and i think somewhere
(maybe in the kernel doc?) it says refcount_inc_not_zero() ensures memory
ordering with dec(). This should only be needed if there is datapath
interaction with headers - i think there's none. We will review. i.e rtnl_lock
protection may be sufficient.

> > +
> > +     return hdrfield;
> > +}
> > +
> > +void tcf_hdrfield_put_ref(struct p4tc_hdrfield *hdrfield)
> > +{
> > +     WARN_ON(!refcount_dec_not_one(&hdrfield->hdrfield_ref));
>
> ditto
>
> > +}
> > +


cheers,
jamal
> > + * Copyright (c) 2022, Mojatatu Networks
> > + * Copyright (c) 2022, Intel Corporation.
> > + * Authors:     Jamal Hadi Salim <jhs@mojatatu.com>
> > + *              Victor Nogueira <victor@mojatatu.com>
> > + *              Pedro Tammela <pctammela@mojatatu.com>
> > + */
> > +
> > +#include <linux/types.h>
> > +#include <linux/kernel.h>
> > +#include <linux/string.h>
> > +#include <linux/errno.h>
> > +#include <linux/slab.h>
> > +#include <linux/skbuff.h>
> > +#include <linux/err.h>
> > +#include <linux/module.h>
> > +#include <net/net_namespace.h>
> > +#include <net/pkt_cls.h>
> > +#include <net/p4tc.h>
> > +#include <net/kparser.h>
> > +#include <net/netlink.h>
> > +
> > +static struct p4tc_parser *parser_find_name(struct p4tc_pipeline *pipeline,
> > +                                         const char *parser_name)
> > +{
> > +     if (unlikely(!pipeline->parser))
> > +             return NULL;
> > +
> > +     if (!strncmp(pipeline->parser->parser_name, parser_name, PARSERNAMSIZ))
> > +             return pipeline->parser;
> > +
> > +     return NULL;
> > +}
> > +
> > +struct p4tc_parser *tcf_parser_find_byid(struct p4tc_pipeline *pipeline,
> > +                                      const u32 parser_inst_id)
> > +{
> > +     if (unlikely(!pipeline->parser))
> > +             return NULL;
> > +
> > +     if (parser_inst_id == pipeline->parser->parser_inst_id)
> > +             return pipeline->parser;
> > +
> > +     return NULL;
> > +}
> > +
> > +static struct p4tc_parser *__parser_find(struct p4tc_pipeline *pipeline,
> > +                                      const char *parser_name,
> > +                                      u32 parser_inst_id,
> > +                                      struct netlink_ext_ack *extack)
> > +{
> > +     struct p4tc_parser *parser;
> > +     int err;
> > +
> > +     if (parser_inst_id) {
> > +             parser = tcf_parser_find_byid(pipeline, parser_inst_id);
> > +             if (!parser) {
> > +                     if (extack)
> > +                             NL_SET_ERR_MSG(extack,
> > +                                            "Unable to find parser by id");
> > +                     err = -EINVAL;
> > +                     goto out;
> > +             }
> > +     } else {
> > +             if (parser_name) {
> > +                     parser = parser_find_name(pipeline, parser_name);
> > +                     if (!parser) {
> > +                             if (extack)
> > +                                     NL_SET_ERR_MSG(extack,
> > +                                                    "Parser name not found");
> > +                             err = -EINVAL;
> > +                             goto out;
> > +                     }
> > +             } else {
> > +                     if (extack)
> > +                             NL_SET_ERR_MSG(extack,
> > +                                            "Must specify parser name or id");
> > +                     err = -EINVAL;
> > +                     goto out;
> > +             }
> > +     }
> > +
> > +     return parser;
> > +
> > +out:
> > +     return ERR_PTR(err);
> > +}
> > +
> > +struct p4tc_parser *tcf_parser_find_byany(struct p4tc_pipeline *pipeline,
> > +                                       const char *parser_name,
> > +                                       u32 parser_inst_id,
> > +                                       struct netlink_ext_ack *extack)
> > +{
> > +     return __parser_find(pipeline, parser_name, parser_inst_id, extack);
> > +}
> > +
> > +#ifdef CONFIG_KPARSER
> > +int tcf_skb_parse(struct sk_buff *skb, struct p4tc_skb_ext *p4tc_skb_ext,
> > +               struct p4tc_parser *parser)
> > +{
> > +     void *hdr = skb_mac_header(skb);
> > +     size_t pktlen = skb_mac_header_len(skb) + skb->len;
> > +
> > +     return __kparser_parse(parser->kparser, hdr, pktlen,
> > +                            p4tc_skb_ext->p4tc_ext->hdrs, HEADER_MAX_LEN);
> > +}
> > +
> > +static int __tcf_parser_fill(struct p4tc_parser *parser,
> > +                          struct netlink_ext_ack *extack)
> > +{
> > +     struct kparser_hkey kparser_key = { 0 };
> > +
> > +     kparser_key.id = parser->parser_inst_id;
> > +     strscpy(kparser_key.name, parser->parser_name, KPARSER_MAX_NAME);
> > +
> > +     parser->kparser = kparser_get_parser(&kparser_key, false);
> > +     if (!parser->kparser) {
> > +             NL_SET_ERR_MSG(extack, "Unable to get kparser instance");
> > +             return -ENOENT;
> > +     }
> > +
> > +     return 0;
> > +}
> > +
> > +void __tcf_parser_put(struct p4tc_parser *parser)
> > +{
> > +     kparser_put_parser(parser->kparser, false);
> > +}
> > +
> > +bool tcf_parser_is_callable(struct p4tc_parser *parser)
> > +{
> > +     return parser && parser->kparser;
> > +}
> > +#else
> > +int tcf_skb_parse(struct sk_buff *skb, struct p4tc_skb_ext *p4tc_skb_ext,
> > +               struct p4tc_parser *parser)
> > +{
> > +     return 0;
> > +}
> > +
> > +static int __tcf_parser_fill(struct p4tc_parser *parser,
> > +                          struct netlink_ext_ack *extack)
> > +{
> > +     return 0;
> > +}
> > +
> > +void __tcf_parser_put(struct p4tc_parser *parser)
> > +{
> > +}
> > +
> > +bool tcf_parser_is_callable(struct p4tc_parser *parser)
> > +{
> > +     return !!parser;
> > +}
> > +#endif
> > +
> > +struct p4tc_parser *
> > +tcf_parser_create(struct p4tc_pipeline *pipeline, const char *parser_name,
> > +               u32 parser_inst_id, struct netlink_ext_ack *extack)
> > +{
> > +     struct p4tc_parser *parser;
> > +     int ret;
> > +
> > +     if (pipeline->parser) {
> > +             NL_SET_ERR_MSG(extack,
> > +                            "Can only have one parser instance per pipeline");
> > +             return ERR_PTR(-EEXIST);
> > +     }
> > +
> > +     parser = kzalloc(sizeof(*parser), GFP_KERNEL);
> > +     if (!parser)
> > +             return ERR_PTR(-ENOMEM);
> > +
> > +     if (parser_inst_id)
> > +             parser->parser_inst_id = parser_inst_id;
> > +     else
> > +             /* Assign to KPARSER_KMOD_ID_MAX + 1 if no ID was supplied */
> > +             parser->parser_inst_id = KPARSER_KMOD_ID_MAX + 1;
> > +
> > +     strscpy(parser->parser_name, parser_name, PARSERNAMSIZ);
> > +
> > +     ret = __tcf_parser_fill(parser, extack);
> > +     if (ret < 0)
> > +             goto err;
> > +
> > +     refcount_set(&parser->parser_ref, 1);
> > +
> > +     idr_init(&parser->hdr_fields_idr);
> > +
> > +     pipeline->parser = parser;
> > +
> > +     return parser;
> > +
> > +err:
> > +     kfree(parser);
> > +     return ERR_PTR(ret);
> > +}
> > +
> > +/* Dummy function which just returns true
> > + * Once we have the proper parser code, this function will work properly
> > + */
> > +bool tcf_parser_check_hdrfields(struct p4tc_parser *parser,
> > +                             struct p4tc_hdrfield *hdrfield)
> > +{
> > +     return true;
> > +}
> > +
> > +int tcf_parser_del(struct net *net, struct p4tc_pipeline *pipeline,
> > +                struct p4tc_parser *parser, struct netlink_ext_ack *extack)
> > +{
> > +     struct p4tc_hdrfield *hdrfield;
> > +     unsigned long hdr_field_id, tmp;
> > +
> > +     __tcf_parser_put(parser);
> > +
> > +     idr_for_each_entry_ul(&parser->hdr_fields_idr, hdrfield, tmp, hdr_field_id)
> > +             hdrfield->common.ops->put(net, &hdrfield->common, true, extack);
> > +
> > +     idr_destroy(&parser->hdr_fields_idr);
> > +
> > +     pipeline->parser = NULL;
> > +
> > +     kfree(parser);
> > +
> > +     return 0;
> > +}
> > diff --git a/net/sched/p4tc/p4tc_pipeline.c b/net/sched/p4tc/p4tc_pipeline.c
> > index 49f0062ad..6fc7bd49d 100644
> > --- a/net/sched/p4tc/p4tc_pipeline.c
> > +++ b/net/sched/p4tc/p4tc_pipeline.c
> > @@ -115,6 +115,8 @@ static int tcf_pipeline_put(struct net *net,
> >          }
> >
> >       idr_remove(&pipe_net->pipeline_idr, pipeline->common.p_id);
> > +     if (pipeline->parser)
> > +             tcf_parser_del(net, pipeline, pipeline->parser, extack);
> >
> >       idr_for_each_entry_ul(&pipeline->p_meta_idr, meta, tmp, m_id)
> >               meta->common.ops->put(net, &meta->common, true, extack);
> > @@ -319,6 +321,8 @@ static struct p4tc_pipeline *tcf_pipeline_create(struct net *net,
> >               pipeline->num_postacts = 0;
> >       }
> >
> > +     pipeline->parser = NULL;
> > +
> >       idr_init(&pipeline->p_meta_idr);
> >       pipeline->p_meta_offset = 0;
> >
> > diff --git a/net/sched/p4tc/p4tc_tmpl_api.c b/net/sched/p4tc/p4tc_tmpl_api.c
> > index a13d02ce5..325b56d2e 100644
> > --- a/net/sched/p4tc/p4tc_tmpl_api.c
> > +++ b/net/sched/p4tc/p4tc_tmpl_api.c
> > @@ -43,6 +43,7 @@ static bool obj_is_valid(u32 obj)
> >       switch (obj) {
> >       case P4TC_OBJ_PIPELINE:
> >       case P4TC_OBJ_META:
> > +     case P4TC_OBJ_HDR_FIELD:
> >               return true;
> >       default:
> >               return false;
> > @@ -52,6 +53,7 @@ static bool obj_is_valid(u32 obj)
> >  static const struct p4tc_template_ops *p4tc_ops[P4TC_OBJ_MAX] = {
> >       [P4TC_OBJ_PIPELINE] = &p4tc_pipeline_ops,
> >       [P4TC_OBJ_META] = &p4tc_meta_ops,
> > +     [P4TC_OBJ_HDR_FIELD] = &p4tc_hdrfield_ops,
> >  };
> >
> >  int tcf_p4_tmpl_generic_dump(struct sk_buff *skb, struct p4tc_dump_ctx *ctx,
>
