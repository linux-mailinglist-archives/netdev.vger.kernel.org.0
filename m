Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91EF74775B9
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 16:20:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238422AbhLPPUd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 10:20:33 -0500
Received: from mail-am6eur05on2106.outbound.protection.outlook.com ([40.107.22.106]:30433
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233101AbhLPPUd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Dec 2021 10:20:33 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LM3MLkOmKmYLxOKTPva9PSyVsPGvZko80fSjrGl4gV5wKqXcc96g0s0XZUCkFrjJqQkQ2xdRGI4NhENOM9s3LCoXgL08OHHkxoKSOqA1BkYjx9eNnHxL8POCf4DZlc3wm+cZRZhnhyAgGKj6WJaflMUvyDPcMvTQujy7eQAUqKOrGuTVVNctxBp1Tjwvf30sjSeTCeyVW509yh6MlkFrwUuuuhT4nc6hayXcF2ofO5Aujb/9pZ2kAM1MNDa4my5Z9TtPVx5ko/3mt9JjOVf5zqBcn5GMe/sDc56WNZolR0tYjrswqGGAS9FitRvuqG9MjQrsE7Q0p+DAmofvj974CQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PLBylyuV/OBPmmUEvwhSqjBCSUnhVgs1ek1yHsKk7Ic=;
 b=UFu7/vNBTssS9T8vLNDm2CjUEiRv/5asorSGqSSzYv/5fp1nZIAzCxx5MqT8n/Cei0GMcIOfYt33ahkKT9QAX7BBw6Qj+5sucdBgBAftt8LhMBotQyzJVQhAt7XLb9BTEtxfG8BgEc9S25Dn9O0h2fkmW8rGXHl85V12BJAOZIse0bQcW0pMoGjjBONz7NKkAj/7Q8B8lxjVN9799B9/cU3PQWMnDPD8CDeBRfyKintobfA0jXgbSKXxHZJLp37Dm6aVfT4sfsX7Fews5RgbzYrt9LIP6sV6hzDJMrQw6pOjzkPgh3crUHvgsyxf5o8/w53DV0EsxRR1568KRllGMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=asocscloud.com; dmarc=pass action=none
 header.from=asocscloud.com; dkim=pass header.d=asocscloud.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Asocs.onmicrosoft.com;
 s=selector2-Asocs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PLBylyuV/OBPmmUEvwhSqjBCSUnhVgs1ek1yHsKk7Ic=;
 b=C0QBjDeg6kbKAwEwct15tIt/LxzdobXBREj+fmFNitbsq/K/XGl8v9GUbYqG98K+P24su826/NjTrwJHcTIHkMEBRXuRICOH6CdNcwCnApmJjlvnbnHP6mofCN3KNHd0TNL7wCuZF2tH9v3Xme3siSzOeK6laqWUGo23pVzKttY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=asocscloud.com;
Received: from VE1PR10MB3936.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:800:16a::10)
 by VI1PR1001MB1088.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:800:71::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Thu, 16 Dec
 2021 15:20:24 +0000
Received: from VE1PR10MB3936.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::10cb:2d8a:d80c:8779]) by VE1PR10MB3936.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::10cb:2d8a:d80c:8779%6]) with mapi id 15.20.4778.018; Thu, 16 Dec 2021
 15:20:24 +0000
Message-ID: <dd7b69a4-f509-2712-78e6-53b74519b63d@asocscloud.com>
Date:   Thu, 16 Dec 2021 17:20:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Content-Language: en-US
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Stefan Assmann <sassmann@kpanic.de>
From:   Leonid Bloch <leonidb@asocscloud.com>
Subject: PROBLEM: iavf seems not to fully bind to all the devices all the time
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR02CA0216.eurprd02.prod.outlook.com
 (2603:10a6:20b:28f::23) To VE1PR10MB3936.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:800:16a::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 35cdd4c4-a163-45e3-49c3-08d9c0a794d5
