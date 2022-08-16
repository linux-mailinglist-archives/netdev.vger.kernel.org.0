Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B23E59604D
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 18:32:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234465AbiHPQbl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 12:31:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236503AbiHPQb2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 12:31:28 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90B9B7FF8A;
        Tue, 16 Aug 2022 09:31:27 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id r69so9692615pgr.2;
        Tue, 16 Aug 2022 09:31:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=OWA+Z0+/O1EA7heD+/eE4RpipBhiyIekMqq5kYmUIfs=;
        b=M+x6wNEzsTNJZ7HNuv5p+qPE7wTSY1jU1LA/N1j9ls2BfESkr9bENtx2G4I2WAOBKF
         SkQJKneOmbCgTk6RXVwmBfB+X7o1CxRpt75aAXQ0PQwwjeyqaNs+9J9SFPpoDcgFCpBD
         QTsu8P/88JljdjZwHHTxVnwlD5iNwhojAUJtMcfGEd5rEUgilpf6TW93ILO/ReyF2b/u
         6kAdX+kWmMGsFFoP2Lstept34RYIto5bBB7N7eMczQ4x4aBT+ULxQmTTCNz+fNRb3dlL
         HhiSp8Bfs9JRX/GWOBoTdZGw21+YdxcD6qy/pGmVy6rpbbsNetAZMcalJeZ3PxafFkOy
         g1kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=OWA+Z0+/O1EA7heD+/eE4RpipBhiyIekMqq5kYmUIfs=;
        b=3BImHZ3WNIO9Xm/Xgi5nbJPo5darSJrUicDUpUdtR3yvP5DxESTLRtU1dS1JFPP4o6
         HPFj4dOHnfLtA/lTbReSMQtgCK3YyiUc+9BH810u56JnhQPplvT43H/Tyds9UPzTDvAR
         e2mbU6Inxvky0091NUpou1j+QHmVx6CFmpnydHgB+O+rc60a/A2YJlVizRIZsxjziq3Q
         zNW3JAtI1YpnFAkkbrKAIhKLDv/poY3U5LyhBEbLea39e/E9NdsRNB65NaV/gwQBb8Ml
         Z2W9+oZnLSBnKk+t6h+G+yQZXFVK68A/knt/pXiMOzhjp9yh6Ob38Yt+3ktK76PINIan
         a6ig==
X-Gm-Message-State: ACgBeo1DTFomwFpjNeRFnhncTG0CdzU7jDIIefDkm9C4Q67q5OnmqYUo
        MwvRMO468Z0ZFBNIEFF824Y=
X-Google-Smtp-Source: AA6agR4Fv7w4ALaSxKqngT2CxCuZQR5SwOw0ac8clzW30E3xAO5Swo+o0p0bAyGj+86t+OGTbYP67g==
X-Received: by 2002:a63:d10b:0:b0:41d:bd7d:7759 with SMTP id k11-20020a63d10b000000b0041dbd7d7759mr18535300pgg.196.1660667487026;
        Tue, 16 Aug 2022 09:31:27 -0700 (PDT)
Received: from localhost (c-73-164-155-12.hsd1.wa.comcast.net. [73.164.155.12])
        by smtp.gmail.com with ESMTPSA id k13-20020a170902ce0d00b0016d738d5dbbsm9257840plg.97.2022.08.16.09.31.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 09:31:26 -0700 (PDT)
Date:   Tue, 16 Aug 2022 02:35:42 +0000
From:   Bobby Eshleman <bobbyeshleman@gmail.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     Bobby Eshleman <bobby.eshleman@gmail.com>,
        Wei Liu <wei.liu@kernel.org>,
        Cong Wang <cong.wang@bytedance.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Dexuan Cui <decui@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Eric Dumazet <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 0/6] virtio/vsock: introduce dgrams, sk_buff, and qdisc
Message-ID: <YvsCftVUqurKIaCC@bullseye>
References: <cover.1660362668.git.bobby.eshleman@bytedance.com>
 <CAGxU2F7+L-UiNPtUm4EukOgTVJ1J6Orqs1LMvhWWvfL9zWb23g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGxU2F7+L-UiNPtUm4EukOgTVJ1J6Orqs1LMvhWWvfL9zWb23g@mail.gmail.com>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DATE_IN_PAST_12_24,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 16, 2022 at 09:00:45AM +0200, Stefano Garzarella wrote:
> Hi Bobby,

..

> 
> Please send next versions of this series as RFC until we have at least an
> agreement on the spec changes.
> 
> I think will be better to agree on the spec before merge Linux changes.
> 
> Thanks,
> Stefano
> 

Duly noted, I'll tag it as RFC on the next send.


Best,
Bobby
