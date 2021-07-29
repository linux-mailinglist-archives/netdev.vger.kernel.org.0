Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12B013D9C50
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 05:39:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233912AbhG2Dj1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 23:39:27 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:24188 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233908AbhG2Di6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 23:38:58 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16T3apt0005970;
        Thu, 29 Jul 2021 03:38:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=KQnxzvTM+ytO7rkFlMSy7u0zaB8Y+yn2yM4yfx5usto=;
 b=gCW1qmeD+deTREuYI/ShB3s1AjlQjIhU1FdMq5M2BhwwlgYTJBGyvdZRJFCGKNHKB99q
 PQmnKqjPgBKtTnJGkUjquj/svpPcGeA0BUwizZmPkqiMRN0oiL2MVIpDfIq3O5C/Qtdf
 sBg8tW2FQfW3W/pKsPLgrC71YrJwPOakapKIW5fHgRLMoznR7tXzDpY5LoSefwmbRTKr
 TIyg+xk7SuIL32/KfDgi/RCQSTQs5N4izhs/eD9DWqOO2x7Rmdlp4eJjp7iTUNgxEetc
 JtCXUPCXAnGjY8BgIrrzIenxnYUEPQLyaIsLbzOk6INHEr5EZmamTFBys+fObakhDjzP lA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=KQnxzvTM+ytO7rkFlMSy7u0zaB8Y+yn2yM4yfx5usto=;
 b=lWDrXVMrUJsDrF/g++2xUOj/n6A1G0aUuzHJOWIe5IUGIe94rbeglBvye8pDQBiGLD+F
 fKa7puhW39WtzjiwNzqBIQACOMAw9sAJlZ/kFWabQcH3Z3yMA0C65Y3ZOdC2Yd8OL4Zy
 NFRN76j+1YQiiVnjlIw/R8FzJWnksDqG6QeUxFuWimaIyyYJQT5Jg07isPX/AoxzRfmp
 VKR6fsS4oflKugtm2j1f0vAdNRYmhYJclIlXbryD8QTlPoSM5D8wj5wyyy/aApvi/Mu5
 9AIujkaXwKPe/v42FfcqqbhjBdgPPe/2vWt5spQMcErzbEroWyHMNnK4fA+VJYdzuESC Mw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a2353e20k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Jul 2021 03:38:40 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16T3UqoR071132;
        Thu, 29 Jul 2021 03:38:39 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2045.outbound.protection.outlook.com [104.47.74.45])
        by userp3020.oracle.com with ESMTP id 3a23501y1t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Jul 2021 03:38:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CMbIBYbZORs+/V/B1b9hPL2WdUha4vt2gKVliqaR+y8XlAu8rQOfluogU75M2QU09yE+Cf5UqebG4ROoFYkKRKr4ab+EyWLg46xxrM1cqKbBYWx4k3M3+1KV8RdGe4RyLrP6eHftaWxrLEWyrDK+u6Bz0HDebWwdFGb/+GYyOZ0qqGIT61c+UQXN7u9aX1A5IZ+fuP/OfEL4j9A/5jM/yZcoLizSIb6KfcZq0VUscSrM1MnQYu6ndN+PffxlHtktcDvvqABBTh/hqJfhuEHLrQq0oi0hRzLfD6uVTebGW/m3WGLAoi3LWsNff+uS8SSLASLJnrf+ki/BUcXvpPbXSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KQnxzvTM+ytO7rkFlMSy7u0zaB8Y+yn2yM4yfx5usto=;
 b=i5VkHQVggtc7POMK6A3AFVw+2QXDDFn4LnjoNy2GlBUrOS1e68dn4nbLRPdp/sIN9Qt1V0ZqZ+n64A48/hE/+OxJ7WjQbAugrTcDEoEl8Pux0WlOHrqtMuGp63oMlprVe66Z7A+dLcVH6jOPAwpfv/17OUluaihRaW+mP7zfiCnPe3OABJ8lZH9clUPEiH5mswpqyIthXDC9coYqNufIkE3w3TpZEaQ6ZojIsqha/EZQQWlPwLTScNWTjUMauc9aOumNTubYIgjIcbFechZU82+AJqEo9vl7NXJpEZML8/F8YwYLiIsG7h1F+NHNZvDGEW7xUe+tY0mcH5V7csxH+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KQnxzvTM+ytO7rkFlMSy7u0zaB8Y+yn2yM4yfx5usto=;
 b=DwJrs6Xxhy8tmnKUrwU00V9DolA15fOpt2nt1aFARE7BpqI4Mdb54sufV8LclyixwnTpr/HVqGN50e/OpQGDuwn6v+eRfYuDOtq1Zjm5Ujh6miN4LvP5m1ugK+plb2UMsDZonvwS1Y3BQZnTSAuUttVRYVu9NJsaiKVjykcQHy4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
 by MWHPR10MB1549.namprd10.prod.outlook.com (2603:10b6:300:26::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.19; Thu, 29 Jul
 2021 03:38:36 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::79e6:7162:c46f:35b7]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::79e6:7162:c46f:35b7%5]) with mapi id 15.20.4373.021; Thu, 29 Jul 2021
 03:38:36 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org,
        Sudarsana Kalluru <skalluru@marvell.com>,
        Nathan Chancellor <nathan@kernel.org>,
        GR-QLogic-Storage-Upstream@marvell.com,
        linux-kernel@vger.kernel.org,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Ariel Elior <aelior@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        GR-everest-linux-l2@marvell.com, netdev@vger.kernel.org,
        Bill Wendling <morbo@google.com>,
        clang-built-linux@googlegroups.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 0/3] Fix clang -Wunused-but-set-variable warnings
