Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEC3A1B77F0
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 16:05:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727091AbgDXOEv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 10:04:51 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:22648 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726987AbgDXOEu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 10:04:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587737089;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0VuZCm8HvCNkNO0M8vLGp4C0YFmiV3243zClgfZKZD0=;
        b=VuXNyDHEtMJLRutLOrM3RsJ4IqmUYwxHgOoIBtn4EyylSFYhnMjeh5gYltPKhw3/F1J1C2
        jb1SUGX5km46KmNLr5GnZnxJNZYvjHTFR4MdJ9mI0fBhSHsRH4y6NYFyGqZs9aKBB0khpi
        Lxltfq5RpnpiLiVCPfFQr/b2kLGIMlk=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-427-sUg_UKKaPLOX5pJVQE5APQ-1; Fri, 24 Apr 2020 10:04:47 -0400
X-MC-Unique: sUg_UKKaPLOX5pJVQE5APQ-1
Received: by mail-lj1-f198.google.com with SMTP id m4so1803049lji.23
        for <netdev@vger.kernel.org>; Fri, 24 Apr 2020 07:04:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=0VuZCm8HvCNkNO0M8vLGp4C0YFmiV3243zClgfZKZD0=;
        b=i9CQDmQA8AHj1hI0KNFR2+6PnGTeQ12QIVUI1jewywUeqZvV8U2AmopUDDjxG5hDxI
         8HB/EGSL7TvsoLLOw427UAZl754P99RGNCU9Ib/xr/nEz8VfXKcHW8EYyT77fTiO3nsO
         VnF8l+sihLFVsZSg18xjJxGohuT2lBtNFZJ8JW5NAGbOL5bCAiQk+jfC7Tl+cvkx87mD
         n5HMlZ4pnxTHOO8AKhIYAMoiKFCyLeWqI7I/tdQp28mzoCZOf7q2+YsZvGcy1lpxO7Ya
         GiFMwwPhjUZwTZxv8GhvJIICmQqDPKCajrhW2TKzJqAFvgp/3RZsLmjJSR2dUrUXj3CU
         QXPg==
X-Gm-Message-State: AGi0PuYgUJg6HE6CJEO27sUvNM4uZDmlKG0vMoy6oQKWWBnkZXpzciNg
        +fs1qDow9omOhdt+h5RsP4bmZvSjWaF4hFxd9bSDKaTN7jdTstXPgzsxH58vxUZrbYIrgLo99KK
        F3MtW0tA5iBVIXtnQ
X-Received: by 2002:a2e:9990:: with SMTP id w16mr6015965lji.194.1587737086238;
        Fri, 24 Apr 2020 07:04:46 -0700 (PDT)
X-Google-Smtp-Source: APiQypIcYuzHqe2Le/bdEmwoFanwD5jjtMRUpUe/Z7es4/wA8F/fojolHJVuYI3fbdh5xL/dy9YHFg==
X-Received: by 2002:a2e:9990:: with SMTP id w16mr6015940lji.194.1587737085934;
        Fri, 24 Apr 2020 07:04:45 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id z13sm4316533ljn.77.2020.04.24.07.04.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2020 07:04:32 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 889121814FF; Fri, 24 Apr 2020 16:04:19 +0200 (CEST)
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
Subject: Re: [PATCH net-next 08/33] xdp: cpumap redirect use frame_sz and increase skb_tailroom
In-Reply-To: <158757168168.1370371.11510167625755235041.stgit@firesoul>
References: <158757160439.1370371.13213378122947426220.stgit@firesoul> <158757168168.1370371.11510167625755235041.stgit@firesoul>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 24 Apr 2020 16:04:19 +0200
Message-ID: <875zdp3rq4.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jesper Dangaard Brouer <brouer@redhat.com> writes:

> Knowing the memory size backing the packet/xdp_frame data area, and
> knowing it already have reserved room for skb_shared_info, simplifies
> using build_skb significantly.
>
> With this change we no-longer lie about the SKB truesize, but more
> importantly a significant larger skb_tailroom is now provided, e.g. when
> drivers uses a full PAGE_SIZE. This extra tailroom (in linear area) can be
> used by the network stack when coalescing SKBs (e.g. in skb_try_coalesce,
> see TCP cases where tcp_queue_rcv() can 'eat' skb).
>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

