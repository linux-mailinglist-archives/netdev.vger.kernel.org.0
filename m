Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19DBF1318D0
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 20:35:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726742AbgAFTfY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 14:35:24 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:35961 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726569AbgAFTfX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jan 2020 14:35:23 -0500
Received: by mail-ed1-f65.google.com with SMTP id j17so48398837edp.3
        for <netdev@vger.kernel.org>; Mon, 06 Jan 2020 11:35:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pcREdpfrxoF79O2EJfgwnAEcmt1tKTcKwZIfJ1TvKxE=;
        b=W3/Gq2w14GdKs95oBvT5NrnIw4CP/y4yWuVwrl2QnuiXyfJpPwVV2vN2SEW0PgG6KF
         9KKRHezXPYyOHmmynG0una40CqVhKwKhhqlYyo5GcMEKL3UXGuVAve/DHu8tjOdg/OHb
         42ABlCcEvZ7n0NVEFWlbWFLyc7GNbk40wVpNeddqW+coI2O+ZDsgXaidZHld8ZZFGbX4
         KujvLEQ4hkXFw5pmh2y3HilUEEfB/8Y2tLe59w4xrEoCOrqCTOqzt/bBAsT8VclsaSzT
         7Hf+HZYr0EsP3jCgwUKckNQ4oxOao4eC1Cmw2FUIR8iwL3TQPrDYlhWWUZOgbQZRU3WF
         IdSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=pcREdpfrxoF79O2EJfgwnAEcmt1tKTcKwZIfJ1TvKxE=;
        b=b8mJzIVHqpZRNXoDIlAKEYT28fDje06vM9oWcILikemBhSfD9jyZqudv3ioljmWqma
         aawTP+DQXOqi8NdgOpuRaWrovWGoPQJPH5MVsLiE7YOrM95hFA8kb4NFEPJi/4nhWezV
         r4fFrSk3Iamujy6lGVzNBTPLNz8aJxEVdtkiNSrtET7Z0RfHSp3CI7aRIXPFNvPQzxgW
         /ruFKzkcvWUfpP7H4TmntPGOpUYrseMPLmrcbOrjW9AOvoRnpWsHqdINwH2w1ma0J4uF
         +OwItzbT8WgulcC2epyYBM0ZYdOCsDWhCYSxcUTEy6HCBI/bkUULKiKl1amlvL8O7tKz
         gesg==
X-Gm-Message-State: APjAAAU7D5F4Onpsia1P5bHx1rb4CSAu2e0/tmJ+o1tCGxaOFCtIof2T
        mpusMhHlV5MVY6NZA/P8G2g=
X-Google-Smtp-Source: APXvYqz688idvalqXIHSefY3oTheQnNRUOdPp2/5Q8/6ESywIMwVI0EAtA8Wq/1v6GvwF6+EIAekVQ==
X-Received: by 2002:a50:a105:: with SMTP id 5mr5646709edj.75.1578339321319;
        Mon, 06 Jan 2020 11:35:21 -0800 (PST)
Received: from [10.67.50.41] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id ch8sm8070993ejb.9.2020.01.06.11.35.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Jan 2020 11:35:20 -0800 (PST)
Subject: Re: [PATCH v5 net-next 5/9] enetc: Make MDIO accessors more generic
 and export to include/linux/fsl
To:     Vladimir Oltean <olteanv@gmail.com>, davem@davemloft.net,
        jakub.kicinski@netronome.com, linux@armlinux.org.uk,
        andrew@lunn.ch, vivien.didelot@gmail.com
Cc:     alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, yangbo.lu@nxp.com,
        netdev@vger.kernel.org, alexandre.belloni@bootlin.com,
        horatiu.vultur@microchip.com, UNGLinuxDriver@microchip.com,
        Vladimir Oltean <vladimir.oltean@nxp.com>
