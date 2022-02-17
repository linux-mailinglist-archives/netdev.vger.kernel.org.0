Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EF024BA489
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 16:38:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242488AbiBQPi6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 10:38:58 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239271AbiBQPi6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 10:38:58 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7F332B2E0E
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 07:38:43 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id p5so13747229ybd.13
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 07:38:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4hk+t9STd/ohkaxKw6p1lqAArc9u/s8Q8z69HF6aLfE=;
        b=dBmphIBTKJBbLyOdiwSe3VTvN12HETj4nWMgwdynneUZO8D6nWfrB0f/GBiBA+3Bxp
         KF+/tApD9j+7MjLO3Ima8cJs2VlPrUd+bMIOWVDaUKtszaSMlEIYrw48DABbvIYL682H
         LD3Re5r4ZXG6jQyafj0JwoDngXYlOewmr0UptZZQLVEVKpRXF4dO5Q3Fr9x91aj6oUXd
         96t9ShajgD7echn30nWeEsEzrNMv7O0d1/NniWqwsF6bsxZCyVn/SdWtu7ldYpWcF8mJ
         knB2bt7Gwyyutk12bI8gZwTL++yweig6tJrG/t4tq1ZgywAGwg/HukZsUJV77AyM7/eP
         Sv3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4hk+t9STd/ohkaxKw6p1lqAArc9u/s8Q8z69HF6aLfE=;
        b=HeqaysngwxAwKVCS+LesGbVLH12SRxTzZT72W2ADNefSJtTsbebnr0u/GWkqk4lv2w
         j0NpqbT1vRS98XLj4u+T3RPaGhBrYU1p1Az8QAaAj3ak/+IwAylCWMWXekMSMhpf+G06
         aCI/DGQYGc4Urug3OTK5xm3mU+JmSqtYPDeRCwarrzKzOn//bnNvDLEaJn/kboUWrEuk
         qc7/DuPV/g1YhQpMzc8Liw96rC5yjSXza/s9XLoVsCcPQZtV20ax1U/zx8q2vk1QLy6d
         ku2cTYxTza/Gle/Tv8DNzyUqq+J/KT/u4kt6uah5yBiYA2IaEdt07bydkhvNDfmInpDz
         2DNA==
X-Gm-Message-State: AOAM530HhIJIQ7Px318X1P51bcLmCXmz67rfyRsnTMnEmFSrX9wh2oCC
        0SBIoKSn3zK+QZRgvELbcKRGRfGuf+LkEMx8fC0+7g==
X-Google-Smtp-Source: ABdhPJxO+ysMqjMYL+p/uFIKcRWnnodcM/TI1tWk7b39KPn14CMGckpJP4fv4wEzgLTuLSCx3ej7mggJkgIO+uDduuk=
X-Received: by 2002:a25:a28d:0:b0:623:fa1b:3eb7 with SMTP id
 c13-20020a25a28d000000b00623fa1b3eb7mr2918043ybi.387.1645112322577; Thu, 17
 Feb 2022 07:38:42 -0800 (PST)
MIME-Version: 1.0
References: <20220217140441.1218045-1-andrzej.hajda@intel.com> <20220217140441.1218045-4-andrzej.hajda@intel.com>
In-Reply-To: <20220217140441.1218045-4-andrzej.hajda@intel.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 17 Feb 2022 07:38:31 -0800
Message-ID: <CANn89iJ3W3ioVUaBJikCpFdCa9o_APpqyb0FmK9AmYPtgOeC7w@mail.gmail.com>
Subject: Re: [PATCH 3/9] lib/ref_tracker: __ref_tracker_dir_print improve printing
To:     Andrzej Hajda <andrzej.hajda@intel.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        netdev <netdev@vger.kernel.org>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Lucas De Marchi <lucas.demarchi@intel.com>,
        Chris Wilson <chris.p.wilson@intel.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 17, 2022 at 6:05 AM Andrzej Hajda <andrzej.hajda@intel.com> wrote:
