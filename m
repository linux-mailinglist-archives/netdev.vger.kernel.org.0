Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31F126B0E4B
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 17:13:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231899AbjCHQNu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 11:13:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232210AbjCHQN2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 11:13:28 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F11B11ACC1;
        Wed,  8 Mar 2023 08:13:01 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id o11-20020a05600c4fcb00b003eb33ea29a8so1489100wmq.1;
        Wed, 08 Mar 2023 08:13:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678291980;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5yarKrwYgW74ytSFWWYwFrKPJOYP7sf86/O/pP8Fr+M=;
        b=b21L4Ywf/gk0Q4VTUWCtJwDPwU/9cfKroztLBCIp1jYa3KleRtQIRSy3+PwPrmDCki
         0hfndDYBLCDkCXgTeP4Zp/kiNfHD5otFvTYgoqJ6gQWmOewaXWhc1BLeROLJuR59T3Et
         twdJIi+93Pu7S/vNd7TOw9GdaaIIl8xF4sHC/RpyFnDDlrxic5vLSFQohGIL1SUoP1lS
         w2EGbKEwAOuv1hTtygjdKYU7X7LjvkT3s4b9NDvEGlzYO45TO+rw46YC3iR0Ajlv98G3
         R71VA0+Y4adCtsJkPDZ01Nw836qN9os8E5M4Eq7bX2x4Cy8ih7dPa4YmTabGiloIMw3b
         1EuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678291980;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5yarKrwYgW74ytSFWWYwFrKPJOYP7sf86/O/pP8Fr+M=;
        b=SW4IVixScdYDcsA8ueUk6mwzYOvfY3TbuwRkgjDSSFNdv8DgBLN0VNLgowlSg1OrN0
         zn6djF6fiNuNAu485ysFDR+owivVlX11Y+qkVRXVhtbukesnEGm0Cc0FHELCihQNzKYE
         2vx41lv6rzL1n1/5iCr3yUP39hm96V/Y/wPYhE+mXL4Iw6XOZLpcgyg61olh0rCUaQUL
         dTwVWrWudccDdNVa19jy8nuwfg5Gtz82fRk9QoeJdyIxPt0ghGmYt1EmSLa9tFoXV5uq
         HZ7anhVVxUNysrfwav+DyMlAeWm09lJEQBVbTOruyVHU/G/kvnLQ+TWLsK7EwiC+0tRp
         qoJw==
X-Gm-Message-State: AO0yUKXh/Lwd4kAyJa1rNwLKOTX7bo6sBoGivxqX9rS7eshEDGiiWX9j
        d4sAxgsZ1KC96YyNNTNkRT4=
X-Google-Smtp-Source: AK7set+LXsaq5/Xvj2v3pnQ2usLXTAaKq1codfeOHSa0TsssNrVlb1LBCvFCXmvf6PMB90kpCSwRaQ==
X-Received: by 2002:a05:600c:a05:b0:3dc:42d2:aee4 with SMTP id z5-20020a05600c0a0500b003dc42d2aee4mr15543045wmp.25.1678291980229;
        Wed, 08 Mar 2023 08:13:00 -0800 (PST)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id v11-20020a5d610b000000b002c5a790e959sm15608549wrt.19.2023.03.08.08.12.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Mar 2023 08:12:59 -0800 (PST)
Subject: Re: [PATCH 17/28] sfc/siena: Drop redundant
 pci_enable_pcie_error_reporting()
To:     Bjorn Helgaas <helgaas@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        Martin Habets <habetsm.xilinx@gmail.com>
References: <20230307181940.868828-1-helgaas@kernel.org>
 <20230307181940.868828-18-helgaas@kernel.org>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <13e1db16-2696-c0a3-8ed2-1d90be4b2956@gmail.com>
Date:   Wed, 8 Mar 2023 16:12:59 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20230307181940.868828-18-helgaas@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/03/2023 18:19, Bjorn Helgaas wrote:
> From: Bjorn Helgaas <bhelgaas@google.com>
> 
> pci_enable_pcie_error_reporting() enables the device to send ERR_*
> Messages.  Since f26e58bf6f54 ("PCI/AER: Enable error reporting when AER is
> native"), the PCI core does this for all devices during enumeration, so the
> driver doesn't need to do it itself.
> 
> Remove the redundant pci_enable_pcie_error_reporting() call from the
> driver.  Also remove the corresponding pci_disable_pcie_error_reporting()
> from the driver .remove() path.
> 
> Note that this only controls ERR_* Messages from the device.  An ERR_*
> Message may cause the Root Port to generate an interrupt, depending on the
> AER Root Error Command register managed by the AER service driver.
> 
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> Cc: Edward Cree <ecree.xilinx@gmail.com>
> Cc: Martin Habets <habetsm.xilinx@gmail.com>
> ---

Acked-by: Edward Cree <ecree.xilinx@gmail.com>
