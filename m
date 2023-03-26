Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3CBE6C9797
	for <lists+netdev@lfdr.de>; Sun, 26 Mar 2023 21:20:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231786AbjCZTUh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 15:20:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbjCZTUg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 15:20:36 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99FDC5263;
        Sun, 26 Mar 2023 12:20:35 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id p203so7914285ybb.13;
        Sun, 26 Mar 2023 12:20:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679858435;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oG/w6m6QtpmYcph7ogXNw2Cb+L528y4HO8hE3WHqySk=;
        b=RuYjs/StRoPkkDWrvmwXiGOQ4iyHBLQ/oUc4LBwsJU954HQ34/la6MiLmEMMLNjbqa
         ZiUeOh17f/1xc5lpEgOWba9hMrolYNI2qlhsq4ilNa1fsdj763IHQLcbbtmWlRouvS+U
         dSrhFSfzFxbzx8uTZEIfCUeszCpSx4HsO84dNQebYcswk4G/8jz7sbQ3dA0ol3PQ+waP
         iB4UqDUppIJIX1r2twnkAJr8idV7fWN8MV3e85gpPvi18qlrTsFtoHk6k71NHG36rprB
         swGIloWRV55T8523Do1MGQ3E2dVOcCW0XtgX2jKeLiU0qmhKETcks2Xzm46REysaFt5s
         Evhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679858435;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oG/w6m6QtpmYcph7ogXNw2Cb+L528y4HO8hE3WHqySk=;
        b=SitwAuNnrUXK5/XvvQboxos8yY8/RtcRC4khWBhH9F7onDyKDNp/P5s+X39jnTjiGn
         ozuJW5szbo0kvgA47lHTkLk1UjETFm0xKCGziXoCwkNb8mb6u6qVcLUGvZZdBFOte2Qm
         PtQSRMAhn2H/qxQME5aNEh4xuQp00eaVX5VSsfWpvkL+ipcT/mOwemxDHDHmso9iYpt+
         dVqvSmLpjFkiBq/R09snLDAtYdWC1ikA8K6g29uCI3+z6sZns2h/55NciPzCtip0QpIS
         XOzemTXUuJdpc+96y0YW7hR3v7CrPhVu7xO0xSl2D4x9uam2eXd9yox7UrsrYcFytX1i
         lR5g==
X-Gm-Message-State: AAQBX9fa9DgrjOKwsW8ChczYsu1WDKcIBw3TZsyXqpHQAChNUmMPMPEl
        uqoDU7BpV4e9csMqTraWoJw=
X-Google-Smtp-Source: AKy350ZX9Q/+0ojpsMuhWZXN3EJq3mCPftR76gOQ189+2+0EJNrC6JBFXYC2V/t/39GIYgzP3Km5zA==
X-Received: by 2002:a25:2650:0:b0:b65:f335:2875 with SMTP id m77-20020a252650000000b00b65f3352875mr9567454ybm.37.1679858434757;
        Sun, 26 Mar 2023 12:20:34 -0700 (PDT)
Received: from localhost ([2600:1700:65a0:ab60:2049:9ff4:d425:1853])
        by smtp.gmail.com with ESMTPSA id 64-20020a250643000000b00b7767ca749esm1874211ybg.59.2023.03.26.12.20.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Mar 2023 12:20:34 -0700 (PDT)
Date:   Sun, 26 Mar 2023 12:20:33 -0700
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     Bobby Eshleman <bobbyeshleman@gmail.com>
Cc:     Stefano Garzarella <sgarzare@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Bobby Eshleman <bobby.eshleman@gmail.com>,
        syzbot <syzbot+0bc015ebddc291a97116@syzkaller.appspotmail.com>,
        axboe@kernel.dk, davem@davemloft.net, edumazet@google.com,
        io-uring@vger.kernel.org, kuba@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, stefanha@redhat.com,
        syzkaller-bugs@googlegroups.com,
        virtualization@lists.linux-foundation.org,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        Krasnov Arseniy Vladimirovich <AVKrasnov@sberdevices.ru>
Subject: Re: [syzbot] [net?] [virt?] [io-uring?] [kvm?] BUG: soft lockup in
 vsock_connect
Message-ID: <ZCCbATwov4U+GBUv@pop-os.localdomain>
References: <00000000000075bebb05f79acfde@google.com>
 <CAGxU2F4jxdzK8Y-jaoKRaX_bDhoMtomOT6TyMek+un-Bp8RX3g@mail.gmail.com>
 <ZBUGp5bvNuE3sK5g@bullseye>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZBUGp5bvNuE3sK5g@bullseye>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 18, 2023 at 12:32:39AM +0000, Bobby Eshleman wrote:
> On Fri, Mar 24, 2023 at 09:38:38AM +0100, Stefano Garzarella wrote:
> > Hi Bobby,
> > FYI we have also this one, but it seems related to
> > syzbot+befff0a9536049e7902e@syzkaller.appspotmail.com
> > 
> > Thanks,
> > Stefano
> > 
> 
> Got it, I'll look into it.
> 

It seems you forgot to set skb->sk??

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 957cdc01c8e8..d47ad27b409d 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -236,6 +236,7 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
        }

        virtio_transport_inc_tx_pkt(vvs, skb);
+       skb_set_owner_w(skb, sk_vsock(vsk));

        return t_ops->send_pkt(skb);
 }