References: <20200106013417.12154-1-olteanv@gmail.com>
 <20200106013417.12154-6-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 xsDiBEjPuBIRBACW9MxSJU9fvEOCTnRNqG/13rAGsj+vJqontvoDSNxRgmafP8d3nesnqPyR
 xGlkaOSDuu09rxuW+69Y2f1TzjFuGpBk4ysWOR85O2Nx8AJ6fYGCoeTbovrNlGT1M9obSFGQ
 X3IzRnWoqlfudjTO5TKoqkbOgpYqIo5n1QbEjCCwCwCg3DOH/4ug2AUUlcIT9/l3pGvoRJ0E
 AICDzi3l7pmC5IWn2n1mvP5247urtHFs/uusE827DDj3K8Upn2vYiOFMBhGsxAk6YKV6IP0d
 ZdWX6fqkJJlu9cSDvWtO1hXeHIfQIE/xcqvlRH783KrihLcsmnBqOiS6rJDO2x1eAgC8meAX
 SAgsrBhcgGl2Rl5gh/jkeA5ykwbxA/9u1eEuL70Qzt5APJmqVXR+kWvrqdBVPoUNy/tQ8mYc
 nzJJ63ng3tHhnwHXZOu8hL4nqwlYHRa9eeglXYhBqja4ZvIvCEqSmEukfivk+DlIgVoOAJbh
 qIWgvr3SIEuR6ayY3f5j0f2ejUMYlYYnKdiHXFlF9uXm1ELrb0YX4GMHz80nRmxvcmlhbiBG
 YWluZWxsaSA8Zi5mYWluZWxsaUBnbWFpbC5jb20+wmYEExECACYCGyMGCwkIBwMCBBUCCAME
 FgIDAQIeAQIXgAUCVF/S8QUJHlwd3wAKCRBhV5kVtWN2DvCVAJ4u4/bPF4P3jxb4qEY8I2gS
 6hG0gACffNWlqJ2T4wSSn+3o7CCZNd7SLSDOwU0EVxvH8AEQAOqv6agYuT4x3DgFIJNv9i0e
 S443rCudGwmg+CbjXGA4RUe1bNdPHYgbbIaN8PFkXfb4jqg64SyU66FXJJJO+DmPK/t7dRNA
 3eMB1h0GbAHlLzsAzD0DKk1ARbjIusnc02aRQNsAUfceqH5fAMfs2hgXBa0ZUJ4bLly5zNbr
 r0t/fqZsyI2rGQT9h1D5OYn4oF3KXpSpo+orJD93PEDeseho1EpmMfsVH7PxjVUlNVzmZ+tc
 IDw24CDSXf0xxnaojoicQi7kzKpUrJodfhNXUnX2JAm/d0f9GR7zClpQMezJ2hYAX7BvBajb
 Wbtzwi34s8lWGI121VjtQNt64mSqsK0iQAE6OYk0uuQbmMaxbBTT63+04rTPBO+gRAWZNDmQ
 b2cTLjrOmdaiPGClSlKx1RhatzW7j1gnUbpfUl91Xzrp6/Rr9BgAZydBE/iu57KWsdMaqu84
 JzO9UBGomh9eyBWBkrBt+Fe1qN78kM7JO6i3/QI56NA4SflV+N4PPgI8TjDVaxgrfUTV0gVa
 cr9gDE5VgnSeSiOleChM1jOByZu0JTShOkT6AcSVW0kCz3fUrd4e5sS3J3uJezSvXjYDZ53k
 +0GS/Hy//7PSvDbNVretLkDWL24Sgxu/v8i3JiYIxe+F5Br8QpkwNa1tm7FK4jOd95xvYADl
 BUI1EZMCPI7zABEBAAHCwagEGBECAAkFAlcbx/ACGwICKQkQYVeZFbVjdg7BXSAEGQECAAYF
 Alcbx/AACgkQh9CWnEQHBwSJBw//Z5n6IO19mVzMy/ZLU/vu8flv0Aa0kwk5qvDyvuvfiDTd
 WQzq2PLs+obX0y1ffntluhvP+8yLzg7h5O6/skOfOV26ZYD9FeV3PIgR3QYF26p2Ocwa3B/k
 P6ENkk2pRL2hh6jaA1Bsi0P34iqC2UzzLq+exctXPa07ioknTIJ09BT31lQ36Udg7NIKalnj
 5UbkRjqApZ+Rp0RAP9jFtq1n/gjvZGyEfuuo/G+EVCaiCt3Vp/cWxDYf2qsX6JxkwmUNswuL
 C3duQ0AOMNYrT6Pn+Vf0kMboZ5UJEzgnSe2/5m8v6TUc9ZbC5I517niyC4+4DY8E2m2V2LS9
 es9uKpA0yNcd4PfEf8bp29/30MEfBWOf80b1yaubrP5y7yLzplcGRZMF3PgBfi0iGo6kM/V2
 13iD/wQ45QTV0WTXaHVbklOdRDXDHIpT69hFJ6hAKnnM7AhqZ70Qi31UHkma9i/TeLLzYYXz
 zhLHGIYaR04dFT8sSKTwTSqvm8rmDzMpN54/NeDSoSJitDuIE8givW/oGQFb0HGAF70qLgp0
 2XiUazRyRU4E4LuhNHGsUxoHOc80B3l+u3jM6xqJht2ZyMZndbAG4LyVA2g9hq2JbpX8BlsF
 skzW1kbzIoIVXT5EhelxYEGqLFsZFdDhCy8tjePOWK069lKuuFSssaZ3C4edHtkZ8gCfWWtA
 8dMsqeOIg9Trx7ZBCDOZGNAAnjYQmSb2eYOAti3PX3Ex7vI8ZhJCzsNNBEjPuBIQEAC/6NPW
 6EfQ91ZNU7e/oKWK91kOoYGFTjfdOatp3RKANidHUMSTUcN7J2mxww80AQHKjr3Yu2InXwVX
 SotMMR4UrkQX7jqabqXV5G+88bj0Lkr3gi6qmVkUPgnNkIBe0gaoM523ujYKLreal2OQ3GoJ
 PS6hTRoSUM1BhwLCLIWqdX9AdT6FMlDXhCJ1ffA/F3f3nTN5oTvZ0aVF0SvQb7eIhGVFxrlb
 WS0+dpyulr9hGdU4kzoqmZX9T/r8WCwcfXipmmz3Zt8o2pYWPMq9Utby9IEgPwultaP06MHY
 nhda1jfzGB5ZKco/XEaXNvNYADtAD91dRtNGMwRHWMotIGiWwhEJ6vFc9bw1xcR88oYBs+7p
 gbFSpmMGYAPA66wdDKGj9+cLhkd0SXGht9AJyaRA5AWB85yNmqcXXLkzzh2chIpSEawRsw8B
 rQIZXc5QaAcBN2dzGN9UzqQArtWaTTjMrGesYhN+aVpMHNCmJuISQORhX5lkjeg54oplt6Zn
 QyIsOCH3MfG95ha0TgWwyFtdxOdY/UY2zv5wGivZ3WeS0TtQf/BcGre2y85rAohFziWOzTaS
 BKZKDaBFHwnGcJi61Pnjkz82hena8OmsnsBIucsz4N0wE+hVd6AbDYN8ZcFNIDyt7+oGD1+c
 PfqLz2df6qjXzq27BBUboklbGUObNwADBQ//V45Z51Q4fRl/6/+oY5q+FPbRLDPlUF2lV6mb
 hymkpqIzi1Aj/2FUKOyImGjbLAkuBQj3uMqy+BSSXyQLG3sg8pDDe8AJwXDpG2fQTyTzQm6l
 OnaMCzosvALk2EOPJryMkOCI52+hk67cSFA0HjgTbkAv4Mssd52y/5VZR28a+LW+mJIZDurI
 Y14UIe50G99xYxjuD1lNdTa/Yv6qFfEAqNdjEBKNuOEUQOlTLndOsvxOOPa1mRUk8Bqm9BUt
 LHk3GDb8bfDwdos1/h2QPEi+eI+O/bm8YX7qE7uZ13bRWBY+S4+cd+Cyj8ezKYAJo9B+0g4a
 RVhdhc3AtW44lvZo1h2iml9twMLfewKkGV3oG35CcF9mOd7n6vDad3teeNpYd/5qYhkopQrG
 k2oRBqxyvpSLrJepsyaIpfrt5NNaH7yTCtGXcxlGf2jzGdei6H4xQPjDcVq2Ra5GJohnb/ix
 uOc0pWciL80ohtpSspLlWoPiIowiKJu/D/Y0bQdatUOZcGadkywCZc/dg5hcAYNYchc8AwA4
 2dp6w8SlIsm1yIGafWlNnfvqbRBglSTnxFuKqVggiz2zk+1wa/oP+B96lm7N4/3Aw6uy7lWC
 HvsHIcv4lxCWkFXkwsuWqzEKK6kxVpRDoEQPDj+Oy/ZJ5fYuMbkdHrlegwoQ64LrqdmiVVPC
 TwQYEQIADwIbDAUCVF/S8QUJHlwd3wAKCRBhV5kVtWN2Do+FAJ956xSz2XpDHql+Wg/2qv3b
 G10n8gCguORqNGMsVRxrlLs7/himep7MrCc=
