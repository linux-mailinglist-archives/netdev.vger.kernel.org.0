Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FDB1DD58A
	for <lists+netdev@lfdr.de>; Sat, 19 Oct 2019 01:34:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389922AbfJRXec (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 19:34:32 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:38452 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727332AbfJRXeb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 19:34:31 -0400
Received: by mail-qt1-f195.google.com with SMTP id j31so11537516qta.5
        for <netdev@vger.kernel.org>; Fri, 18 Oct 2019 16:34:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=86l32FjXBVFoH3QD7EPiX0nO+HvixHavyVDzWDnvOWc=;
        b=nf3aZwJ4wBuWPJ6rlaV/FKJI5hestGCuUCJKcQKPxVsbNZ8Z5lualOD4yL9fCmnyg5
         iXOfjzBLMjfK39LaNeE5zuy233RVUlQwzW0oQZag6zpDAtnZvI5DTtIqxhFHNGMCNmu6
         zf0mxSzRmI3hQyB8m5cYqX1j5RnUShV97Kg5zYaso3bN3Ukm5AB6j/lHFixiPs1C8KIl
         NQiHVCft1fLnaqFLJ7ITl20qMAzSw0BdvsuUSMTpZaHUwyIcPjV/78DcAzpSpi3RLPC4
         kKT0yZUt+JYUySd0WsRqtqnsLkvngmLOSd1sEmYjTOWlMNj0EK6xWfPinIW4QTscFXYi
         pWig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=86l32FjXBVFoH3QD7EPiX0nO+HvixHavyVDzWDnvOWc=;
        b=W/BUCDEsfVe80jviRG7Oz522RKJ9EWTy7hDuDpvsNwfjucttwuzRQ4jKqpY+l+znk6
         LCG8l9Z2zxQr240jS/HA2vZWG9mb4wUwhR7KuPsCvPpqHU1V3LRtuF5mkmsoC/1BE4w4
         sP6GfPUW4MwzN5pmidY10lKW5Zeei1HOo18aqcLOdQBbpsmsQQWtqKKBO71YbDKX5wq7
         0PaZekHCwrK78H+iMQ5JVR7rVVQsuI81Z0drwzQbBF/pCh/nRYoXJYdZRcVWR67czafu
         s5VESMbUWU9FwEQS8MiYecUiI0tiTZ7g/+byp+zqkUKQvOZ1B+hfIeJ4J4z/QEMxDhUZ
         AqSQ==
X-Gm-Message-State: APjAAAVRT/gTI4MLrsridYFRm91IFG9FYpc0UQwIZVxheSNQ8WHnDxy/
        30O7ldbINDLzex9nkqR9g9AjlGkIb5NzRnDtZvwXesQLuHI=
X-Google-Smtp-Source: APXvYqxGDfx0Nbd6OWgcon0Ej6AHgpQ/u6xtnSQj+yIaFW5ekr9AXG2Q7BbpkjH26gPjxuiA9bGOQ9S3m/vqnEs7LKQ=
X-Received: by 2002:a0c:f792:: with SMTP id s18mr12310266qvn.20.1571441670709;
 Fri, 18 Oct 2019 16:34:30 -0700 (PDT)
MIME-Version: 1.0
References: <1571135440-24313-1-git-send-email-xiangxia.m.yue@gmail.com> <1571135440-24313-4-git-send-email-xiangxia.m.yue@gmail.com>
In-Reply-To: <1571135440-24313-4-git-send-email-xiangxia.m.yue@gmail.com>
From:   William Tu <u9012063@gmail.com>
Date:   Fri, 18 Oct 2019 16:33:54 -0700
Message-ID: <CALDO+SYT-kE=e4NhHR5QxY8JAZ2wbUjW+r2avLdZY9chmfOMQQ@mail.gmail.com>
Subject: Re: [ovs-dev] [PATCH net-next v4 03/10] net: openvswitch: shrink the
 mask array if necessary
To:     xiangxia.m.yue@gmail.com
Cc:     Greg Rose <gvrose8192@gmail.com>, pravin shelar <pshelar@ovn.org>,
        "<dev@openvswitch.org>" <dev@openvswitch.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 16, 2019 at 5:53 AM <xiangxia.m.yue@gmail.com> wrote:
>
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
>
> When creating and inserting flow-mask, if there is no available
> flow-mask, we realloc the mask array. When removing flow-mask,
> if necessary, we shrink mask array.
>
> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> Tested-by: Greg Rose <gvrose8192@gmail.com>
> ---

LGTM
Acked-by: William Tu <u9012063@gmail.com>

On the other hand, maybe we should have an upper limit on the
mask cash size?

Regards,
William`
>  net/openvswitch/flow_table.c | 33 +++++++++++++++++++++++----------
>  1 file changed, 23 insertions(+), 10 deletions(-)
>
> diff --git a/net/openvswitch/flow_table.c b/net/openvswitch/flow_table.c
> index 0d1df53..237cf85 100644
> --- a/net/openvswitch/flow_table.c
> +++ b/net/openvswitch/flow_table.c
> @@ -693,6 +693,23 @@ static struct table_instance *table_instance_expand(struct table_instance *ti,
>         return table_instance_rehash(ti, ti->n_buckets * 2, ufid);
>  }
>
> +static void tbl_mask_array_delete_mask(struct mask_array *ma,
> +                                      struct sw_flow_mask *mask)
> +{
> +       int i;
> +
> +       /* Remove the deleted mask pointers from the array */
> +       for (i = 0; i < ma->max; i++) {
> +               if (mask == ovsl_dereference(ma->masks[i])) {
> +                       RCU_INIT_POINTER(ma->masks[i], NULL);
> +                       ma->count--;
> +                       kfree_rcu(mask, rcu);
> +                       return;
> +               }
> +       }
> +       BUG();
> +}
> +
>  /* Remove 'mask' from the mask list, if it is not needed any more. */
>  static void flow_mask_remove(struct flow_table *tbl, struct sw_flow_mask *mask)
>  {
> @@ -706,18 +723,14 @@ static void flow_mask_remove(struct flow_table *tbl, struct sw_flow_mask *mask)
>
>                 if (!mask->ref_count) {
>                         struct mask_array *ma;
> -                       int i;
>
>                         ma = ovsl_dereference(tbl->mask_array);
> -                       for (i = 0; i < ma->max; i++) {
> -                               if (mask == ovsl_dereference(ma->masks[i])) {
> -                                       RCU_INIT_POINTER(ma->masks[i], NULL);
> -                                       ma->count--;
> -                                       kfree_rcu(mask, rcu);
> -                                       return;
> -                               }
> -                       }
> -                       BUG();
> +                       tbl_mask_array_delete_mask(ma, mask);
> +
> +                       /* Shrink the mask array if necessary. */
> +                       if (ma->max >= (MASK_ARRAY_SIZE_MIN * 2) &&
> +                           ma->count <= (ma->max / 3))
> +                               tbl_mask_array_realloc(tbl, ma->max / 2);
>                 }
>         }
>  }
> --
> 1.8.3.1
>
> _______________________________________________
> dev mailing list
> dev@openvswitch.org
> https://mail.openvswitch.org/mailman/listinfo/ovs-dev
