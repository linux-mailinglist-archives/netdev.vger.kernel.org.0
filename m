Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EBF15673CC
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 18:05:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230032AbiGEQFx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 12:05:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiGEQFw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 12:05:52 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF85EBD8;
        Tue,  5 Jul 2022 09:05:51 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 265F4dTC003152;
        Tue, 5 Jul 2022 16:05:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=W0iH9Jz2TRSgQBD58g4Kyxzt8T/RztO6Y/bLr98+90g=;
 b=CfQno9CZI2+qm8nX40OEUYt2kqTZjD2NgcnUl0Hk1fx7OG2fwKCKqjSwdFWlhel6vbI0
 1pUS2N1Jv4jvtKrGTB5UsKJ1RPlhoP+SPK9buwfNScjGRBUoBVG6g7ILc8idjJEXo3T8
 I0RCD08TBw/lOdZKLcr9hPTLIhZOlWVKuM0b29zD1fMXzXaVekVDq0YLfFy0wU7m2drW
 a1WC6U6VNBUzPR4BGaDwOy94cGfql3Atyjd1/WYf9GnSeQVM9rQTdsDI6I0LDToBE+z1
 SXOJS8KiQffNXOsMls9JJ1ezEw21hgRlTEx0tDIteTBQMstXwjsncDhrMqQUZHP0trV5 kw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3h2dwapep2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Jul 2022 16:05:43 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 265G4wof035295;
        Tue, 5 Jul 2022 16:05:42 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2041.outbound.protection.outlook.com [104.47.73.41])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3h32mjcyrn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Jul 2022 16:05:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F3OCp3MLxlp7k98+A7RqUhC+RoybhyceRqMbfbYL04QPngwXeTLUP+w8OG8cB2ubZ/rNpWoMFTEUd4ZZb9DrI3dB6lKRuIiThuUc7U5m4GjJXO1EFyJV6uzxRRMLE0UpTLVzpOUjnSxQc0UdNYCcMaXkJjcoct4uPcNQHjW9lHoLta+kP149H7BIidk6hjahwThxFIBfsLY9UmM0eQVDYvahG2eck/xpZAlESvmCRTHqGJimx+iLRy/iPyLN1NtqLFRt05vxOt9TC4lueth6PTrlfSugiiTV6PWNTiryKozEvuU0/2hx9iAmaQArQi5aEPKhoAr7kZ8Uhe57NTCqkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W0iH9Jz2TRSgQBD58g4Kyxzt8T/RztO6Y/bLr98+90g=;
 b=QnLch3gel3bWmCPZTmmeQMKTK/GJnmZ2b0xyQrILYwP9iVHXn8LN4LmB2L2s1OWC4/FNh1D2bw4cnshMlEXd75qC2IQg8fBJxlfSmJUVimWh4/j7rPZMXIve3tTvMwQXyVx6FB4E9E0uz5ykYBENwSg2EzYyha60FAewKYuJ/sOcLE/bpns3WMdbE6e0/Xh1+m8H85Io1Nifnk9Sup+yb0smIB/QD/dPRgoxxOcRIlmCH6dKc6HDB+QB8uZ0DqnUkCxWFyJc0DLGtL25YEfZSbEekqGzPNTvcfx+MEJP6mEqcj4UdLM76Y5VtKYCV9Aut01/b5r2qR/FYIZcoE7dbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W0iH9Jz2TRSgQBD58g4Kyxzt8T/RztO6Y/bLr98+90g=;
 b=qNynDJtdNiwvyao4JxC7pEGrlm0v0XOt9maZ+4+mF0TiR2UBLoNwT3tGSDFx04MHe8IlVw1BVCH8oJqFfWRK46kWiRiRPEhArIrvcW2xPSMQ4AL40wM2XZHl2vn6+eL0sFx9qjyK/PZ7CLVceZnT9Xm8gHW3G512FvUYZ89BM3o=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BY5PR10MB4001.namprd10.prod.outlook.com (2603:10b6:a03:1f9::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Tue, 5 Jul
 2022 16:05:39 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b842:a301:806d:231e]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b842:a301:806d:231e%8]) with mapi id 15.20.5395.022; Tue, 5 Jul 2022
 16:05:39 +0000
Message-ID: <b1a1544e-87e9-2cbe-5fcd-c622a5943424@oracle.com>
Date:   Tue, 5 Jul 2022 17:05:27 +0100
Subject: Re: [PATCH V1 vfio 06/11] vfio: Introduce the DMA logging feature
 support
