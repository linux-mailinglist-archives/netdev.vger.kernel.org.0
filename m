Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2087F4C8B16
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 12:48:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232359AbiCALtI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 06:49:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbiCALtH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 06:49:07 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7010E13D17;
        Tue,  1 Mar 2022 03:48:26 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id e2so836745pls.10;
        Tue, 01 Mar 2022 03:48:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=GVNww0y/ubpMNmzwfijWtJHUzpAuRS+zSxR5eOOX/oU=;
        b=UXy+QBJSYf6dcc6rcNTFgmGJ+el0nh9Wz7RffJ/YkbiCm6Y3QuaLwxaLTeogEjIxgY
         CATlZk62FRfVdVbdiASXtCKUQKxeIujlfHI0HJKpiVMko9ys8Kcq5gBAgULiJbArD0oZ
         0stvhhStzD+AjwbplHx2HR5OCCTTNxkpB1GrnosWHwbsfRMT3/plQN5TbO5wgZTLQ9P+
         EkhGXlF0B5sPY8oPMoZlC7fcX6nppCM3F0/5pqDS18oWUWWe70jC/Pm+dBMOQ9f1d+Ai
         Bo/vh0+WgtD5zdYhSEgSZMwG4GBeju2MneH+ltsFCf3gmsoVEeqmYYAkpK9pV33VpgBA
         M2Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=GVNww0y/ubpMNmzwfijWtJHUzpAuRS+zSxR5eOOX/oU=;
        b=iJFo3Q/WAXaRjtIILxNiFYTBr97JbKsp5VdwZT6cpX0Go2In/O4M2fgFsKc4G1l+14
         W8NppKEknAW4ljhNv6Cj/UBO4fIoA48ItmhWYOb6xOmNulce4/bUZ1Sy5CdjyO/dKp35
         M6Jxxx/2JKgCa182SeGyuYWc/DthcR0oC3DgL0rGwk4g97iztjUyx7Q3vEZAGzrxNYTj
         7FrTl/yZEXDXuW317oU1fDOYhTV5qfljQfXA02qs1gXvcYLBnPNkUe0nFX8LhX9bqzjw
         BY0UoxSkV70ULscJy3a+oS+igQm0UUy1R1ibp27S743EulVTZ2DMOZ+wBf79jc2WX0SP
         TTgg==
X-Gm-Message-State: AOAM533Ilckm5utWf+Cm2mGsEBP4LmS2WH1twkmCtwxK7DHvq/a2AAW5
        Ti8hutrHulFkxUA6yh0Qsp4=
X-Google-Smtp-Source: ABdhPJzWgz+HJL1DGJAJDDbMGl3BMQGpeYWAzzwNgkh986nwI46FOrusSwKc1vVG7VfMhefKencLxQ==
X-Received: by 2002:a17:902:e803:b0:150:1cb0:e0a4 with SMTP id u3-20020a170902e80300b001501cb0e0a4mr23287343plg.65.1646135306003;
        Tue, 01 Mar 2022 03:48:26 -0800 (PST)
Received: from ubuntu.huawei.com ([119.3.119.18])
        by smtp.googlemail.com with ESMTPSA id t27-20020aa7939b000000b004ce11b956absm15854635pfe.186.2022.03.01.03.48.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Mar 2022 03:48:25 -0800 (PST)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     xiam0nd.tong@gmail.com
Cc:     arnd@arndb.de, gregkh@linuxfoundation.org, jakobkoschel@gmail.com,
        jannh@google.com, keescook@chromium.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, netdev@vger.kernel.org,
        torvalds@linux-foundation.org
Subject: Re: [PATCH 3/6] kernel: remove iterator use outside the loop
Date:   Tue,  1 Mar 2022 19:48:16 +0800
Message-Id: <20220301114816.5729-1-xiam0nd.tong@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220301113436.5513-1-xiam0nd.tong@gmail.com>
References: <20220301113436.5513-1-xiam0nd.tong@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

typo:
 which are introduced in PATCH v2,
correct:
 which are introduced in PATCH 2/6,

Best regards,
--
Xiaomeng Tong
