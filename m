Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3499452CE6
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 09:34:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232323AbhKPIhK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 03:37:10 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:19274 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232129AbhKPIg4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 03:36:56 -0500
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AG7UJbu013778;
        Tue, 16 Nov 2021 08:33:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=corp-2021-07-09;
 bh=xWqZLEG8FvYVPAWBvuM2luBBRq2trYfk1AOoNRWmB90=;
 b=IRWGN7u/cAur7F5lwRZxEfhuOEow0PvXqoza1SPTP3s/xKa7K5kwYeZjQIgQebSSQWF5
 xnUbigZc2g5HYyYEIU3KjnYAtqsvUHR2zJBDvZ1Ei9QJdVaQmtyWye3rrcNobCkROd+l
 QUX3Tv0Fa+lLY+mbVivI51Zsu7XJVNfPCpgm67kdjVVi8qTX+xeSij9nbfA3K5hj95e8
 CpefX7PxUS/9rnHUxGGQicymPjWPHfM2YD5aNDVnxFXYBsOAGbq2p99DkQHtz5QONrbF
 EFS+Uznf870Bj3r9/QZ/5xvGkSPgJi852xiG2IHdZyhcVBgtVq0roFGneTODzEIfjspw cg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cbfjxr9n0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Nov 2021 08:33:25 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AG8V3Tx188485;
        Tue, 16 Nov 2021 08:33:24 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
        by userp3020.oracle.com with ESMTP id 3caq4saeyw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Nov 2021 08:33:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ep62yWfoee9n8hTiRJ9rqhvfFIsYr4k1axIkrWrEoJmyJZyUCUvprc0oEOuzDIjnqsPTb01kun3oW1ll8iY87Oeby7wEUi8ED14nNYc6f/pZmHr/0aiZ5iVDdTUiU5dk7cMvOS/oGOlGQKu6zoj4k18jrwAzCO28zT3Mpcs7dbTEgNIjVrNuNpw5VxWXP4DIc460KNCKolwCNiTmDghPisu4exrA+tX/yS5i1g2PZIR5o8aEKZzUBF3lGfRQEPjO+FxW1DGgnZ07ZIek9xxqMaub95LBfW6jPn4zI/xQoUYjLllpTDY5+9dulluh/G/vhrQqLeAoGl5oqPZNPQa2lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JwCX9UIc+knuZoIfHMZkDkF3uj4gkic17ZYwY+WTAN8=;
 b=mEPpJTeBHTwmwC0MntXJchQFOET+j4zH+O4diynNQcQx+QiRi7vIm+rVDiwBpbkWTbwLNYTxcIKZ8UPcFNX4ZuQx9r0vo7koO6CYh45GkUx8XEF8TEWB2fNutBmVEjUtiXcHSqHQ7CsyXx9RIRFov+Wl/8LAB4Z87M2m5iVg0j/HysMIO/qUVbK0NrYXKCYVus3GY6Ps2+gINVpYoBBdJ0JceV7SQlt0UryFtVTG3olYXmZjQuTuEWcFWX5JcBUdcPlZXm37GLfeUtTo4wHKEKb3U8H7VYMpSiROadyqcbavgiVdLqRGB2wGR04gy++gH51mQ5iMfGKBY83zAFrjQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JwCX9UIc+knuZoIfHMZkDkF3uj4gkic17ZYwY+WTAN8=;
 b=NQu5uVY06rhAn10GLTnM2YVguzWMwnDffcXLxxnxv+zPrUFer8gfxddL9be0ZTgmc1OwrwJ3T/Ij4BiugokeQsiY2bHVtMX2u5NrrsZNCDXp0pu/SNrVGQur5xy6L6NT987U4dgVD/5eCUIfld+FHCyhE5j9DMW5KFha02e902w=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR1001MB2399.namprd10.prod.outlook.com
 (2603:10b6:301:30::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26; Tue, 16 Nov
 2021 08:33:22 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9%5]) with mapi id 15.20.4690.016; Tue, 16 Nov 2021
 08:33:21 +0000
Date:   Tue, 16 Nov 2021 11:32:37 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     roopa@nvidia.com, nikolay@nvidia.com, davem@davemloft.net,
        kuba@kernel.org, bridge@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] net: bridge: Slightly optimize 'find_portno()'
