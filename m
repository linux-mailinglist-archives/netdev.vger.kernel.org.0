Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E79B53E940
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 19:08:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241104AbiFFPp3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 11:45:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241083AbiFFPpU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 11:45:20 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3308E1F5353
        for <netdev@vger.kernel.org>; Mon,  6 Jun 2022 08:45:19 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id j7so13118382pjn.4
        for <netdev@vger.kernel.org>; Mon, 06 Jun 2022 08:45:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aAaGz42Ssf6oh1VgdSL7hzx+O4lxtWIHreUUYK1nFB8=;
        b=p//9qtv6Q3J7CWlWuv4+yoCyjWujQzETk6W2VU6dLEI8t3RnPYXWAjxa7O12Ae8GND
         l6P2iTtjaHwyvr/VmaTSt1Bj/6aaP9FQgzwewCRWEFM3fceUbVcOfG1s9r+HgKCCnxDf
         vl61D33/ldk8emGaqOoGle0O835A+wKLwu5oKcoCR16iyT6QRM4rAydBeZOq8EkdAOIu
         sXmHPu71/B7hh80KT2HLLdK/d/IsD2pKE+9NOZzk31akKyzehlY8Wd1F58XBhRr4D9D0
         Qx8OBQz4byFBpd+uUP2XWQ5TnqWkpI63B3hIWqQV4asDQHoV8R7pYCq+ICb69vc5VCvL
         nDCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aAaGz42Ssf6oh1VgdSL7hzx+O4lxtWIHreUUYK1nFB8=;
        b=cIlf1C7sT5U6shF1Grwld/Jt99JmDO7r1JuDVDzA6ZoqXCNJA6qhwlKVe931QmwO3R
         f5PSgdLxBtAqbTCeIUtI/jf13coMrwXQPy+PORnpAP8LtS1+vXGzSHOWNkAYqYJf6tdL
         sP0PzTtscebSmy60dwkfeShfTdbQZWEDSPy/nCsJ4moL+3hedyvo44lVhKLGsfOudox4
         GKfiFToF9iEzvkDVKN4Ycl1F3BkgkDGkig4mPnJlz8suIXM77boqAg1s1ofXoc4M0zqp
         yWPlTczt/CtuWrMFq8IsFyE2OxLOwO/ZbsxhENvGNSRSkwezLNYbIh2YqM9EkJpYgD+o
         /sng==
X-Gm-Message-State: AOAM530LCbK5L7yWEdi47B/SenpFCsT3UZr+vKeoYpBtKuSdOAGmdBe+
        IhNWt/5PqG3HlqdamnCkpfT8hQ==
X-Google-Smtp-Source: ABdhPJwYSax4yy03NbseMEpK+rfivSlFU9soPhQJ2u+L/b4lVSmI4Nu+hlsJXMbnmO4WZb6qGpVc2w==
X-Received: by 2002:a17:90a:6b41:b0:1e0:e082:14c7 with SMTP id x1-20020a17090a6b4100b001e0e08214c7mr61618515pjl.92.1654530318715;
        Mon, 06 Jun 2022 08:45:18 -0700 (PDT)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id g196-20020a6252cd000000b0051b9e224623sm11471634pfb.141.2022.06.06.08.45.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jun 2022 08:45:18 -0700 (PDT)
Date:   Mon, 6 Jun 2022 08:45:15 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, dsahern@gmail.com,
        netdev@vger.kernel.org, tariqt@nvidia.com
Subject: Re: [PATCH iproute2-next v2] ss: Shorter display format for TLS
 zerocopy sendfile
Message-ID: <20220606084515.4705b22d@hermes.local>
In-Reply-To: <2a1d3514-5c6a-62b6-05b7-b344e0ba3e47@nvidia.com>
References: <20220601122343.2451706-1-maximmi@nvidia.com>
        <20220601234249.244701-1-kuba@kernel.org>
        <bf8c357e-6a1d-4c42-e6f8-f259879b67c6@nvidia.com>
        <20220602094428.4464c58a@kernel.org>
        <779eeee9-efae-56c2-5dd6-dea1a027f65d@nvidia.com>
        <20220603085140.26f29d80@kernel.org>
        <2a1d3514-5c6a-62b6-05b7-b344e0ba3e47@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 6 Jun 2022 14:29:02 +0300
Maxim Mikityanskiy <maximmi@nvidia.com> wrote:

> That makes some sense to me. What about calling the ss flag 
> "zc_sendfile_ro" or "zc_ro_sendfile"? It will still be clear it's 
> zerocopy, but with some nuance.

-ENAMETOOLONG
