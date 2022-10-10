Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 441DC5FA27B
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 19:11:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbiJJRLt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 13:11:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbiJJRLr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 13:11:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5B3E5D13B
        for <netdev@vger.kernel.org>; Mon, 10 Oct 2022 10:11:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665421905;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ihtPTRwtIx7/JivDxGqfc0yBndE/NMthdx5dSqwVLUk=;
        b=SRz6DDglenJtb5MCaMCeP5E69jcoQ9bMOpxeY3yuzPflGBxT1sCjaW9oN82eJSFtrosBRf
        vRGCBPUYExfZ59HqBYkgRdNKopYQ8G3xxuiV5HI0EpzQMyWHD/ZnFiIk2QlnJ8CSBluHUA
        /KKapp2T5bbKY83SE9JK/oQ6bgf6WCE=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-382-gyHT4Ab4OS-A4Rgen5HO0g-1; Mon, 10 Oct 2022 13:11:44 -0400
X-MC-Unique: gyHT4Ab4OS-A4Rgen5HO0g-1
Received: by mail-wm1-f69.google.com with SMTP id ay21-20020a05600c1e1500b003b45fd14b53so5804740wmb.1
        for <netdev@vger.kernel.org>; Mon, 10 Oct 2022 10:11:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ihtPTRwtIx7/JivDxGqfc0yBndE/NMthdx5dSqwVLUk=;
        b=z3BU6qxZcXG2IXG4CFzHUekXF2BuJ/gBpqsnhJnIlpTkbrR6ujQoCpyYIwMNn4mOAM
         Laxmx69a7/i0o3Z32yOHOy4nDdAWWiqutl/upTJ//C8DJ8c+D6/QC0cAsfQo6+l5MAhr
         RfiHfpLUzxO27CgzUOV9sfZS0rDa/18SYMQ7Pj1YgB1BthfMQyutPWNK7FycAGVTMU+Z
         Sl3OFdzBxJgllYFdhhBUMEJxL78BYiQPJuddl6Ko91RzSPxWDWwguBYHSiaoUwe7H9PL
         a+Krs7J/gBAN7uDGcnZ4dBAZTxWpj8iq7jMb+jCjMhZrsXEMbBi2990Yngbxjl5dSc+9
         YavA==
X-Gm-Message-State: ACrzQf31e92uaitafJB1+tfCJ89L7sndl8EvElHWSLxbQKBjavi6aSWy
        Tkrpy9lPqu0EfDFm0+RNQUARQT+1qIVnX2wdJy0Ij000lIexnvh9Av2kYolRYZcmkjiw1JEfQi6
        6aUs842LlifEUZtON
X-Received: by 2002:a05:600c:2255:b0:3c4:6c57:3d19 with SMTP id a21-20020a05600c225500b003c46c573d19mr9236224wmm.92.1665421903384;
        Mon, 10 Oct 2022 10:11:43 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5Pt1iCxXK/D/7OXuLbmKUR4GbwjfQKEwoqRrCp9NsMmehZvd3bh1vqeEQ9Oqps/BNVAHHBkw==
X-Received: by 2002:a05:600c:2255:b0:3c4:6c57:3d19 with SMTP id a21-20020a05600c225500b003c46c573d19mr9236197wmm.92.1665421903113;
        Mon, 10 Oct 2022 10:11:43 -0700 (PDT)
Received: from redhat.com ([2.55.183.131])
        by smtp.gmail.com with ESMTPSA id o19-20020a05600c511300b003b95ed78275sm11264457wms.20.2022.10.10.10.11.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Oct 2022 10:11:42 -0700 (PDT)
Date:   Mon, 10 Oct 2022 13:11:35 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        Eric Dumazet <edumazet@google.com>,
        Gautam Dawar <gautam.dawar@xilinx.com>,
        davem <davem@davemloft.net>
Subject: Re: [PATCH net] virtio-net: add cond_resched() to the command
 waiting loop
Message-ID: <20221009160520-mutt-send-email-mst@kernel.org>
References: <20220905045341.66191-1-jasowang@redhat.com>
 <20220905031405-mutt-send-email-mst@kernel.org>
 <CACGkMEtjQ0Jfok-gcRW+kuinsua2X0TscyTNfBJoXHny0Yob+g@mail.gmail.com>
 <056ba905a2579903a372258383afdf6579767ad0.camel@redhat.com>
 <CACGkMEuiDqqOEKUWRN9LvQKv8Jz4mi3aSZMwbhUsJkZp=C-0RQ@mail.gmail.com>
 <c9180ac41b00543e3531a343afae8f5bdca64d8d.camel@redhat.com>
 <20220907034407-mutt-send-email-mst@kernel.org>
 <d32101bb-783f-dbd1-545a-be291c27cb63@redhat.com>
 <20220908011858-mutt-send-email-mst@kernel.org>
 <c8cd9a2e-3480-6ca5-96fa-4b5bd2c1174a@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c8cd9a2e-3480-6ca5-96fa-4b5bd2c1174a@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 09, 2022 at 01:58:53PM +0800, Jason Wang wrote:
