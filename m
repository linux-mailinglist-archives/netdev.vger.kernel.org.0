Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C07635750B3
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 16:24:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240115AbiGNOYs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 10:24:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239681AbiGNOYq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 10:24:46 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D50447BA4;
        Thu, 14 Jul 2022 07:24:45 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26EDcpH3016420;
        Thu, 14 Jul 2022 14:24:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=QXQ8bh0G4w+1XfmROPvl03le1KKWFaxvPX7wo8NEgZs=;
 b=P5ywcX8OMIVHOZX/sz3cfWIUVnDqVRU6aWWvh6xFhruWtZf52rZ0kDLQeDWKzc6pnUw9
 drTLFTPDSq7x2AZ5PljKJxTVX43QQWFxjcyvfS3lO9g2vTK3pSySXoguc5Gw0hL542PL
 D5XRynUbsocDo/2VmdXvUE8kfXtODDBHk/G7n/rhtDoOaUgicBIuUD76i5EHbMVagbTa
 tZr3KbENjPwaFPP0AehXIoVRyBaScSnbPQz+PLBJmbp+cv+7mV+ejEjEb8v9fubDdH+8
 0hCOZXdKSeRUhRelikgfpWMBZNdzBFAU0KAARSMTkqx51d87KF/IPrtDl3KZfiWzfq46 Jg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3h727snr4e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Jul 2022 14:24:29 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 26EEAH43030917;
        Thu, 14 Jul 2022 14:24:28 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3h7046ase6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Jul 2022 14:24:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f2iNGvO5EzfSFGePsAFKHZ8msrnYpnTq8+DDYEccuLnUjYCOpsGNqrHEH1JlJBdcRN99SJgbuU2lmetKjJ+Db30qI1TmY6oN17vPefAnlI7OY2Pdq+CcIIO+osQdPwe5Q1phcUPMUaBKcHkpRr1fA8Uequw8Ub0/8nYqj7OQJGc24767Ep+fzgw2A/Oa6hczOD0NIFaaYaaJbpTL/5gXZzJaQhh4stsGriiHa+r1tP55HFPzkOIxCG5/j777weAjofcwZHykPPjExHNUK5oOBP4IVK37tSyAxtdlgjU3VsfM1L7Gxq2xsWURVso7pfDYlfiMvimX+7shYSfjZrVIEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QXQ8bh0G4w+1XfmROPvl03le1KKWFaxvPX7wo8NEgZs=;
 b=JdSrRuyuoSB1Arh7GOyyTHri1O1p17t/XQP/D5sdS96RZ7EsIt5HmEA38dq7kTOPYEd7FH2nFLtVjQsC4fMhcoe8cpPEYz5LFQKr/tRWrS0hbJa4U5Hn84U4U6+7lkD/6w+u+Emc6WTZLC2gVGuS0FiCvA+HczH08ti7394BVsoUG0IJwMSTQHAe+3F6i9tmz9ImZuvrigIAW8y8hd22bKQFXhURyYy1HwmL+dvzVFXDJ2W5dS5i5POtaZu7l80pLJwqFBb7HWOWpeA1N6bW0jLpDOWlY+W9bKCa4eqcvY0u525fYV7fWv9Jmb1rGV2Aj4gEOEdd8nPAKjA3ugsE2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QXQ8bh0G4w+1XfmROPvl03le1KKWFaxvPX7wo8NEgZs=;
 b=KS8MoXpdaVm+aSMjwqB5f0+6Xh/ym0M1TK2GlOdIdwR3JAvFiKT0pL4a0MIcUIZDoetx39IbLFDaQdc6R1lOzZbjFUzok57CFu6bHwAK9loG344cdWZx8J07o6maTAMHyOnbWngib//afCDc7JWKehRETw9WNIoL6xn6kMoDPfM=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by DM6PR10MB3403.namprd10.prod.outlook.com
 (2603:10b6:5:1a3::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.14; Thu, 14 Jul
 2022 14:24:19 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5020:9b82:5917:40b]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5020:9b82:5917:40b%6]) with mapi id 15.20.5438.014; Thu, 14 Jul 2022
 14:24:19 +0000
Date:   Thu, 14 Jul 2022 17:23:57 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Bernard f6bvp <f6bvp@free.fr>
Cc:     duoming@zju.edu.cn, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, linux-hams@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, ralf@linux-mips.org
Subject: Re: [PATCH net v6] net: rose: fix null-ptr-deref caused by
 rose_kill_by_neigh
