Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E13F46C318
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 19:49:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240710AbhLGSxR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 13:53:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231469AbhLGSxQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 13:53:16 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E175C061574;
        Tue,  7 Dec 2021 10:49:46 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id f18-20020a17090aa79200b001ad9cb23022so167558pjq.4;
        Tue, 07 Dec 2021 10:49:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=F/yQUYPsKD97ChDwdkNkfz44U9dpuQ4WBjbleQG98/E=;
        b=LbVbUXWsfZvhqVEzvwIL8AWfCXH2pgPaxusH5esX0jmp/82r2m+yzmdaIk1+Hdfc+h
         T41Q3xVWc6syDwemIOY/DrCInlH+IH7fXpeKjC78UM6qrXb/uXTGs2GzuAvoWJfDhPSc
         bcYh/CjCp3FND+D5m9tweZGsb51oYkaVRkPdsSd/1WXjX+LREJvpHkP0rOkNbiAuhQk1
         z+ekQNw8pNDYUAANOHQNabow/Wk7FTjvdHSJiUm6rI5r2lTMDTFX7dsDKaQ2K9LqHsX9
         Z5dCqSyXoSFhQdZfq6CnzLjXV5RalxhJzdhQAh0AOYPV/XH9UEv8MWY5Sy1quaH2m0ra
         8CxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=F/yQUYPsKD97ChDwdkNkfz44U9dpuQ4WBjbleQG98/E=;
        b=2Wx2xYEX3tA8KJxuZISxJssL7UTGJu9xv9Gs+Czvr93j562wnuNztCcPr70PbwAK5F
         71QOLUYw6IvT975jRgMxQtBDM4KP+86nMv+4ETWlNeOlZKQpdYuqo8osaCnyC1nuBFa4
         RPWXL01c8WdCdUBCMAp1DyJ24jzvj7VWdM3xpLvZRQTR33Kvo5EyjnSL2RmJy52x4EEL
         CM1p1Zpd5vO21iyvGAQ9lXPSKcfZ/X+2UrhI84Ghuo7Y5iBHpVKilNFCVe3Pg0vElYkN
         C2Wsk7giP5S5rSxWEy+PGR5IhtRf84IJiA7PrLiTwX4qPcf6M/Duny+0bP9mIsu8GcoG
         UVHQ==
X-Gm-Message-State: AOAM531nUg3TJ2kAUdD3dfeLAs6lbyylNcD/MELnvXV2n7Rz7Au19J8i
        T92ys9vKTz/LRcvkaZtL4I8fk9S1HSo=
X-Google-Smtp-Source: ABdhPJztD0YkRSk81b4tQ6fGccnYyGJuM/brVDyBXBGHtfsn0/bm1lFXxsNpHyPtDzIPqs7ECB2tNw==
X-Received: by 2002:a17:90b:1e4e:: with SMTP id pi14mr978686pjb.161.1638902985031;
        Tue, 07 Dec 2021 10:49:45 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id 38sm220370pgl.73.2021.12.07.10.49.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Dec 2021 10:49:44 -0800 (PST)
Subject: Re: [net-next RFC PATCH 0/6] Add support for qca8k mdio rw in
 Ethernet packet
To:     Andrew Lunn <andrew@lunn.ch>, Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <20211207145942.7444-1-ansuelsmth@gmail.com>
 <Ya96pwC1KKZDO9et@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <77203cb2-ba90-ff01-5940-2e9b599f648f@gmail.com>
Date:   Tue, 7 Dec 2021 10:49:43 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <Ya96pwC1KKZDO9et@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/7/21 7:15 AM, Andrew Lunn wrote:
> On Tue, Dec 07, 2021 at 03:59:36PM +0100, Ansuel Smith wrote:
>> Hi, this is still WIP and currently has some problem but I would love if
>> someone can give this a superficial review and answer to some problem
>> with this.
>>
>> The main reason for this is that we notice some routing problem in the
>> switch and it seems assisted learning is needed. Considering mdio is
>> quite slow due to the indirect write using this Ethernet alternative way
>> seems to be quicker.
>>
>> The qca8k switch supports a special way to pass mdio read/write request
>> using specially crafted Ethernet packet.
> 
> Oh! Cool! Marvell has this as well, and i suspect a few others. It is
> something i've wanted to work on for a long long time, but never had
> the opportunity.
> 
> This also means that, even if you are focusing on qca8k, please try to
> think what could be generic, and what should specific to the
> qca8k. The idea of sending an Ethernet frame and sometime later
> receiving a reply should be generic and usable for other DSA
> drivers. The contents of those frames needs to be driver specific.
> How we hook this into MDIO might also be generic, maybe.
> 
> I will look at your questions later, but soon.

There was a priori attempt from Vivien to add support for mv88e6xxx over
RMU frames:

https://www.mail-archive.com/netdev@vger.kernel.org/msg298317.html

This gets interesting because the switch's control path moves from MDIO
to Ethernet and there is not really an "ethernet bus" though we could
certainly come up with one. We have mdio-i2c, so maybe we should have
mdio-ethernet?
-- 
Florian
