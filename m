Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AB9034FF49
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 13:11:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235086AbhCaLKr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 07:10:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234862AbhCaLKR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 07:10:17 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DCE0C06174A;
        Wed, 31 Mar 2021 04:10:17 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id g20so9953779wmk.3;
        Wed, 31 Mar 2021 04:10:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SCIPrEQXmkFK9b+U3x+rs0/SFIu2Lw+iwpbKzvEC54I=;
        b=Xh5U3k4+K7YqbYZoenAUQ01BUgB9Wnn5PfYMDThE0qXD3ifUPW0Tr1A2BeWybn5Lh+
         9sSEhRzu1FBLW3tinYQ0zHuO6xXpBMpVWo+LtWD4USs1HERKGKse3i5/gAbCh8Ra+RAD
         etdd5KwOOYhMObwE6XVN72GogGGN7vydloH8t3Cj+yx3rR7rXxsMG1xhMWdnMEWCZWRA
         TdNwcOk+14fQPSIm5VTs4wTgKMhaIXYhL76C9U5C2ZJUlieFFF/qRpO1VLShm6oyqCTd
         V5+JH4dONYk7GnqYZSjbt6SpqxZhIGV0l35bQeLW9goudqt7yZvJH9qmqpBJRIp9fhfe
         CkAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SCIPrEQXmkFK9b+U3x+rs0/SFIu2Lw+iwpbKzvEC54I=;
        b=kit0b+gYo1ophfGTClvzZa6y4tgGk4Ig77lO9sM59QnANMgmpW+ilxYyEJ20AIsT4h
         LqU/BEUM3bncAflE3vCmaXo8sn/jfhw/LaSbqWVHlqUnwGWBRELXXmpOEVv8WFrVeVkJ
         YON7lLxQvSVQpatwRfw1D4TBpJTdrQ21LVrg/1mu0fs662P1QAheM4JX2ffH4rkAHeYq
         TWth67PKajYf5x42Eajvg0N+FNcdODl9BPRdcmcvqo61SOyoVxc0YMJEQuN3z5hI+NjX
         ukEVuVKdRZmhRcewPWirAyStjE1HMFkZ4UHDu6FWAn8JB5OP66owT+e4C7aECkF9zrX7
         z6bg==
X-Gm-Message-State: AOAM530dCtAowwfGi9wbg7QxFkZkg+5PZ7EQPxwGUJR+97AyteFNZU+F
        HM6cSP/F/dW1AHkBeu2Fd4g=
X-Google-Smtp-Source: ABdhPJwN9aeNLQFXf4YXYRsuBlLKXWnbvpsOy8BY8Eepw1f7SbXkgtblU15dkqlvX/z7NBnwoAckWA==
X-Received: by 2002:a1c:7905:: with SMTP id l5mr2709597wme.181.1617189015735;
        Wed, 31 Mar 2021 04:10:15 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f1f:bb00:953:1e7:27d8:7327? (p200300ea8f1fbb00095301e727d87327.dip0.t-ipconnect.de. [2003:ea:8f1f:bb00:953:1e7:27d8:7327])
        by smtp.googlemail.com with ESMTPSA id p16sm5139149wrt.54.2021.03.31.04.10.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 Mar 2021 04:10:15 -0700 (PDT)
Subject: Re: [PATCH v4 0/3] PCI: Disable parity checking
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, nic_swsd@realtek.com,
        linux-pci@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>
References: <20210330174318.1289680-1-helgaas@kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <3ed9ff5a-3984-1abd-c857-dd5ca942fcde@gmail.com>
Date:   Wed, 31 Mar 2021 13:08:56 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210330174318.1289680-1-helgaas@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30.03.2021 19:43, Bjorn Helgaas wrote:
> From: Bjorn Helgaas <bhelgaas@google.com>
> 
> I think this is essentially the same as Heiner's v3 posting, with these
> changes:
> 
>   - Added a pci_disable_parity() interface in pci.c instead of making a
>     public pci_quirk_broken_parity() because quirks.c is only compiled when
>     CONFIG_PCI_QUIRKS=y.
> 
>   - Removed the setting of dev->broken_parity_status because it's really
>     only used by EDAC error reporting, and if we disable parity error
>     reporting, we shouldn't get there.  This change will be visible in the
>     sysfs "broken_parity_status" file, but I doubt that's important.
> 
> I dropped Leon's reviewed-by because I fiddled with the code.  Similarly I
> haven't added your signed-off-by, Heiner, because I don't want you blamed
> for my errors.  But if this looks OK to you I'll add it.
> 
> v1: https://lore.kernel.org/r/a6f09e1b-4076-59d1-a4e3-05c5955bfff2@gmail.com
> v2: https://lore.kernel.org/r/bbc33d9b-af7c-8910-cdb3-fa3e3b2e3266@gmail.com
> - reduce scope of N2100 change to using the new PCI core quirk
> v3: https://lore.kernel.org/r/992c800e-2e12-16b0-4845-6311b295d932@gmail.com/
> - improve commit message of patch 2
> 
> v4:
> - add pci_disable_parity() (not conditional on CONFIG_PCI_QUIRKS)
> - remove setting of dev->broken_parity_status
> 
> 
> Bjorn Helgaas (1):
>   PCI: Add pci_disable_parity()
> 
> Heiner Kallweit (2):
>   IB/mthca: Disable parity reporting
>   ARM: iop32x: disable N2100 PCI parity reporting
> 
>  arch/arm/mach-iop32x/n2100.c              |  8 ++++----
>  drivers/net/ethernet/realtek/r8169_main.c | 14 --------------
>  drivers/pci/pci.c                         | 17 +++++++++++++++++
>  drivers/pci/quirks.c                      | 13 ++++---------
>  include/linux/pci.h                       |  1 +
>  5 files changed, 26 insertions(+), 27 deletions(-)
> 

LGTM. Thanks!
