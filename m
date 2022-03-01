Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 744DF4C8810
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 10:34:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233857AbiCAJfW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 04:35:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233904AbiCAJfQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 04:35:16 -0500
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63B348BF0A;
        Tue,  1 Mar 2022 01:34:31 -0800 (PST)
Received: by mail-qk1-x72a.google.com with SMTP id d84so12477087qke.8;
        Tue, 01 Mar 2022 01:34:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3u7MIrbpVdaLqG9Uqr3lA3Jqll+sAuWBAxK//kkArRY=;
        b=hPJQya0fMkrYp7W9gJzWqHP9x4nADh9bRmReFwWvJ3PThg0eFX4wyaaqZ0yQuwnkJo
         uWKbWdDblTL2rWmcvIMv6YjaQS9XVe84m/XaxsPLN7kQMK+a7VUTA9dgY8lNGk9elw4V
         rckreDwBzlqfobzy652C6yMHP6oXEnalLUI0ehFaXn1uDb2kZkcbHfzWncjJlm0Keptd
         ROGy7icoJWpojCSrPuChvIQSDaLIUhLo7S1mXbzPNxLWwrEK9zGtCaR1xS3STPJkHthV
         0HZUQUFSCbylBtIbGx10jnkA3R2LIWl31ZL6Q4d/VGYAqNqhs1K+g9QuNHUGQGM/RNFX
         JDGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3u7MIrbpVdaLqG9Uqr3lA3Jqll+sAuWBAxK//kkArRY=;
        b=GvOEDoRuecFzIP1dxc+SNKqxdrJ3PJ+EWo0Mj10qMA/rQ9lY1rbZBZHsE5ue6s+JIN
         HHGFfCNyJ9wOZAuDmxpaAeCrLSYIkTHU9UoQXqRmAzjZrTvE11bSJqa2c7SRwCBaOHI9
         pV8Z2kMjFfkdmU4CPYt1yYJu4HriQQ2cWQOTL6V10X04UkVHmpX8CDLaJHC7SsYhPHet
         jlYI4xoblvnyD8eqQgn8mkRyUOcnyaWHUkxTPpJ0fd5PUye+h3j2lEmOXYXybUQAwXiV
         SBVH5Jk4W1sVzwKtNbjde6PebLbrZcEsKVi69Vt2PCEPrHrGk50V3JhswEYafVvtCQBL
         C+Rw==
X-Gm-Message-State: AOAM532rTepjJcYIqNXnUTctkv2afGVO+oYxKVEeGnc7pQGGG5QD+X6M
        iHtTqtaIPr9SqjCLHun3gSsQviMzCiI=
X-Google-Smtp-Source: ABdhPJzdfXWlqE2OBTT4ttJLDLsXhOYyN2NmfQp1oLoKqxbU1vgsiJcbTVIirBuFKKpVpRD4LngG9Q==
X-Received: by 2002:a37:8605:0:b0:648:e9ae:ce94 with SMTP id i5-20020a378605000000b00648e9aece94mr13232282qkd.58.1646127270573;
        Tue, 01 Mar 2022 01:34:30 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id o18-20020a05622a139200b002de25b59013sm8663439qtk.84.2022.03.01.01.34.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Mar 2022 01:34:30 -0800 (PST)
From:   Lv Ruyi <cgel.zte@gmail.com>
X-Google-Original-From: Lv Ruyi <lv.ruyi@zte.com.cn>
To:     krzysztof.kozlowski@canonical.com
Cc:     cgel.zte@gmail.com, chi.minghao@zte.com.cn, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, zealci@zte.com.cn
Subject: Re: [PATCH] net/nfc/nci: use memset avoid infoleaks
Date:   Tue,  1 Mar 2022 09:34:24 +0000
Message-Id: <20220301093424.2053471-1-lv.ruyi@zte.com.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <664af071-badf-5cc9-c065-c702b0c8a13d@canonical.com>
References: <664af071-badf-5cc9-c065-c702b0c8a13d@canonical.com>
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

hello sir

I think this way: On 64-bit systems, struct nci_set_config_param has 
an added padding of 7 bytes between struct members id and len. Even 
though all struct members are initialized, the 7-byte hole will 
contain data from the kernel stack. 

thanks
Minghao
