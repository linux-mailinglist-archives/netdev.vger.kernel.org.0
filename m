Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 604FD3DFD06
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 10:35:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236613AbhHDIfO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 04:35:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51770 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236578AbhHDIfN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 04:35:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628066101;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pu0a7lvcVcx3k9JzblDeMR6k/r0nIYwunXvj5hzSi7c=;
        b=P1SjlsweYnvLF0tB/QE8F/TtAVcRRF0r51/PvG+gItXIZkbpDe5T4eF2ZC5aOJPz9r8OkP
        OquHcOJsloapc6SAgqxw6y4q+CjcEqiW9aVVPMLW2hCRzEduh1XZQ9BaEUbMpP5gOMpEtJ
        +dwpikt+H/2QJF9PXkELLt0YPbFdQDo=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-1-sL4WW8LDOGWSmyezGwTUZw-1; Wed, 04 Aug 2021 04:33:25 -0400
X-MC-Unique: sL4WW8LDOGWSmyezGwTUZw-1
Received: by mail-pl1-f197.google.com with SMTP id f9-20020a1709028609b0290128bcba6be7so1577948plo.18
        for <netdev@vger.kernel.org>; Wed, 04 Aug 2021 01:33:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=pu0a7lvcVcx3k9JzblDeMR6k/r0nIYwunXvj5hzSi7c=;
        b=T+0s+8LmnatsVklH4uzp4IR4O1kA9om07SKhazutzjEMtWFKvo1DtgtOJEYDDboBQQ
         VLwMxwGq35YPZeEnb/csKrxSa3MFi76rBkPNf7E2KrDMuLjzkrldwK5TvCixPHelPSet
         OQlwgE0+TEHG541vfA8Z89qloy87krSU5ZAqjm6qU6mzVPdwoTmRaAPxeX3mjXTNh9Yn
         3OmWFep5K32Fl6wUPcLInKz2HgZvYrVyFnPLsx26UPP5eTOd0s1AvVgcFcTeSI2BRcA5
         YPk9rdR13+AcLKhkk01w1brJ8zv7MTsusdR8BhNJ3FJvxc25ff6fGyxw2M5sSMzEPxS5
         1Eww==
X-Gm-Message-State: AOAM530TJcGgBXmePB1i91bQtaRCMwQpQg27k+S/fKSmsQwxI8GeucsB
        evDumdX+YXxXtxICRQoNcpJcNaQR3TlZXaojKTaeS8VqfilaerYgxpjsFewMVlTziZXo/+MbRCu
        hhti3MkWj4dnhfl4m
X-Received: by 2002:a17:90a:d910:: with SMTP id c16mr8668195pjv.62.1628066004065;
        Wed, 04 Aug 2021 01:33:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwGRA+b96dTvWH6rNF0GvUzAXXF5DIHsXTKRy/aLxqgmWgMfbwupx2NN3JsBxmvFmLwQEe/ug==
X-Received: by 2002:a17:90a:d910:: with SMTP id c16mr8668175pjv.62.1628066003910;
        Wed, 04 Aug 2021 01:33:23 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id i24sm1831736pfr.207.2021.08.04.01.33.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Aug 2021 01:33:23 -0700 (PDT)
Subject: Re: [PATCH v10 05/17] vhost-vdpa: Fail the vhost_vdpa_set_status() on
 reset failure
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
        Greg KH <gregkh@linuxfoundation.org>,
        He Zhe <zhe.he@windriver.com>,
        Liu Xiaodong <xiaodong.liu@intel.com>,
        Joe Perches <joe@perches.com>, songmuchun@bytedance.com,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <20210729073503.187-1-xieyongji@bytedance.com>
 <20210729073503.187-6-xieyongji@bytedance.com>
 <55191de0-1a03-ff0d-1a49-afc419014bab@redhat.com>
 <CACycT3sfiFizYQckHi5k4MpVpOOQCEwJhC-cToAnXaBVHTDPQQ@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <f9311396-c461-e14a-d24e-0f8cd6458a11@redhat.com>
Date:   Wed, 4 Aug 2021 16:33:14 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <CACycT3sfiFizYQckHi5k4MpVpOOQCEwJhC-cToAnXaBVHTDPQQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/8/3 下午5:50, Yongji Xie 写道:
> On Tue, Aug 3, 2021 at 4:10 PM Jason Wang <jasowang@redhat.com> wrote:
>>
>> 在 2021/7/29 下午3:34, Xie Yongji 写道:
>>> Re-read the device status to ensure it's set to zero during
>>> resetting. Otherwise, fail the vhost_vdpa_set_status() after timeout.
>>>
>>> Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
>>> ---
>>>    drivers/vhost/vdpa.c | 11 ++++++++++-
>>>    1 file changed, 10 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
>>> index b07aa161f7ad..dd05c1e1133c 100644
>>> --- a/drivers/vhost/vdpa.c
>>> +++ b/drivers/vhost/vdpa.c
>>> @@ -157,7 +157,7 @@ static long vhost_vdpa_set_status(struct vhost_vdpa *v, u8 __user *statusp)
>>>        struct vdpa_device *vdpa = v->vdpa;
>>>        const struct vdpa_config_ops *ops = vdpa->config;
>>>        u8 status, status_old;
>>> -     int nvqs = v->nvqs;
>>> +     int timeout = 0, nvqs = v->nvqs;
>>>        u16 i;
>>>
>>>        if (copy_from_user(&status, statusp, sizeof(status)))
>>> @@ -173,6 +173,15 @@ static long vhost_vdpa_set_status(struct vhost_vdpa *v, u8 __user *statusp)
>>>                return -EINVAL;
>>>
>>>        ops->set_status(vdpa, status);
>>> +     if (status == 0) {
>>> +             while (ops->get_status(vdpa)) {
>>> +                     timeout += 20;
>>> +                     if (timeout > VDPA_RESET_TIMEOUT_MS)
>>> +                             return -EIO;
>>> +
>>> +                     msleep(20);
>>> +             }
>>
>> Spec has introduced the reset a one of the basic facility. And consider
>> we differ reset here.
>>
>> This makes me think if it's better to introduce a dedicated vdpa ops for
>> reset?
>>
> Do you mean replace the ops.set_status(vdev, 0) with the ops.reset()?
> Then we can remove the timeout processing which is device specific
> stuff.


Exactly.

Thanks


>
> Thanks,
> Yongji
>

