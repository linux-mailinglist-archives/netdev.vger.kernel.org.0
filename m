Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9213F59343E
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 19:56:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230506AbiHOR4W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 13:56:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiHOR4W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 13:56:22 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C04915FCD;
        Mon, 15 Aug 2022 10:56:21 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id u133so7193760pfc.10;
        Mon, 15 Aug 2022 10:56:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc;
        bh=mTDkW67VAczUKBcX25GMqVP3oIKQhzniMNz61JrBOoE=;
        b=Yfl8cpVVMsDvl/jn3SxFLjhyNCTpZJ0L3m8+/4Fhjzgmmh4KQWnERqPQh6hMkeu6Mm
         kNFysQUwEBNg7QFjaHy2DfcqBnFDs0+GLpfIJyIG20rPDSbTAgSLk4M6ez5I506pRIFl
         rcBi1CnmFwqBr6LjqlmcIjRqlN5yxp1iDG+GL0fRSJu576ZYOi8mf4ODYGVr9YRWZBI9
         4BbYMIKugmmXG0HqCGgnBJfn5cUJFzIf8qCG4fnhOno5XSilXdckffhna9gkLV53m/UW
         1J677lSm1frZ+uAaP4av9jZ9GZYMue4PyCnXEtajUy4fA5/Bamtq/RYNrkwMwsOiiGm2
         5CuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-message-state:from:to:cc;
        bh=mTDkW67VAczUKBcX25GMqVP3oIKQhzniMNz61JrBOoE=;
        b=In3PzwSLJy/c14QUFAQ2h5YgItGKG4/YVjM9mtqV9vpr1wwgdNXtxHxXp6P8gXf8+n
         hJgk0aSGNduhR2GA97fkHGdkfhYkjR7Tc5uZN5kqmq+OZ3CmIWIU8G6CL2XbL/6y5hos
         B2g8pcOjp961WJBry/Rpq3evedWMbpiAZ2nXaV9BJyKgc7CdxoF363uUrwg2Fv0kjPWa
         9eROrJKQq0DO0TbzWg4rgh0T07ZujpLMwrbC3Y0V2J9BueBtjHtKXud+ieGCTNzoK4s1
         5bFsrVODaa27mPsgIRtBKsUWIveZI84znWQC1PvMnlECCq5Zqx1f9HwjOZI7laz37uuD
         iPPw==
X-Gm-Message-State: ACgBeo1yj8nQfsjBbPgTHeVJYf3fpNmoKitOkur/UbCkAGrs187xjFqn
        9W6/evK1wna5tCgUXf3wt2UTNJidsXrAWOMdJ8U=
X-Google-Smtp-Source: AA6agR78eY49FGkhmn23865l/0o+sM7I5JFzKGAY34SUM1+OiiMVQ43DmRxvllR8E2cxHTbucOGVSQ==
X-Received: by 2002:a05:6a00:a82:b0:530:2f3c:ec99 with SMTP id b2-20020a056a000a8200b005302f3cec99mr17320077pfl.53.1660586180705;
        Mon, 15 Aug 2022 10:56:20 -0700 (PDT)
Received: from C02G8BMUMD6R.bytedance.net (c-73-164-155-12.hsd1.wa.comcast.net. [73.164.155.12])
        by smtp.gmail.com with ESMTPSA id o5-20020a170902d4c500b0016d6963cb12sm7299935plg.304.2022.08.15.10.56.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Aug 2022 10:56:20 -0700 (PDT)
Sender: Bobby Eshleman <bobbyeshleman@gmail.com>
From:   Bobby Eshleman <bobby.eshleman@gmail.com>
X-Google-Original-From: Bobby Eshleman <bobby.eshleman@bytedance.com>
Cc:     Bobby Eshleman <bobbyeshleman@gmail.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
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
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org
Subject: [PATCH 0/6] virtio/vsock: introduce dgrams, sk_buff, and qdisc
Date:   Mon, 15 Aug 2022 10:56:03 -0700
Message-Id: <cover.1660362668.git.bobby.eshleman@bytedance.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey everybody,

