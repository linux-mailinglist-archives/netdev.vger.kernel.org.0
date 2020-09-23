Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7043527642E
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 00:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726702AbgIWWt4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 18:49:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726381AbgIWWtz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 18:49:55 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83622C0613CE;
        Wed, 23 Sep 2020 15:49:55 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id o20so560218pfp.11;
        Wed, 23 Sep 2020 15:49:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qfBl5zu7qqaqfEoc5Ekr41qPkg4LEUSKBzjd3C0LgyI=;
        b=Ff5bCisNITCKlg5tk/gWouMm30fKWCZvhKWs+sTdKQijthmsJ/yklC8QI0P1oNzp8i
         +8n4Ue3KIdERf9A99Bd9RFPICvVKTzJn0tBqkPPupQxHLBRFNvF2YOcMMxtcRhoYPqEP
         NQXLMHqxCwRyDChT5r83X1Ndy6fr+ZqOtE+zFsZ90429JkvypY9tBTq8M+9jDNihObuF
         O9VfD6+zRag5OkOl3Q/Wi9IRGb8gJ4fzjGb9ckXxsDQEjOMbRGMlVz9NIo8tUr+a/WAR
         QO870fOFGr1E+qv+McwvnZygu0vkW+XAGKctaNbF3TxdG38AFoRYqNRlaolAf025T42E
         096w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=qfBl5zu7qqaqfEoc5Ekr41qPkg4LEUSKBzjd3C0LgyI=;
        b=ENy0rU83aYoUxAl51oTRH3s7FgGjOQqc8I7hEXmpJHBurzwfM21eeMlQvl/e26uiri
         9d2rzwcjISWoBgzM/++pr30NZuPjmykx7zc7NXlKPeY61Wy034qrXlJeX3h7X69fhzEQ
         4hncLN7mo9TW6mhJl88aOm1q6wJ+5zgD/6gqbf849VtLV5oQUW6HjIE0v4oZVVYgY9k5
         lXhDhYRQLfGaugg+kU6eNzCvxdpNGsnPLs8I6KLNFoUZGHqUiM+TiwbudOgkhqDBIObf
         u2v85GLWAaHqxcj/urt2m7y4J8XgZ0Tin2hQSnBogQhCVHWytEps/JzewKIXRiLiZjbd
         IxHw==
X-Gm-Message-State: AOAM533cT3SitQIfVQk+KSIycYEyY+xCFvsXlwotKasKQwUGrgfFrRhA
        92S1nWF/5tYi1kI68TbaYMY=
X-Google-Smtp-Source: ABdhPJz6OXwSMHzu10q69LRFF1Yrfkr7Dn85P3kA7qfgqpH38ppAA98p9nKbjUpb+54rPCBwgB4HWw==
X-Received: by 2002:a63:c74f:: with SMTP id v15mr1520823pgg.143.1600901395001;
        Wed, 23 Sep 2020 15:49:55 -0700 (PDT)