Date:   Wed, 28 Jul 2021 23:38:25 -0400
Message-Id: <162752985699.3150.5117188041980420877.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726201924.3202278-1-morbo@google.com>
References: <20210714091747.2814370-1-morbo@google.com> <20210726201924.3202278-1-morbo@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR05CA0067.namprd05.prod.outlook.com
 (2603:10b6:a03:332::12) To CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SJ0PR05CA0067.namprd05.prod.outlook.com (2603:10b6:a03:332::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.11 via Frontend Transport; Thu, 29 Jul 2021 03:38:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2f7243d6-3da5-4b2f-0c01-08d952425910
X-MS-TrafficTypeDiagnostic: MWHPR10MB1549:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB1549E3032A238FA629D69FE88EEB9@MWHPR10MB1549.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IaVmGUI9u0nlGCStvP4QXL7cSWMYIBt8ixelahiPWpqJJGxSTWUgaYiY8B7lDgsRxSHdWr5qHHkBwvWPS4eScmKWx4GnINDxt8egbDpIlmiWdLvpn0OY4qNGc/c2OWxO8kFAQhSMOOIvKjgMHI3kua8cQJ2xAMO09TcTgZVodVVVhTX51dfufbDkp2JORTDhsM5rOaI/bS1H+PA0qRWzL+LvfiP6gFhB5xtLP+qL5yqhjzMfaj0QC0mawAl7WNwvBHI82NkIezKzm8C6+p3Hkv/hQX3Y1GKgAxUt4oUcFzFNjE2FLoRYaepGorISSC1hksz4u2MeTy5a+zqoTj6t2TwCHPRaUIdCAnCEBHs295edQvhDUGlprmQy26RGoGTzy9buGgnqcE9BV4p1/Z2eXWOU7Hbq7S5emmzZsho8HHdHKGUo31hvjcGQw39a3ZWr+BLWXXSV2HFMXTizZAhkygDNQT396xX/ZDf/Tj3++buQ39n3M/xx2NkePR5hIXGaLGmqsJ8vImQpqvm3eZRimusvjJ2FhMKMZWlbjjkiaRfpwO883qZlePeJI+zsS+RLEIFpdRNwRUcjySghoT2U8bd9+6jB1BSKo3r65laMvGqCXZTFMFkmNECJOJkHDRbytuUa7/C7/z/A1oepJGq8KGTZeA2/39cJd/ULo5bOolLFRyIxQxQyA9rNsRgw+hYbH9wegwqBZWSKNPnc8Wd5d++F3TsOL6BqBCjv/ihAZIVsn6+RoKSHwxmU/RDvTRTNilemQnQVJi5Ig3TuMFU87Z6Bu0qOC0sNYFOYx27HnaE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(52116002)(7696005)(921005)(107886003)(966005)(8676002)(508600001)(86362001)(110136005)(8936002)(83380400001)(2616005)(956004)(7416002)(26005)(2906002)(66556008)(66476007)(6486002)(66946007)(38350700002)(38100700002)(4744005)(4326008)(36756003)(5660300002)(316002)(103116003)(186003)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eU9lTEZoMW4wYVhEZDRlTmYvMGY0S3V2ckdBUGk2Z1NnVlJYVHdHQ3BSV1RO?=
 =?utf-8?B?OXYrL1RiQ2hKMExwem9BRHhiWHNZdE1Vd00yT2JDVzI1eXBkalZ6RXRrVEZa?=
 =?utf-8?B?cHRtaG9EdlZuQWpWSTFIOUJRWGczL3Y2dmc2YlZFYWpaNDJrYjkxcVdvSWFQ?=
 =?utf-8?B?L253S3VFUDM1OFNSeE9FNUV6SE1KZWVYNElmK3JSNUZlMkJNV2NERFJSWWtn?=
 =?utf-8?B?Y0tBTlRLeE1sQVNZTVkydzV6UmRMUkRSVE93NG5hTVQ1UWJiWWZaUU5ZTVQ3?=
 =?utf-8?B?SlVNRVc2SFMvRStlTEdOcDE4SllTNzhkQSsrYml3NCtKNTRrQ0VUVWFpOTli?=
 =?utf-8?B?QmJJd2YwSEtLTGlPSjNueTBKM01Ib1Fic1JSRXY5bk53QkQrb2hhR0ZSYVdr?=
 =?utf-8?B?cC8xSnVHMTN4V1dNNHZGSHp2U01lWmdMRzhGOFhqUUg1dldvbXduaHJmVU9J?=
 =?utf-8?B?bFJ3K0RmVWNONlJPMW5YNGNQQzJJTTlHNGtzazEyK2N6MjIwTmRjYnJnVmNG?=
 =?utf-8?B?eG1xMFp6NWhJUHNlZlAzbTUyU3JpL0NuQmpTcEUrMkpCcHNSUnhHTHlOUkUz?=
 =?utf-8?B?bkpjdjRvSld6eS82RzlZZWUxWmNyWTM5TWY1UHF2R1B6NEdmK2RHSFlIeFlT?=
 =?utf-8?B?Mjh6Nlk5NGVPVkM0Tlg1RjNWQy9BN285UVhvUlpjVXU3VU0zeEtxZWFhb1Vz?=
 =?utf-8?B?bXpKYWdsbk1DZGQ3OGRDcnFYUVFJTnQ4WUpsUXpiNFlEeXJaMWY0R1luUUpI?=
 =?utf-8?B?dk9hN2NiM2E4a0g2aVc0VktOcHBlS2dxNkR1MTRBMGQvcFFkcG5Fa2pkZmM1?=
 =?utf-8?B?UytISitXcjc2d1g1QmlucVhKdnAxYkdwb0ljanF6UGdJUmU0dnp6RXczVW1J?=
 =?utf-8?B?d3Q0OWZCV2lscGZmSVdjbFhPcWY2Y2xpVWV5V0RSNWY1bktLcGhwbU84aEpo?=
 =?utf-8?B?TVZ2RHhmQkFvS1R4UjF3UTNsdjVoTG9DNU92T1FOTkcwZVVvMmN3T05qSS9G?=
 =?utf-8?B?VnZvaDQrQ1VtOE1HRWNOU2tVeUxBT0NSVWlyZ2w5S0R1b0tUSnY2WERxU2FL?=
 =?utf-8?B?MmIvaUowZ2tNVlJmMGNUcmhKTDl6eDZlaGsyNHozZDR6d3l5L0tPVjNmRktv?=
 =?utf-8?B?aWQzSGlzdU9Sb3dQejAyVTE2K2huT2NBcVBBV0p4UzdBYXkzUTNsdnlzeTFz?=
 =?utf-8?B?eFZJYVNrSURiWjEvRlpFZVpPUXo1cVBZQkExVzBOVnUyN2hySHBON3RNa0Nq?=
 =?utf-8?B?N2lGRllxeFN0OVI2eFl3VFErMHJLQjhMNjZ3Y09IWWI1bFg1QzY4elg2VTVC?=
 =?utf-8?B?WTdCUlV3cWtJajBEUEphNzZtaG95SGFlaFJKenRibGhCRkpTRWRRaU0yMGRj?=
 =?utf-8?B?UVhKemdKc3YxRVlkcE5hdGUyemhuakpNR2RyY1JKbEFDY1Q4djFQWlJSQVFy?=
 =?utf-8?B?SnlkazFUaklCL1UrQVJJSU9qM1FJODdpTnl1K3JDZkFGc3plb0RCbWk5MkFz?=
 =?utf-8?B?MFNiRVYrbUhZSmZmWDh0RnlZUHlDU25zcHY0SHFBS0JyQUNGODk2VlVuU1d6?=
 =?utf-8?B?VTFDdFlGSnZzaVlKM1JrZGxNV3lwVFMrS2ZwZm5pNVVuSjFOMEhYMHRpSmRk?=
 =?utf-8?B?OWJOempiT0g2VDBNRzNkb1FlemRJNTNHc3luKzBSRGVsTE1VQUZJYlZEUGV1?=
 =?utf-8?B?UHpqaU1meUs4MzBvNC9GVmZxeExIT2MzQ0tRVFVIK0hpR0ZFQnlBdFBKTzVJ?=
 =?utf-8?Q?ah8+6F+YLdzFzZit/qMGAEaKbykO9FsdIOABQHi?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f7243d6-3da5-4b2f-0c01-08d952425910
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2021 03:38:36.7827
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: okwWKd2c4WySu/5T7Q06H4V74uhDKURzDkuPXu9j4YBZl37bc79KtLeK0Es0J3zn+gnh8ovev4FHtHL3G+y613UeaYNSgTEwrITK/kdi8J4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1549
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10059 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 phishscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107290020
X-Proofpoint-GUID: RQxVxFAU7sks0o2EkjPwMNtCcyDJ3oJS
X-Proofpoint-ORIG-GUID: RQxVxFAU7sks0o2EkjPwMNtCcyDJ3oJS
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 26 Jul 2021 13:19:21 -0700, Bill Wendling wrote:

> These patches clean up warnings from clang's '-Wunused-but-set-variable' flag.
> 
> Changes for v2:
> - Mark "no_warn" as "__maybe_unused" to avoid separate warning.
> 
> Bill Wendling (3):
>   base: mark 'no_warn' as unused
>   bnx2x: remove unused variable 'cur_data_offset'
>   scsi: qla2xxx: remove unused variable 'status'
> 
> [...]

Applied to 5.15/scsi-queue, thanks!

[3/3] scsi: qla2xxx: remove unused variable 'status'
      https://git.kernel.org/mkp/scsi/c/cb51bcd5c34b

-- 
Martin K. Petersen	Oracle Linux Engineering
