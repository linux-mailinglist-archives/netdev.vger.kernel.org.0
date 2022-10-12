Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CB825FC91B
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 18:22:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229867AbiJLQWS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 12:22:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbiJLQWP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 12:22:15 -0400
Received: from mail-oa1-f51.google.com (mail-oa1-f51.google.com [209.85.160.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 441F7F253F;
        Wed, 12 Oct 2022 09:22:03 -0700 (PDT)
Received: by mail-oa1-f51.google.com with SMTP id 586e51a60fabf-1324e7a1284so20011468fac.10;
        Wed, 12 Oct 2022 09:22:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w9ooysRCPWwfkOQsofxa8c0vAZXT4BQ/v/BacIsjsJw=;
        b=ZoN2S3I8tMdJi5TGESstwejE8OxWDtshhO482ynUMnoYJNfyohQ6Plc/dx58Cd0BS7
         8hBWIVgdzlk6cPQ5u5ueok0fD2/ayXrNmD7xWHxxndoce89SpP+/+n51MaTLWl0RqtCr
         eSN36jOFJQ55K6M2GBb4UfS8z1F8eELU9Ay38Rp7dEDNgHZjTNthNNaPmoPppJ/otF+i
         MVjLOyDmsj9+HJY8X8H7cAU2opXFGUQsifZRtMERgRR6Kv/gb+hV7Wq4OEJv67neaJl2
         4GWJkq1RBN3lckPNPykCVLzeRo5pdzBmtKMU6ZvIuyk4Icr/UmvO0Ybwj9sJXmzi20O8
         Jfnw==
X-Gm-Message-State: ACrzQf1YMZniz0o6m+HE6hYXOI+bYmNjfW6r3KeHZmMfWUx6dOyGctqW
        /C8f+HjiJuDG/RpYtPBOdw==
X-Google-Smtp-Source: AMsMyM7ax+7oJeMRo/K68gvl3SyHLdXhw2E4wnkt/VLvxvFuCGm6zdglL8IJeCxdEDXSHOc0BNd6UQ==
X-Received: by 2002:a05:6870:88a9:b0:133:605:bb1d with SMTP id m41-20020a05687088a900b001330605bb1dmr2849384oam.220.1665591719121;
        Wed, 12 Oct 2022 09:21:59 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id r26-20020a4ae51a000000b00425806a20f5sm1139604oot.3.2022.10.12.09.21.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Oct 2022 09:21:58 -0700 (PDT)
Received: (nullmailer pid 2282719 invoked by uid 1000);
        Wed, 12 Oct 2022 16:21:59 -0000
Date:   Wed, 12 Oct 2022 11:21:59 -0500
From:   Rob Herring <robh@kernel.org>
To:     Matej Vasilevski <matej.vasilevski@seznam.cz>
Cc:     Ondrej Ille <ondrej.ille@gmail.com>, linux-can@vger.kernel.org,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Paolo Abeni <pabeni@redhat.com>, devicetree@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Eric Dumazet <edumazet@google.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH v5 1/4] dt-bindings: can: ctucanfd: add another clock for
 HW timestamping
Message-ID: <166559171895.2282669.6983651717616748049.robh@kernel.org>
References: <20221012062558.732930-1-matej.vasilevski@seznam.cz>
 <20221012062558.732930-2-matej.vasilevski@seznam.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221012062558.732930-2-matej.vasilevski@seznam.cz>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 12 Oct 2022 08:25:55 +0200, Matej Vasilevski wrote:
> Add second clock phandle to specify the timestamping clock.
> 
> Signed-off-by: Matej Vasilevski <matej.vasilevski@seznam.cz>
> ---
>  .../bindings/net/can/ctu,ctucanfd.yaml        | 19 +++++++++++++++----
>  1 file changed, 15 insertions(+), 4 deletions(-)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