Received: from [10.67.49.188] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id i8sm426379pjv.43.2020.09.23.15.49.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Sep 2020 15:49:54 -0700 (PDT)
Subject: Re: [PATCH net-next v3 1/2] net: dsa: untag the bridge pvid from rx
 skbs
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "nikolay@nvidia.com" <nikolay@nvidia.com>
References: <20200923214038.3671566-1-f.fainelli@gmail.com>
 <20200923214038.3671566-2-f.fainelli@gmail.com>
 <20200923214852.x2z5gb6pzaphpfvv@skbuf>
 <7fce7ddd-14a3-8301-d927-1dd4b4431ffb@gmail.com>
 <20200923220121.phnctzovjkiw2qiz@skbuf>
 <c8ca2861-44b2-4333-d63e-638dfe2f06a0@gmail.com>
 <2601834a-2cf2-f0f4-3775-2a5ebccad40a@gmail.com>
 <20200923222522.suhyowo4ii3qvvpm@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 mQGiBEjPuBIRBACW9MxSJU9fvEOCTnRNqG/13rAGsj+vJqontvoDSNxRgmafP8d3nesnqPyR
 xGlkaOSDuu09rxuW+69Y2f1TzjFuGpBk4ysWOR85O2Nx8AJ6fYGCoeTbovrNlGT1M9obSFGQ
 X3IzRnWoqlfudjTO5TKoqkbOgpYqIo5n1QbEjCCwCwCg3DOH/4ug2AUUlcIT9/l3pGvoRJ0E
 AICDzi3l7pmC5IWn2n1mvP5247urtHFs/uusE827DDj3K8Upn2vYiOFMBhGsxAk6YKV6IP0d
 ZdWX6fqkJJlu9cSDvWtO1hXeHIfQIE/xcqvlRH783KrihLcsmnBqOiS6rJDO2x1eAgC8meAX
 SAgsrBhcgGl2Rl5gh/jkeA5ykwbxA/9u1eEuL70Qzt5APJmqVXR+kWvrqdBVPoUNy/tQ8mYc
 nzJJ63ng3tHhnwHXZOu8hL4nqwlYHRa9eeglXYhBqja4ZvIvCEqSmEukfivk+DlIgVoOAJbh
 qIWgvr3SIEuR6ayY3f5j0f2ejUMYlYYnKdiHXFlF9uXm1ELrb0YX4GMHz7QnRmxvcmlhbiBG
 YWluZWxsaSA8Zi5mYWluZWxsaUBnbWFpbC5jb20+iGYEExECACYCGyMGCwkIBwMCBBUCCAME
 FgIDAQIeAQIXgAUCVF/S8QUJHlwd3wAKCRBhV5kVtWN2DvCVAJ4u4/bPF4P3jxb4qEY8I2gS
 6hG0gACffNWlqJ2T4wSSn+3o7CCZNd7SLSC5BA0ESM+4EhAQAL/o09boR9D3Vk1Tt7+gpYr3
 WQ6hgYVON905q2ndEoA2J0dQxJNRw3snabHDDzQBAcqOvdi7YidfBVdKi0wxHhSuRBfuOppu
 pdXkb7zxuPQuSveCLqqZWRQ+Cc2QgF7SBqgznbe6Ngout5qXY5Dcagk9LqFNGhJQzUGHAsIs
 hap1f0B1PoUyUNeEInV98D8Xd/edM3mhO9nRpUXRK9Bvt4iEZUXGuVtZLT52nK6Wv2EZ1TiT
 OiqZlf1P+vxYLBx9eKmabPdm3yjalhY8yr1S1vL0gSA/C6W1o/TowdieF1rWN/MYHlkpyj9c
 Rpc281gAO0AP3V1G00YzBEdYyi0gaJbCEQnq8Vz1vDXFxHzyhgGz7umBsVKmYwZgA8DrrB0M
 oaP35wuGR3RJcaG30AnJpEDkBYHznI2apxdcuTPOHZyEilIRrBGzDwGtAhldzlBoBwE3Z3MY
 31TOpACu1ZpNOMysZ6xiE35pWkwc0KYm4hJA5GFfmWSN6DniimW3pmdDIiw4Ifcx8b3mFrRO
 BbDIW13E51j9RjbO/nAaK9ndZ5LRO1B/8Fwat7bLzmsCiEXOJY7NNpIEpkoNoEUfCcZwmLrU
 +eOTPzaF6drw6ayewEi5yzPg3TAT6FV3oBsNg3xlwU0gPK3v6gYPX5w9+ovPZ1/qqNfOrbsE
 FRuiSVsZQ5s3AAMFD/9XjlnnVDh9GX/r/6hjmr4U9tEsM+VQXaVXqZuHKaSmojOLUCP/YVQo
 7IiYaNssCS4FCPe4yrL4FJJfJAsbeyDykMN7wAnBcOkbZ9BPJPNCbqU6dowLOiy8AuTYQ48m
 vIyQ4Ijnb6GTrtxIUDQeOBNuQC/gyyx3nbL/lVlHbxr4tb6YkhkO6shjXhQh7nQb33FjGO4P
 WU11Nr9i/qoV8QCo12MQEo244RRA6VMud06y/E449rWZFSTwGqb0FS0seTcYNvxt8PB2izX+
 HZA8SL54j479ubxhfuoTu5nXdtFYFj5Lj5x34LKPx7MpgAmj0H7SDhpFWF2FzcC1bjiW9mjW
 HaKaX23Awt97AqQZXegbfkJwX2Y53ufq8Np3e1542lh3/mpiGSilCsaTahEGrHK+lIusl6mz
 Joil+u3k01ofvJMK0ZdzGUZ/aPMZ16LofjFA+MNxWrZFrkYmiGdv+LG45zSlZyIvzSiG2lKy
 kuVag+IijCIom78P9jRtB1q1Q5lwZp2TLAJlz92DmFwBg1hyFzwDADjZ2nrDxKUiybXIgZp9
 aU2d++ptEGCVJOfEW4qpWCCLPbOT7XBr+g/4H3qWbs3j/cDDq7LuVYIe+wchy/iXEJaQVeTC
 y5arMQorqTFWlEOgRA8OP47L9knl9i4xuR0euV6DChDrguup2aJVU4hPBBgRAgAPAhsMBQJU
 X9LxBQkeXB3fAAoJEGFXmRW1Y3YOj4UAn3nrFLPZekMeqX5aD/aq/dsbXSfyAKC45Go0YyxV
 HGuUuzv+GKZ6nsysJ7kCDQRXG8fwARAA6q/pqBi5PjHcOAUgk2/2LR5LjjesK50bCaD4JuNc
 YDhFR7Vs108diBtsho3w8WRd9viOqDrhLJTroVckkk74OY8r+3t1E0Dd4wHWHQZsAeUvOwDM
 PQMqTUBFuMi6ydzTZpFA2wBR9x6ofl8Ax+zaGBcFrRlQnhsuXLnM1uuvS39+pmzIjasZBP2H
 UPk5ifigXcpelKmj6iskP3c8QN6x6GjUSmYx+xUfs/GNVSU1XOZn61wgPDbgINJd/THGdqiO
 iJxCLuTMqlSsmh1+E1dSdfYkCb93R/0ZHvMKWlAx7MnaFgBfsG8FqNtZu3PCLfizyVYYjXbV
 WO1A23riZKqwrSJAATo5iTS65BuYxrFsFNPrf7TitM8E76BEBZk0OZBvZxMuOs6Z1qI8YKVK
 UrHVGFq3NbuPWCdRul9SX3VfOunr9Gv0GABnJ0ET+K7nspax0xqq7zgnM71QEaiaH17IFYGS
 sG34V7Wo3vyQzsk7qLf9Ajno0DhJ+VX43g8+AjxOMNVrGCt9RNXSBVpyv2AMTlWCdJ5KI6V4
 KEzWM4HJm7QlNKE6RPoBxJVbSQLPd9St3h7mxLcne4l7NK9eNgNnneT7QZL8fL//s9K8Ns1W
 t60uQNYvbhKDG7+/yLcmJgjF74XkGvxCmTA1rW2bsUriM533nG9gAOUFQjURkwI8jvMAEQEA
 AYkCaAQYEQIACQUCVxvH8AIbAgIpCRBhV5kVtWN2DsFdIAQZAQIABgUCVxvH8AAKCRCH0Jac
 RAcHBIkHD/9nmfog7X2ZXMzL9ktT++7x+W/QBrSTCTmq8PK+69+INN1ZDOrY8uz6htfTLV9+
 e2W6G8/7zIvODuHk7r+yQ585XbplgP0V5Xc8iBHdBgXbqnY5zBrcH+Q/oQ2STalEvaGHqNoD
 UGyLQ/fiKoLZTPMur57Fy1c9rTuKiSdMgnT0FPfWVDfpR2Ds0gpqWePlRuRGOoCln5GnREA/
 2MW2rWf+CO9kbIR+66j8b4RUJqIK3dWn9xbENh/aqxfonGTCZQ2zC4sLd25DQA4w1itPo+f5
 V/SQxuhnlQkTOCdJ7b/mby/pNRz1lsLkjnXueLILj7gNjwTabZXYtL16z24qkDTI1x3g98R/
 xunb3/fQwR8FY5/zRvXJq5us/nLvIvOmVwZFkwXc+AF+LSIajqQz9XbXeIP/BDjlBNXRZNdo
 dVuSU51ENcMcilPr2EUnqEAqeczsCGpnvRCLfVQeSZr2L9N4svNhhfPOEscYhhpHTh0VPyxI
 pPBNKq+byuYPMyk3nj814NKhImK0O4gTyCK9b+gZAVvQcYAXvSouCnTZeJRrNHJFTgTgu6E0
 caxTGgc5zzQHeX67eMzrGomG3ZnIxmd1sAbgvJUDaD2GrYlulfwGWwWyTNbWRvMighVdPkSF
 6XFgQaosWxkV0OELLy2N485YrTr2Uq64VKyxpncLh50e2RnyAJ9Za0Dx0yyp44iD1OvHtkEI
 M5kY0ACeNhCZJvZ5g4C2Lc9fcTHu8jxmEkI=
