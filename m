Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D03831A1976
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 03:20:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbgDHBUB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 21:20:01 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:48483 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726416AbgDHBUA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Apr 2020 21:20:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586308799;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Yynh6enpaQOt1XUlAWveegHSiUBm2+b0w4JqLXxNInA=;
        b=QBZ2JqO1rE73UdK5+lZKBShYWCU+ms8I6Vs5tt+hQh13Otgm420kQ+gWRCEwyo4rLMUwC1
        eM4KgDHr24RlPo+Ek2kWeGOHVAfyhvfaarlj72A71m30eYcvcsO42IEDLm12owzBnsd17l
        iprqPDNepAhAiJaky4FxeXBtWf+H9Do=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-241-I--wJGyEMVmG2GKZ-3di1A-1; Tue, 07 Apr 2020 21:19:57 -0400
X-MC-Unique: I--wJGyEMVmG2GKZ-3di1A-1
Received: by mail-wr1-f71.google.com with SMTP id w12so3124766wrl.23
        for <netdev@vger.kernel.org>; Tue, 07 Apr 2020 18:19:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=Yynh6enpaQOt1XUlAWveegHSiUBm2+b0w4JqLXxNInA=;
        b=KGH/Dn3jGt6AmyrAdIrFhtUnvRBvKDgzj5UEMCPMW4WmT548sF/8PBTP1GJJSyFjpu
         xC/XB1A3ZgAvBFoDV8NFLdukJ9xatsJFVIqdQ6T/8aWAxc1+/7XfEsb8eVsHgiN+5ZvH
         Jou1biv2+dshjCYWSnET0sQO8WzyQrZi2gtMiZpvLyAGjolkZwjtSKA2RWsmI/sOLELm
         L9ctnZRBxDKMzKX1YQaV5vk27N7FzxbwQZsPW/8LugYEpDK+jyupBfTYqJyHrjZ2jimn
         dPOis+R44TGn6jl0FXCBq5aU5avKPGymUGW9MPjA90LVSvHhzFtyMY7R0MccUY/iE7xS
         KawA==
X-Gm-Message-State: AGi0PuajjAl8t+9j39clm8oADKIlI/l8OKiuV8EnroUJiFn1bKoAeF5k
        lonGy2EIgxaXvYmqAFhoe0yUH7qK0DQYni0fatDeuWuhmlQpnKdBDAvaY40hCHnJAfLuqZTkwUe
        rKjneSiAjOGRFTxZ1
X-Received: by 2002:a1c:ac8a:: with SMTP id v132mr1914450wme.62.1586308795918;
        Tue, 07 Apr 2020 18:19:55 -0700 (PDT)
X-Google-Smtp-Source: APiQypLaQ8jm+WBVI/QXXC3y/wecnYYtN4bnsLufT0M1q3rnm9XPOgt4HbcYJI5WGFbrJD6qA1XOcQ==
X-Received: by 2002:a1c:ac8a:: with SMTP id v132mr1914429wme.62.1586308795574;
        Tue, 07 Apr 2020 18:19:55 -0700 (PDT)
Received: from turbo.teknoraver.net (net-93-148-149-154.cust.vodafonedsl.it. [93.148.149.154])
        by smtp.gmail.com with ESMTPSA id u7sm5080682wmg.41.2020.04.07.18.19.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Apr 2020 18:19:55 -0700 (PDT)
Date:   Wed, 8 Apr 2020 03:19:52 +0200
From:   Matteo Croce <mcroce@redhat.com>
To:     Chris Packham <chris.packham@alliedtelesis.co.nz>
Cc:     davem@davemloft.net, andrew@lunn.ch, josua@solid-run.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Luka Perkov <luka.perkov@sartura.hr>
Subject: Re: [PATCH v3 0/2] net: mvmdio: avoid error message for optional
 IRQ
Message-ID: <20200408031952.1d8dd01b@turbo.teknoraver.net>
In-Reply-To: <20200316074907.21879-1-chris.packham@alliedtelesis.co.nz>
References: <20200316074907.21879-1-chris.packham@alliedtelesis.co.nz>
Organization: Red Hat
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 Mar 2020 20:49:05 +1300
Chris Packham <chris.packham@alliedtelesis.co.nz> wrote:

> I've gone ahead an sent a revert. This is the same as the original v1
> except I've added Andrew's review to the commit message.
> 
> Chris Packham (2):
>   Revert "net: mvmdio: avoid error message for optional IRQ"
>   net: mvmdio: avoid error message for optional IRQ
> 
>  drivers/net/ethernet/marvell/mvmdio.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 

Hi all,

I have a Macchiatobin board and the 10G port stopped working in net-next.
I suspect that these two patches could be involved.
The phy is correctly detected now (I mean no errors and the device is
registered) but no traffic can be sent or received:

