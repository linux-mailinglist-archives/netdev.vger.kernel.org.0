Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95E6A27F375
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 22:43:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728660AbgI3UnG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 16:43:06 -0400
Received: from know-smtprelay-omc-7.server.virginmedia.net ([80.0.253.71]:34061
        "EHLO know-smtprelay-omc-7.server.virginmedia.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725355AbgI3UnG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 16:43:06 -0400
Received: from [192.168.1.164] ([216.213.158.137])
        by cmsmtp with ESMTPA
        id NiwJkk4LfzNL5NiwJkapw3; Wed, 30 Sep 2020 21:43:04 +0100
X-Originating-IP: [216.213.158.137]
X-Authenticated-User: d.bilsby@virgin.net
X-Spam: 0
X-Authority: v=2.3 cv=VOHzYeHX c=1 sm=1 tr=0 a=KkNRBMPBZrkFnDmfS57fCg==:117
 a=KkNRBMPBZrkFnDmfS57fCg==:17 a=N659UExz7-8A:10 a=lEtCjqtbhUF9KZYFwnMA:9
 a=pILNOxqGKmIA:10
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virgin.net;
        s=meg.feb2017; t=1601498584;
        bh=McxYC7HiYBlBDQCzLxnUPS3fJbvZL9e8QQHykacFNDI=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To;
        b=QhHnzskPu9NZsZoNW5rowjLZs7Hx2LM5XvxyetCVECRX5KxrEmqWCINZTgKaYIzPX
         Hmh8F6kV6CxVa6vZaCfc96cYUyWBbpl+cBjxgye8pKzXKoOs56Uq2bP/DPmB7pNatF
         xU7clM6Mzyix5LZPEST+OEvUFr+keonavKXtwC6z64wyRKExIDhAMijdIlxZcZimck
         8pi1Xm0idrhPSy47SlqGNF329sLMAsEDJNFdbik6KsvNuKmV+y6ZbNBq+/o4j8CWyj
         OkLdQuLeh/Yj87hEKyDHRA2Y99hKiST6fHV5b5T5KoboWjkaBcsRsuIOtvlUT0W7EM
         KuRtkE4pQGzKg==
Subject: Re: Altera TSE driver not working in 100mbps mode
To:     Petko Manolov <petkan@nucleusys.com>
Cc:     Thor Thayer <thor.thayer@linux.intel.com>, netdev@vger.kernel.org
References: <20191127135419.7r53qw6vtp747x62@p310>
 <20191203092918.52x3dfuvnryr5kpx@carbon>
 <c8e4fc3a-0f40-45b6-d9c8-f292c3fdec9d@virgin.net>
 <20200917064239.GA40050@p310>
 <9f312748-1069-4a30-ba3f-d1de6d84e920@virgin.net>
 <20200918171440.GA1538@p310>
From:   David Bilsby <d.bilsby@virgin.net>
Message-ID: <bbd5cc3a-51a9-d46c-ef24-f0bb4d6498fe@virgin.net>
Date:   Wed, 30 Sep 2020 21:43:04 +0100
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200918171440.GA1538@p310>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-CMAE-Envelope: MS4wfIyxl5Oi6Hv+smDiVZoupXa3MFHfpMZBMmlZcC1YuP58VMMiizqArfrHWP4KEoX8rOyW0Wdji0HWC7p+wTLoFEKC8wORV/DG/RlehUMGWfpDuIqjiWCU
 MCCwKcNRbEkGBCkHsAcueG5MTMlowVen1/rH72euCE6sGb3r7h7w98NiAQtnRk51/7IH7k66cOwFGAsTQpT9C0XV56dROVujng6qPz9QHf0+I/qSJIj/KvqG
 E+agSouoES4A4ehcI1bUcg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18/09/2020 18:14, Petko Manolov wrote:
> On 20-09-17 21:29:41, David Bilsby wrote:
>> On 17/09/2020 07:42, Petko Manolov wrote:
>>> On 20-09-16 22:32:03, David Bilsby wrote:
>>>> Hi
>>>>
>>>> Would you consider making the PhyLink modifications to the Altera TSE
>>>> driver public as this would be very useful for a board we have which uses
>>>> an SFP PHY connected to the TSE core via I2C. Currently we are using a
>>>> fibre SFP and fixing the speed to 1G but would really like to be able to
>>>> use a copper SFP which needs to do negotiation.
>>> Well, definitely yes.
>>>
>>> The driver isn't 100% finished, but it mostly works.  One significant
>>> downside is the kernel version i had to port it to: 4.19.  IIRC there is API
>>> change so my current patches can't be applied to 5.x kernels.  Also, i could
>>> not finish the upstreaming as the customer device i worked on had to be
>>> returned.
>> Interesting about kernel versions as we have just moved to the latest 5.4.44
>> lts kernel as suggested on Rocketboard for Arria 10s. We had been having
>> issues with 4.19 kernel which seem to have been resolved in the 5.4.44.
> Always use mainline (and new) kernels.  If possible... ;)
>
>>> However, given access to Altera TSE capable device (which i don't have atm),
>>> running a recent kernel, i'll gladly finish the upstreaming.
>> I would be happy to take what you have at the moment, pre-upstreaming, and see
>> if I can get it going on the latter kernel, and hopefully provide some testing
>> feedback. Obviously pass any changes back for you to review and include as
>> part of your original work.
> There you go.
>
>
> 		Petko

Hi Petko

I've made some progress in integrating your TSE patches, in between 
doing my main work. I've managed to get the code into the later 5.4.44 
kernel and compile without errors, however my initial attempts failed to 
configure the driver. In case it was due to the kernel port I backed out 
to my 4.19 kernel build and used your patches as is. This also failed 
but after a bit of debug I realised it was just the device tree set up. 
I'm using the device tree as created by the sopc2dts tool, however this 
does not seem to create a "pcs" memory region in the TSEs iomem "reg" 
section. Did you add this section manually or was it created 
automatically from your sopcinfo file?

If you added this manually was it because the "pcs" regions location 
depends on the cores configuration, i.e. MAC and PCS or just PCS, and 
therefore it was easier to pass this into the driver through the device 
tree? The firmware manual suggests that for a MAC with PCS core 
configuration the MAC registers appears at offset 0x0 for 0x80 and then 
the PCS registers from 0x80 for 0x20. I manually edited my device tree 
to shrink the default "control_port" region, which seems to map in the 
driver to the MAC config registers and then added the "pcs" region above 
this. Once I'd done that the driver loaded successfully. I suspect if I 
make this change to the 5.4.44 kernel version it will also initialise 
the driver.

I now seem to be tantalisingly close to getting it working. I can see 
network packets arriving if I do a "tcpdump -i eth0" using a copper 
10/100/1000Base-T SFP, but no packets seem to be transmitted. I'm 
guessing I've maybe messed up on the device tree entries for either the 
SFP config or maybe how it links back to the TSE. In the TSE device tree 
section I added the following as suggested by your original post:

         sfp = <&sfp_eth_b>;

         managed = “in-band-status”;

Should I have added anything for the "phy-handle", thinks it's "<0>" at 
the moment?

For the SFP device tree section I added the following at the top level 
which broadly followed the "sff,sfp" document:

/ {

     sfp_eth_b: sfp-eth-b {

         compatible = “sff,sfp”;

         i2c-bus = <sfp_b_i2c>;

         los-gpios = <&pca9506 10 GPIO_ACTIVE_HIGH>;

         …

     };

};

The SFP cage is connected to the "sfp_b_i2c" I2C bus, this is actually 
off an I2C mux but that I'm hoping will be handled by Linux as it has a 
driver for the MUX chip. I assume the default SFP I2C address (0x50) is 
used by the PhyLink layer so there is no need to specify that? The LED 
indicators for my set up are off another I2C GPIO expander (PCA9506), so 
I used those references for the LOS, etc "gpios" entries. This section 
also has the "tx-disable-gpios" property, again I referenced the 
appropriate pin off the PCA9506, so I guess if I got that wrong then 
that could explain the failure on the Tx side. That said none of the LED 
GPIOs I hooked up seemed to light so maybe there is something up there.

Any hints would be most welcome.

Cheers

David



