Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F07F146979E
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 14:58:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244970AbhLFOB6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 09:01:58 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:25376 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231828AbhLFOB5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 09:01:57 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B6DKI2T030775;
        Mon, 6 Dec 2021 13:58:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : in-reply-to : mime-version;
 s=corp-2021-07-09; bh=OrQB76KZQXhSt8MKZ35ZmyMYBc6Y56RRXUWY3EuEjdk=;
 b=FLy3kVIHtxDbb40GYlQkiqjIH1MO5Nbitjg4epqH4amV9+CLUGRs4Xgl3TYQgpCyBxEF
 tmT7ExTKpy1zDAwFvEsZz4ovTJuJEcQbH15e6YjWp8d9bR1VcJwh6I9QtTd/+egfGqOg
 NEqJyGfpa7Ajtc67DHMrISstceF1t4dbjNJiqL1YAwJiIuULyzPxQZVrrGrYVZ6x/Pok
 0LmfYAk0mqtoveO2cTDstNMt0ldskAycCnU4wCsWrzTNTF9qJoZL7nz0IAS8/eXY05FL
 Tby9CfpWD58fsJ46KcFCzW91UIrzm383avb778+SJaQe9Sm8X8jLjxxqYQ4Gm7dCxKEu ZQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cscwca3qa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Dec 2021 13:58:12 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1B6Dp7o9014131;
        Mon, 6 Dec 2021 13:58:10 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
        by userp3030.oracle.com with ESMTP id 3cqwew0vca-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Dec 2021 13:58:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KhXFz2ulZvovlwvctG+1zHqUgudriitv1bnnBTEGWmVQbhndAEG+AZYMZ2UGQ/ZDd4ZQwgti5sYmB8+pGfo9qP8LpejbK/t/uZ6z3D/8pQ4gCBdmMWlIHNQTZ/x2q3TSx39x2/aAjgEk8iItDocwYFpPaX/slf80gw7yJgtKcWL/0V3Z9I9E/zwFYmhXnkwbGCewburxqAuUBArVKvg9d6KJB+hrcNEHUJGIpJho1BVrwXTN5V8mx5z3lNanGvSyDYijOUQCq+EExJXvxn0BlH5QzF6uEfm/5+495A1TAG1a6oHqQ0+09HrZjkxXMZfgiQEO6YJ8G5eATdGhH+1QSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OrQB76KZQXhSt8MKZ35ZmyMYBc6Y56RRXUWY3EuEjdk=;
 b=MAUByuDdFbKDTLx8gnuVPd8Gw33MzO7XiRgdqRq9HCIdhMBcARmKRvdJNiBhLSLWTXxq6xoD5Tzp8/LiS27i7XhE8IW6Ky4t6/7SBIw1d0U4Dtcsfhpaw6OZ5dGt3+hE7pOI0VbuEorHRA+FW5bAIn3JienAr2tAp4gtNrUhpAi4xdMuc99UvLXHwNf6mwkLKopLdxIEOata2ZU2O1MrF338YI+GEpnJzkcCVzmiSPdKw4TI4IQaAZMRqs3oxtp/G0fonh4ZjUN60kLW6zAxpzk5MJuEqBVAdUsOFlfoHEx3eUrzPwQUyYVC4bgg1kwZ6IQyF2q9yIU5UJhFN0ih8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OrQB76KZQXhSt8MKZ35ZmyMYBc6Y56RRXUWY3EuEjdk=;
 b=nF3yYguD7Qo5ErFSM0w1IMAa1OMiLJOcMmgEJlSkU2zHRpJ+I9L1j1RELIp0nFbHwFLd0bjiI4JTPF5+8LHF1Wswe3Ujh9qltijk6aC9h55J063IFWoEy2Po6oUYvTQCd1H3aR1Eed9Nnsv3opprOQXft3wSjUvgiwcBbGmxltw=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MW5PR10MB5808.namprd10.prod.outlook.com
 (2603:10b6:303:19b::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11; Mon, 6 Dec
 2021 13:58:08 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::7194:c377:36cc:d9f0]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::7194:c377:36cc:d9f0%6]) with mapi id 15.20.4755.022; Mon, 6 Dec 2021
 13:58:07 +0000
Date:   Mon, 6 Dec 2021 16:57:44 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     kbuild@lists.01.org, Manish Mandlik <mmandlik@google.com>,
        marcel@holtmann.org, luiz.dentz@gmail.com
