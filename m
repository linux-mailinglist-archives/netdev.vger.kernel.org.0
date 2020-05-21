Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66A9D1DD4B9
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 19:47:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728718AbgEURrP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 13:47:15 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:40981 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727966AbgEURrP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 13:47:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590083233;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=WwzYScIDzPKzEYY/aNyPJaGwE2McykJ7FFyOLpty4a8=;
        b=JJ02a2JoSOTn3L84gdbUsBqpa//kzZbP38qQ1Aw+a9iJOzRi1veyTN9GDoYsF2pBXoOKLS
        06A6edAF0lLKZdhMt+vGkxTUd2iw25j6QyBzr6xr9Y2Iljw9hIPBdebJbtulRK2ADmkDY8
        xV2VBu9gQBhlmuVUAaj9IcuPxbzOrZ8=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-36-WcXjvvAmMj2x__tzuvfJcA-1; Thu, 21 May 2020 13:47:12 -0400
X-MC-Unique: WcXjvvAmMj2x__tzuvfJcA-1
Received: by mail-wm1-f70.google.com with SMTP id l26so2088645wmh.3
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 10:47:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=WwzYScIDzPKzEYY/aNyPJaGwE2McykJ7FFyOLpty4a8=;
        b=R27iwQOLEF08DlIiTPwpaW3w0mtth2gGtsVDJ/CJ79db/K3Q5VxijNcNJnRecoxiVx
         BgDRq7sIxQuJ7ELhsIyl34HiAVf/3XjPF5EyDRLp5P6NmDxZHT+qAgC3Ziq9AwH3UGKO
         pNARpQHnyCU80k/vPJ1+JV17YAc3QSDP9Q3jipZzug24Dz1Wk6QUm0+JeGEJfMsCq2zO
         ZHK9zTDUYo+H6joVvTpMGFe57bGh1Gu8VU1jTqatCqVxz0NAU9YTU5FS24dwbiwk2Syy
         fM9zyhPSNBQ4D+aSnVhfuW5p3qQ4zh1kb9X2pI0TthsOWZsSfCw7tM9f7NvSxHtRFHjc
         LOYg==
X-Gm-Message-State: AOAM532ixcQ6HqrLvkIXO7sDCfebo8bSGIelDEZMGgKqDqoQ6vsLBjGf
        F3n7q3h/YINpmESoTpNRD+OW9xpdhP4YL65iayAS2QMvJUGDhzO4Q78CzBKzgzbvE5xpmyI8ueW
        YuxXYl6pwj6Qf0d1O
X-Received: by 2002:a5d:6283:: with SMTP id k3mr9245256wru.62.1590083231085;
        Thu, 21 May 2020 10:47:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxzr1/ywUSoAeX1gdRYlQPONSiNxwJpVYNSTGkKnw0D/KnnWkz3BcvC2IPOA9oUERgOZfE47Q==
X-Received: by 2002:a5d:6283:: with SMTP id k3mr9245243wru.62.1590083230894;
        Thu, 21 May 2020 10:47:10 -0700 (PDT)
Received: from pc-3.home (2a01cb0585138800b113760e11343d15.ipv6.abo.wanadoo.fr. [2a01:cb05:8513:8800:b113:760e:1134:3d15])
        by smtp.gmail.com with ESMTPSA id a12sm1373472wrs.70.2020.05.21.10.47.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2020 10:47:10 -0700 (PDT)
Date:   Thu, 21 May 2020 19:47:08 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Benjamin LaHaise <benjamin.lahaise@netronome.com>,
        Tom Herbert <tom@herbertland.com>,
        Pieter Jansen van Vuuren 
        <pieter.jansenvanvuuren@netronome.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Liel Shoshan <liels@mellanox.com>,
        Rony Efraim <ronye@mellanox.com>
Subject: [PATCH net-next v2 0/2] flow_dissector, cls_flower: Add support for
 multiple MPLS Label Stack Entries
Message-ID: <cover.1590081480.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, the flow dissector and the Flower classifier can only handle
the first entry of an MPLS label stack. This patch series generalises
the code to allow parsing and matching the Label Stack Entries that
follow.

Patch 1 extends the flow dissector to parse MPLS LSEs until the Bottom
Of Stack bit is reached. The number of parsed LSEs is capped at
FLOW_DIS_MPLS_MAX (arbitrarily set to 7). Flower and the NFP driver
are updated to take into account the new layout of struct
flow_dissector_key_mpls.

Patch 2 extends Flower. It defines new netlink attributes, which are
independent from the previous MPLS ones. Mixing the old and the new
attributes in a same filter is not allowed. For backward compatibility,
the old attributes are used when dumping filters that don't require the
new ones.

Changes since v1:
  * Fix compilation of NFP driver (kbuild test robot).
  * Fix sparse warning with entropy label (kbuild test robot).

Guillaume Nault (2):
  flow_dissector: Parse multiple MPLS Label Stack Entries
  cls_flower: Support filtering on multiple MPLS Label Stack Entries

 .../net/ethernet/netronome/nfp/flower/match.c |  42 ++-
 include/net/flow_dissector.h                  |  14 +-
 include/uapi/linux/pkt_cls.h                  |  23 ++
 net/core/flow_dissector.c                     |  49 ++-
 net/sched/cls_flower.c                        | 295 +++++++++++++++++-
 5 files changed, 378 insertions(+), 45 deletions(-)

-- 
2.21.1

Note: the NFP udpate was only compile-tested as I don't have the
required hardware.

