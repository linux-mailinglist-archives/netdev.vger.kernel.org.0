Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7ADE159751B
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 19:29:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238421AbiHQR3p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 13:29:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241106AbiHQR3c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 13:29:32 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59EA5130;
        Wed, 17 Aug 2022 10:29:32 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id s31-20020a17090a2f2200b001faaf9d92easo2444640pjd.3;
        Wed, 17 Aug 2022 10:29:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=aM3wrL4Fp4MEnHsKbqc+hHkzDolBQyAgPj8hCdYOSxg=;
        b=Rhxe4k4xHun8nsdmCVCBrJmiv1l4fwnoMler6GOgLSgZz205jK5YZ/0nhz9K9Q27Gq
         lHlRqEMXVGqq1eW0XXb46wbt7WWByYxxk9oPLrHAYwRGoCA9u80k5T2Yof6Euj9UupmT
         oBy/pcebDpgXE657jRwmVGCJJL2dPEQh3jH6Btdz0fC6aKVEmkcIUTmSZxuu+WkoVg/n
         HZC5ckQ/fB5V9tdRPDYlqbt4EhsN0ZQwxhR0j5R9e11bMHUwA2NIbRuT2fNqX2bNaWHc
         UcTmZEri35uQf1op67DuNSUl3No4SAegUxO3t6ubxjH6AXLmUDew/F3g3xomqhpyXMT1
         6+jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=aM3wrL4Fp4MEnHsKbqc+hHkzDolBQyAgPj8hCdYOSxg=;
        b=0ClJKoLVCQWTInE85q0xx3yNeFFWImEo7IMzNm7gJBQjxC48F2vcYT9kO765Jw0Ork
         EZ2uVxj5UK1uALz0uDSLPJaX8BzzMYWZPnLZ7GluJJ9mx1DRVJdJUgK0dpmGThPxGfRY
         Q32YaPjA4uxV0ZDNG/LcWfQYqp32i3XaUvgfaf5jjKf0niptPNu69xIOgfWIMhNHEbOS
         p57v2UpgwT7KKiL9wfpEb5RBQrg817gPpkhBbRrbqBQLvNd7NBC8aA6jx/PFkMca/RjO
         rrbJ0Ab4jJEJ2Zx9r9JTO3cQMQ+xsViaGr0QdaxTv3D05vojJDY/EWhm130u06cy9xTI
         w/hQ==
X-Gm-Message-State: ACgBeo0qTeExYI1Ma51Y2SZRmDpzIxJJHyeZqZH3I5kQTOe0M5xTZQqB
        u8qkN6hvbuN9hcK8EYtJi2I=
X-Google-Smtp-Source: AA6agR63sQa3hgQVIDCnk8BJZi1Azr3oDTU0znMG3TzLEJCrYfTIX+5H+FG+ik/fWHtXQGSIQY3dRg==
X-Received: by 2002:a17:90b:380b:b0:1fa:b6a7:87d7 with SMTP id mq11-20020a17090b380b00b001fab6a787d7mr3628620pjb.111.1660757371866;
        Wed, 17 Aug 2022 10:29:31 -0700 (PDT)
Received: from localhost (c-73-164-155-12.hsd1.wa.comcast.net. [73.164.155.12])
        by smtp.gmail.com with ESMTPSA id c7-20020aa79527000000b0052dd7d0ad02sm10747149pfp.162.2022.08.17.10.29.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 10:29:31 -0700 (PDT)
Date:   Tue, 16 Aug 2022 11:08:26 +0000
From:   Bobby Eshleman <bobbyeshleman@gmail.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Bobby Eshleman <bobby.eshleman@gmail.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org
Subject: Re: [PATCH 0/6] virtio/vsock: introduce dgrams, sk_buff, and qdisc
Message-ID: <Yvt6nxUYMfDrLd/A@bullseye>
References: <cover.1660362668.git.bobby.eshleman@bytedance.com>
 <20220817025250-mutt-send-email-mst@kernel.org>
 <YvtmYpMieMFb80qR@bullseye>
 <20220817130044-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220817130044-mutt-send-email-mst@kernel.org>
X-Spam-Status: No, score=-0.8 required=5.0 tests=BAYES_00,DATE_IN_PAST_24_48,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 17, 2022 at 01:02:52PM -0400, Michael S. Tsirkin wrote:
> On Tue, Aug 16, 2022 at 09:42:51AM +0000, Bobby Eshleman wrote:
> > > The basic question to answer then is this: with a net device qdisc
> > > etc in the picture, how is this different from virtio net then?
> > > Why do you still want to use vsock?
> > > 
> > 
> > When using virtio-net, users looking for inter-VM communication are
> > required to setup bridges, TAPs, allocate IP addresses or setup DNS,
> > etc... and then finally when you have a network, you can open a socket
> > on an IP address and port. This is the configuration that vsock avoids.
> > For vsock, we just need a CID and a port, but no network configuration.
> 
> Surely when you mention DNS you are going overboard? vsock doesn't
> remove the need for DNS as much as it does not support it.
> 

Oops, s/DNS/dhcp.
