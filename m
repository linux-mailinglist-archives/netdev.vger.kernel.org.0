Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDE9C4B9C75
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 10:50:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238835AbiBQJso (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 04:48:44 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238003AbiBQJsn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 04:48:43 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A36A917AA7
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 01:48:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645091308;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Xxe0ytJzju6g3/HrW8yGRlI4FlDzlNM0zVQgVVP7siY=;
        b=SSjaqnOGtQgIpq23m6U7e+ztk+zYaB5KIOo8HDOybLH9ji9Uwg/ZLb9/ps+KmDcDsE+KTX
        frZbb8ndgTw9z3bPnPdK4GM/t5ruVVM4hSCPEXo8ZBeqK+jqz1HSzgUsSKV3ie9Da3v+gw
        WtiB1LblXDWElYU6Peq/RQjCwJBiMVI=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-612-R8QsqJuDNUyuEx8qFr8J6w-1; Thu, 17 Feb 2022 04:48:27 -0500
X-MC-Unique: R8QsqJuDNUyuEx8qFr8J6w-1
Received: by mail-qv1-f72.google.com with SMTP id t5-20020a056214118500b0042c272ede45so4679897qvv.13
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 01:48:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Xxe0ytJzju6g3/HrW8yGRlI4FlDzlNM0zVQgVVP7siY=;
        b=6sE1LB5/z+OcrApkA9wfeDcmKIYccQbE6n7B17THoc46/2tbrzX5l9xoN3GfDO2Whf
         D2iPwrKSzpXF3sgPmVYWIh7OfjNzAkfteFzI+MTQhJs4RsezGnIfrRr9U1MTefmoPsIz
         nxGITuhsCnJ4zMy2k7XEneq1oN7bkInymaZz10CQFOYflHfKdT02CPpTy0EqLWiR8lFO
         oZaGpM5ksWmrT+gYUs1ro66a5v3i3D3Tui5hPm5F5Lp9Um7gZJVKn4Bv9q/kFD7ysDAv
         MzW3zfH5tyqt8LwAywQCRpib/cVb3mu9CPpm1j3tzCG9qZZbqls2anPb0kiMfMbkQLkt
         gNQg==
X-Gm-Message-State: AOAM530jd4gDCKrQ79Ao3VmlAnVcxYsTTBlqiiP/7iIRZdmMETFeq8x2
        IZARVPMZvl41MmgBeaQkvpvXWocFPAGRbmh0uJEi0Llp0olI/eRRFgxZrXxtp5inTdGmOXXuJlo
        WuN1trHo7iq6WmBhh
X-Received: by 2002:ac8:57cc:0:b0:2cf:51a9:df93 with SMTP id w12-20020ac857cc000000b002cf51a9df93mr1616157qta.166.1645091307079;
        Thu, 17 Feb 2022 01:48:27 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxJx9ng4NIvyX79q9z7uy2yyP8m7uhEbaPwsePA5VEK9FDTJGfyzyq+NNAAp3Ge6dJX82YMmw==
X-Received: by 2002:ac8:57cc:0:b0:2cf:51a9:df93 with SMTP id w12-20020ac857cc000000b002cf51a9df93mr1616146qta.166.1645091306827;
        Thu, 17 Feb 2022 01:48:26 -0800 (PST)
Received: from sgarzare-redhat (host-95-248-229-156.retail.telecomitalia.it. [95.248.229.156])
        by smtp.gmail.com with ESMTPSA id k4sm22499788qta.6.2022.02.17.01.48.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Feb 2022 01:48:26 -0800 (PST)
Date:   Thu, 17 Feb 2022 10:48:18 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        syzbot <syzbot+1e3ea63db39f2b4440e0@syzkaller.appspotmail.com>,
        kvm <kvm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, syzkaller-bugs@googlegroups.com,
        virtualization <virtualization@lists.linux-foundation.org>,
        Stefan Hajnoczi <stefanha@redhat.com>
Subject: Re: [syzbot] WARNING in vhost_dev_cleanup (2)
Message-ID: <CAGxU2F7CjNu5Wxg3k1hQF8A8uRt-wKLjMW6TMjb+UVCF+MHZbw@mail.gmail.com>
References: <0000000000006f656005d82d24e2@google.com>
 <CACGkMEsyWBBmx3g613tr97nidHd3-avMyO=WRxS8RpcEk7j2=A@mail.gmail.com>
 <20220217023550-mutt-send-email-mst@kernel.org>
 <CACGkMEtuL_4eRYYWd4aQj6rG=cJDQjjr86DWpid3o_N-6xvTWQ@mail.gmail.com>
 <20220217024359-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220217024359-mutt-send-email-mst@kernel.org>
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Thu, Feb 17, 2022 at 8:50 AM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Thu, Feb 17, 2022 at 03:39:48PM +0800, Jason Wang wrote:
> > On Thu, Feb 17, 2022 at 3:36 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > >
> > > On Thu, Feb 17, 2022 at 03:34:13PM +0800, Jason Wang wrote:
> > > > On Thu, Feb 17, 2022 at 10:01 AM syzbot
> > > > <syzbot+1e3ea63db39f2b4440e0@syzkaller.appspotmail.com> wrote:
> > > > >
> > > > > Hello,
> > > > >
> > > > > syzbot found the following issue on:
> > > > >
> > > > > HEAD commit:    c5d9ae265b10 Merge tag 'for-linus' of git://git.kernel.org..
> > > > > git tree:       upstream
> > > > > console output: https://syzkaller.appspot.com/x/log.txt?x=132e687c700000
> > > > > kernel config:  https://syzkaller.appspot.com/x/.config?x=a78b064590b9f912
> > > > > dashboard link: https://syzkaller.appspot.com/bug?extid=1e3ea63db39f2b4440e0
> > > > > compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> > > > >
> > > > > Unfortunately, I don't have any reproducer for this issue yet.
> > > > >
> > > > > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > > > > Reported-by: syzbot+1e3ea63db39f2b4440e0@syzkaller.appspotmail.com
> > > > >
> > > > > WARNING: CPU: 1 PID: 10828 at drivers/vhost/vhost.c:715 vhost_dev_cleanup+0x8b8/0xbc0 drivers/vhost/vhost.c:715
> > > > > Modules linked in:
> > > > > CPU: 0 PID: 10828 Comm: syz-executor.0 Not tainted 5.17.0-rc4-syzkaller-00051-gc5d9ae265b10 #0
> > > > > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> > > > > RIP: 0010:vhost_dev_cleanup+0x8b8/0xbc0 drivers/vhost/vhost.c:715
> > > >
> > > > Probably a hint that we are missing a flush.
> > > >
> > > > Looking at vhost_vsock_stop() that is called by vhost_vsock_dev_release():
> > > >
> > > > static int vhost_vsock_stop(struct vhost_vsock *vsock)
> > > > {
> > > > size_t i;
> > > >         int ret;
> > > >
> > > >         mutex_lock(&vsock->dev.mutex);
> > > >
> > > >         ret = vhost_dev_check_owner(&vsock->dev);
> > > >         if (ret)
> > > >                 goto err;
> > > >
> > > > Where it could fail so the device is not actually stopped.
> > > >
> > > > I wonder if this is something related.
> > > >
> > > > Thanks
> > >
> > >
> > > But then if that is not the owner then no work should be running, right?
> >
> > Could it be a buggy user space that passes the fd to another process
> > and changes the owner just before the mutex_lock() above?
> >
> > Thanks
>
> Maybe, but can you be a bit more explicit? what is the set of
> conditions you see that can lead to this?

I think the issue could be in the vhost_vsock_stop() as Jason mentioned, 
but not related to fd passing, but related to the do_exit() function.

Looking the stack trace, we are in exit_task_work(), that is called 
after exit_mm(), so the vhost_dev_check_owner() can fail because 
current->mm should be NULL at that point.

It seems the fput work is queued by fput_many() in a worker queue, and 
in some cases (maybe a lot of files opened?) the work is still queued 
when we enter in do_exit().

That said, I don't know if we can simply remove that check in 
vhost_vsock_stop(), or check if current->mm is NULL, to understand if 
the process is exiting.

Stefano

