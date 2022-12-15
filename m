Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E25164E1FE
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 20:50:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbiLOTuc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 14:50:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbiLOTua (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 14:50:30 -0500
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93EE5537E6
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 11:50:29 -0800 (PST)
Received: by mail-ot1-x335.google.com with SMTP id x44-20020a05683040ac00b006707c74330eso109872ott.10
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 11:50:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ywXtZbQmJwRoi6FzZZADFFQbHutCfbqyb/F+E/XRqLg=;
        b=StTfLAKSD8eAoRYx1niZPeceGQsyXy3U+YmbAjVeEDsJdBxVAv9G+2w4/ITPZ0rYFa
         ZNE0yigT4kBDtXFbdIGuSQKOwoTcJkpnCP8cRjtKmO3Tsj4/hHlt4RIWrec1YhFubp4I
         N8cjluk43hTlyQ4vsTIv57tbOGmePvFsgkrA4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ywXtZbQmJwRoi6FzZZADFFQbHutCfbqyb/F+E/XRqLg=;
        b=nXWfroTupna/XFqSTsQ2f3h+sGq88Nams03B+bm37xpWWsoWxArH7FoBdiaVV5020m
         eaKOHW3mX7PSzg6wukeQ8oY46aFDnJyCeN5+s6GH9e5BItDrR80L6ECnLrkydJHMBs3+
         wWbJfqqKhJv1ueBzLyrljhKwE9t1mh/5OerxWmsa6xFYREhDThR/EwdyBgZNn9D02Uyw
         BuDM/1NDMs+CStBTWaDqPd/4Qdw8Tw3TAAmDSQzfyu35mTgcbanoQo1JpFyckJZDSWVW
         Z980zYYnMVqPx2X5/4iuZD0dnFokEZuB7FddaiKQ7OmTE9h5d1ULgrqy2+Ibghn58OFe
         QO/Q==
X-Gm-Message-State: ANoB5pmQHVVcf/Oe3jJao8jJ7FzfcduANuSJvfRGmMy4lMc0aAvoCQQG
        NEjrroIf68GJjMXbGGjxfEbXsA==
X-Google-Smtp-Source: AA0mqf50JR9i5FNpy19Cl1AFkKU/es20UOBCsDkUDVNpP/OiuBZlE66IQJQuKcEXBMMWUMxRaxFl3Q==
X-Received: by 2002:a9d:7ada:0:b0:672:3f94:26a5 with SMTP id m26-20020a9d7ada000000b006723f9426a5mr3900140otn.1.1671133828795;
        Thu, 15 Dec 2022 11:50:28 -0800 (PST)
Received: from C02F109XMD6R.local (2603-8080-1300-8fe5-7840-a7ae-5752-5929.res6.spectrum.com. [2603:8080:1300:8fe5:7840:a7ae:5752:5929])
        by smtp.gmail.com with ESMTPSA id a28-20020a056808099c00b0035ba52d0efasm1385841oic.52.2022.12.15.11.50.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Dec 2022 11:50:28 -0800 (PST)
Date:   Thu, 15 Dec 2022 13:50:15 -0600
From:   Alex Forster <aforster@cloudflare.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     Shawn Bohrer <sbohrer@cloudflare.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, bjorn@kernel.org, magnus.karlsson@intel.com,
        kernel-team@cloudflare.com
Subject: Re: Possible race with xsk_flush
Message-ID: <Y5t5MZH1UwfLqhNC@C02F109XMD6R.local>
References: <Y5pO+XL54ZlzZ7Qe@sbohrer-cf-dell>
 <CAJ8uoz2Q6rtSyVk-7jmRAhy_Zx7fN=OOepUX0kwUThDBf-eXfw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJ8uoz2Q6rtSyVk-7jmRAhy_Zx7fN=OOepUX0kwUThDBf-eXfw@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Magnus,

> Could you please share how you set up the two AF_XDP sockets?

Our architecture is pretty unique:

   outside of │ inside of
    namespace │ namespace
              │
    ┌───────┐ │ ┌───────┐
    │ outer │ │ │ inner │
    │  veth │ │ │ veth  │
    └──┬─▲──┘ │ └──┬─▲──┘
       │ │    │    │ │
    ┌──▼─┴────┴────▼─┴──┐
    │    shared umem    │
    └───────────────────┘

The goal is to position ourselves in the middle of a veth pair so that
we can perform bidirectional traffic inspection and manipulation. To do
this, we attach AF_XDP to both veth interfaces and share a umem between
them. This allows us to forward packets between the veth interfaces
without copying in userspace.

These interfaces are both multi-queue, with AF_XDP sockets attached to
each queue. The queues are each managed on their own (unpinned) threads
and have their own rx/tx/fill/completion rings. We also enable
threaded NAPI on both of these interfaces, which may or may not be an
important detail to note, since the problem appears much harder (though
not impossible) to reproduce with threaded NAPI enabled.

Here’s a script that configures a namespace and veth pair that closely
resembles production, except for enabling threaded NAPI:

```
#!/bin/bash

set -e -u -x -o pipefail

QUEUES=${QUEUES:=$(($(grep -c ^processor /proc/cpuinfo)))}

OUTER_CUSTOMER_VETH=${OUTER_CUSTOMER_VETH:=outer-veth}
INNER_CUSTOMER_VETH=${INNER_CUSTOMER_VETH:=inner-veth}
CUSTOMER_NAMESPACE=${CUSTOMER_NAMESPACE:=customer-namespace}

ip netns add $CUSTOMER_NAMESPACE
ip netns exec $CUSTOMER_NAMESPACE bash <<EOF
  set -e -u -x -o pipefail
  ip addr add 127.0.0.1/8 dev lo
  ip link set dev lo up
EOF

ip link add \
  name $OUTER_CUSTOMER_VETH \
  numrxqueues $QUEUES numtxqueues $QUEUES type veth \
  peer name $INNER_CUSTOMER_VETH netns $CUSTOMER_NAMESPACE \
  numrxqueues $QUEUES numtxqueues $QUEUES

ethtool -K $OUTER_CUSTOMER_VETH \
  gro off gso off tso off tx off rxvlan off txvlan off
ip link set dev $OUTER_CUSTOMER_VETH up
ip addr add 169.254.10.1/30 dev $OUTER_CUSTOMER_VETH

ip netns exec $CUSTOMER_NAMESPACE bash <<EOF
  set -e -u -x -o pipefail
  ethtool -K $INNER_CUSTOMER_VETH \
    gro off gso off tso off tx off rxvlan off txvlan off
  ip link set dev $INNER_CUSTOMER_VETH up
  ip addr add 169.254.10.2/30 dev $INNER_CUSTOMER_VETH
EOF
```

> Are you using XDP_DRV mode in your tests?

Yes.

