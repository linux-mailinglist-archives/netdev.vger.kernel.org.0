Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C307C45B4B6
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 07:56:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238442AbhKXHAG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 02:00:06 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:20998 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229549AbhKXHAF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 02:00:05 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AO6Co96006040;
        Wed, 24 Nov 2021 06:56:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=0ZyI8a++EbjjYw86rry1NSh3d/xKcLRzxv5AIoGPUh8=;
 b=o+D5HMsJpY1gtjBPih8mdJIHVUGL/QaCHN2TMRQyXpw8G5VCwQDs3omO3iLGmCsoA24P
 I8y+4h9MAcM28ic16Moq1oEJNRA2veCjYjO1yRrjc6FDminBd8BbFmq6u7SCgEc/2yiE
 ypBXHOjVyHZkXVacEgPkvtAwRLonAzTHm5uO1FbLdw0NU2jLGjBh3vRorNQUxrMDvq72
 8yBHUEZ6BmjA3uDF7KUlIWgnK5HI817andSi85F7q8j6BWSb8CxJwTmHFsaA/bwce2HB
 kbC//kWvYguTrsT7gqFKxJCjeGFFuQ3zHAyTj40GDDDn/IYA2aTvwth5FymuRS5+4e9J JA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cg46ffg5h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Nov 2021 06:56:45 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AO6uiXj148641;
        Wed, 24 Nov 2021 06:56:44 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
        by userp3030.oracle.com with ESMTP id 3cep50y4an-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Nov 2021 06:56:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AfsFohlwVdX3POjnM3YJ55Yasojheo22aGyRofFIURzF+LDoYRAyJEJvrqzQFRbFEyhjnuZXram6xRP7s7JUPUnjGv3r1Ca3Az63S32Ss0D3cNlyQwIuOKsdTc+jwagbjg1glbpLXmr4POhOeA43SkbcDTf3/VerxpKfW31zX4PgL0xhFTS1UraKLyCpR36WXxM54i8QsBpLoHH/a6X1z/sqn0KRtW43/qA689YbmEaibsjPp5hFy2HlVFITi4hUNoG9vCtFy889wjsLTQK3m2XGXo4UMi+ffv6pFNMPrIb7UR72FqsSAuFwxvFcSRoSskpql1XPZZPTQwzTHz1Y1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0ZyI8a++EbjjYw86rry1NSh3d/xKcLRzxv5AIoGPUh8=;
 b=Zu22HFI7qhqm8q2FHCDmPXwQ7v4Kofl0w7v1VJB/EFmlHZr7dnEpypkmfiTg1+3wdm7KBa/rZQU/pjBdPzTcyFYVeo+BdRB83MZH7J3Ngrztdmgm/nnsGU5pDJQ5HsQnXlcWfMYH7N9Q5a4X4ctt/Ebb64bVEa3v5G5qYVclSjLZMIFay8uhBIJsnHtJxHbmtcxqbBfFQDLbs3Sbbg7Wp9HrtG5T9MuhjMnRj2gDQ9jipL28f21Aky1lsWg1eck+YNoLnkL8HO1dVTcek8Ojf0zuzjkL9Kh+xpKWQMAF8yx1MFESoyL4Typ1eQVrwEgTzeqZUVcCfHrBUibFUdsj5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0ZyI8a++EbjjYw86rry1NSh3d/xKcLRzxv5AIoGPUh8=;
 b=fUAhb9mEDyCEOst8WE/byAZIQ7gx3LY+UwBP4NFGgrytcwxCz+lH/TB/cGRBHs6hZ/2F+99+4FRbPH1dzImsrhS1rCex6mmnhzl6aAsVoeXPEw9Blva84OMlWyimnY7ziXHAR7m75HVnWkoEfrlU+OUMl+SLcRufl7nredQ2+HA=
Received: from CY4PR1001MB2358.namprd10.prod.outlook.com
 (2603:10b6:910:4a::32) by CY4PR10MB1637.namprd10.prod.outlook.com
 (2603:10b6:910:8::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Wed, 24 Nov
 2021 06:56:29 +0000
Received: from CY4PR1001MB2358.namprd10.prod.outlook.com
 ([fe80::e5e3:725b:4bb:7809]) by CY4PR1001MB2358.namprd10.prod.outlook.com
 ([fe80::e5e3:725b:4bb:7809%5]) with mapi id 15.20.4713.025; Wed, 24 Nov 2021
 06:56:29 +0000
Date:   Wed, 24 Nov 2021 09:56:06 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leon@kernel.org>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] can: sja1000: fix use after free in
 ems_pcmcia_add_card()
Message-ID: <20211124065605.GE6514@kadam>
References: <20211122075614.GB6581@kili>
 <72ed48e9-0659-78f9-1b31-be54b118ab76@hartkopp.net>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <72ed48e9-0659-78f9-1b31-be54b118ab76@hartkopp.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNAP275CA0013.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4c::18)
 To CY4PR1001MB2358.namprd10.prod.outlook.com (2603:10b6:910:4a::32)