Message-ID: <20211116083237.GH26989@kadam>
References: <00c39d09c8df7ad0673bf2043f6566d6ef08b789.1636916479.git.christophe.jaillet@wanadoo.fr>
 <20211115123534.GD26989@kadam>
 <b3c93506-7dc8-a5fe-6cfc-938fc88b9f07@wanadoo.fr>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b3c93506-7dc8-a5fe-6cfc-938fc88b9f07@wanadoo.fr>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNAP275CA0014.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4c::19)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kadam (102.222.70.114) by JNAP275CA0014.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4c::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19 via Frontend Transport; Tue, 16 Nov 2021 08:33:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4a5b034a-849b-4652-4a18-08d9a8dbbf7d
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2399:
X-Microsoft-Antispam-PRVS: <MWHPR1001MB2399E11991712AC556BFF0638E999@MWHPR1001MB2399.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DYZglhG05/+tmfzoX2Ye7xPfawYKcN+mH3C5TM3epZZj/H+XMlzBtQDhPeCZ/gZWyG/Pe73YUmLP8BMGDP0cJzEjgmOs5qQ3xZdFI38SLfJITteTLveWWBKgM6BSe3662+lkZiPBI+FKcYlYYYXjh45KEUSZm8CrDwqhbYyLs286RoMRoujxwdZP4o9lsdrHYiKbFy2A2InIbPguo2IWGR/Uw5xFaom8almP0V5josYCSOlXjK+m/h9p9FROMyHuxVsW8vIVm71HVqy0LjLbsSDZfbhSFuRKxVfosvYUrQk0Knp2WTEQ2vZNq7Cato1PT5jY8Ke3gf1xiv2WGM0kieO5sZWloEZFMUxBprk6XuG1zFZR0wHFCHlE3HrrB6hHKt/DQtbNue2fKj2+ypzXUTG4NlMcmKp9V4jmj1qySoUWAMXeTudSnOs/6/ddfgrTYKiOKdxrVwPS5vnOfpN/7JzSdwCb/i/z890dTtwhdRVv/NxgIVDag0yQU5rpMqha/RzRko0i6u+owmy/rqzW3m9jkVc3y4X/lNiBR91VAZwF9bjflw2P/wCPssQ2j1NIytmcHH62u9ds9EVg9ZAWVQ1fddY0P/8zx8vzuLHTA+Vx+MZ4oOM/z+ytfoNMjrAZ/C5jMt2NGfDP9hr/EdePhcdIAT+ZDolujo+do6RWKWWYBEABTFPFlwvdb/HFgRQxg7hbn/th7yT626DdfqEmWF7LnxBvt1zMcEe1yoY5SrcqtTajBOQZFfFoozY0c0zv3fHSMIBSET/BdUtClw1HmS/7m27SjZqVW4BSYb3NUM8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66476007)(66556008)(6496006)(52116002)(9576002)(66946007)(966005)(26005)(956004)(83380400001)(8936002)(33716001)(2906002)(5660300002)(316002)(86362001)(4326008)(8676002)(186003)(6916009)(6666004)(44832011)(38100700002)(38350700002)(55016002)(9686003)(33656002)(1076003)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?7c5BZ83/huPmFcErR6lJNQbQtLF/Sir8oYl8RbUj/GrxSijE3NHBCxkii7?=
 =?iso-8859-1?Q?ZEyyqQQbZbrMdpPog7k8dDnO3qt5hgLRi7+Ei//2ngmXxafEKqLk/lEufj?=
 =?iso-8859-1?Q?wGefAYJXbwxDm39bm9kpNpZf0xH/ohRPR8gif5+EwwkpylCS88+JtzDkqB?=
 =?iso-8859-1?Q?s3H6RO9RBoDG7JsVrHNVbkFQA7mM6hEfE1fVnjCIC3DE+QcZElMF9xVNML?=
 =?iso-8859-1?Q?nzA/E3yYB9hwuWu67LDOHrvxxySOoD+WMldpEHkSTWW+BX0oJN22HOKIFH?=
 =?iso-8859-1?Q?7HlMrDHjAjslWZP5bSkKGIIkFucFJ0kro0whMNzeDJbaMrx8IGsmy00xWf?=
 =?iso-8859-1?Q?T0M+eDC/fw+oFKCpZe1So+QWac8Fz9l72q0bt07t7Lf2EnuLr6kOqQm0uJ?=
 =?iso-8859-1?Q?5PSCN5nF9fIWVZhRwNI9LnbZPTmhrFR7gAR3wpecXgm2Jj+eMwU9LuUYzX?=
 =?iso-8859-1?Q?wPDzems5XgC4EQYVfX7I2u2Qeanay7BX7VeFCAD9kW19fsoGRYJjHQykWL?=
 =?iso-8859-1?Q?ZXToLAuhXCuzaMQVnZAPDTQW9RXSyf2k3YyPpg6YNdKLlijGiIDouSqXAS?=
 =?iso-8859-1?Q?U59NC5tJeBl3oDgRRa4tZqf/ZsZlynul5eC4BUMjEm2fD7mLzP+/bvNWxm?=
 =?iso-8859-1?Q?SlxY2crDfuz5t9zO0X17bun7uiMx4lVRCfrKk2kEZcffhFXXF7w3NVVCJ1?=
 =?iso-8859-1?Q?RlewmkjQNBGJGbIa5AXvAY9yJNaviZePl62LNGSiLxm4r9hduueaRBBPaU?=
 =?iso-8859-1?Q?944+4+pJlmBl0qi4GGWpMfeXbsaiovD93qTxJsXbUJb7U6ko70ZZUG7ezn?=
 =?iso-8859-1?Q?ZUwQXALZpSZtfGej4HtGU2BYdBdNY1PydnzFRKLf+eKYwZmGegUV37gv55?=
 =?iso-8859-1?Q?H66BbTYqMzsEcHHAZLJAmQjcbOu1THEyF+tnmJHEm2JhpNNMVnvV9MI6k8?=
 =?iso-8859-1?Q?VRknhsMqs+nRyBcZGMDda4ZUIX0+EXrCa9npIaJsAv6xshOfJ0tantX44N?=
 =?iso-8859-1?Q?8Z2ZSA3ClgxLwEXVywMoX8DUH7w07wJ8djpSMw5C/ztj20tJrWqVkFNe/b?=
 =?iso-8859-1?Q?3FUE9O7PJ/ppokpwonzVyx5+xOYsbqRACfUv54FCjR1wyJnbee/dyOCAqA?=
 =?iso-8859-1?Q?tQgaJXnfjKm8r7oeSXK1dqpQBm4x6/SjbBrmrXse1e2tWuP/DLsvV7N1Zx?=
 =?iso-8859-1?Q?wE8wS7ngTHCzX2Nu76mlOgj4KuYpv6y4H6+FKT5xVUAst3hdbrjk/nlXir?=
 =?iso-8859-1?Q?iVDHh/O8Wt6vCPPOS50b5nZB+kXR1ESKykMl0w2Y3X8ZIPeLUjqSnQpauh?=
 =?iso-8859-1?Q?tdAXokeWvArA9nEZKE7Ii1x91q0gvdyjaiRQZTD0D6XqizJ/g9Rd1sZ3EL?=
 =?iso-8859-1?Q?muYsHPx851+9P2y6puH1hBr02rjMuiZaXwzhXQFBI1An7pPpt3G6D1lLI4?=
 =?iso-8859-1?Q?1U+fQo35324w/MjeEZ5yPg7n0LZEPwYp/HzEq2LNDRoWdLM874OztiJoot?=
 =?iso-8859-1?Q?9gA6Huino2wjrARlrRIMtg+R/xvddrUAKal3kcbtw7H1LQ9cdslD72qNwS?=
 =?iso-8859-1?Q?bmwS5zFlADza9s1ACajbqTLkxq9BMuDI6GczUtbg8rmlE3Vav8LvCtbx9Y?=
 =?iso-8859-1?Q?VJxwEOzSatroMO9Tx/imvgKVKD1M8xuYyx9/fH9g7OFaJlacL7sw7DWZEE?=
 =?iso-8859-1?Q?VaYWm8Y8ylqAdah8bpp9zKUL6T4shcoC1aB4zoF3pyLu3SxpHSwOk7Ov1N?=
 =?iso-8859-1?Q?THtlxAz0/3Q85XKnNhffGBaU0=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a5b034a-849b-4652-4a18-08d9a8dbbf7d
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2021 08:33:21.6337
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v77iE4rkTPvXn2NasPLEKNQSw7xjXXtIEaWmgEh0Ard2JN7XUoBoNaxyFoaVKHIosXnqn9pbBoqSA3AEKVMziuUCECg5AoIGFQgM0RDNFCY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2399
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10169 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 mlxscore=0
 phishscore=0 bulkscore=0 mlxlogscore=385 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111160043
