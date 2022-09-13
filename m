Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F142F5B6A76
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 11:14:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231658AbiIMJOk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 05:14:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231659AbiIMJOZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 05:14:25 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A05D5C964;
        Tue, 13 Sep 2022 02:14:21 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28D9Dknr013070;
        Tue, 13 Sep 2022 09:13:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : in-reply-to : mime-version;
 s=corp-2022-7-12; bh=xtCrQs23zMbIeKh1dSIII4O+FogQZQU/F6duqwRbD8s=;
 b=u1IRiQEpb5anTDT74wlg7RS4vNKlI1ifpaa5HiKtJEndgdBTSdy/mEHSrBAN3W9GrWFY
 0505N6MQfrDJBsZsXUvpBNRtgPLMsPJ48unw0ncbqmQzEhpCyN6ojwDFxh54lVFzFQnE
 tzFhBgJRLTBRvTtoblozRYQ58S/GCpdNtSP/F90aBr1ovZd4ZiPgJn6Pjtnpi6rY6/UQ
 q1T+yrMcPNyIxAbsu1RMXGr3aQyTl5mDMsyyvzFwYtEN77zGlAsFMGX5SNvCadw30J1P
 pIoUii3BkCgthGf/Jju+awNZoTsTmvCTtv6XfA9fyw9j+5WvcwVS63by3WnzpZVqcqoa zA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jgj6sp5fu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Sep 2022 09:13:46 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28D8TV1R026771;
        Tue, 13 Sep 2022 09:13:40 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jgk8p6p7c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Sep 2022 09:13:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f8jyrXNbOVog43jKuhU0QcLc+oa6ckbu/lzGq95JbEMLzSgiWCfovMdBNudZRqbKjlhaKWuSOBn3XRfbbYhOBQL9Em7oaD6os1etgp3JMdmyYwif4jKFFLM89EDgXcEqTKUNsyhnbhp4vj4cUNy2PgnTExcuIn0mGkZYvpv7rMctsJvKKuJnFuKy6MKVYS36M0QEU0lqwQCqwdnHYQ/Lwj8KXqjsZoJ0CoXemdToOVY3EzjdwgP8zXuTB2xRb9nr8E2mVLr8qIeKPngJEbRHiukTuhufvHPXyhpf4j/66A65ntHJGwrdGP3rv+uhbwojSzBragg2vCLIQRuxBaLRkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xtCrQs23zMbIeKh1dSIII4O+FogQZQU/F6duqwRbD8s=;
 b=MeL0PbzWn7y+WOrL3PeKSLYO7VCwYJeliTiISfCq+pN+GrepL3p9FXLU6EwUtOzux+6dkVEHxqVveN2hlwLKg/Gwb9VDB3YK3wZ8fo4QQHqzHfntRI1u+5tPCHfnHZXjQr6kJ1OzTBgapeh8Bkfg34MjUykHz23FDBA3J0AOuzQNtCIFdnjpRuJmujPBsb8RBgecdsN7XFQnW/YbYchdSLDZR816La5bmF3nLJz84jZig1K6U9GGpr3dGJSB8Ud/HarZGSA+IIj+NFlQe/uCyDf0QK0G3uiCjxAUrACuWagim64q6+oBrKnda+7r5baZX3i/oj9FATbWMu1Om6JL7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xtCrQs23zMbIeKh1dSIII4O+FogQZQU/F6duqwRbD8s=;
 b=rV1tv7qkJuEdnBMhcGjaSRwn3RCOuTJXP1d5sia/7CFd/Yy2czspIezsLnM825eeod7DrXmA+Sxz3xdpB3Sdgq0sLUWbLJs2rtgwyr3GLOF+yCy9fk88w03jazRDcXLvqm2inRjWGdqr9eZIw4KI0QJEa7Cg6vld0GjWIkGt/1o=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CH0PR10MB5370.namprd10.prod.outlook.com
 (2603:10b6:610:db::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.20; Tue, 13 Sep
 2022 09:13:38 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::a493:38d9:86ee:73d6]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::a493:38d9:86ee:73d6%6]) with mapi id 15.20.5612.022; Tue, 13 Sep 2022
 09:13:38 +0000
Date:   Tue, 13 Sep 2022 12:13:24 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     kbuild@lists.01.org, Yevhen Orlov <yevhen.orlov@plvision.eu>,
        netdev@vger.kernel.org