>
> To improve readibility of ref_tracker printing following changes
> have been performed:
> - added display name for ref_tracker_dir,
> - stack trace is printed indented, in the same printk call,
> - total number of references is printed every time,
> - print info about dropped references.
>
> Signed-off-by: Andrzej Hajda <andrzej.hajda@intel.com>
> Reviewed-by: Chris Wilson <chris.p.wilson@intel.com>
> ---
>  include/linux/ref_tracker.h | 15 ++++++++++++---
>  lib/ref_tracker.c           | 28 ++++++++++++++++++++++------
>  2 files changed, 34 insertions(+), 9 deletions(-)
>
> diff --git a/include/linux/ref_tracker.h b/include/linux/ref_tracker.h
> index b9c968a716483..090230e5b485d 100644
> --- a/include/linux/ref_tracker.h
> +++ b/include/linux/ref_tracker.h
> @@ -15,18 +15,26 @@ struct ref_tracker_dir {
>         refcount_t              untracked;
>         struct list_head        list; /* List of active trackers */
>         struct list_head        quarantine; /* List of dead trackers */
> +       char                    name[32];
>  #endif
>  };
>
>  #ifdef CONFIG_REF_TRACKER
> -static inline void ref_tracker_dir_init(struct ref_tracker_dir *dir,
> -                                       unsigned int quarantine_count)
> +
> +// Temporary allow two and three arguments, until consumers are converted
> +#define ref_tracker_dir_init(_d, _q, args...) _ref_tracker_dir_init(_d, _q, ##args, #_d)
> +#define _ref_tracker_dir_init(_d, _q, _n, ...) __ref_tracker_dir_init(_d, _q, _n)
> +
> +static inline void __ref_tracker_dir_init(struct ref_tracker_dir *dir,
> +                                       unsigned int quarantine_count,
> +                                       const char *name)
>  {
>         INIT_LIST_HEAD(&dir->list);
>         INIT_LIST_HEAD(&dir->quarantine);
>         spin_lock_init(&dir->lock);
>         dir->quarantine_avail = quarantine_count;
>         refcount_set(&dir->untracked, 1);
> +       strlcpy(dir->name, name, sizeof(dir->name));
>         stack_depot_init();
>  }
>
> @@ -47,7 +55,8 @@ int ref_tracker_free(struct ref_tracker_dir *dir,
>  #else /* CONFIG_REF_TRACKER */
>
>  static inline void ref_tracker_dir_init(struct ref_tracker_dir *dir,
> -                                       unsigned int quarantine_count)
> +                                       unsigned int quarantine_count,
> +                                       ...)
>  {
>  }
>
> diff --git a/lib/ref_tracker.c b/lib/ref_tracker.c
> index 0e9c7d2828ccb..943cff08110e3 100644
> --- a/lib/ref_tracker.c
> +++ b/lib/ref_tracker.c
> @@ -1,4 +1,7 @@
>  // SPDX-License-Identifier: GPL-2.0-or-later
> +
> +#define pr_fmt(fmt) "ref_tracker: " fmt
> +
>  #include <linux/export.h>
>  #include <linux/list_sort.h>
>  #include <linux/ref_tracker.h>
> @@ -7,6 +10,7 @@
>  #include <linux/stackdepot.h>
>
>  #define REF_TRACKER_STACK_ENTRIES 16
> +#define STACK_BUF_SIZE 1024


>
>  struct ref_tracker {
>         struct list_head        head;   /* anchor into dir->list or dir->quarantine */
> @@ -26,31 +30,43 @@ static int ref_tracker_cmp(void *priv, const struct list_head *a, const struct l
>  void __ref_tracker_dir_print(struct ref_tracker_dir *dir,
>                            unsigned int display_limit)
>  {
> -       unsigned int i = 0, count = 0;
> +       unsigned int i = 0, count = 0, total = 0;
>         struct ref_tracker *tracker;
>         depot_stack_handle_t stack;
> +       char *sbuf;
>
>         lockdep_assert_held(&dir->lock);
>
>         if (list_empty(&dir->list))
>                 return;
>
> +       sbuf = kmalloc(STACK_BUF_SIZE, GFP_NOWAIT);
> +
> +       list_for_each_entry(tracker, &dir->list, head)
> +               ++total;

Another iteration over a potential long list.

You can count the @skipped number in the following iteration just fine.

int skipped = 0;

> +
>         list_sort(NULL, &dir->list, ref_tracker_cmp);
>
>         list_for_each_entry(tracker, &dir->list, head) {
> -               if (i++ >= display_limit)
> -                       break;
>                 if (!count++)
>                         stack = tracker->alloc_stack_handle;
>                 if (stack == tracker->alloc_stack_handle &&
>                     !list_is_last(&tracker->head, &dir->list))
>                         continue;
> +               if (i++ >= display_limit)

                            skipped++;
> +                       continue;
>
> -               pr_err("leaked %d references.\n", count);
> -               if (stack)
> -                       stack_depot_print(stack);
> +               if (sbuf && !stack_depot_snprint(stack, sbuf, STACK_BUF_SIZE, 4))
> +                       sbuf[0] = 0;
> +               pr_err("%s@%pK has %d/%d users at\n%s\n",
> +                      dir->name, dir, count, total, sbuf);
>                 count = 0;
>         }
> +       if (i > display_limit)
> +               pr_err("%s@%pK skipped %d/%d reports with %d unique stacks.\n",
> +                      dir->name, dir, count, total, i - display_limit);
> +
> +       kfree(sbuf);
>  }
>  EXPORT_SYMBOL(__ref_tracker_dir_print);
>
> --
> 2.25.1
>
