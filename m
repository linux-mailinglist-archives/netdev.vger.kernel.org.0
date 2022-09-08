Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1106D5B13F4
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 07:19:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229477AbiIHFTd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 01:19:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbiIHFTb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 01:19:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EA726445
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 22:19:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662614368;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B1eDsyH0NCED46aCkehmhrnDxVmlGdOirQ4ogyDejUk=;
        b=fDnsrOHQxdFuZMm90vLxW+L2256a2SGdsONildFxUkvS8r/5SXatzGAT2rw0iZeUbGlb2M
        JV3Jx7GGw8/Nn0VOG4/63qYCZWakCO3h4rHxS0sQ6qCta5YjzA5JXlmpYjGOIYIa5ICBjx
        rOODsMgED2uLqzhGcqKBc4cv+aqdQHk=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-533-S9jNecfmMP2GxVTd09PmpA-1; Thu, 08 Sep 2022 01:19:27 -0400
X-MC-Unique: S9jNecfmMP2GxVTd09PmpA-1
Received: by mail-qt1-f197.google.com with SMTP id cj19-20020a05622a259300b003446920ea91so13668259qtb.10
        for <netdev@vger.kernel.org>; Wed, 07 Sep 2022 22:19:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date;
        bh=B1eDsyH0NCED46aCkehmhrnDxVmlGdOirQ4ogyDejUk=;
        b=Ta6zF+mY3T2PC3LvdZYkcniW9v+U4TqW9Td54nP/liD0awPWxOzMmXgV6qOmKFtWbl
         IXLwpIqWiX3G7JmSKQo7cIlQyRrtMX9f07ntvXo6WhULB7Agn6LCx7VYUvo9amy+3me9
         QYc87dQ5xoPzxFf+FhRiwATz4LL6/WDMN18RYtGzHvTonNia7zxuWTcEzPDW+FUNBpzd
         KRy+sugMgwaUgJQJj7qtIrde1ymRQAU7t/VfsF4ASjPejSlBcqtQwjrsBRVSoT75Om1n
         Jyg3iZa2iV8oK5z0ZIsAUgc+j7PxULqJvUjlxrXQ/kpRJ+Jh7SdljsQKjpgcKSmx3uK2
         TaNg==
X-Gm-Message-State: ACgBeo2W0QjCJSdmRdTRgJ5eh0tlavH5MfwkjkgefCEAfnCNudW+o49x
        eTGYGm3kFetsoc6iW840PnoIwJ8mq/NaSZMp3Lq5zxu2wfAc2GcWNH2y/NcaPElB6UvWEy0IqCH
        RPyD2NDTkQeZb4ns4
X-Received: by 2002:ad4:5aad:0:b0:4aa:a266:d1a7 with SMTP id u13-20020ad45aad000000b004aaa266d1a7mr6185323qvg.70.1662614366712;
        Wed, 07 Sep 2022 22:19:26 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4r1VbJFq8CGl7/bxp5VatqXI2qjsFPHqpStma1EuagWySTzIlSshzGyNA5TkIFgOJkVROScA==
X-Received: by 2002:ad4:5aad:0:b0:4aa:a266:d1a7 with SMTP id u13-20020ad45aad000000b004aaa266d1a7mr6185310qvg.70.1662614366505;
        Wed, 07 Sep 2022 22:19:26 -0700 (PDT)
Received: from redhat.com ([45.144.113.243])
        by smtp.gmail.com with ESMTPSA id a9-20020ac844a9000000b0034305a91aaesm13189404qto.83.2022.09.07.22.19.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Sep 2022 22:19:25 -0700 (PDT)
Date:   Thu, 8 Sep 2022 01:19:20 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Paolo Abeni <pabeni@redhat.com>, netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Gautam Dawar <gautam.dawar@xilinx.com>,
        davem <davem@davemloft.net>
Subject: Re: [PATCH net] virtio-net: add cond_resched() to the command
 waiting loop
