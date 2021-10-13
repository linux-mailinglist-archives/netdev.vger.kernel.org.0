Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D3E542CDBB
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 00:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230302AbhJMWWV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 18:22:21 -0400
Received: from mail-ot1-f47.google.com ([209.85.210.47]:46635 "EHLO
        mail-ot1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229883AbhJMWWU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 18:22:20 -0400
Received: by mail-ot1-f47.google.com with SMTP id 62-20020a9d0a44000000b00552a6f8b804so5074538otg.13;
        Wed, 13 Oct 2021 15:20:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject:date
         :message-id;
        bh=FhOXFtc8ZlYBnjWzOjYeyQHYqTu5IoCFpXCxZaQspmE=;
        b=dtRZ1R7Ysu0fuCIJXP0TH+Ez7j8rSfmewmoroiDkdx4xV4c0HoBmhrZ4KzuKq/oyi5
         7KP2+IjA8Zi7Q4yXt2HuULJ7y3oygC1cUvxwDcVK8+9fdn5Mx+kfXQzFGojJY9BENajq
         /cmLEPD+AY6JSN/QSyEEdWs/aLvqySNauyHNMvPU/ecJ1JWSJT//JwH1OUsmV03AjmYx
         4utuMVuYXRpTLYOwhkqL4oAnql8TSF+up8fsWKB1/YzmQDzaoRq3FZ+svA5Az5vKwRX/
         3bDJYzztfgELq5Fd6dUWFsQfU/T9HUeqlK/XgdeSBWvhUwr3RO8lWsElr61PeCAXMKjD
         +bYA==
X-Gm-Message-State: AOAM533liy4jByb3u+OMLf1WudOxMhxPZHO+/ZGJJBD7QbiN1M50sq4p
        SO1YN31zwk4V6scwPTy7hQ==
X-Google-Smtp-Source: ABdhPJydOw1YpxZRK6382pJlZRPlydDrOZwi+9GWPDjDtOgrhoqlDG7enEBSQP1NRNAeC4kgpWuuAQ==
X-Received: by 2002:a05:6830:2329:: with SMTP id q9mr1639740otg.229.1634163616339;
        Wed, 13 Oct 2021 15:20:16 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id j8sm165915ooc.21.2021.10.13.15.20.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 15:20:15 -0700 (PDT)
Received: (nullmailer pid 1686439 invoked by uid 1000);
        Wed, 13 Oct 2021 22:20:14 -0000
From:   Rob Herring <robh@kernel.org>
To:     =?utf-8?q?Marek_Beh=C3=BAn?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>, pavel@ucw.cz,
        linux-leds@vger.kernel.org, devicetree@vger.kernel.org,
        robh+dt@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20211013204424.10961-2-kabel@kernel.org>
References: <20211013204424.10961-1-kabel@kernel.org> <20211013204424.10961-2-kabel@kernel.org>
Subject: Re: [PATCH 2/3] dt-bindings: leds: Add `excludes` property
Date:   Wed, 13 Oct 2021 17:20:14 -0500
Message-Id: <1634163614.994090.1686438.nullmailer@robh.at.kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 13 Oct 2021 22:44:23 +0200, Marek Behún wrote:
> Some RJ-45 connectors have LEDs wired in the following way:
> 
>          LED1
>       +--|>|--+
>       |       |
>   A---+--|<|--+---B
>          LED2
> 
> With + on A and - on B, LED1 is ON and LED2 is OFF. Inverting the
> polarity turns LED1 OFF and LED2 ON.
> 
> So these LEDs exclude each other.
> 
> Add new `excludes` property to the LED binding. The property is a
> phandle-array to all the other LEDs that are excluded by this LED.
> 
> Signed-off-by: Marek Behún <kabel@kernel.org>
> ---
>  Documentation/devicetree/bindings/leds/common.yaml | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:
./Documentation/devicetree/bindings/leds/common.yaml:66:7: [error] syntax error: could not find expected ':' (syntax)

dtschema/dtc warnings/errors:
make[1]: *** Deleting file 'Documentation/devicetree/bindings/leds/common.example.dts'
Traceback (most recent call last):
  File "/usr/local/bin/dt-extract-example", line 45, in <module>
    binding = yaml.load(open(args.yamlfile, encoding='utf-8').read())
  File "/usr/local/lib/python3.8/dist-packages/ruamel/yaml/main.py", line 434, in load
    return constructor.get_single_data()
  File "/usr/local/lib/python3.8/dist-packages/ruamel/yaml/constructor.py", line 120, in get_single_data
    node = self.composer.get_single_node()
  File "_ruamel_yaml.pyx", line 706, in _ruamel_yaml.CParser.get_single_node
  File "_ruamel_yaml.pyx", line 724, in _ruamel_yaml.CParser._compose_document
  File "_ruamel_yaml.pyx", line 775, in _ruamel_yaml.CParser._compose_node
  File "_ruamel_yaml.pyx", line 889, in _ruamel_yaml.CParser._compose_mapping_node
  File "_ruamel_yaml.pyx", line 775, in _ruamel_yaml.CParser._compose_node
  File "_ruamel_yaml.pyx", line 889, in _ruamel_yaml.CParser._compose_mapping_node
  File "_ruamel_yaml.pyx", line 775, in _ruamel_yaml.CParser._compose_node
  File "_ruamel_yaml.pyx", line 889, in _ruamel_yaml.CParser._compose_mapping_node
  File "_ruamel_yaml.pyx", line 775, in _ruamel_yaml.CParser._compose_node
  File "_ruamel_yaml.pyx", line 891, in _ruamel_yaml.CParser._compose_mapping_node
  File "_ruamel_yaml.pyx", line 904, in _ruamel_yaml.CParser._parse_next_event
ruamel.yaml.scanner.ScannerError: while scanning a simple key
  in "<unicode string>", line 65, column 7
could not find expected ':'
  in "<unicode string>", line 66, column 7
make[1]: *** [Documentation/devicetree/bindings/Makefile:20: Documentation/devicetree/bindings/leds/common.example.dts] Error 1
make[1]: *** Waiting for unfinished jobs....
schemas/leds/common.yaml: ignoring, error parsing file
schemas/leds/common.yaml: ignoring, error parsing file
./Documentation/devicetree/bindings/leds/common.yaml:  while scanning a simple key
  in "<unicode string>", line 65, column 7
could not find expected ':'
  in "<unicode string>", line 66, column 7
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/leds/common.yaml: ignoring, error parsing file
warning: no schema found in file: ./Documentation/devicetree/bindings/leds/common.yaml
make: *** [Makefile:1441: dt_binding_check] Error 2

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/patch/1540615

This check can fail if there are any dependencies. The base for a patch
series is generally the most recent rc1.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit.

