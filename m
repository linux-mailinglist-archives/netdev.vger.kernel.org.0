Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1473241AEEC
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 14:24:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240691AbhI1M0O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 08:26:14 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:12384 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240637AbhI1M0K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 08:26:10 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18SCItaZ004515;
        Tue, 28 Sep 2021 12:24:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=qcgvQBy9QDXHpdPuRmyzp1bj8bCCgylYH7yNnKN8Ndk=;
 b=SFhgexLvNuoNyOr8Il3SfNzX0ttaFGz01JBFkiGTml340lsPHhbKyH3u17H/fUwHO/br
 kmZXCluiKoJCvJXWjBj3qAMneHg/84Gs9aIhJmb3F6I8d8esHy9PoxBJAzvyhEVLE3gV
 W6HVZAJbgpZ2cQUoy2Q3pukpKtP5fWrYfvz8VXSD9PjTywwQZVd+lNJs/Su1bw+t4jTP
 ohYwJveriVgQLT2im5m1M7QPpOAaODdUSw6I5Pd41BUUa7AG2cYf6oAlBwP7crwekRiV
 kQF/ROxAFIC/5ezucnIfSnbuI5V0Kr+cbVG8HeS8WP759GWBq/ynQq0AMcorcZSTclQm 5g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bbejegk81-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Sep 2021 12:24:12 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18SCGNRr173630;
        Tue, 28 Sep 2021 12:24:10 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
        by userp3020.oracle.com with ESMTP id 3badhsnwx9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Sep 2021 12:24:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FPhX5dza5qhsEx+ZtadGtODm3F/uNB64M+YCQl1HfADh/TtVsmdVeNAezoPthC5IetSRq3NYXiDcTEN2jPxTGL8YKofp7/QahXMjLv73Fq89ypcLd+NJhcdwAhj+IY0cnXIdQGWQebI5/9ZLV5s5H6D4T2Znbx9EjUSFSW+uqSiwBoM/IqvfHpfB5/jfH/qKPUQWSW5y4O3m0SJxtNcV2M9PQv5/mkOPHeZzXWJR1XEB5sIaklIZMpf2tAOiBK+/DaHqO/mKEwDkSpnl3zCujw+GH/COgwZ0g+jeNCxa0jFHA+Hn68HZGz/lqvslchAqDbSEieY+K1Kho8OWf+iyPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=qcgvQBy9QDXHpdPuRmyzp1bj8bCCgylYH7yNnKN8Ndk=;
 b=CZdpCkrfQ6+smBBECfp+cfq3XUOaVerC8BK2kgu2nMXindLzUhKQl9yh1O1KB6aNLh9X9iDs8HYp/o3zD5wOxaB80tRggWTkhwVbo2UD7Adp/NFa2FbKdqWtutpB+3LjLLQx8sdpidGSbelCZUEeyx2/qlcwrp2wD95eDoE0iYIbzUgp0llneDe/X0bPZnGnl4bZ4pEBLXxSgpGh8hujHHYQY/djMJcXAnAipe7gb6IIL3AR5+NDYOOMChsKtoIv/YCnhBY0U9gHjXjVMCfOuoUTIBQkRHxOkZbW85X/1Hf6CEMO4sj51Uxyb8uDCf3lVFe1T8XyiTFVTzkoMxgtCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qcgvQBy9QDXHpdPuRmyzp1bj8bCCgylYH7yNnKN8Ndk=;
 b=ZQdiqYNKtjSo50ATNd2feaSp50K5H5HDg4NVW/KxH+Hl8JHDWGXDPnGe13kEjJy0zTyS/nJ3Wq1psdYyJHMBeKiWfQWhkfvw63L8jAt72I+ki/Guhvg2nQJZYp7DbNvu9wvqjwZFZ7TrmA18mBEfYjOQxyN5sxQOeBB/hAo/VGo=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CO6PR10MB5460.namprd10.prod.outlook.com
 (2603:10b6:5:35e::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Tue, 28 Sep
 2021 12:24:08 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9%5]) with mapi id 15.20.4544.021; Tue, 28 Sep 2021
 12:24:08 +0000
Date:   Tue, 28 Sep 2021 15:23:48 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     Yanfei Xu <yanfei.xu@windriver.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, p.zabel@pengutronix.de,
        syzbot+398e7dc692ddbbb4cfec@syzkaller.appspotmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Dongliang Mu <mudongliangabcd@gmail.com>
