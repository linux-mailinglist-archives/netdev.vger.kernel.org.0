Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2918C60EECD
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 05:46:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234332AbiJ0DqS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 23:46:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234127AbiJ0DqM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 23:46:12 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE9C84BA71
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 20:46:09 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id j7so331706ybb.8
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 20:46:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=hYm2eIdTsh6fFKPg4Wkygxm3tnPpIqxoD+YVXOxrxNU=;
        b=QPgBcJyts4KPBtcWrYww9GmjIZM4PMoqTL/bQGjKyPZB8GbKlA6wxJiRzUwwR2qbKJ
         1DSZ6twM5dEm/3ojR2AG4Mug7eWREhTPvZGM6i9lX4b1ak6zY1GKWeKYsXwRL9F66y7+
         mN4fb9cuqxcWVzT5P8eawkYrkbZYxa2kTplaBbPMynDFFJnKj33auWEpQEaGf9Zg79z/
         KYdw8/mmRrmw/Uws0tpfEyGvFJPzn8ZoXA1/3iRrLOSKPcnrYmMvA8peI0HDCSgKZyaZ
         xObxKmw74BoSNchv57FgwEAf18cEFk8F955A1yR4alsJmOXaYAHHBZCRB3M+af7c+7ra
         YNFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hYm2eIdTsh6fFKPg4Wkygxm3tnPpIqxoD+YVXOxrxNU=;
        b=czze4O+B5ZbAj9097nddN6vuiul6MFMKTxIsS6GFeYg/SRvOjHUOiOGxT9odTof+Ce
         jlkSFtynfNses1vOCefC+o3JYyVa7JciQmvlgrPw90soOkJsmbe6HnGk18lITHDrBmyb
         /TQlBs3hYh8WOPxBpXcUcwVDJrq6Ng5lesNFOibICeCuWBxZHs3Wqyo00GC953KCkg9D
         33Pk0rHx41AffvwZGMbBOsrYkYikKfW96cNgLSK7S4ALaQRqsWk87hRinERlKBPaN0Re
         iR+CtYhjXRekMgweZhjQk5sQU6zaYW7eU/O82GeT8vzz9tGH61wLHeF1ePS+XtCmCyou
         cGPg==
X-Gm-Message-State: ACrzQf1PZyDRvjBJAWPqSxoFpI45wQl9W2xH59T14Eksw0FLo53ns7r8
        IUUKg4l4aFcsOtFvc4NUGa7g+mfr5N/l+59SSkCqRA==
X-Google-Smtp-Source: AMsMyM60ablXKisWXtLW19mQvL4Q0EgElMhZFYeuPwRN8S2lD064Zr82DnCllkgtFtALUpSrY/q9F4Djz/2WXVbfcMU=
X-Received: by 2002:a25:32ca:0:b0:6ca:40e2:90c8 with SMTP id
 y193-20020a2532ca000000b006ca40e290c8mr32620466yby.55.1666842368863; Wed, 26
 Oct 2022 20:46:08 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000fd9a4005ebbeac67@google.com> <Y1YeSj2vwPvRAW61@gondor.apana.org.au>
 <CANn89i+41Whp=ACQo393s_wPx_MtWAZgL9DqG9aoLomN4ddwTg@mail.gmail.com>
 <Y1YrVGP+5TP7V1/R@gondor.apana.org.au> <Y1Y8oN5xcIoMu+SH@hog>
 <Y1d8+FdfgtVCaTDS@gondor.apana.org.au> <Y1k4T/rgRz4rkvcl@hog> <Y1n+LM57U3HUHMJa@gondor.apana.org.au>
In-Reply-To: <Y1n+LM57U3HUHMJa@gondor.apana.org.au>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 26 Oct 2022 20:45:57 -0700
Message-ID: <CANn89iLVRq28iMzjKBovyDvytH1ssW_Tp0AjoUbv74dFg2wXWQ@mail.gmail.com>
Subject: Re: [v3 PATCH] af_key: Fix send_acquire race with pfkey_register
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Sabrina Dubroca <sd@queasysnail.net>,
        syzbot <syzbot+1e9af9185d8850e2c2fa@syzkaller.appspotmail.com>,
        davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        steffen.klassert@secunet.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 26, 2022 at 8:42 PM Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Wed, Oct 26, 2022 at 03:38:23PM +0200, Sabrina Dubroca wrote:
> >
> > LGTM, thanks.
> >
> > Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
>
> Thanks for the review and comments!

SGTM, thanks for the fix.

Reviewed-by: Eric Dumazet <edumazet@google.com>
