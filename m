Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7B3F635D13
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 13:41:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236813AbiKWMjo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 07:39:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237450AbiKWMjW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 07:39:22 -0500
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89B0A663D3;
        Wed, 23 Nov 2022 04:39:09 -0800 (PST)
Received: by mail-qk1-f181.google.com with SMTP id x21so12298567qkj.0;
        Wed, 23 Nov 2022 04:39:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=23ZKjQivDaJ6vcJyWC4uv5Yzkf6ZjHvU8yFz/P5RXg4=;
        b=JYdpPwR/WV2EUeCG6tDHcV2nmRZdskSmIx8qFZnQbRvkamPdOtPESUjN1MYMu1KZAk
         NtIzcIHKNltzP8lCAn4XILJBz20VUacFZScrkqqSkjsj8spRooIXaYfNWowwgLeIZle9
         DHf/0qQ15JdVlM+Hmh7EtCfuJKOZ60spbcJwA8TBi4/OuTsay8P7FphzTbLk/s6JyJiU
         XHJzTvVt9P/1gtLbvw8FYuHInlYLEz8MGSTTuo6B4TXPmRVjye7Ds3nvBCf6F3fKeUK9
         HuX9qnP+Wk89Kb+HLAebCZllGOvu4oI7AgIbCIraUANO+FB3rOAIrTiJs9SAjvPK6ZNv
         Bnfw==
X-Gm-Message-State: ANoB5pmDutuHvsNr2XDC52bJk5wR6Cf9BjlIMqb5lkGE5yPkpYBM3P+S
        oM5ORQuYM5DU5aEGQIdCjENJgkal9cZZFJw7SlI=
X-Google-Smtp-Source: AA0mqf41PAaYKSESBcDnkru4EJGZZF66sfFYKXsivNVokGnQ1/TrWtjCKB7G2DKR5wuyuaIubXDR0TK1CxhTvz3zwMc=
X-Received: by 2002:a05:620a:51ca:b0:6ec:fa04:d97c with SMTP id
 cx10-20020a05620a51ca00b006ecfa04d97cmr8572791qkb.764.1669207148628; Wed, 23
 Nov 2022 04:39:08 -0800 (PST)
MIME-Version: 1.0
References: <20221123122523.1332370-1-gregkh@linuxfoundation.org>
In-Reply-To: <20221123122523.1332370-1-gregkh@linuxfoundation.org>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Wed, 23 Nov 2022 13:38:57 +0100
Message-ID: <CAJZ5v0grLAZQbZTfMNo-O+o8OJ1prhXVQ0aaS1P4O2dO_A35fg@mail.gmail.com>
Subject: Re: [PATCH 1/5] driver core: make struct class.dev_uevent() take a
 const *
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Russ Weight <russell.h.weight@intel.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Jean Delvare <jdelvare@suse.com>,
        Johan Hovold <johan@kernel.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>,
        Karsten Keil <isdn@linux-pingi.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Keith Busch <kbusch@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Sebastian Reichel <sre@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Raed Salem <raeds@nvidia.com>,
        Chen Zhongjin <chenzhongjin@huawei.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Avihai Horon <avihaih@nvidia.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Colin Ian King <colin.i.king@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Jakob Koschel <jakobkoschel@gmail.com>,
        Antoine Tenart <atenart@kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Wang Yufen <wangyufen@huawei.com>, linux-block@vger.kernel.org,
        linux-media@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-pm@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 23, 2022 at 1:25 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> The dev_uevent() in struct class should not be modifying the device that
> is passed into it, so mark it as a const * and propagate the function
> signature changes out into all relevant subsystems that use this
> callback.
>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Luis Chamberlain <mcgrof@kernel.org>
> Cc: Russ Weight <russell.h.weight@intel.com>
> Cc: "Rafael J. Wysocki" <rafael@kernel.org>
> Cc: Jean Delvare <jdelvare@suse.com>
> Cc: Johan Hovold <johan@kernel.org>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: Leon Romanovsky <leon@kernel.org>
> Cc: Karsten Keil <isdn@linux-pingi.de>
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> Cc: Keith Busch <kbusch@kernel.org>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Sagi Grimberg <sagi@grimberg.me>
> Cc: Dominik Brodowski <linux@dominikbrodowski.net>
> Cc: Sebastian Reichel <sre@kernel.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: Johannes Berg <johannes@sipsolutions.net>
> Cc: Wolfram Sang <wsa+renesas@sang-engineering.com>
> Cc: Raed Salem <raeds@nvidia.com>
> Cc: Chen Zhongjin <chenzhongjin@huawei.com>
> Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Cc: Avihai Horon <avihaih@nvidia.com>
> Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> Cc: Alan Stern <stern@rowland.harvard.edu>
> Cc: Colin Ian King <colin.i.king@gmail.com>
> Cc: Geert Uytterhoeven <geert+renesas@glider.be>
> Cc: Jakob Koschel <jakobkoschel@gmail.com>
> Cc: Antoine Tenart <atenart@kernel.org>
> Cc: Frederic Weisbecker <frederic@kernel.org>
> Cc: Wang Yufen <wangyufen@huawei.com>
> Cc: linux-block@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-media@vger.kernel.org
> Cc: linux-nvme@lists.infradead.org
> Cc: linux-pm@vger.kernel.org
> Cc: linux-rdma@vger.kernel.org
> Cc: linux-usb@vger.kernel.org
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Acked-by: Rafael J. Wysocki <rafael@kernel.org>

