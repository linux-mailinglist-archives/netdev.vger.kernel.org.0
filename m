Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B5CC6E6C6E
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 20:54:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231216AbjDRSyz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 14:54:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230526AbjDRSyv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 14:54:51 -0400
Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83AFA6A4E;
        Tue, 18 Apr 2023 11:54:47 -0700 (PDT)
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-18777914805so5525175fac.1;
        Tue, 18 Apr 2023 11:54:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681844087; x=1684436087;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YuUNTwvmE9txzOv3MJWv0cD410vaeLbQS17PjjR1ve4=;
        b=D3gq0VVig7syrbOWUlelPnG7/StLbDiFPV9s0UkBYWnijmovQjUMXrujRzo0p2TjD0
         Dnms5vb/JYQ0hajHQVR4hvJPiYWIqKUI1EHs3hW74E5ggPUgRTumFlAd7s/H+Y0YJWBw
         jPN9I80FHntKGJqj3C93pnzWFcv8e8XHShJbR3mhM1XC8JY57Jb4EnYoVJ33usj97SNq
         wapyDAejaI6unqEfo/HefVMOezKbzwMg9jRQhr645wjhsqXczajKDl6xIlL60+wJu70z
         ZHjcv2RmeaP4aVg3HT6vS9n5dZp33EOY4YXX2c1vRW4cqi6tGYC4RREBq/bjOnLzTx0D
         Jmfg==
X-Gm-Message-State: AAQBX9d9sGbMs94N9xX8VsC+NVnKnpIiINA/RR0iCt+YxpmHgGqqJep9
        FCUCdHTyOCLHf6hmCZydPA==
X-Google-Smtp-Source: AKy350ZvMIBe0JAzl0BFm5iJ1agl3dvjKBx1OB0tz14YRyfTifc4bTlUfJCXk3hT+TAMvm+oast9Fg==
X-Received: by 2002:a05:6870:1694:b0:183:f65c:8c41 with SMTP id j20-20020a056870169400b00183f65c8c41mr1849175oae.15.1681844086668;
        Tue, 18 Apr 2023 11:54:46 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id 3-20020a4a0003000000b0053b543b027bsm6121330ooh.42.2023.04.18.11.54.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 11:54:45 -0700 (PDT)
Received: (nullmailer pid 2118440 invoked by uid 1000);
        Tue, 18 Apr 2023 18:54:45 -0000
Date:   Tue, 18 Apr 2023 13:54:45 -0500
From:   Rob Herring <robh@kernel.org>
To:     Ivan Mikhaylov <fr0st61te@gmail.com>
Cc:     Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paul Fertser <fercerpav@gmail.com>
Subject: Re: [PATCH 3/4] net/ftgmac100: add mac-address-increment option for
 GMA command from NC-SI
Message-ID: <20230418185445.GA2111443-robh@kernel.org>
References: <20230413002905.5513-1-fr0st61te@gmail.com>
 <20230413002905.5513-4-fr0st61te@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230413002905.5513-4-fr0st61te@gmail.com>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 13, 2023 at 12:29:04AM +0000, Ivan Mikhaylov wrote:
> Add s32 mac-address-increment option for Get MAC Address command from
> NC-SI.
> 
> Signed-off-by: Paul Fertser <fercerpav@gmail.com>
> Signed-off-by: Ivan Mikhaylov <fr0st61te@gmail.com>
> ---
>  Documentation/devicetree/bindings/net/ftgmac100.txt | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/ftgmac100.txt b/Documentation/devicetree/bindings/net/ftgmac100.txt
> index 29234021f601..7ef5329d888d 100644
> --- a/Documentation/devicetree/bindings/net/ftgmac100.txt
> +++ b/Documentation/devicetree/bindings/net/ftgmac100.txt
> @@ -22,6 +22,10 @@ Optional properties:
>  - use-ncsi: Use the NC-SI stack instead of an MDIO PHY. Currently assumes
>    rmii (100bT) but kept as a separate property in case NC-SI grows support
>    for a gigabit link.
> +- mac-address-increment: Increment the MAC address taken by GMA command via
> +  NC-SI. Specifies a signed number to be added to the host MAC address as
> +  obtained by the OEM GMA command. If not specified, 1 is used by default
> +  for Broadcom and Intel network cards, 0 otherwise.

This would need to be common. There's been some attempts around how to 
support a base MAC address with a transform per instance. So far it's 
not clear that something in DT works for everyone. Until there's 
something common (if ever), you need platform specific code somewhere to 
handle this. The nvmem binding has had some extensions to support that.

Rob
