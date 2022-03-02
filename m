Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C43024CAB35
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 18:11:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237685AbiCBRMG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 12:12:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243758AbiCBRLu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 12:11:50 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4667DCFB85
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 09:10:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646241056;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OCk0IGN+JSNCGOmZy65+tm/Nx0eAS27c5ZIr+XIGJxc=;
        b=CPiHdjBah7pYYTvbUbFy7mDSv6ERqwaSXj4sp6woAsFUNuVE64un2yDlqqXc2dpep549iM
        vwIJIRwJwHKcmkNxSfS+2VFJ2QupstpicHCHYgyjL7LgB3GeU6NjJCax+oLphTnS4EpXxO
        AYeeVFZk+za11p0PRBMM6mnRu5uebZs=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-441-IGv-INJUO8q91G_OEdDDHQ-1; Wed, 02 Mar 2022 12:10:55 -0500
X-MC-Unique: IGv-INJUO8q91G_OEdDDHQ-1
Received: by mail-wm1-f69.google.com with SMTP id c19-20020a05600c0ad300b00385bb3db625so520618wmr.4
        for <netdev@vger.kernel.org>; Wed, 02 Mar 2022 09:10:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OCk0IGN+JSNCGOmZy65+tm/Nx0eAS27c5ZIr+XIGJxc=;
        b=GYxZIwRKQ1Iv628XHcPEVtnNMdMukRjaU4u/fERKhZQTJJGcxrZg0S5aOImSrar+Cu
         xODlcT7Mbm5ux869zMPoaFdfvT+KZAM1xMAvLrYng3fnDK+XfxKEDLcArVMBCXiwYjhL
         INoJYN+aeLD5ztqlfvhz5QoSTomAaSPmvKYpUDmWf7aYglkK2W9qvJ2FsiHjcJ/RUCsU
         riTqGdwVG11u3Pm3Eae+wXgKTRJpeaentrUdf0PFGc5ctvNLkUhb4gY5yITr02o4cekD
         yErOUMpE1Mi2w3QU2AaYx71GqlS04458oifbF2KpGfXsyhxSMfdmM+WAIEFaWIeapyar
         eBbA==
X-Gm-Message-State: AOAM5302jXrElB8cjyoBNPfXhAzBGj0StFcgihVeMBgBnE55ivi2NyQv
        7RGvngmeJfIZ7OW1d7tzMqEu7cjy4i0Q7+oocdX5NH2OyjgeE+EBaXA+LZ58ZtIAv2CTko57rDb
        Oi7atY92M3bjvq8Vk
X-Received: by 2002:a5d:6b0f:0:b0:1e7:9432:ee8c with SMTP id v15-20020a5d6b0f000000b001e79432ee8cmr22844995wrw.216.1646241052249;
        Wed, 02 Mar 2022 09:10:52 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwdCmMTM9zLSI+LlHPZY7Qi9z6yOB/Nx9cLAFKLKH9IIrgIyZ3Z4qt7cBDrf7wigHlwXxKhVQ==
X-Received: by 2002:a5d:6b0f:0:b0:1e7:9432:ee8c with SMTP id v15-20020a5d6b0f000000b001e79432ee8cmr22844983wrw.216.1646241051946;
        Wed, 02 Mar 2022 09:10:51 -0800 (PST)
Received: from sgarzare-redhat (host-95-248-229-156.retail.telecomitalia.it. [95.248.229.156])
        by smtp.gmail.com with ESMTPSA id e20-20020adfa454000000b001f01a14dce8sm5579398wra.97.2022.03.02.09.10.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 09:10:51 -0800 (PST)
Date:   Wed, 2 Mar 2022 18:10:48 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        kernel list <linux-kernel@vger.kernel.org>,
        kvm <kvm@vger.kernel.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>, stable@vger.kernel.org,
        syzbot+adc3cb32385586bec859@syzkaller.appspotmail.com
Subject: Re: [PATCH 1/1] vhost: Protect the virtqueue from being cleared
 whilst still in use
