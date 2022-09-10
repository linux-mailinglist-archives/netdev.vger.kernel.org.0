Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED0375BB108
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 18:18:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbiIPQR7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 12:17:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbiIPQR5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 12:17:57 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CEFAB600E;
        Fri, 16 Sep 2022 09:17:56 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id 207so12397915pgc.7;
        Fri, 16 Sep 2022 09:17:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=u0NEQPoiZmBD9Mm9vr8JrzumZIsWiV897rA1dK7/Fsg=;
        b=PWa9ae0U37Stk+HrwEUbWTPex9EFkXqB/Vbohl+X0KLfWQezIiLvlV68BL7T8Fd1fv
         v0oRkZN/LelvVZBnYevCuzyVmaee9NdFGwFQoVnSUl2t5FuqE0vSeNVSZfIbFeC+/bQj
         bN+VD76nLkXs4NpU2lPJ4VvB59meYts19LM6gFIb4Ir6W0D1o5E1FFi+EZUaJwAdKD+o
         OWr0hqG1q6pMzzoZbrMTXHsLWp2FbAQpHkKoOIUyUHVmvLh+fQj2CW9qQ6pzDUjGf7Lu
         sGpF1t7M+0Vg/H8iZSkmRKK2Cl5UppGjFhScgfw2mnVzr9qDe+llu2hPBQk5Og8K2i/H
         2x7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=u0NEQPoiZmBD9Mm9vr8JrzumZIsWiV897rA1dK7/Fsg=;
        b=r/MubXlty0MqN6dJcp2DendXMpb2tbl4ifUEMdSn5lSPMslEbJM6F3MxEcB2s/7if4
         c0gBpNQL2GBgNR6/doHjnqZVtclU/+Owsu4AjYfbdxZs/gZhgf+xrhMrBQzh3tuRn+7l
         N3OrrDBOvKJ7qO/3xmvKB7JEV0hoWq1jgs0JhH1vFANEu/Cm+rA9ilk0ezz0+Ijuu12J
         nqnhIfYG5RIlhLQtIdUIHXdOhEPWK1oXxZC58XS3QK+h2FDb5YM9H+90DXFXoNCNWGHW
         t1I7O5UA/91uKhSADiJsRdSCvEHGv3fsiMtFezSy9GPFpxq58j5tuQz9GckKJYrmjAz4
         06hw==
X-Gm-Message-State: ACrzQf1HXbxj86ELBo/kz+HQAx+SMmRJIW2g7jHvkyTvpx9RvCMebzGY
        a+htoLbc35/FSprn9lYaRlM=
X-Google-Smtp-Source: AMsMyM5OYAr6DlxPIC3SjG64fd9663YW/izpayOy4YDB0LRXC/p8+T1tw39y0qCKBvzuiGQ68tkLGQ==
X-Received: by 2002:a65:4644:0:b0:42a:dfb6:4e80 with SMTP id k4-20020a654644000000b0042adfb64e80mr5174195pgr.262.1663345075325;
        Fri, 16 Sep 2022 09:17:55 -0700 (PDT)
Received: from localhost (c-73-164-155-12.hsd1.wa.comcast.net. [73.164.155.12])
        by smtp.gmail.com with ESMTPSA id m8-20020a17090aab0800b001fda0505eaasm1692273pjq.1.2022.09.16.09.17.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Sep 2022 09:17:54 -0700 (PDT)
Date:   Sat, 10 Sep 2022 16:29:51 +0000
From:   Bobby Eshleman <bobbyeshleman@gmail.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
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
Subject: Re: Call to discuss vsock netdev/sk_buff [was Re: [PATCH 0/6]
 virtio/vsock: introduce dgrams, sk_buff, and qdisc]
Message-ID: <Yxy7f2KYyRcDsMxm@bullseye>
References: <cover.1660362668.git.bobby.eshleman@bytedance.com>
 <YxdKiUzlfpHs3h3q@fedora>
 <Yv5PFz1YrSk8jxzY@bullseye>
 <20220908143652.tfyjjx2z6in6v66c@sgarzare-redhat>
 <YxuCVfFcRdWHeeh8@bullseye>
 <CAGxU2F5HG_UouKzJNuvfeCASJ4j84qPY9-7-yFUpEtAJQSoxJg@mail.gmail.com>
 <YxvNNd4dNTIUu6Rb@bullseye>
 <CAGxU2F5+M2SYKwr56NJ9s2yO5h40MWQFO82t_RkSvx10VRfbVQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGxU2F5+M2SYKwr56NJ9s2yO5h40MWQFO82t_RkSvx10VRfbVQ@mail.gmail.com>
X-Spam-Status: No, score=1.3 required=5.0 tests=BAYES_00,DATE_IN_PAST_96_XX,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 16, 2022 at 05:51:22AM +0200, Stefano Garzarella wrote:
> On Mon, Sep 12, 2022 at 8:28 PM Bobby Eshleman <bobbyeshleman@gmail.com> wrote:
> >
> > On Mon, Sep 12, 2022 at 08:12:58PM +0200, Stefano Garzarella wrote:
> > > On Fri, Sep 9, 2022 at 8:13 PM Bobby Eshleman <bobbyeshleman@gmail.com> wrote:
> > > >
> > > > Hey Stefano, thanks for sending this out.
> > > >
> > > > On Thu, Sep 08, 2022 at 04:36:52PM +0200, Stefano Garzarella wrote:
> > > > >
> > > > > Looking better at the KVM forum sched, I found 1h slot for Sep 15 at 16:30
> > > > > UTC.
> > > > >
> > > > > Could this work for you?
> > > >
> > > > Unfortunately, I can't make this time slot.
> > >
> > > No problem at all!
> > >
> > > >
> > > > My schedule also opens up a lot the week of the 26th, especially between
> > > > 16:00 and 19:00 UTC, as well as after 22:00 UTC.
> > >
> > > Great, that week works for me too.
> > > What about Sep 27 @ 16:00 UTC?
> > >
> >
> > That time works for me!
> 
> Great! I sent you an invitation.
> 

Awesome, see you then!

Thanks,
Bobby
