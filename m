Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54B593B6BF4
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 03:12:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231926AbhF2BPT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 21:15:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231947AbhF2BPS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 21:15:18 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79FC8C061760
        for <netdev@vger.kernel.org>; Mon, 28 Jun 2021 18:12:52 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id s129so21684351ybf.3
        for <netdev@vger.kernel.org>; Mon, 28 Jun 2021 18:12:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=x64architecture.com; s=x64;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=XZELwKnzE7fpkiE5xCwRnh5NXOHAYtfKC47iuP+cy6A=;
        b=uWGH7fASaMMc4dkOyl0xpNOVwQmODoA1JjJ3px5nxSpfd4jbpmT3et8kWHVTf/FGZX
         1v1D2p/ATQZw8Sa1D7TudfRC1J/GRz/1qN58dJAGHRUjzKPTLGqojOVQ0Ba++1qzivgV
         0eXIL3bu8oHOmbVE0DSy7SaU1tpat0sRPFZzgJGLUUT7bhaXtgpb2zY/c47cqND0qtkp
         FOLm1DxgGO0jbqppeLRp/VJSXJE+H6s7oNzwphYZLXS3xy3vM6HOs23p7PbXmvqcw2Ut
         aIs9B+U+iwASfUhCz0nxmRg/P1BoRNBhuFEMPqmUbR4tQOwt165f4LrMjpW4Hpx+qxjN
         tIoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=XZELwKnzE7fpkiE5xCwRnh5NXOHAYtfKC47iuP+cy6A=;
        b=GBJmTjTQto/05tuXq29EDyYNGbF+AqNMETQEav8t9CT2jwefbpyOs0TK626uJQiJuT
         eC0m4be8zwaYiG+wGXFO6F/aFnsPvuuSeMbLt9XClG4PcNgmOVa8kzAlTWL20qBujxbB
         UTfCx/w6SFAjKZVyiWHIOOUPB+qBqFWt12JdYO0Eus83c3oGsDpNE8MZ3yLoB3rj1CF2
         jg500Dcj8YdRwtvSpiXqZjcEGBzNd+WtvGYeC1gN3howvhsgkBpUEMVr9WhVOjhKzlW8
         pAg//yUoEgz9qrJi3ZTmsdyKyaCakSjrhYvT5o3Q51iS0/F1qwH7Hi1zk0SAQxuCmBq1
         wuGg==
X-Gm-Message-State: AOAM530SslAjF3Oek5Acg2OzTwCDXRenNB7TSJhnoMVRl09Y8NAXvozs
        nO7v2/l8HbW32MRfhyWdehNuXh1o/xeEH/1ln1eJgw==
X-Google-Smtp-Source: ABdhPJzI6xA5JpPNQDWPAJ9kLQhttR9GvOab1/luUtdkqOlbFLkHsb/qZQnfRG4Xe725vXOQV2oBv8qCtX9iAyzbWgg=
X-Received: by 2002:a25:6f82:: with SMTP id k124mr18731326ybc.24.1624929171692;
 Mon, 28 Jun 2021 18:12:51 -0700 (PDT)
MIME-Version: 1.0
References: <20210628192826.1855132-1-kurt@x64architecture.com>
 <20210628192826.1855132-2-kurt@x64architecture.com> <20210629004958.40f3b98c@thinkpad>
 <CADujJWWoWRyW3S+f3F_Zhq9H90QZ1W4eu=5dyad3DeMLHFp2TA@mail.gmail.com> <20210629022335.1d27efc9@thinkpad>
In-Reply-To: <20210629022335.1d27efc9@thinkpad>
From:   Kurt Cancemi <kurt@x64architecture.com>
Date:   Mon, 28 Jun 2021 21:12:41 -0400
Message-ID: <CADujJWXFFBUy9H3-w32uCYs_cJM5dBrWFzRg3x-Dq9+kki436g@mail.gmail.com>
Subject: Re: [PATCH 1/1] net: phy: marvell: Fixed handing of delays with plain
 RGMII interface
To:     =?UTF-8?B?TWFyZWsgQmVow7pu?= <kabel@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I am using drivers/net/ethernet/freescale/dpaa. This is a T2080 soc.

The following is where I added a dev_info statement for "phy_if", it
correctly returned -> PHY_INTERFACE_MODE_RGMII_ID.
https://github.com/torvalds/linux/blob/master/drivers/net/ethernet/freescal=
e/fman/mac.c#L774

I will clarify things better, I am using an almost verbatim device
tree "arch/powerpc/boot/dts/fsl/t2080rdb.dts" the only changes I made
are the following:

Doesn't Work (RX and TX errors on every packet):
--- t2080rdb.dts    2021-06-28 21:08:06.571758700 -0400
+++ t2080rdb-doesnt_work.dts    2021-06-28 21:08:10.704915200 -0400
@@ -68,7 +68,7 @@

         ethernet@e4000 {
             phy-handle =3D <&rgmii_phy1>;
-            phy-connection-type =3D "rgmii";
+            phy-connection-type =3D "rgmii-id";
         };

         ethernet@e6000 {

Works (Your suggestion):
--- t2080rdb.dts    2021-06-28 21:08:06.571758700 -0400
+++ t2080rdb-works.dts    2021-06-28 21:09:49.415971900 -0400
@@ -68,7 +68,7 @@

         ethernet@e4000 {
             phy-handle =3D <&rgmii_phy1>;
-            phy-connection-type =3D "rgmii";
+            phy-mode =3D "rgmii-id";
         };

         ethernet@e6000 {

On Mon, Jun 28, 2021 at 8:23 PM Marek Beh=C3=BAn <kabel@kernel.org> wrote:
>
> On Mon, 28 Jun 2021 19:09:49 -0400
> Kurt Cancemi <kurt@x64architecture.com> wrote:
>
> > I=E2=80=99m sorry if I proposed this wrong (I am new to the kernel mail=
ing list), I
> > acknowledge that this is probably not the way to fix the problem, I wan=
ted
> > to discuss why my fix is necessary. In the cover email I explained that=
 I
> > used (in the device tree) =E2=80=9Crgmii-id=E2=80=9D for the =E2=80=9Cp=
hy-connection-type=E2=80=9D and the
> > DPAA memac correctly reports that the PHY type is =E2=80=9CPHY_INTERFAC=
E_MODE_RGMII_ID=E2=80=9D
> > but without my patch the RX and TX delay flags are not set on the
> > underlying Marvell PHY and I receive RX and TX errors on every network
> > request. Maybe there is some type of incompatibility between the Freesc=
ale
> > DPAA1 Ethernet driver and the Marvell PHY?
>
> Which driver again?
>   drivers/net/ethernet/freescale/dpaa
> or
>   drivers/net/ethernet/freescale/dpaa2
> ?
