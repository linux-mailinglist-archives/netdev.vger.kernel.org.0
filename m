Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D68C322D79
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 16:28:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233101AbhBWP1E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 10:27:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232618AbhBWP1A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 10:27:00 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B576CC06178A
        for <netdev@vger.kernel.org>; Tue, 23 Feb 2021 07:26:16 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id h25so12681763eds.4
        for <netdev@vger.kernel.org>; Tue, 23 Feb 2021 07:26:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Twu7ok+oNZpsPN2HqMqBr09w2K/6OQ1r3T08bEWFeMg=;
        b=I4wa3kgMmxUQ8ga+/b8CAJi0YdRH8Lw8+vcnmb8wU29ijZn3JJraB+ZS3SMC+pDA6C
         W50RxfUddO0cLKlByA5E+Wj2wWt34UCmt/dW2Wbbxhzq2ecGtM3xY1BYlwlsfikgEJCO
         PzthzoO3ooqkJyQ6rMzGS9uA+GWP/ebUcoIzs/0Ib5zsnwgV5Pw8o5WVMCv5zbzIqnid
         fnpEqcLQQLJvLW99+hb3ZAYCkduBvbEmgg3KoSG0FCEJRaFUpJqhRGCo0ZrjX9HH3yzG
         kjIpWDU9pIE34n6N9pjw2d7uVAjpw6e7p7zzn36o/Qusnw6fxvqlel3VFEv8aWwYyxPW
         +R0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Twu7ok+oNZpsPN2HqMqBr09w2K/6OQ1r3T08bEWFeMg=;
        b=TNtvAHvW+o/gvvRCQ11kNPxYs9Edj80vAjDQv8qLdHBV+Fp+cprRERfGcSsBDFAxGE
         Oh6xSm3I8xUQR3BRj16TAMSZIVMLym60eIxIE31d7l80+G8VzklkfDsSOF0b1x/zqCd5
         E+Ndou1BSp5PKUw+/1GwoshHpfx+svIJyGPj0QrvZkqwcO4i7My5P7ESmKG0Oc/MpWv3
         ULdqtBbgea6avZRPi8b1u3i60m7J1Im0g2ZEkVfvZMmv9RaTIulpQ3/J7OWGHzbOyR2Z
         8byB3es3K2vGnSBomyF/YDXlQqS4kcipo/kgB4XRBcYFEDatwuiKN94cmiFCZ5P3UK15
         rHPQ==
X-Gm-Message-State: AOAM532XRoGsDcxxqSqfWSsIGm6QjZKd+mIsxX0g/JdB5ELr1LW/2FLJ
        dyqfvY/VGtc1LztalNnJJu0stqc7/hY=
X-Google-Smtp-Source: ABdhPJzG1xgzP78eZgXy29y6lhwG3PJxT4mZggfdZxomxyK+h+ShjIrPGaEHKMbzoLXlgUC7JylNpQ==
X-Received: by 2002:a05:6402:d09:: with SMTP id eb9mr28985962edb.285.1614093975180;
        Tue, 23 Feb 2021 07:26:15 -0800 (PST)
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com. [209.85.128.49])
        by smtp.gmail.com with ESMTPSA id v9sm12801282ejd.92.2021.02.23.07.26.14
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Feb 2021 07:26:14 -0800 (PST)
Received: by mail-wm1-f49.google.com with SMTP id k66so441542wmf.1
        for <netdev@vger.kernel.org>; Tue, 23 Feb 2021 07:26:14 -0800 (PST)
X-Received: by 2002:a7b:c5d6:: with SMTP id n22mr24892870wmk.70.1614093973847;
 Tue, 23 Feb 2021 07:26:13 -0800 (PST)
MIME-Version: 1.0
References: <6D39040C-4C5E-4CF1-8594-221F0BB38E3E@purdue.edu>
In-Reply-To: <6D39040C-4C5E-4CF1-8594-221F0BB38E3E@purdue.edu>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 23 Feb 2021 10:25:36 -0500
X-Gmail-Original-Message-ID: <CA+FuTSc0FRPJZubXrvojzNP9MvTp3rfJeH2zOQbETCNV80oOcA@mail.gmail.com>
Message-ID: <CA+FuTSc0FRPJZubXrvojzNP9MvTp3rfJeH2zOQbETCNV80oOcA@mail.gmail.com>
Subject: Re: Data race on dev->mtu betwen __dev_set_mtu() and rawv6_send_hdrinc()
To:     "Gong, Sishuai" <sishuai@purdue.edu>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>,
        "dsahern@kernel.org" <dsahern@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 22, 2021 at 6:30 PM Gong, Sishuai <sishuai@purdue.edu> wrote:
>
> Hello,
>
> We found a data race on dev->mtu between function __dev_set_mtu() and raw=
v6_send_hdrinc(). It happens with the following interleaving.
>
> writer: __dev_set_mtu()                                                  =
                       reader: rawv6_send_hdrinc()
>                                                                          =
                                       if (length > rt->dst.dev->mtu) {
>         WRITE_ONCE(dev->mtu, new_mtu);
>                                                                          =
                                               ipv6_local_error(sk, EMSGSIZ=
E, fl6, rt->dst.dev->mtu);
>
> If the writer happens to change dev->mtu to a value that is bigger than t=
he variable =E2=80=98length=E2=80=99, then ipv6_local_error will read a val=
ue that doesn=E2=80=99t satisfy this conditional statement. While there is =
no need to use lock to protect the read, it is probably better to only read=
 dev->mtu once in rawv6_send_hdrinc().

Makes sense. The same would then apply to raw_send_hdrinc().
