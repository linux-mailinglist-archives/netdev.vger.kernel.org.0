Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA09B507157
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 17:06:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238812AbiDSPHP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 11:07:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353581AbiDSPHJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 11:07:09 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DAA23A5FE
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 08:04:19 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id j8so15988645pll.11
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 08:04:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=T0CruxffC9NjNMs1c0Z9nyFCrGLCVaEGx6JeIC2nIRY=;
        b=Gmhx32ovr9Slw5gHW+wid8VIbIZ9rOeHsxymWM1V4GVOOBhy9W7Jkv2owUrk6EDW4+
         7JjQymrCSJeLzL/PY4fT+OLpaf0BmuB8wyLFoYcWc8hfZdkGbxgd9uPaFf7i7VmIyvm7
         PW0ejoejHh1NADg1qfdKg3J/5Oj5b2uWMD4dkJldojyaFvI/75EvNVMWqy2Azdyrnszo
         IdP9NeXuusE1uA9ex/+vkmuYl7x/sJVTeWXkAXS69xVGP+M2zECG/NXK6zvV1b2CzL2K
         a3nqRlvLF4Rze4eA9UYmTDgBTnhdLNfmPUEkbkRHUFwGxNV4gawrK1F+YH46LILaHJr0
         Mk5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=T0CruxffC9NjNMs1c0Z9nyFCrGLCVaEGx6JeIC2nIRY=;
        b=C9V+hLfxgY+h+CTa/KAffIo3ukjI9tncWvarf56H/E5wcwB2n9pcA8K1Jq8XLbJqVk
         BEHui2R6K+k1uH4AWyvHvmEo52lqWkO1qcAhln3An9dtM6TgxSS+mvxEjRbLm9w2lqft
         FX6+xRvE20gKD9OW+EiGl1ZvVFAsy9ZOR7Y2UCKLsvmSBB3w4/bPFyn9etSHeqXgSM7V
         IDXZxPzfoGkh1AdWfhKKIwXXawuKg+u+sh25guEJ/O0OTJ/T1zG8VDMt59vJ+GjjB0Fy
         ccNseDOygd+8sFlvHeL4YGwSc+FafL6E2pJ1gycDjGvAeymSNHIlKcYqW6+eduYvrJjk
         5CDg==
X-Gm-Message-State: AOAM532QyMaJcxBcyOEeoppbXokKJwfvSEpdBHGyy/rf1Mf3ICY3Hcz2
        Jdcsvm4RqXeEq/uW7QBhsO+gNg==
X-Google-Smtp-Source: ABdhPJwyWZQpLaVvAwCljl+DujY7gxzYa94x1sc1skwEYaadT21CX8AS5p3/shK3wo+RRpTsA0Xs0A==
X-Received: by 2002:a17:902:744a:b0:158:9b85:192e with SMTP id e10-20020a170902744a00b001589b85192emr16176902plt.96.1650380658584;
        Tue, 19 Apr 2022 08:04:18 -0700 (PDT)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id g17-20020a625211000000b005056a6313a7sm16513051pfb.87.2022.04.19.08.04.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 08:04:18 -0700 (PDT)
Date:   Tue, 19 Apr 2022 08:04:15 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Florent Fourcot <florent.fourcot@wifirst.fr>
Cc:     netdev@vger.kernel.org, cong.wang@bytedance.com,
        edumazet@google.com, Brian Baboch <brian.baboch@wifirst.fr>
Subject: Re: [PATCH v5 net-next 1/4] rtnetlink: return ENODEV when ifname
 does not exist and group is given
Message-ID: <20220419080415.718913e0@hermes.local>
In-Reply-To: <d63921e9-2306-a153-48fe-a1f65157aafa@wifirst.fr>
References: <20220415165330.10497-1-florent.fourcot@wifirst.fr>
        <20220415165330.10497-2-florent.fourcot@wifirst.fr>
        <20220415122432.5db0de59@hermes.local>
        <d63921e9-2306-a153-48fe-a1f65157aafa@wifirst.fr>
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

On Tue, 19 Apr 2022 09:29:37 +0200
Florent Fourcot <florent.fourcot@wifirst.fr> wrote:

> Hello,
> 
> 
> >> +		if (link_specified)
> >> +			return -ENODEV;  
> > 
> > Please add extack error message as well?
> > Simple errno's are harder to debug.  
> 
> 
> What kind of message have you in mind for that one? Something like 
> "Interface not found" does not have extra information for ENODEV code.
> 
> At this place, one gave interface index or interface name, and nothing 
> matched.

Not sure how code gets here. Maybe "interface name required"
