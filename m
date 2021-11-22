Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A21C458A33
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 08:56:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234234AbhKVH7r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 02:59:47 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:20862 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232708AbhKVH7q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 02:59:46 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AM79nte017078;
        Mon, 22 Nov 2021 07:56:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=w0/B8zArWjEo6miumyRDsRXNbMZ9hY3QyTuxs4paAKE=;
 b=osQRoNdl7NcVae90lec9S1reVUbMJQBVZyOQ956a0tlvgpGmF3HypLlRs7nv6sWZgvpw
 2shsMat7kxXplM8NAlzfzok3DBJRDjeyWXPTRzT+87DhKbfXbVbpIGHNRXe0DgwqQ6dM
 JUXVy9V3EtdI7o//jhYXzR96MAtT7HwK28hX4KNUoRmndp6QF6T8bSXSAaUU2cwNuJTm
 ovm1w1PF8G3JE9OTwJ5CRWKo2DwrtijBEnWsQ0iqXfKk79CDbxrNuAFKbb5iuEKxMFwp
 IcILu3d5qjC0Ccd3FxlH7LaH986gJf44D1pdZbsUKmzQeByWfZSn2pyMJNGQxYZF5QbE mw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cg46f0m66-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Nov 2021 07:56:29 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AM7ohcT098174;
        Mon, 22 Nov 2021 07:56:29 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
        by aserp3030.oracle.com with ESMTP id 3ceq2c75hj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Nov 2021 07:56:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SwnDB6Y+rg1crYKwV/+HiJVKuYqdePSA4moC5ZoP8UkhzXX6obHHdt2yJOg/MyWGYiwd0yL3pU0y4bzueB366z4I0jjt44Yj6SovkawrW4ZroArfFNX/2mSFV95ACKCSzJtIsgNv8Ti7js7506k7VND93wR8j/gwri8HGRwkb/8h/QyY6REuCw1R/XA7d0Ivhg49AfUFPOWrT5C8P9mDefYA+PpFtvk0IPUtc0yVcwGklxsiX5vImPUu5C1uWVPgiUh7gWkzMfmZeyUrgo2azr1dKgdddvpqe7Ioc+04ASDytUpkwWt+TzIvUhRDlO9WIMW8N8yLken4gy4ZIKljhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w0/B8zArWjEo6miumyRDsRXNbMZ9hY3QyTuxs4paAKE=;
 b=aUF0hyXg5B2FUsJqwx1BWwS0loPZbV3ykEUkKag8zzjFubYfwqLz3ET6w407lDuKYVXis1Zm8KYZdc/IDHjSy6mrpSQgsd+VY7sFbrXMmNo+NH4bRDZO9uZ16jICRbvsyMkGrSb6ZlHEJt1C/7J3MXd6zDgmjG7YDPBzuDpo7WO+Ksy+2qpHC2UAtOsKAQaIMIi6G+YE11tn0J/ttpuCwbK7Wnmza2Rqw18jvalWFcAkm4aUONzOcj+B2q7MSlRcplb4h1rSEWrD825ckE0FQIDMVoFRPOuj6b4Gu+kOH6wEgdzSSrgA/h5KD4F3FQXKC8ZkGevqe0h0kdAkGSrDEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w0/B8zArWjEo6miumyRDsRXNbMZ9hY3QyTuxs4paAKE=;
 b=PXtRW3b8U0ZWgw6B1yRptXptdAuv4ZyTj0Z7z+bQp/wentriRG6oxNXifQzJL1IfFRkn0/EOtm6UQU4bE34GRoFZ7x1lpdz2HHhE87FbNxvoP/s+3V8FZOpQWx9eBU8pi6/j4yCIOP7Axk2P2zbhqX3PFZ/ruBoMp/ymmTdpoLY=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1997.namprd10.prod.outlook.com
 (2603:10b6:300:110::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22; Mon, 22 Nov
 2021 07:56:27 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::495f:a05d:ba7a:682]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::495f:a05d:ba7a:682%6]) with mapi id 15.20.4713.024; Mon, 22 Nov 2021
 07:56:27 +0000