Message-ID: <20220714142357.GW2338@kadam>
References: <26cdbcc8.3f44f.181f6cc848f.Coremail.duoming@zju.edu.cn>
 <4c604039-ffb8-bca3-90bb-d8014249c9a2@free.fr>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4c604039-ffb8-bca3-90bb-d8014249c9a2@free.fr>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNXP275CA0023.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:19::35)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dd69834d-283c-4708-5db6-08da65a48a2c
X-MS-TrafficTypeDiagnostic: DM6PR10MB3403:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: szJtCv9aKf0iVtF1lVZjZJDDXz1kU7H9gM93IPe78l2jFa6lPVRoxwcIrIRsDuAuNX1r7JFZpCxMND9HFnwgQIxbcuO0alf0h0/VPNcRC4Qde95QNYQhqpen3IuAVmO+INWhOkEM+Zo+AmAZ7BbgnjMHeHL2azdGCbJTk4FHSV61jyH7PXzfyKywF3P4XHJzFYw74BpWpqiG+OkPd7scaqetr3IR/eUBY5ftREfLDZPhXe0V/Mmfkv4gan32bSF/6v3N/MT+pCueBjPvlFdK5Pn8BplBYd6qfbc0BQL5poZtcXBMrzrlPTkdoy486POCBbcwsrfD+tNJyo4E7HzKJBvdGeeEgwdbYvfswAuSnYDEDBqUuwBWrdDp3Stgj7QG5suGC0ovnrJK0C2uRE/7zUeekA5DvKvH9YwE67YWwAlSPKuKgnXZhTUnKVGuZ7/adoLCmrLQ5vcvIITVSUCMP+9QbCcHqEhOiWDl6Gw1WVoEHkxNyOyTd+VrYpexdrhnd0laVX264xd0QfLZCODEfup4ntb/BMTs6BzGPEHuT0p9N4HFS6rkPP+0dvkwQPc76Fz3gsCtc44sGsz4G/Suc5kSJV7cNEA6hbicGoABV3pjsZGwubL5piKBLvV9jxhoKMie6ZPZt3gIq83ENxpTBF9zf9CN9cOHq3/q6+FEL+LoIX1rn3gFOi2HIs4TqDE78VfhHMv0DZ/zSAISgu+ANg6uvqJP2MDmnzUZ8s+K8S/gUMUATUXm7/ICKCETFQgUkJ3rSB1NrB9bw3qa8nb00O7feY+fM3tteTVzfiwIJoKtZAeJu4iU6mtvSIB00C/rAbTkYFMTyUyAq0sGha5TLeWH66BRssciNLgRrT7+2Exx9RSfvfcIrTwIZKgLuX4p
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(136003)(346002)(396003)(366004)(39860400002)(376002)(8676002)(9686003)(6486002)(26005)(6512007)(5660300002)(6666004)(52116002)(8936002)(966005)(6506007)(2906002)(7416002)(41300700001)(478600001)(33656002)(4744005)(44832011)(1076003)(38100700002)(38350700002)(86362001)(33716001)(316002)(186003)(6916009)(66476007)(66556008)(4326008)(66946007)(41080700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?whNS4LyKrMBGkza+ymbgBXdyqDJiX3nLlXByerPUxN0rEl+0n04UmqoqCCoH?=
 =?us-ascii?Q?DXzJOmKfrNQSn7rtyKomKx4rNdavQPGfAvuG5gk/3nQjBPIBgtE01h65ArqL?=
 =?us-ascii?Q?gEA2xtCByX51kEPuHMMLxRQI8YnEhcf/CP1in9jDsbJ223SO5Bs/9bZ5GVSU?=
 =?us-ascii?Q?YdWo7Lx/996A/RQkITvV9qUWLdeThQ7rj3eoOtZHwvEX5h1IAzDv9rbYkdDE?=
 =?us-ascii?Q?GAwuC1H+jW7jgnpxSLfrccpm+C7nmaI2EgP1FOhZhgsz93bljxgkhBQPEx7G?=
 =?us-ascii?Q?WaIh8KZ8DJRQ69NRZc46eogkzG7UKvGlzEjIzylwgLMiB3BZFWeL6UHGQ98E?=
 =?us-ascii?Q?aQFhQ4cDwVqca8amSuGubXrnM6uKeu4MNgLX6Tdp52wT6CN+rNqw/6hg08sq?=
 =?us-ascii?Q?6Ozi6R+h0czTn76VcStYT5hMn6dFfTbmrh3J+RqXVxGGIWhmRTyDSVWmS1xV?=
 =?us-ascii?Q?69nzh21WJdHKoOVoOAsKowoite0/jqi2KpRziju8SlcwcZ1jtpEo3nnuaY99?=
 =?us-ascii?Q?X5jGKufJRsL4TVQ86grbgMrL+hqqMdDEHXhzLbJdTFuxYVOYJw7irIRGlXRd?=
 =?us-ascii?Q?wWf9XlNDno60vxD4GyL83oPQ7E8XcMLRFrOjxtembFizjnMGGqiRlBLwUa5x?=
 =?us-ascii?Q?WUr90/EbTxLCpQsvCc6YDuDz65Qw0LA8p9XqY4nvH/xk1HvXQoAUkKoBcxLu?=
 =?us-ascii?Q?kB+dk/GkR8kaMDm4gVR1GiyFByqtLEEVszIcun++hVlmriIFUo7/0stRO2WY?=
 =?us-ascii?Q?wjmjX757vNWP4hBUAJapkgqY6NYUeEcVjjsz4ZBQk2+yTr+i1L8KJFCxLXMa?=
 =?us-ascii?Q?5beIlxfNzc3/QjvMgVbJCh1d2Br8EEPTOSMsSXHltEGp89l24P63pxWjkhCr?=
 =?us-ascii?Q?Zzzj3GyvReqZcGsWwkRT8nwiTM4g1ODsUzoCFFTVt/H3h1L4fmdzJsAgdINV?=
 =?us-ascii?Q?sbYPq0/J+aaD4LH9zhvxCy3hUxVjbJPVVo5BfulUWlXS3PN7dtrI4wM9Cv3j?=
 =?us-ascii?Q?oba+jSsaUh37VxtDL7fhLJuTfRTr24mRBR9TFmkIix7rfom8QSKkGqd+B2hS?=
 =?us-ascii?Q?UJ9C42WmwvjNHMQdhYFRWSQMQ5ped6JgScLFvRYdmpAmQNbgQ2jAOEu0xolE?=
 =?us-ascii?Q?yVQrwn9dFz0h90tk6WKr6wICnuwsK5EP1HTP6wc0/hsunu5PlzNlG73k5Et/?=
 =?us-ascii?Q?tD6A+Tuw39zVRTn5IwjZ3nqCGxKMYmmktw5TMw75mNr4Bh3QVCWfdCYzoyuj?=
 =?us-ascii?Q?+U1kp6hBOO17Fe7CTbDEFOIOduVNi7pZPrxkXab1KzgRJ5+qrBmRM/6OhHz+?=
 =?us-ascii?Q?OnopdYl0kKxOnlRlgj1tanrw+x1vhmLCt9kx7etgO31eFC+IxjVczH/y2VSj?=
 =?us-ascii?Q?iyhOvD+zPWUkzYJA1zr5yICa4+lzpMZxXg9Hoiikn51m4x5PdLQvE2mNa7tJ?=
 =?us-ascii?Q?NL6XodTLML3OOJq0FXoxPmxoQQdn+/UE6PT+mONQDA+65FvQ5ciu2QQgbEcO?=
 =?us-ascii?Q?+ePTGHvSWi3UzJ2xlQbFMfIF2wZUzSee8DGgL6h+TUV9n4rMl0TlpEVqbpF0?=
 =?us-ascii?Q?CQLI/JEUXRda8bAVqNe74LDSHir3tISQX6WKINEYH8j6CeethRDvWQptXbTY?=
 =?us-ascii?Q?+g=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd69834d-283c-4708-5db6-08da65a48a2c
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2022 14:24:19.6676
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pK4wX2u1Y+Qp6eqDkSmx6QWOb/yOcM5xKUQ0x7tI7LObBEv0+FXCt4nkqdioEZxSqL/g+8cgnuez/fxF2CdyHvUsbW/0Ro+c6xrgUQTuEfc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3403
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-07-14_10:2022-07-14,2022-07-14 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=563
 malwarescore=0 suspectscore=0 mlxscore=0 spamscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207140061
X-Proofpoint-ORIG-GUID: d6ZIYDOXZPZ-ax_9ntVbUqcIPM-oWSzf
X-Proofpoint-GUID: d6ZIYDOXZPZ-ax_9ntVbUqcIPM-oWSzf
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 14, 2022 at 04:11:44PM +0200, Bernard f6bvp wrote:
> Hi,
> 
> I am an oldtimer FPAC / ROSE user and occasionnally debugger.
> 
> Let me take this opportunity to report a major issue present in rose module
> since kernel 5.4.83 (5.5.10).

Do you think you going do a git bisect to find the buggy patch?

https://wiki.gentoo.org/wiki/Kernel_git-bisect

We should probably start a new email thread for that issue.

regards,
dan carpenter

