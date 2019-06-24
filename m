Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 851F851826
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 18:13:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731755AbfFXQNW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 12:13:22 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:53046 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731751AbfFXQNW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 12:13:22 -0400
Received: by mail-wm1-f67.google.com with SMTP id s3so13374036wms.2
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 09:13:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dev-mellanox-co-il.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2zvd7r5CzWo0aFxwDAgGiowuVQ1kQKzm2sv+yq7HKwU=;
        b=t2qf9CYwOsn5adoA1PaMbT2Nr+f0bTPoHso7DgQcuR+6kYNLRsV0MguxtVCQr2onxt
         hI1bEVvxqIsZHhHCFSKhD/vPu/0RQeotFDVyXkTpNzb6+tLpSW2nSVkTYeVRlhoe7Y3u
         HfRrnLT3HzyYJ7CRN4tGMWbo4+tFsHhbhUvrPSZvgblcPpdC/gRH+r5uxZkEBqudNpps
         SWpfNycawtfjo3R8+X//P1N1/P2Ne54v3FHwSz9RGRcU+/L2wPO/LjWGJ8IRHbKLo3hZ
         72fDqKmV89JL8kPh/1gOvPtobR74xuaAVG5biqSuE9QHZt3iycGp5zu0gDGHjaRx6sYh
         yV9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2zvd7r5CzWo0aFxwDAgGiowuVQ1kQKzm2sv+yq7HKwU=;
        b=pc+jNyGZ9iOHJiPz9UYtutQuGjB9ThH0ML8+sOUvd+Yzc2Pwu2+7NoXJ4bxp9YE2lz
         gv9CzdJuBwa+tUPRpreTpIo+veD+iOExx6PiRzpANvOb4bURTnGG2Toocun06I1LZlBS
         wSSPwF0S+ndrk4tIsDILrAbLR9VPsKn93AhMkNeKnwGqPJIwBXMSDhjLJ3nL1+jE3Hq/
         GI9rnjqQ/8ZBvkt8QuVlFyhE2ykYTH+acyyyiL8U6LPUcTnDrotL0RQfS/HJF5nTswhN
         2FOwNQ2eEnXqb678yeQQnlcFJBTHtJIzZEatAb7NswYLZfxrJka5Df4UtgnKpUQ1Yp+S
         fRSA==
X-Gm-Message-State: APjAAAUVADoEPAyG8AsEBU9z6L4TOdQirYnoQYAnAmVamZWYTE2uFUun
        NC4KirHMtGo2Y3zHiiT/j0EnalxPJ9k=
X-Google-Smtp-Source: APXvYqw1UZe8pl1mQ5of2rqDIIPfSrblzjlNqzISqHs3jd/ui2Bg0noMpBbQY3t+5GOAIQuHeAszcw==
X-Received: by 2002:a1c:9ecd:: with SMTP id h196mr17192746wme.98.1561392798639;
        Mon, 24 Jun 2019 09:13:18 -0700 (PDT)
Received: from [10.8.2.125] ([193.47.165.251])
        by smtp.googlemail.com with ESMTPSA id n14sm25512653wra.75.2019.06.24.09.13.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Jun 2019 09:13:18 -0700 (PDT)
Subject: Re: [PATCH rdma-next v1 10/12] IB/mlx5: Enable subscription for
 device events over DEVX
To:     Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Yishai Hadas <yishaih@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
References: <20190618171540.11729-1-leon@kernel.org>
 <20190618171540.11729-11-leon@kernel.org>
 <20190624115726.GC5479@mellanox.com>
