Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DF0926CEBD
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 00:29:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726375AbgIPW3f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 18:29:35 -0400
Received: from know-smtprelay-omc-5.server.virginmedia.net ([80.0.253.69]:39714
        "EHLO know-smtprelay-omc-5.server.virginmedia.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726187AbgIPW3f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Sep 2020 18:29:35 -0400
X-Greylist: delayed 1196 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Sep 2020 18:29:34 EDT
Received: from [192.168.1.164] ([82.163.255.100])
        by cmsmtp with ESMTPA
        id If24kuM0EsXBbIf24kzX3k; Wed, 16 Sep 2020 22:32:05 +0100
X-Originating-IP: [82.163.255.100]
X-Authenticated-User: d.bilsby@virgin.net
X-Spam: 0
X-Authority: v=2.3 cv=BLWdUmYG c=1 sm=1 tr=0 a=acTulsBkoInqGr3sReUtMw==:117
 a=acTulsBkoInqGr3sReUtMw==:17 a=IkcTkHD0fZMA:10 a=cAs4_CvN1kBeiWRU8RYA:9
 a=viq6OqHhwEegeX7Q:21 a=b2b0b3q4O5IdSwuL:21 a=QEXdDO2ut3YA:10
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virgin.net;
        s=meg.feb2017; t=1600291925;
        bh=Q+Np2WEj1lwBSwbhv8byIL1UOx8SBBOt+q4pC3/SbKM=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To;
        b=aqTz7QULPaIPRsOVrft5D5lHFCgYYCj1rHKt9dVqvj7+Ss0P7Iz+OnS4ewhWzgSVg
         PeOAHZkcxic58KdSMu6IyCyBJX1voKL5eVR7pSHmoYFBg4rJpIa+d12pd1ZnVaDfXE
         3iFAry6Eu503SkzDMEeoboQ4g9gB3LaMNqyfjX7JjOs4/xmidA8falwD87QPmSLBPU
         9+2vzXTc2V7SU4DbfImwr/gaye4l93Ge2QhIpmbAwfJISjc5kt9xtBAveGs8xmyE+y
         DM0veVYOoHyLiU1+bv1O1zFObNsQQdaLGdl3MzYMGyuVcPu0kJD6dkzFqlkxgcGctd
         ivxagYbsqlP/A==
Subject: Re: Re: Altera TSE driver not working in 100mbps mode
To:     Petko Manolov <petkan@nucleusys.com>,
        Thor Thayer <thor.thayer@linux.intel.com>
Cc:     netdev@vger.kernel.org
References: <20191127135419.7r53qw6vtp747x62@p310>
 <20191203092918.52x3dfuvnryr5kpx@carbon>
From:   David Bilsby <d.bilsby@virgin.net>
Message-ID: <c8e4fc3a-0f40-45b6-d9c8-f292c3fdec9d@virgin.net>
Date:   Wed, 16 Sep 2020 22:32:03 +0100
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20191203092918.52x3dfuvnryr5kpx@carbon>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
X-CMAE-Envelope: MS4wfBPdrVgYDy8O+X/HvBQvArwHYeupQhXyfbPeHPAOZBYnRuMf1/4DctAbgaTb/26w+gLrHJc97/v0zmL4rGYlP0sQ1+5Iui0W+D8GMCSuJRpHSuZ/YEmy
 EVkaUBhHLeWshMPS05YHcWNkG4K5cMIgaucLdODQVYedlKgMWbLysF5vSIeKwoSMgqNJrvZhDY7O4kpRJtaqbk8jwbNiLL7KHQlNiIZ056/EBrv0gXBquJMm
 FsVXyWMj4SiwnwMZzTk5FQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi

Would you consider making the PhyLink modifications to the Altera TSE 
driver public as this would be very useful for a board we have which 
uses an SFP PHY connected to the TSE core via I2C. Currently we are 
using a fibre SFP and fixing the speed to 1G but would really like to be 
able to use a copper SFP which needs to do negotiation.

Cheers

David

On 03/12/2019 09:29, Petko Manolov wrote:
> All right, the first message got ignored so this is my take two. :)
>
> Has anyone stumbled on the same problem as me?
>
>
> cheers,
> Petko
>
>
> On 19-11-27 15:54:19, Petko Manolov wrote:
>> 	Hi Thor,
>>
>> In my effort to move Altera TSE driver from PHYLIB to PHYLINK i ran into a
>> problem.  The driver would not work properly on 100Mbit/s links.  This is true
>> for the original driver in linux-5.4.y as well as for my PHYLINK/SFP enabled
>> version.
>>
>> This is a DT fragment of what i've been trying with 5.4.y kernels and the
>> stock driver:
>>
>>                  tse_sub_2: ethernet@0xc0300000 {
>>                          status = "disabled";
>>
>>                          compatible = "altr,tse-msgdma-1.0";
>>                          reg =   <0xc0300000 0x00000400>,
>>                                  <0xc0301000 0x00000020>,
>>                                  <0xc0302000 0x00000020>,
>>                                  <0xc0303000 0x00000008>,
>>                                  <0xc0304000 0x00000020>,
>>                                  <0xc0305000 0x00000020>;
>>                          reg-names = "control_port", "rx_csr", "rx_desc", "rx_resp", "tx_csr", "tx_desc";
>>                          interrupt-parent =< &intc >;
>>                          interrupts = <0 54 4>, <0 55 4>;
>>                          interrupt-names = "rx_irq", "tx_irq";
>>                          rx-fifo-depth = <2048>;
>>                          tx-fifo-depth = <2048>;
>>                          address-bits = <48>;
>>                          max-frame-size = <1500>;
>>                          local-mac-address = [ 00 0C ED 00 00 06 ];
>>                          altr,has-supplementary-unicast;
>>                          altr,has-hash-multicast-filter;
>>                          phy-handle = <0>;
>>                          fixed-link {
>>                                  speed = <1000>;
>>                                  full-duplex;
>>                          };
>>                  };
>>
>> Trying "speed = <100>;" above also doesn't change much, except that the link is
>> reported (as expected) as 100Mbps.
>>
>> With the PHYLINK code the above fragment is pretty much the same except for:
>>
>>                          sfp = <&sfp0>;
>>                          phy-mode = "sgmii";
>>                          managed = "in-band-status";
>>
>> Both (old and new) drivers are working fine on 1Gbps links with optics and
>> copper SFPs.  With PHYLINK code (and in auto-negotiation mode) the link speed
>> and duplex is properly detected as 100Mbps.  MAC and PCS also look correctly set
>> up, but the device is still unable to receive or transmit packages.
>>
>>
>> Please let me know should you need more details.
>>
>>
>> thanks,
>> Petko
>>
