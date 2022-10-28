Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0420261137B
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 15:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231389AbiJ1Nq4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 09:46:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230379AbiJ1Nqh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 09:46:37 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBD441C114A;
        Fri, 28 Oct 2022 06:45:34 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29SBNo6P018953;
        Fri, 28 Oct 2022 13:44:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=corp-2022-7-12;
 bh=RQqcyoE/SAVprigXGWr01L3rDFRoZ/ZocOD+zw6+8/4=;
 b=f2S2rzkT+zWDZ5zGfvkeuHq4RwlIN1JqvRFzbiM6DZnW8PnYLthF3Q3mImWT0gyj5e6R
 v47hb9WoL83ZQ751GF+6wGda/sjhkK3FeLuf5miVoKBGQmssvo0TOWNe1CRU0ztyNLWI
 ht7J/Hce07gxAVTCDrhGeF/vGV5OpLR54kfUX3eE9kjUYkZsRUih9JoOLdQf/WBXWZAi
 nLnyxI2uUEybtUPZqx3wWkdI+qI9t96Xh+hr783HfyxxFIRrBI3xcueVYcQgLn69JGGY
 pEzXr/ynQ/HuvWHqMgLFUTYBGdYPSbXI5xg7NrbXLi8vbrvWptpK3jO1Ig7YVqT9OQ1F EA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kfax7vtmy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Oct 2022 13:44:55 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29SB1LoP017532;
        Fri, 28 Oct 2022 13:44:54 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kfaghka8m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Oct 2022 13:44:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gE4UzjFWjHEMeAJHz8Jd8Lidr16u2tx35oPRsHfMr0oDozN7wEJbiYHjZrZWxh24ZMk1NR9B1V9EXs7Z6c9UTGzeUDHGsCxYF05713U7oXiqBvFvORLrSMfdaNkeoVyDE3QMboJILBwRY/tg6jPdHataSEsP9uqjd7wOl1KfIW3N3G78Pmkce/sktN4Oy0zXjgi4LSOSW6mSGVqJtcNvfh4Nl6Gfnt9ScoBEufTP/0rh9iTpGGXTgHPSXVOUKGs5NLtUIff6v7mwmo7l91cpIBot1XzhqkFlbNk4Np4ugYp7oAqclqhGKULBeBFFpxbCZC+7k1rYzYPHGeoz/3iskQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RQqcyoE/SAVprigXGWr01L3rDFRoZ/ZocOD+zw6+8/4=;
 b=ICRAGFG9FEIhk1srg91fRY+nOGAtpcuWPKIUSOdMu8VQtVzafK7Nm0KcfFnmv9ll2KINVVPu9dBWiOCX+lsNDy1DmzbfnnxGJPW9qorZ6nfIujBBEn2vFgUkgbGbFBEhUoN6pVuaKjK3zvhutgZna2xcAGrk0Ese0BERQ9ESnllO1V5PsjjmDLcJE8MqLE69G4g/i0HikwmTF3y7L8BQqsnmRvONVbNvLNUxMmhdhcoOtQMEhrtFzIseH7b66VBBK3InnI1sMr6mkkrTjRbyuASBDWUwZ1jRn1ZTpiTh98wflsYnV6UoZrHzQm74HGJpK0V+rUXbyP4WCjwRmtBjIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RQqcyoE/SAVprigXGWr01L3rDFRoZ/ZocOD+zw6+8/4=;
 b=orLUjPNcAxCJKaetsw02n5SjdBMavyixBwc2fXx1dbXgeXQlPXEk5LPeSS67Bqp1mew/XScwNykVT0GHm4eWjbSSeTvEKAF0BHMkq7q06osDwX/6d2m3ZIKuZnsOR8SaUqohPyVIu2dT7t91Smec8vxKMLEEr6V2PGW1uDo01nM=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by DM4PR10MB6207.namprd10.prod.outlook.com
 (2603:10b6:8:8c::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28; Fri, 28 Oct
 2022 13:44:52 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::3809:e335:4589:331e]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::3809:e335:4589:331e%7]) with mapi id 15.20.5769.015; Fri, 28 Oct 2022
 13:44:52 +0000
Date:   Fri, 28 Oct 2022 16:44:40 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Bagas Sanjaya <bagasdotme@gmail.com>
Cc:     =?utf-8?B?0L3QsNCx?= <nabijaczleweli@nabijaczleweli.xyz>,
        Jonathan Corbet <corbet@lwn.net>,
        Federico Vaga <federico.vaga@vaga.pv.it>,
        Alex Shi <alexs@kernel.org>,
        Yanteng Si <siyanteng@loongson.cn>,
        Hu Haowen <src.res@email.cn>,
        Jean-Paul Roubelat <jpr@f6fbb.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub =?utf-8?B?S2ljacWEc2tp?= <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-doc-tw-discuss@lists.sourceforge.net,
        linux-hams@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 02/15] hamradio: yam: remove YAM_MAGIC
Message-ID: <Y1vcyJKhZDA2/xlR@kadam>
References: <9a453437b5c3b4b1887c1bd84455b0cc3d1c40b2.1666822928.git.nabijaczleweli@nabijaczleweli.xyz>
 <e12d4648a757b613a2ecf09886116900fba1c154.1666822928.git.nabijaczleweli@nabijaczleweli.xyz>
 <4e7726a2-a631-642f-e8f5-c97ff3fc689f@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4e7726a2-a631-642f-e8f5-c97ff3fc689f@gmail.com>