X-MS-TrafficTypeDiagnostic: VI1PR1001MB1088:EE_
X-Microsoft-Antispam-PRVS: <VI1PR1001MB1088D641C207E048067AD1E5CE779@VI1PR1001MB1088.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1D6z+7lcQdbQFp4YhBQ3WF6HF1i9aF1tSuhU1IJw0OBYEz3nDYLN52oOP0AYZlRLGlCS4KF2G/ZqZXpl30l2eqXboFo0gyTjWUT3R3UPg/3MZOrIE2Nfq8sIk/ICuX60Hpo48vn1tXF1fGkN2vYWvU5WBDwd25eeaJI75JopMu5mzxoJCqeUAciQYI2j6c283A+jmv1al3a5uLbDiJRNy3C4LRvp20JJ+UqKhryvwDRJINxofVz/jgigUzT2U1NyG/AOTRBnz76Y49U+3bb3JkDtzpdHxe009FJS1VWKztwxeCkoMFaje2DmeE9JOq2SsKqElorwSTCGHJfj8rzn+EMR8q+T5znSYEqjwT3A5VAeOvWxuEHFWNjYXMSeaTybUzINFOhaPTg3k6rWuqEutvwuCr+wNvkULsHkSWGvk1nJWXXiGwqgc42zBr3hahNVj7yvt9cwW6/cjAjWcHhytXuHlF/BnYtwxGkQodxw//RJJ9kc7gC4s8O+SG/f0y82msbL1+7EEAkTstq6/COg7HJB/EHez+MeP7EXiVj/vadFcdtSqPza7GA3zWDwZWm+bMnTeaC6M5NzrwRX3/9Hqwfz3Pd7gQdXXf15fKndOv2bBFVbYJdQLsLZmnL+wZWpusfB4pXZooJVTncq7NNoQN9O/609zyQkbHmn1aygzCqFP9e8naTlj4erkvRjJIN9KeMq+hwhfVStJuCkQRmhwcjOEpTda9Ev7zzEIl0NhHE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR10MB3936.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(39840400004)(396003)(376002)(346002)(8936002)(31696002)(26005)(38100700002)(316002)(2906002)(6506007)(66476007)(66556008)(4326008)(6486002)(36756003)(110136005)(6666004)(66946007)(2616005)(86362001)(6512007)(5660300002)(508600001)(186003)(8676002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RHh5Tmg2cjJyWkF2TG5lQ0NhS05ITFdUY2g1UElHUHZGRlM1WG5qVVQzem1m?=
 =?utf-8?B?cFVjTnZRTFRUSFpMQUJ2aW5aeVFTdkpONUNLOG9oS3VVdk5DN0NIcVVjRkkz?=
 =?utf-8?B?N1dxVXpBYVBpdW8zQzlDbXcwRy9LL05XcGM5WEZhd29XbDU4THdjMG9SZTFz?=
 =?utf-8?B?SmxlQzJLWmFFVjRHcStkUDRWQnJOenhOMWU3dzBEa3lrK1hicmUvazV2MjQx?=
 =?utf-8?B?cWEzamJoaEo2am9mMWExanhLeVVGSFdWNkI3bHh6TC9wemdhK0hGYWtRNmE1?=
 =?utf-8?B?RFJjZmdVUFIyZEYxL3pVb3g4QkFpVHlET2RNOFhCcmNFVXdYQ2ZJaGt6b0VE?=
 =?utf-8?B?OFpENk5lSFowakt2dTc1Z2QyeGJrelJFMWQ2a0orTVJ0SHB6OTJPL2RydDM1?=
 =?utf-8?B?bktDcnVYVit1NVZhKzdWdndkdHJoWWllbFlkUVYrS2o0bDV0aG1BbFNLa1gx?=
 =?utf-8?B?RXZURlozSEx2NkRLMExGWWlLWHQxdGJnUHJvK1c0WGg4OTBPbXRqdW1aK0tZ?=
 =?utf-8?B?M216Tm9ob3pKRWUrVVFMayt1R1h5aGlmVXJyRitpZ0NwWVVyMVVSekIvbFh0?=
 =?utf-8?B?N0taRjgrSFNZdVREelRnU0RLMW1lbmsrcCsrU2NsUXlNdjJ6TFlZWkR0cW5O?=
 =?utf-8?B?eHlFL0kyellDcUlTWEVyTmo2b05DSWdhcFRIU2cxRk5MUnRIUnU4cUZjdElU?=
 =?utf-8?B?UyttNTBTT3k5WU93QnIrSzcrQ3VkSkNSdWN4TExQeXZUUHZMVmo1bU5BOG9s?=
 =?utf-8?B?VzgyaDdFRW9BLzlqckNUZGJmR3dETTFibXpYalpJK1lVc0ZuTy9aZEg3Rzg2?=
 =?utf-8?B?RGV6Um5iUWJ6cDhqYU1vZGl3Yi9XUk1qZktHRzBOWHAwZlhYYW5QVzV6UTV5?=
 =?utf-8?B?YS8yYzl6VXR1QkxZUnZEMVE0dnk0YWxYRnhFZll5WEtQQ0JtckNENVdjNjAw?=
 =?utf-8?B?MVlPTkpFMmhhOG0zMHVDKzQ4ZG5mOHJaZ2FPWDZOa2YrN3pUbDdyeS9TRkdL?=
 =?utf-8?B?aEhvcVVDK1F2NzdZb29hcWk5cUREbGpLVUZZa1FVUGo3TnpKUnlmbTNTdHhl?=
 =?utf-8?B?bko2RStlNU5BdFRjdGpXMTBUMlNrQ3pPckRFaDQxMlgrbWx6ZUd0NlRyNVRE?=
 =?utf-8?B?NzFkQ1hWRHloSGdkYTJGMUxEWFM3QzdQTmJDTlB1UE9ZSU4rOVVzYzNLT3hs?=
 =?utf-8?B?UlFrcHpHbmttNjdWU25DN0lxNjdmMGd1OVNnL1NHRDN3M1VYVWlRQkpkWEcy?=
 =?utf-8?B?UU9GODNXTEpPMDhkSW4rbjNoTU1sOGQvc3FNV1hmOTZjdzE1UEt1OWtFOWlL?=
 =?utf-8?B?Q0hWa1NyYVgwZzdzbk5kc3pGeXFoYzZGc3oyeTdTeGRabGQrQVNRWTZ2bWVH?=
 =?utf-8?B?U0VKNXI0aFVYcE5ueFlSQUgvbk0wNmN4czV4N1JEOU1RaHdMWmVaejRTTERO?=
 =?utf-8?B?bUc5Zlo2czQ0Q3ZpYXlIWWZ6WmdRZnh0ajAyejkveEM0R0xGQzkwcDFQREFx?=
 =?utf-8?B?N0dtOFFJOFJwM2tTVXRORGc5d1orM1VsMG4zcVNOOE9KZkt4QUdObVdKb2Jv?=
 =?utf-8?B?SFpWSHpLSXNXYTBib0lCMXhIY1l4bEtEYjVEdW9EOEFSVzY3NEVHK2VGYmxQ?=
 =?utf-8?B?ZHBQaWtIZ0hOeHZzSFNaRzVhY0xiOGFmZkRnZ1BaWk1jZkZyNTgrb2J0dk40?=
 =?utf-8?B?VzhvSDIxRDcrdW9CS0NYeUU2ZGYzakxudXJqYytmbXRoMUdNNE5SUUpoNmVv?=
 =?utf-8?B?VE1LTVFMd0VWb3ZqODdyNCt5YTFRSHVUcDNVUzFnVGZIVzZSWSsyVWxiMUYv?=
 =?utf-8?B?OEYvOHY4dTBEeXlPY3p0UlhJb1BnN09TOG1CV2xzVTRMVDlrWmtqMW9tdjhz?=
 =?utf-8?B?bk0vcWRpYXF4N1ZHSU4zby9Oemtyc0c4dTI2V3Rqa0xRQmZNQ2lReU5Sdi9G?=
 =?utf-8?B?d3FSMUZoN3h3QVh0dW1DOHBrc2RLSXVPa2tIVkljY0h6NGpLS01iL2YrbW5s?=
 =?utf-8?B?ZTU2LzRWOThEbFpyVFV2TWlBY2JUZ3hVdU00a1lDZE82RTRTaUxxb01lZ0Fy?=
 =?utf-8?B?RmpxUUQ2WnppK2NSNURPZlZzN1N5R1Z1WVowRWxSWnQ1WEI0MFJDaGxnNWNQ?=
 =?utf-8?B?alYwKzNXeHJlOFlHc09hb05KT0ZuNHZCQmkySlQzUWg0MWlveHZZbndwcUx3?=
 =?utf-8?Q?eLS79+n8Oi+7NN4/lRsO+PI=3D?=