Cc:     lkp@intel.com, kbuild-all@lists.01.org,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-kernel@vger.kernel.org,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Subject: Re: [PATCH net-next v5 1/9] net: marvell: prestera: Add router
 nexthops ABI
Message-ID: <202209111152.gf5xyKKy-lkp@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220908225211.31482-2-yevhen.orlov@plvision.eu>
X-ClientProxiedBy: JNXP275CA0026.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:18::14)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2365:EE_|CH0PR10MB5370:EE_
X-MS-Office365-Filtering-Correlation-Id: c07e4c50-e6f5-4b50-7a4f-08da95683e02
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: No2HC2Ke7MfEmnmzk/NIrJmB7sXdgJUgzyJCoqApbSE26oCe9Bgw4PIzds7/ivul58OsB8bRXUBQc6aAv/eIIhXAMqIX4Hg+mSn9OkIZY09lbnuwcLuT/UBJmrN5sIHAbenATDdwC4xX2lvJlwer4l9eOpgq8y8V0NowY4eTJ9I3IAazxSRO/L0Ph+vWCA9ztRhJhWORDKp97mwPm9vhnk7VdAkr8RcVsvyMfAt7E68eIQCO7Qa+MytP56bDy8Q6Ug/cTzXd103jfPE6lry48dv2DeYDFygR/TQWF2XhMrU/Jx6KTcC6BuyDNQJDr+n6vH9l+V2B19+dCDUB4KxkshCXuKLUn7DQEjKtZaCyOuPaGEgtDH50Xc1YKhMzGM4Haq1LrhDXZ1L+QRBkkwEqM3zJV0TnQZ2zHswxVoRPxmfNfA3vzk/3xzmLGw8FEYhyyVNk5KJlPCr/gFA0a1oWxtJcrku6LmfhQVt/xhVqz56cCKINGupPAnIQ6Cd1vKeUCZuoJT9LLYapnQtu2SrVlwZXLEJhVXlZfMkNxOV+u7xJm0xsJKUKTVxh0pdCUvAxEBL+SK0P/V3jtjVWkroEix0UnjO/yU64qFBqtCbgY9a6Oz78AZ2sb/NSv7i3OkpTpT4BvenzdYGJlCzUebO0XldY7cOxRN6L9wUvfwUr3QILJK9Z904x6n31awG03vMAkRiF3NjMzPEl+hdLhXR1zNki8Asppf4fSQSC+OhT9FmnkBnexkt2NV5pXcFv2tQ4cl5Dv05wG7XkHAVuAp7scQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(376002)(136003)(346002)(39860400002)(451199015)(86362001)(4326008)(7416002)(6512007)(8676002)(26005)(66556008)(38100700002)(478600001)(6506007)(1076003)(9686003)(2906002)(6486002)(41300700001)(44832011)(5660300002)(316002)(6666004)(966005)(83380400001)(66946007)(36756003)(54906003)(66476007)(8936002)(186003)(66574015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8z/4h7Uhs19vz06Zuuh5kXjJSFbhBJ/rYsPFX4XGW8Dd7oQpaYE9D6d9aZ0x?=
 =?us-ascii?Q?DoVm7fjGKN6uKMbDrc2KowNv0kUPy0Nyi/O49CB+QLYvii//3H4Q482rp4CV?=
 =?us-ascii?Q?+lXaZhK9kMXa7jnsFOYKCeOp/8t1ahw6MMGDM/CAMr/tEFy69rmifWdGn4Vx?=
 =?us-ascii?Q?SCtoVYPbLz5uwW8EnAvs/ZkTIdOisa+Y5LAlXSCcsbn1VLhQ53xX6bLjczAn?=
 =?us-ascii?Q?yDJZHoG1iWvhbTNofymM6MX3bciGuAXToiPipks9jxxLzAAxRrmsy+iMIv30?=
 =?us-ascii?Q?/s8t8wNlZWXWcnriD6pbN0+RaSXgrvYZHUOHgEXqFSmcMr4uDyDnTR8oaHF8?=
 =?us-ascii?Q?4+QhbTm/0VsMDVgVtWOjt7PQiaw5DvYaMeTKKH/x0Quq6QVfPxTYUKrczkiX?=
 =?us-ascii?Q?HiFBZMn5DT01QercHmih9mrzNbuJFnTTK9bj5qYvenpjrkK7RUYTt5p1IC6K?=
 =?us-ascii?Q?E6ZyXXLzyqpzMXKaY+nSCYTlMNKmf+FupBgT71lgmIOUmNMZ4nJMT1L01G+L?=
 =?us-ascii?Q?tMMvj7ZddJG++QW3gkxoRDH2AyQ00fKrYMpY+yUJbmsL4efSX5MKnamHRqg1?=
 =?us-ascii?Q?3c0FxwJ5Y7ba0Q/MmIZUn77+cq8pXAjNp+1Mh/1LrNvTYdJId7wbbGdmDPHG?=
 =?us-ascii?Q?uNWpEFPfjskOEJ9Kewpx0uhxzt6/h6vBRO9HKTlaP/jkCL0P/ATOGXpQSfcN?=
 =?us-ascii?Q?tZegHRj8bkalFNcZ0bmFY3Z0e5f6tbAU2zsZ0/8EyHjv14rviC0k54Yilrw7?=
 =?us-ascii?Q?auZtktPxYbY9QBou2LTYP3jM8dWQbfXBVqrgC0LKLEfz18yaV0FIMdl/cVfJ?=
 =?us-ascii?Q?7jmWY7fxNi6O8Lz1uJEhWElstAOA1TmWqYO9l+pRMljwuWTRDML1LrWov1I5?=
 =?us-ascii?Q?mmqIERwbstJ2smeFt4CLfC181MBkpe/6FqxZ2hUpVLeFOmB+sGjFkmIVObmI?=
 =?us-ascii?Q?3ktaNtVyqyoT1pa5JFKHjhRLnCHM+UOlVlyZWXb1ZByzlVlC8np3ojx1uOOm?=
 =?us-ascii?Q?hI15tT27Izop4ivLJLc5UYsO03Wgo90ROBEkU2daWAg18wY/uKD2/wKKFzTr?=
 =?us-ascii?Q?Yv1ka56RA5J4I5NmTuWGon7yhlwlXq7lc58aSVgimcgPhL+esrx41MyUUb7R?=
 =?us-ascii?Q?P00fLCVkLGkrEcUnqmizaBLS9trvVOUyY77A+wmdxxlQXQ7qA72/gD+X6Huo?=
 =?us-ascii?Q?4bVXauZ87rEwZnFzhf0Rpc5sI406k9zjMFOPdqFm7Dq8Apb6K90N1rlfqCwJ?=
 =?us-ascii?Q?Lzzmno8/OCTYC0I/WkHsNedIpFX7js89r+ty+lm/Z5fgIUNg6vzgq7Sp3D0e?=
 =?us-ascii?Q?FJ3HR2Tv9RYkY8O7W3PBoNkd3cn2wT3eAOCF5aAaN5KsDJi06fr6ViAg9CPY?=
 =?us-ascii?Q?SLwjW7o053FX4TSiaixWNqWNMSi0HOPh/6G/z/6DdNidTMaJ4MV19TKe4fZV?=
 =?us-ascii?Q?dgNtTo+YClzgp/yzdGDFcQIIQVKmP1Rai+/0XGimn8eiIlbB9mDXkvoo/Rha?=
 =?us-ascii?Q?mxkDpEuTAqbh8Pbv/JGjgc1JuC+pCdq/0ndHBY/qJk/dOTIqsfrQK6+lc/rr?=
 =?us-ascii?Q?HDFQWyQpXRhJt6ukwNJYQLxM4nV8vLQ3lzuluRR+sNGUXY7zpTzhAPNHKlko?=
 =?us-ascii?Q?Vg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c07e4c50-e6f5-4b50-7a4f-08da95683e02
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2022 09:13:38.0052
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wqiIoH/fiumAo0P7O1V7HrfuNO9b6cKq7z07FE6MUeODXg+8eVZj/9iMYGrgIEOGCKFdBkCsimGJnNaFFDgfHQviV+cNSWCKIDqDXXzwrtY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5370
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-13_03,2022-09-12_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 mlxlogscore=999 spamscore=0 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2209130041
X-Proofpoint-GUID: kSwc0hLrKncvVHligCiB7T_yEunPyr8A
X-Proofpoint-ORIG-GUID: kSwc0hLrKncvVHligCiB7T_yEunPyr8A
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Yevhen,

url:    https://github.com/intel-lab-lkp/linux/commits/Yevhen-Orlov/net-marvell-prestera-add-nexthop-routes-offloading/20220909-065815
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 9f8f1933dce555d3c246f447f54fca8de8889da9
config: openrisc-randconfig-m041-20220907 (https://download.01.org/0day-ci/archive/20220911/202209111152.gf5xyKKy-lkp@intel.com/config)
compiler: or1k-linux-gcc (GCC) 12.1.0

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>

smatch warnings:
drivers/net/ethernet/marvell/prestera/prestera_hw.c:2139 prestera_hw_nhgrp_blk_get() error: uninitialized symbol 'err'.

vim +/err +2139 drivers/net/ethernet/marvell/prestera/prestera_hw.c

ec3daf86e28107 Yevhen Orlov 2022-09-09  2110  int prestera_hw_nhgrp_blk_get(struct prestera_switch *sw,
ec3daf86e28107 Yevhen Orlov 2022-09-09  2111  			      u8 *hw_state, u32 buf_size /* Buffer in bytes */)
ec3daf86e28107 Yevhen Orlov 2022-09-09  2112  {
ec3daf86e28107 Yevhen Orlov 2022-09-09  2113  	struct prestera_msg_nh_chunk_req req;
ec3daf86e28107 Yevhen Orlov 2022-09-09  2114  	static struct prestera_msg_nh_chunk_resp resp;
ec3daf86e28107 Yevhen Orlov 2022-09-09  2115  	int err;
ec3daf86e28107 Yevhen Orlov 2022-09-09  2116  	u32 buf_offset;
ec3daf86e28107 Yevhen Orlov 2022-09-09  2117  
ec3daf86e28107 Yevhen Orlov 2022-09-09  2118  	memset(&hw_state[0], 0, buf_size);
ec3daf86e28107 Yevhen Orlov 2022-09-09  2119  	buf_offset = 0;
ec3daf86e28107 Yevhen Orlov 2022-09-09  2120  	while (1) {
ec3daf86e28107 Yevhen Orlov 2022-09-09  2121  		if (buf_offset >= buf_size)
ec3daf86e28107 Yevhen Orlov 2022-09-09  2122  			break;

Smatch always worries about zero sizes...

ec3daf86e28107 Yevhen Orlov 2022-09-09  2123  
ec3daf86e28107 Yevhen Orlov 2022-09-09  2124  		memset(&req, 0, sizeof(req));
ec3daf86e28107 Yevhen Orlov 2022-09-09  2125  		req.offset = __cpu_to_le32(buf_offset * 8); /* 8 bits in u8 */
ec3daf86e28107 Yevhen Orlov 2022-09-09  2126  		err = prestera_cmd_ret(sw,
ec3daf86e28107 Yevhen Orlov 2022-09-09  2127  				       PRESTERA_CMD_TYPE_ROUTER_NH_GRP_BLK_GET,
ec3daf86e28107 Yevhen Orlov 2022-09-09  2128  				       &req.cmd, sizeof(req), &resp.ret,
ec3daf86e28107 Yevhen Orlov 2022-09-09  2129  				       sizeof(resp));
ec3daf86e28107 Yevhen Orlov 2022-09-09  2130  		if (err)
ec3daf86e28107 Yevhen Orlov 2022-09-09  2131  			return err;
ec3daf86e28107 Yevhen Orlov 2022-09-09  2132  
ec3daf86e28107 Yevhen Orlov 2022-09-09  2133  		memcpy(&hw_state[buf_offset], &resp.hw_state[0],
ec3daf86e28107 Yevhen Orlov 2022-09-09  2134  		       buf_offset + PRESTERA_MSG_CHUNK_SIZE > buf_size ?
ec3daf86e28107 Yevhen Orlov 2022-09-09  2135  			buf_size - buf_offset : PRESTERA_MSG_CHUNK_SIZE);
ec3daf86e28107 Yevhen Orlov 2022-09-09  2136  		buf_offset += PRESTERA_MSG_CHUNK_SIZE;
ec3daf86e28107 Yevhen Orlov 2022-09-09  2137  	}
ec3daf86e28107 Yevhen Orlov 2022-09-09  2138  
ec3daf86e28107 Yevhen Orlov 2022-09-09 @2139  	return err;
ec3daf86e28107 Yevhen Orlov 2022-09-09  2140  }

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp

