Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24B5F1AD273
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 00:00:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728674AbgDPWA4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 18:00:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727998AbgDPWAz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 18:00:55 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90F3CC061A0C;
        Thu, 16 Apr 2020 15:00:55 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id ay1so151484plb.0;
        Thu, 16 Apr 2020 15:00:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:content-transfer-encoding:mime-version:subject:message-id:date
         :cc:to;
        bh=f7+Ji9iwyRin8bF/31Jh4PKZRcSeX5vOP4UH9FsYD94=;
        b=E5IdDBB4L/OKqkLFUHMZFbtWTcxOc2AoCuLv/N7tmC4Kl4h3rH+BIKEnx0ioKABbVV
         MlYIIxQL7uVuluHIw4Cx6+rNpjOcmTgOQbr+MFQpjOQrRW5+K3yYxi7ZiycD/0Y8xJQB
         GMadALZ1J9hFZyiZ3DCNNYmGocky3rwaAt8REDl3v7rGvDOoLUds5nO/C5PVVxHCPwY5
         sdXq31KX5j0rd7OX5vbVtzHRZwgV0Mn2y8VbPQabGNgtAFkdIw0oeqHwxn5zW8sNpFIr
         PHfNZ5QD9hyfFn+tg4yGecZPKkJNGEorZFlZ8k4Cx3KutFowGPB5/Ehd9FHgjkKEhOQx
         emYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:content-transfer-encoding:mime-version
         :subject:message-id:date:cc:to;
        bh=f7+Ji9iwyRin8bF/31Jh4PKZRcSeX5vOP4UH9FsYD94=;
        b=MQFs8W9MEO3h9KjQW7updH5dDgslxz94hDC/RwuDh3+Oa9oOIIPRElhpP1xP5QCLMS
         GGMnKjGQX7URKHMYerr+vgD4sYzVQyakWIGjx1Yh1HKKxAMidYeuzr6CIf3coPZmfXGI
         sYQCIEPnEmc4Hc6rVHAX72KUnIUvnZGlOtAHh/uCol+/jLy/DpMdIudBfnU6Jd47JOep
         Gj6JHH7cFn1TVttktk/8aXBRcEQHBG0nQ/kzXbBQ4Q1obNnshs5jSsQzG/V0Be0836xz
         tYFAmB+4D11Rv0LLGa26lOgrvOauhRY5/SajvnoG93CvTJlsJeNlynoBGTxPr7NL1Foe
         T9LA==
X-Gm-Message-State: AGi0PubjE+rnYDaa66G84zICCKy/fp7ji3h1oHSm7L63FI4XeA98nhsX
        4np4XBeAeToTmlZRp0t/OmA=
X-Google-Smtp-Source: APiQypI6Z9JJ7fEBKA5VHeBcpql11ojdROgYG4Kv2o+ScM38w0eVljhuMqzAkhiwlfDC+sK2K24Glg==
X-Received: by 2002:a17:90b:1993:: with SMTP id mv19mr507130pjb.88.1587074454950;
        Thu, 16 Apr 2020 15:00:54 -0700 (PDT)
Received: from [10.227.185.29] ([216.113.160.71])
        by smtp.gmail.com with ESMTPSA id o9sm3500862pje.47.2020.04.16.15.00.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 16 Apr 2020 15:00:54 -0700 (PDT)
From:   yunhong-cgl jiang <xintian1976@gmail.com>
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.14\))
Subject: Long delay on estimation_timer causes packet latency
Message-Id: <D25792C1-1B89-45DE-9F10-EC350DC04ADC@gmail.com>
Date:   Thu, 16 Apr 2020 15:00:53 -0700
Cc:     netdev@vger.kernel.org, lvs-devel@vger.kernel.org,
        Yunhong Jiang <yunhjiang@ebay.com>
To:     horms@verge.net.au, ja@ssi.bg
X-Mailer: Apple Mail (2.3445.104.14)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, Simon & Julian,
	We noticed that on our kubernetes node utilizing IPVS, the =
estimation_timer() takes very long (>200sm as shown below). Such long =
delay on timer softirq causes long packet latency. =20

          <idle>-0     [007] dNH. 25652945.670814: softirq_raise: vec=3D1 =
[action=3DTIMER]
.....
          <idle>-0     [007] .Ns. 25652945.992273: softirq_exit: vec=3D1 =
[action=3DTIMER]

	The long latency is caused by the big service number (>50k) and =
large CPU number (>80 CPUs),

	We tried to move the timer function into a kernel thread so that =
it will not block the system and seems solves our problem. Is this the =
right direction? If yes, we will do more testing and send out the RFC =
patch. If not, can you give us some suggestion?

Thanks
=E2=80=94yunhong=20=
