Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC9A7508541
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 11:53:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377353AbiDTJ4a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 05:56:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377345AbiDTJ43 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 05:56:29 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15C3B3982B
        for <netdev@vger.kernel.org>; Wed, 20 Apr 2022 02:53:44 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id s17so1313513plg.9
        for <netdev@vger.kernel.org>; Wed, 20 Apr 2022 02:53:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=K8Pz9LFSYZkZJXhFZr8BqVVT7lkzhUcOpzkZPZanr4U=;
        b=OY3N83zMuqvhtAz1nci4ef1QHq0vWD+DinRkkDDKGHl0blO453v3p6CzFT07n8DExK
         GKz+rk2tQNnEcad9aZITXQkLFL4/El2OsC0SPc+QdH5uyonUVrblUBTECIctpFjePZAi
         ZzKjlrjLjZgRYknfeK7pHWtjccgFb5t0v5yci/Ti/9eEVrsUlkOYq64KiTfKexxszdhs
         PnfTbA25afRedYfUJ1jqj7teJbsUkjhEmVln9vU1SNIQUG+5JikuZOf19MVOAZtS6+by
         bblhh5kThi2ZdNvAMn7sMLOYwTJgpwR0YjiWQe2TQYB9cUlJwPXI6cXTBq1mWSKXBhqD
         Wxkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=K8Pz9LFSYZkZJXhFZr8BqVVT7lkzhUcOpzkZPZanr4U=;
        b=iQH1XDlRIfxS7YBcoUtufZWxf8KTJtZZVcizMyrn3SAxCCnVRpSMHWM6JQWPoe9fUY
         TywKHDicMIwsgzzwWXq93bUJGYWZ4ar6tGS+lvC/tu07KkQPNI2VJdbyyHKPw3xCzMh2
         KP6AwE4eP2iaL/rOnxWn8G2wBnxfQ5SP9grLC1xl0qy/KhNt2pAHe8D2Cdz8zB0N5kV1
         SFYyDNZNKhKrU21CGR0IWKGI8Z65UAJwelY0iZ3H8vrTcNjMWDAOs6NCp4fbuxXra6xJ
         ymdqHErRdV+kT9nGRDlAZthk95jJP5IHE+d19nwzMZTcoBDq1h/nO0X2ZOTNH40ay/wV
         IE/g==
X-Gm-Message-State: AOAM531fTAgt/qu5qiuXQ9MMS5/rCRXerFPAZjzRzxM+m40HmiWst2+G
        8/vasOftyBSmlv4KJl11HMs7YV8zOAAtTWPJrk7RLw==
X-Google-Smtp-Source: ABdhPJxmbevs4eeg97gHzoNf435BJadPcz2cCR1eojoGz9G4MJIVn/f4/rxYWB2tlNlnXLat6/e/+LmmpDoNVDOyW+I=
X-Received: by 2002:a17:902:e881:b0:158:fd34:7b28 with SMTP id
 w1-20020a170902e88100b00158fd347b28mr13889782plg.95.1650448423471; Wed, 20
 Apr 2022 02:53:43 -0700 (PDT)
MIME-Version: 1.0
References: <0bc6443a-dbac-70ab-bf99-9a439e35f3ef@I-love.SAKURA.ne.jp>
In-Reply-To: <0bc6443a-dbac-70ab-bf99-9a439e35f3ef@I-love.SAKURA.ne.jp>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Wed, 20 Apr 2022 11:53:07 +0200
Message-ID: <CAMZdPi_uieGNWyGAAywBz2Utg0iW1jGUTWzUbj3SmsZ+-iDTfQ@mail.gmail.com>
Subject: Re: [PATCH] wwan_hwsim: Avoid flush_scheduled_work() usage
To:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc:     Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Tetsuo, Sergey,

On Wed, 20 Apr 2022 at 04:22, Tetsuo Handa
<penguin-kernel@i-love.sakura.ne.jp> wrote:
>
> Flushing system-wide workqueues is dangerous and will be forbidden.
> Replace system_wq with local wwan_wq.
>
> Link: https://lkml.kernel.org/r/49925af7-78a8-a3dd-bce6-cfc02e1a9236@I-love.SAKURA.ne.jp
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

