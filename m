Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 610F6596038
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 18:31:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236411AbiHPQ1L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 12:27:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236397AbiHPQ1J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 12:27:09 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DFDE7B7A0;
        Tue, 16 Aug 2022 09:27:07 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id s36-20020a17090a69a700b001faad0a7a34so515137pjj.4;
        Tue, 16 Aug 2022 09:27:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=Iy+lcK0z1Pv9kZZ/l2ldtDAdFaOohY4aditAQU865N8=;
        b=UgUacS841BUW2A0gjmS9P2fm8xwyFNWB/NxCwLTu1FYyCYwPFtYeiqShlGy1cbXULy
         LzL6O/HWYDV06qsabtIVgsJ1n9yfdDmY+MxKGhNb1eZd8eBibmvxHw2ehtXO5oce18Dl
         bZYDpJ8dKBl1kIEim6z/ky+TOHRVkwxsne9Do7KeetA6qjQisUHzVNfgjqIWpjL/C+2H
         aVqWR0in+NFHlIk3w0qAZt/ldCYLH2xJGVm0Td2TtA1EgfBTpgcBDrDlYfp+AQN2w9LD
         CgURhAkDbGkeJqf1AyL6pLaUcaELfYXqDUJB66jAQa/MG2LzoZchnuASqEDvAVHugDHn
         spMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=Iy+lcK0z1Pv9kZZ/l2ldtDAdFaOohY4aditAQU865N8=;
        b=nluwZnXwVH6TyxJdm0gGHTZSotBn4UvFvoVnzoN6rx/0EsBbGGuO6QxFjrXkpAjysz
         FWnQOFfurQk4VT2rPmv0qJsvCNI3BlkKWWd8EtrvAvDbOodqLzkbxS5rCyEE8BSQ9R/9
         yD1oGWqJagaDvBRGDBOeLBuiHp9y8WIq73bAZiyx3M69RqrWoBAgEX9pmMXZvVYzatJ9
         Ll9u1LkG+y/VCl0+WZ75/hsNq3opsb/1Tg8KBnW3qxfW6jHmewxSwI8p2Ps+AprhJin/
         wytHo6cELFjgRV+9mOGvOPryuBXuus3Dc6/WYDLUcYyW+BbBDzVt5b6qdx4sOPOTjXOm
         hZWA==
X-Gm-Message-State: ACgBeo0U0tRGunMEdCSKhZf0ZmTJUMH3sLdd/XnOncIy3dFEeYaCjzdB
        1XwcpO9t0mfD6ix+fcbr1rw=
X-Google-Smtp-Source: AA6agR7Yv47tj7AOeGDfaSc5dIL4Zz5VCGqdvitrY4IlPGps5RA8SimPfwZfDF4OebiCdyVIW+mItQ==
X-Received: by 2002:a17:90b:3141:b0:1f7:75cf:a449 with SMTP id ip1-20020a17090b314100b001f775cfa449mr24069838pjb.18.1660667226565;
        Tue, 16 Aug 2022 09:27:06 -0700 (PDT)
Received: from localhost (c-73-164-155-12.hsd1.wa.comcast.net. [73.164.155.12])
        by smtp.gmail.com with ESMTPSA id n12-20020a17090a394c00b001f2ef3c7956sm6544549pjf.25.2022.08.16.09.27.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 09:27:05 -0700 (PDT)
Date:   Tue, 16 Aug 2022 02:30:59 +0000
From:   Bobby Eshleman <bobbyeshleman@gmail.com>
To:     Bobby Eshleman <bobby.eshleman@gmail.com>
Cc:     virtio-dev@lists.oasis-open.org,
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
Subject: Re: [PATCH 2/6] vsock: return errors other than -ENOMEM to socket
Message-ID: <YvsBYyPFnKRhvPfp@bullseye>
References: <cover.1660362668.git.bobby.eshleman@bytedance.com>
 <d81818b868216c774613dd03641fcfe63cc55a45.1660362668.git.bobby.eshleman@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d81818b868216c774613dd03641fcfe63cc55a45.1660362668.git.bobby.eshleman@bytedance.com>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DATE_IN_PAST_12_24,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CC'ing virtio-dev@lists.oasis-open.org

