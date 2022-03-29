Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB07E4EAED7
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 15:52:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237551AbiC2Nyh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 09:54:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237212AbiC2Nyg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 09:54:36 -0400
Received: from gateway24.websitewelcome.com (gateway24.websitewelcome.com [192.185.50.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8D9A1B6092
        for <netdev@vger.kernel.org>; Tue, 29 Mar 2022 06:52:53 -0700 (PDT)
Received: from cm12.websitewelcome.com (cm12.websitewelcome.com [100.42.49.8])
        by gateway24.websitewelcome.com (Postfix) with ESMTP id 1CF1E7CF832
        for <netdev@vger.kernel.org>; Tue, 29 Mar 2022 08:52:53 -0500 (CDT)
Received: from 162-215-252-75.unifiedlayer.com ([208.91.199.152])
        by cmsmtp with SMTP
        id ZCHEnPr699AGSZCHEnBpRn; Tue, 29 Mar 2022 08:52:53 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=roeck-us.net; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:Subject:From:References:Cc:To:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=R8VF1083Jml6bSlqQeVvGDZxIbXB4VClUDd8cNl8HqA=; b=ycg/a9dlJnrsrXw2QIi/hOynJz
        YapMKagNgi0vMp0GKaSr32e2PIXcmtWBEGCIkRUbEDIFRzkBAbqKOr9vwcCt/gwl2/RmYmxlbDwkc
        9irvStDtwQR1PmxXGudquz6OypiepTQyImdwe86pa2qNZ+RBuuzFhvfjW8UYrAbVPqd0T9MNXdgU2
        GsCNUaso2xsF8byuJGCZZ8Fu7zTMQHxp0LxKZ+T7dZRFOegM8Xv9lhn0dn2oyMuj+gfN5KuX2d71l
        /zHjs+zTOn4H2vXsh38qxOjPkyq6NOLnzP08v7IukXPeYIKRnd3vSoZ22hmGWKFxT6imnN4wfFsHq
        9C00d64A==;
Received: from 108-223-40-66.lightspeed.sntcca.sbcglobal.net ([108.223.40.66]:54542)
        by bh-25.webhostbox.net with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@roeck-us.net>)
        id 1nZCHD-00353G-Re; Tue, 29 Mar 2022 13:52:51 +0000
Message-ID: <ad6373ce-ad60-e54c-139c-b4b807f3531c@roeck-us.net>
Date:   Tue, 29 Mar 2022 06:52:50 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Content-Language: en-US
To:     Michael Walle <michael@walle.cc>
Cc:     Andrew Lunn <andrew@lunn.ch>, Xu Yilun <yilun.xu@intel.com>,
        Tom Rix <trix@redhat.com>, Jean Delvare <jdelvare@suse.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-hwmon@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20220328115226.3042322-1-michael@walle.cc>
 <YkGwjjUz+421O2E1@lunn.ch>
 <ab64105b-c48d-cdf2-598a-3e0a2e261b27@roeck-us.net>
 <e87c3ab2a0c188dced27bf83fc444c40@walle.cc>
From:   Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH v1 0/2] hwmon: introduce hwmon_sanitize()
In-Reply-To: <e87c3ab2a0c188dced27bf83fc444c40@walle.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-BWhitelist: no
X-Source-IP: 108.223.40.66
X-Source-L: No
X-Exim-ID: 1nZCHD-00353G-Re
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 108-223-40-66.lightspeed.sntcca.sbcglobal.net [108.223.40.66]:54542
X-Source-Auth: linux@roeck-us.net
X-Email-Count: 7
X-Source-Cap: cm9lY2s7YWN0aXZzdG07YmgtMjUud2ViaG9zdGJveC5uZXQ=
X-Local-Domain: yes
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/28/22 15:50, Michael Walle wrote:
> Am 2022-03-28 18:27, schrieb Guenter Roeck:
>> On 3/28/22 05:56, Andrew Lunn wrote:
>>>> I'm not sure how to handle this correctly, as this touches both the
>>>> network tree and the hwmon tree. Also, the GPY PHY temperature senors
>>>> driver would use it.
>>>
>>> There are a few options:
>>>
>>> 1) Get the hwmon_sanitize_name() merged into hwmon, ask for a stable
>>> branch, and get it merged into netdev net-next.
>>>
>>> 2) Have the hwmon maintainers ACK the change and agree that it can be
>>> merged via netdev.
>>>
>>> Probably the second option is easiest, and since it is not touching
>>> the core of hwmon, it is unlikely to cause merge conflicts.
>>>
>>
>> No, it isn't the easiest solution because it also modifies a hwmon
>> driver to use it.
> 
> So that leaves us with option 1? The next version will contain the
> additional patch which moves the hwmon_is_bad_char() from the include
> to the core and make it private. That will then need an immutable
> branch from netdev to get merged back into hwmon before that patch
> can be applied, right?

We can not control if someone else starts using the function before
it is removed. As pointed out, the immutable branch needs to be from hwmon,
and the patch to make hwmon_is_bad_char private can only be applied
after all of its users are gone from the mainline kernel.

I would actually suggest to allocate the new string as part of the
function and have it return a pointer to a new string. Something like
	char *devm_hwmon_sanitize_name(struct device *dev, const char *name);
and
         char *hwmon_sanitize_name(const char *name);

because the string duplication is also part of all calling code.

Guenter
