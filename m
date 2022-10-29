Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 073216120DE
	for <lists+netdev@lfdr.de>; Sat, 29 Oct 2022 09:12:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbiJ2HMc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Oct 2022 03:12:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229746AbiJ2HMa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Oct 2022 03:12:30 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EB4B5050C
        for <netdev@vger.kernel.org>; Sat, 29 Oct 2022 00:12:28 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id r61-20020a17090a43c300b00212f4e9cccdso11747338pjg.5
        for <netdev@vger.kernel.org>; Sat, 29 Oct 2022 00:12:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RrR7Fd4dpR3eHxzK4A2TRAKJqOEBfIdmQppFpAcI5qY=;
        b=a/i7ZywpD27zAcNOxH5/Y17eWyXoHL7NnUMcugYVlhVLsxQ6nO45s8Vh4Xmda5CiAA
         sXr9qa6zgtlLbQpJRGZwqH0YFHiUCZxZ44+P4Mb1lnaWf6A0g0iQ/z1qaceX1CRgjS2l
         DqhE1ok6pQYER3PSrh9BXFe8K2wYdkXpUTG+I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RrR7Fd4dpR3eHxzK4A2TRAKJqOEBfIdmQppFpAcI5qY=;
        b=Fs0R+aanBYQj0WmabFPteq1IOW5RMd/+Smb60Ri1tZWEpm1HDzs9ETihFLzHdiG8fF
         1EoRSl5mO0iqVF9+A94+WrOCTVTL5gRa/7+1KzwNXMYBGrDVgb72GrwsAS0zB3FgOyL9
         1aJVydkabIyF8FTAjApiUD029WMD8rFdWXn9+rjqHVulsdrZLc8Rinn6BfFJNA6q3TEd
         DGBY0BDx2EUQm0+UinPkaXLkRwVE8xSeWVJwYHJcBE7GU8vTCMMliO9so02KsNI9JfR1
         W4FUFO86mGQFp1Y+n1l7ZrGcDhkS9EPAM4wT+yetmFsascq58Fk8u4MFnUn+O2H/HIW2
         j8YQ==
X-Gm-Message-State: ACrzQf3f3FB+N0LdHIKINVhX574ZWCj9ybIxGhf5KKPPdHIPDSKM6uu2
        6V0PijFKV7xZ7rJqj0RqVtrEzg==
X-Google-Smtp-Source: AMsMyM5jaTkfGqW3TaDyAXvVKf3tyxuC0huHhgm3imqJjHbqpfk6HnuLbWFjjy+qUIMhn3wbxwZjfQ==
X-Received: by 2002:a17:90b:3a89:b0:213:aff5:e536 with SMTP id om9-20020a17090b3a8900b00213aff5e536mr1361706pjb.109.1667027547694;
        Sat, 29 Oct 2022 00:12:27 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id ft10-20020a17090b0f8a00b00210c84b8ae5sm483389pjb.35.2022.10.29.00.12.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Oct 2022 00:12:27 -0700 (PDT)
Date:   Sat, 29 Oct 2022 00:12:26 -0700
From:   Kees Cook <keescook@chromium.org>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Sudarsana Kalluru <skalluru@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com, Rasesh Mody <rmody@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH v2 5/6] bna: Avoid clashing function prototypes
Message-ID: <202210290009.C42E731@keescook>
References: <cover.1666894751.git.gustavoars@kernel.org>
 <2812afc0de278b97413a142d39d939a08ac74025.1666894751.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2812afc0de278b97413a142d39d939a08ac74025.1666894751.git.gustavoars@kernel.org>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 27, 2022 at 03:20:47PM -0500, Gustavo A. R. Silva wrote:
> When built with Control Flow Integrity, function prototypes between
> caller and function declaration must match. These mismatches are visible
> at compile time with the new -Wcast-function-type-strict in Clang[1].
> 
> Fix a total of 227 warnings like these:
> 
> drivers/net/ethernet/brocade/bna/bna_enet.c:519:3: warning: cast from 'void (*)(struct bna_ethport *, enum bna_ethport_event)' to 'bfa_fsm_t' (aka 'void (*)(void *, int)') converts to incompatible function type [-Wcast-function-type-strict]
>                 bfa_fsm_set_state(ethport, bna_ethport_sm_down);
>                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> The bna state machine code heavily overloads its state machine functions,
> so these have been separated into their own sets of structs, enums,
> typedefs, and helper functions. There are almost zero binary code changes,
> all seem to be related to header file line numbers changing, or the
> addition of the new stats helper.

This looks like it borrowed from
https://lore.kernel.org/linux-hardening/20220929230334.2109344-1-keescook@chromium.org/
Nice to get a couple hundred more fixed. :)

> [1] https://reviews.llvm.org/D134831
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> ---
> Changes in v2:
>  - None. This patch is new in the series.

This is relatively stand-alone (not an iw_handler patch), so it could
also go separately too.

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
