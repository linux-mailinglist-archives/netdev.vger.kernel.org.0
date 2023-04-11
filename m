Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F1276DD142
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 06:58:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbjDKE62 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 00:58:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbjDKE61 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 00:58:27 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FCF8E6F
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 21:58:25 -0700 (PDT)
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 1DB1E3F232
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 04:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1681189103;
        bh=KZfBLpN/gahf4Na+DiCMXXdGEJe19xHkIm66KVYL3RU=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=wXVAx+NvdegvvpUD6OOFsuukq4xI5TADWG8uJEnaKwDNs8FqEyDKLD4sMrDLWboGM
         RZajAd7tAOpmtmqoWM4q3mCbPAg2jME5IuvVTQZhyYuw3/5rfV+Y1mpFLURZQ4XU85
         xye/sTagXn+seHcTsHXoLMly3xPUbKf+ZvfFeDnBCLGF8xHhNC6ffl5rQRdyEx3c3i
         UfPgNC08rHsdA54gbnqAWMxMjSPjunjXiuxIEpCcdhV/CPJYJtd8LlRFgzzti2ac7w
         AFkAvmT6OPAMvJoYMvt43h6CCfb4mOksRgC9lAgkLyX1AAmkzDtHB1Tqx4/Zs1lN+Y
         mCwEix4Ubka5g==
Received: by mail-pl1-f200.google.com with SMTP id m13-20020a170902db0d00b001a63c5ce31cso2687406plx.3
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 21:58:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681189101; x=1683781101;
        h=message-id:date:content-id:mime-version:comments:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KZfBLpN/gahf4Na+DiCMXXdGEJe19xHkIm66KVYL3RU=;
        b=02/zqooY7X3UwIoTfmEWO1au5GEyYWIdgAHPPZe0OtV6j5jg6I2uMfMtVf3gWmtXt9
         ePyMguwjyCp1Ad7f+6VxROBEgRAFN3+OYGEFvjz/iJxMx/Ctz1jOnSxtuZxZWvC0Us8c
         uH3sygLSNxSFI1il15MIhSbfrJTPjNTNVqud+xRw/E4gZef0+rQp4JAtf0ubh8Cec5b9
         I2Y+f5hrhalZdJ/ybswoLWBKzJU0domDdIjG50/PZeR3tHzTeuGR0OQrUUB0K6owBH4p
         CnObvcGIAoNKhJ2pTkeQq1NDsCna5d84vu2FYXdPZ/cYkshj2ex35PVB8bQssqkksDXV
         qJnQ==
X-Gm-Message-State: AAQBX9es3QKw1EA1HmUsYXBaRLnS9udKVZNXRRILGGb29hYfsUxhxP08
        sJ3n9GDpyE4YmoWENLlnekQ0pDRUj/j34Pwz5KYgKns6rVCLA9foIqRWdfMbIYHwKo/SsrF3aTj
        KXqyYTtT2FckWveBvARoV8DYLa8BNdbHspQ==
X-Received: by 2002:a05:6a20:33a8:b0:e3:8710:6848 with SMTP id f40-20020a056a2033a800b000e387106848mr8659162pzd.41.1681189101490;
        Mon, 10 Apr 2023 21:58:21 -0700 (PDT)
X-Google-Smtp-Source: AKy350bEqfmn5biyh+6G1LBlXJucwKMd0MRFFYszdQXPYNvTuuWT+6lnsJYqDYeWyAEkzCrOoXsqvQ==
X-Received: by 2002:a05:6a20:33a8:b0:e3:8710:6848 with SMTP id f40-20020a056a2033a800b000e387106848mr8659142pzd.41.1681189101180;
        Mon, 10 Apr 2023 21:58:21 -0700 (PDT)
Received: from famine.localdomain ([50.125.80.253])
        by smtp.gmail.com with ESMTPSA id p25-20020a62ab19000000b00638c9a2ba5csm2351342pff.62.2023.04.10.21.58.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 Apr 2023 21:58:20 -0700 (PDT)
