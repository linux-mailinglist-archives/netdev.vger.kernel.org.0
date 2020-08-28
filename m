Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3457A25632D
	for <lists+netdev@lfdr.de>; Sat, 29 Aug 2020 00:34:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726626AbgH1WeI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 18:34:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726536AbgH1WeH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Aug 2020 18:34:07 -0400
Received: from ipv6.s19.hekko.net.pl (ipv6.s19.hekko.net.pl [IPv6:2a02:1778:113::19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCEF1C061264
        for <netdev@vger.kernel.org>; Fri, 28 Aug 2020 15:34:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=arf.net.pl;
         s=x; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version:Date:
        Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Q1O9CsRtHN19t4S94lJWd9Gcp7LVdGKjZcFkPSnBV3Y=; b=SzHL8sHXDcdqvrkeMfhfRP/qvc
        lbbeN+Q703HFnokafTpMvOVgp3Vc564ueBvTI8FdxUAYuHE2YrtdHHHYp83Xwam4sMaai+hU/wFKs
        1PcKyHe93OKTP6MnL16ElZrXamrSO/F1AaRG+zRZ77D1zHWjZpuaYqPECC83n4RHEFMrHBoi5418t
        dLV0rmzPrEFL5M8PU975SkRUHDxQ6+pGOeShU04XXYm9RX9VgbeAtBhAflzpdLnloCUTHEE+/ArGQ
        s3SdzTsfKv01+l8su6hUE25hRuM48dI9t2TDEIHN1TjEMZlzxHOQ9XnCmdG125PvCJGfUi1kz5IEh
        rrgatx4w==;
Received: from [185.135.2.46] (helo=[172.20.10.2])
        by s19.hekko.net.pl with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.92.3)
        (envelope-from <adam.rudzinski@arf.net.pl>)
        id 1kBmwf-00Fqv5-6z; Sat, 29 Aug 2020 00:34:05 +0200
Subject: Re: drivers/of/of_mdio.c needs a small modification
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     robh+dt@kernel.org, frowand.list@gmail.com, f.fainelli@gmail.com,
        netdev <netdev@vger.kernel.org>
References: <c8b74845-b9e1-6d85-3947-56333b73d756@arf.net.pl>
 <20200828222846.GA2403519@lunn.ch>
From:   =?UTF-8?Q?Adam_Rudzi=c5=84ski?= <adam.rudzinski@arf.net.pl>
Message-ID: <dcfea76d-5340-76cf-7ad0-313af334a2fd@arf.net.pl>
Date:   Sat, 29 Aug 2020 00:34:05 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200828222846.GA2403519@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: pl
X-Authenticated-Id: ar@arf.net.pl
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew.

W dniu 2020-08-29 o 00:28, Andrew Lunn pisze:
> Hi Adam
>
>> If kernel has to bring up two Ethernet interfaces, the processor has two
>> peripherals with functionality of MACs (in i.MX6ULL these are Fast Ethernet
>> Controllers, FECs), but uses a shared MDIO bus, then the kernel first probes
>> one MAC, enables clock for its PHY, probes MDIO bus tryng to discover _all_
>> PHYs, and then probes the second MAC, and enables clock for its PHY. The
>> result is that the second PHY is still inactive during PHY discovery. Thus,
>> one Ethernet interface is not functional.
> What clock are you talking about? Do you have the FEC feeding a 50MHz
> clock to the PHY? Each FEC providing its own clock to its own PHY? And
> are you saying a PHY without its reference clock does not respond to
> MDIO reads and hence the second PHY does not probe because it has no
> reference clock?
>
> 	  Andrew

Yes, exactly. In my case the PHYs are LAN8720A, and it works this way.
Maybe this problem is PHY-related.
I also think that my proposition allows to make device tree look better 
and be less confusing, as a side-effect.

Best regards,
Adam

