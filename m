Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 963526B0E47
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 17:12:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232049AbjCHQMk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 11:12:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231825AbjCHQMQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 11:12:16 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA9F5B7896;
        Wed,  8 Mar 2023 08:11:58 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id p26so10126431wmc.4;
        Wed, 08 Mar 2023 08:11:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678291917;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5yarKrwYgW74ytSFWWYwFrKPJOYP7sf86/O/pP8Fr+M=;
        b=UGF/AHviK3WX6iYbqc7x1U/SvmrmW52S8vOOgCAB4A+FomenW1QySrYVUt3TnzN3FX
         d3g6RAVUcvELt8oWDYd4cDbWU7U044SiwWRzUDF8N2Cyuz4CxdK2/D/dPzWnOFz919t6
         mwTIu2dM2/R99DAfJSobRrBzcBsY3MiRySauFjbTJDR2A1/PTZl3e7M8/jjU35k1eJ40
         bilcnxCf1/ebD+mag702KGb+wLlsfZXYjhanmGmkLjsOdB4UOhvi2EkMKjSNOJYaiy33
         9wBCLbtwZmik1rNko+TkwUp4Yi0jOJSmbVo2lVQu0BPZ6fGheFmda8/0yG4TjF+o02g7
         v9+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678291917;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5yarKrwYgW74ytSFWWYwFrKPJOYP7sf86/O/pP8Fr+M=;
        b=dnUuBLLtkN/Ol9nayb5zJ1fTPajxQxeeIsKcJd0STAndrZHWknbfZAGdV9wdZunLR4
         9u8ngJfVu1Fz7u32/Jf/8YUamCSw0CUhH0zS9i3s/e+pj+jnLyDEVt61LtgyD8IzMIq0
         XwywYTaQTCeMsFyZhDlN89midNeRFd3jUemopvCHGh3OHEh+Xq82enaa54FXrnlmspSc
         tLK6wcBWEkNG+09A8jYxEmZhgNCwPwa6Y0zk9POmwrvgvndes/ETsUgGJECm6ZDmQ5gJ
         9IyPOtgtE99IERiv+vi6tR5FfrKgJp58fIv/f2CWALJlj3s6HjbLvbvRvcKj94mwzy7P
         J29Q==
X-Gm-Message-State: AO0yUKV9HLVkBUWY2J3FzQlcvWZvQpfrBlIpYchbNY33I1/XfqKRt1ow
        huHjoz14USVSeUb8s36+J2Y=
X-Google-Smtp-Source: AK7set+KtOMGQ3+5j6qXfDtSzjuP7LvII7FJM7gsom2AQx74f9Nfyp52tbQXBZAlCltt1ogRCKGCRA==
X-Received: by 2002:a05:600c:1c85:b0:3ea:fc95:7bf with SMTP id k5-20020a05600c1c8500b003eafc9507bfmr16900948wms.30.1678291917346;
        Wed, 08 Mar 2023 08:11:57 -0800 (PST)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id q14-20020a05600c46ce00b003daffc2ecdesm21080140wmo.13.2023.03.08.08.11.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Mar 2023 08:11:57 -0800 (PST)
Subject: Re: [PATCH 15/28] sfc: Drop redundant
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
 <20230307181940.868828-16-helgaas@kernel.org>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <f506759b-937d-d092-e3f3-b773556ae71f@gmail.com>
Date:   Wed, 8 Mar 2023 16:11:56 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20230307181940.868828-16-helgaas@kernel.org>
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