X-OriginatorOrg: asocscloud.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35cdd4c4-a163-45e3-49c3-08d9c0a794d5
X-MS-Exchange-CrossTenant-AuthSource: VE1PR10MB3936.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2021 15:20:24.0515
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 09a71e5b-e130-419f-bde2-1e8422f00aaa
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zn59m/neNanv3StEW7nL1VWiDQa0P+NlBaTnPYLii70q9wN/cZeX1XN30bnyPXp8wVL07NPsi8XZ6SRcdjrFzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR1001MB1088
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I have a VM with 3 Intel VF's attached:

# lspci | grep Ethernet
04:00.0 Ethernet controller: VMware VMXNET3 Ethernet Controller (rev 01)
0b:00.0 Ethernet controller: Intel Corporation Ethernet Virtual Function 
700 Series (rev 04)
13:00.0 Ethernet controller: Intel Corporation Ethernet Virtual Function 
700 Series (rev 04)
1b:00.0 Ethernet controller: Intel Corporation Ethernet Virtual Function 
700 Series (rev 04)

But not on every boot or driver load/unload all the VFs are fully 
initialized (some do not appear as network interfaces):

# ip l | sed '/^[0-9]\+:/! d' | bc <<<"$(wc -l) - 2"
3
# rmmod iavf
# modprobe iavf
# ip l | sed '/^[0-9]\+:/! d' | bc <<<"$(wc -l) - 2"
1
# rmmod iavf
# modprobe iavf
# ip l | sed '/^[0-9]\+:/! d' | bc <<<"$(wc -l) - 2"
3