Content-Language: en-US
From:   Joao Martins <joao.m.martins@oracle.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     kbuild-all@lists.01.org, saeedm@nvidia.com, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, kevin.tian@intel.com,
        leonro@nvidia.com, maorg@nvidia.com, cohuck@redhat.com,
        kernel test robot <lkp@intel.com>, jgg@nvidia.com,
        alex.williamson@redhat.com
References: <20220705102740.29337-7-yishaih@nvidia.com>
 <202207052209.x00Iykkp-lkp@intel.com>
 <3145cfaf-7b3b-826f-0519-5f03a72462b0@oracle.com>
In-Reply-To: <3145cfaf-7b3b-826f-0519-5f03a72462b0@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM3PR07CA0061.eurprd07.prod.outlook.com
 (2603:10a6:207:4::19) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f81403f7-3c16-4668-6f53-08da5ea03475
X-MS-TrafficTypeDiagnostic: BY5PR10MB4001:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5liEpTpUSUFQTRJhT/EklI/ztBy/ISYcL0vZbJO4nkPsPWKzGFlpAa4bZWI/O+av94JnQzlnmpLt2FhHf3LAtkGE0Mz89aZ3EZruIjXIzW3D/mGt0SvK9+gCtYM/cCNo+Tn35mqWdIyVly2vc24UN/Yti5m2as0Pj5Aqy9cqWbKX/H+9ATwJHkBsQuHVz0Z9/pmThhB2LC4wkqxxarrvHauDSdHWoP6tLysNMUXzQ7kx7SgED/3vlisfI0NcZkc2s/gvAdMA0ubvjhVPkysAfDtamKHFWcNUVGW9g518puhT9Sn0ygzTX9efBaXActinZPujIDxGLqGfXMoStdjHiN9lhSn9wQhXiRWSU8D3VCopzvBTc9bryLrbXwnu0tQwsHDBAIu6PVyBXB4HaDsrFojeBLfwJuZJwpjZvyytyMh90VsxaSNNDizA5qazqK7xPG+PfFtR/E5Y5FSVq1gtSMkQVJ5a7HQ21vU/ksx9buZT6K6vRJbLD+rjcB7pPCNwL8g7NqpMkSz6Mz+72jviKlXD97acNAUUZjNSKnpzwPP4beS+7NZ3K9nr5vijC+yj35SGEfoVXPNu203DsrtYzwmoM3JZsi5fYEBZaIQbQyJhyDXMliFoEjF5tN+VZJjOc9KElq9lyhpw8jIDSqnmrbhhX5gMUMuUfB9cFuBSjJ5bC0sAMfs4HfTwq40RtZvD58jWlfInHKqPFWTuKeBDszjot0/ZPil987SOSW8aCRSzBjE8ZcNC8MVWZv5N3ecRzuNFWG8cEe06FqQsoF4xkZxfZCrma0InkmUPZU9ZNFuJpmwwOGxmLEC1UKj8W+O+50nV0lo3KZGUbyCI/JmYoH7a62uruwCziQUa3ZOw21BMeFVeTWJi3KpxghXLlmwC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(39860400002)(346002)(366004)(396003)(136003)(478600001)(6666004)(6486002)(966005)(41300700001)(7416002)(26005)(6512007)(316002)(8936002)(6916009)(5660300002)(31696002)(53546011)(86362001)(31686004)(186003)(4326008)(8676002)(66556008)(66476007)(2616005)(66946007)(36756003)(38100700002)(6506007)(2906002)(83380400001)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WXlCYlNtSDdxRXJ3N2c4Mjh4MmVrcEZrZGo5V1ZnRHEzV3lLOExJcUhhY0lp?=
 =?utf-8?B?dWtqVVZ6YTlERVNGOFdjU28yTDlaZUNBSlgzUkw2aVdDMUUvT1FJZjQyNDlo?=
 =?utf-8?B?cmN6NUdVU3RPUVh6ZXZiUys2RmdjWXZtNWRxNmk3Y3dSZ2piZWJNRERPN3pO?=
 =?utf-8?B?ckpZNEpvN2MvRnhxSU1FY3RwVldUVFVDSDZKYm44WXQrYlpFQ3ZTc0IxdVNh?=
 =?utf-8?B?UFlUZE1hODQ0aHBja0tmWktXVWoyVWx4NW9nYjB4Z1pBMVM2UU1mMzdTY04w?=
 =?utf-8?B?cGdCZ0s3ZGI2M01MZnYwaDVOVExMbmpkc3hLOXVBSkExcEJKQnJjZUV0bjJw?=
 =?utf-8?B?dUMwMHpObDFPejVjMlVpOURhaFhsc3pweDU5TG5jQWFWYnp5elNLRXVDM2pP?=
 =?utf-8?B?dzA3UXJGaWVwQ1BDRno2S0RvQU9JRFNvalVTRkFsenRHZzltT2l2THBhL0lw?=
 =?utf-8?B?aUNnYXlQZkk1VlhsK1Y3Q1JLL1diUjRuOFdOOW83UXNMUlQzN0ZnM25HQjQy?=
 =?utf-8?B?MlBQZ0tTMEZKM2J5TXk2T0xvNkFpNEN5Y0I1UGVuaE5sTVViaWp4NFUwUTlj?=
 =?utf-8?B?QlJnNTVka015Z3FKNFBNMFBESzRwN1ZBaVBJNEZTSm1BQ3B6dWQ3SDUyakMx?=
 =?utf-8?B?S1lXRU5Ob2t0cVFYeFYxOHBWc1FIWjQvZlJjOEhtemc4OWtycWU2TnVjWWlC?=
 =?utf-8?B?Wmk1Q0h1TVpSSW1reXF5UmhSVGg1c0dKOEFHbUMwcm5vUVAzTlVxRGdhdkcw?=
 =?utf-8?B?OFVIblpWbzZyOVBQTE1uS1FjRUhUNEFZVEJPL0xMMTJqVFc1ODM5SFhiMlZa?=
 =?utf-8?B?dXczOFN6OFBHZk00WTE1dmUza1VXRlU2ZlUyeGJKcjAzeTY0cDVXS1pXeGlR?=
 =?utf-8?B?KzlTcmwyNWhJMjVaLzkxNUE2ZEQyYjNVS2NSWlIwSFBQRnlJNUl1RWZudk0y?=
 =?utf-8?B?Z1BXR0c4RVNabzFwL3JxMTkvei90OXd6V1dRVEJaVnJ3SnRvanJJdTV4UjAx?=
 =?utf-8?B?c0U5L25memJRNEVvQ0M1RHoxRXFuR1N5ckJxYXJSTDA2QnNvbTN0WDVBYTZ6?=
 =?utf-8?B?clZEaXI2UE4xL2UyMGIvVlZaQ1FBYjdrRFNyLyt5cHpOcncyNjR0UVlzcFVV?=
 =?utf-8?B?M3JhQmxKenlaZVN2aGhIaEc4NGs2WnQ1TTVuQmNUNnQyN0RCclQvWnVSVU1l?=
 =?utf-8?B?a1FIeCtGT3B5NGFKeXV1NmljeXRLNVkycmRQWUE0dHFKYzQrQmV5KzJiZ2xa?=
 =?utf-8?B?L0p6bFBVV3ZCbDlKb3Y0aEMwKzQxWjBCUlorRWRSeFhDTGNkNm5IQjY1eTlw?=
 =?utf-8?B?YmsvY3FyVzlaKzlranZuY2JPdyt6bmpkcXkxY0tuU212UlhHdkxpTEJFZEtk?=
 =?utf-8?B?TGExTHpxNnFXY01QUGRTcGlLVE43Q3hidFl4dFVqUFU5YmR2Z1RlRUpPQitX?=
 =?utf-8?B?NjVDSVBjY2VOaUlwbjhqbENUZk9yQmJ3blczRXJqaVBVZmNwOXpobHB4ZTZK?=
 =?utf-8?B?WU0rYWQ1UFh1RDFYYTV1L0lxT09BSHJBR0lFZVZselRxaXhHd1JaMzVLNFRi?=
 =?utf-8?B?SG1wbElsWit3bVF5dUNXc0c1c0RDRkhPWW5lUEMvS3IzeUNDWGN4WnZvQW4z?=
 =?utf-8?B?bXF3MmUrYXNzenlwRW85U0xuM251WER6VHFsMlZGenAzbk9Qdy9yVmxRMFo4?=
 =?utf-8?B?MVltV0Z6RW5SQ3hhOXRYRElKT2EvWmgxMTZmQ0h2VmFXMDNKcFBpbk1IY1JZ?=
 =?utf-8?B?KzRqQXlkZ1BNd1JPUjBSN0NuOElTb1RzOWNrZjl2SXFTSHVuWmtTMWFnVWtz?=
 =?utf-8?B?TkVQcWlMOXR6cDl0eDBuSUlmSHJlQ3NjUFZ1Q0IrZW9peFpBdEFSeVpVZ3JM?=
 =?utf-8?B?VXQrQXVMWCswUW8wem9qaXgyeC9NcENXeS9XMTBsbGhWMmdoblUyTS9pR0VZ?=
 =?utf-8?B?aEV2RmVsQ1hVc0VTZVhWcytkSGJFSnZ4QTR0ZkJoVWFHaEovaEVLTzVYV25T?=
 =?utf-8?B?eC9GZlcvK092eTRncFl0ZGJ3TWNWYXM2SWxINW5WWlBGRHVkYUlFUnkwdGtJ?=
 =?utf-8?B?d1VQeWNWVUZDdFdsa2RZdWpXdlVtVTVNMUZaclhrNzdneVlycmswSk5Xcm1l?=
 =?utf-8?B?OFZ4dUExbXM4ZUVMNEFmV3ZpaFpQN3RtUEtuMnp3a08vdEQxQWFzMFd3Vmhl?=
 =?utf-8?B?eHc9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f81403f7-3c16-4668-6f53-08da5ea03475
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jul 2022 16:05:39.5954
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W2wd2y/wQI1ozDIV30b5RPDYN9unlvjrueAu6eTLqvjD65570Bl1quZmCV4YftLQUH1kRPzy6raXmezUW8MtZwcfmCgHv7jQ+GzHE0Zkv1k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4001
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-07-05_13:2022-06-28,2022-07-05 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 malwarescore=0 phishscore=0 adultscore=0 spamscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2207050070
X-Proofpoint-ORIG-GUID: LBsAd1Qg-hsomlnv4seXyu5TVTITCCNQ
X-Proofpoint-GUID: LBsAd1Qg-hsomlnv4seXyu5TVTITCCNQ
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/5/22 15:28, Joao Martins wrote:
> On 7/5/22 15:11, kernel test robot wrote:
>> Hi Yishai,
>>
>> I love your patch! Yet something to improve:
>>
>> [auto build test ERROR on awilliam-vfio/next]
>> [also build test ERROR on next-20220705]
>> [cannot apply to linus/master v5.19-rc5]
>> [If your patch is applied to the wrong git tree, kindly drop us a note.
>> And when submitting patch, we suggest to use '--base' as documented in
>> https://git-scm.com/docs/git-format-patch]
>>
>> url:    https://github.com/intel-lab-lkp/linux/commits/Yishai-Hadas/Add-device-DMA-logging-support-for-mlx5-driver/20220705-183119
>> base:   https://github.com/awilliam/linux-vfio.git next
>> config: openrisc-randconfig-r036-20220703 (https://download.01.org/0day-ci/archive/20220705/202207052209.x00Iykkp-lkp@intel.com/config)
>> compiler: or1k-linux-gcc (GCC) 11.3.0
>> reproduce (this is a W=1 build):
>>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>>         chmod +x ~/bin/make.cross
>>         # https://github.com/intel-lab-lkp/linux/commit/12299d61a80f6adf70a2e76b8f4721f3b7bcd95a
>>         git remote add linux-review https://github.com/intel-lab-lkp/linux
>>         git fetch --no-tags linux-review Yishai-Hadas/Add-device-DMA-logging-support-for-mlx5-driver/20220705-183119
>>         git checkout 12299d61a80f6adf70a2e76b8f4721f3b7bcd95a
>>         # save the config file
>>         mkdir build_dir && cp config build_dir/.config
>>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0 make.cross W=1 O=build_dir ARCH=openrisc SHELL=/bin/bash
>>
>> If you fix the issue, kindly add following tag where applicable
>> Reported-by: kernel test robot <lkp@intel.com>
>>
>> All errors (new ones prefixed by >>):
>>
>>    or1k-linux-ld: certs/system_keyring.o: in function `load_system_certificate_list':
>>    system_keyring.c:(.init.text+0xc0): undefined reference to `x509_load_certificate_list'
>>    system_keyring.c:(.init.text+0xc0): relocation truncated to fit: R_OR1K_INSN_REL_26 against undefined symbol `x509_load_certificate_list'
>>    or1k-linux-ld: or1k-linux-ld: DWARF error: could not find abbrev number 36676422
>>    drivers/vfio/vfio_main.o: in function `vfio_ioctl_device_feature_logging_start':
>>    vfio_main.c:(.text+0x18c8): undefined reference to `interval_tree_iter_first'
>>    vfio_main.c:(.text+0x18c8): relocation truncated to fit: R_OR1K_INSN_REL_26 against undefined symbol `interval_tree_iter_first'
>>>> or1k-linux-ld: vfio_main.c:(.text+0x18e4): undefined reference to `interval_tree_insert'
>>    vfio_main.c:(.text+0x18e4): relocation truncated to fit: R_OR1K_INSN_REL_26 against undefined symbol `interval_tree_insert'
>>
> 
> Sounds like this needs:
> 
> 	select INTERVAL_TREE
> 
> in drivers/vfio/pci/Kconfig VFIO_PCI_CORE

Err... I meant drivers/vfio/Kconfig VFIO
