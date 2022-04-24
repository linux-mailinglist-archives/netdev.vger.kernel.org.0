Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E58250CE79
	for <lists+netdev@lfdr.de>; Sun, 24 Apr 2022 04:29:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237708AbiDXCcx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Apr 2022 22:32:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237427AbiDXCcw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Apr 2022 22:32:52 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F376E1AB8E0
        for <netdev@vger.kernel.org>; Sat, 23 Apr 2022 19:29:53 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id q19so10523948pgm.6
        for <netdev@vger.kernel.org>; Sat, 23 Apr 2022 19:29:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UhsZaluN5dnOKO3U0Krppq9VaLGF2RdY+bajBrR8028=;
        b=LF1cemno9GFo6gpDhieYb6gKUzr+sC6+6wg2sRBjjYpBbNtDVi3yncL3LPzLhDKLB2
         LKiKoYfP0DBjxgfCAxgGKF3FgYGkNNZLXoaTg34vT+Rto++IHQWAl2YzypH2z4n2QEwB
         sJ0B0apKUuHQG2gGttSUbRO5+CfLx8aCN3gCWIEN8VW3iwpIb5RabpR+hRIU6mcQbSLD
         IEJotVfH03fhcd9nuUe6uDttO+kj1YGnmW7p/3EzvWmELSkEslRNXxHYVT1+mb9zCM7x
         lGbyv5VHJI6s9C9e84Z3eXZ9EisUeXcnOfuNn3QuvHt8om3ixgdDjM/yfz4GFPlck058
         IbgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UhsZaluN5dnOKO3U0Krppq9VaLGF2RdY+bajBrR8028=;
        b=dT9zNx4eIM01ZVDo6Wu+5QVheMxJuwN9nSB+Z17oG0AR9edDDdCoWuJRnrMj8at828
         /zRbiqFNFmCVJ6bePEy5bTaDznAAWUzQuBV4fZsqfQlWi92gF7pG/ISO+6DIohRq4y1s
         +bmU2YBHqc4HKOt1GSQhVfrtQMSuCQDXWmyT3ln7FD9e54uXnX5y3SslcLZ1H2t6U+8L
         tC43u3jBFPvhwxdF06AsZskj/iBipxedNnrBljJXta06sE4wDJVCNcGX5hHeuRg2infB
         KhQv1FIW0z2T7ZgGGoxYHcdLa6fAlregZA3miCfOxd551XajUYTbpAeIEF2UTIUx195q
         /aHg==
X-Gm-Message-State: AOAM533EgMUfydMS4VGjdZ8Cx9QDFQvSiFL1kW5p1vt2zNBGtQ+bZ7aW
        ZPML0hl6AgDNV7izg4Td4MGnHv8NmOk=
X-Google-Smtp-Source: ABdhPJxc2t/eQsDsrBhxh5508hCySY6AvC2iaiAbY6ZY/PDdw5eu+FrebLTlxemRKXvnkMePjkSR9Q==
X-Received: by 2002:a65:618d:0:b0:39e:2d10:6d69 with SMTP id c13-20020a65618d000000b0039e2d106d69mr9720773pgv.468.1650767393474;
        Sat, 23 Apr 2022 19:29:53 -0700 (PDT)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id d8-20020aa78688000000b00505793566f7sm6681301pfo.211.2022.04.23.19.29.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Apr 2022 19:29:52 -0700 (PDT)
Date:   Sun, 24 Apr 2022 10:29:45 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     netdev@vger.kernel.org, "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        virtualization@lists.linux-foundation.org,
        Balazs Nemeth <bnemeth@redhat.com>,
        Mike Pattrick <mpattric@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next] net/af_packet: add VLAN support for AF_PACKET
 SOCK_RAW GSO
Message-ID: <YmS2Gd6c1b+o5nyR@Laptop-X1>
References: <20220420082758.581245-1-liuhangbin@gmail.com>
 <CA+FuTScyF4BKEcNSCYOv8SBA_EmB806YtKA17jb3F+fymVF-Pg@mail.gmail.com>
 <YmDCHI330AUfcYKa@Laptop-X1>
 <CA+FuTSckEJVUH1Q2vBxGbfPgVteyDVmTfjJC6hBj=qRP+JcAxA@mail.gmail.com>
 <YmIOLBihyeLy+PCS@Laptop-X1>
 <CA+FuTSfzcAUXrxzbLd-MPctTyLu8USJQ4gvsqPBfLpA+svYMYA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+FuTSfzcAUXrxzbLd-MPctTyLu8USJQ4gvsqPBfLpA+svYMYA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 22, 2022 at 05:39:48PM -0400, Willem de Bruijn wrote:
> > If we split skb_probe_transport_header() from packet_parse_headers() and
> > move it before calling virtio_net_hdr_* function in packet_snd(). Should
> > we do the same for tpacket_snd(), i.e. move skb_probe_transport_header()
> > after the virtio_net_hdr_* function?
> 
> That sounds like the inverse: "move after" instead of "move before"?

That's for "split packet_parse_headers()" option.

> 
> But I thought the plan was to go back to your last patch which brings
> packet_snd in line with tpacket_snd by moving packet_parse_headers in
> its entirety before virtio_net_hdr_*?

Yes, exactly.

> > So my conclusion is. There is no need to split packet_parse_headers(). Move
> > packet_parse_headers() before calling virtio_net_hdr_* function in packet_snd()
> > should be safe.
> 
> Ack. Sorry if my last response was not entirely clear on this point.

Thanks a lot for your review. Do you think if I need to re-post the patch?
Or will you give an Acked-by for this one?

Hangbin
