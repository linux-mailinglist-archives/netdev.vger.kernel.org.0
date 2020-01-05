Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51E361305B1
	for <lists+netdev@lfdr.de>; Sun,  5 Jan 2020 05:39:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbgAEEjS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jan 2020 23:39:18 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:43565 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726240AbgAEEjS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jan 2020 23:39:18 -0500
Received: by mail-pg1-f195.google.com with SMTP id k197so25251156pga.10
        for <netdev@vger.kernel.org>; Sat, 04 Jan 2020 20:39:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=btNboQ5Spk/+AUDdJagF8ukvr5d84/WRoFmMpaxmyEM=;
        b=QYlHJTVUN1lj4QJ9/B0BP9hKSkGLMHOteODXp4sFTi193cZHeUh0Oi5veQNdVoh07g
         HwrcRHSXzfI2zP1X1b6lUuaEBGLfDN2wgZwJzw+pBRvoAIH3zwX0O6XKHmwDDL3jwWV8
         xEGWIVfey8gDWOd8wDyRMuyzl53HG9YPLtrsTFqYjm1yOdpOOJrhaI68x2VoCMtThO+o
         7HvAAi1UDe1wMbCc86v+DF42DZn84V5WLqHcrMkzCeUqdmOeUoRKWPYXC8dUdrRDPlFn
         ddnfgB27zCjmVrnIkMYA5P43csmTLz1wrmTs32BsjM9ZwrRYUWYY223NDft6gig6tjBJ
         VbtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=btNboQ5Spk/+AUDdJagF8ukvr5d84/WRoFmMpaxmyEM=;
        b=AtpzAJOrC8vo1apNwtgpL/IDE+ChHQj0ulJ/Ir03yr+F9uhoT9avBu922T0bmFQDWR
         S8IT6vePvQtt2ZYz2IAaDmZokRPFEk7QW5EQVVgaEuDYZzn8hXHN7Ww0y+Rf6b50tdSi
         PhygrMmzskfU7QDshSSNgLBDa/iAtSgM4GB4/tBHIW08IH8ts6vdu1oe1SILFXVXmBxl
         2x5vR+CnJvbFhWG0TqVey3PVxvviIFnIZhSY/nKrPYughmeu+dUycy1AEWSyrp1o49YD
         RWQGCXD3r2ZtALopVlu8zBTJ4p3cQJZH7m0Uj/YSIanhQKEzHemr5wlRdwaFDeyy4CAI
         baAw==
X-Gm-Message-State: APjAAAX59rPZyaUdwIeu7rRaB0J6i7B124rk1fC2memMGhFcigexOrpu
        F4dg0PqK9JF8IlJCDyI0db8hcTdm
X-Google-Smtp-Source: APXvYqx6lD9bCyE50xAXT23T87MsKH9oZ87XeLRdGFohwu8Ta17Mdm4tFOvBGx0PBBKi7BxrOuH8PA==
X-Received: by 2002:aa7:8e13:: with SMTP id c19mr68434179pfr.227.1578199156972;
        Sat, 04 Jan 2020 20:39:16 -0800 (PST)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id d4sm19498667pjz.12.2020.01.04.20.39.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 04 Jan 2020 20:39:16 -0800 (PST)
Subject: Re: [PATCH v2 net-next 2/3] net: dsa: Make deferred_xmit private to
 sja1105
To:     Vladimir Oltean <olteanv@gmail.com>, vivien.didelot@gmail.com,
        andrew@lunn.ch, davem@davemloft.net
Cc:     netdev@vger.kernel.org
References: <20200104003711.18366-1-olteanv@gmail.com>
 <20200104003711.18366-3-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
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
 6XFgQaosWxkV0OELLy2N485YrTr2Uq64VKyxpncLh50e2RnyAJ9qfUATKC9NgZjRvBztfqy4
 a9BQwACgnzGuH1BVeT2J0Ra+ZYgkx7DaPR0=
Message-ID: <06cfe113-745c-5a67-1eae-b1305943f46f@gmail.com>
Date:   Sat, 4 Jan 2020 20:39:16 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20200104003711.18366-3-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/3/2020 4:37 PM, Vladimir Oltean wrote:
> There are 3 things that are wrong with the DSA deferred xmit mechanism:
> 
> 1. Its introduction has made the DSA hotpath ever so slightly more
>    inefficient for everybody, since DSA_SKB_CB(skb)->deferred_xmit needs
>    to be initialized to false for every transmitted frame, in order to
>    figure out whether the driver requested deferral or not (a very rare
>    occasion, rare even for the only driver that does use this mechanism:
>    sja1105). That was necessary to avoid kfree_skb from freeing the skb.
> 
> 2. Because L2 PTP is a link-local protocol like STP, it requires
>    management routes and deferred xmit with this switch. But as opposed
>    to STP, the deferred work mechanism needs to schedule the packet
>    rather quickly for the TX timstamp to be collected in time and sent
>    to user space. But there is no provision for controlling the
>    scheduling priority of this deferred xmit workqueue. Too bad this is
>    a rather specific requirement for a feature that nobody else uses
>    (more below).
> 
> 3. Perhaps most importantly, it makes the DSA core adhere a bit too
>    much to the NXP company-wide policy "Innovate Where It Doesn't
>    Matter". The sja1105 is probably the only DSA switch that requires
>    some frames sent from the CPU to be routed to the slave port via an
>    out-of-band configuration (register write) rather than in-band (DSA
>    tag). And there are indeed very good reasons to not want to do that:
>    if that out-of-band register is at the other end of a slow bus such
>    as SPI, then you limit that Ethernet flow's throughput to effectively
>    the throughput of the SPI bus. So hardware vendors should definitely
>    not be encouraged to design this way. We do _not_ want more
>    widespread use of this mechanism.
> 
> Luckily we have a solution for each of the 3 issues:
> 
> For 1, we can just remove that variable in the skb->cb and counteract
> the effect of kfree_skb with skb_get, much to the same effect. The
> advantage, of course, being that anybody who doesn't use deferred xmit
> doesn't need to do any extra operation in the hotpath.
> 
> For 2, we can create a kernel thread for each port's deferred xmit work.
> If the user switch ports are named swp0, swp1, swp2, the kernel threads
> will be named swp0_xmit, swp1_xmit, swp2_xmit (there appears to be a 15
> character length limit on kernel thread names). With this, the user can
> change the scheduling priority with chrt $(pidof swp2_xmit).
> 
> For 3, we can actually move the entire implementation to the sja1105
> driver.
> 
> So this patch deletes the generic implementation from the DSA core and
> adds a new one, more adequate to the requirements of PTP TX
> timestamping, in sja1105_main.c.
> 
> Suggested-by: Florian Fainelli <f.fainelli@gmail.com>
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

Thanks for addressing this so quickly.
-- 
Florian
