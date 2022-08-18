Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 509D85AF96C
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 03:44:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbiIGBoU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 21:44:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiIGBoT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 21:44:19 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD21A7FFAC;
        Tue,  6 Sep 2022 18:44:17 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id q15-20020a17090a304f00b002002ac83485so9323758pjl.0;
        Tue, 06 Sep 2022 18:44:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=BvyWfUoKFedS2O3cuEWewtWgL/+UsS4AV/bMppR9YBY=;
        b=QwssDy6i5gOjaJYF0wf9BVXVDSjLOzIQRMaSA5lTCd+pQJypukFNAATJgcu4+qBveH
         Rmv1dnZbUFRwg9hfKk9T0q1WMSfFbDqn+zjplt7l/MRVTV6cv7nKW+SH/0Xaa+PRxrex
         zs621Zjtz6jvPJFV7hOGyTlEFgaTLgqw6KEjyrXGVtUnue/nciEOcnEFkFmcpKLzxHuw
         E7VMXGHWPkth38v+npm+H2yxT5dsEfkh4HdsVgS2I3VGeS9xvDLTBDcJltVVAU2ld3XU
         yrjMpsk7wTzF5lrR03LJZpGScJvuV/DxMXck1+MY0J5+BrNTvT+KLudtwevmDOWGu0S7
         F/Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=BvyWfUoKFedS2O3cuEWewtWgL/+UsS4AV/bMppR9YBY=;
        b=pi6vAt1lvTMyMeZGVpQebvwrd5+f5jKtP0MSKpuGMdH4zqGyxgO+EUTXU/PRdAR3bv
         ZOonnQAvZMMNoy1TZtm/6UU5jCr6j5kzB8OJr68JhLNo+E4roEhKnG7OsR7IfUyUHfEf
         lT/20Gu34NoVSVKDfqIrX1KyB9LhdFqsZr+VmZwJdV5jIGuIyWSmtqzefMb7mS0mXdub
         Uin0zY9a+PJ5/gsTjrdPn6JOnEpICcp/w9NcSTUCsIPGKTCpFjb6FRo+ula+HUD4P76h
         tWM29lPYzcVDPHKHMXeH4nW9RgezPN4jnD5vTE3CVO0auaTfs6e11SAgipM4t/AQTgFi
         wLGQ==
X-Gm-Message-State: ACgBeo2Fk54g9IVEMN8Xw5ooHzge5Hb/jbuaO8x/yTZMB99PSW8kQYsw
        uQDXdL7c8BGJiJU8Yv1ox6A=
X-Google-Smtp-Source: AA6agR7iTgTbHnCw9ar66lt9Q7u+yBE+eq3kHUld5PUljWZFXkSpFPVy2E7fHubXuGcSxTspNf7Xjg==
X-Received: by 2002:a17:90b:4a02:b0:1fe:1391:314d with SMTP id kk2-20020a17090b4a0200b001fe1391314dmr28380891pjb.216.1662515057196;
        Tue, 06 Sep 2022 18:44:17 -0700 (PDT)
Received: from localhost (ec2-13-57-97-131.us-west-1.compute.amazonaws.com. [13.57.97.131])
        by smtp.gmail.com with ESMTPSA id i11-20020a056a00004b00b0053ba52b49a3sm7275713pfk.25.2022.09.06.18.44.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Sep 2022 18:44:16 -0700 (PDT)
Date:   Thu, 18 Aug 2022 14:20:06 +0000
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
        Paolo Abeni <pabeni@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] vsock: add netdev to vhost/virtio vsock
Message-ID: <Yv5KVHgUtcpHgWML@bullseye>
References: <cover.1660362668.git.bobby.eshleman@bytedance.com>
 <5a93c5aad99d79f028d349cb7e3c128c65d5d7e2.1660362668.git.bobby.eshleman@bytedance.com>
 <20220906065523-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220906065523-mutt-send-email-mst@kernel.org>
X-Spam-Status: No, score=1.3 required=5.0 tests=BAYES_00,DATE_IN_PAST_96_XX,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 06, 2022 at 06:58:32AM -0400, Michael S. Tsirkin wrote:
> On Mon, Aug 15, 2022 at 10:56:06AM -0700, Bobby Eshleman wrote:
> > In order to support usage of qdisc on vsock traffic, this commit
> > introduces a struct net_device to vhost and virtio vsock.
> > 
> > Two new devices are created, vhost-vsock for vhost and virtio-vsock
> > for virtio. The devices are attached to the respective transports.
> > 
> > To bypass the usage of the device, the user may "down" the associated
> > network interface using common tools. For example, "ip link set dev
> > virtio-vsock down" lets vsock bypass the net_device and qdisc entirely,
> > simply using the FIFO logic of the prior implementation.
> > 
> > For both hosts and guests, there is one device for all G2H vsock sockets
> > and one device for all H2G vsock sockets. This makes sense for guests
> > because the driver only supports a single vsock channel (one pair of
> > TX/RX virtqueues), so one device and qdisc fits. For hosts, this may not
> > seem ideal for some workloads. However, it is possible to use a
> > multi-queue qdisc, where a given queue is responsible for a range of
> > sockets. This seems to be a better solution than having one device per
> > socket, which may yield a very large number of devices and qdiscs, all
> > of which are dynamically being created and destroyed. Because of this
> > dynamism, it would also require a complex policy management daemon, as
> > devices would constantly be spun up and down as sockets were created and
> > destroyed. To avoid this, one device and qdisc also applies to all H2G
> > sockets.
> > 
> > Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
> 
> 
> I've been thinking about this generally. vsock currently
> assumes reliability, but with qdisc can't we get
> packet drops e.g. depending on the queueing?
> 
> What prevents user from configuring such a discipline?
> One thing people like about vsock is that it's very hard
> to break H2G communication even with misconfigured
> networking.
> 

If qdisc decides to discard a packet, it returns NET_XMIT_CN via
dev_queue_xmit(). This v1 allows this quietly, but v2 could return
an error to the user (-ENOMEM or maybe -ENOBUFS) when this happens, similar
to when vsock is unable to enqueue a packet currently.

The user could still, for example, choose the noop qdisc. Assuming the
v2 change mentioned above, their sendmsg() calls will return errors.
Similar to how if they choose the wrong CID they will get an error when
connecting a socket.

Best,
Bobby
