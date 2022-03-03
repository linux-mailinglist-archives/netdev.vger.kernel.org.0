Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 089CE4CBFD1
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 15:17:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233850AbiCCOSA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 09:18:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233966AbiCCOR7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 09:17:59 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B18218CC74
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 06:17:12 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id j17so8140858wrc.0
        for <netdev@vger.kernel.org>; Thu, 03 Mar 2022 06:17:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=o87FE1s1Wm0goe8u+iMFz3QFDTGxpEfcNIHyIf4cYXc=;
        b=qjtp5qx/MAS7oqOrzTmksFxlCuVhzhNjct9+cVdZJ0lL6LcvKJpYIbhjcbFQ5y9Sev
         DocA3PoxsiNIlDGie3zqTL7+3cZqizI67vE9M6VfGzSXMuNeAvca61E1ggaYqv9zQFqL
         fJODUuKt9vY9USIyyVUP20Kqq0V7c19LkZlvs7UwQ2NN5XFi/YawqJef+7uk3L9avGAN
         U+tVGYNR/FGSTKHT61X9VJIZzSU+SKbQpPqMelLVGiYbB9c5AR28XhyRDVus0xBAcPmJ
         6FreKTdHUZke8zDVjWjeeEE8ttpNaGeilOikSatq/h4i7sbml9cna2lWaV+MvgXYz04K
         Bjfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=o87FE1s1Wm0goe8u+iMFz3QFDTGxpEfcNIHyIf4cYXc=;
        b=XLsIVumaBEMR1RZIU3xdAthRkuAfyxLtd304nnFnJn+R6C22vZtFpMbnZ4y7EY1txq
         t160Bjin6Oi6UBcQ8nMOF1ZfHRiv+CmCUdGi9YgkiVx2YTSB9bUc6i3BYG7pssA+uDHj
         9SSVlmS1cqcO0pwlvbaghTJmHjik+yT364BKpNIYelBJ3WKC+Kz8Cu7VDBlbuoKTjSoo
         agbaiFyIyGNYsq4QzPvDmrp1+TvIdDAs4qblBGeU3b4XsoZcdGSjDWsbqoXe7BMCycf8
         CKfU7m8/sN4GKbiu/YX/DN32TGVEi4i+nesjsxCB7xryhgSnmEi1cR1A3/kMLgL+A3yw
         hLCw==
X-Gm-Message-State: AOAM531SJ5bIFXhraRWC8uRsJBfFLlhJ0WzoC15usJVyRKTFLijMItD5
        Cfv2lnFMBSlLQRHcMzUfaiw3Tw==
X-Google-Smtp-Source: ABdhPJxGby9qFrKdJzMjz97SEhrdFbTgsA5JiONah34Fa2/z0rLBVsD2gF8PbtEBkulh+SvN06cb+A==
X-Received: by 2002:adf:edc4:0:b0:1ee:27de:4b04 with SMTP id v4-20020adfedc4000000b001ee27de4b04mr25622352wro.117.1646317030825;
        Thu, 03 Mar 2022 06:17:10 -0800 (PST)
Received: from google.com (cpc155339-bagu17-2-0-cust87.1-3.cable.virginm.net. [86.27.177.88])
        by smtp.gmail.com with ESMTPSA id z6-20020a1cf406000000b0037c4e2d3baesm9037338wma.19.2022.03.03.06.17.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 06:17:10 -0800 (PST)
Date:   Thu, 3 Mar 2022 14:17:07 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        kernel list <linux-kernel@vger.kernel.org>,
        kvm <kvm@vger.kernel.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>, stable@vger.kernel.org,
        syzbot+adc3cb32385586bec859@syzkaller.appspotmail.com
Subject: Re: [PATCH 1/1] vhost: Protect the virtqueue from being cleared
 whilst still in use
Message-ID: <YiDN4xpb1+8k5K5/@google.com>
References: <20220302075421.2131221-1-lee.jones@linaro.org>
 <20220302082021-mutt-send-email-mst@kernel.org>
 <Yh93k2ZKJBIYQJjp@google.com>
 <20220302095045-mutt-send-email-mst@kernel.org>
 <Yh+F1gkCGoYF2lMV@google.com>
 <CAGxU2F4cUDrMzoHH1NT5_ivxBPgEE8HOzP5s_Bt5JURRaSsLdQ@mail.gmail.com>
 <20220302112945-mutt-send-email-mst@kernel.org>
 <Yh+gDZUbgBRx/1ro@google.com>
 <20220302171048.aijkcrwcrgsu475z@sgarzare-redhat>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220302171048.aijkcrwcrgsu475z@sgarzare-redhat>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 02 Mar 2022, Stefano Garzarella wrote:

> On Wed, Mar 02, 2022 at 04:49:17PM +0000, Lee Jones wrote:
> > On Wed, 02 Mar 2022, Michael S. Tsirkin wrote:
> > 
> > > On Wed, Mar 02, 2022 at 05:28:31PM +0100, Stefano Garzarella wrote:
> > > > On Wed, Mar 2, 2022 at 3:57 PM Lee Jones <lee.jones@linaro.org> wrote:
> > > > >
> > > > > On Wed, 02 Mar 2022, Michael S. Tsirkin wrote:
> > > > >
> > > > > > On Wed, Mar 02, 2022 at 01:56:35PM +0000, Lee Jones wrote:
> > > > > > > On Wed, 02 Mar 2022, Michael S. Tsirkin wrote:
> > > > > > >
> > > > > > > > On Wed, Mar 02, 2022 at 07:54:21AM +0000, Lee Jones wrote:
> > > > > > > > > vhost_vsock_handle_tx_kick() already holds the mutex during its call
> > > > > > > > > to vhost_get_vq_desc().  All we have to do is take the same lock
> > > > > > > > > during virtqueue clean-up and we mitigate the reported issues.
> > > > > > > > >
> > > > > > > > > Link: https://syzkaller.appspot.com/bug?extid=279432d30d825e63ba00
> > > > > > > > >
> > > > > > > > > Cc: <stable@vger.kernel.org>
> > > > > > > > > Reported-by: syzbot+adc3cb32385586bec859@syzkaller.appspotmail.com
> > > > > > > > > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > > > > > > > > ---
> > > > > > > > >  drivers/vhost/vhost.c | 2 ++
> > > > > > > > >  1 file changed, 2 insertions(+)
> > > > > > > > >
> > > > > > > > > diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> > > > > > > > > index 59edb5a1ffe28..bbaff6a5e21b8 100644
> > > > > > > > > --- a/drivers/vhost/vhost.c
> > > > > > > > > +++ b/drivers/vhost/vhost.c
> > > > > > > > > @@ -693,6 +693,7 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
> > > > > > > > >         int i;
> > > > > > > > >
> > > > > > > > >         for (i = 0; i < dev->nvqs; ++i) {
> > > > > > > > > +               mutex_lock(&dev->vqs[i]->mutex);
> > > > > > > > >                 if (dev->vqs[i]->error_ctx)
> > > > > > > > >                         eventfd_ctx_put(dev->vqs[i]->error_ctx);
> > > > > > > > >                 if (dev->vqs[i]->kick)
> > > > > > > > > @@ -700,6 +701,7 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
> > > > > > > > >                 if (dev->vqs[i]->call_ctx.ctx)
> > > > > > > > >                         eventfd_ctx_put(dev->vqs[i]->call_ctx.ctx);
> > > > > > > > >                 vhost_vq_reset(dev, dev->vqs[i]);
> > > > > > > > > +               mutex_unlock(&dev->vqs[i]->mutex);
> > > > > > > > >         }
> > > > > > > >
> > > > > > > > So this is a mitigation plan but the bug is still there though
> > > > > > > > we don't know exactly what it is.  I would prefer adding something like
> > > > > > > > WARN_ON(mutex_is_locked(vqs[i]->mutex) here - does this make sense?
> > > > > > >
> > > > > > > As a rework to this, or as a subsequent patch?
> > > > > >
> > > > > > Can be a separate patch.
> > > > > >
> > > > > > > Just before the first lock I assume?
> > > > > >
> > > > > > I guess so, yes.
> > > > >
> > > > > No problem.  Patch to follow.
> > > > >
> > > > > I'm also going to attempt to debug the root cause, but I'm new to this
> > > > > subsystem to it might take a while for me to get my head around.
> > > >
> > > > IIUC the root cause should be the same as the one we solved here:
> > > > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=a58da53ffd70294ebea8ecd0eb45fd0d74add9f9
> > > >
> > > > The worker was not stopped before calling vhost_dev_cleanup(). So while
> > > > the worker was still running we were going to free memory or initialize
> > > > fields while it was still using virtqueue.
> > > 
> > > Right, and I agree but it's not the root though, we do attempt to stop all workers.
> > 
> > Exactly.  This is what happens, but the question I'm going to attempt
> > to answer is *why* does this happen.
> 
> IIUC the worker was still running because the /dev/vhost-vsock file was not
> explicitly closed, so vhost_vsock_dev_release() was called in the do_exit()
> of the process.
> 
> In that case there was the issue, because vhost_dev_check_owner() returned
> false in vhost_vsock_stop() since current->mm was NULL.
> So it returned earlier, without calling vhost_vq_set_backend(vq, NULL).
> 
> This did not stop the worker from continuing to run, causing the multiple
> issues we are seeing.
> 
> current->mm was NULL, because in the do_exit() the address space is cleaned
> in the exit_mm(), which is called before releasing the files into the
> exit_task_work().
> 
> This can be seen from the logs, where we see first the warnings printed by
> vhost_dev_cleanup() and then the panic in the worker (e.g. here
> https://syzkaller.appspot.com/text?tag=CrashLog&x=16a61fce700000)
> 
> Mike also added a few more helpful details in this thread:
> https://lore.kernel.org/virtualization/20220221100500.2x3s2sddqahgdfyt@sgarzare-redhat/T/#ree61316eac63245c9ba3050b44330e4034282cc2

I guess that about sums it up. :)

-- 
Lee Jones [李琼斯]
Principal Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
