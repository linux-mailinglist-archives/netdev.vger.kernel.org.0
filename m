Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C0013FB1FE
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 09:38:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233627AbhH3HjS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 03:39:18 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:10470 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230285AbhH3HjQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 03:39:16 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 17U6wn1S030911;
        Mon, 30 Aug 2021 07:38:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=jiNkQ5cp8r2mSaCKA5VPrQ3PJWAPKWA21lG1b9JiH8o=;
 b=tDPFGKxTSFrprha3MnngAEPo3piEktbsa8btbh2hPLPwM5h4WryiXWFjP3YiWKK+D2zt
 ABrlYaFLrXBRftDQLwleO3+DUwF2Vuph/4tv8swM6nTEcW21NX6qa+OzoIY6cdNLJdHo
 PySRzH+7AtRWEMZ3NkR6+rXJtF5Uhdm50fpNfSWF79fOm4tA+RRDxMvJEt8oGBOrpqxI
 iZDHsSvDiXwwxeudGf9WLzZJRd94X297iOvS55N1XEsUYz2LRjJiFgOolPVuR8aRvBEm
 yYa32ILE1PcyFd9mZ+qtEkXET+s+DZltue0RkcTAQvJ4CdEhNmlAKJq5ZrJ40CGNXlr7 Cg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2020-01-29;
 bh=jiNkQ5cp8r2mSaCKA5VPrQ3PJWAPKWA21lG1b9JiH8o=;
 b=vqdCi6x77L3onmdxW7p3afASSC279QtVnUSIvXGN2SxJIDuPBPfXv092oQCrU5LMDXnb
 OG6QfNdhN2x6W8oNuyK1ww1sa3IwRJ9U/DZic+LRVy9F9KHIYQt5Jr3oDSZSvIOPt4Qn
 6BqFmQag+3pJRjQ7EVUuApICQhrXW5d3tZeAoTHISPQe2vkaj/Dfmq/QJ4LS1znbJV78
 2swCuxooiwjG+lELde5fyRK74gL2RT1X5NdRtcOHCyP7uMonlszvv0bsFw99HrcWPw+b
 AbMDBLkSez1Jg7B9iMt866UgCZqJc0P1LdzmIoAIv16+KfC4l/gdshMU5I0uEPX0oYhb Jw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3arbxxguf7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Aug 2021 07:38:20 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17U7a43X077543;
        Mon, 30 Aug 2021 07:38:19 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
        by userp3030.oracle.com with ESMTP id 3arpf1uxyc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Aug 2021 07:38:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BtXzLe1STVxTzul5ZAvqwqqWBgP37H715cLi7Jj8UyJcCYigpseeUe3+ka3MoK98bLDY7Xje43/9iPXzjbQ+MDJoq0hTonI6szzKd8oyhDN9F3ME2qr1YUoKAAj5Oov3HWmLID9H8Mg0gt3k0nP0/Li/BrLAGNPjXE4rDMl1XP83a+bFnQkBmbo6VNTz1B5PstPoGlDnaqn3QjaIyaB5+Zq/fshoWGwo48XsaQkC0l8+jTr5PIOXDjHhrThFs/id+vBq5ibOWIf5oYoWXc6pKYehZgKIvtvmkmU+OXSLLcfBh0MmOS2WmHk4V1bf2v/kkLSB34DOXszxW2tGP3RAsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jiNkQ5cp8r2mSaCKA5VPrQ3PJWAPKWA21lG1b9JiH8o=;
 b=ZhoIYSNlRRTclCyidG8muosa7RvPztC8Qb+PQzEGQdwB3EqUN/fkKH/04xcRCxfk2g3dYsPPQTPwCnUEYaHNiGg0hlhxlWK2roD7yzcD8nOjPbHbNVyqXu0ZCHLlz7atqrXNgP5JR2/eys0xY0re1xk5y2GHP7phGAFfoBHfmf1CzjYLdjGqB0PCmSnzJmIuXBXyROQm+MmM3CCMVZWOISViBpPHX8as3VZbNdulVxeKz3ZqNIKSVNmEWETUFMUXgag83FK5LSRoicnhv2tN+yKahagV/vr4AE5fnftaW4r982k4XCxOj5O5cOJc6ImII9pikSoia2rHa2Qb/8NZFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jiNkQ5cp8r2mSaCKA5VPrQ3PJWAPKWA21lG1b9JiH8o=;
 b=NfxgOCURxbr3qwXj+ckPPouh8D/j418G4ILmbArSc154aRqX6LzwFR8UjTmclpaNhhngticfp5zEkEMVmWXgmuLPnaVBNvI1OfLxI4gd4LTp12PqYM9b/MH/0oBe3Ak1mSet5s+NBBo26M0ReJqJQBDWZ1DCiGKQC9p4YZnleq4=
