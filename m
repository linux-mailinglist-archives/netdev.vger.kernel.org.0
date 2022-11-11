Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CF74626322
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 21:45:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233476AbiKKUpO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 15:45:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231625AbiKKUpN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 15:45:13 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7234145A26
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 12:45:11 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id 140so4370229pfz.6
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 12:45:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gateworks-com.20210112.gappssmtp.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=d8m2Zw4oWN2ixkNtEl2hUN3TTxVYsgtW6pwWgbf1jfs=;
        b=eIlvZ08rE7ZmkvxASeI+Rk1XAT+QdJf6gzVO/Wj3lEcst1uDtOpVFCeNyVtG4pRuJu
         MgCHxNAAvR8V+9BpKYfev3ut60T3C9RBnfVN8MzBMI/tmaGlFUEBHpiVAlVBvUMiIm2H
         KNJJVpViFxKU3u9s9Q3OCZkrxRlgzPt4ULBqCxNCYNPIhIdxL1kYXOLB6xQ06c41JSlU
         UB0F/hL3hQmt7FOgt7kMX4ULDBLaQzpwhnW2nvxBsDcBcu6e+s02Cs7kUTvmkqCmM1DG
         aioMa2KlsTsdep3kkmXs5BVH6mskglP60IlIqpYZc8WgvmlKs0jSR9j144z1tSiNMnyC
         LSpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=d8m2Zw4oWN2ixkNtEl2hUN3TTxVYsgtW6pwWgbf1jfs=;
        b=WIauCxpONjsrT36hxHz34mmHNy0bLKCBn7KHLfYsZNBiJRW3x31J/j/FovCI3P2Kz5
         ADbToVVRkHSLRPViSi97KKJR69lhaFwIMDWSOC2UHgUdSplYhXaDaNxZkAU2+pNvDsra
         seg91pDXB/nQnRffGnldHzhlAPOdB8TEiw0ubltPyW+u45WzJnV/yp7Qd7KC4RJ/eh2W
         577dJn7YC8oXJ3ACxbXaJY5LKGzgM6iwvONoCtWKVVVRlkUNEnuSJMSFJSkwclwR+Os8
         j5TVTQNNlVInjQEEJAc/Kf2c9b4X99A/O7HHPOG3yDutGFz3H4psWlgrBJmhqQQifFRq
         y3Xg==
X-Gm-Message-State: ANoB5plZmlduDZiT4tZqEl+A4zRS2PVyt2g0tf4uGhDR5q9qfJMS4T3F
        dBFpaZu6DG5G9yp70hIlpEjxO9+vbT/f2308lxoCs8gMqMBRdw==
X-Google-Smtp-Source: AA0mqf4mt2NjgL9vVB4ZDGPDcEccG2UQ9q4we+to+wQ86i7yg+ny54IUTQ53sisQMKBSbrv0KMGumVx5R+xCzYCh0Vo=
X-Received: by 2002:a63:5307:0:b0:45b:f8be:7402 with SMTP id
 h7-20020a635307000000b0045bf8be7402mr3023424pgb.484.1668199510695; Fri, 11
 Nov 2022 12:45:10 -0800 (PST)
MIME-Version: 1.0
From:   Tim Harvey <tharvey@gateworks.com>
Date:   Fri, 11 Nov 2022 12:44:59 -0800
Message-ID: <CAJ+vNU3zeNqiGhjTKE8jRjDYR0D7f=iqPLB8phNyA2CWixy7JA@mail.gmail.com>
Subject: status of rate adaptation
To:     netdev <netdev@vger.kernel.org>,
        Sean Anderson <sean.anderson@seco.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greetings,

I've noticed some recent commits that appear to add rate adaptation support:
3c42563b3041 net: phy: aquantia: Add support for rate matching
7de26bf144f6 net: phy: aquantia: Add some additional phy interfaces
b7e9294885b6 net: phylink: Adjust advertisement based on rate matching
ae0e4bb2a0e0 net: phylink: Adjust link settings based on rate matching
0c3e10cb4423 net: phy: Add support for rate matching

I have a board with an AQR113C PHY over XFI that functions properly at
10Gbe links but still not at 1Gbe,2.5Gbe,5.0Gbe,100M with v6.1-rc4

Should I expect this to work now at those lower rates and if so what
kind of debug information or testing can I provide?

Best Regards,

Tim