> 
> 在 2022/9/8 13:19, Michael S. Tsirkin 写道:
> > On Thu, Sep 08, 2022 at 10:21:45AM +0800, Jason Wang wrote:
> > > 在 2022/9/7 15:46, Michael S. Tsirkin 写道:
> > > > On Wed, Sep 07, 2022 at 09:07:20AM +0200, Paolo Abeni wrote:
> > > > > On Wed, 2022-09-07 at 10:09 +0800, Jason Wang wrote:
> > > > > > On Tue, Sep 6, 2022 at 6:56 PM Paolo Abeni <pabeni@redhat.com> wrote:
> > > > > > > On Mon, 2022-09-05 at 15:49 +0800, Jason Wang wrote:
> > > > > > > > On Mon, Sep 5, 2022 at 3:15 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > > > > > > On Mon, Sep 05, 2022 at 12:53:41PM +0800, Jason Wang wrote:
> > > > > > > > > > Adding cond_resched() to the command waiting loop for a better
> > > > > > > > > > co-operation with the scheduler. This allows to give CPU a breath to
> > > > > > > > > > run other task(workqueue) instead of busy looping when preemption is
> > > > > > > > > > not allowed.
> > > > > > > > > > 
> > > > > > > > > > What's more important. This is a must for some vDPA parent to work
> > > > > > > > > > since control virtqueue is emulated via a workqueue for those parents.
> > > > > > > > > > 
> > > > > > > > > > Fixes: bda324fd037a ("vdpasim: control virtqueue support")
> > > > > > > > > That's a weird commit to fix. so it fixes the simulator?
> > > > > > > > Yes, since the simulator is using a workqueue to handle control virtueue.
> > > > > > > Uhmm... touching a driver for a simulator's sake looks a little weird.
> > > > > > Simulator is not the only one that is using a workqueue (but should be
> > > > > > the first).
> > > > > > 
> > > > > > I can see  that the mlx5 vDPA driver is using a workqueue as well (see
> > > > > > mlx5_vdpa_kick_vq()).
> > > > > > 
> > > > > > And in the case of VDUSE, it needs to wait for the response from the
> > > > > > userspace, this means cond_resched() is probably a must for the case
> > > > > > like UP.
> > > > > > 
> > > > > > > Additionally, if the bug is vdpasim, I think it's better to try to
> > > > > > > solve it there, if possible.
> > > > > > > 
> > > > > > > Looking at vdpasim_net_work() and vdpasim_blk_work() it looks like
> > > > > > > neither needs a process context, so perhaps you could rework it to run
> > > > > > > the work_fn() directly from vdpasim_kick_vq(), at least for the control
> > > > > > > virtqueue?
> > > > > > It's possible (but require some rework on the simulator core). But
> > > > > > considering we have other similar use cases, it looks better to solve
> > > > > > it in the virtio-net driver.
> > > > > I see.
> > > > > 
> > > > > > Additionally, this may have better behaviour when using for the buggy
> > > > > > hardware (e.g the control virtqueue takes too long to respond). We may
> > > > > > consider switching to use interrupt/sleep in the future (but not
> > > > > > suitable for -net).
> > > > > Agreed. Possibly a timeout could be useful, too.
> > > > > 
> > > > > Cheers,
> > > > > 
> > > > > Paolo
> > > > Hmm timeouts are kind of arbitrary.
> > > > regular drivers basically derive them from hardware
> > > > behaviour but with a generic driver like virtio it's harder.
> > > > I guess we could add timeout as a config field, have
> > > > device make a promise to the driver.
> > > > 
> > > > Making the wait interruptible seems more reasonable.
> > > 
> > > Yes, but I think we still need this patch for -net and -stable.
> > > 
> > > Thanks
> > I was referring to Paolo's idea of having a timeout.
> 
> 
> Ok, I think we're fine with this patch. Any chance to merge this or do I
> need to resend?
> 
> Thanks

Last question: do we want cpu_relax here now? Or is cond_resched
sufficient?

> 
> > 

