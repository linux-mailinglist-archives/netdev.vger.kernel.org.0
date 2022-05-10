Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65E455221F3
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 19:08:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238571AbiEJRLz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 13:11:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347776AbiEJRLw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 13:11:52 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB7B456F9F;
        Tue, 10 May 2022 10:07:51 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id k14so15167021pga.0;
        Tue, 10 May 2022 10:07:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zIype/cZZggoKMv2+Lp7+DJjIFxw0T4PQlIuMMh3aP0=;
        b=kxpggMHoWYtfA37VEsMzGIqcU6HAujHR5psBfheDgHM5/JT0d4AdbZv+GErs59j765
         nmNb5lk23+vBh4y5oXfPLR9tFg1KVyy9Br0s91wVBywjmDlLSl7hOo8gp/DHrCEipUc9
         N1cfWdxScyAwzO/wcU/kCU8hdhvM7XIVzk/9UgtcMxXV2z4w5OVXH8BFC0B86S5zxs+D
         CJVHThtd1R404ht5cWguikMCNkmHfULFeWClFeiIHwWWAYGfq6IrfHnL+C8r3fZY2Sth
         0kRIYgXsCLCOUKUPEONFnpdd7LZcrVxid45D0+z48k6WM/FodHywcg/+EGhItPw2gT1X
         f08A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zIype/cZZggoKMv2+Lp7+DJjIFxw0T4PQlIuMMh3aP0=;
        b=FIPY9iAJQwPDvpjr1LQj4XYBnEUdTfriiIJocOSj765TxwEcHhNoM6r9gePpqH3TME
         TKdRiT0zEIos/fxUuf4xxFc+VuHE2QKYeaOWPMVN0XFQkABTH8K6AjZP8j32B9Yptcv7
         Ch4708aFMW9imPywyXUuOZecasPdBIwyGi4fGLGim7M6wb+KskCVaOZP7MPzLKO+3Zs0
         dTlK1P9/ygRZ+GEFYbYx7OxY5bS97Yxu03yZphmmTuxmLVA+1/V8IHKGVzjeICY68AG8
         oCVVZAvs4J0KLYMWIAObYzHrr/bVWxQe2JkJFk64Ay8HP28YlSkJBs7Et245QTdwdjVT
         5gRQ==
X-Gm-Message-State: AOAM533sL6Cnlmj/u4OtlHTu/4kds2GAqds/6kDLo0wKw2J65yBaUwQx
        ezpK/gVDhpFnp0lsFgN07lewDB2TDiU=
X-Google-Smtp-Source: ABdhPJyX/DhA8ziE9lSUbKRMOk34nNfgYQb2PXenq6G+/TgYwFNOUIkvHYIrOwLgCU7LEPWmCKgHhg==
X-Received: by 2002:a63:6c0a:0:b0:3ab:894f:8309 with SMTP id h10-20020a636c0a000000b003ab894f8309mr17659220pgc.536.1652202470953;
        Tue, 10 May 2022 10:07:50 -0700 (PDT)
Received: from MBP-98dd607d3435.dhcp.thefacebook.com ([2620:10d:c090:400::4:e8e5])
        by smtp.gmail.com with ESMTPSA id u11-20020a170902bf4b00b0015e8d4eb21asm2312536pls.100.2022.05.10.10.07.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 May 2022 10:07:50 -0700 (PDT)
Date:   Tue, 10 May 2022 10:07:46 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, yhs@fb.com, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, jonathan.lemon@gmail.com, bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next 0/9] selftests: xsk: add busy-poll testing plus
 various fixes
Message-ID: <20220510170746.ujho4d22xao3ingj@MBP-98dd607d3435.dhcp.thefacebook.com>
References: <20220510115604.8717-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220510115604.8717-1-magnus.karlsson@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 10, 2022 at 01:55:55PM +0200, Magnus Karlsson wrote:
> This patch set adds busy-poll testing to the xsk selftests. It runs
> exactly the same tests as with regular softirq processing, but with
> busy-poll enabled. I have also included a number of fixes to the
> selftests that have been bugging me for a while or was discovered
> while implementing the busy-poll support. In summary these are:
> 
> * Fix the error reporting of failed tests. Each failed test used to be
>   reported as both failed and passed, messing up things.
> 
> * Added a summary test printout at the end of the test suite so that
>   users do not have to scroll up and look at the result of both the
>   softirq run and the busy_poll run.
> 
> * Added a timeout to the tests, so that if a test locks up, we report
>   a fail and still get to run all the other tests.
> 
> * Made the stats test just look and feel like all the other
>   tests. Makes the code simpler and the test reporting more
>   consistent. These are the 3 last commits.
> 
> * Replaced zero length packets with packets of 64 byte length. This so
>   that some of the tests will pass after commit 726e2c5929de84 ("veth:
>   Ensure eth header is in skb's linear part").
> 
> * Added clean-up of the veth pair when terminating the test run.
> 
> * Some smaller clean-ups of unused stuff.

Sounds like a good set of improvements and fixes.

Bjorn,
please review.
