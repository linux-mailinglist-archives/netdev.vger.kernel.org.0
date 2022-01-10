Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 046CD489A34
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 14:43:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233084AbiAJNnK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 08:43:10 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:32730 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233069AbiAJNnJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 08:43:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641822189;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=6EmyWqiyozHMoNR3PXo4tfVbKSmC+qgSjnsbb0F163c=;
        b=eUjNd1CsRjjfWUEATk2h8RccLxOchqpzQsUg0UwOkYpBJWQ3z215uNYqxQwi/K94uH/1Xo
        pO8/eODpYjQovnoBIqWyFyvqfUDQ4OZx3BqWDOOx6Bu0POH/PFtyw32rfhjDbyJolR9OqH
        btuAPUllKt7/ASBoLDodp/9cNkJB5nQ=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-177-4UOTUP18NZuhibtHHR9uvg-1; Mon, 10 Jan 2022 08:43:07 -0500
X-MC-Unique: 4UOTUP18NZuhibtHHR9uvg-1
Received: by mail-wm1-f70.google.com with SMTP id b2-20020a7bc242000000b00348639aed88so684937wmj.8
        for <netdev@vger.kernel.org>; Mon, 10 Jan 2022 05:43:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=6EmyWqiyozHMoNR3PXo4tfVbKSmC+qgSjnsbb0F163c=;
        b=FGhb44eoA4HckfPrixbelfQLvCci2FbJp0szpyBABOaAplMqEolOX0Iknov90wAlwm
         QzFv+5GnYQtQ22eN5xr/rvWXq0BMMTRN1nOC/M0jNHmQnPzAXiemrdWLuf+UV2z6MPQU
         C6Pd9NfVTpVZa74UTclEpNN59YEMI4icZJzI60RjMRa6AmMQPpcGkZtdh+JFfSW5bdX+
         i5HhIfdS+O2rEHJG4cvjeeu9tbNCDyI94y/DnmssYkTNL+PJrPYNG8hUuDHmrsU6vEq/
         wMclzxRyXRD+WHFftIAox98+CnqOX8nWSsM0nF8dwqgNPuUIrQZGIWyNAFtRLy1QQhyV
         DDww==
X-Gm-Message-State: AOAM531qhoZPC+9cOiwougdX6oc83r5QNhsQGFPRMDEw6MFxOl9tKKds
        gcQaXAGZWm8EQqwm3Wu4FtOCMRsknpl4+Mcc5lddCcq1Co0RSAFo6qb5dvh0mmkQsvm6ZpKN4DL
        OFtMz8DmRMIHh9i0W
X-Received: by 2002:a7b:c747:: with SMTP id w7mr4797178wmk.89.1641822186663;
        Mon, 10 Jan 2022 05:43:06 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzxKmm0pNyFqKTi2kvuVgjObYNjW65kwC9Q9zl4eYkaH8R7h7TXicNEoj4veWKBSgt14DE6aA==
X-Received: by 2002:a7b:c747:: with SMTP id w7mr4797166wmk.89.1641822186514;
        Mon, 10 Jan 2022 05:43:06 -0800 (PST)
Received: from pc-4.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id o29sm10698837wms.3.2022.01.10.05.43.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jan 2022 05:43:06 -0800 (PST)
Date:   Mon, 10 Jan 2022 14:43:04 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, wenxu <wenxu@ucloud.cn>,
        Varun Prakash <varun@chelsio.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Vlad Buslov <vladbu@nvidia.com>,
        Or Gerlitz <ogerlitz@mellanox.com>
Subject: [PATCH v2 net 0/4] ipv4: Fix accidental RTO_ONLINK flags passed to
 ip_route_output_key_hash()
Message-ID: <cover.1641821242.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The IPv4 stack generally uses the last bit of ->flowi4_tos as a flag
indicating link scope for route lookups (RTO_ONLINK). Therefore, we
have to be careful when copying a TOS value to ->flowi4_tos. In
particular, the ->tos field of IPv4 packets may have this bit set
because of ECN. Also tunnel keys generally accept any user value for
the tos.

This series fixes several places where ->flowi4_tos was set from
non-sanitised values and the flowi4 structure was later used by
ip_route_output_key_hash().

Note that the IPv4 stack usually clears the RTO_ONLINK bit using
RT_TOS(). However this macro is based on an obsolete interpretation of
the old IPv4 TOS field (RFC 1349) and clears the three high order bits
too. Since we don't need to clear these bits and since it doesn't make
sense to clear only one of the ECN bits, this patch series uses
INET_ECN_MASK instead.

All patches were compile tested only.

v2: Rebase on top of net.

Guillaume Nault (4):
  xfrm: Don't accidentally set RTO_ONLINK in decode_session4()
  gre: Don't accidentally set RTO_ONLINK in gre_fill_metadata_dst()
  libcxgb: Don't accidentally set RTO_ONLINK in cxgb_find_route()
  mlx5: Don't accidentally set RTO_ONLINK before
    mlx5e_route_lookup_ipv4_get()

 drivers/net/ethernet/chelsio/libcxgb/libcxgb_cm.c   | 3 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c | 5 +++--
 net/ipv4/ip_gre.c                                   | 5 +++--
 net/xfrm/xfrm_policy.c                              | 3 ++-
 4 files changed, 10 insertions(+), 6 deletions(-)

-- 
2.21.3

