Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED7AF67E8AD
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 15:54:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234023AbjA0Oy3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 09:54:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230244AbjA0Oy0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 09:54:26 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 373A547EF9
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 06:53:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674831214;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=O4CJ3o8SwPvw9JAPwWMxi0hbq7glhKayvo3+sTVOOds=;
        b=OVLgBL1YZt/li06R1tL6+OiIzXmk15ZeeKD+9SXBHahN2zrG8z2AyIXAwUGZhSsK8YSKnK
        8aGpBhnlLUiRtYc1oWwXqNx6zReYqlnrN29Jphx1+UOw6LSPRIuX2Wa3ZlwS8OqiaowXVe
        6ux3OxHsZqx+A61Iw1+n796K98v85qE=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-74-UDYYKke7NYifEDlLcfV3Kw-1; Fri, 27 Jan 2023 09:53:29 -0500
X-MC-Unique: UDYYKke7NYifEDlLcfV3Kw-1
Received: by mail-ej1-f70.google.com with SMTP id jg2-20020a170907970200b0086ee94381fbso3544666ejc.2
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 06:53:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O4CJ3o8SwPvw9JAPwWMxi0hbq7glhKayvo3+sTVOOds=;
        b=OjEbavg7xb8fnavhe4mqx+1+FvuBX9Y0WNcM9h8WjgbWmTUfHnNME0fI8nY6/IVB6B
         U4HM15TDWeUrch1TNfF9S4dcfRqbh5eDfwRg4dLLmD/jjRkMWyAxx0nwh4sGPoM9jfjs
         iP8RlaKrezVSUOWJyv+FubhwL9yRm10O7B6jG0EArIihvNQfAssWS4qaJu68Xiowc44y
         UN1nDEhGF828bx+9RoEmAfD/ePE6w2mmE8NU89/AVqSs6gc/oU72BnUNwDSQDxYO/pUh
         NOSOMlaycQdGE8IuA/AoWRhxJmaVjBJJ1snNc7F2oenargXpC209EDTYc1qr+2TKKzLQ
         LJ1A==
X-Gm-Message-State: AFqh2kpl81LCLoRGyCjc+VCwCpOlfJAccbsOz8hEijZQG20qXxcQW9+A
        EJ16k64sfJWVUIJiKNyjZ5HJTvL7RCj/DQWP+DdbFDSKh9o7vatTyPdzkX0TwCrWuIfs0Ejz4WX
        lfUxLVkBa0LRaQJ6X
X-Received: by 2002:a17:907:2910:b0:86f:9fb1:307b with SMTP id eq16-20020a170907291000b0086f9fb1307bmr36437574ejc.31.1674831207486;
        Fri, 27 Jan 2023 06:53:27 -0800 (PST)
X-Google-Smtp-Source: AMrXdXs3lmUJfXCsL0vxaEyFuB+wjhQkLdYV/HlYTb++NiWJcPsVBn8ESe4mgXBk9E1XlSzlDrVsNg==
X-Received: by 2002:a17:907:2910:b0:86f:9fb1:307b with SMTP id eq16-20020a170907291000b0086f9fb1307bmr36437560ejc.31.1674831207200;
        Fri, 27 Jan 2023 06:53:27 -0800 (PST)
Received: from redhat.com ([2.52.137.69])
        by smtp.gmail.com with ESMTPSA id 9-20020a170906200900b0087848a5daf5sm2308443ejo.225.2023.01.27.06.53.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jan 2023 06:53:26 -0800 (PST)
Date:   Fri, 27 Jan 2023 09:53:22 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Laurent Vivier <lvivier@redhat.com>
Cc:     linux-kernel@vger.kernel.org,
        Gautam Dawar <gautam.dawar@xilinx.com>,
        Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
        netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Eli Cohen <elic@nvidia.com>, Cindy Lu <lulu@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Parav Pandit <parav@nvidia.com>
Subject: Re: [PATCH v2 1/1] virtio_net: notify MAC address change on device
 initialization
Message-ID: <20230127095125-mutt-send-email-mst@kernel.org>
References: <20230123120022.2364889-1-lvivier@redhat.com>
 <20230123120022.2364889-2-lvivier@redhat.com>
 <20230124024711-mutt-send-email-mst@kernel.org>
 <971beeaf-5e68-eb4a-1ceb-63a5ffa74aff@redhat.com>
 <20230127060453-mutt-send-email-mst@kernel.org>
 <5d82047d-411b-a98d-ce0e-1195838db42c@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d82047d-411b-a98d-ce0e-1195838db42c@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 27, 2023 at 01:28:01PM +0100, Laurent Vivier wrote:
