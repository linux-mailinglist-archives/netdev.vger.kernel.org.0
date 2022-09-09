Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25EFC5B60FC
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 20:33:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230307AbiILSdb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 14:33:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230345AbiILSdL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 14:33:11 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44B6BE8A;
        Mon, 12 Sep 2022 11:29:30 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id x1-20020a17090ab00100b001fda21bbc90so13192517pjq.3;
        Mon, 12 Sep 2022 11:29:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=0PyKa4qN1t7Lc7OVKvX5YmFo24JkCfK4+njrWDDQpwI=;
        b=hg22JNp0dTm415YeCOqjN0j6ciXTv2J4mNTffYau27V4VlelFRJsc1Et43ui/tgZJY
         8dqwCK4iYO9XfZDqFSEQvmINTBoWbZihw6ORYxdMtIXghUyigY6vDmb9ualZZTaNtRgd
         Wl0WDZgEjBbmJU2g8Ll4+tqjJ4HHJVxvdbBoIuMVlHGCHLBQQALSIDn70IBhRHPru1mt
         eOqXb+IHiE0IOUkcth4LFf3S7oqMRqnIMh+CyJeJdRailJf/3xBJEmXlvTNyWGzR/35a
         hNsbgMV9hY7C6+mKVbWqHnudGW2dMRxCy9sLmQt7yCp99gUJJlKUWTkN85a8aac0OsbA
         r1Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=0PyKa4qN1t7Lc7OVKvX5YmFo24JkCfK4+njrWDDQpwI=;
        b=l1LorJ+MWR3YIB2GWOPbnN0YdVUioAQp7UcBUzMqQenGQBzaQyevepHNXk8seATvBY
         ksW7AiEzfcVUeIZa4ouE91w3yZcEFUJivn5Bgd6xWAFB7NRW46semcUgiH041r7RwrQo
         kcglo5tYNK5PIOD2xoMKMCgSGHD32hwNGTokm2qUVaKauHEqH3KgvpV/sCff8l5lRz92
         x8Eyk8gD0h1qlFwvrx6ZbbmUI2Dy5lgdOHlLwcMrxJH8VaqqBXx+H9NM+a0OnLhHrehD
         wdlS3lArf/fdMbD7vNHXMvMMvAuWAktAQ+YtmV0RTLoidTKY3mZDk+p7qVingvSrewGj
         gE6Q==
X-Gm-Message-State: ACgBeo19Wz8aC0ZJPyCMCh3GxwFEli4xUEirwcDGRWHOTdIie2lFYfAY
        g9w9M9kashvB4RhewOxVmgQ=
X-Google-Smtp-Source: AA6agR7AeTUfhCV3pccbDMaHtEGEJCcPfbbKgA9WjlC5Zbi+w772b/E2Az1fg1yKIRpO2UD8bxHVSw==
X-Received: by 2002:a17:903:1c5:b0:178:44cd:e9c with SMTP id e5-20020a17090301c500b0017844cd0e9cmr404153plh.132.1663007317694;
        Mon, 12 Sep 2022 11:28:37 -0700 (PDT)
Received: from localhost (c-73-164-155-12.hsd1.wa.comcast.net. [73.164.155.12])
        by smtp.gmail.com with ESMTPSA id w19-20020a63c113000000b0042b5b036da4sm5838068pgf.68.2022.09.12.11.28.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Sep 2022 11:28:37 -0700 (PDT)
Date:   Fri, 9 Sep 2022 23:33:09 +0000
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
Message-ID: <YxvNNd4dNTIUu6Rb@bullseye>
References: <cover.1660362668.git.bobby.eshleman@bytedance.com>
 <YxdKiUzlfpHs3h3q@fedora>
 <Yv5PFz1YrSk8jxzY@bullseye>
 <20220908143652.tfyjjx2z6in6v66c@sgarzare-redhat>
 <YxuCVfFcRdWHeeh8@bullseye>
 <CAGxU2F5HG_UouKzJNuvfeCASJ4j84qPY9-7-yFUpEtAJQSoxJg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGxU2F5HG_UouKzJNuvfeCASJ4j84qPY9-7-yFUpEtAJQSoxJg@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 12, 2022 at 08:12:58PM +0200, Stefano Garzarella wrote:
> On Fri, Sep 9, 2022 at 8:13 PM Bobby Eshleman <bobbyeshleman@gmail.com> wrote:
> >
> > Hey Stefano, thanks for sending this out.
> >
> > On Thu, Sep 08, 2022 at 04:36:52PM +0200, Stefano Garzarella wrote:
> > >
> > > Looking better at the KVM forum sched, I found 1h slot for Sep 15 at 16:30
> > > UTC.
> > >
> > > Could this work for you?
> >
> > Unfortunately, I can't make this time slot.
> 
> No problem at all!
> 
> >
> > My schedule also opens up a lot the week of the 26th, especially between
> > 16:00 and 19:00 UTC, as well as after 22:00 UTC.
> 
> Great, that week works for me too.
> What about Sep 27 @ 16:00 UTC?
> 

That time works for me!

Thanks,
Bobby