MIME-Version: 1.0
Received: from kadam (102.222.70.114) by JNAP275CA0013.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4c::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19 via Frontend Transport; Wed, 24 Nov 2021 06:56:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4b954dfa-0f56-4d3c-7d3b-08d9af178a0c
X-MS-TrafficTypeDiagnostic: CY4PR10MB1637:
X-Microsoft-Antispam-PRVS: <CY4PR10MB16374D92ACECF7BB374EB7038E619@CY4PR10MB1637.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2Vq0tPl6X/c5xAxYD/P5nMVB7uL40fkgaleLZspIy/b14wzFbmFBjsKsQChUqLlK7snPnAGVJTdqP+hcadRSzn8PCvvtt7G9JclH51cKg+ePRFX4IsrIMYOPmhL968Nxq6KIjqOM4lzCvUhQWFB1No+3OObtZzV3Oyt6smqx3gEPFgQ9fyfo6u8GEYqZqqyZBO2TJAlbsvv841z/Ed7yb9LPzJZ1c/kYQtbETvxekQJGifGHL7ybEfLHQV3mx3K6odg4VMt2aa3b1DJaHuEunRy5t1Fr4SYvDo6pYOCIM29kImqg/C5qbswQ+BA4j6YKa5DsB/J1lFQTs98KwUj7ICbKrp8vSsoEJirnYOSobWbiMI9DyPsDqpTEaf/hdCvWwxFm1AcqfQH4r2eOqd5FN64U70sVf983FeYXo+epMIKvoJKnF/ZouaNiQV77nVP8pmcBykF7sWPeAIAlpgCsGVtKwUds08Rx0Beidc2px7XVfatM4CUps7jIa3ngMGGjf4o/fOvXtztRz8U7k0oAp8KTzK+lvmfrSY/sUByjSwwDpowru3uu0mqWFsMX7OIbPya/Zx6WvgzwFu0qtjixjXNzq0OFVvLVJRGfNcemMOHZN8YT56R0FNd21jdlk+HIzhNyWKYnrr+u6KIsG/9zMlauKpPlxolakHKDOiJTgZnuoWuD92D+ZeJ/x+IpRozEmZiUSV9Ui4/7inQaAPnn4g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1001MB2358.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66476007)(66556008)(6496006)(8936002)(66946007)(6916009)(26005)(54906003)(33656002)(52116002)(9576002)(508600001)(9686003)(86362001)(8676002)(956004)(4326008)(316002)(53546011)(38350700002)(55016003)(6666004)(44832011)(1076003)(83380400001)(2906002)(38100700002)(186003)(5660300002)(33716001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zWVqf+R/U4MwSLxMrO/h7CTqVCB7OHZajdKcbWVY7mbIVET0lGR/pRkKawYw?=
 =?us-ascii?Q?Eyccqs1hp2JErQp6FvNowcGJKqSQQH2fKozk81bOh49+hVxaC4z2wmdp/w6q?=
 =?us-ascii?Q?hZxFXm4BCCLHxoPg0TBl5rPynadI3NPVAvdQvQ5CZlXhj6qEjAKIfmLSbhr1?=
 =?us-ascii?Q?DI1WFg3Cxcz+399NOkmG20luS3LDGdgtZGD5SAHqJbBonKZf/ienFGoJVgpQ?=
 =?us-ascii?Q?DePdXRSgka2xwO2fOuemRsWy4ILmj/Zl0C2L3FUKTK6tZc13XWElqbHWURac?=
 =?us-ascii?Q?9i0Ljo8YVIuPxekT9mkNiDBNtGuKEYFipKiIV6pKgNnRljik3kfUzhjoU6Pq?=
 =?us-ascii?Q?o1ElGemN2Ynb5/lROC4JagqXdIfN5+PUoYkc47f/+oix8NE9YruYeVRiOXSs?=
 =?us-ascii?Q?O0arZQQuhQzPSLI/oSdMYTl5GEgvk0hgsJuAUJAQ4oVKvc6URfYyTl9kCpNp?=
 =?us-ascii?Q?bFjYtji0sfMQaFTwk3dNoYEMhPACaK0pSmPKfzYu2m6/Q7BH42WGsxFxN+AR?=
 =?us-ascii?Q?CJghTRo4qKWx5P1KKJqkBo5IuQajA5XZGB2eB2/3CWwm/ECwdGXEnzKUaY6i?=
 =?us-ascii?Q?cbHB1GDQeo94hKQNgfzuMUq4Xh6/eVD2zZVAOBmaSOdzQ7rrcM2U9+xttxyQ?=
 =?us-ascii?Q?M2QJGcDaBA4WK7ei8ywcGjglRPAch0ZTqYXJA4uSH97q9sGOXngUqiOuskL7?=
 =?us-ascii?Q?nQJEpHmQ4W//ggZw8TqcDEyhjng2NPTcm2WECjUvtN45iax5uocGaKbC4c8y?=
 =?us-ascii?Q?jrLi6tStXk2aOUyB1G6dFnaeiKSJ+tYLneYuERBOUXXeaWogUpIykZih0/q+?=
 =?us-ascii?Q?A8mlU7yktY1NjU1rAfG5aDyYLgKm1URSFP2dgdtpyF0uxyEMqi3THWXCQsN+?=
 =?us-ascii?Q?4XdpwB6p2DYfEAVo7hJDTHxaCxc5aOyiF/GLniuWgKFXDboRYWtvOlyxEclJ?=
 =?us-ascii?Q?L/m0NIXxA396qCfMAOMgiL9u+U2Fa572VQJNMsyAZzRAKhcQqRAJhXTEm1cK?=
 =?us-ascii?Q?rvrjmE9YHgq34lXer4hrBXuldOa/o07flRbcaGONoPRG9lvymFgcjVJNRITC?=
 =?us-ascii?Q?ZxIYEFyyhzzX2t7xmEoLgmSKBX6v7oes2NzGJmoIF8onkjwPhzT51/NRSXn+?=
 =?us-ascii?Q?0mlRkZ7/pQg6r6w+dNbEUaqGl52PIPX84QvcpFgch73ihcFh4NN/YVEmgPMJ?=
 =?us-ascii?Q?SNF0okH/96eG3k/iky/n+HvVyM6k10ylsimXoCyMn3CUKGGp4dkLsKhuf9YP?=
 =?us-ascii?Q?gHMuqN1c0h1Hwm6OG6gNOkwtg46tqktvoZGghPu23WdWI4Ko24+4OgXYTekd?=
 =?us-ascii?Q?zq/YtGpVKPlLwGR1LaayhQ2MWzXb6kkm717G/1CzFw8tMM7A+LC9kGYdfK65?=
 =?us-ascii?Q?ITeZLxVNuKRraHXfxEo/8b+I6aJB9QloFo7MIuKSlESpF8CwYO1OyTvbUsdO?=
 =?us-ascii?Q?edccND9O7Q9XPfAA7hYg3hf7FMGH6OYaETsiKVFL+TTuc7APrxFZ5e/THBgj?=
 =?us-ascii?Q?1JPLryw/Eo0Ya6cSZ2R8UeRCVVVrhEEJ48PnSMTtGs1rrOgXPq/d6q2n7P07?=
 =?us-ascii?Q?QG3l3a5MpI0tvyQ0cR/F08iIw6lGLIOJxG1UemqSREcp2L+cVDGqRq9b8UAt?=
 =?us-ascii?Q?hdJH2VCwyUCXu+Leiy15/jXHpdLdMXVOtcTGuwQne4ohIxoWIJ9IrMK5uYc6?=
 =?us-ascii?Q?x0GjFBcVBRfBDwe3R8bJ6a+Z4fA=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b954dfa-0f56-4d3c-7d3b-08d9af178a0c
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1001MB2358.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2021 06:56:29.1484
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DJvVujjHkbYosFoLSlMfAIENvbNAqH4vk9II5TFtorjD4CWUYgWIjmg+2j7b/5bjkjCRz85OZFoK2I+sKBFLGp1dlQG8gF2H83tmsKM8lYI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1637
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10177 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxlogscore=790 bulkscore=0 mlxscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111240039
X-Proofpoint-GUID: qoUivb9r6b5B6VqgH9NT622A1_zqOYBl
X-Proofpoint-ORIG-GUID: qoUivb9r6b5B6VqgH9NT622A1_zqOYBl
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 23, 2021 at 09:42:12PM +0100, Oliver Hartkopp wrote:
> Hello Dan,
> 
> On 22.11.21 08:56, Dan Carpenter wrote:
> > In the original code if ems_pcmcia_check_chan() returned false then
> > it called free_sja1000dev(dev) but did not set the error code or jump
> > to the clean up code.  This frees "dev" and leads to a use after free.
> > 
> > I flipped the ems_pcmcia_check_chan() check around to make the error
> > handling more consistent and readable.  That lets us pull the rest of
> > the code in one tab.
> > 
> > Fixes: fd734c6f25ae ("can/sja1000: add driver for EMS PCMCIA card")
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> I do not think, that you are fixing something here.
> 
> The loop
> 
> for (i = 0; i < EMS_PCMCIA_MAX_CHAN; i++) { ...
> 
> checks with
> 
> if (ems_pcmcia_check_chan(priv))
> 
> whether this channel is 'available' or not.
> 
> As this hardware could come with only ONE channel it is just wrong to tag a
> missing channel as error and finally kill the entire setup process
> (including the potentially working channel we already initialized).
> 
> So thanks for the patch but NACK ;-)

There is definitely a use after free bug with the "dev" pointer, but
you're right that it would only affect things if it were the last
channel.  The easy solution would be to do something like:

-	err = request_irq(dev->irq, &ems_pcmcia_interrupt, IRQF_SHARED,
+	err = request_irq(pdev->irq, &ems_pcmcia_interrupt, IRQF_SHARED,

I'll send a patch for that.

If we were super paranoid, we could add a check for if of the channels
were available.

regards,
dan carpenter

