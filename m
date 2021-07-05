Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86F0C3BB5F3
	for <lists+netdev@lfdr.de>; Mon,  5 Jul 2021 05:48:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbhGEDvZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Jul 2021 23:51:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52636 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229715AbhGEDvZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Jul 2021 23:51:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625456928;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=25P6+qOObwDiaurdWnfUZ/5fIR3I7PXs4U3cGO2pDNQ=;
        b=ZxfKnzuUsmBJ24UVTsrzkAeYBQNnDiNzUV/bqxYppgDq1SU3RyEdzt0Se4hoHuUpnk4G1x
        Gltq3yKVXEelmzk5iBAO35A5/LKb2D4RbY1O6zdlmoHUos8D9oOYnEXkUw36XZInZOIaid
        +p05T5anyVxz+wzT9RmF1sq4ZNfyDLQ=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-143-huTfiF0eOCWJrzoGtVtCyA-1; Sun, 04 Jul 2021 23:48:47 -0400
X-MC-Unique: huTfiF0eOCWJrzoGtVtCyA-1
Received: by mail-pg1-f200.google.com with SMTP id x9-20020a6541490000b0290222fe6234d6so12617826pgp.14
        for <netdev@vger.kernel.org>; Sun, 04 Jul 2021 20:48:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=25P6+qOObwDiaurdWnfUZ/5fIR3I7PXs4U3cGO2pDNQ=;
        b=OHGwaez9jsyx3N1bwu4HgoGwiNqkSRFB0S0IMrMAE+BBWPw5F0QaN+O8ATBMJne3HY
         /mrvSyhGFKH9JhpOpP+uByFoUXvF2eGCrzbtEyxRlhlX4PwZcOB6YZxkmzeoQTBtagbe
         tvkhVLbMF++Z+dtZdljN8m2piahAlKNJGyDGa97yCdSKprwAM23kvQzMsge3YfpVzMQR
         d/y8zKdz7/T2xQ6WpjN43bhpHuUmMKiLLkkKxwL3y76m7fnqSM5j7AHkpRAkqOlIu3eu
         kYQhHvo74mY4fn5Ulla81vRlSFhQaTAlu+hXPTBw5lhWTxihDuEXVWVBZdxLLmN9CmhL
         GnHg==
X-Gm-Message-State: AOAM533M9Bp/b67mR2cmiVewx5R1Fii02MfZrV+v+BiRwP47mtXS4jFx
        Z0AHn3GO2kQx268FrhWFVXoB6aoQ5dvUSM2ba875CNLZ6/FlHzXHzECoGbwai6OQKmco3h775xC
        wTOz7OPMUG9XpsqME
X-Received: by 2002:a63:f955:: with SMTP id q21mr13651929pgk.448.1625456925971;
        Sun, 04 Jul 2021 20:48:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxh+8a0lcafys7ntL0qYOJsYQ0uxw1HqHLN2/UyNlqrNDJW0H4QdQRaegwbRorAJ1FTbNPV1A==
X-Received: by 2002:a63:f955:: with SMTP id q21mr13651917pgk.448.1625456925713;
        Sun, 04 Jul 2021 20:48:45 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id f193sm2380694pfa.185.2021.07.04.20.48.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 04 Jul 2021 20:48:45 -0700 (PDT)
Subject: Re: [RFC PATCH] vhost-vdpa: mark vhost device invalid to reflect vdpa
 device unregistration
To:     gautam.dawar@xilinx.com
Cc:     martinh@xilinx.com, hanand@xilinx.com, gdawar@xilinx.com,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210704205205.6132-1-gdawar@xilinx.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <3d02b8f5-0a6b-e8d1-533d-8503da3fcc4e@redhat.com>
Date:   Mon, 5 Jul 2021 11:48:36 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210704205205.6132-1-gdawar@xilinx.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/7/5 ÉÏÎç4:52, gautam.dawar@xilinx.com Ð´µÀ:
>   	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
> @@ -1091,11 +1122,13 @@ static void vhost_vdpa_remove(struct vdpa_device *vdpa)
>   		opened = atomic_cmpxchg(&v->opened, 0, 1);
>   		if (!opened)
>   			break;
> -		wait_for_completion_timeout(&v->completion,
> -					    msecs_to_jiffies(1000));
> -		dev_warn_once(&v->dev,
> -			      "%s waiting for/dev/%s to be closed\n",
> -			      __func__, dev_name(&v->dev));
> +		if (!wait_for_completion_timeout(&v->completion,
> +					    msecs_to_jiffies(1000))) {
> +			dev_warn(&v->dev,
> +				 "%s/dev/%s in use, continue..\n",
> +				 __func__, dev_name(&v->dev));
> +			break;
> +		}
>   	} while (1);
>   
>   	put_device(&v->dev);
> +	v->dev_invalid = true;


Besides the mapping handling mentioned by Michael. I think this can lead 
use-after-free. put_device may release the memory.

Another fundamental issue, vDPA is the parent of vhost-vDPA device. I'm 
not sure the device core can allow the parent to go away first.

Thanks


