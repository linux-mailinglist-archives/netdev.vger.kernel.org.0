Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DA0168EF2A
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 13:40:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230184AbjBHMkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 07:40:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbjBHMkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 07:40:18 -0500
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADBBC4A1D0
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 04:40:12 -0800 (PST)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.19/8.17.1.19) with ESMTP id 318Axeq0028429;
        Wed, 8 Feb 2023 04:40:08 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=MV28Hel8FD19GGIa6YfxIEjnsEEpdoTnT8TeLsDplkc=;
 b=cj+PcRFSQP1s00VUplqGCzEc7QEf24G9gLwnmwRsOCtUbirXbxowLgg2G0CBg6Vdv6IN
 GZ1qBwXTOCWdh9ehgQ9QUXmEjLKIBvffvOkr+lMk9ElkI8v54wloE4p80p1IynzKhlDM
 UMDLGZnIpz59vRiX0BwkHTpwNQBtL5QdrlaKF2I49LtCPJ0nJNl4m7bKOWhtKzJU8/zx
 LnVh5j6dZuA4XHgUVHaA0zMCzBuzwKKwtkYnzemO0wIRaqerY/EzQAo857yTgwSuaER4
 cEnr5AsMKZwfrpOeFTAKlK0eXIZ6rCp759ZXduTf1ASJ30vl1LRzMv+9oIWr3/NiGt/3 pQ== 
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2046.outbound.protection.outlook.com [104.47.74.46])
        by m0001303.ppops.net (PPS) with ESMTPS id 3nk2whghf8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Feb 2023 04:40:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l3NvMlBo1mRBABBrfXcrztUgSn6AJVFNmwERPD5mBAJLHVSGTgd4Fi59hu/Gvf9v5eEzU1JsL3ZRBzB/j+CTj1ilqRFpmN2GpgAkgR1yZSmPyp8u5u2iJKxmI5nc8RltG74Qd1INCHJjUsH86k9JmDuKJ/2ogujRUZ40mxcOO247auQOYJpp+pb7fDtaGzCP1Wplw0eC8IfSrb+WZA20fxDg9ooATAMxzNTINhUV1JnP6Xr7qrY9RHtDJHryseglOvtnp4u3DzznLnYe3JynUrBUQJdWHJAV9n99LYBcWYusWOIwW52rVU+x2TiZ1uMLs1mP1s6WsmlFYvgzDA/J5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MV28Hel8FD19GGIa6YfxIEjnsEEpdoTnT8TeLsDplkc=;
 b=A/5PoLb4O1k21TZtFk5M2N7VYnqjNBV8r90P+2hi7maiJFbpobXpNUmq3eEM4kYKFUTX+chKVxC34JvbCVmVmxhI86+uv9VTf7dTY9Scx7diPc3GHzWt4CEWQDWvgRfZmMVm66LQ4XEu64o9ApMEsjHzDPV+4Vk8UJauPf/7fJsmdaGbFh33VSlsnnV6iKMmWvo0x6dQLD57wtfZ5YwkVnkfuiNPmNezzusHjLCOTOZNiZtbOmanZYDOKzokbJf7doAzpQ4MyY21HoZlh2a8TYDku1fGTuF+SiH5qwt68O7uwyfbptJxJmGRoIR6OqIx+JFFMBzwRZkrk0ompYrqvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from BLAPR15MB3874.namprd15.prod.outlook.com (2603:10b6:208:272::10)
 by PH0PR15MB5168.namprd15.prod.outlook.com (2603:10b6:510:129::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.17; Wed, 8 Feb
 2023 12:40:06 +0000
Received: from BLAPR15MB3874.namprd15.prod.outlook.com
 ([fe80::8f58:63ac:99f9:45d7]) by BLAPR15MB3874.namprd15.prod.outlook.com
 ([fe80::8f58:63ac:99f9:45d7%4]) with mapi id 15.20.6064.036; Wed, 8 Feb 2023
 12:40:06 +0000
Message-ID: <66d29f48-f8e1-7a2e-cc46-3872a963c33a@meta.com>
Date:   Wed, 8 Feb 2023 12:40:00 +0000
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [pull request][net 00/10] mlx5 fixes 2023-02-07
Content-Language: en-US
To:     Saeed Mahameed <saeed@kernel.org>, Jakub Kicinski <kuba@kernel.org>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>
References: <20230208030302.95378-1-saeed@kernel.org>
From:   Vadim Fedorenko <vadfed@meta.com>
In-Reply-To: <20230208030302.95378-1-saeed@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0155.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:188::16) To BLAPR15MB3874.namprd15.prod.outlook.com
 (2603:10b6:208:272::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR15MB3874:EE_|PH0PR15MB5168:EE_
X-MS-Office365-Filtering-Correlation-Id: ad261b63-0b7b-47c2-3a53-08db09d19b01
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u7CqZ4Tbz8pMTl2REwmy4aQI3HgjK4bXvsguehDghTY8FeMkiXd/MTvlZlJWr4qnpVH+9svkMQ6/Rdml4LNYBkc5b27X2cf5PyHAVmaijJ/ba8ekIA/PxnU2Co/amlY+Qn/MHVgGVIkKI87Rj6Ma6GcWUeSnebQrERwBlAwRpHr7T0itFIO4cs8EpGDYWGeXNPnfUgmgxPjHKw2Z2iYuajR5JlQHZ/k5yd5GI8LscFmykpimmhKF5b98MNyLXHxVTu/nk8SQT+NAdt0VsLUBg0v32+J19GsOVux0c5opebulMjPWQrynveU5QziRyViLU1rxynjBjTz6lz8UJ9GiE/M3vPkFBzJowRCIxPMJm83d81QwzTt1T1yaDsutpdAcMWrO96YW1OTQ2KHZ6LNkXa9gJTGmnL2JjAkWyd7EdJJU2GX1D728RM5uj82LBFeA2u4tkGHf/jUg0pQxIvP9drMWFVxviQ48vKMxsx2+G4G4fJJYxxV0oyxXEFvSpZSGliqyXgqq513ObixbXiHX9SBVl+NuRarz67Pj9+5KSsZaT0oeWmDOJYveusUVr8MGwaLMl17S8W0GHS/h/Tw+bztN0BnMRwlpnMqBQga1X+3wecmxLRf0hpT1/drDGnfeJANMqt17ocRCHmt3VULL74LpmS8Eizry1Km1cHau2TYddSE9RKOic/gXV1jKdhIMPlOcTvtsmIAWmJbAP3FFlZYOy0cwmv4Cj5FJfNhZHHA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR15MB3874.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(136003)(396003)(366004)(376002)(346002)(451199018)(2906002)(31686004)(36756003)(5660300002)(8936002)(41300700001)(558084003)(66476007)(66556008)(66946007)(2616005)(4326008)(316002)(6512007)(38100700002)(86362001)(186003)(110136005)(53546011)(6506007)(54906003)(8676002)(31696002)(478600001)(6486002)(6666004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WVRCOGxETzhUYTFWOWp0NUtLVkgxYmlLSDVNd0tJd2RodnRvVCtPNFJ2a01w?=
 =?utf-8?B?UjFNbit4c0FZdkxONFVPTlR5QmhuWExiRnUxMEdCZEl1ZGFFV0N4bEx3bDNy?=
 =?utf-8?B?QXByQUtNMkVKZnd1cmFEODd0MTludE0vSEk3VnVkNjVWbU9EOGRKdnFDRHdw?=
 =?utf-8?B?QUZtYXUvQksvbjFXNlhic3lHUU1vMUdOTFV5b1ZSVytScmVJekpoVGR1L1VM?=
 =?utf-8?B?UFFvcVVySEtaaXZuYTVzbzFjdDBUQ0dBNUJkYzA0TkZQbmJ2dHFlbDc0ZUlE?=
 =?utf-8?B?RjJ5cGs1ejZZTFBlNVJlWW1BR2xsNnd6ai9pMzlqalR0Z2l6b1BKZnpBZXR6?=
 =?utf-8?B?bWpqWkdKM0JXNjJGK3BOb2NaOE9SSXhFTzJsYTFKWThZejlCREovSzR5d1I3?=
 =?utf-8?B?ZnhkWHlRM21HZ2g0VnpKdlZteXFSRTVqQXMwWHVja0xSdi96NFdseFhSckx6?=
 =?utf-8?B?aGFsY1BlMWtVZmpuZHJiY2h5WWx3aW9lWGNRM0xEZkYvSE0ybHY5aE1XZW9L?=
 =?utf-8?B?ekJFNGx3ajQyRHFFMkdSQzBIUXJjbGV3TTlnMVdoancyTE9WQlBISjJQOHJB?=
 =?utf-8?B?ZGFzT0RPYlBXeVJJb1ZSK2RiU0ErZWVPKzUrQ2NjUXVsT1puWFZKTmRRRVpm?=
 =?utf-8?B?ZGtCcDA0ZHZJbExBc3NxdThneGZrM0czdGk5S1FMdkdGZnZvYjFNaDNFeXlp?=
 =?utf-8?B?Ujc4ODFZckM1aGM1V2hOUHJVQU9oR1RWT3h5RzdOUUNVOXdwNDFIdWd1SHE4?=
 =?utf-8?B?V251ZTZ0L2lGRkJmd0IzNlc1dWNWbGhFanRJS0NJRG5yWUtPRVJWNkNiVkxx?=
 =?utf-8?B?QmxzM3YyS08wVHVUVlhtbWZQb3lLcS9yVGFmU014Wlc1d1NSN0drQlg2U3N2?=
 =?utf-8?B?RzFCNWFBZ05IZVJ5OEVER0l6bmpBY2R3MFU0cmY5OENodjhPVTY2dFBrUmgr?=
 =?utf-8?B?bFI0K1pEdi82ZzRPVWsrOVhXRjZJZGdJaytPdmJNYkZQeFVDWit4UHFzRnNr?=
 =?utf-8?B?WXBTaE5Ca2RRWmZMUUFzS0hnWFNIWmN4Y2Q2dzVwRWFBUjd3QTVvNzBCUkhr?=
 =?utf-8?B?dkNNUFR1Q0tjYXp2WTA4NkpWUkRwa09icWlWelBqYUNxSnRGS2ExL1pVR0U3?=
 =?utf-8?B?U1U4V08yQVIvL2V0S1NIcHp4VzZncEQrSzczODRtamo5TWpJU2RpckNoUTN3?=
 =?utf-8?B?K3RRU0tSdUliaUpOSkRnZVVBcStiTis0YkRhRENjeGlUOEQ0VXNiTXdpbmwx?=
 =?utf-8?B?L1RISi9USldLYWw1NDRmTXM3T0MrcWZBNGRzZzJRaDEzWTJxNVAwT2FzaDVF?=
 =?utf-8?B?R01oYUh0RVdnL2lNeW5ZUDh2VE5uRFhPRWJjbUkzS3lzS2o3OWNmWmZ3OGdC?=
 =?utf-8?B?U0tMZmg0dHpUcmc4K2FZVGxrRjIveVhYbEZTTmwvdEEwcU5QdW50ZlJ5ei9m?=
 =?utf-8?B?cVVTQmttUUhvczBicUlGb0tRazdFdWFSYUNVVllwTFhhOVd6YUd0TnV5aVM3?=
 =?utf-8?B?UzQ1WjRUbGVnQUx3TmZxT1ZBZHhXa2tyb1g3ZzhQYUJUMWp0cXBkYkdrWU1j?=
 =?utf-8?B?SEdHRnR1bXVHbmFBcVZQVnE0YTdCVjUzT1pJNFVjZFN3QWhqVlVBTmFYMTRx?=
 =?utf-8?B?WnVGWkFDVVFrd0ZHOUJQWEZmVWJpVVdjSkczeUdJZlliQWgwcElmTGd4MHBw?=
 =?utf-8?B?MVBsSExjZjl3L0kzeWFId1RWa3RVN1dUYWs4ZGkrenlmNUJsQnZkNi9scXBp?=
 =?utf-8?B?VWtyVzU2WnRhbXNNRHJ4MjluSm9EVFBxcG1NekxMVHZYSEJFVlZMOG93bENP?=
 =?utf-8?B?LzlvcGV1elBqWXR5L3Zyb0dsNWNqMkowbW9wMUdjTGRMbEhrVTU3emtOREQy?=
 =?utf-8?B?OVZBMUoxNUVuaVUrUVBXOHFKUmYvTzQvcnFBNDcyeHdMZkwzME01QVBsenlX?=
 =?utf-8?B?YjI1d0NNRldlT2ZOS2xaay9kSk1xNjVyT3orZ1lUdDllR0JFWFcydC9jeXls?=
 =?utf-8?B?OFlQYU9MU3Qya1M1NVBWT0ZPRjlZdEpMV0duK0pMbUVxRGZpUGNJZXF6eXgv?=
 =?utf-8?B?L1E5Mkd6aStRSkVLTU1JVFRuYXB2ZVB0MzRhUjBwaVBNRWw4ZEpSMzVVUE0v?=
 =?utf-8?B?dlJycmVCT2xEZU91RlRIKzI1c2NSNWxYZmliVEFFRTEzQjJGWmVRWlBleHdO?=
 =?utf-8?B?eEE9PQ==?=
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad261b63-0b7b-47c2-3a53-08db09d19b01
X-MS-Exchange-CrossTenant-AuthSource: BLAPR15MB3874.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2023 12:40:06.0014
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s2jSO23SiQgTyS4/FyRj/VTzycEgVPTnT85ndxF9SI0UH0TQRwbmQz+HwXcsZa9Q
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR15MB5168
X-Proofpoint-GUID: 3moulSIho-COjreuJldIe62VkgWzdNin
X-Proofpoint-ORIG-GUID: 3moulSIho-COjreuJldIe62VkgWzdNin
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-08_04,2023-02-08_02,2022-06-22_01
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/02/2023 03:02, Saeed Mahameed wrote:
> From: Saeed Mahameed <saeedm@nvidia.com>
> 
> This series provides bug fixes to mlx5 driver.
> Please pull and let me know if there is any problem.
> 
Still no patches for PTP queue? That's a bit wierd.
Do you think that they are not ready to be in -net?

