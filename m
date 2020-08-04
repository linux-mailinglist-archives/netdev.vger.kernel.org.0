Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0231423BC1A
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 16:27:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729240AbgHDO1d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 10:27:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729217AbgHDO1O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 10:27:14 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16441C06174A
        for <netdev@vger.kernel.org>; Tue,  4 Aug 2020 07:27:12 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id m20so20533897eds.2
        for <netdev@vger.kernel.org>; Tue, 04 Aug 2020 07:27:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RxbJzF7IYY/Xus1T8XnEygfwwXnPKxY8WWK9ypkUQv0=;
        b=NLJHhZqiI6A6vYzAolV8/RYp6HeJDLhToe/j/KKPtl/s05Sf1RLO3Pc16sergqyscL
         EbR/gzhww+vHwGkD4PBP0GH9k6454hOJwgl5x3xOOTPdvNsR2Hkk5s1sap16bdMeaAz8
         PZxNFlyfps0BzA7KbkJPv4KRWhSfCIlZUso9slcvlDYhTEq5OUiGpOIyk7f3Byg//wLV
         EGAFrQO3K8OaNTPm3gY50yOuGX+kvdrRCSLTg9n19miPIK+zBs2wagnMhcBZDWwwoWEc
         IwATxN2WRjkUceXKp20+5T08cj8/ywvsOgnKnlgCZeI/fuilc5P4jY8pq5ZeraMcwoAr
         diRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RxbJzF7IYY/Xus1T8XnEygfwwXnPKxY8WWK9ypkUQv0=;
        b=ou/mquZII/5oOzz/FN036KePLA73RVS57t9f+T5eeR8MY9chDmsamGlrqz2BLV1Vie
         91xE291S5cVPg26WhLoPwfIqaOiauHDYCSwoYbfmpSSqwoLsXYIwhW2uXBc/oy3Gfikn
         r2dKuqWEmmlZC2nhPXF8UzaPQ6/ePIDnIboKDc1aW9hvWIes8hh5Zlu/eYa6JOiAb/no
         ohOcfzvyGW1TLBcIddgIP1WJu45YGdI9GUN6jsYYjXpzOe5kmGRDeudMocJHT22PERng
         5HcgbPO+gfkveViCtDeftht3Dav8JPxcN8q02hDBXdbqB2cgVl1Az6vVPyGh0Vxj6xwS
         /kqg==
X-Gm-Message-State: AOAM530TrJkiVFd4qPZsofUg/6MGfh4sN/Mr0SIQL3STzqUucpqnXwjm
        qZ4r6SQVzQ3jyvknWr6VH68=
X-Google-Smtp-Source: ABdhPJz2Es/x2oSDSEVzKz1dEPPm9rbETwXg0bpYZPFpl7yha7+dZG5YtKy360s7bCiYTDez0Bl2wA==
X-Received: by 2002:aa7:cb56:: with SMTP id w22mr20305024edt.96.1596551230823;
        Tue, 04 Aug 2020 07:27:10 -0700 (PDT)
Received: from skbuf ([188.26.57.97])
        by smtp.gmail.com with ESMTPSA id q7sm18635436ejo.22.2020.08.04.07.27.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2020 07:27:10 -0700 (PDT)
Date:   Tue, 4 Aug 2020 17:27:08 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Gaube, Marvin (THSE-TL1)" <Marvin.Gaube@tesat.de>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        edumazet@google.com
Subject: Re: PROBLEM: (DSA/Microchip): 802.1Q-Header lost on KSZ9477-DSA
 ingress without bridge
Message-ID: <20200804142708.zjos3b6jvqjj7uas@skbuf>
References: <ad09e947263c44c48a1d2c01bcb4d90a@BK99MAIL02.bk.local>
 <c531bf92-dd7e-0e69-8307-4c4f37cb2d02@gmail.com>
 <f8465c4b8db649e0bb5463482f9be96e@BK99MAIL02.bk.local>
 <b5ad26fe-e6c3-e771-fb10-77eecae219f6@gmail.com>
 <020a80686edc48d5810e1dbf884ae497@BK99MAIL02.bk.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <020a80686edc48d5810e1dbf884ae497@BK99MAIL02.bk.local>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 04, 2020 at 02:14:33PM +0000, Gaube, Marvin (THSE-TL1) wrote:
> Hello,
> I looked into it deeper, the driver does rxvlan offloading. 
> By disabling it manually trough ethtool, the behavior becomes as
> expected.
> 
> I've taken "net: dsa: sja1105: disable rxvlan offload for the DSA
> master" from
> (https://lore.kernel.org/netdev/20200512234921.25460-1-olteanv@gmail.com/)
> and also applied it to the KSZ9477-Driver, which fixes the problem.
> It's probably a workaround, but fixes the VLAN behavior for now. I
> would suggest also applying "ds->disable_master_rxvlan = true;" to
> KSZ9477 after the mentioned patch is merged.
> 
> Best Regards
> Marvin Gaube
> 

And I wanted to suggest that, but it seemed too freaky to be what's
going on.... But since ksz9477 uses a tail tag, it makes perfect sense.

My patch is in limbo because Eric, who started zeroing the skb offloaded
VLAN data in the first place, hasn't said anything.

Thanks,
-Vladimir