Cc:     lkp@intel.com, kbuild-all@lists.01.org,
        linux-bluetooth@vger.kernel.org,
        chromeos-bluetooth-upstreaming@chromium.org,
        Manish Mandlik <mmandlik@google.com>,
        Miao-chen Chou <mcchou@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v7 1/2] bluetooth: Handle MSFT Monitor Device Event
Message-ID: <202112050416.RYsEcWkk-lkp@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211202231123.v7.1.Ic0a40b84dee3825302890aaea690e73165c71820@changeid>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNXP275CA0048.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:18::36)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kadam (102.222.70.114) by JNXP275CA0048.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:18::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11 via Frontend Transport; Mon, 6 Dec 2021 13:57:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b599cb15-3e6b-4782-dfb0-08d9b8c06e67
X-MS-TrafficTypeDiagnostic: MW5PR10MB5808:EE_
X-Microsoft-Antispam-PRVS: <MW5PR10MB5808E280FF7E223C92AD8C2A8E6D9@MW5PR10MB5808.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ec4FQgqTazRdjK/iAO8e2V+wkc6QwzbIzYMqJzHucMB0/vrqUPh1fXjdSs8+4t6cPPdjCF59cSTIJovVH8r2wTW82DQOCAtHL0EzVf+D52ol4mj47890pgC4+LtNTC8ei5wsLt3pZDbI9f6JCcLOCbkT+liJptTIRotu/p9P4lxUdMivcGh4EyEuY+UQaVPrGqfJGf5fok/VFUCAZKpBssPSgloHzwHPPYfpPg33sy4Dn7uPNbsoVE5o/ZnzxGvIAftJI4Yf91YqWXb2hGKgSn5vQNEFYbiX5sgD7UArbFAW6gyVRcZ8jzWbWb9X97UVywev6QJUkH641/rJrnkR9sno81WMoC/GHDRElfiE5UjqnnKXkf2hQ43+vRAvXmQ7ZAke2Fk0n/LzbLrmqi+AOCvUVMjTYN6KNaX+GxThU4qyIjkwC6fLfrDZOJtJa7G20CCF7rXVefBzwuxrZqjRLnIx6fbWtw6w0+S4/Z2K/b6NiD2uT9l50/g+HWTjS+Md3KH3ltPa7v17DfaTEx4VSKeEBBMLnMhM+giq4CUiY7s4f61JUiIn9/3YNDANMWb4QB19ddbCzDESMKlk7W0IncQpyFjmCgg2S20j5lElwei25IazFpPL4KpSKtEj4rHlh8vRvgxHJjhEo+B3kK7Efets8x2ha5tRjzwKkj24WDLfq//3Ev1ZGkOBwIUL4eyjXf8ONFxcXCfi6+W9etov37O89BHorBMPux9VU8snqKcZtodMyn/FePjweSKBmnqQzHIi+n3wGymz5tgxnXVem5dLwc12Xd+ss74dRBmi3TAKqr+jqs1KJ+0eOHmcE03QAmqIqtvS/QLgKskfDGGFug==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(4326008)(52116002)(6486002)(38350700002)(36756003)(7416002)(5660300002)(26005)(316002)(1076003)(2906002)(966005)(66946007)(54906003)(44832011)(186003)(508600001)(9686003)(83380400001)(6496006)(956004)(66476007)(8936002)(86362001)(4001150100001)(6666004)(8676002)(38100700002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cCziawEHkTUr4YDRn6q3cOnkw8Ct/Ixbf2iRCNoPEA+wj4o3pqhk9HaTxAt6?=
 =?us-ascii?Q?QitXpiLLO/akx0WX3nZHCTlTTH1PnhWm/4YfJZClKeAD7El7rk9/bCZyZ41R?=
 =?us-ascii?Q?6DVA+XWFTxNha9quueLw39+q4GJYE2hMAlBkJtHlPSbgb8L2LfNEDZkMiE1g?=
 =?us-ascii?Q?rlzXeOtnWQGZEvWXGCXS6XQkrrDF4Q75uT5vfInn9nu1ic/+tuaenTDGbcCu?=
 =?us-ascii?Q?7TJHVhb05cMWqiJEznAluWW4sIVnyS9tq2osYgbqzc0ddDuhPcG13nPIudtD?=
 =?us-ascii?Q?OEzIgrWj5AwilSjo3WRzHfJvWjcCWNzMAQSFPRCZ3EsO6zHDh1gapWDsMJOT?=
 =?us-ascii?Q?sb8Ey3hKbIUikXVdUP4tRVEzSCn97+JNvEcLIE7eGdOMpbniH8p7qg1gcxOD?=
 =?us-ascii?Q?KhrQtKy7zNMJ3GVc/BN2Ssurfjci1UEiKj+9iMQUXNSy6TaHlY2vTpTIhWlG?=
 =?us-ascii?Q?IOBMK42PtvdCzO+l0arE4YVhshthsgvH2EVzzRnwwlbphMBmcfrWb/Ae9Mst?=
 =?us-ascii?Q?MLgSbaz5Efk71+s2hXaBkfAdaFxpdV1UW/tudVJ1eZqfLAFipaPbqR7CWsUA?=
 =?us-ascii?Q?ehQh3dzF0dH8iuHOLWZGv9Pf93S9wiDG6fDE/og3rb8+ykYQ9uj6smXsRxfp?=
 =?us-ascii?Q?GR2yAkjhYFOxIExwxvRkSqpcsk6zgc6TVKZ3FILOrx68l9WZA9d7AcSGGdzX?=
 =?us-ascii?Q?mdIIzkKGbn3CuewiIdg+xMrMiDOsBsG94KVxuxWNAoG5NTUke+i7cGq63GYi?=
 =?us-ascii?Q?uoJhzOEitKlViy/JWFFEQOaumfdN9OQ0NVERYl1e9rNCrQnoXI2hRV6F2yyI?=
 =?us-ascii?Q?1wHxvWV+PLA3Lcfpl1MlREbXtMOrxoPllGdz+GmdbfDed34ksAeXv+BfbkG6?=
 =?us-ascii?Q?p2hW82y1zxYto9g4b4FQqcKKC3LDqfFJo4uDFAHdeccTkBOM7mpaX4T62LM9?=
 =?us-ascii?Q?iwd/TpdAaCxTxSLNNupYc4Ukawoh+XsAMLzIoqNyGP0pFxFhlGl6E84gg1Kd?=
 =?us-ascii?Q?h68rVkIAMK0DVjDoisPfBNHxATC9wXSCWrnMuxV6HjlQH5Drp729dxetnsnc?=
 =?us-ascii?Q?UJB9PzLNtotHG2YrUD51q5CmaHwcHGqeIL8OrYOuTc8qRq2jR/eeXObBiItB?=
 =?us-ascii?Q?pHb9Czs3y93LWlotMaSVyZfWpEio0IWLPOeOTv2xvO2sFV17+1rXJ8fT1yLa?=
 =?us-ascii?Q?DuUD2anGRm33P88I7rxTpUuJs1R9zSFuMOD/ir1Z8KvsJas1Svt6QP/T2ZqD?=
 =?us-ascii?Q?AHKUSJ4xY7YJKpqtjRGIXV1USwjU2LpUKAxiY3S5jgpmMaMBByCKpV9G2hEN?=
 =?us-ascii?Q?MxWz8JF3kyOFhh6JjR6eA64qhJsH3imArQLF05QxocxFni3Ja9DkrxYGRbZh?=
 =?us-ascii?Q?6J+DhpYg2g+viGekEg765nV2BbU+76H/H/g/caH6vh840kd5z9ecEmo6Lm5D?=
 =?us-ascii?Q?qgRy+w+DvDMmoaoLNRRjz6VK42kHbZILL5un9k1XA1k4MQALaftggAU7GuPN?=
 =?us-ascii?Q?7EuVKxgmQmh3vn74sHhms1KaQHWkIaCpl6joMVUpI4ltmnNEt0OL3AkIZndh?=
 =?us-ascii?Q?xmqucs5eMhNBp3k+cbO+ehQ/jt4NMEHMBWyac9RXY4G3wHTRMJ1lFzG7Qqic?=
 =?us-ascii?Q?SJItoUY3/vS4q04zyV5Yh6nKyxlZdidFJYyYC2bAI8TPUs6FQ0ezH/OJ89Pj?=
 =?us-ascii?Q?bbFA1ax6qdveoME11mkElmcEq9k=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b599cb15-3e6b-4782-dfb0-08d9b8c06e67
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2021 13:58:07.9386
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wDtIRKjEykjEm67q2kw2OFl/Qi0DxytVpBFMDIwSLY4pkI5Ihf4U21HqI9Iwsqmzo8AKnwu6GVCvp8keKtUFjhALB1SwfWCOXnuZ/yH9Ffw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5808
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10189 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 adultscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112060086
X-Proofpoint-ORIG-GUID: cKmsU9YWLFFmaOmTV6d7ZSeMDUDeAnnw
X-Proofpoint-GUID: cKmsU9YWLFFmaOmTV6d7ZSeMDUDeAnnw
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Manish,