> ---
>  block/genhd.c                             | 4 ++--
>  drivers/base/firmware_loader/sysfs.c      | 6 +++---
>  drivers/base/firmware_loader/sysfs.h      | 2 +-
>  drivers/firmware/dmi-id.c                 | 2 +-
>  drivers/gnss/core.c                       | 6 +++---
>  drivers/infiniband/core/device.c          | 2 +-
>  drivers/isdn/mISDN/core.c                 | 4 ++--
>  drivers/media/dvb-core/dvbdev.c           | 4 ++--
>  drivers/nvme/host/core.c                  | 4 ++--
>  drivers/pcmcia/cs.c                       | 4 ++--
>  drivers/power/supply/power_supply.h       | 2 +-
>  drivers/power/supply/power_supply_sysfs.c | 8 ++++----
>  drivers/usb/gadget/udc/core.c             | 4 ++--
>  include/linux/device/class.h              | 2 +-
>  include/linux/mISDNif.h                   | 2 +-
>  net/atm/atm_sysfs.c                       | 4 ++--
>  net/core/net-sysfs.c                      | 4 ++--
>  net/rfkill/core.c                         | 2 +-
>  18 files changed, 33 insertions(+), 33 deletions(-)
>
> diff --git a/block/genhd.c b/block/genhd.c
> index 0f9769db2de8..3f1124713442 100644
> --- a/block/genhd.c
> +++ b/block/genhd.c
> @@ -1181,9 +1181,9 @@ static void disk_release(struct device *dev)
>         iput(disk->part0->bd_inode);    /* frees the disk */
>  }
>
> -static int block_uevent(struct device *dev, struct kobj_uevent_env *env)
> +static int block_uevent(const struct device *dev, struct kobj_uevent_env *env)
>  {
> -       struct gendisk *disk = dev_to_disk(dev);
> +       const struct gendisk *disk = dev_to_disk(dev);
>
>         return add_uevent_var(env, "DISKSEQ=%llu", disk->diskseq);
>  }
> diff --git a/drivers/base/firmware_loader/sysfs.c b/drivers/base/firmware_loader/sysfs.c
> index 5b66b3d1fa16..56911d75b90a 100644
> --- a/drivers/base/firmware_loader/sysfs.c
> +++ b/drivers/base/firmware_loader/sysfs.c
> @@ -64,7 +64,7 @@ static struct attribute *firmware_class_attrs[] = {
>  };
>  ATTRIBUTE_GROUPS(firmware_class);
>
> -static int do_firmware_uevent(struct fw_sysfs *fw_sysfs, struct kobj_uevent_env *env)
> +static int do_firmware_uevent(const struct fw_sysfs *fw_sysfs, struct kobj_uevent_env *env)
>  {
>         if (add_uevent_var(env, "FIRMWARE=%s", fw_sysfs->fw_priv->fw_name))
>                 return -ENOMEM;
> @@ -76,9 +76,9 @@ static int do_firmware_uevent(struct fw_sysfs *fw_sysfs, struct kobj_uevent_env
>         return 0;
>  }
>
> -static int firmware_uevent(struct device *dev, struct kobj_uevent_env *env)
> +static int firmware_uevent(const struct device *dev, struct kobj_uevent_env *env)
>  {
> -       struct fw_sysfs *fw_sysfs = to_fw_sysfs(dev);
> +       const struct fw_sysfs *fw_sysfs = to_fw_sysfs(dev);
>         int err = 0;
>
>         mutex_lock(&fw_lock);
> diff --git a/drivers/base/firmware_loader/sysfs.h b/drivers/base/firmware_loader/sysfs.h
> index df1d5add698f..fd0b4ad9bdbb 100644
> --- a/drivers/base/firmware_loader/sysfs.h
> +++ b/drivers/base/firmware_loader/sysfs.h
> @@ -81,7 +81,7 @@ struct fw_sysfs {
>         void *fw_upload_priv;
>  };
>
> -static inline struct fw_sysfs *to_fw_sysfs(struct device *dev)
> +static inline struct fw_sysfs *to_fw_sysfs(const struct device *dev)
>  {
>         return container_of(dev, struct fw_sysfs, dev);
>  }
> diff --git a/drivers/firmware/dmi-id.c b/drivers/firmware/dmi-id.c
> index 940ddf916202..5f3a3e913d28 100644
> --- a/drivers/firmware/dmi-id.c
> +++ b/drivers/firmware/dmi-id.c
> @@ -155,7 +155,7 @@ static const struct attribute_group* sys_dmi_attribute_groups[] = {
>         NULL
>  };
>
> -static int dmi_dev_uevent(struct device *dev, struct kobj_uevent_env *env)
> +static int dmi_dev_uevent(const struct device *dev, struct kobj_uevent_env *env)
>  {
>         ssize_t len;
>
> diff --git a/drivers/gnss/core.c b/drivers/gnss/core.c
> index 1e82b7967570..77a4b280c552 100644
> --- a/drivers/gnss/core.c
> +++ b/drivers/gnss/core.c
> @@ -337,7 +337,7 @@ static const char * const gnss_type_names[GNSS_TYPE_COUNT] = {
>         [GNSS_TYPE_MTK]         = "MTK",
>  };
>
> -static const char *gnss_type_name(struct gnss_device *gdev)
> +static const char *gnss_type_name(const struct gnss_device *gdev)
>  {
>         const char *name = NULL;
>
> @@ -365,9 +365,9 @@ static struct attribute *gnss_attrs[] = {
>  };
>  ATTRIBUTE_GROUPS(gnss);
>
> -static int gnss_uevent(struct device *dev, struct kobj_uevent_env *env)
> +static int gnss_uevent(const struct device *dev, struct kobj_uevent_env *env)
>  {
> -       struct gnss_device *gdev = to_gnss_device(dev);
> +       const struct gnss_device *gdev = to_gnss_device(dev);
>         int ret;
>
>         ret = add_uevent_var(env, "GNSS_TYPE=%s", gnss_type_name(gdev));
> diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
> index fa65c5d3d395..4186dbf9377f 100644
> --- a/drivers/infiniband/core/device.c
> +++ b/drivers/infiniband/core/device.c
> @@ -511,7 +511,7 @@ static void ib_device_release(struct device *device)
>         kfree_rcu(dev, rcu_head);
>  }
>
> -static int ib_device_uevent(struct device *device,
> +static int ib_device_uevent(const struct device *device,
>                             struct kobj_uevent_env *env)
>  {
>         if (add_uevent_var(env, "NAME=%s", dev_name(device)))
> diff --git a/drivers/isdn/mISDN/core.c b/drivers/isdn/mISDN/core.c
> index 90ee56d07a6e..9120be590325 100644
> --- a/drivers/isdn/mISDN/core.c
> +++ b/drivers/isdn/mISDN/core.c
> @@ -139,9 +139,9 @@ static struct attribute *mISDN_attrs[] = {
>  };
>  ATTRIBUTE_GROUPS(mISDN);
>
> -static int mISDN_uevent(struct device *dev, struct kobj_uevent_env *env)
> +static int mISDN_uevent(const struct device *dev, struct kobj_uevent_env *env)
>  {
> -       struct mISDNdevice *mdev = dev_to_mISDN(dev);
> +       const struct mISDNdevice *mdev = dev_to_mISDN(dev);
>
>         if (!mdev)
>                 return 0;
> diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
> index 675d877a67b2..6ef18bab9648 100644
> --- a/drivers/media/dvb-core/dvbdev.c
> +++ b/drivers/media/dvb-core/dvbdev.c
> @@ -1008,9 +1008,9 @@ void dvb_module_release(struct i2c_client *client)
>  EXPORT_SYMBOL_GPL(dvb_module_release);
>  #endif
>
> -static int dvb_uevent(struct device *dev, struct kobj_uevent_env *env)
> +static int dvb_uevent(const struct device *dev, struct kobj_uevent_env *env)
>  {
> -       struct dvb_device *dvbdev = dev_get_drvdata(dev);
> +       const struct dvb_device *dvbdev = dev_get_drvdata(dev);
>
>         add_uevent_var(env, "DVB_ADAPTER_NUM=%d", dvbdev->adapter->num);
>         add_uevent_var(env, "DVB_DEVICE_TYPE=%s", dnames[dvbdev->type]);
> diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
> index da55ce45ac70..b4778b970dd4 100644
> --- a/drivers/nvme/host/core.c
> +++ b/drivers/nvme/host/core.c
> @@ -4580,9 +4580,9 @@ void nvme_remove_namespaces(struct nvme_ctrl *ctrl)
>  }
>  EXPORT_SYMBOL_GPL(nvme_remove_namespaces);
>
> -static int nvme_class_uevent(struct device *dev, struct kobj_uevent_env *env)
> +static int nvme_class_uevent(const struct device *dev, struct kobj_uevent_env *env)
>  {
> -       struct nvme_ctrl *ctrl =
> +       const struct nvme_ctrl *ctrl =
>                 container_of(dev, struct nvme_ctrl, ctrl_device);
>         struct nvmf_ctrl_options *opts = ctrl->opts;
>         int ret;
> diff --git a/drivers/pcmcia/cs.c b/drivers/pcmcia/cs.c
> index f70197154a36..e3224e49c43f 100644
> --- a/drivers/pcmcia/cs.c
> +++ b/drivers/pcmcia/cs.c
> @@ -810,10 +810,10 @@ int pcmcia_reset_card(struct pcmcia_socket *skt)
>  EXPORT_SYMBOL(pcmcia_reset_card);
>
>
> -static int pcmcia_socket_uevent(struct device *dev,
> +static int pcmcia_socket_uevent(const struct device *dev,
>                                 struct kobj_uevent_env *env)
>  {
> -       struct pcmcia_socket *s = container_of(dev, struct pcmcia_socket, dev);
> +       const struct pcmcia_socket *s = container_of(dev, struct pcmcia_socket, dev);
>
>         if (add_uevent_var(env, "SOCKET_NO=%u", s->sock))
>                 return -ENOMEM;
> diff --git a/drivers/power/supply/power_supply.h b/drivers/power/supply/power_supply.h
> index c310d4f36c10..645eee4d6b6a 100644
> --- a/drivers/power/supply/power_supply.h
> +++ b/drivers/power/supply/power_supply.h
> @@ -16,7 +16,7 @@ struct power_supply;
>  #ifdef CONFIG_SYSFS
>
>  extern void power_supply_init_attrs(struct device_type *dev_type);
> -extern int power_supply_uevent(struct device *dev, struct kobj_uevent_env *env);
> +extern int power_supply_uevent(const struct device *dev, struct kobj_uevent_env *env);
>
>  #else
>
> diff --git a/drivers/power/supply/power_supply_sysfs.c b/drivers/power/supply/power_supply_sysfs.c
> index 5369abaceb5c..6ca7d3985a40 100644
> --- a/drivers/power/supply/power_supply_sysfs.c
> +++ b/drivers/power/supply/power_supply_sysfs.c
> @@ -427,7 +427,7 @@ void power_supply_init_attrs(struct device_type *dev_type)
>         }
>  }
>
> -static int add_prop_uevent(struct device *dev, struct kobj_uevent_env *env,
> +static int add_prop_uevent(const struct device *dev, struct kobj_uevent_env *env,
>                            enum power_supply_property prop, char *prop_buf)
>  {
>         int ret = 0;
> @@ -438,7 +438,7 @@ static int add_prop_uevent(struct device *dev, struct kobj_uevent_env *env,
>         pwr_attr = &power_supply_attrs[prop];
>         dev_attr = &pwr_attr->dev_attr;
>
> -       ret = power_supply_show_property(dev, dev_attr, prop_buf);
> +       ret = power_supply_show_property((struct device *)dev, dev_attr, prop_buf);
>         if (ret == -ENODEV || ret == -ENODATA) {
>                 /*
>                  * When a battery is absent, we expect -ENODEV. Don't abort;
> @@ -458,9 +458,9 @@ static int add_prop_uevent(struct device *dev, struct kobj_uevent_env *env,
>                               pwr_attr->prop_name, prop_buf);
>  }
>
> -int power_supply_uevent(struct device *dev, struct kobj_uevent_env *env)
> +int power_supply_uevent(const struct device *dev, struct kobj_uevent_env *env)
>  {
> -       struct power_supply *psy = dev_get_drvdata(dev);
> +       const struct power_supply *psy = dev_get_drvdata(dev);
>         int ret = 0, j;
>         char *prop_buf;
>
> diff --git a/drivers/usb/gadget/udc/core.c b/drivers/usb/gadget/udc/core.c
> index c63c0c2cf649..b5994a0604f6 100644
> --- a/drivers/usb/gadget/udc/core.c
> +++ b/drivers/usb/gadget/udc/core.c
> @@ -1723,9 +1723,9 @@ static const struct attribute_group *usb_udc_attr_groups[] = {
>         NULL,
>  };
>
> -static int usb_udc_uevent(struct device *dev, struct kobj_uevent_env *env)
> +static int usb_udc_uevent(const struct device *dev, struct kobj_uevent_env *env)
>  {
> -       struct usb_udc          *udc = container_of(dev, struct usb_udc, dev);
> +       const struct usb_udc    *udc = container_of(dev, struct usb_udc, dev);
>         int                     ret;
>
>         ret = add_uevent_var(env, "USB_UDC_NAME=%s", udc->gadget->name);
> diff --git a/include/linux/device/class.h b/include/linux/device/class.h
> index 20103e0b03c3..94b1107258e5 100644
> --- a/include/linux/device/class.h
> +++ b/include/linux/device/class.h
> @@ -59,7 +59,7 @@ struct class {
>         const struct attribute_group    **dev_groups;
>         struct kobject                  *dev_kobj;
>
> -       int (*dev_uevent)(struct device *dev, struct kobj_uevent_env *env);
> +       int (*dev_uevent)(const struct device *dev, struct kobj_uevent_env *env);
>         char *(*devnode)(struct device *dev, umode_t *mode);
>
>         void (*class_release)(struct class *class);
> diff --git a/include/linux/mISDNif.h b/include/linux/mISDNif.h
> index 7dd1f01ec4f9..7aab4a769736 100644
> --- a/include/linux/mISDNif.h
> +++ b/include/linux/mISDNif.h
> @@ -586,7 +586,7 @@ extern struct mISDNclock *mISDN_register_clock(char *, int, clockctl_func_t *,
>                                                 void *);
>  extern void    mISDN_unregister_clock(struct mISDNclock *);
>
> -static inline struct mISDNdevice *dev_to_mISDN(struct device *dev)
> +static inline struct mISDNdevice *dev_to_mISDN(const struct device *dev)
>  {
>         if (dev)
>                 return dev_get_drvdata(dev);
> diff --git a/net/atm/atm_sysfs.c b/net/atm/atm_sysfs.c
> index 0fdbdfd19474..466353b3dde4 100644
> --- a/net/atm/atm_sysfs.c
> +++ b/net/atm/atm_sysfs.c
> @@ -108,9 +108,9 @@ static struct device_attribute *atm_attrs[] = {
>  };
>
>
> -static int atm_uevent(struct device *cdev, struct kobj_uevent_env *env)
> +static int atm_uevent(const struct device *cdev, struct kobj_uevent_env *env)
>  {
> -       struct atm_dev *adev;
> +       const struct atm_dev *adev;
>
>         if (!cdev)
>                 return -ENODEV;
> diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
> index 9cfc80b8ed25..03a61d1dffbd 100644
> --- a/net/core/net-sysfs.c
> +++ b/net/core/net-sysfs.c
> @@ -1873,9 +1873,9 @@ const struct kobj_ns_type_operations net_ns_type_operations = {
>  };
>  EXPORT_SYMBOL_GPL(net_ns_type_operations);
>
> -static int netdev_uevent(struct device *d, struct kobj_uevent_env *env)
> +static int netdev_uevent(const struct device *d, struct kobj_uevent_env *env)
>  {
> -       struct net_device *dev = to_net_dev(d);
> +       const struct net_device *dev = to_net_dev(d);
>         int retval;
>
>         /* pass interface to uevent. */
> diff --git a/net/rfkill/core.c b/net/rfkill/core.c
> index dac4fdc7488a..b390ff245d5e 100644
> --- a/net/rfkill/core.c
> +++ b/net/rfkill/core.c
> @@ -832,7 +832,7 @@ static void rfkill_release(struct device *dev)
>         kfree(rfkill);
>  }
>
> -static int rfkill_dev_uevent(struct device *dev, struct kobj_uevent_env *env)
> +static int rfkill_dev_uevent(const struct device *dev, struct kobj_uevent_env *env)
>  {
>         struct rfkill *rfkill = to_rfkill(dev);
>         unsigned long flags;
> --
> 2.38.1
>