Received: by famine.localdomain (Postfix, from userid 1000)
        id 1772F61E6E; Mon, 10 Apr 2023 21:58:20 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 103909FB79;
        Mon, 10 Apr 2023 21:58:20 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Liang Li <liali@redhat.com>
cc:     vfalico@gmail.com, andy@greyhouse.net, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org,
        Paolo Abeni <pabeni@redhat.com>, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hangbin Liu <haliu@redhat.com>,
        "Toppins, Jonathan" <jtoppins@redhat.com>
Subject: Re: [Question] About bonding offload
In-reply-to: <CAKVySpzU_23Z6Gu1N=z0DRm+sUQDjyiyUc18r4rJ_YQ+YELuFg@mail.gmail.com>
References: <CAKVySpzU_23Z6Gu1N=z0DRm+sUQDjyiyUc18r4rJ_YQ+YELuFg@mail.gmail.com>
Comments: In-reply-to Liang Li <liali@redhat.com>
   message dated "Tue, 11 Apr 2023 09:47:14 +0800."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <27296.1681189100.1@famine>
Date:   Mon, 10 Apr 2023 21:58:20 -0700
Message-ID: <27297.1681189100@famine>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Liang Li <liali@redhat.com> wrote:

>Hi Everyone,
>
>I'm a redhat network-qe and am testing bonding offload. e.g. gso,tso,gro,lro.
>I got two questions during my testing.
>
>1. The tcp performance has no difference when bonding GRO is on versus off.
>When testing with bonding, I always get ~890 Mbits/sec bandwidth no
>matter whether GRO is on.
>When testing with a physical NIC instead of bonding on the same
>machine, with GRO off, I get 464 Mbits/sec bandwidth, with GRO on, I
>get  897 Mbits/sec bandwidth.
>So looks like the GRO can't be turned off on bonding?

	Well, it's probably more correct to say that GRO is
unimplemented for "stacked on top" interfaces like bonding (or bridge,
vlan, team, etc).  GRO operates early in the receive processing, when
the device driver is receiving packets, typically by calling
napi_gro_receive() from its NAPI poll function.  This is well before
bonding, bridge, et al, are involved, as these drivers don't do NAPI at
all.

>I used iperf3 to test performance.
>And I limited iperf3 process cpu usage during my testing to simulate a
>cpu bottleneck.
>Otherwise it's difficult to see bandwidth differences when offload is
>on versus off.
>
>I reported a bz for this: https://bugzilla.redhat.com/show_bug.cgi?id=2183434
>
>2.  Should bonding propagate offload configuration to slaves?
>For now, only "ethtool -K bond0 lro off" can be propagated to slaves,
>others can't be propagated to slaves, e.g.
>  ethtool -K bond0 tso on/off
>  ethtool -K bond0 gso on/off
>  ethtool -K bond0 gro on/off
>  ethtool -K bond0 lro on
>All above configurations can't be propagated to bonding slaves.

	The LRO case is because it's set in NETIF_F_UPPER_DISABLES, as
checked in netdev_sync_upper_features() and netdev_sync_lower_features().

	A subset of features is handled in bond_compute_features().
Some feature changes, e.g., scatter-gather, do propagate upwards (but
not downwards), as bonding handles NETDEV_FEAT_CHANGE events for its
members (but not vice versa).

	TSO, GSO, and GRO aren't handled in either of these situations,
and so changes don't propagate at all.  Whether they should or not is a
separate, complicated, question.  E.g., should features propagate
upwards, or downwards?  How many levels of nesting?

	-J

>I reports a bz for this: https://bugzilla.redhat.com/show_bug.cgi?id=2183777
>
>I am using the RHEL with kernel 4.18.0-481.el8.x86_64.
>
>BR,
>Liang Li
>

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
