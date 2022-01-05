Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63481484D6B
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 06:21:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237504AbiAEFVJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 00:21:09 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:37386 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237473AbiAEFU7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 00:20:59 -0500
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 204Nio0H008994;
        Wed, 5 Jan 2022 05:20:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=Mhd5v13B3Y9kjMSB93WKrFWko22U03JMh3EB5GB3plw=;
 b=sIUZMm773F2HydjhKss9DrFRaJDX95DX/sg82GxVtW9lPxStb4Q2wuZkMLWjAA8QNOzF
 j6LhHxGurlQcBR8N8ilOr7LIeaVcSgPulDJLiCAorZYZ8GanpqOqN4ZUUhfXNejxSDuW
 h2z47uIjU5qREekV3H5+Hjv0k1UG1ltnrEg1xL1uQtwNAUxI/9Fz0h7erj8inHEnFnIs
 6demffcRF8did4syHEC9osyreVOJBib3I8wrIS5IrXHNyRgD9D+CgglJ3P1tkj15Rkj0
 rrvv60mYu3UhNh+P/cs72kTL/L2QUSESwBl6Sx8P+yVuS52xNQqTRJo/eZV33WT3iDzN LA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dc9d933nk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Jan 2022 05:20:10 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2055BluM121449;
        Wed, 5 Jan 2022 05:20:09 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2044.outbound.protection.outlook.com [104.47.66.44])
        by userp3030.oracle.com with ESMTP id 3dac2xppj0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Jan 2022 05:20:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GYCd8XSVryfgBZH0OjCbOsn3jRnphaHAAJX2uYF7sVLlAwXlQJm5LxC1/e5vr836au3s66S8rgZC6BawkxoLxSfuBtCWkYGJys632OVnDWn5hv9Aih+l8NHAvksTJ5p5wy6Mjo08TM/oYY2H20AaYQtSJpsWxx+Eg9OXZ8dHykp44b57PWuMdi4OJNAstrIys4UXgfpgeyYro7evQBUCKQGRhmgmLbwIHa51ejh597oXTVNrjke8Rz2PMyFr9V3BmQ49ww17oV59KqKSIk1TAYMdGm3AgXn0qUXY170VF2yT+ighAgx8QBRghr+jy7a5OFc8eE4YiTGjmFFNRCtzSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mhd5v13B3Y9kjMSB93WKrFWko22U03JMh3EB5GB3plw=;
 b=iz3mDqbVNuhFkNNHh/COOtaqkbIPzOcAaALW4eul/TDQhIInWpnVI9G42hzfzYhm+UAkJ/KZ4iOBZjz5elMaROug0HYOhskCqdOo9aF+7wcVSNZ9vSNvH6YQH8KYlw1Emu7WI37XVMt9I4VjUV07ahoJv5/59MaMMiYoF7LSGaB9KUnr8pLGV87E3p+Mr8psEF2Kxo3XdWzX7ObvU0GekQBixFXNootnmttp9U2UMABSEcrJxJVGNqV/JDUYJQL93GIWU93URV9vEJQc3EgwvPuWUBGbOuK2sfTUcRtot7XqLXQgzQsqeexZCy7c4bKCOIqkRm4vOLIqYj/fKh/6MQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mhd5v13B3Y9kjMSB93WKrFWko22U03JMh3EB5GB3plw=;
 b=bDGu1CCyIXBP1963sAwBlp4HFZ9il6ijhu49zzyGel6rJIfD1nBpnKwrWITI/+xPr03eMYjJbBEuwu/SMc30Hi5u/eVrsJwzga2tpCP1q66TnVr84DfcH6aEB5lyb7r/63uqBvpaxa4VAZEnio+BVLWYr5R/zKDRr9dOlQznex8=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH7PR10MB5879.namprd10.prod.outlook.com (2603:10b6:510:126::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.14; Wed, 5 Jan
 2022 05:20:04 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::1053:7ae3:932b:f166]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::1053:7ae3:932b:f166%5]) with mapi id 15.20.4844.016; Wed, 5 Jan 2022
 05:20:04 +0000
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>
Cc:     skashyap@marvell.com, jhasan@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux@armlinux.org.uk,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] scsi: qedf: potential dereference of null pointer
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq11r1m21z8.fsf@ca-mkp.ca.oracle.com>
References: <20211216101449.375953-1-jiasheng@iscas.ac.cn>
Date:   Wed, 05 Jan 2022 00:20:02 -0500
In-Reply-To: <20211216101449.375953-1-jiasheng@iscas.ac.cn> (Jiasheng Jiang's
        message of "Thu, 16 Dec 2021 18:14:49 +0800")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0206.namprd05.prod.outlook.com
 (2603:10b6:a03:330::31) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1054497e-0916-4662-16a5-08d9d00b07a5
