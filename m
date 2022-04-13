Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30EDE4FFA51
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 17:33:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236566AbiDMPfl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 11:35:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbiDMPfk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 11:35:40 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCEB638BD4;
        Wed, 13 Apr 2022 08:33:18 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23DFNb43003034;
        Wed, 13 Apr 2022 15:33:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=xsCPrRu8eCxPxpMiMB4WZe9ljm5FA9oNfN+KZ3E9hZI=;
 b=Ay7GuMRrdr9vysZ+OQ3fFzjn5On7M/Kdk/SO+OZ55x8ScoxR+R57Z7zNt+v+RQR+PbQ+
 Uu/nxtJj4uDPcrvE5cbCVR2qayN4aAGvLOEuSOfmxppraCOT8TMrW4Ct9Jsdf1fJ8JOZ
 hgNYiq13gOs+oVsJ63jYto9EvvPtkEPuK+C/sFh2ioiTA1gz9Za1timKcOQ2e+g1uu5Y
 Ib85pWUJ+OD75a7v9lZcy8FNp95cVSmFoOjo/001OuVw+ihYSpWWWcc87SOlGzawqs/c
 /E+XQ0SBJQEA4F/a9i9tVcgHyGIhPM4PvY33bf9WLDKoWI9f+BPp2KL4t6e/+mLLA4wq Xw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com with ESMTP id 3fb0x2jaue-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Apr 2022 15:33:05 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23DFFnmO006520;
        Wed, 13 Apr 2022 15:33:05 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fb0k49rjv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Apr 2022 15:33:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kjhlIh6bnN9s34Lxk71HbGR2odY7ZUZWyNOG8adsbFt/Kegy/b3zgDBq+waLdRbdr3BfsGsJfUSnsvzy14Gx7VMfi65TROFdzPtlDkq8qyx7WERqpIZeK1Ddn59w/ipA+T42vK6+HhHpo5SDJcgagiDXIdXIMzsXLhOHHn14Qm4nyoDH7NExzcs7pXs9XsJJr5k0RO08LAOc5J59PNfNZ6dsfTebG4sFtcSOutEDjnkmoVdVys24hpK9MpYzCWlSeEur/wltBuV9fnm15TrihuNJrPEDmEjY3CbNhV9Zx6wmU4eMY+PQsX02lCBmFPar9XzkwP9SMH4M1MhO5xrUow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xsCPrRu8eCxPxpMiMB4WZe9ljm5FA9oNfN+KZ3E9hZI=;
 b=ZqegNSMKPSI8W0XM4qVYADsjzYkgDPJdLj1dfBZ08QDZgmCByET9Ycj3GnYqLU0vkLSKiOSww23CFynAdXVclIIL+zaAeBXeoSjCHZAxU6VVfSddVFQSud5J4+24M/2YfbXYxUcmNPgsNntLTq8gtswPWa48Zg7Z05k7Wvmkfl8ruxLXdTFPcwYQNYSCwvmhgH3SengiPSeiEwwX/zKDhcgfaQ9QnYMknl9a59iUHisv93bSr3x7JstGag+zePPWVhFfKO5zNud/XoqD7U50r91N1ddI/W7zBan83TgFYaAEiATpZl6/cbbtRzYz/yZZqfTMjfz7+QYxX1JJ5XWg5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xsCPrRu8eCxPxpMiMB4WZe9ljm5FA9oNfN+KZ3E9hZI=;
 b=An/2h1VseMJ2sSnzKP94XkuQS/au5cqg1L54fRYE4c0t5Rj4WGzEBFA/36mXRPoXhx5WOLPYQ8DiFC04nOiVTuNV9qgbHEw37TMiyiCwYvkRypnShreAJdlilViwKE5wCs3GRKSxqUlLITsyw6/iqgmB2EkRJ4SIJAU59d3n6IM=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CO1PR10MB5507.namprd10.prod.outlook.com
 (2603:10b6:303:162::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.18; Wed, 13 Apr
 2022 15:33:03 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::b5d5:7b39:ca2d:1b87]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::b5d5:7b39:ca2d:1b87%5]) with mapi id 15.20.5144.022; Wed, 13 Apr 2022
 15:33:02 +0000
