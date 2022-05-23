Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5042253073D
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 03:45:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235475AbiEWBpF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 May 2022 21:45:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232626AbiEWBpD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 May 2022 21:45:03 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD5D22E087
        for <netdev@vger.kernel.org>; Sun, 22 May 2022 18:45:01 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id w200so12365587pfc.10
        for <netdev@vger.kernel.org>; Sun, 22 May 2022 18:45:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zSm+7Gmlrv50V+RVhmOaUs+k3dWY5NfmKugFSck278k=;
        b=oLzbvEJaIRINzQ7vGPY8dMAa9TLXtBnZe8vAVBWtQsCljcy01w0xke52zx643EFbCH
         zMGo52QWyOT6FS7shoVnkGkUKPNomy9/YzhRY+pcvY1bp9m8oHb7KCBjaQidqjlLTPSb
         JOLCM1BZD6X7ayf7GHtCFxQN7FizN9ZPMYFmH0bvUexef9pSCdkcS9aQ+H8+oFRYpQpf
         TCb60dbVDqOdjkgMTxctJMO/O8k+ezG/179V5y5nDO/NxiWmeH5tusd5H3OZwpGO4FRo
         nq2og8RNtT/rGoeM3AdRhwG57mXeurSHymD9L3wT9VSXVwTrugs6X/wFTP2qsCWb8/39
         xV1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zSm+7Gmlrv50V+RVhmOaUs+k3dWY5NfmKugFSck278k=;
        b=5aL35zOaWf+IMGoigSaMT2I1kY3LO8kOUmhMVDeCU11qEJAUyYJwCF2aAGnLlxZIzn
         3JdPV0ZnihEBXuljehGGzELkLoK0Aixz8MnYHqExqDqwbsUAHtwv4wSQME5HrBAdCN8R
         Fgw3mjUVv+6oaV0f56qtFin1cWxAHMp2kWxu7YfGoXLmi9QZoojXBsp4CKs6DDIN6HJH
         C6iEDVIB61Crq7WXJ7VQHq4PkGnawFkfShZTSdLpQ/+W4Zm4ohC4LB7AQXxQbdcAzH8q
         uAAlNv+ew+SIlY0koqigXDsofL46SQgEbphej/a3jLYqeZiGEbhbEaynURPa76K9BoPy
         ES/Q==
X-Gm-Message-State: AOAM533UkNtRvLDiyvJB/VX8/Ejh48YhI2n2nqPqUWE30SkRnk2tGv8R
        tCCfhgp0C2Q6bMkfyIOMQ6InbVJxRAC9R0xV4M4IMSQw
X-Google-Smtp-Source: ABdhPJzCFwic6JtM/NHqB5PDA+rxiHHD0RDzKgtuO7SZTWmG1A/FvIpC0nux7Dk2woALUzF3OolhmJQ5gJyrvwAa6CE=
X-Received: by 2002:aa7:9109:0:b0:50a:78c8:8603 with SMTP id
 9-20020aa79109000000b0050a78c88603mr21676541pfh.77.1653270301132; Sun, 22 May
 2022 18:45:01 -0700 (PDT)
MIME-Version: 1.0
References: <20220523013233.20045-1-luizluca@gmail.com>
In-Reply-To: <20220523013233.20045-1-luizluca@gmail.com>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Sun, 22 May 2022 22:44:50 -0300
Message-ID: <CAJq09z4PAOen079zE68SMDWDXjJxCDMHYsAtFoUiktA-K1P8Yg@mail.gmail.com>
Subject: Re: [PATCH net-next RESEND] net: dsa: OF-ware slave_mii_bus
To:     "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Rob Herring <robh@kernel.org>
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

In the last attempt, this patch was part of a doc+net series. However,
Rob Herring NAKed the binding patch as we cannot define a "mdio" node
in dsa.yaml without breaking anyone who references dsa.yaml to need to
redefine/specialize that same node.

https://lore.kernel.org/lkml/Yhfmi2Mn6e0NMXh3@robh.at.kernel.org/

So, the generic slave "mdio" node must be declared on each device that
might use it in the future.

Regards,

Luiz
