Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A23354DF3A
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 12:37:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359605AbiFPKhy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 06:37:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359447AbiFPKhw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 06:37:52 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3B8F1FB;
        Thu, 16 Jun 2022 03:37:50 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25G8l7In022329;
        Thu, 16 Jun 2022 10:37:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=corp-2021-07-09;
 bh=D/PfaelS2zt7s1/gawW7FKdmRTBXq/CWEVvNCFEpBMw=;
 b=hzcL+lpPrQEsxRDE2O3EpVjUJUjLyULy4ERa56f3p1eVGctsUhSQEWg4V14ydaHdkpLD
 EhAiufeV6EsL86PEK0S7t6fc55fk/TJiV1ZIyjWyEaUMywv3nXDZL+NOV1JTOZJllonA
 fc1lHUIwOsD1usHCcsBlpRFkveSLJfLYSzAeBavucrZbGqIgTCIn3Ad8trJ4E3ERRJjN
 lut2a3/V0cS+PJovE7/bstcNi3jSImbcfbrlIRSmhybO2rmeFfD2igmv04sRY09dvgl7
 LgoyC0MQr5CHZiP+Emzc+XwCFBi/E231ZXKie/IUhFMXpYeVQ9ugdKBiB17P919oK0jy kA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gmhfctub9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jun 2022 10:37:09 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25GAaSto033490;
        Thu, 16 Jun 2022 10:37:06 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gpqq28b0t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jun 2022 10:37:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ghKzgLqHrqIgv8BBINyH+WCvIu2ldBPbTPf89o4CR7Wl5ESXlUip6dAK+rea41JRf5Xz7zWBtHVKIlbmXqp0lgnNqQrBR2s6aGUXzUOSgyw5UG2ydgxGL+IOp1OtoZ9hv/4xOBgNu8g7RvKO1phAf4EH0UymhnsmfgScWIWpiFzWkcQ2rKhlhv/biqmvcO8AV00Co1W8weaJaALSkUfRQUHaY2e0lFzgmYP2ct9PJW6ysOo8g7UIphFY7qWiu4mohBg2DsUTxYQM3ycgNKEI+6sITrvME8kVYwPAyRfBGPhPcDcmxOdMqgRJjopq1zPjrPM3N7jpnJhmHZXcdwQqhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=auBj9uD5sGTc1Rojd1QsHtF48XtWzxWXpnbbJRKJsPQ=;
 b=Umpw4jClACIJJ9DnCObyTpttZ+VnVRj56Z5/ZvGCneMpHdkJVxjnyneITvjVtMuCZxhMAMT7RtjBcRzKbcDT/VT7KVkfDpND9rR0Xz5TXMo8XMiDlayWY2Gl3C9lVRb8+O2rys/FVGPrALVD4glOQvUaa5Sn/J2svr7lppVt9yM+Uj1TOez0QWfDdounGwY4E0O/9+h0Wy25Es3L7RPKrzxQeopXYZ4/57pY2+TTr2wU8WjwqbOc7FbcH4vuq5VK/FHG8TdkVG5hzIyQWvyFjLPtzl2yrb4oao31cG49FoFMgF2A+3H6VPgBI+3R1C73smMeOe4uOvd+DWp0fnucCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=auBj9uD5sGTc1Rojd1QsHtF48XtWzxWXpnbbJRKJsPQ=;
 b=eqgNl/VRif/kq8WYRBSF4xqpozgz/4JoNvY0ImR0yTDZLu3OOOuN05znLScN4ydoDGVxe1XjX4A3SV/HVCZrO6ZNjFlkuUPnxezoX8q3P2g7u5lLJhCXm1RwG+PoKDFloX7NEKgfsQxrQIZ+JpWx5GW6tmBRk+/35EECHpvoGY8=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by BYAPR10MB2533.namprd10.prod.outlook.com
 (2603:10b6:a02:b4::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.16; Thu, 16 Jun
 2022 10:37:03 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5020:9b82:5917:40b]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5020:9b82:5917:40b%6]) with mapi id 15.20.5332.020; Thu, 16 Jun 2022
 10:37:03 +0000
