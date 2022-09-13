Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF29A5B694B
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 10:15:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231358AbiIMIPz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 04:15:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230108AbiIMIPy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 04:15:54 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 229851E3D4;
        Tue, 13 Sep 2022 01:15:53 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id l12so13435241ljg.9;
        Tue, 13 Sep 2022 01:15:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references
         :organization:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date;
        bh=4ZZv5xCVVnY4y6rYdm7dulVMSoOLJlOJUQL0RHpll98=;
        b=qgXNIR8wAXAwWAJ6ChzaJEDc385w5xU5sTXNBOhucQiH7k5wNMoSwB+UxHaKcZZca9
         9krr/Mg5miP2No270CtLt0pKUNXHRG8hI/g7x2kFsYLe96seFldobIDrg95T2EzxCE9p
         XRcO2Z2AZn2ZC5h6pCCyeoVQ0o1xSti1hCS6pAbqo74OKoOjaplPCCkzhhWK32Uxn8rz
         hPk7hBPwY29iCrn+8fgA85kxNCEWwJJdCtLAyOtczPRP3z0Swvxc2hHaNbtjxmgQ60+K
         ppmTlRRcp5OlWHj1x4Qp+HCuM04ogniDaKSHnU/V/AnzwsMCJL5OqEd6kdoyzaEL7fqu
         89eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references
         :organization:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date;
        bh=4ZZv5xCVVnY4y6rYdm7dulVMSoOLJlOJUQL0RHpll98=;
        b=xzjXcnFgMhSORDcCd8UmbW3m6amifJiotAwJG/zB83doZnYO9mpaVJ0uRgZzg2jJQC
         KIrHXAZRTGyjR+uKR6QtNZ1jHL7fm8iapnwqpcJHUvbNZCzhDCp1FcUbbPVHDDq3qwDW
         uc6A9ATP/qcm1IsOCnmi+5RP6x1FdUDs3VNdoYqC4hc9Cii0lAR/VRaecbkg2ARUJSr4
         hOPQuAqcP7MOLyjPqD9A8w1tpxH81qsvqkfvBSfs2p7mTAhxYDVNjtBd9SoPYV1UfVbH
         MbTA8kb4EJDxWVCvXh16Tw3JbLooa7pgGyHspH0MsioTEENh/sJhGCckWLeBFpd5kzSU
         i+Cw==
X-Gm-Message-State: ACgBeo1WD2felYGf+NRovvk8XyQg1xucXDeMOWSRUGWAHlhrU7mCsx/N
        FM43q7ooSZ60vCK2BNEaB9k=
X-Google-Smtp-Source: AA6agR6yJVHuuaqQSsevIAm5TLHRMUDcbyGPp84h0+Qeu7rIxl3UujxKPvj36ABCMA9af+8S+DeYlA==
X-Received: by 2002:a2e:3e13:0:b0:26b:e6f1:ce14 with SMTP id l19-20020a2e3e13000000b0026be6f1ce14mr5735525lja.454.1663056951361;
        Tue, 13 Sep 2022 01:15:51 -0700 (PDT)
Received: from wse-c0155 (c90-143-177-32.bredband.tele2.se. [90.143.177.32])
        by smtp.gmail.com with ESMTPSA id p39-20020a05651213a700b0048a9e18ae67sm1554255lfa.84.2022.09.13.01.15.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Sep 2022 01:15:50 -0700 (PDT)
Date:   Tue, 13 Sep 2022 10:15:48 +0200
From:   Casper Andersson <casper.casan@gmail.com>
To:     Nathan Huckleberry <nhuck@google.com>
Cc:     Dan Carpenter <error27@gmail.com>, llvm@lists.linux.dev,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: sparx5: Fix return type of sparx5_port_xmit_impl
Message-ID: <20220913081548.gmngjwuagbt63j7h@wse-c0155>
Organization: Westermo Network Technologies AB
References: <20220912214432.928989-1-nhuck@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220912214432.928989-1-nhuck@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 2022-09-12 14:44, Nathan Huckleberry wrote:
> The ndo_start_xmit field in net_device_ops is expected to be of type
> netdev_tx_t (*ndo_start_xmit)(struct sk_buff *skb, struct net_device *dev).
> 
> The mismatched return type breaks forward edge kCFI since the underlying
> function definition does not match the function hook definition.
> 
> The return type of sparx5_port_xmit_impl should be changed from int to
> netdev_tx_t.

I noticed that the functions that assign the return value inside
sparx5_port_xmit_impl also have return type int, which would ideally
also be changed. But a bigger issue might be that
sparx5_ptp_txtstamp_request and sparx5_inject (called inside
sparx5_port_xmit_impl) returns -EBUSY (-16), when they should return
NETDEV_TX_BUSY (16). If this is an issue then it also needs to be fixed.

sparx5_fdma_xmit also has int return type, but always returns
NETDEV_TX_OK right now.

Best Regards,
Casper

