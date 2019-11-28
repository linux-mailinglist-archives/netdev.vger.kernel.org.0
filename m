Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8268910C31E
	for <lists+netdev@lfdr.de>; Thu, 28 Nov 2019 05:01:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727389AbfK1EAa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 23:00:30 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:46441 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727113AbfK1EA3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 23:00:29 -0500
Received: by mail-wr1-f67.google.com with SMTP id z7so25865956wrl.13
        for <netdev@vger.kernel.org>; Wed, 27 Nov 2019 20:00:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=E5OSlJLSJ8MiAGb6VpBDjS91A2dQ5e+r96wJOjrxQzE=;
        b=m4i98IaT1rikknt3ueQP4PdDZ7FOoeT6WT0H68pFx2JBzmpnZZb+VEhBN9DePnBEBt
         fdW+Vox3heD/gZ5MOe9JvgCNnsWDZLVgQoKrz5fU9J5irG8D1mekbmtNnSnUgUEplFaU
         t0JMN3FwTtnKdzCi55iPId8z6G5dJcEdIBNrkA3mSpmDbd+j7x5hOtemMpzadm3Ehlv0
         munUfJh+Or6xIJFcqqmdo7sWZqK7p8Swr4bcoN1S0YSwpZyua6qj2wT67SbP9TUNNg2a
         ho0D5FB3q1tnut5zNho7kMrq33AxmZaOb+bCfBxJfCPTPY74AmP2zz/4WNyopsdRj0dX
         PFuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=E5OSlJLSJ8MiAGb6VpBDjS91A2dQ5e+r96wJOjrxQzE=;
        b=Es+97WXLV2fNthdWm8ahEidA0jZ0+BJMuXILz+yp4NWaLUpNkWe5WrWxV7IJUIgBtd
         J4j0qOT768nZ9jnha3utjqee09WgAlvPJS/aimQgP4GVU11yhXEXkGaKda5iLBPlK3Sy
         bEwp0rRNChox+U/TEnSihOXDbVsgKEeCYyd1zIAXtbDofqEbRciVuB2ss8r0cNMbWtd6
         k5lokCqlx0kFPszsaIB82hOcvN9wjsbdrUlgwpVbowKT0WZINO3lCWNNIKXUI4iK/9lR
         CYOj5u/avmwAfmd0cUSFCu2L3u/Ze83d/MOeHCgIVAIkTVVXE6a0SnTuPPIhLPtxYHiH
         y37Q==
X-Gm-Message-State: APjAAAWZc7yA6YdU1zQ7s56rFlY2Z4fAiv6jq6S6KeEeFuCFRjw6Chr8
        Dw5MW+IQWfqu+8kvQjm29d8=
X-Google-Smtp-Source: APXvYqzQIQ8M3lBbibf2nY4Cb13/od/pHXAnurPVIyDLjFLGW2d0UYknlr7Ccw/nJQwkJQyMzFir3w==
X-Received: by 2002:adf:de0a:: with SMTP id b10mr46082870wrm.268.1574913626496;
        Wed, 27 Nov 2019 20:00:26 -0800 (PST)
Received: from [10.230.31.140] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id n10sm3104053wrt.14.2019.11.27.20.00.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Nov 2019 20:00:25 -0800 (PST)
Subject: Re: [PATCH net] net: mscc: ocelot: unregister the PTP clock on deinit
To:     Vladimir Oltean <olteanv@gmail.com>, davem@davemloft.net,
        richardcochran@gmail.com
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, xiaoliang.yang_1@nxp.com,
        yangbo.lu@nxp.com, netdev@vger.kernel.org,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        Vladimir Oltean <vladimir.oltean@nxp.com>
