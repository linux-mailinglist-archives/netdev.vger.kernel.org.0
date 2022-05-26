Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F6A0535130
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 17:03:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344733AbiEZPD4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 11:03:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230463AbiEZPDy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 11:03:54 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A63D6A42A;
        Thu, 26 May 2022 08:03:50 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24QEIbqw023102;
        Thu, 26 May 2022 15:03:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=A9gYVVzNysph+up9zBB3jlC53MHMwEss4RNCPYTZk/A=;
 b=tlwaHAtWRPD5G1vTjq/lcbCk/m6n32uiYJUF+MurUHIRneTBYSKdLdjN4SZ33NCvbvkL
 ssPcKDtbwCaUj62jR7N9qsZAPj73QGvsV4jon0cHMzgruNI1/fPG5VUJmYGKYHEY1B4n
 RETQSeFy5GmXe407YZTAsBF7aHUkPW8lekOG7c1ZJHLPMKeEnwhUKGbMlX2Ol0DvT4lG
 /cRrdDolcFeSPkf78um+ugFNqeTpTGslHEclOW3imH8KTgzW3RiidLxHwH79Yaonmhgm
 B4uy1xSnxfdapJy718JT8unGHsD/Yhpu/0bRYqw0ZPIp6RIcCDf+CpCc/cm3Q8WXXEvk 0A== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g93t9w2w1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 May 2022 15:03:24 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24QExMFr012302;
        Thu, 26 May 2022 15:03:23 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2045.outbound.protection.outlook.com [104.47.51.45])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3g93wxe0mc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 May 2022 15:03:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bh6AW3CZ5bFVjgTD0/+NJG+gmsLH8f5bXnpKFKduDc+3O+WHXiuz1lOszsQkejMxnsW8qrbR9GD8Aehxkd+5XW+CCVAdHnwy8lmvmda//2Cg8tFJ02RFypkB4WyOiMsWBsgk4V/UeEUN8r3QPMjgB7ULCHcXH8bq0MIiy68fzHoVBCDSzjCbAE+HsrsZ6BmxzlGi8TGnLbJF4yJvrAA1KInTu1VYXmkS17oIfLamXTKVJAT+8N6EdkfIQVdGbJlCYcDONrslJIRRO+yqy2F/Cgzaj94xhViW0c6u0t3E5lQDdERZSs2pZHV3dqU3DQ88FOAHjVcpbQ6+nfW9dNiKCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A9gYVVzNysph+up9zBB3jlC53MHMwEss4RNCPYTZk/A=;
 b=K+Osf9mLOPZkyngjkYuPAdna3mPifM/kxHWIBsj6s8bShF5IrC36QnT0RWd08J6ZzxRc3UGtwixSMZwpWm/+x9O48qnn6XbnZZBsSkSUnk2QRxNxuce+dPbbtHtYPMkBsysg9fLpYaTg39V0gPG+CuHC266rLx0AOM0I/sPpo9FjDtDpiJcaOuVmzYATJW3FRryqprpgIHLmkTlnKYJYSeCPuyoggdZD6gm3r7cZDRox2BHafeP6CfM58AyJkQrtkZXlhQJmbsR/NcWTLHVQRRRacw+s6hfVX+dO4f7NafBUcOtoiNE7ODL9KYvdUuaAE4d141qoJRCzQKPdUzDr1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A9gYVVzNysph+up9zBB3jlC53MHMwEss4RNCPYTZk/A=;
 b=R1U1gp1GvF1gDYJBl4zBnx/CmNZbv9oRmOVU7WIL5E0Fix87GdHnCeAEnCFUmRuvAHbcwHhK8Gu5Y6hR+/cbOWVaOcZy6fcqdvtJ3RB/PEq+Ix7pSZVU44/N63XGncVxhclYURNWLVJutD/lyFmBKJjTOtM+BObMyIatq8b5VQE=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by DS7PR10MB4864.namprd10.prod.outlook.com
 (2603:10b6:5:3a2::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.13; Thu, 26 May
 2022 15:03:21 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::86f:81ba:9951:5a7e]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::86f:81ba:9951:5a7e%2]) with mapi id 15.20.5293.013; Thu, 26 May 2022
 15:03:20 +0000
