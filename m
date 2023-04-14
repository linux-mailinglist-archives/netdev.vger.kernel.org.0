Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D1016E1E47
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 10:30:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230167AbjDNIaD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 04:30:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230303AbjDNI3q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 04:29:46 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C180AD08
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 01:29:20 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id bx15so16179358ljb.7
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 01:29:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681460957; x=1684052957;
        h=content-transfer-encoding:subject:to:from:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=87RAp3zmP5aCYK8yNzhHFKW2AQI55vD4dRLl1+wIj5o=;
        b=mSu0u7Qn9s67i7MxguTHqKLF8TUctHr8qbLnUnRiBL5ZYdgqpa2UNiOz263orsl8oX
         a4GIF9uGzmxXuEr9kpTCUuITgEb3xqkDrxe/luT1o4G7nvAeqQdn6ACj4jmpbFlLKTOA
         gYoA5XRUdP5ymxXzIvbZyl+l3jW3AVB5a4KDsCmlOaesJi9hsSXcC53K4qdwP1/quyXn
         +2pY6ypxx0wwsE2KFlNGt3MqPYz8mVAOUVmRwcqTOzWoeaH8mCg3InL8GdkmQhCKiWRh
         OgS+OakDBJzp6JhbsgVyuBKfRk0XU5BaXPhruQ/Hu8tLj7yEMUKo2cSCu26rh9ryq/Mb
         0VdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681460957; x=1684052957;
        h=content-transfer-encoding:subject:to:from:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=87RAp3zmP5aCYK8yNzhHFKW2AQI55vD4dRLl1+wIj5o=;
        b=OTUmtrqkk1EWJTPjbpw3vUphHL+P8dj7I662kGfjZ8jOz6zG0LFGPvVXhHAmbBJ5Vj
         feddO0FvMuN79qtsFZ+xZ/nX+lUdDGrvgB1bmN41+biQatKQ8AJzzSM4O4qZkBc60mGy
         PYoMTgw0itOWqYmMI9fQx63KMuU/cPYmR3WppdzrThBW+lH2Pl0yI+19fO5tSgBH6dlw
         qyu9h8tngMuEej5c97+EKvXgdfoDrDarlmhnJUMkbKIlU6BkKDblAbvDC1fChru9O9+R
         A16bbPiwx15Lgv4bFY+6lglDKtaif7DEBcOoaay4i0pzXmypijkfLe7kRCvvPY4O/knH
         +bvg==
X-Gm-Message-State: AAQBX9epFlEWQrJXgF+VofDEKcIYWluYqpDE/fyJVsSsV2gJI9VVRtk2
        vnzo8ChfwNnO0HFjRbG1DO8xHORFL9eGqA==
X-Google-Smtp-Source: AKy350bluhwh6wJrnjpVZNGh2JZpWn1sSSokecltauMZSjuuTKOEbDhYMhlk+ymIEI3qMR9U2iLceA==
X-Received: by 2002:a2e:a9a9:0:b0:2a7:b0b2:29 with SMTP id x41-20020a2ea9a9000000b002a7b0b20029mr1742854ljq.22.1681460956929;
        Fri, 14 Apr 2023 01:29:16 -0700 (PDT)
Received: from [192.168.10.208] (c-9b3c524e.03-153-73746f67.bbcust.telenor.se. [78.82.60.155])
        by smtp.gmail.com with ESMTPSA id l17-20020a2e9091000000b002a7758b13c9sm687251ljg.52.2023.04.14.01.29.16
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Apr 2023 01:29:16 -0700 (PDT)
Message-ID: <e3bfc8e6-5522-4e65-373e-976388533765@gmail.com>
Date:   Fri, 14 Apr 2023 10:29:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Content-Language: en-US
From:   Lars Ekman <uablrek@gmail.com>
To:     netdev@vger.kernel.org
Subject: iproute2 bug in json output for encap
Content-Type: text/plain; charset=UTF-8; format=flowed
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

The destination is lost in json printout and replaced by the encap 
destination. The destination can even be ipv6 for an ipv4 route.

Example:

vm-002 ~ # ip route add 10.0.0.0/24 proto 5 dev ip6tnl6 encap ip6 dst 
fd00::192.168.2.221
vm-002 ~ # ip route show proto 5
10.0.0.0/24  encap ip6 id 0 src :: dst fd00::c0a8:2dd hoplimit 0 tc 0 
dev ip6tnl6 scope link
vm-002 ~ # ip -j route show proto 5 | jq
[
   {
     "dst": "fd00::c0a8:2dd",
     "encap": "ip6",
     "id": 0,
     "src": "::",
     "hoplimit": 0,
     "tc": 0,
     "dev": "ip6tnl6",
     "scope": "link",
     "flags": []
   }
]

