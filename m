Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A90049B602
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 15:21:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1578396AbiAYOTI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 09:19:08 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:26542 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1578125AbiAYOOk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 09:14:40 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20PAxDZv029911;
        Tue, 25 Jan 2022 14:14:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=AOA3T7T5CYWWQ/tVHiMgyTqnJ/MREMvuv22qc7XzdM8=;
 b=HEZMlLXi0WQNOUx8hN7nyoMi/b+lyagHtAxp3dQWBVFTGsbUgKkr4nHBVCGcD6MpFgMi
 /FfrDDtmqw5XNnZPjpgVabWiNoD7hPNN6hjytCO/NZ5P/sgXGqA67l6UzVCoTzoU1Mum
 Pvd/wYaQWyIPNqo6AENycwDRl4PAT9i/Lj7uQ3CObvIfsUhAn7vZ76oH1ib4cLF0Wdaf
 Xh8vN3CP7lgtmrJgC195nb5Ideg8rjnHmJIg9pO8TF31x/+6KdbHghIZ0OzMIdV2tyow
 UFEhALBA1Fhn+kSJAdzj5YuEzZZLKWNMWaeXcgMtKkYmrcThFYaO/0Pg0rpPcEi3l+L2 4g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dsy7au6c1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jan 2022 14:14:25 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20PEAknI156901;
        Tue, 25 Jan 2022 14:14:24 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
        by aserp3020.oracle.com with ESMTP id 3dtax6hpcs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jan 2022 14:14:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fYrUgXUzzuMG0joMJkJJxubVdRPU0+HQZ2V6ToQTMD7vi8S2RYGaveIp0hZUjPzh1v3x2ur5ZG7MHAZZqvyCsh4M5o0iuc1C5jrcLvmf01h2IiYtvUz6SQqrCpPFJ3IsY459HvFxdy6hrMJI4V5DuTT2kuqlmpleM1U0IJ5VhvX3DBeLkUAfOfz8JRadFN7T6x4+DZDojhkym84yFer2pCHHa6lSV/MKsJZJBXDcsGB4eYALIT8z9h2qqyp83oOyUV4dYQlnH+iO/fB+gsnSggv1zAHmDoZywW3CvoD4VTUVaJiK3p/K8trsG0CSxWsCqcHPaAklvSg0Q+u3L2jW1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AOA3T7T5CYWWQ/tVHiMgyTqnJ/MREMvuv22qc7XzdM8=;
 b=mI3eR5++oe7LWQaoIxoxGcqq2W0pdEzqinDDMsLIjtJLV73znlz8cVZSxAs3FwkbksAgJul67jzAbtrH/Z6bwF3aIBWhcG0rgQtYgfwsAAR5liBHN+gqDiq6HFz3NwCdeb0Br1GJM3hubr0f5ewGN6SSgWq2Qycfj6/rvrl8M1Vcduk2DDWisRVl7QL3+P4/UoMVw7SIZWMZy7ixnTiZ5Xw8UYQpD90CXU8Hm7fqLwo1DXjf3vpcSDd4h7KUBMS8JevEtqFvwyYwcMRW/Fpd5xkZjfr/rHueAex1049O+AG4P/sqpGgt7vk+2PA4XyFiljgu+heVA47ojP0XZDx7dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AOA3T7T5CYWWQ/tVHiMgyTqnJ/MREMvuv22qc7XzdM8=;
 b=NdojT9jYNWnEshE4XSeMlz6mo2eiX86Qsxcv/KO17JSD8ccMUTqKTZYfBjPjtX3pyA8I+x9858/0XFQ7Uh+STt68SnqJIMUKTcYT4KUvh6qyet8XfhMnOVyEtU5KG50O1dZdDw9UVO5QJSJUmPFLbrYkRxX1Oe9Gi1Ft2MX2nis=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CO6PR10MB5475.namprd10.prod.outlook.com
 (2603:10b6:303:13e::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Tue, 25 Jan
 2022 14:14:21 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::c13b:5812:a403:6d96]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::c13b:5812:a403:6d96%6]) with mapi id 15.20.4909.019; Tue, 25 Jan 2022
 14:14:21 +0000
