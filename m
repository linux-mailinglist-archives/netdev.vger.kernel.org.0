Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C8F56B0E61
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 17:17:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231670AbjCHQR0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 11:17:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230400AbjCHQRF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 11:17:05 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D718C8880;
        Wed,  8 Mar 2023 08:16:47 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id p23-20020a05600c1d9700b003ead4835046so2441305wms.0;
        Wed, 08 Mar 2023 08:16:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678292206;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1rLq/HYeJphIwLaIhhUVdQYGBeFy324eqdU4A/8md5w=;
        b=TtbEhAFXqADfWWC4RtqgxN8hhY7QzPYkg4OnQmdFzqay7dSi+Sb42Ukq6GjfpUbWiH
         SmYpb2SHAtbjbMqI/TrdtEf11KqI2JK7OWvrgi3+Z1xEvR5BSg1FefNmAQ8h2vieSHED
         AAAGokUqWG1AENofvRdjbEj0CPme1Fzkko7VpiF0gXRMfiCJRJdIJTZYUqDzX0q5nsjH
         Q5vx05PtWo4GbLpF6L7AboBNOPUCOmoN0/WVuNh8XIyC3ddJ1p+Z5Ff4c2t5uRooAczT
         lEY7DNT9vwVhkI0lnoBumsZWJ+gIuZSAo9rA8h4b7RZfum/1ekcRCfRAvvNMhfdpS82B
         49JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678292206;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1rLq/HYeJphIwLaIhhUVdQYGBeFy324eqdU4A/8md5w=;
        b=MHH+IoK4PcCIVMnwf3CiPCr1i4o4BMIS90X1PWz8YM5PwbAVRcSJuWYja+9sWGYOHT
         vVCHAdSwsxC/2gtxTu0TAVpwuewg+ulo2MCP87TpkGQaxH7YznzncV+nyy8bl2NyMi39
         P6FRwSkArV49Z2O3duE1pgEui7xQgiL0qFwTmi2hDkyk6KnqM5aFk4xdEvBwGI3uhUlY
         Oz6QM9CG80ztttLrcPvJX6+qWYCuRroTLSZIf3ymJFo5QGSH4Shkyeh1Tmu2db2qwMQm
         xdcUELGhgdb7LJQxd3ZVTzJLU6ansDKwgtu4ESp4DA06uV88dEFDD7omzepvOorBe5QC
         nc6A==
X-Gm-Message-State: AO0yUKWirA0d5RR7zLoRJyaCACrPSwVA/KxHedwKDki0eVc0Hb6RHFiw
        qc6vWuWREKx3k+q+KBrqbzc=
X-Google-Smtp-Source: AK7set+5HKHeb1dFcqoQYhy1cl5gWhdTYnkY9O0CB7s2XKIIV5D3vJRwKroKtRvjuIMWHYtYmBX30g==
X-Received: by 2002:a05:600c:3594:b0:3eb:395b:19dc with SMTP id p20-20020a05600c359400b003eb395b19dcmr16678713wmq.9.1678292206112;
        Wed, 08 Mar 2023 08:16:46 -0800 (PST)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id m18-20020a05600c3b1200b003db0ad636d1sm22035992wms.28.2023.03.08.08.16.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Mar 2023 08:16:45 -0800 (PST)
Subject: Re: [PATCH 18/28] sfc_ef100: Drop redundant
 pci_disable_pcie_error_reporting()
To:     Bjorn Helgaas <helgaas@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        Martin Habets <habetsm.xilinx@gmail.com>
References: <20230307181940.868828-1-helgaas@kernel.org>
 <20230307181940.868828-19-helgaas@kernel.org>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <92c6d8e0-d131-1080-e7ce-fda97cd4a02e@gmail.com>
Date:   Wed, 8 Mar 2023 16:16:45 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20230307181940.868828-19-helgaas@kernel.org>
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
> 51b35a454efd ("sfc: skeleton EF100 PF driver") added a call to
> pci_disable_pcie_error_reporting() in ef100_pci_remove().
> 
> Remove this call since there's no apparent reason to disable error
> reporting when it was not previously enabled.
> 
> Note that since f26e58bf6f54 ("PCI/AER: Enable error reporting when AER is
> native"), the PCI core enables PCIe error reporting for all devices during
> enumeration, so the driver doesn't need to do it itself.
> 
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> Cc: Edward Cree <ecree.xilinx@gmail.com>
> Cc: Martin Habets <habetsm.xilinx@gmail.com>
> ---

Yeah it looks like we meant to add an enable too but lost it somewhere
 in the upstreaming process.  Anyway,
Acked-by: Edward Cree <ecree.xilinx@gmail.com>
