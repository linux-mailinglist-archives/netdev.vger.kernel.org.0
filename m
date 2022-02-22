Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DD1A4BF45A
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 10:06:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229984AbiBVJG1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 04:06:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbiBVJG0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 04:06:26 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0AC071480FA
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 01:06:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645520760;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=n95hjcK3W4o+MmDITLyeBOBOgMA4dIl+GTEujgQXs3M=;
        b=X4ohnVg0UUit3fKyLCeWRAZBNQQxHm645lgOMEVX3rags7rjM2P1jeKyLniLEfr1RAFOBr
        i84jTlw6Fd66Aoon2kUMWITY7JJjLIX67YFVCscypJll0VXsFSp9HgNw0r6EJAOpv+k9e/
        ues9BJyZvwIFjIyIbKuVOEctuep52Mc=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-304-bfAOsdj2MZ2wI9Z88TJ5kw-1; Tue, 22 Feb 2022 04:05:58 -0500
X-MC-Unique: bfAOsdj2MZ2wI9Z88TJ5kw-1
Received: by mail-qk1-f199.google.com with SMTP id q5-20020a05620a0d8500b004738c1b48beso17085757qkl.7
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 01:05:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=n95hjcK3W4o+MmDITLyeBOBOgMA4dIl+GTEujgQXs3M=;
        b=MWNhocrEjNkQ3sTgflfc505P36jPzok00knWL7wGxVDwus6QqWB8Lqsnlvc+/jI7Ca
         l2bmOOywaCfh7o6sfJFLre5HJRU+5crN2aorYtc25xqlVnrEWwiJ0uzkYd/wEvyo8HzH
         kXGAu1073DG/L7Q2TF08tScL5+LHULljMKGMY4u8l8/4F2/O+P0R1UZa95aaEoJQGV4U
         t6uOuwUN0CmqntjXLTalEl68k8xOZiXUGOpprpfnCPS0TuWfy+5rm2XOqMcIas1hdCAN
         N3rgCZ7dt78Uhc72jn/cxR39Ntbr69o86RAGegXLEqrKs3Agtz+4GulkZY7HInZEVtWe
         sTZg==
X-Gm-Message-State: AOAM531exMMfk/c1zeVu8prpilenXcbJdEjjnvNKwFY3nNEcLENNdXUi
        6D8BNMXNfZtocK6C92VS2JEer3aJ82jeNVCV0YRHvfTAa6yvmWGaAIg9MXitReNHg0KOxQ22qkB
        CBnKfI23tVOxMRUYD
X-Received: by 2002:a05:620a:165b:b0:62c:ecc8:c795 with SMTP id c27-20020a05620a165b00b0062cecc8c795mr10836985qko.82.1645520758433;
        Tue, 22 Feb 2022 01:05:58 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwS9dXNMBTyZjFRzRaVicdBY9VjlIvSE10BjYtbw4zFc28c6qtGpYGes7034CgvhIY4gqaD/w==
X-Received: by 2002:a05:620a:165b:b0:62c:ecc8:c795 with SMTP id c27-20020a05620a165b00b0062cecc8c795mr10836977qko.82.1645520758216;
        Tue, 22 Feb 2022 01:05:58 -0800 (PST)
Received: from sgarzare-redhat (host-95-248-229-156.retail.telecomitalia.it. [95.248.229.156])
        by smtp.gmail.com with ESMTPSA id p66sm14199658qkf.12.2022.02.22.01.05.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Feb 2022 01:05:57 -0800 (PST)
Date:   Tue, 22 Feb 2022 10:05:50 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Anirudh Rayabharam <mail@anirudhrb.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        kernel list <linux-kernel@vger.kernel.org>,
        Mike Christie <michael.christie@oracle.com>,
        Jason Wang <jasowang@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        kvm <kvm@vger.kernel.org>, Hillf Danton <hdanton@sina.com>
Subject: Re: [PATCH] vhost/vsock: don't check owner in vhost_vsock_stop()
 while releasing
