Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5A73B2971
	for <lists+netdev@lfdr.de>; Sat, 14 Sep 2019 05:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730658AbfINC7J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 22:59:09 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:38461 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730479AbfINC7J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Sep 2019 22:59:09 -0400
Received: by mail-ot1-f66.google.com with SMTP id h17so27389356otn.5
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 19:59:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/seHVHx61NKB3A5zoct31LN0/TaJypPmdOKNBbiRtQ0=;
        b=abFzT0VwntmH3ES6sVkhsomAPe7N6H4RuPdBLej+415eyIdVlD74agD/X76hLnlzcF
         sPwhzZGLvVSb+B4l+Vh7Hacos9j4mpkw1c872Na/FgY6NMeozKEugUPk4KuyikvypKgt
         wNCzZccK8OsJkPtsGZ2v7BmYPlupy3wvz8nr7uMhPr2NTHACxDD+UdFX50gwz63PE+or
         2oE84aFxMte+QVqIYMyYsTJBkn5ZTzJRSiEUmqN6GjIQG/ziJKiFOpbcrj7yrJ+IA0Pw
         7gEAUQoIAEs03Wf5Ye9UdsbeadPcf/R/eolZy8Uqa8rWxCNcjIKGDipfjNJ8g2yp53HM
         81Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/seHVHx61NKB3A5zoct31LN0/TaJypPmdOKNBbiRtQ0=;
        b=LbiATZu3oOGotnktEJ9FHAuSrCEx+YSrVU1Ive6JgdHZXJyHAYdP0xj0UJeRXV9mId
         ZNIIqODwGJ2zqBjTbI+l/cbYoQbPbArGqoHdvqTgxe/L5lZCMFwFsfsDIFmNYdpy62Ep
         T832tTsNwklfw82qyYiAZBWOEy6gSzNBpm3NTPdyuD4za+sHYoL8IC/EUJXp9R3/yupe
         To4rh2wXm1Fv7L0if7OKlOsfsYfcuB8A3YQCKoAv3MgMhRRs6PF/lN37dJuf6MbzoWIA
         R8Cf+i7AkhtyO+qd4vSIiYkRCp+bcQx9gsIGZ969Y5mTcFRffPB/cqZhr4dMiaWgoNdW
         ca7g==
X-Gm-Message-State: APjAAAWD5mz/FI4JmmxYKCZMJWhYRi4m35G8c9VVLQKH5HnUAKXNVdcX
        yqOA36Ds6XLAlsXC86MVG78zsnPiiXE=
X-Google-Smtp-Source: APXvYqxok3Usp4AswpcJ7uJ/TUyinY6eHjm5qTIo0weLF9afzhJXvlu5I1wSYAUpOb7/IP4U4nwRCg==
X-Received: by 2002:a9d:6a12:: with SMTP id g18mr14193365otn.37.1568429948498;
        Fri, 13 Sep 2019 19:59:08 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id r28sm1427044oij.31.2019.09.13.19.59.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 13 Sep 2019 19:59:07 -0700 (PDT)
Subject: Re: [PATCH v2 net-next 2/7] net: dsa: Pass ndo_setup_tc slave
 callback to drivers
To:     Vladimir Oltean <olteanv@gmail.com>, vivien.didelot@gmail.com,
        andrew@lunn.ch, davem@davemloft.net, vinicius.gomes@intel.com,
        vedang.patel@intel.com, richardcochran@gmail.com
Cc:     weifeng.voon@intel.com, jiri@mellanox.com, m-karicheri2@ti.com,
        Jose.Abreu@synopsys.com, ilias.apalodimas@linaro.org,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        kurt.kanzenbach@linutronix.de, joergen.andreasen@microchip.com,
        netdev@vger.kernel.org
References: <20190914011802.1602-1-olteanv@gmail.com>
 <20190914011802.1602-3-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <21fbd0cc-ff1f-5774-a65f-840d844ad2e6@gmail.com>
Date:   Fri, 13 Sep 2019 19:59:03 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20190914011802.1602-3-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/13/2019 6:17 PM, Vladimir Oltean wrote:
> DSA currently handles shared block filters (for the classifier-action
> qdisc) in the core due to what I believe are simply pragmatic reasons -
> hiding the complexity from drivers and offerring a simple API for port
> mirroring.
> 
> Extend the dsa_slave_setup_tc function by passing all other qdisc
> offloads to the driver layer, where the driver may choose what it
> implements and how. DSA is simply a pass-through in this case.
> 
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> Acked-by: Kurt Kanzenbach <kurt@linutronix.de>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
