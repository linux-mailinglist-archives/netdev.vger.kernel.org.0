Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ACF561DCA2
	for <lists+netdev@lfdr.de>; Sat,  5 Nov 2022 18:42:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbiKERmK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Nov 2022 13:42:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiKERmK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Nov 2022 13:42:10 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E743A1C91E
        for <netdev@vger.kernel.org>; Sat,  5 Nov 2022 10:42:08 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id y16so10898977wrt.12
        for <netdev@vger.kernel.org>; Sat, 05 Nov 2022 10:42:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-language:thread-index:content-transfer-encoding
         :mime-version:message-id:date:subject:to:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=gXqF6ghsV1QeTgqO0S2aYcU47u1LrV7dTF/uSEqXBHM=;
        b=ijWuuOAYOBaTmQndk/UjF3NQ7lzal8YjmiXFN9PUifZN85UrzZe7rk+HmW0LdjTfOD
         v7ClkGK5rAoN1UomlFhhOIM/Dk9Xt2McUHWmQYb+hWJM2sQLcQmUzLybRy5+PNNc0r6Q
         LGOELuq80Et214ex52VS8Uzhb50hAVyZYrjPG04oGpGrbFrtdSxTo3XDxZ7UmlvsBUxN
         q9dzSJDlBUn/3681kUmP0/Z7FFK8xf+m7QrC/d+RZ6WsiqLwnniuVYAzjyLw2Z2XzEl0
         nfMwxyxmO/v4VnpbeB3xG0/2VSRAPA2bNWEyrT1Mf27tWKzoQZCPQQ5KIWx4ZNb6CPyJ
         aHQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:thread-index:content-transfer-encoding
         :mime-version:message-id:date:subject:to:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gXqF6ghsV1QeTgqO0S2aYcU47u1LrV7dTF/uSEqXBHM=;
        b=23w9AJQKb+fhDpgKL9I/rp+aeBlZ2/lNn/qm/lsPZw5yuB8cpS5Q2mH1ZDUbNkODr/
         XqskayYij6ws+QfecWoNBspS89RK00EO3MgOV6hdyxmgiMEjYooQc68vuX1Ua+Megb+e
         0ViDOevKRcpq9qu/aoVO+foWSldIbePmkfFT1mCibOdpXPCDY/L78jH9CqQtgt2LVsns
         51fvLNZLuZb4O4qPEVnCrc3sMoh30IHHpQPEIcFLDXouut3zrjz0lMzPnivX94GDG/SX
         Y67xbi27X/LXU9aZg33g9Tbr68qBoFqaUKcP2EgS9RKKPNHWpcOhE+e4DEHg3F5bFPjA
         Thvw==
X-Gm-Message-State: ACrzQf1AB5s5LgWe8BpxHDJtNbNrPHOe8NUmR0yed0nGZxUXtjBVPU76
        5qmTf9Kyipt/odN0MXTmBN4NmERCxWV89A==
X-Google-Smtp-Source: AMsMyM4c+SI4t34Ujrc1MmFsxZODP/l19JyOSjohyUHctBMyjUb8gtPWQM2soXv/ikmBMW5wMxIGQA==
X-Received: by 2002:a5d:5186:0:b0:236:79a2:af1 with SMTP id k6-20020a5d5186000000b0023679a20af1mr26264451wrv.648.1667670127085;
        Sat, 05 Nov 2022 10:42:07 -0700 (PDT)
Received: from zbpt9gl1 (net-2-45-26-236.cust.vodafonedsl.it. [2.45.26.236])
        by smtp.gmail.com with ESMTPSA id bg27-20020a05600c3c9b00b003a5f3f5883dsm7334291wmb.17.2022.11.05.10.42.06
        for <netdev@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 05 Nov 2022 10:42:06 -0700 (PDT)
From:   <piergiorgio.beruto@gmail.com>
To:     <netdev@vger.kernel.org>
Subject: Adding IEEE802.3cg Clause 148 PLCA support to Linux
Date:   Sat, 5 Nov 2022 18:42:10 +0100
Message-ID: <026701d8f13d$ef0c2800$cd247800$@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AdjxO1BPMo/qcrVLSfirwB2eLOeyww==
Content-Language: en-us
X-Spam-Status: No, score=-0.2 required=5.0 tests=BAYES_20,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,
I would like to add IEEE 802.3cg-2019 PLCA support to Linux.
PLCA (Physical Layer Collision Avoidance) is an enhanced media-access =
protocol for multi-drop networks, and it is currently specified for the =
10BASE-T1S PHY defined in Clause 147 of the same standard.
This feature is fully integrated into PHY and MACPHY implementations =
such as the onsemi NCN26010 and Microchip LAN867x, which are available =
on the market.
And, I am the inventor of the PLCA protocol =F0=9F=98=8A.

I am writing here because I am seeking advice on what is the best way =
forward.
In practice, what we need to do is configuring some additional =
parameters of the PHY: PLCA ID, TO_TIMER, NODE_COUNT, BURST.
The PHY registers for PLCA configuration are further documented in the =
OPEN alliance SIG public specifications (see =
https://www.opensig.org/about/specifications/ -> PLCA Management =
Registers)

The parameters I mentioned has to be configured dynamically. Therefore, =
I think we should not use module parameters or static DT configurations.
Based on my personal experience, It looks to me that extending ethtool =
is the way to go. Maybe we should consider those as =
=E2=80=9Ctunables=E2=80=9D?

I am really interested to hear the opinion of the relevant Linux network =
experts on this topic.

Kind Regards,
Piergiorgio


