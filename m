Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3604333CDC4
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 07:10:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235629AbhCPGJo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 02:09:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49403 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233098AbhCPGJN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 02:09:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615874953;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2BW1sBItML7wtTpQapaMP53TtXuZoCkLLYqm0wfSE7A=;
        b=RuyscgyHdMHcycD99zzeonkfWcrwDd+mHPbkNiRQBMUA2eylv819As6MV3fZi8I9Nsxfu+
        wToNZjSEcy7awkMrx1PxZ6Uswt98+nrvBPtoTUtc9fqcmAKbs9k5qUXdBQkEEl0RXsXTUz
        YCxAUeiOZSrVggUXygDxIDUf1a2ufvU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-153-VChqBI0RMoW8WQp27xjQ-g-1; Tue, 16 Mar 2021 02:09:09 -0400
X-MC-Unique: VChqBI0RMoW8WQp27xjQ-g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 94237801817;
        Tue, 16 Mar 2021 06:09:07 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-12-216.pek2.redhat.com [10.72.12.216])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 746CF60C0F;
        Tue, 16 Mar 2021 06:09:01 +0000 (UTC)
Subject: Re: [PATCH V4 1/7] vDPA/ifcvf: get_vendor_id returns a device
 specific vendor id
To:     Zhu Lingshan <lingshan.zhu@intel.com>, mst@redhat.com,
        lulu@redhat.com, leonro@nvidia.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210315074501.15868-1-lingshan.zhu@intel.com>
 <20210315074501.15868-2-lingshan.zhu@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <7ad48606-1ed1-0b96-a236-ecdb0b01e560@redhat.com>
Date:   Tue, 16 Mar 2021 14:09:00 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210315074501.15868-2-lingshan.zhu@intel.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/3/15 ÏÂÎç3:44, Zhu Lingshan Ð´µÀ:
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

