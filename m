Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C4A24E8346
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 19:26:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233500AbiCZS2Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Mar 2022 14:28:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiCZS2P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Mar 2022 14:28:15 -0400
Received: from mail-vs1-xe29.google.com (mail-vs1-xe29.google.com [IPv6:2607:f8b0:4864:20::e29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E70E24B5C8;
        Sat, 26 Mar 2022 11:26:38 -0700 (PDT)
Received: by mail-vs1-xe29.google.com with SMTP id i186so11648684vsc.9;
        Sat, 26 Mar 2022 11:26:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bPdZKpF/7DB7Dp8qO6KWdHrNRbjjcPEd6Sgqv72R038=;
        b=lOkQfnewJc94Knoqhdw0SOgQA/6x3qfxQFFd9qR05QCV2VKUH42F+lKc9hZ2c/3JVz
         t3bhgAvA7EVf4KygZu5ETopk1qAyfPkCV2Ehi+J33L1kO78AUNKKEBOCM9YhTHGot2hE
         TT9MOQ+9Clkbtwu27PVHCEx5yuQsrKqPLCVMrIGxTOVmLocragD+E2JgPGzIR/aqUk4v
         Sry8HegBbfR5238TcL6wn2EkVE1qhgXpIO7ne1LvLJHDki70RyS00pzmVEjYEpVPtrkJ
         Ya+Xc+Uzu/N38mUIzez/If2yRPicuWx3FHNho1K5a7BbeXeELLcAww1aHFVPfvSbRfuZ
         X3kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bPdZKpF/7DB7Dp8qO6KWdHrNRbjjcPEd6Sgqv72R038=;
        b=XmReY46RFjWx9Hn6BzehgaNG+NX6F9ToxnznSIB0sRrEKx9SEqiBOlmdIRsuMNY52h
         kGJKZNyUDd9kFkU0wqds8TgPYC/merV2A5UDVrs2rHk/oZxBCjUxd8hF0eOXfIwJDC7/
         zHBsqUw+zOpukoyrvhOwrFwjkJGZE4S5LXFV4+6lLPfvP9+JX9JVNnpH4PY2ulULo350
         BkGdVRGA/2en6PBqAdhCXmgYZYuW+y/54hP6NP2D1/+L1/9v3KAGzhi2hSIG5uuKxiYF
         qT4l7bo4RN+BM8+9qU6jBzoFJjCimDLstP+L7Pu9hmrEOTPtQesmj/ID1gx3rQ0WDHq5
         RuSA==
X-Gm-Message-State: AOAM532ewOfHnbH6ONifqVnWMFstC18XjvvaHJN9guJ2WORoTNbzgE+/
        mOwwMYIXMsSzx5XFV0m1M+UO5EayFXXv0CbxITU=
X-Google-Smtp-Source: ABdhPJzhzQCqddgnUn90/XrUTxZda3K4kDITtog9Fk94pe+bEul2V8Xc+BjxfLfkKzQr0gIgMl/BFA7lmoTQl8hZUUY=
X-Received: by 2002:a05:6102:2339:b0:325:880f:62f5 with SMTP id
 b25-20020a056102233900b00325880f62f5mr1088285vsa.36.1648319197718; Sat, 26
 Mar 2022 11:26:37 -0700 (PDT)
MIME-Version: 1.0
References: <CAAZOf27PHWxdZifZpQYfTHb3h=qk22jRc6-A2LvBkLTR6xNOKg@mail.gmail.com>
 <CAAZOf24Gux0bfS-QGgjcd93NpcpxeA5xU5n2k+EhhyphJo-Mmg@mail.gmail.com> <59034997-46f4-697d-3620-7897db7fb97d@gmail.com>
In-Reply-To: <59034997-46f4-697d-3620-7897db7fb97d@gmail.com>
From:   David Kahurani <k.kahurani@gmail.com>
Date:   Sat, 26 Mar 2022 21:26:26 +0300
Message-ID: <CAAZOf25uFOf=Edz2fEU6ecjPi2QYRimx6dKRuOOGDhd1eAwh8A@mail.gmail.com>
Subject: Re: [syzbot] KMSAN: uninit-value in ax88179_led_setting
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     davem@davemloft.net, jgg@ziepe.ca, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, Phillip Potter <phil@philpotter.co.uk>,
        syzkaller-bugs@googlegroups.com,
        syzbot+d3dbdf31fbe9d8f5f311@syzkaller.appspotmail.com,
        arnd@arndb.de
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

On Sat, Mar 26, 2022 at 3:43 PM Pavel Skripkin <paskripkin@gmail.com> wrote:
>
> Hi David,
>
> On 3/26/22 14:47, David Kahurani wrote:
> >>
> >> Signed-off-by: David Kahurani <k.kahurani@gmail.com>
> >> Reported-by: syzbot+d3dbdf31fbe9d8f5f311@syzkaller.appspotmail.com
> >> ---
> >>  drivers/net/usb/ax88179_178a.c | 181 +++++++++++++++++++++++++++------
> >>  1 file changed, 152 insertions(+), 29 deletions(-)
> >>
> >> diff --git a/drivers/net/usb/ax88179_178a.c b/drivers/net/usb/ax88179_178a.c
> >> index a31098981..932e21a65 100644
> >> --- a/drivers/net/usb/ax88179_178a.c
> >> +++ b/drivers/net/usb/ax88179_178a.c
> >> @@ -224,9 +224,12 @@ static int __ax88179_write_cmd(struct usbnet *dev, u8 cmd, u16 value, u16 index,
> >>   ret = fn(dev, cmd, USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
> >>   value, index, data, size);
> >>
>

Yes, this breaks the logic of the entire patch. It was a mistake. Will
fix that alongside your other comments.

> You've changed __ax88179_write_cmd(), but not __ax88179_read_cmd(). I've
> missed it. Changing  __ax88179_write_cmd() does not help with uninit
> value bugs
>
> Also I believe, __ax88179_read_cmd() should have __must_check annotation
> too, since problem came from it in the first place (I mean after added
> sane error handling inside it)
>
> Next thing is ax88179_read_cmd_nopm() still prone to uninit value bugs,
> since it touches uninitialized `buf` in case of __ax88179_read_cmd()
> error...
>
>
>
> I remembered why I gave up on fixing this driver... I hope, you have
> more free time and motivation :)
>
>
>
>
> With regards,
> Pavel Skripkin
