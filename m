Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01ED11D1AE7
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 18:22:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389455AbgEMQWN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 12:22:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730831AbgEMQWM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 12:22:12 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57DF3C061A0C
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 09:22:12 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id u10so30226pls.8
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 09:22:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vr4xrBPd6WjwGJ9UzkknlTs/G07kz8VNYmqVhHv2SyM=;
        b=L+qtKFp04VhJiTPE26PtBtsN3xx4OPyKOk87nXqdhh8cutiT+AdExFlLX5fGsUfPc9
         EiiQjvu0nQmrPz9UfwAUmmKblXukSy5CoK6pMgt1koyOL+ltqTVwNGIsehuU6EeepwGd
         zEWMNzN39iShzqN6U4HRjCwVQjXGS8d63sevuDfpQkQ+QpSJEBeRxRYkNo+XzCwwrTjk
         nz1MlmDL+XaPT8O4+mw/ZohQ4sxPl1mG4m9Mc76hpmBZ/ZmHlC7ZplkVyHNGzp4JXeX6
         4fujrdRW+oIurc4h6mizG8QpGWvQ35gM2yBJXvSLQmFUIAVFBiXOkDl0wLDFqE1DWp2q
         PHHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vr4xrBPd6WjwGJ9UzkknlTs/G07kz8VNYmqVhHv2SyM=;
        b=i6eQGc92dDEj0LGvxjJqqmKvxFboZ3GRhxRltUsMNpJEJnevLX5Rw7R3J/eqdCeHVv
         OKQAkv6Ls09SZG/bloyTbgsj1PMeCo1HCCMlmKL+z33gVVeraISMulY7zFo7Gc6NuwCp
         fB/TPfbRw/1zrcEvs/ghZoa2EvA5HaBYNhKAygvo2k4tZm6TiEibX0ikJZrBbkKHva/3
         dD9/LzW9fKPAjycV/H4QQMz5WErzzQa1W9PTN27H+24PqSVCDh8Ie4lwMjIEhUKnnfbZ
         PEC50Py5SU/u+astZbLixKILTA5ZB5pK9i4EtVNoaPLULobpgriCo6wA/dE+NPL7oWec
         NqfA==
X-Gm-Message-State: AGi0Pua2/jL2y9OW+wj6TEOdp2oKm+AAZfdX6SbUSyy/4yvNusS/8cxZ
        boKQAzSNEpjyLUWzgfiSV5Y=
X-Google-Smtp-Source: APiQypIAunS+VuOWk0L1U8KjD+iXDjrbOKSioete0M+CIUAzQKtjgeqCWkCPByMQ8tlSG0/d7fnCvw==
X-Received: by 2002:a17:902:b948:: with SMTP id h8mr24776566pls.309.1589386928799;
        Wed, 13 May 2020 09:22:08 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id b13sm146266pgi.58.2020.05.13.09.22.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 May 2020 09:22:08 -0700 (PDT)
Subject: Re: [PATCH net-next] net: dsa: mt7530: set CPU port to fallback mode
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     DENG Qingfang <dqfext@gmail.com>, netdev <netdev@vger.kernel.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        Russell King <linux@armlinux.org.uk>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        =?UTF-8?Q?Ren=c3=a9_van_Dorst?= <opensource@vdorst.com>,
        Tom James <tj17@me.com>,
        Stijn Segers <foss@volatilesystems.org>,
        riddlariddla@hotmail.com, Szabolcs Hubai <szab.hu@gmail.com>,
        Paul Fertser <fercerpav@gmail.com>
References: <20200513153717.15599-1-dqfext@gmail.com>
 <5d77da58-694a-7f9c-53fb-9d107e271d40@gmail.com>
 <CA+h21hr_TyWQyvGukXqS0SocmvOBWUp6keghuhZh6HSaxAGb8A@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <280bce1d-a95d-b2fd-6b46-0e3f46508292@gmail.com>
Date:   Wed, 13 May 2020 09:22:04 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <CA+h21hr_TyWQyvGukXqS0SocmvOBWUp6keghuhZh6HSaxAGb8A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/13/2020 9:17 AM, Vladimir Oltean wrote:
> On Wed, 13 May 2020 at 18:49, Florian Fainelli <f.fainelli@gmail.com> wrote:
>>
>>
>>
>> On 5/13/2020 8:37 AM, DENG Qingfang wrote:
>>> Currently, setting a bridge's self PVID to other value and deleting
>>> the default VID 1 renders untagged ports of that VLAN unable to talk to
>>> the CPU port:
>>>
>>>       bridge vlan add dev br0 vid 2 pvid untagged self
>>>       bridge vlan del dev br0 vid 1 self
>>>       bridge vlan add dev sw0p0 vid 2 pvid untagged
>>>       bridge vlan del dev sw0p0 vid 1
>>>       # br0 cannot send untagged frames out of sw0p0 anymore
>>>
>>> That is because the CPU port is set to security mode and its PVID is
>>> still 1, and untagged frames are dropped due to VLAN member violation.
>>>
>>> Set the CPU port to fallback mode so untagged frames can pass through.
>>
>> How about if the bridge has vlan_filtering=1? The use case you present
>> seems to be valid to me, that is, you may create a VLAN just for the
>> user ports and not have the CPU port be part of it at all.
>>
> 
> What Qingfang is doing is in effect (but not by intention) removing
> the front panel port sw0p0 from the membership list of the CPU port's
> pvid. What you seem to be thinking of (VLAN of which the CPU is not a
> member of) does not seem to be supported in DSA at the moment.

Indeed and I replied to Qingfang already that I had misunderstood his
patch originally.

> 
> As a fix, there's nothing wrong with the patch actually, I don't even
> know how it would work otherwise. DSA doesn't change the pvid of the
> CPU port when the pvid of a slave changes, because 4 slave ports could
> have 4 different pvids and the CPU port pvid would keep changing.
> Fallback mode should only apply on ingress from CPU, so there's no
> danger really.

Agreed.

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
