Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F2E655247
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 16:42:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731501AbfFYOly (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 10:41:54 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:34559 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731366AbfFYOly (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 10:41:54 -0400
Received: by mail-wm1-f68.google.com with SMTP id w9so2451489wmd.1
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 07:41:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dev-mellanox-co-il.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=n0d0Ae+gSGnxl88/UU21Zsil+h14+9dBRPmEv3CyqL0=;
        b=LhAgCPctl/m5O0Vc6d9e/xtYSilZmhLLaeFYpVW74acBkRtSLVHY3p9GXOw6caEKMd
         mtDqDZSk15+RBC7LCOCk1QuDcKkjMiY7+B+QRoW1nJbaueAhUxON7WWy/VXfklns0ywd
         pkSGLa82+sBKdbaRZGTuea84+l70xCweV6i3TK9HvPNsCyj+7pLS1zWnE3lSFW+fHtvk
         SOsn8s6le8K2hrVQ+aP4l0v4Bpap8pQERb4ZUOs69RO2Zp0VS6bb+Da8pBaU0rW5bume
         t9Z/TXHBa6fB4G1MJ7aytDteFxnohuW/rQCvRheYjWAWB0R9IclRzm2OCPQksG3N7iAY
         Jl+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=n0d0Ae+gSGnxl88/UU21Zsil+h14+9dBRPmEv3CyqL0=;
        b=pmDgVdszjIAswqG3RH8mIUF1yJJ5eC6EOTel1jo+lpG/rb/fRWrZHewmOpWjZSI9Gl
         lHzd7D1uJHqtaC1CzHd5lAXLwhzUTSeDVSmnM5F/ysGyyhK0hsT6g36HP35oHTwstS0g
         CX8DC97OSVjxaDxx7ALF+KTvAbZUBro9o8piz5utOfqcu0e9EaCPB7iglozmh/NyRqdg
         t6BISskgNsj+EhIPMFNT8lMWCM1CdZ7Viw55rCY/oY54kzYmruPdApOB2Sapd1hXpMMm
         LKyV2DJyEM6IoYL3ICqkJx6DFEBvPU2yMOhcFC2hUPFUovCUP29AMZVVTZSErtXcKENh
         FFlA==
X-Gm-Message-State: APjAAAVVrbGPL63gWWVP0IUhGPiBTG9AxzS20mFwXqZogrP7rkxnstIS
        O/zO221VVqrqso58+B0o+EcdI4VDml4=
X-Google-Smtp-Source: APXvYqzErTbZkrZpCWohh9Nh6olaNAg1q/fowQr7ZYvw8rVdlN/W9IRu6pU5+0j7ltBB7Hai6tiQyg==
X-Received: by 2002:a05:600c:1008:: with SMTP id c8mr20641579wmc.133.1561473711671;
        Tue, 25 Jun 2019 07:41:51 -0700 (PDT)
Received: from [10.8.2.125] ([193.47.165.251])
        by smtp.googlemail.com with ESMTPSA id a7sm14889670wrs.94.2019.06.25.07.41.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Jun 2019 07:41:51 -0700 (PDT)
Subject: Re: [PATCH rdma-next v1 11/12] IB/mlx5: Implement DEVX dispatching
 event
To:     Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Yishai Hadas <yishaih@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
References: <20190618171540.11729-1-leon@kernel.org>
 <20190618171540.11729-12-leon@kernel.org>
 <20190624120338.GD5479@mellanox.com>
 <3a2e53f8-e7dd-3e01-c7c7-99d41f711d87@dev.mellanox.co.il>
 <20190624180558.GL7418@mellanox.com>
From:   Yishai Hadas <yishaih@dev.mellanox.co.il>
Message-ID: <a2380ea6-4542-c72c-96f7-e68786847ccc@dev.mellanox.co.il>
Date:   Tue, 25 Jun 2019 17:41:49 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190624180558.GL7418@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/24/2019 9:06 PM, Jason Gunthorpe wrote:
> On Mon, Jun 24, 2019 at 07:55:32PM +0300, Yishai Hadas wrote:
> 
>>>> +	/* Explicit filtering to kernel events which may occur frequently */
>>>> +	if (event_type == MLX5_EVENT_TYPE_CMD ||
>>>> +	    event_type == MLX5_EVENT_TYPE_PAGE_REQUEST)
>>>> +		return NOTIFY_OK;
>>>> +
>>>> +	table = container_of(nb, struct mlx5_devx_event_table, devx_nb.nb);
>>>> +	dev = container_of(table, struct mlx5_ib_dev, devx_event_table);
>>>> +	is_unaffiliated = is_unaffiliated_event(dev->mdev, event_type);
>>>> +
>>>> +	if (!is_unaffiliated)
>>>> +		obj_type = get_event_obj_type(event_type, data);
>>>> +	event = xa_load(&table->event_xa, event_type | (obj_type << 16));
>>>> +	if (!event)
>>>> +		return NOTIFY_DONE;
>>>
>>> event should be in the rcu as well
>>
>> Do we really need this ? I didn't see a flow that really requires
>> that.
> 
> I think there are no frees left? Even so it makes much more sense to
> include the event in the rcu as if we ever did need to kfree it would
> have to be via rcu
> 

OK

>>>> +	while (list_empty(&ev_queue->event_list)) {
>>>> +		spin_unlock_irq(&ev_queue->lock);
>>>> +
>>>> +		if (filp->f_flags & O_NONBLOCK)
>>>> +			return -EAGAIN;
>>>> +
>>>> +		if (wait_event_interruptible(ev_queue->poll_wait,
>>>> +			    (!list_empty(&ev_queue->event_list) ||
>>>> +			     ev_queue->is_destroyed))) {
>>>> +			return -ERESTARTSYS;
>>>> +		}
>>>> +
>>>> +		if (list_empty(&ev_queue->event_list) &&
>>>> +		    ev_queue->is_destroyed)
>>>> +			return -EIO;
>>>
>>> All these tests should be under the lock.
>>
>> We can't call wait_event_interruptible() above which may sleep under the
>> lock, correct ? are you referring to the list_empty() and
>> is_destroyed ?
> 
> yes
> 
>> By the way looking in uverb code [1], similar code which is not done under
>> the lock as of here..
>>
>> [1] https://elixir.bootlin.com/linux/latest/source/drivers/infiniband/core/uverbs_main.c#L244
> 
> Also not a good idea
> 
>>> Why don't we return EIO as soon as is-destroyed happens? What is the
>>> point of flushing out the accumulated events?
>>
>> It follows the above uverb code/logic that returns existing events even in
>> that case, also the async command events in this file follows that logic, I
>> suggest to stay consistent.
> 
> Don't follow broken uverbs stuff...

May it be that there is some event that we still want to deliver post 
unbind/hot-unplug ? for example IB_EVENT_DEVICE_FATAL in uverbs and 
others from the driver code.

Not sure that we want to change this logic.
What do you think ?

> 
>>> Maybe the event should be re-added on error? Tricky.
>>
>> What will happen if another copy_to_user may then fail again (loop ?) ...
>> not sure that we want to get into this tricky handling ...
>>
>> As of above, It follows the logic from uverbs at that area.
>> https://elixir.bootlin.com/linux/latest/source/drivers/infiniband/core/uverbs_main.c#L267
> 
> again it is wrong...
> 
> There is no loop if you just stick the item back on the head of the
> list and exit, which is probably the right thing to do..
> 

What if copy_to_user() will fail again just later on ? we might end-up 
with loop of read(s) that always find an event as it was put back.
I suggest to leave this flow as it's now, at least for this series 
submission.

Agree ?


>>>> @@ -2374,6 +2705,17 @@ static int devx_hot_unplug_async_cmd_event_file(struct ib_uobject *uobj,
>>>>    static int devx_hot_unplug_async_event_file(struct ib_uobject *uobj,
>>>>    					    enum rdma_remove_reason why)
>>>>    {
>>>> +	struct devx_async_event_file *ev_file =
>>>> +		container_of(uobj, struct devx_async_event_file,
>>>> +			     uobj);
>>>> +	struct devx_async_event_queue *ev_queue = &ev_file->ev_queue;
>>>> +
>>>> +	spin_lock_irq(&ev_queue->lock);
>>>> +	ev_queue->is_destroyed = 1;
>>>> +	spin_unlock_irq(&ev_queue->lock);
>>>> +
>>>> +	if (why == RDMA_REMOVE_DRIVER_REMOVE)
>>>> +		wake_up_interruptible(&ev_queue->poll_wait);
>>>
>>> Why isn't this wakeup always done?
>>
>> Maybe you are right and this can be always done to wake up any readers as
>> the 'is_destroyed' was set.
>>
>> By the way, any idea why it was done as such in uverbs [1] for similar flow
>> ? also the command events follows that.
> 
> I don't know, it is probably pointless too.
> 
> If we don't need it here then we shouldn't have it.
> 
> These random pointless ifs bother me as we have to spend time trying
> to figure out that they are pointless down the road.
> 

OK, will drop this if.

