Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAE403E1441
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 13:58:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241166AbhHEL6f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 07:58:35 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:31420 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230446AbhHEL6e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 07:58:34 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 175Bvj8p015493;
        Thu, 5 Aug 2021 11:58:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=AtX9AWvJ9Nskb+bELsEMOS/nRY31GmmksZCW3SYz89U=;
 b=F2/yequokuLzgth1DLiTNA20atkLG85YK3ntfIt61Wr8kK7C7/G6kfmFmj1JLnP1bmLc
 pt/T1UtdxwZq8sQgMHN9/tCfdScrLMF8oLsVjYYUP/TweZUF0nqgGJRH21z5GlxkUtHR
 XsG1Bn7npp6hj63ClK0bChX/RPWLFXcQsa+CidAh5ctzemO8eSuTVmmZ7x1klaQmyj2a
 Br/jVLIaoSrITSoI0RWt1u+DJUa8dcGi8s6XWRMk8DIbq6yxtlPCXqzxDX2kzE9yKG5F
 4yw2NMkWVHZRMPj45mj73j1Mjjf6OXqWOSVQAGEHOidimQLWGLoZKHBUdyhrtXqpv50V 8A== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2020-01-29;
 bh=AtX9AWvJ9Nskb+bELsEMOS/nRY31GmmksZCW3SYz89U=;
 b=Z4tTUHpLTJoICpOaKeKA83URRD2sHczMkyH0f7d7q1ukMF4kTwFgnWhh453/shq0HSRa
 OOeSCOo5cNStp32ci0s2bUhe/ojabr5TtRvHgo+yPuXkXEhAY7Hru/XH9nchVtVCDEOu
 uSmjsr1rvL5/+IHd4efDOCZVibIFhJ+Hb0DeAngr5njRoQLzbHInWx8e7SehYYat3S/h
 Ixv/GWAffJzHIyb+RGkVjfHCZPJZFTQVBe/D9JTFnujGzrx5WKu2VKPM20AiWKXvqflV
 Dcs3RF/SFWLNPr0CWSioPUrqrW4VjtFtra9/6aamxBXxSD6Ji1ZAprTQqXNULFfWSz7/ eA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a7aq0cff6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Aug 2021 11:58:19 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 175BtUZr120911;
        Thu, 5 Aug 2021 11:58:17 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by userp3020.oracle.com with ESMTP id 3a5ga03678-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Aug 2021 11:58:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VJjFFNSgvuEiarGbdgKpiqveKa+uORZvQkwUfbfRMRAgaVSBvkd7UowtMBoqCZ0GBeKd1cxJ/xMDDocC4LRB7ePBZZbSEakWDAbCzuK0GRhGLCuoyboaGSQl1WklQNHauEryHeFXxL6y4miemHRt4U2pEBEoNgTXdRtWPERwoiztruFZJzAPR5Sa0KryP2pI+KA6hvAMQMmylC0xN6p5xiyIaEjad8Fmx5Feevvx/Z8AJo3HzsiKTGLW9Tygmm0OqSmV86QYdBdn3PNYDOCifxdqbDbLU9BUAwB/4DxZcbOaY7qPsM26BoQjPHLdfx1hs6SlyRRpTBxHw2Lfvigjaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AtX9AWvJ9Nskb+bELsEMOS/nRY31GmmksZCW3SYz89U=;
 b=MG/LOTjTT7XTjIqgHT0hSxQyHmVo4hPo8BuogAjUo06fDfbl5uUL0oZymr3SroZLjhu4/nD1R5oHknCMVZmhklZkKVqbg3sHGQuQSXmKUCf9m6D7JjNK2bskmWjJpRakxcDYYe2JKyz/f1CD3KK36cUoCpl+Aofkd/O2DmkRCDkdgAYjt0IKjq4dO/aMHZKA+w9WsuiFj8hl8jv0wj17AHmjo80oQ4foOFBnTqmvpdhEkCJSLNR32pyWSr//Xti9hQ6Z5pKv4yNgWqBFkEO7LM9QSRweLjQRx3xV4Fh8diyf9lEm5EeWaWEpF3ZH7kDVHbD8eV/Vx/2FcdgNgiAxdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AtX9AWvJ9Nskb+bELsEMOS/nRY31GmmksZCW3SYz89U=;
 b=mAvpBBC7wHFw2uoZalqPRXe+9hPJgYD0vGZ1Kec2Z9gEYzl9IAg9/uTq8ZZS85RNBim5m2+rzEuKxc6tNp5MDVrtIHRBbJD0PhSZcvXdjSvk2tIxozBOZJznxq8HQbGxlqMznAMZBbPvqMHKjZNyYS/1nfZxfuir0wd2eBn8hnY=
