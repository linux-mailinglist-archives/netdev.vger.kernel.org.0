Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 729686BBFFC
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 23:46:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232208AbjCOWqR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 18:46:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbjCOWqR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 18:46:17 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DC641632E
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 15:46:15 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id e15-20020a17090ac20f00b0023d1b009f52so3495907pjt.2
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 15:46:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112; t=1678920375;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VRoAVQGIsRJMXMu3pr397XkvJaPmgbFkqljbaqaNGRE=;
        b=6m2ZEoPOctc31pgD/nlr6a58e+Vz3JTK4XWBd+a8gEGaBuh6JQp8owrwsP6arcYEXf
         ahryLetU0AUIX7EP/clK4TGB7/p96t5uiCBV/5BG4M8ZYGU2XtbPcifUw1Bo3d2JpF1d
         RT1q7RE4eDcQSg1CpD+IEdyEhyQYNc8FgbBXZkIbucu5vRNIFCDXfmsWcYO5Akb0XIXM
         RT5R1xNt2PiBcN7R+HY6AkhtVu244IdzEZjBTLv60KaT6mV84ifjJ7DPRcSBKEjJLKe7
         nDOUF8tf2cS9R+SI6YO4Og4IxPGQoCGhjkcAcepZfKX5d3JuBgE1MMJaxauEBJ2h1r0s
         TvSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678920375;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VRoAVQGIsRJMXMu3pr397XkvJaPmgbFkqljbaqaNGRE=;
        b=stZisdmgPrMCM3aMMe2Zqk5E8eBOnsdd0uyvhyZbywzwZKpyfH2HBKXlUJh4iv5GBE
         WsbSs0fEgcnywO70yMQdLHzfTXZOG9wWXrXFZ3ihwGv7pWKhMbC5xCiH3Zw0SAvU5GKz
         JwFGfj6BwfCspp5wQRrs4S9ZP4QHhBEbFyrYS80nyjSXGfshBogv2qKf4X4mvfVGn7Cv
         rn1ojafAz8HkNZxfOUI8j1qOsmUWBwgVqAEFBoExNeoBIvABFeJKbZjsoAXD6qACdU3F
         wB5PBPkh/Un8mIj2gh2y4XIjsQOuWtsOcyXl6doqeyk/QzDRl+nHgXqIN21V8D72BRiN
         bosQ==
X-Gm-Message-State: AO0yUKVoqGETnkZzMhfVJbKvza7ltjNY7kptlYxoI4zbT+ykAblnmmCA
        OaBzpCuvBzVNIXvOyFS1qa/r9w==
X-Google-Smtp-Source: AK7set+dkt06uH52CAclRD8wryQi/67P1R0ok/bvHLriyLIX4uqaqacvsP4ynIQDJHX9P5tzFWuWaA==
X-Received: by 2002:a17:90b:1b4d:b0:23b:5688:d7f5 with SMTP id nv13-20020a17090b1b4d00b0023b5688d7f5mr1381506pjb.47.1678920374744;
        Wed, 15 Mar 2023 15:46:14 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id k3-20020a17090a910300b00233b196fe30sm1858996pjo.20.2023.03.15.15.46.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 15:46:14 -0700 (PDT)
Date:   Wed, 15 Mar 2023 15:46:13 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, corbet@lwn.net,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH net-next] docs: networking: document NAPI
Message-ID: <20230315154613.63c1834f@hermes.local>
In-Reply-To: <20230315223044.471002-1-kuba@kernel.org>
References: <20230315223044.471002-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Mar 2023 15:30:44 -0700
Jakub Kicinski <kuba@kernel.org> wrote:

> Add basic documentation about NAPI. We can stop linking to the ancient
> doc on the LF wiki.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: jesse.brandeburg@intel.com
> CC: anthony.l.nguyen@intel.com
> CC: corbet@lwn.net
> CC: linux-doc@vger.kernel.org

And the ancient LF wiki can be updated to point to kernel.org

