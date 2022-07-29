Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28ADE58568C
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 23:37:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239328AbiG2VhZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 17:37:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239107AbiG2VhY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 17:37:24 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBE75863D9;
        Fri, 29 Jul 2022 14:37:23 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id c3so5667949pfb.13;
        Fri, 29 Jul 2022 14:37:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=5C8ivZfL0PyHezAoRA/l+/nmUSepfmvxkYjOnnFI1nc=;
        b=WvZix0u2t0q5RKGbBGwymGOkBSofxhF4qPELEvJyKtBU2QatcqUgCRlc+KXJpYyEgj
         FP1Rb0h+poXbtqNPbI+xX5H9DgjQmmlW3G0Axacyk0TAVbTuqDE4BKpXzOA0CwAHEqwv
         QTcsu7c3gth+ZVGBrV4UH9dsNRKrGDz9qyA8guQZKS1ADHO+iOLJzirfPML5iAntBCfT
         29GcPxAKSdfKiSJuHxlUioF5bwjxzDxQSwHReZNaGSNCNauy+4ufBvM/cckg49RinIc0
         VA2vQQlh7iOPjEMbhHhtKrkI6s+wyRrfG4QSN/PcIPwmACGGnLL494D40DX65pVWs91b
         TMyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=5C8ivZfL0PyHezAoRA/l+/nmUSepfmvxkYjOnnFI1nc=;
        b=M5VEiL7gflEaIEB6oqQBip0GSp9kxqZ1L7CJiEnada+OF7OV8SyPKP1Zolh/uSsfB5
         7H/2pgH10yDoRXryu4ZKkSRN+O/rQ0eT/dhGLAAxBBwa8zQik6REsGj6C76pW9MrIOXn
         AVwpHE54Q2JuCsf0G173e8M6KJd47CUu4NYqpakyXK/DoGoQ2kFqAxOzUgpvZEaRUKeR
         A82ryQILswdosrePXzbJ8VIG+STu+oCQ7/5oG9srKhlE1ccEWDYrPcp0wkFeS5+LzJWi
         Vj2PLyhZL6AOjwNwpEz35ok4RFWYfbV6noo64EeSOCdIORHrfWEqFg+w7GubAzdFbcbd
         O1gQ==
X-Gm-Message-State: AJIora90IkN8huDGMQLCmPOrqg+A/PyaOwJo2ggDZpeqEcCf+usXvdT+
        t35ZVXo4OBpqCGxEDMv0mf8=
X-Google-Smtp-Source: AGRyM1vt3VqvFE7ITX/jlK4MZQc2NMasEZrKrVs3Ur1xOOAout5rOdQGXbIRAkgifUBvwuYhFvOigQ==
X-Received: by 2002:a65:6d10:0:b0:41a:1817:2c59 with SMTP id bf16-20020a656d10000000b0041a18172c59mr4392421pgb.320.1659130643227;
        Fri, 29 Jul 2022 14:37:23 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id o3-20020a625a03000000b0052b84ca900csm3336396pfb.62.2022.07.29.14.37.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Jul 2022 14:37:22 -0700 (PDT)
Message-ID: <3540b119-6db4-75f7-6eb9-faed835240bd@gmail.com>
Date:   Fri, 29 Jul 2022 14:37:17 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [net-next PATCH v5 07/14] net: dsa: qca8k: move port set
 status/eee/ethtool stats function to common code
Content-Language: en-US
To:     Christian Marangi <ansuelsmth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <20220727113523.19742-1-ansuelsmth@gmail.com>
 <20220727113523.19742-8-ansuelsmth@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220727113523.19742-8-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/27/22 04:35, Christian Marangi wrote:
> The same logic to disable/enable port, set eee and get ethtool stats is
> used by drivers based on qca8k family switch.
> Move it to common code to make it accessible also by other drivers.
> While at it also drop unnecessary qca8k_priv cast for void pointers.
> 
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
