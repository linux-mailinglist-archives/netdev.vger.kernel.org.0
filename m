Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46371617FF2
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 15:49:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231734AbiKCOs7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 10:48:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231757AbiKCOs4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 10:48:56 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E4F118B15;
        Thu,  3 Nov 2022 07:48:55 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id bs21so3145786wrb.4;
        Thu, 03 Nov 2022 07:48:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=OyyRFN6o9cSPSQOmcN/1EM+CmiHfqIcoRrnXjizSh5k=;
        b=UiD6Sw+BCc8/v2kAxBpA4XlTQDkFfgJLJVlGwLZvxlPlnD5+ynC6Eq8DbPlt3NW9h0
         bAD0JrWxYpZyk+g5EL9zTxmBD11V4eHsfrpY9GQ+5UfPRnbePRyzxV5OEA/zcUhujJDC
         Gy/COKqcAtQUFIeQ2Eo3dlOvoUYxm4Dbu87s45v+vvUNU5352mEb7lfuIpX/V4Re5rhz
         n+oHq03FKxelkwBIr7lr2YsKRfX3+6J3GhjH7PAw1a790wpPGH90M0pVryi1iA2ObvPO
         cih1QQKeW350S+iC7phkiyqumk3RQOxihOSnl3wQH8CyC4VMH4VixE5QRKtHMfFCumYF
         xscQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OyyRFN6o9cSPSQOmcN/1EM+CmiHfqIcoRrnXjizSh5k=;
        b=GxIz5prZ/YlGxQ5hY8NrIhraw7SyW9sCXtLMaTPizmWYhS8DvTmhPtsMl2F7UMRlhP
         /Ez4tjByWTRpKHiuB3bZ2ATwzLHXx2y+klywaT8jo5Wdt3pMoOCrXbdQc+HIPS+7eH1n
         hV6abGqE8VVVRFYYg1oVKCx+FmrClFBSn0pWFc+AVKIEn7zgYB4rfHQ6X+olvvTH6X2O
         HwJtdUGuFK0Oml5NZxoelGwy3JgGprU/ytb+E5Q186zm8eOhU6j4NpBmMONJdgtdD1Ma
         qGEMdqBbI4WZX5qVfos50sdpbtFV5JPWCJ60+UGs2ufpeS+aY9ta2iZiDF4FwWq0kSnt
         mohQ==
X-Gm-Message-State: ACrzQf1M5FpuPrJeeQsqPeU4X6G8lkCvKFD+BAPdkzwv2p5xOLbVJgyj
        bT6mDOGSUswzrwXS1RcOP9E5Ff3V38Er4A==
X-Google-Smtp-Source: AMsMyM4K/tdvIzFule6PjRafCbDb6HsmdP5OBU7nmsT0oVnHvqtXJEI3fBPFQ1oYPtFAPthl+pvllg==
X-Received: by 2002:adf:f687:0:b0:236:481f:83a6 with SMTP id v7-20020adff687000000b00236481f83a6mr19368811wrp.342.1667486933978;
        Thu, 03 Nov 2022 07:48:53 -0700 (PDT)
Received: from krava (2001-1ae9-1c2-4c00-726e-c10f-8833-ff22.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:726e:c10f:8833:ff22])
        by smtp.gmail.com with ESMTPSA id y16-20020adff6d0000000b0023647841c5bsm1038753wrp.60.2022.11.03.07.48.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Nov 2022 07:48:53 -0700 (PDT)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Thu, 3 Nov 2022 15:48:51 +0100
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     olsajiri@gmail.com, ast@kernel.org, daniel@iogearbox.net,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, bjorn@kernel.org, toke@redhat.com,
        David.Laight@aculab.com, rostedt@goodmis.org
Subject: Re: [PATCH 0/2] bpf: Yet another approach to fix the BPF dispatcher
 thing
Message-ID: <Y2PU01h0hy+6dI0J@krava>
References: <20221103120012.717020618@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221103120012.717020618@infradead.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 03, 2022 at 01:00:12PM +0100, Peter Zijlstra wrote:
> Hi!
> 
> Even thought the __attribute__((patchable_function_entry())) solution to the
> BPF dispatcher woes works, it turns out to not be supported by the whole range
> of ageing compilers we support. Specifically this attribute seems to be GCC-8
> and later.
> 
> This is another approach -- using static_call() to rewrite the dispatcher
> function. I've compile tested this on:
> 
>   x86_64  (inline static-call support)
>   i386    (out-of-line static-call support)
>   aargh64 (no static-call support)
> 
> A previous version was tested and found working by Bjorn.
> 
> It is split in two patches; first reverting the current approach and then
> introducing the new for ease of review.
> 

Acked-by: Jiri Olsa <jolsa@kernel.org>
Tested-by: Jiri Olsa <jolsa@kernel.org>

thanks,
jirka