Authentication-Results: lists.01.org; dkim=none (message not signed)
 header.d=none;lists.01.org; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1903.namprd10.prod.outlook.com
 (2603:10b6:300:10b::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15; Thu, 5 Aug
 2021 11:58:15 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268%7]) with mapi id 15.20.4373.027; Thu, 5 Aug 2021
 11:58:15 +0000
Date:   Thu, 5 Aug 2021 14:57:57 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     kbuild@lists.01.org, Rao Shoaib <rao.shoaib@oracle.com>
Cc:     lkp@intel.com, kbuild-all@lists.01.org, netdev@vger.kernel.org
Subject: [net-next:master 2/15] net/unix/af_unix.c:2471 manage_oob() warn:
 returning freed memory 'skb'
Message-ID: <202108051610.IrlkPw7d-lkp@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNAP275CA0020.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4d::20)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kadam (102.222.70.252) by JNAP275CA0020.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4d::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.17 via Frontend Transport; Thu, 5 Aug 2021 11:58:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8b01fc7c-9fae-4bce-cd34-08d958084e6b
X-MS-TrafficTypeDiagnostic: MWHPR10MB1903:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB190315135C04E04B9D5455D58EF29@MWHPR10MB1903.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:142;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DTbEc2O6Vmxc6c1Veg6P9UkKePFtFUGhERUCdMZLBK2Qq6kE9zshtEeS6b15QRorxnv+f9Z1+C1DRrsfyfAKYZ+dBQIsvk8utGqxydPBwXfGz92QFFNinqUmXa9Btvp0hdZC7pSbzT6xajCUfLXU4gdJNyKSud8fAqP+NMvYAuQlBOryuIUDlt0WareHMoop8836RfyCSfDe73Nzv0i3RUlCRvQZRQfEsvKmnAcuoKlBs3LT7FQrE8hq8/Z/BNlHdOg5o/U+7KEb9tHXFF7vS6o62e9JArLHHFuv6JkAJrKkaXxMq+SjWhgnV7vNl1dcHGt3cjAPvcWA/fdabwKcGmiky2Lpv91WWJYjL+go7CxYjyThohgrg2e/jswPMOOC1BXawNRsbypabnnMt1hXQa9nJA8KQVrgzr4ceORlCAa6Pl29LSNMNpNaq5VsgapcRqeGa5dVNSbvqAaNlz09GxuzcLaKU9r+gxu2cNPj/qPnMAyoRc8rLzfpG4PvFpWG1wK/FsdbMZn/decyV4Y8KzpsEtq3BWnMNWdj7BTMWJjXuPFT9U8WyNDyr0OGLETCoRE73CXvhq5K2/SjDpMeM+BQu8sFw3uxuK17XeK2tYODW3ibkjbS/xABFiqta0G/tR9nFLuRSDqb3T3dgmmZoWY7rE46thEaDv5Il4eNUMg/A+n+6lcOXZJakw9ORmfXZSF4o6rG2wv1Rvq4goBL0xuUBIsu7VxUJT4hRPJf0/e9QU71IH2iZprfb6K4j9xtV/mRNRSw+QrKpxo+7AA5HYXDipNfHJrg6WbGZM1qjhCfDFO9uSrfmWP/yzA1A4HO6hA9tEGurbkN/FeuM2mUXg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(346002)(366004)(136003)(396003)(316002)(8936002)(6486002)(1076003)(478600001)(9686003)(66946007)(66556008)(6862004)(5660300002)(38100700002)(66476007)(86362001)(38350700002)(36756003)(966005)(956004)(44832011)(6496006)(26005)(83380400001)(8676002)(6636002)(186003)(4326008)(2906002)(52116002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/AqqSASgFIkH8HsMvPfQszFAxZ0nB/t4a9VVa0JjT7jAEBwSDL8yYqTBU6q4?=
 =?us-ascii?Q?us3GBcEkzTuiSbyHAPWH3AYJphDgfFiK4JAyoTQ11lK/08PVu4QIS2nFvQDN?=
 =?us-ascii?Q?xvM6isd6+//RCjJVBkKYQYKrmsJPnhh5ei9fYMPD1f+2qIx10jNcqEIjJ4tj?=
 =?us-ascii?Q?+PS1gam4tatxw9VD2Zh+hjOLhZVo8e2BopUXhFH5CjwNVdKgiaDMfa4pounx?=
 =?us-ascii?Q?5u+6HGU1C/ryxtj48AhRvec+7Bg+0+OPh5dmSXNUHfMcLEMTntVEyZnEtxiL?=
 =?us-ascii?Q?t2ndjJyswsP6ina7QTQhGsnmRa7+q3DdhFQflsEj+W8+eWSQya8T3sY2sUOl?=
 =?us-ascii?Q?atd/Tb/SUy9NWeF/vNCQ04Bd7XkJth4D7AsljxzK6zk7v9CB4vCI0KS+ug87?=
 =?us-ascii?Q?QjlC069QzF2oE3oeqJMHVDlrPGiEkIGelejLyISYWs2hfzvsTQyvj/Ra2qNR?=
 =?us-ascii?Q?ter1gsFkiHuEQTc6Rmi9QOPAQbgCytVEi+dcFUYMXXLsbs58gKEzSo5nldkQ?=
 =?us-ascii?Q?hYOikEfzeL+acLIxcL3ccmCHhmZUKQ5spWYfEKW9odn8u91VTGo1fZnb/BcK?=
 =?us-ascii?Q?z7I5Dpp/mn52b8NIWfik3i4mO9QU61rlDwVfj2AaqzQ1bW26dNN7o2/XqrH3?=
 =?us-ascii?Q?X/c6D0r+2g5Gh1QDXfKauYSY6m5QKDDIS6L3Lldg+3z9GRKTsUUjMtjUKCms?=
 =?us-ascii?Q?c+hTkxT+DEhDg2rTE2iyVwXl+oPeoTbCurr0xTNa9cZlfZRLz66rdTzzqW0m?=
 =?us-ascii?Q?IJpoxkTD6b7HmvtzwJFlTJIfYzR8oPGO2PnbxLkr0wWqnLNYXA9Hg57aRJZn?=
 =?us-ascii?Q?1SU8i/u5hHJZ8xQsZSYgmTX0nudon0iEhdudOBESnOW3lU4BDl4u8E3qFKy7?=
 =?us-ascii?Q?+qv19ueed3wBJWcipDOABkbrUst/LgNT96ZFlsEmlz0RkmeE0MdH/cGAPlgj?=
 =?us-ascii?Q?rxXv0SACrNL68qbbbYEZvlrv4RbZTCLuPYEmZkOU5j/euMkPTEe90Q8Zp5uR?=
 =?us-ascii?Q?RvokPzrHuurSXFnxeAsv1+diTinrG6RmYGZGft2hJ0gQYT2/WwkFfN/pUxhQ?=
 =?us-ascii?Q?TH5XQfxJuVaNc5KNmetG2JlbJAQZ0Q0BF9h/3gm/LP+kAt8xWWNGTIPwy7NM?=
 =?us-ascii?Q?TGvOzXOGumTcHQxTeSLtIR0rn48fkQrWNyxTJSlRsPNcMOGIvJZe/ROENLJ9?=
 =?us-ascii?Q?otOabdWx8TJxB3sssoRfdeVkRx46+NPwexGUNZiE5Bs3jGQGxVUdz8BNbask?=
 =?us-ascii?Q?E8LW2mx6WmwcBIEatPCXefbClRjGbjHFCuDYDuLaBaSVrqRROHwoV1/KiLTT?=
 =?us-ascii?Q?+Pf6GgL/65PueVjVf4xXCPpE?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b01fc7c-9fae-4bce-cd34-08d958084e6b
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2021 11:58:14.9285
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uYiuqnd5zuzlgKwphb2a1zEq71GRFWC3kAGRvkUs8uKoh2GNH/WmudlE3SoOM+n8ZcsZNWzOLDnqHAYm5byIk5oF/de96fwbZDepfNyrAwc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1903
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10066 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 spamscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108050072
X-Proofpoint-ORIG-GUID: aFsDBZx80i8H2ykjLd-JqRnulQ3gwh6w
X-Proofpoint-GUID: aFsDBZx80i8H2ykjLd-JqRnulQ3gwh6w
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git master
head:   c2eecaa193ff1e516a1b389637169ae86a6fa867
commit: 314001f0bf927015e459c9d387d62a231fe93af3 [2/15] af_unix: Add OOB support
config: nios2-randconfig-m031-20210804 (attached as .config)
compiler: nios2-linux-gcc (GCC) 10.3.0

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>

New smatch warnings:
net/unix/af_unix.c:2471 manage_oob() warn: returning freed memory 'skb'

vim +/skb +2471 net/unix/af_unix.c

314001f0bf9270 Rao Shoaib 2021-08-01  2446  static struct sk_buff *manage_oob(struct sk_buff *skb, struct sock *sk,
314001f0bf9270 Rao Shoaib 2021-08-01  2447  				  int flags, int copied)
314001f0bf9270 Rao Shoaib 2021-08-01  2448  {
314001f0bf9270 Rao Shoaib 2021-08-01  2449  	struct unix_sock *u = unix_sk(sk);
314001f0bf9270 Rao Shoaib 2021-08-01  2450  
314001f0bf9270 Rao Shoaib 2021-08-01  2451  	if (!unix_skb_len(skb) && !(flags & MSG_PEEK)) {
314001f0bf9270 Rao Shoaib 2021-08-01  2452  		skb_unlink(skb, &sk->sk_receive_queue);
314001f0bf9270 Rao Shoaib 2021-08-01  2453  		consume_skb(skb);
314001f0bf9270 Rao Shoaib 2021-08-01  2454  		skb = NULL;
314001f0bf9270 Rao Shoaib 2021-08-01  2455  	} else {
314001f0bf9270 Rao Shoaib 2021-08-01  2456  		if (skb == u->oob_skb) {
314001f0bf9270 Rao Shoaib 2021-08-01  2457  			if (copied) {
314001f0bf9270 Rao Shoaib 2021-08-01  2458  				skb = NULL;
314001f0bf9270 Rao Shoaib 2021-08-01  2459  			} else if (sock_flag(sk, SOCK_URGINLINE)) {
314001f0bf9270 Rao Shoaib 2021-08-01  2460  				if (!(flags & MSG_PEEK)) {
314001f0bf9270 Rao Shoaib 2021-08-01  2461  					u->oob_skb = NULL;
314001f0bf9270 Rao Shoaib 2021-08-01  2462  					consume_skb(skb);

Need to set "skb = NULL;" after the consume.

314001f0bf9270 Rao Shoaib 2021-08-01  2463  				}
314001f0bf9270 Rao Shoaib 2021-08-01  2464  			} else if (!(flags & MSG_PEEK)) {
314001f0bf9270 Rao Shoaib 2021-08-01  2465  				skb_unlink(skb, &sk->sk_receive_queue);
314001f0bf9270 Rao Shoaib 2021-08-01  2466  				consume_skb(skb);
314001f0bf9270 Rao Shoaib 2021-08-01  2467  				skb = skb_peek(&sk->sk_receive_queue);
314001f0bf9270 Rao Shoaib 2021-08-01  2468  			}
314001f0bf9270 Rao Shoaib 2021-08-01  2469  		}
314001f0bf9270 Rao Shoaib 2021-08-01  2470  	}
314001f0bf9270 Rao Shoaib 2021-08-01 @2471  	return skb;
314001f0bf9270 Rao Shoaib 2021-08-01  2472  }

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

