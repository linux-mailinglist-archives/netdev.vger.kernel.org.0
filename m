Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 196294FEEC3
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 07:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232622AbiDMFz0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 01:55:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229917AbiDMFzZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 01:55:25 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1104738DB5
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 22:53:05 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id k5so1597878lfg.9
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 22:53:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7U40Ltcj2IU9/USLZ23kMUEI1qqBd4qWHJo2TOH5zSQ=;
        b=OR9C6RtXfkdyzSyh7vrDh0o+8LlhQrLAliQFeLCNjMLdXz5WavEo2tzgTVvHcDz1Wn
         D7prtbZE/X0g7u8twN//FxoKtexCYLwK06bDeDBxXjjml2b9aezthrOx7wy2HdoCasaI
         GWhTodeSf2oQJQxy2pKTX8NQaHybughVr0qdoO1Y7N7uvl1MX3A1T6DGee0fWV/lfip8
         YiCtVo077EgmiJQZzbbmjB2WM0lID5yuTnH6HnQtwTGv8HLpwjrzFa5aYqYn+kOloso3
         dD9zp7aORPWSHtisuRPGWvdtgst6/6ZEAr2vtLuausOKRKWVh/OKYXbVYlpj18R8zXRE
         l8uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7U40Ltcj2IU9/USLZ23kMUEI1qqBd4qWHJo2TOH5zSQ=;
        b=EnfDq/DGUPh/ut1AU3MOmFuQDnbOyHhQkCXco97opc7A17aaqYsnX5jJ45H4A2NEDI
         XuYBT5rU2DR14wkLF+zVMBJtVBacyQrKvDbZb8nK8Ah9JhysdXs48rmcv5vbHH+Yy5cK
         M+quVRVreF9KxsMh80YFfWBW/kwmGtxh9y9ISneaNlbOyL0Lk+Kj77WNGTbECum7e/mf
         2N474jTfaphD0FbSWQvvWr48k50cJEGWNomIV9lpFG9U4ad47530S//MWdorEBaNxBkx
         D31K88gFV4QeizwihUYQg9nLNW7ytUxGW0aThzrfwC+2qQ2hRwoiHn8rszz21G6PWYa1
         1oQg==
X-Gm-Message-State: AOAM531oakLgzRYYml0BEucmQArZgDBNyutGbFhV9XKgRuuN52f36uxd
        VTw9bK4ajnWYcgOJ7rrcnEkezPwHuIm5/Q==
X-Google-Smtp-Source: ABdhPJwgCIY6iYn2zICUkN4nb1qBRzyYrkhospTzwXNAGF4wOTt6IAm2JHGYOasBtbgpyJFXwGwGVQ==
X-Received: by 2002:ac2:4c89:0:b0:46b:c187:b761 with SMTP id d9-20020ac24c89000000b0046bc187b761mr3312052lfl.272.1649829182966;
        Tue, 12 Apr 2022 22:53:02 -0700 (PDT)
Received: from wse-c0089.westermo.com (h-98-128-237-157.A259.priv.bahnhof.se. [98.128.237.157])
        by smtp.gmail.com with ESMTPSA id o18-20020a2e9b52000000b0024af0b04d04sm3681231ljj.1.2022.04.12.22.53.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 22:53:02 -0700 (PDT)
From:   Mattias Forsblad <mattias.forsblad@gmail.com>
To:     netdev@vger.kernel.org
Cc:     roid@nvidia.com, vladbu@nvidia.com, Eli Cohen <eli@mellanox.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Mattias Forsblad <mattias.forsblad@gmail.com>
Subject: [RFC net-next] net: tc: flow indirect framework issue
Date:   Wed, 13 Apr 2022 07:52:48 +0200
Message-Id: <20220413055248.1959073-1-mattias.forsblad@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello all,

I'm currently working to get offloading of tc rules (clsact/matchall/drop) 
on a bridge offloaded to HW. The patch series is here:

https://lore.kernel.org/netdev/20220411131619.43js6owwkalcdwwa@skbuf/T/#m07bff9e205e9ac03d15a4e758b4129235da88aba

However I'm having some trouble with it. More specific in the limitations section
in the link above, quote:

Limitations
If there is tc rules on a bridge and all the ports leave the bridge
and then joins the bridge again, the indirect framwork doesn't seem
to reoffload them at join. The tc rules need to be torn down and
re-added. This seems to be because of limitations in the tc
framework.

The same issue can bee seen it you have a bridge with no ports
and then adds a tc rule, like so:

tc qdisc add dev br0 clsact
tc filter add dev br0 ingress pref 1 proto all matchall action drop

And then adds a port to that bridge
ip link set dev swp0 master br0   <---- flow_indr_dev_register() bc this

I'm seeing the callback(TC_SETUP_BLOCK) from flow_indr_dev_register()
but I'm not getting any callbacks that I've added via flow_block_cb_add()

Do you maybe have some idea why I'm seeing this behavior?
Am i doing something wrong or is it a known issue or something else?

Best regards,

Mattias Forsblad
mattias.forsblad@gmail.com
