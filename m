Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE45B5EB320
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 23:31:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230003AbiIZVa7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 17:30:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229832AbiIZVa5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 17:30:57 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C46BB70E6D;
        Mon, 26 Sep 2022 14:30:55 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id 129so6271827pgc.5;
        Mon, 26 Sep 2022 14:30:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=CJgECI9GSZwbRImCn+I7/z8LmCg9UFNYzoXCC6Gp6b8=;
        b=fWfHJ1EtHfULrHPqq+CX9bCj1kaALCWEIFQUeQkL1X6ZtPWa2p+FutjLJX2mnB4tFP
         QUwZQQioanBVFwRupD0MqUOTeXTDyEu0vV9p7xX65+iENlzooh5wOBfVyUlagRutlDLA
         M37yzHimmh6GVhYGEYJSJr3JGCA+R+3+aJpxCCHT8SEDvDSYUvzMCk6NDr5W2mIgGCMC
         RxTLldMmW+Gfga1SQt03K71vVgR4dwWdU2tz3jUgNrdbMo1Od2+cuP8nXU4+F1eCwmNh
         2rfH07VEo41+y/vOk7wqAxwrA8W6po2SwKV562XEV/M2FaGQhq2U7Z9RMojAhL3sNs8T
         obwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=CJgECI9GSZwbRImCn+I7/z8LmCg9UFNYzoXCC6Gp6b8=;
        b=pazeLnCnC/LIR1YPMIukp/ZGKxmLxyixlQyKcQ5hj8rwz/0iJOERXq+gPx4640ApV3
         tj5Kxx1qFZvSVrTnKhe3glhtujIc8BxvA+1ycO28J3wmlZL3Zdf07/f0hbPnDgF8L+Z3
         b8QnDd2zdX65M+ZrCLUD8k/F10zVBPQnqBKV3CTf67FIGuqq3pls4Ghh+/i48VH9xU5F
         YGtl9mma8ELZkz8PaF5XFztUhB1CcwXbadbegsyIzdk4wC1ySwj9Lvj8sbgUkehGh/re
         c5TUNW2SKC7pboxd2mBWz434COTIGIb3cdXO5iXvgnQf1pXgA2Gq6OioihTM/n/Rc5cV
         JPlg==
X-Gm-Message-State: ACrzQf0iytnFIDscLwkYvjSgM+01giUsnKu5Iy52SNgZjaLelsr58pSC
        qYV9xGRBNySaMm2XFqXQ2/k=
X-Google-Smtp-Source: AMsMyM530VmWjcHqhukVESF49I5E0pR4S1Np4w9YJnGIorJFnLTGftQP3cSyhurkf4w2Ad7pGznUCQ==
X-Received: by 2002:aa7:838a:0:b0:536:101a:9ccf with SMTP id u10-20020aa7838a000000b00536101a9ccfmr25585686pfm.18.1664227855098;
        Mon, 26 Sep 2022 14:30:55 -0700 (PDT)
Received: from localhost (c-73-164-155-12.hsd1.wa.comcast.net. [73.164.155.12])
        by smtp.gmail.com with ESMTPSA id js17-20020a17090b149100b001fb0fc33d72sm7007744pjb.47.2022.09.26.14.30.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 14:30:54 -0700 (PDT)
Date:   Mon, 26 Sep 2022 21:30:53 +0000
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
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>, kvm@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-hyperv@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 2/6] vsock: return errors other than -ENOMEM to socket
Message-ID: <YzIaDbYnbFUT6Jr/@bullseye>
References: <cover.1660362668.git.bobby.eshleman@bytedance.com>
 <d81818b868216c774613dd03641fcfe63cc55a45.1660362668.git.bobby.eshleman@bytedance.com>
 <20220926132145.utv2rzswhejhxrvb@sgarzare-redhat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220926132145.utv2rzswhejhxrvb@sgarzare-redhat>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 26, 2022 at 03:21:45PM +0200, Stefano Garzarella wrote:
