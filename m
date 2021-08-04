Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C1D13DFCD2
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 10:28:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236320AbhHDI2L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 04:28:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:42586 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236354AbhHDI2K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 04:28:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628065677;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VzZ2fz11QFkhGxgNVXLaPyQv4vbgyLKy/JcMqXEwSCE=;
        b=G6m8oA3op9pu+76PZVZ8PHY/jWhpglbO+cAwI3S0z/PqxPFwTv9Yh8r2LfVlqWOgDH06C9
        lNbB9mQpPk0xLukYBxK6dOhlmCf/o+NX4XoHUl/j5GuS5ot+RyDfjnu6KNO3NzUz1XsQ1k
        KzJZDVxJTgj6V6k2lDzDLfMVBWj6Lj8=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-166-dOwo3b5uOJ2MPXdbM7IA0w-1; Wed, 04 Aug 2021 04:27:56 -0400
X-MC-Unique: dOwo3b5uOJ2MPXdbM7IA0w-1
Received: by mail-pj1-f72.google.com with SMTP id v9-20020a17090a7c09b02901778a2a8fd6so5799125pjf.3
        for <netdev@vger.kernel.org>; Wed, 04 Aug 2021 01:27:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=VzZ2fz11QFkhGxgNVXLaPyQv4vbgyLKy/JcMqXEwSCE=;
        b=M6Or7sVt2BYcRfl1vnMRAhu6K2DxTUj0mcv9SYatUwuG6MPzdbO70JGNRJHBlS/dWP
         TWbhW/id/dw3WLnXeNAJ/eqBQTK4JkgFWkqHa1kBjz1Zg8UZAtUtPfdDuxHgDVJEGC0m
         ljd6KbQaS26NkQVk0/CQTKRCapHi/rQ9zZPGt7WzyzsxBZBaMVc0yAKga8M5ZWH8omRN
         mrYksZc2WXPugfGTy2SXe1i4dy2kJjUNKoBv3PV3gtiLgoJshx7jGu1bei9nZGyUzCWh
         4a0FHAJzuT7cqFN9Vt48VyTzC2qwt20L+1U5O1EBVVUN3/xOw3+NrYmr5WXeFoRA2r4d
         GO/Q==
X-Gm-Message-State: AOAM533lY406yXzD81kJLgTCI6m9h6pS3hR4e29ApqepzDzLET6pqA2H
        hWkNW+h8FPNjKY+8bEGRuSApmmSDl7fJrMQuBFB444rACFO/KpIwSQMXwVvLeA0pANMp6bBxEg0
        jOXaiqj7ebosppr7y
X-Received: by 2002:a65:620a:: with SMTP id d10mr1146350pgv.120.1628065675419;
        Wed, 04 Aug 2021 01:27:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyXILAtwY28td6fRSflYoyigX2PjP4ZVbOPHaGCmnbiB1lEKAblvPX4KIAKHqSTrKqVGtkG2Q==
X-Received: by 2002:a65:620a:: with SMTP id d10mr1146334pgv.120.1628065675198;
        Wed, 04 Aug 2021 01:27:55 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id l2sm1714190pfc.157.2021.08.04.01.27.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Aug 2021 01:27:54 -0700 (PDT)
Subject: Re: [PATCH v10 02/17] file: Export receive_fd() to modules
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
 <20210729073503.187-3-xieyongji@bytedance.com>
 <a0ab081a-db06-6b7a-b22e-4ace96a5c7db@redhat.com>
 <CACycT3sdx8nA8fh3pjO_=pbiM+Bs5y+h4fuGkFQEsRSaBnph7Q@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <0a37dce4-0012-c2d1-bb06-5e9409815b93@redhat.com>
Date:   Wed, 4 Aug 2021 16:27:42 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <CACycT3sdx8nA8fh3pjO_=pbiM+Bs5y+h4fuGkFQEsRSaBnph7Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/8/3 下午5:01, Yongji Xie 写道:
> On Tue, Aug 3, 2021 at 3:46 PM Jason Wang <jasowang@redhat.com> wrote:
>>
>> 在 2021/7/29 下午3:34, Xie Yongji 写道:
>>> Export receive_fd() so that some modules can use
>>> it to pass file descriptor between processes without
>>> missing any security stuffs.
>>>
>>> Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
>>> ---
>>>    fs/file.c            | 6 ++++++
>>>    include/linux/file.h | 7 +++----
>>>    2 files changed, 9 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/fs/file.c b/fs/file.c
>>> index 86dc9956af32..210e540672aa 100644
>>> --- a/fs/file.c
>>> +++ b/fs/file.c
>>> @@ -1134,6 +1134,12 @@ int receive_fd_replace(int new_fd, struct file *file, unsigned int o_flags)
>>>        return new_fd;
>>>    }
>>>
>>> +int receive_fd(struct file *file, unsigned int o_flags)
>>> +{
>>> +     return __receive_fd(file, NULL, o_flags);
>>
>> Any reason that receive_fd_user() can live in the file.h?
>>
> Since no modules use it.
>
> Thanks,
> Yongji


Ok.


Acked-by: Jason Wang <jasowang@redhat.com>


>

