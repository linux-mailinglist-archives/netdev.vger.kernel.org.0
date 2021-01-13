Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D58AD2F41DD
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 03:37:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728233AbhAMCgc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 21:36:32 -0500
Received: from mail-ot1-f48.google.com ([209.85.210.48]:38421 "EHLO
        mail-ot1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726643AbhAMCga (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 21:36:30 -0500
Received: by mail-ot1-f48.google.com with SMTP id j20so545616otq.5;
        Tue, 12 Jan 2021 18:36:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject:date
         :message-id;
        bh=IoaJYJQmMhqV7U5ier1HCMp4QjhC1tvGvIPb2Gen7tg=;
        b=V7E8b+92T+gb88Y/i9aOf4Z+Wzce9hm1UFCkqNAn/Bh27/x1IHI34oc3beK5gnFC6a
         ru7z5Df/XpkxjUYeIfn9Bh0ixqsR7gz/t26mfzxFnJJx+yIAQmqsImAR+u1/oF1tBnni
         aUVQDC6+ZEGZWY5xfCpAhM3sMWA/20jwyE0nZvhDxSp7D2Gops2oqsZhsH21A6zTZVLo
         PeLoc7v1KyMgg7wBvxmDLTcxbhDYWcJYkY2YP5HVRMysdtnGSa+B1Xin7N9LJq0lnSqw
         fdTQAOE6mgMDI6V58sXs9skkc6mgps8NM7j1662akLC5DmVktegr2L3i0eYp2glMjT8l
         A7tQ==
X-Gm-Message-State: AOAM5326gocljNXL6PqUk+vK8Pkk7ZtNf1OuYXS3dPU03FoXY6/iL6ds
        rVbEP3b24iu/PAwlijsv1g==
X-Google-Smtp-Source: ABdhPJw0zTV8fgpAZ5s7JRVN2psSRfa0I5h450EhuMgt4UqvhiG9uaOc2A+i38rAx+iQ19/03odQlA==
X-Received: by 2002:a05:6830:1e41:: with SMTP id e1mr1556338otj.143.1610505349763;
        Tue, 12 Jan 2021 18:35:49 -0800 (PST)
Received: from robh.at.kernel.org (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id t24sm154492oij.7.2021.01.12.18.35.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jan 2021 18:35:49 -0800 (PST)
Received: (nullmailer pid 1401171 invoked by uid 1000);
        Wed, 13 Jan 2021 02:35:47 -0000
From:   Rob Herring <robh@kernel.org>
To:     Alex Elder <elder@linaro.org>
Cc:     linux-kernel@vger.kernel.org, cpratapa@codeaurora.org,
        robh+dt@kernel.org, kuba@kernel.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, davem@davemloft.net, evgreen@chromium.org,
        devicetree@vger.kernel.org, subashab@codeaurora.org,
        rdunlap@infradead.org
In-Reply-To: <20210112192831.686-3-elder@linaro.org>
References: <20210112192831.686-1-elder@linaro.org> <20210112192831.686-3-elder@linaro.org>
Subject: Re: [PATCH net-next 2/4] dt-bindings: net: remove modem-remoteproc property
Date:   Tue, 12 Jan 2021 20:35:47 -0600
Message-Id: <1610505347.887927.1401170.nullmailer@robh.at.kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 Jan 2021 13:28:29 -0600, Alex Elder wrote:
> The IPA driver uses the remoteproc SSR notifier now, rather than the
> temporary IPA notification system used initially.  As a result it no
> longer needs a property identifying the modem subsystem DT node.
> 
> Use GIC_SPI rather than 0 in the example interrupt definition.
> 
> Signed-off-by: Alex Elder <elder@linaro.org>
> ---
>  Documentation/devicetree/bindings/net/qcom,ipa.yaml | 13 ++-----------
>  1 file changed, 2 insertions(+), 11 deletions(-)
> 

My bot found errors running 'make dt_binding_check' on your patch:

yamllint warnings/errors:

dtschema/dtc warnings/errors:
Error: Documentation/devicetree/bindings/net/qcom,ipa.example.dts:49.46-47 syntax error
FATAL ERROR: Unable to parse input tree
make[1]: *** [scripts/Makefile.lib:344: Documentation/devicetree/bindings/net/qcom,ipa.example.dt.yaml] Error 1
make: *** [Makefile:1370: dt_binding_check] Error 2

See https://patchwork.ozlabs.org/patch/1425462

This check can fail if there are any dependencies. The base for a patch
series is generally the most recent rc1.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit.

