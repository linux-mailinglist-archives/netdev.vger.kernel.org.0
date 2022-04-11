Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB76A4FB3C0
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 08:31:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244914AbiDKGda (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 02:33:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244109AbiDKGda (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 02:33:30 -0400
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2C9A2DD0;
        Sun, 10 Apr 2022 23:31:16 -0700 (PDT)
Received: by mail-qv1-xf2b.google.com with SMTP id d9so2831681qvm.4;
        Sun, 10 Apr 2022 23:31:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=RFwUllTIRMIWM5Lf0IwA2ZRf8BL8H37QwlGOURioq/w=;
        b=etJ5V57g5PfQnWDjf2F/i1XH8sxmr2Jk3ugaxBTtAVGVjDVnHkAL1Mzw22YXp/2pzW
         hO1GF3KOqLc16q9C/ivy2/doYtAotkPkJZOyHb+vmYO9UqL26pL022gfRXz7w4Mt8vQd
         udYVtAb+DdYiri7wm9pID8mMnp8izOZ4GSnc2ioC55nuUrU42hnfXyrOsPF/4wu08ZfV
         /Hb+v/opc4JI6KRVIjas/N8iXUaWB9yu6zWrM2u4073EUu0y2tXwLjshzAe66AtyaVJw
         mkmcvrc8NEjtRhqwR4r0l2C9C/uEsZEFLCO1+5yXckU5ykpMC3+/SjrxiRDzGTcUAatH
         SqPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=RFwUllTIRMIWM5Lf0IwA2ZRf8BL8H37QwlGOURioq/w=;
        b=ClOhqtRMJt/D0V53D4wRfJzevmc7gpXI27ePwAx0Cyb8dQcuTNddndYEsiWCVi95Kq
         y30aIXFGgBukkLJDb9ZUVRyTRTcMXx51M1tWGIabSUBhpcX1mw7HgpOGjGBTiInIGHEa
         XeyLF0kkKoxjLd3wGwMLyzPpNWQR1UVuY7LFebzKzIjwP3wURIOIlbT3SqzLhQEiUpPU
         qwl1OZICaZWn6qWq+qEX7E/EmzojSuvErBt6BX/nBZVpemm6NtEVn+BMv9DZ62qZlW8F
         zjFXOR+P29LX5IrTx9ILLpPcBI7DWLPnCmnnww6RN2mKoylK5kYaNygNJ6kLgxp9MI48
         AjQg==
X-Gm-Message-State: AOAM532tImpZ2+WgLDY2ixCzlCMnmpE157Ss2dnVb+ivQUgdrgWYz6q0
        1M9znmbkKwjlnQArSZNDMQpJA8gIyiKZ83Y5adbND0sV2dDX3Q==
X-Google-Smtp-Source: ABdhPJwl4L3Hs3yCGEEHY0TC1QZOnQmzJQUzs2+k+z+sE9vqwzSjaVBk1isZhK0UOkHwrDuK5CJCUQUktKDE+Q9gIc4=
X-Received: by 2002:a05:6214:1d02:b0:444:263c:fa36 with SMTP id
 e2-20020a0562141d0200b00444263cfa36mr11629953qvd.36.1649658675707; Sun, 10
 Apr 2022 23:31:15 -0700 (PDT)
MIME-Version: 1.0
From:   Vishnu Motghare <vishnumotghare@gmail.com>
Date:   Mon, 11 Apr 2022 12:01:04 +0530
Message-ID: <CADSz7_efMoSG9wYr_jaaXtG8YB0FkhB4862iL40Y-BeUw+UB+A@mail.gmail.com>
Subject: gianfar ethernet driver losses Rx-Messages
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     claudiu.manoil@nxp.com, davem@davemloft.net, kuba@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I have Freescale LS1021A target with kernel version - 5.10.35-rt. The
device has 3 ethernet ports & one of the ports is used for EtherCAT.
The Samba service is running on the device, which configures on all
interfaces by default. We have observed that EtherCAT master losses RX
messages frequently. On analyzing the tcpdump messages, it is seen
that loss of RX message is seen immediately after NetBIOS packets
which are from the samba service. The loss of message counter reported
by EtherCat Master & Kernel driver is the same. To get the missed RX
error I've applied a patch from the mainline kernel -
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/patch/drivers/net/ethernet/freescale/gianfar.c?id=14870b75fe0be5c565339f008ba25326f86a7ce8

How gianfar ethernet driver lose RX messages immediately after NetBios
packets? Any help is appreciated.

ifconfig output:

ETH1 Link encap:Ethernet  HWaddr 70:B3:D5:AB:45:73
          inet addr:192.168.137.248  Bcast:255.255.255.255  Mask:255.255.255.0
          UP BROADCAST RUNNING PROMISC MULTICAST  MTU:1500  Metric:1
          RX packets:737729 errors:0 dropped:8 overruns:0 frame:0
          TX packets:737753 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:96268280 (91.8 MiB)  TX bytes:96273512 (91.8 MiB)
          Base address:0x3000