Authentication-Results: linux.dev; dkim=none (message not signed)
 header.d=none;linux.dev; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1247.namprd10.prod.outlook.com
 (2603:10b6:301:7::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.20; Mon, 30 Aug
 2021 07:38:17 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268%7]) with mapi id 15.20.4457.024; Mon, 30 Aug 2021
 07:38:17 +0000
Date:   Mon, 30 Aug 2021 10:38:02 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     yajun.deng@linux.dev
Cc:     netdev@vger.kernel.org
Subject: Re: [bug report] net: ipv4: Move ip_options_fragment() out of loop
Message-ID: <20210830073802.GR7722@kadam>
References: <20210827084915.GA8737@kili>
 <31823d969f554ffd04e5f9b3b459ecf4@linux.dev>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <31823d969f554ffd04e5f9b3b459ecf4@linux.dev>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNAP275CA0030.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4d::21)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kadam (62.8.83.99) by JNAP275CA0030.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4d::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.20 via Frontend Transport; Mon, 30 Aug 2021 07:38:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 92a95ebb-9a89-493f-70d4-08d96b89220e
X-MS-TrafficTypeDiagnostic: MWHPR10MB1247:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB1247D90D64CFE1EA3913E4A18ECB9@MWHPR10MB1247.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:935;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zuOXcdbzeQcI+qr9n36M1xqAr9mE4oL7xsRxs871+nS/bgJKXe1YJdlpqoObJMY0CX1vDLg2xvPNCVuT2/YaXda0S9CR+OpKgtK3jWVt2q/Ddsw2MROtzVIlqn/UCTo4Qe9muA4hb6rH3hIhLa318XiEwxQVHmfJni+oZZ7NVx9rqIv7JvAZndp21s3r5+3pIwuklZxj1W5Vo0At6BAGnRcb6so2AHwLojlHdMfjw4TSnvl0pYCpmk+SlKD6Y1rPpr+Tdccs+5gmsCsnYvWXkIW3YLeqbcx0hvOHp56Px1Ox5Im5U8dghgD0fXvawndWFqCTi7vjt4KI992swPwqH0wo4yH2MpEKW19RzhYolQhfp2NNyiWszKYhPJbh8Ej39q1ua+9wjlVEEesQwUZ3qNwzTIqvAkefz4DoplRihzMVawUjvsP4F6rRfp8UXHCmBswazhXyQbtNwvr8E0qn1zvuv7nBqLAM/hhRcUSp3h+sIQ4G4KCpwl4uOs/M0w1vTut/s0YQM6BJxIGQj2ovLsdjarH4jmqlFsG14qct8gQalOtLuy6h8IrAJeDpREr3IUlCM4+5q+6786CDBoqtG4IhqZhTuka4OWckbBSCIXUd2i98rFqi00TyKL9guzAVa/8KZTmsdm5DmgskUMKB/wuARFi58Y6LRslF3H4ghs1ts/KbHIHdhOyAEeUj0sUTYj2ZyqtoBFqCjGNPPqcOqw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(376002)(346002)(136003)(396003)(6496006)(33716001)(1076003)(33656002)(55016002)(8676002)(6916009)(186003)(83380400001)(26005)(38100700002)(9686003)(44832011)(66556008)(66476007)(66946007)(86362001)(52116002)(9576002)(38350700002)(2906002)(956004)(316002)(8936002)(6666004)(4744005)(478600001)(5660300002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VDtUy/Cd1brHDBi6mH80mrTuaiLupunkZmU51cZ9v2/K3ynIcFJIOjdRKOoK?=
 =?us-ascii?Q?FYAZYpYBzrh1PxzRU8ZteUJ2pi3VK0bivjcQ/HF18f20g3eYVrPdnasJ7OMw?=
 =?us-ascii?Q?5uOKjoaIOSKxNJTHNl8Go9E6Z6hA4l6XWCj5ibhXtoI6bRx4DtDdFBncA1FF?=
 =?us-ascii?Q?LcSJ5bGJxAwz6DcPGGcLCn6wcm35zdWfffrutF/4Upf3ysH9Dqi/Df5Rev1K?=
 =?us-ascii?Q?RPOzyf//f7bvZxN6AlFqifRuseJ96mQA2ky+QMISsyQ2Mf9JJN6eNTJv25WP?=
 =?us-ascii?Q?kQ5lGbQm21rmsNViueQKtYEOaXm/oyTZwfHaKvHr9VRT7Fo7YJo41wsJWhEu?=
 =?us-ascii?Q?ByHqy+h41WIHd8if+1XQMgKLhmtfF8EJ13RkgU1kybxttBbW6HXUjPPb3L+4?=
 =?us-ascii?Q?5TlzkegbRutuHeFVUsGYdodYJSlRxXAE5nPuve0U56lehHey+byaxS4u6cYl?=
 =?us-ascii?Q?vJC3ZoN/9HM2oPIo7Xd2eoQ1qjP9qj5R91VeMME6dsJ59NeChLsqwN1EQwHi?=
 =?us-ascii?Q?yzL0SlmGN1PLmcM0tMoOX/ATh1qjgJhp1uhLAj38dMZw2NXzklrJJ2dx0sfq?=
 =?us-ascii?Q?njgFnSAiCwkgCBNF16hGx15slneazLyd8f/FJJywcskbB0969+10s1fi0MwI?=
 =?us-ascii?Q?4SGEqAuHIAjC6BBBkoQMoEWUhmrOrwthNBAIquIvJFXzBwiR1ajsMJxChze9?=
 =?us-ascii?Q?1Sb/gn99DwCRNYaOCvtM+sF2H100dPt8v41JTjYHI0NazICac6wl0NvqWsEQ?=
 =?us-ascii?Q?NTRJCtUv2fnhpmApiWZkw5uISGM83nuwvcMp6G8QO7QZokqxkGQaxQ/vuN2b?=
 =?us-ascii?Q?xmXnvTp3cEmZvygTOlj2uyhw5XliWyK1u2Smy8eRDqcQMzGur9w6oqbJ4SPe?=
 =?us-ascii?Q?ArEBTCit1gLPC+ttdBjJQUxegNU2vWQlu4SrrIAG7o5V4DVBD2efOtXV7vDr?=
 =?us-ascii?Q?6cZpVbhk49yBZefLlgfdCG5I4HFAC5Kovbn65xQr8q0QStvUftjp0B/sqYlo?=
 =?us-ascii?Q?ZObXBel4hi27Llfufwe6HjUbOI/i9vYXDderd+U5TcoXDYMq+zU76xVmOc8w?=
 =?us-ascii?Q?Ihqra35XzZcH0hZOO745GLW+pulQ/K09w/sP7tGuz1M0ZL3Quvt4PaiTa6HB?=
 =?us-ascii?Q?nW/Knq8WQ21CIVRoXHixFimeIqxA7junjIE+d2/aXwbW0n9hnXbJoi7BLjP2?=
 =?us-ascii?Q?xkBLuBSuymv/5h6+welRh/YobRFYo4E2W4FjI9gxdX2xeSFM7jUKJ9KCNxft?=
 =?us-ascii?Q?mLN1o9AjoZdCxzaZZl+ShSNEKhuZw7y3SZQiscu99qjadovQ8jKpQ3BKqmVO?=
 =?us-ascii?Q?qC6mPdKBigJG1YhwPSTjt+8Y?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92a95ebb-9a89-493f-70d4-08d96b89220e
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2021 07:38:17.7231
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZMQb184n2LXYDCIoGB3/RX5k5gKdYh3QKLUAFaXnMoLcok1Pnn2KXGs8A1PCmy/tAvpwv0746nwpCovoGZsN7BI+5pbwElDm/8W3/JHTOTU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1247
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10091 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 phishscore=0
 spamscore=0 mlxlogscore=999 adultscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108300055
X-Proofpoint-ORIG-GUID: 2r6lpE9I8kLTBGN4JSx2Gce10KbeowC1
X-Proofpoint-GUID: 2r6lpE9I8kLTBGN4JSx2Gce10KbeowC1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 27, 2021 at 09:23:22AM +0000, yajun.deng@linux.dev wrote:
> August 27, 2021 4:49 PM, "Dan Carpenter" <dan.carpenter@oracle.com> wrote:
> 
> > Hello Yajun Deng,
> > 
> > This is a semi-automatic email about new static checker warnings.
> 
> Can you test the attached?
> 

Looks good.  Thanks!

regards,
dan carpenter