Message-ID: <8718ea22-d1aa-fe58-bd69-521eeee5190a@gmail.com>
Date:   Mon, 6 Jan 2020 11:35:14 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200106013417.12154-6-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/5/20 5:34 PM, Vladimir Oltean wrote:
> From: Claudiu Manoil <claudiu.manoil@nxp.com>
> 
> Within the LS1028A SoC, the register map for the ENETC MDIO controller
> is instantiated a few times: for the central (external) MDIO controller,
> for the internal bus of each standalone ENETC port, and for the internal
> bus of the Felix switch.
> 
> Refactoring is needed to support multiple MDIO buses from multiple
> drivers. The enetc_hw structure is made an opaque type and a smaller
> enetc_mdio_priv is created.
> 
> 'mdio_base' - MDIO registers base address - is being parameterized, to
> be able to work with different MDIO register bases.
> 
> The ENETC MDIO bus operations are exported from the fsl-enetc-mdio
> kernel object, the same that registers the central MDIO controller (the
> dedicated PF). The ENETC main driver has been changed to select it, and
> use its exported helpers to further register its private MDIO bus. The
> DSA Felix driver will do the same.

This series has already been applied so this may be food for thought at
this point, but why was not the solution to create a standalone mii_bus
driver and have all consumers be pointed it?

It is not uncommon for MDIO controllers to be re-used and integrated
within a larger block and when that happens whoever owns the largest
address space, say the Ethernet MAC can request the large resource
region and the MDIO bus controler can work on that premise, that's what
we did with genet/bcmmii.c and mdio-bcm-unimac.c for instance (so we
only do an ioremap, not request_mem_region + ioremap).

Your commit message does not provide a justification for why this
abstraction (mii_bus) was not suitable or considered here. Do you think
that could be changed?

Thanks!
-- 
Florian
