Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13C92647048
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 13:59:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbiLHM7n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 07:59:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbiLHM7l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 07:59:41 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 593BB81383;
        Thu,  8 Dec 2022 04:59:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1670504378; x=1702040378;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=+mdgGveD5F8/TOIbQl7PQKtjdVw3MnrmVuzHSyLSyiY=;
  b=am29KiO9f9J6T25v83EY0kvUezhiEzeAR7Q1wY1gwqMNP396Vncl8hwf
   iVGmFfyRkJp+wKNxj09Lf039yvAeRr1fD+2e+8FeXy+cgU44/JSwrH8Yc
   TrGkgyIlioVwjO3u7Bd9+5v/msvWII3nyKnGJmqb/Rm7xKKiT+y/+qKLV
   aP6eOnQCDkOkdWMP8HgEdQrkgVTx8gV1kwkvwdMQTJJfedV+U9ccdqzAI
   m8k3JhlNPwKwkralP2XnkcW2Kv600jnWk4oD41/uD6jnnaej+NEBDSp6G
   g2kENcBnF5VCEE+Gwp96ljFU3dwhw4M8GzWzvwWzEkAGW0V03dHhLENkY
   g==;
X-IronPort-AV: E=Sophos;i="5.96,227,1665471600"; 
   d="scan'208";a="192222046"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Dec 2022 05:59:37 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Thu, 8 Dec 2022 05:59:37 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2507.12 via Frontend
 Transport; Thu, 8 Dec 2022 05:59:37 -0700
Date:   Thu, 8 Dec 2022 14:04:44 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Michael Walle <michael@walle.cc>
CC:     <Steen.Hegelund@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <daniel.machon@microchip.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>,
        <lars.povlsen@microchip.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <olteanv@gmail.com>, <pabeni@redhat.com>,
        <richardcochran@gmail.com>
Subject: Re: [PATCH net-next v3 4/4] net: lan966x: Add ptp trap rules
Message-ID: <20221208130444.xshazhpg4e2utvjs@soft-dev3-1>
References: <20221203104348.1749811-5-horatiu.vultur@microchip.com>
 <20221208092511.4122746-1-michael@walle.cc>
 <c8b2ef73330c7bc5d823997dd1c8bf09@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <c8b2ef73330c7bc5d823997dd1c8bf09@walle.cc>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 12/08/2022 10:27, Michael Walle wrote:
> 
> Am 2022-12-08 10:25, schrieb Michael Walle:
> > Hi Horatiu,

Hi Michael,

> > 
> > > Currently lan966x, doesn't allow to run PTP over interfaces that are
> > > part of the bridge. The reason is when the lan966x was receiving a
> > > PTP frame (regardless if L2/IPv4/IPv6) the HW it would flood this
> > > frame.
> > > Now that it is possible to add VCAP rules to the HW, such to trap
> > > these
> > > frames to the CPU, it is possible to run PTP also over interfaces that
> > > are part of the bridge.
> > 
> > This gives me:
> > 
> > # /etc/init.d/S65ptp4l start
> > Starting linuxptp daemon: OK
> > [   44.136870] vcap_val_rule:1678: keyset was not updated: -22
> > [   44.140196] vcap_val_rule:1678: keyset was not updated: -22
> > #
> > 
> > # ptp4l -v
> > 3.1.1
> > # uname -a
> > Linux buildroot 6.1.0-rc8-next-20221208+ #924 SMP Thu Dec  8 10:08:58
> > CET 2022 armv7l GNU/Linux
> > 
> > I don't know whats going on, but I'm happy to help with debugging with
> > some
> > guidance.
> 
> Oh, and linuxptp is running on eth0, no bridges are set up. linuxptp
> is started with "/usr/sbin/ptp4l -f /etc/linuxptp.cfg"
> 
> # cat /etc/linuxptp.cfg
> # LinuxPTP configuration file for synchronizing the system clock to
> # a remote PTP master in slave-only mode.
> #
> # By default synchronize time in slave-only mode using UDP and hardware
> time
> # stamps on eth0. If the difference to master is >1.0 second correct by
> # stepping the clock instead of adjusting the frequency.
> #
> # If you change the configuration don't forget to update the phc2sys
> # parameters accordingly in linuxptp-system-clock.service (systemd)
> # or the linuxptp SysV init script.
> 
> [global]
> slaveOnly               1
> delay_mechanism         Auto
> network_transport       UDPv4
> time_stamping           hardware
> step_threshold          1.0
> 
> [eth0]

Thanks for trying this!

The issue is because you have not enabled the TCAM lookups per
port. They can be enabled using this commands:

tc qdisc add dev eth0 clsact
tc filter add dev eth0 ingress prio 5 handle 5 matchall skip_sw action goto chain 8000000

This will enable the lookup and then you should be able to start again
the ptp4l. Sorry for not mention this, at least I should have written it
somewhere that this is required.

I was not sure if lan966x should or not enable tcam lookups
automatically when a ptp trap action is added. I am open to suggestion
here.

> 
> -michael

-- 
/Horatiu
