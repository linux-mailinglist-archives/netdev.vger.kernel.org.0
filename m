Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1D70470F4F
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 01:17:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243906AbhLKAUf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 19:20:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240722AbhLKAUe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 19:20:34 -0500
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4008EC061714;
        Fri, 10 Dec 2021 16:16:59 -0800 (PST)
Received: by mail-oi1-x235.google.com with SMTP id 7so15388485oip.12;
        Fri, 10 Dec 2021 16:16:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=LPsEBllkti1Y/WFnvaprKAKcU70ku+EJ/zndB3NRcV4=;
        b=CCqnhmWYXAbY0SLoWvB2AAc4cmOi2AdcDLsTQcb4eHH7jg9YjG6UMbmU1a4wXuWyMg
         gzUFuJDverG65JpPqI+//PJDJ3qKxiW3QDIdIPvNGaUdg7VVJdMXF1Ez7+Rxyb2d5ROT
         yVh+vMzfdIxnj1GerBJ20PdIQfWyMkjBpZw2Y4Ui68Vl7F5LHO6jaThSwUDkVEiIIr4a
         O/sSxlqOn/uh3TW0LwDGd1cSQ7KSG5h3wamEiz+T0l6A+aIpp7oEAWGfXhDNN6xmJcpa
         JUiaBl95yBQls+K1+lMYhNqGhNUzycyLT02xwaJt+w94oNgWfc2qDIfnbZv27RecdVDl
         9b7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=LPsEBllkti1Y/WFnvaprKAKcU70ku+EJ/zndB3NRcV4=;
        b=tzBMJbfiWcGOH03Xmi1rWnFtDgeYH6nNICHtnr+HuT9fQ4mcg2PuE8vvX/3EaQdzsE
         Bal6eiPIiUw9W14Pz8lbF1t3i1j1JOSDoM5KAYjKlsXSQZxlW3v10+m4fLyK2GtWivtF
         k8i9QmqZ16dMJEdbVFICAehTU0tRwL1D1Dxo+wfquFNNfpm4s/gZhuIsqmrIIfeCg2XR
         rA+Mb5lMRrMZC+IQpaVkahddVmiRo1wV0CEgklkYOzdKBbByTDUxgXq+ld4+VyTZ+JMo
         IhFh4cuuU+sg9dfz9jYyIuFUM6Wf0C/4FNe+KkxWseWknsHTGPZd9em0XhBXoNWiD6SZ
         dfTw==
X-Gm-Message-State: AOAM532VWbTpC4GxHSeP50zJl6eb3+OIs3NswuINwov8IaR+M+U/XKgB
        N73/MVMYvAM1q2zIX1c6ilk=
X-Google-Smtp-Source: ABdhPJy57y/3rG8iI5IVRwu/IgQEjLMHVCikBXPbAdBkaF/5cRnB6popLjFbhq5rCEy7a/0O3dBEzg==
X-Received: by 2002:aca:5b87:: with SMTP id p129mr15382978oib.30.1639181818600;
        Fri, 10 Dec 2021 16:16:58 -0800 (PST)
Received: from localhost ([172.243.151.11])
        by smtp.gmail.com with ESMTPSA id j187sm1057295oih.5.2021.12.10.16.16.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 16:16:57 -0800 (PST)
Date:   Fri, 10 Dec 2021 16:16:51 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Message-ID: <61b3edf34d399_2c40320815@john.notmuch>
In-Reply-To: <cover.1639162845.git.lorenzo@kernel.org>
References: <cover.1639162845.git.lorenzo@kernel.org>
Subject: RE: [PATCH v20 bpf-next 00/23] mvneta: introduce XDP multi-buffer
 support
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenzo Bianconi wrote:
> This series introduce XDP multi-buffer support. The mvneta driver is
> the first to support these new "non-linear" xdp_{buff,frame}. Reviewers=

> please focus on how these new types of xdp_{buff,frame} packets
> traverse the different layers and the layout design. It is on purpose
> that BPF-helpers are kept simple, as we don't want to expose the
> internal layout to allow later changes.
> =

> The main idea for the new multi-buffer layout is to reuse the same
> structure used for non-linear SKB. This rely on the "skb_shared_info"
> struct at the end of the first buffer to link together subsequent
> buffers. Keeping the layout compatible with SKBs is also done to ease
> and speedup creating a SKB from an xdp_{buff,frame}.
> Converting xdp_frame to SKB and deliver it to the network stack is show=
n
> in patch 05/18 (e.g. cpumaps).
> =

> A multi-buffer bit (mb) has been introduced in the flags field of xdp_{=
buff,frame}
> structure to notify the bpf/network layer if this is a xdp multi-buffer=
 frame
> (mb =3D 1) or not (mb =3D 0).
> The mb bit will be set by a xdp multi-buffer capable driver only for
> non-linear frames maintaining the capability to receive linear frames
> without any extra cost since the skb_shared_info structure at the end
> of the first buffer will be initialized only if mb is set.
> Moreover the flags field in xdp_{buff,frame} will be reused even for
> xdp rx csum offloading in future series.
> =

> Typical use cases for this series are:
> - Jumbo-frames
> - Packet header split (please see Google=EF=BF=BD=EF=BF=BD=EF=BF=BDs us=
e-case @ NetDevConf 0x14, [0])
> - TSO/GRO for XDP_REDIRECT
> =

> The three following ebpf helpers (and related selftests) has been intro=
duced:
> - bpf_xdp_load_bytes:
>   This helper is provided as an easy way to load data from a xdp buffer=
. It
>   can be used to load len bytes from offset from the frame associated t=
o
>   xdp_md, into the buffer pointed by buf.
> - bpf_xdp_store_bytes:
>   Store len bytes from buffer buf into the frame associated to xdp_md, =
at
>   offset.
> - bpf_xdp_get_buff_len:
>   Return the total frame size (linear + paged parts)
> =

> bpf_xdp_adjust_tail and bpf_xdp_copy helpers have been modified to take=
 into
> account xdp multi-buff frames.
> Moreover, similar to skb_header_pointer, we introduced bpf_xdp_pointer =
utility
> routine to return a pointer to a given position in the xdp_buff if the
> requested area (offset + len) is contained in a contiguous memory area
> otherwise it must be copied in a bounce buffer provided by the caller r=
unning
> bpf_xdp_copy_buf().
> =

> BPF_F_XDP_MB flag for bpf_attr has been introduced to notify the kernel=
 the
> eBPF program fully support xdp multi-buffer.
> SEC("xdp_mb/"), SEC_DEF("xdp_devmap_mb/") and SEC_DEF("xdp_cpumap_mb/" =
have been
> introduced to declare xdp multi-buffer support.
> The NIC driver is expected to reject an eBPF program if it is running i=
n XDP
> multi-buffer mode and the program does not support XDP multi-buffer.
> In the same way it is not possible to mix xdp multi-buffer and xdp lega=
cy
> programs in a CPUMAP/DEVMAP or tailcall a xdp multi-buffer/legacy progr=
am from
> a legacy/multi-buff one.
> =

> More info about the main idea behind this approach can be found here [1=
][2].

Thanks for sticking with this.

OK for the series, I really want to see this on some other hardware thoug=
h,
preferably 40Gbps or more ASAP...

Acked-by: John Fastabend <john.fastabend@gmail.com>=
