Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBEEA3C3DF9
	for <lists+netdev@lfdr.de>; Sun, 11 Jul 2021 18:33:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231846AbhGKQfd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Jul 2021 12:35:33 -0400
Received: from mail-sn1anam02on2138.outbound.protection.outlook.com ([40.107.96.138]:52492
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229817AbhGKQfc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Jul 2021 12:35:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YHzCqS3SxHmXhbnRX9+jD9vu94x8FcXSdBbav6kEF71kqlMusXBf47qzGAZmG5RlHe+CDXEJ3FGMc2q0vFDjvvrRaYl/XeFyzpCWRJUkeI6LQuqmt8F+mar8dXndKazr9ro9m3YC/t1l/P910tRAgaVi0/SZNd/bn0fqEmGFu+amsmBtIrAwj9FysYYOvRmTDdDaOJYl9WrJk6vgiECK1YCyBfPuEGEV/NdL6OsFvNyw4HSnkXNwPkTGnt3o3agPxy/1b2rs/L+ux/qMG3Q87GWVP7+J+DIqqCKXkrwUZGty5MzV3TPGULwSi+W2b8X6d+gRj1uvw7CQ++HfvtXAYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ThP4IMoGjtFC65c+TmhOiqgJe06jApodr5U+KS91LFI=;
 b=eL8mTFm3IRdU1Q9lzX0Z4J0OckSuAVen1yMFP66tFCv8ke9jOtpJzZps1KBmx/ML1BFjr4pWdzYn1EH7EP3WhbYXEEXf/0j36WJIakhIy4i578vIRQuolAQbZGGN+y/A6wUhcgcS+tAbllwL6cq/NU4rrdhvbQpugj1oyx9EBrNkeGfu1MCMLvNYGYbCVsmdsbIlUKf/ksaA2MAPk9qV9O/ErZMrBO/eFh2qbxdiPnOSl2WmnmpkNvVR1bU4mrrvDexnatHT42gaMvAWAzuTnlDYd5ZcU40NQwCBo+c+pm+gzoK05KsHHyrhKKCTWpBvzAc9swYsd9IsYFKvO/UaNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ThP4IMoGjtFC65c+TmhOiqgJe06jApodr5U+KS91LFI=;
 b=A08Gu1uDVUI6QfZhS+9LhGLDZZZOC8BQxi36IlUieYMQ/E7TWSWl01s3uPzqkwbR5KuYYcorFoAmgvCrw/f3EDyH8Q0Hpaa9fW1VvE7uy/towJ9EBpSqsGMhG/kjuulTRD7C4hqMri47p8iHiz8jCXLziAsho3MsOFGD7q7cH0o=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MWHPR10MB1759.namprd10.prod.outlook.com
 (2603:10b6:301:8::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.23; Sun, 11 Jul
 2021 16:32:41 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::e81f:cf8e:6ad6:d24d]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::e81f:cf8e:6ad6:d24d%3]) with mapi id 15.20.4308.026; Sun, 11 Jul 2021
 16:32:40 +0000
Date:   Sun, 11 Jul 2021 09:32:31 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 net-next 0/8] Add support for VSC7511-7514 chips
 over SPI
Message-ID: <20210711163231.GA2219684@euler>
References: <20210710192602.2186370-1-colin.foster@in-advantage.com>
 <20210710194755.xmt5jnaanh45dmlm@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210710194755.xmt5jnaanh45dmlm@skbuf>