X-MS-TrafficTypeDiagnostic: PH7PR10MB5879:EE_
X-Microsoft-Antispam-PRVS: <PH7PR10MB587932EA77112A95CE53EEAD8E4B9@PH7PR10MB5879.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ak3S5ZHCuk0cHC0qU8r/aBuLql9M+u0NuR/A088oz8nb7tmqdxEhj643Nch8OfNKSLrB93Arb9wPjlPRFGQqhddVLZ0n6wHfo9ZZYvRFfY0LThX3QL1dR0bZ9Da9JVxrA192+bigPqYRB4FYg1IkpJTlbShBjyPHpLdUYKAXEBIJ09caS2XmEnT3bvPB9tRFPykBfjJFwtwJ7JsMY5T4wziIQLFc4P4zC4lGFTlQS0YS1aqQdPnxgFAgdfFKgKIpGcFTUFIPxslaUJSJcnyUykABoCRKsXqd/ykwpOotEuMa3Vp7AqdwKkDTlp/PBspW3VstFvX8z/g/qQheNp8fpL+Tn0KTkqP0j5iAGVdQh5g0xs1SX6Mh1/omqt9gv+G0mG17Md+F7wSquwb5a8ok/lBu0u1BCL2UZnb1JzCSQTMWIdE/LJa3olQmDhtIYene4BKhluJB3NlJeGc2muqjEmZumYeXGl9idtnaUd/4UROSmmErpdVvkT041lgd6Di2PXo5Mo2tEG2sliuHhvS2nEMt9l3Kl6gDId5bL3lxaMUj/sMxOa5vjjMRoU5SFEXUf3N9iddZVoKDeObleaOKfC0iB2KYBpdGUlkmCwFUL2Q+QmtQUXmNOpki7XOpwGI2/2hzo7hiYykfXMpMkQO8fn/xyMNqDqi0vDwz8jJ0bd2ayKcMWfeJ8DAoIouJHU/42HtfEDrNRNmjFcTPhqx+yQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66946007)(6512007)(4326008)(83380400001)(5660300002)(86362001)(186003)(66476007)(66556008)(2906002)(558084003)(508600001)(26005)(6506007)(8676002)(6916009)(38350700002)(8936002)(36916002)(52116002)(316002)(38100700002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aN52BoVSrAgbqfYAhHtwCt+nJqyeMUmXMQl2wc+ugiwdefrwV2hCVxBDTdaf?=
 =?us-ascii?Q?fdJbGY+10USWwH2tPFA9S80Y+VvtJwfXEFABZphIVEkPhSLnfdEKS8lKxHEL?=
 =?us-ascii?Q?ImfaFBwN2d4HbBxoy051wDunymo8qf40oYsM2/F8J7Gq3P3uIIfqaCUh9+5w?=
 =?us-ascii?Q?Y39pPF4I27Q8oISZ8bbE9gxJxuOX8gcdlydoprPBVyX3D1o3DENiMrUnbvUZ?=
 =?us-ascii?Q?CGFyjxmKofSVg0VDHqIVgowCyL7tM5YxiBbhrry0jr4jrFuFcXvmWN2DLVuq?=
 =?us-ascii?Q?1ElfHPa42aD5BvK6jOH+Qw3YLPrRijKEqWReVUhr4NsGqKaNdf2LnQn/Ssp5?=
 =?us-ascii?Q?sDmsQiliZB3Z/45JJVdBb0h2JvYbhYVTcsQHhYQRb8UstOSwoyIk7dtURy+G?=
 =?us-ascii?Q?fAO5H+0t/2HA+Cdr9hxTlVFX/1sBuAS5xwUQ/U3GYDP6rxAa85U+03NYW4sJ?=
 =?us-ascii?Q?IoXAge5bFb4xlQLqTnlYpikbSvxwDOU48BgdN//wuz3StGKe/S5f6rFHp+H1?=
 =?us-ascii?Q?ec/mKG3+Vvxuz91IRwXmg43FaTsBf93Q73+uxrMZVBGwQ/fAsfe/MduheTo8?=
 =?us-ascii?Q?gM1Bd3wQQBxEJcFiJHKUiWzN7Ae1VUgdaiHimc5I3IranwzHqU/dolj6GWsD?=
 =?us-ascii?Q?r+fWQLM2UN99c6GUOlPBgfCX0wJHyhrNKdGCetVzDSfMXjKPy/NiJksseYE6?=
 =?us-ascii?Q?NbtBTqKBECVhg3ldO1oJYnAMSgAF0TYIwkbOESbWsG7VUF4YS/E7axJAtTEx?=
 =?us-ascii?Q?YR7hV9f5pRtEOQS6Q9uEQumv+pLWQWMjn6hWlLvga+aIw3jGB/UMgdKqs2JN?=
 =?us-ascii?Q?OfDhrF2PF/cBLfoNiqFf0GetrI0kz3ZoM+tTfJRLmvTYS1mdVVqE245Gf8JZ?=
 =?us-ascii?Q?B4vbM8EiSpyE1eOnVdte80nAXq0rdjWgRd6H8HoSf9LbIJub6Xy1baxjTGOQ?=
 =?us-ascii?Q?DOIdP/CNCSWuy85C2txt0mYzaAc3tBohsj+k+0EqhltPhia6MiqA1MQsMaCW?=
 =?us-ascii?Q?I067eCFXuqsuZNAE6lwDRHwCE5xDDIEZM957o3iK2viqdYHbFhR27b0b2VC1?=
 =?us-ascii?Q?de5kfykB3KDKnRhnJecexvFstNg8NzmmLrrI/M30wE5nKdZmZoqpCSthgIRZ?=
 =?us-ascii?Q?1JijL5cUEPeRpM5rDbZ8xjcUj2L86BH4ioyAoNhnprzNNM3T/baJRW7pVqqw?=
 =?us-ascii?Q?SAIPjjnugWSr8RF7MYtdlaDB1LgAM4xmYBN5ZVKDyzTIK752Bco6FgeCJv8K?=
 =?us-ascii?Q?opxZZroOghbKugXwrbBXLjhOLn+jJUGDmxf/4+nVU8BEWNzL+V+XVZZnhCHz?=
 =?us-ascii?Q?bd67sSeZlNaAmW8RnK5LSWfAy59SR6GcgHVKKgTjPsiCTI6mZh6jhw/nit+N?=
 =?us-ascii?Q?OuVpSTz1cePv8JYX5CMIIILb/j9nsd/sltmgXTJJ8FrAisxweR31V+ZrlFt2?=
 =?us-ascii?Q?4MqTaXdaqMmfVUDw3Nk4jH2rBblI+5zY/FFt0YCMBs+cOSOOq8YHUPUaJaoA?=
 =?us-ascii?Q?+thkxRxjxKjWgPRe2dz5kiHNJs/4YUW1e1oL0KYWJNlR2/RCFkDYIu5Fi9am?=
 =?us-ascii?Q?Hll6yTGBJrwGM1crsRlxk8lgjpXc+HlfFsh0LD7DOFNyi5gOKrlsxm/dyCvU?=
 =?us-ascii?Q?5QnLlg1C029f6m3VB7alVXk21U+kubEZ97HvSQcS87u4Efg8KQDmrtZY0O1L?=
 =?us-ascii?Q?SCIOyQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1054497e-0916-4662-16a5-08d9d00b07a5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2022 05:20:04.2987
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gF8ZcREVxfUeIOvpn2Ere7cecpEzQa9XDhWLQUZ4zybutt/LQCT4lHDpwXgBA6pSYpurwNAtK1OJRXVMt/nFvKPEx5+lcLlYeRhWncbp65o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5879
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10217 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=781 mlxscore=0
 suspectscore=0 spamscore=0 phishscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201050035
X-Proofpoint-ORIG-GUID: ShC6ywFUj6lHJQfzHwrVRXD2iqHxfm2H
X-Proofpoint-GUID: ShC6ywFUj6lHJQfzHwrVRXD2iqHxfm2H
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Jiasheng,

> The return value of dma_alloc_coherent() needs to be checked.
> To avoid use of null pointer in case of the failure of alloc.

Applied to 5.17/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
