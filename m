Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28BBA1B77EE
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 16:04:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbgDXOEX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 10:04:23 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:56521 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726987AbgDXOEX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 10:04:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587737062;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IbBfGpEY8+GjC2WewPiir6IFAYsaeTvZp7+stE4C2lo=;
        b=KhlGuCiUr1tJ60YYwIsq4LYrBDgpAlTqIVjD4ZxACBHp3hljl9l2YyrbZrytbEjKW0GYKj
        rPiXv1Yq0U471iuPODY/VHp7d+tZdx2c+IJSikj+jDCUqaeS3SdnwhVmnqvXFfn1Ju7v8S
        QVXc0YAaQbdHOSRIgTy8Lr2To8eBToQ=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-270-qjJMCylNMfWuQrlyOEJzcw-1; Fri, 24 Apr 2020 10:04:20 -0400
X-MC-Unique: qjJMCylNMfWuQrlyOEJzcw-1
Received: by mail-lf1-f72.google.com with SMTP id 66so3937959lfa.7
        for <netdev@vger.kernel.org>; Fri, 24 Apr 2020 07:04:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=IbBfGpEY8+GjC2WewPiir6IFAYsaeTvZp7+stE4C2lo=;
        b=c+6V7ty8VXA3GDA3AceEHPYgloeKoWVaKTNvdkpligOT8B5HkcJJ6aKAefCni1wbGq
         Nf4QhboRiz1wlq6VB3CVqnnvn+Dl+ZNE9shqXL9X+ZPtD6uBM+V4ag6+FVXrXS2WyS8P
         X8nFRmNve/vxb7G0Juz66Z1J00bDSzGxwGZzvldyBpsj1o+M4abflxG0kvE2WvL7U597
         rnIAZPq275nsSWtIbyXT+hy16bOmPFfH9KHIhiOGE+m8P87SbmYSZqoUfrDjzBQ4XOSD
         hJsGLZmogTyRboxtqnvd2ZZ5oJ38kqPWrux+atqDz32Ip1pYT4FvtOAY+flza6rAjfn/
         lkDQ==
X-Gm-Message-State: AGi0PuZTgz3+BFiUkieUeQ2NiNHVhn7XwItnpijt+AtYAeH+WD4o7gpY
        fZtU2/eXMKPIAd7+hvwJQ/GX8k94wFy13KtSD37HDaJRJd6ZdcGbGRNo0c7e4HE8NqO4BF0WNDI
        9EdARm2xd6FekXvu1
X-Received: by 2002:a2e:8296:: with SMTP id y22mr5075269ljg.254.1587737058699;
        Fri, 24 Apr 2020 07:04:18 -0700 (PDT)
X-Google-Smtp-Source: APiQypK/iGLfqsZyVyMqba2b23d/LSG4sByRwForTHPiAk1tRffjUZ/fq7BkQYl2bTAzmuHQwrIiyQ==
X-Received: by 2002:a2e:8296:: with SMTP id y22mr5075252ljg.254.1587737058471;
        Fri, 24 Apr 2020 07:04:18 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id u7sm4690127lfu.3.2020.04.24.07.04.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2020 07:04:17 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id D5E7E1814FF; Fri, 24 Apr 2020 16:04:04 +0200 (CEST)
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
Subject: Re: [PATCH net-next 07/33] xdp: xdp_frame add member frame_sz and handle in convert_to_xdp_frame
In-Reply-To: <158757167661.1370371.5983006045491610549.stgit@firesoul>
References: <158757160439.1370371.13213378122947426220.stgit@firesoul> <158757167661.1370371.5983006045491610549.stgit@firesoul>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 24 Apr 2020 16:04:04 +0200
Message-ID: <878sil3rqj.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jesper Dangaard Brouer <brouer@redhat.com> writes:

> Use hole in struct xdp_frame, when adding member frame_sz, which keeps
> same sizeof struct (32 bytes)
>
> Drivers ixgbe and sfc had bug cases where the necessary/expected
> tailroom was not reserved. This can lead to some hard to catch memory
> corruption issues. Having the drivers frame_sz this can be detected when
> packet length/end via xdp->data_end exceed the xdp_data_hard_end
> pointer, which accounts for the reserved the tailroom.
>
> When detecting this driver issue, simply fail the conversion with NULL,
> which results in feedback to driver (failing xdp_do_redirect()) causing
> driver to drop packet. Given the lack of consistent XDP stats, this can
> be hard to troubleshoot. And given this is a driver bug, we want to
> generate some more noise in form of a WARN stack dump (to ID the driver
> code that inlined convert_to_xdp_frame).
>
> Inlining the WARN macro is problematic, because it adds an asm
> instruction (on Intel CPUs ud2) what influence instruction cache
> prefetching. Thus, introduce xdp_warn and macro XDP_WARN, to avoid this
> and at the same time make identifying the function and line of this
> inlined function easier.
>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