X-ClientProxiedBy: MW4PR03CA0003.namprd03.prod.outlook.com
 (2603:10b6:303:8f::8) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from euler (67.185.175.147) by MW4PR03CA0003.namprd03.prod.outlook.com (2603:10b6:303:8f::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.19 via Frontend Transport; Sun, 11 Jul 2021 16:32:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e003c5da-fbc9-458d-7906-08d94489802e
X-MS-TrafficTypeDiagnostic: MWHPR10MB1759:
X-Microsoft-Antispam-PRVS: <MWHPR10MB1759CCF1B99FA7ECD4566637A4169@MWHPR10MB1759.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bU1GTmV46snE8hQyjtfK/6MfVxr6uhfslEEU2UWsSSTsMDu3YZnst726WJF4ajcZsJHOGCVT+TUUZHHbd3OMEpgxmV5XBO4eNUDEW3A+SGeEk9oL2FCKNz9pjZApJHL9tYxEDriKcm8l3NWipI86tuOT4CSbhbp96R35hW6x0wTPPFKpvGNNWsre5A97uYAP0E8cpj0MUNVYQoqxGo9kRR+aS6efDQidaxMqZfUZLi1sCRIl/uAoDQNTs+W7Ps+XUEQevorGOs/YFQTYXP/b3W1c4YOWl5liOfBHrGfkgEWNLK7Y1AhAMW5pC7FEwAXQTUokZg3JrexGQbficPw/ay4erFPPkmTZ+dSH0W0hrpsVvISiK8a6Z+TE7K5FE2jSAif7GYA8krkHbU+sv4WjeTMBtqPApquoYVtZ7wBv3/2PA5jIFsO4OOjfWVuhCNnBLsrZ0yqKz6kd29CUDKvUimWkZQOLkCyFuEqKW5ANDsh4LlOzMZLVKH/WO/xQYeRamG4DdIVzch7Ly1vigTNqMSpT4UepK9YlOqofx/RdfxeaYGkQ4dReucKO2PiS1zoBgMdtswRByQAmnqiU4ajuQWHc5z2NxUK5xlrnsjIE/ajTvUzlMLTaxH7uH4KIK6dBneoD807DPWt3iJtaJmSDfdRWrg/28Ls6TWIpvhgneBB6R5tmULtG3suk7uS2gS9TC1i2joDTkOi2bwp0JzvwiQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(396003)(136003)(366004)(39840400004)(316002)(4326008)(86362001)(66946007)(478600001)(8936002)(33656002)(66476007)(83380400001)(55016002)(8676002)(7416002)(186003)(1076003)(52116002)(6916009)(26005)(5660300002)(6496006)(38350700002)(66556008)(6666004)(9686003)(956004)(2906002)(44832011)(9576002)(33716001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oJAa3zaHxt2k8yTuDUhS45GZyLj4sDSZ9gQubyYp5dllVTDBnA+DFEUtH8gV?=
 =?us-ascii?Q?vPRRY4rP/Lsu9XjzD6Kxi8wwwtGHMfNTHQF7Yy+STgKwpWVvoGiR6DaAJAWt?=
 =?us-ascii?Q?xO7vSFz9cfDmZlGH32oTNMsYS5ay/vb2OaZDHI+NjE6GrlTI79/WueJfIepv?=
 =?us-ascii?Q?qZlDj4a6yyOhtUuyf0mLxy5Vqi1AfMPWVFE9n1rxS1H6p2nkdrQ4Qxs8cXv8?=
 =?us-ascii?Q?dyZjdiB6gI/co/oCdU0gcpNfUQ/uoz9twFBuiyOSfGwp8x5fMyhjSVJlSzZ2?=
 =?us-ascii?Q?yU9wY6JfphrTT0W/dYrTfLqLbivaber1T4lWWI/KdmpLk6Kf/Xdu64bv2+OB?=
 =?us-ascii?Q?YId9SmmOZChKa4Y5kQqNYbEcTqC79m1FnYbwBmsvzrAkVrYdJGMJjbdJbInS?=
 =?us-ascii?Q?+tysgPDQ4Sy8Sy3l4JD1Hid6IU4RcjQM6PZAZfx3gbt4EG6zLSiyawEvwJqY?=
 =?us-ascii?Q?a72tMrIWWK7SpIcxIv6C0MyI5PuaMVlbhRXldAFbFUzrXtdIVJvVacsCzwLF?=
 =?us-ascii?Q?4Ig39U4Uxym47WNf8Wya5EogN01XY/LZzk/VwgRoQHl7bXGUwtyGcSWm7VD3?=
 =?us-ascii?Q?UpeF8xgDQxFS2ih8cwvyXJwsqMOUijRb95IyE9fHRtHGDcIZB7RUHWfCJ+IB?=
 =?us-ascii?Q?TdfJ3cishEBjK+gtTC7yUXDpo+wsBxgM/T34ztYBaOjjR//b52z+BwD7YSSH?=
 =?us-ascii?Q?R3YgzXqFekf1fhcO+IlRkTR0VmhIw+RBMfT2PbfiUlaK/1n0UeMlcU/w9ukf?=
 =?us-ascii?Q?1ZmjdtfiEtXGfMlEIJ+Zc3HOnKCtsiJm8G+JqnWEsszH5RejyijtpfuzrsyO?=
 =?us-ascii?Q?I/I8aUgsCDlt+IX9zoE/MlC9FjX0NJ0BM2wxM7Ru+qy6zoVG8NZCyEaLjFfh?=
 =?us-ascii?Q?VUvTyg2o+v6T4sNPI0qJufTpTrBNeC39r+zB4qXC4gMkuD0A7V9kmTy+m99T?=
 =?us-ascii?Q?HaeysWoKlxOGFqJsqSQv9HEyUinl7eHYoiGnxPKPGwbVn48TU8oOzLXp4JmE?=
 =?us-ascii?Q?Z1xnEDgJ3TzwMwHNuFVSE1nozk2g9RAnlfe/rg6W6pWY2dkQcsr2TYT6/RTB?=
 =?us-ascii?Q?denC6IfCbzraj8fv0ct6xTnFKNH/T3cO1cql/6XimsfrpwBH2VVzsm1a+bnS?=
 =?us-ascii?Q?YpCwY3suNlEub+1PJ70H4oi89oD69SoQxI28QGK0YN8OJTMX29st6lQdTjHW?=
 =?us-ascii?Q?HKw79qEwYp3r2LpyAtbRmaQCuYck+pX76qqDGMrCEPHSkZod8L9w+nhEk4FG?=
 =?us-ascii?Q?v+qcUGZ7TTlE2Nfsc/8rMkKoc1RefT/hQs1FINQr72bqcvfMsvWdHqq/eYsG?=
 =?us-ascii?Q?nDL5SORUKYCqZSoApzZbD1bq?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e003c5da-fbc9-458d-7906-08d94489802e
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2021 16:32:40.7260
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qaW9spmv1dx5KUJY933yqHzm7qFxsB2BEq5q6dKm1HikFU0cQtT5RqIn99pNpoA6u2EBaB0o4ynz86GFSkmMSgiBxavcCd2fPnP56IY65fs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1759
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 10, 2021 at 10:47:55PM +0300, Vladimir Oltean wrote:
> On Sat, Jul 10, 2021 at 12:25:54PM -0700, Colin Foster wrote:
> > 1. The first probe of the internal MDIO bus fails. I suspect this is related to
> > power supplies / grounding issues that would not appear on standard hardware.
> 
> Where and with what error code does it fail exactly? I don't understand
> the concept of "the first probe"? You mean that there is an
> -EPROBE_DEFER and it tries again immediately afterwards? Or you need to
> unbind and rebind the driver to the device, or what?

My hardware I'm using for test / dev is a bit of a hack. Beaglebone
jumped to a VSC7512 dev board SPI lines after some modifications. 

I believe I'm seeing grounding-related issues as a result of this. For
instance, if I power on the dev board before powering on the Beaglebone,
the BB will be held in reset. The same thing will happen if I reset the
BB when the Microsemi dev board has been powered on, but left
unconfigured.

When I run "modprobe mscc_ocelot_spi" the first time the driver fails to
enumerate swp1-3 with "failed to connect to port X: -19" message. But
after doing that, I can reset the BB to my heart's content. Future boots
will be able to successfully find those at initial mod insertion. And
reloading / rebinding the driver successfully registers the ports at
spi0.0-imdio:0X

> 
> > 2. Communication to the CPU bus doesn't seem to function properly. I suspect
> > this is due to the fact that ocelot / felix assumes it is using the built-in CPU
> > / NPI port for forwarding, though I am not positive.
> 
> What is the CPU bus and what doesn't function properly about it?

I'm still learning a lot about how the chip functions, especially now
that I have attained some functionality from the driver. There's a CPU
bus that can be utilized when you're running internally, and I believe
that can be configured as the NPI bus if you're running through PCIe.
When controlling through SPI I'm not convinced we'll have access to that
bus, and if the Ocelot driver relies on that functionality I've got some
more work in front of me.

> 
> > Nonetheless, these two issues likely won't require a large architecture change,
> > and perhaps those who know much more about the ocelot chips than I could chime
> > in.
> 
> I guess you don't know if that's the case or not until you know what the
> problem is...

True
