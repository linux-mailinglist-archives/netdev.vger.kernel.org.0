Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4598E5BA590
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 05:51:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbiIPDvk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 23:51:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbiIPDvi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 23:51:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14D8995AF2
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 20:51:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663300296;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=C/CNirb5aNM2+/jDbEf4rfvjRpTSCtEdOZAcwKqI7yU=;
        b=Y37N6X7Xh/f5l99QkEjFJkwk9T1hLSiaUkciHhuVdV44Bc4ZSN/vbfO90NdRpZIOtBQVrj
        AQHCIzB6EjSXfgX0zIH/o/z3wag/BYhJ3SfcxdUpa+WvpPMx4kgWab3NC5/mSpHCFlfRKu
        7KHyQygC9fgNjznG7VOS1Rkb+Bjhf7M=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-325-3kKzQvhQPmGSHZOm8-caeA-1; Thu, 15 Sep 2022 23:51:34 -0400
X-MC-Unique: 3kKzQvhQPmGSHZOm8-caeA-1
Received: by mail-lf1-f72.google.com with SMTP id a24-20020ac25e78000000b00497ad54b081so6172659lfr.2
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 20:51:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=C/CNirb5aNM2+/jDbEf4rfvjRpTSCtEdOZAcwKqI7yU=;
        b=aNJqfJa4HJah0ONcdz2LJME7pxULYKq8PcALJAX0uqjIKf0md5I1TbV63fyjBKf9PP
         M04JT6N1vPQge495wBjkkjE2sDrGfjBrYB1cWMh7393mIQxI/gnexmhfBkUHuefkH0gS
         HcQOUK4ijkFgJ5awrwpD59e0hk73rhXmujk7fQDJyE8OyRvt7AzuRLtPov8874gXfdsp
         uG+5Of30DqmIdjM19GdEMpet1Fvk5959rLxpI6ZrrzyGkHgL98osIZoWNbdREG8kAxZj
         Cbb3Tyjb4yXImpSvoZCFQvskWPEDVbDTJBXKg5SVb3Z3C9egMXgpb6aTYQ30mvQlAthI
         UbQQ==
X-Gm-Message-State: ACrzQf1Zi3AOHhX1hjig0Md5NsRE3ZnadDbfQAd6+NlwIeGSXd8TLmDX
        22enrJIamOO6d6juDtgmBvkvp+R1ziCrPcFW902rvf4uDAUJQiVWx21ic0+Wd9AXnhfUo1ioYCH
        sZCF6C/fIQFQZxhCVfDjrsX0FD4P01QW0
X-Received: by 2002:a05:6512:3d17:b0:497:9e34:94f2 with SMTP id d23-20020a0565123d1700b004979e3494f2mr941115lfv.285.1663300293439;
        Thu, 15 Sep 2022 20:51:33 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4KIjQQOQEAz2rfnCXfJXK795QetoyHr8NUQ0oWj6eNCqrdNbxhUg53OGOwyxCvA4D1rGGNQcSqWMcwTJW2PsE=
X-Received: by 2002:a05:6512:3d17:b0:497:9e34:94f2 with SMTP id
 d23-20020a0565123d1700b004979e3494f2mr941108lfv.285.1663300293246; Thu, 15
 Sep 2022 20:51:33 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1660362668.git.bobby.eshleman@bytedance.com>
 <YxdKiUzlfpHs3h3q@fedora> <Yv5PFz1YrSk8jxzY@bullseye> <20220908143652.tfyjjx2z6in6v66c@sgarzare-redhat>
 <YxuCVfFcRdWHeeh8@bullseye> <CAGxU2F5HG_UouKzJNuvfeCASJ4j84qPY9-7-yFUpEtAJQSoxJg@mail.gmail.com>
 <YxvNNd4dNTIUu6Rb@bullseye>
In-Reply-To: <YxvNNd4dNTIUu6Rb@bullseye>
From:   Stefano Garzarella <sgarzare@redhat.com>
Date:   Fri, 16 Sep 2022 05:51:22 +0200
Message-ID: <CAGxU2F5+M2SYKwr56NJ9s2yO5h40MWQFO82t_RkSvx10VRfbVQ@mail.gmail.com>
Subject: Re: Call to discuss vsock netdev/sk_buff [was Re: [PATCH 0/6]
 virtio/vsock: introduce dgrams, sk_buff, and qdisc]
To:     Bobby Eshleman <bobbyeshleman@gmail.com>
Cc:     Dexuan Cui <decui@microsoft.com>, Bryan Tan <bryantan@vmware.com>,
        Vishnu Dasa <vdasa@vmware.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Bobby Eshleman <bobby.eshleman@gmail.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 12, 2022 at 8:28 PM Bobby Eshleman <bobbyeshleman@gmail.com> wrote:
>
> On Mon, Sep 12, 2022 at 08:12:58PM +0200, Stefano Garzarella wrote:
> > On Fri, Sep 9, 2022 at 8:13 PM Bobby Eshleman <bobbyeshleman@gmail.com> wrote:
> > >
> > > Hey Stefano, thanks for sending this out.
> > >
> > > On Thu, Sep 08, 2022 at 04:36:52PM +0200, Stefano Garzarella wrote:
> > > >
> > > > Looking better at the KVM forum sched, I found 1h slot for Sep 15 at 16:30
> > > > UTC.
> > > >
> > > > Could this work for you?
> > >
> > > Unfortunately, I can't make this time slot.
> >
> > No problem at all!
> >
> > >
> > > My schedule also opens up a lot the week of the 26th, especially between
> > > 16:00 and 19:00 UTC, as well as after 22:00 UTC.
> >
> > Great, that week works for me too.
> > What about Sep 27 @ 16:00 UTC?
> >
>
> That time works for me!

Great! I sent you an invitation.

For others that want to join the discussion, we will meet Sep 27 @
16:00 UTC at this room: https://meet.google.com/fxi-vuzr-jjb

Thanks,
Stefano

