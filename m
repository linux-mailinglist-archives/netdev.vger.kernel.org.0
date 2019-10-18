Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63293DBCCB
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 07:18:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407286AbfJRFRu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 01:17:50 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:32979 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728020AbfJRFRt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 01:17:49 -0400
Received: by mail-ot1-f65.google.com with SMTP id 60so3954967otu.0
        for <netdev@vger.kernel.org>; Thu, 17 Oct 2019 22:17:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OUOTlVchVFeVtgOPkn2cGjK9PfSx9O8xoUJpS6HBtHY=;
        b=YRUxh/tDWWtJ46T/2oFQ7uMqz/JV1HTW2yU5005ACk0wQzvvHNHP03KlgaOiRTvNAx
         K91stoPUBLXKwLfBqHTnIiYCrOkCTCmdV9YYba3MbAxm8LfP9I5Tmgcd0UsiAUhiV+qk
         TThYmv4KG85TbZD6mwYOOROazABlOp6zAuYcsV418UCBcRSLfwZc9Vt9V5FHTgK0ZBdQ
         z/SsmKc/DwhEG/G0hdNwjLDXfiCaEOx5ALm/wkbX1v4s0SAZXpiU8dtI41grQrBWzPXA
         4UJXYmbaznEg/+alKi1hOcl4uf09/rTAI9v9DHHFtfOKHBIZG7q8vp/UMziyPDnH+Ibz
         GzJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OUOTlVchVFeVtgOPkn2cGjK9PfSx9O8xoUJpS6HBtHY=;
        b=JKK+5aUGd7xNPidWIt65nFPHTmhvF8sdBGSEfuRJ6bAMLJGTHeXqfwODwd+9oUuq9n
         HO6wYYjYT76fb++rL9/DVIboxM5yBp9eRNqx/d36YpXLmm552HQrO79uEBHOWVKlvb29
         pG+OOCiGLiLtv1Povd2Iki8mjlOS4Qdt222toB1hMnSSYMWqbZlk16KsyO0+jCFG6pd3
         JBTeM4m1TmQYiSUSo0k1rqinJvg2HC1cazu+XwyS7w6EGAOTf9FlPe8xo1yWm6YKk/1r
         OXtWlxFEuSXMxwPBtA2oXMqPxchnfHm1NSeUy5vst0DTm6UirCuVobDVK4O1rcMLO4cz
         m/Aw==
X-Gm-Message-State: APjAAAWRfbrpy1csInCoY7VqdfqjfCbR135gh2PKlgPZFQCO8em9iZRW
        zDmwtihZzej51gdPYBdFOh6LYb4sbQ1k6dZh0SFOO+pW
X-Google-Smtp-Source: APXvYqzeM6Xg0cPmHj/kqbGb3WL87+4jOt9bbfT4f4PhIDFrOeN48TnhTIeHdWTETz3P7LrXsGZvzYPaZFd/erDrCfw=
X-Received: by 2002:a9d:73d8:: with SMTP id m24mr5631045otk.336.1571368614078;
 Thu, 17 Oct 2019 20:16:54 -0700 (PDT)
MIME-Version: 1.0
References: <1571135440-24313-1-git-send-email-xiangxia.m.yue@gmail.com>
 <1571135440-24313-9-git-send-email-xiangxia.m.yue@gmail.com> <CAOrHB_B5dLuvoTxGpmaMiX9deEk9KjQHacqNKEpzHA2m5YS7jw@mail.gmail.com>
In-Reply-To: <CAOrHB_B5dLuvoTxGpmaMiX9deEk9KjQHacqNKEpzHA2m5YS7jw@mail.gmail.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Fri, 18 Oct 2019 11:16:17 +0800
Message-ID: <CAMDZJNWD=a+EBneEU-qs3pzXSBoOdzidn5cgOKs-y8G0UWvbnA@mail.gmail.com>
Subject: Re: [PATCH net-next v4 08/10] net: openvswitch: fix possible memleak
 on destroy flow-table
To:     Pravin Shelar <pshelar@ovn.org>
Cc:     Greg Rose <gvrose8192@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        ovs dev <dev@openvswitch.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 18, 2019 at 6:38 AM Pravin Shelar <pshelar@ovn.org> wrote:
>
> On Wed, Oct 16, 2019 at 5:50 AM <xiangxia.m.yue@gmail.com> wrote:
> >
> > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> >
> > When we destroy the flow tables which may contain the flow_mask,
> > so release the flow mask struct.
> >
> > Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > Tested-by: Greg Rose <gvrose8192@gmail.com>
> > ---
> >  net/openvswitch/flow_table.c | 14 +++++++++++++-
> >  1 file changed, 13 insertions(+), 1 deletion(-)
> >
> > diff --git a/net/openvswitch/flow_table.c b/net/openvswitch/flow_table.c
> > index 5df5182..d5d768e 100644
> > --- a/net/openvswitch/flow_table.c
> > +++ b/net/openvswitch/flow_table.c
> > @@ -295,6 +295,18 @@ static void table_instance_destroy(struct table_instance *ti,
> >         }
> >  }
> >
> > +static void tbl_mask_array_destroy(struct flow_table *tbl)
> > +{
> > +       struct mask_array *ma = ovsl_dereference(tbl->mask_array);
> > +       int i;
> > +
> > +       /* Free the flow-mask and kfree_rcu the NULL is allowed. */
> > +       for (i = 0; i < ma->max; i++)
> > +               kfree_rcu(rcu_dereference_raw(ma->masks[i]), rcu);
> > +
> > +       kfree_rcu(rcu_dereference_raw(tbl->mask_array), rcu);
> > +}
> > +
> >  /* No need for locking this function is called from RCU callback or
> >   * error path.
> >   */
> > @@ -304,7 +316,7 @@ void ovs_flow_tbl_destroy(struct flow_table *table)
> >         struct table_instance *ufid_ti = rcu_dereference_raw(table->ufid_ti);
> >
> >         free_percpu(table->mask_cache);
> > -       kfree_rcu(rcu_dereference_raw(table->mask_array), rcu);
> > +       tbl_mask_array_destroy(table);
> >         table_instance_destroy(ti, ufid_ti, false);
> >  }
>
> This should not be required. mask is linked to a flow and gets
> released when flow is removed.
> Does the memory leak occur when OVS module is abruptly unloaded and
> userspace does not cleanup flow table?
When we destroy the ovs datapath or net namespace is destroyed , the
mask memory will be happened. The call tree:
ovs_exit_net/ovs_dp_cmd_del
-->__dp_destroy
-->destroy_dp_rcu
-->ovs_flow_tbl_destroy
-->table_instance_destroy (which don't release the mask memory because
don't call the ovs_flow_tbl_remove /flow_mask_remove directly or
indirectly).

but one thing, when we flush the flow, we don't flush the mask flow.(
If necessary, one patch should be sent)

> In that case better fix could be calling ovs_flow_tbl_remove()
> equivalent from table_instance_destroy when it is iterating flow
> table.
I think operation of  the flow mask and flow table should use
different API, for example:
for flow mask, we use the:
-tbl_mask_array_add_mask
-tbl_mask_array_del_mask
-tbl_mask_array_alloc
-tbl_mask_array_realloc
-tbl_mask_array_destroy(this patch introduce.)

table instance:
-table_instance_alloc
-table_instance_destroy
....