Subject: Re: [PATCH] net: mdiobus: Fix memory leak in __mdiobus_register
Message-ID: <20210928122348.GO2083@kadam>
References: <20210928085549.GA6559@kili>
 <20210928092657.GI2048@kadam>
 <6f90fa0f-6d3b-0ca7-e894-eb971b3b69fa@gmail.com>
 <20210928103908.GJ2048@kadam>
 <63b18426-c39e-d898-08fb-8bfd05b7be9e@gmail.com>
 <20210928105943.GL2083@kadam>
 <283d01f0-d5eb-914e-1bd2-baae0420073c@gmail.com>
 <f587da4b-09dd-4c32-4ee4-5ec8b9ad792f@gmail.com>
 <20210928113055.GN2083@kadam>
 <c86fecd6-6412-fec8-1dce-81e99c059e38@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c86fecd6-6412-fec8-1dce-81e99c059e38@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNXP275CA0042.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:18::30)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kadam (62.8.83.99) by JNXP275CA0042.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:18::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.13 via Frontend Transport; Tue, 28 Sep 2021 12:24:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5b4189d7-838c-483a-14bf-08d9827adea0
X-MS-TrafficTypeDiagnostic: CO6PR10MB5460:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO6PR10MB5460C777A77D5CFB18297CEE8EA89@CO6PR10MB5460.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: loeYEv2EPQyXZDHQAGPLsCtpGq5M2OdFCE5fDfMnYIvZGhBx6UTHlv6/EaPlYy7xASWOYZtBPuC6288T9OTeSsneog4CbIXalVOO119KRYv/hcxaXtsQ4GYgP7p4k3udPm3GEnzlia9YDSCc6Xx0cBLXhalTPOtKuOUBGn3aJ1b8NytaK4wXM2KUyvlyGCOiavyOCOYnALlbWrl7YJrS3dmJWZxo1hLIIxjNooxWOsAo7ionK/QVnfAGHA+R2YC8nw6de7FUvfy3MRpf+BkR6LTpBDkcSQSbNZh98hCY8Qf7JUCsyT/4wP06Vt5cNppAsmivXPaMqOfMuS6O1Ujt0YArtYF3iboj4FNzDNnhHJdSXvLuM45QWdJ/pZpMKUP2VamVdQXRsl9vsfuNMGwdGrsyaXeX4k+3ivgQ8eAqQLC44+Yi5h37k2vQqevyDTFbiE28qxrbc+GInOVyLvmJi/XzxtyHJLRUlSc2F/YLhV30o2C/Bep3vn2qUZzj/QgAZALA+WoIjlkBjs8wIg2tL+0KOaOe9CNb2jEk/iX5jMNtrU91hP6wEJ97sih7iPyHKxaGKXA9BRt5cASElMqPVXX3Ns/Uek0nwYsqiGcG43tSvGonxh2m528x26RVBjhuGPU03xRX9OKkL3I5NbwBrtNh+2ZM9+mLeT2rYdpmJ0rjfFhRhEePZZU7YdUlEQoPTAHqmCfrojuGGd96uZuCjA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(38100700002)(956004)(33716001)(66946007)(38350700002)(86362001)(83380400001)(8936002)(6666004)(8676002)(5660300002)(9686003)(54906003)(53546011)(55016002)(2906002)(508600001)(52116002)(316002)(186003)(66476007)(33656002)(44832011)(6916009)(1076003)(66556008)(6496006)(26005)(9576002)(7416002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MJVVT9KXzwXy7MTt2kVLMmNXpF7DpR8gxLZohSwPDFkUvscb/L+ofReKpWQI?=
 =?us-ascii?Q?K9YNg1M9ie+yDl2fvwsZzlKYtRGV4VRNHfXqrcQLdjv+SmpEMiWeWYR+A2Sk?=
 =?us-ascii?Q?GkYrJj/PXAZ76hle7IV3jWFh8pDFaeiwqkVLyZcbr7L13eFI6uCEdNeFDFuv?=
 =?us-ascii?Q?qzycSsHmTiXhT9YBbvN7emGZiI/1MGGaMGleyX8m+Qn4fG5WLITp/up2UuYV?=
 =?us-ascii?Q?mpUmXVVvI1XBcEhpJ5n4IcZGoR60OsQdGGjXurwPSLf47N8XV03uhzBMMWpX?=
 =?us-ascii?Q?gpkBwO6oy1DHTKJ1X4ngL/zTSyc4HaqSPQMoNsZymzAQi1VCIk9g8nrEy38M?=
 =?us-ascii?Q?TfWAYe59cIYmj8QTV+YCZo5AGpyiuUP4yh0Dr0VFxJYj7JbcF6UPvKyx06eD?=
 =?us-ascii?Q?pzacerYh+4skeFrEeVvMhb/KJTBc/IQ8oD9q2pWs97xUJMv+HN16jDm5nHgJ?=
 =?us-ascii?Q?lzB7SH2Nybw7UYOzfOccx0pXZ6RKYgwiBRNRKTP8IsmNaDrSTIIsyx062+lG?=
 =?us-ascii?Q?W8rPCYOcfA/6F/rRTgeF5CeyFE+HA7l9UdNYOwvdi66pOTcxQtt40EsZnzvJ?=
 =?us-ascii?Q?Usy7vvKH3uLzGqB3sYba2avIDRI3g0mBm1OFtp4RWIxI+20xkhQSFK4PEZwp?=
 =?us-ascii?Q?nLeB/ftdKTTGecDpt5wm9pRYeeBYgI3Aw/Xtu3E1m8StL/0mXqpYzNrTg060?=
 =?us-ascii?Q?BRDgvDU6pDmhCQ/NutoEyhrS0bLpZeN8lntzw23xb5Cyvaw9FgqvIu/bRrd/?=
 =?us-ascii?Q?pBi04rNmjBgqgNVLOhGsNKVpnJb0V7pONRbgdx7bc71syYnFgAewZhc5ELEg?=
 =?us-ascii?Q?15R/eIOgpfD+ybClXNKLq6JwZAPUneM+JSkrNrBa4Lo31CfJoFI/KfFOc+dq?=
 =?us-ascii?Q?pIVk0ZiO9+EyJKzb4ZOt7ON7xYUVQKPnnRbTf4GH/mtWYrgmMx91aiaiA6EI?=
 =?us-ascii?Q?mryYxrTX6eBP+P+Z9GvQHp59eAZs7ysuDefsaEn1V7pHx/vdogDSTbL71dwy?=
 =?us-ascii?Q?x0EDYMRif8TmfO6bqdbdNKJ8M7+YqSAse2/s+b+l8/yLL1CuvzFjeuHlWeIc?=
 =?us-ascii?Q?eFzNL6gXFVHMqpqfA9TKwb9FQtdkrOGuMiQ3oUqVGxS/ZDLnkGTgKZJ9O1Oc?=
 =?us-ascii?Q?wCEAdjQHhaW5WqR5I+mnS1WKGz7shDpnf3dESCInPTy+iWWE0qeEhR35N0Vq?=
 =?us-ascii?Q?cGPtqdLDhSfYDR4WkR4/kVkR2UTBhOgAtBzbkBsBFcKm5hlzayvaQDhosk3a?=
 =?us-ascii?Q?qrUHpnspKuG2LTad+D9ZtO+75/TsgPAZvXVqa5c8nmfFBcQ5o3BNLyYB7aJF?=
 =?us-ascii?Q?NhgKASyXp70BHo+KLW+HNEPL?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b4189d7-838c-483a-14bf-08d9827adea0
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2021 12:24:08.4728
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Dg6KrSboTul7i6FmUMMgzN4ybAuwPtFbdO978LFnafP3ty+hVL1cx9ny8lTkEVrqhxqRBz/RzF29m86tQrL6m4wzxhJd1+y4vPh71j8cT0I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5460
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10120 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 malwarescore=0 spamscore=0 adultscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109280070
X-Proofpoint-GUID: g9ax_bI5C2mqe_T1p88K9wa7UogjhcHD
X-Proofpoint-ORIG-GUID: g9ax_bI5C2mqe_T1p88K9wa7UogjhcHD
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 28, 2021 at 02:45:39PM +0300, Pavel Skripkin wrote:
> On 9/28/21 14:30, Dan Carpenter wrote:
> > On Tue, Sep 28, 2021 at 02:09:06PM +0300, Pavel Skripkin wrote:
> >
> > Huh...  You're right that the log should say "failed to register".  But
> > I don't think that's the correct syzbot link for your patch either
> > because I don't think anyone calls mdiobus_free() if
> > __devm_mdiobus_register() fails.  I have looked at these callers.  It
> > would be a bug as well.
> > 
> 
> mdiobus_free() is called in case of ->probe() failure, because devres clean
> up function for bus is devm_mdiobus_free(). It simply calls mdiobus_free().
> 
> 
> So, i imagine following calltrace:
> 
> ax88772_bind
>   ax88772_init_mdio
>     devm_mdiobus_alloc() <- bus registered as devres
>     devm_mdiobus_register() <- fail (->probe failure)
> 
> ...
> 
> devres_release_all
>   mdiobus_free()

Argh... Crap.  You're right.  There is just one bug.  No need to
change __devm_mdiobus_register() and trying to do that would lead to a
UAF.

Your patch is the correct fix but with the modifications we discussed.

regards,
dan carpenter

