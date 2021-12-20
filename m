Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFE3147B088
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 16:44:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230121AbhLTPoj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 10:44:39 -0500
Received: from mail-dm6nam10on2086.outbound.protection.outlook.com ([40.107.93.86]:29408
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229644AbhLTPoj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Dec 2021 10:44:39 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eYcyrsPRiTLow+Ll40VkpJ+HwO55unAiMATAw3rUG7ZlQL0X3ICDttuMbD6PPJYd3eWAPSLoAxMOTXlQBw2D9qINY8NX6N33o/4fexe641W3sW/C352hRFxNxBjSg3VV7o8T9cq06K0O2Bg0dfg0HkSBv4qrvSueddTWEwmka3Gq0o/HSSZT2+3ofFmiyzyme8Z4VNVeHPrvH9dcfdi/fDwiDG6AAx7MzyZRQQLOhVV6r9YY+OYIYvSpzbM2FVzTqQtRTD21/yUymVhWTLap0ZAtQ2RuDOJztdRDjvE4f+knGeWO/QT2MD7FV/XltY8hJ0d4mvRbG6JSykNjkjELNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EbrHyPimB+ojUAjfQOW7SiOisIuHeY6QcR8MhsWB3tc=;
 b=mGh72bC6vqnjY5hZvHjnOwdhUDPqRomeDwbukXVCDSwgAgcXf+pUqF7doR/7ZplMBiNCEqMRdHOLCE8zkfLOFm+Mhr8CEV51imexfYqXxquOFoRqwGorXboE5ubqH6vuwM9pXGmP7RE5hyLUowpz2cTRQQMQGPwo8OoVLOpsJSypvHWU+2yaoAyRUZAD3yzZQ3Vk86b5od7jFbyuva+ajJan9gKNoLRDHqcrK4lQF1y5jo6irNIQKseYFVevYce1al8sHKDw5K/s2Dm4VtRnu6LIFD7oGzb/XUQlqrYuxlPJmTRl/LTG7b7NCRIT2+PmBLeyH2rlI9GMQjccDU13rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EbrHyPimB+ojUAjfQOW7SiOisIuHeY6QcR8MhsWB3tc=;
 b=mqr0wKARKbW/kS6vdSxrucnD2XHKskI6g9FfwzxAFUoi+DuHkFf/agvLg8gBCEJbQrE92NxaKuV1ulNwkYGKUEn5p/GNcayxdvBdtR9ofAVVbdjCzvFYwysCbL1XJTSF9O28+EI44CyXonT6FNwXxpzl0rugSNDcsasQ33NxOW8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DM8PR12MB5496.namprd12.prod.outlook.com (2603:10b6:8:38::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14; Mon, 20 Dec
 2021 15:44:37 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::2429:24de:1fd2:12c5]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::2429:24de:1fd2:12c5%5]) with mapi id 15.20.4801.020; Mon, 20 Dec 2021
 15:44:37 +0000
Subject: Re: [PATCH net-next v2 0/3] net: amd-xgbe: Add support for Yellow
 Carp Ethernet device
To:     Raju Rangoju <rrangoju@amd.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, Shyam-sundar.S-k@amd.com,
        Sudheesh.Mavila@amd.com, Raju.Rangoju@amd.com
References: <20211220135428.1123575-1-rrangoju@amd.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <826ea2bc-8f84-a473-114b-fd05b5972558@amd.com>
Date:   Mon, 20 Dec 2021 09:44:34 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
In-Reply-To: <20211220135428.1123575-1-rrangoju@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0276.namprd13.prod.outlook.com
 (2603:10b6:208:2bc::11) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0326117f-a631-4c32-48b3-08d9c3cfa068
