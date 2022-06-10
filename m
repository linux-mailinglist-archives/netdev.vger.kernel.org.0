Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A5B5545E41
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 10:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347150AbiFJILu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 04:11:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347192AbiFJILa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 04:11:30 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DE4621E32D;
        Fri, 10 Jun 2022 01:11:23 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25A1V0gj002885;
        Fri, 10 Jun 2022 08:10:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=AMsjRJcrLyPsDc31mIm9J00joV6EQz9iYY3opP4QBXs=;
 b=NkL2RJUX4NsEwMA7YAO/2eyao/gG3RO8Gs1UXHpBAWVCgdbWJ/CTcWzMk1SXruh8vPeF
 yCBEb9K2Hejpg8JRBhQRdOcnWzKKxjPAFVJJccxPBX7HDBvjvx0Iq6diQzGqJgNt5xiY
 OkxtiaoVpYmKXRIQ2D6gCJUpjlx7hSmAkMBdwHPSL0OP4a+2xwI4a6TUhcff8HyuTCjF
 g9F4sjPpNbGbyU56TJOpM3c3TC3Hrv41KTRASIERE/kcUrhhOVSeGtzrECwM64muwC+O
 jNFJk8GiWhktM6wDXabaueNF/Z3EZOW4UdiNak/WzczKr0kN/9qztcob96o3nZk4JwiU DQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gfyxsn8mf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Jun 2022 08:10:58 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25A8AiMX037977;
        Fri, 10 Jun 2022 08:10:57 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2170.outbound.protection.outlook.com [104.47.73.170])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gfwu5nmtj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Jun 2022 08:10:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HuAUTpggpqffVmmPYsh26nNgcF+rCb0sbPe0WrsjAwhRXhL3ZZ8rEg/wzsBpyjKRDt5dcESTbAQX5KobikXJQcdRgkczsIK7K5MjkwpnevQHZMqHas889TJjFblIy7ia2PMNGheMddJGoXfjBrlq4oMH83lQ+UXZJ0nr8ulOntVOva8iqyJFp2zDULD/HV701eIkeFCbSHv3Z1P+TQeaHb7GpEG7+Q2cx9Xc87eQByu+XMaGgVEH5TzoLLF5FdRlunSMptNCLAtq9jEv6kvRXhWAD/w8EjHzowExy/Ob/Nc93hU9KMDsCJDyEiBrTusI+oPGsk7yh207PMJ63Kgs9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AMsjRJcrLyPsDc31mIm9J00joV6EQz9iYY3opP4QBXs=;
 b=OhS5v1lJwRLBgUZgC2Ikep8s0ns5uNu++92s5FGEb9W2uDgONPbJ73gRy7jj4C42psRHTpVfRxpMHFtizT3wPrKxYxQS9TxEa/7R4CHsQQRwHKfkgUJ74TDWAyqRdhiSVeymq8coQTkqHVaONrjJovbJLTlg6VowSY/IhPMeAAcAb/aOdkm2RVzg45P6OSIv2pMTgV+8XXRtt1MbRVMZ7p6r3KCvLxdkDoz454rAQpKUI1vm9EFkkempuG9xDaaPc12glcvN+KNcfV1GDjUolqug/F45RPrNJ1xrw6nc/MWnvFxgxiv7KIkJzbPFIfuC8tAl7wpm9iBZGWxr4ew8CQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AMsjRJcrLyPsDc31mIm9J00joV6EQz9iYY3opP4QBXs=;
 b=vP2Yizf3DZe3BGxDrD+pnoezJ3iCzEVMJruPkS82Fob2l9g1EOJXz0s4XpfJZVZEKYXFQCvDo7YQLxsTMP5fkxsYjmWHNmtU8lINL/ST842f2r3iVeNnmWm5y+CgAgwNkK45DGy3hZZfwaNkCbkQm2IrJ6VpPVyOlmwjY6PQ9VE=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by PH7PR10MB5813.namprd10.prod.outlook.com
 (2603:10b6:510:132::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.12; Fri, 10 Jun
 2022 08:10:55 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5020:9b82:5917:40b]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5020:9b82:5917:40b%6]) with mapi id 15.20.5332.013; Fri, 10 Jun 2022
 08:10:55 +0000
Date:   Fri, 10 Jun 2022 11:10:43 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Thomas Osterried <thomas@osterried.de>
Cc:     Eric Dumazet <edumazet@google.com>,
        Duoming Zhou <duoming@zju.edu.cn>,
        LKML <linux-kernel@vger.kernel.org>, jreuter@yaina.de,
        Ralf =?iso-8859-1?Q?B=E4chle?= DL5RB <ralf@linux-mips.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>, linux-hams@vger.kernel.org
Subject: Re: [PATCH net-next] ax25: Fix deadlock caused by skb_recv_datagram
 in ax25_recvmsg
