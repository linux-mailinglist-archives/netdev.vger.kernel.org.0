Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE0D74BEA95
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 20:36:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231414AbiBUS1s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 13:27:48 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230155AbiBUS1B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 13:27:01 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 36B10C7E
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 10:26:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645467997;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JZ5IPvV3yb/nAnNH+aq40HHCb2PtQ6O64EyaH6AnGYs=;
        b=TLMp94cimxeF0eLYgW26lJxFD4EWeXxAIHhD9qxtBo29cuTtnaXqEcl5wCiQjzbE5vsAlB
        bnOqlQImT8KDOhllC+JFbNQn1AQJZD8athJWGY3xD+vC/1Q0jO6rPnja+EtntxKpK6ZAUo
        jlLAOnPjY1kJg6jw1EKzyoJCaNw+mog=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-658-rkYvXc2OPaG4Uo9xcW9umA-1; Mon, 21 Feb 2022 13:26:35 -0500
X-MC-Unique: rkYvXc2OPaG4Uo9xcW9umA-1
Received: by mail-qk1-f197.google.com with SMTP id 2-20020a370a02000000b0060df1ac78baso11145215qkk.20
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 10:26:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JZ5IPvV3yb/nAnNH+aq40HHCb2PtQ6O64EyaH6AnGYs=;
        b=yYQcXLf9sqQiWQqUBx2orLwwNpewtGwro7+g7JUeD5+63924b1KY7/THsDO/kKjQ6J
         rOlF9Rs+FtCulHMDBsKliZAt3xujTzDsWHx8KazP1f2CBoZXg8EmryaKhTmzNZxN5YHw
         Fm68N57H9GggAen8HOuG54ZeUZ3ik/9Ng+fHAYI2FpdJ+Nd9RbRiwMuUh03Nyngd5t8w
         LCXjcz4F81itOOvR6M2uAKVpAkLmi4NetHF/REHaCerulhc9UO2CpOt4bFOZXw1Y84Dq
         XbQCN3f+Iv4GaJpApD8q2nUbUN0DaCm2oqS/MgjfUG5aaU5oETU3J1B21yHhtL6uCEV3
         Q9fw==
X-Gm-Message-State: AOAM532QEUeG9lq8buGYTnYyHsuHPxeje45UlDztZRSiSICmpE6+UHbj
        MPplI4vrLinlK82KWcjXLs0hQi9Zj9BAS/vwEAPaqqBJs980KJMAr4FhHNT9vZ+raHfErrLWO7e
        CI/pOETCPo4M2zlle
X-Received: by 2002:a37:424a:0:b0:47c:cdc:ce63 with SMTP id p71-20020a37424a000000b0047c0cdcce63mr12938106qka.530.1645467994998;
        Mon, 21 Feb 2022 10:26:34 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx4Os+URRdB/SGPRTo0xBKVVbUYwpunZIvTXStuObgWhuvPS2PN1PoD2ZEPNCiFy8upFn3MwQ==
X-Received: by 2002:a37:424a:0:b0:47c:cdc:ce63 with SMTP id p71-20020a37424a000000b0047c0cdcce63mr12938089qka.530.1645467994703;
        Mon, 21 Feb 2022 10:26:34 -0800 (PST)
Received: from sgarzare-redhat (host-95-248-229-156.retail.telecomitalia.it. [95.248.229.156])
        by smtp.gmail.com with ESMTPSA id c12sm832212qtd.45.2022.02.21.10.26.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Feb 2022 10:26:34 -0800 (PST)
Date:   Mon, 21 Feb 2022 19:26:28 +0100
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
Message-ID: <20220221182628.vy2bjntxnzqh7elj@sgarzare-redhat>
References: <20220221114916.107045-1-sgarzare@redhat.com>
 <CAGxU2F6aMqTaNaeO7xChtf=veDJYtBjDRayRRYkZ_FOq4CYJWQ@mail.gmail.com>
 <YhO6bwu7iDtUFQGj@anirudhrb.com>
 <20220221164420.cnhs6sgxizc6tcok@sgarzare-redhat>
 <YhPT37ETuSfmxr5G@anirudhrb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <YhPT37ETuSfmxr5G@anirudhrb.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 21, 2022 at 11:33:11PM +0530, Anirudh Rayabharam wrote:
>On Mon, Feb 21, 2022 at 05:44:20PM +0100, Stefano Garzarella wrote:
>> On Mon, Feb 21, 2022 at 09:44:39PM +0530, Anirudh Rayabharam wrote:
>> > On Mon, Feb 21, 2022 at 02:59:30PM +0100, Stefano Garzarella wrote:
>> > > On Mon, Feb 21, 2022 at 12:49 PM Stefano Garzarella <sgarzare@redhat.com> wrote:
>> > > >
>> > > > vhost_vsock_stop() calls vhost_dev_check_owner() to check the device
>> > > > ownership. It expects current->mm to be valid.
>> > > >
>> > > > vhost_vsock_stop() is also called by vhost_vsock_dev_release() when
>> > > > the user has not done close(), so when we are in do_exit(). In this
>> > > > case current->mm is invalid and we're releasing the device, so we
>> > > > should clean it anyway.
>> > > >
>> > > > Let's check the owner only when vhost_vsock_stop() is called
>> > > > by an ioctl.
>> > > >
>> > > > Fixes: 433fc58e6bf2 ("VSOCK: Introduce vhost_vsock.ko")
>> > > > Cc: stable@vger.kernel.org
>> > > > Reported-by: syzbot+1e3ea63db39f2b4440e0@syzkaller.appspotmail.com
>> > > > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
>> > > > ---
>> > > >  drivers/vhost/vsock.c | 14 ++++++++------
>> > > >  1 file changed, 8 insertions(+), 6 deletions(-)
>> > >
>> > > Reported-and-tested-by: syzbot+0abd373e2e50d704db87@syzkaller.appspotmail.com
>> >
>> > I don't think this patch fixes "INFO: task hung in vhost_work_dev_flush"
>> > even though syzbot says so. I am able to reproduce the issue locally
>> > even with this patch applied.
>>
>> Are you using the sysbot reproducer or another test?
>> In that case, can you share it?
>
>I am using the syzbot reproducer.
>
>>
>> From the stack trace it seemed to me that the worker accesses a zone that
>> has been cleaned (iotlb), so it is invalid and fails.
>
>Would the thread hang in that case? How?

Looking at this log [1] it seems that the process is blocked on the 
wait_for_completion() in vhost_work_dev_flush().

Since we're not setting the backend to NULL to stop the worker, it's 
likely that the worker will keep running, preventing the flush work from 
completing.

[1] https://syzkaller.appspot.com/text?tag=CrashLog&x=153f0852700000

