Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6B289B46C
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 18:23:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436709AbfHWQXY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 12:23:24 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:43619 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389827AbfHWQXX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 12:23:23 -0400
Received: by mail-pl1-f196.google.com with SMTP id 4so5830204pld.10
        for <netdev@vger.kernel.org>; Fri, 23 Aug 2019 09:23:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Rvxnhfnnnb48briEK2JdASWNCds++VWs01GxnCmZHU4=;
        b=kwDrVnUycJ8VSCSdbqUKQaSPG1nsdnpja4XFeIOTg3ia/asJ28aYI6CKjYq6QRDV3C
         jQIF0dN74A2GSMwO46/LP58/93Sph1SG1qeFcY4IKKwQpKI3CktdAQMGDoWmJB+NOFmm
         lbY5i5Bx0rJd9+3A1iO3DmKtKX5zbPcruqaV8PRoaeMsCT3nuEGEBHBbvM8DmGgwAJS6
         bkB9gmlohaw/glBJcPJmIb+LIPSe1BJy4mqZbqCFFPLY1/hOzUEwAp0iiSBEKmyomOEP
         BmIbpHD1AK5UQdK/j2OZWkVB/hWaZ/AjXIy07Mniy5KIEqRvY0hs0rEJ7yRNw4JnRoPK
         J8Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=Rvxnhfnnnb48briEK2JdASWNCds++VWs01GxnCmZHU4=;
        b=Nmf3BSvlMf6WvkQag0QAzeCm4tVQTdPJG3Rof3WEiZE/9+vVo+tbNjYVYlB9KiCRGC
         VzVvWCZoVaXscB1HZ/EeIPYuFshJtgQxTnSBhXW4+6dcEOkUSheZO5rwxZB32rl7QJgT
         HLK/QJeBspOafGOYgXIV1QjIfd/Dm6b3aMObkoK4k0sWmHC3Pb78HDynqjyDUGLPhNzI
         4O7RyLFZcyjDWpWDmTEcvqrLaV3tTmTTLnWi3RTrYj3ehMjFFGUnxVOfBUaPLfwegDGO
         xCpmMwDESbh2DbbSMI1/C9XmUo2pvZyaJd7sutI2p4TOPzrz1BjpKFo+0uai4VvyHxPt
         VOIg==
X-Gm-Message-State: APjAAAW0MhP0GSV78U+7TkO7bqcQy/zyCrrgxm4YctbQ7HkVul3JGTKo
        Q5nVDKvanD41n5U4MdMRhfXmS3Ak
X-Google-Smtp-Source: APXvYqwPpm9fQeHx1wN55vPDIbJfmjBC4T77pGSO9FvEn1Qod6HyJ2w07+vuyT4ajpUsu0SYnrgqfw==
X-Received: by 2002:a17:902:12d:: with SMTP id 42mr5497370plb.187.1566577402773;
        Fri, 23 Aug 2019 09:23:22 -0700 (PDT)
Received: from [10.67.49.31] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id i137sm4091246pgc.4.2019.08.23.09.23.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 23 Aug 2019 09:23:21 -0700 (PDT)
Subject: Re: [PATCH net-next 2/6] net: dsa: do not skip -EOPNOTSUPP in
 dsa_port_vid_add
To:     Vladimir Oltean <olteanv@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>
References: <20190822201323.1292-1-vivien.didelot@gmail.com>
 <20190822201323.1292-3-vivien.didelot@gmail.com>
 <f179fa10-3123-d055-1c67-0d24adf3cb08@gmail.com>
 <20190822194304.GB30912@t480s.localdomain>
 <CA+h21hpgCJ9oKwQxzu62hmvyCOyDZ52R5fYnejprGHWeZR7L6Q@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 M5kY0ACeNhCZJvZ5g4C2Lc9fcTHu8jxmEkI=
Message-ID: <2a43ee4c-0e20-1037-d856-3945d516ea7b@gmail.com>
Date:   Fri, 23 Aug 2019 09:23:20 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CA+h21hpgCJ9oKwQxzu62hmvyCOyDZ52R5fYnejprGHWeZR7L6Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/22/19 4:44 PM, Vladimir Oltean wrote:
> On Fri, 23 Aug 2019 at 02:43, Vivien Didelot <vivien.didelot@gmail.com> wrote:
>>
>> Hi Vladimir,
>>
>> On Fri, 23 Aug 2019 01:06:58 +0300, Vladimir Oltean <olteanv@gmail.com> wrote:
>>> Hi Vivien,
>>>
>>> On 8/22/19 11:13 PM, Vivien Didelot wrote:
>>>> Currently dsa_port_vid_add returns 0 if the switch returns -EOPNOTSUPP.
>>>>
>>>> This function is used in the tag_8021q.c code to offload the PVID of
>>>> ports, which would simply not work if .port_vlan_add is not supported
>>>> by the underlying switch.
>>>>
>>>> Do not skip -EOPNOTSUPP in dsa_port_vid_add but only when necessary,
>>>> that is to say in dsa_slave_vlan_rx_add_vid.
>>>>
>>>
>>> Do you know why Florian suppressed -EOPNOTSUPP in 061f6a505ac3 ("net:
>>> dsa: Add ndo_vlan_rx_{add, kill}_vid implementation")?
>>> I forced a return value of -EOPNOTSUPP here and when I create a VLAN
>>> sub-interface nothing breaks, it just says:
>>> RTNETLINK answers: Operation not supported
>>> which IMO is expected.
>>
>> I do not know what you mean. This patch does not change the behavior of
>> dsa_slave_vlan_rx_add_vid, which returns 0 if -EOPNOTSUPP is caught.
>>
> 
> Yes, but what's wrong with just forwarding -EOPNOTSUPP?

It makes us fail adding the VLAN to the slave network device, which
sounds silly, if we can't offload it in HW, that's fine, we can still do
a SW VLAN instead, see net/8021q/vlan_core.c::vlan_add_rx_filter_info().

Maybe a more correct solution is to set the NETIF_F_HW_VLAN_CTAG_FILTER
feature bit only if we have the ability to offload, now that I think
about it. Would you want me to cook a patch doing that?
-- 
Florian
