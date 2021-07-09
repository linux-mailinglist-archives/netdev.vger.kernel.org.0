Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 658E13C2B52
	for <lists+netdev@lfdr.de>; Sat, 10 Jul 2021 00:25:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231283AbhGIW2Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 18:28:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbhGIW2Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Jul 2021 18:28:24 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D16E8C0613DD;
        Fri,  9 Jul 2021 15:25:39 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id v20so18902410eji.10;
        Fri, 09 Jul 2021 15:25:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+ntQZJpzij1w4h4k2ak0sfnEmP3r69+mLD4JchBnw40=;
        b=koH5CtgXSRam9jL0guU8+1wnm5xSarmQYW5DrPFWqGvydm+TWj0SgHFXJ7aIRp5hTd
         0bdBN0fSAjt3DsLL65TA+bh8VzCnZpZZs4H/O81iJzfG4Y10A4yMQDNl3+lus1DGIk1X
         L4pU9Mc92efGHbb+7sHuy3fgDScyluuW/WKeGgZSVg0K/TBnBcylBzJvDT0b0v3GClhu
         LY4MPU8fSGRjmsX3tvzWZ2g/NHjk7KnStM4xVF5lUSQLNIwvhOg9nVZF02Rzl9gmsT2A
         g6R3iyqUU5LuCikx4XwBtmnz83BjncrLey0Dl0IPzDjRloe2r5of2bCDhBgbq+KJqoC7
         bacg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+ntQZJpzij1w4h4k2ak0sfnEmP3r69+mLD4JchBnw40=;
        b=VtWTQ1pPMNK/MT9+SGQMCcnOQokKPHKf67u/0AuwJqmpcpn067tzVpVV4qvwNT3e2+
         RWL3asnlAZyN5jyPWH9OavdD9jCH42pqaDFCdpAIv0JbfxlP3Akdt0r/9xp811+Eubr/
         kpGB+R9ovY8FcR7/dK8xVTtzccO6nJGJDswCuvRujgta0F1LEJ/IefNYZ7WyKeml+xNG
         AIOiOwXWnbbezdFcHvcz7G83F1VF212yiSf6chJfEp/SwoHUJ/6K7Nku2aYHX06qxEzV
         ixdcYf09491LZxL8uBozrVscvoR/sYPqqUldhn3VjlnA3uwgf1Xe9FHDoME5g/YtKmhS
         PB2w==
X-Gm-Message-State: AOAM530VQtrhtsxQn5KkM/EMapa8v+MtpaSCcxteM2u4ro+a3LNnF0jq
        rT0bXf9pLSpeVuK561/hwLo=
X-Google-Smtp-Source: ABdhPJzrngb4Eh3NWGeqbSd5808UnsLTbEhnoO/ORNUFyMsVTz4Zq6sILqA294Xv32/iLKbBrGIF/A==
X-Received: by 2002:a17:907:d28:: with SMTP id gn40mr35224280ejc.175.1625869538365;
        Fri, 09 Jul 2021 15:25:38 -0700 (PDT)
Received: from [10.17.0.13] ([37.58.58.229])
        by smtp.gmail.com with ESMTPSA id k8sm3636498edr.92.2021.07.09.15.25.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Jul 2021 15:25:37 -0700 (PDT)
Subject: Re: [PATCH v2 2/2] mwifiex: pcie: add reset_d3cold quirk for Surface
 gen4+ devices
To:     =?UTF-8?Q?Pali_Roh=c3=a1r?= <pali@kernel.org>
Cc:     =?UTF-8?Q?Jonas_Dre=c3=9fler?= <verdre@v0yd.nl>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tsuchiya Yuto <kitakar@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>
References: <20210709151800.7b2qqezlcicbgrqn@pali>
 <b1002254-97c6-d271-c385-4a5c9fe0c914@mailbox.org>
 <20210709161251.g4cvq3l4fnh4ve4r@pali>
 <d9158206-8ebe-c857-7533-47155a6464e1@gmail.com>
 <20210709173013.vkavxrtz767vrmej@pali>
 <89a60b06-b22d-2ea8-d164-b74e4c92c914@gmail.com>
 <20210709184443.fxcbc77te6ptypar@pali>
 <251bd696-9029-ec5a-8b0c-da78a0c8b2eb@gmail.com>
 <20210709194401.7lto67x6oij23uc5@pali>
 <4e35bfc1-c38d-7198-dedf-a1f2ec28c788@gmail.com>
 <20210709212505.mmqxdplmxbemqzlo@pali>
From:   Maximilian Luz <luzmaximilian@gmail.com>
Message-ID: <bfbb3b4d-07f7-1b97-54f0-21eba4766798@gmail.com>
Date:   Sat, 10 Jul 2021 00:25:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210709212505.mmqxdplmxbemqzlo@pali>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/9/21 11:25 PM, Pali Rohár wrote:

[...]

> PCIe Function Level Reset should reset only one PCIe part of device. And
> seems that this type of reset does not work properly in some situations.
> 
> Note that PCIe Function Level Reset is independent of running firmware.
> It is implement in hardware and (should) work also at early stage when
> firmware is not loaded yet.
> 
> I'm starting to think more and more if quirk in this patch really needs
> to be behind DMI check and if rather it should not be called on other
> platforms too?

Maybe? I'm not sure how well this behaves on other devices and if there
even are any devices outside of the MS Surface line that really require
or benefit from something like this. To me it seems safer to put it
behind quirks, at least until we know more.

Also not sure if this is just my bias, but it feels like the Surface
line always had more problems with that driver (and firmware) than
others.  I'm honestly a bit surprised that MS stuck with them for this
long (they decided to go with Intel for 7th gen devices). AFAICT they
initially chose Marvell due to connected standby support, so maybe that
causes issue for us and others simply aren't using that feature? Just
guessing though.
