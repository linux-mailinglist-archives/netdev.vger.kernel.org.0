Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F96364B9E7
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 17:37:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236108AbiLMQhi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 11:37:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235937AbiLMQhg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 11:37:36 -0500
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30D1D218BA;
        Tue, 13 Dec 2022 08:37:35 -0800 (PST)
Received: by mail-qt1-f174.google.com with SMTP id i20so254441qtw.9;
        Tue, 13 Dec 2022 08:37:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dkqo/f6TMEumBsXzKtrUT8iISRroziZrZAkikhWcpfE=;
        b=Iho3HoVup2f5P1zUupcWZrgW4oWpS4knc3GBlUR6vYL+vVwtrE4X86e57ym1ZdlG4M
         2/B8QyuJXRBuwbkr9Mz/mll8qxsR/lPHq/Vo8vpG5Ra1Aw4RyX2kSkjRx25cj/D+GTRT
         D32F5eH6cZTqVDvqlMS+SGEy65wb2XQjJdUw8D2Df1hnoYYpQKiRKzOaReBsc+ft3h0m
         CFkdM+nGLhHzPreLliT5+1qX6Oxn4vAZnlyQao5dTNjhAlfhF4BqaUlzK/+HYCR5SI87
         xs14cIxn9ECPYrKwPwlEnSq3pvWi3Q8MdnQYZRgquy4W0d5R5lmPePNuKgHJj8bOyFdo
         xuPA==
X-Gm-Message-State: ANoB5pl/3UJ/XDfosUaJgFl8DPobHZ9bM5ZmzyQIv+it9m4ivO76fDdr
        kiSshTroDEbknwwHQUx5q0U=
X-Google-Smtp-Source: AA0mqf50bvyGGGPmiGQL2J9wi1SXO1PoY3/g5E6Pktn5hXRICzhQVBM5RJCTNWJ7SpLgad9eiZzXww==
X-Received: by 2002:a05:622a:4a88:b0:3a6:9011:3de0 with SMTP id fw8-20020a05622a4a8800b003a690113de0mr30870665qtb.40.1670949453980;
        Tue, 13 Dec 2022 08:37:33 -0800 (PST)
Received: from maniforge.lan ([2620:10d:c091:480::1:8faa])
        by smtp.gmail.com with ESMTPSA id cr26-20020a05622a429a00b0039853b7b771sm113274qtb.80.2022.12.13.08.37.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Dec 2022 08:37:33 -0800 (PST)
Date:   Tue, 13 Dec 2022 10:37:32 -0600
From:   David Vernet <void@manifault.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
        haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next v4 01/15] bpf: Document XDP RX metadata
Message-ID: <Y5iqTKnhtX2yaSAq@maniforge.lan>
References: <20221213023605.737383-1-sdf@google.com>
 <20221213023605.737383-2-sdf@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221213023605.737383-2-sdf@google.com>
User-Agent: Mutt/2.2.7 (2022-08-07)
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 12, 2022 at 06:35:51PM -0800, Stanislav Fomichev wrote:
> Document all current use-cases and assumptions.
> 
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Martin KaFai Lau <martin.lau@linux.dev>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Willem de Bruijn <willemb@google.com>
> Cc: Jesper Dangaard Brouer <brouer@redhat.com>
> Cc: Anatoly Burakov <anatoly.burakov@intel.com>
> Cc: Alexander Lobakin <alexandr.lobakin@intel.com>
> Cc: Magnus Karlsson <magnus.karlsson@gmail.com>
> Cc: Maryam Tahhan <mtahhan@redhat.com>
> Cc: xdp-hints@xdp-project.net
> Cc: netdev@vger.kernel.org
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>  Documentation/bpf/xdp-rx-metadata.rst | 90 +++++++++++++++++++++++++++
>  1 file changed, 90 insertions(+)
>  create mode 100644 Documentation/bpf/xdp-rx-metadata.rst
> 
> diff --git a/Documentation/bpf/xdp-rx-metadata.rst b/Documentation/bpf/xdp-rx-metadata.rst
> new file mode 100644
> index 000000000000..498eae718275
> --- /dev/null
> +++ b/Documentation/bpf/xdp-rx-metadata.rst

I think you need to add this to Documentation/bpf/index.rst. Or even
better, maybe it's time to add an xdp/ subdirectory and put all docs
there? Don't want to block your patchset from bikeshedding on this
point, so for now it's fine to just put it in
Documentation/bpf/index.rst until we figure that out.

> @@ -0,0 +1,90 @@
> +===============
> +XDP RX Metadata
> +===============
> +
> +XDP programs support creating and passing custom metadata via
> +``bpf_xdp_adjust_meta``. This metadata can be consumed by the following
> +entities:

Can you add a couple of sentences to this intro section that explains
what metadata is at a high level?

> +
> +1. ``AF_XDP`` consumer.
> +2. Kernel core stack via ``XDP_PASS``.
> +3. Another device via ``bpf_redirect_map``.
> +4. Other BPF programs via ``bpf_tail_call``.
> +
> +General Design
> +==============
> +
> +XDP has access to a set of kfuncs to manipulate the metadata. Every

"...to manipulate the metadata in an XDP frame." ?

> +device driver implements these kfuncs. The set of kfuncs is

"Every device driver implements these kfuncs" can you be a bit more
specific about which types of device drivers will implement these?

> +declared in ``include/net/xdp.h`` via ``XDP_METADATA_KFUNC_xxx``.

Why is it suffixed with _xxx?

> +
> +Currently, the following kfuncs are supported. In the future, as more
> +metadata is supported, this set will grow:
> +
> +- ``bpf_xdp_metadata_rx_timestamp_supported`` returns true/false to
> +  indicate whether the device supports RX timestamps
> +- ``bpf_xdp_metadata_rx_timestamp`` returns packet RX timestamp

s/returns packet/returns a packet's

> +- ``bpf_xdp_metadata_rx_hash_supported`` returns true/false to
> +  indicate whether the device supports RX hash

I don't see bpf_xdp_metadata_rx_timestamp_supported() or
bpf_xdp_metadata_rx_hash_supported() being added in your patch set. Can
you remove these entries until they're actually implemented?

> +- ``bpf_xdp_metadata_rx_hash`` returns packet RX hash

We should probably also add a note that these kfuncs currently just
return -EOPNOTSUPP.

Finally, should we add either some example code showing how to use these
kfuncs, or at the very least some links to their selftests so readers
have example code they can refer to?

> +
> +Within the XDP frame, the metadata layout is as follows::
> +
> +  +----------+-----------------+------+
> +  | headroom | custom metadata | data |
> +  +----------+-----------------+------+
> +             ^                 ^
> +             |                 |
> +   xdp_buff->data_meta   xdp_buff->data
> +
> +AF_XDP
> +======
> +
> +``AF_XDP`` use-case implies that there is a contract between the BPF program
> +that redirects XDP frames into the ``XSK`` and the final consumer.

Can you fully spell out what XSK stands for the first time it's used?
Something like "...that redirects XDP frames into the ``AF_XDP`` socket
(``XSK``) and the final consumer." Applies anywhere else you think
appropriate as well.

> +Thus the BPF program manually allocates a fixed number of
> +bytes out of metadata via ``bpf_xdp_adjust_meta`` and calls a subset
> +of kfuncs to populate it. User-space ``XSK`` consumer, looks

s/User-space/The user-space

Also, it feels like it might read better without the comma, and by
doing something like s/looks at/computes. Wdyt?

> +at ``xsk_umem__get_data() - METADATA_SIZE`` to locate its metadata.
> +
> +Here is the ``AF_XDP`` consumer layout (note missing ``data_meta`` pointer)::
> +
> +  +----------+-----------------+------+
> +  | headroom | custom metadata | data |
> +  +----------+-----------------+------+
> +                               ^
> +                               |
> +                        rx_desc->address
> +
> +XDP_PASS
> +========
> +
> +This is the path where the packets processed by the XDP program are passed
> +into the kernel. The kernel creates ``skb`` out of the ``xdp_buff`` contents.

s/creates ``skb``/creates the ``skb``

> +Currently, every driver has a custom kernel code to parse the descriptors and
> +populate ``skb`` metadata when doing this ``xdp_buff->skb`` conversion.
> +In the future, we'd like to support a case where XDP program can override

s/where XDP program/where an XDP program

> +some of that metadata.
> +
> +The plan of record is to make this path similar to ``bpf_redirect_map``
> +so the program can control which metadata is passed to the skb layer.
> +
> +bpf_redirect_map
> +================
> +
> +``bpf_redirect_map`` can redirect the frame to a different device.
> +In this case we don't know ahead of time whether that final consumer
> +will further redirect to an ``XSK`` or pass it to the kernel via ``XDP_PASS``.
> +Additionally, the final consumer doesn't have access to the original
> +hardware descriptor and can't access any of the original metadata.
> +
> +For this use-case, only custom metadata is currently supported. If
> +the frame is eventually passed to the kernel, the skb created from such
> +a frame won't have any skb metadata. The ``XSK`` consumer will only
> +have access to the custom metadata.
> +
> +bpf_tail_call
> +=============
> +
> +No special handling here. Tail-called program operates on the same context

s/Tail-called program/A tail-called program

> +as the original one.
> -- 
> 2.39.0.rc1.256.g54fd8350bd-goog
> 
