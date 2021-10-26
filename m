Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A40C43B894
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 19:49:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236761AbhJZRvg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 13:51:36 -0400
Received: from mail-eopbgr140085.outbound.protection.outlook.com ([40.107.14.85]:3713
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231622AbhJZRvf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 13:51:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cBjk9B/8JeQQtu9XgDwO/BrAC/OXaqZYKRRBZng+L4x74r99gwDt5KrfzxE2+YsOLdTjFlYnZbFXWC6Bcve0hDyFAncqzEQApdg+TRcQ0Mf7raHlodHriGDw6+KJk991eHcH8z1bGc1xKxezjOTNWlPqqsoIET1TmldKa5V7bWApkrYyVAcRbITA9obs4jJiHI2eA8ul6JjKGfwSSgTeRW29T2E+KcsJP2EiipDLXBStETnsym5VSaGk3/DTAobPfkV12Yf2oTI6knj/PXp8togUDPExYsYT8bVO4hCP+MzOvaVQf1/Ys9Y+ui0QVU76imvHim0CVBQCBDtVmYW/aQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8OFt/1RJbWvZDt3aDqQxG88GhPinky0xU4UNPOAAVww=;
 b=V1x9J56CisrKcQ8XL/s9JG3jUspT3L/7Cf36UaJk5pmviSth35IaJa8Qo9flUcFEoRV1avbI67Zu8HoEvO00BBFZ1bdtdZ6y9+dnjioMxqP9fuuOGH2qkB5mP5yc+3ZWMUs+pMbwFwq646E7sHGFbxYTGgFrYPDmx2PiVG3hGjq8e9X6vQ/LAW5Cl7vj1ShBTqekq5kwJiOPi1JLvARiT8ZMey6LWcMsm5ijHRABYazr8HjSIDyW3HYheNVTxDf7Q0G0+1R3Fc/0fDWWQIdlOxCC+SFTx8pfFdFmuwmXECiFtP1We0QC5kl16+rgPZ1jRnPCQu2APIlbpMv+hLSsng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8OFt/1RJbWvZDt3aDqQxG88GhPinky0xU4UNPOAAVww=;
 b=M6Vg57gCVZTSYO/obXq+7TNn5IWYMiXlHlzLeUzpP8ukyhrIGdj36o0gZbiYc+rnaFV/RnVA/tUwEQgatSHXmoSJW7gFIGDLM75ZTtaPXNvLVIa6dwrk5cW2uTkLe9MqAc08YrEGeTBgLIanlgVh6afWJCwWf/rKIw8R8ma/yps=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
 by DB8PR03MB6028.eurprd03.prod.outlook.com (2603:10a6:10:ee::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Tue, 26 Oct
 2021 17:49:08 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf%6]) with mapi id 15.20.4628.020; Tue, 26 Oct 2021
 17:49:08 +0000
Subject: Re: [PATCH v4] net: macb: Fix several edge cases in validate
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Nicolas Ferre <nicolas.ferre@microchip.com>,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Antoine Tenart <atenart@kernel.org>
References: <20211025172405.211164-1-sean.anderson@seco.com>
 <YXcfRciQWl9t3E5Y@shell.armlinux.org.uk>
 <5e946ab6-94fe-e760-c64b-5abaf8ac9068@seco.com>
 <a0c6edd9-3057-45cf-ef2d-6d54a201c9b2@microchip.com>
 <YXg1F7cGOEjd2a+c@shell.armlinux.org.uk>
 <61d9f92e-78d8-5d14-50d1-1ed886ec0e17@seco.com>
 <YXg/DP2d1UM831+c@shell.armlinux.org.uk>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <b911cfcc-1c6f-1092-3803-6a57f785bde1@seco.com>
Date:   Tue, 26 Oct 2021 13:49:03 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <YXg/DP2d1UM831+c@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1P221CA0030.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:2c5::21) To DB7PR03MB4523.eurprd03.prod.outlook.com
 (2603:10a6:10:19::27)