Could you add a 'Fixes' tag?

> ---
> Note: This patch is only compile tested. By the way, don't you want to call
> debugfs_remove(wwan_hwsim_debugfs_devcreate) at err_clean_devs label in
> wwan_hwsim_init() like wwan_hwsim_exit() does, for debugfs_create_file("devcreate")
> is called before "goto err_clean_devs" happens?
>
>  drivers/net/wwan/wwan_hwsim.c | 16 ++++++++++++----
>  1 file changed, 12 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/wwan/wwan_hwsim.c b/drivers/net/wwan/wwan_hwsim.c
> index 5b62cf3b3c42..2136319f588f 100644
> --- a/drivers/net/wwan/wwan_hwsim.c
> +++ b/drivers/net/wwan/wwan_hwsim.c
> @@ -33,6 +33,7 @@ static struct dentry *wwan_hwsim_debugfs_devcreate;
>  static DEFINE_SPINLOCK(wwan_hwsim_devs_lock);
>  static LIST_HEAD(wwan_hwsim_devs);
>  static unsigned int wwan_hwsim_dev_idx;
> +static struct workqueue_struct *wwan_wq;
>
>  struct wwan_hwsim_dev {
>         struct list_head list;
> @@ -371,7 +372,7 @@ static ssize_t wwan_hwsim_debugfs_portdestroy_write(struct file *file,
>          * waiting this callback to finish in the debugfs_remove() call. So,
>          * use workqueue.
>          */
> -       schedule_work(&port->del_work);
> +       queue_work(wwan_wq, &port->del_work);
>
>         return count;
>  }
> @@ -416,7 +417,7 @@ static ssize_t wwan_hwsim_debugfs_devdestroy_write(struct file *file,
>          * waiting this callback to finish in the debugfs_remove() call. So,
>          * use workqueue.
>          */
> -       schedule_work(&dev->del_work);
> +       queue_work(wwan_wq, &dev->del_work);
>
>         return count;
>  }
> @@ -506,9 +507,15 @@ static int __init wwan_hwsim_init(void)
>         if (wwan_hwsim_devsnum < 0 || wwan_hwsim_devsnum > 128)
>                 return -EINVAL;
>
> +       wwan_wq = alloc_workqueue("wwan_wq", 0, 0);
> +       if (!wwan_wq)
> +               return -ENOMEM;
> +
>         wwan_hwsim_class = class_create(THIS_MODULE, "wwan_hwsim");
> -       if (IS_ERR(wwan_hwsim_class))
> +       if (IS_ERR(wwan_hwsim_class)) {
> +               destroy_workqueue(wwan_wq);
>                 return PTR_ERR(wwan_hwsim_class);
> +       }
>
>         wwan_hwsim_debugfs_topdir = debugfs_create_dir("wwan_hwsim", NULL);
>         wwan_hwsim_debugfs_devcreate =
> @@ -524,6 +531,7 @@ static int __init wwan_hwsim_init(void)
>
>  err_clean_devs:
>         wwan_hwsim_free_devs();
> +       destroy_workqueue(wwan_wq);
>         debugfs_remove(wwan_hwsim_debugfs_topdir);
>         class_destroy(wwan_hwsim_class);
>
> @@ -534,7 +542,7 @@ static void __exit wwan_hwsim_exit(void)
>  {
>         debugfs_remove(wwan_hwsim_debugfs_devcreate);   /* Avoid new devs */
>         wwan_hwsim_free_devs();
> -       flush_scheduled_work();         /* Wait deletion works completion */
> +       destroy_workqueue(wwan_wq);             /* Wait deletion works completion */

Wouldn't it be simpler to just remove the flush call. It Looks like
all ports have been removed at that point, and all works cancelled,
right?

>         debugfs_remove(wwan_hwsim_debugfs_topdir);
>         class_destroy(wwan_hwsim_class);
>  }
> --
> 2.32.0

Regards,
Loic
