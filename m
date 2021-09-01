Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A612A3FD186
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 04:52:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241773AbhIACxB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 22:53:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37626 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241756AbhIACxA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 22:53:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630464723;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=22daRUQV9U4yr6Wt0e3afK9IF5RqMvZ3yQMarWKzKaw=;
        b=JxkWfQ7EGfdRby2Hd9j56rPsXil9S4cm2C3FAZXX5OO7cUDSxFTYinqBbb3iSpD6TdXSJT
        6PrikPnEDTcBMAOb1V26OPOx1bsNDR+/Rg4qYR1bHBBiYO3xsUrVrBd9lpGTuUWxbipX6o
        bPgZ3hpHWHlyTA3A+VvZuKPecQT/dm4=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-413-v60ti7wPMrWtJu71fqIiIg-1; Tue, 31 Aug 2021 22:52:02 -0400
X-MC-Unique: v60ti7wPMrWtJu71fqIiIg-1
Received: by mail-pf1-f198.google.com with SMTP id o130-20020a62cd88000000b004053c6c1765so656166pfg.6
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 19:52:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=22daRUQV9U4yr6Wt0e3afK9IF5RqMvZ3yQMarWKzKaw=;
        b=VraBiEX2UhD5vh5Wi5P/fwAWQG4j0hoyePKSVJX45LM2R/DQb2364xMGybeyAIl8Bk
         jZuX1vWr9R6ayXzGhdSGM6+/WJVs+cB5cOkDvcYnMbZkdaEBNNmXbJyf/a8MLmwxfHZE
         Z5loHbGaUMKrrm5DHYnbaRcDPaYaFTUQaKfMvFFpx22LxZB2IU6vAwLkFiS0g4P4mDsF
         mT2zUybmCJZM8nIXeywtohGZ4BgP56GJ12JxVg4PNQ4+adtF1lCfLGn9nDZVm4uhePrt
         0DecB1Y60LJENzL9ZgkQJ1OfUDMxekZ8E3TBdMkkhNAMeK65trIA1Il2DUAbE6/tQmRF
         IWig==
X-Gm-Message-State: AOAM533t+rwWoJ+cwd1Dcan49KJY2FuKxU0Vss3BH9m5DMeZbe3sdEOa
        4AFbbbveeOtkb3AgoaNbFx8M4W6aEIEHLd2HcYIxt9lsVX3c4/45neO9IsbANx1+9Aw3IIWFmbQ
        Rf5JahTvS7HjWqryf
X-Received: by 2002:a17:902:ea89:b0:134:7eb7:b4d7 with SMTP id x9-20020a170902ea8900b001347eb7b4d7mr7633975plb.43.1630464721016;
        Tue, 31 Aug 2021 19:52:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwTWS6gU6vtbRqrdbv/Yqpra3725hn41k3JbwUi9Z5AqTrEe2L3d1WI2eNmIrtm6tnQdkeYWQ==
X-Received: by 2002:a17:902:ea89:b0:134:7eb7:b4d7 with SMTP id x9-20020a170902ea8900b001347eb7b4d7mr7633932plb.43.1630464720692;
        Tue, 31 Aug 2021 19:52:00 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b7sm19703920pgs.64.2021.08.31.19.51.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Aug 2021 19:51:59 -0700 (PDT)
Subject: Re: [PATCH v13 02/13] eventfd: Export eventfd_wake_count to modules
To:     Xie Yongji <xieyongji@bytedance.com>, mst@redhat.com,
        stefanha@redhat.com, sgarzare@redhat.com, parav@nvidia.com,
        hch@infradead.org, christian.brauner@canonical.com,
        rdunlap@infradead.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, axboe@kernel.dk, bcrl@kvack.org,
        corbet@lwn.net, mika.penttila@nextfour.com,
        dan.carpenter@oracle.com, joro@8bytes.org,
        gregkh@linuxfoundation.org, zhe.he@windriver.com,
        xiaodong.liu@intel.com, joe@perches.com, robin.murphy@arm.com,
        will@kernel.org, john.garry@huawei.com
Cc:     songmuchun@bytedance.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <20210831103634.33-1-xieyongji@bytedance.com>
 <20210831103634.33-3-xieyongji@bytedance.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <0e486c0a-0055-e698-ffd2-31c4b75dae5d@redhat.com>
Date:   Wed, 1 Sep 2021 10:50:40 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210831103634.33-3-xieyongji@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/8/31 下午6:36, Xie Yongji 写道:
> Export eventfd_wake_count so that some modules can use
> the eventfd_signal_count() to check whether the
> eventfd_signal() call should be deferred to a safe context.
>
> Signed-off-by: Xie Yongji <xieyongji@bytedance.com>


And this matches the comment inside eventfd_signal():

         /*
          * Deadlock or stack overflow issues can happen if we recurse here
          * through waitqueue wakeup handlers. If the caller users 
potentially
          * nested waitqueues with custom wakeup handlers, then it should
          * check eventfd_signal_count() before calling this function. If
          * it returns true, the eventfd_signal() call should be 
deferred to a
          * safe context.
          */


So:

Acked-by: Jason Wang <jasowang@redhat.com>


> ---
>   fs/eventfd.c | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/fs/eventfd.c b/fs/eventfd.c
> index e265b6dd4f34..1b3130b8d6c1 100644
> --- a/fs/eventfd.c
> +++ b/fs/eventfd.c
> @@ -26,6 +26,7 @@
>   #include <linux/uio.h>
>   
>   DEFINE_PER_CPU(int, eventfd_wake_count);
> +EXPORT_PER_CPU_SYMBOL_GPL(eventfd_wake_count);
>   
>   static DEFINE_IDA(eventfd_ida);
>   

