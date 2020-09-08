Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50843260933
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 06:09:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725965AbgIHEJ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 00:09:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725801AbgIHEJZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 00:09:25 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A98F8C061573
        for <netdev@vger.kernel.org>; Mon,  7 Sep 2020 21:09:23 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id n14so1921438pff.6
        for <netdev@vger.kernel.org>; Mon, 07 Sep 2020 21:09:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3NjiSZ+VGfzD1s2phBZDGaniaF8Uh3Zo99AGMkpx5VE=;
        b=H10Ss0p/lwWNiQwtlQsSdP3gvns0HCnf0kY5wGjPNPvRD6C9wVmM0lsNIQY9Kl624E
         CoMlQlxXpOkAcGJaEhokxGQOzr4cq4Cexg6TLIphfEfAchfOgVlVp3rRhxDlHiAS/AIk
         TaH4JHzWYK+EhKnVmhzbYuUf52i7qCjjoprDgEgeaYrvdn5SLIfhpmpW9G/WC5Mh+Ep8
         rtsDgtwKhEt8711AO548j1RIMtZxO0mlbO6kXkqWlfGJhrKCxB+Lajo/P1dngjqV7HJJ
         9N54s8484eFlAEvVDtB0vrF0O7lOY5tLCZdpFIaYvcAGJH4MXSeXTroArfPCb4nxMrQr
         VDqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3NjiSZ+VGfzD1s2phBZDGaniaF8Uh3Zo99AGMkpx5VE=;
        b=ohcdxPiWFnS0Cnd6FUh4q/+m1pAzHU2iERZI6hfiRivsftMVKetCfrcsJOsg9c2gpj
         w+CUb6nbOmEzWfg+GBvO3T2prn5vDKC46WoQlDuDKwIHbk3/tJ9FWdWDgHdtN0XA3u92
         tD+ry1yiDwl6bdPt9TTFIpBbR0Xx/ert/dx1/pBJWb5HtwbBpMMGzO+oDXq0t8Gs37Qk
         iCsdLUDlq8c7u1uX70hhfr7v+kmF5lmCaDdEFSDfGl7PljBmXucr9P5jViiS57vybf/H
         3h6uC7TmSWb5ayG855A4wlZaXQxiKQGH6xwpadGHsT+h/mu/OqhTDf9qtOP87bubV+en
         DFnw==
X-Gm-Message-State: AOAM530P4M4AHSLRnxfyeBHpCq7oPrhyTGiTtGtKazSPmJkXqg8q8J08
        DreM9mh1bRjPweZjMgsO+A+077tIMdE=
X-Google-Smtp-Source: ABdhPJyLoIwbzSmCRAY/ylwebBi5qnR34AEIVgqXzJBB2CO7SW17JcZ9u6Pvmy91/jOR8toWbq4Eiw==
X-Received: by 2002:a62:1888:: with SMTP id 130mr22801267pfy.220.1599538162864;
        Mon, 07 Sep 2020 21:09:22 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id t24sm13534007pgo.51.2020.09.07.21.09.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Sep 2020 21:09:22 -0700 (PDT)
Subject: Re: [PATCH v2 3/4] net: dsa: microchip: Disable RGMII in-band status
 on KSZ9893
To:     Paul Barker <pbarker@konsulko.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
References: <20200907101208.1223-1-pbarker@konsulko.com>
 <20200907101208.1223-4-pbarker@konsulko.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <17e3dffb-8494-0130-5447-e0bda64d9965@gmail.com>
Date:   Mon, 7 Sep 2020 21:09:21 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.2.1
MIME-Version: 1.0
In-Reply-To: <20200907101208.1223-4-pbarker@konsulko.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/7/2020 3:12 AM, Paul Barker wrote:
> We can't assume that the link partner supports the in-band status
> reporting which is enabled by default on the KSZ9893 when using RGMII
> for the upstream port.
> 
> Signed-off-by: Paul Barker <pbarker@konsulko.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
