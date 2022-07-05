Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47407567106
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 16:28:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232908AbiGEO2u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 10:28:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232918AbiGEO2q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 10:28:46 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33BA6113E;
        Tue,  5 Jul 2022 07:28:45 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 265CZrC8012246;
        Tue, 5 Jul 2022 14:28:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=5ZhDRV/CeFr9CR7TsuNpYv/9xcXYD+pTVn4G5HcPa6Y=;
 b=oAzCmuRYiIECbS6Ik6uvUllkcKvwePtsUKu8QsHvwz6u4n1c5NN3RnjYgbjvQmGloBdB
 997LaOFXCo21bHyTJBCCp6w6kKT5UyCUSDxjU0PGJesgpplKpQioox2rDEOxqG596ZHV
 t29m8Pmsfe+9QhssuUqKXB2zEs3CfZNRHkJwxKeCwSf1hbBw/Pi2nCPwahaKIwX8kRIS
 j4iBHMbJ/iXpbVTDdbu0azA9z6jZ+T0w5mJUYVx8V8GHMU8jGsEJPQv2emuSTyBDT0ig
 U4QVNCkdY0BC/iwuAQ1iOMYCYjGR53jdVMsqJfrDt5aG2yd2zcnub2Wj1KiNw1E1o5N1 2g== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3h2eju67be-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Jul 2022 14:28:25 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 265EFFoR010111;
        Tue, 5 Jul 2022 14:28:25 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2176.outbound.protection.outlook.com [104.47.57.176])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3h2cf2ecr3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Jul 2022 14:28:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=COZZkhWb/X26kHh20NOtjxYRYcETFj2S3BU8BGLSgRpBgJyFqbYoSF64pcXmmvwx8loCYyFmiwMepwxwuiy9WEjmfw243m0xmaob6nI8uu+tnKVrph2Q2VHRfWPfuuXEdXyZ4wOzLOV84umpY9pmasBFndpk8/zI/dBF4PRCxmHBQFceVLxiZoIK6Zw78LKM8tFX7fhrCSZATQsOjTw2FWh6AVtD+4eaOMZY6OB7SDHtTGv2sNDypsl96GUxf50EMh4KJ+WMoSHQLjtFNNxZz7+75CoJyuskiJZlmJ7a0vZbmSmcgSPRviqRYMJBDYoTgPhWIiUJCY85ND8AXAQCag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5ZhDRV/CeFr9CR7TsuNpYv/9xcXYD+pTVn4G5HcPa6Y=;
 b=KBVlnZF6qufyUQu3VActYro8haR+U5ORMcGP4RYeeBJ9bnQg6QU13djvR84SU3Y1OTPzwx6B5bKeCKVsuqyUnLqSNf48TQkYw/5t+JpYdh2soK8wVfVmTPMUW4mVGImGqt/287/MlpDDj3NROYrH2JTmvc6cpkdK2BkkweEUWSut+020M684jNFPO81L/CPi+HsZCqqptoYX3bRCG0QR36F6GlZUVyTGqhFokXPLRy3YSwu++9U0AoZu3FZL4GhzrA6rirHRZNj5CmuWnuhKVVXR0BHAXFCpmYXOrq5sGQekKdKr7w2ucvalYuY5UEOjpbv1mXCIbBLIgPQl5vfvZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5ZhDRV/CeFr9CR7TsuNpYv/9xcXYD+pTVn4G5HcPa6Y=;
 b=RoBLzK+AiVlD4TsndjMnFbfliMy/w/rjRHL67IrkFGJMJ0d6MWhFLYeLRtDKJDKfYlUgJnuHFm8Db/p+L9dSt5ne0qX1Wcd1KCGbj0AN4HyiNs48uQxZFd0uHByCsmiDcRXWyAF7vMmrnIxL9ZiiQOzlREsc0z12Gc/LkJ0Kls0=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BN6PR10MB1748.namprd10.prod.outlook.com (2603:10b6:405:9::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Tue, 5 Jul
 2022 14:28:23 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b842:a301:806d:231e]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b842:a301:806d:231e%8]) with mapi id 15.20.5395.022; Tue, 5 Jul 2022
 14:28:23 +0000
Message-ID: <3145cfaf-7b3b-826f-0519-5f03a72462b0@oracle.com>
Date:   Tue, 5 Jul 2022 15:28:12 +0100
Subject: Re: [PATCH V1 vfio 06/11] vfio: Introduce the DMA logging feature
 support