url:    https://github.com/0day-ci/linux/commits/Manish-Mandlik/bluetooth-Handle-MSFT-Monitor-Device-Event/20211203-151659
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git master
config: x86_64-randconfig-m001-20211203 (https://download.01.org/0day-ci/archive/20211205/202112050416.RYsEcWkk-lkp@intel.com/config)
compiler: gcc-9 (Debian 9.3.0-22) 9.3.0

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>

smatch warnings:
net/bluetooth/msft.c:312 msft_le_cancel_monitor_advertisement_cb() error: dereferencing freed memory 'handle_data'

vim +/handle_data +312 net/bluetooth/msft.c

182ee45da083db Luiz Augusto von Dentz 2021-10-27  266  static void msft_le_cancel_monitor_advertisement_cb(struct hci_dev *hdev,
182ee45da083db Luiz Augusto von Dentz 2021-10-27  267  						    u8 status, u16 opcode,
182ee45da083db Luiz Augusto von Dentz 2021-10-27  268  						    struct sk_buff *skb)
ce81843be24e9d Manish Mandlik         2021-09-21  269  {
182ee45da083db Luiz Augusto von Dentz 2021-10-27  270  	struct msft_cp_le_cancel_monitor_advertisement *cp;
182ee45da083db Luiz Augusto von Dentz 2021-10-27  271  	struct msft_rp_le_cancel_monitor_advertisement *rp;
182ee45da083db Luiz Augusto von Dentz 2021-10-27  272  	struct adv_monitor *monitor;
182ee45da083db Luiz Augusto von Dentz 2021-10-27  273  	struct msft_monitor_advertisement_handle_data *handle_data;
ce81843be24e9d Manish Mandlik         2021-09-21  274  	struct msft_data *msft = hdev->msft_data;
182ee45da083db Luiz Augusto von Dentz 2021-10-27  275  	int err;
182ee45da083db Luiz Augusto von Dentz 2021-10-27  276  	bool pending;
eb96f195e598b7 Manish Mandlik         2021-12-02  277  	struct monitored_device *dev, *tmp;
ce81843be24e9d Manish Mandlik         2021-09-21  278  
182ee45da083db Luiz Augusto von Dentz 2021-10-27  279  	if (status)
182ee45da083db Luiz Augusto von Dentz 2021-10-27  280  		goto done;
182ee45da083db Luiz Augusto von Dentz 2021-10-27  281  
182ee45da083db Luiz Augusto von Dentz 2021-10-27  282  	rp = (struct msft_rp_le_cancel_monitor_advertisement *)skb->data;
182ee45da083db Luiz Augusto von Dentz 2021-10-27  283  	if (skb->len < sizeof(*rp)) {
182ee45da083db Luiz Augusto von Dentz 2021-10-27  284  		status = HCI_ERROR_UNSPECIFIED;
182ee45da083db Luiz Augusto von Dentz 2021-10-27  285  		goto done;
182ee45da083db Luiz Augusto von Dentz 2021-10-27  286  	}
182ee45da083db Luiz Augusto von Dentz 2021-10-27  287  
182ee45da083db Luiz Augusto von Dentz 2021-10-27  288  	hci_dev_lock(hdev);
182ee45da083db Luiz Augusto von Dentz 2021-10-27  289  
182ee45da083db Luiz Augusto von Dentz 2021-10-27  290  	cp = hci_sent_cmd_data(hdev, hdev->msft_opcode);
182ee45da083db Luiz Augusto von Dentz 2021-10-27  291  	handle_data = msft_find_handle_data(hdev, cp->handle, false);
182ee45da083db Luiz Augusto von Dentz 2021-10-27  292  
182ee45da083db Luiz Augusto von Dentz 2021-10-27  293  	if (handle_data) {
182ee45da083db Luiz Augusto von Dentz 2021-10-27  294  		monitor = idr_find(&hdev->adv_monitors_idr,
182ee45da083db Luiz Augusto von Dentz 2021-10-27  295  				   handle_data->mgmt_handle);
182ee45da083db Luiz Augusto von Dentz 2021-10-27  296  
182ee45da083db Luiz Augusto von Dentz 2021-10-27  297  		if (monitor && monitor->state == ADV_MONITOR_STATE_OFFLOADED)
182ee45da083db Luiz Augusto von Dentz 2021-10-27  298  			monitor->state = ADV_MONITOR_STATE_REGISTERED;
182ee45da083db Luiz Augusto von Dentz 2021-10-27  299  
182ee45da083db Luiz Augusto von Dentz 2021-10-27  300  		/* Do not free the monitor if it is being removed due to
182ee45da083db Luiz Augusto von Dentz 2021-10-27  301  		 * suspend. It will be re-monitored on resume.
182ee45da083db Luiz Augusto von Dentz 2021-10-27  302  		 */
182ee45da083db Luiz Augusto von Dentz 2021-10-27  303  		if (monitor && !msft->suspending)
182ee45da083db Luiz Augusto von Dentz 2021-10-27  304  			hci_free_adv_monitor(hdev, monitor);
182ee45da083db Luiz Augusto von Dentz 2021-10-27  305  
182ee45da083db Luiz Augusto von Dentz 2021-10-27  306  		list_del(&handle_data->list);
182ee45da083db Luiz Augusto von Dentz 2021-10-27  307  		kfree(handle_data);
                                                                ^^^^^^^^^^^^^^^^^^
Free

eb96f195e598b7 Manish Mandlik         2021-12-02  308  
eb96f195e598b7 Manish Mandlik         2021-12-02  309  		/* Clear any monitored devices by this Adv Monitor */
eb96f195e598b7 Manish Mandlik         2021-12-02  310  		list_for_each_entry_safe(dev, tmp, &hdev->monitored_devices,
eb96f195e598b7 Manish Mandlik         2021-12-02  311  					 list) {
eb96f195e598b7 Manish Mandlik         2021-12-02 @312  			if (dev->handle == handle_data->mgmt_handle) {
                                                                                           ^^^^^^^^^^^^^^^^^^^^^^^^
Use after free.

eb96f195e598b7 Manish Mandlik         2021-12-02  313  				list_del(&dev->list);
eb96f195e598b7 Manish Mandlik         2021-12-02  314  				kfree(dev);
eb96f195e598b7 Manish Mandlik         2021-12-02  315  			}
eb96f195e598b7 Manish Mandlik         2021-12-02  316  		}
182ee45da083db Luiz Augusto von Dentz 2021-10-27  317  	}
182ee45da083db Luiz Augusto von Dentz 2021-10-27  318  
182ee45da083db Luiz Augusto von Dentz 2021-10-27  319  	/* If remove all monitors is required, we need to continue the process
182ee45da083db Luiz Augusto von Dentz 2021-10-27  320  	 * here because the earlier it was paused when waiting for the
182ee45da083db Luiz Augusto von Dentz 2021-10-27  321  	 * response from controller.
182ee45da083db Luiz Augusto von Dentz 2021-10-27  322  	 */
182ee45da083db Luiz Augusto von Dentz 2021-10-27  323  	if (msft->pending_remove_handle == 0) {
182ee45da083db Luiz Augusto von Dentz 2021-10-27  324  		pending = hci_remove_all_adv_monitor(hdev, &err);
182ee45da083db Luiz Augusto von Dentz 2021-10-27  325  		if (pending) {
182ee45da083db Luiz Augusto von Dentz 2021-10-27  326  			hci_dev_unlock(hdev);
ce81843be24e9d Manish Mandlik         2021-09-21  327  			return;
182ee45da083db Luiz Augusto von Dentz 2021-10-27  328  		}
182ee45da083db Luiz Augusto von Dentz 2021-10-27  329  
182ee45da083db Luiz Augusto von Dentz 2021-10-27  330  		if (err)
182ee45da083db Luiz Augusto von Dentz 2021-10-27  331  			status = HCI_ERROR_UNSPECIFIED;
182ee45da083db Luiz Augusto von Dentz 2021-10-27  332  	}
182ee45da083db Luiz Augusto von Dentz 2021-10-27  333  
182ee45da083db Luiz Augusto von Dentz 2021-10-27  334  	hci_dev_unlock(hdev);
182ee45da083db Luiz Augusto von Dentz 2021-10-27  335  
182ee45da083db Luiz Augusto von Dentz 2021-10-27  336  done:
182ee45da083db Luiz Augusto von Dentz 2021-10-27  337  	if (!msft->suspending)
182ee45da083db Luiz Augusto von Dentz 2021-10-27  338  		hci_remove_adv_monitor_complete(hdev, status);
182ee45da083db Luiz Augusto von Dentz 2021-10-27  339  }

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