X-Proofpoint-ORIG-GUID: fr4W52j6eLKhOEGKQvD90ww-MwoTt0Iq
X-Proofpoint-GUID: fr4W52j6eLKhOEGKQvD90ww-MwoTt0Iq
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 15, 2021 at 07:35:48PM +0100, Christophe JAILLET wrote:
> Le 15/11/2021 à 13:35, Dan Carpenter a écrit :
> > On Sun, Nov 14, 2021 at 08:02:35PM +0100, Christophe JAILLET wrote:
> > > The 'inuse' bitmap is local to this function. So we can use the
> > > non-atomic '__set_bit()' to save a few cycles.
> > > 
> > > While at it, also remove some useless {}.
> > 
> > I like the {} and tend to add it in new code.  There isn't a rule about
> > this one way or the other.
> > 

[ heavily snipped ]

> 
> - checkpatch prefers the style without {}

Not for these.

> - Usually, greg k-h and Joe Perches give feed-back that extra {} should be
> removed.

I can't find any reference to that.

> - in https://www.kernel.org/doc/html/v5.13/process/coding-style.html, after
> "Rationale: K&R":
>    "Do not unnecessarily use braces where a single statement will do."

There are exceptions for readability.  For example, mutiline indents
get it whether they need or not.  Do while statements get braces.

Quite a lot of people don't use braces for list_for_each() unless it's
required, definitely, but I think it's allowable.

regards,
dan carpenter