Date:   Thu, 26 May 2022 18:03:05 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Jessica Clarke <jrtc27@jrtc27.com>,
        kernel test robot <lkp@intel.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-staging@lists.linux.dev, linux-riscv@lists.infradead.org,
        linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-parport@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-mm@kvack.org, linux-fbdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, bpf@vger.kernel.org,
        amd-gfx@lists.freedesktop.org, alsa-devel@alsa-project.org
Subject: Re: [linux-next:master] BUILD REGRESSION
 8cb8311e95e3bb58bd84d6350365f14a718faa6d
Message-ID: <20220526150305.GH2168@kadam>
References: <628ea118.wJYf60YnZco0hs9o%lkp@intel.com>
 <20220525145056.953631743a4c494aabf000dc@linux-foundation.org>
 <F0E25DFF-8256-48FF-8B88-C0E3730A3E5E@jrtc27.com>
 <20220525152006.e87d3fa50aca58fdc1b43b6a@linux-foundation.org>
 <Yo7U8kglHlcvQ0Ri@casper.infradead.org>
 <20220526084832.GC2146@kadam>
 <Yo+OiR6abzVksVTM@casper.infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yo+OiR6abzVksVTM@casper.infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: MR2P264CA0027.FRAP264.PROD.OUTLOOK.COM (2603:10a6:500::15)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ae00354d-9cee-4d24-b13d-08da3f28df67