On Mon, Aug 15, 2022 at 10:56:05AM -0700, Bobby Eshleman wrote:
> This commit allows vsock implementations to return errors
> to the socket layer other than -ENOMEM. One immediate effect
> of this is that upon the sk_sndbuf threshold being reached -EAGAIN
> will be returned and userspace may throttle appropriately.
> 
> Resultingly, a known issue with uperf is resolved[1].
> 
> Additionally, to preserve legacy behavior for non-virtio
> implementations, hyperv/vmci force errors to be -ENOMEM so that behavior
> is unchanged.
> 
> [1]: https://gitlab.com/vsock/vsock/-/issues/1
> 
> Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
> ---
>  include/linux/virtio_vsock.h            | 3 +++
>  net/vmw_vsock/af_vsock.c                | 3 ++-
>  net/vmw_vsock/hyperv_transport.c        | 2 +-
>  net/vmw_vsock/virtio_transport_common.c | 3 ---
>  net/vmw_vsock/vmci_transport.c          | 9 ++++++++-
>  5 files changed, 14 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
> index 17ed01466875..9a37eddbb87a 100644
> --- a/include/linux/virtio_vsock.h
> +++ b/include/linux/virtio_vsock.h
> @@ -8,6 +8,9 @@
>  #include <net/sock.h>
>  #include <net/af_vsock.h>
>  
> +/* Threshold for detecting small packets to copy */
> +#define GOOD_COPY_LEN  128
> +
>  enum virtio_vsock_metadata_flags {
>  	VIRTIO_VSOCK_METADATA_FLAGS_REPLY		= BIT(0),
>  	VIRTIO_VSOCK_METADATA_FLAGS_TAP_DELIVERED	= BIT(1),
> diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
> index e348b2d09eac..1893f8aafa48 100644
> --- a/net/vmw_vsock/af_vsock.c
> +++ b/net/vmw_vsock/af_vsock.c
> @@ -1844,8 +1844,9 @@ static int vsock_connectible_sendmsg(struct socket *sock, struct msghdr *msg,
>  			written = transport->stream_enqueue(vsk,
>  					msg, len - total_written);
>  		}
> +
>  		if (written < 0) {
> -			err = -ENOMEM;
> +			err = written;
>  			goto out_err;
>  		}
>  
> diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_transport.c
> index fd98229e3db3..e99aea571f6f 100644
> --- a/net/vmw_vsock/hyperv_transport.c
> +++ b/net/vmw_vsock/hyperv_transport.c
> @@ -687,7 +687,7 @@ static ssize_t hvs_stream_enqueue(struct vsock_sock *vsk, struct msghdr *msg,
>  	if (bytes_written)
>  		ret = bytes_written;
>  	kfree(send_buf);
> -	return ret;
> +	return ret < 0 ? -ENOMEM : ret;
>  }
>  
>  static s64 hvs_stream_has_data(struct vsock_sock *vsk)
> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
> index 920578597bb9..d5780599fe93 100644
> --- a/net/vmw_vsock/virtio_transport_common.c
> +++ b/net/vmw_vsock/virtio_transport_common.c
> @@ -23,9 +23,6 @@
>  /* How long to wait for graceful shutdown of a connection */
>  #define VSOCK_CLOSE_TIMEOUT (8 * HZ)
>  
> -/* Threshold for detecting small packets to copy */
> -#define GOOD_COPY_LEN  128
> -
>  static const struct virtio_transport *
>  virtio_transport_get_ops(struct vsock_sock *vsk)
>  {
> diff --git a/net/vmw_vsock/vmci_transport.c b/net/vmw_vsock/vmci_transport.c
> index b14f0ed7427b..c927a90dc859 100644
> --- a/net/vmw_vsock/vmci_transport.c
> +++ b/net/vmw_vsock/vmci_transport.c
> @@ -1838,7 +1838,14 @@ static ssize_t vmci_transport_stream_enqueue(
>  	struct msghdr *msg,
>  	size_t len)
>  {
> -	return vmci_qpair_enquev(vmci_trans(vsk)->qpair, msg, len, 0);
> +	int err;
> +
> +	err = vmci_qpair_enquev(vmci_trans(vsk)->qpair, msg, len, 0);
> +
> +	if (err < 0)
> +		err = -ENOMEM;
> +
> +	return err;
>  }
>  
>  static s64 vmci_transport_stream_has_data(struct vsock_sock *vsk)
> -- 
> 2.35.1
> 
