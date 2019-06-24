Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6693E50A4E
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 14:03:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727763AbfFXMDw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 08:03:52 -0400
Received: from mail-eopbgr80078.outbound.protection.outlook.com ([40.107.8.78]:9447
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726375AbfFXMDw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jun 2019 08:03:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nX/qq+AKnD22MB/ZcPL+DIMlJE1tgP55likkUrqKOn0=;
 b=kqCo+WVxu+z9S9xfTIlzv86ChPR3QV4tSPwEA9i01VX0RlhqNShiaHULm21AB/i5DF/wepZL3vu0NAVbCTZ3SchCZ5RKun/itSvjzmD2h6epDUT7DsStPjeF+NYJLczz3fYb/i5fSgjs7rINlErFIXoRcRXlM8YyvHGL2BjbQ9I=
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (10.171.182.144) by
 VI1PR05MB4111.eurprd05.prod.outlook.com (10.171.182.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Mon, 24 Jun 2019 12:03:42 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::f5d8:df9:731:682e]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::f5d8:df9:731:682e%5]) with mapi id 15.20.2008.014; Mon, 24 Jun 2019
 12:03:42 +0000
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     Doug Ledford <dledford@redhat.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Yishai Hadas <yishaih@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH rdma-next v1 11/12] IB/mlx5: Implement DEVX dispatching
 event
Thread-Topic: [PATCH rdma-next v1 11/12] IB/mlx5: Implement DEVX dispatching
 event
Thread-Index: AQHVJfmOhAl6cjxbGkeHYVIPFHC63aaqvcMA
Date:   Mon, 24 Jun 2019 12:03:42 +0000
Message-ID: <20190624120338.GD5479@mellanox.com>
References: <20190618171540.11729-1-leon@kernel.org>
 <20190618171540.11729-12-leon@kernel.org>
In-Reply-To: <20190618171540.11729-12-leon@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BL0PR02CA0134.namprd02.prod.outlook.com
 (2603:10b6:208:35::39) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:4d::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [209.213.91.242]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 31da0e6b-e85f-4990-4b42-08d6f89c002e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:VI1PR05MB4111;
