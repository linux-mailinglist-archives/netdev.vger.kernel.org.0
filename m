Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAA2142D6C3
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 12:06:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230192AbhJNKIQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 06:08:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:47382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230179AbhJNKIJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Oct 2021 06:08:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 26B856101E;
        Thu, 14 Oct 2021 10:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634205965;
        bh=/DwZK5Nqwyga0GMSWPMyT43TU7YWs7C3bgxh4CwgbEw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=m52fPtgtgnew0Aq0pgkU6z7LidydJ+7r294XdHXWQlpClh0dni+lhC7ORhqNG57Dn
         zqV8yIdYjoknBtZ/zrLVqm84podfu/tth4b35shx3G78BHpb5hkGtrYpz8y2yc3Hlu
         C0An/rlAg9obXIa7HhdO9yzxVARlgtnOBd4rbvQU++Oit8HpuehM1nleW5Qmfkl9oV
         0N0B/quQC4RHz6Fz7aUsb6WEsoTp0dWNvmty29qTjG2b7npsUR990bde5eBv74x7Bk
         3CUOYNKHFcj55v25yv+NVhTVgu0z8YhpLh6O8ZXm7ZZfDlzygq/0romtNUHRcGHgdd
         /jdO/m+Axe2nw==
Date:   Thu, 14 Oct 2021 12:06:01 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc:     robh+dt@kernel.org, devicetree@vger.kernel.org,
        U-Boot Mailing List <u-boot@lists.denx.de>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Luka Kovacic <luka.kovacic@sartura.hr>
Subject: Re: [PATCH RFC linux] dt-bindings: nvmem: Add binding for U-Boot
 environment NVMEM provider
Message-ID: <20211014120601.133e9a84@dellmb>
In-Reply-To: <629c8ba1-c924-565f-0b3c-8b625f4e5fb0@linaro.org>
References: <20211013232048.16559-1-kabel@kernel.org>
        <629c8ba1-c924-565f-0b3c-8b625f4e5fb0@linaro.org>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 Oct 2021 09:26:27 +0100
Srinivas Kandagatla <srinivas.kandagatla@linaro.org> wrote:

> On 14/10/2021 00:20, Marek Beh=C3=BAn wrote:
> > Add device tree bindings for U-Boot environment NVMEM provider.
> >=20
> > U-Boot environment can be stored at a specific offset of a MTD
> > device, EEPROM, MMC, NAND or SATA device, on an UBI volume, or in a
> > file on a filesystem.
> >=20
> > The environment can contain information such as device's MAC
> > address, which should be used by the ethernet controller node.
> >  =20
>=20
> Have you looked at=20
> ./Documentation/devicetree/bindings/mtd/partitions/nvmem-cells.yaml ?

Hello srini,

yes, I have. What about it? :)

That binding won't work for u-boot-env, because the data are stored
in a different way. A cell does not have a constant predetermined
offset on the MTD.
The variables are stored as a sequence of values of format
"name=3Dvalue", separated by '\0's, for example:
  board=3Dturris_mox\0ethaddr=3D00:11:22:33:44:55\0bootcmd=3Drun distro_boo=
tcmd\0....
Chaning lengths of values of variables, or deleting variables, moves
the data around. Integers and MAC addresses are stored as strings, and so o=
n.

Also the mtd/partitions/nvmem-cells.yaml doesn't take into account
u-boot-env stored on non-MTD devices.

Marek

 =20
