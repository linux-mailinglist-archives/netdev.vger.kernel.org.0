Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EAF651711D
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 16:00:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385461AbiEBOD0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 10:03:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385454AbiEBODV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 10:03:21 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6380A11C38
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 06:59:53 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id t11-20020a17090ad50b00b001d95bf21996so16161548pju.2
        for <netdev@vger.kernel.org>; Mon, 02 May 2022 06:59:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KGRacn9uuiwDK9IDVtO65TRRHa9q/c61O2nawSy9wRU=;
        b=XWTxrSFoXTzXCx61/5jA2YmGAPQNLI8EEOymHmo+S78cRG398PhG+F5ut7u2Cy75TF
         dZ+q7ml/foO6L3HA4svgVcEOFrLWF4I8MEoT5aj6bDFAv+Fc0cBKPiTukm4XLmFElVda
         SUZZspiyaoUZtp2spe9sBwYPqEPDIAGfrhOD1PTP3jDeKoZsWe5xrtE7bni9rHO4V35t
         quLipTMBIKmZfmLejud3yBJfHytnEFG9jkwDKSVNekqtsmjbJbRlQYjuf37WLJiHTPtc
         v1WXorLtfiWYB9BrroikcUynuC51KV5xVFE1UAhqAxoHaD6ePKArfe2HBsDlofqDwQWP
         bzHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KGRacn9uuiwDK9IDVtO65TRRHa9q/c61O2nawSy9wRU=;
        b=zS7rCUUqr7HPU/bAFVQWcfcm+Hzwts+aljuVST91xbmHfwGcCwgkQOicnideb0v/df
         IE1bMx2UYK07vQLzd6Z4uGhumaIzHyOZb1surkgb2Z/Ez2H19LkQOtUxsNxwjb7BcZFz
         0/Slq4C/2zzfgdIxiSm8cI50HzquxN9cAMbF7OiuVxKBTQvBCsEXFYmUz3zH6QmrWaRG
         JbZ4S7wrhCMPQ1Bn6nK1Xbt3+OkS9lnuAwBnxb3K4pguuH7JeeHAU2lYGylvdPgjd5vl
         l0Tl6b8woD2l5bUwRqkkH/DF0p7JAcfz7ZTnW6gmNPgW/jAvnjwufqQPr5xuLoKpxQD+
         6zTg==
X-Gm-Message-State: AOAM533SivWYlxg3IRhfipVBJ2tys3dhsXYZfdsHzT7vEk1rrx8c6C7I
        zn6Ne77unuufSWBa/y8E5vKdWg==
X-Google-Smtp-Source: ABdhPJzbhEupKS4z3Gw3q462sX+yNWMqq9eX6Jvx95MRe8NLovH5H1UF5eSgCTitrwnaCP/1ibgVNg==
X-Received: by 2002:a17:90a:9418:b0:1d8:91d1:4d74 with SMTP id r24-20020a17090a941800b001d891d14d74mr18264422pjo.62.1651499992730;
        Mon, 02 May 2022 06:59:52 -0700 (PDT)
Received: from google.com (201.59.83.34.bc.googleusercontent.com. [34.83.59.201])
        by smtp.gmail.com with ESMTPSA id n189-20020a6327c6000000b003c265b7d4f6sm140071pgn.44.2022.05.02.06.59.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 May 2022 06:59:52 -0700 (PDT)
Date:   Mon, 2 May 2022 13:59:48 +0000
From:   Carlos Llamas <cmllamas@google.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, kernel@pengutronix.de,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH net 2/2] selftests/net: so_txtime: usage(): fix
 documentation of default clock
Message-ID: <Ym/j1PGE2NWJ4OQz@google.com>
References: <20220502094638.1921702-1-mkl@pengutronix.de>
 <20220502094638.1921702-3-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220502094638.1921702-3-mkl@pengutronix.de>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 02, 2022 at 11:46:38AM +0200, Marc Kleine-Budde wrote:
> The program uses CLOCK_TAI as default clock since it was added to the
> Linux repo. In commit:
> | 040806343bb4 ("selftests/net: so_txtime multi-host support")
> a help text stating the wrong default clock was added.
> 
> This patch fixes the help text.
> 
> Fixes: 040806343bb4 ("selftests/net: so_txtime multi-host support")
> Cc: Carlos Llamas <cmllamas@google.com>
> Cc: Willem de Bruijn <willemb@google.com>
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> ---

LGTM, thanks.

Reviewed-by: Carlos Llamas <cmllamas@google.com>

--
Carlos Llamas
