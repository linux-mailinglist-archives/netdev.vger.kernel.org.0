Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90F773AFE5B
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 09:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230312AbhFVHw3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 03:52:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26516 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230206AbhFVHwZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 03:52:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624348209;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B9jxicCY/A2tBCMMCVXdYtwBAnUmmmvP+ho9k5jFvbQ=;
        b=fIYGh6Hf655kIAaK85Psrw/osHc7q4XumW1rgRgSM+n4mYO8+D3yzaK/Ryltzp2IVwWnAj
        1S8N971M8Fcpe6y0b7mepFJt2k+Bc4MZDfbCBg1LDvYd7myp02kkC1lVjqwH0EVidCR7lx
        pc2UQEM2lGMC9FPVE84c5to+9NbXxPU=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-573-hyrGzalsPJiIQy6KAEwmPg-1; Tue, 22 Jun 2021 03:50:06 -0400
X-MC-Unique: hyrGzalsPJiIQy6KAEwmPg-1
Received: by mail-pg1-f197.google.com with SMTP id s14-20020a63450e0000b029021f631b8861so13215124pga.20
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 00:50:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=B9jxicCY/A2tBCMMCVXdYtwBAnUmmmvP+ho9k5jFvbQ=;
        b=IYLr8TnUYrALsWFd40EiL32jaIoSiKiIGzRm0Rw5y1uyW9Fb5gUFZLxpETrwPWafBo
         3am68NRPweWgRKkdxD1Z80iO+sA9B/iDfDk/uvsItMq5gbjwJ0WiXUK8vKOds3lZ/WMP
         +YJN/NjHMIyNiZiNxtPbHbOEfhv+Cfu2szjgu0qpvvBCcjtoLzjisviy3Zuetv15xoOL
         v8iE18E8pK8oHeLusCHmNCSFHjzyjIOxWzkHBHh4ryK4RZyeHV05F6DgkGBWD87nWLR2
         ucMP1H7Dhy+1jRuQZxhIJAoamaoPqCNsJTxXNzRgtjGS2QCjVLAmdxFspOG9Hc+GUB5O
         mnhA==
X-Gm-Message-State: AOAM533R/VdutrcgRIdu8Vp3GjTXsKmlfSV5AxaaVCW8Y85ryT1ZKjw3
        xfRqW2+19Nz0e6yHFsrghX0ncl81UThgLWrGD+TL6D9UQtj/zU0bYuvDz4/9dqkMdfd0vAR5yU5
        oTxfyIieUxnnG72ac
X-Received: by 2002:a17:902:c641:b029:122:6927:6e50 with SMTP id s1-20020a170902c641b029012269276e50mr9862239pls.6.1624348205578;
        Tue, 22 Jun 2021 00:50:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxekq+kgOUVrlD5LnpXeHpq0h9w1ALVma6btHHZ2quAdETHnuyEnF0QoKaSap2eytMg2NykVQ==
X-Received: by 2002:a17:902:c641:b029:122:6927:6e50 with SMTP id s1-20020a170902c641b029012269276e50mr9862215pls.6.1624348205162;
        Tue, 22 Jun 2021 00:50:05 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id f18sm1474016pjq.48.2021.06.22.00.49.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Jun 2021 00:50:04 -0700 (PDT)
Subject: Re: [PATCH v8 09/10] vduse: Introduce VDUSE - vDPA Device in
 Userspace
To:     Yongji Xie <xieyongji@bytedance.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Parav Pandit <parav@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        Christian Brauner <christian.brauner@canonical.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>, bcrl@kvack.org,
        Jonathan Corbet <corbet@lwn.net>,
        =?UTF-8?Q?Mika_Penttil=c3=a4?= <mika.penttila@nextfour.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, joro@8bytes.org,
        Greg KH <gregkh@linuxfoundation.org>, songmuchun@bytedance.com,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <20210615141331.407-1-xieyongji@bytedance.com>
 <20210615141331.407-10-xieyongji@bytedance.com>
 <adfb2be9-9ed9-ca37-ac37-4cd00bdff349@redhat.com>
 <CACycT3tAON+-qZev+9EqyL2XbgH5HDspOqNt3ohQLQ8GqVK=EA@mail.gmail.com>
 <1bba439f-ffc8-c20e-e8a4-ac73e890c592@redhat.com>
 <CACycT3uzMJS7vw6MVMOgY4rb=SPfT2srV+8DPdwUVeELEiJgbA@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <0aeb7cb7-58e5-1a95-d830-68edd7e8ec2e@redhat.com>