> On 1/27/23 12:08, Michael S. Tsirkin wrote:
> > On Tue, Jan 24, 2023 at 12:04:24PM +0100, Laurent Vivier wrote:
> > > On 1/24/23 11:15, Michael S. Tsirkin wrote:
> > > > On Mon, Jan 23, 2023 at 01:00:22PM +0100, Laurent Vivier wrote:
> > > > > In virtnet_probe(), if the device doesn't provide a MAC address the
> > > > > driver assigns a random one.
> > > > > As we modify the MAC address we need to notify the device to allow it
> > > > > to update all the related information.
> > > > > 
> > > > > The problem can be seen with vDPA and mlx5_vdpa driver as it doesn't
> > > > > assign a MAC address by default. The virtio_net device uses a random
> > > > > MAC address (we can see it with "ip link"), but we can't ping a net
> > > > > namespace from another one using the virtio-vdpa device because the
> > > > > new MAC address has not been provided to the hardware.
> > > > 
> > > > And then what exactly happens? Does hardware drop the outgoing
> > > > or the incoming packets? Pls include in the commit log.
> > > 
> > > I don't know. There is nothing in the kernel logs.
> > > 
> > > The ping error is: "Destination Host Unreachable"
> > > 
> > > I found the problem with the mlx5 driver as in "it doesn't work when MAC
> > > address is not set"...
> > > 
> > > Perhaps Eli can explain what happens when the MAC address is not set?
> > > 
> > > > 
> > > > > Signed-off-by: Laurent Vivier <lvivier@redhat.com>
> > > > > ---
> > > > >    drivers/net/virtio_net.c | 14 ++++++++++++++
> > > > >    1 file changed, 14 insertions(+)
> > > > > 
> > > > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > > > index 7723b2a49d8e..4bdc8286678b 100644
> > > > > --- a/drivers/net/virtio_net.c
> > > > > +++ b/drivers/net/virtio_net.c
> > > > > @@ -3800,6 +3800,8 @@ static int virtnet_probe(struct virtio_device *vdev)
> > > > >    		eth_hw_addr_set(dev, addr);
> > > > >    	} else {
> > > > >    		eth_hw_addr_random(dev);
> > > > > +		dev_info(&vdev->dev, "Assigned random MAC address %pM\n",
> > > > > +			 dev->dev_addr);
> > > > >    	}
> > > > >    	/* Set up our device-specific information */
> > > > > @@ -3956,6 +3958,18 @@ static int virtnet_probe(struct virtio_device *vdev)
> > > > >    	pr_debug("virtnet: registered device %s with %d RX and TX vq's\n",
> > > > >    		 dev->name, max_queue_pairs);
> > > > > +	/* a random MAC address has been assigned, notify the device */
> > > > > +	if (!virtio_has_feature(vdev, VIRTIO_NET_F_MAC) &&
> > > > > +	    virtio_has_feature(vi->vdev, VIRTIO_NET_F_CTRL_MAC_ADDR)) {
> > > > 
> > > > Maybe add a comment explaining that we don't fail probe if
> > > > VIRTIO_NET_F_CTRL_MAC_ADDR is not there because
> > > > many devices work fine without getting MAC explicitly.
> > > 
> > > OK
> > > 
> > > > 
> > > > > +		struct scatterlist sg;
> > > > > +
> > > > > +		sg_init_one(&sg, dev->dev_addr, dev->addr_len);
> > > > > +		if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_MAC,
> > > > > +					  VIRTIO_NET_CTRL_MAC_ADDR_SET, &sg)) {
> > > > > +			dev_warn(&vdev->dev, "Failed to update MAC address.\n");
> > > > 
> > > > Here, I'm not sure we want to proceed. Is it useful sometimes?
> > > 
> > > I think reporting an error is always useful, but I can remove that if you prefer.
> > 
> > No the question was whether we should fail probe not
> > whether we print the warning.
> 
> Good question.
> 
> After all, as VIRTIO_NET_F_CTRL_MAC_ADDR is set, if
> VIRTIO_NET_CTRL_MAC_ADDR_SET fails it means there is a real problem, so yes,
> we should fail.
> 
> > 
> > 
> > > > I note that we deny with virtnet_set_mac_address.
> > > > 
> > > > > +		}
> > > > > +	}
> > > > > +
> > > > >    	return 0;
> > > > 
> > > > 
> > > > 
> > > > Also, some code duplication with virtnet_set_mac_address here.
> > > > 
> > > > Also:
> > > > 	When using the legacy interface, \field{mac} is driver-writable
> > > > 	which provided a way for drivers to update the MAC without
> > > > 	negotiating VIRTIO_NET_F_CTRL_MAC_ADDR.
> > > > 
> > > > How about factoring out code in virtnet_set_mac_address
> > > > and reusing that?
> > > > 
> > > 
> > > In fact, we can write in the field only if we have VIRTIO_NET_F_MAC
> > > (according to virtnet_set_mac_address(), and this code is executed only if
> > > we do not have VIRTIO_NET_F_MAC. So I think it's better not factoring the
> > > code as we have only the control queue case to manage.
> > > 
> > > > This will also handle corner cases such as VIRTIO_NET_F_STANDBY
> > > > which are not currently addressed.
> > > 
> > > F_STANDBY is only enabled when virtio-net device MAC address is equal to the
> > > VFIO device MAC address, I don't think it can be enabled when the MAC
> > > address is randomly assigned (in this case it has already failed in
> > > net_failover_create(), as it has been called using the random mac address),
> > > it's why I didn't check for it.
> > 
> > But the spec did not say there's a dependency :(.
> > My point is what should we do if there's F_STANDBY but no MAC?
> > Maybe add a separate patch clearing F_STANDBY in this case?
> 
> The simplest would be to add at the beginning of the probe function:
> 
> if (!virtio_has_feature(vdev, VIRTIO_NET_F_MAC) &&
>     virtio_has_feature(vdev, VIRTIO_NET_F_STANDBY)) {
> 	pr_err("virtio-net: a standby device cannot be used without a MAC address");
> 	return -EOPNOTSUPP;
> }
> 
> And I think it would help a lot to debug misconfiguration of the interface.
> 
> Thanks,
> Laurent

I would rather add these checks in virtnet_validate.
And I think it's cleaner to just do __virtio_clear_bit on
VIRTIO_NET_F_STANDBY rather than failing simply because
we previously did not prohibit it so there could be
devices like these out there.

A spec patch saying VIRTIO_NET_F_STANDBY should also have
VIRTIO_NET_F_MAC is also welcome.

> > 
> > > > 
> > > > 
> > > > >    free_unregister_netdev:
> > > > > -- 
> > > > > 2.39.0
> > > > 
> > > 
> > > Thanks,
> > > Laurent
> > 

