Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14E2342DBF2
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 16:42:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231665AbhJNOoh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 10:44:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:35760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231286AbhJNOog (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Oct 2021 10:44:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C31EB60E96;
        Thu, 14 Oct 2021 14:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634222551;
        bh=fdhTS66TOVDzx8KtquiTV6pJu0VSd2p4ZibtwFJ6e5Q=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=AvOkMWb9LYqhw0j4orEhtR1txAXUInuvW633fDb+TQVhvDHap03TwlMBh2qeczBmX
         Ri+keFSGIkgXFSdIzu6bwT8ZDurmK6KCVzLEjuLcxdwApgHUZQviQ5UyEsWYYUuTvf
         4/usieL7klqmsowMa325ng3gVEAMlO5pCe5Fs9goSAZznNIBp52U193iFhgmzdpTZJ
         WyMhMx1XpcRsNzqv9nWptrCchbmNa/kDub7PYlE/CkawK2hc5GCBIhgEBUL0/yyVGS
         cZhLEpbgKIo7SxLlq1/WdGAVn3kv3DQHLa/xXplOKagpwkIv5mD7iXmgujx2tbmIYS
         YSLqxysJQf+ww==
Received: by mail-ed1-f52.google.com with SMTP id y12so26134968eda.4;
        Thu, 14 Oct 2021 07:42:31 -0700 (PDT)
X-Gm-Message-State: AOAM533nsQioKLxtF0k8k2P44gskUAIlJVMaHiJMoh74/y9878eh1tSK
        Ezt1KaUX3t3S92HBSb65Jg1N70AIRs3IdbzKOQ==
X-Google-Smtp-Source: ABdhPJxM5Uhcff7BCaGJHmbmB9JXZvWTU1yQyXDETewwjg/h9UtviGQRmtNS9N8T6a/ID0xDkhc7i4+bv61tRY4XgNk=
X-Received: by 2002:a17:906:9399:: with SMTP id l25mr4245067ejx.363.1634222517021;
 Thu, 14 Oct 2021 07:41:57 -0700 (PDT)
MIME-Version: 1.0
References: <20211013232048.16559-1-kabel@kernel.org>
In-Reply-To: <20211013232048.16559-1-kabel@kernel.org>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Thu, 14 Oct 2021 09:41:44 -0500
X-Gmail-Original-Message-ID: <CAL_JsqJZC0G_SGfuK0zg8n+uPm5b1L44fo8axUbpvAAZ2b8tAQ@mail.gmail.com>
Message-ID: <CAL_JsqJZC0G_SGfuK0zg8n+uPm5b1L44fo8axUbpvAAZ2b8tAQ@mail.gmail.com>
Subject: Re: [PATCH RFC linux] dt-bindings: nvmem: Add binding for U-Boot
 environment NVMEM provider
To:     =?UTF-8?B?TWFyZWsgQmVow7pu?= <kabel@kernel.org>
Cc:     devicetree@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        U-Boot Mailing List <u-boot@lists.denx.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Luka Kovacic <luka.kovacic@sartura.hr>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 13, 2021 at 6:20 PM Marek Beh=C3=BAn <kabel@kernel.org> wrote:
>
> Add device tree bindings for U-Boot environment NVMEM provider.
>
> U-Boot environment can be stored at a specific offset of a MTD device,
> EEPROM, MMC, NAND or SATA device, on an UBI volume, or in a file on a
> filesystem.
>
> The environment can contain information such as device's MAC address,
> which should be used by the ethernet controller node.
>
> Signed-off-by: Marek Beh=C3=BAn <kabel@kernel.org>
> ---
>  .../bindings/nvmem/denx,u-boot-env.yaml       | 88 +++++++++++++++++++
>  include/dt-bindings/nvmem/u-boot-env.h        | 18 ++++
>  2 files changed, 106 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/nvmem/denx,u-boot-e=
nv.yaml
>  create mode 100644 include/dt-bindings/nvmem/u-boot-env.h
>
> diff --git a/Documentation/devicetree/bindings/nvmem/denx,u-boot-env.yaml=
 b/Documentation/devicetree/bindings/nvmem/denx,u-boot-env.yaml
> new file mode 100644
> index 000000000000..56505c08e622
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/nvmem/denx,u-boot-env.yaml
> @@ -0,0 +1,88 @@
> +# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/nvmem/denx,u-boot-env.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: U-Boot environment NVMEM Device Tree Bindings
> +
> +maintainers:
> +  - Marek Beh=C3=BAn <kabel@kernel.org>
> +
> +description:
> +  This binding represents U-Boot's environment NVMEM settings which can =
be
> +  stored on a specific offset of an EEPROM, MMC, NAND or SATA device, or
> +  an UBI volume, or in a file on a filesystem.
> +
> +properties:
> +  compatible:
> +    const: denx,u-boot-env

'u-boot' is a vendor prefix. Unless you are saying Denx owns u-boot...

> +
> +  path:
> +    description:
> +      The path to the file containing the environment if on a filesystem=
.
> +    $ref: /schemas/types.yaml#/definitions/string
> +
> +patternProperties:
> +  "^[^=3D]+$":
> +    type: object
> +
> +    description:
> +      This node represents one U-Boot environment variable, which is als=
o one
> +      NVMEM data cell.
> +
> +    properties:
> +      name:

'name' is already a property for every node, so this would collide. It
used to be in the dtb itself, but current revisions generate it from
the node name.

> +        description:
> +          If the variable name contains characters not allowed in device=
 tree node
> +          name, use this property to specify the name, otherwise the var=
iable name
> +          is equal to node name.
> +        $ref: /schemas/types.yaml#/definitions/string
> +
> +      type:

'type' is really too generic. Any given property name should have 1
meaning and data type.

But I expect based on other comments already, all this is going away anyway=
s.

> +        description:
> +          Type of the variable. Since variables, even integers and MAC a=
ddresses,
> +          are stored as strings in U-Boot environment, for proper conver=
sion the
> +          type needs to be specified. Use one of the U_BOOT_ENV_TYPE_* p=
refixed
> +          definitions from include/dt-bindings/nvmem/u-boot-env.h.
> +        $ref: /schemas/types.yaml#/definitions/uint32
> +        minimum: 0
> +        maximum: 5
