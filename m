Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23DA85005CA
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 08:12:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238945AbiDNGO0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 02:14:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235796AbiDNGOY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 02:14:24 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D36DFE03A;
        Wed, 13 Apr 2022 23:12:00 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id q12so3901720pgj.13;
        Wed, 13 Apr 2022 23:12:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :references:content-language:in-reply-to:content-transfer-encoding;
        bh=uxc+Rbc4MVtaiGHWJNYpUhBcIKPKccnha2/GwgVCHSE=;
        b=GCnOkCFb4B2Avx5jAvlZxD59sPiZJxRxt/UE1g1ntuTxx0a27YNGvyRuiUPFTljWWG
         D7Booa5p8RFOr9zKuXWubJDk00xKF9PuQ4X0mjLc6+xBiXVftVHNyLIs+otrwCljuMkv
         53bM2txMkcls32CtsHt/4OSq7AMK72ddMFyP8lsuhfC7tT2LpoV30QscbcaP468vc8GV
         Ol9Hx+YhoOmRrIOwMpX4RtzTFo0hwMhOBOCSeee7PPQKEEWch5PLRHN0kfWCj8cQDy9i
         TXNebDIawGfbjA9snJjamxb/1AYni57BLqvbBUrTMZfEdIF+D6f81vpz1/OJjWVJGrHl
         DchA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:cc:references:content-language:in-reply-to
         :content-transfer-encoding;
        bh=uxc+Rbc4MVtaiGHWJNYpUhBcIKPKccnha2/GwgVCHSE=;
        b=BFKWgSmhxFvMrAUvX2rl0AbehYAWOXQ/xwaN7k4BHHNcBKlRH1kWJ2Dlp0fBVklIp/
         B+hS0RW2A/purEifexfPs4idfBTKvrrfOosMlcnrDfcJ0sT14jR+p5DcB5Sv2xUvYhCi
         OFXvACVYJY1B5iq2xTRi2YoJMUUCkMoQEQ2C3TqtRhMMIZnXa0nK8QywYxaKEv4wVup1
         ehNmGuIxr6j+P8byKXsMXwVToOQQ7vCLx/2GCWP3CTPfKmgKQ9Zitp3nQDDktQbFF4bd
         kgoU8yfPJmmg/oKpCuhcvU4nMdpufx66VfEfDKrqpIILuzo/4OTfIsntr1siPjY3edxw
         A9PA==
X-Gm-Message-State: AOAM530xyxBsLtX8uStLvXzg+lVtR/QSuJCixAgcRQMlPVfs9RoVDq7e
        A2QP7OuKYf/ZQ7V7sOXpS1Lxai7oD/o=
X-Google-Smtp-Source: ABdhPJy2iFtPsCIFlrCmJZhjSmLYz3yzJE+3xXvCiLEd6UviGRVevk386TdIxotvSMr9ezLpFha/Vg==
X-Received: by 2002:a05:6a00:1a49:b0:505:7ab3:e5c7 with SMTP id h9-20020a056a001a4900b005057ab3e5c7mr2396809pfv.62.1649916720273;
        Wed, 13 Apr 2022 23:12:00 -0700 (PDT)
Received: from [192.168.43.80] (subs32-116-206-28-5.three.co.id. [116.206.28.5])
        by smtp.gmail.com with ESMTPSA id a38-20020a056a001d2600b004fae885424dsm953485pfx.72.2022.04.13.23.11.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Apr 2022 23:11:59 -0700 (PDT)
Message-ID: <0bf37720-870a-9dde-d825-92e12633ce38@gmail.com>
Date:   Thu, 14 Apr 2022 13:11:52 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
From:   Bagas Sanjaya <bagasdotme@gmail.com>
Subject: Re: [PATCH net-next v4] net/ipv6: Introduce accept_unsolicited_na
 knob to implement router-side changes for RFC9131
To:     Arun Ajith S <aajith@arista.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, dsahern@kernel.org,
        yoshfuji@linux-ipv6.org, kuba@kernel.org, pabeni@redhat.com,
        corbet@lwn.net, prestwoj@gmail.com, gilligan@arista.com,
        noureddine@arista.com, gk@arista.com
References: <20220414025609.578-1-aajith@arista.com>
Content-Language: en-US
In-Reply-To: <20220414025609.578-1-aajith@arista.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/14/22 09:56, Arun Ajith S wrote:
> Add a new neighbour cache entry in STALE state for routers on receiving
> an unsolicited (gratuitous) neighbour advertisement with
> target link-layer-address option specified.
> This is similar to the arp_accept configuration for IPv4.
> A new sysctl endpoint is created to turn on this behaviour:
> /proc/sys/net/ipv6/conf/interface/accept_unsolicited_na.
> 

Hi,

Building the documentation (htmldocs) with this patch, I got:

/home/bagas/repo/linux-stable/Documentation/networking/ip-sysctl.rst:2475:
WARNING: Unexpected indentation.
/home/bagas/repo/linux-stable/Documentation/networking/ip-sysctl.rst:2477:
WARNING: Unexpected indentation.
/home/bagas/repo/linux-stable/Documentation/networking/ip-sysctl.rst:2481:
WARNING: Unexpected indentation.
/home/bagas/repo/linux-stable/Documentation/networking/ip-sysctl.rst:2482:
WARNING: Block quote ends without a blank line; unexpected unindent.

I have applied following fixup.

---- 8> ----
From 304846b43a9f962f53f3841afabfd597b3b80951 Mon Sep 17 00:00:00 2001
From: Bagas Sanjaya <bagasdotme@gmail.com>
Date: Thu, 14 Apr 2022 12:59:46 +0700
Subject: [PATCH] fixup for "net/ipv6: Introduce accept_unsolicited_na knob to
 implement router-side changes for RFC9131"

Fix the simple table syntax.

Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 Documentation/networking/ip-sysctl.rst | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index 9e17efe343a..433f2e4a5fe 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -2472,13 +2472,17 @@ accept_unsolicited_na - BOOLEAN
 	unsolicited neighbour advertisement with target link-layer address option
 	specified. This is as per router-side behavior documented in RFC9131.
 	This has lower precedence than drop_unsolicited_na.
+
+	 ====   ======  ======  ==============================================
 	 drop   accept  fwding                   behaviour
 	 ----   ------  ------  ----------------------------------------------
 	    1        X       X  Drop NA packet and don't pass up the stack
 	    0        0       X  Pass NA packet up the stack, don't update NC
 	    0        1       0  Pass NA packet up the stack, don't update NC
 	    0        1       1  Pass NA packet up the stack, and add a STALE
-	                          NC entry
+	                        NC entry
+	 ====   ======  ======  ==============================================
+
 	This will optimize the return path for the initial off-link communication
 	that is initiated by a directly connected host, by ensuring that
 	the first-hop router which turns on this setting doesn't have to

base-commit: 38e01f46e0e7f88b92ca0b3f52ac6b9909ed413b
-- 
An old man doll... just what I always wanted! - Clara

Thanks.

-- 
An old man doll... just what I always wanted! - Clara
