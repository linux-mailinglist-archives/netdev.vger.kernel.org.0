Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2701669DBA2
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 09:04:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233223AbjBUIEz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 03:04:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233113AbjBUIEx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 03:04:53 -0500
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4954F1A959;
        Tue, 21 Feb 2023 00:04:51 -0800 (PST)
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31L7kAkQ007685;
        Tue, 21 Feb 2023 08:04:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=subject : to : cc
 : references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=PPS06212021;
 bh=WxAYs9bS8/HSgrA3i/kDScYLRCWEOVJNBXev+Jy5ws8=;
 b=M0e6V6S6IkDJ4f28dwnm0xPijnoOM/17O/98prb+ImKpcqPhS3XdvAb7ADv9XnEKd5Nj
 kXhhFUUwH9/8PbtXjTpDtyqVSRmAUelXWSvHhKdd73BiHd2SLlAYETo2UKbXV95EgKnI
 QBq3YfrlzljMPPm48p48csSGofbrDW1wausgW/SiqBwWbVowWDzgHhKgaYFQOIoaTSA3
 GfNQ6ipOSireylivkZC0mQd+Rk0VZeeA8QCTGSmHCMzdiiN2YV5srJCq9A5UlBus5ucH
 wEVsqc39zgkav1PJ5EfVWbeBEOp+apriCr/yfzIMDQ/fEEfeyyAnlCBSmBa3wmcBkYnG eQ== 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3ntpem2eku-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Feb 2023 08:04:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EHOmtkWVqd3DqljwI1bp+o+/yHzorLiFVXMttct60wodBRwoEx2CqlpCA5LiY7Xv1NXpAVvLC9r0k+FC9okxLiK8uX2AGojOQoz6GtU8xTc/FjmXdvSiPz1p9wWqDaVuNECd2phHX5iBriZVpFrwHiOu2339KOT/mPmVsvKF5sR3EAo/MCIWTdXi/tNtQz03+qLlTbldeaw7Qz94LablDCt0y9rRiNermN/h/+BWjqAzGIVhmUKohHencZZF7GbZN415tx3cb2ALlKooPBv2csTnzu2yfMV+Efey3wmuTNrduD6qrIQ8dAoUDD4VY+Fs5DbgRDSTfljdEu8/cdZ05g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WxAYs9bS8/HSgrA3i/kDScYLRCWEOVJNBXev+Jy5ws8=;
 b=mYHUsvLAKIbkDk8m1JE0Pz9fBvRswUsK1JSuf2tHrIanMMvmcU5YlIlCZreAJTOZ99FAAo8fkQh7YYJJ/axfjCezqxsd+v2qFbY1OssdEfdaBiAEpTwDv73yFxVay2wm/85ocsSaoi/5iv+eDgPu8KKggx+jyeLFVHtvm4LWQF2ewru2yAH7zDmCC+HaXiU7VorlScoRAJscPqyl+xmtoZAyGyaMuvBiJErxza85IuX8XNtzsk/Os9gCpnI28ib8totrpBuUk2X7GOPtfPSkSpxk2A8OcNd1QBgyZSbkTSU+Ad8MA15+N0wMMZqNh+r64TcIFEgkBe9h5+inC3okkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from MW5PR11MB5764.namprd11.prod.outlook.com (2603:10b6:303:197::8)
 by SJ0PR11MB5149.namprd11.prod.outlook.com (2603:10b6:a03:2d1::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.21; Tue, 21 Feb
 2023 08:04:22 +0000
Received: from MW5PR11MB5764.namprd11.prod.outlook.com
 ([fe80::7709:2bed:5653:b4d1]) by MW5PR11MB5764.namprd11.prod.outlook.com
 ([fe80::7709:2bed:5653:b4d1%4]) with mapi id 15.20.6111.021; Tue, 21 Feb 2023
 08:04:22 +0000
Subject: Re: BCM54220: After the BCM54220 closes the auto-negotiation, the
 configuration forces the 1000M network port to be linked down all the time.
To:     Florian Fainelli <f.fainelli@gmail.com>,
        "bcm-kernel-feedback-list@broadcom.com" 
        <bcm-kernel-feedback-list@broadcom.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <MW5PR11MB5764F9734ACFED2EF390DFF795A19@MW5PR11MB5764.namprd11.prod.outlook.com>
 <ae41658a-ddf9-290d-e674-550372619b8f@gmail.com>
From:   wangxiaolei <xiaolei.wang@windriver.com>
Message-ID: <fcb5c95c-fb81-9a66-bb15-dbae28e4899d@windriver.com>
Date:   Tue, 21 Feb 2023 16:04:16 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <ae41658a-ddf9-290d-e674-550372619b8f@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: BY5PR17CA0063.namprd17.prod.outlook.com
 (2603:10b6:a03:167::40) To MW5PR11MB5764.namprd11.prod.outlook.com
 (2603:10b6:303:197::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW5PR11MB5764:EE_|SJ0PR11MB5149:EE_
X-MS-Office365-Filtering-Correlation-Id: 46ad0c97-2ff6-4ebe-1821-08db13e23dd5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GWH76XxGKrcZH9u5cBXg0jxBjoSoZ8eUh9W7f8+sz74xZ8qBx8oTfGJuHd34/7saXNyxcJJdZHtVvpTTH+gxahZBLyEKPEgUytERZgpHpFHbbzALU5/4UxrYceh6dYWGAtAQXRyT5f6emGqyjqgNUH1Rd3pPvo0LbSEp912fkK1j3CItwzQuUvcjkzNC1Z9iCTuKy2gZhOCrb9ndvzMDzxk/nY/7F7snQaHde7ULmq1H2+izIVolk6MA0wtVdnXPGClGuQukWjixjNt2Ywi/J3ZkWKFArXxJFhATKHnKQvssN9AxqNI9Ne7/HmiKyNLEx5mezdhVf7FGtXViVgNgvIB2JeyReg9aWcRP30iYt40aI3jkSWNAswBamv8Bf4fS6oLKatw9uhOYWd6MOp8iaaZfoiF716vMNQeB9WvWgzfWtHuwMCbhqxxk0qqotIkkOw1m2CzAK9Ugw+n/W3Xx4goIg9Mx0xJn6Q0t0SJxD58VfP4/QLzHUx1dFaA8CCB7x81NhAqp/+ZEUJ2Z3do7Qx3pymGe/zIDRA3F4AaTWOjJKJrPowJZLUfcD7sZiQ9lLwOSbhMlMDFP7C1adF3YX4teAIshb/6/qpo3l/E4n4wZ4ktHY0dznonQ1jH+AKN60qBogkJAwR29gIJSA53LodcudnhqaXCGMSXD2ILvKIZ4pQy9m1CISi8JRNi++6uBlKXbzgwAGkTP2CrZqFslGyTbEaNK+ivh1sNBYditjhgvMbwMMXH1gVZ6mxj4/lb5WHSRaWG86xGvG14JKvy3DONBNH/M87Vom35jQp+nrhM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR11MB5764.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(376002)(396003)(346002)(39850400004)(366004)(451199018)(36756003)(54906003)(110136005)(83380400001)(316002)(6666004)(6486002)(478600001)(966005)(2616005)(53546011)(6506007)(6512007)(186003)(26005)(41300700001)(86362001)(8936002)(2906002)(921005)(5660300002)(7416002)(4326008)(31696002)(66476007)(66556008)(8676002)(38100700002)(66946007)(31686004)(84970400001)(43062005)(43740500002)(45980500001)(357404004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y21FOTMwaW85U3NkSE1PdFU0Yjl6L0hYYXIrVU9uMVVlcE54NDRqdXB4QjNX?=
 =?utf-8?B?K09WSmNneExaOWFkWk04TTd0OTJ4cDIwN0lPK0trNE5KTDJaVjJuUnF3dER5?=
 =?utf-8?B?Vm8zRjhyLzJWWEhrRDlud3BKQ0pKUlFJTmZLeUNSbmJoMUFxUTh1aE9TeWQx?=
 =?utf-8?B?QjNDbTNsam8wTC9pZkFYWlhtMHMrbmpuNUx0YjQzRnh1S0o4MjF4YXR1MTVa?=
 =?utf-8?B?VXRpZ1VmczRUZkIwM2I4aWpsMzkxNlZPK1JENTBnMmg4UEhrU1dwS2pYS0VL?=
 =?utf-8?B?UUozNEhoa2hZMjlZTUlrWTdsU0FCTHBSTlZFWGxGeUhCWkJZVTVWM21CWXFY?=
 =?utf-8?B?NnBadXNpQ2ZkdGRLN1UwME1rRmFKU1hzTWQvS0o5aHo0d2YyTjExSC9hSm1T?=
 =?utf-8?B?RGF3eElhcFoyVEl2TFM5TktoNk9iQmJ4NUROSGQrcHNpa1Y2Qi9rUHVBU0p0?=
 =?utf-8?B?b2NreTJHK3RSOWJUN2F4cFozK1g2b1ZmVEJXMGlMSTRubjJPWlhPakcxM3JZ?=
 =?utf-8?B?S08rblBWWHQ1anZuNEtLMVFLSVRMTlFnTU9oV1lwS2Q4ZWtFTEk1MTBxK1R2?=
 =?utf-8?B?bUJuVDBUWURMSDVNV2ZCakEwMjRpTVNkYVFZQjhvUDVocGNpVmJBOUU4U1Yw?=
 =?utf-8?B?c2pXMzBZZ0xTa3NMa1pDZ1ZrV2JneFErOXkxSXVaVnZmMk01dTZReXNuTWlI?=
 =?utf-8?B?Yks5TXVnMm1NbWY3dUpQVGtNMnE3c3M1ek5jQUYrdTFhR3dDOFF2Y3BHMFNh?=
 =?utf-8?B?WlVUYW53UnQ5NVQvK3A3MjU5REcra3E0VUdzb0NHVFJuRTZ6Zzh0MEZuUzM0?=
 =?utf-8?B?Sno0YWs3SDR4TlVKZmMvQ1p2d3F6ZjJ4QU8zZlVYMWx2ZTlLU1QzMzZCZW5n?=
 =?utf-8?B?Lys1Z2FwNi9zdUhEbWtuTFVlN1M5Wm85anNRUkxzbDk0WFJlUG82dlcwbjJ6?=
 =?utf-8?B?ZmFPT05vOFoyeXJ4N3YremN0NDdNQXJpNzNXdXhGUGFWNGJyU2lkRmVDR0lI?=
 =?utf-8?B?UW5NbEJ5akhnUWJXaHM4NFZuQnA3ZTdxdjd4ZW1IbXZUZ1VKbUhPek42T2or?=
 =?utf-8?B?d1UxMHBVWDNSVXl1eDhHMjdEem1jbE5xSjVObFBVMzd1SU9OU2gvUFEzYk0z?=
 =?utf-8?B?QzY2WHh1ZlpHdHhlUXo4M3pzL3BmSUg5QVpuazFxczBlVWRWVzYvNWFPdUE5?=
 =?utf-8?B?bk15dlJxbW9TUTBuTmwwU2JTR1h3cExvNHp5TGViUkZEZFEralN6UTRpMWk5?=
 =?utf-8?B?ak5LN2QwSWhmQldyUW5uQjUzdWJaYUpNNXViNjRENWNBdldyWlBYL2dGQ1pI?=
 =?utf-8?B?MllNY3phTEpMZndUVURueW1uQXFxd2loRXBDN3RGZ21TK1U4SmtDRmMzTU9k?=
 =?utf-8?B?TzFnMjF1N1pycTJHNi9FK052L1hYSWxGNy9BQ05Ebnd3UGhBME1vRm42Zlds?=
 =?utf-8?B?MlhSR2lqLzlVNzVFQW1YUHNpVmF6VDZlV0lrQVRUV3Nrd1dsbTZrWUJtSldI?=
 =?utf-8?B?cTRya3RWWkRGcVhDWjg1ekdqZEdSdjU5eUhjRFZlQUt5cS9veDhaNU1hSE5i?=
 =?utf-8?B?N1U0UjBkWjk4Y1hXc3NQT05RV285ZzlJSURlaEl6U0FHOUd4NTA1UG1UMXlH?=
 =?utf-8?B?bTNOY2xwYmVmMUNqbk1NUWdsbEw5dExNK3RQK1drSGRBMVVRbUxreUN4R2VV?=
 =?utf-8?B?aVFFNVdmd0xleU9EdGN4am1NMGt6dnRrVk96c2djZ1ZKczFEMHBhelliWURv?=
 =?utf-8?B?a2JEbzBVems4Z05WMEdzNjhhVm43WTRMN0NEejQ0Y2FKVllCZkZ1Ti9hMUxJ?=
 =?utf-8?B?cGhGOTZ4Sk85Rkozak1iNWlGRGxuQXlyVnhJQnc3MjY1cVZlb0hPdlNhQzVm?=
 =?utf-8?B?c3JiVWVRdFZ2US95VlZYUU9UWHRDQWhqQjNHNEN3L2dMc0Q5TWxrTEZTU1lo?=
 =?utf-8?B?d3FrN0NEdmxDWGRadWh3MG1ENG9LRXJSa2tZUDVQTUFRdTNlWXg2Vmx0aVdC?=
 =?utf-8?B?OXVGYmFPT1lFQ1plY0VGaW9MTjIwZzF2elVhQ2VvRG83aEhUWmozenp6Q0xB?=
 =?utf-8?B?dXRQZm9WWXpaWTVxVjFZcWF0NHhUZXk1S255V2dOOUI2dFowZi9IeGxYcXBR?=
 =?utf-8?B?RUMrbEhMWGdCUTBoNERkTVZDSXpUZDREQ1RiOFBKTWd1dFYwVStCd2JTbVBn?=
 =?utf-8?B?a3c9PQ==?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46ad0c97-2ff6-4ebe-1821-08db13e23dd5
X-MS-Exchange-CrossTenant-AuthSource: MW5PR11MB5764.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2023 08:04:22.5143
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IB5t7Sno4mJfZipRW5AyZAsrtLTwdXK2L1XESLFqZZEHSjqODnzRceTuYxQe3od54/1HEIuC8cr5OL5UkaE5Zu6QMu7uVKV1hxk4JIqzYGc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5149
X-Proofpoint-ORIG-GUID: WWQ4dzNtsejusXHHz9e53DFUCGc4GwuR
X-Proofpoint-GUID: WWQ4dzNtsejusXHHz9e53DFUCGc4GwuR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-21_04,2023-02-20_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 lowpriorityscore=0 priorityscore=1501 suspectscore=0 mlxlogscore=999
 bulkscore=0 spamscore=0 malwarescore=0 impostorscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302210069
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2/18/23 1:13 AM, Florian Fainelli wrote:
> CAUTION: This email comes from a non Wind River email account!
> Do not click links or open attachments unless you recognize the sender 
> and know the content is safe.
>
> On 2/17/23 00:06, Wang, Xiaolei wrote:
>> hi
>>
>>      When I use the nxp-imx7 board, eth0 is connected to the PC, eth0 is
>> turned off the auto-negotiation mode, and the configuration is forced to
>> 10M, 100M, 1000M. When configured to force 1000M，
>>      The link status of phy status reg(0x1) is always 0, and the chip of
>> phy is BCM54220, but I did not find the relevant datasheet on BCM
>> official website, does anyone have any suggestions or the datasheet of
>> BCM54220?
>
> I don't have access to a system with a BCM54220 but can look at the
> datasheet, could you provide the full output of mii-diag in both cases?
In auto-negotiation mode: normal Link Up, dump of registers:

Read: reg0, 0x1140
Read: reg1, 0x796d
Read: reg2, 0x600d
Read: reg3, 0x8589
Read: reg4, 0x05e1
Read: reg5, 0xc5e1
Read: reg6, 0x006d
Read: reg7, 0x2001
Read: reg8, 0x5bbc
Read: reg9, 0x0200
Read: rega, 0x3800
Read: regb, 0x0000
Read: regc, 0x0000
Read: regd, 0x0000
Read: rege, 0x0000
Read: regf, 0x3000
Read: reg10, 0x0000
Read: reg11, 0x0301
Read: reg12, 0x0000
Read: reg13, 0x0000
Read: reg14, 0x0000
Read: reg15, 0xff1f
Read: reg16, 0x043e
Read: reg17, 0xffff
Read: reg18, 0x8800
Read: reg19, 0x3490
Read: reg1a, 0x0000
Read: reg1b, 0x0000

When auto-negotiation is disabled and configured as forced 1000M mode, 
the register dump:

Read: reg0, 0x0140
Read: reg1, 0x7949
Read: reg2, 0x600d
Read: reg3, 0x8589
Read: reg4, 0x0401
Read: reg5, 0x0000
Read: reg6, 0x0064
Read: reg7, 0x2001
Read: reg8, 0x0000
Read: reg9, 0x0200
Read: rega, 0x0000
Read: regb, 0x0000
Read: regc, 0x0000
Read: regd, 0x0000
Read: rege, 0x0000
Read: regf, 0x3000
Read: reg10, 0x0000
Read: reg11, 0x0000
Read: reg12, 0x0000
Read: reg13, 0x0000
Read: reg14, 0x0000
Read: reg15, 0x0700
Read: reg16, 0x0006
Read: reg17, 0xffff
Read: reg18, 0x8000
Read: reg19, 0x051d
Read: reg1a, 0x0000
Read: reg1b, 0x0000
> What do the PC report as far as link partner advertisement goes etc.?
The other end of the port is also in the link down state.
>
> You are using a twister pair cable to connect your two systems?

I am using copper mode.

And I found that the AR8031 PHY also has this problem. In the case of 
auto-negotiation, 1000M can be negotiated. When auto-negotiation is 
turned off, 10M and 100M can be Link Up, but 1000M can also be Link 
Down. I read the AR8031 manual https://pdf1. 
alldatasheet.com/datasheet-pdf/view/1132454/ETC2/AR8035.html, there is 
only such a statement "If auto-negotiation is disabled, a 10 BASE-Te or 
100 BASE-TX can be manually selected using the IEEE MII registers .”

thanks

xiaolei

> -- 
> Florian
>
