Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 629F04EEBB2
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 12:41:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344956AbiDAKmp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 06:42:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344948AbiDAKmp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 06:42:45 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE20C103DA0;
        Fri,  1 Apr 2022 03:40:55 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id a1so3591582wrh.10;
        Fri, 01 Apr 2022 03:40:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=ZXjr35ZteUA9cEWV/UbslxEAKr8SJWVJnre3hF4Zsy8=;
        b=pS02gleyzkk52m7GJzgAvR71BKhIiY3DOZA9DyxvHiaxSKl3OiXMoIzU9u8Jnx+HoJ
         8BDlRnbTRE5pDnlCbRtoyTFQb8hd1l9m7hjoRr8E1dKYOHbDOUszeduAm9eVkgzl6g2j
         8Ew7XzfyywsmEQ0zgQTaUMh0pempKiXYa36wciogXdpQQ9as9ZUBA0gMLsausv8wB10G
         UC/RbBVHlZIahiSQ+t02ptZL9YSsd3RQfoQGFq4wuKzFD0zWZjgWKVEoIvJJT9CxNMYv
         fLucQGIJW65EphtowK67ARL6RDwswTJi+vgTzzWqhKwvkjIpknUh4lfWXfGpZcmjMnor
         PUFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=ZXjr35ZteUA9cEWV/UbslxEAKr8SJWVJnre3hF4Zsy8=;
        b=xvw5RVyEvTekoSYli9wkTpVRQFC3S/jUT+58zd/+Cz76Tqn+B6uwweBROlTXDmokvF
         f16ak0VUWGSe6JbiFk6XPdZheKFlh2JQ9KVgraWCcV5nKDFjL8Lbl+SzO3HDDtEZqD3f
         6IHc+5yNCXKBi4OBIaeWDwWD//ejvJDLrDfw/TmsfvmPFm+eREFZejQVmfXHqMHApIIq
         YnxI78JmD3WZKs8FuG/ZCVVwmtJ533lr6h8bot7j1U4wumGOih5FMvp0lBHTx7c9WyZl
         fKQDqgVj7H0X8qiYcIAlnxYJa1Fe8lVSo9cMO+buVoZVKdaQ/lod/5cE4Q0dr9Ub/Y9P
         D9iA==
X-Gm-Message-State: AOAM533TABDaEVr168b6hnG7p2g/wmHNdJmdyVpRaPdDPsb1qcyl8ySp
        PX+y144lNFjXtnv+uEywZagJ6S2diGOqtZYm
X-Google-Smtp-Source: ABdhPJwLvfh11SzHH2AVZnsm5e1A1We8PDM/qM/tKhCFQgTKooaSX3XUb//GflIVqmuUDHd7Br7C5A==
X-Received: by 2002:a05:6000:186c:b0:205:3479:ad85 with SMTP id d12-20020a056000186c00b002053479ad85mr7434568wri.54.1648809654253;
        Fri, 01 Apr 2022 03:40:54 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id j17-20020a05600c1c1100b0038e389ab62esm10053958wms.9.2022.04.01.03.40.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Apr 2022 03:40:53 -0700 (PDT)
To:     pablo@netfilter.org
Cc:     Network Development <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org
From:   Edward Cree <ecree.xilinx@gmail.com>
Subject: Conntrack offload and ingress_ifindex
Message-ID: <e4ba278d-3308-ada8-d4ab-4d3a6c489216@gmail.com>
Date:   Fri, 1 Apr 2022 11:40:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pablo,

When developing a conntrack offload driver, I was quite surprised to find
 that CT entries passed to the driver's flow-block callback (as registered
 with nf_flow_table_offload_add_cb()) include a match on ingress_ifindex,
 with mask 0xffffffff and key 0.  This is especially confusing as AIUI 0 is
 not a valid ifindex.
From reading the calling code, looking at git logs etc, I can't determine
 the intended semantics of this match; could you clarify what (if anything)
 drivers are expected to do with it?
(Looking at other drivers it appears that e.g. mlx5e simply ignores it, as
 its test for `key & mask` in mlx5_tc_ct_set_tuple_match() will be false.)

-ed
