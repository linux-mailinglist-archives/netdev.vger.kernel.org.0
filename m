Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 787184C8B7E
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 13:24:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234716AbiCAMYx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 07:24:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234707AbiCAMYw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 07:24:52 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72FE9887BA;
        Tue,  1 Mar 2022 04:24:11 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id v4so13926826pjh.2;
        Tue, 01 Mar 2022 04:24:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ssKwAQc6zCsSKhvQTz6MaBCU3uUmKpNHZ8vjrQi8cYo=;
        b=K8E59u5M2G2R64caq5UMg3jGxjZn5qjDQQ1q//+zF89zpGJj7eoWg8cWoYqXMlB7mk
         S0lBVKstWRNhwgSdxBSOtw6dezKo85nugkvHh8dBADRG5Y9RpMPYQtn4rIgGGnny9Fjp
         qEChkBE8H3I783hmApK8eiZ6PS5fSbfdgX3imGdZm8lCTbsVjsugLOIwga76li9/v/47
         RTpquztcpH7EN5hs7D2kZKxrrhHgoYbQt7ibqD2pGCFnu4vNOqPcUGJdcZOiPGNfLtTV
         cHILjeW7p91mwSYNGCCgOUdutnZN0YH5c/1feL9CfVa96jLBYS4grYmDz3k6jrRluMxc
         Ph4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ssKwAQc6zCsSKhvQTz6MaBCU3uUmKpNHZ8vjrQi8cYo=;
        b=HtvEj3Ug5PUBd9sXZvnjl/2Uh4o7f11Lp2pTCc3xIFuOnj3jnPyfGW6wqcyXEsht2p
         iqS1amiW1SUHmBiXPDIKtdiD9pJlmX1Y5NixHd9GaNEV0quo4x+ODoPlNdHW84qUm7XR
         3hVmKQvFTxeLg2T4ck8catR18xcN9lmVhC4J0BkqXz1SnkCS45w3GZAh9Mg/5ex7+XmG
         25T9Fvqbj9NmBbtov0nJxGW2DFaNXwSpW5LPezjvx6WT74DpNOtDi8prm1Mmy0uXcar4
         jYzHgFPHf6x30rW/OMVNUNzd4Ll34HmwIwqMlE6/SvDkc+ZWnfdaOdmMwVQnCEeS0Rzu
         DoSw==
X-Gm-Message-State: AOAM530ZXDSycxwYC4GyU3BXFJif0dl/PVk/wVvTRRfEEllZ+xJmlKdD
        m05qaA7z72eJedPKyZi0KyYrq28ZXis8fg==
X-Google-Smtp-Source: ABdhPJzArZjzwX0DpT1f/kLNVz6q3wv7rT4JkcOCR9DKDjHmTzaRLOrLzfnnoBG5cMOORru0C+kisg==
X-Received: by 2002:a17:903:3092:b0:14f:9c1c:45a4 with SMTP id u18-20020a170903309200b0014f9c1c45a4mr24899887plc.126.1646137440272;
        Tue, 01 Mar 2022 04:24:00 -0800 (PST)
Received: from ubuntu.huawei.com ([119.3.119.18])
        by smtp.googlemail.com with ESMTPSA id nl12-20020a17090b384c00b001bc1bb5449bsm2312376pjb.2.2022.03.01.04.23.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Mar 2022 04:23:59 -0800 (PST)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     xiam0nd.tong@gmail.com
Cc:     arnd@arndb.de, gregkh@linuxfoundation.org, jakobkoschel@gmail.com,
        jannh@google.com, keescook@chromium.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, netdev@vger.kernel.org,
        torvalds@linux-foundation.org
Subject: Re: [PATCH 5/6] net/core: remove iterator use outside the loop
Date:   Tue,  1 Mar 2022 20:23:53 +0800
Message-Id: <20220301122353.6189-1-xiam0nd.tong@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220301075839.4156-6-xiam0nd.tong@gmail.com>
References: <20220301075839.4156-6-xiam0nd.tong@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I'm sorry for have created the confusion. I made this patch to remove
the use of iterator (in this patch is "skp", "p") outside
the list_for_each_entry* loop, using the new *_inside macros instead
which are introduced in PATCH 2/6, and to prove the effectiveness of
the new macros.

Best regards,
--
Xiaomeng Tong
