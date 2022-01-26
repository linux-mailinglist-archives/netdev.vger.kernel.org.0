Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B73B849C21F
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 04:29:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237200AbiAZD30 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 22:29:26 -0500
Received: from mail-oi1-f174.google.com ([209.85.167.174]:41763 "EHLO
        mail-oi1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230046AbiAZD3Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 22:29:25 -0500
Received: by mail-oi1-f174.google.com with SMTP id q186so35102280oih.8;
        Tue, 25 Jan 2022 19:29:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject:date
         :message-id;
        bh=DWroU9v+B0oJUaHbfVpIph6/oG0k3TQn8iAd7iCA4ZI=;
        b=k/7jRfyYAqmmDgpJIvbYKGZq6+CrXFubpkxbu2tJIQnEf5GzBNMAOL8/qnrvSdfQU1
         UqCiY12NkXWt9EKU9ACMqQ7ZZI1KbYx1BbehcxtibbfTs+CdCXGsqqY2fSyL4YLn1mHe
         JtzHC3L/JEqq/dmCyLc3CLriWlbev/Pq7ne1FUZEYT6c7z1TTHJlgC3Z8vzkBMhnEKbH
         9c024I4mBQU7O5lCm4UsCshDEgbS6AKWyoiufT89NQTAD6rSgi26sceTKyPAxPlEJDjh
         fnA8qjf6x27um9Gu8PioqlS11KuEZuPEHWBJzjWXWS1iQfoV5HWu2wC0thoIE1h3tfnr
         u2qg==
X-Gm-Message-State: AOAM532+y1YgrrTRzSKL+Ldwe+Nkrb6MDcgisqNJoxMuGJpcuKzpmhen
        awNdoMYH0QTem308WpVKQw==
X-Google-Smtp-Source: ABdhPJz0v3qCcz93L/KdRR5wO7FXg9UY5oeER2ADrIk1PCOqzkwXMlAYT9z1NgvpSBjcJoKGffRl5w==
X-Received: by 2002:a05:6808:150b:: with SMTP id u11mr536058oiw.211.1643167765208;
        Tue, 25 Jan 2022 19:29:25 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id w7sm6859202oou.13.2022.01.25.19.29.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 19:29:24 -0800 (PST)
Received: (nullmailer pid 3724358 invoked by uid 1000);
        Wed, 26 Jan 2022 03:29:18 -0000
From:   Rob Herring <robh@kernel.org>
To:     =?utf-8?b?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc:     Richard Weinberger <richard@nod.at>, Andrew Lunn <andrew@lunn.ch>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        Shawn Guo <shawnguo@kernel.org>, linux-mtd@lists.infradead.org,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Michael Walle <michael@walle.cc>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Frank Rowand <frowand.list@gmail.com>,
        =?utf-8?b?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Li Yang <leoyang.li@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
In-Reply-To: <20220125180114.12286-3-zajec5@gmail.com>
References: <20220125180114.12286-1-zajec5@gmail.com> <20220125180114.12286-3-zajec5@gmail.com>
Subject: Re: [PATCH 2/2] dt-bindings: nvmem: cells: add MAC address cell
Date:   Tue, 25 Jan 2022 21:29:18 -0600
Message-Id: <1643167758.854851.3724357.nullmailer@robh.at.kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 25 Jan 2022 19:01:14 +0100, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> This adds support for describing details of NVMEM cell containing MAC
> address. Those are often device specific and could be nicely stored in
> DT.
> 
> Initial documentation includes support for describing:
> 1. Cell data format (e.g. Broadcom's NVRAM uses ASCII to store MAC)
> 2. Reversed bytes flash (required for i.MX6/i.MX7 OCOTP support)
> 3. Source for multiple addresses (very common in home routers)
> 
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> ---
>  .../bindings/nvmem/cells/mac-address.yaml     | 94 +++++++++++++++++++
>  1 file changed, 94 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/nvmem/cells/mac-address.yaml
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:

dtschema/dtc warnings/errors:
schemas/nvmem/cells/cell.yaml: ignoring, error parsing file
make[1]: *** Deleting file 'Documentation/devicetree/bindings/nvmem/cells/mac-address.example.dt.yaml'
schemas/nvmem/cells/cell.yaml: ignoring, error parsing file
Traceback (most recent call last):
  File "/usr/local/bin/dt-validate", line 170, in <module>
    sg.check_trees(filename, testtree)
  File "/usr/local/bin/dt-validate", line 119, in check_trees
    self.check_subtree(dt, subtree, False, "/", "/", filename)
  File "/usr/local/bin/dt-validate", line 110, in check_subtree
    self.check_subtree(tree, value, disabled, name, fullname + name, filename)
  File "/usr/local/bin/dt-validate", line 110, in check_subtree
    self.check_subtree(tree, value, disabled, name, fullname + name, filename)
  File "/usr/local/bin/dt-validate", line 110, in check_subtree
    self.check_subtree(tree, value, disabled, name, fullname + name, filename)
  [Previous line repeated 1 more time]
  File "/usr/local/bin/dt-validate", line 105, in check_subtree
    self.check_node(tree, subtree, disabled, nodename, fullname, filename)
  File "/usr/local/bin/dt-validate", line 49, in check_node
    errors = sorted(dtschema.DTValidator(schema).iter_errors(node), key=lambda e: e.linecol)
  File "/usr/local/lib/python3.8/dist-packages/dtschema/lib.py", line 771, in iter_errors
    for error in super().iter_errors(instance, _schema):
  File "/usr/local/lib/python3.8/dist-packages/jsonschema/validators.py", line 229, in iter_errors
    for error in errors:
  File "/usr/local/lib/python3.8/dist-packages/jsonschema/_validators.py", line 362, in allOf
    yield from validator.descend(instance, subschema, schema_path=index)
  File "/usr/local/lib/python3.8/dist-packages/jsonschema/validators.py", line 245, in descend
    for error in self.evolve(schema=schema).iter_errors(instance):
  File "/usr/local/lib/python3.8/dist-packages/dtschema/lib.py", line 771, in iter_errors
    for error in super().iter_errors(instance, _schema):
  File "/usr/local/lib/python3.8/dist-packages/jsonschema/validators.py", line 229, in iter_errors
    for error in errors:
  File "/usr/local/lib/python3.8/dist-packages/jsonschema/_validators.py", line 298, in ref
    yield from validator.descend(instance, resolved)
  File "/usr/local/lib/python3.8/dist-packages/jsonschema/validators.py", line 245, in descend
    for error in self.evolve(schema=schema).iter_errors(instance):
  File "/usr/local/lib/python3.8/dist-packages/dtschema/lib.py", line 771, in iter_errors
    for error in super().iter_errors(instance, _schema):
  File "/usr/local/lib/python3.8/dist-packages/jsonschema/validators.py", line 219, in iter_errors
    scope = id_of(_schema)
  File "/usr/local/lib/python3.8/dist-packages/jsonschema/validators.py", line 96, in _id_of
    return schema.get("$id", "")
AttributeError: 'NoneType' object has no attribute 'get'
make[1]: *** [scripts/Makefile.lib:378: Documentation/devicetree/bindings/nvmem/cells/mac-address.example.dt.yaml] Error 1
make[1]: *** Waiting for unfinished jobs....
make: *** [Makefile:1398: dt_binding_check] Error 2

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/patch/1584227

This check can fail if there are any dependencies. The base for a patch
series is generally the most recent rc1.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit.

