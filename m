Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4139267A8C4
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 03:30:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233279AbjAYCa3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 21:30:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230251AbjAYCa2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 21:30:28 -0500
Received: from mail-oo1-xc2f.google.com (mail-oo1-xc2f.google.com [IPv6:2607:f8b0:4864:20::c2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 441C645F5E;
        Tue, 24 Jan 2023 18:30:26 -0800 (PST)
Received: by mail-oo1-xc2f.google.com with SMTP id h3-20020a4ac443000000b004fb2954e7c3so2945356ooq.10;
        Tue, 24 Jan 2023 18:30:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BJExUS8crGcUXgJHEJI5GEH9KPZmVFh2RbeUyVORSms=;
        b=lRmnxkLWAlxS7hvgjplK/0QE15EFNbDkUm60gqtwUVaD8wVsWfwEeCllwKYJE2dAux
         kGtiKbzuiVNpz02kJusnBg+cdrMm5j5h3GmOlJyQkAkHYL0565zp2Gc4TfRR9ZGZssQD
         TVEExdwlI9lz+IByNMKbg1gzWLBpPxyn0dsaab5o6AmhKs7sq8SSS4s4fkTacZvUdQ2F
         kyB6fdOFN2L7eAJdsPlStIYOygRse1Jk9KQkRmOxVm0sFAQAcRiiEQQe9G6mkYHcpqIp
         KCb9TC7fC8UH42/Ls1sPw4FwRYFlvNu1e1W1FtIIewg54U01oeIE3D9EIeD5O51tPPYA
         P5sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BJExUS8crGcUXgJHEJI5GEH9KPZmVFh2RbeUyVORSms=;
        b=0w6rH5ebtoDWOrLfwPfDTWJ9j72c018w8ocslX4nXps5TDbKgEZ4wKDOndSEOoOr6f
         shVlmk9heSw5fu3lIIFBoifLEA7OyCFldzxvSMFNWusutjqF+1wjGHpnSHe9EH9SECiU
         Lew5e/kOHETWBAJDIWX0mfmHicrZue6eirnxoV4hOyWKeu1c8MiGF9IJkq7ZIr70WYLj
         JR+zlJldeGe+WiiC1Vf6P/L2Or6A40elpfKje+yfeYz4FStMsnolwzQhgzGnMvF6sQVv
         hrr2+D9hV/FcDJboZZEMiZnNacikr3UiZe9N7W6uO2SX3jTM5TskpTbUlMcsulVxbw2B
         TW4w==
X-Gm-Message-State: AFqh2kqV5k3rWSM2cwtBQLrelLmNOyeAwZSva4ih4JWjFcWDV6Rt+OiY
        ehSHltLcd5D4o21kOjlYMsc=
X-Google-Smtp-Source: AMrXdXsFn7mPjCUei34jCi8frpRDkqA/+WC7BJpfI/zoTKOciI8aFZUPFst0ie/vBzfIaYnlm8STHw==
X-Received: by 2002:a4a:e4c6:0:b0:4f2:b25b:574 with SMTP id w6-20020a4ae4c6000000b004f2b25b0574mr11814087oov.2.1674613825382;
        Tue, 24 Jan 2023 18:30:25 -0800 (PST)
Received: from t14s.localdomain ([2001:1284:f013:d30f:6272:a08b:2b30:ac0e])
        by smtp.gmail.com with ESMTPSA id b43-20020a4a98ee000000b0051134f333d3sm461983ooj.16.2023.01.24.18.30.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jan 2023 18:30:24 -0800 (PST)
Received: by t14s.localdomain (Postfix, from userid 1000)
        id 571854AF03F; Tue, 24 Jan 2023 23:30:22 -0300 (-03)
Date:   Tue, 24 Jan 2023 23:30:22 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
        Xin Long <lucien.xin@gmail.com>,
        Pietro Borrello <borrello@diag.uniroma1.it>
Subject: Re: [PATCH net] sctp: fail if no bound addresses can be used for a
 given scope
Message-ID: <Y9CUPsuuYgdr/g+s@t14s.localdomain>
References: <9fcd182f1099f86c6661f3717f63712ddd1c676c.1674496737.git.marcelo.leitner@gmail.com>
 <20230124181416.6218adb7@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230124181416.6218adb7@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 24, 2023 at 06:14:16PM -0800, Jakub Kicinski wrote:
> On Mon, 23 Jan 2023 14:59:33 -0300 Marcelo Ricardo Leitner wrote:
> > Currently, if you bind the socket to something like:
> >         servaddr.sin6_family = AF_INET6;
> >         servaddr.sin6_port = htons(0);
> >         servaddr.sin6_scope_id = 0;
> >         inet_pton(AF_INET6, "::1", &servaddr.sin6_addr);
> > 
> > And then request a connect to:
> >         connaddr.sin6_family = AF_INET6;
> >         connaddr.sin6_port = htons(20000);
> >         connaddr.sin6_scope_id = if_nametoindex("lo");
> >         inet_pton(AF_INET6, "fe88::1", &connaddr.sin6_addr);
> > 
> > What the stack does is:
> >  - bind the socket
> >  - create a new asoc
> >  - to handle the connect
> >    - copy the addresses that can be used for the given scope
> >    - try to connect
> > 
> > But the copy returns 0 addresses, and the effect is that it ends up
> > trying to connect as if the socket wasn't bound, which is not the
> > desired behavior. This unexpected behavior also allows KASLR leaks
> > through SCTP diag interface.
> > 
> > The fix here then is, if when trying to copy the addresses that can
> > be used for the scope used in connect() it returns 0 addresses, bail
> > out. This is what TCP does with a similar reproducer.
> > 
> > Reported-by: Pietro Borrello <borrello@diag.uniroma1.it>
> > Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> 
> Fixes tag?

Lost in Narnia again, I suppose. :)

Ok, I had forgot it, but now checking, it predates git.
What should I have used in this case again please? Perhaps just:

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")

