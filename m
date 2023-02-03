Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EEE3688EC8
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 06:06:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231635AbjBCFF5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 00:05:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231149AbjBCFF4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 00:05:56 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA4862708;
        Thu,  2 Feb 2023 21:05:55 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id ml19so12422074ejb.0;
        Thu, 02 Feb 2023 21:05:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=7fY5j1jAIj7Uxf/jZW/utbpEJzbkP46FJilFzLuPxMw=;
        b=bbf7KnwRHsVNww7xW2PNvzqncFNGQBVTdV0dxU9LcZpJGyLv6VISNhuCjBSw1t5SPo
         Ai5nOv1OzagwRSQO/csZ4YTJklCa01o5NeyakaasYfWXytjW8hKTQQR3cMP2qPt1WXuG
         Bzz5gvpaXdXxk6XYZzS//9mO82G6cR0srMCq/GRocl785IXy18DElb1QgQCiv9l3N24N
         N1EOyIxixuVSE3EbeT67fg+xxQBVHXUH14n1Vxp1KadyEx/4JqJXKoiJrXRuqIRgdm1H
         4b2S2xUARsGhx61lQzVtjpH8Ol2O5UsVk31h4CdvHaQ6Q8phn1EFM16cJ+aIDkQ0A5lS
         nG6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7fY5j1jAIj7Uxf/jZW/utbpEJzbkP46FJilFzLuPxMw=;
        b=CJjH0G4i9f06kxqo0ck8zABbSBRZgjRk1sshts1897bn/WZQLEzkxAL9iQ3E8/uEgA
         Rhi30ELAZlwsfhWxBT2IkxO0EfokYV2k5gyDANwLl92MWuB9OV9XFfCQrF4GYg+VPzMq
         awHbw/5llo/5gOnwfmhAgbiW4bQ9Z5sBf1F7fmKfsKzVgZZmxV2SmRZhyAdUyQvGqtyF
         kuh8z9sX1Ci4RWoGSQZoFNlQpwmcN7onzb6ilLF/uxBgoAtg5XgUxq2huMq1oaI9H+1d
         UZ7wjEcf1SVPAYqTKHQj5ARQOtvay9lf1cl+jLar5DLtvurAIc86GpCE453aF12D0ysJ
         Qn+Q==
X-Gm-Message-State: AO0yUKVducAm16UZ3ZEGo8Fyih6W3eZN2f6JCaT78f1lVRcV3Diq74rx
        p2dCkpde4grek/iX1ayQiJhMGpCGM2yjWP3ob9I=
X-Google-Smtp-Source: AK7set922hbQ0vxTuxQ2UbTgS6R45DiqMDRtcZYe5a+RO0zzG+Ch1ZlSoj4uAzQuiE690kPEWT/SxFBtUax2285mFo8=
X-Received: by 2002:a17:906:fc20:b0:86e:429b:6a20 with SMTP id
 ov32-20020a170906fc2000b0086e429b6a20mr2576522ejb.247.1675400754106; Thu, 02
 Feb 2023 21:05:54 -0800 (PST)
MIME-Version: 1.0
References: <cover.1675245257.git.lorenzo@kernel.org> <7c1af8e7e6ef0614cf32fa9e6bdaa2d8d605f859.1675245258.git.lorenzo@kernel.org>
In-Reply-To: <7c1af8e7e6ef0614cf32fa9e6bdaa2d8d605f859.1675245258.git.lorenzo@kernel.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 2 Feb 2023 21:05:42 -0800
Message-ID: <CAADnVQLTBSTCr4O2kGWSz3ihOZxpXHz-8TuwbwXe6=7-XhiDkA@mail.gmail.com>
Subject: Re: [PATCH v5 bpf-next 8/8] selftests/bpf: introduce XDP compliance
 test tool
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Marek Majtyka <alardam@gmail.com>,
        Saeed Mahameed <saeedm@nvidia.com>, anthony.l.nguyen@intel.com,
        Andy Gospodarek <gospo@broadcom.com>, vladimir.oltean@nxp.com,
        Felix Fietkau <nbd@nbd.name>, john@phrozen.org,
        Leon Romanovsky <leon@kernel.org>,
        Simon Horman <simon.horman@corigine.com>,
        Ariel Elior <aelior@marvell.com>,
        christophe.jaillet@wanadoo.fr, ecree.xilinx@gmail.com,
        "Michael S. Tsirkin" <mst@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Stanislav Fomichev <sdf@google.com>,
        gerhard@engleder-embedded.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 1, 2023 at 2:25 AM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>
> Introduce xdp_features tool in order to test XDP features supported by
> the NIC and match them against advertised ones.
> In order to test supported/advertised XDP features, xdp_features must
> run on the Device Under Test (DUT) and on a Tester device.
> xdp_features opens a control TCP channel between DUT and Tester devices
> to send control commands from Tester to the DUT and a UDP data channel
> where the Tester sends UDP 'echo' packets and the DUT is expected to
> reply back with the same packet. DUT installs multiple XDP programs on the
> NIC to test XDP capabilities and reports back to the Tester some XDP stats.


'DUT installs...'? what? The device installs XDP programs ?

> +
> +       ctrl_sockfd = accept(*sockfd, (struct sockaddr *)&ctrl_addr, &addrlen);
> +       if (ctrl_sockfd < 0) {
> +               fprintf(stderr, "Failed to accept connection on DUT socket\n");

Applied, but overuse of the word 'DUT' is incorrect and confusing.

'DUT socket' ? what is that?
'Invalid DUT address' ? what address?
The UX in general is not user friendly.

./xdp_features
Invalid ifindex

This is not a helpful message.

./xdp_features eth0
Starting DUT on device 3
Failed to accept connection on DUT socket

'Starting DUT' ? What did it start?
