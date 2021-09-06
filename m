Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DB364016A5
	for <lists+netdev@lfdr.de>; Mon,  6 Sep 2021 08:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239398AbhIFGyz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Sep 2021 02:54:55 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:53434 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229792AbhIFGyy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Sep 2021 02:54:54 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1864BaZg032734;
        Mon, 6 Sep 2021 06:53:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=OwHHeBF47yLDv6dfRZzfb2pvALzq02JqDGglLHuaudo=;
 b=NV5rwneHn1qAL/VpVIYqYorDIDd8zcPTRC3x14K7N6VfdkURbDr9DuP6bbVva0TUW6V/
 oa7S/TOsPnOumcTAL7gj7ODQAhVCo89udY9TWar+q4+MRt+SP+fiYgWFpqkNDuXLhq6O
 dgI22pI3DEtjAJkaCx4c9ounRMtKKJGwP5Uz+lA++EPVv62ssEVya4+giSklW/DOQ/Dd
 JSKSvpLYELUizRkuGx0Cti8qHwzrmgqL5AuUFPmrIEHf9wiGWGFBR371N5InrAKmT2B/
 WM42vwU+7YA1WCo9TuGHG275UV+PHmf1ELIyO4a8BBPzDS2gjWkq73aqRL9JbEz2BftU lA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2020-01-29;
 bh=OwHHeBF47yLDv6dfRZzfb2pvALzq02JqDGglLHuaudo=;
 b=FSQw+oWeuAeC2Q7Xr1J3egmh0Mw1dDBJll5wWh0HyEZcXujqvFZRfRsE5eEEgv1aMhFi
 LmNA6jRtQGt1gMJfrWUf8PBZn2HfqTOw4O8ATIhEjhtk1U5kJQlRj5DaTU5n0/HH7AHJ
 /rCJbaICVVAF3rkUlBpG6i0Y/rLhMqDJnSxsAOHRdOX6AeLxtifljihZYgaNV6zDoIvF
 DLRRYuwAez7P7c+ZzHjlwErtDSvYdbzWmm00snrVNU5Rqsb+BCRsDj3UXIdp8BaWeaub
 BWh/zxWQTq7ScUFePYdj8a30P7Uucev149qO4G3n+qWTt682iFIHLqgbZ4OC7j8wgdwA qA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3avxtq9dch-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Sep 2021 06:53:38 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1866nuEX174432;
        Mon, 6 Sep 2021 06:53:37 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2172.outbound.protection.outlook.com [104.47.55.172])
        by aserp3020.oracle.com with ESMTP id 3av0m2sk80-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Sep 2021 06:53:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f0BNE7HChnESqLy+/Za1kbdHi/LSSrf7ZwNDFBogcJkiBeWh7Uz63f7KtOalfUcBXdzlY5fA7if0RUxArorXci8AmoWJhersIMFj8Eb0nKDoNeMtKM18yAI0K7shGwc7RQlDuW7Vz535j9u6eB42TQBfjwIDZulr4Kxke6KXkq+KfIqvlubB/stKyepnfbwxkp2laWphhtVS+ZZPdSVV5WUBUeJ0HQLxwPyRIvBMR0dPZSQJoEt/TLwnD+t5O9JXfNxyT1vZ4yo0Dd5GMtaSUH+rkyHEPgKWFNEdytkHod73lfbd0n0xFrtoc8SqGDm/j6Jj2+IksCqj4e3JQp1x7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=OwHHeBF47yLDv6dfRZzfb2pvALzq02JqDGglLHuaudo=;
 b=DBpzy6KV9wiv+L1sA43HahlMskqVVwL4gYBmL8LRhLbJ/Xi+osr+3HvGO2raUEQgM9HMKCMHUdtxMle6reylbI+S7KZfN6JgXG2uh8KYqirT9+zc5EBbWyHpKIQWkPlM6ILOq4NIuFa4sLXAtznOwI6XM5t5+yMQny5P/+UU6FGm7RpR2KUEOS+QNZcpJ7Go9x8CVUI3exAj7SMuqdrP/NPAT0BHCB5WDQ8Z4J2IKY/DrkjgUPwwnoPZ/glgUtbb615TY73fHbDnm/VLOWGsSBWF+M5ifrqlUSymufC8tO512OLEdgJDsRyoib7lhQq7oQ+nRwgIPAqhom9+V2W7kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OwHHeBF47yLDv6dfRZzfb2pvALzq02JqDGglLHuaudo=;
 b=mzrWGLWUsuhKduwYw7ZzhgxdlSEJilgQw1U8G2ALW7foKsux/s1535MimFmZL9RNmvchFkCZJzcQsHwCm7ZPFnDcX4mvWYSqzk2/99xxRflwzOxSpgQlI5cTVtiuy+QCHHtCmGQzg3lKEXDfCLDGHbMUR4cSQVNCrObEV1qcaxI=
