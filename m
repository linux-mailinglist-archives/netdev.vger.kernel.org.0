Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BBF8331CDD
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 03:19:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230464AbhCICSl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 21:18:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27155 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230492AbhCICSX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Mar 2021 21:18:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615256303;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rcShwLoJWnpEZpwYw3XT7sfmNyFh50D0tcu/Ys15ACw=;
        b=WDl0EDRmCvJiIIdZ4j1qcaOdEektFwmPYRlpLg/5fCPBGV6Ii7javwDQelNJnubPRXGUfm
        9N9Z0d64omm7TTNJtsKfg6gf5Mx0alo0SN6y/X/1VOb1GkfWt7tVtt5CL0KGPVUsz5/4k+
        anRYIBbCbW375x0f9cq+nHWg063FiUA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-417-Yjo8hpWsNR6Gv8zljaCtoQ-1; Mon, 08 Mar 2021 21:18:20 -0500
X-MC-Unique: Yjo8hpWsNR6Gv8zljaCtoQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B0E2C80432D;
        Tue,  9 Mar 2021 02:18:18 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-13-202.pek2.redhat.com [10.72.13.202])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 61C0D5C27C;
        Tue,  9 Mar 2021 02:18:12 +0000 (UTC)
Subject: Re: [PATCH V2 1/4] vDPA/ifcvf: get_vendor_id returns a device
 specific vendor id
To:     Zhu Lingshan <lingshan.zhu@intel.com>, mst@redhat.com,
        lulu@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210308083525.382514-1-lingshan.zhu@intel.com>
 <20210308083525.382514-2-lingshan.zhu@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <2a7b9cba-620f-a447-7de6-0b9dc74817ba@redhat.com>
Date:   Tue, 9 Mar 2021 10:18:11 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210308083525.382514-2-lingshan.zhu@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/3/8 4:35 下午, Zhu Lingshan wrote:
> In this commit, ifcvf_get_vendor_id() will return
> a device specific vendor id of the probed pci device
> than a hard code.
>
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>


Acked-by: Jason Wang <jasowang@redhat.com>


> ---
>   drivers/vdpa/ifcvf/ifcvf_main.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
> index fa1af301cf55..e501ee07de17 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
> @@ -324,7 +324,10 @@ static u32 ifcvf_vdpa_get_device_id(struct vdpa_device *vdpa_dev)
>   
>   static u32 ifcvf_vdpa_get_vendor_id(struct vdpa_device *vdpa_dev)
>   {
> -	return IFCVF_SUBSYS_VENDOR_ID;
> +	struct ifcvf_adapter *adapter = vdpa_to_adapter(vdpa_dev);
> +	struct pci_dev *pdev = adapter->pdev;
> +
> +	return pdev->subsystem_vendor;
>   }
>   
>   static u32 ifcvf_vdpa_get_vq_align(struct vdpa_device *vdpa_dev)

