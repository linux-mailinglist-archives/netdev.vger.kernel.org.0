Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98AC21A469
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 23:19:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728086AbfEJVS6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 May 2019 17:18:58 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:40900 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727767AbfEJVS5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 May 2019 17:18:57 -0400
Received: by mail-wr1-f67.google.com with SMTP id h4so9286465wre.7;
        Fri, 10 May 2019 14:18:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:mime-version:message-id:in-reply-to
         :references:user-agent:content-transfer-encoding;
        bh=bYllTi8jpDtNJjUd5zBBxw0HJVYPX6WhjtOSbLVC9b8=;
        b=uGTioTFAOlBRUIV9IXvNX/QeqP63v4+loXn+2+k/hmbMtFdvpylHSwf3J4H+Gra4+7
         pnYUYPEKjnBduDg3UbHxBv1uUKRcoxMJIvRx7NOVyS9Tjyi8icSTkE1RnXQwTUMh7yWm
         E7D5DQFNcQDGZX6E2Ig0XHuunIry7ODDjuXQ1a0uLwCM/SGcYOveguQRUds+9oU+IoOP
         RzuAmkRGzkj+TURvEdP3Hoxb7Yxu7vQCz2W2n0YraqRIWQ+clLN92y1sipnZX7KC+ub5
         V/lGYWYDn6CWw5pYU0ubfQUTDFo3qe4z018qv7GShty/pZFxRjSC3VZesnkIVg9A0+xW
         8I/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:mime-version:message-id
         :in-reply-to:references:user-agent:content-transfer-encoding;
        bh=bYllTi8jpDtNJjUd5zBBxw0HJVYPX6WhjtOSbLVC9b8=;
        b=hsBNGAldOXHrLOuciPXQOdMwsRd5RIUD9HYsnBMdzf8geHgm12XwvPcAOmgLG9Xro5
         hfActVKom5Z37/30VLHEEH5Jv5G7H6c5cqFKJcn+MBUz5uuumLAHl4clHyEtwC2qXAAN
         hl8FaOp2uupMwOaNoCCyrpY/4bSVyV2+vqgErKcbi9KOV8BZzkJL77A5l5zuSdzE9DN8
         9x/qQmKneNrAq62sX9RlY6voafU0VSC9WMijEBGsa/7p1cST//6+e6CVZjeszfTr4s/P
         TA9aLKjWPdtnA6HsUnqkG3iBsEpaXVonCfz4z6s6HRYuF/IGv0LI7dmTB7IhHaWlJC8Z
         znsg==
X-Gm-Message-State: APjAAAU7UXnSnwFOlpDNFVpRH/ZeLa8RKdkrzgb4ZZCjCxpLd/pSE5jX
        0y887P2MVg26SusUlG24ifxz/C1IxP+6eA==
X-Google-Smtp-Source: APXvYqxdKLKEcgkJmKn3wJW070jw9Ue+FcwQ6Lk76nd2n+zLdpS24Y7Za/Ng9w80gjOMRSU9OqW0LQ==
X-Received: by 2002:a5d:4e8d:: with SMTP id e13mr1852856wru.299.1557523135851;
        Fri, 10 May 2019 14:18:55 -0700 (PDT)
Received: from localhost ([92.59.185.54])
        by smtp.gmail.com with ESMTPSA id l18sm3451729wrv.38.2019.05.10.14.18.54
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 10 May 2019 14:18:55 -0700 (PDT)
From:   Vicente Bergas <vicencb@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Serge Semin <fancer.lancer@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: net: phy: realtek: regression, kernel null pointer dereference
Date:   Fri, 10 May 2019 23:18:54 +0200
MIME-Version: 1.0
Message-ID: <e9265e58-1038-4194-a8de-f52f5bc3a7d8@gmail.com>
In-Reply-To: <742a2235-4571-aa7d-af90-14c708205c6f@gmail.com>
References: <16f75ff4-e3e3-4d96-b084-e772e3ce1c2b@gmail.com>
 <742a2235-4571-aa7d-af90-14c708205c6f@gmail.com>
User-Agent: Trojita
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Friday, May 10, 2019 10:28:06 PM CEST, Heiner Kallweit wrote:
> On 10.05.2019 17:05, Vicente Bergas wrote:
>> Hello,
>> there is a regression on linux v5.1-9573-gb970afcfcabd with a kernel null
>> pointer dereference.
>> The issue is the commit f81dadbcf7fd067baf184b63c179fc392bdb226e
>>  net: phy: realtek: Add rtl8211e rx/tx delays config ...
> The page operation callbacks are missing in the RTL8211E driver.
> I just submitted a fix adding these callbacks to few Realtek PHY drivers
> including RTl8211E. This should fix the issue.

Thanks for fixing it so fast!

> Nevertheless your proposed patch looks good to me, just one small change
> would be needed and it should be splitted.

The diff on the first mail was just to show which steps i did to debug the
issue, it was not intended to be applied.

Regards,
  Vicen=C3=A7.

> The change to phy-core I would consider a fix and it should be fine to
> submit it to net (net-next is closed currently).
>
> Adding the warning to the Realtek driver is fine, but this would be
> something for net-next once it's open again.
>
>> Regards,
>>  Vicen=C3=A7.
>>=20
> Heiner
>
>> --- a/drivers/net/phy/phy-core.c
>> +++ b/drivers/net/phy/phy-core.c
>> @@ -648,11 +648,17 @@
>>=20
>> static int __phy_read_page(struct phy_device *phydev)
>> { ...
>
> Here phydev_warn() should be used.
>
>> +        return 0;
>> +    }
>>=20
>>     ret =3D phy_write(phydev, RTL821x_EXT_PAGE_SELECT, 0xa4);
>>     if (ret)