root@macchiatobin:~# dmesg |grep -i -e phy -e mvpp2
[    0.000000] Booting Linux on physical CPU 0x0000000000 [0x410fd081]
[    0.000000] arch_timer: cp15 timer(s) running at 25.00MHz (phys).
[    0.062798] libphy: Fixed MDIO Bus: probed
[    1.132552] armada8k-pcie f2600000.pcie: Phy link never came up
[    2.553464] libphy: orion_mdio_bus: probed
[    2.558045] libphy: orion_mdio_bus: probed
[    2.564037] mvpp2 f2000000.ethernet: using 8 per-cpu buffers
[    2.588754] mvpp2 f2000000.ethernet eth0: Using random mac address 1e:a6:ce:39:8d:22
[    2.599980] mvpp2 f4000000.ethernet: using 8 per-cpu buffers
[    2.623293] mvpp2 f4000000.ethernet eth1: Using random mac address aa:ad:b5:91:8c:1e
[    2.626535] mvpp2 f4000000.ethernet eth2: Using random mac address 6e:39:fb:74:09:6e
[    2.629600] mvpp2 f4000000.ethernet eth3: Using random mac address 16:ec:bf:9e:11:0f
[    2.952063] mvpp2 f4000000.ethernet eth2: PHY [f212a200.mdio-mii:00] driver [Marvell 88E1510] (irq=POLL)
[    2.953251] mvpp2 f4000000.ethernet eth2: configuring for phy/sgmii link mode
[    7.122899] mvpp2 f4000000.ethernet eth2: Link is Up - 1Gbps/Full - flow control rx/tx
[   25.727756] mvpp2 f2000000.ethernet eth0: PHY [f212a600.mdio-mii:00] driver [mv88x3310] (irq=POLL)
[   25.746711] mvpp2 f2000000.ethernet eth0: configuring for phy/10gbase-r link mode
[   27.842712] mvpp2 f2000000.ethernet eth0: Link is Up - 10Gbps/Full - flow control off


The only way to have it working is to unplug the power, boot an old
kernel, e.g. 5.3.0:

root@macchiatobin:~# dmesg |grep -i -e phy -e mvpp2
[    0.000000] Booting Linux on physical CPU 0x0000000000 [0x410fd081]
[    0.000000] arch_timer: cp15 timer(s) running at 25.00MHz (phys).
[    0.083647] libphy: Fixed MDIO Bus: probed
[    0.152788] armada8k-pcie f2600000.pcie: Failed to initialize PHY(s) (-22)
[    1.429643] libphy: orion_mdio_bus: probed
[    1.439109] libphy: orion_mdio_bus: probed
[    1.450989] mvpp2 f2000000.ethernet eth0: Using random mac address 5a:09:5f:97:aa:cc
[    1.476692] mvpp2 f4000000.ethernet eth1: Using random mac address f2:e2:c1:77:fa:23
[    1.479688] mvpp2 f4000000.ethernet eth2: Using random mac address b2:33:c0:2f:da:ba
[    1.482296] mvpp2 f4000000.ethernet eth3: Using random mac address 6a:38:79:2e:96:8c
[    1.814163] mvpp2 f4000000.ethernet eth2: PHY [f212a200.mdio-mii:00] driver [Marvell 88E1510]
[    1.814170] mvpp2 f4000000.ethernet eth2: phy: setting supported 00,00000000,000066ef advertising 00,00000000,000066ef
[    1.826025] mvpp2 f4000000.ethernet eth2: configuring for phy/sgmii link mode
[    1.826030] mvpp2 f4000000.ethernet eth2: phylink_mac_config: mode=phy/sgmii/Unknown/Unknown adv=00,00000000,000066ef pause=10 link=0 an=1
[    1.827683] mvpp2 f4000000.ethernet eth2: phy link down sgmii/1Gbps/Half
[    6.002304] mvpp2 f4000000.ethernet eth2: phy link up sgmii/1Gbps/Full
[    6.002313] mvpp2 f4000000.ethernet eth2: phylink_mac_config: mode=phy/sgmii/1Gbps/Full adv=00,00000000,00000000 pause=0f link=1 an=0
[    6.002332] mvpp2 f4000000.ethernet eth2: Link is Up - 1Gbps/Full - flow control rx/tx
[   33.186689] mvpp2 f2000000.ethernet eth0: PHY [f212a600.mdio-mii:00] driver [mv88x3310]
[   33.194739] mvpp2 f2000000.ethernet eth0: phy: setting supported 00,00008000,0000706f advertising 00,00008000,0000706f
[   33.218029] mvpp2 f2000000.ethernet eth0: configuring for phy/10gbase-kr link mode
[   33.225637] mvpp2 f2000000.ethernet eth0: phylink_mac_config: mode=phy/10gbase-kr/Unknown/Unknown adv=00,00008000,0000706f pause=10 link=0 an=1
[   33.241341] mvpp2 f2000000.ethernet eth0: phy link down 10gbase-kr/Unknown/Unknown
[   35.362160] mvpp2 f2000000.ethernet eth0: phy link up 10gbase-kr/10Gbps/Full
[   35.369243] mvpp2 f2000000.ethernet eth0: phylink_mac_config: mode=phy/10gbase-kr/10Gbps/Full adv=00,00000000,00000000 pause=00 link=1 an=0
[   35.381836] mvpp2 f2000000.ethernet eth0: Link is Up - 10Gbps/Full - flow control off


And then do a soft reboot to net-next which works.
By rebooting the board multiple times it works, until I unplug the power.

Any hint?
Bye,

-- 
Matteo Croce
per aspera ad upstream