Content-Language: en-US
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     kbuild-all@lists.01.org, saeedm@nvidia.com, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, kevin.tian@intel.com,
        leonro@nvidia.com, maorg@nvidia.com, cohuck@redhat.com,
        kernel test robot <lkp@intel.com>, jgg@nvidia.com,
        alex.williamson@redhat.com
References: <20220705102740.29337-7-yishaih@nvidia.com>
 <202207052209.x00Iykkp-lkp@intel.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <202207052209.x00Iykkp-lkp@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM8P251CA0015.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:21b::20) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 69862977-71d2-4763-ca0c-08da5e929d88
X-MS-TrafficTypeDiagnostic: BN6PR10MB1748:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I1J5Z6kk4iEFi/Rfmt9DNAVadY98yvtqxBCMw8+al/39HFYqWRgxlMQnbs+Wv2ZDLFY6qP5DzwRg/rWlg8bZjiadU7IN+mdg8XgKfTB3uOr/KGE+YPuYAq7BxfEPW+DArLxS4SUC2EP3S7IPnkkHBFPQL2PCv6ia9feN/WWtXe/F/O58NAn4RZRLb36nKl4lMnxUs3jq5ikvlrVP27c5aTl2fXqFq2JO5MtX73We/8FqKbB80osxuTm8laYWEY2gHX/vZJO9P3ZiORs7nPwStf9b7J5mWgUr/v2Uin4XDbQgyEWnaBX5AA5BXWCFeB7sYY51uu0Vu71GeA/CVn8wD/nkBP+aepk3zZNXjTPso9IKD7YdYyEGExIXkPG4xsS/rqiKS/iNxZSfy6ABTPR4/Mu1ME7DKVdUrcSg9UUM3obutag8esuBrnbZTUQVgEr5u9ztUW186FRIDQejrwe3PNwxrmpuWBTmw6L2cSbatpbJ69COtgqfPSdKRojibcwvdukz6F5S8+ua2XFf6LygG2CplZ0jXHYoQphfS7zq3+ChaO6bXrRSNq8iclxPfIqpABr5gNNDobf/YkHRPnT3BdT1DJuFXyy0oieVJhQVy/3t2bD+1gTUPchQ38RdgWcsFe4cMlb/WwCTcIwm80cPEMXPx3yyga+M9EXXiRCc6NXQNmYc2kxOYjj9sEKMGWZcFwYnyCG+AbJ0pmh/qMBYLZvYa1V3JKOKcwfoyx5BABD1zn4fsEKZhL6TL+PZeG7wX4vs8zWsG0D9DM89BPYym8Pm9JwA/xDP9AbYaUnfbdhzQcarV+7zEvWP8NAM1MuqXIOZFqZtu0XrgcDwxCGBrQGd8KLoAWo95hs9eUfme1hG53DUrys0/SxvBFaNQfRi
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(346002)(396003)(366004)(376002)(39860400002)(66556008)(66476007)(66946007)(41300700001)(6666004)(8676002)(53546011)(6506007)(38100700002)(4326008)(186003)(86362001)(8936002)(36756003)(5660300002)(2616005)(31696002)(7416002)(316002)(31686004)(6512007)(2906002)(966005)(6486002)(478600001)(26005)(83380400001)(6916009)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZGVyd0h4YzVvRHhnbUZ2ZDdnaStsaVBXczhGa095M1hsbGZvWFhXODNDOTFl?=
 =?utf-8?B?NmZEK1gxOGNDNHpoNlJxNnMrd3R1TklQeUFWSDdCZ3NQSncwYjFZNVg2dnlW?=
 =?utf-8?B?YmNZa2c1YTJmZXJ2MDRJZFN2M29xSmd0WEFCaGE1Tm5KTVJsbWFKTHhreUk1?=
 =?utf-8?B?eStVVXRQMmpnUEg5R0xXQytaSldmcitSbEtsaEE4QTZQK1RWdGhiRFEvaHhT?=
 =?utf-8?B?ejVER0VlNDc2V1FWcmxZK1h0VlFRQ2lMQStTWEFObjNqTUliZ3dmN0kwQ3ps?=
 =?utf-8?B?MWwxTEFMcmFJeHN4RjBiTkZqVkNxM1ltSmthcVR3QXRlaWtyaGNEQzFWcTJD?=
 =?utf-8?B?ZUhRZ05pWkUzeUNtUmxRWE5ZM1pWckFSNnl5dUI4V2dZTHRBeXREUEl2a2F3?=
 =?utf-8?B?WHdETTg5Slo3Uk9SenE3VHBNNEF3ZGNvVWJtbDV4UkpWYWE0RmpvQ2JWNjI2?=
 =?utf-8?B?Z3M1Qmh4Lyt0a2R3ZFVVRGVBWlhjT0lRSE9kQWNkRUZWNThoanIySkN1YjdW?=
 =?utf-8?B?NXFsOVUxQTh0SjhBR0dZMk01Yi9PTHRjUEpWSmRldk1rQUMyb0VzSEd1SEZj?=
 =?utf-8?B?a2xnbGl4N2x0cTVJczVKQWthVGUrMW1aei9jRnlWekZVWEhPbWJsQWliWGY4?=
 =?utf-8?B?KzVqK2xlRUxWYXJsZnFqUU1uQkM4b0dPcmJmUzBWdFFDTFZ3eXoyZis2SUY1?=
 =?utf-8?B?blBweVlXWGNRRlgwdDd1N2dYa0o0K0pCRXNtd1cvTUNVQlR1ZzB0SEtoSGY2?=
 =?utf-8?B?ZHJDSFdobytnd2ZWSFRXL1BndUFWckxWQzlsNU5mVGxPMzVrekhCQVVVU3J3?=
 =?utf-8?B?MzNVc2FsK2hBd0R6VU4xTWEveVRmRmlBbnFRa2gxSUZRUzMwNWQzNzJyYjMy?=
 =?utf-8?B?YW5sSVdEZjdvbDRRRGNIanY5WmNLSTB1S2JYYWZnTjdXZW9RRXRjSXlXVWVY?=
 =?utf-8?B?UFFqbzVDTUJzQi9ySW93eHhnQVd4WS9oMDFwN1J6SVJIeng3ZENxQTNJeE9x?=
 =?utf-8?B?ano3ZEkycDU1TDNBbS92eGFSQ1V3Rm9vcEJPdjZ3dDM3NGFPVStZOUUxSFA3?=
 =?utf-8?B?bTdEUmR4T2hZOUVINUdhOXAreTJ6c053cWJ4dklXeURBSWdFRndhMVpxaTVa?=
 =?utf-8?B?eW9jQlJyemhMd25iSzR0OXh3NldCbTVEYzB3eG9JUWo4T21PSXdoRG0yYytJ?=
 =?utf-8?B?VVpBRWMyOWFlaGFRY0JvZGd2S2pmOW1JWUd2eWgyeStkYi85dGpsN3BLdlVr?=
 =?utf-8?B?dk1mRklQaWl6SEZxTG1xY2M5b0JOa2JNMkYvY3dpYTM1V2ZuaXBqN0JUMW1X?=
 =?utf-8?B?YmxDanVVRFp0ZDBoMCs2RE9OOWY4eXptY01ZN1ZhZkVESDB5ei9MYThDdUZy?=
 =?utf-8?B?Z1pDTXZXNEVTTkg0ZEszTFlkQlJWRFJXTGcvWEx3SkVGUVZDTmdzeW9sNmx3?=
 =?utf-8?B?dXJwa0FTVXhBeWFzSW1UK1FkenF0VVlPaUExYXJ4cE8rU1Ztdk1QZ1VBUXhr?=
 =?utf-8?B?ZU9TZkNDeThPa2FLTVE2REM1S3AwRzQ5ZTJPK3pOL3F3OE9KRnJNUjg1UXFu?=
 =?utf-8?B?dzJMSVFXbGdlVUpSVFBkSDZtOW1wM2t0TzU2TGlWOVNEWWVXY0FQUTBJUFRs?=
 =?utf-8?B?S1MwdFRHTE8xaG0xKzRGZnFhQ1N0MVdPSnM5Vk5sVXd1VVpaUUdJNFpTdlp1?=
 =?utf-8?B?ck5zWVQ1MitwS29SckFvYiszakVrOWdHS2JFODFYV2U1TTg3aVRyT0JXOCts?=
 =?utf-8?B?Znl5TzIyZER0eUY1NkhoeVhMMVNZUFBxb1VmV0w3emRrbXdQMmllWThlNXJs?=
 =?utf-8?B?UzdtMGpTdExvUU41WXcvM3BUK3AvN2EyTmc0ZkRsZmdGZTljaUxyRU5VT0kr?=
 =?utf-8?B?TnBuWmFReEFyazJQV2VlbHd3SFVuQUhsUFA4VmRNU1N3UGtTOXQvbFhOUEt6?=
 =?utf-8?B?UnpzMTJRWGRXTklUMm5ZWGZTTGRBUTNNdHZ0VFVSMFJBemxTT0sxb1pLQ3Vx?=
 =?utf-8?B?OVUwaW0xeng4Z3NwdS93eVFKWGNvaFVTWk5KM0F6d1NqUHlFSHBEL3hFK3lY?=
 =?utf-8?B?azExZDUzWm5mYnBTQ1lKUUxhbktnR0FESkJhKzdjM2xta1pBdnhONE54WE9Y?=
 =?utf-8?B?ZTZqNjhpNmp0cDBnSlBtUFk0U0hzU2pzV1c0dFdMQjBKTUNGRHVuQkZhVUZN?=
 =?utf-8?B?K3c9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69862977-71d2-4763-ca0c-08da5e929d88
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jul 2022 14:28:23.1163
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0p4PBjL4x8UE4AOIJ9XX+oMK3+VvqcNGYays5+4cjfQcrP0cxSvkvGhoWQFFzIjpcFCn8gx6u8lQp42lNKC268aVwTI6JjrjBe+y88eHczo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR10MB1748
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-07-05_10:2022-06-28,2022-07-05 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 adultscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2207050062
X-Proofpoint-GUID: xPvKUuTPF0T7anA-h1dEDGPN2bPGukWd
X-Proofpoint-ORIG-GUID: xPvKUuTPF0T7anA-h1dEDGPN2bPGukWd
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/5/22 15:11, kernel test robot wrote:
> Hi Yishai,
> 
> I love your patch! Yet something to improve:
> 
> [auto build test ERROR on awilliam-vfio/next]
> [also build test ERROR on next-20220705]
> [cannot apply to linus/master v5.19-rc5]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Yishai-Hadas/Add-device-DMA-logging-support-for-mlx5-driver/20220705-183119
> base:   https://github.com/awilliam/linux-vfio.git next
> config: openrisc-randconfig-r036-20220703 (https://download.01.org/0day-ci/archive/20220705/202207052209.x00Iykkp-lkp@intel.com/config)
> compiler: or1k-linux-gcc (GCC) 11.3.0
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # https://github.com/intel-lab-lkp/linux/commit/12299d61a80f6adf70a2e76b8f4721f3b7bcd95a
>         git remote add linux-review https://github.com/intel-lab-lkp/linux
>         git fetch --no-tags linux-review Yishai-Hadas/Add-device-DMA-logging-support-for-mlx5-driver/20220705-183119
>         git checkout 12299d61a80f6adf70a2e76b8f4721f3b7bcd95a
>         # save the config file
>         mkdir build_dir && cp config build_dir/.config
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0 make.cross W=1 O=build_dir ARCH=openrisc SHELL=/bin/bash
> 
> If you fix the issue, kindly add following tag where applicable
> Reported-by: kernel test robot <lkp@intel.com>
> 
> All errors (new ones prefixed by >>):
> 
>    or1k-linux-ld: certs/system_keyring.o: in function `load_system_certificate_list':
>    system_keyring.c:(.init.text+0xc0): undefined reference to `x509_load_certificate_list'
>    system_keyring.c:(.init.text+0xc0): relocation truncated to fit: R_OR1K_INSN_REL_26 against undefined symbol `x509_load_certificate_list'
>    or1k-linux-ld: or1k-linux-ld: DWARF error: could not find abbrev number 36676422
>    drivers/vfio/vfio_main.o: in function `vfio_ioctl_device_feature_logging_start':
>    vfio_main.c:(.text+0x18c8): undefined reference to `interval_tree_iter_first'
>    vfio_main.c:(.text+0x18c8): relocation truncated to fit: R_OR1K_INSN_REL_26 against undefined symbol `interval_tree_iter_first'
>>> or1k-linux-ld: vfio_main.c:(.text+0x18e4): undefined reference to `interval_tree_insert'
>    vfio_main.c:(.text+0x18e4): relocation truncated to fit: R_OR1K_INSN_REL_26 against undefined symbol `interval_tree_insert'
> 

Sounds like this needs:

	select INTERVAL_TREE

in drivers/vfio/pci/Kconfig VFIO_PCI_CORE
