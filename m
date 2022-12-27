Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32A3F6567BB
	for <lists+netdev@lfdr.de>; Tue, 27 Dec 2022 08:14:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbiL0HOF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Dec 2022 02:14:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229719AbiL0HOE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Dec 2022 02:14:04 -0500
Received: from mail-vs1-xe30.google.com (mail-vs1-xe30.google.com [IPv6:2607:f8b0:4864:20::e30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C668A639C
        for <netdev@vger.kernel.org>; Mon, 26 Dec 2022 23:14:00 -0800 (PST)
Received: by mail-vs1-xe30.google.com with SMTP id m2so11898200vsv.9
        for <netdev@vger.kernel.org>; Mon, 26 Dec 2022 23:14:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=igel-co-jp.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+KQfd0qQa24pmN4jbSpJWNWeqDqVNRsi5GfHHVHb10I=;
        b=JnDgLgH3KEZYTTFz2OogWOc6UzxCg8sWVfEVHFghkWlpxlqZqelxy06X6jxl+1Qu4U
         5XbZ9CYTNySXfjx+Auz3LO7ziUDzSgOCEbwfyVWxcBj6aHAVy30eyInCPVqdjrDhDv5D
         azzjNfXtFa5kF8SmRD+zMOl+khoViUXeCmhNAe9I72Wjdi9Ui5C8X9geF1uK+l4iH7Yk
         3fd4ZsS+OZBcYdUAkNiCfqhm0ZUf8J05J/Y34snl9SUh4i+9ws7mgvc5B0ot+dCwyb9z
         atFV+c2Hn+RKPH8wgEI+ZMKfo6h7s7HJ5APo3ZeAwVy6CrblZf3x2fXCkVo+ZEQH/TBJ
         Ytuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+KQfd0qQa24pmN4jbSpJWNWeqDqVNRsi5GfHHVHb10I=;
        b=ufxq3yPACbhhc8TZsGooF+1B6Jx11LQwR6mC4qWiOOqO2PS2HUqwcjS0DzrodRlvtF
         amJmi2llqIja1IxKclYwGtqrIvCH5Wq+TzDzFYXouva4z0Gri7PwRHHDDUvFI4QnTYh1
         9+J95nYD4HunaXbWr0L+wheWomy0PPIsAa4aIqbxRqggS6dMbsg6epWkZ/ZKBz4MbVu7
         iNZIZEa08nsv+QNFzPmuF8dpUJzO7L0v1XpNacNHTbFkyRvGwNIjEiOm5fkzmp2TPOmu
         tNZqPrw0dcE73H/2Tad289PT8oEjkBVdhQEf2VlZp4UvjV48GuevuFOZmCj+t8zrzDOj
         29oQ==
X-Gm-Message-State: AFqh2koALra0lJcIOIq1vnSHkH3F2TeLThww3ASSnJLu0ZaVEdtJJ38C
        6W6VLH/QJiKhFBSBRfL4oTCEgeRdA4GnK4LDYxgIhA==
X-Google-Smtp-Source: AMrXdXveVEzfaCgCX7ll10/TckFbSv+JK5mIYKf8aCht+1Noe74CJXwAERw1BZvxxJVNWvLE//EQJd/v6X6NLOza8Yc=
X-Received: by 2002:a05:6102:14a7:b0:3b5:1126:2b62 with SMTP id
 d39-20020a05610214a700b003b511262b62mr2182450vsv.51.1672125239853; Mon, 26
 Dec 2022 23:13:59 -0800 (PST)
MIME-Version: 1.0
References: <20221227022528.609839-1-mie@igel.co.jp> <20221227022528.609839-3-mie@igel.co.jp>
 <CACGkMEtAaYpuZtS0gx_m931nFzcvqSNK9BhvUZH_tZXTzjgQCg@mail.gmail.com> <20221227020425-mutt-send-email-mst@kernel.org>
In-Reply-To: <20221227020425-mutt-send-email-mst@kernel.org>
From:   Shunsuke Mie <mie@igel.co.jp>
Date:   Tue, 27 Dec 2022 16:13:49 +0900
Message-ID: <CANXvt5pXkS=TTOU0+Lkx6CjcV7xvDHRS6FbFikJ4Ww8832sg8g@mail.gmail.com>
Subject: Re: [RFC PATCH 2/9] vringh: remove vringh_iov and unite to vringh_kiov
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2022=E5=B9=B412=E6=9C=8827=E6=97=A5(=E7=81=AB) 16:05 Michael S. Tsirkin <ms=
t@redhat.com>:
>
> On Tue, Dec 27, 2022 at 02:04:03PM +0800, Jason Wang wrote:
> > On Tue, Dec 27, 2022 at 10:25 AM Shunsuke Mie <mie@igel.co.jp> wrote:
> > >
> > > struct vringh_iov is defined to hold userland addresses. However, to =
use
> > > common function, __vring_iov, finally the vringh_iov converts to the
> > > vringh_kiov with simple cast. It includes compile time check code to =
make
> > > sure it can be cast correctly.
> > >
> > > To simplify the code, this patch removes the struct vringh_iov and un=
ifies
> > > APIs to struct vringh_kiov.
> > >
> > > Signed-off-by: Shunsuke Mie <mie@igel.co.jp>
> >
> > While at this, I wonder if we need to go further, that is, switch to
> > using an iov iterator instead of a vringh customized one.
> >
> > Thanks
>
> Possibly, but when doing changes like this one needs to be careful
> to avoid breaking all the inlining tricks vringh relies on for
> performance.
Definitely, I'm evaluating the performance using vringh_test. I'll add a
result of the evaluation. But, If there are other evaluation methods, could=
 you
please tell me?
> --
> MST
>

Best,
Shunsuke
