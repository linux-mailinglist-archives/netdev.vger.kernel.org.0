Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72A22272327
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 13:52:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbgIULwn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 07:52:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726424AbgIULwm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 07:52:42 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10EA9C0613CF
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 04:52:42 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id 16so14580255qkf.4
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 04:52:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9GdfLLnBwmTIrHlBrgKS0vwwGe97TiHUVxEiYepX0Ik=;
        b=jd8mtccJd95vXG8tPvhTo5cmxVU/9D6fSI4BYPyufILC+upgo8ryyRIWhBoOerxqXd
         BpWfFxCy8gWG+RgU9W4DeeKG/BHRVl95xXhbTSm+H2dE/wJJPXAXDwRrrtkjnAW3T8gP
         lM1X+xsvG9oKy0MfknmFJ7YWqQ4bmuph0NLS7Ew9HgNR/uipDNWBCwoifN5cYojfXXv8
         1vodTw6UDdRsC/PK3CJEmosE02WNk3bUx3AELA30Grac2iziP4KCY6+5UDo/zLjZy/2H
         hz0USvFBtoXKQu6R3ePu7kL8+a4yMjbCsOR5LlPBGH0/+JnZaHt0TIcAAyMutlyjgooa
         xo+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9GdfLLnBwmTIrHlBrgKS0vwwGe97TiHUVxEiYepX0Ik=;
        b=VawdiSeVVYUB2HG7EpYA9yLzl1LVImGA+PHVZZYyZ1QmhY8yNXopgHBwudn5/0OnHI
         rbSUYWYO/3xcZ/vGOIoCIGRTuhwJ53wRARdPfl+5zsL6AtsNiCoGXGndBv1YQ11/31im
         yuS5syaf59wRokOLkBCPWJ0IyPqMlteXuNm/zNOnwue6Wf647wS9YPOqTjy92tI10aq6
         0JChEyF5er5RISZnPXHZytsmhqUyuFsOe1ESpXLY8zgAJCPRnGIDDGY6Fp+CxAiwNgxM
         HKSpOI/9uAmwYE1zSCgZD5JNL8ay6pZYG6GHD/HXPk+VYgHYXkBhNJEobl21K15GnMkb
         MgAg==
X-Gm-Message-State: AOAM530pD5ApGC/TL1sRbgGEb8AdAAYTaoEy5KTOW3BsDrwPujIZXpqc
        JapldExKJLYAi0wDjTFzPa6Jjg==
X-Google-Smtp-Source: ABdhPJww4SA+NBlwW6cnSm5w5H+olbfUT5soN9XUNZ4B0XivTeFiStV1r25OdfE0Z547vGPoichUIQ==
X-Received: by 2002:a37:5144:: with SMTP id f65mr7480324qkb.351.1600689161019;
        Mon, 21 Sep 2020 04:52:41 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-48-30.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.48.30])
        by smtp.gmail.com with ESMTPSA id p187sm8622635qkd.129.2020.09.21.04.52.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2020 04:52:40 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1kKKN5-002aXy-Dp; Mon, 21 Sep 2020 08:52:39 -0300
Date:   Mon, 21 Sep 2020 08:52:39 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Oded Gabbay <oded.gabbay@gmail.com>,
        Leon Romanovsky <leon@kernel.org>,
        Gal Pressman <galpress@amazon.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, SW_Drivers <SW_Drivers@habana.ai>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH v3 00/14] Adding GAUDI NIC code to habanalabs driver
Message-ID: <20200921115239.GC8409@ziepe.ca>
References: <20200918120340.GT869610@unreal>
 <CAFCwf12VPuyGFqFJK5D19zcKFQJ=fmzjwscdPG82tfR_v_h3Kg@mail.gmail.com>
 <20200918121905.GU869610@unreal>
 <20200919064020.GC439518@kroah.com>
 <20200919082003.GW869610@unreal>
 <20200919083012.GA465680@kroah.com>
 <CAFCwf122V-ep44Kqk1DgRJN+tq3ctxE9uVbqYL07apLkLe2Z7g@mail.gmail.com>
 <20200919172730.GC2733595@kroah.com>
 <20200919192235.GB8409@ziepe.ca>
 <20200920084702.GA533114@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200920084702.GA533114@kroah.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 20, 2020 at 10:47:02AM +0200, Greg Kroah-Hartman wrote:
> > If not, what open source userspace are you going to ask them to
> > present to merge the kernel side into misc?
> 
> I don't think that they have a userspace api to their rdma feature from
> what I understand, but I could be totally wrong as I do not know their
> hardware at all, so I'll let them answer this question.

I thought Oded was pretty clear, the goal of this series is to expose
their RDMA HW to userspace. This problem space requires co-mingling
networking and compute at extremely high speed/low overhead. This is
all done in userspace.

We are specifically talking about this in
include/uapi/misc/habanalabs.h:

 /*
  * NIC
  *
  * This IOCTL allows the user to manage and configure the device's NIC ports.
  * The following operations are available:
  * - Create a completion queue
  * - Destroy a completion queue
  * - Wait on completion queue
  * - Poll a completion queue
  * - Update consumed completion queue entries
  * - Set a work queue
  * - Unset a work queue
  *
  * For all operations, the user should provide a pointer to an input structure
  * with the context parameters. Some of the operations also require a pointer to
  * driver regarding how many of the available CQEs were actually
  * processed/consumed. Only then the driver will override them with newer
  * entries.
  * The set WQ operation should provide the device virtual address of the WQ with
  * a matching size for the number of WQs and entries per WQ.
  *
  */
 #define HL_IOCTL_NIC	_IOWR('H', 0x07, struct hl_nic_args)

Which is ibv_create_qp, ibv_create_cq, ibv_poll_cq, etc, etc

Habana has repeatedly described their HW as having multiple 100G RoCE
ports. RoCE is one of the common industry standards that ibverbs
unambiguously is responsible for.

I would be much less annoyed if they were not actively marketing their
product as RoCE RDMA.

Sure there is some argument that their RoCE isn't spec compliant, but
I don't think it excuses the basic principle of our subsystem:

 RDMA HW needs to demonstrate some basic functionality using the
 standard open source userspace software stack.

I don't like this idea of backdooring a bunch of proprietary closed
source RDMA userspace through drivers/misc, and if you don't have a
clear idea how to get something equal for drivers/misc you should not
accept the H_IOCTL_NIC.

Plus RoCE is complicated, there is a bunch of interaction with netdev
and rules related to that that really needs to be respected.

> For anything that _has_ to have a userspace RMDA interface, sure ibverbs
> are the one we are stuck with, but I didn't think that was the issue
> here at all, which is why I wrote the above comments.

I think you should look at the patches #8 through 11:

https://lore.kernel.org/lkml/20200915171022.10561-9-oded.gabbay@gmail.com/

Jason
