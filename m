Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C7BD1B77BB
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 16:01:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728073AbgDXOBD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 10:01:03 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:31068 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726968AbgDXOBD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 10:01:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587736861;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JqV6csMf2d/oC1hVByib6X4BqL6+W9+JGkigoSnBbHM=;
        b=dhOhdYS1WOM/qwLAkxRbwmgBR8yDYB6EWJWA2BBDhqaj/iG3Rb5YKZBHmZmpg9AlamIUB6
        fjgJrk7gGGcu3sTs+rC9mqgNrSlQMVfoX5gWR41ZNGcwNm/7D5WFNA1marUMcNTcvVF6zA
        03vkuZyrpB6du7dXACvH5KxjKWiKeMM=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-395-tOAtXt7EPXeD-a819esHsA-1; Fri, 24 Apr 2020 10:01:00 -0400
X-MC-Unique: tOAtXt7EPXeD-a819esHsA-1
Received: by mail-lf1-f72.google.com with SMTP id v22so3956156lfa.1
        for <netdev@vger.kernel.org>; Fri, 24 Apr 2020 07:00:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=JqV6csMf2d/oC1hVByib6X4BqL6+W9+JGkigoSnBbHM=;
        b=RAZG6b2qASqosVQdJVgNzDQ3wv6r14YwSKu8yyED2Yb3UbSPgAkdDWR6R3Q5sfux0z
         CFXI3pqSxtkI3YTU8i3Hm33jVXQA8+m+Kx0WBRNldR4CpuW0q8SJTFR0gxJbBx2D17XK
         osEE5LB2KV2/1vCgeNjN1EEDoqFqkDAyvNyB4937wXoJVxwSHogOUJQ7ACdnaxUaii55
         lCiskhiU4Ugg9hwkDqmBaAWORmzqLyHRGoEYwnk81tIxVPHZXfF8kfO1UXHtYwj/w7Gj
         N4Z6S4B1BqNOOa3t3GgTEmV3YTKRPceFp2+3KdrHi/kVuwX5GyxPmcaTfXZAYQceC6LT
         qBSw==
X-Gm-Message-State: AGi0Pub/Rw6mNbbe9aJdRBN6LPFp30ApdLgyQTFy203qZOQTUZi/E03A
        82LEM9a8tX6OdmWWYkcCHwQ6mt+EA8IsI3dkfiF3q5Ex2pUrAeZTGcsifj/URCw+ewylSce8MXp
        VUCW/DPABQGfonejO
X-Received: by 2002:a2e:a311:: with SMTP id l17mr6025776lje.106.1587736858395;
        Fri, 24 Apr 2020 07:00:58 -0700 (PDT)
X-Google-Smtp-Source: APiQypLFMBlsGM2Z2iNZhFhTOd6GpNHHs8QXLXB0sALxjHaaOWp9qIgvpqMi9sWEsNXM2SMOTGecaw==
X-Received: by 2002:a2e:a311:: with SMTP id l17mr6025740lje.106.1587736857812;
        Fri, 24 Apr 2020 07:00:57 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id t81sm4559912lff.52.2020.04.24.07.00.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2020 07:00:55 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 597571814FF; Fri, 24 Apr 2020 16:00:53 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>, sameehj@amazon.com
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, zorik@amazon.com, akiyano@amazon.com,
        gtzalik@amazon.com, Daniel Borkmann <borkmann@iogearbox.net>,
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
Subject: Re: [PATCH net-next 01/33] xdp: add frame size to xdp_buff
In-Reply-To: <158757164613.1370371.2655437650342381672.stgit@firesoul>
References: <158757160439.1370371.13213378122947426220.stgit@firesoul> <158757164613.1370371.2655437650342381672.stgit@firesoul>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 24 Apr 2020 16:00:53 +0200
Message-ID: <87eesd3rvu.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jesper Dangaard Brouer <brouer@redhat.com> writes:

> XDP have evolved to support several frame sizes, but xdp_buff was not
> updated with this information. The frame size (frame_sz) member of
> xdp_buff is introduced to know the real size of the memory the frame is
> delivered in.
>
> When introducing this also make it clear that some tailroom is
> reserved/required when creating SKBs using build_skb().
>
> It would also have been an option to introduce a pointer to
> data_hard_end (with reserved offset). The advantage with frame_sz is
> that (like rxq) drivers only need to setup/assign this value once per
> NAPI cycle. Due to XDP-generic (and some drivers) it's not possible to
> store frame_sz inside xdp_rxq_info, because it's varies per packet as it
> can be based/depend on packet length.
>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>

With one possible nit below:

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

> ---
>  include/net/xdp.h |   13 +++++++++++++
>  1 file changed, 13 insertions(+)
>
> diff --git a/include/net/xdp.h b/include/net/xdp.h
> index 40c6d3398458..1ccf7df98bee 100644
> --- a/include/net/xdp.h
> +++ b/include/net/xdp.h
> @@ -6,6 +6,8 @@
>  #ifndef __LINUX_NET_XDP_H__
>  #define __LINUX_NET_XDP_H__
>=20=20
> +#include <linux/skbuff.h> /* skb_shared_info */
> +
>  /**
>   * DOC: XDP RX-queue information
>   *
> @@ -70,8 +72,19 @@ struct xdp_buff {
>  	void *data_hard_start;
>  	unsigned long handle;
>  	struct xdp_rxq_info *rxq;
> +	u32 frame_sz; /* frame size to deduct data_hard_end/reserved tailroom*/

I think maybe you want to s/deduct/deduce/ here?

-Toke

