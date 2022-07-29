Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C9C1584B03
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 07:17:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233965AbiG2FRv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 01:17:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230166AbiG2FRu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 01:17:50 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCDC6459A0
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 22:17:49 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id q14so2942542iod.3
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 22:17:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uRmiiy1FQnn0DuHrid/zESSywY3in2Re6mxD+/BDHdI=;
        b=NJGIfcX6gMFiBNbdKW8eAOfzz44G2DzcaTvLjDlOXmCENX9Zf3+JvD/6LzjzQHxAaF
         N67mbC9O668r+8tNTLOu6h1MWculcDV++AtwhEBvy25qHP901gkKBSIlj7msTQIeOe7d
         yujEiih9P3Gf8WAJyBoMuv1v0tk6DVqq+G0MmyFb1G5RBpn0WWjc5Uk5q7TkEgGWKs0J
         3H3WZZJHlySVJ6kLXO4Y9Uh+lEgGy42NTqmrVV/t74frqwpflpu48ou1aQMtkh8jTe0e
         Q7+BBg8ANUpo9H4VjyGMkcXcxmMFOT85LEfgN6OjlkNCq6T1/2bpf7KUyqMGRDCCcQFs
         PMBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uRmiiy1FQnn0DuHrid/zESSywY3in2Re6mxD+/BDHdI=;
        b=70L7XGpYhXgGQ0l9UuTO/SEkkBnPYIotxbD460J+IqeswknNLV1CVQ1igJ3y6MucQB
         gQro3d14lhkGNSPbv7Sx8X6agT3/0pg6S9hMONyDV+rXsCE9VYGyty2z6o1dUuQ58WD7
         TRIW2/IxMa5XnD88Rxd7rD4hWMJm0fXekFlOzegxTOaXVXwcGTCdM4AeYxTMJgSx4UOk
         VGR3+nxYUi12JCJPO1k6juCFj8S8zMF6TAXg7D1Qf3G9g9mFCoSli+zEN5nAlBV1buYu
         76OpYrEBKqTCmxQ8EiC/hS4fav9F/v+lGHvX8HPyohzQTaE+gv3L6VIixCezc1bJ5w/a
         CZgw==
X-Gm-Message-State: AJIora8LCv6LcNnRhGLq02mPWewGUMzgn1HUiQmTWK8FC0n2K6+P8jrT
        sgnD8+336dvJr+Z6qqtUf9Dy+WpofuoxYClK
X-Google-Smtp-Source: AGRyM1vyJNIz/DXdw9xq1wrGoIHQ81Hr5IxtGxJ84mxjo3ITe4vArG8nPDXlFPyvx2htd1VEQtjHUw==
X-Received: by 2002:a02:a68c:0:b0:33f:46d4:918e with SMTP id j12-20020a02a68c000000b0033f46d4918emr752290jam.58.1659071869268;
        Thu, 28 Jul 2022 22:17:49 -0700 (PDT)
Received: from localhost (cpec09435e3ea83-cmc09435e3ea81.cpe.net.cable.rogers.com. [99.235.148.253])
        by smtp.gmail.com with UTF8SMTPSA id z26-20020a05663822ba00b0033ec34174a4sm1254531jas.39.2022.07.28.22.17.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jul 2022 22:17:48 -0700 (PDT)
From:   Cezar Bulinaru <cbulinaru@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     willemb@google.com, netdev@vger.kernel.org, cbulinaru@gmail.com
Subject: 
Date:   Fri, 29 Jul 2022 01:17:37 -0400
Message-Id: <20220729051738.7742-1-cbulinaru@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220728185640.085c83b6@kernel.org>
References: <20220728185640.085c83b6@kernel.org>
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


Please see attached v2 of the patch, I've added a test file and applied the suggested fixes.
Sorry for the confusion, was not sure to which list to send it, hopefully I've got it right.

Thank You

