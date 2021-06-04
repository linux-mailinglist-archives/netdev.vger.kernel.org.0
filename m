Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3DF639B0A1
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 04:56:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229867AbhFDC51 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 22:57:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:27376 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229576AbhFDC50 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 22:57:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622775340;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z5Yy/Eia0fr/9rnx2a/3XJTF6Pp5rYFEVjfdEJ4j4cA=;
        b=eiARpoXMfW9sOHZtK241Sv6Pf/zyH7SAWuJYrzUN8DfXB3VyCrM8OxIv0dD1lP9j0pvPQv
        uBjqk8A9v7MwUiCCWZMkoY6bGuKd/k4roAcdQQCHHIo8akrF11ghiWuY62FFKMTxkvhAXG
        P5y8hG8XYd8St+nh7ck7Q8DPx0CpXPg=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-516-qn0FDpkYNuelbW7TXCWy8A-1; Thu, 03 Jun 2021 22:55:39 -0400
X-MC-Unique: qn0FDpkYNuelbW7TXCWy8A-1
Received: by mail-pj1-f69.google.com with SMTP id c13-20020a17090aa60db029015c73ea2ce5so4979075pjq.0
        for <netdev@vger.kernel.org>; Thu, 03 Jun 2021 19:55:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=z5Yy/Eia0fr/9rnx2a/3XJTF6Pp5rYFEVjfdEJ4j4cA=;
        b=ZIdzhkrt1Rqm9SxprqofIaFwXg2r7QCxiRYbLkAuTKFEIKmyiqjdibGGvvPAGvYHL4
         Imobt3lDL6+dVYSePgA8jHjrCltUA3M+hmtCVUWJOZJiqFlQA1NCIT9ih4MCzDeEdj+m
         Jj9fNiVxuCaUDuK7iy7miR0VnSeEGoUDHYSoSa2mcFu986Ft0idIv5KYdyXXO4Ok/cgC
         HRiv/BB763ABu8nxxY/UHPqiI8jH8i+sY1wKMdPR8ctLE2VG3aX1OF6xeGE6PtMkvrXi
         tfoNfe//jN3wkRPbg+0jEJpseNwyX2vbnL8y+/1o7vQLbqz3RuXkhCuunuHCjyDkovFR
         8eaw==
X-Gm-Message-State: AOAM53109cSag4i2ncUVAXgGBVFcy9W80TB9F/MKB/iuV5eI9j5+cQ9A
        urKQeCGy5I7elLq7uVl6moP8YLGpr5YXLTCSYqemzDSAF44E49KPGX5C11MBWg+IJk+MAG+3d7/
        ofZ+AbipUfzhDsM+M
X-Received: by 2002:a17:90a:a106:: with SMTP id s6mr2499070pjp.170.1622775338707;
        Thu, 03 Jun 2021 19:55:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxhaw+UGFTMFcOiURz1Zjh3luyPdx2n0CCOJsDxkKn1EgSxPC94IXMUtjSeky4N5DQMl4Z4Ug==
X-Received: by 2002:a17:90a:a106:: with SMTP id s6mr2499055pjp.170.1622775338491;
        Thu, 03 Jun 2021 19:55:38 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s21sm355111pfw.57.2021.06.03.19.55.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Jun 2021 19:55:37 -0700 (PDT)
Subject: Re: [PATCH net-next v3 0/3] virtio_net: add optional flow dissection
 in virtio_net_hdr_to_skb
To:     Tanner Love <tannerlove.kernel@gmail.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Petar Penkov <ppenkov@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Tanner Love <tannerlove@google.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
References: <20210601221841.1251830-1-tannerlove.kernel@gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <eef275f7-38c5-6967-7678-57dd5d59cf76@redhat.com>
Date:   Fri, 4 Jun 2021 10:55:28 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210601221841.1251830-1-tannerlove.kernel@gmail.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/6/2 ÉÏÎç6:18, Tanner Love Ð´µÀ:
> From: Tanner Love <tannerlove@google.com>
>
> First patch extends the flow dissector BPF program type to accept
> virtio-net header members.
>
> Second patch uses this feature to add optional flow dissection in
> virtio_net_hdr_to_skb(). This allows admins to define permitted
> packets more strictly, for example dropping deprecated UDP_UFO
> packets.
>
> Third patch extends kselftest to cover this feature.


I wonder why virtio maintainers is not copied in this series.

Several questions:

1) having bpf core to know about virito-net header seems like a layer 
violation, it doesn't scale as we may add new fields, actually there's 
already fields that is not implemented in the spec but not Linux right now.
2) virtio_net_hdr_to_skb() is not the single entry point, packet could 
go via XDP
3) I wonder whether we can simply use XDP to solve this issue (metadata 
probably but I don't have a deep thought)
4) If I understand the code correctly, it should deal with all dodgy 
packets instead of just for virtio

Thanks


>
> Tanner Love (3):
>    net: flow_dissector: extend bpf flow dissector support with vnet hdr
>    virtio_net: add optional flow dissection in virtio_net_hdr_to_skb
>    selftests/net: amend bpf flow dissector prog to do vnet hdr validation
>
>   drivers/net/bonding/bond_main.c               |   2 +-
>   include/linux/skbuff.h                        |  26 ++-
>   include/linux/virtio_net.h                    |  25 ++-
>   include/net/flow_dissector.h                  |   6 +
>   include/uapi/linux/bpf.h                      |   6 +
>   net/core/filter.c                             |  55 +++++
>   net/core/flow_dissector.c                     |  27 ++-
>   net/core/sysctl_net_core.c                    |   9 +
>   tools/include/uapi/linux/bpf.h                |   6 +
>   tools/testing/selftests/bpf/progs/bpf_flow.c  | 188 +++++++++++++-----
>   .../selftests/bpf/test_flow_dissector.c       | 181 +++++++++++++++--
>   .../selftests/bpf/test_flow_dissector.sh      |  19 ++
>   12 files changed, 470 insertions(+), 80 deletions(-)
>

