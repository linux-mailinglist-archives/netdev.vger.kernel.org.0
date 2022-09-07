Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67B335AFDE8
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 09:47:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230098AbiIGHrd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 03:47:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230126AbiIGHrQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 03:47:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ABD7A74F9
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 00:47:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662536822;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nsmvzDdU873IEoh1AjpLdUk0IkH22pk9o0ERO+Ke0Qs=;
        b=iSlYk+u/XcsYRjyXOHQn9t6UjEJ5AJoNWRfziAnntuR23j7fh7tqf1tPT6cGcNFKd7zcGz
        Mw3TgMbLT7xV3XgQaPu+pIQrcMIqdVP2ppSFKKdWWMiD3DwO+AT7Lwn8mLLVRdeDsPyEjw
        +Q+8mj1J5HDRL85UMm2GLCPY2wYHn2w=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-346-ODJWwBT4Ose4Gdg9on-sJQ-1; Wed, 07 Sep 2022 03:47:01 -0400
X-MC-Unique: ODJWwBT4Ose4Gdg9on-sJQ-1
Received: by mail-ej1-f70.google.com with SMTP id qw34-20020a1709066a2200b00730ca5a94bfso4512999ejc.3
        for <netdev@vger.kernel.org>; Wed, 07 Sep 2022 00:47:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=nsmvzDdU873IEoh1AjpLdUk0IkH22pk9o0ERO+Ke0Qs=;
        b=xMdmMO13BNiK7IKuKV6hKxrzcY5eLX6ppGYHasFEtz+OrHE74xbO11Y/BxPy6fzbip
         SST9AQCxn5Z7E2KpDh+8JBaCmnZrfFAIaQvNtm1Sde2VB7NXbnb8il3hVv+dKwczLUmT
         IDknonu6MvsZOlAzb3bR7IR4c2iK36BbKLSUhsLtomXOvT/lAKdcjXPxXknUGnug7tYD
         lU/AIf/OYqEFkyDOnlBVf2SsdC1nPKcneLlbuC7mnbRvhBgJs78jN7QvSc3+l0AIZC4n
         RHMbukuqqum3VNcPjLZSA/rAfG3O/xCYdMv6Oii+2NZT9caovKdBmEtcHojDGqkcsTdk
         MWlg==
X-Gm-Message-State: ACgBeo28a/MSNszy4+218C2wWZ5VvqDJZn2KuVN9llIKbELe7ERLG5Kb
        0DcfZ89lj1tEAGBhgbsH12cH1Y+Fin42zFJFMCjj9DE3toHHf9AKNzrOtpLxxJSfU8k9PXc7rcv
        tnsnqDJo3FWBeVxjp
X-Received: by 2002:a17:907:75ea:b0:73d:daa0:3cbe with SMTP id jz10-20020a17090775ea00b0073ddaa03cbemr1456169ejc.662.1662536820003;
        Wed, 07 Sep 2022 00:47:00 -0700 (PDT)
X-Google-Smtp-Source: AA6agR53nL8cnG0zY4L4+T4oecAyIfM8opFTzrBVui+uiS85jZRfT6dg9G8YzC/sl54kdM02S1/TMA==
X-Received: by 2002:a17:907:75ea:b0:73d:daa0:3cbe with SMTP id jz10-20020a17090775ea00b0073ddaa03cbemr1456158ejc.662.1662536819797;
        Wed, 07 Sep 2022 00:46:59 -0700 (PDT)
Received: from redhat.com ([2.52.135.118])
        by smtp.gmail.com with ESMTPSA id b9-20020a1709063ca900b0073c82539183sm8022689ejh.91.2022.09.07.00.46.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Sep 2022 00:46:59 -0700 (PDT)
Date:   Wed, 7 Sep 2022 03:46:55 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>, netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Gautam Dawar <gautam.dawar@xilinx.com>,
        davem <davem@davemloft.net>
Subject: Re: [PATCH net] virtio-net: add cond_resched() to the command
 waiting loop
Message-ID: <20220907034407-mutt-send-email-mst@kernel.org>
References: <20220905045341.66191-1-jasowang@redhat.com>
 <20220905031405-mutt-send-email-mst@kernel.org>
 <CACGkMEtjQ0Jfok-gcRW+kuinsua2X0TscyTNfBJoXHny0Yob+g@mail.gmail.com>
 <056ba905a2579903a372258383afdf6579767ad0.camel@redhat.com>
 <CACGkMEuiDqqOEKUWRN9LvQKv8Jz4mi3aSZMwbhUsJkZp=C-0RQ@mail.gmail.com>
 <c9180ac41b00543e3531a343afae8f5bdca64d8d.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c9180ac41b00543e3531a343afae8f5bdca64d8d.camel@redhat.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 07, 2022 at 09:07:20AM +0200, Paolo Abeni wrote:
> On Wed, 2022-09-07 at 10:09 +0800, Jason Wang wrote:
> > On Tue, Sep 6, 2022 at 6:56 PM Paolo Abeni <pabeni@redhat.com> wrote:
> > > 
> > > On Mon, 2022-09-05 at 15:49 +0800, Jason Wang wrote:
> > > > On Mon, Sep 5, 2022 at 3:15 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > > 
> > > > > On Mon, Sep 05, 2022 at 12:53:41PM +0800, Jason Wang wrote:
> > > > > > Adding cond_resched() to the command waiting loop for a better
> > > > > > co-operation with the scheduler. This allows to give CPU a breath to
> > > > > > run other task(workqueue) instead of busy looping when preemption is
> > > > > > not allowed.
> > > > > > 
> > > > > > What's more important. This is a must for some vDPA parent to work
> > > > > > since control virtqueue is emulated via a workqueue for those parents.
> > > > > > 
> > > > > > Fixes: bda324fd037a ("vdpasim: control virtqueue support")
> > > > > 
> > > > > That's a weird commit to fix. so it fixes the simulator?
> > > > 
> > > > Yes, since the simulator is using a workqueue to handle control virtueue.
> > > 
> > > Uhmm... touching a driver for a simulator's sake looks a little weird.
> > 
> > Simulator is not the only one that is using a workqueue (but should be
> > the first).
> > 
> > I can see  that the mlx5 vDPA driver is using a workqueue as well (see
> > mlx5_vdpa_kick_vq()).
> > 
> > And in the case of VDUSE, it needs to wait for the response from the
> > userspace, this means cond_resched() is probably a must for the case
> > like UP.
> > 
> > > 
> > > Additionally, if the bug is vdpasim, I think it's better to try to
> > > solve it there, if possible.
> > > 
> > > Looking at vdpasim_net_work() and vdpasim_blk_work() it looks like
> > > neither needs a process context, so perhaps you could rework it to run
> > > the work_fn() directly from vdpasim_kick_vq(), at least for the control
> > > virtqueue?
> > 
> > It's possible (but require some rework on the simulator core). But
> > considering we have other similar use cases, it looks better to solve
> > it in the virtio-net driver.
> 
> I see.
> 
> > Additionally, this may have better behaviour when using for the buggy
> > hardware (e.g the control virtqueue takes too long to respond). We may
> > consider switching to use interrupt/sleep in the future (but not
> > suitable for -net).
> 
> Agreed. Possibly a timeout could be useful, too.
> 
> Cheers,
> 
> Paolo


Hmm timeouts are kind of arbitrary.
regular drivers basically derive them from hardware
behaviour but with a generic driver like virtio it's harder.
I guess we could add timeout as a config field, have
device make a promise to the driver.

Making the wait interruptible seems more reasonable.

-- 
MST

