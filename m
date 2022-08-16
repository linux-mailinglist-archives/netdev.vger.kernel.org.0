Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EEBA5975AE
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 20:27:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240686AbiHQS0r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 14:26:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238247AbiHQS0q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 14:26:46 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 925829A99E;
        Wed, 17 Aug 2022 11:26:45 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id d65-20020a17090a6f4700b001f303a97b14so2728075pjk.1;
        Wed, 17 Aug 2022 11:26:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=I3Pf9OIc8DGk9E58AEq8EGcTaeKj6hHjSLnNzQDAIvY=;
        b=kS0yawzf1I+kUu55z3yGa7UPahuYejKLOOwqu6RtPwZfrKieepYLPWvrsSuUAEm1MC
         pq/Sk2LQEGYKJBW1g3eEmBJlkozfRJv+7JAv1fG/avwFLrzvnO17rs3ywJC4DLC8b5B1
         A8X49MWFQCmYVYL9hEKrHlrAeYOXTuoCM/2AZ5ICrIMtiTPNGe8g71zYWURkJRLqauVR
         vaLHGkPHFoVMBStTMT6HexyG2jx1t6aJiPvEXhqQp0OIipEfmFxh690OT9PJ2RcwBQrx
         biK5KCk/H0UopTmUGXm/eVMx+rU9i0XfmspEJMi8LscRIcHcdPhBenb/KMMwTE4yKRgL
         TIYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=I3Pf9OIc8DGk9E58AEq8EGcTaeKj6hHjSLnNzQDAIvY=;
        b=S6/kwjRXnAQqZDTc0VEw2dOSwf/43yAGNc/reJ0T9SpNVUQOXXVJ8zKpA9e8lYCyyd
         mUaaW2absM10QU39OmGiBrvv3plEa4YyhqwHfKDygMJcG8HeHN0kKqFSnrQhApJJyNbK
         A6wzENrfVeXznIi9WtE9eNkg9fRiRvnASNlBgvPEI5jBH8QBpzsDso3o4OAFOcEPgQTw
         u0fWbEPkARGyplQrEFn6arsml9tQWkUccTJIuWaJXTYbmhAKgZQeoTkeHYfARcjT25vm
         OAiOz3XJcqqWKidxG58lDGtU6K6mPW61Mihn5LjYOgYmzKtXWn6a7Xa44crf0ggEvHVX
         bvEg==
X-Gm-Message-State: ACgBeo2CHahVZyI5SF2a4oP+y+AKxbu22h0PzaeFgM6OWCpEmTbIjTTg
        23s64/cgOHpnG++lXvKOIcY=
X-Google-Smtp-Source: AA6agR43iEdqfdHIoOSbjahQdXE7/joUWXo6Xi/riiIPDrHY+FAs3Crt6ENsOaOMai5oVvlO63eDqA==
X-Received: by 2002:a17:902:d890:b0:16c:abb4:94d0 with SMTP id b16-20020a170902d89000b0016cabb494d0mr28016185plz.50.1660760805029;
        Wed, 17 Aug 2022 11:26:45 -0700 (PDT)
Received: from localhost (c-73-164-155-12.hsd1.wa.comcast.net. [73.164.155.12])
        by smtp.gmail.com with ESMTPSA id g11-20020aa796ab000000b0052da654301esm11115800pfk.170.2022.08.17.11.26.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 11:26:44 -0700 (PDT)
Date:   Tue, 16 Aug 2022 12:10:25 +0000
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
Message-ID: <YvuJJTVV8+r7MXNc@bullseye>
References: <cover.1660362668.git.bobby.eshleman@bytedance.com>
 <20220817025250-mutt-send-email-mst@kernel.org>
 <YvtmYpMieMFb80qR@bullseye>
 <20220817130044-mutt-send-email-mst@kernel.org>
 <Yvt6nxUYMfDrLd/A@bullseye>
 <20220817135311-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220817135311-mutt-send-email-mst@kernel.org>
X-Spam-Status: No, score=-0.8 required=5.0 tests=BAYES_00,DATE_IN_PAST_24_48,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 17, 2022 at 01:53:32PM -0400, Michael S. Tsirkin wrote:
> On Tue, Aug 16, 2022 at 11:08:26AM +0000, Bobby Eshleman wrote:
> > On Wed, Aug 17, 2022 at 01:02:52PM -0400, Michael S. Tsirkin wrote:
> > > On Tue, Aug 16, 2022 at 09:42:51AM +0000, Bobby Eshleman wrote:
> > > > > The basic question to answer then is this: with a net device qdisc
> > > > > etc in the picture, how is this different from virtio net then?
> > > > > Why do you still want to use vsock?
> > > > > 
> > > > 
> > > > When using virtio-net, users looking for inter-VM communication are
> > > > required to setup bridges, TAPs, allocate IP addresses or setup DNS,
> > > > etc... and then finally when you have a network, you can open a socket
> > > > on an IP address and port. This is the configuration that vsock avoids.
> > > > For vsock, we just need a CID and a port, but no network configuration.
> > > 
> > > Surely when you mention DNS you are going overboard? vsock doesn't
> > > remove the need for DNS as much as it does not support it.
> > > 
> > 
> > Oops, s/DNS/dhcp.
> 
> That too.
> 

Sure, setting up dhcp would be overboard for just inter-VM comms.

It is fair to mention that vsock CIDs also need to be managed /
allocated somehow.