Date:   Tue, 25 Jan 2022 17:14:01 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Colin Ian King <colin.i.king@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-parisc@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: tulip: remove redundant assignment to variable
 new_csr6
Message-ID: <20220125141401.GV1951@kadam>
References: <20220123183440.112495-1-colin.i.king@gmail.com>
 <20220124103038.76f15516@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220124103038.76f15516@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNAP275CA0033.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4d::14)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6aa0a650-1296-42c0-fcc3-08d9e00cfb2e
X-MS-TrafficTypeDiagnostic: CO6PR10MB5475:EE_
X-Microsoft-Antispam-PRVS: <CO6PR10MB54756EC22E8C9F31E0089CC08E5F9@CO6PR10MB5475.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1284;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O2N9izYMOcOsLnsAqc3+xmLlxBoHzj35qtcgs1hCwb/rS3UIOEyttZaP/veFbpCuuE9jU7oe91DvheLNuHBdUbgEsOtqiNlrqzjwFrL3ZRXEDlju48+oI7iNdldHIqQkmynmID6dSTF6wouXS0WXdr+zUVtT/M1nOqXj7WIj0aSTc8MzN1XY7W/xXhc2r3M/3CPkjBDVdMo8PLWD5hcbXfizp5blM24yTwLmC8+9Cm/F5i2OFXqMj23T9mBx7SAErfYnHgxQdKcXCGK3jzvc65kzi62ZWuM2BeenE/mySI/CRqOb8ui2gTCn6QdKoBmDmLBXeQuPXRXpkcOyCPigBIEzzdGtzgDn6KkCWxT4VV3t11waX8pglAEU0EHfvAcnXCfDeUSuRXUmEo/SHNtlgxK5WYuVcpl8FJjLMHiEpAvd4fWbTnucOqCYCawUy+z7nYDO00VA2O+1/nbQtnr0zvdM8cgU6nOrdR6UjgcfdASPQHo3xq/yzv+owUdjsgxiYtYqWh9n5FXB8uFXHU2j2kL8+rfhHlN0i2IA4o80UlmUKccjQfhHO9lz3++7U//9gnaG0K7Yhpyhl3ARoXJNdN2f7HpiSDsBgPTMSazJcjWqXHhh2fPFogo0eNJ8TqbgNzL8lA7XfJ7QYmN7Zo8ce650aRgPAym7z8uTlP7LaTzX3MdLUkmToidhcEi9lyj05IPozadwNny1k9nv9aykWg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(6506007)(6512007)(6666004)(9686003)(86362001)(52116002)(54906003)(316002)(6486002)(83380400001)(508600001)(6916009)(26005)(186003)(38350700002)(38100700002)(1076003)(33656002)(8936002)(5660300002)(44832011)(4326008)(66946007)(2906002)(66556008)(33716001)(66476007)(8676002)(20210929001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AWIk5Fqsn3jFFf9oe17mQiNmpw9Ylb5zck1PLvq+cD46cj3RKP0Vr6/GR/e/?=
 =?us-ascii?Q?7HJ7ll2O1E9wu+FbwbsReJjPXTsDGADkK9s/vqgx7weR93AtoBeJZbtDv3gW?=
 =?us-ascii?Q?C5IvydMdCt96ZQEXIfB0YbqWuqmEp8oH49UkdVQREAC3hdshCn0toZmq39pQ?=
 =?us-ascii?Q?yCH3GLVdOqGD+qiPwInoa6nBliBVWt5CS5UC2sYNq8TciWHQtBfZjby7MxFs?=
 =?us-ascii?Q?X9xCmuXP/UseU1dw89GHkhNx2HNXFsC07QmJ4PeYK3iqVTIhZBvJ9d7li+Yw?=
 =?us-ascii?Q?P2zMmwoYQ5eLjgNXnjFL0G0T5pzIGXV2Y8pLah5w0Z+pt2pxKP68SLQdK3ns?=
 =?us-ascii?Q?d4MZZbo7lmSARyptBDksJb9b2DwA/SFbNl6VTbZKwyD1CPEmkkPPsgnEX3Eb?=
 =?us-ascii?Q?LdT4puCqd+62dWQzEmco7zlQrSCeoNCB3LU0M4BfIzT5j/5T23rmR5ynQ9R7?=
 =?us-ascii?Q?Gr2Io8XWE6WAJsLYOwvPjy+iCoF74JPnxWU4OJPIb4WtCaES7jTn/QydKIJk?=
 =?us-ascii?Q?qWYsNDataEoYaM8D4/lmdsmsL7BcAS2qD0zeORr930ugix+ioTzfraqmA1oX?=
 =?us-ascii?Q?8fb/XYbiEXlQjIL2uERsA5uyrKQDjzMl/1Q5c3ulTVJb1e+qmnp7LlzY4jVh?=
 =?us-ascii?Q?bB2uh1MeW+iF5tTB7fTgXKUS9kpa77MzszvFQSf/UluCIyLLHw5fq13abN8j?=
 =?us-ascii?Q?9+qKZcA1hjY78NBxcTgX41y9gGeHEl7IIJ4i3fKTE/xk/8yyhyl5q7O0+JDu?=
 =?us-ascii?Q?ao8yXN+XuhVN2PhNbI8D7owxmqXuWATE1F1cV5CF5jvNp+33EQ2KjEQnEVQX?=
 =?us-ascii?Q?9yGtsUDH+877TwzUMBzHTc9DxJqhWhGzhmTBv2+T1GTD5HXXyVYSOM2Kr/Rm?=
 =?us-ascii?Q?eI2eVyNE54T5V8x+ORuuXOFaed71mMtT+r6ZnNSdfuM3nFo+pET5tCvwAsZi?=
 =?us-ascii?Q?B5O3ah5uAsc5O0qw/kMoZxuFyDmIEu4EPtVpO5Yni/nmpTyTuqlMa/TQdu5p?=
 =?us-ascii?Q?5ulJOMo2ZX8Ew7Kem9+FEcbMsSqX9rNi0TorM9bBGqZ8UAjd+87WjXblwFJe?=
 =?us-ascii?Q?o75FuC61rx4UbdxS72jJ9KfsKpKnLi6RP3ZR1b0d4frCYXCDPWmkyPHnln15?=
 =?us-ascii?Q?pUy8QyKMtYXjmvp55K9nwFsM6YikPlcoKQF6q1RyMfq+5s6JW3PUFXnrdTPt?=
 =?us-ascii?Q?cXcgJaFePVMdCZrGeI4bsC9YqjAkRxnEkVt0xWUp/RuvplEoVdvPd4+pKSSo?=
 =?us-ascii?Q?9kDTwVcDVUxrnCQkxd3sAfPZmLhTnAHWz1ZnapEib9Mi5h97CWCjlwspNoBl?=
 =?us-ascii?Q?OwMgY27sf52F2O+FBS9KHtCOqawDEVpGbflBGX6yJhMEAY3vXm4S+0a6E7QS?=
 =?us-ascii?Q?JtWo+cKgFZbaeD0YcT5TjsuA2vdy4rgHVxzKSx6nayZJwdxXrVuOu5jBIW+w?=
 =?us-ascii?Q?dLmjg+kR4sOrk+CWBKvhz/fayxiz40ZnMRT2UgHz1hIq/kN3EFXEh8R/FSSg?=
 =?us-ascii?Q?1kEBBuhhyw8n6BR6QYPHlBAHGkyhXvezvGmgGQzmxojO9n1aHT5R/cCrVDk7?=
 =?us-ascii?Q?QRyMd+GniEA8H6ZZI/ztliQ/AZfidtEaodu9bl4yW/QtwYaIwmIgZCk/3Dg8?=
 =?us-ascii?Q?b65HITku7Q9qlIP8eAhUhJnBP3u1wFez/6IqVwsdVQE/NiYab68tuCIz29sV?=
 =?us-ascii?Q?nKPZc2RN/f+6Fy+GJlgg2EY0I1o=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6aa0a650-1296-42c0-fcc3-08d9e00cfb2e
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2022 14:14:21.5212
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uApql8IkpkzW/QGpW3S1nR/N+QELSmEeSbJr7b59oQUegmvhHpikXNu09VvT8Ab/xycQolvPo5o46+34ShrN7G0lThLeaaaPWNGWEIraLGk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5475
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10237 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 mlxscore=0
 phishscore=0 suspectscore=0 spamscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2201250093
