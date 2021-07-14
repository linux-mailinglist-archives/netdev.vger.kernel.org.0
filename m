Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89B9F3C7C26
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 04:54:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237635AbhGNC5P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 22:57:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25489 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237456AbhGNC5O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Jul 2021 22:57:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626231263;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L8YuQd5Ts4JNGV6wtOAvCK5EPGDYCcnR+6g/ZGfnDJI=;
        b=BAyyWUmPNx1uQ/8+GV32/pc5x7Rumus9OvFX2Q7B90oCLYtPc44dll/3Z8x+mKKhLLZR50
        hR5Wi8i4IUDn4vg2V6DQfFOMeXfphdBlbGLSyU4mGiRjcs9gA7jgeikELD0nEgfHgRpOOP
        x+hR3SO36L31sP8e+CjakIO3APs1AuQ=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-593-7hmeHIxyPs2NaCVDmq43zw-1; Tue, 13 Jul 2021 22:54:22 -0400
X-MC-Unique: 7hmeHIxyPs2NaCVDmq43zw-1
Received: by mail-pf1-f200.google.com with SMTP id w191-20020a62ddc80000b0290318fa423788so543258pff.11
        for <netdev@vger.kernel.org>; Tue, 13 Jul 2021 19:54:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=L8YuQd5Ts4JNGV6wtOAvCK5EPGDYCcnR+6g/ZGfnDJI=;
        b=QGTpGlJKnKx41qVRtqWXSB1bPEC3EByzB8xc6dCc4ndYdXdoVoF4Y1OLsoGaAkH8Xa
         gNK7ozCPgW9tMI1pN28YVRozHI67R2G4tCArpwRZjtowOyaP3DiHNP3FnOmC1nXf4OE3
         v3l9yAjqqXr9A4BFKtpFjTv0PuGPIaKNFD3zI5GyT0X1FcysPNvHIXw0MUJPEvnzHXRH
         JN+xnH+p0hIF1RaMSSQ1WjKSFTfM0mGOdjDriLexZ2umeTCi0qD71oZhK8OA4V3m4GZl
         s50htFpKF9fwMUl5zlbrOIQZ62cw7DBqeECviXiA+Ea54hSoz8Wk90TvyG+k832lpOWZ
         cUtQ==
X-Gm-Message-State: AOAM530vbr6Qx+9NonLdTpu9X2gQqBfXoM3/JslBJtX8BAS9TxxgUIh2
        G2ZE3RocmfcUo7VIiVtUR+1wcVcbUkOKQK7xPV7xwMfqB2C6xKykXiTpvFqH7OAV4oJuytLHBqY
        dQugEPk5LHCzBYuKq
X-Received: by 2002:aa7:93cd:0:b029:328:9d89:a790 with SMTP id y13-20020aa793cd0000b02903289d89a790mr7769428pff.71.1626231261376;
        Tue, 13 Jul 2021 19:54:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyVcvRFQIHUh/wToTzbSqcRq399rxXFtmmAr5rDXhIuYW/QN+SkST9rmMlarwJcwx/uWSDVUw==
X-Received: by 2002:aa7:93cd:0:b029:328:9d89:a790 with SMTP id y13-20020aa793cd0000b02903289d89a790mr7769384pff.71.1626231260928;
        Tue, 13 Jul 2021 19:54:20 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id v11sm494452pjs.13.2021.07.13.19.54.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Jul 2021 19:54:20 -0700 (PDT)
Subject: Re: [PATCH v9 16/17] vduse: Introduce VDUSE - vDPA Device in
 Userspace
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        Xie Yongji <xieyongji@bytedance.com>
Cc:     mst@redhat.com, stefanha@redhat.com, sgarzare@redhat.com,
        parav@nvidia.com, hch@infradead.org,
        christian.brauner@canonical.com, rdunlap@infradead.org,
        willy@infradead.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
        bcrl@kvack.org, corbet@lwn.net, mika.penttila@nextfour.com,
        joro@8bytes.org, gregkh@linuxfoundation.org, zhe.he@windriver.com,
        xiaodong.liu@intel.com, songmuchun@bytedance.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <20210713084656.232-1-xieyongji@bytedance.com>
 <20210713084656.232-17-xieyongji@bytedance.com> <20210713132741.GM1954@kadam>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <c42979dd-331f-4af5-fda6-18d80f22be2d@redhat.com>
Date:   Wed, 14 Jul 2021 10:54:08 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210713132741.GM1954@kadam>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/7/13 ÏÂÎç9:27, Dan Carpenter Ð´µÀ:
> On Tue, Jul 13, 2021 at 04:46:55PM +0800, Xie Yongji wrote:
>> +static int vduse_dev_init_vdpa(struct vduse_dev *dev, const char *name)
>> +{
>> +	struct vduse_vdpa *vdev;
>> +	int ret;
>> +
>> +	if (dev->vdev)
>> +		return -EEXIST;
>> +
>> +	vdev = vdpa_alloc_device(struct vduse_vdpa, vdpa, dev->dev,
>> +				 &vduse_vdpa_config_ops, name, true);
>> +	if (!vdev)
>> +		return -ENOMEM;
> This should be an IS_ERR() check instead of a NULL check.


Yes.


>
> The vdpa_alloc_device() macro is doing something very complicated but
> I'm not sure what.  It calls container_of() and that looks buggy until
> you spot the BUILD_BUG_ON_ZERO() compile time assert which ensures that
> the container_of() is a no-op.
>
> Only one of the callers checks for error pointers correctly so maybe
> it's too complicated or maybe there should be better documentation.


We need better documentation for this macro and fix all the buggy callers.

Yong Ji, want to do that?

Thanks


>
> regards,
> dan carpenter
>

