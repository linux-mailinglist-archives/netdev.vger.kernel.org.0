Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 332384D1927
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 14:29:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231164AbiCHNaZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 08:30:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231289AbiCHNaW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 08:30:22 -0500
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3991F44746
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 05:29:26 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id h14so7227668lfk.11
        for <netdev@vger.kernel.org>; Tue, 08 Mar 2022 05:29:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version:organization
         :content-transfer-encoding;
        bh=vFCtKwPpCOWV7xEAjBoA09CoT7jpkABydzgtjedBdFg=;
        b=pvA3PxoxvKf8ezqMElyGpMHzZ5o5OqlaJ6+rdths8+jvmy8qIkyi38wH5FXbFJafui
         eactrpnHuB+QslGu/qgSqppJUZpHDgkgy4+0YiR/YgaT/pRBFzj4t4ZnXWgCXr7PxH81
         YXzeRgzq2uvGGJe8WCyJuELF0ldpgIZdjVHkPICA3cG4DkH8qJxjXFkL7zY88oYNPuf7
         8wGGbVHglIxNHgqQn4sKfhr7lOutaYot9aJ2EUwiEsjhkioE6ppcvbKGJh7auiEk41KQ
         /Hem/iJuTqm5L0Z1tdTcCYBm6WBJ+kia4O8Yae3U4DoXg1UpJ8Bx7Y5MLxGC1nVeIzke
         irHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :organization:content-transfer-encoding;
        bh=vFCtKwPpCOWV7xEAjBoA09CoT7jpkABydzgtjedBdFg=;
        b=PkIehHKswHT8hXihwP7KEhprrsyX/M0SDCQdU1ZXIe3oak9uo5FG5cWEHhwIuyqDux
         096AGgrjI49sgCB/5f4umX5mc9T1KoWal6LBtmwmPRnZ0gUljpzNA0QNfAO3Z1HNDRSs
         bWYtr4ljET3Xdf8pZ0nWP+KasVXUoz9/mJ/gPbgyyagUOah/D0I+uEVvqzpYdcnMh0gz
         18gPvzG1RjrcKpolLrMK2UkNZ3G2md05riZxrCaL47nDb8yOYvTbTcj0HMbY5hzhNQDn
         gx395TMKiFgswr0g56BcYJ2ess6+AlRabXSvSE/O9izXZB6zOcdgWu9NtVBwULJ4y8ZC
         N9/A==
X-Gm-Message-State: AOAM533opogcZAs2PZDpltBCoFyADjqHOCAKr8iJ2pGWAkM5Vm47EbWs
        UtyHxtgJmyfdjFRs7CzoDXE9oW4N5fQ=
X-Google-Smtp-Source: ABdhPJwWBtOxH1kNN4sKl/WRcMmYoqSzyOC68eQg3jRnLxnQhBvzDjubYVgLLfLrlMp0OWQQX5xfng==
X-Received: by 2002:a05:6512:33d2:b0:448:3237:56dd with SMTP id d18-20020a05651233d200b00448323756ddmr5502770lfg.502.1646746164030;
        Tue, 08 Mar 2022 05:29:24 -0800 (PST)
Received: from wbg.labs.westermo.se (a124.broadband3.quicknet.se. [46.17.184.124])
        by smtp.gmail.com with ESMTPSA id c4-20020ac244a4000000b004482d916b47sm1578711lfm.253.2022.03.08.05.29.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 05:29:23 -0800 (PST)
From:   Joachim Wiberg <troglobit@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Joachim Wiberg <troglobit@gmail.com>
Subject: [PATCH iproute2-next 0/2] bridge: support for controlling broadcast flooding per port
Date:   Tue,  8 Mar 2022 14:29:13 +0100
Message-Id: <20220308132915.2610480-1-troglobit@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Organization: Westermo Network Technologies AB
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

Hi,

this patch set addresses a slight omission in controlling broadcast
flooding per bridge port, which the bridge has had support for a good
while now.

I've grouped the setting alongside it's cousin mcast_flood, but there
could be a need for some rearrangement to also move unicast flooding
to the same group.

Best regards
 /Joachim