Date:   Wed, 13 Apr 2022 18:32:49 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     David Kahurani <k.kahurani@gmail.com>
Cc:     netdev@vger.kernel.org,
        syzbot <syzbot+d3dbdf31fbe9d8f5f311@syzkaller.appspotmail.com>,
        davem@davemloft.net, jgg@ziepe.ca, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Phillip Potter <phil@philpotter.co.uk>,
        syzkaller-bugs@googlegroups.com, arnd@arndb.de,
        Pavel Skripkin <paskripkin@gmail.com>
Subject: Re: [PATCH] net: ax88179: add proper error handling of usb read
 errors
Message-ID: <20220413153249.GZ12805@kadam>
References: <20220404151036.265901-1-k.kahurani@gmail.com>
 <20220404153151.GF3293@kadam>
 <CAAZOf25i_mLO9igOY5wiUaxLOsxMt3jrvytSm1wm95R-bdKysA@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAZOf25i_mLO9igOY5wiUaxLOsxMt3jrvytSm1wm95R-bdKysA@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: MR2P264CA0136.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:500:30::28) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0d8fb6e5-bf60-445c-6a8b-08da1d62e5d7
X-MS-TrafficTypeDiagnostic: CO1PR10MB5507:EE_
X-Microsoft-Antispam-PRVS: <CO1PR10MB5507C88CCCF21FFCAE99E8948EEC9@CO1PR10MB5507.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ShitkBKOAwmKMqSgjZkTYIk2BmheBu2CyTxJHcpbF23ed7YnWMSXroCrHqy/TIUKYfw+m3jgxZn2IXfeXrN2+l8I8V3+kR3GBBMN4R1T6j5iHEJtIhsj0wfufNQeLCSAwWL1HsH+SJ3SIodSOatZJvfsTDofP+UnwhFz/jKXKiVeiQw0/imyV/sKRSZurdLdHnH0TXmlXllpvFnoDsPvMa2tP1XdUIApNmh6n2WROkjw5nMo1nHE1hCn2jEJpImT68INi3lWB312/dIDTDC9kID3O1fOs2bzVF5hNPfdSzfS+BZ3HMXq4vvspjxGohKNsvEcrnNjfhA9E85E4++RlSlpCW5szY6efMXl582rrmaaEgOvOY+iH4/bdtbvRxmhLaldbCf4tlI+CEtRwerl4w6KiymaxZ8GJiHP6j0Ba65s8veWYyDTbkBdohft5mAeln52n8XhKnUT7fkCu4tO186+HUpxLXx3WstywZw20B6uohL13mgoq7kgZiVQGM8cYaRvBdsm8gt1gOjIjValy0zqtdn3myWbvJwN9Xa+CkOAUrAFYkIaMXOW/zBCyJj69I7YxKeDTti9rqpzwylOrr9mWvJUtl5KWM/Bo99IeIL36LjQjQd2VzZ40QVfwHRQPwuelzj6iAgtD1qHU3TUeIEZOLOEufd/q4nHSjz7/ai5F3SPmNHauxomp4O56xnF2JoLczHRZwPEXUGye2UAjA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(66946007)(186003)(8676002)(4326008)(33716001)(2906002)(5660300002)(7416002)(38100700002)(44832011)(38350700002)(316002)(33656002)(508600001)(1076003)(8936002)(26005)(6512007)(86362001)(6506007)(6666004)(52116002)(53546011)(6486002)(54906003)(6916009)(66476007)(9686003)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6hbg0AMMfcfbGrIzPGU3CYjKg5K9RD9FT1VZkcOgNG+7QLWedt4jERXEhSpz?=
 =?us-ascii?Q?9hpqxYL0QgXU16bw9vsZiDqjH7TA8WU0pB9F/Ib0prLFFpjcv+uahRE5qdas?=
 =?us-ascii?Q?/XTF2GA1Fm5VeoyxP0o19v3BRgofA0WvZSVSUVWqtkmx362A0SwZSPwY3s7I?=
 =?us-ascii?Q?yEq4tuHntdOH10mSq0/rvFhNpAreUqRoYaHx1VwReB5ndqA0I/Coidi2KjdR?=
 =?us-ascii?Q?Mg5NjfPR+eDx3oEgNzJzG/e/e7lZY6uRetYOdMI1z28d9y0/Rx4ThqTm82ow?=
 =?us-ascii?Q?uFisaLhCFYeAfAxqFXtqHVyAice+RhSJpx57sPtpCRFRf2s9NZdc8o6wfLnQ?=
 =?us-ascii?Q?GEI8j5RzwfWQo4WHqRwBLG0dZqTjvNpD98HxXKN3hUPT76rrtRfOT/N0FqGV?=
 =?us-ascii?Q?BlV3FfoD+jPH5QB3OSaidycHdLA0+0WQli/+XPmYq6Fw+0FMm+cEL7UUybRT?=
 =?us-ascii?Q?SQ5yJfyFfq5QJrfh0CXLxfcSAe0KPVRL6x3KIDnun3qG++DmqER6Q8PQ2K2p?=
 =?us-ascii?Q?pzpPnCHXDGgAweNprep3PIN4WZDeAOZcobamUzOaKSqnHy5RHLWqxRhi415G?=
 =?us-ascii?Q?BTzgl+s7z8jAbvLtwjpR8Bf6Yk8uFVccOKhwlBuV+oNmFcxe1hDGY29WF4WE?=
 =?us-ascii?Q?6wTZBP5iwK+7Ffcgy6b2ITIRhtzoe59dNTDocmKq6IE3T/FR2paiT5qkffoK?=
 =?us-ascii?Q?wnb9fbpkDI6Gw0HP/EpxhVGsTQZImxg0/zYPanjc2H4DMnQqGd6sIcmg97eP?=
 =?us-ascii?Q?evEfSWqtIoKALARuwMfvSiuxJphr7zF+ymVKmafSIvybG3e0XnkgPK7CVclg?=
 =?us-ascii?Q?YzccXO6KYd6KzDm/N5wf62CTpIlFpplGWVYyc5DUQUOEcuzQXRLMjrOCEpm5?=
 =?us-ascii?Q?IoM+WfjbX5Cd2T2ga3tNr5a5xYJx1D+2qY92gYkUOVJd+k3CU+CIJHSw0deS?=
 =?us-ascii?Q?a68Y3ABzCrX2RcUdzYP4B7wbpPHuYV8bu9SVSj4ZqJea3MEqV22xx+z2OgPn?=
 =?us-ascii?Q?XXvNuUZ0dcPEYWcs2G68Ss8Z0k9pwu3xNoyRlUvFIXY8lMW2PO1c0jL0TPom?=
 =?us-ascii?Q?4r0Sb4U8ZT70TBq6dxUxBRJrZ9UyhDghmy4K2YPZmB6fGqMVylLg3eju90OB?=
 =?us-ascii?Q?IfmYab3/6YggH+56EzrFUb0WxUvKLYFPG82oVCAXEjjHx+c/8uK+Yt0vPcSL?=
 =?us-ascii?Q?R2LQuRLAta+W576GlRO9ep9Ugl6+sO2yxfGYw4bOThyB7oSwlL/wnDNEo38s?=
 =?us-ascii?Q?+vRmRh/E0/MhYcB1w/zTBMqFkQye4ww3EKYslXaGh8NDojPygKPqrhvlurdN?=
 =?us-ascii?Q?zejh5tM13u5C43pMxWAHqhlYN2DF35ONgXSJDvM+WlRlmRnxvsItBcI2q0Jx?=
 =?us-ascii?Q?bBVcXmWjs8NUFDj3QOgBmZGoBkbLhGo50NXyGKahtFwpp96LweY3xoVwrSgq?=
 =?us-ascii?Q?ff3minDc43MuFc5jShUDDrRuunM9MfCchN/ZWALH4/vFOszAkLI8GmcEuYyH?=
 =?us-ascii?Q?zr6CtTYyspEQl0CHDlAgXK02NgXRPygcbFkE0RkrcHOpnLX6N4SC1wlz8GFZ?=
 =?us-ascii?Q?d8hlebSzeSp+fSvZzA7gqXNkwjkm4s/36Uqz/+XtXnSlYOzfz/W1zOlb5VAM?=
 =?us-ascii?Q?6jXxo6cmF8jxqenLlKxkK1NW4NbAxb09W6KnAySwM/8VgvWfOjxhV+EfW4Ha?=
 =?us-ascii?Q?ZqmEcx6TlBWL1ZTLhIRM2DoK/A7ERJrva2HvMfZ1VooBsQ/++Q5ZbzOc+qxg?=
 =?us-ascii?Q?WamB32K2Yq0qJ//zxQa6HxetqPqzh3c=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d8fb6e5-bf60-445c-6a8b-08da1d62e5d7
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2022 15:33:02.9103
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ymlfWWOHnqyJf973DGkg+3X9TpOxkO2eabSXrGATOOps+o1oO6gSaJ2RXRfqwniJws3mK022DK89H5X1X7w5GNfZcRs+risGBoJiUWaU2dQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB5507
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-13_02:2022-04-13,2022-04-13 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=967 malwarescore=0
 mlxscore=0 phishscore=0 suspectscore=0 spamscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204130082
