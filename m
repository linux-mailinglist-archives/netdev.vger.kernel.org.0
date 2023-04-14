Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C40A6E297C
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 19:30:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230432AbjDNRal (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 13:30:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230265AbjDNRaa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 13:30:30 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D723B77D;
        Fri, 14 Apr 2023 10:29:49 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id fw22-20020a17090b129600b00247255b2f40so5216433pjb.1;
        Fri, 14 Apr 2023 10:29:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681493387; x=1684085387;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oA7v86V6iYy/er+GdPOTuYZa860KsTLlZwCwQrf+4GM=;
        b=kTsQI1JEp+BNjizJZdsaHTeLSPzTMh+8ZhdIBAOetu/YXFaPfSks9nrwtLzMucsXwY
         OPVssxeXxKw9KUDK2tM54IF15q7H6BzvNX2QIhGeXqdaAO7Rbn8H9zNisL5IAk9WVakL
         ornllfdf5snpZilws1YgiAdOIpIuxhUza3DYzxXcZwW1qFDQ9ACxuY0AnosV4H76mz8T
         QO7NaENDQ68ytJfL0wmKxDb4mQJxcFbxuCHXydsAMubiCavrXBV9z00nzJhu4NCdN/SQ
         vAulexmGQamd7ftwaO/9+GGJiNm6KAGiT/QGrmDiIOavzWBePL/FZaoX34xXL6PjP1wh
         bNLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681493387; x=1684085387;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oA7v86V6iYy/er+GdPOTuYZa860KsTLlZwCwQrf+4GM=;
        b=JcTWsZIhzQSU8qbsiDrw8mMEJFlH5BP1SONWZ6tUX04G9SnmZ3xlVpiySVt+0wDd8e
         vD+I8NAttgs75D3iUKQbw+YTRvenjH7GVvbWUKJq/vCl1KjcDUSRM0NurDJEBNC/afDv
         RocEASvajbCKuRyTP4m986a/9n6jsPE6OVsIYHYEHWQ6OqSQPDVKdr5bPNmMkFzX1NbY
         1p2uYPSgx2OKdBoxBVkmc8s5/vfkn0zUXMCYkzI0U1FNpC448+kwxCU8eNTYHCikdJjj
         ZPxxuN3pNp7IUmwmMy7M9rTIKUoN/P0XMWdcpoicnxaWdWAN07F+IlveIEF6IFZ9w/VJ
         NrAQ==
X-Gm-Message-State: AAQBX9c45ck+U2BQ9J+aBKPxsbScgym/An/0b4tcgK1wd588T5HtTA2T
        JlHOrSeAfw0CZS3v8gv5NlolwuDXVzGeVoJP
X-Google-Smtp-Source: AKy350ZM/lCKFNROMkR2BLN8j5h2sYyTe4cwE/DBiZZPljtct0wXCMbeFUr0FvTHbZ5DdocTi+b1dQ==
X-Received: by 2002:a17:902:ecc5:b0:1a6:54cd:ccd9 with SMTP id a5-20020a170902ecc500b001a654cdccd9mr1583490plh.9.1681493386999;
        Fri, 14 Apr 2023 10:29:46 -0700 (PDT)
Received: from localhost (c-73-25-35-85.hsd1.wa.comcast.net. [73.25.35.85])
        by smtp.gmail.com with ESMTPSA id iw5-20020a170903044500b001a64ce7b18dsm3326202plb.165.2023.04.14.10.29.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Apr 2023 10:29:46 -0700 (PDT)
Date:   Fri, 14 Apr 2023 10:28:28 +0000
From:   Bobby Eshleman <bobbyeshleman@gmail.com>
To:     Alvaro Karsz <alvaro.karsz@solid-run.com>
Cc:     Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Bryan Tan <bryantan@vmware.com>,
        Vishnu Dasa <vdasa@vmware.com>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        Jiang Wang <jiang.wang@bytedance.com>
Subject: Re: [PATCH RFC net-next v2 2/4] virtio/vsock: add
 VIRTIO_VSOCK_F_DGRAM feature bit
Message-ID: <ZBajz9+ehv+Ixv+s@bullseye>
References: <20230413-b4-vsock-dgram-v2-0-079cc7cee62e@bytedance.com>
 <20230413-b4-vsock-dgram-v2-2-079cc7cee62e@bytedance.com>
 <AM0PR04MB47238453B33915D18F247ABBD4999@AM0PR04MB4723.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM0PR04MB47238453B33915D18F247ABBD4999@AM0PR04MB4723.eurprd04.prod.outlook.com>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DATE_IN_PAST_06_12,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 14, 2023 at 08:47:52AM +0000, Alvaro Karsz wrote:
> Hi Bobby,
> 
> >  /* The feature bitmap for virtio vsock */
> >  #define VIRTIO_VSOCK_F_SEQPACKET       1       /* SOCK_SEQPACKET supported */
> > +#define VIRTIO_VSOCK_F_DGRAM           2       /* Host support dgram vsock */
> 
> Seems that bit 2 is already taken by VIRTIO_VSOCK_F_NO_IMPLIED_STREAM.
> 
> https://github.com/oasis-tcs/virtio-spec/commit/26ed30ccb049fd51d6e20aad3de2807d678edb3a

Right! I'll bump that in the next rev.

Thanks,
Bobby
