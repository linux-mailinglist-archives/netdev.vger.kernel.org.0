Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B2F3264E44
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 21:08:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727107AbgIJTHx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 15:07:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbgIJTFY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 15:05:24 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C08F6C061798
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 12:05:23 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id s65so3699222pgb.0
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 12:05:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zxMAQmyORWap3qE7hGx88IOoMW2g2+T7lJOcW+qcUEM=;
        b=fi117Ag0kPgFzseH6jc1iSKWM02mraq59eXwUNcy3C8InhOn6a1Ptkq8aPPrPhfUuL
         rn/cKIGDGA0zxZu3Ze6T31JGS85bR4q/nzEUV1qaGMmg9h1QgI3xw1ApLg81p6FKPPvM
         GJA2nctbH9Oxzd2qF36jN9CEQe607QMwxEwyCjMzNuhFQweqxKLpWTwSaRk5LkWQPXCH
         35+EWVNlPNJUZX4R9kzpIlnk06+PXJSdxz6fVIVfYRvE45bi5T2Vu3i8+G4XiT3HN4wl
         CmD8CLNcA4QHm/QDiwagYBkk3LDnaZxY3rkakV3bvi45fSgmWWpom2jUvWCe9T/SLqzq
         PCCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zxMAQmyORWap3qE7hGx88IOoMW2g2+T7lJOcW+qcUEM=;
        b=QDH4P55L26WL9Pj+t/0UiEG/PPMuGuG0VwGyT5NzvwrOpHZagWnL3ugHTdhsyckMsy
         fJjtE+XLndjxy3wPydjZdSnubxtx8Z6VXgFsk+d/HsGFy2BNZ0NGrKrEbmebXiZc+H9E
         xH1v0XRJAq6PhuxIG9R4DGK6A6913g/ux8bbipcfrC5ffYn2kGi11kHd4UvA74MYpOU0
         L4HcNLMnurRXInYVlbpalxLhfdDtqURovOS+RWwpC6F+OS6OuCfnsiHBBeDgsumX0I/M
         v51f8npWlBD46+53DbNSH1YnZ0GSpeZhJm0ogNQYGnODo79oR+S0nZgDlSRrD5LWqjhI
         tUAw==
X-Gm-Message-State: AOAM5334eafzVMvMpj4gNGy5D8Gzmw+zhYLtrhedzBOJj2Nh0Q9lUndq
        pmFRknX050Huqz0FN66XPZE=
X-Google-Smtp-Source: ABdhPJxxoz1uqqJN/0P3MTu2sRQHx6Feka4DM8gNuKOyhZxtZYO1KjHWLXRFOOV0YcjgenJhxeTyTQ==
X-Received: by 2002:a17:902:bcc2:: with SMTP id o2mr6886340pls.87.1599764723171;
        Thu, 10 Sep 2020 12:05:23 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id in10sm2566370pjb.11.2020.09.10.12.05.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Sep 2020 12:05:22 -0700 (PDT)
Subject: Re: VLAN filtering with DSA
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
References: <20200910150738.mwhh2i6j2qgacqev@skbuf>
 <86ebd9ca-86a3-0938-bf5d-9627420417bf@gmail.com>
 <20200910190119.n2mnqkv2toyqbmzn@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <7b23a257-6ac2-e6b2-7df8-9df28973e315@gmail.com>
Date:   Thu, 10 Sep 2020 12:05:17 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.2.1
MIME-Version: 1.0
In-Reply-To: <20200910190119.n2mnqkv2toyqbmzn@skbuf>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/10/2020 12:01 PM, Vladimir Oltean wrote:
> On Thu, Sep 10, 2020 at 11:42:02AM -0700, Florian Fainelli wrote:
>> On 9/10/2020 8:07 AM, Vladimir Oltean wrote:
>> Yes, doing what you suggest would make perfect sense for a DSA master that
>> is capable of VLAN filtering, I did encounter that problem with e1000 and
>> the dsa-loop.c mockup driver while working on a mock-up 802.1Q data path.
> 
> Yes, I have another patch where I add those VLANs from tag_8021q.c which
> I did not show here.
> 
> But if the DSA switch that uses tag_8021q is cascaded to another one,
> that's of little use if the upper switch does not propagate that
> configuration to its own upstream.

Yes, that would not work. As soon as you have a bridge spanning any of 
those switches, does not the problem go away by virtue of the switch 
port forcing the DSA master/upstream to be in promiscuous mode?
-- 
Florian
