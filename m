Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CC9F70F05
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 04:16:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729557AbfGWCQk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 22:16:40 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:42275 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726825AbfGWCQj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 22:16:39 -0400
Received: by mail-ed1-f66.google.com with SMTP id v15so42351266eds.9;
        Mon, 22 Jul 2019 19:16:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=0d1KOuIEFnf1KFCnr4djXsFhQxtzBMVUUZ05z+W/5jo=;
        b=fMxJbXGSICZlJtOwdqceWfojiNmjnRgT5K43L+Zm5AQhz/7xvxndUvQkWy3Hw5n2yC
         WnbX36qnW5HcnoafAekJ3rVs/H92XUHH8eM0dkSgfNS/6dEmXtPzRzWjPdAYGpipf/7w
         eB1zipAXEkUgnnxJtBd5/0X3bOZ4ZC8lnwoIBOiiCLT/ECjy4HA1Aj1T1OH7mfNLp7H0
         +kYqY3ojl3sTigxtk8gDlOuLOakd2zsB1ei5dfMJ2nfo4hZGjpTTWHo+a1dX4Pha5HUp
         WKD1rNoh00njvz9fQVmjM7HWtvUowpkMnQWxrOyqOG/rIZOb24qplrsXB9+WePQTIwFy
         OOSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=0d1KOuIEFnf1KFCnr4djXsFhQxtzBMVUUZ05z+W/5jo=;
        b=eo2PDrwwt+I5LsZBipDIJP6LXGhvBSFDC6NtfKNo/h1RAJWW3z3SpIJ+Ih4xfKIbKz
         eZKdZzO4H3mrCDiiRV2+hYxUno6fymUr76eABPogknf/CgXN4RfYDrQMp+1XY4qLoU65
         M4nR5FZxq0ZKgnSFdnY6bTAdGG6FhZP0p6itCWUpZ+TagpcagPu2o96kopkXtd9+Qpgk
         2zG5E+rFx5U3gAys9U561b1jGzOfrJ2R7E6Ex2i+2yocr21+Ru3/HNbL3ow1GCBLx6xg
         2DYtnimw1aqHOdKYhB5OZsvXRkorvZduzWqzRS8yql2X4ub6L+RWKBLNgD3H5tTVWEJj
         AAXA==
X-Gm-Message-State: APjAAAWcmEEDjjWlWJZ4xE2Z7QyEqnVwEZMySk07SRUZXOh7i8rbCC84
        58i0+A7sPjzN1l0jGaE5J1MlWBRnzImOP7CugrO4uFZrvzo=
X-Google-Smtp-Source: APXvYqy4q3AMNZbXBpqbDGc239s6nk2XqlT/lo3mXwgLbjbnfoME99u3vIkOa8SniVmPP8GMstUG/4SE0VABk101Q4E=
X-Received: by 2002:aa7:ca41:: with SMTP id j1mr64655205edt.149.1563848198072;
 Mon, 22 Jul 2019 19:16:38 -0700 (PDT)
MIME-Version: 1.0
References: <20190722074133.17777-1-hslester96@gmail.com> <20190722.182235.195933962601112626.davem@davemloft.net>
In-Reply-To: <20190722.182235.195933962601112626.davem@davemloft.net>
From:   Chuhong Yuan <hslester96@gmail.com>
Date:   Tue, 23 Jul 2019 10:16:27 +0800
Message-ID: <CANhBUQ0FMJATcjkb0RYyM8LhA92htq9mddLqcNB94FcxMBGsbg@mail.gmail.com>
Subject: Re: [PATCH] net: usb: Merge cpu_to_le32s + memcpy to put_unaligned_le32
To:     David Miller <davem@davemloft.net>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Miller <davem@davemloft.net> =E4=BA=8E2019=E5=B9=B47=E6=9C=8823=E6=97=
=A5=E5=91=A8=E4=BA=8C =E4=B8=8A=E5=8D=889:22=E5=86=99=E9=81=93=EF=BC=9A
>
> From: Chuhong Yuan <hslester96@gmail.com>
> Date: Mon, 22 Jul 2019 15:41:34 +0800
>
> > Merge the combo uses of cpu_to_le32s and memcpy.
> > Use put_unaligned_le32 instead.
> > This simplifies the code.
> >
> > Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
>
> Isn't the skb->data aligned to 4 bytes in these situations?
>
> If so, we should use the aligned variants.
>
> Thank you.

I have checked the five changed files.
I find that they all have used get_unaligned_le32 for skb->data
according to my previous applied patches and existing code.
So I think the skb->data is unaligned in these situations.

Usages of get_unaligned_le32:
asix_common.c: line 104 and 133
ax88179_178a.c: https://lkml.org/lkml/2019/7/19/652
lan78xx.c: https://lkml.org/lkml/2019/7/19/573
smsc75xx.c: https://lkml.org/lkml/2019/7/19/617
sr9800.c: line 73