From:   Yishai Hadas <yishaih@dev.mellanox.co.il>
Message-ID: <33f9402b-ccae-b874-cc72-b6afb1fb8655@dev.mellanox.co.il>
Date:   Mon, 24 Jun 2019 19:13:14 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190624115726.GC5479@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/24/2019 2:57 PM, Jason Gunthorpe wrote:
> On Tue, Jun 18, 2019 at 08:15:38PM +0300, Leon Romanovsky wrote:
>> From: Yishai Hadas <yishaih@mellanox.com>
>>
>> Enable subscription for device events over DEVX.
>>
>> Each subscription is added to the two level XA data structure according
>> to its event number and the DEVX object information in case was given
>> with the given target fd.
>>
>> Those events will be reported over the given fd once will occur.
>> Downstream patches will mange the dispatching to any subscription.
>>
>> Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
>> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
>>   drivers/infiniband/hw/mlx5/devx.c        | 564 ++++++++++++++++++++++-
>>   include/uapi/rdma/mlx5_user_ioctl_cmds.h |   9 +
>>   2 files changed, 566 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/mlx5/devx.c
>> index e9b9ba5a3e9a..304b13e7a265 100644
>> +++ b/drivers/infiniband/hw/mlx5/devx.c
>> @@ -14,6 +14,7 @@
>>   #include <linux/mlx5/driver.h>
>>   #include <linux/mlx5/fs.h>
>>   #include "mlx5_ib.h"
>> +#include <linux/xarray.h>
>>   
>>   #define UVERBS_MODULE_NAME mlx5_ib
>>   #include <rdma/uverbs_named_ioctl.h>
>> @@ -33,6 +34,37 @@ struct devx_async_data {
>>   	struct mlx5_ib_uapi_devx_async_cmd_hdr hdr;
>>   };
>>   
>> +/* first level XA value data structure */
>> +struct devx_event {
>> +	struct xarray object_ids; /* second XA level, Key = object id */
>> +	struct list_head unaffiliated_list;
>> +};
>> +
>> +/* second level XA value data structure */
>> +struct devx_obj_event {
>> +	struct rcu_head rcu;
>> +	struct list_head obj_sub_list;
>> +};
>> +
>> +struct devx_event_subscription {
>> +	struct list_head file_list; /* headed in private_data->
>> +				     * subscribed_events_list
>> +				     */
>> +	struct list_head xa_list; /* headed in devx_event->unaffiliated_list or
>> +				   * devx_obj_event->obj_sub_list
>> +				   */
>> +	struct list_head obj_list; /* headed in devx_object */
>> +
>> +	u32 xa_key_level1;
>> +	u32 xa_key_level2;
>> +	struct rcu_head	rcu;
>> +	u64 cookie;
>> +	bool is_obj_related;
>> +	struct ib_uobject *fd_uobj;
>> +	void *object;	/* May need direct access upon hot unplug */
> 
> This should be a 'struct file *' and have a better name.
> 

OK, will change.

> And I'm unclear why we need to store both the ib_uobject and the
> struct file for the same thing? 

Post hot unplug/unbind the uobj can't be accessed any more to reach the 
object as it will be set to NULL by ib_core layer [1].
As the filp is still open we need a direct access to it down the road 
and for that we have it separately.

This was the comment that I have just put above in the code, I may 
improve it with more details as pointed here.

[1]
https://elixir.bootlin.com/linux/latest/source/drivers/infiniband/core/rdma_core.c#L149

And why are we storing the uobj here
> instead of the struct devx_async_event_file *?
> 

Basically storing the uobj is the same as of storing the 
devx_async_event_file, as we just use container_of to get it from.
There is no direct access from uobj to any of its fields so that we 
should be fine.

> Since uobj->object == flip && filp->private_data == uobj, I have a
> hard time to understand why we need both things, it seems to me that
> if we get the fget on the filp then we can rely on the
> filp->private_data to get back to the devx_async_event_file.
> 

The idea was to not take an extra ref count on the file (i.e. fget) per 
subscription, this will let the release option to be called once the 
file will be closed by the application.
Otherwise we might need to consider having some unsubscribe method to 
put the ref count back with all its overhead and implications without a 
real justified reason.


>> +	struct eventfd_ctx *eventfd;
>> +};
>> +
> 
>>   /*
>>    * As the obj_id in the firmware is not globally unique the object type
>>    * must be considered upon checking for a valid object id.
>> @@ -1143,14 +1275,53 @@ static void devx_cleanup_mkey(struct devx_obj *obj)
>>   	write_unlock_irqrestore(&table->lock, flags);
>>   }
>>   
>> +static void devx_cleanup_subscription(struct mlx5_ib_dev *dev,
>> +				      struct devx_event_subscription *sub)
>> +{
>> +	list_del_rcu(&sub->file_list);
>> +	list_del_rcu(&sub->xa_list);
>> +
>> +	if (sub->is_obj_related) {
> 
> is_obj_related looks like it is just list_empty(obj_list)??
>


Yes, in that approach we may need to call INIT_LIST_HEAD(sub->obj_list) 
in case it wasn't an object upon subscription, will do that.

> Success oriented flow
> 
>> @@ -1523,6 +1700,350 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_ASYNC_QUERY)(
>>   	return err;
>>   }
>>   
>> +static void
>> +subscribe_event_xa_dealloc(struct mlx5_devx_event_table *devx_event_table,
>> +			   u32 key_level1,
>> +			   u32 key_level2,
>> +			   struct devx_obj_event *alloc_obj_event)
>> +{
>> +	struct devx_event *event;
>> +
>> +	/* Level 1 is valid for future use - no need to free */
>> +	if (!alloc_obj_event)
>> +		return;
>> +
>> +	event = xa_load(&devx_event_table->event_xa, key_level1);
>> +	WARN_ON(!event);
>> +
>> +	xa_erase(&event->object_ids, key_level2);
> 
> Shoulnd't this only erase if the value stored is NULL?
> 

