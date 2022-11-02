Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C36A4616A39
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 18:12:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230133AbiKBRMT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 13:12:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230311AbiKBRMC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 13:12:02 -0400
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 486D51EEC8
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 10:12:02 -0700 (PDT)
Received: by mail-qv1-xf29.google.com with SMTP id n18so12890025qvt.11
        for <netdev@vger.kernel.org>; Wed, 02 Nov 2022 10:12:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=LGRyNxwNSMOrgTSvVhvOBr15sKkbS1HEuxqyL7LKDWk=;
        b=Q5KbwXYZj8MDaBvyciSx1CANFhNgUwEMsZxIGB4krPlfhwQxmiqE4gzP+4hMZBkHBE
         xV7f2sJo2Ts3Lj9joweJjLZNvH0c7ZQ0TvzomGQavCHvcrdw/dk2jVibGV7/bHr4D4mE
         0BNfJTNuOOIwQOhWjw1fUdBJkZvgGzNMLRNxzioox+HrtauoQRrJF3PIRUhEZ8a2HdnA
         Alv4n2YBv+jxleKyAZnXzdQ7EQx80kevgZtRUZMnpnbfM3r/i4PvytMm16bdJKvyDCP6
         6ZyYYN8rJ/hQBYVQHkxWDoWm5j7SYEyoVWEMHeGjqSwXZw5EbuBvGmBG8rhfn+hBxTpe
         Kj2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LGRyNxwNSMOrgTSvVhvOBr15sKkbS1HEuxqyL7LKDWk=;
        b=amwyodZ4D9LjJQbfS0fUo8HlJq1BFhv5D0O4aiVtijq6aEtJT4paUX0wRtRPvbqVHd
         ECfGxq5p76K9ervL5UsLDqPrTvSu1p0XUdYjmIWPaZVVB20E21gq3xgfUtxBaNpl+hrx
         f2VIEThLeE6zvfqn8TlkGmiXhKErFA4Etng51PIPumlUcbqJqPH/UMmB5gAJ+dRXd2/x
         VBXPGoBmaLUmrq5UTaQqLI13OnUSHvK/QsQ8r3ns2V+SP3b+SFcZKvFFyr3CffbI1iTf
         cOhhpfexg8lqEEQwDwcsZBSANHma2jmS7+KE1/tGe+ljAmOpwjs8YmG0WWGIP4Ia2iIK
         aMBw==
X-Gm-Message-State: ACrzQf392yRzwyO4w+5AJsSqsPchx8PjUrbXaxQ/X2YkV2GBlvdzFWA9
        YLgSRYxlyf/q1WZjnSByVGDK/eyDKZ4=
X-Google-Smtp-Source: AMsMyM7HfBBn6STtyIN9DWDKdy7ryoeDZWLO1c6pKOuF8z52XHnhMWkYCvJ5sGWyzBX4NT988OPv4A==
X-Received: by 2002:a05:6214:2461:b0:4bb:4aa2:e59e with SMTP id im1-20020a056214246100b004bb4aa2e59emr22442988qvb.98.1667409121380;
        Wed, 02 Nov 2022 10:12:01 -0700 (PDT)
Received: from mail-yb1-f172.google.com (mail-yb1-f172.google.com. [209.85.219.172])
        by smtp.gmail.com with ESMTPSA id i5-20020ac84f45000000b0039ee562799csm6855191qtw.59.2022.11.02.10.12.00
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Nov 2022 10:12:00 -0700 (PDT)
Received: by mail-yb1-f172.google.com with SMTP id o70so21927097yba.7
        for <netdev@vger.kernel.org>; Wed, 02 Nov 2022 10:12:00 -0700 (PDT)
X-Received: by 2002:a25:6d85:0:b0:6cf:e382:8fc9 with SMTP id
 i127-20020a256d85000000b006cfe3828fc9mr5167801ybc.171.1667409120414; Wed, 02
 Nov 2022 10:12:00 -0700 (PDT)
MIME-Version: 1.0
References: <e04426a6a91baf4d1081e1b478c82b5de25fdf21.1667407944.git.jbenc@redhat.com>
In-Reply-To: <e04426a6a91baf4d1081e1b478c82b5de25fdf21.1667407944.git.jbenc@redhat.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 2 Nov 2022 13:11:22 -0400
X-Gmail-Original-Message-ID: <CA+FuTSf56Bk7fh78r8abTjr2_qKQXzgAacVqkuD=t6kuLJ+srw@mail.gmail.com>
Message-ID: <CA+FuTSf56Bk7fh78r8abTjr2_qKQXzgAacVqkuD=t6kuLJ+srw@mail.gmail.com>
Subject: Re: [PATCH net v2] net: gso: fix panic on frag_list with mixed head
 alloc types
To:     Jiri Benc <jbenc@redhat.com>
Cc:     netdev@vger.kernel.org, Shmulik Ladkani <shmulik@metanetworks.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Tomas Hruby <tomas@tigera.io>,
        Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 2, 2022 at 12:55 PM Jiri Benc <jbenc@redhat.com> wrote:
>
> Since commit 3dcbdb134f32 ("net: gso: Fix skb_segment splat when
> splitting gso_size mangled skb having linear-headed frag_list"), it is
> allowed to change gso_size of a GRO packet. However, that commit assumes
> that "checking the first list_skb member suffices; i.e if either of the
> list_skb members have non head_frag head, then the first one has too".
>
> It turns out this assumption does not hold. We've seen BUG_ON being hit
> in skb_segment when skbs on the frag_list had differing head_frag with
> the vmxnet3 driver. This happens because __netdev_alloc_skb and
> __napi_alloc_skb can return a skb that is page backed or kmalloced
> depending on the requested size. As the result, the last small skb in
> the GRO packet can be kmalloced.
>
> There are three different locations where this can be fixed:
>
> (1) We could check head_frag in GRO and not allow GROing skbs with
>     different head_frag. However, that would lead to performance
>     regression on normal forward paths with unmodified gso_size, where
>     !head_frag in the last packet is not a problem.
>
> (2) Set a flag in bpf_skb_net_grow and bpf_skb_net_shrink indicating
>     that NETIF_F_SG is undesirable. That would need to eat a bit in
>     sk_buff. Furthermore, that flag can be unset when all skbs on the
>     frag_list are page backed. To retain good performance,
>     bpf_skb_net_grow/shrink would have to walk the frag_list.
>
> (3) Walk the frag_list in skb_segment when determining whether
>     NETIF_F_SG should be cleared. This of course slows things down.
>
> This patch implements (3). To limit the performance impact in
> skb_segment, the list is walked only for skbs with SKB_GSO_DODGY set
> that have gso_size changed. Normal paths thus will not hit it.
>
> We could check only the last skb but since we need to walk the whole
> list anyway, let's stay on the safe side.
>
> Fixes: 3dcbdb134f32 ("net: gso: Fix skb_segment splat when splitting gso_size mangled skb having linear-headed frag_list")
> Signed-off-by: Jiri Benc <jbenc@redhat.com>

Reviewed-by: Willem de Bruijn <willemb@google.com>
