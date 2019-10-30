Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA03AE96F3
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 08:05:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726884AbfJ3HFL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 03:05:11 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:29854 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726407AbfJ3HFL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 03:05:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572419110;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZYjavpYNdju7uQHCnPbWIWk6TuX9M9rpxBlmDPHLt1Y=;
        b=eWfcnH3AIyr84h82tMFsNCOH0RHN5+msjck3I2cSNjqNaUuIXdYHSsSm0qIQRDLpH0JfHL
        0yJBD2lNgLqKHmz324W/J18btM9rQHyY2LT91ciUQPudGb2zfceprc+st2ZplEcawbJ52p
        5oU1JVJRPg6V+MSHnbeHuRq6YrPe1lM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-82-OCSk8MvqNOiwx4R9AcJRYQ-1; Wed, 30 Oct 2019 03:05:06 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4EDA0180496F;
        Wed, 30 Oct 2019 07:05:05 +0000 (UTC)
Received: from [10.72.12.223] (ovpn-12-223.pek2.redhat.com [10.72.12.223])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0CC0210016EB;
        Wed, 30 Oct 2019 07:04:37 +0000 (UTC)
Subject: Re: [RFC] vhost_mdev: add network control vq support
To:     Tiwei Bie <tiwei.bie@intel.com>
Cc:     mst@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        dan.daly@intel.com, cunming.liang@intel.com,
        zhihong.wang@intel.com, lingshan.zhu@intel.com
References: <20191029101726.12699-1-tiwei.bie@intel.com>
 <59474431-9e77-567c-9a46-a3965f587f65@redhat.com>
 <20191030061711.GA11968@___>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <39aa9f66-8e58-ea63-5795-7df8861ff3a0@redhat.com>
Date:   Wed, 30 Oct 2019 15:04:37 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191030061711.GA11968@___>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: OCSk8MvqNOiwx4R9AcJRYQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/10/30 =E4=B8=8B=E5=8D=882:17, Tiwei Bie wrote:
> On Tue, Oct 29, 2019 at 06:51:32PM +0800, Jason Wang wrote:
>> On 2019/10/29 =E4=B8=8B=E5=8D=886:17, Tiwei Bie wrote:
>>> This patch adds the network control vq support in vhost-mdev.
>>> A vhost-mdev specific op is introduced to allow parent drivers
>>> to handle the network control commands come from userspace.
>> Probably work for userspace driver but not kernel driver.
> Exactly. This is only for userspace.
>
> I got your point now. In virtio-mdev kernel driver case,
> the ctrl-vq can be special as well.
>

Then maybe it's better to introduce vhost-mdev-net on top?

Looking at the other type of virtio device:

- console have two control virtqueues when multiqueue port is enabled

- SCSI has controlq + eventq

- GPU has controlq

- Crypto device has one controlq

- Socket has eventq

...

Thanks

