Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2345B4EB907
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 05:47:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242399AbiC3Dsn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 23:48:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242395AbiC3Dsi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 23:48:38 -0400
X-Greylist: delayed 127138 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 29 Mar 2022 20:46:54 PDT
Received: from gateway30.websitewelcome.com (gateway30.websitewelcome.com [192.185.147.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BFDC4C7B9
        for <netdev@vger.kernel.org>; Tue, 29 Mar 2022 20:46:52 -0700 (PDT)
Received: from cm16.websitewelcome.com (cm16.websitewelcome.com [100.42.49.19])
        by gateway30.websitewelcome.com (Postfix) with ESMTP id AC1DB9109
        for <netdev@vger.kernel.org>; Tue, 29 Mar 2022 22:46:51 -0500 (CDT)
Received: from 162-215-252-75.unifiedlayer.com ([208.91.199.152])
        by cmsmtp with SMTP
        id ZPIJnQNObXvvJZPIJnbOIB; Tue, 29 Mar 2022 22:46:51 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=roeck-us.net; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:Subject:From:References:Cc:To:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=D64CVYRUZxQ9kdAIABEkTcGSNTJSs+DSr+nWgsftIBM=; b=bq8i4zAOHXSwkZb1jiPeckomHP
        hvE+k+q8kv5Djmhq6buFrE7vBmmEorlfg1oXDXe+dbtyk2TQhyzMFRMzxy1aYwz+3LRNhfS1Dk3VA
        ELxmR2cSVY1inn3v3JkepJwpr8/1sag+orTsmTzuvVIDKxD+4bU/Cy+oaS9be2adB3vEfAQQhJANx
        l6mUs1qZDY67NXPYk+ZxU0hmmZcD9VpK5nmmCTLIg0ES2bOrYyO9nSxkuHgLvmbh30+7oYpeIKUlD
        SwMWy5Z9Fu4Z1f7X7csquMA4kHsT09sxhPv+Xsmy640sNUFnG4Yc9eFD+lAaA7Qv9H5oN1e3/nygo
        PRqaRYnQ==;
Received: from 108-223-40-66.lightspeed.sntcca.sbcglobal.net ([108.223.40.66]:54550)
        by bh-25.webhostbox.net with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@roeck-us.net>)
        id 1nZPII-003TiD-TC; Wed, 30 Mar 2022 03:46:50 +0000
Message-ID: <fa1f64d2-32a1-b8f9-0929-093fbd45d219@roeck-us.net>
Date:   Tue, 29 Mar 2022 20:46:48 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Content-Language: en-US
To:     David Laight <David.Laight@ACULAB.COM>,
        'Michael Walle' <michael@walle.cc>,
        Xu Yilun <yilun.xu@intel.com>, Tom Rix <trix@redhat.com>,
        Jean Delvare <jdelvare@suse.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     "linux-hwmon@vger.kernel.org" <linux-hwmon@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20220329160730.3265481-1-michael@walle.cc>
 <20220329160730.3265481-2-michael@walle.cc>
 <16d8b45eba7b44e78fa8205e6666f2bd@AcuMS.aculab.com>
From:   Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH v2 1/5] hwmon: introduce hwmon_sanitize_name()
In-Reply-To: <16d8b45eba7b44e78fa8205e6666f2bd@AcuMS.aculab.com>
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
X-Exim-ID: 1nZPII-003TiD-TC
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 108-223-40-66.lightspeed.sntcca.sbcglobal.net [108.223.40.66]:54550
X-Source-Auth: linux@roeck-us.net
X-Email-Count: 1
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

On 3/29/22 19:57, David Laight wrote:
> From: Michael Walle
>> Sent: 29 March 2022 17:07
>>
>> More and more drivers will check for bad characters in the hwmon name
>> and all are using the same code snippet. Consolidate that code by adding
>> a new hwmon_sanitize_name() function.
> 
> I'm assuming these 'bad' hwmon names come from userspace?
> Like ethernet interface names??
> 
> Is silently changing the name of the hwmon entries the right
> thing to do at all?
> 
> What happens if the user tries to create both "foo_bar" and "foo-bar"?
> I'm sure that is going to go horribly wrong somewhere.
> 
> It would certainly make sense to have a function to verify the name
> is actually valid.
> Then bad names can be rejected earlier on.
> 
> I'm also intrigued about the list of invalid characters:
> 
> +static bool hwmon_is_bad_char(const char ch)
> +{
> +	switch (ch) {
> +	case '-':
> +	case '*':
> +	case ' ':
> +	case '\t':
> +	case '\n':
> +		return true;
> +	default:
> +		return false;
> +	}
> +}
> 
> If '\t' and '\n' are invalid why are all the other control characters
> allowed?
> I'm guessing '*' is disallowed because it is the shell wildcard?
> So what about '?'.
> Then I'd expect '/' to be invalid - but that isn't checked.
> Never mind all the values 0x80 to 0xff - they are probably worse
> than whitespace.
> 
> OTOH why are any characters invalid at all - except '/'?
> 

The name is supposed to reflect a driver name. Usually driver names
are not defined by userspace but by driver authors. The name is used
by libsensors to distinguish a driver from its instantiation.
libsensors uses wildcards in /etc/sensors3.conf. Duplicate names
are expected; there can be many instances of the same driver in
the system. For example, on the system I am typing this on, I have:

/sys/class/hwmon/hwmon0/name:nvme
/sys/class/hwmon/hwmon1/name:nvme
/sys/class/hwmon/hwmon2/name:nouveau
/sys/class/hwmon/hwmon3/name:nct6797
/sys/class/hwmon/hwmon4/name:jc42
/sys/class/hwmon/hwmon5/name:jc42
/sys/class/hwmon/hwmon6/name:jc42
/sys/class/hwmon/hwmon7/name:jc42
/sys/class/hwmon/hwmon8/name:k10temp

hwmon_is_bad_char() filters out characters which interfere with
libsensor's view of driver instances and the configuration data
in /etc/sensors3.conf. For example, again on my system, the
"sensors" command reports the following jc42 and nvme sensors.

jc42-i2c-0-1a
jc42-i2c-0-18
jc42-i2c-0-1b
jc42-i2c-0-19
nvme-pci-0100
nvme-pci-2500

In /etc/sensors3.conf, there might be entries for "jc42-*" or "nvme-*".
I don't think libsensors cares if a driver is named "this/is/my/driver".
That driver would then, assuming it is an i2c driver, show up
with the sensors command as "this/is/my/driver-i2c-0-25" or similar.
If it is named "this%is%my%driver", it would be something like
"this%is%my%driver-i2c-0-25". And so on. We can not permit "jc-42"
because libsensors would not be able to parse something like
"jc-42-*" or "jc-42-i2c-*".

Taking your example, if driver authors implement two drivers, one
named foo-bar and the other foo_bar, it would be the driver authors'
responsibility to provide valid driver names to the hwmon subsystem,
whatever those names might be. If both end up named "foo_bar" and can
as result not be distinguished from each other by libsensors,
or a user of the "sensors" command, that would be entirely the
responsibility of the driver authors. The only involvement of the
hwmon subsystem - and that is optional - would be to provide means
to the drivers to help them ensure that the names are valid, but
not that they are unique.

If there is ever a driver with a driver name that interferes with
libsensors' ability to distinguish the driver name from interface/port
information, we'll be happy to add the offending character(s)
to hwmon_is_bad_char(). Until then, being picky doesn't really
add any value and appears pointless.

Thanks,
Guenter
