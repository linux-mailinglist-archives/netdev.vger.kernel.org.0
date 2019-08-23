Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 568D09B4E5
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 18:49:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391577AbfHWQty (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 12:49:54 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:45296 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389534AbfHWQty (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 12:49:54 -0400
Received: by mail-pg1-f195.google.com with SMTP id o13so6059810pgp.12
        for <netdev@vger.kernel.org>; Fri, 23 Aug 2019 09:49:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8Gi23FudRBjLQvjZ1Rxxk9cxEVAf+1Piq2HbgtPhSTU=;
        b=Pz4i5PFkmWAdfMcztKnudDArS2cOsimekn2E5zvfSyv/SdAZsCXsiKkJCVAjlgIBqs
         7D/mC2j5yBAyfMIAL11+em3uGSddwWnYzzeZPpaG3DlDjvCFhSox7uXSx7IoIM4S5cOh
         oUN+zl4paAC7CeQbdrWjqEUF/lkSpGH6Ml05U6096OtCG0JCoHxIVojP4iuNxJJ3ud7H
         pqQ/tvFCcr9ERfVliwIJJAKsLIIvsUBEq5O2uB9Nk9wmwlF3dOBRnCwlGR8+WdLiqaUj
         pMgUmiJ+LpJwcop0lS8l9gGsqjKNNV3gCHcoQouB6bG+tkB/n507mjvyU3s9qmCc40fb
         ckhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=8Gi23FudRBjLQvjZ1Rxxk9cxEVAf+1Piq2HbgtPhSTU=;
        b=t8ak3dsgRCbHMLU/+seyGAl44HY0R7qCDQzvuNMEHF/vL7b2DL35tGLiXLy0rl6J8i
         2FtfQXPINGbku7NAnmfmJJuhNeIXuqUeQ2sBTS4QaF35tD7wt23GFlN298uswi3Pyt4H
         us9TSUsTw+cnrM9syD2C7anHukvB2bPXQItA63EeSrglBwnwWs5z2Obrd9NBb0mR7Mae
         pL+tz7CRmRRfUoJyGd9pbr2u70Hv2Z/wjYnKv4mfcUiUXKrNWm8DShPQcfdLZ6U9+1M+
         l0aYjfsVtkDAPsn7mfOUlqkjTFhYfiu4UVeKTtjpYcFD0mDr7StCgMLfwDChP/RGD7qt
         h7+g==
X-Gm-Message-State: APjAAAVYLDT06zJmq/0D18aSIYaFopgPBwLzEzJLKEDwj3tbDutR/jC4
        sxtWdAJwtLcxS81WENTaCC5QLShA
X-Google-Smtp-Source: APXvYqwtGXatKoutNcNLR8AgrkONdzUdvLP5UUPQPu0PV05ziZiIZf+4Yck0s1RXKfi0/4ObW0bZOw==
X-Received: by 2002:a17:90a:2764:: with SMTP id o91mr6266963pje.57.1566578992965;
        Fri, 23 Aug 2019 09:49:52 -0700 (PDT)
Received: from [10.67.49.31] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id ev3sm17360629pjb.3.2019.08.23.09.49.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 23 Aug 2019 09:49:52 -0700 (PDT)
Subject: Re: [PATCH net-next 2/6] net: dsa: do not skip -EOPNOTSUPP in
 dsa_port_vid_add
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>
References: <20190822201323.1292-1-vivien.didelot@gmail.com>
 <20190822201323.1292-3-vivien.didelot@gmail.com>
 <f179fa10-3123-d055-1c67-0d24adf3cb08@gmail.com>
 <20190822194304.GB30912@t480s.localdomain>
 <CA+h21hpgCJ9oKwQxzu62hmvyCOyDZ52R5fYnejprGHWeZR7L6Q@mail.gmail.com>
 <2a43ee4c-0e20-1037-d856-3945d516ea7b@gmail.com>
 <CA+h21hpzSNZTK6-wQJkJCC9vs0hao12_tpQRLM5JLXXD_26c_w@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 M5kY0ACeNhCZJvZ5g4C2Lc9fcTHu8jxmEkI=
Message-ID: <670c1d7f-4d2c-e9b4-3057-e87a66ad0d33@gmail.com>
Date:   Fri, 23 Aug 2019 09:49:49 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CA+h21hpzSNZTK6-wQJkJCC9vs0hao12_tpQRLM5JLXXD_26c_w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/23/19 9:32 AM, Vladimir Oltean wrote:
> Hi Florian,
> 
> On Fri, 23 Aug 2019 at 19:23, Florian Fainelli <f.fainelli@gmail.com> wrote:
>>
>> On 8/22/19 4:44 PM, Vladimir Oltean wrote:
>>> On Fri, 23 Aug 2019 at 02:43, Vivien Didelot <vivien.didelot@gmail.com> wrote:
>>>>
>>>> Hi Vladimir,
>>>>
>>>> On Fri, 23 Aug 2019 01:06:58 +0300, Vladimir Oltean <olteanv@gmail.com> wrote:
>>>>> Hi Vivien,
>>>>>
>>>>> On 8/22/19 11:13 PM, Vivien Didelot wrote:
>>>>>> Currently dsa_port_vid_add returns 0 if the switch returns -EOPNOTSUPP.
>>>>>>
>>>>>> This function is used in the tag_8021q.c code to offload the PVID of
>>>>>> ports, which would simply not work if .port_vlan_add is not supported
>>>>>> by the underlying switch.
>>>>>>
>>>>>> Do not skip -EOPNOTSUPP in dsa_port_vid_add but only when necessary,
>>>>>> that is to say in dsa_slave_vlan_rx_add_vid.
>>>>>>
>>>>>
>>>>> Do you know why Florian suppressed -EOPNOTSUPP in 061f6a505ac3 ("net:
>>>>> dsa: Add ndo_vlan_rx_{add, kill}_vid implementation")?
>>>>> I forced a return value of -EOPNOTSUPP here and when I create a VLAN
>>>>> sub-interface nothing breaks, it just says:
>>>>> RTNETLINK answers: Operation not supported
>>>>> which IMO is expected.
>>>>
>>>> I do not know what you mean. This patch does not change the behavior of
>>>> dsa_slave_vlan_rx_add_vid, which returns 0 if -EOPNOTSUPP is caught.
>>>>
>>>
>>> Yes, but what's wrong with just forwarding -EOPNOTSUPP?
>>
>> It makes us fail adding the VLAN to the slave network device, which
>> sounds silly, if we can't offload it in HW, that's fine, we can still do
>> a SW VLAN instead, see net/8021q/vlan_core.c::vlan_add_rx_filter_info().
>>
>> Maybe a more correct solution is to set the NETIF_F_HW_VLAN_CTAG_FILTER
>> feature bit only if we have the ability to offload, now that I think
>> about it. Would you want me to cook a patch doing that?
> 
> sja1105 doesn't support offloading NETIF_F_HW_VLAN_CTAG_FILTER even
> though it does support programming VLANs.

The additional of the ndo_vlan_rx_{add,kill}_vid() is such that
standalone DSA ports continue to work while there is a bridge with
vlan_filtering=1 spanning other ports. In order for that ndo operation
to be called, we need to advertise the NETIF_F_HW_VLAN_CTAG_FILTER feature.

> Adding an offloaded VLAN sub-interface on a standalone switch port
> (vlan_filtering=0, uses dsa_8021q) would make the driver insert a VLAN
> entry whilst the TPID is ETH_P_DSA_8021Q.
> Maybe just let the driver set the netdev features, similar to how it
> does for the number of TX queues?

Why should we bend the framework because sja1105 and dsa_8021q are
special? Let me counter the argument: if the tagging is DSA_8021Q, why
not clear the feature then?
-- 
Florian
