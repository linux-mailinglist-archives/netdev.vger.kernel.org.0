Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B5CC6B0E49
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 17:13:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231678AbjCHQM7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 11:12:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232259AbjCHQMX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 11:12:23 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23F2251C89;
        Wed,  8 Mar 2023 08:12:22 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id ay29-20020a05600c1e1d00b003e9f4c2b623so1683156wmb.3;
        Wed, 08 Mar 2023 08:12:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678291940;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5yarKrwYgW74ytSFWWYwFrKPJOYP7sf86/O/pP8Fr+M=;
        b=WXKZlUhMFnA6DAo3HeodvMa++8/c/Cv9HYzGHRN1WnazGPoEGsP+iwThSUrM/gRDf3
         BJd6LazG9ZiiU1S7unRRuMbqyOITKtlN2kayQujbTXAZHqC0O3PjV35wtm9l4sj+4DYf
         wKwhnNUBF/2h8h55nLNBHIkYUy8EQu+2sR9bMPPZLD14xiJFFrwX6gqOpHD+MSv25ZqD
         TtmODYeBn+0FgT0JaI26JSjwVaPSvDhCg5BDlbKz90vSB3gpud2isrdPGuuofjgTKmPo
         7/TivAnMF7dpmcNFs9/sVq+cbeXa0xaZnYr3qB+AQ1UrZ7pcijK6KKCEWrOKECqwEhGx
         SY6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678291940;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5yarKrwYgW74ytSFWWYwFrKPJOYP7sf86/O/pP8Fr+M=;
        b=2lpbc+iUc9pTIMcjaaxCQUgaGmBnsLgYeZ2ZTLM5Rh4ehPH8u4/jsJFBHedCzVH53y
         Otr31kNyLS9eDKoMn1BZi2gNpC6wnU5pr4R7RfO4DBx0dSOblwnJ+XewBK1b32RDTH+W
         i1+8InvapvQvtcYew1kOwYOOIICR8AG4Vp1hpH/YZlUJsrGA6ZOXE/cH00eav3fr8mog
         g/HlUWvYU+n4itbUE9ELHwM8YdBpifrMsF/CJsFGX/MyITQdd/Vz2qY20QCsANkx/cPA
         WSy/j1TQV6+fmcQN6zMu4acFiSHVhs87QlKr+ebhpMlTHtHY1ldw2fZya3x37KAMGS6B
         z0kw==
X-Gm-Message-State: AO0yUKUkzg07NW/doyRNfd8jePeyN82Vv5wlp8nPQaTmTlE3k9OAlRSn
        TJqp9NDcYjRsox2E0YYvY6g=
X-Google-Smtp-Source: AK7set/DQskI/XicEQQVUmlX5fSg7v1QuInbrGey+MNsDJmm2BeV+CZL+8APXj+tj8oHyUyBZfbLHA==
X-Received: by 2002:a05:600c:3c95:b0:3eb:a4e:a2b2 with SMTP id bg21-20020a05600c3c9500b003eb0a4ea2b2mr16800907wmb.4.1678291940558;
        Wed, 08 Mar 2023 08:12:20 -0800 (PST)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id e4-20020a5d5304000000b002ce3cccda0bsm15180061wrv.81.2023.03.08.08.12.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Mar 2023 08:12:20 -0800 (PST)
Subject: Re: [PATCH 16/28] sfc: falcon: Drop redundant
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
 <20230307181940.868828-17-helgaas@kernel.org>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <bf7b1013-0ef4-c5a4-24b1-3894fc495582@gmail.com>
Date:   Wed, 8 Mar 2023 16:12:19 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20230307181940.868828-17-helgaas@kernel.org>
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
