Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A72CB6A4479
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 15:34:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbjB0Oec (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 09:34:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjB0Oea (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 09:34:30 -0500
Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45EEBE399;
        Mon, 27 Feb 2023 06:34:27 -0800 (PST)
Received: from [141.14.220.45] (g45.guest.molgen.mpg.de [141.14.220.45])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id C090B61CC40F9;
        Mon, 27 Feb 2023 15:34:25 +0100 (CET)
Message-ID: <939a51b6-25f7-2cb1-d86e-0bcead931876@molgen.mpg.de>
Date:   Mon, 27 Feb 2023 15:34:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Content-Language: en-US
To:     Gregory Greenman <gregory.greenman@intel.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
Subject: What to do about warnings: `WRT: Overriding region id X`
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Linux folks,


On a Dell Precision 3540, BIOS 1.23.0 12/19/2022, with Debian 
sid/unstable, Linux 6.1.12 logs the warnings below.

```
$ lspci -nn -s 00:14.3 -kv
00:14.3 Network controller [0280]: Intel Corporation Cannon Point-LP 
CNVi [Wireless-AC] [8086:9df0] (rev 30)
	DeviceName: Onboard - Ethernet
	Subsystem: Intel Corporation Cannon Point-LP CNVi [Wireless-AC] [8086:4030]
	Flags: bus master, fast devsel, latency 0, IRQ 16, IOMMU group 6
	Memory at ec43c000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: <access denied>
	Kernel driver in use: iwlwifi
	Kernel modules: iwlwifi
```

```
$ dmesg
[…]
[   20.753295] iwlwifi 0000:00:14.3: firmware: direct-loading firmware 
iwlwifi-9000-pu-b0-jf-b0-46.ucode
[   20.753313] iwlwifi 0000:00:14.3: WRT: Overriding region id 0
[   20.753314] iwlwifi 0000:00:14.3: WRT: Overriding region id 1
[   20.753315] iwlwifi 0000:00:14.3: WRT: Overriding region id 2
[   20.753316] iwlwifi 0000:00:14.3: WRT: Overriding region id 3
[   20.753317] iwlwifi 0000:00:14.3: WRT: Overriding region id 4
[   20.753318] iwlwifi 0000:00:14.3: WRT: Overriding region id 6
[   20.753319] iwlwifi 0000:00:14.3: WRT: Overriding region id 8
[   20.753320] iwlwifi 0000:00:14.3: WRT: Overriding region id 9
[   20.753320] iwlwifi 0000:00:14.3: WRT: Overriding region id 10
[   20.753321] iwlwifi 0000:00:14.3: WRT: Overriding region id 11
[   20.753322] iwlwifi 0000:00:14.3: WRT: Overriding region id 15
[   20.753323] iwlwifi 0000:00:14.3: WRT: Overriding region id 16
[   20.753324] iwlwifi 0000:00:14.3: WRT: Overriding region id 18
[   20.753325] iwlwifi 0000:00:14.3: WRT: Overriding region id 19
[   20.753326] iwlwifi 0000:00:14.3: WRT: Overriding region id 20
[   20.753326] iwlwifi 0000:00:14.3: WRT: Overriding region id 21
[   20.753327] iwlwifi 0000:00:14.3: WRT: Overriding region id 28
[   20.753642] iwlwifi 0000:00:14.3: firmware: failed to load 
iwl-debug-yoyo.bin (-2)
[   20.753643] firmware_class: See https://wiki.debian.org/Firmware for 
information about missing firmware
[   20.753651] iwlwifi 0000:00:14.3: firmware: failed to load 
iwl-debug-yoyo.bin (-2)
[   20.753653] iwlwifi 0000:00:14.3: loaded firmware version 
46.6b541b68.0 9000-pu-b0-jf-b0-46.ucode op_mode iwlmvm
[…]
```

What can a user do about these warnings?


Kind regards,

Paul
