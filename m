Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7179048D494
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 10:49:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233395AbiAMI6z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 03:58:55 -0500
Received: from mail-dm6nam11on2073.outbound.protection.outlook.com ([40.107.223.73]:16221
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233351AbiAMI6O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jan 2022 03:58:14 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UfaoJMFSWHJbC4Dgoq3vfbCdEKaSPs7G+r2X0IfFPkWGnYVVHG7Juy6Niayc7vKL63JjwVbH9SrGNqTTCb/YNBN34gl67DnQ+U4UG+sz9y7gt1FetpaMS+MlbMPJueFccu6oKaTqoduuA8bo4QrCDX73e9UJfw1phb6+n3+vFsRJqYYu9t6Y+y1Ua2aCHTznxIBY2LPgBj398xFSukIbHVvLlSf8b3sh/fDcNFysErksjxKwzKUuNGdEbey9/1CDkgNipVQGMBFlTW0h2tOieihoXZWkf66EFi/rM+c0tZ/oXP9KU9c6myhKT7Rac4NBaCFub8+7JoyKgJf8JwdYuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CraUO1EHQRox2TGQiIRnhpiB+IZaBNVOt3+Jn+Afr2c=;
 b=egiOM84+r9ds1R+BxvznOVmQBAFJBYSZewXT1EhM4pHN3zAMGigTKmqUugf6/DEbHhhq7sijJzPpmBI2xRkTtrJhewBaxgk4ytDL6N9CVwwA/R8rl8HPi8S+AwTwX4GakGpVAdURZtMrI1iHFy/T5eEyUkk3UYUxhhD3l/R0LgnyBChYRkRXk3j6guh9MbO2V+9HC8Ub/USt6zY5L/H8bRs3qZH+agyXmjSHdc++nV7/bIqfkTSjp8XMvbgqX+VmgEjrmP8pYoEqFyxJiXrTdIlTPPE3Mf0l3sU4XkRQDvBVJxuPIgCYGY+IpcbCDevDsc8f/Nx2i+6NRxcbae5r7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CraUO1EHQRox2TGQiIRnhpiB+IZaBNVOt3+Jn+Afr2c=;
 b=g1iPfIEYMOg6zPg/Ap5PWhY7fYcV4uUvnKa1kMQ2Xq4pVTxYfkGnCc/8eGtwigY/i+Ie0I9ZTRV6Ax3UPFmvkN7hlM7N70qbVDCr8d/m+/JE/dt/y08c5DsWYkQCM7LEoZyxPyThT1tSlCutyuf34aCi7MoHW0QOeuT7RUL1ZW0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=silabs.com;
Received: from PH0PR11MB5657.namprd11.prod.outlook.com (2603:10b6:510:ee::19)
 by CY4PR1101MB2071.namprd11.prod.outlook.com (2603:10b6:910:1a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.9; Thu, 13 Jan
 2022 08:56:36 +0000
Received: from PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::d031:da9e:71a:73e4]) by PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::d031:da9e:71a:73e4%5]) with mapi id 15.20.4888.011; Thu, 13 Jan 2022
 08:56:36 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 29/31] staging: wfx: drop legacy compatible values
