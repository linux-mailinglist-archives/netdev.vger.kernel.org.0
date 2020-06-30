Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08E4A20FC6A
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 21:04:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726818AbgF3TEF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 15:04:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726055AbgF3TEE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 15:04:04 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACC75C061755
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 12:04:04 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id q17so9812865pfu.8
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 12:04:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Yb/+OmDrovK5iAUA1A6U3kI8F8/atuQMOR5pYp61yyw=;
        b=q/JeEBdEvW8snoSeFAH12lYYa2s/WV+T0sjIvvJPXkKv4jd0LDSmxx3IKWYTYjqzrt
         9fBYQ+Xig/jhqZpWZwV+HLJpsVSXp8vMQyB9WtnoZtnvSRZJeN2h7UaSJnyMtn7jm4B7
         d7Y9B3Kv8EpAWu/dFb3HjaXxHZTnLCntX0dq/FfQpvNsqOGrlP5zwQLuQv5pzh4jtqwO
         dtCunI6wZNCgFm+uxOxSjL2X6KRVD7gO0414c5ayGD0HX/1ecAza09e15cq2v0HuOv8G
         uLkD5zIAZmu2cxWLmFo/yeXLv5RbdS7Uj8gonh5aUeei4YB6ShQ/LgGbNWJ1FcsN6kW/
         fvuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Yb/+OmDrovK5iAUA1A6U3kI8F8/atuQMOR5pYp61yyw=;
        b=U6oPFTRX4/ucP8aDloltb/2JM7dKkgGqVvm+a8Zw5ViQRA1mjUZUgCNXxf2gFtUdMG
         QW6k/51Xc1fxR6Nc54sxS4eIfhV+dZb6xuNIqsUw6B85u0DXaM2KXbjkSR9rLUBFF8PK
         uoVtBu8baQGZDjICqP7bqyiBfvPPGyT1SHUQ0jFsc67cIiI69PbRvPHKFVVvuk3+ebL7
         jqlDjijwAFLQzBplEKu0KZtAfUAQF9z9gUK8Xsyids8SjcghmCrjixxyHVMb7MZLfd/b
         CD1SM9UZdlJJC4h4pTIDR+nUcLqoOc5HPs4J4NowjoweoXg2oyYhd7PFaEDIZaiVguzb
         TBhA==
X-Gm-Message-State: AOAM530IWemPqz55Wf6AJOR5sWwfHJrTdVEysAPgqKqKBG7lLW3BYBS9
        gfv+jMYD89noN9CpOUqOhGIkBNQJ
X-Google-Smtp-Source: ABdhPJxowEx2GpzNArGTRG1+hDVo3XntAUF1EEngw4IV/bqtC+3XXTlnSNHAZYqPsL4nZ/GVNxdTow==
X-Received: by 2002:a63:7054:: with SMTP id a20mr15731795pgn.17.1593543843585;
        Tue, 30 Jun 2020 12:04:03 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id m92sm3081827pje.13.2020.06.30.12.04.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Jun 2020 12:04:02 -0700 (PDT)
Subject: Re: [PATCH RFC net-next 06/13] net: phylink: avoid mac_config calls
To:     Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        "michael@walle.cc" <michael@walle.cc>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
References: <20200630142754.GC1551@shell.armlinux.org.uk>
 <E1jqHFt-0006P7-Ed@rmk-PC.armlinux.org.uk>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <0ed50b80-6e11-9114-c307-71737ea47ba9@gmail.com>
Date:   Tue, 30 Jun 2020 12:04:01 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <E1jqHFt-0006P7-Ed@rmk-PC.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/30/2020 7:29 AM, Russell King wrote:
> Avoid calling mac_config() when using split PCS, and the interface
> remains the same.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
