Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C4BD3663A3
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 04:29:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234671AbhDUCaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 22:30:22 -0400
Received: from mail-dm6nam10on2077.outbound.protection.outlook.com ([40.107.93.77]:16609
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234641AbhDUCaV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Apr 2021 22:30:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XqYxTUG51Q4VCs23xk0ovRlNmZeI7yo0HWW+Pde7gnOtv2nyqZdmCCXuk7D9rPv31L+/xtx+6nf71NExGOISqS3S0DWnwOrJViPTzwzn1o9WkkZTlAbMxMX85kRuq3SxOj3VNQJYqCMlkYtYcS5GpOLTDG4J0er0ap3i5ShF/qLfejS80p+mkHHCwyx158kYsURRFVM2L95p1aeHt7JJMHoA70ngGLuqkQZQVHypCUu956wZcKyViW7rERws8K17FI5U4Ea1vohbNrVfP7fyJKPi67ViJGgDU2h1i4HC+zn0RLrcV+NBptZQgeR5tpYgG3sfOaPIGB0Ch4K6pM8+kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DTK0PJHmUJN9GfwTnv6XVP6CeypvZ6t/uRhCf+NkZm8=;
 b=S51jtWtC+1+irk6inN4UdiQ2zcVKeaAooLjUnOcOgoR5vJ9UwHfuO7XfzXRiXLx2c0Y7mY2lcwSRth8291Dcdo+/GnfG0hvr4cj1n65ryAyZhk3jISGsOY1ugCbK+vFv6P74QnwG+K+k4il8PZBHzvoabNeZHPx4O2yGaa62jpX/7g9IPsQOEF3vQTrdJD570m+kWqwEA/7fhtCqYygKE73Yj0IbOsRneOFMqcwpkf/3wf7wq5p4cEfs9OPUHUSn2Gr0nXUWR6hw9FcDzz0hx0GiInfN6/+2WdaPHrb6EDlOomqsn9Mc4ijAboFkKlL96H9Lcd8dHgE5Ol7iO/oNwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DTK0PJHmUJN9GfwTnv6XVP6CeypvZ6t/uRhCf+NkZm8=;
 b=Es9GWbpkpwJiX++XESplFe/n43wUOHi+kFhMv8GqfxCAj9CWA0JzAyqg22eBqt4etcpyzYzMYobEBdH0nKlblEKQMf6vV0FVBfKe7rQtOcoN6Z8KTuF0/vkVMBs10jnhu7pA7+L52bHsuaxb+DG6zOapYNp851WaiCHF66eN/3M=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from DM6PR11MB3419.namprd11.prod.outlook.com (2603:10b6:5:6f::32) by
 DM6PR11MB3593.namprd11.prod.outlook.com (2603:10b6:5:138::27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4042.16; Wed, 21 Apr 2021 02:29:47 +0000
Received: from DM6PR11MB3419.namprd11.prod.outlook.com
 ([fe80::5d18:2208:ab30:d880]) by DM6PR11MB3419.namprd11.prod.outlook.com
 ([fe80::5d18:2208:ab30:d880%5]) with mapi id 15.20.4042.024; Wed, 21 Apr 2021
 02:29:47 +0000
Subject: Re: [PATCH] ice: set the value of global config lock timeout longer
To:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "Venkataramanan, Anirudh" <anirudh.venkataramanan@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20210419093106.6487-1-liwei.song@windriver.com>
 <7d85412de58342e4469efdfdc6196925ce770993.camel@intel.com>
From:   Liwei Song <liwei.song@windriver.com>
Message-ID: <fca32ba9-ad20-0994-de7c-b3bf8425a07b@windriver.com>
Date:   Wed, 21 Apr 2021 10:29:37 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <7d85412de58342e4469efdfdc6196925ce770993.camel@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [60.247.85.82]
X-ClientProxiedBy: HK2PR02CA0129.apcprd02.prod.outlook.com
 (2603:1096:202:16::13) To DM6PR11MB3419.namprd11.prod.outlook.com
 (2603:10b6:5:6f::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [128.224.162.157] (60.247.85.82) by HK2PR02CA0129.apcprd02.prod.outlook.com (2603:1096:202:16::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21 via Frontend Transport; Wed, 21 Apr 2021 02:29:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0245b1fc-060b-45b5-bea9-08d9046d54e5
X-MS-TrafficTypeDiagnostic: DM6PR11MB3593:
X-Microsoft-Antispam-PRVS: <DM6PR11MB3593F69950CA125EF02B6E459E479@DM6PR11MB3593.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2276;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gYcBlG1iZEk0avQiIB0Ib7SRHCSIuAh2UOOJn83AFxkX+25uPwMEV8UXIAGZu4OC/hkYHbW4QdP7F6FiB11QsxlP+qqZ5G+daCxxXklfyw8ApTDxgupAkT/LvbFBZ4bBPq8m8zXMuB0RXbIS00ar0QhflcaE1wBPgQwYLn0Tb+R9/UdD/oWupyjSKXr9FOAmxoRumxo81Y0zIsbXracQjeodKFmEeLhiKyu1JYn3UJil7KCGfw/lTQbdkC7BGeCq6Q1xyFIZvpcVtSIjb8DvqmQHpijsKiGnUAzPSnIeunTTTNcKNTwGOl+JJqkh/jJ8QapLG72vsFI9HUXWny1OO0Fko/4XqhGTV1GWELa4PIRlTLALGxy/2PcA4mxHWDrlYAS7TiGStbqJqOfM0D2JBlblqt+GCUuTCopr2rS0oAd3Ce97zp7+4ljvuO2CGfR+PQWoRQlInmtVmAeyyU2DUDQZgYkRPt7Cat6jfUWhqoz8Osqu7bod/pKVK4Kwx2CQcCnZp+NprMPrHt4ZFBVcLTNQ57DKu+H9ZbSQH13Ndkr+lQ+N3TyyJR+LQICqcKydXddxJjvrhkkKL04SRT8QhZZZByalzXlJOvMyXWWwOKycFRa5n0ZMxLK0X8mXvbtdWV1jXaXgJJAoybjJuCMHkXluvZdoYQ46Qwz8G0QXI6zCgZIxAWDwc2byNSyYzoNRFsPdv4pWvSQLAfUCOpIs8YsUC2Zxj3msPbYKZmJ/Imu3h/hGYorBp3CxnuQ8Xu0d/Hh+VgxobkvuUZkeohJFVw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3419.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(136003)(366004)(39850400004)(396003)(478600001)(4326008)(26005)(66476007)(54906003)(16526019)(186003)(36756003)(956004)(38100700002)(38350700002)(6486002)(8676002)(8936002)(16576012)(2616005)(6666004)(110136005)(6706004)(31696002)(53546011)(44832011)(316002)(5660300002)(66946007)(83380400001)(86362001)(31686004)(52116002)(2906002)(66556008)(148743002)(78286007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?VkFzUzZZeHZiY1NvM08zdmduVml1ZFBwdjZVeDBrOWRmUkFGZ0N6RFlaK0pm?=
 =?utf-8?B?eUpZRktDb1MxMHFYUGFDRGdJYmxPY2tobTk3ZGRPWmcxczIzSW81Q29SREhk?=
 =?utf-8?B?czA1VEJNRXVrcTlQZFEvOEhrRWRabWhGSlpvRTZBc0hJczhMeXpKL3lMY1ox?=
 =?utf-8?B?cVJoUTl2eENubnNWL1RvWTdQQXFqczZ3UE1rZ0NyUVVKejZrRU44NHRjVHhE?=
 =?utf-8?B?QkMreXJlOXJTeWdpQURySVJpcVF3UE5ybFByRGNjeHpVMHY2SG1TTkJyUVdG?=
 =?utf-8?B?MWM4Sk51MU1zTC9WLytxUmxKanZBcEZTM081QW5ZM04zbUE4UmMyTGhpRlNV?=
 =?utf-8?B?dWVKd0JsS3o4eXFYcjUwb3BsSUgrUklKWVVSWWZGSXBWYmVjRlNOdENJS3Vm?=
 =?utf-8?B?SmNrOHdwMjJMNE1lcVFiUGdWbC8xckpXZTNYOFFkdDlZREZJM2ZtQ3Q2a2tj?=
 =?utf-8?B?M1ByVFVwTUtuM3lPcE9YNTZHZmtHa0FBRXNyOHlyR28ybzRrM290TDJWeXI4?=
 =?utf-8?B?VDhMczNjcXlIU1VNWGE2YjFDTmd2c1JmVFZrZkhpdHZhTVhPSDdCSGxFZnho?=
 =?utf-8?B?MnFNd2Q2bmV2Y1pvQ0REY0Q2SlhhRFd2NTNIUGxmRlRKWlB6WW1YUWNEd0V2?=
 =?utf-8?B?Ry9OeFNIVWRiTnJsYUZhdWk4SjhObENtL2dZb0xRcitpK2s5QlptalBqUDkz?=
 =?utf-8?B?TGdNeDVUdndYcXpHMWo1Tnp3SE56NTg3cmY0S2VlK3BoMHFycTArczN2SlMw?=
 =?utf-8?B?OVdHeXpnWjFvdmNndy9lYXNTVlFwb1drZ0Zob1BXWnZUOWFxSGRESEx5czh3?=
 =?utf-8?B?OTNBZGZ5R1NQdjRPRk9iTVpUZnFaZzNCeGlaWVdYMTQ2RzVoMUptMWxVR3Vx?=
 =?utf-8?B?cm45ZGRGQnBpTnBqMHU3MVhQeTRwUlpLeXdFakxxR045alRoc0lTelRlYnpO?=
 =?utf-8?B?MDhXSDkxR3YwK1JEK1c5Nm1HS0VHUktLdmswK3BmMDhPRjZydjAzMERWWnJw?=
 =?utf-8?B?WlJ1Mmp4aVd5bkgyZUtvL0xBVFJHc0xuWitjeWViTm9ncWV4RnpFeEd5RUZ3?=
 =?utf-8?B?dEdEMnFYQVF1WXZ0MGFFQUlrN3F3Z0xLRWpTZDc0MFNjMGdsZ2plaUhnbmRr?=
 =?utf-8?B?d3ZCYitZRzgxNjJEY1ArRTNQK0FzVFBQUEQzN3NjWkJGcHRQTXN5Q1o3WkFa?=
 =?utf-8?B?VEhsY0c3R3ZKSUtYR2tIVmJDMUhrOEdRd0tHcXdxMm5HU1hhZFFRUWtZdTBm?=
 =?utf-8?B?QlVIbG1qV3VDZTZQRFJGWWdZbEMzUFlXb2g5R2VJcC9rWlZRNDg4RzJwbUNm?=
 =?utf-8?B?QWMyb1VGQmRoUi81Si9GbUYxZURNMXlRSDYyemxmamhrNjk1eWY2TkVKbFpX?=
 =?utf-8?B?NW5EZUtYbnNEQldwWE9YbVBRMHAvSmhZdDZFUEJvL2xhcFJMTUV3amdqUFJE?=
 =?utf-8?B?NGJHZlpiY01nVWdrR2Y2Y0s4V3NhUTV1RVlUVG1SWUhBUGZzZnNjVzdZQ3k0?=
 =?utf-8?B?TFVQZjJEdW1rTDRPdmhSSmVPbUs0OWhvUmpEYVFQa3ZvUS8vZW9aQUR6SFln?=
 =?utf-8?B?WkhoWGYvQytxM2NMb1B6MUw1SVpuSEJXNkF1c1A4WDZTZVRSZDRnNGlUbThr?=
 =?utf-8?B?VXZsWnIxVGlvVDlROCtrYUt6Z0hLTHZyTjI2QXd1cGdObmdmWmxIK0VXTWps?=
 =?utf-8?B?UUFKL2NuMEthZFZBRVR2aEdXcnhxK3pLSUZGK3dRZ0JuamxxOUZScUxLR0JY?=
 =?utf-8?Q?0KhJuuzWsqgIyERnDu4R0u+Dn3eqv7JvJwWh2fg?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0245b1fc-060b-45b5-bea9-08d9046d54e5
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3419.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2021 02:29:47.3554
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: szKwRnk81bpH5nshmufyIquFmQDFJPE53nckHLTN01THI38MWliEPbPcxSeI0qRJFz7VOIvKW34Cv27RfwXBbZ3jfOkgkPzajoOOkTWHblc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3593
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/21/21 06:48, Nguyen, Anthony L wrote:
> On Mon, 2021-04-19 at 17:31 +0800, Liwei Song wrote:
>> It may need hold Global Config Lock a longer time when download DDP
>> package file, extend the timeout value to 5000ms to ensure that
>> download can be finished before other AQ command got time to run,
>> this will fix the issue below when probe the device, 5000ms is a test
>> value that work with both Backplane and BreakoutCable NVM image:
>>
>> ice 0000:f4:00.0: VSI 12 failed lan queue config, error ICE_ERR_CFG
>> ice 0000:f4:00.0: Failed to delete VSI 12 in FW - error:
>> ICE_ERR_AQ_TIMEOUT
>> ice 0000:f4:00.0: probe failed due to setup PF switch: -12
>> ice: probe of 0000:f4:00.0 failed with error -12
> 
> Hi Liwei,
> 
> We haven't encountered this issue before. Can you provide some more
> info on your setup or how you're coming across this issue?
> 
> Perhaps, lspci output and some more of the dmesg log? We'd like to try
> to reproduce this so we can invesitgate it further.

Hi Tony,

My board is Idaville ICE-D platform, it can be reproduced when
there is no QSFP Transceiver Module setup on it, it is not
happened on each "modprobe ice", about 1/8 rate to got that
error message when I loop run "modprobe -r ice && modprobe ice".
the port type is Backplane, and I haven't reproduce
it with Breakout mode. 

In Backplane mode:
root@intel-x86-64:~# time modprobe ice

real	0m25.990s
user	0m0.000s
sys	0m0.015s


In Breakout mode(don't have that issue)
root@intel-x86-64:~# time modprobe ice

real    0m1.323s
user    0m0.000s
sys     0m0.022s


The whole message when probe ice:

ice: Intel(R) Ethernet Connection E800 Series Linux Driver
ice: Copyright (c) 2018, Intel Corporation.
ice 0000:f4:00.0: The DDP package was successfully loaded: ICE OS Default Package version 1.3.16.0
ice 0000:f4:00.0: VSI 12 failed lan queue config, error ICE_ERR_CFG
ice 0000:f4:00.0: Failed to delete VSI 12 in FW - error: ICE_ERR_AQ_TIMEOUT
ice 0000:f4:00.0: probe failed due to setup PF switch: -12
ice: probe of 0000:f4:00.0 failed with error -12
ice 0000:f4:00.1: The DDP package was successfully loaded: ICE OS Default Package version 1.3.16.0
ice 0000:f4:00.1: DCB is enabled in the hardware, max number of TCs supported on this port are 8
ice 0000:f4:00.1: FW LLDP is disabled, DCBx/LLDP in SW mode.
ice 0000:f4:00.1: Commit DCB Configuration to the hardware
ice 0000:f4:00.1: 2.000 Gb/s available PCIe bandwidth (2.5 GT/s x1 link)
ice 0000:f4:00.2: DDP package already present on device: ICE OS Default Package version 1.3.16.0
ice 0000:f4:00.2: DCB is enabled in the hardware, max number of TCs supported on this port are 8
ice 0000:f4:00.2: FW LLDP is disabled, DCBx/LLDP in SW mode.
ice 0000:f4:00.2: Commit DCB Configuration to the hardware
ice 0000:f4:00.2: 2.000 Gb/s available PCIe bandwidth (2.5 GT/s x1 link)
ice 0000:f4:00.3: DDP package already present on device: ICE OS Default Package version 1.3.16.0
ice 0000:f4:00.3: DCB is enabled in the hardware, max number of TCs supported on this port are 8
ice 0000:f4:00.3: FW LLDP is disabled, DCBx/LLDP in SW mode.
ice 0000:f4:00.3: Commit DCB Configuration to the hardware
ice 0000:f4:00.3: 2.000 Gb/s available PCIe bandwidth (2.5 GT/s x1 link)



lspci:

f4:00.0 Ethernet controller [0200]: Intel Corporation Device [8086:124c]
	Subsystem: Intel Corporation Device [8086:0000]
	Flags: bus master, fast devsel, latency 0, IRQ 16, NUMA node 0
	Memory at 22ff0000000 (64-bit, prefetchable) [size=128M]
	Memory at 22ffc030000 (64-bit, prefetchable) [size=64K]
	Expansion ROM at d8000000 [disabled] [size=1M]
	Capabilities: [40] Power Management version 3
	Capabilities: [50] MSI: Enable- Count=1/1 Maskable+ 64bit+
	Capabilities: [70] MSI-X: Enable+ Count=512 Masked-
	Capabilities: [a0] Express Endpoint, MSI 00
	Capabilities: [e0] Vital Product Data
	Capabilities: [100] Advanced Error Reporting
	Capabilities: [148] Alternative Routing-ID Interpretation (ARI)
	Capabilities: [160] Single Root I/O Virtualization (SR-IOV)
	Capabilities: [1a0] Transaction Processing Hints
	Capabilities: [1b0] Access Control Services
	Kernel driver in use: ice
	Kernel modules: ice


ethtool info:

root@intel-x86-64:~# ethtool eth1
Settings for eth1:
	Supported ports: [ ]
	Supported link modes:   1000baseKX/Full 
	                        10000baseKR/Full 
	Supported pause frame use: Symmetric
	Supports auto-negotiation: Yes
	Supported FEC modes: None
	Advertised link modes:  1000baseKX/Full 
	                        10000baseKR/Full 
	Advertised pause frame use: No
	Advertised auto-negotiation: Yes
	Advertised FEC modes: None
	Speed: Unknown!
	Duplex: Unknown! (255)
	Port: Other
	PHYAD: 0
	Transceiver: internal
	Auto-negotiation: off
	Supports Wake-on: g
	Wake-on: d
	Current message level: 0x00000007 (7)
			       drv probe link
	Link detected: no


root@intel-x86-64:~# ethtool -i eth1
driver: ice
version: 5.12.0-rc5+
firmware-version: 1.24 0x80005e12 1.2817.0
expansion-rom-version: 
bus-info: 0000:f4:00.0
supports-statistics: yes
supports-test: yes
supports-eeprom-access: yes
supports-register-dump: yes
supports-priv-flags: yes

Thanks,
Liwei.

> 
> Thanks,
> Tony
> 
>> Signed-off-by: Liwei Song <liwei.song@windriver.com>
>> ---
>>  drivers/net/ethernet/intel/ice/ice_type.h | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/ethernet/intel/ice/ice_type.h
>> b/drivers/net/ethernet/intel/ice/ice_type.h
>> index 266036b7a49a..8a90c47e337d 100644
>> --- a/drivers/net/ethernet/intel/ice/ice_type.h
>> +++ b/drivers/net/ethernet/intel/ice/ice_type.h
>> @@ -63,7 +63,7 @@ enum ice_aq_res_ids {
>>  /* FW update timeout definitions are in milliseconds */
>>  #define ICE_NVM_TIMEOUT			180000
>>  #define ICE_CHANGE_LOCK_TIMEOUT		1000
>> -#define ICE_GLOBAL_CFG_LOCK_TIMEOUT	3000
>> +#define ICE_GLOBAL_CFG_LOCK_TIMEOUT	5000
>>  
>>  enum ice_aq_res_access_type {
>>  	ICE_RES_READ = 1,
