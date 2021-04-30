Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31A6836F41A
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 04:39:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbhD3Cjj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 22:39:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbhD3Cji (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Apr 2021 22:39:38 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30193C06138B;
        Thu, 29 Apr 2021 19:38:51 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id a11so4946627plh.3;
        Thu, 29 Apr 2021 19:38:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=jaCub1Sk5luNFcSj2KyJUdoWo/o9f4mzXOf2bkFAbRc=;
        b=gCndhTw3ouP0rMi0uKkO4yYmc7jRf0minwRX/Kisp3zUqWh+ygE+h+/Me3vzKPW66S
         nO3Noa7whRSWeksIenMTgmXEprywhUOgoI7ThvhzlAAp5eMieV9d8pBAEIUANrSYLOiN
         lLb9anH74xTH5vPl/wiZIEtVCCJBTHnSrAKAFtT8KaO4jhs5GhWSXOMXnpR34jHTJ0JQ
         kV8/2E1wanSSCO7GynRJ9qM612MP4GV5g6WkEw5jv8+4d9uqlzAX2HHHAuej2E7wZE+S
         +vx9UHNFM0+exkUHL0O9GBKUaYps8YtKhvBsS+DVaBSdTuH/pFyomWBmfCpBD4NdzoT2
         PzUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=jaCub1Sk5luNFcSj2KyJUdoWo/o9f4mzXOf2bkFAbRc=;
        b=XhnPUfzHoi1CTWfCRk0u5607JkdVeGKISd/B0aTdOd7JdsqVGLF0NOTL0S7BA/FWdR
         nZS2/UChpHViHZIRQBgMFeXudblC0yrHj/8eMKG6RMbEU0PUA1/Vyu+u+DIsW5MKqkPa
         cxPTMYA5lXxjTXq6V3S1jwRDjy7cZCM31QpIFg5kCQcaEV36qu/O8gUERIc/a9CRbF1A
         XUK/PM2N85nyEDlUin3DPeHTeUbb/iPz7ubxrunvu9nxBbM+q1h/xTsoZkMj98tTzurS
         DvdJYrBLFwELnj9daBw0bVJVfTsiU6LxQ9/JfkJgqG79rnj1kBRwwklaxCE37tbgdnvd
         lyIg==
X-Gm-Message-State: AOAM5324IiUtm4A7w7fSHKGkWplXjDM6exqHr07D5aGcaImez75vnsno
        8dlLmRuehixyg81rh0lpOZ4=
X-Google-Smtp-Source: ABdhPJxoY/Hw8IXQtiW/BgUbYJZMs3c7bERLbztAkvCoMex1EAzOXh7z4+LBt9CcfYAY9pz/zdslhg==
X-Received: by 2002:a17:90a:a389:: with SMTP id x9mr12546207pjp.232.1619750330653;
        Thu, 29 Apr 2021 19:38:50 -0700 (PDT)
Received: from localhost.localdomain ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id in1sm8765736pjb.23.2021.04.29.19.38.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Apr 2021 19:38:49 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        kuba@kernel.org, Landen.Chao@mediatek.com, matthias.bgg@gmail.com,
        linux@armlinux.org.uk, sean.wang@mediatek.com,
        vivien.didelot@gmail.com, olteanv@gmail.com, robh+dt@kernel.org,
        linus.walleij@linaro.org, gregkh@linuxfoundation.org,
        sergio.paracuellos@gmail.com, linux-kernel@vger.kernel.org,
        linux-mediatek@lists.infradead.org, linux-staging@lists.linux.dev,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        weijie.gao@mediatek.com, gch981213@gmail.com,
        opensource@vdorst.com, frank-w@public-files.de, tglx@linutronix.de,
        maz@kernel.org
Subject: Re: [PATCH net-next 0/4] MT7530 interrupt support
Date:   Fri, 30 Apr 2021 10:38:39 +0800
Message-Id: <20210430023839.246447-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210429.170815.956010543291313915.davem@davemloft.net>
References: <20210429062130.29403-1-dqfext@gmail.com> <20210429.170815.956010543291313915.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 29, 2021 at 05:08:15PM -0700, David Miller wrote:
> 
> Please fix this:
> 
> error: the following would cause module name conflict:
>   drivers/net/phy/mediatek.ko
>   drivers/usb/musb/mediatek.ko

So I still have to rename the PHY driver..
Andrew, what is your suggestion? Is mediatek_phy.c okay?

> 
> 
> Thanks.
