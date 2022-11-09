Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB2AC6237A0
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 00:43:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230041AbiKIXno (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 18:43:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiKIXnn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 18:43:43 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1351F101E3;
        Wed,  9 Nov 2022 15:43:41 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id v124-20020a1cac82000000b003cf7a4ea2caso2294062wme.5;
        Wed, 09 Nov 2022 15:43:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OFt2iInFdLzf7GfwKHdD3j+aUdF9jsCsydxz9v2UQ1A=;
        b=kYEiR5/XOnWEJcuYQMT/lDt/q8F2QByKoxnBIy8kZjgohSvQyo0mUtanQgf3+szIvN
         MSOVRCegCpQf51QSynEnBwEnWtNVgeWke+9m74gQDRNLOwx8GSh9kF2VvTh07UtAyeb+
         tHytmoLhDRJpJzaYFDE72YRZKtE9IdNDwOlN6rG6bu0dkd9DBpkTm2vFQVWZDZrPxtDH
         tGyyJeySMdSgqKFslJQXsRmVIbR26tBqoBEdsYUEsjx+vwoa6R2jLXMWXhSREnez3NmD
         GPxrfdpRIgqKjbZ98FAYSpXRJcPhzA2UBZWktFLXLHj8Va++t3WQwNv6SbFdTK1Ms7J4
         9Ssg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OFt2iInFdLzf7GfwKHdD3j+aUdF9jsCsydxz9v2UQ1A=;
        b=m5WT4wupvfLaZKZxeqiKU5byj0D56GTNJUL/nF1jPyVHbnUR5hFlne80U5dmAFu9jC
         GCAF52d0gsfOevcfY6B9XziMO+SvjvpdMM/FAj47bATLdaUNp+JrRlBXBLP9FKDdNeAP
         /i2cMn+3hv8YczJhRm+RNrXsCczqitbJC3m13qHwjUe6jWwQzHnNUiegs8Z/4asunBMI
         5n/8khYSupXDgrhzRaUgroOvn7IFNhfSuHbhucPUJLspoybCCxz18FOkUmXPxiLhFaXS
         Ux1gx/T02nczY7qnF/7v6lu8Pcb8ApOiB6MzuXjmoQ8bcRZJ7ItpXldEdiQ23eLni57/
         031w==
X-Gm-Message-State: ACrzQf1qNTFhpMIcY1rNZZivO7qqoBv+o5K4lJ4sHfm+JWngOHPGhP5a
        Nf9IfEgzPvhehP/fpD27Djs=
X-Google-Smtp-Source: AMsMyM5mQGFSLzsRyD3kfuv9grfSRmnWBY0njMWzcYer+2VdrbkUGshrhvuuBCy7VXGZRtVzf0QNAA==
X-Received: by 2002:a7b:c3c4:0:b0:3c4:785a:36d7 with SMTP id t4-20020a7bc3c4000000b003c4785a36d7mr52661181wmj.138.1668037419391;
        Wed, 09 Nov 2022 15:43:39 -0800 (PST)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id b9-20020a05600003c900b0022e6178bd84sm14494051wrg.8.2022.11.09.15.43.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Nov 2022 15:43:39 -0800 (PST)
Date:   Thu, 10 Nov 2022 01:43:36 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Rob Herring <robh@kernel.org>
Cc:     Colin Foster <colin.foster@in-advantage.com>,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        =?utf-8?B?bsOnIMOcTkFM?= <arinc.unal@arinc9.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Subject: Re: [PATCH v2 net-next 5/6] dt-bindings: net: add generic
 ethernet-switch-port binding
Message-ID: <20221109234336.s4womtunv3i62agk@skbuf>
References: <20221104045204.746124-1-colin.foster@in-advantage.com>
 <20221104045204.746124-6-colin.foster@in-advantage.com>
 <20221104185028.GB2133300-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221104185028.GB2133300-robh@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 04, 2022 at 01:50:28PM -0500, Rob Herring wrote:
> Or we can just allow anything from ethernet-controller.yaml and drop 
> this list.

Sounds fine to me. Makes ethernet-switch-port just an ethernet-controller
where "reg" has a particular meaning (port number). Which is basically true.