Date:   Thu, 16 Jun 2022 13:36:40 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Christian Lamparter <chunkeey@gmail.com>
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Christian Lamparter <chunkeey@web.de>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH v2] p54: Fix an error handling path in p54spi_probe()
Message-ID: <20220616103640.GB16517@kadam>
References: <297d2547ff2ee627731662abceeab9dbdaf23231.1655068321.git.christophe.jaillet@wanadoo.fr>
 <CAAd0S9DgctqyRx+ppfT6dNntUR-cpySnsYaL=unboQ+qTK2wGQ@mail.gmail.com>
 <f13c3976-2ba0-e16d-0853-5b5b1be16d11@wanadoo.fr>
 <df6b487b-b8b7-44fc-7c2d-e6fd15072c14@gmail.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <df6b487b-b8b7-44fc-7c2d-e6fd15072c14@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNAP275CA0026.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4d::10)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4b6053eb-0e96-4d89-0545-08da4f84269d
X-MS-TrafficTypeDiagnostic: BYAPR10MB2533:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB25338897660E94BA39D125A18EAC9@BYAPR10MB2533.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3F5oimjEqTX0WmSGQeCPVJlZxCcJxNDMSsZeur95rOyiZuNSBcnokxdV46sB2YRnDhQOuv1QWKHzYaReLaXTnNeMPZ5Qcz5tTWxYbSVbtOPTFFt+fDgmxpF7sw1JVzXKX2H5xvm8TIsXKRuBsYSDqbhdzAz70GFbadEKRNAIwMJ7CveZlt80X3hXJWuY2ugiJwmQ/3jR1DC/ao3ZULc5VsgJ7/lTKVY8p8sP7ApDUx0yVryUlF7ulxnsF5xjVwofnuGqQSZUfbPp5Wiiu1eAAEJ60WdhuOfOxcv1IQmSvKc45T71tf1fA8saPF+TlRi2SMqPouw8jcONWt0IDTCpIOIe1bx6QKPc9++TH35v/WBrn04D+M91OLq79LjdmLYlDXF78s9g8bW9z3pMJCuYdSbAiQqRbuhk5ZtyAwmCnePn+bac44c/p4mgEJl1ZXb4AfjC50FCItsCIoKa3wSp+EofNPeeJso9Mx6wWONq1shGJHBrbfd2zqgcHrZKlW0Sg5W2gsDwvL5sj+wDghpOEVXI1k01TC23tpnUzBjEJ+RQGpAExeiYomz2+Sn6d1QHlh2VGI1t3FwtceZ4JrHAsaFtb6zSa+HDzerKhYbux8sf8nkvbjIgd4YB7scOfXgvD4iHKHwYvC5NIdnD2WKskPSmeHmXaq6TZbi2AUZ90gGL77eIE8cnfIGpGdpcaLYaSYIaW9eglbw/Xan01Vsung==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(366004)(6512007)(66574015)(6666004)(186003)(52116002)(33656002)(26005)(1076003)(6506007)(316002)(66476007)(53546011)(8936002)(38100700002)(38350700002)(86362001)(33716001)(66946007)(44832011)(6916009)(66556008)(508600001)(6486002)(4326008)(8676002)(7416002)(54906003)(9686003)(5660300002)(83380400001)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?ZDXkOab2Dv206ktjJ4ENeWCRQ+A5wcQUIHY+U/X/arD/ktvA6udMda9/+v?=
 =?iso-8859-1?Q?6V9deRFHZ9Y9ATWWVOHsZpvjLR5/8cqVicIfdWtUyusEctvHIJla8tPgEp?=
 =?iso-8859-1?Q?Mvd8a4Dn6YU7c3Sr1bPBJoODxDqlreIjhOS8Oct7FEVteYJO2xY0Ky+OP6?=
 =?iso-8859-1?Q?z/FGjVerUXQs1stEsP0SQ40Cr3swnldM4qFs3ZuKrO28Vv9m1HDC+/4uYl?=
 =?iso-8859-1?Q?9jQLyguzzQTocLjZT+ivVfeuyw4JPiMKjdRVdgF9hsBFTye/iGcgj1YGxG?=
 =?iso-8859-1?Q?+yvp1kxLsEwJyxfJVHJNvpfOQo2hMESlErrpny2okHmAO9AQyJ57UrbRQP?=
 =?iso-8859-1?Q?KKq9cYcpUyL1UCPiGVfax60+DuexeUmhuQ5XNaSVoZzCJC35Ds1Hwl+r5S?=
 =?iso-8859-1?Q?q4Rbdk+R04G2IWhFY0SKJx+tMG+P3vwApH8lc09Av4WDlZgRR+oyJ3SKRs?=
 =?iso-8859-1?Q?W0SYE7ZtFdThXn1gqcLmcIR23wr9SJLh7Pzj1Wj/kBNFEZVcYiAw2Bh6Qp?=
 =?iso-8859-1?Q?Lc21GlA6O8G9xyCiSU+YopeeQsYW4hEvpaT2PA2CwcTBTNWeowK3lUNst0?=
 =?iso-8859-1?Q?EznT2FO6kGeg+2Xh5k2fGw8Hwiao7fa7UFQbRFCi6JYYfKZD4yKqt4/cbo?=
 =?iso-8859-1?Q?Zuyay3psKrH4ulaqe665JjeGGo9h8PNgSasL6B1ctPNgqUAOYbY1wagJoV?=
 =?iso-8859-1?Q?7txrYpLuKPD6kVIFelcmDSd7IdItvFQ6VAMh3oDYZ1/TgndWsvRIwyCIr5?=
 =?iso-8859-1?Q?SMSnUe5asSQJQrKgKcB0uNTcIPMjjx7NIp5t93+7HROynRWxXjdBxAU8w/?=
 =?iso-8859-1?Q?Ri7KAzEFqcyqKOv8ipVogw9yttm7SCD10TqPLrfjwCkKL6gNIUvZvp77Q4?=
 =?iso-8859-1?Q?hbMIA3q2fW5XbUEJVXM3a+TVUlTRmv24wZWoKviqIJ0TX2jn5xnEVad219?=
 =?iso-8859-1?Q?qGlGOtd06ONSR3sunV9j9WGQ9o3W6mDVMd6rhniCby5xckByxaPrwXR9dv?=
 =?iso-8859-1?Q?QWQCz+GvKKkznshT6SNb+EoswFtN5AtztP15IYiiLn1v/5BNzOiUns4kB/?=
 =?iso-8859-1?Q?fnDsn43p3wn7r7cCl9AnW2+8VCKn4T9JzLDmjSKbqtjrWy9a0+aPXzayeL?=
 =?iso-8859-1?Q?N0Us2EwXmRhCLTeRb+YylUD04IIsoyi95yRQp8e83D4bQYTenKbu36L67m?=
 =?iso-8859-1?Q?1xQW9901L+q2VFNLEvyx6hGxsaj89PehLW3USm7yzltv52FqnXiXdwCKHX?=
 =?iso-8859-1?Q?aWkBAb2ObI0ppNbwNfWui7RjfdwuAsGcRXjvlVp4+Q/4Xls1CCNAUXXUgu?=
 =?iso-8859-1?Q?Blf5SH7CC+21hdmHhxtAykc5iejS4VJeoD2pmiZLEZ15NYRoihHnWzDudk?=
 =?iso-8859-1?Q?tv11jR4qxy0LHYAr8B43d7tlGvmdl+mrLD1QhDxTbsfrjTMsSl62x9Xi9P?=
 =?iso-8859-1?Q?oaGiQV+kgpRDdYkR1WJ5/gHjJAbGeqZW7+cQGhTI8dpOEumYE4zuGS9DR7?=
 =?iso-8859-1?Q?cjQiW3T/3lWQM3btv/nrt+YqTsrlRpwsoia/xxIJnpUjnyF9uyYA2Pq2C9?=
 =?iso-8859-1?Q?ZB9HJ8dKgsXmC0dXI9hoYRvoPZIxGn948yCcID4VC1CstuGh/uqiLa03G3?=
 =?iso-8859-1?Q?3AeFoQfd2o5dr3a/PKMjMrUilYwsZxrrPNoV0WzKiqn1dJHFd6IjzR4NA8?=
 =?iso-8859-1?Q?f0xik4MMI2+TmAeIg3Tra16AJv+jEbrhi/oG+QJLHGOhIr+it2b6wcoA62?=
 =?iso-8859-1?Q?D7LbAfHsVwTe2mEWqKYPi2TqIS165gaFkUMcyDFmHr1yzVT2Fhg+4rG1ln?=
 =?iso-8859-1?Q?6BMnOZSq9gY9dpsOHnuDntSdcGm5O+s=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b6053eb-0e96-4d89-0545-08da4f84269d
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2022 10:37:03.3291
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6QyEllC/vbecMokS077kPOZ++qxr+ddqb4Uya0kmUSN1BBiKBKxA03Anr5rLTJdfHpx2MRBmX87Koe2/yd7WZzhn7aLxz5Vue9v3yI/QSDc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2533
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-16_06:2022-06-16,2022-06-16 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 bulkscore=0 spamscore=0 phishscore=0 adultscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206160042
X-Proofpoint-ORIG-GUID: r2wpG5cLeqTAxstfZlAKYnf-yBcQ-YI1
X-Proofpoint-GUID: r2wpG5cLeqTAxstfZlAKYnf-yBcQ-YI1
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 15, 2022 at 11:03:34PM +0200, Christian Lamparter wrote:
> On 13/06/2022 22:57, Christophe JAILLET wrote:
> > Le 13/06/2022 à 22:02, Christian Lamparter a écrit :
> > > On Sun, Jun 12, 2022 at 11:12 PM Christophe JAILLET
> > > <christophe.jaillet@wanadoo.fr> wrote:
> > > > 
> > > > If an error occurs after a successful call to p54spi_request_firmware(), it
> > > > must be undone by a corresponding release_firmware() as already done in
> > > > the error handling path of p54spi_request_firmware() and in the .remove()
> > > > function.
> > > > 
> > > > Add the missing call in the error handling path and remove it from
> > > > p54spi_request_firmware() now that it is the responsibility of the caller
> > > > to release the firmawre
> > > 
> > > that last word hast a typo:  firmware. (maybe Kalle can fix this in post).
> > 
> > More or less the same typo twice in a row... _Embarrassed_
> > 
> > > 
> > > > Fixes: cd8d3d321285 ("p54spi: p54spi driver")
> > > > Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> > > Acked-by: Christian Lamparter <chunkeey@gmail.com>
> > > (Though, v1 was fine too.)
> > > > ---
> > > > v2: reduce diffstat and take advantage on the fact that release_firmware()
> > > > checks for NULL
> > > 
> > > Heh, ok ;) . Now that I see it,  the "ret = p54_parse_firmware(...); ... "
> > > could have been replaced with "return p54_parse_firmware(dev, priv->firmware);"
> > > so the p54spi.c could shrink another 5-6 lines.
> > > 
> > > I think leaving p54spi_request_firmware() callee to deal with
> > > releasing the firmware
> > > in the error case as well is nicer because it gets rid of a "but in
> > > this case" complexity.
> > 
> > 
> > Take the one you consider being the best one.
> 
> well said!
> 
> > 
> > If it deserves a v3 to axe some lines of code, I can do it but, as said
> > previously,
> > v1 is for me the cleaner and more future proof.
> 
> Gee, that last sentence about "future proof" is daring.

The future is vast and unknowable but one thing which is pretty likely
is that Christophe's patch will introduce a static checker warning.  We
really would have expected a to find a release_firmware() in the place
where it was in the original code.  There is a comment there now so no
one is going to re-add the release_firmware() but that's been an issue
in the past.

I'm sort of surprised that it wasn't a static checker warning already.
Anyway, I'll add this to Smatch check_unwind.c

+         { "request_firmware", ALLOC, 0, "*$", &int_zero, &int_zero},
+         { "release_firmware", RELEASE, 0, "$"},

regards,
dan carpenter

