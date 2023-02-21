Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00F8D69DE76
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 12:09:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233405AbjBULJH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 06:09:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233015AbjBULJG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 06:09:06 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48348199D6;
        Tue, 21 Feb 2023 03:09:05 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id c5so4671490wrr.5;
        Tue, 21 Feb 2023 03:09:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TWKnaBniQXPyP/0jLOxUcGL9VMvje6381rzZYK4wJ/U=;
        b=dc6iQN5wbuqJ440ThKhrbs4Ler3siZkFj27xcjQtbJZz7l1PUegbIQ6GqpcPnfhxMJ
         b9GIYbeV9eZQ4vs61qn+uqnXytjFGnpqcbouVwcDQsgmZdfZtWN4YO3JyjTTHo+QlYTA
         /ys7UpNiJ2CYw0siIT9j/gFbBoiUR/AiXo8PWHdGsdeMJjC6YCixniPzMHJkpSywg7tS
         m7IHD/huZGRNgpFRUOGlNfTTd0y3iRrdKfVxUy+8/FKsumJozfouOBc9tF4AcYEgojQL
         dDBCrBUX+V0VW+eYq7r7LFl4VV/GMISyVTehBZj5Li9YmLRdrlhHCTfxrMc8sOWD/MPl
         bI9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TWKnaBniQXPyP/0jLOxUcGL9VMvje6381rzZYK4wJ/U=;
        b=p1jjO71WMlTkW1mvjp9nZytgGzcZ1hrux8yHrJO2JiOKFN/h1iNUht1hKOFA5tjcbA
         DXH3aMVl8U+kYLGiuyMmBJLQh0pm6S/EJYpFTxPOy7z/ADry8JaZqOu3brjuaJxfQEJX
         G505iwXJoitjxKYei2Du6xD0enwSuC2PKa1mvoKip+RCIVWNZmZR4uErp7cGUnAonJ57
         Fxca8AgGDfNqkgH5IUOtnIyPxIZxbZUehM622CIIRQUON7wJtjij8wptLCi2ZIhOKFRu
         WutzzAEAsXBnwit3jB0GsxNFh7Xdfrt5fLCZyx5x/AzJ/FFtKYhVOgjJV4/q1TXtSz7n
         UciA==
X-Gm-Message-State: AO0yUKUZNpBwUpKfxWzpFeISjXgrK/2KuvmND5+oNjwSvWiAtnYLpUET
        bTlhNvLJygXRRFL3Cd2D5ZE=
X-Google-Smtp-Source: AK7set/+2xlogQZWgFspeDKERePjRFiu+jh9WWWSCfUl8J1LIB1T3dg8Rp2j+x6HwVJRLexwM7AtPw==
X-Received: by 2002:a5d:4d01:0:b0:2c5:4ca0:1abb with SMTP id z1-20020a5d4d01000000b002c54ca01abbmr4490403wrt.60.1676977743566;
        Tue, 21 Feb 2023 03:09:03 -0800 (PST)
Received: from ?IPV6:2a01:c22:6e4d:5f00:c8b7:365d:f8a9:9c38? (dynamic-2a01-0c22-6e4d-5f00-c8b7-365d-f8a9-9c38.c22.pool.telefonica.de. [2a01:c22:6e4d:5f00:c8b7:365d:f8a9:9c38])
        by smtp.googlemail.com with ESMTPSA id a16-20020adffb90000000b002c54c92e125sm3275933wrr.46.2023.02.21.03.09.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Feb 2023 03:09:02 -0800 (PST)
Message-ID: <c21a3f74-871c-8726-f078-b4c2c3414ebd@gmail.com>
Date:   Tue, 21 Feb 2023 11:48:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v8 RESEND 0/6] r8169: Enable ASPM for recent 1.0/2.5Gbps
 Realtek NICs
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>, nic_swsd@realtek.com,
        bhelgaas@google.com
Cc:     koba.ko@canonical.com, acelan.kao@canonical.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        vidyas@nvidia.com, rafael.j.wysocki@intel.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
References: <20230221023849.1906728-1-kai.heng.feng@canonical.com>
Content-Language: en-US
From:   Heiner Kallweit <hkallweit1@gmail.com>
In-Reply-To: <20230221023849.1906728-1-kai.heng.feng@canonical.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21.02.2023 03:38, Kai-Heng Feng wrote:
> The series is to enable ASPM on more r8169 supported devices, if
> available.
> 
> The latest Realtek vendor driver and its Windows driver implements a
> feature called "dynamic ASPM" which can improve performance on it's
> ethernet NICs.
> 
> We have "dynamic ASPM" mechanism in Ubuntu 22.04 LTS kernel for quite a
> while, and AFAIK it hasn't introduced any regression so far. 
> 
> A very similar issue was observed on Realtek wireless NIC, and it was
> resolved by disabling ASPM during NAPI poll. So in v8, we use the same
> approach, which is more straightforward, instead of toggling ASPM based
> on packet count.
> 
> v7:
> https://lore.kernel.org/netdev/20211016075442.650311-1-kai.heng.feng@canonical.com/
> 
> v6:
> https://lore.kernel.org/netdev/20211007161552.272771-1-kai.heng.feng@canonical.com/
> 
> v5:
> https://lore.kernel.org/netdev/20210916154417.664323-1-kai.heng.feng@canonical.com/
> 
> v4:
> https://lore.kernel.org/netdev/20210827171452.217123-1-kai.heng.feng@canonical.com/
> 
> v3:
> https://lore.kernel.org/netdev/20210819054542.608745-1-kai.heng.feng@canonical.com/
> 
> v2:
> https://lore.kernel.org/netdev/20210812155341.817031-1-kai.heng.feng@canonical.com/
> 
> v1:
> https://lore.kernel.org/netdev/20210803152823.515849-1-kai.heng.feng@canonical.com/
> 
> Kai-Heng Feng (6):
>   r8169: Disable ASPM L1.1 on 8168h
>   Revert "PCI/ASPM: Unexport pcie_aspm_support_enabled()"
>   PCI/ASPM: Add pcie_aspm_capable() helper
>   r8169: Consider chip-specific ASPM can be enabled on more cases
>   r8169: Use mutex to guard config register locking
>   r8169: Disable ASPM while doing NAPI poll
> 
>  drivers/net/ethernet/realtek/r8169_main.c | 48 ++++++++++++++++++-----
>  drivers/pci/pcie/aspm.c                   | 12 ++++++
>  include/linux/pci.h                       |  2 +
>  3 files changed, 53 insertions(+), 9 deletions(-)
> 

Note that net-next is closed during merge window.
Formal aspect: Your patches miss the net/net-next annotation.
The title of the series may be an old one. Actually most ASPM
states are enabled, you add to disable ASPM temporarily.
