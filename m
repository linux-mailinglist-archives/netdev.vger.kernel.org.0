Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCE015B3E9F
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 20:14:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231841AbiIISNx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 14:13:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231826AbiIISNo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 14:13:44 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E59DDFF4B;
        Fri,  9 Sep 2022 11:13:43 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id v1so2518038plo.9;
        Fri, 09 Sep 2022 11:13:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=2rBWOVv3s+/BgGo/HoYIVzLUNrlvQyzpwbNtQsvWT2I=;
        b=U0OPC7Mybv9nOmzkVZ0q7GdbU6DFYu/oD8m83e0oJa97abKroHSB2iIGEEiSDIcR4H
         6lteeo0bBVNtmM8aK90o2FGhEbxQgVcJQUnx9ADdfUmgYuDYpWupqxNRqDCTFZoigLuh
         DYf3JqdYTwYiPvDN4ex+2XEJLfeKns1FWGLRuLCUB0yspf5KOQaTIUcf95BxaCdCoR94
         o6q4D2n2tPNMYEM09cMyKGDUNRn3fXrhHXzsiDitg1XYIISGpRp2ZkrU5xIcBCv7v+lh
         9vCG5/ArewR1H8ZpXUbMn9Pad4i7P8zqfF4Re2bZbEs++Y6I+oe3j4ITF2FU1R1u5Vol
         eTJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=2rBWOVv3s+/BgGo/HoYIVzLUNrlvQyzpwbNtQsvWT2I=;
        b=WDX0tDyCC7jD3JlXmZHAPnFAsqsxV4EZDscjbGJfhHWrQcf0zGOb6zxIJgpgBHgt7A
         RkNcQSeLctjQp8WmU7pz7J+IFFbkWtO6YlAzxoJoV+Kb8Uy2Eutt8I0mYX1/N+nJUgmF
         GnkAkPK/mqqZmldg9J4hwqqozIymh5pVqBxdP4SxCVPgidZuv5zuf34zJwT+A5EcB4a1
         sWypo1bG49htW5fJw9uBGGSrwIZn4KTqTr6AdC99eOmV1Ep2WBjHvtkg0GkKURi+Pbxw
         +1SJDK7xZfiB8k4nHnvaG//5DJa9vtmtQHlCr52YX6kKNzFFClPp35Clte1Br7ZUdiAu
         Y9DQ==
X-Gm-Message-State: ACgBeo2io/kkorCR3/cH+UkehAlGVC9XLDaUtPrLakNzZyR+0CGfU3Is
        8D6/qcZtWVXh4lAg3dSAUYw=
X-Google-Smtp-Source: AA6agR5nPtj/Vphsk/4jmNa1U1Db4c4Gob5akLfQ/k0i0pA3yyn7H9N4iy3dQpAVK4lGKrHgWUINyg==
X-Received: by 2002:a17:903:2104:b0:176:a9ef:418b with SMTP id o4-20020a170903210400b00176a9ef418bmr14719928ple.134.1662747222905;
        Fri, 09 Sep 2022 11:13:42 -0700 (PDT)
Received: from localhost ([208.71.200.116])
        by smtp.gmail.com with ESMTPSA id i10-20020a170902c94a00b001768517f99esm745300pla.244.2022.09.09.11.13.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Sep 2022 11:13:42 -0700 (PDT)
Date:   Fri, 9 Sep 2022 18:13:41 +0000
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
Message-ID: <YxuCVfFcRdWHeeh8@bullseye>
References: <cover.1660362668.git.bobby.eshleman@bytedance.com>
 <YxdKiUzlfpHs3h3q@fedora>
 <Yv5PFz1YrSk8jxzY@bullseye>
 <20220908143652.tfyjjx2z6in6v66c@sgarzare-redhat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220908143652.tfyjjx2z6in6v66c@sgarzare-redhat>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey Stefano, thanks for sending this out.

On Thu, Sep 08, 2022 at 04:36:52PM +0200, Stefano Garzarella wrote:
> 
> Looking better at the KVM forum sched, I found 1h slot for Sep 15 at 16:30
> UTC.
> 
> Could this work for you?

Unfortunately, I can't make this time slot.

My schedule also opens up a lot the week of the 26th, especially between
16:00 and 19:00 UTC, as well as after 22:00 UTC.

Best,
Bobby
