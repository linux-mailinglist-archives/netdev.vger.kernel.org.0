Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3487D6AA5
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 22:15:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731502AbfJNUPJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 16:15:09 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:37022 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729864AbfJNUPI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Oct 2019 16:15:08 -0400
Received: by mail-pf1-f195.google.com with SMTP id y5so10999721pfo.4
        for <netdev@vger.kernel.org>; Mon, 14 Oct 2019 13:15:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rNLplWPzCFWlmBH0YsnpdjS526HhYFOEgUd29EPDURg=;
        b=2L37Oana/SBHUxavko8qwllSxv1fjK5o1T0Rp9D+Qz1tbjxGeVMHwnsWY51ht5CthN
         GORU7ezb1/jDwAKWMomGBH2FiPjiRtsZyfKCzqIr0eboZpOMZVPnx0KhhD82IX3hb5Bc
         NERLNoX6rlbEiRXrLSYIJaei7D1Fpilyk7fKxRc5veZe3YrR55PzHtRbYpA6REH4Y3Bl
         MkabbiT1ahWZx33XDQHoq8gqIfSRGQrXBiOiyn2o1R/ib4DDcMuuy5qX0jzfstTiTHV5
         u4woIp10Z3kPPWYZwJV48lEC2F6M6uuVfznhLyRj85XWwJzojwHn9XCgPUXwF+yWEdeu
         7XOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rNLplWPzCFWlmBH0YsnpdjS526HhYFOEgUd29EPDURg=;
        b=kdbkWNxUZdtdhMv3O/qxOBOYrskxpNSiTe6mqgU+xfWWKSvMyWjZs6yOrL+TZ0ilhR
         ErdLkiJ9LuOShfsy+nctuJ87S0XyB+vrKgaAIFOv2TwKbkgmgOhCbyGtU1oZFiguFKJH
         POClpVeDF7oo/HM26T9jms4+KfU8YZksdEMmXgz85X4RlPNxFKx2Cl+ha8S/aPEA5jbd
         77Jv1Fv+eoUGK/t6XNV9/aVCZWks6zQ+5YzQGVzSIgoqaW/vdXrqZbOe4OAPcbnpbn83
         3PgG0sez6vgmOR8zfedaRuIGFQ1Ez+jr9v5mQPIslCE8TIABw0G20pGQUndep1ZnAOWu
         nh0g==
X-Gm-Message-State: APjAAAWca+zB+3rm2pr2ws4bn2JyNVGBOG2N3cxsXqdIMpbVoGbFTbJG
        5yu2TIrDDB5GeD+guW+wFd8eEgtIoqqytA==
X-Google-Smtp-Source: APXvYqzsc0CHOFHsx4KSnRNR5nZ3i2IbdP1j6QBvQqsMcI3ZR17YHqeAOYppvKBUA0HrqwLQWffnEA==
X-Received: by 2002:a65:5cca:: with SMTP id b10mr17912355pgt.258.1571084107864;
        Mon, 14 Oct 2019 13:15:07 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id 19sm18637993pjd.23.2019.10.14.13.15.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Oct 2019 13:15:07 -0700 (PDT)
Date:   Mon, 14 Oct 2019 13:15:00 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        Petr Oros <poros@redhat.com>
Subject: Re: [PATCH iproute2] ipnetns: enable to dump nsid conversion table
Message-ID: <20191014131500.7dd2b1a8@hermes.lan>
In-Reply-To: <20191007134447.20077-1-nicolas.dichtel@6wind.com>
References: <20191007134447.20077-1-nicolas.dichtel@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  7 Oct 2019 15:44:47 +0200
Nicolas Dichtel <nicolas.dichtel@6wind.com> wrote:

> This patch enables to dump/get nsid from a netns into another netns.
> 
> Example:
> $ ./test.sh
> + ip netns add foo
> + ip netns add bar
> + touch /var/run/netns/init_net
> + mount --bind /proc/1/ns/net /var/run/netns/init_net
> + ip netns set init_net 11
> + ip netns set foo 12
> + ip netns set bar 13
> + ip netns
> init_net (id: 11)
> bar (id: 13)
> foo (id: 12)
> + ip -n foo netns set init_net 21
> + ip -n foo netns set foo 22
> + ip -n foo netns set bar 23
> + ip -n foo netns
> init_net (id: 21)
> bar (id: 23)
> foo (id: 22)
> + ip -n bar netns set init_net 31
> + ip -n bar netns set foo 32
> + ip -n bar netns set bar 33
> + ip -n bar netns
> init_net (id: 31)
> bar (id: 33)
> foo (id: 32)
> + ip netns list-id target-nsid 12
> nsid 21 current-nsid 11 (iproute2 netns name: init_net)
> nsid 22 current-nsid 12 (iproute2 netns name: foo)
> nsid 23 current-nsid 13 (iproute2 netns name: bar)
> + ip -n foo netns list-id target-nsid 21
> nsid 11 current-nsid 21 (iproute2 netns name: init_net)
> nsid 12 current-nsid 22 (iproute2 netns name: foo)
> nsid 13 current-nsid 23 (iproute2 netns name: bar)
> + ip -n bar netns list-id target-nsid 33 nsid 32
> nsid 32 current-nsid 32 (iproute2 netns name: foo)
> + ip -n bar netns list-id target-nsid 31 nsid 32
> nsid 12 current-nsid 32 (iproute2 netns name: foo)
> + ip netns list-id nsid 13
> nsid 13 (iproute2 netns name: bar)
> 
> CC: Petr Oros <poros@redhat.com>
> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> ---
>  include/libnetlink.h |   5 +-
>  ip/ip_common.h       |   1 +
>  ip/ipnetns.c         | 115 +++++++++++++++++++++++++++++++++++++++++--
>  lib/libnetlink.c     |  15 ++++--
>  4 files changed, 126 insertions(+), 10 deletions(-)
> 

Applied. Please send another patch to update man page.

