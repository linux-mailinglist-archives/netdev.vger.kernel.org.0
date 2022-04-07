Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5E934F8487
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 18:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345569AbiDGQHZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 12:07:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230478AbiDGQHV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 12:07:21 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26671114DE4;
        Thu,  7 Apr 2022 09:05:21 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id w4so8493602wrg.12;
        Thu, 07 Apr 2022 09:05:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RwGnOv9tuCS4Glh/q7Oki8zffnkUd/Q0fjECuAqwO7c=;
        b=gmV3yEoVNk48jcao6xPblrNPo2DepjB/cLhPBrWrEehQVu9A8va2bBHzlDCfzHi5sm
         GMGDkHH6ugea546NIYx/mw+RooJuDb2MQNzC9pBuoFhkqem4NjIjUbsVCRPkqusvtGA6
         dVISATNeHRq6Pd2MEN/MqxDOQ+nJCDF/HOzwyZpbPbahgsWgkXaSfp10+g3BndlncXnp
         fKf+wkkD+pzzWTAoJGgzOPdI17YByZWb3bC6+tDxp2qzjzgqJuZgDwnr20OdJZb5HX4M
         +n0afAhNsqjK7zxZ6pc3seudiFD8Q2CqvlqKS4dEKu1H8GAlzeI5qwrvzeAFIYfCyJHt
         WdPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RwGnOv9tuCS4Glh/q7Oki8zffnkUd/Q0fjECuAqwO7c=;
        b=ypZ1G50AsQN/UYnlSFjnhpJ9eaQnAPRmPTxgLW+O87Ra7qkeFCt38WS7f6fZR94boT
         vvOzz28Y0f3L2KhITlOTLtUVpR7SPIFO/evPpNx4nlfij/NrxGxDkc/4GoAzBZo/p4Ba
         gSkoFECtkiHFO1LRyQpR4Ora5f6g8j7Lmh6ofS3SdLaHgNNA31OHpCpGShPYD/Q6JJ9z
         8w8w2WR5+J+lRx8uuQbx5akid1/JPPbkzcSA0xYeFwUSWHoZONYA5CAa8Ukup2XNsalY
         vk6cKDJRdPRx5S0Q7jrsVlY6uSQxzZ0SaWU58+gkxR7mfaqeDSy0xKadO7FEXEotPIQb
         lyJw==
X-Gm-Message-State: AOAM531RLgYtzgKOAAUPkwtZiLJrdyZ92smIMgrCAnX4mEqtiSf99lBx
        /0h5Oy/kyb7nq/aHR8tfeBpZFajUeEvNCA==
X-Google-Smtp-Source: ABdhPJw5LXgWJ0+mFqcCsIxYkYvOGUsbpwr0rk1MnX3hYB9nf98fHqjiWFS+OJN2YQaf4rPa8l7aAQ==
X-Received: by 2002:adf:b745:0:b0:205:b8e2:f470 with SMTP id n5-20020adfb745000000b00205b8e2f470mr11089350wre.91.1649347519726;
        Thu, 07 Apr 2022 09:05:19 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id t6-20020a05600c198600b0038cafe3d47dsm8725698wmq.42.2022.04.07.09.05.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Apr 2022 09:05:19 -0700 (PDT)
Subject: Re: [PATCH net-next] sfc: Stop using iommu_present()
To:     Robin Murphy <robin.murphy@arm.com>, habetsm.xilinx@gmail.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
References: <7350f957944ecfce6cce90f422e3992a1f428775.1649166055.git.robin.murphy@arm.com>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <296fa369-723f-f9b7-773f-7695b12c9971@gmail.com>
Date:   Thu, 7 Apr 2022 17:05:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <7350f957944ecfce6cce90f422e3992a1f428775.1649166055.git.robin.murphy@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/04/2022 14:40, Robin Murphy wrote:
> Even if an IOMMU might be present for some PCI segment in the system,
> that doesn't necessarily mean it provides translation for the device
> we care about. It appears that what we care about here is specifically
> whether DMA mapping ops involve any IOMMU overhead or not, so check for
> translation actually being active for our device.
> 
> Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Acked-by: Edward Cree <ecree.xilinx@gmail.com>