X-Proofpoint-GUID: 6is_FKRevyMC7Svjmnfs2jrLVoNfWUoy
X-Proofpoint-ORIG-GUID: 6is_FKRevyMC7Svjmnfs2jrLVoNfWUoy
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 24, 2022 at 10:30:38AM -0800, Jakub Kicinski wrote:
> On Sun, 23 Jan 2022 18:34:40 +0000 Colin Ian King wrote:
> > Variable new_csr6 is being initialized with a value that is never
> > read, it is being re-assigned later on. The assignment is redundant
> > and can be removed.
> 
> > @@ -21,7 +21,7 @@ void pnic_do_nway(struct net_device *dev)
> >  	struct tulip_private *tp = netdev_priv(dev);
> >  	void __iomem *ioaddr = tp->base_addr;
> >  	u32 phy_reg = ioread32(ioaddr + 0xB8);
> > -	u32 new_csr6 = tp->csr6 & ~0x40C40200;
> > +	u32 new_csr6;
> >  
> >  	if (phy_reg & 0x78000000) { /* Ignore baseT4 */
> >  		if (phy_reg & 0x20000000)		dev->if_port = 5;
> 
> I can't say I see what you mean, it's not set in some cases:
> 
> 			if (tp->medialock) {
> 			} else if (tp->nwayset  &&  (dev->if_port & 1)) {
> 				next_tick = 1*HZ;
> 			} else if (dev->if_port == 0) {
> 				dev->if_port = 3;
> 				iowrite32(0x33, ioaddr + CSR12);
> 				new_csr6 = 0x01860000;
> 				iowrite32(0x1F868, ioaddr + 0xB8);
> 			} else {
> 				dev->if_port = 0;
> 				iowrite32(0x32, ioaddr + CSR12);
> 				new_csr6 = 0x00420000;
> 				iowrite32(0x1F078, ioaddr + 0xB8);
> 			}
> 			if (tp->csr6 != new_csr6) {
> 				tp->csr6 = new_csr6;
> 
> 
> That said clang doesn't complain so maybe I'm missing something static
> analysis had figured out about this code.

You're looking at the wrong function.  This is pnic_do_nway() and you're
looking at pnic_timer().

Of course, Colin's patch assumes the current behavior is correct...  I
guess the current behavior can't be that terrible since it predates git
and no one has complained.

drivers/net/ethernet/dec/tulip/pnic.c
    19        void pnic_do_nway(struct net_device *dev)
    20        {
    21                struct tulip_private *tp = netdev_priv(dev);
    22                void __iomem *ioaddr = tp->base_addr;
    23                u32 phy_reg = ioread32(ioaddr + 0xB8);
    24                u32 new_csr6 = tp->csr6 & ~0x40C40200;
                      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

    25
    26                if (phy_reg & 0x78000000) { /* Ignore baseT4 */
    27                        if (phy_reg & 0x20000000)                dev->if_port = 5;
    28                        else if (phy_reg & 0x40000000)        dev->if_port = 3;
    29                        else if (phy_reg & 0x10000000)        dev->if_port = 4;
    30                        else if (phy_reg & 0x08000000)        dev->if_port = 0;
    31                        tp->nwayset = 1;
    32                        new_csr6 = (dev->if_port & 1) ? 0x01860000 : 0x00420000;
                              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

    33                        iowrite32(0x32 | (dev->if_port & 1), ioaddr + CSR12);
    34                        if (dev->if_port & 1)
    35                                iowrite32(0x1F868, ioaddr + 0xB8);
    36                        if (phy_reg & 0x30000000) {
    37                                tp->full_duplex = 1;
    38                                new_csr6 |= 0x00000200;
    39                        }
    40                        if (tulip_debug > 1)
    41                                netdev_dbg(dev, "PNIC autonegotiated status %08x, %s\n",
    42                                           phy_reg, medianame[dev->if_port]);
    43                        if (tp->csr6 != new_csr6) {
    44                                tp->csr6 = new_csr6;
    45                                /* Restart Tx */
    46                                tulip_restart_rxtx(tp);
    47                                netif_trans_update(dev);
    48                        }
    49                }
    50        }

regards,
dan carpenter
