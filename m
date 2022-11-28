Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC54963AD77
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 17:16:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232736AbiK1QQR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 11:16:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232602AbiK1QPw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 11:15:52 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43B7625C7A
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 08:15:32 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id n20so27184785ejh.0
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 08:15:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=e49lpcajP1pWfP9PLN5ezZLkzYU5TdqdlWhinBMuT3s=;
        b=VnTu/HiJszV69VtcaGgtXrtza6pmORHOH1LkoKj8GZRErF8dMyOx7Ogajoa5uAaXOj
         BlaJ5kyQGv2cqxqFuHF/DC76n1hu21QdNElwx2tqCYJnyHAMY/vWxSV/iY7xJEMKViKH
         kOLTSDhdJ+92mGAkEGDIWBWRsUus/FXaeYY+IH7WGeNUNJqLnPA5aVSsAKJ4b0CzrZ0E
         Ezn0pl8ZqoD8btMrGw7No4zxqBBSRcSck9jubbcNfsCAOcBjok27effNyuiKGSpMSIuO
         SL+mrtd1/5tdQupcMOtITaoAfm6Q7ltnAbcBAAgLpzOAptJ3SeKjvBmpusiJQOuzGPJ6
         6v9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=e49lpcajP1pWfP9PLN5ezZLkzYU5TdqdlWhinBMuT3s=;
        b=B693/jJJHzD8SvhqcD2t2Z5qgg4nEYef1RkHjtSehzwScIoi/MTkm1He/1itBkag1w
         S808ieL5JIFSqycBfa97OgyXnEKBuDXh9440Z2kkCg4kGxN2+dRClH70dHtoPAil+B8X
         K0QFmsKDS/SPPUpekzoNLbFHjN3x/ieszv7oyM7ZLQNpuWqvWYSFPWmD+8ksu1k08vQT
         UPqTzemng6fYW4A8yzqQsLjv4QNOAtemzuKIdQk0Een9MDKyhG2j9efnJlZAShtxNtNx
         u5ZQuPHcaEZfDEGV2PQMBbo1cd7v1ty7U49YadGpam2V8rVE8es1OBwBEHw/VemJP+US
         dgfw==
X-Gm-Message-State: ANoB5pkMR2YfSBWvnG9u6O0mYF7cP86GqFcQudl0nd7DOOTQl1+gMJNI
        Yz/CmriwihNtmkiJxeZafFVhnhpGJz0=
X-Google-Smtp-Source: AA0mqf47xTXLU7GQx8b2vO4JAzVwBiEojkkAZXap5srGHLHhlGXiYPRv2JAc0Pva5vnZWuiWEq/MGw==
X-Received: by 2002:a17:907:77ce:b0:7c0:8225:54d with SMTP id kz14-20020a17090777ce00b007c08225054dmr253517ejc.286.1669652130701;
        Mon, 28 Nov 2022 08:15:30 -0800 (PST)
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com. [209.85.221.48])
        by smtp.gmail.com with ESMTPSA id z3-20020aa7c643000000b004587f9d3ce8sm5325962edr.56.2022.11.28.08.15.29
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Nov 2022 08:15:30 -0800 (PST)
Received: by mail-wr1-f48.google.com with SMTP id z4so17703754wrr.3
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 08:15:29 -0800 (PST)
X-Received: by 2002:a5d:6d49:0:b0:236:bad6:44df with SMTP id
 k9-20020a5d6d49000000b00236bad644dfmr30706289wri.489.1669652129410; Mon, 28
 Nov 2022 08:15:29 -0800 (PST)
MIME-Version: 1.0
References: <20221128140210.553391-1-willemdebruijn.kernel@gmail.com> <1951bd409f86287fcffce41e22026ed09605f9b2.camel@redhat.com>
In-Reply-To: <1951bd409f86287fcffce41e22026ed09605f9b2.camel@redhat.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 28 Nov 2022 11:14:52 -0500
X-Gmail-Original-Message-ID: <CA+FuTScsg6b8wKc4Sz=z+M53nWaxOZh4J+A=JooJspDjysXg6Q@mail.gmail.com>
Message-ID: <CA+FuTScsg6b8wKc4Sz=z+M53nWaxOZh4J+A=JooJspDjysXg6Q@mail.gmail.com>
Subject: Re: [PATCH net-next] selftests/net: add csum offload test
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com
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

On Mon, Nov 28, 2022 at 11:08 AM Paolo Abeni <pabeni@redhat.com> wrote:
>
> Hi,
>
> On Mon, 2022-11-28 at 09:02 -0500, Willem de Bruijn wrote:
> > From: Willem de Bruijn <willemb@google.com>
> >
> > Test NIC hardware checksum offload:
> >
> > - Rx + Tx
> > - IPv4 + IPv6
> > - TCP + UDP
> >
> > Optional features:
> >
> > - zero checksum 0xFFFF
> > - checksum disable 0x0000
> > - transport encap headers
> > - randomization
> >
> > See file header for detailed comments.
> >
> > Expected results differ depending on NIC features:
> >
> > - CHECKSUM_UNNECESSARY vs CHECKSUM_COMPLETE
> > - NETIF_F_HW_CSUM (csum_start/csum_off) vs NETIF_F_IP(V6)_CSUM
> >
> > Signed-off-by: Willem de Bruijn <willemb@google.com>
>
> I'm wondering if we could hook this into the self-tests list with a
> suitable wrapper script, e.g. searching for a NIC exposing the loopback
> feature, quering the NETIF_F_HW_CSUM/NETIF_F_IP(V6)_CSUM bit via
> ethtool and guessing CHECKSUM_UNNECESSARY vs CHECKSUM_COMPLETE via the
> received packet.
>
> If the host lacks a suitable device, the test is skipped. WDYT?

We could. Optionally with ipvlan and two netns to really emulate a two
host setup.

I'm hesitant to include this into kselftests without warning though.
Have too often had to debug tests that crashed and left a machine
unreachable, because in loopback mode.

Either way, something to do as a separate follow-up patch?
