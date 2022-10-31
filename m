Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E44A16133DC
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 11:44:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230020AbiJaKoQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 06:44:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229889AbiJaKoO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 06:44:14 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08D6AD98;
        Mon, 31 Oct 2022 03:44:13 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id k8so15386331wrh.1;
        Mon, 31 Oct 2022 03:44:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references
         :organization:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=mLyuDMVnPMQLxfqSCOA6WKTcHcZPNlbCeVpGI+Kz9Mc=;
        b=bbpjQCMNu35fkuIAQRiS6l6lItaINBwkOH6pRZO/wK8bLbu+dwSy6VF6GCeWHX9hg6
         SwInEK3dqS2xCRBmIngFPtYXUjHEgEKYCp9TdOuNqINjDLwoYT1PWeDABJuChodF3IHp
         1NH3eF043snO92fCIe/xfrlP2QjrnXfE6ADMzLisTR8a2zs873kkjx65WpDL7ZSJegsf
         avtTuBdElqIdxouCje9IphNPjX+3ApEvyd8chxTyN4nQfLOKwaDL4UgMF+eqCPgdA7nQ
         QA2stDqxwk4LbU+wE0VVX3z/3Jk6G8q7TUk9vburWit49AhpyPRUkE9jyfdyyav/YzhD
         WbyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references
         :organization:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mLyuDMVnPMQLxfqSCOA6WKTcHcZPNlbCeVpGI+Kz9Mc=;
        b=JeywMZ1cxCrOk9kbrhlhzwyVCVv3xI3i1Chh+DwF/Lsa+blw80Zq8XHWViSyHtG31j
         uTxTR1OY4KMa6xwGYZUY3m3wCFTxnNwkUULFJ+gRfjDuD9eO7AUWr1btVP0LhBDrrF6M
         IuOD/IlWi7AtliA8Hibci3kOFxJWJNW4JvZyK5qEY/nl/Tbg77np7QurXWcdRcyvp6m4
         ChWyyKZB1vEpoV0bj18LxucT/atmGVJ4Yp/LT07gIsvAXNSrY9avahT1Eyyu322DAUJR
         FYEF3CvfWv63jNFc2X7Ud6MCqdJVoj768L1jP6C3WoI5qMWyiRlxvk4E6anjfm+4s5F+
         UaRA==
X-Gm-Message-State: ACrzQf2slWdAcjeoJH4PRx3XLcOyk+dxjq8PY1T/guKBRe0JU0GR/NM0
        dNiPDo2QOCed02KGVB5p3mw=
X-Google-Smtp-Source: AMsMyM7sUhBnxGkKp87JpgaUAB7A5KgNn6cV9iGP87kknDHIDNZR8BSCqTdUcwDe6QWh8NjwqCz8oA==
X-Received: by 2002:a05:6000:887:b0:21e:24a0:f302 with SMTP id ca7-20020a056000088700b0021e24a0f302mr7315795wrb.466.1667213051475;
        Mon, 31 Oct 2022 03:44:11 -0700 (PDT)
Received: from wse-c0155 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id q8-20020a05600c46c800b003b4868eb71bsm6447707wmo.25.2022.10.31.03.44.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Oct 2022 03:44:10 -0700 (PDT)
Date:   Mon, 31 Oct 2022 11:44:09 +0100
From:   Casper Andersson <casper.casan@gmail.com>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, UNGLinuxDriver@microchip.com,
        Randy Dunlap <rdunlap@infradead.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Wan Jiabing <wanjiabing@vivo.com>,
        Nathan Huckleberry <nhuck@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Daniel Machon <daniel.machon@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>
Subject: Re: [PATCH net-next v2 2/5] net: microchip: sparx5: Adding more tc
 flower keys for the IS2 VCAP
Message-ID: <20221031103747.uk76tudphqdo6uto@wse-c0155>
Organization: Westermo Network Technologies AB
References: <20221028144540.3344995-1-steen.hegelund@microchip.com>
 <20221028144540.3344995-3-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221028144540.3344995-3-steen.hegelund@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Steen,

On 2022-10-28 16:45, Steen Hegelund wrote:
> - IPv4 Addresses
>     tc filter add dev eth12 ingress chain 8000000 prio 12 handle 12 \
>         protocol ip flower skip_sw dst_ip 1.0.1.1 src_ip 2.0.2.2    \
>         action trap

I'm not able to get this working on PCB135. I tested the VLAN tags and
did not work either (did not test the rest). The example from the
previous patch series doesn't work either after applying this series.

tc qdisc add dev eth3 clsact
tc filter add dev eth3 ingress chain 8000000 prio 10 handle 10 \
	protocol all flower skip_sw \
	dst_mac 0a:0b:0c:0d:0e:0f \
	src_mac 2:0:0:0:0:1 \
	action trap

This example was provided in your last patch series and worked earlier.

My setup is PC-eth0 -> PCB135-eth3 and I use the following EasyFrames
command to send packets:

ef tx eth0 rep 50 eth smac 02:00:00:00:00:01 dmac 0a:0b:0c:0d:0e:0f

IPv4:
tc qdisc add dev eth3 clsact
tc filter add dev eth3 ingress chain 8000000 prio 12 handle 12 \
    protocol ip flower skip_sw dst_ip 1.0.1.1 src_ip 2.0.2.2    \
    action trap

ef tx eth0 rep 50 eth smac 02:00:00:00:00:01 dmac 0a:0b:0c:0d:0e:0f ipv4 dip 1.0.1.1 sip 2.0.2.2

Same setup as above and I can't get this to work either.

I'm using tcpdump to watch the interface to see if the packets are being
trapped or not. Changing the packets' dmac to broadcast lets me see the
packets so I don't have any issue with the setup.

BR,
Casper

