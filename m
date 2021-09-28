Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 751D041AD75
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 13:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240304AbhI1LCC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 07:02:02 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:32570 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239306AbhI1LCB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 07:02:01 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18SAxFa7028569;
        Tue, 28 Sep 2021 11:00:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=j2O1VsehhMhQfyhAqv8RWI/JWkvdNXmBJfsmTNYmCMs=;
 b=ZH4vlFNXUsslt5JAGs/xfbTR2F7BLM929rc+Pxu7kx1oAIrBffoNMZ8q5i8ahDmjVocw
 f+xc7syrLNkHm4TfESXwHXupSJAPpBKsDGpd7y2knLPWzodqw1j0Ll9CZfIA3TeZiqnA
 Q4Qs4GMbT0suTKP8HIyPrgaxKe9JzgwDOtOanmqCIqTTbZmYx+/Qzos8gMZhmr4iCUqP
 gRwoLm06JTomx5WZEWc3CRCBq6AdXqQOvrwTOJ+XXIzrnDFN+3nIBDzK7blTaHkJa0zT
 pt7NbeqMwpiW9VKJGyWUIHJjLnl6/2qXB465lGvlagrsUyRDs22jZlQIZkhu8fDqzqxU 5A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bbhvbwvay-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Sep 2021 11:00:07 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18SAtax7075190;
        Tue, 28 Sep 2021 11:00:05 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        by aserp3030.oracle.com with ESMTP id 3b9ste1sju-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Sep 2021 11:00:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h02S85vrC7kDwuJYW2qlWe4KtfFlcvc4vffXRhS8LEI1RptAhBcJpPO6/9SnuzWOPUBZh8Lz6z2vsnWXu1KmbkDeos2K1b8iXSDMnLUrpW4zQxdxVvzJ4kRm2AWmwg5ifmbDOzcDcNpThsG9SF+zKp5zl1vDNqyaWwZ79DUR4iHBL7EGGFG9cvUeIz0klB6wH5P1fWU1HX9+9kiBIU4l+f+krATZmYryxbwYW3OesRHPx0yXueyecsszYIuxYnZ1kUy880+D7OzqsD+8U3ZZDuRid5O/nlswMTXtIo+flu0jT2uGKuGaeMrQqRMC9uBNN5Uyfb+jy/ypQWmqiSW0Yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=j2O1VsehhMhQfyhAqv8RWI/JWkvdNXmBJfsmTNYmCMs=;
 b=WIB9gHjlOmw7YgYQG2qLXl6l0fuxuSRFxPGDCucuNUj3hD37cGNo0nJ2G3X20FAMEDic4eO7W25UP1oxv87EaRaYrFM92F3YyNy7HxxZGNU8B4QvGGARx1ozubrJXM8ve5Z+oa2VH7H7QrlyxqTIPfm1g1fslEzUiAHRJ3+ujPyUOZwwSKebgx4fQASOotbYAUlJm8VplmD3wp1ZBk6WEPUqevZQ3x95aHJTsOYHXcvtEZggdw274bzEmKH/P2ZgJhnePsfwGhg7JaFg7gar3x4II34A67pDADFtGzjNNWi4yFX4S4Cgu1HfKAprv7aq6Kh/EbnjGgAly4a9rk4djA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j2O1VsehhMhQfyhAqv8RWI/JWkvdNXmBJfsmTNYmCMs=;
 b=CoUHzI9l89QplGsMXsSnkH0QnU6VxmW5RkcqXT+Q6tuLCTT+BmSxtEaOM6pEdPkCHG+RSlJiW2jHl3qBAYnhZ5N3jIaFfGk84YlpIPltJK8fBvcwj/jqJCh6jURTBfn9MZxxVQ3Udr5A48wHwl7j+4RAvuVHMQKcey+/E8enig0=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1614.namprd10.prod.outlook.com
 (2603:10b6:301:8::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.21; Tue, 28 Sep
 2021 11:00:03 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9%5]) with mapi id 15.20.4544.021; Tue, 28 Sep 2021
 11:00:03 +0000
