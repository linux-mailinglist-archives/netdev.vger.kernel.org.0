Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C8FD50938A
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 01:21:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383161AbiDTXYf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 19:24:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383156AbiDTXY3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 19:24:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1BEA51B7B4
        for <netdev@vger.kernel.org>; Wed, 20 Apr 2022 16:21:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650496901;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=hbJYGdvEOazrXlCtcoBfBwuX3abqIWg2vu1EtizrtC8=;
        b=KXmgvQEkEL3bHWLO2U6B2kr7pc+ZY4sD829uBZF418vdaaPsdLey6sFiRZSt2qzuOLX93K
        gF/mqdEyNETAPFR3CYK3jW3Sem1JLUyhwMBlJsoz0MtOGlnQWE31ZCzSE0L2sksjpd2OMO
        +7aXmEj51buo0eAyNEYUvcHWzUknzCg=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-128-F7_fw8QCNz63fs_cwA7c1A-1; Wed, 20 Apr 2022 19:21:24 -0400
X-MC-Unique: F7_fw8QCNz63fs_cwA7c1A-1
Received: by mail-wm1-f71.google.com with SMTP id r9-20020a1c4409000000b0038ff033b654so1554234wma.0
        for <netdev@vger.kernel.org>; Wed, 20 Apr 2022 16:21:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=hbJYGdvEOazrXlCtcoBfBwuX3abqIWg2vu1EtizrtC8=;
        b=SAudJwbna1Ry0fTHR/550ZaoRai7KtaPNKsUmcCKoUYtOquDftZLBOaZmRrGKpkFXE
         z80zhAqKHOCDr2ZAepmpfGJuUyapRM/EARd0vaxbhjI8S3RwvKuDda4m3PAUFSHuoXXk
         o6lyyfbzs7apfONE+6JyGCod7Qy/HQ9zYJcoKDzGSKdbGH7f45AfEdJyKmKdy7SWq8G7
         VmG/Iiuk/Vgv3KL95dB3zS2cwuJtgPN0ADwIShNudQPvIaeA2yxalFCl+VUw14h/PoKG
         2DROC9+qXfIHXl8HUTbOZfKUM1uEI3OJVKs3pyB+rAeBnHn2YBX2I6kg1oBkIhWLlh5M
         JHBA==
X-Gm-Message-State: AOAM533MHx55Hp3Y4hDy+fe/oek48mo1Vm4+vFXr9i/DGWq+JNqNMT3p
        jf7sl/tOpGgKSNG3qlbgbmvALFfSZwA484X+a6KuJVwgAlC9JN1qH/ai3KofGHOnZZRqnwz6Po8
        LyIvhBJxgKqv6fUW3
X-Received: by 2002:a05:600c:a03:b0:37b:daff:6146 with SMTP id z3-20020a05600c0a0300b0037bdaff6146mr5774384wmp.85.1650496882616;
        Wed, 20 Apr 2022 16:21:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxo89OB0L7C+fOTGPu87GxJ363Qr+U5mDJtwcIHCT3LXyuAOI6bYIdOKR918/xx3V47JNwkOA==
X-Received: by 2002:a05:600c:a03:b0:37b:daff:6146 with SMTP id z3-20020a05600c0a0300b0037bdaff6146mr5774368wmp.85.1650496882421;
        Wed, 20 Apr 2022 16:21:22 -0700 (PDT)
Received: from debian.home (2a01cb058d3818005c1e4a7b0f47339f.ipv6.abo.wanadoo.fr. [2a01:cb05:8d38:1800:5c1e:4a7b:f47:339f])
        by smtp.gmail.com with ESMTPSA id y6-20020a056000168600b0020a96d2cf8fsm1107213wrd.60.2022.04.20.16.21.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Apr 2022 16:21:22 -0700 (PDT)
Date:   Thu, 21 Apr 2022 01:21:19 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, dccp@vger.kernel.org
Subject: [PATCH net-next 0/3] ipv4: First steps toward removing RTO_ONLINK
Message-ID: <cover.1650470610.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RTO_ONLINK is a flag that allows to reduce the scope of route lookups.
It's stored in a normally unused bit of the ->flowi4_tos field, in
struct flowi4. However it has several problems:

 * This bit is also used by ECN. Although ECN bits are supposed to be
   cleared before doing a route lookup, it happened that some code
   paths didn't properly sanitise their ->flowi4_tos. So this mechanism
   is fragile and we had bugs in the past where ECN bits slipped in and
   could end up being erroneously interpreted as RTO_ONLINK.

 * A dscp_t type was recently introduced to ensure ECN bits are cleared
   during route lookups. ->flowi4_tos is the most important structure
   field to convert, but RTO_ONLINK prevents such conversion, as dscp_t
   mandates that ECN bits (where RTO_ONLINK is stored) be zero.

Therefore we need to stop using RTO_ONLINK altogether. Fortunately
RTO_ONLINK isn't a necessity. Instead of passing a flag in ->flowi4_tos
to tell the route lookup function to restrict the scope, we can simply
initialise the scope correctly.

Patch 1 does some preparatory work: it stops resetting ->flowi4_scope
automatically before a route lookup, thus allowing callers to set their
desired scope without having to rely on the RTO_ONLINK flag.

Patch 2-3 convert a few code paths to avoid relying on RTO_ONLINK.

More conversions will have to take place before we can eventually
remove this flag.

Guillaume Nault (3):
  ipv4: Don't reset ->flowi4_scope in ip_rt_fix_tos().
  ipv4: Avoid using RTO_ONLINK with ip_route_connect().
  ipv4: Initialise ->flowi4_scope properly in ICMP handlers.

 include/net/route.h | 36 ++++++++++++++++++++++++------------
 net/dccp/ipv4.c     |  5 ++---
 net/ipv4/af_inet.c  |  6 +++---
 net/ipv4/datagram.c |  7 +++----
 net/ipv4/route.c    | 41 +++++++++++++++++++----------------------
 net/ipv4/tcp_ipv4.c |  5 ++---
 6 files changed, 53 insertions(+), 47 deletions(-)

-- 
2.21.3

