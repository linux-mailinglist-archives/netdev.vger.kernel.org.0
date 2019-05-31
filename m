Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC326310CC
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 17:02:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbfEaPCW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 11:02:22 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33440 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726548AbfEaPCW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 11:02:22 -0400
Received: by mail-wr1-f65.google.com with SMTP id d9so6777284wrx.0
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 08:02:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yhVi3GTFCQvvTIxl5mOOdrJTPKmESuh+XsvZuHIBFUA=;
        b=J0mJR0rYbu7nLXSjhS2+ZbFJdnv5aUwWyTszsu5dt3yPf3YX8TrJVy8ES8a3v/0JBD
         2wL+73E34KfUz2DwRGECSq9Rk6kRsnZzQTtn5nrhxO5c7CcidX6RvoD3B1Rv/iuiF8Un
         tsWUNKFY/AOEstNJVHdihksOAFNs9HR78/tM3IqeTLkx4WKxHNTf1J4wCLzSZ8QAGm/y
         uM9XwSon/jIun8o1gzwHxRHjqODnKlqzsnyezjtyGnN4wHP0xdvzfBlLvmlcLFbtOnuw
         mg2fGVxQVRzLNKjEafr3tWV/vi8fSDiZDqrY3Dh7xOmco0bJShp89adqEpQimpA65kRI
         ue2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yhVi3GTFCQvvTIxl5mOOdrJTPKmESuh+XsvZuHIBFUA=;
        b=miJgdLvmSHbXB1a22TxG9W74ji34bw6JEI3scG0VyQ9fLUEFIh8hZWenkgpZVaMkcw
         qpZREpBMH08w8Y3xKLBe4r5TQYociMAyPkS85+AGFErZDMTWIgKvnzXVG/9XBlhEd+LT
         vN/mXpj8Qq7Dsj7351OjWHDzesDySIdOt/YEnt9gn4ydz69vXuPdI+YNuqmf/fscISiI
         VdNpZ2X7rUC2Aq7GXBg5XV63Ddc60nuYusOX1Mhf1aj+eZfHKrK2UD4biMyaFUWlxdLP
         IyJXQRtkJBimXiDGPSbgU54DxgsbCRgshkDGrFt8GPA+OxYrGcZ4oyEHcpXGEde6QY+x
         RJqg==
X-Gm-Message-State: APjAAAX5Matre5uLftD4aH8H4xHywdWPs+s3Nr4OOHFxyHun/fNY0rte
        LqWNjK7CyCu9gB8xXV/BnW+7hg==
X-Google-Smtp-Source: APXvYqys8NqsVcs78h+7pzuMj6F9INb4P295nbS8UFgQK4YSDSuwHD81dGbsvau2gG921pNHh+h4rA==
X-Received: by 2002:adf:b643:: with SMTP id i3mr7333639wre.284.1559314940594;
        Fri, 31 May 2019 08:02:20 -0700 (PDT)
Received: from [192.168.112.17] (nikaet.starlink.ru. [94.141.168.29])
        by smtp.gmail.com with ESMTPSA id u205sm7254690wmu.47.2019.05.31.08.02.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 May 2019 08:02:20 -0700 (PDT)
Subject: Re: [PATCH] net: dsa: mv88e6xxx: avoid error message on remove from
 VLAN 0
To:     Vivien Didelot <vivien.didelot@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        =?UTF-8?Q?Marek_Beh=c3=ban?= <marek.behun@nic.cz>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Healy <cphealy@gmail.com>
References: <20190531073514.2171-1-nikita.yoush@cogentembedded.com>
 <20190531103105.GE23464@t480s.localdomain> <20190531143758.GB23821@lunn.ch>
 <422482dc-8887-0f92-c8c9-f9d639882c77@cogentembedded.com>
 <20190531110017.GB2075@t480s.localdomain>
From:   Nikita Yushchenko <nikita.yoush@cogentembedded.com>
Message-ID: <6dd8f8d5-9453-ab94-3aae-18eb5e35b051@cogentembedded.com>
Date:   Fri, 31 May 2019 18:02:18 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190531110017.GB2075@t480s.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> Kernel currently does, but it is caught in
>> mv88e6xxx_port_check_hw_vlan() and returns -ENOTSUPP from there.
> 
> But VID 0 has a special meaning for the kernel, it means the port's private
> database (when it is isolated, non-bridged), it is not meant to be programmed
> in the switch. That's why I would've put that knowledge into the DSA layer,
> which job is to translate the kernel operations to the (dumb) DSA drivers.
> 
> I hope I'm seeing things correctly here.

I'm ok with either solution.
