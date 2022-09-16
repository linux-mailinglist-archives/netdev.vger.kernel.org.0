Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 584365BAF8B
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 16:43:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231376AbiIPOnn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 10:43:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231616AbiIPOnh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 10:43:37 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17DC15F221;
        Fri, 16 Sep 2022 07:43:36 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id bj12so49840120ejb.13;
        Fri, 16 Sep 2022 07:43:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=LKoaZ5We1TGLeFod6UTJMH7q09dtJndCh1W2gfaDfzM=;
        b=FPZdopoGGaFUGRqTDSLf/mbn0u3wwg02p7UxOEwbSG5bvv6s1++oPirhDM2S8KDyD3
         Be4kaXWPqfFNLq2WkV+3glORMuZGdpg1KhtQloZrB3q+fLSD6ftqJGEgYYjBh/wBd3eE
         eIuCY02i9QkxVIJ4CbywRVkrJM2CNGcmWwjFWBY9/VggqGJEfPMkOg73aeUsYNqc11Nk
         BSpoheNWqki6kQX/hPBNjmaOV9wmEYoonf2nu8mYsDV4yu7o3NB1BDKYhzVXyVPip/ve
         8UoGeR9+5GsN6d3gary881TBLdzmIfsEcLA5ilkgjX6j1j7bK6TaBbXKy6ba9TUBhjZV
         NCjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=LKoaZ5We1TGLeFod6UTJMH7q09dtJndCh1W2gfaDfzM=;
        b=fuB89yp6QwMSgMXJyaWttiGFhkLJoGPCn0pLCkWp+6RCkufhRcZJiQhxhfvq0CwhRU
         FKK7HAuIo7TwaQybiNLlSWgZgBmM1MRPQqfXTHzFk1pux0kl6xFEe4zFTphPk8NoUTc6
         ym+DEc9zWQ/onJ8RmUHGW0j6tGAglAKnZYqAu12m4q6a0VXgxkU9Yi4PJUPoyhnilmEL
         Rg8MsOEoN/XEBYuu6kVqVKG5Ue6hREkFAnFLGMu0gecrHlt/QoSNQIBDabSyBzLTtNMb
         yRYMMcviPgvc6oU1hstuDxdDfScPoSq49YBJrAQwyi9gwNTxx1yMAk6LM3oLCG/gmcmp
         KBDw==
X-Gm-Message-State: ACrzQf1b2mymPay0SlCyEI9Gk2pMEC/X7w4lBGD+hvLlMay5pLa2nPye
        WbeX2ELqr1VA2rRT3NwiW4M=
X-Google-Smtp-Source: AMsMyM7zIcoW0FRIFKPApyLHgN4mHUuTE5bIgYjHNY9NOwwKb46Fr6t/zkSgRGUmnFvAOxGKYq84kA==
X-Received: by 2002:a17:906:7944:b0:73c:838:ac3d with SMTP id l4-20020a170906794400b0073c0838ac3dmr3838252ejo.242.1663339414462;
        Fri, 16 Sep 2022 07:43:34 -0700 (PDT)
Received: from labdl-itc-sw06.tmt.telital.com (static-82-85-31-68.clienti.tiscali.it. [82.85.31.68])
        by smtp.gmail.com with ESMTPSA id b15-20020aa7cd0f000000b004527eb874ebsm6273792edw.40.2022.09.16.07.43.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Sep 2022 07:43:31 -0700 (PDT)
From:   Fabio Porcedda <fabio.porcedda@gmail.com>
To:     mhi@lists.linux.dev, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, mani@kernel.org, loic.poulain@linaro.org,
        ryazanov.s.a@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Cc:     dnlplm@gmail.com
Subject: [PATCH 0/2] Add a secondary AT port to the Telit FN990
Date:   Fri, 16 Sep 2022 16:43:27 +0200
Message-Id: <20220916144329.243368-1-fabio.porcedda@gmail.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to add a secondary AT port to the Telit FN990 first add "DUN2"
to mhi_wwan_ctrl.c, after that add a seconday AT port to the
Telit FN990 in pci_generic.c

Fabio Porcedda (2):
  net: wwan: mhi_wwan_ctrl: Add DUN2 to have a secondary AT port
  bus: mhi: host: pci_generic: Add a secondary AT port to Telit FN990

 drivers/bus/mhi/host/pci_generic.c | 2 ++
 drivers/net/wwan/mhi_wwan_ctrl.c   | 1 +
 2 files changed, 3 insertions(+)

-- 
2.37.3

