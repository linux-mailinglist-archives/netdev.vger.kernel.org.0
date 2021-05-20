Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB06B38AF72
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 14:59:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243398AbhETNA5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 09:00:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243546AbhETNAC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 09:00:02 -0400
X-Greylist: delayed 455 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 20 May 2021 05:25:58 PDT
Received: from discovery.labus-online.de (discovery.labus-online.de [IPv6:2a01:4f8:231:4262::1001])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA518C07E5F9
        for <netdev@vger.kernel.org>; Thu, 20 May 2021 05:25:58 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by discovery.labus-online.de (Postfix) with ESMTP id 4AFC31120009;
        Thu, 20 May 2021 14:18:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=freifunk-rtk.de;
        s=modoboa; t=1621513096;
        bh=3ELUNMMPTeVhh3rOOjZqK9/Bfz34rnsUi8hzpJIQOUA=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=NxHWsDOkAO2VzQcxoA3sckADmDRHF4YHj7yKzyeKYq2iCZbzxHycgh8DEk+TLDyF2
         Hoj6x20LTKnd8CHZISWB2hnvHlglEEQ4kYFZds+kybekfDB3hTnadrih66a7Cv6Nvn
         p3bxQCzJM50x0CqOrizwudN++3apsS3n0KFMMyKkFLOe7269DT1EME02F3eJ6xJRjW
         zfTUk6hC1Cb+Na9KK8jeMHLffMqw/s1hXqDr2Qj5MmBpjazgo6IUOdlJ/TOND63eyd
         k0aA8R6TCJvHeFZywTc+lKOKDn4c0p0Hw1PUkuPK59gYZLZpoWv5aoqtbMhBZnTS/L
         lxtJ5XUnI/Ilw==
X-Virus-Scanned: Debian amavisd-new at discovery.labus-online.de
Received: from discovery.labus-online.de ([127.0.0.1])
        by localhost (mail.labus-online.de [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id TDjFtml2sow2; Thu, 20 May 2021 14:18:07 +0200 (CEST)
Received: from [IPv6:2a02:908:1966:3a60:b62e:99ff:fe91:d1a9] (unknown [IPv6:2a02:908:1966:3a60:b62e:99ff:fe91:d1a9])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature ECDSA (P-384) server-digest SHA384)
        (No client certificate requested)
        by discovery.labus-online.de (Postfix) with ESMTPSA;
        Thu, 20 May 2021 14:18:07 +0200 (CEST)
Subject: Re: stmmac: zero udp checksum
To:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, mschiffer@universe-factory.net,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>
References: <cfc1ede9-4a1c-1a62-bdeb-d1e54c27f2e7@freifunk-rtk.de>
 <YGsQQUHPpuEGIRoh@lunn.ch>
 <98fcc1a7-8ce2-ac15-92a1-8c53b0e12658@freifunk-rtk.de>
 <YGs+DeFzhVh7UlEh@lunn.ch>
 <20210405160339.1c264af4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Julian Labus <julian@freifunk-rtk.de>
Message-ID: <e68b0973-226d-8223-7d0d-32a865c7af70@freifunk-rtk.de>
Date:   Thu, 20 May 2021 14:18:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210405160339.1c264af4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi stmmac maintainers,

it's around 1 1/2 months without any response on this topic.
Could you please advice how to proceed with this problem?

Kind regards,
Julian

On 06.04.21 01:03, Jakub Kicinski wrote:
> On Mon, 5 Apr 2021 18:42:53 +0200 Andrew Lunn wrote:
>>> But was is still a bit strange to me is that it seems like the stmmac driver
>>> behaves different than other ethernet drivers which do not drop UDP packets
>>> with zero checksums when rx checksumming is enabled.
>>
>> To answer that, you need somebody with more knowledge of the stmmac
>> hardware.
> 
> +1 stmmac maintainers could you advise?
> 
>> It is actually quite hard to do. It means you need to parse
>> more of the frame to determine if the frame contains a VXLAN
>> encapsulated frame. Probably the stmmac cannot do that. It sees the
>> checksum is wrong and drops the packet.
>>
>> Have you looked at where it actually drops the packet?
>> Is it one of
>>
>> https://elixir.bootlin.com/linux/latest/source/drivers/net/ethernet/stmicro/stmmac/norm_desc.c#L95
>>
>> or
>>
>> https://elixir.bootlin.com/linux/latest/source/drivers/net/ethernet/stmicro/stmmac/enh_desc.c#L87
>>
>> It could be, you need to see if the checksum has fail, then check if
>> the checksum is actually zero, and then go deeper into the frame and
>> check if it is a vxlan frame. It could be the linux software checksum
>> code knows about this vxlan exception, so you can just run that before
>> deciding to drop the frame.
> 
> To be clear the expectation is that devices / drivers will only drop
> packets on L2 / FCS errors. If L3 or L4 csum is incorrect the packet
> should be passed up the stack and kernel will handle it how it sees fit.
> 