If this key_level2 wasn't allocated by the subscribe flow and exists 
before we may not reach here and return from the above lines in this 
function [1], otherwise we need to erase as done here.

[1]
if (!alloc_obj_event)
	return;

>> +	kfree(alloc_obj_event);
>> +}
>> +
>> +static int
>> +subscribe_event_xa_alloc(struct mlx5_devx_event_table *devx_event_table,
>> +			 u32 key_level1,
>> +			 bool is_level2,
>> +			 u32 key_level2,
>> +			 struct devx_obj_event **alloc_obj_event)
>> +{
>> +	struct devx_obj_event *obj_event;
>> +	struct devx_event *event;
>> +	bool new_entry_level1 = false;
>> +	int err;
>> +
>> +	event = xa_load(&devx_event_table->event_xa, key_level1);
>> +	if (!event) {
>> +		event = kzalloc(sizeof(*event), GFP_KERNEL);
>> +		if (!event)
>> +			return -ENOMEM;
>> +
>> +		new_entry_level1 = true;
>> +		INIT_LIST_HEAD(&event->unaffiliated_list);
>> +		xa_init(&event->object_ids);
>> +
>> +		err = xa_insert(&devx_event_table->event_xa,
>> +				key_level1,
>> +				event,
>> +				GFP_KERNEL);
>> +		if (err)
>> +			goto end;
>> +	}
>> +
>> +	if (!is_level2)
>> +		return 0;
>> +
>> +	obj_event = xa_load(&event->object_ids, key_level2);
>> +	if (!obj_event) {
>> +		err = xa_reserve(&event->object_ids, key_level2, GFP_KERNEL);
>> +		if (err)
>> +			goto err_level1;
>> +
>> +		obj_event = kzalloc(sizeof(*obj_event), GFP_KERNEL);
>> +		if (!obj_event) {
>> +			err = -ENOMEM;
>> +			goto err_level2;
>> +		}
>> +
>> +		INIT_LIST_HEAD(&obj_event->obj_sub_list);
>> +		*alloc_obj_event = obj_event;
> 
> This is goofy, just store the empty obj_event in the xa instead of
> using xa_reserve, and when you go to do the error unwind just delete
> any level2' devx_obj_event' that has a list_empty(obj_sub_list), get
> rid of the wonky alloc_obj_event stuff.
> 

Please see my answer above about how level2 is managed by this 
alloc_obj_event, is that really worth a change ? I found current logic 
to be clear. I may put some note here if we can stay with that.

> The best configuration would be to use devx_cleanup_subscription to
> undo the partially ready subscription.
> 

This partially ready subscription might not match the 
devx_cleanup_subscription(), e.g. it wasn't added to xa_list and can't 
be deleted without any specific flag to ignore ..


>> +	}
>> +
>> +	return 0;
>> +
>> +err_level2:
>> +	xa_erase(&event->object_ids, key_level2);
>> +
>> +err_level1:
>> +	if (new_entry_level1)
>> +		xa_erase(&devx_event_table->event_xa, key_level1);
>> +end:
>> +	if (new_entry_level1)
>> +		kfree(event);
> 
> Can't do this, once the level1 is put in the tree it could be referenced by
> the irqs. At least it needs a kfree_rcu, most likely it is simpler to
> just leave it.
> 

Agree, it looks simpler just to leave it, will handle.

>> +#define MAX_NUM_EVENTS 16
>> +static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_SUBSCRIBE_EVENT)(
>> +	struct uverbs_attr_bundle *attrs)
>> +{
>> +	struct ib_uobject *devx_uobj = uverbs_attr_get_uobject(
>> +				attrs,
>> +				MLX5_IB_ATTR_DEVX_SUBSCRIBE_EVENT_OBJ_HANDLE);
>> +	struct mlx5_ib_ucontext *c = rdma_udata_to_drv_context(
>> +		&attrs->driver_udata, struct mlx5_ib_ucontext, ibucontext);
>> +	struct mlx5_ib_dev *dev = to_mdev(c->ibucontext.device);
>> +	struct ib_uobject *fd_uobj;
>> +	struct devx_obj *obj = NULL;
>> +	struct devx_async_event_file *ev_file;
>> +	struct mlx5_devx_event_table *devx_event_table = &dev->devx_event_table;
>> +	u16 *event_type_num_list;
>> +	struct devx_event_subscription **event_sub_arr;
>> +	struct devx_obj_event  **event_obj_array_alloc;
>> +	int redirect_fd;
>> +	bool use_eventfd = false;
>> +	int num_events;
>> +	int num_alloc_xa_entries = 0;
>> +	u16 obj_type = 0;
>> +	u64 cookie = 0;
>> +	u32 obj_id = 0;
>> +	int err;
>> +	int i;
>> +
>> +	if (!c->devx_uid)
>> +		return -EINVAL;
>> +
>> +	if (!IS_ERR(devx_uobj)) {
>> +		obj = (struct devx_obj *)devx_uobj->object;
>> +		if (obj)
>> +			obj_id = get_dec_obj_id(obj->obj_id);
>> +	}
>> +
>> +	fd_uobj = uverbs_attr_get_uobject(attrs,
>> +				MLX5_IB_ATTR_DEVX_SUBSCRIBE_EVENT_FD_HANDLE);
>> +	if (IS_ERR(fd_uobj))
>> +		return PTR_ERR(fd_uobj);
>> +
>> +	ev_file = container_of(fd_uobj, struct devx_async_event_file,
>> +			       uobj);
>> +
>> +	if (uverbs_attr_is_valid(attrs,
>> +				 MLX5_IB_ATTR_DEVX_SUBSCRIBE_EVENT_FD_NUM)) {
>> +		err = uverbs_copy_from(&redirect_fd, attrs,
>> +			       MLX5_IB_ATTR_DEVX_SUBSCRIBE_EVENT_FD_NUM);
>> +		if (err)
>> +			return err;
>> +
>> +		use_eventfd = true;
>> +	}
>> +
>> +	if (uverbs_attr_is_valid(attrs,
>> +				 MLX5_IB_ATTR_DEVX_SUBSCRIBE_EVENT_COOKIE)) {
>> +		if (use_eventfd)
>> +			return -EINVAL;
>> +
>> +		err = uverbs_copy_from(&cookie, attrs,
>> +				MLX5_IB_ATTR_DEVX_SUBSCRIBE_EVENT_COOKIE);
>> +		if (err)
>> +			return err;
>> +	}
>> +
>> +	num_events = uverbs_attr_ptr_get_array_size(
>> +		attrs, MLX5_IB_ATTR_DEVX_SUBSCRIBE_EVENT_TYPE_NUM_LIST,
>> +		sizeof(u16));
>> +
>> +	if (num_events < 0)
>> +		return num_events;
>> +
>> +	if (num_events > MAX_NUM_EVENTS)
>> +		return -EINVAL;
>> +
>> +	event_type_num_list = uverbs_attr_get_alloced_ptr(attrs,
>> +			MLX5_IB_ATTR_DEVX_SUBSCRIBE_EVENT_TYPE_NUM_LIST);
>> +
>> +	if (!is_valid_events(dev->mdev, num_events, event_type_num_list, obj))
>> +		return -EINVAL;
>> +
>> +	event_sub_arr = uverbs_zalloc(attrs,
>> +		MAX_NUM_EVENTS * sizeof(struct devx_event_subscription *));
>> +	event_obj_array_alloc = uverbs_zalloc(attrs,
>> +		MAX_NUM_EVENTS * sizeof(struct devx_obj_event *));
> 
> There are so many list_heads in the devx_event_subscription, why not
> use just one of them to store the allocated events instead of this
> temp array? ie event_list looks good for this purpose.
> 

I'm using the array later on with direct access to the index that should 
be de-allocated. I would prefer staying with this array rather than 
using the 'event_list' which has other purpose down the road, it's used 
per subscription and doesn't look match to hold the devx_obj_event which 
has no list entry for this purpose..

>> +
>> +	if (!event_sub_arr || !event_obj_array_alloc)
>> +		return -ENOMEM;
>> +
>> +	/* Protect from concurrent subscriptions to same XA entries to allow
>> +	 * both to succeed
>> +	 */
>> +	mutex_lock(&devx_event_table->event_xa_lock);
>> +	for (i = 0; i < num_events; i++) {
>> +		u32 key_level1;
>> +
>> +		if (obj)
>> +			obj_type = get_dec_obj_type(obj,
>> +						    event_type_num_list[i]);
>> +		key_level1 = event_type_num_list[i] | obj_type << 16;
>> +
>> +		err = subscribe_event_xa_alloc(devx_event_table,
>> +					       key_level1,
>> +					       obj ? true : false,
>> +					       obj_id,
>> +					       &event_obj_array_alloc[i]);
> 
> Usless ?:

What do you suggest instead ?

> 
>> +		if (err)
>> +			goto err;
>> +
>> +		num_alloc_xa_entries++;
>> +		event_sub_arr[i] = kzalloc(sizeof(*event_sub_arr[i]),
>> +					   GFP_KERNEL);
>> +		if (!event_sub_arr[i])
>> +			goto err;
>> +
>> +		if (use_eventfd) {
>> +			event_sub_arr[i]->eventfd =
>> +				eventfd_ctx_fdget(redirect_fd);
>> +
>> +			if (IS_ERR(event_sub_arr[i]->eventfd)) {
>> +				err = PTR_ERR(event_sub_arr[i]->eventfd);
>> +				event_sub_arr[i]->eventfd = NULL;
>> +				goto err;
>> +			}
>> +		}
>> +
>> +		event_sub_arr[i]->cookie = cookie;
>> +		event_sub_arr[i]->fd_uobj = fd_uobj;
>> +		event_sub_arr[i]->object = fd_uobj->object;
>> +		/* May be needed upon cleanup the devx object/subscription */
>> +		event_sub_arr[i]->xa_key_level1 = key_level1;
>> +		event_sub_arr[i]->xa_key_level2 = obj_id;
>> +		event_sub_arr[i]->is_obj_related = obj ? true : false;
> 


