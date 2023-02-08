Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D498568F41F
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 18:16:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231515AbjBHRQA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 12:16:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230290AbjBHRP7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 12:15:59 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 253F528D03
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 09:15:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675876511;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=pf+MRjcS0vkSAveWPfrv42Noh2meZT4kW8DODMvq+8k=;
        b=JHoMFh/IuoC/cfV+SIA4kbVlFred6AXODL6ficmDNAVGPdGHMdvW+CsK6/IRMNVvXi0+PI
        zCg3lQGBQ81sKLXovzAVfsGBXXXThd1KX5tPeFIs//n5RzEcWx8CcH7DkbX2G0HL4Ofpc8
        89p9Fe9xsUrrq98ecsbRVMFSm7DdKQ4=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-661-VVC4T-5UMcWiyIGcHHqsoA-1; Wed, 08 Feb 2023 12:14:06 -0500
X-MC-Unique: VVC4T-5UMcWiyIGcHHqsoA-1
Received: by mail-qt1-f198.google.com with SMTP id l3-20020a05622a174300b003b9b6101f65so11138462qtk.11
        for <netdev@vger.kernel.org>; Wed, 08 Feb 2023 09:14:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pf+MRjcS0vkSAveWPfrv42Noh2meZT4kW8DODMvq+8k=;
        b=34iWK0IYNgaCJEsIsX62DyiJwLCbj78ResR8ygk+R0bpp/C9ArFuNHTeFLPCqoSRzh
         ZymQuXetWzi4u0mLCMQxzAmKLbmaMaZLit9n2bw028wJacKtCpJoUO1WUu2ylBoxHSdl
         fssdLdumeXmWt8DqmaqPC14H8o2Hsry4h+g9mAuTugR5fY5J2OUQUh85VPBZY7aQiesP
         Aha4AeZ9hN5EMRzVUAhkF31/g28AVeb7vsI37PisQbZh/b7XetcEVMpKwXnK/Ifr6TUd
         EPcdHRGMEKJNlVpw315mNmEGSUxCzCTZmLdyDhJBTx7oN9+xVbSIsYswBkLiZddCWP9x
         3ZhQ==
X-Gm-Message-State: AO0yUKUuP98D94RG5cvkVNnY6C+r0Zn0JO+YrvKQXJxqVq2ur98KPOfQ
        AT98G23OSNV/yt/5AnE3KbtwxXjEKCZkcw0qWVey8v5CXRhtcqobSkOki3ptkA8vIzHIc051n5q
        XQy1TAB15IZK2DDWH
X-Received: by 2002:a05:622a:1a8d:b0:3a7:e625:14f with SMTP id s13-20020a05622a1a8d00b003a7e625014fmr12464348qtc.9.1675876440686;
        Wed, 08 Feb 2023 09:14:00 -0800 (PST)
X-Google-Smtp-Source: AK7set+qez4YiBK4x3/d8EqcZ54Qtsoj7YzxG/FDPzL2TAvD8tav6RI2IcL6U1iiC5KECysM+5u7bg==
X-Received: by 2002:a05:622a:1a8d:b0:3a7:e625:14f with SMTP id s13-20020a05622a1a8d00b003a7e625014fmr12464318qtc.9.1675876440419;
        Wed, 08 Feb 2023 09:14:00 -0800 (PST)
Received: from debian (2a01cb058918ce00464fe7234b8f6f47.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:464f:e723:4b8f:6f47])
        by smtp.gmail.com with ESMTPSA id bs11-20020a05620a470b00b0071b1fe18746sm12059398qkb.63.2023.02.08.09.13.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Feb 2023 09:13:59 -0800 (PST)
Date:   Wed, 8 Feb 2023 18:13:56 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Subject: [PATCH net 0/3] ipv6: Fix socket connection with DSCP fib-rules.
Message-ID: <cover.1675875519.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The "flowlabel" field of struct flowi6 is used to store both the actual
flow label and the DS Field (or Traffic Class). However the .connect
handlers of datagram and TCP sockets don't set the DS Field part when
doing their route lookup. This breaks fib-rules that match on DSCP.

Guillaume Nault (3):
  ipv6: Fix datagram socket connect with DSCP.
  ipv6: Fix tcp socket connect with DSCP.
  selftests: fib_rule_tests: Test UDP and TCP connections with DSCP
    rules.

 net/ipv6/datagram.c                           |   2 +-
 net/ipv6/tcp_ipv6.c                           |   1 +
 tools/testing/selftests/net/fib_rule_tests.sh | 128 +++++++++++++++++-
 tools/testing/selftests/net/nettest.c         |  51 ++++++-
 4 files changed, 179 insertions(+), 3 deletions(-)

-- 
2.30.2

