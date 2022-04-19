Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 143065061D5
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 03:52:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239958AbiDSBzD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 21:55:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233223AbiDSBzD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 21:55:03 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90AD41EC62;
        Mon, 18 Apr 2022 18:52:22 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id d198so9342303qkc.12;
        Mon, 18 Apr 2022 18:52:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=J7x6RHJjVOP6JJpTtFmXSE8AFbsY9RkxCow2mq3xx84=;
        b=Inr814cus80rxIujEAiX/uzkL7nLz4oEogx68KmUDBGD9OMSXoz+2FijnJS8SmvJwF
         xmUEbQqZYmU3Jvxodxb/v8MnJjsLPtXWmWO4ReJmh4RVJbnq+r6LOEX6h2DXMk7+i9HS
         ZRk+upBisaOd+tii0BhfUVKRYG65ZuZ9JjW+ACIoMr+C4luRQ8mJjhpaNdMAarQgW+tg
         /D5b30/fnIEc6MmzEv7qqziqjbnGTcShSvvHVEgn6NWEK+nndhdpx4lz/INeU51JWLEt
         WgKNNxB6nBk0jOKSU1YJtmlI9dJSyb0begH/knsL4T1uNn3g2Er3KnVbX9TgG8TxzwoF
         mvkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=J7x6RHJjVOP6JJpTtFmXSE8AFbsY9RkxCow2mq3xx84=;
        b=PcKMfKheRCTtQES8lBVM4C9l7wGPZvi6JDk+gEGLU1teiFs5LWmMP+7PLPIOraw+Rl
         MJSvq3tIbjOgOUaFi3VtrO53LbdsA0L92TnCYOqRQB5px4uf9MLorMEmmNw1A2+bZL/u
         kdw1+rVjXPcGFH9iIDW87MRj7Bu26tQnFGzRtWXTUUHnBmwSrh8yYZ+TpE3JiXfwsLEk
         +f7MgaL5Ueb7qQ6tk/6DMMMKqNyy6u08kJAFhdBrMi+Mg0qhGSrvSrlbyLXh5T53r4lF
         G2X88GM4oZYXxbKP39mZIrzv/DlxXdWplUruXVpChyGKEn5t527tHbK9pjQfQCugEUWb
         +anA==
X-Gm-Message-State: AOAM5320ZX4mjz5qZHXREe1VGcLNc1pRnWiCrQb3paBlnjckb8+h4SAw
        CrW675VSj3t7xFdtG5Ir1qM=
X-Google-Smtp-Source: ABdhPJztID5/0vPuAzBWkdlrZtnLGluRAXeAVIqZj3k0RVMIGtNNeGzxjPiMnTSEzk0h2YC7VD86Hw==
X-Received: by 2002:a05:620a:2988:b0:69c:6fef:4661 with SMTP id r8-20020a05620a298800b0069c6fef4661mr8188474qkp.165.1650333141754;
        Mon, 18 Apr 2022 18:52:21 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id t19-20020ac85893000000b002e1afa26591sm9410769qta.52.2022.04.18.18.52.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Apr 2022 18:52:21 -0700 (PDT)
From:   Lv Ruyi <cgel.zte@gmail.com>
X-Google-Original-From: Lv Ruyi <lv.ruyi@zte.com.cn>
To:     cgel.zte@gmail.com
Cc:     andrew@lunn.ch, bcm-kernel-feedback-list@broadcom.com,
        davem@davemloft.net, f.fainelli@gmail.com, hkallweit1@gmail.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux@armlinux.org.uk, lv.ruyi@zte.com.cn, netdev@vger.kernel.org,
        pabeni@redhat.com, zealci@zte.com.cn
Subject: Re: [PATCH] net: ethernet: mtk_eth_soc: fix error check return value of debugfs_create_dir()
Date:   Tue, 19 Apr 2022 01:52:15 +0000
Message-Id: <20220419015215.2561973-1-lv.ruyi@zte.com.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220419014056.2561750-1-lv.ruyi@zte.com.cn>
References: <20220419014056.2561750-1-lv.ruyi@zte.com.cn>
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

so sorry, please ignore the noise, I sent the mail to the wrong person.

Thanks
Lv Ruyi
