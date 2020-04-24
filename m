Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 420A81B77F9
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 16:06:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728007AbgDXOGV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 10:06:21 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:59160 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727914AbgDXOGU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 10:06:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587737179;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XD/8fSrDljhSMhAXxrRpIOeU+6aO8IuBMFYijn23O/I=;
        b=Om2NmL/FCtq9rjLX442GKcjyL8dxhz2yM7AkNn4KnxcjUwTb7cX+A0YUT5+ty1zOGbaujR
        PNYSIgjYw74DQxvSkcX0mtZahp23as1cVrCKutHC47CbL7oZEvXMFl2N/FtBgfbMGDBIUs
        Z4ubEi+/VVSP8kYUgQ5cxJ1jBZCM7yc=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-319-gQvtSIEzOiug6pKRd4XiJQ-1; Fri, 24 Apr 2020 10:06:15 -0400
X-MC-Unique: gQvtSIEzOiug6pKRd4XiJQ-1
Received: by mail-lf1-f69.google.com with SMTP id m3so3940847lfp.21
        for <netdev@vger.kernel.org>; Fri, 24 Apr 2020 07:06:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=XD/8fSrDljhSMhAXxrRpIOeU+6aO8IuBMFYijn23O/I=;
        b=aYNClpqzW00X+HM23/1u72JKWHZpI5sR4Rhfc9HdHsVJkPJAJWk9XH2rspHSiwlfv+
         CofDFlGQZH7XqRAFk3CXb5L1orX/OtRjJxSR9gZySKGzPnA2CpryXac6Qy8Pl0TZAzYV
         yDLMaEbFGTpDPqyLkLB+6NmqYFLsk/+OPcN3otWHK5SU63R059kKg7HSz5nzjg3hSVsl
         rmZGELa29GpgC9cnjw7VS1S+5vOq3tR65WSbUzM20KFFGyBjF9MUR8eOCe+sY3WTe0A0
         0qkq/DT6DWxs5O4nlk8NQ7MEW5QOB/ln8jZekOm7ZBdse2ckZ/T5ctr0CLJgULQwODdL
         F4ig==
X-Gm-Message-State: AGi0PuYnkxPaaAeP/7sNDtCL//OjoMuHF2+GFj0/tpMz791XivsTRfVt
        a7tw+8eYyaawIJa/+JgVH/klYNu/sXYCYmM7BpMe+M1Gh3xcpphmtmCAYnv8fDmnyj/IMhOhU7m
        sIBfIbAGvebtSqGma
X-Received: by 2002:a2e:9207:: with SMTP id k7mr6051080ljg.124.1587737174202;
        Fri, 24 Apr 2020 07:06:14 -0700 (PDT)
X-Google-Smtp-Source: APiQypJ6h7uERsLmhAPBnRhqObB3yqw69uY5U6lX8MEZMcAIqMwJ8z5fUipamaGIU7vHgPaanI6Fow==
X-Received: by 2002:a2e:9207:: with SMTP id k7mr6051063ljg.124.1587737173930;
        Fri, 24 Apr 2020 07:06:13 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id t13sm4204213ljd.38.2020.04.24.07.05.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2020 07:06:02 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 0F5001814FF; Fri, 24 Apr 2020 16:05:54 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>, sameehj@amazon.com
Cc:     Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Mao Wenan <maowenan@huawei.com>,
        Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org, zorik@amazon.com,
        akiyano@amazon.com, gtzalik@amazon.com,
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
Subject: Re: [PATCH net-next 09/33] veth: adjust hard_start offset on redirect XDP frames
In-Reply-To: <158757168676.1370371.9335548837047528670.stgit@firesoul>
References: <158757160439.1370371.13213378122947426220.stgit@firesoul> <158757168676.1370371.9335548837047528670.stgit@firesoul>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 24 Apr 2020 16:05:54 +0200
Message-ID: <87368t3rnh.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jesper Dangaard Brouer <brouer@redhat.com> writes:

> When native XDP redirect into a veth device, the frame arrives in the
> xdp_frame structure. It is then processed in veth_xdp_rcv_one(),
> which can run a new XDP bpf_prog on the packet. Doing so requires
> converting xdp_frame to xdp_buff, but the tricky part is that
> xdp_frame memory area is located in the top (data_hard_start) memory
> area that xdp_buff will point into.
>
> The current code tried to protect the xdp_frame area, by assigning
> xdp_buff.data_hard_start past this memory. This results in 32 bytes
> less headroom to expand into via BPF-helper bpf_xdp_adjust_head().
>
> This protect step is actually not needed, because BPF-helper
> bpf_xdp_adjust_head() already reserve this area, and don't allow
> BPF-prog to expand into it. Thus, it is safe to point data_hard_start
> directly at xdp_frame memory area.
>
> Cc: Toshiaki Makita <toshiaki.makita1@gmail.com>
> Fixes: 9fc8d518d9d5 ("veth: Handle xdp_frames in xdp napi ring")
> Reported-by: Mao Wenan <maowenan@huawei.com>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Acked-by: Toshiaki Makita <toshiaki.makita1@gmail.com>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