...etc (the number always varies between 3 - all the interfaces, and 1 - 
only one interface, never 0).

The PCI devices which do not appear as network interfaces however, still 
appear as bound to iavf, but somehow not fully:

When all the interfaces appear:
# lshw | grep iavf
configuration: autonegotiation=off broadcast=yes driver=iavf 
driverversion=5.10.78.rt56-1 duplex=full firmware=N/A latency=64 link=no 
multicast=yes
configuration: autonegotiation=off broadcast=yes driver=iavf 
driverversion=5.10.78.rt56-1 duplex=full firmware=N/A latency=64 link=no 
multicast=yes
configuration: autonegotiation=off broadcast=yes driver=iavf 
driverversion=5.10.78.rt56-1 duplex=full firmware=N/A latency=64 link=no 
multicast=yes

When only 2/3 appear:
# lshw | grep iavf
configuration: autonegotiation=off broadcast=yes driver=iavf 
driverversion=5.10.78.rt56-1 duplex=full firmware=N/A latency=64 link=no 
multicast=yes
configuration: driver=iavf latency=64
configuration: autonegotiation=off broadcast=yes driver=iavf 
driverversion=5.10.78.rt56-1 duplex=full firmware=N/A latency=64 link=no 
multicast=yes

There are no apparent errors in dmesg.

The kernels used: 5.15.7, 5.15.3, 5.15.2, 5.10.78, 5.10.56 (the ones I 
tried so far).

Any suggestions?


Thanks,
Leonid.