Date:   Tue, 28 Sep 2021 13:59:43 +0300
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
Message-ID: <20210928105943.GL2083@kadam>
References: <20210926045313.2267655-1-yanfei.xu@windriver.com>
 <20210928085549.GA6559@kili>
 <20210928092657.GI2048@kadam>
 <6f90fa0f-6d3b-0ca7-e894-eb971b3b69fa@gmail.com>
 <20210928103908.GJ2048@kadam>
 <63b18426-c39e-d898-08fb-8bfd05b7be9e@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <63b18426-c39e-d898-08fb-8bfd05b7be9e@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNXP275CA0003.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:19::15)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kadam (62.8.83.99) by JNXP275CA0003.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:19::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.13 via Frontend Transport; Tue, 28 Sep 2021 10:59:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: efeacbaf-e016-4045-753d-08d9826f1f5c
X-MS-TrafficTypeDiagnostic: MWHPR10MB1614:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB1614626B8F691AFCC66E053B8EA89@MWHPR10MB1614.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1XxpPTJgpxm6Ceuyn6Se+dzZ1651Qy+2x/tl0HSI2ubsiuhOJ8oJEYAdy7ReHpief7PTa/uQYquRQj93LE14r7FNPS1u0Q5nspvaVk+Wja9QwYC1cyJoWHTNKgox6mJONCMPw7irdRfK+jQ1ZWXl/9LS/JnQeZTmfeJS0GR1RMPQmwm9F3EXlybFV4Q+dfeSNMo+W2tt+vZPMr8sAuKOvFUZiXOrk/eQb4nyNq7+25yNNVmw3PnL7waY7wd9uMJzASQkJ9TsC/s1SPJDmBnYKnCV0zedziWKTJwFJQKXgFQiBxMej7DZxWjQyFf38EJpuhM4Qibacugxcqfz5ntKTL2qtFVYzPqTjjQhf5Y4cYxA1UpFtmVrsZd/zoHyJlVYZ1MxCL5N+j9023N2ZWAw9yxfY/1EkP+c15FiCpI/n+v3DZMf6Ylf8tk7vFS9iZTCoGRalJiiplvTa8khspOimbrHgHsd11TDlifDLMeFCTroPNiqz2gMMmXbzUaUSQg+Zeq3CkPXBQWtetsq8yh2+bk8spW0zNG1mJNKXAmrUjZruTtw7j1/0OzHGCYx6RNjFXxAYJsbgtlNO2ZHubprY8pk8+rsTsVVchTEEpBg3/l3puJ49RjezCVSAPIOh5D3DX6lhea1Xpj2aBw0AyqKdHncnmGt0/F35EQgqbkHVTkLsAQDDPlDSZJNfDnoh0AEL5A7UkZz+TdY6W41+6VVeA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(9686003)(316002)(2906002)(6496006)(6666004)(4744005)(55016002)(5660300002)(52116002)(33656002)(54906003)(44832011)(8676002)(7416002)(1076003)(66946007)(33716001)(66476007)(66556008)(86362001)(38100700002)(8936002)(9576002)(38350700002)(26005)(508600001)(186003)(6916009)(4326008)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OQHKVkWfjZSAzE38qLB58etAEoXHHztpsri6xGVChB714y9WJF5pvQaV6Ond?=
 =?us-ascii?Q?ekwx/7QAGk9Wi4Lj3Y0uhzdOpTjDI3bSUGSUgmm7pyYToCPR/KiXEObxsph7?=
 =?us-ascii?Q?WwVN74sRiTwFw3vS3OCEwmiR1euAb3Npoiy67R5DzeoZQnq9l002toIPdwkd?=
 =?us-ascii?Q?Fi91QczbKCNJLweTnPXQLHv5mpmNT3EOIIC3nt91rI145mSnb4baxor1M35v?=
 =?us-ascii?Q?ZaJmbee321bYR4Md9kvTPnk052PdcmfPVCDGR+qCYAeIai5uHzT9L6F1b3K+?=
 =?us-ascii?Q?nhfTvJU68a1+kRC/IjnUK7Q2gIFy1HLtnCZ6kPcLWHBkIdnkFaUNibO/HfnQ?=
 =?us-ascii?Q?ATmD22DFRDZSKWGGC9jtvWCydENW1iDMjq6N/xQJI9n/2+eSP+PEMPWnfFlr?=
 =?us-ascii?Q?aRDx5U8/HNK6e2xzb8IPqzMtQ7LRIOD4sGk5SfDwmwitGd+YgM7GDcc4Hg/b?=
 =?us-ascii?Q?uo0+78LE8S7VkzwfmkyBNL24PhSwIPo/y4ofTDqO2XCCxMSD5vDFtvoGSUTf?=
 =?us-ascii?Q?dqGp8+Y81qtxh6EixVSUStPsaxcF2GT29Pt29W5+oS1xE6JwxtT/hujuLuii?=
 =?us-ascii?Q?EsawqT3PX25KJcUNskaR1SzPzjl6HlHCUcjtltjXvL7QG6br4ivwL6UdeEyA?=
 =?us-ascii?Q?kd1UuZhhd5sucajCrrWyzDbISZ9wxgeUzdgzqeWxUBtED8XreLmy8Qhr084+?=
 =?us-ascii?Q?/zx10A05z3uuQtifUGokDYsy2GZt38S9MJQd5TXGeMih3bcI30xUUCxXBKKS?=
 =?us-ascii?Q?P48Eoaf/Oz3gZK/+D9Q8PDRrIMOOP2S1sEtPX4JCy/139kuzBD8YiFTbHk3c?=
 =?us-ascii?Q?5AGMmi19cuqA9X46d2gj4dJqkeDOmhmRKAsJqz4o42jBWHJCY4i7tl+/f8xJ?=
 =?us-ascii?Q?gWfqMfqZpUW2d4vBU0uCeHXoxofbymLH9qt4YNXOSm41R8Nid/fBHYUZnphP?=
 =?us-ascii?Q?JzYTkmEYgY2Cb39oB5AuqJ8Hx7kbioDIHT2WMul3Rtds5kAwuTNd/bS0o0YD?=
 =?us-ascii?Q?Smqr1fZv6t1UDpk35/7ZcDqK0DtGSI4Cuxf7RQdICfTTdRpAqNZWtp/rlXlK?=
 =?us-ascii?Q?v9XmQuSoDs5sFU+QaydzdCu+qJYu5HGn84C6c0w1tgLq8JjrVkEU2KnKeiMa?=
 =?us-ascii?Q?9wC7rdBDarzOlNT1Oe7BJURom4D0yJdTGaWeS33eY6JRiWa/zbgsiDdAvQ6T?=
 =?us-ascii?Q?+VDfLwH0uUfPatNLLUWa2vnYtlmf0CLqo/bewGg2/ISZPZ1JKYLdDV0vkSgk?=
 =?us-ascii?Q?30q7ukt9RpK6G50BHVyRixsHz5Alh5LqzLLZ3IXCCG1G6OuCIHVFcItD60IP?=
 =?us-ascii?Q?r4sNqWuwQYAkLyVghzfBTeIQ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: efeacbaf-e016-4045-753d-08d9826f1f5c
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2021 11:00:03.0808
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: obMXVtY36rA/+zJwBoM2VPd/GSf1slU4wYJU+6+Z9MSLlzofKhfluVUtGlX6o0w78DD6T1pyKwWkjkQQojdxdLW1nfKMu8PRCdHTDojpfR8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1614
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10120 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 mlxscore=0
 malwarescore=0 spamscore=0 phishscore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2109280062
X-Proofpoint-ORIG-GUID: cbojNGj9a7ysSJaX17VGpctVAUZuIMtY
X-Proofpoint-GUID: cbojNGj9a7ysSJaX17VGpctVAUZuIMtY
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 28, 2021 at 01:46:56PM +0300, Pavel Skripkin wrote:
> > diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
> > index ee8313a4ac71..c380a30a77bc 100644
> > --- a/drivers/net/phy/mdio_bus.c
> > +++ b/drivers/net/phy/mdio_bus.c
> > @@ -538,6 +538,7 @@ int __mdiobus_register(struct mii_bus *bus, struct module *owner)
> >   	bus->dev.groups = NULL;
> >   	dev_set_name(&bus->dev, "%s", bus->id);
> > +	bus->state = MDIOBUS_UNREGISTERED;
> >   	err = device_register(&bus->dev);
> >   	if (err) {
> >   		pr_err("mii_bus %s failed to register\n", bus->id);
> > 
> > 
> yep, it's the same as mine, but I thought, that MDIOBUS_UNREGISTERED is not
> correct name for this state :) Anyway, thank you for suggestion
> 

It's not actually the same.  The state has to be set before the
device_register() or there is still a leak.

regards,
dan carpenter