X-MS-TrafficTypeDiagnostic: DM8PR12MB5496:EE_
X-Microsoft-Antispam-PRVS: <DM8PR12MB549614F9034EE239F9A1F942EC7B9@DM8PR12MB5496.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 39pD96FyOQbBINRt5dbtnr9SI/8sFli4iov/U7vB2R3lov8rEdWK2WYdWzerKFqms3U7a5oQO1O4jN0E75uz9kK7x9o6ZZAnQd8Ok/5thqOYU4ZFqfdyy/o6jWn7Rx+bCkdPUVx+s9K3KBUV6nYohb2QoFpZIdHbLtQqmbufmCbDffv8nSbNM/7ADrHc4FRJ5bG2yaHONSCBlQFUac51Bu2eriMpx9JLCFo3qNoliwTXpXWc4kGjnoBnTZ2lG09JrOoO+5VIQoopYXbK+BEnSGJKJfuTyr/BJVeaSGZEIRAvLl+AWSrdySpv2IB7O2xupbDeQG1hXGIppzwDiCTlw9/xo+LccK6G1Sjm3E9AePktinZr7Gak0ABD0NJG3BNBiE4M9xIthUeTBDDiBZ7whrJaY8pI0/hJc2LefZvjTjPqj66/MoRoyIqil8ZlD4jjtqG/Ylikuzt8UWFO4Ec/3FFrqoD9NN0/FJZ7u5C+AKXAtTH93LgqhzVWTqm8AutKXPybjUjtgXuR7fhFnMpoe7TB9FyoY7z80P3EUr3OnufH4p3+54qVI2p8mgyvcQY+XktQJbI1t5zGQY43bqDOJR7VK1z2yIiqfMB99KTy+Xn0PUDNWt6PAePD985In2ohOkBajbWT38gbxrM1E8VE4OqlR2+xmzd1OJoZTvAOI9zI64soicTWKncUM/Ty46c+xYUiPmf/rZGLR/ysAXb7TD36ffirWqMKD8/WYKBeGZQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66476007)(66946007)(66556008)(186003)(4326008)(83380400001)(4744005)(86362001)(31696002)(53546011)(26005)(2616005)(2906002)(31686004)(38100700002)(316002)(6486002)(8676002)(6506007)(508600001)(6666004)(8936002)(36756003)(5660300002)(6512007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dUFobUZEOEdlYzR6d0NvdjE0YjQzb1VhMXZQMDdoYVEydEJJNGVmUWE0MnFL?=
 =?utf-8?B?aXFLZ2pQaE9xYWpiOGxrSXlXY0k2RGVaSVVrVXpkQzRrbUIxUTFJc2loeWZW?=
 =?utf-8?B?dVpOVGttdTcrQWxITWtMN091T0RwMi9WbitVc2dJaTRnVFA4dEd0TkY3aG1z?=
 =?utf-8?B?L3htTzJDdk9SUW9DeE5lYmRDL2szSWlsanY1RnFWcVFhaFl3U2pMbVZLZEtK?=
 =?utf-8?B?VmxSV3NUNDZEMlJCN2dOa2tLdEYzS3B1V3ZmdEFDOGJ1RFdRWnNRYnl3Y2NN?=
 =?utf-8?B?MmZqWWJwbDIzM0hPOGxpbmxXRVhIaW5DQklmK0dneXhudzlYRjVzb0lwQUxT?=
 =?utf-8?B?c2pMUEtVcXV2MTEybXQ4NlEvNjhTUUxjbCtBbG1DUkg0UW9kTHhHNk5PYzNs?=
 =?utf-8?B?MWVaaDBzY21kRkphbWhzZTZ1Y0VncXM4dHB3U2s5NStaV0x4NWcycDhhTnEv?=
 =?utf-8?B?aW9DVTZLMnZIMVFDdlJabTB2eEZCczJ2eW16YjdJNHMzQW8wbXpvV1kzR2Vx?=
 =?utf-8?B?TDhkS3RJWXdvR2ZBRXVqV1NhWmw5QjZqVUh0YzQ5NEx2YmVnaHJZanJXWDh6?=
 =?utf-8?B?MGFhc0ljTzhjQnQyOHArOFVVVU1LOFpqMUxqZ1VlTUlnVk9lNXY5V3QxM3pv?=
 =?utf-8?B?OFhSWjNaUmlFbTBmdUNIZ2tlS2JzL1gvUys5MzRvUzl6Z2FFdThPbXJoUE9H?=
 =?utf-8?B?d2hKdDNFdnY3ZDRKUUM1Z1hlZ0RWWDQ1V0tNdzNOYWFiZFRyNHdOdVd0VnRl?=
 =?utf-8?B?blR3dStOc3oxV050dnhXelQ1dkU5ejBnNGN6ZzNYazVnK1Fua003Tk1TSjFn?=
 =?utf-8?B?WlJFeXRkMW5xTVpwalFXRXpQakVpZmNwcmJ6cURqQms4L3MvVER6bmNuaW5N?=
 =?utf-8?B?MXhrOGZRNzlzdFBXcTMwUGVydEx0VnlZWlplTWNlellSZFZqTytLL08rSzRp?=
 =?utf-8?B?WEFCUnhaUFE3ZjF4aHpiZzdKaElUd0Y5ZkY3UVU4OW9MYWc5SXcxYnplalVm?=
 =?utf-8?B?NTRwUEt4N0d1VUl0dlVtNUg5K3p6STBxTVN0VTRiSFpKZkd2dHF0NFNROVZr?=
 =?utf-8?B?aEtRbWtzV1M2TjlaS0kxU1RSUjRNNDU3SW1KcDJrOUtid2JKc0YrSk5YeEF6?=
 =?utf-8?B?SVV3emhQd2txMEpKR1NXd2M4Vk45L3VVem9xUi9KaVVia1FGVG9nSXc1eFRL?=
 =?utf-8?B?OWYzR3FWNUhOWWxRaDMzRDRQQzBwRzRjdXl2UHVvNkhiMGtHbTFiR1JqeDgy?=
 =?utf-8?B?eWxRd1U2eWYzQUZrVTIxQ09EUzVGbWxxL3ZmaWpISTEzZDlyM09GVm1zWkNh?=
 =?utf-8?B?YjBvbW5ROU1FbmVGUnBTR0N1TFNzNnM3RXlMQnFHVjl5WUhlQ1lVNUc4YzBV?=
 =?utf-8?B?WDAvYVFCb0JCaW9ZbzFHaTdzaG9KOWJSTm9yVXdqeXVzampCNWNpcGp0U1Nu?=
 =?utf-8?B?RFNINmF6TDF0SVA0MlBFYTgrZUhBL3FHZXNldndPRDgrMXN0ZFdUWTJlN2hK?=
 =?utf-8?B?K3VlaWhEeHR5NUk2dm9VZVk4dE5lSUY3ZTQzRFRkSU84eFUrNms3MFZ6Wlhi?=
 =?utf-8?B?OEdMSEJpWFk5R0h0RFgwTEVsaVMwUEFSWkJsVUswY2pxNnhWTjVWK1hlcHlv?=
 =?utf-8?B?eTdGK01pTHhvMi8rYkRnN0dsZjI3QjRGQmZoMWd4QVFzSi9ibURvZWs3cWR3?=
 =?utf-8?B?UFZYcDAvZ1cwNFhNZ2IvMytkdEpYK2dqMzJ6Yi81cFlxdjVpYWdLclZaTTd5?=
 =?utf-8?B?NTRpcnV1ZU1NQ0ZCQ0dRdXhmL2FDSkhiNzRhS3NPK05FbDdwYnVGTnBaMFZi?=
 =?utf-8?B?VHVsVzEwTUl3STZpTjZ5dzZ3NWlsa0p0WHBWY0VGcngvY0RVZmFzTzE4WWYy?=
 =?utf-8?B?dURVVlJ0NHVGeE8vSjRhQmdrelI0dmlmNU0venYvZFRHdUIvSUdGLzk2WUho?=
 =?utf-8?B?R0xCVXRPT0RPc3Z6aVFVekhzUVozOWxGcHF2Nm1obzkySUJHb3l2bTNxcUxC?=
 =?utf-8?B?NXhVYktOa2VnUmxyY3NCTE9sVzFNdnpKOGdmeEhsbkMxQzh6MDJyR1BLWkpw?=
 =?utf-8?B?UFU3cXNjdWYrMVRUZlhWeGVEUnZrSTRiekNzWGNNU1hCTDR0ZFZJSmlHWXRV?=
 =?utf-8?B?U2NLUGlBTUVucVM2VmdxeWFTY0tJWm5aVnJsN2lQTi9JSldPT1BMZEczaUtt?=
 =?utf-8?Q?gTTnKsvAhj8O6hOpKgibsFI=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0326117f-a631-4c32-48b3-08d9c3cfa068
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2021 15:44:36.8346
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 159rcrqyL2hHwwXC9lVIAmmz5HdvN+DSbg31NhMhpq2a5F8hy/ArGr9hyJeoQmzP1wBCeAiuvcLckalPYPhgNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5496
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/20/21 7:54 AM, Raju Rangoju wrote:
> From: Raju Rangoju <Raju.Rangoju@amd.com>
> 
> Add support for newer version of Hardware, the Yellow Carp Ethernet device

Looks good Raju.

Thanks,
Tom

> 
> Changelog:
> v1->v2:
>   - Rework xgbe_pci_probe logic to set pdata->xpcs_window.. registers for
>     all the platforms
>   - Add a blank line before the comment
> 
> Raju Rangoju (3):
>    net: amd-xgbe: Add Support for Yellow Carp Ethernet device
>    net: amd-xgbe: Alter the port speed bit range
>    net: amd-xgbe: Disable the CDR workaround path for Yellow Carp Devices
> 
>   drivers/net/ethernet/amd/xgbe/xgbe-common.h |  6 ++++--
>   drivers/net/ethernet/amd/xgbe/xgbe-pci.c    | 11 +++++++++--
>   drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c |  8 ++++----
>   3 files changed, 17 insertions(+), 8 deletions(-)
> 