MIME-Version: 1.0
Received: from [172.27.1.65] (50.195.82.171) by BL1P221CA0030.NAMP221.PROD.OUTLOOK.COM (2603:10b6:208:2c5::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.22 via Frontend Transport; Tue, 26 Oct 2021 17:49:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 97f6c309-3657-4f7c-3669-08d998a8e93d
X-MS-TrafficTypeDiagnostic: DB8PR03MB6028:
X-Microsoft-Antispam-PRVS: <DB8PR03MB60283164E10B8A1D9543B56A96849@DB8PR03MB6028.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gznmwuAzjRufqTyaEhskAAVSVkuvYYO260Qc/Ex4GyCKRAr7jamO4LB5+li5Rrv8Psi74Vw91vpA6ZY7DDuouHzXNEU67ZtCGQQqm/C9fR7O53twfibBksGUmkIi9e6PKIaLsi409rWjTHVCeQLBdeb+9rjGuE6Vml7eylkNnfeRoY6rJappn9Dx9juhCvdeHlb3IWovZOcEp1Qa1+ndDh2j6sewBUg6qsRL+PHlt+YAOz3BKgd4tuQqdpQjbnImZuH2aJ+WFiMR0uqfI8sX1OYir3NtEGDjDTPS6XRWGrpnF3FcGQKYgX5vzar233gHR0MKpgCVJfkPDIoDjIQ600Hs5zBK4soktYB9FmBbggLx5v5P9G1dK7A4pLFOtB2dLBROAR/ERR/l8rP207LHJz5gNgPev4X4+7Jzm9ppJkpZZpdWo0MzS6mBBU7PfoxsKNzBtU+azsdom5QbuAG0LhjsFMySvZCemyIUeXJFWp4Qu6+Nb4NzihN+7F7iphUSTczSXJ2pULrt/Qx9Awl4/vGe0f3MMObWX3K6NQBPFjalm+NfALpr3qRztwYIKroGZGwVuciQAjLXSMulkLBih8suzEOy8jyjKehypLXvP3bhumK2HOi+PoBD5n+aU8qxjaHOEP6n/PUDQuqnICr4WmzeDDMDMqD8GMwSfd78J9OzMe2tMovc6WIEKNYAVWG3Aej4WT0WBcW5kQ0sQjCz9hO9qnUWOEDTDo08FOhIhsy1eI821Q/xvU1N+RPtuAEY/YBqWWYGhRTydcDozZcZY07k0nh/X6kkRwFwZRTAsdLZ7GGH/3+4gqYkwjSp7hdUKWr0AF4wJFEAs3CRrgsnjZFDXDNsvzvjnKH6l15KjRs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66946007)(66476007)(966005)(5660300002)(4326008)(956004)(66556008)(38100700002)(36756003)(26005)(6666004)(186003)(44832011)(31686004)(54906003)(53546011)(508600001)(6486002)(16576012)(316002)(2906002)(52116002)(31696002)(38350700002)(6916009)(8676002)(86362001)(8936002)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eHFiQ2VVQ0wwWE9CcDBIWmdPRjc2cTdSS2JQM1dIZTVJSVEvV3JvRWVOK2dS?=
 =?utf-8?B?U0g5dDdpeTBrTzJ2Lzl2NHE4c1cyZ0J1YnZFbFkrcVBOTCtCaTByRkw1ZHEy?=
 =?utf-8?B?SzgzRlFMVE1BMG9SS0FseUJjbiszQXBzT2pCazZlc0RBeVR1cmZGYkpFZjdk?=
 =?utf-8?B?ZU9mc25yelR6VTMrZ1NKUVdPZmZsc1RJWXcvZDdoZk83d2ZDUFhKdkVXRVV1?=
 =?utf-8?B?NTFMRXc0a2xhQkhnKzRVNzJkMEhCQzh1MmdqalFqYTNqRnRoL21uT0Z3S3B0?=
 =?utf-8?B?dFFlQm4xaHZvaWZHZER3cWJoOFhTM2laU0MxRjZkYjZnS3BseGs4L0t0M0ph?=
 =?utf-8?B?OTA5b3VyUDcyY1lBRG40WWhYNCsxSk0zOSsrc25aNUNmYjlGM3A5TTFXTHlr?=
 =?utf-8?B?UUVTUDAybk05a21tMVpwUndwbml3bnlOZmU3aEVFcWxXNXg1WWlKZHh4TDBE?=
 =?utf-8?B?Z0RKbkFuOGRkRXZPSmc4TmdhM0NrMWl1a3IrNzFuWEhiWVZpZUdKOStZRHlY?=
 =?utf-8?B?NkxrQ0NjL1BSSlBKNXlXeXlLNkdHdlhQSFdyOEl1M01Ua0NEK3Q5azdDdUc0?=
 =?utf-8?B?T25UUzA3eXd1MWdHNnF5QWM0REduR0xndFM2eDRUZzRZV3NNU0Fyd3VIZXdC?=
 =?utf-8?B?NldxaEVmVVNZQWV2Q2EwSFhMdUIwSHNvQThtRDhNVzJnMThxcFQ1SHFmYmxo?=
 =?utf-8?B?V05CSHZGeXdIK284YjdTTWkxRlJ1dDRUT3F0dlM2M2ZnWDJEVEpJS1pNLzJq?=
 =?utf-8?B?STByYmtjNkZORkhVcTZMNE83VjdQT2RNT3BFUE4wL2ZZQjVDVy92dU52ZEpr?=
 =?utf-8?B?d0tHTTJ4TDNpaUNIaFZtdE50YWxkT0FmMU5UTnVjcFBPQ25IYkttNFRCZXpm?=
 =?utf-8?B?V1RBSC81aVhxVDE5eGhPTStoM1pTdzRDaVBOa044UFRraFdkSnloVndQUFRx?=
 =?utf-8?B?USs1V09VdjhFN2orL0pYc1RhTVJ2TXpQMnd1ZENuRU5welFoVStGVjBPQVda?=
 =?utf-8?B?QzdDNnBnc0txYzZubWVFNDQxeUJ3VG9wSENwdVVCY3EwWG1iTy9MTnJ3bEdG?=
 =?utf-8?B?OFVRVjg1MU1wK3VvUEUrUGpVRGxucHJUSHIySUpYNWVkcGp0MnFNQmVxcEFh?=
 =?utf-8?B?aitTL1VHRnZzc01xblN5QzdKTFV0NHBuaWdNTzFmdmlwdmhianlDcThLS0lQ?=
 =?utf-8?B?RjRRMCtmSkhtc2RjL2kzVldsYVB1YldjNzNhSU9PZG1tSklOVVcwQ0I3a3E3?=
 =?utf-8?B?U05JVkxEVjFnOCs4OENLcFdtY2FnbGZmT2tGT0ZSWXc5dEFid1VodjVzdWIw?=
 =?utf-8?B?ZkVZZHMxVFRtampXRzRDVWh4VjVzdDRmTmtBVFRNVjhzRWIycUdYbGN5SmE0?=
 =?utf-8?B?RmF5SWlLUjRhbFRQekw0RDc1YlhMNVVBSml4MkVYeTdOcCtwWk9iS0xsMXRW?=
 =?utf-8?B?NWF4UktOZy9lY29DeWFxR2lHUWtKaHY0N2dwdnFmNm12ZmdkWmVGeG4yMERo?=
 =?utf-8?B?ODljc1pvekg2TnF4b2trR1lWaWNISjB4bEhPcU5sRGdhRHRhRm9scHZvWWhq?=
 =?utf-8?B?WlQ5Y1FWMG1JZjZpais3dWpCSEFYVUNnS09veDJBekpibk1scERPWEFsQm5y?=
 =?utf-8?B?WW9SdlFVekViNHJOZHdkVkNRazZmeWtPMStudUN2Y3llSGtEbEd2OVN1L2l6?=
 =?utf-8?B?SURvZkppaGpnN1FSMFhESVNqNHJxU3l2YnpKMEhWa2pZMkZrTjF0bi9Ocko4?=
 =?utf-8?B?Y0dhczV3SlNkSldhWk5Vb3NHSXNmRStSeEkyUGJVYVRNV0hjUSsvQ2FBaVMx?=
 =?utf-8?B?cko2OXFkSzR5ZWxzbHM4aHpxK3NReFlaQVB4dXk0Mk54ZExxQWxsN0NSN053?=
 =?utf-8?B?NHNTdVFpc05lR01MY0RUWjkvREpvaFlnckhYT0FYNG1oVHVWRFpRd1pZNzRk?=
 =?utf-8?B?dEJGNFhJRFNuNUZ3bS9ycUhNMFFxUGpZSFAvRnM3WlZYZjlOVEFVN0lScUlL?=
 =?utf-8?B?enRsZXJjWkpHTmZ5Z3l1cjM3R0loZUxJL3VSNFFsWTVkeUFNRFJ3Ylp1dkNy?=
 =?utf-8?B?TTZJVW5mdkdQbmFPZGJSRElFU0RJVysvME1xVFlXK014dklCTkFkQWZjYkpL?=
 =?utf-8?B?cW5XaTRjc1EwOEdhN2Y3ZEcvYUN0Q0pKLzhwTml3NVN4VlZpemt4WisrYmFJ?=
 =?utf-8?Q?UHH6JjwAhyOH5CJlSLDkWGw=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97f6c309-3657-4f7c-3669-08d998a8e93d
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2021 17:49:08.6055
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: een0SWHjabVRd2SD4Ja20cWDaMzRXqHqU7IYHIOvJSn87rItFRWQ5NSmS4a/K6dELaJOzgmvVnJOl32EwkInvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR03MB6028
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/26/21 1:46 PM, Russell King (Oracle) wrote:
> On Tue, Oct 26, 2021 at 01:28:15PM -0400, Sean Anderson wrote:
>> Actually, according to the Zynq UltraScale+ Devices Register Reference
>> [1], the PCS does not support 10/100. So should SGMII even fall through
>> here?
>> 
>> [1] https://www.xilinx.com/html_docs/registers/ug1087/gem___pcs_control.html
> 
> Hmm. That brings with it fundamental question: if the PCS supports 1G
> only, does it _actually_ support Cisco SGMII, or does it only support
> 1000base-X?
> 

Of course, in the technical reference manual [1], they say

 > The line rate is 1 Gb/s as SGMII hardwired to function at 1 Gb/s only.
 > However, the data transfer rate can be forced down to 100 Mb/s or 10
 > Mb/s if the link partner is not capable.

which sounds like the normal byte-repetition of SGMII...

And they also talk about how the autonegotiation timeout and control words are different.

--Sean

[1] https://www.xilinx.com/support/documentation/user_guides/ug1085-zynq-ultrascale-trm.pdf