> On Mon, Aug 15, 2022 at 10:56:05AM -0700, Bobby Eshleman wrote:
> > This commit allows vsock implementations to return errors
> > to the socket layer other than -ENOMEM. One immediate effect
> > of this is that upon the sk_sndbuf threshold being reached -EAGAIN
> > will be returned and userspace may throttle appropriately.
> > 
> > Resultingly, a known issue with uperf is resolved[1].
> > 
> > Additionally, to preserve legacy behavior for non-virtio
> > implementations, hyperv/vmci force errors to be -ENOMEM so that behavior
> > is unchanged.
> > 
> > [1]: https://gitlab.com/vsock/vsock/-/issues/1
> > 
> > Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
> > ---
> > include/linux/virtio_vsock.h            | 3 +++
> > net/vmw_vsock/af_vsock.c                | 3 ++-
> > net/vmw_vsock/hyperv_transport.c        | 2 +-
> > net/vmw_vsock/virtio_transport_common.c | 3 ---
> > net/vmw_vsock/vmci_transport.c          | 9 ++++++++-
> > 5 files changed, 14 insertions(+), 6 deletions(-)
> > 
> > diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
> > index 17ed01466875..9a37eddbb87a 100644
> > --- a/include/linux/virtio_vsock.h
> > +++ b/include/linux/virtio_vsock.h
> > @@ -8,6 +8,9 @@
> > #include <net/sock.h>
> > #include <net/af_vsock.h>
> > 
> > +/* Threshold for detecting small packets to copy */
> > +#define GOOD_COPY_LEN  128
> > +
> 
> This change seems unrelated.
> 
> Please move it in the patch where you need this.
> Maybe it's better to add a prefix if we move it in an header file (e.g.
> VIRTIO_VSOCK_...).
> 
> Thanks,
> Stefano
> 

Oh yes, definitely.

Thanks,
Bobby

> > enum virtio_vsock_metadata_flags {
> > 	VIRTIO_VSOCK_METADATA_FLAGS_REPLY		= BIT(0),
> > 	VIRTIO_VSOCK_METADATA_FLAGS_TAP_DELIVERED	= BIT(1),
> > diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
> > index e348b2d09eac..1893f8aafa48 100644
> > --- a/net/vmw_vsock/af_vsock.c
> > +++ b/net/vmw_vsock/af_vsock.c
> > @@ -1844,8 +1844,9 @@ static int vsock_connectible_sendmsg(struct socket *sock, struct msghdr *msg,
> > 			written = transport->stream_enqueue(vsk,
> > 					msg, len - total_written);
> > 		}
> > +
> > 		if (written < 0) {
> > -			err = -ENOMEM;
> > +			err = written;
> > 			goto out_err;
> > 		}
> > 
> > diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_transport.c
> > index fd98229e3db3..e99aea571f6f 100644
> > --- a/net/vmw_vsock/hyperv_transport.c
> > +++ b/net/vmw_vsock/hyperv_transport.c
> > @@ -687,7 +687,7 @@ static ssize_t hvs_stream_enqueue(struct vsock_sock *vsk, struct msghdr *msg,
> > 	if (bytes_written)
> > 		ret = bytes_written;
> > 	kfree(send_buf);
> > -	return ret;
> > +	return ret < 0 ? -ENOMEM : ret;
> > }
> > 
> > static s64 hvs_stream_has_data(struct vsock_sock *vsk)
> > diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
> > index 920578597bb9..d5780599fe93 100644
> > --- a/net/vmw_vsock/virtio_transport_common.c
> > +++ b/net/vmw_vsock/virtio_transport_common.c
> > @@ -23,9 +23,6 @@
> > /* How long to wait for graceful shutdown of a connection */
> > #define VSOCK_CLOSE_TIMEOUT (8 * HZ)
> > 
> > -/* Threshold for detecting small packets to copy */
> > -#define GOOD_COPY_LEN  128
> > -
> > static const struct virtio_transport *
> > virtio_transport_get_ops(struct vsock_sock *vsk)
> > {
> > diff --git a/net/vmw_vsock/vmci_transport.c b/net/vmw_vsock/vmci_transport.c
> > index b14f0ed7427b..c927a90dc859 100644
> > --- a/net/vmw_vsock/vmci_transport.c
> > +++ b/net/vmw_vsock/vmci_transport.c
> > @@ -1838,7 +1838,14 @@ static ssize_t vmci_transport_stream_enqueue(
> > 	struct msghdr *msg,
> > 	size_t len)
> > {
> > -	return vmci_qpair_enquev(vmci_trans(vsk)->qpair, msg, len, 0);
> > +	int err;
> > +
> > +	err = vmci_qpair_enquev(vmci_trans(vsk)->qpair, msg, len, 0);
> > +
> > +	if (err < 0)
> > +		err = -ENOMEM;
> > +
> > +	return err;
> > }
> > 
> > static s64 vmci_transport_stream_has_data(struct vsock_sock *vsk)
> > -- 
> > 2.35.1
> > 
> 
> _______________________________________________
> Virtualization mailing list
> Virtualization@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/virtualization
