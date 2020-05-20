Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E7D71DB427
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 14:52:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726718AbgETMwe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 08:52:34 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:22661 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726452AbgETMwe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 08:52:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1589979154; x=1621515154;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Pmrtx5eXqbCxI6dGo1e/Adh6TjwHWVWJoZlKDTB14lY=;
  b=JypEm3ttTACHI28s6GWVUQZc0Lt+Lf5PidZtxV1zV+dU4ew4zj1e6cCZ
   gS8vBUrrhbWxhXD85anFUbK428E8xlswZqxRd50Cl+2bNT5tdBBTYgboe
   Jklc7djSkRfkHoKlhRZJ7WodsHSATUOx08Aef71RAGZ9iKbaBtEn8nuXo
   LOFf3dya7F4MhtnniNxasuQAB5GYp7kx75cua20Ry7coLTXJb5jlrq4U9
   S4uKiUPDa66rZKCzJCzXofDBe9tD2hVEHYELEm8wPJSYPil5epiLoIT50
   ba/vEtgU/6w8KkwpMtdw5815W3+/8w/5w8Gwn1BmJVXroambG6KzFn6We
   g==;
IronPort-SDR: 3q/NpLbeOzsh8aoH7SJjOMpaA5WaQxNVLFey39YBgI57Y4mXWDtzJO1uzyJlOamUXxJ0ZFmIZQ
 vWZz7ewPjQQVyDquzdadzj1gfcKMavDFoZXm53TFuRq+h9s537CSgUBnvuWaTM8pFEfRRV5hVM
 bBCAZi60WJfWER5Lv/sLLFAM8RGUQrGdiN7XOJSnByVNWYJn2uu9V71HQZBL6ldtyWIvWjXlxC
 3Kw4NvW+tRIO+zHMh9Bw/mkxhKJmAXlFI8S3/sEbe3vDZAtlYaUv1m3v4J/qs0QDqpCsLJ6oni
 2Bk=
X-IronPort-AV: E=Sophos;i="5.73,414,1583218800"; 
   d="scan'208";a="76490592"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 May 2020 05:52:33 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 20 May 2020 05:52:33 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Wed, 20 May 2020 05:52:33 -0700
Date:   Wed, 20 May 2020 14:52:32 +0200
From:   Joergen Andreasen <joergen.andreasen@microchip.com>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
CC:     Andre Guedes <andre.guedes@intel.com>,
        <intel-wired-lan@lists.osuosl.org>, <jeffrey.t.kirsher@intel.com>,
        <netdev@vger.kernel.org>, <vladimir.oltean@nxp.com>,
        <po.liu@nxp.com>, <m-karicheri2@ti.com>, <Jose.Abreu@synopsys.com>
Subject: Re: [next-queue RFC 0/4] ethtool: Add support for frame preemption
Message-ID: <20200520125232.s3zrmlnesqjilcf6@soft-dev16>
References: <20200516012948.3173993-1-vinicius.gomes@intel.com>
 <158992799425.36166.17850279656312622646@twxiong-mobl.amr.corp.intel.com>
 <87y2pnmr83.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <87y2pnmr83.fsf@intel.com>
User-Agent: NeoMutt/20171215
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 05/19/2020 16:37, Vinicius Costa Gomes wrote:
> 
> Andre Guedes <andre.guedes@intel.com> writes:
> 
> > Hi,
> >
> > Quoting Vinicius Costa Gomes (2020-05-15 18:29:44)
> >> One example, for retrieving and setting the configuration:
> >>
> >> $ ethtool $ sudo ./ethtool --show-frame-preemption enp3s0
> >> Frame preemption settings for enp3s0:
> >>         support: supported
> >>         active: active
> >
> > IIUC the code in patch 2, 'active' is the actual configuration knob that
> > enables or disables the FP functionality on the NIC.
> >
> > That sounded a bit confusing to me since the spec uses the term 'active' to
> > indicate FP is currently enabled at both ends, and it is a read-only
> > information (see 12.30.1.4 from IEEE 802.1Q-2018). Maybe if we called this
> > 'enabled' it would be more clear.
> 
> Good point. Will rename this to "enabled".
> 
> >
> >>         supported queues: 0xf
> >>         supported queues: 0xe
> >>         minimum fragment size: 68
> >
> > I'm assuming this is the configuration knob for the minimal non-final fragment
> > defined in 802.3br.
> >
> > My understanding from the specs is that this value must be a multiple from 64
> > and cannot assume arbitrary values like shown here. See 99.4.7.3 from IEEE
> > 802.3 and Note 1 in S.2 from IEEE 802.1Q. In the previous discussion about FP,
> > we had this as a multiplier factor, not absolute value.
> 
> I thought that exposing this as "(1 + N)*64" (with 0 <= N <= 3) that it
> was more related to what's exposed via LLDP than the actual capabilities
> of the hardware. And for the hardware I have actually the values
> supported are: (1 + N)*64 + 4 (for N = 0, 1, 2, 3).
> 
> So I thought I was better to let the driver decide what values are
> acceptable.
> 
> This is a good question for people working with other hardware.
> 

I think it's most intuitive to use the values for AddFragSize as described in
802.3br (N = 0, 1, 2, 3).
You will anyway have to use one of these values when you want to expose the
requirements of your receiver through LLDP.

> 
> --
> Vinicius

-- 
Joergen Andreasen, Microchip
