Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40A5510A458
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 20:11:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726926AbfKZTLP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 14:11:15 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:38836 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726101AbfKZTLP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 14:11:15 -0500
Received: by mail-wm1-f65.google.com with SMTP id z19so4645435wmk.3
        for <netdev@vger.kernel.org>; Tue, 26 Nov 2019 11:11:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XVGfgf6gtnz72gmf5Fo0WW0GPR3nVq6bXn0NkBB6p60=;
        b=DX9ZDi2afGhn0OfCR7c1VnV41jpGXRaFTz0zEpFA6kCZMFZs3rDi1AOHELnGlpi0Lb
         i0WD4kY4ySIDfnxDwh/59DPvI7ziCTshakazg7tG9CQKG2wGSqN3c3wpJaQB0kHQWAzf
         s91fp6NVYxEZFttfwxC6/rIqnU+7JqyrXpS8StDoEjwX1DAW0c77tNoL0obTNxeNAs4z
         HNCj6NAe0ieMlNGeqn8sDKnNUuFXaFkcmH+c5jvaDpsskfWswcOQam9v+assT20W2860
         UiOGHTgF7AbZofwlPHxDStGaCZFNMH/PWOl2gf6NeSpV6yLB3NcM2G7lfqkBR1nuKo9/
         FLNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XVGfgf6gtnz72gmf5Fo0WW0GPR3nVq6bXn0NkBB6p60=;
        b=ONwRtUV0RIM9a8951N3qanR4C6K5PrK+I7s2Q7BDTCePSfmYm9JQpBEKzfmvB8vO95
         djq/fpmiTMQs59sh9ijlISV0DRLGCeDBtpeUS6tN8HpVBWXRc52hn07LRWpLdHFcBj/6
         Bn+uxTZluvitCsxkVsYMwT6jkUBR22CSRbaPVBc7EbiGVloe2HsdkW+ZOmDIhpONo/oR
         i/isDJXBvbi+fed0drXTwgWOTjbImt5KA7DEUjubdbD6shLJmSmnStw3qbNs0brnA/Ic
         CGcxyH8xeCDXi4nx7yFSUS/MFUp2NOyiz2EUnWJajldsFkT6AuWxWp07D/S+0jvJXPjs
         A/5w==
X-Gm-Message-State: APjAAAV4LiwKzEHFaCGTrwDKsb8MOv7LzrsjS4JuvpB8DIoGbn3tQHEE
        jttW8ypUVKZ4VKvtJCwTpJsfMiYd7oRBGw==
X-Google-Smtp-Source: APXvYqznlaBX8elqTtLN0mTZn9rdWGZyXj9RCkx+KhrchOQQ9zLohzeo3gBhw/cML6W6qptzvDG84A==
X-Received: by 2002:a05:600c:2254:: with SMTP id a20mr568307wmm.97.1574795472687;
        Tue, 26 Nov 2019 11:11:12 -0800 (PST)
Received: from ?IPv6:2001:1620:2777:11:cde9:57f6:17e:8aa5? ([2001:1620:2777:11:cde9:57f6:17e:8aa5])
        by smtp.gmail.com with ESMTPSA id i9sm14982176wrb.2.2019.11.26.11.11.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 26 Nov 2019 11:11:12 -0800 (PST)
From:   Oliver Herms <oliver.peter.herms@gmail.com>
Subject: Re: [PATCH v2] net: ip/tnl: Set iph->id only when don't fragment is
 not set
To:     David Miller <davem@davemloft.net>
Cc:     yoshfuji@linux-ipv6.org, kuznet@ms2.inr.ac.ru,
        netdev@vger.kernel.org
References: <20191124132418.GA13864@fuckup>
 <20191125.144139.1331751213975518867.davem@davemloft.net>
Message-ID: <4e964168-2c83-24bb-8e44-f5f47555e589@gmail.com>
Date:   Tue, 26 Nov 2019 20:10:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191125.144139.1331751213975518867.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

On 25.11.19 23:41, David Miller wrote:
> From: Oliver Herms <oliver.peter.herms@gmail.com>
> Date: Sun, 24 Nov 2019 14:24:18 +0100
> 
>> From RFC 6864 "Updated Specification of the IPv4 ID Field" section 4.1:
> 
> Just reading the abstract of this RFC I cannot take it seriously:
> 
> 	This document updates the specification of the IPv4 ID field
> 	in RFCs 791, 1122, and 2003 to more closely reflect current
> 	practice...
> 
> "more closely reflect current practice" ?!?!
> 
> That statement is a joke right?
> 
> Linux generates the bulk of the traffic on the internet and we've had
> the current behavior of the ID field for decades.
> 
> Therefore, I don't think even the premise of this document is valid.
> 
> These are all red flags to me, and I think we should keep the current
> behavior.
> 
> I'm not applying your patch, sorry.
> 
I totally understand your argument.

What do you think about making this configurable via sysctl and make the current
behavior the default? I would also like to make this configurable for other 
payload types like TCP and UDP. IMHO there the ID is unnecessary, too, when DF is set.

Would you be willing to merge a patch that offers this?

Thanks
Oliver
