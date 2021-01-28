Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88C19306AB9
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 02:53:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbhA1Bvs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 20:51:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbhA1Bvo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 20:51:44 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 537D8C061573
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 17:51:03 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id j12so2941431pfj.12
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 17:51:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tb8BFcDTTuHpv5p1IwWR00tBxJv8VR4oDrs15a7eJ3o=;
        b=ruWAaDB4fI66OHvNi7Ko0dzy5iPKgzQk3KajBTT6YXr7X/ZlxgN07SeCW4C2MMWdIR
         dRGSK9kSjQzkFVUxoDIcPtfr1gwhy8KDxQzA2RMtBv2vwJFRFR1iNNWOAptV0aFvwyhM
         oOQjtl5Tn9YUjDwHZpOCTc14F6d3bAz24vcRy93dQ2dpRoQMF8cj2rDn7UcWQYce9LBb
         8UCrbvBQerdZw5s4uWZ5sF4uFm7r8brFRr8QLw5jAKaOmpRtIAUR06zs9Y5WuUkvu1FO
         PkhgrOBpLeB9JZSH+wiE7Rc+49PiaFVRGTgNS96xC3MWbZrqD48UvirrABRtZ6zBJZcA
         niyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tb8BFcDTTuHpv5p1IwWR00tBxJv8VR4oDrs15a7eJ3o=;
        b=oAz9asDjxSR7z3gg0fdl+TQk0+iDS42n9VxgbOxvpE9bmwllTztSWRT4sfKBZUzlK0
         pQoXq71CaLyEjyPTd24J7X0/DOdPL1gdfo4TC2YWHrOaxdyeX+fgHEiJor78HEnr1hHn
         GtJjtxh/6FdNKQzx6zOUGeGsiw4EhJCG8EeeZ3sgSxM3cMCRKr4+ZZxIrngJm69nsXWD
         lajS5jJ3+CA+jfL0/5uhNuIJeGmmOe7r/gxZXhzQpv/Y9tUF/gVCAGfYPh95vE/tVeRg
         e4uNAMRgnEMjHvlWvhO22ybUn8+KicWRzMaeP7WTuQK7i6LB0V/XJNi6rsZrYzMIVGdJ
         MnZQ==
X-Gm-Message-State: AOAM532yCWpz5VfSSw0iNh90YVgaojvxRgkyuOL2YceI+DP4CcU7yCDZ
        bnZAIdBEl6yKO/2zx/2aPEw=
X-Google-Smtp-Source: ABdhPJx3O+EPGUisJsGzcCUh9I1q6kH148Sh73974CqAqeWa308js+L2WcZlXlw0r/wddFigtf2prA==
X-Received: by 2002:a63:700c:: with SMTP id l12mr14084558pgc.137.1611798662835;
        Wed, 27 Jan 2021 17:51:02 -0800 (PST)
Received: from [10.230.29.30] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id h12sm3615938pgs.7.2021.01.27.17.51.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Jan 2021 17:51:02 -0800 (PST)
Subject: Re: [PATCH v7 net-next 08/11] net: dsa: allow changing the tag
 protocol via the "tagging" device attribute
To:     Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        UNGLinuxDriver@microchip.com
References: <20210125220333.1004365-1-olteanv@gmail.com>
 <20210125220333.1004365-9-olteanv@gmail.com>
 <20210127173044.65de6aba@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <06f6bbc8-c841-5071-ece5-4ee31adc7d36@gmail.com>
Date:   Wed, 27 Jan 2021 17:51:00 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210127173044.65de6aba@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/27/2021 5:30 PM, Jakub Kicinski wrote:
> On Tue, 26 Jan 2021 00:03:30 +0200 Vladimir Oltean wrote:
>> From: Vladimir Oltean <vladimir.oltean@nxp.com>
>>
>> Currently DSA exposes the following sysfs:
>> $ cat /sys/class/net/eno2/dsa/tagging
>> ocelot
>>
>> which is a read-only device attribute, introduced in the kernel as
>> commit 98cdb4807123 ("net: dsa: Expose tagging protocol to user-space"),
>> and used by libpcap since its commit 993db3800d7d ("Add support for DSA
>> link-layer types").
>>
>> It would be nice if we could extend this device attribute by making it
>> writable:
>> $ echo ocelot-8021q > /sys/class/net/eno2/dsa/tagging
>>
>> This is useful with DSA switches that can make use of more than one
>> tagging protocol. It may be useful in dsa_loop in the future too, to
>> perform offline testing of various taggers, or for changing between dsa
>> and edsa on Marvell switches, if that is desirable.
>>
>> In terms of implementation, drivers can now move their tagging protocol
>> configuration outside of .setup/.teardown, and into .set_tag_protocol
>> and .del_tag_protocol. The calling order is:
>>
>> .setup -> [.set_tag_protocol -> .del_tag_protocol]+ -> .teardown
>>
>> There was one more contract between the DSA framework and drivers, which
>> is that if a CPU port needs to account for the tagger overhead in its
>> MTU configuration, it must do that privately. Which means it needs the
>> information about what tagger it uses before we call its MTU
>> configuration function. That promise is still held.
>>
>> Writing to the tagging sysfs will first tear down the tagging protocol
>> for all switches in the tree attached to that DSA master, then will
>> attempt setup with the new tagger.
>>
>> Writing will fail quickly with -EOPNOTSUPP for drivers that don't
>> support .set_tag_protocol, since that is checked during the deletion
>> phase. It is assumed that all switches within the same DSA tree use the
>> same driver, and therefore either all have .set_tag_protocol implemented,
>> or none do.
>>
>> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
>> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> 
>> +const struct dsa_device_ops *dsa_find_tagger_by_name(const char *buf)
>> +{
>> +	const struct dsa_device_ops *ops = NULL;
>> +	struct dsa_tag_driver *dsa_tag_driver;
>> +
>> +	mutex_lock(&dsa_tag_drivers_lock);
>> +	list_for_each_entry(dsa_tag_driver, &dsa_tag_drivers_list, list) {
>> +		const struct dsa_device_ops *tmp = dsa_tag_driver->ops;
>> +
>> +		if (!sysfs_streq(buf, tmp->name))
>> +			continue;
>> +
>> +		ops = tmp;
>> +		break;
>> +	}
>> +	mutex_unlock(&dsa_tag_drivers_lock);
> 
> What's protecting from the tag driver unloading at this very moment?

Yes good point I missed that, too. The tag driver would need to get its
reference count incremented similarly to what dsa_tag_driver_get() does
and you would need to release the previous tag driver if successful in
grabbing the new one.
-- 
Florian