X-ClientProxiedBy: JN2P275CA0006.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:3::18)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2365:EE_|DM4PR10MB6207:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e9e7937-02de-4e78-84f7-08dab8ea967b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tPI9Ch5RKAuHrW7EhrByWWY6PKyD3zuUQpHAp7HdtTbU+meH9JtkHWuX8Wu1z+DJciD2wwjN8yM1NNGjY0kt1UiNgr3RgtAP7Gh/FEl8Mi/pGJyB2FpqN9AZyBsDwOTbgxVM8JY++X7xOQajOof/tghhNxciTM42Bv2Vmp6K7fXqJptRbWIHSni31Tu+gag7tShGWokamNCa89L2+zPEJPqwn7yfJNCrYXrNKmicN3zxQtLILssEcK7flc4ckJ5mcHu5SNeiU7kfOztpO9KTpqCEa9v7vVcBGXJjSy7g8brjSYKWHpDPgRUPt0piKtPZp1uWTyYyGHpd85YuAKxOPEDd1G1MJ4J/16FjhOxw1RCZReRIF7LWkUszQBd+k+DuTg9zD6S6q2d0E9N1WDtlp1VBCe7va73rvSfYY0AJ4vO8cVW/2EzPF1b9vKFeW2YjuouJXCMIAlbr4v0J06iOL3OnpkqSisJpA4AsRnV1gUhB6B7KXCEAtYCQjqOcAGYCaEhO/kdflEP+TD4Pp+IIrEiGQaUKBTRDmo2JitXJqkjsyMsc8ilSbJXr01Q4YorGk46O2A4RPhEDVNLvEieJf4zsiFoCRD960RmlxeF00/UTjNoiH0jbmxtVBcaAKSxpINGV22B0VUTgZEnXgcBYja+Nzt2ueeo38rL0uMOaa0BsZjQKzyLGk1yUNe9sEou7xKUmmF8gCkgJseg/XBzbOldxVvtZtx0jxkJ1wSOKFOk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(366004)(396003)(376002)(346002)(136003)(39860400002)(451199015)(26005)(478600001)(66476007)(83380400001)(6506007)(186003)(6512007)(7416002)(6666004)(9686003)(2906002)(44832011)(53546011)(54906003)(6916009)(8936002)(66946007)(33716001)(4326008)(66556008)(6486002)(5660300002)(41300700001)(4744005)(8676002)(316002)(966005)(86362001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WURaZU9zeWJqMnJzOS8xS1hUM1Q4bVBjd3NGZlRoblZ3SE9oTkpxREFvbWpM?=
 =?utf-8?B?TGwvQm5oTEdFRWtYWS85R3dBZzgyL1JzSWxPM3EwUjB6SSthWGRFTDArT1JR?=
 =?utf-8?B?T1ozdUJ1MVJoU1RyRDVwOHBvUll5MFB0V3FRdlJia1NZcExpQThjOGpzaUFa?=
 =?utf-8?B?OTA3NFBUQkpoZEE5TU1meTZkYXB3ZG9KSkI0NXEzNTRMeXNOYWpWVjNEZTIx?=
 =?utf-8?B?UVJ5TXc3OE0zV0RkbmozZURzMFprU1JQckpuNVBuNkNHNkZwT1ZNYkRMa091?=
 =?utf-8?B?UTNEdVp4TEpmb0NzZTBVeDVrRzU1c2hPWXFvbXc3OU5XNnVLT2VLRmFNQkF2?=
 =?utf-8?B?V1BIc0tYejdXaE1BbmJMMXZITlhsYTdRWE4zMER5TjhpNStUTGc1bnRta3hN?=
 =?utf-8?B?TWdwa1BWR1U2bGU4OU12MFgwcWZMOUxhMzczc2pzaGV3bThQdG9jTlQ1VEI1?=
 =?utf-8?B?WThHdUFWZm1LM3VRVHZ1THpaRWM4OFkvMzdaU0lFWjJlTzFBUDVDYmF0ZFh2?=
 =?utf-8?B?aGZPYS9tTi93Z2RjNWM2UzVZRElYWU1YaDFSMmQzVEdNRXVBOC9QOHUwaHdi?=
 =?utf-8?B?VWliRWR4VzdBYUJ1M0g3emh0ZXRncjBMdUFENTVPdVYzL05XQUlaQWliSVp2?=
 =?utf-8?B?NkFzVTNNRHcwT21Kc0J1WTRrWDhhTjhLV1UyS0ZEdDlURWY4YkFDb255dmNy?=
 =?utf-8?B?UGpjZ2VMVitIeHdNWFhXSzlUUmowWEd5QTBjaksyeW1wUFd1a1EzRTFIaWQr?=
 =?utf-8?B?Zk9VSG83S1U1d1dwT2xJUk1oSHNiWVBua1FIN1ZFVjJBVEFBMllpMUNCS2NY?=
 =?utf-8?B?UVIxWGVRKytHd1lCc1RnQmdKU1VUaDJuTTdDQ1Erd3JkTGY4bDBQVG5pNThO?=
 =?utf-8?B?WE5FZjMvZHhDUlZ4RVJoa2Q2WG44dUxtZXVWd1pjRE9rYkhwblFkQzVtRm9m?=
 =?utf-8?B?R3M1SUt5T202QXNMTWVNMkdleTFwTHorSko4d2s1UjJONm0yeS85K0lBUkxG?=
 =?utf-8?B?ZlpqaGM0RGJUcnFLWUxQMWZnMVFNdzlONkRML0pkVUp5dWVENFZPdWNIbW5F?=
 =?utf-8?B?UW9WWVd4QXYrc2RaU01aTlE2WnVzMmg2U3hMZmxWeWxwUGMrNTNlYzIvWG5B?=
 =?utf-8?B?ZjJGZTAzMUk3dnlJWFNxRGYyOFJIQnJiclNQM2NJNlJYYkJ1bC80VE4zbVBy?=
 =?utf-8?B?TmxXYjNQVnpub3NDckZ6c0diT3UvY3RMQ1JvUU5PZmVBcGRDaGlaMTZ4MDRX?=
 =?utf-8?B?TUFHYmQwbHBab2RsSWUrR2s2VVB2YmpmMDlwVi9BL2lXSHFRWE1UTzBWWGx0?=
 =?utf-8?B?bGhDVzdLZFJYek15VDduanpGbm8vVkJ6cEUxeXBEcVc0eW40QUVlSkZuMS9O?=
 =?utf-8?B?aFlGOWJoOEFLNktXMmZlZjY5N2k5aDJqL1FkWjNNV1VEN3dIdGQ3VXpPc3lG?=
 =?utf-8?B?Q3JnQ2U0Z25yZ0RTdWxGOU9rajhLNTdua2xHOC9Bc1hBdlZvb0FWVkpwZXVj?=
 =?utf-8?B?eFg1Rzd2WUNDS2grNzhGTjc0R1RhUFdkeWZKd2ZMSkhOY09zOWxmR2V2a2Ju?=
 =?utf-8?B?NVFaQlltVUEvUFQ4Y0VXa05NL05FOUY3dE5pZG5BNlpESXVMeW9SWmlRWnlQ?=
 =?utf-8?B?N2R2Mjlia1V1MnVYSnp4VFFEOTVqV0NhTDBrWEJ4d3pUR3NGWjYzc0hZWkFF?=
 =?utf-8?B?OFZNYmgxRU9PUXFleTVlYUQ3bVVDNTBMZkd5VkVjWFd0dnpRempROG1lL3hJ?=
 =?utf-8?B?ZkhndnhHZjN2OHk5eTJGekt6MEJHK0ZXSkhLeUtvQkRrWWNxb0NIRlh5cDJk?=
 =?utf-8?B?VjBGTmJxY0x4M0Y0b0c0L3hCK2tjNW9wUTEra1Z0b2JvTklzazJJVmVGSE52?=
 =?utf-8?B?ZmY5MnozNXRlRUw2dTRqY0FzU2o2SU1Xd3BteVFMN3B5TXdDZDdBWmVQSENW?=
 =?utf-8?B?L3VUY2JRSmVaNzhhc2dKcHpsc1ZLV2ttVWpGaEo3SjFtZ1cvdjQrWGMwQmJ3?=
 =?utf-8?B?d2Jwc0pBZzZoTUE0dTh5VkJMZDZRTXRZSWJ6RnZuQlQ2MU16M3lmS1NyYWxW?=
 =?utf-8?B?N0xZNnpzSjJCK0hjZFFNSWJnUndLOEo4eUViT3J0RWZ3UEpMblR6UnM2N0Y3?=
 =?utf-8?B?WGdiSERPODdrZUNxUlZkNEFQZ3Z4a0grUVRBTG9KQzZ0L3dzSmtLbWRjTytO?=
 =?utf-8?B?SFE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e9e7937-02de-4e78-84f7-08dab8ea967b
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2022 13:44:52.2412
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DufPNiHNi401HX+KuKMzCjf3C7YoTOkg828EAGFaTdenm+RyZPAA1CSQXQHb/acV6Z03uzPRRUCDuEOBQdTqJ2pkLOC3RlXleLUbapfmnyY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6207
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-28_07,2022-10-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 phishscore=0 mlxlogscore=792 mlxscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2210280085
X-Proofpoint-GUID: ifoJBhXpWV6th8T11eUY_sn3_2AA2Hev
X-Proofpoint-ORIG-GUID: ifoJBhXpWV6th8T11eUY_sn3_2AA2Hev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 28, 2022 at 08:19:51PM +0700, Bagas Sanjaya wrote:
> On 10/27/22 05:42, наб wrote:
> > This is cruft, and we have better debugging tooling nowadays: kill it
> > 
> 
> That "mature phrase" again? Same reply as [1]. Thanks.
> 
> [1]: https://lore.kernel.org/linux-doc/47c2bffb-6bfe-7f5d-0d2d-3cbb99d31019@gmail.com/

This is just a link to your previous email which we just recieved...  :/

regards,
dan carpenter

