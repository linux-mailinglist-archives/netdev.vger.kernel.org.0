Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF8851CC31D
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 19:13:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728511AbgEIRM6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 13:12:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726013AbgEIRM6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 13:12:58 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8B15C061A0C;
        Sat,  9 May 2020 10:12:56 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id b8so2063471plm.11;
        Sat, 09 May 2020 10:12:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NzlmaplnmFYst+5uNkRJPktQ7+DmI1r+QMC2p7xnzeM=;
        b=Ghq/OkrCjI1vXOlg3VMfPptWZ1WX1V3tg71NANtzdckUVuO3MisC6wkiemrfUDe5+c
         f+CDYO5HG5jzyh03MJrgVrKF9Yx68CKadtxT2uDyPMsHOUcUM0nzhOCgCILYwOiZdcgW
         Q9l2sztgy6Dg9vAAMrqKksSrILzS7UWqsEaMkVnAoaqNT9Uoo9kzwZP9Fq/Yw1vp7dZH
         lAqkdMWGST8uqC57/dLm4lzBL68lsQQXTwyRFLsd55c5Di0uuEICyHw3ovO67BHIZmXp
         m49kCxB0Tr56HH64sb27mT/5gIZTBdJY0YjUUVi6G83SU+cVQRpXY1gP/31QiC5gAP4+
         k2TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NzlmaplnmFYst+5uNkRJPktQ7+DmI1r+QMC2p7xnzeM=;
        b=hJoxHcmqxNjnNHcnfu+orJVyYNWPR4UKBXCfiWrbfErlcLi1Qz+HN0k5NcGF+t/4Pe
         tcOzsA82xndB+3XNSP44uuiC4yrQHgGpGAmIXo7gebTlJoEU1Nn1Kx8BdF65aC+p5EXc
         NlDe3jPr90TO+ZdElK8LEc+mxbEPQ0Z4qD27qGUTislm/uRjp8IgZaFJTnNLVvWIxLy+
         HRHlhsb6liW1mHMS+WOv+3C5Op6siEfIRA4Y0mGUCfZXO9gxKLI0kz9Nk7z911Nk0uOA
         IBIJCoGaa+SHD4D+4tgY7OKX5Jn59mU+REb1bTx2kDLtzuFUieDvP1ZcpQghH069IGqu
         ywjw==
X-Gm-Message-State: AGi0PuZJmuzmenoRN1z88Emy7SLGFgbv3gZtDgC5RJREuuxX0+QFwafS
        vs9/m+BPrcVPSJFvpYEuou4iC2yQ
X-Google-Smtp-Source: APiQypJqpLS2HQBkDIPvXZVTIDDHB9fnk2eWcsDxw1L6nO3LrCHQJxZjfaVZTQ/dsJKMtO8DmUWzfQ==
X-Received: by 2002:a17:902:9042:: with SMTP id w2mr7842796plz.127.1589044375921;
        Sat, 09 May 2020 10:12:55 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id u3sm5013799pfb.105.2020.05.09.10.12.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 09 May 2020 10:12:55 -0700 (PDT)
Subject: Re: [PATCH net] net: broadcom: Imply BROADCOM_PHY for BCMGENET
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Stefan Wahren <wahrenst@gmx.net>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tal Gilboa <talgi@mellanox.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Andy Gospodarek <gospo@broadcom.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20200508223216.6611-1-f.fainelli@gmail.com>
 <CAMuHMdU2A1rzqsnNZFt-Gd+ZO5qc6Mzeyunn-LXpbxk_6zq-Ng@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <ebac4532-6dae-5609-9629-ba10197671c3@gmail.com>
Date:   Sat, 9 May 2020 10:12:52 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <CAMuHMdU2A1rzqsnNZFt-Gd+ZO5qc6Mzeyunn-LXpbxk_6zq-Ng@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/9/2020 12:38 AM, Geert Uytterhoeven wrote:
> Hi Florian,
> 
> Thanks for your patch!
> 
> On Sat, May 9, 2020 at 12:32 AM Florian Fainelli <f.fainelli@gmail.com> wrote:
>> The GENET controller on the Raspberry Pi 4 (2711) is typically
>> interfaced with an external Broadcom PHY via a RGMII electrical
>> interface. To make sure that delays are properly configured at the PHY
>> side, ensure that we get a chance to have the dedicated Broadcom PHY
>> driver (CONFIG_BROADCOM_PHY) enabled for this to happen.
> 
> I guess it can be interfaced to a different external PHY, too?

Yes, although this has not happened yet to the best of my knowledge.

> 
>> Fixes: 402482a6a78e ("net: bcmgenet: Clear ID_MODE_DIS in EXT_RGMII_OOB_CTRL when not needed")
>> Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> 
>> --- a/drivers/net/ethernet/broadcom/Kconfig
>> +++ b/drivers/net/ethernet/broadcom/Kconfig
>> @@ -69,6 +69,7 @@ config BCMGENET
>>          select BCM7XXX_PHY
>>          select MDIO_BCM_UNIMAC
>>          select DIMLIB
>> +       imply BROADCOM_PHY if ARCH_BCM2835
> 
> Which means support for the BROADCOM_PHY is always included
> on ARCH_BCM2835, even if a different PHY is used?

It is included by default on  and can be deselected if needed, which is 
exactly what we want here, a sane default, but without the inflexibility 
of "select".

> 
>>          help
>>            This driver supports the built-in Ethernet MACs found in the
>>            Broadcom BCM7xxx Set Top Box family chipset.
> 
> Gr{oetje,eeting}s,
> 
>                          Geert
> 

-- 
Florian