Date:   Tue, 22 Jun 2021 15:49:52 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CACycT3uzMJS7vw6MVMOgY4rb=SPfT2srV+8DPdwUVeELEiJgbA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/6/22 下午3:22, Yongji Xie 写道:
>> We need fix a way to propagate the error to the userspace.
>>
>> E.g if we want to stop the deivce, we will delay the status reset until
>> we get respose from the userspace?
>>
> I didn't get how to delay the status reset. And should it be a DoS
> that we want to fix if the userspace doesn't give a response forever?


You're right. So let's make set_status() can fail first, then propagate 
its failure via VHOST_VDPA_SET_STATUS.


>
>>>>> +     }
>>>>> +}
>>>>> +
>>>>> +static size_t vduse_vdpa_get_config_size(struct vdpa_device *vdpa)
>>>>> +{
>>>>> +     struct vduse_dev *dev = vdpa_to_vduse(vdpa);
>>>>> +
>>>>> +     return dev->config_size;
>>>>> +}
>>>>> +
>>>>> +static void vduse_vdpa_get_config(struct vdpa_device *vdpa, unsigned int offset,
>>>>> +                               void *buf, unsigned int len)
>>>>> +{
>>>>> +     struct vduse_dev *dev = vdpa_to_vduse(vdpa);
>>>>> +
>>>>> +     memcpy(buf, dev->config + offset, len);
>>>>> +}
>>>>> +
>>>>> +static void vduse_vdpa_set_config(struct vdpa_device *vdpa, unsigned int offset,
>>>>> +                     const void *buf, unsigned int len)
>>>>> +{
>>>>> +     /* Now we only support read-only configuration space */
>>>>> +}
>>>>> +
>>>>> +static u32 vduse_vdpa_get_generation(struct vdpa_device *vdpa)
>>>>> +{
>>>>> +     struct vduse_dev *dev = vdpa_to_vduse(vdpa);
>>>>> +
>>>>> +     return dev->generation;
>>>>> +}
>>>>> +
>>>>> +static int vduse_vdpa_set_map(struct vdpa_device *vdpa,
>>>>> +                             struct vhost_iotlb *iotlb)
>>>>> +{
>>>>> +     struct vduse_dev *dev = vdpa_to_vduse(vdpa);
>>>>> +     int ret;
>>>>> +
>>>>> +     ret = vduse_domain_set_map(dev->domain, iotlb);
>>>>> +     if (ret)
>>>>> +             return ret;
>>>>> +
>>>>> +     ret = vduse_dev_update_iotlb(dev, 0ULL, ULLONG_MAX);
>>>>> +     if (ret) {
>>>>> +             vduse_domain_clear_map(dev->domain, iotlb);
>>>>> +             return ret;
>>>>> +     }
>>>>> +
>>>>> +     return 0;
>>>>> +}
>>>>> +
>>>>> +static void vduse_vdpa_free(struct vdpa_device *vdpa)
>>>>> +{
>>>>> +     struct vduse_dev *dev = vdpa_to_vduse(vdpa);
>>>>> +
>>>>> +     dev->vdev = NULL;
>>>>> +}
>>>>> +
>>>>> +static const struct vdpa_config_ops vduse_vdpa_config_ops = {
>>>>> +     .set_vq_address         = vduse_vdpa_set_vq_address,
>>>>> +     .kick_vq                = vduse_vdpa_kick_vq,
>>>>> +     .set_vq_cb              = vduse_vdpa_set_vq_cb,
>>>>> +     .set_vq_num             = vduse_vdpa_set_vq_num,
>>>>> +     .set_vq_ready           = vduse_vdpa_set_vq_ready,
>>>>> +     .get_vq_ready           = vduse_vdpa_get_vq_ready,
>>>>> +     .set_vq_state           = vduse_vdpa_set_vq_state,
>>>>> +     .get_vq_state           = vduse_vdpa_get_vq_state,
>>>>> +     .get_vq_align           = vduse_vdpa_get_vq_align,
>>>>> +     .get_features           = vduse_vdpa_get_features,
>>>>> +     .set_features           = vduse_vdpa_set_features,
>>>>> +     .set_config_cb          = vduse_vdpa_set_config_cb,
>>>>> +     .get_vq_num_max         = vduse_vdpa_get_vq_num_max,
>>>>> +     .get_device_id          = vduse_vdpa_get_device_id,
>>>>> +     .get_vendor_id          = vduse_vdpa_get_vendor_id,
>>>>> +     .get_status             = vduse_vdpa_get_status,
>>>>> +     .set_status             = vduse_vdpa_set_status,
>>>>> +     .get_config_size        = vduse_vdpa_get_config_size,
>>>>> +     .get_config             = vduse_vdpa_get_config,
>>>>> +     .set_config             = vduse_vdpa_set_config,
>>>>> +     .get_generation         = vduse_vdpa_get_generation,
>>>>> +     .set_map                = vduse_vdpa_set_map,
>>>>> +     .free                   = vduse_vdpa_free,
>>>>> +};
>>>>> +
>>>>> +static dma_addr_t vduse_dev_map_page(struct device *dev, struct page *page,
>>>>> +                                  unsigned long offset, size_t size,
>>>>> +                                  enum dma_data_direction dir,
>>>>> +                                  unsigned long attrs)
>>>>> +{
>>>>> +     struct vduse_dev *vdev = dev_to_vduse(dev);
>>>>> +     struct vduse_iova_domain *domain = vdev->domain;
>>>>> +
>>>>> +     return vduse_domain_map_page(domain, page, offset, size, dir, attrs);
>>>>> +}
>>>>> +
>>>>> +static void vduse_dev_unmap_page(struct device *dev, dma_addr_t dma_addr,
>>>>> +                             size_t size, enum dma_data_direction dir,
>>>>> +                             unsigned long attrs)
>>>>> +{
>>>>> +     struct vduse_dev *vdev = dev_to_vduse(dev);
>>>>> +     struct vduse_iova_domain *domain = vdev->domain;
>>>>> +
>>>>> +     return vduse_domain_unmap_page(domain, dma_addr, size, dir, attrs);
>>>>> +}
>>>>> +
>>>>> +static void *vduse_dev_alloc_coherent(struct device *dev, size_t size,
>>>>> +                                     dma_addr_t *dma_addr, gfp_t flag,
>>>>> +                                     unsigned long attrs)
>>>>> +{
>>>>> +     struct vduse_dev *vdev = dev_to_vduse(dev);
>>>>> +     struct vduse_iova_domain *domain = vdev->domain;
>>>>> +     unsigned long iova;
>>>>> +     void *addr;
>>>>> +
>>>>> +     *dma_addr = DMA_MAPPING_ERROR;
>>>>> +     addr = vduse_domain_alloc_coherent(domain, size,
>>>>> +                             (dma_addr_t *)&iova, flag, attrs);
>>>>> +     if (!addr)
>>>>> +             return NULL;
>>>>> +
>>>>> +     *dma_addr = (dma_addr_t)iova;
>>>>> +
>>>>> +     return addr;
>>>>> +}
>>>>> +
>>>>> +static void vduse_dev_free_coherent(struct device *dev, size_t size,
>>>>> +                                     void *vaddr, dma_addr_t dma_addr,
>>>>> +                                     unsigned long attrs)
>>>>> +{
>>>>> +     struct vduse_dev *vdev = dev_to_vduse(dev);
>>>>> +     struct vduse_iova_domain *domain = vdev->domain;
>>>>> +
>>>>> +     vduse_domain_free_coherent(domain, size, vaddr, dma_addr, attrs);
>>>>> +}
>>>>> +
>>>>> +static size_t vduse_dev_max_mapping_size(struct device *dev)
>>>>> +{
>>>>> +     struct vduse_dev *vdev = dev_to_vduse(dev);
>>>>> +     struct vduse_iova_domain *domain = vdev->domain;
>>>>> +
>>>>> +     return domain->bounce_size;
>>>>> +}
>>>>> +
>>>>> +static const struct dma_map_ops vduse_dev_dma_ops = {
>>>>> +     .map_page = vduse_dev_map_page,
>>>>> +     .unmap_page = vduse_dev_unmap_page,
>>>>> +     .alloc = vduse_dev_alloc_coherent,
>>>>> +     .free = vduse_dev_free_coherent,
>>>>> +     .max_mapping_size = vduse_dev_max_mapping_size,
>>>>> +};
>>>>> +
>>>>> +static unsigned int perm_to_file_flags(u8 perm)
>>>>> +{
>>>>> +     unsigned int flags = 0;
>>>>> +
>>>>> +     switch (perm) {
>>>>> +     case VDUSE_ACCESS_WO:
>>>>> +             flags |= O_WRONLY;
>>>>> +             break;
>>>>> +     case VDUSE_ACCESS_RO:
>>>>> +             flags |= O_RDONLY;
>>>>> +             break;
>>>>> +     case VDUSE_ACCESS_RW:
>>>>> +             flags |= O_RDWR;
>>>>> +             break;
>>>>> +     default:
>>>>> +             WARN(1, "invalidate vhost IOTLB permission\n");
>>>>> +             break;
>>>>> +     }
>>>>> +
>>>>> +     return flags;
>>>>> +}
>>>>> +
>>>>> +static int vduse_kickfd_setup(struct vduse_dev *dev,
>>>>> +                     struct vduse_vq_eventfd *eventfd)
>>>>> +{
>>>>> +     struct eventfd_ctx *ctx = NULL;
>>>>> +     struct vduse_virtqueue *vq;
>>>>> +     u32 index;
>>>>> +
>>>>> +     if (eventfd->index >= dev->vq_num)
>>>>> +             return -EINVAL;
>>>>> +
>>>>> +     index = array_index_nospec(eventfd->index, dev->vq_num);
>>>>> +     vq = &dev->vqs[index];
>>>>> +     if (eventfd->fd >= 0) {
>>>>> +             ctx = eventfd_ctx_fdget(eventfd->fd);
>>>>> +             if (IS_ERR(ctx))
>>>>> +                     return PTR_ERR(ctx);
>>>>> +     } else if (eventfd->fd != VDUSE_EVENTFD_DEASSIGN)
>>>>> +             return 0;
>>>>> +
>>>>> +     spin_lock(&vq->kick_lock);
>>>>> +     if (vq->kickfd)
>>>>> +             eventfd_ctx_put(vq->kickfd);
>>>>> +     vq->kickfd = ctx;
>>>>> +     if (vq->ready && vq->kicked && vq->kickfd) {
>>>>> +             eventfd_signal(vq->kickfd, 1);
>>>>> +             vq->kicked = false;
>>>>> +     }
>>>>> +     spin_unlock(&vq->kick_lock);
>>>>> +
>>>>> +     return 0;
>>>>> +}
>>>>> +
>>>>> +static void vduse_dev_irq_inject(struct work_struct *work)
>>>>> +{
>>>>> +     struct vduse_dev *dev = container_of(work, struct vduse_dev, inject);
>>>>> +
>>>>> +     spin_lock_irq(&dev->irq_lock);
>>>>> +     if (dev->config_cb.callback)
>>>>> +             dev->config_cb.callback(dev->config_cb.private);
>>>>> +     spin_unlock_irq(&dev->irq_lock);
>>>>> +}
>>>>> +
>>>>> +static void vduse_vq_irq_inject(struct work_struct *work)
>>>>> +{
>>>>> +     struct vduse_virtqueue *vq = container_of(work,
>>>>> +                                     struct vduse_virtqueue, inject);
>>>>> +
>>>>> +     spin_lock_irq(&vq->irq_lock);
>>>>> +     if (vq->ready && vq->cb.callback)
>>>>> +             vq->cb.callback(vq->cb.private);
>>>>> +     spin_unlock_irq(&vq->irq_lock);
>>>>> +}
>>>>> +
>>>>> +static long vduse_dev_ioctl(struct file *file, unsigned int cmd,
>>>>> +                         unsigned long arg)
>>>>> +{
>>>>> +     struct vduse_dev *dev = file->private_data;
>>>>> +     void __user *argp = (void __user *)arg;
>>>>> +     int ret;
>>>>> +
>>>>> +     switch (cmd) {
>>>>> +     case VDUSE_IOTLB_GET_FD: {
>>>>> +             struct vduse_iotlb_entry entry;
>>>>> +             struct vhost_iotlb_map *map;
>>>>> +             struct vdpa_map_file *map_file;
>>>>> +             struct vduse_iova_domain *domain = dev->domain;
>>>>> +             struct file *f = NULL;
>>>>> +
>>>>> +             ret = -EFAULT;
>>>>> +             if (copy_from_user(&entry, argp, sizeof(entry)))
>>>>> +                     break;
>>>>> +
>>>>> +             ret = -EINVAL;
>>>>> +             if (entry.start > entry.last)
>>>>> +                     break;
>>>>> +
>>>>> +             spin_lock(&domain->iotlb_lock);
>>>>> +             map = vhost_iotlb_itree_first(domain->iotlb,
>>>>> +                                           entry.start, entry.last);
>>>>> +             if (map) {
>>>>> +                     map_file = (struct vdpa_map_file *)map->opaque;
>>>>> +                     f = get_file(map_file->file);
>>>>> +                     entry.offset = map_file->offset;
>>>>> +                     entry.start = map->start;
>>>>> +                     entry.last = map->last;
>>>>> +                     entry.perm = map->perm;
>>>>> +             }
>>>>> +             spin_unlock(&domain->iotlb_lock);
>>>>> +             ret = -EINVAL;
>>>>> +             if (!f)
>>>>> +                     break;
>>>>> +
>>>>> +             ret = -EFAULT;
>>>>> +             if (copy_to_user(argp, &entry, sizeof(entry))) {
>>>>> +                     fput(f);
>>>>> +                     break;
>>>>> +             }
>>>>> +             ret = receive_fd(f, perm_to_file_flags(entry.perm));
>>>>> +             fput(f);
>>>>> +             break;
>>>>> +     }
>>>>> +     case VDUSE_DEV_GET_FEATURES:
>>>>> +             ret = put_user(dev->features, (u64 __user *)argp);
>>>>> +             break;
>>>>> +     case VDUSE_DEV_UPDATE_CONFIG: {
>>>>> +             struct vduse_config_update config;
>>>>> +             unsigned long size = offsetof(struct vduse_config_update,
>>>>> +                                           buffer);
>>>>> +
>>>>> +             ret = -EFAULT;
>>>>> +             if (copy_from_user(&config, argp, size))
>>>>> +                     break;
>>>>> +
>>>>> +             ret = -EINVAL;
>>>>> +             if (config.length == 0 ||
>>>>> +                 config.length > dev->config_size - config.offset)
>>>>> +                     break;
>>>>> +
>>>>> +             ret = -EFAULT;
>>>>> +             if (copy_from_user(dev->config + config.offset, argp + size,
>>>>> +                                config.length))
>>>>> +                     break;
>>>>> +
>>>>> +             ret = 0;
>>>>> +             queue_work(vduse_irq_wq, &dev->inject);
>>>> I wonder if it's better to separate config interrupt out of config
>>>> update or we need document this.
>>>>
>>> I have documented it in the docs. Looks like a config update should be
>>> always followed by a config interrupt. I didn't find a case that uses
>>> them separately.
>> The uAPI doesn't prevent us from the following scenario:
>>
>> update_config(mac[0], ..);
>> update_config(max[1], ..);
>>
>> So it looks to me it's better to separate the config interrupt from the
>> config updating.
>>
> Fine.
>
>>>>> +             break;
>>>>> +     }
>>>>> +     case VDUSE_VQ_GET_INFO: {
>>>> Do we need to limit this only when DRIVER_OK is set?
>>>>
>>> Any reason to add this limitation?
>> Otherwise the vq is not fully initialized, e.g the desc_addr might not
>> be correct.
>>
> The vq_info->ready can be used to tell userspace whether the vq is
> initialized or not.


Yes, this will work as well.

Thanks


>
> Thanks,
> Yongji
>

