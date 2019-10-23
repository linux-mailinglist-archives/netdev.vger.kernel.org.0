Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3B62E1459
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 10:36:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390391AbfJWIgd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 04:36:33 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:36631 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390233AbfJWIgd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 04:36:33 -0400
Received: by mail-qk1-f193.google.com with SMTP id y189so19037700qkc.3
        for <netdev@vger.kernel.org>; Wed, 23 Oct 2019 01:36:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9v9iQV19DgUi7HpW2WaXbL0gSupsIrn2jbWl4B5cbgA=;
        b=GVNr3B/Pu7MhpLCF/dDljxT+FdoGWUX3wKn2/1eUXY7mn6PbLjPdBp3YQsOZ3yPYLQ
         WSWxUBvh9cHNDXTl/XYd6WcF58ndf5Enb6Zf8GLJrDjg5QY6kDKBcRU+VbEj3gahLRg7
         vJ9UFiG27wNkTs/40C073ctPhILdFtxNxS+6tI4RSo7/BtCENKdU3NUEzHRPNk2pkyGp
         cKRNlEWDrcCZQOXVaRFjIaVuR+ng9CxjSsJOAjcXp+VlZYyTIbSM7X1Oxmk8LwouDTkq
         JOfQ4gCi61/2ZVRZbGRn4D2gGe28nDUzHjiqJm8y4UqCUqMgTGv1E98tZF4saJknGme8
         2zeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9v9iQV19DgUi7HpW2WaXbL0gSupsIrn2jbWl4B5cbgA=;
        b=dKD51lo1a6xLjM/tzkKtkIA7voz+9L1oVE0wDksxJ11vDX1vEpOmiVpFHj8ffQEhlW
         /0Vw4487pTtF8EbFn2xCtgByOmrptWTVebvtZ585mayWWeusI6z2f5+Xm7oa9McQOSXO
         XbPwVG6kuOtSOE5y9hz0iLI4wDaYbpzop5astp/xICPajxyq+RyIq2kmTx/GaWlOxOEx
         LxZTJlsG2y+n7lFJT6pXk6r42ZwQfMKiR517QbZfPRy95vCt25hJpPu3+TiTG1PxjvAI
         8r+dXbtHZ4bL+XDkzDrP8CYV7jI1MRNNRVMsTWsbs/svYIMpcNao/P2/UDP/xOYCGpBZ
         Dxvg==
X-Gm-Message-State: APjAAAXLdDPqxl3M7kd9iLxB+6xlGPLA7yr2pBkOHVOCdq971l2znD/D
        nc3ohLNYdDE7rwVYKP4snoB2TsYwaGrmvBX65XIqKA==
X-Google-Smtp-Source: APXvYqz5/xtUvZp/vVxcL3Gonlq1fmzZz6efHYtE62iXY8lYaTgZeEKiWaOv+Rs97z8NDXNy+5/kH6MjE+IQOOktJZw=
X-Received: by 2002:a05:620a:16a6:: with SMTP id s6mr6613669qkj.407.1571819792095;
 Wed, 23 Oct 2019 01:36:32 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1571762488.git.andreyknvl@google.com> <26e088ae3ebcaa30afe957aeabaa9f0c653df7d0.1571762488.git.andreyknvl@google.com>
In-Reply-To: <26e088ae3ebcaa30afe957aeabaa9f0c653df7d0.1571762488.git.andreyknvl@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Wed, 23 Oct 2019 10:36:20 +0200
Message-ID: <CACT4Y+YntxT+cpESOBvbg+h=g-84ECJwQrFg7LM5tbq_zaMd3A@mail.gmail.com>
Subject: Re: [PATCH 3/3] vhost, kcov: collect coverage from vhost_worker
To:     Andrey Konovalov <andreyknvl@google.com>
Cc:     USB list <linux-usb@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Windsor <dwindsor@gmail.com>,
        Elena Reshetova <elena.reshetova@intel.com>,
        Anders Roxell <anders.roxell@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 22, 2019 at 6:46 PM Andrey Konovalov <andreyknvl@google.com> wrote:
>
> This patch adds kcov_remote_start()/kcov_remote_stop() annotations to the
> vhost_worker() function, which is responsible for processing vhost works.
> Since vhost_worker() threads are spawned per vhost device instance
> the common kcov handle is used for kcov_remote_start()/stop() annotations
> (see Documentation/dev-tools/kcov.rst for details). As the result kcov can
> now be used to collect coverage from vhost worker threads.
>
> Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
> ---
>  drivers/vhost/vhost.c | 6 ++++++
>  drivers/vhost/vhost.h | 1 +
>  2 files changed, 7 insertions(+)
>
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index 36ca2cf419bf..a5a557c4b67f 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -30,6 +30,7 @@
>  #include <linux/sched/signal.h>
>  #include <linux/interval_tree_generic.h>
>  #include <linux/nospec.h>
> +#include <linux/kcov.h>
>
>  #include "vhost.h"
>
> @@ -357,7 +358,9 @@ static int vhost_worker(void *data)
>                 llist_for_each_entry_safe(work, work_next, node, node) {
>                         clear_bit(VHOST_WORK_QUEUED, &work->flags);
>                         __set_current_state(TASK_RUNNING);
> +                       kcov_remote_start(dev->kcov_handle);
>                         work->fn(work);
> +                       kcov_remote_stop();
>                         if (need_resched())
>                                 schedule();
>                 }
> @@ -546,6 +549,7 @@ long vhost_dev_set_owner(struct vhost_dev *dev)
>
>         /* No owner, become one */
>         dev->mm = get_task_mm(current);
> +       dev->kcov_handle = current->kcov_handle;

kcov_handle is not present in task_struct if !CONFIG_KCOV

Also this does not use KCOV_SUBSYSTEM_COMMON.
We discussed something along the following lines:

u64 kcov_remote_handle(u64 subsys, u64 id)
{
  WARN_ON(subsys or id has wrong bits set).
  return ...;
}

kcov_remote_handle(KCOV_SUBSYSTEM_USB, bus);
kcov_remote_handle(KCOV_SUBSYSTEM_COMMON, current->kcov_handle);


>         worker = kthread_create(vhost_worker, dev, "vhost-%d", current->pid);
>         if (IS_ERR(worker)) {
>                 err = PTR_ERR(worker);
> @@ -571,6 +575,7 @@ long vhost_dev_set_owner(struct vhost_dev *dev)
>         if (dev->mm)
>                 mmput(dev->mm);
>         dev->mm = NULL;
> +       dev->kcov_handle = 0;
>  err_mm:
>         return err;
>  }
> @@ -682,6 +687,7 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
>         if (dev->worker) {
>                 kthread_stop(dev->worker);
>                 dev->worker = NULL;
> +               dev->kcov_handle = 0;
>         }
>         if (dev->mm)
>                 mmput(dev->mm);
> diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
> index e9ed2722b633..a123fd70847e 100644
> --- a/drivers/vhost/vhost.h
> +++ b/drivers/vhost/vhost.h
> @@ -173,6 +173,7 @@ struct vhost_dev {
>         int iov_limit;
>         int weight;
>         int byte_weight;
> +       u64 kcov_handle;
>  };
>
>  bool vhost_exceeds_weight(struct vhost_virtqueue *vq, int pkts, int total_len);
> --
> 2.23.0.866.gb869b98d4c-goog
>
