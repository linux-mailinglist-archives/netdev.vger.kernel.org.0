Return-Path: <netdev+bounces-6487-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 607D1716904
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 18:17:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 021E81C20C8E
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 16:17:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EEE82771D;
	Tue, 30 May 2023 16:17:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D38623C6F
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 16:17:20 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05B3D129
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 09:17:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685463429;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PXXxKnRvMOF+CPjYfKEygZupqtBPL6uEzDsFClnEJ3U=;
	b=C5wNAiPFXA7UtY2pAWpww432dIslgBKVGA+phkhQEquiVH4WB5WwqdsQuxCARpWdKhZgxR
	13NMjit3K6zJj4K3IqhEQVFOeyYt/MNvkKM1lUTVsk3Vy+WIuJDQGczbxWkmvNvNLgbZ5P
	LlnQMqmTCsOB/Q30GFIAQgsxciPapNM=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-615-UPKcOew-OCSSk23OQlXIzQ-1; Tue, 30 May 2023 12:17:07 -0400
X-MC-Unique: UPKcOew-OCSSk23OQlXIzQ-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-3f6f2f18ecbso16242625e9.0
        for <netdev@vger.kernel.org>; Tue, 30 May 2023 09:17:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685463426; x=1688055426;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PXXxKnRvMOF+CPjYfKEygZupqtBPL6uEzDsFClnEJ3U=;
        b=PH1DYZwXnYuCSoRHfYUfgYFJ1p97TCfX0RZd2ja/fqGVPuRrAys+4lBxYqwCq/AuNd
         BO7vy3sst39FF2+ICodXGANKROmKcn6F0lJT6KgYbMyqrTb2dVtK9BT0RPT40hfivXtC
         SeMjgK9pYSL7TQFnHe/pqE27xxP/7gYrMcuywjdLAWzrZEJEcKv8g1EGDu0vvZPoieTA
         evxbacDMbIV3kJu3S5V9YPA7/hlewMjnI/tCr6G1PpOTcBeGksS+IakUonhe7e5IEU5z
         f+WtT6dcNEqBGnwR2YtFvNHi96R32YROaRQJBV/570Kg0fLRTA8DH11vNE4he5jwIniC
         HYLQ==
X-Gm-Message-State: AC+VfDzoHd8O/LMMHo6GqjDc9t8NOIkEX2YFACD77d1AzYEB9yA7AZbS
	Ndhg2IjPf3qgagvera/lM0INMInS5t+Qe3lqInuOE0q9Bme7iyBjts54lqMgnUz0LOhsk/jjQrR
	6/rer8kS1WANHM2cV
X-Received: by 2002:a05:600c:3787:b0:3f6:1e6:d5a2 with SMTP id o7-20020a05600c378700b003f601e6d5a2mr1912250wmr.4.1685463426375;
        Tue, 30 May 2023 09:17:06 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6JJkBsRON0rkAHj+JwffsCltg3bPYMz+mQckZWzt5fCsTTE3DG9uwIij60afTolUjor/lsmQ==
X-Received: by 2002:a05:600c:3787:b0:3f6:1e6:d5a2 with SMTP id o7-20020a05600c378700b003f601e6d5a2mr1912237wmr.4.1685463426114;
        Tue, 30 May 2023 09:17:06 -0700 (PDT)
Received: from sgarzare-redhat (host-87-12-25-16.business.telecomitalia.it. [87.12.25.16])
        by smtp.gmail.com with ESMTPSA id f10-20020a7bc8ca000000b003f42ceb3bf4sm17673875wml.32.2023.05.30.09.17.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 May 2023 09:17:05 -0700 (PDT)
Date: Tue, 30 May 2023 18:17:00 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Mike Christie <michael.christie@oracle.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, 
	syzbot <syzbot+d0d442c22fa8db45ff0e@syzkaller.appspotmail.com>, jasowang@redhat.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com, 
	virtualization@lists.linux-foundation.org, stefanha@redhat.com
Subject: Re: [syzbot] [kvm?] [net?] [virt?] general protection fault in
 vhost_work_queue
Message-ID: <6p7pi6mf3db3gp3xqarap4uzrgwlzqiz7wgg5kn2ep7hvrw5pg@wxowhbw4e7w7>
References: <0000000000001777f605fce42c5f@google.com>
 <20230530072310-mutt-send-email-mst@kernel.org>
 <CAGxU2F7O7ef3mdvNXtiC0VtWiS2DMnoiGwSR=Z6SWbzqcrBF-g@mail.gmail.com>
 <CAGxU2F7HK5KRggiY7xnKHeXFRXJmqcKbjf3JnXC3mbmn9xqRtw@mail.gmail.com>
 <e4589879-1139-22cc-854f-fed22cc18693@oracle.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <e4589879-1139-22cc-854f-fed22cc18693@oracle.com>
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 30, 2023 at 11:09:09AM -0500, Mike Christie wrote:
>On 5/30/23 11:00 AM, Stefano Garzarella wrote:
>> I think it is partially related to commit 6e890c5d5021 ("vhost: use
>> vhost_tasks for worker threads") and commit 1a5f8090c6de ("vhost: move
>> worker thread fields to new struct"). Maybe that commits just
>> highlighted the issue and it was already existing.
>
>See my mail about the crash. Agree with your analysis about worker->vtsk
>not being set yet. It's a bug from my commit where I should have not set
>it so early or I should be checking for
>
>if (dev->worker && worker->vtsk)
>
>instead of
>
>if (dev->worker)

Yes, though, in my opinion the problem may persist depending on how the
instructions are reordered.

Should we protect dev->worker() with an RCU to be safe?

>
>One question about the behavior before my commit though and what we want in
>the end going forward. Before that patch we would just drop work if
>vhost_work_queue was called before VHOST_SET_OWNER. Was that correct/expected?

I think so, since we ask the guest to call VHOST_SET_OWNER, before any
other command.

>
>The call to vhost_work_queue in vhost_vsock_start was only seeing the
>works queued after VHOST_SET_OWNER. Did you want works queued before that?
>

Yes, for example if an application in the host has tried to connect and
is waiting for a timeout, we already have work queued up to flush as
soon as we start the device. (See commit 0b841030625c ("vhost: vsock:
kick send_pkt worker once device is started")).

Thanks,
Stefano


