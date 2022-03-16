Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A48104DB712
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 18:24:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353053AbiCPR0D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 13:26:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350605AbiCPR0C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 13:26:02 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11873AE4E
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 10:24:48 -0700 (PDT)
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id A07753F1FC
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 17:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1647451486;
        bh=DFWkk+dD+miD1tAhLV++xP/XlZBQMQ7X6zFsvz7Q3qs=;
        h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
         In-Reply-To:Content-Type;
        b=rdLd0i7EOiwNv4y+CkRUDFmygq1HZH3twJalOTOytHjUVDhI+W5Nw6XWtSy+8WX+a
         ycHQdNjZEB6jCVJ/oe91rP0TGDAC05anIJT9EigNou4smDzwcA/cLMq4dqq1DX6q6B
         aEQNCsRIoKMWA7925bP+Tx2kEyod+VE038BTsU1/98yHKI7YicbD593bvJzGpKxqku
         8qJdKAgDByfyGJ4ht++5QQD7MoObkkWUDiQsUNI0yBKbAfGEBfBFFli7QJ7s7ZB1Q0
         vEm1KZ52W2MXz023X04MMSA575Gyngn4HkAgEQpmm2eBAXDsK6xGme8fE9t3nV4KU8
         rpbpdzYXZabyg==
Received: by mail-wm1-f71.google.com with SMTP id 2-20020a1c0202000000b0038c71e8c49cso794793wmc.1
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 10:24:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=DFWkk+dD+miD1tAhLV++xP/XlZBQMQ7X6zFsvz7Q3qs=;
        b=RE/Qg5PSgniLB1TDyaU92Pl/WNrJWVvnse9ViAZPRrrcalV0ICN78B1+RtlGCXbTbJ
         aPYsTe87NJ7OOduK0nntJLzEuA9rSdToctHlg/9ZtVEko8CqYnNhGr7qdxNnnsDtTPlD
         vhEvFqKOVaUSUvyKLF35hL6fUo3LIKeHs9oPmVsBbognWIreiq/C0Vvc5EPXjjo2L3QT
         WFv5vpQzD2Kdjce88K9uAMfBEpz7ItwGP9r6GMuIsJs0dhcPg03Zlhz45Irxpfr9aU7E
         jQH92y7aIB6mSzZpav7lzUVXdDzWvgCAvM5OXkZwTHEIWI3BopgpRGB7eLBnRlaPlmLQ
         M1hQ==
X-Gm-Message-State: AOAM5338wHrkSdFjj25VxDgXY1KUmZdT/wTR3Pvfr1ytxSSttWbnkLTx
        h2QSZC4dfyye50KSe/LOg8euM/BQLglWXX9PJRnPLTe4UKi9ZBt/gSrusxLgS0GYdosnjvYsQZt
        CBl/tguBX/gcRFQhF0hG8nsCBZcH7T41/Pw==
X-Received: by 2002:a5d:5308:0:b0:1f0:6300:f1d0 with SMTP id e8-20020a5d5308000000b001f06300f1d0mr807660wrv.278.1647451486351;
        Wed, 16 Mar 2022 10:24:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyKIDxRFk6Y7FutZOGNJm0wMC59ZyrwAOZDtuOajZo3/h8b2cFROj96IpV5T4Wa6hFneoX2Jw==
X-Received: by 2002:a5d:5308:0:b0:1f0:6300:f1d0 with SMTP id e8-20020a5d5308000000b001f06300f1d0mr807651wrv.278.1647451486124;
        Wed, 16 Mar 2022 10:24:46 -0700 (PDT)
Received: from [192.168.0.17] (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.googlemail.com with ESMTPSA id p12-20020a5d48cc000000b001e6114938a8sm2111015wrs.56.2022.03.16.10.24.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Mar 2022 10:24:45 -0700 (PDT)
Message-ID: <6490a3e5-04c8-535a-7c29-de7ca9bc8f1e@canonical.com>
Date:   Wed, 16 Mar 2022 18:24:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v4] dt-bindings: can: xilinx_can: Convert Xilinx CAN
 binding to YAML
Content-Language: en-US
To:     Amit Kumar Mahapatra <amit.kumar-mahapatra@xilinx.com>,
        wg@grandegger.com, mkl@pengutronix.de, davem@davemloft.net,
        kuba@kernel.org, robh+dt@kernel.org, appana.durga.rao@xilinx.com
Cc:     git@xilinx.com, michal.simek@xilinx.com, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        akumarma@xilinx.com
References: <20220316171105.17654-1-amit.kumar-mahapatra@xilinx.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
In-Reply-To: <20220316171105.17654-1-amit.kumar-mahapatra@xilinx.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16/03/2022 18:11, Amit Kumar Mahapatra wrote:
> Convert Xilinx CAN binding documentation to YAML.
> 
> Signed-off-by: Amit Kumar Mahapatra <amit.kumar-mahapatra@xilinx.com>
> ---
> BRANCH: yaml
> 
> Changes in v2:
>  - Added reference to can-controller.yaml
>  - Added example node for canfd-2.0
> 
> Changes in v3:
>  - Changed yaml file name from xilinx_can.yaml to xilinx,can.yaml
>  - Added "power-domains" to fix dts_check warnings
>  - Grouped "clock-names" and "clocks" together
>  - Added type $ref for all non-standard fields
>  - Defined compatible strings as enum
>  - Used defines,instead of hard-coded values, for GIC interrupts
>  - Droped unused labels in examples
>  - Droped description for standard fields
> 
> Changes in v4:
>  - Replaced additionalProperties with unevaluatedProperties
>  - Moved reg property just after compatible in all examples
> ---
>  .../bindings/net/can/xilinx,can.yaml          | 161 ++++++++++++++++++
>  .../bindings/net/can/xilinx_can.txt           |  61 -------
>  2 files changed, 161 insertions(+), 61 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/can/xilinx,can.yaml
>  delete mode 100644 Documentation/devicetree/bindings/net/can/xilinx_can.txt
> 


Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>


Best regards,
Krzysztof