Message-ID: <20220610081043.GB2146@kadam>
References: <20220606162138.81505-1-duoming@zju.edu.cn>
 <CANn89i+HbdWS4JU0odCbRApuCTGFAt9_NSUoCSFo-b4-z0uWCQ@mail.gmail.com>
 <E5F82D12-56D3-4040-A92B-C658772FD8DD@osterried.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E5F82D12-56D3-4040-A92B-C658772FD8DD@osterried.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: AS8PR04CA0027.eurprd04.prod.outlook.com
 (2603:10a6:20b:310::32) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e4df3aa9-ec8c-4ffc-a096-08da4ab8be3c
X-MS-TrafficTypeDiagnostic: PH7PR10MB5813:EE_
X-Microsoft-Antispam-PRVS: <PH7PR10MB58137028397E158B676488838EA69@PH7PR10MB5813.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6THrnPlrssf6HftvO4mpsQGsnieuBBcvH88UCvueFoPEBgQ8rUZ2MWWeBF528C+WQiJhCqao2opMmfjwjmFlPu6mJWebzedyw3pkg3qi7Y/dGG3PU+bs4ziRIOP9wMMVAm8nZyYBaM1/97tzbMlzsQ+mjAVwzcCyuI55CCMkTRa8o1bgPZGWWwBkai7NGCfw5W0IiI4Xj1HyldfjJSdu7GbaRS4a+RxOqAG6H1XM0wu/A8s66Q4qpNrQJpDSzxUvX1MgLSSzigXJh27a3TIGOsHySLVp/L4Ubm+hoHzpvcOUPCYjiTVEF/XOzJhUFYIIVD+m2uF0kWc8RjeWT3t45vyxkg2eaQe4HCPWAOmkAF775te51QhULti8ID84SVnlTEnfucZeyRN0UMFV6RjpUuNO0cREjHgnirhbapYWpvVpo4fwH2qtuU6qAhslH9SY3RxNNW6vSv1uJlPyFKjisdMdtVWh7/4EdZd9L/3NhS81t14waW2NPnOaUBeBM31gMpk1/Hoy6ZpohUwnhzuBUCNwIS0G3y6Qo5w976zdwUzPs6ySgsYvzI1AGCwJ7qxiY7xZPsP9Ni41GbKo5gbRDqCogbq45JC2LCaK/uhpUHEzKwQyDcVMfeGqqKS+jga1u+cRiOgi6WW/u379hi62LPynxOzvqu2DrXfmVcTdvwu7WJlJgnOSXLqSxIoEdFrQ1Fe/SHLYlc0+2k6s2Y2KUxEsmOAEPnrzfdHvR4Ju4XrdQcbHMIsd3Sp29ItoW39irrc8t4KkTci23MvV9OCVw2BBsvGED8LTR3NPnVRbQQo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(26005)(316002)(38350700002)(6486002)(8936002)(86362001)(1076003)(52116002)(6506007)(38100700002)(66946007)(8676002)(186003)(66556008)(4326008)(44832011)(33656002)(4744005)(6916009)(5660300002)(508600001)(6666004)(33716001)(6512007)(9686003)(66476007)(54906003)(2906002)(966005)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wdiJ8Wgy6ZEwsO3YgEySqx9bi3NcZR3D5gTvOXVumaL/3x1pHFXuCOpO0vgn?=
 =?us-ascii?Q?oLJy0x1hGBUNaxvdCzX90k/evKINyIOYWSKPNodU8UgXGup6ZfLI9PcSkkvO?=
 =?us-ascii?Q?TKB7jMQRP7+dqkCAzX+J+dpzCu5LOAU6XW42qHpSlCqzixJvt7/+3SqpKs7K?=
 =?us-ascii?Q?ZXWsgLXnK+qwFBkVvkDegfP8ClCnkudk6yb6/3einjC5Rc9sRmC1duhwMdDr?=
 =?us-ascii?Q?6n+52irCWT8ZN7UMl+1Lv/5XM4VZJFxJtGl/j58y2KAoQa4lMpEMzj1B0Q29?=
 =?us-ascii?Q?WBci/s2RNlsHhA8ZcW8bVgNq3Q1niFyyy/VBtwvIh7RncZEBMz52RQiZnBFj?=
 =?us-ascii?Q?XNv1e1M6+rJLUcKfkznDj9y2uYMhLP9N8BjDt5YTN3DTNjNIqQdrrJSeXxsN?=
 =?us-ascii?Q?pqsj/svxhZnIBzPO0AYuR9UwJ7gHJaWBh8ZKCu53qd6XPErDLz0pV1cS7Dr3?=
 =?us-ascii?Q?bXQP+NeSyNGl6f+MNYuaW46w+LjGWS291mW8fNrfAveKqXh2ezjSV1C1E04k?=
 =?us-ascii?Q?nMmiTIyyIRzQF+SdvvzwWT1w9m33bgad2s3EbvKWeawx3tdhXwBd1on4ilmH?=
 =?us-ascii?Q?ykTOd5RHH8ziA1ePT3RgK43q8sZkY6gYeyvckLtIV0KzdlgMkJFcbrfuboKv?=
 =?us-ascii?Q?ehz7t7WZ6Gm1I/wj/bwZaojp4njEjCAiaOdiFR7PQjYUfkWa3EyWVLrqY4AB?=
 =?us-ascii?Q?WCMLCeTSGTmtcumN2YPgW2NOy5K+6wdQERv7k5xZuTjRrcLvo7PPwSLVhc+3?=
 =?us-ascii?Q?NioULXKa0nf1q3N0JrTVlLNcLV5QgshS57UChBtzxVG2+3plwkuIyeQ7HT7B?=
 =?us-ascii?Q?IvkFi0JXutCuD5x2czHaEWOiPFR6QVSXzpTDDNloegXipW89M30SMpKvNGoR?=
 =?us-ascii?Q?QkW1HRpgh91dSLClKFlwo67RfFc+fyZa5HoYYlHav2KGkgf70TZamiiE8QwU?=
 =?us-ascii?Q?Z6OtgtF9t2caMrx1hhm5sC2qVQSljIkv0JVwwY6uohADJ/Jw+U8Rq5ntMefJ?=
 =?us-ascii?Q?KstB6/S8+LRIclKnUdUZTAK21LQTm3aC9jzbiosYUcVcv43ft1wbCFVOU1Tn?=
 =?us-ascii?Q?xc0BdyEAIqIv1C6FgSG3uxxwGNq7zkoSWQXXetbIZbTzlbCitsBc7zdegSBN?=
 =?us-ascii?Q?34dj26oXC4LQiagwE/G7TZrm6pgDnB2SQ7RFy8pIjpMz93MNB6952wS5UXd9?=
 =?us-ascii?Q?dyw1kIuVrpLWRH3tZMB3mwE1TzQVWaRfAL7jBUQD+V1vAuY+7+H8ebF4ZK5x?=
 =?us-ascii?Q?ai3nUOiWOaekJTrEHXsl9MJcsjkAZSeylduPiTAFQb0X6F36Jy2XqnfUVHJo?=
 =?us-ascii?Q?PEhkirpzL9mTfXzZkmHuHB7RWebn6rSWd3FVs7bD618jIVnaH9ET7dtWiAaW?=
 =?us-ascii?Q?6jRCbuqq1Z7LtpcCISmv1ng2pw2zRigfLjXxJA611ClpBG26x7VfHR5IwGIh?=
 =?us-ascii?Q?6k0tPpX4IDtUm+94h9MgCsXpDTJ8nwWOt3z4M0o3Gbzr3OZH+dRV97v7nRcS?=
 =?us-ascii?Q?CKG085vpe86y2iJkTkceMcL2LugJIpH8cC+EcfwGHcwsgNIum6y17xOUZOIE?=
 =?us-ascii?Q?HUbHw78/LXEQQoyZXEjOYcnUxGOB2TyMGp2GPKGBNOS/G1ze87My4qDVVd4B?=
 =?us-ascii?Q?kX2elILdIl/volSJyfFRPWd/ANUce7Gv2ACBr5Yhw+xMW9DPIqsGBLzTSOy5?=
 =?us-ascii?Q?9uwjsYgl1ILjsCI3fgqbu964xA08qG/GKRXnjzIf4ggKVuJexZmSkizTws8a?=
 =?us-ascii?Q?RDxXyPoX755Z9XAT3a5OIX8KSbvG3HA=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4df3aa9-ec8c-4ffc-a096-08da4ab8be3c
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2022 08:10:55.6178
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WyCVngMR9ClDYVzVJGeBksMz0NfWGJ0EPOUTsG9rSAbxz74qT7eCiQ99CIHpH2rhXNfcfqy/OuTxBcLvc9VJFpOKMRWAqNj5KTkaeVe4tfs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5813
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-10_02:2022-06-09,2022-06-10 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=736 spamscore=0
 adultscore=0 suspectscore=0 malwarescore=0 phishscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206100029
X-Proofpoint-ORIG-GUID: kW9zVf1XJU_zNQBCRppGdi1Or547xym0
X-Proofpoint-GUID: kW9zVf1XJU_zNQBCRppGdi1Or547xym0
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 07, 2022 at 11:14:34AM +0200, Thomas Osterried wrote:
> > Why is this targeting net-next tree ?
> 
> Off-topic question for better understanding: when patches go to netdev,
> when to net-next tree? Ah, found explanation it here (mentioning it
> for our readers at linux-hams@):
>   https://www.kernel.org/doc/Documentation/networking/netdev-FAQ.txt
> 
> > 1) A fix should target net tree
> > 2) It should include a Fixes: tag
> 
> tnx for info. "Fix" in subject is not enough?
> 

A Fixes tag says when the bug was introduced.

regards,
dan carpenter