Message-ID: <5aae1978-501e-ffc1-6744-59a3cd6b52e8@gmail.com>
Date:   Wed, 23 Sep 2020 15:49:47 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200923222522.suhyowo4ii3qvvpm@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/23/20 3:25 PM, Vladimir Oltean wrote:
> On Wed, Sep 23, 2020 at 03:08:49PM -0700, Florian Fainelli wrote:
>> On 9/23/20 3:06 PM, Florian Fainelli wrote:
>>> On 9/23/20 3:01 PM, Vladimir Oltean wrote:
>>>> On Wed, Sep 23, 2020 at 02:51:09PM -0700, Florian Fainelli wrote:
>>>>> Speaking of that part of the code, I was also wondering whether you
>>>>> wanted this to be netdev_for_each_upper_dev_rcu(br, upper_dev, iter) and
>>>>> catch a bridge device upper as opposed to a switch port upper? Either
>>>>> way is fine and there are possibly use cases for either.
>>>>
>>>> So, yeah, both use cases are valid, and I did in fact mean uppers of the
>>>> bridge, but now that you're raising the point, do we actually support
>>>> properly the use case with an 8021q upper of a bridged port? My
>>>> understanding is that this VLAN-tagged traffic should not be switched on
>>>> RX. So without some ACL rule on ingress that the driver must install, I
>>>> don't see how that can work properly.
>>>
>>> Is not this a problem only if the DSA master does VLAN receive filtering
>>> though?
> 
> I don't understand how the DSA master is involved here, sorry.

