Return-Path: <netdev+bounces-808-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 675636F9FC8
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 08:23:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0E0F8280F74
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 06:23:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4A9E1548C;
	Mon,  8 May 2023 06:18:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7541442B
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 06:18:23 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DBF61FD0
	for <netdev@vger.kernel.org>; Sun,  7 May 2023 23:18:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683526701;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=twNVqqauWglNgKKrdFKUfRfF/HMwG9acwMp36woonWA=;
	b=QdLKK1Yq4DZzwj30AfcpFlPiUX7mYgIcN71LSWMtblcFFzpOtCne1gjdbHNKzcqAxlUfU1
	QEequIAVpabYOsgPModDbzoa5jxX6FMnRSd9lVCE94MMuYqRyjzCfLJSHkirPRDDRs1EQH
	XLn1llykN5gbS12quweVCz68/Sj1tLE=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-637-EGKFtM1pMNu4CnfICTpKSA-1; Mon, 08 May 2023 02:18:20 -0400
X-MC-Unique: EGKFtM1pMNu4CnfICTpKSA-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-30634323dfeso1438981f8f.3
        for <netdev@vger.kernel.org>; Sun, 07 May 2023 23:18:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683526699; x=1686118699;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=twNVqqauWglNgKKrdFKUfRfF/HMwG9acwMp36woonWA=;
        b=HpLK8x+5ew3nt1dS8xclPv1ugJyPaR39viqbSmL5eADmBwVhHjIibzUiIPTE3FOHuz
         XQM8DUJxbXiqeaNvcfFD3D0IGBOuWzKSTYQs2ZBb88dlTDR+I1pViDbaS/yWzf9LORcZ
         4jV/tHeHv0/KyEfear8cI6Ab75aAdgxwFjr701kSndH6X8UwXbjz6HouUxQulkiXc2pT
         CxSopjwomDccXtiHUYGU/AD7zgkK0sHFHAsW8rBst1YAKo8F4ovRwDDHS+b+CHd9+2G2
         0FEymUm9lpqZ8PNzXeXU5ik04WdTBVNYQJCOV86CIuysZxnxWY4L2pfy7i5Xe11J8fUM
         OQ4g==
X-Gm-Message-State: AC+VfDxhdmig6ZtQXXkhnID948oKzN5sseAgzj6brz53IYxGOXqmlr8F
	QMsuBqb2FAdyCpEiUih70H9BX1QKS1wRzCtFCJRJ42gAKTG1nPtaXIYoZ0+VxPrMAT0Wbyr25+t
	f69hoRi6HjTZgfBU/
X-Received: by 2002:a5d:43c4:0:b0:307:6278:611a with SMTP id v4-20020a5d43c4000000b003076278611amr6983772wrr.21.1683526699119;
        Sun, 07 May 2023 23:18:19 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4xKmKhnerUW03D9p2QkXzZlk0/X16EpWQ6gzcG7QI5oWBVZfiaRw8SsukRANFbpIHqbmlbaA==
X-Received: by 2002:a5d:43c4:0:b0:307:6278:611a with SMTP id v4-20020a5d43c4000000b003076278611amr6983764wrr.21.1683526698837;
        Sun, 07 May 2023 23:18:18 -0700 (PDT)
Received: from redhat.com ([2.52.158.28])
        by smtp.gmail.com with ESMTPSA id e1-20020adffc41000000b003063c130ef1sm10238380wrs.112.2023.05.07.23.18.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 May 2023 23:18:18 -0700 (PDT)
Date: Mon, 8 May 2023 02:18:14 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc: netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
Subject: Re: [PATCH net-next v5 00/15] virtio_net: refactor xdp codes
Message-ID: <20230508021807-mutt-send-email-mst@kernel.org>
References: <20230508061417.65297-1-xuanzhuo@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230508061417.65297-1-xuanzhuo@linux.alibaba.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 08, 2023 at 02:14:02PM +0800, Xuan Zhuo wrote:
> Due to historical reasons, the implementation of XDP in virtio-net is relatively
> chaotic. For example, the processing of XDP actions has two copies of similar
> code. Such as page, xdp_page processing, etc.
> 
> The purpose of this patch set is to refactor these code. Reduce the difficulty
> of subsequent maintenance. Subsequent developers will not introduce new bugs
> because of some complex logical relationships.
> 
> In addition, the supporting to AF_XDP that I want to submit later will also need
> to reuse the logic of XDP, such as the processing of actions, I don't want to
> introduce a new similar code. In this way, I can reuse these codes in the
> future.
> 
> Please review.
> 
> Thanks.

Series:

Acked-by: Michael S. Tsirkin <mst@redhat.com>


> v5:
>     1. replace "double counting" by "code duplication"
> 
> v2:
>     1. re-split to make review more convenient
> 
> v1:
>     1. fix some variables are uninitialized
> 
> 
> 
> 
> Xuan Zhuo (15):
>   virtio_net: mergeable xdp: put old page immediately
>   virtio_net: introduce mergeable_xdp_get_buf()
>   virtio_net: optimize mergeable_xdp_get_buf()
>   virtio_net: introduce virtnet_xdp_handler() to seprate the logic of
>     run xdp
>   virtio_net: separate the logic of freeing xdp shinfo
>   virtio_net: separate the logic of freeing the rest mergeable buf
>   virtio_net: virtnet_build_xdp_buff_mrg() auto release xdp shinfo
>   virtio_net: introduce receive_mergeable_xdp()
>   virtio_net: merge: remove skip_xdp
>   virtio_net: introduce receive_small_xdp()
>   virtio_net: small: remove the delta
>   virtio_net: small: avoid code duplication in xdp scenarios
>   virtio_net: small: remove skip_xdp
>   virtio_net: introduce receive_small_build_xdp
>   virtio_net: introduce virtnet_build_skb()
> 
>  drivers/net/virtio_net.c | 657 +++++++++++++++++++++++----------------
>  1 file changed, 384 insertions(+), 273 deletions(-)
> 
> --
> 2.32.0.3.g01195cf9f