Authentication-Results: protonmail.com; dkim=none (message not signed)
 header.d=none;protonmail.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CO1PR10MB4658.namprd10.prod.outlook.com
 (2603:10b6:303:91::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.21; Mon, 6 Sep
 2021 06:53:35 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268%7]) with mapi id 15.20.4478.025; Mon, 6 Sep 2021
 06:53:35 +0000
Date:   Mon, 6 Sep 2021 09:53:20 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Yassine Oudjana <y.oudjana@protonmail.com>
Cc:     bjorn.andersson@linaro.org, butterflyhuangxx@gmail.com,
        davem@davemloft.net, kuba@kernel.org,
        linux-arm-msm@vger.kernel.org, loic.poulain@linaro.org,
        mani@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 net] net: qrtr: make checks in qrtr_endpoint_post()
 stricter
Message-ID: <20210906065320.GC1935@kadam>
References: <S4IVYQ.R543O8OZ1IFR3@protonmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <S4IVYQ.R543O8OZ1IFR3@protonmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JN2P275CA0028.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:2::16)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kadam (41.210.143.41) by JN2P275CA0028.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:2::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19 via Frontend Transport; Mon, 6 Sep 2021 06:53:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 60bd4607-8eb3-469b-6feb-08d971030c38
X-MS-TrafficTypeDiagnostic: CO1PR10MB4658:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO1PR10MB465867E56619E92AABC660788ED29@CO1PR10MB4658.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rRGrtJAxx+p6yWp+wWefQWfMhvETPX+wBFXZT1mtgG1JrEwma2mn0BQU8C58RDiOZzZcgyaRJ+0dJoOPL3wOs5q/uyWN2Hp3I2WJxhl9Mg24kTCT5pUHe/ianWfhYH7evHvRO7AQQXfv+DL3dPRnq92aAhMz8T6j31L1oKOqJJLtDPMzqBxnxEDhMsavbBMX6vn5YOOym7Z/dfUZcqMbhn9nKAYL19Y13rDbGb8o5aHon7Gow4rbH1SwaXmiNcdQJ+nek4AgltfyrgkeimcTH8AwJSgFoN83D1Vs9ySEsr87qszUrQMigXVAfhbctBPOVhLwBrbUEeC0HihPQaB4TwSAJTcH43Jx+zhn/y9ArkoD46IPlcL7weQkpBkPcbrOv3ElvE5slpzcKAMzTqI4FLzbThgldxaJewu+1jHnGtMEYE+aTRokVkIAuxUViTXc3H+EjpHGWCc65ZLqdZpoH2WpaTQDBY5GrvvmlpMNbvvwlTmvRfmBI4q73k6a2CCO6pGt4jkRy+vyQ4utf/shRrL5qljoHM+iK8v/iuzjmZ+giFinzFCMj+ZqnhQxqM22lxLHmdZJYv25bBul7kgM289XSe4kDGYAOPE8MdHT6ohobia0OSYHUasdVGSz6jrNeAKbHxYE+oD6hqg+8acVecLTx/Uxl7baaC0dSfCtuY85tnUZiwQTOQCs5scVLW//FszB3ixIkTDowFfzhXH6uvcXQ3rQh5Ighpxb5ll1xs0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(39860400002)(376002)(366004)(396003)(66476007)(66556008)(956004)(33716001)(9686003)(5001810100001)(6496006)(316002)(6916009)(52116002)(4744005)(478600001)(4326008)(38100700002)(55016002)(86362001)(26005)(5660300002)(8676002)(44832011)(8936002)(1076003)(6666004)(83380400001)(2906002)(66946007)(186003)(9576002)(33656002)(38350700002)(5716013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+rKYRW3f26YcwylVTQheKlbsi7UbZpETn8VuNWL3tv7lU5emAF3DlVfsJoTK?=
 =?us-ascii?Q?b6YThNDhx/cRlCP/HxGdej/YlGiJEJa9INnZF2B68eVChUrgoHR5K/vKKSvR?=
 =?us-ascii?Q?Pdh0Oq47WQhtWnXkk2Ac2/ouZz+sNep196Zv4k0cNqP5cR/doIukgUfJzuQu?=
 =?us-ascii?Q?Y5PiebFz6YWV2axV8rw55Bs4e5Rj8DRvs9AxUPR1VGijEUp5IeKv2gMrRYhr?=
 =?us-ascii?Q?K/ErKjY7xZeD/FPYSHpkRNvaJOO/JHpNpHDHLLfCL4mMHnWNoyPMJoPT1kDO?=
 =?us-ascii?Q?z/P0Xn4DVFMNOuCXyoqw087Q/QOOE+co4aF8ON4mcxVQOVHHBRlrLgu33Gsl?=
 =?us-ascii?Q?KQ+6BQHStjHBLq5uk5UpJGkPROomjBWvr02oSElm4vGdaBUM349XeWyx926Q?=
 =?us-ascii?Q?3BEGIf41ZTACqbfgumfKSBpF18TJXDXRy6CYXp0iQxHoin8Z+P/prm8dyMKF?=
 =?us-ascii?Q?8flGfQPyK+yHQJC+j0rSEP9+YjOnDhhSZemLBOdi7yPclDVfx/qLPjBX4mtF?=
 =?us-ascii?Q?tE+SdXUZGhfc0W+qa2BhjyhKbXhwr0vXRSh4+dsYn+adgyMZ9zdUimoWHxz6?=
 =?us-ascii?Q?DekZB5M0pnJ0F0avmqQxjqa+AFrgSr2mpFndWJSLMn75yavUGhewHTXpq3BM?=
 =?us-ascii?Q?xlfZLfsPfrWoxi6iCJqJ99fO9q3aT7NyVpTWGgQEsrtCUE73h4D8qUVNPt3e?=
 =?us-ascii?Q?LciMW+UsvTzpGf38xIWO9VWbJ3nKlvMPxllr1F63Q/fDkrhSK4F04aLgG+a/?=
 =?us-ascii?Q?+D+Ty1egusJ2S+zR0ppGL8QJ8cONmbsxHnMD8iofZSlX9DBQfeaFDSPUqUzL?=
 =?us-ascii?Q?+sGGkXNqGss5cWpa4V1cRquxSRr5jh6mRKVLcNuUVe3nyal3jtCU/ujoJWCX?=
 =?us-ascii?Q?vfNBHf2eVGqqJgjExihI3YukVi2nuLEBlu2oiGLi0JC+Yxt2cDizcNr0BLP6?=
 =?us-ascii?Q?cYR4ksaUAUQwVGMzYSN2LJwmuxxvvlL6jO+W+mfOVmiyOJe2y8GkyRzO/IhT?=
 =?us-ascii?Q?TIdJ164g67E0E4R8mrRyjkFNuI1/vwjQBhaGWTImrElQ7arBNlgFIyM9Orrf?=
 =?us-ascii?Q?m/PsNsJ4Ld3kDGq6GVJmGAOuC3wcZ1wmSakQX0ZELBYCxT74ki5l/SmgE/3o?=
 =?us-ascii?Q?a/lD56TvDfeEVaCvR/W9b3unOYLSV/FVa2UjCTuueN1q0c1zoEVJM/YIrR8Q?=
 =?us-ascii?Q?SgN4kz3JXo49+ZQwulL/gAJbM+TlUzmutQMk/SZY8MFftXATOYyKhynHeMFE?=
 =?us-ascii?Q?B38qz/ktOszzC4FmhrEOr1ZhrB1cIkkbm3kb+BeqGnh2SXU/ZYlfCLqqbJFF?=
 =?us-ascii?Q?yk0PU6O5zeGhYbLY9XTt5r9G?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60bd4607-8eb3-469b-6feb-08d971030c38
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2021 06:53:35.5350
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hoRHZaVI6O0hQixhdBwhWqUB4eXnv9fdfJsovitKpxmKsalMlQa9jukn7VLlMQc5LKYPZupWRErsEFO34DCWHU7Cb6AYiZp0IaNtumHu4Gs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4658
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10098 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 bulkscore=0 suspectscore=0 spamscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2108310000 definitions=main-2109060043
X-Proofpoint-GUID: fG7m5HulYPuCMftGh8hcG1Wc51ntZXtc
X-Proofpoint-ORIG-GUID: fG7m5HulYPuCMftGh8hcG1Wc51ntZXtc
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 03, 2021 at 07:29:28PM +0000, Yassine Oudjana wrote:
>  > if (cb->dst_port != QRTR_PORT_CTRL && cb->type != QRTR_TYPE_DATA &&
>  > @@ -506,8 +506,12 @@ int qrtr_endpoint_post(struct qrtr_endpoint 
> *ep, const void *data, size_t len)
>  >
>  > if (cb->type == QRTR_TYPE_NEW_SERVER) {
>  > /* Remote node endpoint can bridge other distant nodes */
>  > - const struct qrtr_ctrl_pkt *pkt = data + hdrlen;
>  > + const struct qrtr_ctrl_pkt *pkt;
>  >
>  > + if (size < sizeof(*pkt))
>  > + goto err;
>  > +
>  > + pkt = data + hdrlen;
>  > qrtr_node_assign(node, le32_to_cpu(pkt->server.node));
>  > }
>  >
>  > --
>  > 2.20.1
>  >
> 
> This is crashing MSM8996. I get these messages (dmesg | grep 
> remoteproc):

Yes.  I apologize for that.  The fix has been merged already.

regards,
dan carpenter