Date:   Mon, 22 Nov 2021 10:56:14 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leon@kernel.org>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH net-next] can: sja1000: fix use after free in
 ems_pcmcia_add_card()
Message-ID: <20211122075614.GB6581@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZR0P278CA0173.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:45::8) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kili (102.222.70.114) by ZR0P278CA0173.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:45::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.24 via Frontend Transport; Mon, 22 Nov 2021 07:56:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9aef56c8-e9bc-4058-730b-08d9ad8d95fc
X-MS-TrafficTypeDiagnostic: MWHPR10MB1997:
X-Microsoft-Antispam-PRVS: <MWHPR10MB1997DEBF104436F8D231ACB08E9F9@MWHPR10MB1997.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iP4p0dE4lR1/wsAD/YS1Dlzy3eWLMW8gBhoLP6O1flQv1ltLbJ2AA/Ku142X6YwCxg0IhSdE+SJ0s8Z49/1BTl+A3zORVAGL0RVDlGinBaVyemUBcqKmxp4vYa/QBO0GFyFB9TJMNG1GR3CoyuLwQHwGhaZjORPUJqKFb/3BybZwcYJy2NS2R/rzJExYfuTTBt+Wm9y1vdzZDvlREVmkf+93x9g0nrY8282TFGQijbTGJs6H3mA1rr3zyFTZxv5Oscmon3qSUnCA/Da5nHV3ufq8X/gebMbhGwo9K9DBUUFCGyWUGMElCfVh0KFuCf9a4xVDcuUz/IAtPXLuvocb5z6OtPCpH9P9vfqLss6+7WeobdSc6JqjHZT6qOCtauzbt+uAPopSdHJd0HCOysON8qvTL/G0E0YpfUxqKedM5fPuk4bp+ZCbwKlLest5aawBGDvY/zER52z6h6/7jJjPTxV3oSDvwZUgv5cMpAet+PExWqDUek7AJDxt6iXoTaXhjT6qvu/FmqdAHFjb266qL9Yo4rti8ynI9KhvSf3YmI6x+jPv36yJ7vAAW/HYi2OdhBkZ+NwjBFBrn8qa03tBDpQj1wRJviUO+hCJbiXotXvZZdkS+FgdsrKAsNmKGYraocm/5HLPrX1QRbpOpeIpYSmMGipfO92FL3Ns8VxRMKsaXs21wki1u4eFV8FPv3yRCrxPUAp/pICpy4UI/p6XaQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(55016002)(8676002)(33656002)(2906002)(38350700002)(44832011)(6496006)(8936002)(1076003)(186003)(66476007)(66946007)(6666004)(9686003)(38100700002)(9576002)(4326008)(86362001)(508600001)(54906003)(83380400001)(316002)(5660300002)(956004)(110136005)(52116002)(26005)(66556008)(33716001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iSoOiQh8GcQ5N6l84hOG9jIbiSVWR+Ua0Mvnrc9CPrJk8REfQiK0hQHDN/pp?=
 =?us-ascii?Q?xQZYUpxO0KqdUfKt6JBdqaYHA2uHciRzMNClaN+NtBFflZOhoiLLCJE6ArXL?=
 =?us-ascii?Q?I7G+ABvxjiRQCbhokqKrSiufKG1ze3lK6BBrhbBoKKQS14KEIljGGW8tMA0L?=
 =?us-ascii?Q?8C0O4Fbu7+MzK9NL2B3K5jO28CdzWvxqm7LImr7x3KzJEbq6jh0I9ma/wHcO?=
 =?us-ascii?Q?liKLYnhZf1WLlkA5EiX+20c3RkjGZx6JF9xcXf0U49e36/233TiROESnwn+2?=
 =?us-ascii?Q?1ZA/KC5dn5Aohcw1Mp74z4PRWOYUpivo19O4G2/b6yOd7ba37NV9PfrHCL4C?=
 =?us-ascii?Q?JkcfGdE1GOkrJw/bEjKOw4qJqVhOm6/6ASUdtca+p7iVoYCQ/d91Nlwku4dq?=
 =?us-ascii?Q?DhnikEwh7qk17p0nVtWvtvBPWjSeMlt072j219ZEjW4Si6oIgy5nDYN1EzwM?=
 =?us-ascii?Q?LV1FlaWYPkD9t1yd6S4/YXOEeWxPITqHbIZJ/6AV6CuCyD81zNtErWGlarUi?=
 =?us-ascii?Q?z1vz0nyDKQEKA70OTcD9xHHa8Q9e1zwSpyKI3L42zQ8yx7EG6DbFesIF7P6h?=
 =?us-ascii?Q?fo6hTKqD+YU6jcMhOi+t/BvFulrCuTLACc3FQfjFnecan4AO0v5yzFScm0An?=
 =?us-ascii?Q?OUy8JMejgW+7ghqd4uT8gt5lQ8bf/FZiSjMkMZEcGYSxltH0Vmcc0o+XRu+S?=
 =?us-ascii?Q?/wAB8mxVS740t2/3NUu2b3rSBhgUylcvxTfDt+cx9VNgUjrtGtsgwbYmOO0e?=
 =?us-ascii?Q?mCuN3luoj3YCFpzbuZ0PdcmoOSK0+E7InprWgIIVAILixhFpZGTZ70KVGQN9?=
 =?us-ascii?Q?oO5ZO3ELbIKXhhlWLvsuvkD0AwTlFeIVjujocsIkxVYcyZ39c5GThYXeX5Cw?=
 =?us-ascii?Q?VyDw0BcvzsJnIVrgYatJkndiiC8+Z1bhLD+2LjDxgjLePXYrJl8VJq/pYr9W?=
 =?us-ascii?Q?KmjuitwxYdYXxtAuSBUhRrsQ1fSHGPuPpn0dnyCU13qSXlGI2FWQ8awChdrd?=
 =?us-ascii?Q?3ZwL+eHwQxp2FpB3fqNoxzbN2lxeIhfm2x+MjNy/FQVWKbCY6hPhge1ELMv0?=
 =?us-ascii?Q?4iNWfQXpexCPOaxo8LbAapr3LzDF0d71og8BQgrHmdk6mdYCjdycgSoFlRSk?=
 =?us-ascii?Q?qtBXjRomOyjGadOBKUBun7JbvP1e4GzKErUs+Hr3odq791/iUXq1cXX49bDl?=
 =?us-ascii?Q?9Qpn0q8cjW+5qptDp8jvkrMI9CNKTMrAbpdY7g8hg983f279IkKwHvKpxdjs?=
 =?us-ascii?Q?8a78GdmrgWrRuv5yr7/k4oAtKyX4uM3eScU/r3M5Hzf7z97DMNg6XJ9Cu7Ua?=
 =?us-ascii?Q?Tl0fzEEfO5Co4SQw3ibd8ieH3FF1w8zKVhOZ/27ayKzunNwJAx932sspS/6i?=
 =?us-ascii?Q?6qM5vIFmvd7Soc/zKmJ0FIsAExQ+3Cx0Mt+tDxQygLDqMWuwuWIQ1azbMHpo?=
 =?us-ascii?Q?4Qc5pCac4Dze6/WMuSKcvLN+H+EFMlimzmr+rrThRl9w0D8XNPKLA5tL1+om?=
 =?us-ascii?Q?ugJXKGEuP0/N6WmegdGDNknXqriCpc50Yo5jmfROOk4hL3EMy9CQNBFRuZZN?=
 =?us-ascii?Q?Yko37DIZkX2+V0hjAvKZ4nOT6W3UE+qSwdfl9p5c/h1ieRkkcm0851i3BXxf?=
 =?us-ascii?Q?r0EiKR4bgtLuJ8PsClNcZahO9Ft6nKhoRaLol3Olxst8GeXHAKFGIgHfZPvG?=
 =?us-ascii?Q?do4nwZbiXgzbbyjbDN2FUVQLdBQ=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9aef56c8-e9bc-4058-730b-08d9ad8d95fc
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2021 07:56:27.0947
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iW8/QMiC696CfMCwTpFK2Awm6KGcirmqVzIJ7UtsuE0L2p0qZKj89XN8UmeUS0KyGf33DnwEKl84qo1qHNedgVc2y8iODxa1MgljbKKF7gs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1997
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10175 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 spamscore=0
 bulkscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111220039
X-Proofpoint-GUID: 8kUNpDWaO48VaFYyu1jvTDsdaMlO2tte
X-Proofpoint-ORIG-GUID: 8kUNpDWaO48VaFYyu1jvTDsdaMlO2tte
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the original code if ems_pcmcia_check_chan() returned false then
it called free_sja1000dev(dev) but did not set the error code or jump
to the clean up code.  This frees "dev" and leads to a use after free.

I flipped the ems_pcmcia_check_chan() check around to make the error
handling more consistent and readable.  That lets us pull the rest of
the code in one tab.

Fixes: fd734c6f25ae ("can/sja1000: add driver for EMS PCMCIA card")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/can/sja1000/ems_pcmcia.c | 44 +++++++++++++++-------------
 1 file changed, 23 insertions(+), 21 deletions(-)

diff --git a/drivers/net/can/sja1000/ems_pcmcia.c b/drivers/net/can/sja1000/ems_pcmcia.c
index e21b169c14c0..271fe9444827 100644
--- a/drivers/net/can/sja1000/ems_pcmcia.c
+++ b/drivers/net/can/sja1000/ems_pcmcia.c
@@ -210,28 +210,30 @@ static int ems_pcmcia_add_card(struct pcmcia_device *pdev, unsigned long base)
 			(i * EMS_PCMCIA_CAN_CTRL_SIZE);
 
 		/* Check if channel is present */
-		if (ems_pcmcia_check_chan(priv)) {
-			priv->read_reg  = ems_pcmcia_read_reg;
-			priv->write_reg = ems_pcmcia_write_reg;
-			priv->can.clock.freq = EMS_PCMCIA_CAN_CLOCK;
-			priv->ocr = EMS_PCMCIA_OCR;
-			priv->cdr = EMS_PCMCIA_CDR;
-			priv->flags |= SJA1000_CUSTOM_IRQ_HANDLER;
-
-			/* Register SJA1000 device */
-			err = register_sja1000dev(dev);
-			if (err) {
-				free_sja1000dev(dev);
-				goto failure_cleanup;
-			}
-
-			card->channels++;
-
-			printk(KERN_INFO "%s: registered %s on channel "
-			       "#%d at 0x%p, irq %d\n", DRV_NAME, dev->name,
-			       i, priv->reg_base, dev->irq);
-		} else
+		if (!ems_pcmcia_check_chan(priv)) {
+			err = -EINVAL;
 			free_sja1000dev(dev);
+			goto failure_cleanup;
+		}
+		priv->read_reg  = ems_pcmcia_read_reg;
+		priv->write_reg = ems_pcmcia_write_reg;
+		priv->can.clock.freq = EMS_PCMCIA_CAN_CLOCK;
+		priv->ocr = EMS_PCMCIA_OCR;
+		priv->cdr = EMS_PCMCIA_CDR;
+		priv->flags |= SJA1000_CUSTOM_IRQ_HANDLER;
+
+		/* Register SJA1000 device */
+		err = register_sja1000dev(dev);
+		if (err) {
+			free_sja1000dev(dev);
+			goto failure_cleanup;
+		}
+
+		card->channels++;
+
+		printk(KERN_INFO "%s: registered %s on channel "
+		       "#%d at 0x%p, irq %d\n", DRV_NAME, dev->name,
+		       i, priv->reg_base, dev->irq);
 	}
 
 	err = request_irq(dev->irq, &ems_pcmcia_interrupt, IRQF_SHARED,
-- 
2.20.1