X-Proofpoint-ORIG-GUID: 7wW3BczcsnMJG3xBxHT5caX1egkUtKIn
X-Proofpoint-GUID: 7wW3BczcsnMJG3xBxHT5caX1egkUtKIn
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 13, 2022 at 03:36:57PM +0300, David Kahurani wrote:
> On Mon, Apr 4, 2022 at 6:32 PM Dan Carpenter <dan.carpenter@oracle.com> wrote:
> 
> Hi Dan
> 
> > >       int ret;
> > >       int (*fn)(struct usbnet *, u8, u8, u16, u16, void *, u16);
> > > @@ -201,9 +202,12 @@ static int __ax88179_read_cmd(struct usbnet *dev, u8 cmd, u16 value, u16 index,
> > >       ret = fn(dev, cmd, USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
> > >                value, index, data, size);
> > >
> > > -     if (unlikely(ret < 0))
> > > +     if (unlikely(ret < size)) {
> > > +             ret = ret < 0 ? ret : -ENODATA;
> > > +
> > >               netdev_warn(dev->net, "Failed to read reg index 0x%04x: %d\n",
> > >                           index, ret);
> > > +     }
> > >
> > >       return ret;
> >
> > It would be better to make __ax88179_read_cmd() return 0 on success
> > instead of returning size on success.  Non-standard returns lead to bugs.
> >
> 
> I don't suppose this would have much effect on the structure of the
> code and indeed plan to do this but just some minor clarification.
> 
> Isn't it standard for reader functions to return the number of bytes read?
> 

Not really.

There are some functions that do it, but it has historically lead to bug
after bug.  For example, see commit 719b8f2850d3 ("USB: add
usb_control_msg_send() and usb_control_msg_recv()") where USB is moving
away from that to avoid bugs.

If you return zero on success then it's simple:

	if (ret)
		return ret;

If you return the bytes people will try call kinds of things:

	if (ret)
		return ret;

Bug: Now the driver is broken.  (Not everyone can test the hardware).

	if (ret != size)
		return ret;

Bug: returns a positive.

	if (ret != size)
		return -EIO;

Bug: forgot to propagate the error code.

	if (ret < sizeof(foo))
		return -EIO;

Bug: because of type promotion negative error codes are treated as
     success.

	if (ret < 0)
		return ret;

Bug: buffer partially filled.  Information leak.

If you return the bytes then the only correct way to write error
handling is:

	if (ret < 0)
		return ret;
	if (ret != size)
		return -EIO;

regards,
dan carpenter


