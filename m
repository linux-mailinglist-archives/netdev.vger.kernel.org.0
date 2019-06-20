Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9859F4CA21
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 10:58:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731264AbfFTI6p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 04:58:45 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:45011 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726175AbfFTI6p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 04:58:45 -0400
Received: by mail-lf1-f67.google.com with SMTP id r15so1821003lfm.11
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 01:58:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dfxJ4a2QTSJhkHiDqzwqK9Tivfex2EusFAKfwRKgyto=;
        b=tA2EL2AFfZRqDrIIYLfmZxNarz18c+FrlQ9uWa9jZGI2Xz7DlZylft13OUaLaZKFFh
         XsQbVTBSNkhBHWR/ZMnTfshfgmfCSmYhtz59wxZN9OVHXRxxt5CkEQAn5aNXS5PdZHJ/
         H0NpPb+3EpxxnyOjrnDB2IsVRG+jR5J7egrYr+dqo/gf9fDtEbWaKLakQol6Zfa1J0pk
         BIFoi6pCIPadQHBmH9Wq0BDx88ZiZd5R+tINXxFhqiq6F+gIF1QMQXvmFw1tsyC1uhhL
         cgLkRfeP/f8Zy3eW4DOPLZIRQc1fTRKn8lR1qkBBhzTRJBgewbfwPLmxlwuWpQ8A1Z01
         fJsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dfxJ4a2QTSJhkHiDqzwqK9Tivfex2EusFAKfwRKgyto=;
        b=pAyV23fz8JXzGPZjqbd1hqU4ZJN1G79/kIgrW6qlOnYjj7qezExtfYSSGec7gHqb4E
         wvRsEZvTp/RbYSneme22HOdLBOYHbqLqNqwG3JfS8oPUqpK7Oo9PKQ2rFvBM6iycG7tr
         ULRmCfoSqr0dJR7vtA6NnTC2bRfjz8X6tUqYKMdpbM6G6XrW4zMr/vNOzwctKLOU4KzF
         gyXzw/wXs9eKI429YfMoXz+NWE/u/qYkuH1NL2LIbn9nJeKJkYVW2+fGHtUlj1CuE+R5
         m+wzkAtw4x6BJdKFm4cq+HajOFKS1kQTOfkPFQ9R5u/yykyFE3CFfEbLIsCq1o2MCvgv
         jEtg==
X-Gm-Message-State: APjAAAVnp2OQsoR0O/a4eecFaurCH3MU6HBz3cw9RMBOpYFDJ/imv0+Z
        O6Rxf7fKcU59sDiCHoqKp4HsIg==
X-Google-Smtp-Source: APXvYqx5ktYLTZynXGSE+vTJdFLuUIHLNqlOp0FQpxzu8dC2WHR3IFfJrM3Ppk6ii7J96jDCV+r9Nw==
X-Received: by 2002:ac2:46ef:: with SMTP id q15mr2537282lfo.63.1561021123413;
        Thu, 20 Jun 2019 01:58:43 -0700 (PDT)
Received: from [192.168.0.199] ([31.173.80.13])
        by smtp.gmail.com with ESMTPSA id m25sm3062325lfp.97.2019.06.20.01.58.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Jun 2019 01:58:42 -0700 (PDT)
Subject: Re: [PATCH net] net: mvpp2: prs: Don't override the sign bit in SRAM
 parser shift
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        thomas.petazzoni@bootlin.com, gregory.clement@bootlin.com,
        nadavh@marvell.com, stefanc@marvell.com, mw@semihalf.com,
        Alan Winkowski <walan@marvell.com>
References: <20190619145413.21852-1-maxime.chevallier@bootlin.com>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <64727f68-866b-b2eb-38c9-5670efe68aaf@cogentembedded.com>
Date:   Thu, 20 Jun 2019 11:58:18 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <20190619145413.21852-1-maxime.chevallier@bootlin.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19.06.2019 17:54, Maxime Chevallier wrote:

> The Header Parser allows identifying various fields in the packet
> headers, used for for various kind of filtering and classification

    One "for" is enough. :-)

> steps.
> 
> This is a re-entrant process, where the offset in the packet header
> depends on the previous lookup results. This offset is represented in
> the SRAM results of the TCAM, as a shift to be operated.
> 
> This shift can be negative in some cases, such as in IPv6 parsing.
> 
> This commit prevents overriding the sign bit when setting the shift
> value, which could cause instabilities when parsing IPv6 flows.
> 
> Fixes: 3f518509dedc ("ethernet: Add new driver for Marvell Armada 375 network unit")
> Suggested-by: Alan Winkowski <walan@marvell.com>
> Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
[...]

MBR, Sergei