X-MS-TrafficTypeDiagnostic: DS7PR10MB4864:EE_
X-Microsoft-Antispam-PRVS: <DS7PR10MB4864C5CC12C33A44ECC1124E8ED99@DS7PR10MB4864.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tnPiCPFlzY6jwItTS5pncvpPP9j2kGbohE1gfbCuVzJLRDhTIYFn7fv+WaVVzEGhXwPjdjmpSd/eEFDwYInnDSWzTGdECtu4V27JJHfgwd+ybhOXLHFp3naKVuL9jCy1g9A9ZvnDBfUmKX94iklJvj2NexaYoKCSeZgn0zXrWS3c8L9bR5Y4bzPYHTSspxneXCxPOxPs9Jct6bmTKYJFfXg5q7/jJXgMFBq93B9nz22i+sxuA5NbChg4IYcb/9TnhPCqPx86jVxZTehk503U3wSi2m/Zk9u8cdkoUExO+AsYnU/D8g7WCZYYqwivg+syFkt6mZubs2UUI3F2T5knPOIFWhFcE+wgX4CxDIzVG3NOZjEHd5pkjbfH6MwI68LOczkkL6g6ePP5at+Yjv7lEOOrfnZs58lYp0WLr9nHBPNWqqVwbTkSvB/23FoHbJ5gr/3d/9/Kei9Dj1QVi5mpJvO2xGU8iHxXOWWMHLmwyvYeezHfeJuHmnDO4VGUZCsQ5ETx75lk7E5ka/JcAf0TmFKhGkUDRK/Ak3EJ7nTdVpcFhaeP1U2i5sczwH6Y3+hPAh59EjX5CCKiYMU11RFnLGHwCJogLdZM+dH0mrmMzU8sBquMpDDPLm1psNm1mVuuqDI1xOEXU9uxvgbJH2w3LfYZ+LCTp8TYoDyft0qGoO/3UQhnNgdzdxnOl8reLNhCBVw1TH6e4HrrWassZg80Jnl7ixcfVi0XNvdX2rws6kq1iXd6MW3CuwgjVyhol3IWKWn6B7lRADKgFzjCPI8662+YVeY5nkqX8t9ThSS1VRk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(38100700002)(316002)(6666004)(38350700002)(8936002)(83380400001)(6486002)(1076003)(2906002)(966005)(186003)(6916009)(54906003)(7416002)(4326008)(66946007)(52116002)(8676002)(44832011)(6506007)(66556008)(9686003)(6512007)(66476007)(26005)(86362001)(33656002)(5660300002)(508600001)(33716001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?raDkuo2GVu/vCS1uFW/R2WZ5j1q+7rFgh3rRfhEpouijlHkoPITumDK9PExl?=
 =?us-ascii?Q?h5rDl/J51xrdlvJ2pb02djgwYXxg9HN+ZRYYzbaEDhbmEPDa65Skt96sduVo?=
 =?us-ascii?Q?bcopJyo6L2akldrQQ4QacN4aZJiVndcWzi/9L2CxamgdGQSIkyB/+dajnX6E?=
 =?us-ascii?Q?bFsGAfl1vTVdVervMjOexFv/lRRRm6btefxO0xUI+mBVxmz8xhIIy18kt14m?=
 =?us-ascii?Q?Eq/ESWG3Nzyb0x6vCmAz8VqUbNYyxVCwheNEWb7Dz7o0nOYYCWjFIzGM/W0I?=
 =?us-ascii?Q?AMTbh9c5/5qz2BY6eNZTg6JlLAgI2q05H6OqEPfcbODUqnKbCRc7w5AujwqS?=
 =?us-ascii?Q?+71xJhyUpfQwN4DYbqa5sbLLUJocjql+wYI88+zkfVP/fTmTjTWAyHipCtTX?=
 =?us-ascii?Q?OTMGW3pTG9GpHLK6T72zfr1xtTkusMYYimQlUt7brFjKzKAX54fT1fd1MrVg?=
 =?us-ascii?Q?B4Kj9shNeN8Y1IUDCkIntK6MUu2oQieON+Tcz17LbtXY9MMJxgjgsS/hXGgs?=
 =?us-ascii?Q?VUnLPzLJv+RAQPAtjXrwQOjR3GJAUrAA3Y0FwiI7bWGOygbZbjefnz0VZZOQ?=
 =?us-ascii?Q?vu+4rnSFNFtYojd/sUUcEpsNowrmsO8Z9IErUWtiKrhhTYe3kE8DeMgdZ99B?=
 =?us-ascii?Q?tj5J1hFpZxIlkl3ttC9FGGsLsko+TaeDKhHArvwWN+vpUdXsKS7vXcAOpO0t?=
 =?us-ascii?Q?4b3mOIF9gS0RZV+6WJJiGQbrXxc+d41cqg9k7TqjJ0CFlFx1rX9bj7aHAEl5?=
 =?us-ascii?Q?9aPRZHJz4vlwlmrT+8TY93GquGGtl4gvk2ZNQAC0SQ+YoXyz+T6CV7v8UWtn?=
 =?us-ascii?Q?LtOGDFStAvLZ1VcbTLnQctZj/RPiesGSNYJ817skT/A1p496LU9dhktOkd6A?=
 =?us-ascii?Q?QOQunxSZzZGuH7xPvvzRM5ht2NOyK1mXZ8Y/QNd51NPpCePhYvfeaL0xBNkQ?=
 =?us-ascii?Q?J4AkBxJ4ulLRGu1Yi7znAiErsuUiWY8fhKySRqzQwWsq4Ns+JAPyjfWW1z+a?=
 =?us-ascii?Q?AbBdKpeYprbor9UMUriDUshW6lKI7hDdh72PciNYtYKAFJkihtJfVoUVKa+f?=
 =?us-ascii?Q?zUe6hSXDXFOTC6VkItxJ0gYH3HJr7iVyo9vd96BRBEX0d30ejWiZ4k0oK/X2?=
 =?us-ascii?Q?Ycnvdn/HJyvlTqrXP054PBevBh0/cmXQ1jvubJBtaXST9pUIJ/yU29zUKXG6?=
 =?us-ascii?Q?j++3GJB3H8Ap+aInIMPC1Drnb6Srm057zjLLFTZuZcF/uo74elHnNaE2O5ht?=
 =?us-ascii?Q?/nKJkJSRic5PBdedrlIX6i+dCE7HPa4i7pGxrdOL+t/4P2+g7aQMYg4RkPjy?=
 =?us-ascii?Q?REi3LcLUX0me2c6JCO+X/WZuLI8E1IseZ/X6LqmdIR4WktLFf4nBEEfLjpDJ?=
 =?us-ascii?Q?f8IOETtntmlBGtfMPxt8zJ45UTXedAvMEDkGJMKrknqvnGURUMhMzhx1OXc2?=
 =?us-ascii?Q?Wfx+gsZDQQhaLk80nUOYF3k4BSx+fgNAC5ECgz0SA7Dq8oyA7w50vTwB6474?=
 =?us-ascii?Q?27LB6OLJ1c/3pLLrVrZVL8GGe9MWW2kI3iX1uyetIq2WvqLrlpFuwSyM3krd?=
 =?us-ascii?Q?+TDT/wEqbB+yJ1l8m0lfFhL/5iQAl6r4YO7klAEFhagXGNV8DILAs7as1I90?=
 =?us-ascii?Q?cyMJ6WqQ/BtfDPDwwxzgVaRLIPyOhOi7xTESelCHfbtMR5eJy/PtFp5qjOc2?=
 =?us-ascii?Q?MrnZkzal/sItYgK4gGFiDuJNs68NK7mFD79lzmZorc00xtLhkmRKdTHRUXU7?=
 =?us-ascii?Q?RYLx7Whnci5bGG0hG0tz2gf2Kt0Z1B4=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae00354d-9cee-4d24-b13d-08da3f28df67
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2022 15:03:20.6952
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vg+ASQsPLS7+2Re+X6SaTzi8KmZj7NDR9lCqb6gz3y2vYDcj76ldNQCmWVtDXAJcXstJCVw0rDAbH/sggJveA9AcutWqbIrl8keD6Okqqts=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4864
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-26_06:2022-05-25,2022-05-26 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 mlxscore=0
 phishscore=0 spamscore=0 mlxlogscore=865 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2205260072
X-Proofpoint-ORIG-GUID: 0oDiZ2vguk5fK6cCtV9ekvcyzyyGmwt5
X-Proofpoint-GUID: 0oDiZ2vguk5fK6cCtV9ekvcyzyyGmwt5
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 26, 2022 at 03:28:25PM +0100, Matthew Wilcox wrote:
> On Thu, May 26, 2022 at 11:48:32AM +0300, Dan Carpenter wrote:
> > On Thu, May 26, 2022 at 02:16:34AM +0100, Matthew Wilcox wrote:
> > > Bizarre this started showing up now.  The recent patch was:
> > > 
> > > -       info->alloced += compound_nr(page);
> > > -       inode->i_blocks += BLOCKS_PER_PAGE << compound_order(page);
> > > +       info->alloced += folio_nr_pages(folio);
> > > +       inode->i_blocks += BLOCKS_PER_PAGE << folio_order(folio);
> > > 
> > > so it could tell that compound_order() was small, but folio_order()
> > > might be large?
> > 
> > The old code also generates a warning on my test system.  Smatch thinks
> > both compound_order() and folio_order() are 0-255.  I guess because of
> > the "unsigned char compound_order;" in the struct page.
> 
> It'd be nice if we could annotate that as "contains a value between
> 1 and BITS_PER_LONG - PAGE_SHIFT".  Then be able to optionally enable
> a checker that ensures that's true on loads/stores.  Maybe we need a
> language that isn't C :-P  Ada can do this ... I don't think Rust can.

Machine Parsable Comments.  It's a matter of figuring out the best
format and writing the code.

In Smatch, I have table of hard coded return values in the format:
<function> <old return> <new hard coded return>
https://github.com/error27/smatch/blob/master/smatch_data/db/kernel.return_fixes
I don't have code to handle something like BITS_PER_LONG or PAGE_SHIFT.
To be honest, Smatch code always assumes that PAGE_SIZE is 4096 but I
should actually look it up...  It's not impossible to do.  The GFP_KERNEL
values changed enough so that I eventually made that look up the actual
defines.

I also have a table in the database where I could edit the values of
(struct page)->compound_order.

regards,
dan carpenter
