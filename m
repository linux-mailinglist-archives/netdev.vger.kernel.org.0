Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9B886A244B
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 23:33:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229737AbjBXWdc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 17:33:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbjBXWdb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 17:33:31 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E2491A94C
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 14:33:29 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id h14so961662plf.10
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 14:33:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x6iwz3lJGJ6kQxqZ5URx4Y4qPLQBqjOE4gRsb3DI4fI=;
        b=OUAVSZNiotq+lQ0O96tjhNmYmgsBanvD6uWIoyMRjVA3mLHe5yFz/IUV+zOixRE9OB
         zSEgi2jXmhD131adTcRt4UIBBpdV9ytFg+30zCFud7Stq9lR5dBPGjsvENNv9ITL//Wo
         TkKUUzKW/kExkmAYkw9viTX0/grPNRthNnNjbHzY6YPZtkjlN8u1/kkbU6hyIeKr5M12
         /Spcnu/obkSQIvzybRAYhwvxhGYWX8k1trlllGuyHuKIziVKnu+C7YxrYtRz/DXpvoxC
         5ISf6gecptbDSeG4zAS+wG4Z6l7JHXUmAAvWy96LutB9ah3//dG/6ELycLzPqXe/nxUl
         uGLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x6iwz3lJGJ6kQxqZ5URx4Y4qPLQBqjOE4gRsb3DI4fI=;
        b=ML3v7kbyTVOBnHDXyGFYndtg+hh7zSGuVm6j/vU0z0LYMaXJT07iDTrL35lKsINHpB
         aZkrlgImqCxVpa9o7S+V7Uz1pYUFM/bRVMF2BqxA6UdbNfqiT3f26ArFt0QQwPRQE2UO
         PRZrXYiS4AxwXPC4TUE9m5tKl8W212igHJjdsc9/iZz6yU2Uws93lTGgF9AwRqLJS5XQ
         Mbqewy03I+9NlHMEeRHv7yjmjZRDQJ0Kcf9jquMu7wKLP/aTY08JZDV2ynNo03k54Zvk
         STNuCTrI9LLQDpwVJrbbNYXSm+B6Wg4NaTEKz7yg7qJtiMe0efZ7K5WFGGhG2DIG1avA
         NQqA==
X-Gm-Message-State: AO0yUKXwIrdr2U+BMRksVGh7tj2qOnlLl+kGsZdHBiUU2U1YowXM60d4
        mRj6z+jZPVC48fC4GWJ/v7XsHg==
X-Google-Smtp-Source: AK7set93KF77giNxevnfHBD3PZ6NnTo1knt/6phVUD7HykiaGWnxQtFgngOI7dwRaM0Z1Y8TrueAUA==
X-Received: by 2002:a17:90a:1c8:b0:233:d870:f4c7 with SMTP id 8-20020a17090a01c800b00233d870f4c7mr20107827pjd.21.1677278008862;
        Fri, 24 Feb 2023 14:33:28 -0800 (PST)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id jd1-20020a170903260100b001991942dde7sm16249plb.125.2023.02.24.14.33.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Feb 2023 14:33:28 -0800 (PST)
Date:   Fri, 24 Feb 2023 14:33:27 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, dsahern@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH iproute2] genl: print caps for all families
Message-ID: <20230224143327.4221f8a5@hermes.local>
In-Reply-To: <20230224102935.591dbb43@kernel.org>
References: <20230224015234.1626025-1-kuba@kernel.org>
        <20230223192742.36fd977a@hermes.local>
        <20230224091146.39eae414@kernel.org>
        <CAM0EoM=Ugqtg_jg_kgWjA+eojcV7k+nZuyov8Qn2C7L7aPwSRQ@mail.gmail.com>
        <20230224102935.591dbb43@kernel.org>
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

On Fri, 24 Feb 2023 10:29:35 -0800
Jakub Kicinski <kuba@kernel.org> wrote:

> On Fri, 24 Feb 2023 12:47:02 -0500 Jamal Hadi Salim wrote:
> > On Fri, Feb 24, 2023 at 12:11 PM Jakub Kicinski <kuba@kernel.org> wrote:  
> > > On Thu, 23 Feb 2023 19:27:42 -0800 Stephen Hemminger wrote:    
> > > > What about JSON support. Is genl not json ready yet?    
> > >
> > > All the genl code looks quite dated, no JSON anywhere in sight :(    
> > 
> > We'll take care of this...  
> 
> I'm biased but at this point the time is probably better spent trying
> to filling the gaps in ynl than add JSON to a CLI tool nobody knows
> about... too harsh? :

So I can drop it (insert sarcasm here)
