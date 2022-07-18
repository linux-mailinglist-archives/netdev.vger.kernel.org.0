Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E517D578E05
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 01:04:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236428AbiGRXEM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 19:04:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236414AbiGRXEG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 19:04:06 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56442EE2F;
        Mon, 18 Jul 2022 16:04:05 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id z22so8283613lfu.7;
        Mon, 18 Jul 2022 16:04:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TZUTBE8JOO+dBwswBQU/UW48YDxWzcOqBKIIatUeRxg=;
        b=eu+8mAmsNBdDm3xB9tJ7qWbNXhdC6joRhpKHQAJ4NU3Mky13rD9L25sbhWt9DuIotI
         gUojvdBW5A0Yn/MC4O+GhB63tm4n97gegK8HpEZRkzwH2RBhJ3qbgnumGnjVrlCvsJR7
         2tNXRis6jsm9duhk3z7u+9TVJuxAzDeFkQhctki+wu7c0eWrDms/Ckpf9yes50sGz5ZS
         iqzCE8Mh9LilppMXKYD8OidSUpoV8K4oY90b0RKIZ/yMBMgmavyjBG0D5sM+o8aKrngS
         gmmNcREgRh2MPSjA60ICVGr0N2G66g230+VXfqZ4m8y7QeVjVf+NB5gcvz50Ti9awr+y
         lg8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TZUTBE8JOO+dBwswBQU/UW48YDxWzcOqBKIIatUeRxg=;
        b=rtpI9Unm45IrX6GHJ32A73KgZUTHBXuByJTKBO3+A2GvT6xLpx/vDxNkkHn2VZ+RSo
         T6009zsOqom79UFdfVY9lC/9GSyFCCEB7Jvc7/9QQf/aLKf8iEekOjI+2cn/w3Md6MwV
         L2FyNHJAd/OUu8sQkG6rUM4RafOFbH/prvOHFVdWFAV+TZYO2qNQFAfj9GSacUub35Jm
         kR+CK+76LsW0BMcQ++Mf2VyktVpkMTrT4zE2z79zrQGSnVwD/0XAdOqoeUY+MNKOpiql
         lc+Riy8yc1sTQ0hQamw/yDviN+8E1qH6Ho5jYY+hyzWKPgzHhrAyRQqiinVkJI9ymV6U
         duNA==
X-Gm-Message-State: AJIora95pibKA1l3Z+2MrEWIAlDa3oCFEekfIoOFQO6PDUHxf8DnjbLF
        1yBkN4cEfKDJTrRS97aVR5uxmcrtPWapTgb8fLAeYpS81FPgjg==
X-Google-Smtp-Source: AGRyM1u0wBbNmMakHQBA/ZO0hGJZKUbnq/dnkUov8nPUnJv4Mrzha3OP1ESzVnpMYzPJIoYstMUH0d87QXPunDiWZNY=
X-Received: by 2002:a05:6512:3409:b0:489:c549:4693 with SMTP id
 i9-20020a056512340900b00489c5494693mr15228484lfr.26.1658185443502; Mon, 18
 Jul 2022 16:04:03 -0700 (PDT)
MIME-Version: 1.0
References: <20220717133759.8479-1-khalid.masum.92@gmail.com>
 <3ea0ea90-48bf-ce19-e014-9443d732e831@gmail.com> <CAABMjtHiet1_SRvLBhoNxeEh865rwtZCkb510JmFPkHFMd5chQ@mail.gmail.com>
In-Reply-To: <CAABMjtHiet1_SRvLBhoNxeEh865rwtZCkb510JmFPkHFMd5chQ@mail.gmail.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Mon, 18 Jul 2022 16:03:52 -0700
Message-ID: <CABBYNZJVv=pJv60P6fYZh65JU+BV5agGfXEh4VenxELEXqtDsA@mail.gmail.com>
Subject: Re: [PATCH] Bluetooth: hci_core: Use ERR_PTR instead of NULL
To:     Khalid Masum <khalid.masum.92@gmail.com>
Cc:     Pavel Skripkin <paskripkin@gmail.com>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Khalid,

On Sun, Jul 17, 2022 at 11:34 AM Khalid Masum <khalid.masum.92@gmail.com> wrote:
>
> On Sun, Jul 17, 2022 at 10:17 PM Pavel Skripkin <paskripkin@gmail.com> wrote:
> >
> > Hi Khalid,
> >
> > Khalid Masum <khalid.masum.92@gmail.com> says:
> > > Failure of kzalloc to allocate memory is not reported. Return Error
> > > pointer to ENOMEM if memory allocation fails. This will increase
> > > readability and will make the function easier to use in future.
> > >
> > > Signed-off-by: Khalid Masum <khalid.masum.92@gmail.com>
> > > ---
> >
> > [snip]
> >
> > > index a0f99baafd35..ea50767e02bf 100644
> > > --- a/net/bluetooth/hci_core.c
> > > +++ b/net/bluetooth/hci_core.c
> > > @@ -2419,7 +2419,7 @@ struct hci_dev *hci_alloc_dev_priv(int sizeof_priv)
> > >
> > >       hdev = kzalloc(alloc_size, GFP_KERNEL);
> > >       if (!hdev)
> > > -             return NULL;
> > > +             return ERR_PTR(-ENOMEM);
> > >
> >
> > This will break all callers of hci_alloc_dev(). All callers expect NULL
> > in case of an error, so you will leave them with wrong pointer.
>
> You are right. All callers of hci_alloc_dev() need to be able to handle
> the error pointer. I shall send a V2 with all the callers of hci_alloc_dev
> handling the ERR_PTR.
>
> > Also, allocation functionS return an error only in case of ENOMEM, so
> > initial code is fine, IMO
> >

If there just a single error like ENOMEM then Id say this is fine,
just as it is fine for kzalloc.

> I think it makes the memory allocation error handling look to be a bit
> different from what we usually do while allocating memory which is,
> returning an error or an error pointer. Here we are returning a NULL
> without any context, making it a bit unreadable. So I think returning
> an error pointer is better. If I am not mistaken, this also complies with
> the return convention:
> https://www.kernel.org/doc/htmldocs/kernel-hacking/convention-returns.html

Not sure if that would apply to code that is basically a wrapper of kzalloc.

> >
> > Thanks,
> > --Pavel Skripkin
>
>
> Thanks,
>   -- Khalid Masum



-- 
Luiz Augusto von Dentz
