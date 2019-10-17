Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEEB8DB843
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 22:29:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436940AbfJQU3j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 16:29:39 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:40890 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392669AbfJQU3i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 16:29:38 -0400
Received: by mail-pg1-f196.google.com with SMTP id e13so1997413pga.7
        for <netdev@vger.kernel.org>; Thu, 17 Oct 2019 13:29:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=i6RZhwqro9Z0mnc/kx8iAMoTXXnMXc98i8dZcjcuJ2A=;
        b=kG5RkV5fmREObbH3PXnIty7hZHdKOL6bbtHyC9wDr6ZLl08lDGg7kYKqh0WPECXlo2
         LD3eOLHc9N885exrouI+glBohVo3JU0yryZh9m7u31MrLYQiz3lBA4Ej5YmGTG9xgYf3
         mMNzFjWUxyOadUoOXMNfPcpgkuqaXBTgRb+Obg06Y+9Ssa2mNAbWkY0wFpvWf3kKZEJM
         ZtAVUw3rZHgdbVGttd+XPzdCZFnNFokCu7/oHKfo5p+qRD3zT0U2L50NM9u5c3yo4cgH
         2sEnQ6CD7zmphSAVqhxKqMzTARAS2Asqu19/Uy+OBKhlYi61MMgPAIsKqnvo7H8e/U3v
         ZtIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=i6RZhwqro9Z0mnc/kx8iAMoTXXnMXc98i8dZcjcuJ2A=;
        b=AOZF1s5QbsQNzBMethRGxSOT8f/+AkLCD+YFGfeWpAoyMnUitLQ0mJFBUmcDXYXb9L
         y4xWlYLODzuQf/C2Sf6t2Uk7plHW3j6W/gZJHxwkM+gKSKlxNahgRoqYib+hph10RXVi
         P7HtO3PDcMx12J+UGviV68CvViBzPd7jm24CIRRprv/WfObngXOPa9wd2LAZC78lqtZ9
         Fc7ql26PrE23040Fj4Jksj6DbUYX9EaYnKsZJ/pkyjWyhlePNmbsZ+t1RuMold3owu4Z
         ufwRdIZSXbBzEiGyMJQbn1Pd4ugeHDLp8SsudlNJDgb+UftyfdK6QsjWPezMvMRXy+8H
         jsEg==
X-Gm-Message-State: APjAAAVutoGfWcuGf64Y1q1kj51keYnGiRRE9EdStBKunIPPcj/VwUbQ
        ZZ8J4GOMCu5OIWp7hEPxBoFwuolSGF4=
X-Google-Smtp-Source: APXvYqyGje+ZYaM1ma4Atn1bXuUUL9fKPdshS5Uh2G5UIxHNNLJ0Rt0U2BQq1W0B9w6U2ZuQhEWGRA==
X-Received: by 2002:a17:90a:356a:: with SMTP id q97mr6526885pjb.50.1571344178224;
        Thu, 17 Oct 2019 13:29:38 -0700 (PDT)
Received: from [192.168.0.16] (97-115-119-26.ptld.qwest.net. [97.115.119.26])
        by smtp.gmail.com with ESMTPSA id n2sm3398463pgg.77.2019.10.17.13.29.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Oct 2019 13:29:37 -0700 (PDT)
Subject: Re: [PATCH net-next v4 00/10] optimize openvswitch flow looking up
To:     David Miller <davem@davemloft.net>, xiangxia.m.yue@gmail.com
Cc:     pshelar@ovn.org, netdev@vger.kernel.org, dev@openvswitch.org
References: <1571135440-24313-1-git-send-email-xiangxia.m.yue@gmail.com>
 <20191017.152200.1589061319789109083.davem@davemloft.net>
From:   Gregory Rose <gvrose8192@gmail.com>
Message-ID: <381cb243-8353-d676-22b1-f5dc785c32b6@gmail.com>
Date:   Thu, 17 Oct 2019 13:29:34 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191017.152200.1589061319789109083.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 10/17/2019 12:22 PM, David Miller wrote:
> From: xiangxia.m.yue@gmail.com
> Date: Tue, 15 Oct 2019 18:30:30 +0800
>
>> This series patch optimize openvswitch for performance or simplify
>> codes.
>   ...
>
> Pravin and company, please review!

Hi Dave,

I've tested the patches and provided my 'Tested-by' tag.  Pravin has had 
some suggestions for versions 1-3 of these
patches so I'll let him provide the ack on this latest patch set.

Thanks,

- Greg
