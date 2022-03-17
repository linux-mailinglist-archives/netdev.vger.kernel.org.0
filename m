Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB53E4DC5F9
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 13:45:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233659AbiCQMqa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 08:46:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233660AbiCQMq2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 08:46:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6E0031042A3
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 05:45:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647521110;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=Qqa/Ov513ThnEsEWFPNgQG8r30QerKlezRS4gXg/kpo=;
        b=gLhvx+5Y+tyPxaM0pRvriTWU72x2G4axV+4qWvVChnh8K8hHuMgjLerDCb6nmVigR85Rfy
        9BNVUdEEtFqjtBW1R9EaJ/CGpk1rLiK9TxU8hxmyqpccJEURGUjE4lXQGdQd5T6NRHsHPZ
        4f9tc7pTyGGT6axNcEf3KktyLQXo4xk=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-554-_c4GXSIBMSuWwqyAfcCztg-1; Thu, 17 Mar 2022 08:45:09 -0400
X-MC-Unique: _c4GXSIBMSuWwqyAfcCztg-1
Received: by mail-wr1-f70.google.com with SMTP id k20-20020adfc714000000b001e305cd1597so1500423wrg.19
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 05:45:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=Qqa/Ov513ThnEsEWFPNgQG8r30QerKlezRS4gXg/kpo=;
        b=5OzV/K7L3xZ3Os5cMuDNB8AaaxkGKG87Xj4bEwfHO1+vO6koq6hl/NorOxsjTf4Xc9
         tjSGrE4ZjJXhE4adyb5yrb5B44/da9KbZT7WufnB4CLT0YytlgySUKFQMX4ZaJ03L3aO
         dNI1ssJznyaw+wh0CmccxjZrOi3sUZ6cSQYIzBJ6Xsjy/i0p6CqPllaers/o0PqDszQY
         PdfMHvhbtsbPSRHf8JVu+knEIX1p2BRhPbsJzEVQZX7cZtnsZHn/YZl5LeFaiVqDma/J
         ppuTGkiHKQjwo/cE1cbgsRJx7Nwt7cPVLMeVKgLgs6ZLZyIn9XJAztIJmJkwhceofUne
         50Nw==
X-Gm-Message-State: AOAM531lsn7K4cMRB9rRnoNhwJaojvswTOCsclQ2wS2OK2of+NAiIZnn
        KtzQUdRlt4lirAVHjAm2/z6hcMOwkyChuiC5WdsUXRuDgZ7bq0n8SALqwC+TGk6tLFZu5Ibo7Aa
        m+rBwZ5BMVserxHmY
X-Received: by 2002:a5d:66c5:0:b0:1f1:d7e3:7068 with SMTP id k5-20020a5d66c5000000b001f1d7e37068mr3831193wrw.410.1647521107887;
        Thu, 17 Mar 2022 05:45:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzQUEz9vTD/tN2vTIWpyB+hSq9ZgG3GpogtOJn/Hz4HV5q/2amMBXTc2kBHynEiyLTPZY+MFA==
X-Received: by 2002:a5d:66c5:0:b0:1f1:d7e3:7068 with SMTP id k5-20020a5d66c5000000b001f1d7e37068mr3831183wrw.410.1647521107691;
        Thu, 17 Mar 2022 05:45:07 -0700 (PDT)
Received: from pc-4.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id 11-20020a05600c26cb00b0037ff53511f2sm6947761wmv.31.2022.03.17.05.45.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Mar 2022 05:45:07 -0700 (PDT)
Date:   Thu, 17 Mar 2022 13:45:05 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org
Subject: [PATCH net v2 0/2] ipv4: Handle TOS and scope properly for ICMP
 redirects and PMTU updates
Message-ID: <cover.1647519748.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ICMPv4 PMTU and redirect handlers didn't properly initialise the
struct flowi4 they used for route lookups:

  * ECN bits sometimes weren't cleared from ->flowi4_tos.
  * The RTO_ONLINK flag wasn't taken into account for ->flowi4_scope.

In some special cases, this resulted in ICMP redirects and PMTU updates
not being taken into account because fib_lookup() couldn't retrieve the
correct route.

Changes since v1:
  * Fix 'Fixes' tag in patch 1 (David Ahern).
  * Add kernel seltest (David Ahern).

Guillaume Nault (2):
  ipv4: Fix route lookups when handling ICMP redirects and PMTU updates
  selftest: net: Test IPv4 PMTU exceptions with DSCP and ECN

 net/ipv4/route.c                    |  18 +++-
 tools/testing/selftests/net/pmtu.sh | 141 +++++++++++++++++++++++++++-
 2 files changed, 151 insertions(+), 8 deletions(-)

-- 
2.21.3

