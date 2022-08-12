Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4301C591073
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 14:03:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234432AbiHLMDk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 08:03:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231250AbiHLMDk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 08:03:40 -0400
Received: from mail-yw1-x1135.google.com (mail-yw1-x1135.google.com [IPv6:2607:f8b0:4864:20::1135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 341419A97A;
        Fri, 12 Aug 2022 05:03:37 -0700 (PDT)
Received: by mail-yw1-x1135.google.com with SMTP id 00721157ae682-32194238c77so7835987b3.4;
        Fri, 12 Aug 2022 05:03:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=+GekjXTUi66HUPgrzyGJXQiRM5598c+QHeBBcM7EfC4=;
        b=DrTs1gwaQeh0LzV8JRLL9Lk9r9xlNkpOsnv2ZcrXZQLtdKNmJEHdoS6LdMeaZbcsEM
         YE/otOdX1krCNyrD+Rv3FUA0JuK24XryjeLVpVYC8r11Nlpk4wwBhq78pELd7wwV+8gF
         dAUQ9NXVwAYHbL/Q1utJKmw0e+ifYLfXGBkH6tEMATyE9gbMDxFWKMm8Dz9NOdkekgwn
         ef/oQk5mjIdZpXAhMslmT6n1k2c8MqDD04R0IqhH3h29BQrLl1bhD2/fp+mQtKS22cV1
         2/q+83sfked2EihA60sclltU6MHhaqWFMbYeqzpykLE5V8W2wdjKxRWvMAkxUiXBkYke
         5dFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=+GekjXTUi66HUPgrzyGJXQiRM5598c+QHeBBcM7EfC4=;
        b=35LK5v6ofbdnL85yO4yB71UCjhISdt+/9CULmcfA5O30fH1qL76/J+Ss2u+iIRDS72
         e6r579QSTw5yJpGtvrK1yW3tZTuburt/5a3uN1ZcGyT1193zpIEcHgPfa5EV9m4KJTbg
         i/RkxFr4sN8xED17wLSw23FiAY+gV+hDQ+zwS3GOpcU6qnL9gsEG+eeZ5KOO1dFoBphM
         rm7UXxUiM56bk40RsQ8zhswBlZsZar6WVueGZw9y3c+JGkXd3ppop53rWnNsSKL0Npw9
         cRdGg2qspjWyRoc9px5ORRayVmD7lB5/hsUHfl8iVJhOKSrUSwxUOSy85cV+pXa6RPpP
         qekQ==
X-Gm-Message-State: ACgBeo0vMReOhY9kH90eDCt3ezEOKXEnb50h2n5Erb0bQkuRNz0jJv1Q
        goA4FyTZQ3seud74jDUUBR+Nh1t6FBpa/k4wsSU=
X-Google-Smtp-Source: AA6agR5mZLcNYry70OgTHxs7ixri5iGVBMzDvxELIwWtB1t0f4XsJo5eCYIBnRulBqOns6RjNySZMFPFGhHXRbKvaPk=
X-Received: by 2002:a81:928c:0:b0:324:7008:1390 with SMTP id
 j134-20020a81928c000000b0032470081390mr3524259ywg.39.1660305816360; Fri, 12
 Aug 2022 05:03:36 -0700 (PDT)
MIME-Version: 1.0
References: <YvY4xdZEWAPosFdJ@debian> <f0a6f8cc-e8a5-ff72-b8f0-ed25fcf03b47@molgen.mpg.de>
In-Reply-To: <f0a6f8cc-e8a5-ff72-b8f0-ed25fcf03b47@molgen.mpg.de>
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date:   Fri, 12 Aug 2022 13:03:00 +0100
Message-ID: <CADVatmO8S-_k8ySktH9-GT7G_AC-UDRH=5D88XVYo_vu7qfEjg@mail.gmail.com>
Subject: Re: mainline build failure due to 332f1795ca20 ("Bluetooth: L2CAP:
 Fix l2cap_global_chan_by_psm regression")
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-bluetooth@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Palmer Dabbelt <palmer@rivosinc.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Paul,

On Fri, Aug 12, 2022 at 12:44 PM Paul Menzel <pmenzel@molgen.mpg.de> wrote:
>
> Dear Sudip,
>
>
> Am 12.08.22 um 13:25 schrieb Sudip Mukherjee (Codethink):
>
> > The latest mainline kernel branch fails to build csky and mips allmodconfig
> > with gcc-12.
> >

<snip>

>
> Does *[PATCH] Bluetooth: L2CAP: Elide a string overflow warning* [1] fix it?

Yes, this patch fixes the failure.

>
>
> > --
> > Regards
> > Sudip
>
> Only if you care, your signature delimiter is missing a trailing space [2].

Thanks. Should be fixed now.


-- 
Regards
Sudip
