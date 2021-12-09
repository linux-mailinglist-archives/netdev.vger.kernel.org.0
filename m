Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F80A46E9A7
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 15:11:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238411AbhLIOPB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 09:15:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238401AbhLIOPA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 09:15:00 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C03F8C0617A2
        for <netdev@vger.kernel.org>; Thu,  9 Dec 2021 06:11:26 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id g191-20020a1c9dc8000000b0032fbf912885so4172530wme.4
        for <netdev@vger.kernel.org>; Thu, 09 Dec 2021 06:11:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=a2tXxsXCaxEsDkdFABP3QB5zkyYyslmPCU1sxe4bwWU=;
        b=hQUZOu9fn+0tSRYNo5YIO/fAqyN3BrECCRn67HUtge3wlFf6nMiMRiCWQ2rkBHM7w7
         +W3tLzeCUKHRG2K+DAh/ECpaT25XWOVg4k/fRiEiDLo4bKBXwog9ut1V+bVqDh2WIs2/
         9KhCe9eiPw/ZqgAwPzDSiuZq0U5eFcO9YY5+NZ1U/9yq5fWoUd0jzuoM+thwFfBYv7DT
         W46iVMJdy1JQ+Gd3LeLe8aRgwSLCf8lhpXmySuYzyjmZ42kxD5l4gPwnVa4sKgqSK/S0
         0YWHXR2+4v4NmD1jPUAyMhPaIKSGhLyljBj2swmv81fjhaCuDa8cb3abBV/vqKzTXSzm
         CuFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=a2tXxsXCaxEsDkdFABP3QB5zkyYyslmPCU1sxe4bwWU=;
        b=uTyddUE9Ec7u5pz0odtcE2W0sFdrT//fAzetx4KOv7A8355mkvjO1UDN3CtwTyGcxg
         EyAKOG6X05/mNvdVAARSBMMlY2JgHKH/vBJ7liNJS4F93Z5+UU6iMesbQSnoMJxgWFhq
         NvjsKkWq4y9I+VICJoXFFV1gmODZ+6eBleoJwRkGi36ZaugGHLnfda+4G/3roYcg0Sxm
         /j5q1x8inWkxXvx578W1fNxYus/2YV8CHUyzvRhaJSm8cc5Tt2mAh5e0M0Ik2Gaaq+MU
         dGvZpflu4n7/srPdZOWAjD+ChspTIGQPaZrsp+ZgmJexQAxWXN8+qzpTYCvr+G8uQ0Eg
         IK3g==
X-Gm-Message-State: AOAM533eKHFwSRU3qdLCO4QiKvcDvkwyzEf7sURL1JabdateeqfVzMs9
        8VP62R0ntbjfTSiLRKIXLBV0+g==
X-Google-Smtp-Source: ABdhPJxlnH8PSplZUk/T4ZpATlfN1OZM+7DPUEepMM3eGDtJOY0WOi+ijEXjclc0iC0C6+IOyyr7ew==
X-Received: by 2002:a05:600c:1d91:: with SMTP id p17mr7534226wms.193.1639059084386;
        Thu, 09 Dec 2021 06:11:24 -0800 (PST)
Received: from google.com ([2.31.167.18])
        by smtp.gmail.com with ESMTPSA id j18sm11610930wmq.44.2021.12.09.06.11.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 06:11:23 -0800 (PST)
Date:   Thu, 9 Dec 2021 14:11:21 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     linux-kernel@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        lksctp developers <linux-sctp@vger.kernel.org>,
        "H.P. Yarroll" <piggy@acm.org>,
        Karl Knutson <karl@athena.chicago.il.us>,
        Jon Grimm <jgrimm@us.ibm.com>,
        Xingang Guo <xingang.guo@intel.com>,
        Hui Huang <hui.huang@nokia.com>,
        Sridhar Samudrala <sri@us.ibm.com>,
        Daisy Chang <daisyc@us.ibm.com>,
        Ryan Layer <rmlayer@us.ibm.com>,
        Kevin Gao <kevin.gao@intel.com>, netdev@vger.kernel.org
Subject: Re: [PATCH 1/1] sctp: Protect cached endpoints to prevent possible
 UAF
Message-ID: <YbIOie1KbasjLAhs@google.com>
References: <20211208165434.2962062-1-lee.jones@linaro.org>
 <YbH5um3HVQbSecx4@t14s.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YbH5um3HVQbSecx4@t14s.localdomain>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 09 Dec 2021, Marcelo Ricardo Leitner wrote:

> On Wed, Dec 08, 2021 at 04:54:34PM +0000, Lee Jones wrote:
> > To prevent this from happening we need to take a reference on the
> > to-be-used/dereferenced 'struct sctp_endpoint' until such a time when
> > we know it can be safely released.
> > 
> > When KASAN is not enabled, a similar, but slightly different NULL
> > pointer derefernce crash occurs later along the thread of execution in
> > inet_sctp_diag_fill() this time.
> 
> Hey Lee, did you try running lksctp-tools [1] func tests with this patch?
> I'm getting failures here.
> 
> [root@vm1 func_tests]# make v4test
> ./test_assoc_abort
> test_assoc_abort.c  1 PASS : ABORT an association using SCTP_ABORT
> test_assoc_abort passes
> 
> ./test_assoc_shutdown
> test_assoc_shutdown.c  1 BROK : bind: Address already in use
> DUMP_CORE ../../src/testlib/sctputil.h: 145
> /bin/sh: line 1:  3727 Segmentation fault      (core dumped) ./$a
> test_assoc_shutdown fails
> make: *** [Makefile:1648: v4test] Error 1
> 
> I didn't check it closely but it would seem that the ep is beind held
> forever. If I simply retry after a few seconds, it's still there (now the 1st
> test fails):
> 
> [root@vm1 func_tests]# make v4test
> ./test_assoc_abort
> test_assoc_abort.c  1 BROK : bind: Address already in use
> DUMP_CORE ../../src/testlib/sctputil.h: 145
> /bin/sh: line 1:  3751 Segmentation fault      (core dumped) ./$a
> test_assoc_abort fails
> 
> 1.https://github.com/sctp/lksctp-tools

No I haven't, but I will do once I get a moment.

The only thing I can think of, before I go digging again, is that
either the association is never unhashed (so it stays in cache
forever - I doubt this, as it would be very bad) or the association
was migrated via sctp_assoc_migrate() and the additional reference was
not transferred across.

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
