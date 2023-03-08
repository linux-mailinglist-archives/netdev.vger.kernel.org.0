Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE88E6B9AC4
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 17:12:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbjCNQMv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 12:12:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbjCNQMu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 12:12:50 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F51694F5C;
        Tue, 14 Mar 2023 09:12:48 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id u3-20020a17090a450300b00239db6d7d47so15648766pjg.4;
        Tue, 14 Mar 2023 09:12:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678810367;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=C5uLFf+sVT2J6M6gdOnHyNJaoWCkU+nFg/cWWB+zLDg=;
        b=oXneExBLdlhKkgG6l+TPOEUbFXHJ/7Q3qXRUj+qRHvWeasfzacN4r/EMx/+yVSJNBK
         IN1AnTFbIoorrI9swJm5gTCz457dPmnBCSzDAO/jyDh43ruFlFVkbNkJCJy87EF6Symn
         MeAe6DRCj139nfJuOiikCFAKYVklojUrGGG40v8+/ln+/4OXhdnaxifF6HjPB0BqZTLa
         R/WFCPF9ura2rX3LKXnvB8hkWNo3kc9q5aPDoAWEbbED0qEXvrzTNALKUUGCRBZfxuXT
         KtmcK1rvhmC5CUebSyzEnT7vsE7z/8cWRAucB3e0Szn1diQDi1lF9tKXQKUtytny83yF
         B0Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678810367;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C5uLFf+sVT2J6M6gdOnHyNJaoWCkU+nFg/cWWB+zLDg=;
        b=fy1m9vnv38m3QuSUS4e7nKy8xe+gIW8hyMknlnww+Wiq6j+FX4LloI00YF0BYDh8A8
         AN8H0dZD/01IB+8Iw4RqeZM33Sok3t/qBp86dDEIM6PGtqZayfYPGDohQLgL/Aa0fMEU
         mN67uDZdrHVQEd7nVSt1GatZ0/Dnh8erbfcsVxT/DV4rkHPTAxLJ1w0FvDglq3NReFyB
         Wv8PeM20/1Icwz2K+bFWAwUa/qbHK85SuOI08MmrVP3qvogekKmXtf9cV4C1Y2dcATqA
         UINcZRNHMmG5K2m5PVy/5JYjNt0/cKnXybP0FkXrImWmPyxqOuj2hxMoQUvdykAp8B0O
         WF3g==
X-Gm-Message-State: AO0yUKXa9nu5g36vqNtBmGnUUUDMNMH1uqmTgN9sHEKnS10HtAItKecX
        Ac9oWtSUjErhzw0/lJXJIAs=
X-Google-Smtp-Source: AK7set8gH5kS9KTR5Tz4rtKTS6LOvzmQ/hY1opLiL6ivcduLJ+FWhGt3+j6/AOzCQP3I5Zwfl/7ewQ==
X-Received: by 2002:a17:902:e54f:b0:19d:d14:d48a with SMTP id n15-20020a170902e54f00b0019d0d14d48amr46133724plf.3.1678810367436;
        Tue, 14 Mar 2023 09:12:47 -0700 (PDT)
Received: from localhost (ec2-54-67-115-33.us-west-1.compute.amazonaws.com. [54.67.115.33])
        by smtp.gmail.com with ESMTPSA id t3-20020a170902a5c300b0019a6e8ceb49sm1924524plq.259.2023.03.14.09.12.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 09:12:47 -0700 (PDT)
Date:   Wed, 8 Mar 2023 15:15:04 +0000
From:   Bobby Eshleman <bobbyeshleman@gmail.com>
To:     Arseniy Krasnov <avkrasnov@sberdevices.ru>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@sberdevices.ru, oxffffaa@gmail.com
Subject: Re: [PATCH RESEND net v4 2/4] virtio/vsock: remove redundant
 'skb_pull()' call
Message-ID: <ZAimeNvNmdFz2/ns@bullseye>
References: <1bfcb7fd-bce3-30cf-8a58-8baa57b7345c@sberdevices.ru>
 <75e3f51b-2848-d3ce-a995-4ac8320663f6@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <75e3f51b-2848-d3ce-a995-4ac8320663f6@sberdevices.ru>
X-Spam-Status: No, score=1.3 required=5.0 tests=BAYES_00,DATE_IN_PAST_96_XX,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 02:06:53PM +0300, Arseniy Krasnov wrote:
> Since we now no longer use 'skb->len' to update credit, there is no sense
> to update skbuff state, because it is used only once after dequeue to
> copy data and then will be released.
> 
> Fixes: 71dc9ec9ac7d ("virtio/vsock: replace virtio_vsock_pkt with sk_buff")
> Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
> Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
>  net/vmw_vsock/virtio_transport_common.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
> index 618680fd9906..9a411475e201 100644
> --- a/net/vmw_vsock/virtio_transport_common.c
> +++ b/net/vmw_vsock/virtio_transport_common.c
> @@ -465,7 +465,6 @@ static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
>  					dequeued_len = err;
>  				} else {
>  					user_buf_len -= bytes_to_copy;
> -					skb_pull(skb, bytes_to_copy);
>  				}
>  
>  				spin_lock_bh(&vvs->rx_lock);
> -- 
> 2.25.1

Acked-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
