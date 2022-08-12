Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D57345909C5
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 03:05:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235962AbiHLBE6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 21:04:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231131AbiHLBE5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 21:04:57 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C07074DF3
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 18:04:56 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id r69so12013511pgr.2
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 18:04:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc;
        bh=13c4cDf7Rg8kM7TM5Ec2p51x9MFvfEzElyjMeLmbLRk=;
        b=OfwjUrmFSb3TQ8oa7tx3tqDRMunGTMJ7T2WvIlESznBI31h0Xpct9T0K5V8CMDEwiz
         RyIro+6vNMkbnkcntM1rdAy15qJPwNy764JCHEZU1nuNpxPHqIcofPyRJit8EuaplwJG
         4zbhmNixmceL0aCXtVNkWypzR/LXmYT2Rfg4gds93cDrAhr4T8EwUeDGXGWwPwM8PDDi
         8eLo1EMMpmXg4nWvt1zu14558V14rH8mnduQr41sGrJhU6TwKj0kKGKgEyHs5NJsy8ke
         ce0gJ80CmP1KVC6GOArEdncAcyHSqua6hEqFz7LxHHf6ol1QUDupz7lILn/2i8cBNiCp
         uDKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=13c4cDf7Rg8kM7TM5Ec2p51x9MFvfEzElyjMeLmbLRk=;
        b=lVm+GW68zBMWgtZqFlSKZeh/3iX/JVDpLbkCQAky8PBjWRBA5rhk5TPMLXJZmZ9iKc
         t/C5usJIk/+QJY+EN4PB50Ei3XKD/Y5J9uiRxNDxZk58OpD1daGCZpmJwzOKcgWtwRRB
         +ZVcALEyNR+jRwek7z7Vmknf43W2UkezccZHG9yQE0RWx0NteJ1Erg2d5LaaoxIAKzqf
         LZy+3IbrtPU0tBJ5gUOLORNcBmEX/9XCfL0b3enStUBxM0PsoXF9DZtsZG+sgfFUNrOf
         Yc5eBCihfoMNyV9aFz0FUI1JDTIGBNLfAIj+aeyiaziuVM04IHEshnIXEtA6pTbX92U8
         Jb0g==
X-Gm-Message-State: ACgBeo30a6dInbYYste4PCMGVdM4rV6ek8LhVA+kuBbeonpe3IuESRL1
        wpiMIHtzEg8bEFfNAw77TvgLkg==
X-Google-Smtp-Source: AA6agR48u7sDkJFmTcHZV4pgR6oYPyOtV6HhezsRNckdXU+kC7cHvJAcUuUbKPmyNgEnqXm6X2M64Q==
X-Received: by 2002:a65:6cc8:0:b0:3fe:2b89:cc00 with SMTP id g8-20020a656cc8000000b003fe2b89cc00mr1268011pgw.599.1660266295837;
        Thu, 11 Aug 2022 18:04:55 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id c14-20020a170903234e00b0016d1b70872asm300397plh.134.2022.08.11.18.04.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Aug 2022 18:04:55 -0700 (PDT)
Date:   Thu, 11 Aug 2022 18:04:52 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, sdf@google.com, jacob.e.keller@intel.com,
        vadfed@fb.com, johannes@sipsolutions.net, jiri@resnulli.us,
        dsahern@kernel.org, fw@strlen.de, linux-doc@vger.kernel.org
Subject: Re: [RFC net-next 3/4] ynl: add a sample python library
Message-ID: <20220811180452.13f06623@hermes.local>
In-Reply-To: <20220811022304.583300-4-kuba@kernel.org>
References: <20220811022304.583300-1-kuba@kernel.org>
        <20220811022304.583300-4-kuba@kernel.org>
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

On Wed, 10 Aug 2022 19:23:03 -0700
Jakub Kicinski <kuba@kernel.org> wrote:

> A very short and very incomplete generic python library.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

It would be great if python had standard module for netlink.
Then your code could just (re)use that.
Something like mnl but for python.