References: <20191128015636.26961-1-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 a9BQwACgnzGuH1BVeT2J0Ra+ZYgkx7DaPR0=
Message-ID: <a4282b8e-e12a-21f3-e97b-cc4620339c69@gmail.com>
Date:   Wed, 27 Nov 2019 20:00:22 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191128015636.26961-1-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/27/2019 5:56 PM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Currently a switch driver deinit frees the regmaps, but the PTP clock is
> still out there, available to user space via /dev/ptpN. Any PTP
> operation is a ticking time bomb, since it will attempt to use the freed
> regmaps and thus trigger kernel panics:
> 
> [    4.291746] fsl_enetc 0000:00:00.2 eth1: error -22 setting up slave phy
> [    4.291871] mscc_felix 0000:00:00.5: Failed to register DSA switch: -22
> [    4.308666] mscc_felix: probe of 0000:00:00.5 failed with error -22
> [    6.358270] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000088
> [    6.367090] Mem abort info:
> [    6.369888]   ESR = 0x96000046
> [    6.369891]   EC = 0x25: DABT (current EL), IL = 32 bits
> [    6.369892]   SET = 0, FnV = 0
> [    6.369894]   EA = 0, S1PTW = 0
> [    6.369895] Data abort info:
> [    6.369897]   ISV = 0, ISS = 0x00000046
> [    6.369899]   CM = 0, WnR = 1
> [    6.369902] user pgtable: 4k pages, 48-bit VAs, pgdp=00000020d58c7000
> [    6.369904] [0000000000000088] pgd=00000020d5912003, pud=00000020d5915003, pmd=0000000000000000
> [    6.369914] Internal error: Oops: 96000046 [#1] PREEMPT SMP
> [    6.420443] Modules linked in:
> [    6.423506] CPU: 1 PID: 262 Comm: phc_ctl Not tainted 5.4.0-03625-gb7b2a5dadd7f #204
> [    6.431273] Hardware name: LS1028A RDB Board (DT)
> [    6.435989] pstate: 40000085 (nZcv daIf -PAN -UAO)
> [    6.440802] pc : css_release+0x24/0x58
> [    6.444561] lr : regmap_read+0x40/0x78
> [    6.448316] sp : ffff800010513cc0
> [    6.451636] x29: ffff800010513cc0 x28: ffff002055873040
> [    6.456963] x27: 0000000000000000 x26: 0000000000000000
> [    6.462289] x25: 0000000000000000 x24: 0000000000000000
> [    6.467617] x23: 0000000000000000 x22: 0000000000000080
> [    6.472944] x21: ffff800010513d44 x20: 0000000000000080
> [    6.478270] x19: 0000000000000000 x18: 0000000000000000
> [    6.483596] x17: 0000000000000000 x16: 0000000000000000
> [    6.488921] x15: 0000000000000000 x14: 0000000000000000
> [    6.494247] x13: 0000000000000000 x12: 0000000000000000
> [    6.499573] x11: 0000000000000000 x10: 0000000000000000
> [    6.504899] x9 : 0000000000000000 x8 : 0000000000000000
> [    6.510225] x7 : 0000000000000000 x6 : ffff800010513cf0
> [    6.515550] x5 : 0000000000000000 x4 : 0000000fffffffe0
> [    6.520876] x3 : 0000000000000088 x2 : ffff800010513d44
> [    6.526202] x1 : ffffcada668ea000 x0 : ffffcada64d8b0c0
> [    6.531528] Call trace:
> [    6.533977]  css_release+0x24/0x58
> [    6.537385]  regmap_read+0x40/0x78
> [    6.540795]  __ocelot_read_ix+0x6c/0xa0
> [    6.544641]  ocelot_ptp_gettime64+0x4c/0x110
> [    6.548921]  ptp_clock_gettime+0x4c/0x58
> [    6.552853]  pc_clock_gettime+0x5c/0xa8
> [    6.556699]  __arm64_sys_clock_gettime+0x68/0xc8
> [    6.561331]  el0_svc_common.constprop.2+0x7c/0x178
> [    6.566133]  el0_svc_handler+0x34/0xa0
> [    6.569891]  el0_sync_handler+0x114/0x1d0
> [    6.573908]  el0_sync+0x140/0x180
> [    6.577232] Code: d503201f b00119a1 91022263 b27b7be4 (f9004663)
> [    6.583349] ---[ end trace d196b9b14cdae2da ]---
> [    6.587977] Kernel panic - not syncing: Fatal exception
> [    6.593216] SMP: stopping secondary CPUs
> [    6.597151] Kernel Offset: 0x4ada54400000 from 0xffff800010000000
> [    6.603261] PHYS_OFFSET: 0xffffd0a7c0000000
> [    6.607454] CPU features: 0x10002,21806008
> [    6.611558] Memory Limit: none
> [    6.614620] Rebooting in 3 seconds..
> 
> Fixes: 4e3b0468e6d7 ("net: mscc: PTP Hardware Clock (PHC) support")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

Tag valid for either this version or Yangbo's suggestion.
-- 
Florian