I do not have a VLAN filtering DSA master at hand so maybe I am
fantasizing on something that is not a problem, but if the switch send
tagged traffic towards the DSA master and that DSA master is VLAN
filtering on receive and today we are not making sure that those VLANs
are programmed into the filter (regardless of a bridge existing), how do
we deliver these VLAN tagged frames to the DSA master?

> 
>>> In a bridge with vlan_filtering=0 the switch port is supposed to
>>> accept any VLAN tagged frames because it does not do ingress VLAN ID
>>> checking.
>>>
>>> Prior to your patch, I would always install a br0.1 upper to pop the
>>> default_pvid and that would work fine because the underlying DSA master
>>> does not do VLAN filtering.
> 
> Yes, but on both your Broadcom tags, the VLAN header is shifted to the
> right, so the master's hardware parser shouldn't figure out it's looking
> at VLAN (unless your master is DSA-aware). So again, I don't see how
> that makes a difference.

The NICs are all Broadcom tag aware but it only seems to matter to them
for checksum purposes, as none support VLAN extraction or filtering. I
get your point now.

> 
>>
>> This is kind of a bad example, because the switch port has been added to
>> the default_pvid VLAN entry, but I believe the rest to be correct though.
> 
> I don't think it's a bad example, and I think that we should try to keep
> br0.1 working.
> 
> Given the fact that all skbs are received as VLAN-tagged, the
> dsa_untag_bridge_pvid function tries to guess what is the intention of
> the user, in order to figure out when it should strip that tag and when
> it shouldn't. When there is a swp0.1 upper, it is clear (to me, at
> least) that the intention of the user is to terminate some traffic on
> it, so the VLAN tag should be kept. Same should apply to br0.1. The only
> difference is that swp0.1 might not work correctly today due to other,
> unrelated reasons (like I said, the 8021q upper should 'steal' traffic
> from the bridge inside the actual hardware datapath, but without
> explicit configuration, which we don't have, it isn't really doing
> that). Lastly, in absence of any 8021q upper, the function should untag
> the skb to allow VLAN-unaware networking to be performed through the
> bridge, because, presumably, that VLAN was added only as a side effect
> of driver internal configuration, and is not desirable to any upper
> layer.
> 

I don't think it would be making much sense to add an 802.1Q upper for
the bridge's default_pvid to the switch port, and add that upper as a
bridge port. Maybe we should make it work, maybe not.
-- 
Florian