Message-ID: <20220222090550.5wokee4tfynr36jn@sgarzare-redhat>
References: <20220221114916.107045-1-sgarzare@redhat.com>
 <CAGxU2F6aMqTaNaeO7xChtf=veDJYtBjDRayRRYkZ_FOq4CYJWQ@mail.gmail.com>
 <YhO6bwu7iDtUFQGj@anirudhrb.com>
 <20220221164420.cnhs6sgxizc6tcok@sgarzare-redhat>
 <YhPT37ETuSfmxr5G@anirudhrb.com>
 <20220221182628.vy2bjntxnzqh7elj@sgarzare-redhat>
 <YhPprNUAqYS3RVtU@anirudhrb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <YhPprNUAqYS3RVtU@anirudhrb.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 22, 2022 at 01:06:12AM +0530, Anirudh Rayabharam wrote:
>On Mon, Feb 21, 2022 at 07:26:28PM +0100, Stefano Garzarella wrote:
>> On Mon, Feb 21, 2022 at 11:33:11PM +0530, Anirudh Rayabharam wrote:
>> > On Mon, Feb 21, 2022 at 05:44:20PM +0100, Stefano Garzarella wrote:
>> > > On Mon, Feb 21, 2022 at 09:44:39PM +0530, Anirudh Rayabharam wrote:
>> > > > On Mon, Feb 21, 2022 at 02:59:30PM +0100, Stefano Garzarella wrote:
>> > > > > On Mon, Feb 21, 2022 at 12:49 PM Stefano Garzarella <sgarzare@redhat.com> wrote:
>> > > > > >
>> > > > > > vhost_vsock_stop() calls vhost_dev_check_owner() to check the device
>> > > > > > ownership. It expects current->mm to be valid.
>> > > > > >
>> > > > > > vhost_vsock_stop() is also called by vhost_vsock_dev_release() when
>> > > > > > the user has not done close(), so when we are in do_exit(). In this
>> > > > > > case current->mm is invalid and we're releasing the device, so we
>> > > > > > should clean it anyway.
>> > > > > >
>> > > > > > Let's check the owner only when vhost_vsock_stop() is called
>> > > > > > by an ioctl.
>> > > > > >
>> > > > > > Fixes: 433fc58e6bf2 ("VSOCK: Introduce vhost_vsock.ko")
>> > > > > > Cc: stable@vger.kernel.org
>> > > > > > Reported-by: syzbot+1e3ea63db39f2b4440e0@syzkaller.appspotmail.com
>> > > > > > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
>> > > > > > ---
>> > > > > >  drivers/vhost/vsock.c | 14 ++++++++------
>> > > > > >  1 file changed, 8 insertions(+), 6 deletions(-)
>> > > > >
>> > > > > Reported-and-tested-by: syzbot+0abd373e2e50d704db87@syzkaller.appspotmail.com
>> > > >
>> > > > I don't think this patch fixes "INFO: task hung in vhost_work_dev_flush"
>> > > > even though syzbot says so. I am able to reproduce the issue locally
>> > > > even with this patch applied.
>> > >
>> > > Are you using the sysbot reproducer or another test?
>> > > In that case, can you share it?
>> >
>> > I am using the syzbot reproducer.
>> >
>> > >
>> > > From the stack trace it seemed to me that the worker accesses a zone that
>> > > has been cleaned (iotlb), so it is invalid and fails.
>> >
>> > Would the thread hang in that case? How?
>>
>> Looking at this log [1] it seems that the process is blocked on the
>> wait_for_completion() in vhost_work_dev_flush().
>>
>> Since we're not setting the backend to NULL to stop the worker, it's likely
>> that the worker will keep running, preventing the flush work from
>> completing.
>
>The log shows that the worker thread is stuck in iotlb_access_ok(). How
>will setting the backend to NULL stop it? During my debugging I found
>that the worker is stuck in this while loop:

Okay, looking at your new patch, now I see. If we enter in this loop 
before setting the backend to NULL and we have start = 0 and end = (u64) 
-1 , we should be there forever.

I'll remove that tag in v2, but the test might fail without this patch 
applied, because for now we don't stop workers correctly.

Thanks,
Stefano

