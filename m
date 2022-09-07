Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DCB05AFD15
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 09:07:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229715AbiIGHH2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 03:07:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbiIGHH0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 03:07:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B70089800
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 00:07:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662534444;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z/+HSxg5tcrvz/CJsTFm78OgI3pQS+e1F1DHw+MtS9w=;
        b=e3D1tHrzogqMR04hatD+VWTJm8wJtzU3PjQGV9hQjF6DCfAXxSVWQFAW1Da7SeQAanlHm4
        7C3YpaA4GamqLWT0OFEWdGb8oozqnFqbh37sOi33CVx+WdCxNSWRBja/spy7+FmZi0BB5Y
        xKGaN0KqGHRxYBwoFbhe9LYWCHetiBg=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-93-uUNV_JqDMh6Q1P4e6B51Kg-1; Wed, 07 Sep 2022 03:07:23 -0400
X-MC-Unique: uUNV_JqDMh6Q1P4e6B51Kg-1
Received: by mail-wr1-f71.google.com with SMTP id d16-20020adfa350000000b00228628ff913so2677044wrb.0
        for <netdev@vger.kernel.org>; Wed, 07 Sep 2022 00:07:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date;
        bh=z/+HSxg5tcrvz/CJsTFm78OgI3pQS+e1F1DHw+MtS9w=;
        b=whMrdMLc0xzd81rP0kT0Rm+gSrg0lqJRa3I247RsyTu4wQfVeUCABgxYjPiQ1NuGdQ
         55che7OchRf/pe1wAmfTwynpKRYxwzlqX0hINtQWOsEvpqEhGj1BpthAJU4CbrD6U2Xu
         qMoZAJ3v8UvgyVL+vMwq51cXNOUUihMR8vEQiZpflsNcfwOBJ3ck2tIvxpY+usUFpPoy
         PBF9Pq6cOAkJegJMt8eBHcZXj8t+PtJgxAhtY+jJ+RB/22NReER5KE4WN4uUzLtAuTaH
         K4s0VOYATJQj5/2CALjQFMst6lZ2rLqVr7Qc0AF3i2ajyNsYZECK4/5A1vfPB+t7vuvv
         MWhw==
X-Gm-Message-State: ACgBeo0waRR1GD/6c0fMVDyK5Ba3ZRvtdxdrwlTj0Ftr0I9HrqqkFxdn
        4EaHffUePRSMRVVC0tLNC4qdn5w4wfTcUXz2PpEjUhtduPYB7VsrZHpW2H6608IEIBJmTxDv7s+
        fPFTguRRcWTXLnWsF
X-Received: by 2002:a05:6000:178e:b0:220:635f:eb13 with SMTP id e14-20020a056000178e00b00220635feb13mr1090937wrg.634.1662534442060;
        Wed, 07 Sep 2022 00:07:22 -0700 (PDT)
X-Google-Smtp-Source: AA6agR49NwluFNkfmL/l1sDW03NqaJvOQWjUhRUW2teBAjXK1WwZOvJMJQqIMKJkY8eq21o01mwfig==
X-Received: by 2002:a05:6000:178e:b0:220:635f:eb13 with SMTP id e14-20020a056000178e00b00220635feb13mr1090919wrg.634.1662534441847;
        Wed, 07 Sep 2022 00:07:21 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-112-72.dyn.eolo.it. [146.241.112.72])
        by smtp.gmail.com with ESMTPSA id ay19-20020a05600c1e1300b003a50924f1c0sm18241872wmb.18.2022.09.07.00.07.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Sep 2022 00:07:21 -0700 (PDT)
Message-ID: <c9180ac41b00543e3531a343afae8f5bdca64d8d.camel@redhat.com>
Subject: Re: [PATCH net] virtio-net: add cond_resched() to the command
 waiting loop
From:   Paolo Abeni <pabeni@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Gautam Dawar <gautam.dawar@xilinx.com>,
        davem <davem@davemloft.net>
Date:   Wed, 07 Sep 2022 09:07:20 +0200
In-Reply-To: <CACGkMEuiDqqOEKUWRN9LvQKv8Jz4mi3aSZMwbhUsJkZp=C-0RQ@mail.gmail.com>
References: <20220905045341.66191-1-jasowang@redhat.com>
         <20220905031405-mutt-send-email-mst@kernel.org>
         <CACGkMEtjQ0Jfok-gcRW+kuinsua2X0TscyTNfBJoXHny0Yob+g@mail.gmail.com>
         <056ba905a2579903a372258383afdf6579767ad0.camel@redhat.com>
         <CACGkMEuiDqqOEKUWRN9LvQKv8Jz4mi3aSZMwbhUsJkZp=C-0RQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-09-07 at 10:09 +0800, Jason Wang wrote:
> On Tue, Sep 6, 2022 at 6:56 PM Paolo Abeni <pabeni@redhat.com> wrote:
> > 
> > On Mon, 2022-09-05 at 15:49 +0800, Jason Wang wrote:
> > > On Mon, Sep 5, 2022 at 3:15 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > 
> > > > On Mon, Sep 05, 2022 at 12:53:41PM +0800, Jason Wang wrote:
> > > > > Adding cond_resched() to the command waiting loop for a better
> > > > > co-operation with the scheduler. This allows to give CPU a breath to
> > > > > run other task(workqueue) instead of busy looping when preemption is
> > > > > not allowed.
> > > > > 
> > > > > What's more important. This is a must for some vDPA parent to work
> > > > > since control virtqueue is emulated via a workqueue for those parents.
> > > > > 
> > > > > Fixes: bda324fd037a ("vdpasim: control virtqueue support")
> > > > 
> > > > That's a weird commit to fix. so it fixes the simulator?
> > > 
> > > Yes, since the simulator is using a workqueue to handle control virtueue.
> > 
> > Uhmm... touching a driver for a simulator's sake looks a little weird.
> 
> Simulator is not the only one that is using a workqueue (but should be
> the first).
> 
> I can see  that the mlx5 vDPA driver is using a workqueue as well (see
> mlx5_vdpa_kick_vq()).
> 
> And in the case of VDUSE, it needs to wait for the response from the
> userspace, this means cond_resched() is probably a must for the case
> like UP.
> 
> > 
> > Additionally, if the bug is vdpasim, I think it's better to try to
> > solve it there, if possible.
> > 
> > Looking at vdpasim_net_work() and vdpasim_blk_work() it looks like
> > neither needs a process context, so perhaps you could rework it to run
> > the work_fn() directly from vdpasim_kick_vq(), at least for the control
> > virtqueue?
> 
> It's possible (but require some rework on the simulator core). But
> considering we have other similar use cases, it looks better to solve
> it in the virtio-net driver.

I see.

> Additionally, this may have better behaviour when using for the buggy
> hardware (e.g the control virtqueue takes too long to respond). We may
> consider switching to use interrupt/sleep in the future (but not
> suitable for -net).

Agreed. Possibly a timeout could be useful, too.

Cheers,

Paolo

