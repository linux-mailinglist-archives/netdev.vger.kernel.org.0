Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B038F379D9E
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 05:22:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230137AbhEKDXr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 23:23:47 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:39998 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229465AbhEKDXq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 23:23:46 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14B3EdWb149463;
        Tue, 11 May 2021 03:22:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=a+MD6hh56eTfkKemIOm2LT5qws3mCdfceRKvU2oOqhg=;
 b=RnjazZMwD9h2uE4ABOBoKUf/oGspjn8L7voT4EtNU18PaKIMSJJASvukdSzPzCdUO/Q+
 1hQsHuKz30LVheRhBdIQ8tJSb/gWftF2JOPB2coGmjDRwAUaYQE2jIgGIvx9csuMmAxC
 8hAP4qDEJZzSuHz3GZkHu2Pz0LFQyidxfsvhNLvEawqQ0gSvMTDv9+lCdmuZC0ULMsz+
 xlHEtM/x2o2+z1n128mrqsY+foCG7oW6WL3a9AAc3FqKbf3VZrR1LWLfg9FqUl/v5RVF
 ox8sjq0cZNHM5NCvJpoxuoI5uRHs4G7LVjbpsF8p7fa9Vr37qw1vR8ifEpfMIWvw0OKq +Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 38dk9nd78t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 May 2021 03:22:32 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14B3FoYa103115;
        Tue, 11 May 2021 03:22:31 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2102.outbound.protection.outlook.com [104.47.58.102])
        by aserp3030.oracle.com with ESMTP id 38e5pwfgat-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 May 2021 03:22:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LheGFj4KgdwoVpZhRBYOlYQo8NsjK4ireb9hzEb6XRo5smi2qZkc+El09y7CR2pCz1R2FtVSVHR+jM3FQkwOIRCWXYGlsojCGatSiEst/5GyYhfQVZ1N+wzaVfviwyW62C4SMvfAzfxl8aK9Tm0eidgBBYGKFe6tmkciAanfp7R9SywLr3l382P3EMTbdSkuwp6D2Zu7eBXGTQbUgZL0PHNkKo+bhlBnjEuwgb6xlyIpRSIxbGA4saU+Hqxd9tSw4EhUiSsYo21OPARWRtwufXG1JVsHTqWLgPluuyqXG3BSldC0BdMNWLkevbPip8vUA551ybX3GCHLBlPT5hEjBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a+MD6hh56eTfkKemIOm2LT5qws3mCdfceRKvU2oOqhg=;
 b=GbcZBKe9bm7h5D7L4Iz/qQJ/nqYK3akUvfTiNL2ieW/XflUcTBfTLfrEx1p2h66n7Bqn4SKvATTtZFi0daByO0al2y1VKwV4anlYdl0kt/FlHACwox8X5kjZFdm7pcwNnlO046AvQGJgHGW0Azq7E8Zm/45jCsZ01D0GDxTdIAHTEQ3jHSd+0D5hcTdhtdS46L20emqMrK5Hlm7DhFWf8HOVAK/uWqYSz3eN2uuy4G9eDs4N596KEs+1BMUA7JoS8kdF5OXaQPRx3Uh12SD04ejHj6L1WZf9DLMOXqrwz+o2u//Da44zOLXGTuw4gk17iVPXGPjA2c9+T2QCtYZEXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a+MD6hh56eTfkKemIOm2LT5qws3mCdfceRKvU2oOqhg=;
 b=qp17pTEV/ilksJshwWmpwVzf9w4YtcqMEAe4yVRutPk/26S1znXa+dwNZJuXBwry0P6xxFNMXXkAn70STjtV2n5z0g4VF8xY7+v4sxqcEe6Yy5v8AR9PBXTot27dniFB5MgbLNtuZrSj8jkbTzHwXHx8UkBpb3+NEnxV7z9O9Nw=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4789.namprd10.prod.outlook.com (2603:10b6:510:3c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.29; Tue, 11 May
 2021 03:22:28 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4108.031; Tue, 11 May 2021
 03:22:28 +0000
To:     "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, wei.liu@kernel.org,
        davem@davemloft.net, kuba@kernel.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org, linux-scsi@vger.kernel.org,
        mikelley@microsoft.com
Subject: Re: [PATCH v2] scsi: storvsc: Use blk_mq_unique_tag() to generate
 requestIDs
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1k0o6ez1h.fsf@ca-mkp.ca.oracle.com>
References: <20210510210841.370472-1-parri.andrea@gmail.com>
Date:   Mon, 10 May 2021 23:22:25 -0400
In-Reply-To: <20210510210841.370472-1-parri.andrea@gmail.com> (Andrea Parri's
        message of "Mon, 10 May 2021 23:08:41 +0200")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SN4PR0701CA0023.namprd07.prod.outlook.com
 (2603:10b6:803:28::33) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN4PR0701CA0023.namprd07.prod.outlook.com (2603:10b6:803:28::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Tue, 11 May 2021 03:22:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3e8db0f4-a211-42be-60eb-08d9142c0181
X-MS-TrafficTypeDiagnostic: PH0PR10MB4789:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB478912C8C84E7D1100910FB88E539@PH0PR10MB4789.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: leeH3yB+Od1IT3lxPg8M9W7uQ0nHG/u9S7FGKQP15HzgzBtnZuatQRjaJ+m+Jz1RRd4GMJgvJJaqxC04Lb/ipQ/6lw+oJ/3GbEQPc8r7sHb2qnoY5ASEkxPw65wskNZP9OU/f63bVH5g3KgbllMeNzsyfhXpBFG058reLFmvJ4S4Kw/Ip0gfyATEWh8MpZRt7FzOyefrRdt3sD+K5Lq5VP7wcHRmUhU1vWQ1/Os/w6P2Z7cNKDkowGA3CT3vLPMMJP+Z4PAmh3D89JUZl5Y8MdmlPfPlgz0uUDkaEYEPP7JIyHfYPqft4usuaOwTtprdcgQHYVh2VskPYti4evaP+JueMwFgiUfiWfckQFodn+lMA4J8y1NdPpa39XBwkAq2vHVunOFJUOO50U1JbH+YdaE/ViPXb3m5bUidB9cUuf+PRXBDtNfU4E0EnMnrggQL3wG0DVCIQfMJ8jnXvL46PtnQ8r9rg+klNZ2to9RsVmohYCS1PuPu6GXMzoMn1rpth8D3dREN0PdvU6WRnOhFYDDHaUStsNQQwgyO1nFMF8NdW1rZXT/lxn1PIuRphFdnkA9DXcwg7v5KFaHd6cVRn4V1rZZC0mMX5RjSYJg07yoFdAF/CpTCspshFiR2JJUFnvfsU7kKpLUiClmpT5IcglnwzOuXblWxJ5JD57R4wtk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(396003)(39860400002)(346002)(376002)(86362001)(38100700002)(7696005)(478600001)(956004)(7416002)(83380400001)(2906002)(38350700002)(8676002)(6666004)(16526019)(186003)(8936002)(26005)(6916009)(66556008)(66476007)(55016002)(4326008)(4744005)(5660300002)(316002)(52116002)(66946007)(36916002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?RYDHc/l18aJL0nFbpjzPQsBPEWmJAMk/CId2saSQCPrvBRr9ftNJtuqEV0rg?=
 =?us-ascii?Q?yoNmkyMInXaTi8p4z4qB64QmgyaI09IdeUT1PR9qamoWg5uNXZ+WhwDaOJtc?=
 =?us-ascii?Q?kxWntgCiY1cQ/07qJDTQo1es9mHb0W0LNoOkTsJsuo+I/kDiPdn+Y/+yxkp9?=
 =?us-ascii?Q?j9lwupgD+gX739jpYdJsinCDcViI7a4CrAbBaoV2gLgV84RA4I80EI2mDXp+?=
 =?us-ascii?Q?RPoGQlBfFKKCxTJFK3qZr1Avm2sRF2JJuyy11LurNUIUn0gpI9r9XsrWM7XQ?=
 =?us-ascii?Q?oihX7u14Fu3vDeluDZvpH6eZ4pesAEGzEfkkmcqJ7xw9Q9zZIuvWqtc+fhem?=
 =?us-ascii?Q?W0NgSoaAD28o368VReirJgvXXMU+M1Oc4SzXt+IBymXhuQOTQcfUGPf2ZiBB?=
 =?us-ascii?Q?hif/vSQBWJ9RrwYIo+FaZCFtgyLjW7tmwwZtp+AYnRjq10qMaq9AzD2dxEUb?=
 =?us-ascii?Q?SyjeboFaTm13lL4ENF2qgBUZMV25IT9FX1++i1dp00VQxF68PuMCSRssWZO7?=
 =?us-ascii?Q?xWD/iIBkcgNFA+RVmoEoqb0DgNFaWnoo1gisd1HfqZ6s7vmcjT3nkLsenku3?=
 =?us-ascii?Q?BZ3IjXHRDFvNIdCLGVXGZ3k/B4ptbvUYwG3TBe0UF1zU5WVRc1VxxW+qasc5?=
 =?us-ascii?Q?h6zckKi7qeloFMoL3BlodJsQKwHU6/nN+SiHbPX4FzBLe/eIgCuYXR/QstTU?=
 =?us-ascii?Q?8PthTjN/nFzKLmDv62ByjCw4ZPlwNfpz/1L5gUVNY12xHFyDLbdmHA5xkVP3?=
 =?us-ascii?Q?RJhE0zjg1OOlgp6I0sVH5NPbMKv912K+VXSxsotd0wsLwH1/XOth8lxnUwlA?=
 =?us-ascii?Q?S7vreBh4n2Jl5p+xrmGklLoED/Ikjde3l6BW+qUuKcVTgOhGGNJYVvAKaDF5?=
 =?us-ascii?Q?HCHnn9W+QOP/xchsW2Z86sOcKXyne3RuIBw3lbNyp0wNmwrTXRkE91qeHSEj?=
 =?us-ascii?Q?gRfsYv44bgUUz4pELbcGvAFgyINwPAnIkXeFXTBnB1x4dhQCPOLXhTqu6AVl?=
 =?us-ascii?Q?nysRIwwTvMHHydjyxvpi+/E/TmAq8UMeFHp94aXlJB4+lWTVtgRmq1ZBEJfr?=
 =?us-ascii?Q?3/GFLC3nOMfFhfCu13iIN+V/i4RNJjk3PN8FgJPNWqoQEC9mozRPdbQ7/hBn?=
 =?us-ascii?Q?4QHGJHW4TT8yIx+VKX4rc61LvuVDvyuFs+Icg6Dr16NTRc9cmi783ezaO7+8?=
 =?us-ascii?Q?5Wa807/d5bDLEo9hiVAlP4BZSY9Ibs5C75Q+2aHHTyFkbAl1lWgPtYwSziup?=
 =?us-ascii?Q?XmuW5EUEVFxV7EUQiHGGZXpk4YzEaH9ZRb436a0GegTkhlq6mjPPcLtmuLf5?=
 =?us-ascii?Q?0I96lnGrjfo+ZT2Bo1VAS0K0?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e8db0f4-a211-42be-60eb-08d9142c0181
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2021 03:22:28.6994
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zgvylhueUvxlNu/2CCs2tHvUljV0SN9pIVtxg8RVbhAFgo5VahMah2vzeWDwYxlqxoyRejNEnARmvnLgJrOn8JzsAt9XtdM5PPKAmCSaLUo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4789
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9980 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 mlxscore=0 adultscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105110024
X-Proofpoint-ORIG-GUID: QxpgEUlWxNHEGs-WcLG3fTPuwxXfSGel
X-Proofpoint-GUID: QxpgEUlWxNHEGs-WcLG3fTPuwxXfSGel
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9980 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0
 adultscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 lowpriorityscore=0
 malwarescore=0 priorityscore=1501 clxscore=1011 bulkscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105110024
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Andrea,

> Use blk_mq_unique_tag() to generate requestIDs for StorVSC, avoiding
> all issues with allocating enough entries in the VMbus requestor.

Dropped v1 from the SCSI staging tree. OK with this change going through
hv if that is easier.

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
