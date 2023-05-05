Return-Path: <netdev+bounces-489-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 979BE6F7B81
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 05:28:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8FF27280F76
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 03:28:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 329571854;
	Fri,  5 May 2023 03:28:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2322915A4
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 03:28:43 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0CE7AD15
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 20:28:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683257319;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vtGTOV4w8H+HmedJBYfP7zUt+D2uJS6ykp/9DQHbib8=;
	b=Yt2Nu0A32sp18bYqItXmjOFCla2i7ry/vUKiupQUoZRFRw/m6w817Ymrp06xKBTxqVMuqw
	3D/PsUpbAtNxwEBJQf9dDpvYQQUOSz7B+KyzR26VjMO+FkLLE4ZQypR+oc1GtIHuyC7Mml
	QJmM2AJyqSFUS2hk9XWbwzF9tLAb9Is=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-635-F0TuNwZONqqxZHAy3vYy-w-1; Thu, 04 May 2023 23:28:38 -0400
X-MC-Unique: F0TuNwZONqqxZHAy3vYy-w-1
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-4edc5526c5eso692341e87.1
        for <netdev@vger.kernel.org>; Thu, 04 May 2023 20:28:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683257317; x=1685849317;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vtGTOV4w8H+HmedJBYfP7zUt+D2uJS6ykp/9DQHbib8=;
        b=HoUvHp/gDB2RwMpbCb+8/YKYO5nPH5ldBu6JaVZ7FWEpl4iHi2cETjE99ClV9uLX+y
         QPK06ThY7UYFtFyxYiqVySZ1J4fKExgdjTd9EBxBePJvXSFKBSbIl8jaOkXM2Xhlyp2m
         +6mSB7pqhEOZIYx7SlAsRnMTzG3jU/3sJjihx5k1trOqpgoB6G5HbAIsiYrKD5Jh0eVX
         TW+Z5rvI/k1OClxjNS97TH+R13xz2Qpdzv6ux5IA1e+ArOiu82OukskBryuxvJ1qo1X3
         G2I5BQ5b/QLTr+Dd/YC2pdymtbt3TVuMx16s8Nq6+b7KUTeYRcr0AYeW4saciaVPtsG7
         Eh4Q==
X-Gm-Message-State: AC+VfDwCU+7lceJOpPxqqv24hmqu0SIvZ0p4jGMr5shLExQ0S5mT8UwF
	FN11n+fjRV8+ZElI7HiC6oaoZYxGKv4iSeJasah/YUthHf2nex9JCrZfJzMViVEvtDkguF6oqF6
	2HgF6LI4DK3KCnrPjlB8aMrsdzFsdXCN/
X-Received: by 2002:ac2:4d1a:0:b0:4ec:363a:5f24 with SMTP id r26-20020ac24d1a000000b004ec363a5f24mr132433lfi.23.1683257317336;
        Thu, 04 May 2023 20:28:37 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6ipOT60VlicZnRmQ8NuJpg74uxqB+3AiqJuLc3hm+sdWRslDFolnCBok9HRcDycod3TakBwcUmh99tPZ15x4I=
X-Received: by 2002:ac2:4d1a:0:b0:4ec:363a:5f24 with SMTP id
 r26-20020ac24d1a000000b004ec363a5f24mr132425lfi.23.1683257317049; Thu, 04 May
 2023 20:28:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <1683167226-7012-1-git-send-email-wangwenliang.1995@bytedance.com>
In-Reply-To: <1683167226-7012-1-git-send-email-wangwenliang.1995@bytedance.com>
From: Jason Wang <jasowang@redhat.com>
Date: Fri, 5 May 2023 11:28:25 +0800
Message-ID: <CACGkMEs_4kUzc6iSBWvhZA1+U70Pp0o+WhE0aQnC-5pECW7QXA@mail.gmail.com>
Subject: Re: [PATCH v4] virtio_net: suppress cpu stall when free_unused_bufs
To: Wenliang Wang <wangwenliang.1995@bytedance.com>
Cc: mst@redhat.com, davem@davemloft.net, edumazet@google.com, kuba@kernel.org, 
	pabeni@redhat.com, zhengqi.arch@bytedance.com, 
	willemdebruijn.kernel@gmail.com, virtualization@lists.linux-foundation.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	xuanzhuo@linux.alibaba.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 4, 2023 at 10:27=E2=80=AFAM Wenliang Wang
<wangwenliang.1995@bytedance.com> wrote:
>
> For multi-queue and large ring-size use case, the following error
> occurred when free_unused_bufs:
> rcu: INFO: rcu_sched self-detected stall on CPU.
>
> Fixes: 986a4f4d452d ("virtio_net: multiqueue support")
> Signed-off-by: Wenliang Wang <wangwenliang.1995@bytedance.com>
> ---
> v2:
> -add need_resched check.
> -apply same logic to sq.
> v3:
> -use cond_resched instead.
> v4:
> -add fixes tag
> ---
>  drivers/net/virtio_net.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 8d8038538fc4..a12ae26db0e2 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -3560,12 +3560,14 @@ static void free_unused_bufs(struct virtnet_info =
*vi)
>                 struct virtqueue *vq =3D vi->sq[i].vq;
>                 while ((buf =3D virtqueue_detach_unused_buf(vq)) !=3D NUL=
L)
>                         virtnet_sq_free_unused_buf(vq, buf);
> +               cond_resched();

Does this really address the case when the virtqueue is very large?

Thanks

>         }
>
>         for (i =3D 0; i < vi->max_queue_pairs; i++) {
>                 struct virtqueue *vq =3D vi->rq[i].vq;
>                 while ((buf =3D virtqueue_detach_unused_buf(vq)) !=3D NUL=
L)
>                         virtnet_rq_free_unused_buf(vq, buf);
> +               cond_resched();
>         }
>  }
>
> --
> 2.20.1
>


