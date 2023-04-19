Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BBAD6E7B0E
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 15:39:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232895AbjDSNji (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 09:39:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232035AbjDSNjh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 09:39:37 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8538E60;
        Wed, 19 Apr 2023 06:39:35 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id vc20so26819504ejc.10;
        Wed, 19 Apr 2023 06:39:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681911574; x=1684503574;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tJWbp1tfEuIBgO3KjXBgANNDdus3rVnLPSEwlC3kPi4=;
        b=POiZ82GaBj5KpeYp1zkRXb3HJFZC59lbpVOn94aKhckb0eBs+KHbzuwkC55U8TaHUM
         GTAp8/li2tq37vQS5tGB1tlnf5n2iCcc+v5SudC3PYwa8K9I9EcmWUiMgCt/LWxCRZZR
         ybOkNldslhZQWmKU/gMVyF8PDWd6fG1mBbFw66Kz6AvNxMq7fL8TmhTi3VUVDloxwjQo
         pa2dO+zkye9e+vGxugROHlBiD3AOsh+SaDyA0f8HkXoPgcQYzB8KjJ9IGtLQk1gkgGta
         052f5zN/cuaD9TBXNcnSI3I6E7JbxZaLYV6NIXeejHfC9ShYDrm7B0vxHmRr4zVjgAmd
         zdVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681911574; x=1684503574;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tJWbp1tfEuIBgO3KjXBgANNDdus3rVnLPSEwlC3kPi4=;
        b=cchHKcJI2pWRmfc2/T+VfKg/f+XbjS8GuE16J/c/3VFK2qUQJIeW49z4w1xFkyvDS3
         xlJJAaKQPua3diva3kouHt1KhUI1sBr+D/bbAZ9R85/6QYgivcwOPM/7cC5V756Z/nrw
         E24AvO9kZatSMr79+/m4U3zDeV3wAnRJs/H73yZYOS5YFjyF038CP+VKek8S2DeTH36+
         MFVzb+6nRGE7IudwdtTywNbDBN3YBJA6pnyeA4sT4d0gGZpHuW3S2K7E5ZA88Q0d0xZn
         oRFAeOZl81r15tfPRlfeUCS8VSxsqZCRwk/dk7PktKqxV0Z39wZO4edqTt/dCJpzDaMI
         8f2A==
X-Gm-Message-State: AAQBX9f/L5EAF3LhYvuJ87OY++7y6qkz+5NeZOUWVBroQJWR9TFZz/MG
        d2n+d0FwFtNYNtg7cswKgxmQ5hDMwbSXsg==
X-Google-Smtp-Source: AKy350Z3/V908UnVtPmmQpMT4HDcol2ix7w5BeXwbLRUqmzO29i1kEWc6GDZuaNMoZCwiXdAKBna/w==
X-Received: by 2002:a17:906:dc1:b0:94a:474a:4dd5 with SMTP id p1-20020a1709060dc100b0094a474a4dd5mr14305062eji.9.1681911574271;
        Wed, 19 Apr 2023 06:39:34 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id nc16-20020a1709071c1000b0095004c87676sm2662199ejc.199.2023.04.19.06.39.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 06:39:33 -0700 (PDT)
Date:   Wed, 19 Apr 2023 16:39:31 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jiawen Wu <jiawenwu@trustnetic.com>
Cc:     netdev@vger.kernel.org, linux@armlinux.org.uk,
        linux-i2c@vger.kernel.org, linux-gpio@vger.kernel.org,
        mengyuanlou@net-swift.com
Subject: Re: [PATCH net-next v3 0/8] TXGBE PHYLINK support
Message-ID: <20230419133931.mpmjzzolnds4kv6l@skbuf>
References: <20230419082739.295180-1-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230419082739.295180-1-jiawenwu@trustnetic.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 19, 2023 at 04:27:31PM +0800, Jiawen Wu wrote:
> Implement I2C, SFP, GPIO and PHYLINK to setup TXGBE link and switch link
> rate based on optical module information.
> 
> Because our I2C and PCS are based on Synopsys Designware IP-core, extend
> the i2c-designware and pcs-xpcs driver to realize our functions.

For next patch versions, please copy the maintainers/reviewers listed
under "SFF/SFP/SFP+ MODULE SUPPORT", "SOFTWARE NODES AND DEVICE PROPERTIES",
"ETHERNET PHY LIBRARY".