Message-ID: <20220302171048.aijkcrwcrgsu475z@sgarzare-redhat>
References: <20220302075421.2131221-1-lee.jones@linaro.org>
 <20220302082021-mutt-send-email-mst@kernel.org>
 <Yh93k2ZKJBIYQJjp@google.com>
 <20220302095045-mutt-send-email-mst@kernel.org>
 <Yh+F1gkCGoYF2lMV@google.com>
 <CAGxU2F4cUDrMzoHH1NT5_ivxBPgEE8HOzP5s_Bt5JURRaSsLdQ@mail.gmail.com>
 <20220302112945-mutt-send-email-mst@kernel.org>
 <Yh+gDZUbgBRx/1ro@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <Yh+gDZUbgBRx/1ro@google.com>
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 02, 2022 at 04:49:17PM +0000, Lee Jones wrote:
>On Wed, 02 Mar 2022, Michael S. Tsirkin wrote:
>
>> On Wed, Mar 02, 2022 at 05:28:31PM +0100, Stefano Garzarella wrote:
>> > On Wed, Mar 2, 2022 at 3:57 PM Lee Jones <lee.jones@linaro.org> wrote:
>> > >
>> > > On Wed, 02 Mar 2022, Michael S. Tsirkin wrote:
>> > >
>> > > > On Wed, Mar 02, 2022 at 01:56:35PM +0000, Lee Jones wrote:
>> > > > > On Wed, 02 Mar 2022, Michael S. Tsirkin wrote:
>> > > > >
>> > > > > > On Wed, Mar 02, 2022 at 07:54:21AM +0000, Lee Jones wrote:
>> > > > > > > vhost_vsock_handle_tx_kick() already holds the mutex during its call
>> > > > > > > to vhost_get_vq_desc().  All we have to do is take the same lock
>> > > > > > > during virtqueue clean-up and we mitigate the reported issues.
>> > > > > > >
>> > > > > > > Link: https://syzkaller.appspot.com/bug?extid=279432d30d825e63ba00
>> > > > > > >
>> > > > > > > Cc: <stable@vger.kernel.org>
>> > > > > > > Reported-by: syzbot+adc3cb32385586bec859@syzkaller.appspotmail.com
>> > > > > > > Signed-off-by: Lee Jones <lee.jones@linaro.org>
>> > > > > > > ---
>> > > > > > >  drivers/vhost/vhost.c | 2 ++
>> > > > > > >  1 file changed, 2 insertions(+)
>> > > > > > >
>> > > > > > > diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
>> > > > > > > index 59edb5a1ffe28..bbaff6a5e21b8 100644
>> > > > > > > --- a/drivers/vhost/vhost.c
>> > > > > > > +++ b/drivers/vhost/vhost.c
>> > > > > > > @@ -693,6 +693,7 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
>> > > > > > >         int i;
>> > > > > > >
>> > > > > > >         for (i = 0; i < dev->nvqs; ++i) {
>> > > > > > > +               mutex_lock(&dev->vqs[i]->mutex);
>> > > > > > >                 if (dev->vqs[i]->error_ctx)
>> > > > > > >                         eventfd_ctx_put(dev->vqs[i]->error_ctx);
>> > > > > > >                 if (dev->vqs[i]->kick)
>> > > > > > > @@ -700,6 +701,7 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
>> > > > > > >                 if (dev->vqs[i]->call_ctx.ctx)
>> > > > > > >                         eventfd_ctx_put(dev->vqs[i]->call_ctx.ctx);
>> > > > > > >                 vhost_vq_reset(dev, dev->vqs[i]);
>> > > > > > > +               mutex_unlock(&dev->vqs[i]->mutex);
>> > > > > > >         }
>> > > > > >
>> > > > > > So this is a mitigation plan but the bug is still there though
>> > > > > > we don't know exactly what it is.  I would prefer adding something like
>> > > > > > WARN_ON(mutex_is_locked(vqs[i]->mutex) here - does this make sense?
>> > > > >
>> > > > > As a rework to this, or as a subsequent patch?
>> > > >
>> > > > Can be a separate patch.
>> > > >
>> > > > > Just before the first lock I assume?
>> > > >
>> > > > I guess so, yes.
>> > >
>> > > No problem.  Patch to follow.
>> > >
>> > > I'm also going to attempt to debug the root cause, but I'm new to this
>> > > subsystem to it might take a while for me to get my head around.
>> >
>> > IIUC the root cause should be the same as the one we solved here:
>> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=a58da53ffd70294ebea8ecd0eb45fd0d74add9f9
>> >
>> > The worker was not stopped before calling vhost_dev_cleanup(). So while
>> > the worker was still running we were going to free memory or initialize
>> > fields while it was still using virtqueue.
>>
>> Right, and I agree but it's not the root though, we do attempt to stop all workers.
>
>Exactly.  This is what happens, but the question I'm going to attempt
>to answer is *why* does this happen.

IIUC the worker was still running because the /dev/vhost-vsock file was 
not explicitly closed, so vhost_vsock_dev_release() was called in the 
do_exit() of the process.

In that case there was the issue, because vhost_dev_check_owner() 
returned false in vhost_vsock_stop() since current->mm was NULL.
So it returned earlier, without calling vhost_vq_set_backend(vq, NULL).

This did not stop the worker from continuing to run, causing the 
multiple issues we are seeing.

current->mm was NULL, because in the do_exit() the address space is 
cleaned in the exit_mm(), which is called before releasing the files 
into the exit_task_work().

This can be seen from the logs, where we see first the warnings printed 
by vhost_dev_cleanup() and then the panic in the worker (e.g. here 
https://syzkaller.appspot.com/text?tag=CrashLog&x=16a61fce700000)

Mike also added a few more helpful details in this thread: 
https://lore.kernel.org/virtualization/20220221100500.2x3s2sddqahgdfyt@sgarzare-redhat/T/#ree61316eac63245c9ba3050b44330e4034282cc2

Thanks,
Stefano