This series introduces datagrams, packet scheduling, and sk_buff usage
to virtio vsock.

The usage of struct sk_buff benefits users by a) preparing vsock to use
other related systems that require sk_buff, such as sockmap and qdisc,
b) supporting basic congestion control via sock_alloc_send_skb, and c)
reducing copying when delivering packets to TAP.

The socket layer no longer forces errors to be -ENOMEM, as typically
userspace expects -EAGAIN when the sk_sndbuf threshold is reached and
messages are being sent with option MSG_DONTWAIT.

The datagram work is based off previous patches by Jiang Wang[1].

The introduction of datagrams creates a transport layer fairness issue
where datagrams may freely starve streams of queue access. This happens
because, unlike streams, datagrams lack the transactions necessary for
calculating credits and throttling.

Previous proposals introduce changes to the spec to add an additional
virtqueue pair for datagrams[1]. Although this solution works, using
Linux's qdisc for packet scheduling leverages already existing systems,
avoids the need to change the virtio specification, and gives additional
capabilities. The usage of SFQ or fq_codel, for example, may solve the
transport layer starvation problem. It is easy to imagine other use
cases as well. For example, services of varying importance may be
assigned different priorities, and qdisc will apply appropriate
priority-based scheduling. By default, the system default pfifo qdisc is
used. The qdisc may be bypassed and legacy queuing is resumed by simply
setting the virtio-vsock%d network device to state DOWN. This technique
still allows vsock to work with zero-configuration.

In summary, this series introduces these major changes to vsock:

- virtio vsock supports datagrams
- virtio vsock uses struct sk_buff instead of virtio_vsock_pkt
  - Because virtio vsock uses sk_buff, it also uses sock_alloc_send_skb,
    which applies the throttling threshold sk_sndbuf.
- The vsock socket layer supports returning errors other than -ENOMEM.
  - This is used to return -EAGAIN when the sk_sndbuf threshold is
    reached.
- virtio vsock uses a net_device, through which qdisc may be used.
 - qdisc allows scheduling policies to be applied to vsock flows.
  - Some qdiscs, like SFQ, may allow vsock to avoid transport layer congestion. That is,
    it may avoid datagrams from flooding out stream flows. The benefit
    to this is that additional virtqueues are not needed for datagrams.
  - The net_device and qdisc is bypassed by simply setting the
    net_device state to DOWN.

[1]: https://lore.kernel.org/all/20210914055440.3121004-1-jiang.wang@bytedance.com/

Bobby Eshleman (5):
  vsock: replace virtio_vsock_pkt with sk_buff
  vsock: return errors other than -ENOMEM to socket
  vsock: add netdev to vhost/virtio vsock
  virtio/vsock: add VIRTIO_VSOCK_F_DGRAM feature bit
  virtio/vsock: add support for dgram

Jiang Wang (1):
  vsock_test: add tests for vsock dgram

 drivers/vhost/vsock.c                   | 238 ++++----
 include/linux/virtio_vsock.h            |  73 ++-
 include/net/af_vsock.h                  |   2 +
 include/uapi/linux/virtio_vsock.h       |   2 +
 net/vmw_vsock/af_vsock.c                |  30 +-
 net/vmw_vsock/hyperv_transport.c        |   2 +-
 net/vmw_vsock/virtio_transport.c        | 237 +++++---
 net/vmw_vsock/virtio_transport_common.c | 771 ++++++++++++++++--------
 net/vmw_vsock/vmci_transport.c          |   9 +-
 net/vmw_vsock/vsock_loopback.c          |  51 +-
 tools/testing/vsock/util.c              | 105 ++++
 tools/testing/vsock/util.h              |   4 +
 tools/testing/vsock/vsock_test.c        | 195 ++++++
 13 files changed, 1176 insertions(+), 543 deletions(-)

-- 
2.35.1