Message-ID: <20220908011858-mutt-send-email-mst@kernel.org>
References: <20220905045341.66191-1-jasowang@redhat.com>
 <20220905031405-mutt-send-email-mst@kernel.org>
 <CACGkMEtjQ0Jfok-gcRW+kuinsua2X0TscyTNfBJoXHny0Yob+g@mail.gmail.com>
 <056ba905a2579903a372258383afdf6579767ad0.camel@redhat.com>
 <CACGkMEuiDqqOEKUWRN9LvQKv8Jz4mi3aSZMwbhUsJkZp=C-0RQ@mail.gmail.com>
 <c9180ac41b00543e3531a343afae8f5bdca64d8d.camel@redhat.com>
 <20220907034407-mutt-send-email-mst@kernel.org>
 <d32101bb-783f-dbd1-545a-be291c27cb63@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d32101bb-783f-dbd1-545a-be291c27cb63@redhat.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 08, 2022 at 10:21:45AM +0800, Jason Wang wrote:
> 
> 在 2022/9/7 15:46, Michael S. Tsirkin 写道:
> > On Wed, Sep 07, 2022 at 09:07:20AM +0200, Paolo Abeni wrote:
> > > On Wed, 2022-09-07 at 10:09 +0800, Jason Wang wrote:
> > > > On Tue, Sep 6, 2022 at 6:56 PM Paolo Abeni <pabeni@redhat.com> wrote:
> > > > > On Mon, 2022-09-05 at 15:49 +0800, Jason Wang wrote:
> > > > > > On Mon, Sep 5, 2022 at 3:15 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > > > > On Mon, Sep 05, 2022 at 12:53:41PM +0800, Jason Wang wrote:
> > > > > > > > Adding cond_resched() to the command waiting loop for a better
> > > > > > > > co-operation with the scheduler. This allows to give CPU a breath to
> > > > > > > > run other task(workqueue) instead of busy looping when preemption is
> > > > > > > > not allowed.
> > > > > > > > 
> > > > > > > > What's more important. This is a must for some vDPA parent to work
> > > > > > > > since control virtqueue is emulated via a workqueue for those parents.
> > > > > > > > 
> > > > > > > > Fixes: bda324fd037a ("vdpasim: control virtqueue support")
> > > > > > > That's a weird commit to fix. so it fixes the simulator?
> > > > > > Yes, since the simulator is using a workqueue to handle control virtueue.
> > > > > Uhmm... touching a driver for a simulator's sake looks a little weird.
> > > > Simulator is not the only one that is using a workqueue (but should be
> > > > the first).
> > > > 
> > > > I can see  that the mlx5 vDPA driver is using a workqueue as well (see
> > > > mlx5_vdpa_kick_vq()).
> > > > 
> > > > And in the case of VDUSE, it needs to wait for the response from the
> > > > userspace, this means cond_resched() is probably a must for the case
> > > > like UP.
> > > > 
> > > > > Additionally, if the bug is vdpasim, I think it's better to try to
> > > > > solve it there, if possible.
> > > > > 
> > > > > Looking at vdpasim_net_work() and vdpasim_blk_work() it looks like
> > > > > neither needs a process context, so perhaps you could rework it to run
> > > > > the work_fn() directly from vdpasim_kick_vq(), at least for the control
> > > > > virtqueue?
> > > > It's possible (but require some rework on the simulator core). But
> > > > considering we have other similar use cases, it looks better to solve
> > > > it in the virtio-net driver.
> > > I see.
> > > 
> > > > Additionally, this may have better behaviour when using for the buggy
> > > > hardware (e.g the control virtqueue takes too long to respond). We may
> > > > consider switching to use interrupt/sleep in the future (but not
> > > > suitable for -net).
> > > Agreed. Possibly a timeout could be useful, too.
> > > 
> > > Cheers,
> > > 
> > > Paolo
> > 
> > Hmm timeouts are kind of arbitrary.
> > regular drivers basically derive them from hardware
> > behaviour but with a generic driver like virtio it's harder.
> > I guess we could add timeout as a config field, have
> > device make a promise to the driver.
> > 
> > Making the wait interruptible seems more reasonable.
> 
> 
> Yes, but I think we still need this patch for -net and -stable.
> 
> Thanks

I was referring to Paolo's idea of having a timeout.

-- 
MST