x-ms-traffictypediagnostic: VI1PR05MB4111:
x-microsoft-antispam-prvs: <VI1PR05MB4111043A583F3FD5FD61C58CCFE00@VI1PR05MB4111.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 007814487B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(39860400002)(366004)(396003)(346002)(376002)(199004)(189003)(54906003)(11346002)(2616005)(33656002)(6486002)(3846002)(6916009)(66066001)(305945005)(26005)(6116002)(4326008)(2906002)(36756003)(478600001)(68736007)(7736002)(229853002)(52116002)(186003)(446003)(316002)(64756008)(486006)(102836004)(5660300002)(14454004)(476003)(6246003)(53936002)(66946007)(71200400001)(71190400001)(8676002)(81156014)(73956011)(1076003)(76176011)(14444005)(81166006)(6512007)(99286004)(6506007)(386003)(256004)(25786009)(8936002)(66476007)(66446008)(6436002)(86362001)(66556008)(30864003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4111;H:VI1PR05MB4141.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: NOd81UlSry0dMe2PR+Y0ZM1qoEuoq+xbnxE/WT4s1Yf9xEH7kFuoyUFH3WgiYs3YnOxBvKMMG9AsVW6B9leeqnkCUws4PXncCakoFWpv598PXJAKVLUoOohBbuPDUiPEEjHZLYlb77TQOKRvfcS/Uj2eoUV9yWFGBdVY8iiT0J0soErtRzISvO9fDu1LtddedcEdr+tQoMtB9KJEw5UEJIKoGuKCIcxQn0lXqJ2XajZVg/gAMoFK+zQKCIFAZbgOBq/QjYRN9PmctoaETzFYL83njdkt0zY/xaOMrw6GJVWXq/Aqlvaqt0t5hvvfNfzgcW/aKHtIvfBZMY0vNE1iF1Po2nMlzAr6geKY6Q7C81P932obRXHtxy5g5cajxq5/j2yTnQUZUkL4tZj1+FmbwOiH+YjZ6Fgl7TTyUg8z/Sk=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <BB36472CAF886847A9CA885F0F470D9F@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31da0e6b-e85f-4990-4b42-08d6f89c002e
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2019 12:03:42.5361
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jgg@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4111
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 18, 2019 at 08:15:39PM +0300, Leon Romanovsky wrote:
> From: Yishai Hadas <yishaih@mellanox.com>
>=20
> Implement DEVX dispatching event by looking up for the applicable
> subscriptions for the reported event and using their target fd to
> signal/set the event.
>=20
> Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
>  drivers/infiniband/hw/mlx5/devx.c         | 362 +++++++++++++++++++++-
>  include/uapi/rdma/mlx5_user_ioctl_verbs.h |   5 +
>  2 files changed, 357 insertions(+), 10 deletions(-)
>=20
> diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/ml=
x5/devx.c
> index 304b13e7a265..49fdce95d6d9 100644
> +++ b/drivers/infiniband/hw/mlx5/devx.c
> @@ -34,6 +34,11 @@ struct devx_async_data {
>  	struct mlx5_ib_uapi_devx_async_cmd_hdr hdr;
>  };
> =20
> +struct devx_async_event_data {
> +	struct list_head list; /* headed in ev_queue->event_list */
> +	struct mlx5_ib_uapi_devx_async_event_hdr hdr;
> +};
> +
>  /* first level XA value data structure */
>  struct devx_event {
>  	struct xarray object_ids; /* second XA level, Key =3D object id */
> @@ -54,7 +59,9 @@ struct devx_event_subscription {
>  				   * devx_obj_event->obj_sub_list
>  				   */
>  	struct list_head obj_list; /* headed in devx_object */
> +	struct list_head event_list; /* headed in ev_queue->event_list */
> =20
> +	u8  is_cleaned:1;

There is a loose bool 'is_obj_related' that should be combined with
this bool bitfield as well.

>  static void devx_cleanup_subscription(struct mlx5_ib_dev *dev,
> -				      struct devx_event_subscription *sub)
> +				      struct devx_event_subscription *sub,
> +				      bool file_close)
>  {
> -	list_del_rcu(&sub->file_list);
> +	if (sub->is_cleaned)
> +		goto end;
> +
> +	sub->is_cleaned =3D 1;
>  	list_del_rcu(&sub->xa_list);
> =20
>  	if (sub->is_obj_related) {
> @@ -1303,10 +1355,15 @@ static void devx_cleanup_subscription(struct mlx5=
_ib_dev *dev,
>  		}
>  	}
> =20
> -	if (sub->eventfd)
> -		eventfd_ctx_put(sub->eventfd);
> +end:
> +	if (file_close) {
> +		if (sub->eventfd)
> +			eventfd_ctx_put(sub->eventfd);
> =20
> -	kfree_rcu(sub, rcu);
> +		list_del_rcu(&sub->file_list);
> +		/* subscription may not be used by the read API any more */
> +		kfree_rcu(sub, rcu);
> +	}

Dis like this confusing file_close stuff, just put this in the single place
that calls this with the true bool

> +static int deliver_event(struct devx_event_subscription *event_sub,
> +			 const void *data)
> +{
> +	struct ib_uobject *fd_uobj =3D event_sub->fd_uobj;
> +	struct devx_async_event_file *ev_file;
> +	struct devx_async_event_queue *ev_queue;
> +	struct devx_async_event_data *event_data;
> +	unsigned long flags;
> +	bool omit_data;
> +
> +	ev_file =3D container_of(fd_uobj, struct devx_async_event_file,
> +			       uobj);
> +	ev_queue =3D &ev_file->ev_queue;
> +	omit_data =3D ev_queue->flags &
> +		MLX5_IB_UAPI_DEVX_CREATE_EVENT_CHANNEL_FLAGS_OMIT_EV_DATA;
> +
> +	if (omit_data) {
> +		spin_lock_irqsave(&ev_queue->lock, flags);
> +		if (!list_empty(&event_sub->event_list)) {
> +			spin_unlock_irqrestore(&ev_queue->lock, flags);
> +			return 0;
> +		}
> +
> +		list_add_tail(&event_sub->event_list, &ev_queue->event_list);
> +		spin_unlock_irqrestore(&ev_queue->lock, flags);
> +		wake_up_interruptible(&ev_queue->poll_wait);
> +		return 0;
> +	}
> +
> +	event_data =3D kzalloc(sizeof(*event_data) +
> +			     (omit_data ? 0 : sizeof(struct mlx5_eqe)),
> +			     GFP_ATOMIC);

omit_data is always false here

> +	if (!event_data) {
> +		spin_lock_irqsave(&ev_queue->lock, flags);
> +		ev_queue->is_overflow_err =3D 1;
> +		spin_unlock_irqrestore(&ev_queue->lock, flags);
> +		return -ENOMEM;
> +	}
> +
> +	event_data->hdr.cookie =3D event_sub->cookie;
> +	memcpy(event_data->hdr.out_data, data, sizeof(struct mlx5_eqe));
> +
> +	spin_lock_irqsave(&ev_queue->lock, flags);
> +	list_add_tail(&event_data->list, &ev_queue->event_list);
> +	spin_unlock_irqrestore(&ev_queue->lock, flags);
> +	wake_up_interruptible(&ev_queue->poll_wait);
> +
> +	return 0;
> +}
> +
> +static void dispatch_event_fd(struct list_head *fd_list,
> +			      const void *data)
> +{
> +	struct devx_event_subscription *item;
> +
> +	list_for_each_entry_rcu(item, fd_list, xa_list) {
> +		if (!get_file_rcu((struct file *)item->object))
> +			continue;
> +
> +		if (item->eventfd) {
> +			eventfd_signal(item->eventfd, 1);
> +			fput(item->object);
> +			continue;
> +		}
> +
> +		deliver_event(item, data);
> +		fput(item->object);
> +	}
> +}
> +
>  static int devx_event_notifier(struct notifier_block *nb,
>  			       unsigned long event_type, void *data)
>  {
> -	return NOTIFY_DONE;
> +	struct mlx5_devx_event_table *table;
> +	struct mlx5_ib_dev *dev;
> +	struct devx_event *event;
> +	struct devx_obj_event *obj_event;
> +	u16 obj_type =3D 0;
> +	bool is_unaffiliated;
> +	u32 obj_id;
> +
> +	/* Explicit filtering to kernel events which may occur frequently */
> +	if (event_type =3D=3D MLX5_EVENT_TYPE_CMD ||
> +	    event_type =3D=3D MLX5_EVENT_TYPE_PAGE_REQUEST)
> +		return NOTIFY_OK;
> +
> +	table =3D container_of(nb, struct mlx5_devx_event_table, devx_nb.nb);
> +	dev =3D container_of(table, struct mlx5_ib_dev, devx_event_table);
> +	is_unaffiliated =3D is_unaffiliated_event(dev->mdev, event_type);
> +
> +	if (!is_unaffiliated)
> +		obj_type =3D get_event_obj_type(event_type, data);
> +	event =3D xa_load(&table->event_xa, event_type | (obj_type << 16));
> +	if (!event)
> +		return NOTIFY_DONE;

event should be in the rcu as well

> +	if (is_unaffiliated) {
> +		dispatch_event_fd(&event->unaffiliated_list, data);
> +		return NOTIFY_OK;
> +	}
> +
> +	obj_id =3D devx_get_obj_id_from_event(event_type, data);
> +	rcu_read_lock();
> +	obj_event =3D xa_load(&event->object_ids, obj_id);
> +	if (!obj_event) {
> +		rcu_read_unlock();
> +		return NOTIFY_DONE;
> +	}
> +
> +	dispatch_event_fd(&obj_event->obj_sub_list, data);
> +
> +	rcu_read_unlock();
> +	return NOTIFY_OK;
>  }
> =20
>  void mlx5_ib_devx_init_event_table(struct mlx5_ib_dev *dev)
> @@ -2221,7 +2444,7 @@ void mlx5_ib_devx_cleanup_event_table(struct mlx5_i=
b_dev *dev)
>  		event =3D entry;
>  		list_for_each_entry_safe(sub, tmp, &event->unaffiliated_list,
>  					 xa_list)
> -			devx_cleanup_subscription(dev, sub);
> +			devx_cleanup_subscription(dev, sub, false);
>  		kfree(entry);
>  	}
>  	mutex_unlock(&dev->devx_event_table.event_xa_lock);
> @@ -2329,18 +2552,126 @@ static const struct file_operations devx_async_c=
md_event_fops =3D {
>  static ssize_t devx_async_event_read(struct file *filp, char __user *buf=
,
>  				     size_t count, loff_t *pos)
>  {
> -	return -EINVAL;
> +	struct devx_async_event_file *ev_file =3D filp->private_data;
> +	struct devx_async_event_queue *ev_queue =3D &ev_file->ev_queue;
> +	struct devx_event_subscription *event_sub;
> +	struct devx_async_event_data *uninitialized_var(event);
> +	int ret =3D 0;
> +	size_t eventsz;
> +	bool omit_data;
> +	void *event_data;
> +
> +	omit_data =3D ev_queue->flags &
> +		MLX5_IB_UAPI_DEVX_CREATE_EVENT_CHANNEL_FLAGS_OMIT_EV_DATA;
> +
> +	spin_lock_irq(&ev_queue->lock);
> +
> +	if (ev_queue->is_overflow_err) {
> +		ev_queue->is_overflow_err =3D 0;
> +		spin_unlock_irq(&ev_queue->lock);
> +		return -EOVERFLOW;
> +	}
> +
> +	while (list_empty(&ev_queue->event_list)) {
> +		spin_unlock_irq(&ev_queue->lock);
> +
> +		if (filp->f_flags & O_NONBLOCK)
> +			return -EAGAIN;
> +
> +		if (wait_event_interruptible(ev_queue->poll_wait,
> +			    (!list_empty(&ev_queue->event_list) ||
> +			     ev_queue->is_destroyed))) {
> +			return -ERESTARTSYS;
> +		}
> +
> +		if (list_empty(&ev_queue->event_list) &&
> +		    ev_queue->is_destroyed)
> +			return -EIO;

All these tests should be under the lock.

Why don't we return EIO as soon as is-destroyed happens? What is the
point of flushing out the accumulated events?

> +
> +		spin_lock_irq(&ev_queue->lock);
> +	}
> +
> +	if (omit_data) {
> +		event_sub =3D list_first_entry(&ev_queue->event_list,
> +					struct devx_event_subscription,
> +					event_list);
> +		eventsz =3D sizeof(event_sub->cookie);
> +		event_data =3D &event_sub->cookie;
> +	} else {
> +		event =3D list_first_entry(&ev_queue->event_list,
> +				      struct devx_async_event_data, list);
> +		eventsz =3D sizeof(struct mlx5_eqe) +
> +			sizeof(struct mlx5_ib_uapi_devx_async_event_hdr);
> +		event_data =3D &event->hdr;
> +	}
> +
> +	if (eventsz > count) {
> +		spin_unlock_irq(&ev_queue->lock);
> +		return -ENOSPC;

This is probably the wrong errno

> +	}
> +
> +	if (omit_data)
> +		list_del_init(&event_sub->event_list);
> +	else
> +		list_del(&event->list);
> +
> +	spin_unlock_irq(&ev_queue->lock);
> +
> +	if (copy_to_user(buf, event_data, eventsz))
> +		ret =3D -EFAULT;
> +	else
> +		ret =3D eventsz;

This is really poorly ordered, EFAULT will cause the event to be lost. :(

Maybe the event should be re-added on error? Tricky.

> +	if (!omit_data)
> +		kfree(event);
> +	return ret;
>  }
> =20
>  static __poll_t devx_async_event_poll(struct file *filp,
>  				      struct poll_table_struct *wait)
>  {
> -	return 0;
> +	struct devx_async_event_file *ev_file =3D filp->private_data;
> +	struct devx_async_event_queue *ev_queue =3D &ev_file->ev_queue;
> +	__poll_t pollflags =3D 0;
> +
> +	poll_wait(filp, &ev_queue->poll_wait, wait);
> +
> +	spin_lock_irq(&ev_queue->lock);
> +	if (ev_queue->is_destroyed)
> +		pollflags =3D EPOLLIN | EPOLLRDNORM | EPOLLRDHUP;
> +	else if (!list_empty(&ev_queue->event_list))
> +		pollflags =3D EPOLLIN | EPOLLRDNORM;
> +	spin_unlock_irq(&ev_queue->lock);
> +
> +	return pollflags;
>  }
> =20
>  static int devx_async_event_close(struct inode *inode, struct file *filp=
)
>  {
> +	struct ib_uobject *uobj =3D filp->private_data;
> +	struct devx_async_event_file *ev_file =3D
> +		container_of(uobj, struct devx_async_event_file, uobj);
> +	struct devx_event_subscription *event_sub, *event_sub_tmp;
> +	struct devx_async_event_data *entry, *tmp;
> +
> +	mutex_lock(&ev_file->dev->devx_event_table.event_xa_lock);
> +	/* delete the subscriptions which are related to this FD */
> +	list_for_each_entry_safe(event_sub, event_sub_tmp,
> +				 &ev_file->subscribed_events_list, file_list)
> +		devx_cleanup_subscription(ev_file->dev, event_sub, true);
> +	mutex_unlock(&ev_file->dev->devx_event_table.event_xa_lock);
> +
> +	/* free the pending events allocation */
> +	if (!(ev_file->ev_queue.flags &
> +	    MLX5_IB_UAPI_DEVX_CREATE_EVENT_CHANNEL_FLAGS_OMIT_EV_DATA)) {
> +		spin_lock_irq(&ev_file->ev_queue.lock);
> +		list_for_each_entry_safe(entry, tmp,
> +					 &ev_file->ev_queue.event_list, list)
> +			kfree(entry); /* read can't come any nore */

spelling

> +		spin_unlock_irq(&ev_file->ev_queue.lock);
> +	}
>  	uverbs_close_fd(filp);
> +	put_device(&ev_file->dev->ib_dev.dev);
>  	return 0;
>  }
> =20
> @@ -2374,6 +2705,17 @@ static int devx_hot_unplug_async_cmd_event_file(st=
ruct ib_uobject *uobj,
>  static int devx_hot_unplug_async_event_file(struct ib_uobject *uobj,
>  					    enum rdma_remove_reason why)
>  {
> +	struct devx_async_event_file *ev_file =3D
> +		container_of(uobj, struct devx_async_event_file,
> +			     uobj);
> +	struct devx_async_event_queue *ev_queue =3D &ev_file->ev_queue;
> +
> +	spin_lock_irq(&ev_queue->lock);
> +	ev_queue->is_destroyed =3D 1;
> +	spin_unlock_irq(&ev_queue->lock);
> +
> +	if (why =3D=3D RDMA_REMOVE_DRIVER_REMOVE)
> +		wake_up_interruptible(&ev_queue->poll_wait);

Why isn't this wakeup always done?

Jason
