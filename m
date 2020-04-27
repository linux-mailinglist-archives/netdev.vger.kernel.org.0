Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCEDA1B967E
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 07:27:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726460AbgD0F1G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 01:27:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726172AbgD0F1G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 01:27:06 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C403BC061A0F;
        Sun, 26 Apr 2020 22:27:05 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id i19so17480146ioh.12;
        Sun, 26 Apr 2020 22:27:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=H2oJ5XA6LXnBsivbio4jQlN7ghxS0Va0pZyULsoo4y8=;
        b=i8wLonqv1AqR1oBd2XtZq2fV4C3nPsAjXqxPEjcFdjKu7DOlaQLl71cQwQWwT74Ofo
         tulp8hxG77Pnp2mvXSDNbU5hER0h+SIT391f26otRzC/Z6HpB+ZxZTTv5qT88VLhVM05
         6ZfEwH2Y/ljW57RORJ/1fjs7/CXD6OKFLY9YOi3Vm1AhHsqbjVItHfo1lFObcnt0OQ6Y
         KY5ky2hY5AbDUDZUP2sVw1Tb7com7c4rbFJtWTExyHMziGRHeMUz2NLqlcQDdbyY2NNi
         R9+0wexKHJ6V0tQBu9DLba5r82loan3OUTVbiDtg9ctHb3xZQr5HQt12EeSwU5UbnGvV
         s9Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=H2oJ5XA6LXnBsivbio4jQlN7ghxS0Va0pZyULsoo4y8=;
        b=uEh2/QiLuX989Vr2n3BYs1DXrP2SDFPqlPVWrPoiUdxTUHM3RYSlLsph88T4hvftUH
         GIT0zIAMEvPb8V8Z4WJ6OYUXBF/J6S9VndGTukAntN77Gz34JrhdBD2VOsoM5IDLcpGS
         86QqRPwNeKxc/1PoCGbm1s6t6zLU7xNa2QFudzFko9NClXgLy1E08Z3u8eq5ztU3Qx8c
         MILXAseXvC4rOo/f9hoNRekEksLFMVv1ndcWa37DWEurvIolgED3zfeeCpwsMFpf1keu
         mXjGzPd3zw6nFBQbw9jfTqO55wz9kgtw8hEvtN2u3AmRdmA+rLz1/skXJfxpolmkAA4u
         E/Kg==
X-Gm-Message-State: AGi0PuaFMD1muNdnnmCejKYvQ/JhT0kjLJyMXV9wpYp4L0ZXBk8oPOkP
        UUzb4URoIvSLhDz+g1C5ZeY=
X-Google-Smtp-Source: APiQypJDMj2PEqqeFoNhX2Bs/6M6IpRSO2tuHW7BSlA1RCc8Vg7Ua/9mEd1Aw7myVrFi9KAEhWAdpA==
X-Received: by 2002:a02:9f94:: with SMTP id a20mr18437156jam.40.1587965225184;
        Sun, 26 Apr 2020 22:27:05 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id o19sm5109097ild.42.2020.04.26.22.27.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Apr 2020 22:27:03 -0700 (PDT)
Date:   Sun, 26 Apr 2020 22:26:54 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>, sameehj@amazon.com
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, zorik@amazon.com, akiyano@amazon.com,
        gtzalik@amazon.com,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        steffen.klassert@secunet.com
Message-ID: <5ea66d1ec37bc_59462aeb755845b848@john-XPS-13-9370.notmuch>
In-Reply-To: <158757179349.1370371.14581472372520364962.stgit@firesoul>
References: <158757160439.1370371.13213378122947426220.stgit@firesoul>
 <158757179349.1370371.14581472372520364962.stgit@firesoul>
Subject: RE: [PATCH net-next 30/33] xdp: clear grow memory in
 bpf_xdp_adjust_tail()
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jesper Dangaard Brouer wrote:
> Clearing memory of tail when grow happens, because it is too easy
> to write a XDP_PASS program that extend the tail, which expose
> this memory to users that can run tcpdump.
> 
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---

Hi Jesper, Thanks for the series any idea what the cost of doing
this is? If you have some data I would be curious to know a
baseline measurment, a grow with memset, then a grow with memset.
I'm guess this can be relatively expensive?

>  net/core/filter.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 5e9c387f74eb..889d96a690c2 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -3442,6 +3442,10 @@ BPF_CALL_2(bpf_xdp_adjust_tail, struct xdp_buff *, xdp, int, offset)
>  	if (unlikely(data_end < xdp->data + ETH_HLEN))
>  		return -EINVAL;
>  
> +	/* Clear memory area on grow, can contain uninit kernel memory */
> +	if (offset > 0)
> +		memset(xdp->data_end, 0, offset);
> +
>  	xdp->data_end = data_end;
>  
>  	return 0;
> 
> 


