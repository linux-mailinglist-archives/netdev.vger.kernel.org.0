Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6544B6483F8
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 15:43:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbiLIOng (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 09:43:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbiLIOnd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 09:43:33 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A38F2BDC;
        Fri,  9 Dec 2022 06:43:32 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id qk9so12024040ejc.3;
        Fri, 09 Dec 2022 06:43:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=D20OyJ3zuiEaGi/DMMYTp6sCrUU0uqeDQNQLFJkeVKU=;
        b=HCRkqlSZRXzk54NVCCGe6FdzNNRYyVGCc28998rDNjy2sGgE0YILFzZ9qmWcw5izMV
         vlNcmhgnkjSDP5DR3k+ffeW5hEaKbpFL3qe24ui0f0K0n4bF9qxbzgSu/BOvsKe4de6Q
         sQ+yUVgIRPMRM+csuEAagpFAU6lcw/rFpKZsRuZYk2qCCOBQkVAklOdp+Z2Ni8Vjoj0S
         mOIRvW6F7MLUvc8E42BP7u+F70gDGsPkoe7ph2Hcd9yMTWMdHWKHRMEIJnL7Pyz61CCQ
         IGr8+8r8n7C+1c5Tc3PcmlHJG07hlAhbK6KQ+WrQECbIk63rv7agsOaf0903eSnubq0C
         Ftgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D20OyJ3zuiEaGi/DMMYTp6sCrUU0uqeDQNQLFJkeVKU=;
        b=0PzpngWNzlNDt2ZnWN5IKLrvXxVVZHFAYtHoS/Fr9OmjR1/ZRpiQATrOR70E/qM9/3
         /dDr6um4Y29yIQtos7+Kexd0CXK9ODA7Ikf8CstcdeBWTysf28SoZ18jl6HjJiU1V0xh
         lcB06UhMg2c4P5nJp22H+S6R7yrahY0KNNYTdBvaQZYBtY/8/XcsSFZWjVsH2sH1w473
         vH5dY7fhPNSOkrQqJXdmkTaWxFrH1nJLPUpaLRNhzkIXwgCRX2TGAREiLiRyoIOMHLfI
         mQMT292m7zceewB8LwKOrDwsNISZe6CSvXnzQL5a/wes+59FZYaz7lLbqw37RR/zRDPB
         5i2Q==
X-Gm-Message-State: ANoB5pmaPfItyGs9A9HzHjdddFy+Mm5nJJbjdJgT8Aa5KjMfs+gn1vD7
        vV6O6uuiaz1zuPr2NZUNd1A=
X-Google-Smtp-Source: AA0mqf6yyZN/fiCfewm+0GGs1z1Rqmxrju3RsTmqzGBFlLQECo8gvzp0NcyHdw/MXV9QBb+oVGaqeQ==
X-Received: by 2002:a17:906:2802:b0:7c0:b3a3:9b70 with SMTP id r2-20020a170906280200b007c0b3a39b70mr5368012ejc.62.1670597010983;
        Fri, 09 Dec 2022 06:43:30 -0800 (PST)
Received: from skbuf ([188.27.185.190])
        by smtp.gmail.com with ESMTPSA id b18-20020a17090630d200b007ae1e528390sm623066ejb.163.2022.12.09.06.43.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Dec 2022 06:43:30 -0800 (PST)
Date:   Fri, 9 Dec 2022 16:43:28 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     Michael Walle <michael@walle.cc>, Steen.Hegelund@microchip.com,
        UNGLinuxDriver@microchip.com, daniel.machon@microchip.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        lars.povlsen@microchip.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, richardcochran@gmail.com
Subject: Re: [PATCH net-next v3 4/4] net: lan966x: Add ptp trap rules
Message-ID: <20221209144328.m54ksmoeitmcjo5f@skbuf>
References: <20221208092511.4122746-1-michael@walle.cc>
 <c8b2ef73330c7bc5d823997dd1c8bf09@walle.cc>
 <20221208130444.xshazhpg4e2utvjs@soft-dev3-1>
 <adb8e2312b169d13e756ff23c45872c3@walle.cc>
 <20221209092904.asgka7zttvdtijub@soft-dev3-1>
 <c8b755672e20c223a83bc3cd4332f8cd@walle.cc>
 <20221209125857.yhsqt4nj5kmavhmc@soft-dev3-1>
 <20221209125611.m5cp3depjigs7452@skbuf>
 <a821d62e2ed2c6ec7b305f7d34abf0ba@walle.cc>
 <20221209142058.ww7aijhsr76y3h2t@soft-dev3-1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221209142058.ww7aijhsr76y3h2t@soft-dev3-1>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 09, 2022 at 03:20:58PM +0100, Horatiu Vultur wrote:
> On ocelot, the vcap is enabled at port initialization, while on other
> platforms(lan966x and sparx5) you have the option to enable or disable.

Even if that wasn't the case, I'd still consider enabling/disabling VCAP
lookups privately in the ocelot driver when there are non-tc users of
traps, instead of requiring users to do anything with tc. It's simply
too unfriendly for somebody who just wants PTP. You can use devlink
traps to show which non-tc traps are active.
