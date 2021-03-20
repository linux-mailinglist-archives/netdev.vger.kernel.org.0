Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10EB7342D14
	for <lists+netdev@lfdr.de>; Sat, 20 Mar 2021 14:35:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbhCTNYP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Mar 2021 09:24:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbhCTNYF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Mar 2021 09:24:05 -0400
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D8D6C061762
        for <netdev@vger.kernel.org>; Sat, 20 Mar 2021 06:24:05 -0700 (PDT)
Received: by mail-qv1-xf2a.google.com with SMTP id t16so6431973qvr.12
        for <netdev@vger.kernel.org>; Sat, 20 Mar 2021 06:24:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FZlHKrOX6Ha9xSGN1OJQNV1fPSjbR8XrhLStL61dRCY=;
        b=Q0AABxAJ4qDg0KkZgvXHjK7fDq1vN1SX44aNVyiGmi9+eyO+X/gsfYO6Svb9zpK4C9
         bcTpEFAoLMF+mQ05trp+ye+eBkygVa3PGIDO01VCE8u548hBCHum3UMlJ4HcFP4ZJZlA
         +uMEKiSEa2BQxY8o5WRozKBakAPLH86igU0A/Ny1QRPcIKOMT5Cer5sdTNwRkrB4eJc6
         LcIG3QJAYf4swuFveG661jCQV0R5Jk/8l9KXFDIVhbR+GrlsxiVcs5LM0Ff301axK2PF
         hHz7fbHW65awqfRQ6NgfLonCS+X1znrEI2vxYzsJ29xnycy/h9YKA96qejpGKvvjQWCs
         5apA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FZlHKrOX6Ha9xSGN1OJQNV1fPSjbR8XrhLStL61dRCY=;
        b=JZipHxLXrGFapRx8HEAr/FB/hzo1jsu2lpkuiAZM2ClgSRwZ7cRSp7knnDBH7BLucQ
         /YIFR/nXITJLdrp6dVBWkApFlHooyEYa+ZNkKlPBqn8g8MnYx6doLwFDm/D4Uj8yqrcg
         e9b5+U3H6EKHRfgXiAhLPEws3VzGtitZ5WtUMHvTd8qHtmRgsu/HM+uAE6C7N90SAJqR
         bhVUkzNzSApeLOZU9BBqFgJkiqKZP5G1GydLbZC4V3QP2AE+jrJjlW8HOMZUHijEq7I4
         SHtMUrc4Ke+DE/9qP5G+fm1OuQExtIbVDuGOS7T87tMNpaWDYFHMc3lwy2Ib9nlK9mLQ
         Czpg==
X-Gm-Message-State: AOAM530D5IdSPQj3P3gH+6/GwnEgaIPnp8Dcf827JVbam++cpgAWNcLL
        /j/xCYm7bgzCC9hyLDl34Th0TQ==
X-Google-Smtp-Source: ABdhPJy/SLMRdKsAtatoS/KsNBjEGX8M3tmx2Pej19mAkU3XLanrIj8g+Vb+Q0PT6zFIPz1LgtPHlA==
X-Received: by 2002:a05:6214:889:: with SMTP id cz9mr13676144qvb.5.1616246644078;
        Sat, 20 Mar 2021 06:24:04 -0700 (PDT)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id s13sm6644263qkg.17.2021.03.20.06.24.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 20 Mar 2021 06:24:03 -0700 (PDT)
Subject: Re: [PATCH net-next 0/4] net: ipa: fix validation
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, elder@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210319042923.1584593-1-elder@linaro.org>
Message-ID: <5c6fabcf-88c7-29db-431e-01818321e9e7@linaro.org>
Date:   Sat, 20 Mar 2021 08:24:02 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210319042923.1584593-1-elder@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/18/21 11:29 PM, Alex Elder wrote:
> There is sanity checking code in the IPA driver that's meant to be
> enabled only during development.  This allows the driver to make
> certain assumptions, but not have to verify those assumptions are
> true at (operational) runtime.  This code is built conditional on
> IPA_VALIDATION, set (if desired) inside the IPA makefile.

Given the pushback on the ipa_assert() patch I will send
out version 2 of this series, omitting the two patches
that involve assertions.

I still think there's a case for my proposal, but I'm
going to move on for now and try to find other ways
to do what I want.  In some cases BUILD_BUG_ON() or
WARN_ON_DEV() could be used.  In other spots, I might
be able to use dev_dbg() for checking things only
while developing.  But there remain a few cases where
none of these options is quite right.

If I ever want to suggest an assertion again I'll do
it as an RFC and will copy Leon and Andrew, to make
sure they can provide input.

Thanks.

					-Alex

> Unfortunately, this validation code has some errors.  First, there
> are some mismatched arguments supplied to some dev_err() calls in
> ipa_cmd_table_valid() and ipa_cmd_header_valid(), and these are
> exposed if validation is enabled.  Second, the tag that enables
> this conditional code isn't used consistently (it's IPA_VALIDATE
> in some spots and IPA_VALIDATION in others).
> 
> This series fixes those two problems with the conditional validation
> code.
> 
> In addition, this series introduces some new assertion macros.  I
> have been meaning to add this for a long time.  There are comments
> indicating places where assertions could be checked throughout the
> code.
> 
> The macros are designed so that any asserted condition will be
> checked at compile time if possible.  Otherwise, the condition
> will be checked at runtime *only* if IPA_VALIDATION is enabled,
> and ignored otherwise.
> 
> NOTE:  The third patch produces two bogus (but understandable)
> warnings from checkpatch.pl.  It does not recognize that the "expr"
> argument passed to those macros aren't actually evaluated more than
> once.  In both cases, all but one reference is consumed by the
> preprocessor or compiler.
> 
> A final patch converts a handful of commented assertions into
> "real" ones.  Some existing validation code can done more simply
> with assertions, so over time such cases will be converted.  For
> now though, this series adds this assertion capability.
> 
> 					-Alex
> 
> Alex Elder (4):
>    net: ipa: fix init header command validation
>    net: ipa: fix IPA validation
>    net: ipa: introduce ipa_assert()
>    net: ipa: activate some commented assertions
> 
>   drivers/net/ipa/Makefile       |  2 +-
>   drivers/net/ipa/gsi_trans.c    |  8 ++---
>   drivers/net/ipa/ipa_assert.h   | 50 ++++++++++++++++++++++++++++++++
>   drivers/net/ipa/ipa_cmd.c      | 53 ++++++++++++++++++++++------------
>   drivers/net/ipa/ipa_cmd.h      |  6 ++--
>   drivers/net/ipa/ipa_endpoint.c |  6 ++--
>   drivers/net/ipa/ipa_main.c     |  6 ++--
>   drivers/net/ipa/ipa_mem.c      |  6 ++--
>   drivers/net/ipa/ipa_reg.h      |  7 +++--
>   drivers/net/ipa/ipa_table.c    | 11 ++++---
>   drivers/net/ipa/ipa_table.h    |  6 ++--
>   11 files changed, 115 insertions(+), 46 deletions(-)
>   create mode 100644 drivers/net/ipa/ipa_assert.h
> 

