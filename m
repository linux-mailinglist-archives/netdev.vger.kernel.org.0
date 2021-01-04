Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 135CC2E90BE
	for <lists+netdev@lfdr.de>; Mon,  4 Jan 2021 08:05:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727300AbhADHE7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 02:04:59 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:23197 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726734AbhADHE6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jan 2021 02:04:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609743812;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+f9+XPdRZxWwAbMjqhs2a72E1AbDKCUZW2paxgvF++4=;
        b=IQ3jBEpE/LwUJAmRgn++lgdyegeIWud0XJX2G8GHM2nLJGoH8T5VD9u65xUP+ZxpTrLaH7
        d+mJ3A8I/Wp7As/nxEPVAO5TzaV0rFeS5Y+FZcyLIBFNRAqfvoLERUAEu5tE1pKR91CjEj
        axkYozU428pXwpjpzw17xS/grYNmIBc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-280-G0J0Lc5EPiKFogy4VNJQCQ-1; Mon, 04 Jan 2021 02:03:30 -0500
X-MC-Unique: G0J0Lc5EPiKFogy4VNJQCQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A12E1800D55;
        Mon,  4 Jan 2021 07:03:29 +0000 (UTC)
Received: from [10.72.13.91] (ovpn-13-91.pek2.redhat.com [10.72.13.91])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C7C2B100239A;
        Mon,  4 Jan 2021 07:03:24 +0000 (UTC)
Subject: Re: [PATCH linux-next v2 4/7] vdpa: Define vdpa mgmt device, ops and
 a netlink interface
To:     Parav Pandit <parav@nvidia.com>,
        virtualization@lists.linux-foundation.org
Cc:     mst@redhat.com, elic@nvidia.com, netdev@vger.kernel.org
References: <20201112064005.349268-1-parav@nvidia.com>
 <20210104033141.105876-1-parav@nvidia.com>
 <20210104033141.105876-5-parav@nvidia.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <b08ede5d-e393-b4f8-d1d8-2aa29e409872@redhat.com>
Date:   Mon, 4 Jan 2021 15:03:23 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210104033141.105876-5-parav@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/1/4 上午11:31, Parav Pandit wrote:
> To add one or more VDPA devices, define a management device which
> allows adding or removing vdpa device. A management device defines
> set of callbacks to manage vdpa devices.
>
> To begin with, it defines add and remove callbacks through which a user
> defined vdpa device can be added or removed.
>
> A unique management device is identified by its unique handle identified
> by management device name and optionally the bus name.
>
> Hence, introduce routine through which driver can register a
> management device and its callback operations for adding and remove
> a vdpa device.
>
> Introduce vdpa netlink socket family so that user can query management
> device and its attributes.
>
> Example of show vdpa management device which allows creating vdpa device of
> networking class (device id = 0x1) of virtio specification 1.1
> section 5.1.1.
>
> $ vdpa mgmtdev show
> vdpasim_net:
>    supported_classes:
>      net
>
> Example of showing vdpa management device in JSON format.
>
> $ vdpa mgmtdev show -jp
> {
>      "show": {
>          "vdpasim_net": {
>              "supported_classes": [ "net" ]
>          }
>      }
> }
>
> Signed-off-by: Parav Pandit<parav@nvidia.com>
> Reviewed-by: Eli Cohen<elic@nvidia.com>
> Reviewed-by: Jason Wang<jasowang@redhat.com>
> ---
> Changelog:
> v1->v2:
>   - rebased
>   - updated commit log example for management device name from
>     "vdpasim" to "vdpasim_net"
>   - removed device_id as net and block management devices are separated


So I wonder whether there could be a type of management devices that can 
deal with multiple types of virtio devices. If yes, we probably need to 
add device id back.

Thanks


