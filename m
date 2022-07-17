Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6523C5777C6
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 20:34:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbiGQSec (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jul 2022 14:34:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiGQSeb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jul 2022 14:34:31 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5755912752;
        Sun, 17 Jul 2022 11:34:30 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id v185so7762136ioe.11;
        Sun, 17 Jul 2022 11:34:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7T1elb4VQwrC1sZg3F4EdxUouZCTWEFZq0pNjmM10H4=;
        b=R+qaOJ/RIl3tbU2jrW/9rmGOvRSHh7KgGM8IOx/eYI3V0sYo9NQmH4FJw4hNkIeZEc
         L6glhandgJX4/1fNKk9uOpAh1MYb1SmhGdyTTj/tiOqprl10s8pSnGVB8hls1Qro3O/Q
         hsGU2inzEMgiQ3M+Peh0rABJjo7yZRQ0z3+WP9/nK4/XINkll/MVTwfkAyD/jpduSMc0
         rBtyGjceHwVaO6EyN8BTRtKRyLxkSJU/V8PcuG4Nz2XUBJSB34BTcREnZNn+zCdok3fx
         0lv26C9wusy4wO8CpSnZt9qonkLuT2UNIItzdLy8FDRALcJ8ZR0a7DiLQTrdajBmAXsE
         wISA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7T1elb4VQwrC1sZg3F4EdxUouZCTWEFZq0pNjmM10H4=;
        b=v57PEs1jnXfn7Ob4FJV5fHQMoh9HgSRlEkB/mpsJSW5Crqy6d5NttfQbTkEfSC+eB/
         jZXLc5ViuBpoAHUM172OVeC5DEez3uUtrX8d4jKRn46olxUaBeipazKZ5vP9tuNOW990
         APqcPulOvIN4zplaZjrzHj8u5Ax4JY37fgAFxDMy3cfIxtVf9LwHKx5hWq8rBeVZbObk
         qnfb8CDqT9qnjEVbPNUAINOAFn5P+9d3OzazUhze9LmKTSFdEXkVJhlHSQ+UswqM1WbP
         2FayBJYM3LTJqKXBHIUQZ1bxOowMd1lF6F+ZieUCc8lr5YY3AU/LSpENf7jK22p+nvqW
         saYQ==
X-Gm-Message-State: AJIora/GHvcFpqNIs0SQcD+PW5NhJcfz9Grh/C+ybUIQguGZA+JKonXQ
        LplKp6oUpfkMyWg6Tktrer2VJbtpt16Q8kBC/SIqMIZBUW+UKUHg
X-Google-Smtp-Source: AGRyM1uwKboyXHtiqj1uHFqFb9BJSoG9rYLgloobGhf3g81UQO0u3jikyOPgFmybtt+5ILMNrsR6hmzz46pfsolzH8c=
X-Received: by 2002:a05:6638:4883:b0:33f:7948:e685 with SMTP id
 ct3-20020a056638488300b0033f7948e685mr12872724jab.138.1658082869800; Sun, 17
 Jul 2022 11:34:29 -0700 (PDT)
MIME-Version: 1.0
References: <20220717133759.8479-1-khalid.masum.92@gmail.com> <3ea0ea90-48bf-ce19-e014-9443d732e831@gmail.com>
In-Reply-To: <3ea0ea90-48bf-ce19-e014-9443d732e831@gmail.com>
From:   Khalid Masum <khalid.masum.92@gmail.com>
Date:   Mon, 18 Jul 2022 00:34:19 +0600
Message-ID: <CAABMjtHiet1_SRvLBhoNxeEh865rwtZCkb510JmFPkHFMd5chQ@mail.gmail.com>
Subject: Re: [PATCH] Bluetooth: hci_core: Use ERR_PTR instead of NULL
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     linux-kernel-mentees@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 17, 2022 at 10:17 PM Pavel Skripkin <paskripkin@gmail.com> wrote:
>
> Hi Khalid,
>
> Khalid Masum <khalid.masum.92@gmail.com> says:
> > Failure of kzalloc to allocate memory is not reported. Return Error
> > pointer to ENOMEM if memory allocation fails. This will increase
> > readability and will make the function easier to use in future.
> >
> > Signed-off-by: Khalid Masum <khalid.masum.92@gmail.com>
> > ---
>
> [snip]
>
> > index a0f99baafd35..ea50767e02bf 100644
> > --- a/net/bluetooth/hci_core.c
> > +++ b/net/bluetooth/hci_core.c
> > @@ -2419,7 +2419,7 @@ struct hci_dev *hci_alloc_dev_priv(int sizeof_priv)
> >
> >       hdev = kzalloc(alloc_size, GFP_KERNEL);
> >       if (!hdev)
> > -             return NULL;
> > +             return ERR_PTR(-ENOMEM);
> >
>
> This will break all callers of hci_alloc_dev(). All callers expect NULL
> in case of an error, so you will leave them with wrong pointer.

You are right. All callers of hci_alloc_dev() need to be able to handle
the error pointer. I shall send a V2 with all the callers of hci_alloc_dev
handling the ERR_PTR.

> Also, allocation functionS return an error only in case of ENOMEM, so
> initial code is fine, IMO
>

I think it makes the memory allocation error handling look to be a bit
different from what we usually do while allocating memory which is,
returning an error or an error pointer. Here we are returning a NULL
without any context, making it a bit unreadable. So I think returning
an error pointer is better. If I am not mistaken, this also complies with
the return convention:
https://www.kernel.org/doc/htmldocs/kernel-hacking/convention-returns.html

>
> Thanks,
> --Pavel Skripkin


Thanks,
  -- Khalid Masum
