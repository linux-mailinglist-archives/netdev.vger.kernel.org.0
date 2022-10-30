Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6F3A612B01
	for <lists+netdev@lfdr.de>; Sun, 30 Oct 2022 15:33:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbiJ3Odb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Oct 2022 10:33:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbiJ3Oda (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Oct 2022 10:33:30 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 827F3BF2
        for <netdev@vger.kernel.org>; Sun, 30 Oct 2022 07:33:29 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id d6so15622116lfs.10
        for <netdev@vger.kernel.org>; Sun, 30 Oct 2022 07:33:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=1DkbMD9ZaMPy1a2PDm2Aky3E4CD3Hw3C1r6pzx/1RWo=;
        b=CQ8u98aXEwDPSZKoQuhGr9CNZIG7Og1ZYeAsE2AtEE3oLgpW64GQChABkd3BdaYI1x
         ONPPw9yB4YvJS7xXYAN2ro/pSXVgtIkZi0ztEba4xFeeOTYsjNxFfKpItJA63RZqFXAl
         hi/Wa7/Ssp+SH+ra6TqubfQDHlHFdwQm5c5Ns0fmO8Ce/kDlNxzgE8k5jX6uyh8aCHUi
         q8Pz7IPtWW5/d6E2Rjyckut6yONEsAcpAOleEv2oZ3gB//O2F3US43x5zEzsL7/1gjXM
         +CwDx7cvgSUBL6jMvbLFsR71MMdfMROxKk8ynznMYMIQPLk5xhcEEBcjZwe5JXV+Cetz
         xhiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1DkbMD9ZaMPy1a2PDm2Aky3E4CD3Hw3C1r6pzx/1RWo=;
        b=2fcICD8H514el13J/L+yyxxZ7lnVQt+jwuzBhkAb73yE0+aIfmbriO3ADGKMARjWPC
         waKPwTixB3Hwic+wMvrUWW8mJbWn6XHyFUJGT6nJtpU7bJx8l3giUBNvTLTFpCFhnz8s
         TQSKwio2BBSC6IDUfAGj+QMAZPmTes0D9EOVO1811M1orQ/rIvPvuCuvb+W0uAKJemJg
         w9KwmPdaZ3PpWu87kzsJb6j6Izw9vs/yxmxVp6FvLNHZfoMPdf2Rq8tTCeTbZhYEaDEK
         svzp819aiECvfqVyAgyXoSX5/HzWMH+OT6MexXT3KyVrfb2ioFSVQphdT8lfkQEJZF+8
         KL7g==
X-Gm-Message-State: ACrzQf0+RqyCfg0NstHIcyVC1dj/co/plwPtZISe52xrsP+ndU2AUOuC
        9IjA37FtOn9FJwRugcndVA2hKlybeH+DzOlOWDq0AQ==
X-Google-Smtp-Source: AMsMyM4qoHg8mMxvvnY2G7+LmT9AXHsfhBQerK5hJtENPSzlsHeuAB3wPrvWKLCUpn7qV8KfbypaSdSsA64f7Ic/ZHc=
X-Received: by 2002:a19:380b:0:b0:4ab:edfc:5f3 with SMTP id
 f11-20020a19380b000000b004abedfc05f3mr3735742lfa.598.1667140407510; Sun, 30
 Oct 2022 07:33:27 -0700 (PDT)
MIME-Version: 1.0
References: <20221030142919.3196780-1-dvyukov@google.com>
In-Reply-To: <20221030142919.3196780-1-dvyukov@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Sun, 30 Oct 2022 07:33:15 -0700
Message-ID: <CACT4Y+aZpC8HCq7ztZpV1ahyg2QxGonz6P7bwk+irRT=M2n-YA@mail.gmail.com>
Subject: Re: [PATCH] nfc: Allow to create multiple virtual nci devices
To:     bongsu.jeon@samsung.com, krzysztof.kozlowski@linaro.org,
        netdev@vger.kernel.org
Cc:     syzkaller@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 30 Oct 2022 at 07:29, Dmitry Vyukov <dvyukov@google.com> wrote:
>
> The current virtual nci driver is great for testing and fuzzing.
> But it allows to create at most one "global" device which does not allow
> to run parallel tests and harms fuzzing isolation and reproducibility.
> Restructure the driver to allow creation of multiple independent devices.
> This should be backwards compatible for existing tests.
>
> Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
> Cc: Bongsu Jeon <bongsu.jeon@samsung.com>
> Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> Cc: netdev@vger.kernel.org

FYI here is this commit on github if it makes it easier to review for you:
https://github.com/dvyukov/linux/commit/d0659d94a8d80f6e33f926b87a37bf1d7bdbb99d

Thanks

> ---
>  drivers/nfc/virtual_ncidev.c | 143 ++++++++++++++++-------------------
>  1 file changed, 66 insertions(+), 77 deletions(-)
>
> diff --git a/drivers/nfc/virtual_ncidev.c b/drivers/nfc/virtual_ncidev.c
> index 85c06dbb2c449..8c2836a174ba2 100644
> --- a/drivers/nfc/virtual_ncidev.c
> +++ b/drivers/nfc/virtual_ncidev.c
> @@ -13,12 +13,6 @@
>  #include <linux/wait.h>
>  #include <net/nfc/nci_core.h>
>
> -enum virtual_ncidev_mode {
> -       virtual_ncidev_enabled,
> -       virtual_ncidev_disabled,
> -       virtual_ncidev_disabling,
> -};
> -
>  #define IOCTL_GET_NCIDEV_IDX    0
>  #define VIRTUAL_NFC_PROTOCOLS  (NFC_PROTO_JEWEL_MASK | \
>                                  NFC_PROTO_MIFARE_MASK | \
> @@ -27,12 +21,12 @@ enum virtual_ncidev_mode {
>                                  NFC_PROTO_ISO14443_B_MASK | \
>                                  NFC_PROTO_ISO15693_MASK)
>
> -static enum virtual_ncidev_mode state;
> -static DECLARE_WAIT_QUEUE_HEAD(wq);
> -static struct miscdevice miscdev;
> -static struct sk_buff *send_buff;
> -static struct nci_dev *ndev;
> -static DEFINE_MUTEX(nci_mutex);
> +struct virtual_nci_dev {
> +       struct nci_dev *ndev;
> +       struct mutex mtx;
> +       struct sk_buff *send_buff;
> +       struct wait_queue_head wq;
> +};
>
>  static int virtual_nci_open(struct nci_dev *ndev)
>  {
> @@ -41,31 +35,29 @@ static int virtual_nci_open(struct nci_dev *ndev)
>
>  static int virtual_nci_close(struct nci_dev *ndev)
>  {
> -       mutex_lock(&nci_mutex);
> -       kfree_skb(send_buff);
> -       send_buff = NULL;
> -       mutex_unlock(&nci_mutex);
> +       struct virtual_nci_dev *vdev = nci_get_drvdata(ndev);
> +
> +       mutex_lock(&vdev->mtx);
> +       kfree_skb(vdev->send_buff);
> +       vdev->send_buff = NULL;
> +       mutex_unlock(&vdev->mtx);
>
>         return 0;
>  }
>
>  static int virtual_nci_send(struct nci_dev *ndev, struct sk_buff *skb)
>  {
> -       mutex_lock(&nci_mutex);
> -       if (state != virtual_ncidev_enabled) {
> -               mutex_unlock(&nci_mutex);
> -               kfree_skb(skb);
> -               return 0;
> -       }
> +       struct virtual_nci_dev *vdev = nci_get_drvdata(ndev);
>
> -       if (send_buff) {
> -               mutex_unlock(&nci_mutex);
> +       mutex_lock(&vdev->mtx);
> +       if (vdev->send_buff) {
> +               mutex_unlock(&vdev->mtx);
>                 kfree_skb(skb);
>                 return -1;
>         }
> -       send_buff = skb_copy(skb, GFP_KERNEL);
> -       mutex_unlock(&nci_mutex);
> -       wake_up_interruptible(&wq);
> +       vdev->send_buff = skb_copy(skb, GFP_KERNEL);
> +       mutex_unlock(&vdev->mtx);
> +       wake_up_interruptible(&vdev->wq);
>         consume_skb(skb);
>
>         return 0;
> @@ -80,29 +72,30 @@ static const struct nci_ops virtual_nci_ops = {
>  static ssize_t virtual_ncidev_read(struct file *file, char __user *buf,
>                                    size_t count, loff_t *ppos)
>  {
> +       struct virtual_nci_dev *vdev = file->private_data;
>         size_t actual_len;
>
> -       mutex_lock(&nci_mutex);
> -       while (!send_buff) {
> -               mutex_unlock(&nci_mutex);
> -               if (wait_event_interruptible(wq, send_buff))
> +       mutex_lock(&vdev->mtx);
> +       while (!vdev->send_buff) {
> +               mutex_unlock(&vdev->mtx);
> +               if (wait_event_interruptible(vdev->wq, vdev->send_buff))
>                         return -EFAULT;
> -               mutex_lock(&nci_mutex);
> +               mutex_lock(&vdev->mtx);
>         }
>
> -       actual_len = min_t(size_t, count, send_buff->len);
> +       actual_len = min_t(size_t, count, vdev->send_buff->len);
>
> -       if (copy_to_user(buf, send_buff->data, actual_len)) {
> -               mutex_unlock(&nci_mutex);
> +       if (copy_to_user(buf, vdev->send_buff->data, actual_len)) {
> +               mutex_unlock(&vdev->mtx);
>                 return -EFAULT;
>         }
>
> -       skb_pull(send_buff, actual_len);
> -       if (send_buff->len == 0) {
> -               consume_skb(send_buff);
> -               send_buff = NULL;
> +       skb_pull(vdev->send_buff, actual_len);
> +       if (vdev->send_buff->len == 0) {
> +               consume_skb(vdev->send_buff);
> +               vdev->send_buff = NULL;
>         }
> -       mutex_unlock(&nci_mutex);
> +       mutex_unlock(&vdev->mtx);
>
>         return actual_len;
>  }
> @@ -111,6 +104,7 @@ static ssize_t virtual_ncidev_write(struct file *file,
>                                     const char __user *buf,
>                                     size_t count, loff_t *ppos)
>  {
> +       struct virtual_nci_dev *vdev = file->private_data;
>         struct sk_buff *skb;
>
>         skb = alloc_skb(count, GFP_KERNEL);
> @@ -122,63 +116,57 @@ static ssize_t virtual_ncidev_write(struct file *file,
>                 return -EFAULT;
>         }
>
> -       nci_recv_frame(ndev, skb);
> +       nci_recv_frame(vdev->ndev, skb);
>         return count;
>  }
>
>  static int virtual_ncidev_open(struct inode *inode, struct file *file)
>  {
>         int ret = 0;
> +       struct virtual_nci_dev *vdev;
>
> -       mutex_lock(&nci_mutex);
> -       if (state != virtual_ncidev_disabled) {
> -               mutex_unlock(&nci_mutex);
> -               return -EBUSY;
> -       }
> -
> -       ndev = nci_allocate_device(&virtual_nci_ops, VIRTUAL_NFC_PROTOCOLS,
> -                                  0, 0);
> -       if (!ndev) {
> -               mutex_unlock(&nci_mutex);
> +       vdev = kzalloc(sizeof(*vdev), GFP_KERNEL);
> +       if (!vdev)
> +               return -ENOMEM;
> +       vdev->ndev = nci_allocate_device(&virtual_nci_ops,
> +               VIRTUAL_NFC_PROTOCOLS, 0, 0);
> +       if (!vdev->ndev) {
> +               kfree(vdev);
>                 return -ENOMEM;
>         }
>
> -       ret = nci_register_device(ndev);
> +       mutex_init(&vdev->mtx);
> +       init_waitqueue_head(&vdev->wq);
> +       file->private_data = vdev;
> +       nci_set_drvdata(vdev->ndev, vdev);
> +
> +       ret = nci_register_device(vdev->ndev);
>         if (ret < 0) {
> -               nci_free_device(ndev);
> -               mutex_unlock(&nci_mutex);
> +               mutex_destroy(&vdev->mtx);
> +               nci_free_device(vdev->ndev);
> +               kfree(vdev);
>                 return ret;
>         }
> -       state = virtual_ncidev_enabled;
> -       mutex_unlock(&nci_mutex);
>
>         return 0;
>  }
>
>  static int virtual_ncidev_close(struct inode *inode, struct file *file)
>  {
> -       mutex_lock(&nci_mutex);
> -
> -       if (state == virtual_ncidev_enabled) {
> -               state = virtual_ncidev_disabling;
> -               mutex_unlock(&nci_mutex);
> -
> -               nci_unregister_device(ndev);
> -               nci_free_device(ndev);
> -
> -               mutex_lock(&nci_mutex);
> -       }
> +       struct virtual_nci_dev *vdev = file->private_data;
>
> -       state = virtual_ncidev_disabled;
> -       mutex_unlock(&nci_mutex);
> +       nci_unregister_device(vdev->ndev);
> +       nci_free_device(vdev->ndev);
> +       mutex_destroy(&vdev->mtx);
>
>         return 0;
>  }
>
> -static long virtual_ncidev_ioctl(struct file *flip, unsigned int cmd,
> +static long virtual_ncidev_ioctl(struct file *file, unsigned int cmd,
>                                  unsigned long arg)
>  {
> -       const struct nfc_dev *nfc_dev = ndev->nfc_dev;
> +       struct virtual_nci_dev *vdev = file->private_data;
> +       const struct nfc_dev *nfc_dev = vdev->ndev->nfc_dev;
>         void __user *p = (void __user *)arg;
>
>         if (cmd != IOCTL_GET_NCIDEV_IDX)
> @@ -199,14 +187,15 @@ static const struct file_operations virtual_ncidev_fops = {
>         .unlocked_ioctl = virtual_ncidev_ioctl
>  };
>
> +static struct miscdevice miscdev = {
> +       .minor = MISC_DYNAMIC_MINOR,
> +       .name = "virtual_nci",
> +       .fops = &virtual_ncidev_fops,
> +       .mode = 0600,
> +};
> +
>  static int __init virtual_ncidev_init(void)
>  {
> -       state = virtual_ncidev_disabled;
> -       miscdev.minor = MISC_DYNAMIC_MINOR;
> -       miscdev.name = "virtual_nci";
> -       miscdev.fops = &virtual_ncidev_fops;
> -       miscdev.mode = 0600;
> -
>         return misc_register(&miscdev);
>  }
>
>
> base-commit: 02a97e02c64fb3245b84835cbbed1c3a3222e2f1
> --
> 2.38.1.273.g43a17bfeac-goog
>