Date:   Thu, 13 Jan 2022 09:55:22 +0100
Message-Id: <20220113085524.1110708-30-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220113085524.1110708-1-Jerome.Pouiller@silabs.com>
References: <20220113085524.1110708-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: SA0PR11CA0117.namprd11.prod.outlook.com
 (2603:10b6:806:d1::32) To PH0PR11MB5657.namprd11.prod.outlook.com
 (2603:10b6:510:ee::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dafbfa3a-73c7-4008-0fb8-08d9d6729afb
X-MS-TrafficTypeDiagnostic: CY4PR1101MB2071:EE_
X-Microsoft-Antispam-PRVS: <CY4PR1101MB207175C6194121285019A4EA93539@CY4PR1101MB2071.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 78oo6fJbxkc/VtNSaRqmaSRvJ6I0lwMRhdRP4UKXNA/uj3YrNEUe+yHkD2OwxhilKf+mbJmhTQKHg4Dfp4kYJ5rhZ8nsHHx7ydzm5Xr5taYXbwMwBlaizq8ACblVxGKG018/7adce6uvALSJNWYVPAkJZSGOqeidaljHaeGPJy/5N+Pq7sgwZLbSQzxKEYGpfd8L6F39Stx57U/VXF5bcl77gHgHtvOe85f2dDf9EQ7RANvQjw2GvXm9BJv6FLeW9OUfWOBpyVY3CNEQCehgpwrUm6F0x7i5CqMzQgr3jrSIzzxkQXd0ONM+6D1z4E6M1+4vsfWpuVHPT41NIhv6a5/oC2X4rvici2G2wsmpOS/Oo5anC9cTZx80kuN2ZU77qJDxVvX3O96SWu2WtZ59q3pnCdw9LbHCRGwkLMNU8KYO9+1yy046qVfOHbhqxU3qMsyEL3S+B9MO5VIJ8FdcrPFkGKnBEpf+EBk/zixzsRPBxEuvF/Rfr8FdoaKGL/QWPFzxK9axQEfWXNTfmN+HcAGTD3CQvxn2v8Icv2dYPtf+mI+x4uA+dmQKldzdy0L8e3VYACNhL6QF70Kd7ywlxSbRbAU3nvyeNVKqVMi2/d7cAI7Usu0p85bhkMmAFRwq+awpmxqnkUZ+uVpVzQmvAw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2616005)(66476007)(52116002)(8676002)(6486002)(4326008)(38100700002)(8936002)(83380400001)(6506007)(107886003)(66556008)(6666004)(36756003)(508600001)(2906002)(5660300002)(6512007)(1076003)(86362001)(186003)(316002)(66946007)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MHpjaURZL1Ayd25zTXk3ZkppWVdubjlPZi82WklET0p1UnlITlpsRnlFSVg4?=
 =?utf-8?B?dzN3c0ozQXNhenJVR3BYbUN2WlF3aGkxbjdsUTBlYzBiRFNkUFl3V08zYk8y?=
 =?utf-8?B?NnJNUVB3OEk4cnkzbm9nbGZiNTgxQVUrVUloZlNha2s2TmxDMVROOVkwUUdr?=
 =?utf-8?B?ZkRZNjROeW1VVVkwMjlYOTdUSVRNd1hkeXdKVE5sdUQvaGV1WGdEdUQzWHlJ?=
 =?utf-8?B?TXVXNGtRQk5Pd0IwTThzSGNXektiUWtvb1l6OUhEYWtMV2oweTgvQUlqaXBh?=
 =?utf-8?B?bHhpNFc3QnJMZ1lRaVphZzdnMkRtRFd0ZFhzQVJJRXpsbHZIV3k5UTM3UnJX?=
 =?utf-8?B?aSthd0d5N25KQUFOdisxZ0txZzVvcWVlUkpWTUtkWTdpZ3V4bUcrbS9qb3lE?=
 =?utf-8?B?Q0FZOEhvMlBHbnJpeS9pR3UrMGNsM3R0QWs1cWhncFJiR2ZkdXMrcEgxb0lr?=
 =?utf-8?B?WjEraTNSZ3A5YTBsdDJaYkk2a2NWakVKTi9aOVRDczB5N2RIckhrYzNvUHMw?=
 =?utf-8?B?R09IOTYyOEl6YUQ4eFVDMzVKaVNnd1ZiUFNPdU5MSkRCalM2U3RNM1d5STcw?=
 =?utf-8?B?aENya1NYWWl0TjhGNkRRd3o4bnZaUlFVVDZ2cFNsR1h1TW4veUEzQy9pVXRM?=
 =?utf-8?B?YmRQTHZ0NzJDSjY2WlNlQmlRNDREb3FNcGZrMXZsMTVjWE41U2prdmI0ZWtZ?=
 =?utf-8?B?OHJFT3RqMnZuNWVnRnpyek9mdGFJOXMvU09rdnRIYm5xd3piNXpOS05aM3B1?=
 =?utf-8?B?WEFBS3BlRk5JUUJ6c2RzdGFoSFh0OWdaWXZhZkh4ZjBERVRTT0hqNHZLV0Zq?=
 =?utf-8?B?bFZuUDVwcVV5ejRacldNTFhwUytEbi9kNzNDYlpBdElyMEgwYzFhY1lHZG1X?=
 =?utf-8?B?VE9YMjdrL0xUa0lwazc1aWNZb3pDNHl4UTYwSTNzUWtmNFZqVmFLQ3AwTmIy?=
 =?utf-8?B?TmJLcFVXQUhQbmczcU1EcytjSTNDUlplL294b1d3NTJHRTZnL2FBY0RRd0RT?=
 =?utf-8?B?VmJCSjR2VExoMGNPZUgzUVFyS09zYUg4a2VOcGNyVkcrTTQxVU5Fa2Z1YXZs?=
 =?utf-8?B?S05Dai9reWcrdEpQUmJST3FaVFg4R0NVMDE0U3ZVVzU3YVlEWXg4RldsbjZS?=
 =?utf-8?B?OXJTa3FWN25oK2ZBTDhvdnZtYytkRzFZcVlpNTZwcGoycUtmU0dPdmhudjh5?=
 =?utf-8?B?VmQ4cTFUdStkK3lQak5INU5rODJrbEJ0RlRWV0tpN3FFSk9qTzN6Y0VDa3Bs?=
 =?utf-8?B?UlhjbFFGOGhKSEZJaWVRc2I0K1kzdFRIN0hUdGx0M1BmTVY5d0FaZDRQR1Rm?=
 =?utf-8?B?R2h6THZyY08wQzlIR2ZkcWpZNEFIRS80WTFxNjBGMEFxM2ZISEsvNy9qbWZK?=
 =?utf-8?B?UGFhSXlBS0xpOXhXK2JvQzBkNVNLVW16T0tmQ3N5ODhqMVdiaWZsY1BWNzha?=
 =?utf-8?B?V05sczlyY0l3UWxXb2NreDBOR3drQXNkQ0pHMkxQdlhiLzV0TWhlZFVjVFMw?=
 =?utf-8?B?QUYxN01zUzliUmh4Vk5qR21taXczVndWR2hSNGlxQnExd0lpdTBHV1B0MTVi?=
 =?utf-8?B?WkVLTGhtZ3BBTzJWZVFPWGJkY1lVSEkzaXZDRUlLNVo2YmVYQ1NVQjk2NHBZ?=
 =?utf-8?B?RlhueTkyZDBpOWd6ZzNNUTkvdXdGVGNMTEdUWVBDS29YRFBRQWszNll0MGFX?=
 =?utf-8?B?ZnJnM0N1TVFsL0NBTk96L3lGOEgvUHdPbVNGK0FMa2dJNlA5VkowUzArS0Jw?=
 =?utf-8?B?TmJUUG1lRkd2NDJ2ZGRxd3lTNTNXelAySXJJTThxdFZGUnc3NFZuRUlRb09E?=
 =?utf-8?B?NEJZVldjNlF1eE9nVSt4LzdCNUd4ZjFxYVNLK2tmTXU3UFoxRWhjWUN3U2Nl?=
 =?utf-8?B?Vi9Sb25Ca0hHL1ZwMHRrRFhqSElTK1poMWpHYVlCYUk1NE9SeVpBVHROSjJu?=
 =?utf-8?B?d0wyemlDZ3RYcGF6TlBVR0xDeFNQMmYrTVp3VW9HZFV6TTQ5ZTJqY1JnL0RW?=
 =?utf-8?B?MHdqNzUyMXk3eUJwclFobzZwNWRreWZvVFhXUjRPUmRJQnhwQTdEbDVFUjU3?=
 =?utf-8?B?M3BiQXlKUHorVDdXcldRRksyd25VbHZCcEVhdmxxeVpaOTZIUU1iTXljU3dL?=
 =?utf-8?B?MVAxL0tVTHJsSFJnUGdvbkkxeHNSL21MSkNCbk4vNm5GNlpxNHlBSzVBUlRC?=
 =?utf-8?B?czBTTUt0NmxoR09pSTVFS0lUeE54eWJsalJyKzRFQ2NKODAwRU1Eb3kzUG9D?=
 =?utf-8?Q?1O0tca2wtXISizMOmAOsNPRtnf4B865KQ6WxClngUo=3D?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dafbfa3a-73c7-4008-0fb8-08d9d6729afb
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2022 08:56:36.6739
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mAsWkyZLmdqdOQ09ZMEosmMPB+HGu9H22g2Dff96VU1jICb8KkalFFG/Oc6mIF/dUS879buUyQx4dsLqHsXdjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1101MB2071
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVmFs
dWVzICJzaWxhYnMsd2Z4LXNkaW8iIGFuZCAic2lsYWJzLHdmeC1zcGkiIGFyZSBkZXByZWNhdGVk
IGZvciBhIHdoaWxlCm5vdy4gV2UgdGFrZSBhZHZhbnRhZ2Ugb2YgZ2V0dGluZyBvdXQgb2YgdGhl
IHN0YWdpbmcgdHJlZSB0byBkcm9wIHRoZW0KYW5kIHN0YXJ0IGZyb20gYSBibGFuayBzaGVldC4K
ClNpZ25lZC1vZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2lsYWJz
LmNvbT4KLS0tCiAuLi4vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvd2lyZWxlc3Mvc2lsYWJzLHdm
eC55YW1sIHwgIDMgKy0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2J1c19zZGlvLmMgICAgICAgICAg
ICAgICAgICAgICAgIHwgIDcgLS0tLS0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9idXNfc3BpLmMg
ICAgICAgICAgICAgICAgICAgICAgICB8IDEyIC0tLS0tLS0tLS0tLQogZHJpdmVycy9zdGFnaW5n
L3dmeC9tYWluLmggICAgICAgICAgICAgICAgICAgICAgICAgICB8ICAxIC0KIDQgZmlsZXMgY2hh
bmdlZCwgMSBpbnNlcnRpb24oKyksIDIyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZl
cnMvc3RhZ2luZy93ZngvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC93aXJl
bGVzcy9zaWxhYnMsd2Z4LnlhbWwgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L0RvY3VtZW50YXRpb24v
ZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvd2lyZWxlc3Mvc2lsYWJzLHdmeC55YW1sCmluZGV4IDQ0
YWViYTBmNzI3Ni4uYzEyYmUxOGViNmFjIDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4
L0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvd2lyZWxlc3Mvc2lsYWJzLHdm
eC55YW1sCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVl
L2JpbmRpbmdzL25ldC93aXJlbGVzcy9zaWxhYnMsd2Z4LnlhbWwKQEAgLTY0LDggKzY0LDcgQEAg
cHJvcGVydGllczoKICAgcmVzZXQtZ3Bpb3M6CiAgICAgZGVzY3JpcHRpb246IChTUEkgb25seSkg
UGhhbmRsZSBvZiBncGlvIHRoYXQgd2lsbCBiZSB1c2VkIHRvIHJlc2V0IGNoaXAKICAgICAgIGR1
cmluZyBwcm9iZS4gV2l0aG91dCB0aGlzIHByb3BlcnR5LCB5b3UgbWF5IGVuY291bnRlciBpc3N1
ZXMgd2l0aCB3YXJtCi0gICAgICBib290LiAoRm9yIGxlZ2FjeSBwdXJwb3NlLCB0aGUgZ3BpbyBp
biBpbnZlcnRlZCB3aGVuIGNvbXBhdGlibGUgPT0KLSAgICAgICJzaWxhYnMsd2Z4LXNwaSIpCisg
ICAgICBib290LgogCiAgICAgICBGb3IgU0RJTywgdGhlIHJlc2V0IGdwaW8gc2hvdWxkIGRlY2xh
cmVkIHVzaW5nIGEgbW1jLXB3cnNlcS4KICAgICBtYXhJdGVtczogMQpkaWZmIC0tZ2l0IGEvZHJp
dmVycy9zdGFnaW5nL3dmeC9idXNfc2Rpby5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9idXNfc2Rp
by5jCmluZGV4IDZlYWQ2OTU3Yjc1MS4uNmVhNTczMjIxYWIxIDEwMDY0NAotLS0gYS9kcml2ZXJz
L3N0YWdpbmcvd2Z4L2J1c19zZGlvLmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9idXNfc2Rp
by5jCkBAIC00MSwxMiArNDEsNiBAQCBzdGF0aWMgY29uc3Qgc3RydWN0IHdmeF9wbGF0Zm9ybV9k
YXRhIHBkYXRhX2JyZDgwMjNhID0gewogCS5maWxlX3BkcyA9ICJ3ZngvYnJkODAyM2EucGRzIiwK
IH07CiAKLS8qIExlZ2FjeSBEVCBkb24ndCB1c2UgaXQgKi8KLXN0YXRpYyBjb25zdCBzdHJ1Y3Qg
d2Z4X3BsYXRmb3JtX2RhdGEgcGRhdGFfd2Z4X3NkaW8gPSB7Ci0JLmZpbGVfZncgPSAid2ZtX3dm
MjAwIiwKLQkuZmlsZV9wZHMgPSAid2YyMDAucGRzIiwKLX07Ci0KIHN0cnVjdCB3Znhfc2Rpb19w
cml2IHsKIAlzdHJ1Y3Qgc2Rpb19mdW5jICpmdW5jOwogCXN0cnVjdCB3ZnhfZGV2ICpjb3JlOwpA
QCAtMTkzLDcgKzE4Nyw2IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3Qgb2ZfZGV2aWNlX2lkIHdmeF9z
ZGlvX29mX21hdGNoW10gPSB7CiAJeyAuY29tcGF0aWJsZSA9ICJzaWxhYnMsYnJkNDAwMWEiLCAu
ZGF0YSA9ICZwZGF0YV9icmQ0MDAxYSB9LAogCXsgLmNvbXBhdGlibGUgPSAic2lsYWJzLGJyZDgw
MjJhIiwgLmRhdGEgPSAmcGRhdGFfYnJkODAyMmEgfSwKIAl7IC5jb21wYXRpYmxlID0gInNpbGFi
cyxicmQ4MDIzYSIsIC5kYXRhID0gJnBkYXRhX2JyZDgwMjNhIH0sCi0JeyAuY29tcGF0aWJsZSA9
ICJzaWxhYnMsd2Z4LXNkaW8iLCAuZGF0YSA9ICZwZGF0YV93Znhfc2RpbyB9LAogCXsgfSwKIH07
CiBNT0RVTEVfREVWSUNFX1RBQkxFKG9mLCB3Znhfc2Rpb19vZl9tYXRjaCk7CmRpZmYgLS1naXQg
YS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2J1c19zcGkuYyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvYnVz
X3NwaS5jCmluZGV4IDZiNGY5ZmZmOGI0NC4uMDYyODI2YWE3ZTZjIDEwMDY0NAotLS0gYS9kcml2
ZXJzL3N0YWdpbmcvd2Z4L2J1c19zcGkuYworKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2J1c19z
cGkuYwpAQCAtNDcsMTQgKzQ3LDYgQEAgc3RhdGljIGNvbnN0IHN0cnVjdCB3ZnhfcGxhdGZvcm1f
ZGF0YSBwZGF0YV9icmQ4MDIzYSA9IHsKIAkudXNlX3Jpc2luZ19jbGsgPSB0cnVlLAogfTsKIAot
LyogTGVnYWN5IERUIGRvbid0IHVzZSBpdCAqLwotc3RhdGljIGNvbnN0IHN0cnVjdCB3ZnhfcGxh
dGZvcm1fZGF0YSBwZGF0YV93Znhfc3BpID0gewotCS5maWxlX2Z3ID0gIndmbV93ZjIwMCIsCi0J
LmZpbGVfcGRzID0gIndmMjAwLnBkcyIsCi0JLnVzZV9yaXNpbmdfY2xrID0gdHJ1ZSwKLQkucmVz
ZXRfaW52ZXJ0ZWQgPSB0cnVlLAotfTsKLQogc3RydWN0IHdmeF9zcGlfcHJpdiB7CiAJc3RydWN0
IHNwaV9kZXZpY2UgKmZ1bmM7CiAJc3RydWN0IHdmeF9kZXYgKmNvcmU7CkBAIC0yMzcsOCArMjI5
LDYgQEAgc3RhdGljIGludCB3Znhfc3BpX3Byb2JlKHN0cnVjdCBzcGlfZGV2aWNlICpmdW5jKQog
CQlkZXZfd2FybigmZnVuYy0+ZGV2LCAiZ3BpbyByZXNldCBpcyBub3QgZGVmaW5lZCwgdHJ5aW5n
IHRvIGxvYWQgZmlybXdhcmUgYW55d2F5XG4iKTsKIAl9IGVsc2UgewogCQlncGlvZF9zZXRfY29u
c3VtZXJfbmFtZShidXMtPmdwaW9fcmVzZXQsICJ3ZnggcmVzZXQiKTsKLQkJaWYgKHBkYXRhLT5y
ZXNldF9pbnZlcnRlZCkKLQkJCWdwaW9kX3RvZ2dsZV9hY3RpdmVfbG93KGJ1cy0+Z3Bpb19yZXNl
dCk7CiAJCWdwaW9kX3NldF92YWx1ZV9jYW5zbGVlcChidXMtPmdwaW9fcmVzZXQsIDEpOwogCQl1
c2xlZXBfcmFuZ2UoMTAwLCAxNTApOwogCQlncGlvZF9zZXRfdmFsdWVfY2Fuc2xlZXAoYnVzLT5n
cGlvX3Jlc2V0LCAwKTsKQEAgLTI2OSw3ICsyNTksNiBAQCBzdGF0aWMgY29uc3Qgc3RydWN0IHNw
aV9kZXZpY2VfaWQgd2Z4X3NwaV9pZFtdID0gewogCXsgImJyZDQwMDFhIiwgKGtlcm5lbF91bG9u
Z190KSZwZGF0YV9icmQ0MDAxYSB9LAogCXsgImJyZDgwMjJhIiwgKGtlcm5lbF91bG9uZ190KSZw
ZGF0YV9icmQ4MDIyYSB9LAogCXsgImJyZDgwMjNhIiwgKGtlcm5lbF91bG9uZ190KSZwZGF0YV9i
cmQ4MDIzYSB9LAotCXsgIndmeC1zcGkiLCAgKGtlcm5lbF91bG9uZ190KSZwZGF0YV93Znhfc3Bp
IH0sCiAJeyB9LAogfTsKIE1PRFVMRV9ERVZJQ0VfVEFCTEUoc3BpLCB3Znhfc3BpX2lkKTsKQEAg
LTI4MCw3ICsyNjksNiBAQCBzdGF0aWMgY29uc3Qgc3RydWN0IG9mX2RldmljZV9pZCB3Znhfc3Bp
X29mX21hdGNoW10gPSB7CiAJeyAuY29tcGF0aWJsZSA9ICJzaWxhYnMsYnJkNDAwMWEiIH0sCiAJ
eyAuY29tcGF0aWJsZSA9ICJzaWxhYnMsYnJkODAyMmEiIH0sCiAJeyAuY29tcGF0aWJsZSA9ICJz
aWxhYnMsYnJkODAyM2EiIH0sCi0JeyAuY29tcGF0aWJsZSA9ICJzaWxhYnMsd2Z4LXNwaSIgfSwK
IAl7IH0sCiB9OwogTU9EVUxFX0RFVklDRV9UQUJMRShvZiwgd2Z4X3NwaV9vZl9tYXRjaCk7CmRp
ZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L21haW4uaCBiL2RyaXZlcnMvc3RhZ2luZy93
ZngvbWFpbi5oCmluZGV4IGZjZDI2YjI0NTE5ZS4uNjhjNjY1MzA3MTUzIDEwMDY0NAotLS0gYS9k
cml2ZXJzL3N0YWdpbmcvd2Z4L21haW4uaAorKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L21haW4u
aApAQCAtMjMsNyArMjMsNiBAQCBzdHJ1Y3Qgd2Z4X3BsYXRmb3JtX2RhdGEgewogCWNvbnN0IGNo
YXIgKmZpbGVfZnc7CiAJY29uc3QgY2hhciAqZmlsZV9wZHM7CiAJc3RydWN0IGdwaW9fZGVzYyAq
Z3Bpb193YWtldXA7Ci0JYm9vbCByZXNldF9pbnZlcnRlZDsKIAkvKiBpZiB0cnVlIEhJRiBEX291
dCBpcyBzYW1wbGVkIG9uIHRoZSByaXNpbmcgZWRnZSBvZiB0aGUgY2xvY2sgKGludGVuZGVkIHRv
IGJlIHVzZWQgaW4KIAkgKiA1ME1oeiBTRElPKQogCSAqLwotLSAKMi4zNC4xCgo=
