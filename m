Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFBEC6C8027
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 15:44:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231135AbjCXOoG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 10:44:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230117AbjCXOn7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 10:43:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2717EF9D
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 07:43:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679668987;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RTM4M2SNjA5FZsosnRIZjHnCRJF879F1P/kiqHZ5HjY=;
        b=Ze91IsQgJKaNp+kL1luaQJqcPGY+/dK0dY6oxqY+WP6o134kalcihoyoBLle5DjU+t6VLQ
        hc+Ii6GvC/Srx4H1iAu67XHQNmXgzXQE/PwRe+/BAwoiXWuVxdOhP7xHJfzF+563wVhIJC
        cpDoPKmcRz8J7LRVfHqk+6Cw+KxzzpQ=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-74-28-MxmOzPn2Rc5ezq68jwQ-1; Fri, 24 Mar 2023 10:43:06 -0400
X-MC-Unique: 28-MxmOzPn2Rc5ezq68jwQ-1
Received: by mail-ed1-f70.google.com with SMTP id t26-20020a50d71a000000b005003c5087caso3533793edi.1
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 07:43:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679668985;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RTM4M2SNjA5FZsosnRIZjHnCRJF879F1P/kiqHZ5HjY=;
        b=qnEvg7+updciErI4b/AWIBc0IQ+OLrm5IGWVKShUy6zDnbbBKg17/yNM/5lclWz+ws
         aVHkEg8O4pru0Ac8qfPsiGGq9wVzJ3b1n1ki1ikjQul/lYM9DYy7DtJ6Jqsl0TiMTKyj
         N3AJX6J1Y9dnt977h6xoBJmtrqxKF0fUp1F9mlbuzsbMJog1/mIMVDw7TK24kqLTjjaJ
         Owi+obUczJqZPV1hFTgBaOcdBZn7utmExvcno37Sew6cb/5HfWlmcMJu+UYJA4aZ6wms
         Y5FJmpS95p5cOVhOuIBsGhzCu7PKzHKof46lTQ1gSkSwgYFWb/kHlh6dgFij8lVjUgva
         edTw==
X-Gm-Message-State: AAQBX9ekWoov2/hfEp7wRJRvJQZkceVXlvwZ77TAloqqThlYHSIsV5NF
        he5xsjCKMPgtrYDFmik6TVYHeI8SbYpU2pi27yoaOTDsFBDkCgIeQFUnC18hFUvSk00FFy57Ijf
        PmHO97KRK9YrHI/6u
X-Received: by 2002:a17:906:74f:b0:933:3b2e:6016 with SMTP id z15-20020a170906074f00b009333b2e6016mr2817359ejb.7.1679668985385;
        Fri, 24 Mar 2023 07:43:05 -0700 (PDT)
X-Google-Smtp-Source: AKy350bH91Eohsmveeezt2qh6UzwwaDwrZKpjhh9RUKdgHpoMPxgzsZ/fiNdaDbea2Uje8vSwhq7VA==
X-Received: by 2002:a17:906:74f:b0:933:3b2e:6016 with SMTP id z15-20020a170906074f00b009333b2e6016mr2817346ejb.7.1679668985134;
        Fri, 24 Mar 2023 07:43:05 -0700 (PDT)
Received: from sgarzare-redhat (host-82-53-134-98.retail.telecomitalia.it. [82.53.134.98])
        by smtp.gmail.com with ESMTPSA id t7-20020a1709064f0700b008cda6560404sm10314573eju.193.2023.03.24.07.43.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Mar 2023 07:43:04 -0700 (PDT)
Date:   Fri, 24 Mar 2023 15:43:02 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        stefanha@redhat.com, linux-kernel@vger.kernel.org,
        eperezma@redhat.com, "Michael S. Tsirkin" <mst@redhat.com>,
        Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3 8/8] vdpa_sim: add support for user VA
Message-ID: <j6d2b5zqbb7rlrem76wopsabyy344wwnkbutvacebcig5fupnu@a2xkhywajwta>
References: <20230321154804.184577-1-sgarzare@redhat.com>
 <20230321154804.184577-4-sgarzare@redhat.com>
 <CACGkMEtbrt3zuqy9YdhNyE90HHUT1R=HF-YRAQ6b4KnW_SdZ-w@mail.gmail.com>
 <20230323095006.jvbbdjvkdvhzcehz@sgarzare-redhat>
 <CACGkMEveMGEzX7bCPuQuqm=9q7Ut-k=MLrRYM3Bq6cMpaw9fVQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACGkMEveMGEzX7bCPuQuqm=9q7Ut-k=MLrRYM3Bq6cMpaw9fVQ@mail.gmail.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 24, 2023 at 10:54:39AM +0800, Jason Wang wrote:
>On Thu, Mar 23, 2023 at 5:50 PM Stefano Garzarella <sgarzare@redhat.com> wrote:
>>
>> On Thu, Mar 23, 2023 at 11:42:07AM +0800, Jason Wang wrote:
>> >On Tue, Mar 21, 2023 at 11:48 PM Stefano Garzarella <sgarzare@redhat.com> wrote:
>> >>
>> >> The new "use_va" module parameter (default: true) is used in
>> >> vdpa_alloc_device() to inform the vDPA framework that the device
>> >> supports VA.
>> >>
>> >> vringh is initialized to use VA only when "use_va" is true and the
>> >> user's mm has been bound. So, only when the bus supports user VA
>> >> (e.g. vhost-vdpa).
>> >>
>> >> vdpasim_mm_work_fn work is used to serialize the binding to a new
>> >> address space when the .bind_mm callback is invoked, and unbinding
>> >> when the .unbind_mm callback is invoked.
>> >>
>> >> Call mmget_not_zero()/kthread_use_mm() inside the worker function
>> >> to pin the address space only as long as needed, following the
>> >> documentation of mmget() in include/linux/sched/mm.h:
>> >>
>> >>   * Never use this function to pin this address space for an
>> >>   * unbounded/indefinite amount of time.
>> >
>> >I wonder if everything would be simplified if we just allow the parent
>> >to advertise whether or not it requires the address space.
>> >
>> >Then when vhost-vDPA probes the device it can simply advertise
>> >use_work as true so vhost core can use get_task_mm() in this case?
>>
>> IIUC set user_worker to true, it also creates the kthread in the vhost
>> core (but we can add another variable to avoid this).
>>
>> My biggest concern is the comment in include/linux/sched/mm.h.
>> get_task_mm() uses mmget(), but in the documentation they advise against
>> pinning the address space indefinitely, so I preferred in keeping
>> mmgrab() in the vhost core, then call mmget_not_zero() in the worker
>> only when it is running.
>
>Ok.
>
>>
>> In the future maybe mm will be used differently from parent if somehow
>> it is supported by iommu, so I would leave it to the parent to handle
>> this.
>
>This should be possible, I was told by Intel that their IOMMU can
>access the process page table for shared virtual memory.

Cool, we should investigate this. Do you have any pointers to their
documentation?

Thanks,
Stefano

