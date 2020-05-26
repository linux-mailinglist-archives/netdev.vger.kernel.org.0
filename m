Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A90921E1C8E
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 09:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731626AbgEZHyy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 03:54:54 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:33423 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726048AbgEZHyy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 03:54:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590479693;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9p+fsIHXzXoy0clpUjlxHl8jM7kJ0asdcmZkdUaHtj4=;
        b=LA6PTaOPT1xFozxfrtFkw9neF5GtJTXJ3JSb/hAlSyljVueuw5STC2kl8bq56scux8+iEe
        v4mMGeRRY48ScwDPxgO2F0LvhTn51Z8hgpIcWBDnvGDHaC6hy4Cv9ns5zFgEogBt2I2kKI
        SUr2Hx4zW4aS/b6UB3+kOt4QZ4rW3gE=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-368-0rMiOF2FOLeaTQzIgzW7KQ-1; Tue, 26 May 2020 03:54:51 -0400
X-MC-Unique: 0rMiOF2FOLeaTQzIgzW7KQ-1
Received: by mail-wm1-f69.google.com with SMTP id g194so758690wmg.0
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 00:54:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=9p+fsIHXzXoy0clpUjlxHl8jM7kJ0asdcmZkdUaHtj4=;
        b=tuXiHf+GiRKgRNEwRSyziZfABQZ4Xqs75xQC/l13x2K047fW7vgRj77kQIBeW+C9Ol
         sMQZbDTcvB7J8Do3WzO+OyzPMTRqEjJ3iKu/h194AuTM+JCa47xpDGAb4wf50HFBDQhQ
         Iz7hQhJ4s8hUYlUdmI4EwywCwhXhCDQgR5TMYbiHqSxvRF7qIFgjQBFpVWROqnQXeV57
         7/kxczCKmX9XK0U6/u5VBUaRuTjLcjPSuGoJ3jmUcL1o1d4gq2Mu4gqV6nsuHjq/VDXd
         siFYPN98jnHEPGlvMrXrnbGVEO61a4wXc8GAcv/B1kZfh10z+DflHw8xj27UDEqhULk/
         HE7g==
X-Gm-Message-State: AOAM533bkiT2bs1YABDoNhWbhD6dXWPUSXGMsBFcuZ3G2jDWnh/FpBN5
        bEBzWgzBUhiBxzUyZsa/SWIYCpor/85nlvSJsxzAVwIo4JWchwNYjvhs9QBGyD+vEUYbg5Xhfon
        KUBAz3nMn5VSsGqgU
X-Received: by 2002:a5d:628c:: with SMTP id k12mr11189704wru.211.1590479690232;
        Tue, 26 May 2020 00:54:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzkS9NP4Rz+qtgahxRuAWQyed/WDl6cF4Mq8n+pcS9sDY9Af0B2Xam0hS2gjaONCpzTlMrVrA==
X-Received: by 2002:a5d:628c:: with SMTP id k12mr11189693wru.211.1590479690013;
        Tue, 26 May 2020 00:54:50 -0700 (PDT)
Received: from pc-3.home (2a01cb0585138800b113760e11343d15.ipv6.abo.wanadoo.fr. [2a01:cb05:8513:8800:b113:760e:1134:3d15])
        by smtp.gmail.com with ESMTPSA id z132sm22024240wmc.29.2020.05.26.00.54.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2020 00:54:49 -0700 (PDT)
Date:   Tue, 26 May 2020 09:54:47 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>
Cc:     kuba@kernel.org, netdev@vger.kernel.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@mellanox.com,
        benjamin.lahaise@netronome.com, tom@herbertland.com,
        pieter.jansenvanvuuren@netronome.com, pablo@netfilter.org,
        liels@mellanox.com, ronye@mellanox.com
Subject: Re: [PATCH net-next v2 0/2] flow_dissector, cls_flower: Add support
 for multiple MPLS Label Stack Entries
Message-ID: <20200526075447.GA19878@pc-3.home>
References: <cover.1590081480.git.gnault@redhat.com>
 <20200525.173818.1886112260004012915.davem@davemloft.net>
 <20200525.174951.2144256991021641644.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200525.174951.2144256991021641644.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 25, 2020 at 05:49:51PM -0700, David Miller wrote:
> From: David Miller <davem@davemloft.net>
> Date: Mon, 25 May 2020 17:38:18 -0700 (PDT)
> 
> > Series applied, thanks.
> 
> Reverted, this doesn't even build with the one of the most popular drivers
> in the tree, mlx5.
> 
Well, this comes from the latest mlx5 pull request, which was posted
_after_ this patch set.

> drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_mplsoudp.c: In function ‘parse_tunnel’:
> drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_mplsoudp.c:105:52: error: ‘struct flow_dissector_key_mpls’ has no member named ‘mpls_label’
>   105 |    outer_first_mpls_over_udp.mpls_label, match.mask->mpls_label);
>       |                                                    ^~
> ./include/linux/mlx5/device.h:74:11: note: in definition of macro ‘MLX5_SET’
>    74 |  u32 _v = v; \
>       |           ^
> drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_mplsoudp.c:107:51: error: ‘struct flow_dissector_key_mpls’ has no member named ‘mpls_label’
>   107 |    outer_first_mpls_over_udp.mpls_label, match.key->mpls_label);
>       |                                                   ^~
> ./include/linux/mlx5/device.h:74:11: note: in definition of macro ‘MLX5_SET’
>    74 |  u32 _v = v; \
>       |           ^

Anyway, I'll respin.

