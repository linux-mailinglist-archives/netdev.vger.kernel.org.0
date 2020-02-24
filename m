Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC7316A032
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 09:38:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727426AbgBXIii (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 03:38:38 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:42361 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726216AbgBXIii (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 03:38:38 -0500
Received: by mail-qk1-f196.google.com with SMTP id o28so7988776qkj.9
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 00:38:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=oDOHsVBllGLqzPGxFKFlfVXiTsWDTxesE0vuR1/hyrQ=;
        b=AaeBJj5BzViS7CnZaS7cDZn98qibPevI8sJ2Fr8x1H8QSZtnf5irt56hIilIeya8R3
         Ak3+d4zf7JPjxt5Ae0ShCLpdcvcJr+4DTWYl/S6VbQ4+l51evya/G24Rk998XQTiwzxk
         yxmLvJ9nCHUn3pQ0XbuzjEyIy6dgNkFPg30VMQTj+K5cSogGnvT87QsIc9o8yVG+0flf
         n00lBAcWBxOaqP5cpCGrpBCw8RZ5+JwbAeMY6Dd3GMstkQW3fAV1jsUgrhYFbT6vN1Kj
         ahi2EBazoAM3KVxT80oU7+BoQY4WQ62+qQ/s/Un6vuXWOmJalIuz3V84gbokoxU6L1ae
         Rc1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=oDOHsVBllGLqzPGxFKFlfVXiTsWDTxesE0vuR1/hyrQ=;
        b=dh2CxfoVLGSwr76EGqN3DhvqajY+jqnf8A6xBRuem3qaJvh1eScPb/wKm/dcoPhMII
         21G/Eo2w63NVqDZWQS8oAdt8CH8WJrf/FrBZ5wxLYUJS5rlGwZza5J1B+AeS3S4zaDX7
         EPKdwXZQaJ+lcZINRph604TvxH1/tlz/6ZTUu9bug+OuQFkngTyYJsafkQ174I8KAqXe
         n8WqNWhLPCkd1byv2gceYeDG2fVkltMGmSLMUcoflMfGbfVdZN4gxSDG9928z1VVvVMW
         W3arPMsuwwvu1SnnRsbPZ90SdR+ULQPHUqWqzU5MBURw6XK42EYDbgYyjrg8qpp1AWLA
         aYrA==
X-Gm-Message-State: APjAAAVC16/GMhOP5BNxMpsXTsRrTwB6imsMXmJ+Yd96m7hhK3r8I43G
        wxk7FzHHxZqHMEaiUetdasMt4u7dFpQhwkWhlzPQEwGBakE=
X-Google-Smtp-Source: APXvYqzvp4yiCGy0vtYQyqTNEOog+Ws+lAj3WZIhdFaudL3LYvN3JFeOriQtymtbXSbnt4i8q4j+1JXgVJZMjTha6r4=
X-Received: by 2002:a37:6343:: with SMTP id x64mr30515652qkb.469.1582533516842;
 Mon, 24 Feb 2020 00:38:36 -0800 (PST)
MIME-Version: 1.0
References: <20200221131705.26053-1-dnlplm@gmail.com> <87eeul5sm4.fsf@miraculix.mork.no>
In-Reply-To: <87eeul5sm4.fsf@miraculix.mork.no>
From:   Daniele Palmas <dnlplm@gmail.com>
Date:   Mon, 24 Feb 2020 09:38:25 +0100
Message-ID: <CAGRyCJFj--vTTiJcQ2L3WjXYmu-Xkbyx=4Mfy+xoY0+zZK1eLg@mail.gmail.com>
Subject: Re: [PATCH 1/1] net: usb: qmi_wwan: restore mtu min/max values after
 raw_ip switch
To:     =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Il giorno dom 23 feb 2020 alle ore 14:41 Bj=C3=B8rn Mork <bjorn@mork.no> ha=
 scritto:
>
> Daniele Palmas <dnlplm@gmail.com> writes:
>
> > usbnet creates network interfaces with min_mtu =3D 0 and
> > max_mtu =3D ETH_MAX_MTU.
> >
> > These values are not modified by qmi_wwan when the network interface
> > is created initially, allowing, for example, to set mtu greater than 15=
00.
> >
> > When a raw_ip switch is done (raw_ip set to 'Y', then set to 'N') the m=
tu
> > values for the network interface are set through ether_setup, with
> > min_mtu =3D ETH_MIN_MTU and max_mtu =3D ETH_DATA_LEN, not allowing anym=
ore to
> > set mtu greater than 1500 (error: mtu greater than device maximum).
> >
> > The patch restores the original min/max mtu values set by usbnet after =
a
> > raw_ip switch.
> >
> > Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
>
> Great! I tried to look up the origin of this bug, and it seems to be a
> hard-to-spot fallout from the 'centralized MTU checking'.  Not easy to
> see the hidden connection in usbnet.c and eth.c. Thanks for finding and
> fixing it!
>
> This should probably go to stable as well?
>

Yes, I think it won't hurt.

Thanks,
Daniele

> Acked-by: Bj=C3=B8rn Mork <bjorn@mork.no>
