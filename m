Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DCF61643C5
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 12:58:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727211AbgBSL6f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 06:58:35 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:3806 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726558AbgBSL6e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 06:58:34 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01JBuXu8008228;
        Wed, 19 Feb 2020 03:57:51 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=date : from : to :
 cc : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=pfpt0818; bh=hVSYXq9QOrcLi3i8lVmT22lO2OcEHbVGSR8MrLGiwsU=;
 b=dwSV9A7NLj6iYOkcIyHZjim503SXuDNKBmYBrk09Z9jadKyTDEzEKrQC55c96FcK4Rs4
 QAHM9fT1BCaAs3ZiAmWSMAcpq1q57SV2WW2EmbBKOBZB42l0F1yBc3rYAbYyJ1w7g0BC
 6mm8+YywEivro2v7D78yYfU6xtQC8PHq72fbn4YIenDSq0n8UI8/odLz1yQSLVu6LQUW
 6ScKU3l3Wc/CVyZqBvJGwP/yeUw88pSC6QvzdlIyw7273oLCwvcVcSGlgCGVdkdMjmBL
 rIdfl7QW6kOA6ieYK90IWJOIG62+/3rGitxzinYKvfGXfECDo8//r2h+TdsSD+hc/3L1 vg== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 2y8ubv1wpy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 19 Feb 2020 03:57:51 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 19 Feb
 2020 03:57:49 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 19 Feb
 2020 03:57:49 -0800
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (104.47.44.51) by
 SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Wed, 19 Feb 2020 03:57:48 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KJmk45N0JG6u/q/dRrfz4kjQy+Mbr5vy6HZcs5Q6ua1XFVfjXoifI1WvIOjkPsWn8WIEgB0/njD3Ij7ry/E67QZD6SBZGwyxdQEx31cfeNugjr81CtMIiv+SLF7DB1pKBnEC3BFS4DKMIZR1a8lpXpgFhfrnUDIsWC0B9XYpTLZ2Mo//PveZEw8GnK6mZ/RoNOrecOZWTpRQWdRbRZVD7NQAt8u25H9gnCJYA8rgb1CQHnPzDqz42U1tmijF1QvEVBYj9TZ/YST5N80GAnclkCcTfvagYBxORVvB9ngKLAneCAvYe2YFLOhSnmJDt/nI/HaJnmnTMkOLqCEBcfTHYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hVSYXq9QOrcLi3i8lVmT22lO2OcEHbVGSR8MrLGiwsU=;
 b=MJzZ8YEJsDP7GBlFMhZHEfpcP6TrwtUhFGuE7rzI28Mr7vsgbK2poUotvhBYr6bTp98s8V7SYr1ScYb5JOeaxCOLhA/0dUJLP/9wVsk/f7z7HH1sDrn7Lq7N1/6zkbSpfDmOH29g/BCLt5ZyVB9WDCvb0iHIgadPUMn+UIqXHBeXhG8uEFCs/BqbLp8MHysFx+aYiFhUecIo3osrSM6pRog4QVunYRPNEE5zIghETpzjxX2TZUWGD/q00yT5sLYndMlHnysUq8BlXEjTocdAV7ULl1nJVf6En8P4wUSA+TD+5oF+gDprJK3sQnxCRC0viJKbpz0BBnschlahOxZsOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hVSYXq9QOrcLi3i8lVmT22lO2OcEHbVGSR8MrLGiwsU=;
 b=XRvH903FZc19KWXmHX4gi2jtQImddIqRwsXhsgVsdmy5UfD+Fq5Q+i09LzMtyQmfUQpoaUag7M8Y+hbXOj+M9wmFbECM7NhqWOOhP3l5Ew+GYkdr3SraOp5qYZ0GoxSe9m5t4xdtl1QVhDL90FeBnAAjWXBqBErFoO3KGAR/l1E=
Received: from MN2PR18MB3408.namprd18.prod.outlook.com (10.255.237.10) by
 MN2PR18MB2766.namprd18.prod.outlook.com (20.178.255.217) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.29; Wed, 19 Feb 2020 11:57:46 +0000
Received: from MN2PR18MB3408.namprd18.prod.outlook.com
 ([fe80::30c4:52fe:fdf8:faff]) by MN2PR18MB3408.namprd18.prod.outlook.com
 ([fe80::30c4:52fe:fdf8:faff%7]) with mapi id 15.20.2729.033; Wed, 19 Feb 2020
 11:57:46 +0000
Date:   Wed, 19 Feb 2020 12:57:36 +0100
From:   Robert Richter <rrichter@marvell.com>
To:     Rob Herring <robh@kernel.org>
CC:     <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <soc@kernel.org>,
        Andre Przywara <andre.przywara@arm.com>,
        Jon Loeliger <jdl@jdl.com>, Alexander Graf <graf@amazon.com>,
        Matthias Brugger <mbrugger@suse.com>,
        Mark Langsdorf <mlangsdo@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        <devicetree@vger.kernel.org>, Eric Auger <eric.auger@redhat.com>,
        <iommu@lists.linux-foundation.org>,
        James Morse <james.morse@arm.com>,
        Jens Axboe <axboe@kernel.dk>, Joerg Roedel <joro@8bytes.org>,
        <kvm@vger.kernel.org>, <linux-clk@vger.kernel.org>,
        <linux-edac@vger.kernel.org>, <linux-ide@vger.kernel.org>,
        <linux-pm@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        <netdev@vger.kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "Robin Murphy" <robin.murphy@arm.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Tony Luck <tony.luck@intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Will Deacon <will@kernel.org>
Subject: Re: [RFC PATCH 05/11] EDAC: Remove Calxeda drivers
Message-ID: <20200219115736.tiussdepepqj2jtf@rric.localdomain>
References: <20200218171321.30990-1-robh@kernel.org>
 <20200218171321.30990-6-robh@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200218171321.30990-6-robh@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-ClientProxiedBy: HE1PR05CA0296.eurprd05.prod.outlook.com
 (2603:10a6:7:93::27) To MN2PR18MB3408.namprd18.prod.outlook.com
 (2603:10b6:208:165::10)
MIME-Version: 1.0
Received: from rric.localdomain (31.208.96.227) by HE1PR05CA0296.eurprd05.prod.outlook.com (2603:10a6:7:93::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.17 via Frontend Transport; Wed, 19 Feb 2020 11:57:42 +0000
X-Originating-IP: [31.208.96.227]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c0016273-6367-4ee4-ff14-08d7b532ef4d
X-MS-TrafficTypeDiagnostic: MN2PR18MB2766:
X-Microsoft-Antispam-PRVS: <MN2PR18MB2766A11793F4AC81A7F3A88ED9100@MN2PR18MB2766.namprd18.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-Forefront-PRVS: 0318501FAE
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(376002)(39860400002)(396003)(136003)(199004)(189003)(7696005)(316002)(956004)(52116002)(2906002)(6666004)(4744005)(8936002)(478600001)(4326008)(7416002)(16526019)(54906003)(7406005)(186003)(6506007)(53546011)(5660300002)(26005)(55016002)(81156014)(81166006)(6916009)(86362001)(66476007)(66946007)(9686003)(1076003)(8676002)(66556008);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB2766;H:MN2PR18MB3408.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J6Wj/XBr5++dQdwABbQqaKSkbsdO+0osP8bTZH9ijEX5ayw4fWZ5wstnRp6XL/qjJEBTTMxNNQ1W5gORvM6dGMlNu1KM0XOoLIy0KuI7/X48QdR62Nr9h9zVeCeEcvbyAfwZLK+unsq8flT4Ja2gP9g/HpbFgZcYVd2V6SDEGeABiAGYBUXIdTEYOih8pdhlNCzNpes3znC5EVHIKJ3EnPz9/B+EhlmHkaki29E87v1LAzae+RB6ue61pcqC48eEoff5nWfasoTrsDPOkG2lxFT580583pPdhzLsgrOQjWhucignr2KhQI3/IAs/WKzWK+ZkbXhu0i/XUQQtP5DBKB4gHsIq5tfbh6F0cFyAJqdYP7KbvjY5W3PjQ92jSI1cCK8o1P7YZ+NwSWYYM6hJ/J3VZBfi268ayDeyNnjPcP0oPFcsFiUTzJmX6xWPvjWL
X-MS-Exchange-AntiSpam-MessageData: iLbix4Tt12DsgbwXFE1wBpRypSb188b3KAARX+qlgxt/MQbqsSlFlHU9qvAL+pizl5GEku86usfY9gVgsVFWY0P1E0aRCvDTKzkkeNKAIs7naFyH+d4Cvb2ByO+bvFZcOYOSDiWvCSCcVssdn1JPLw==
X-MS-Exchange-CrossTenant-Network-Message-Id: c0016273-6367-4ee4-ff14-08d7b532ef4d
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2020 11:57:46.6401
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fKW7SCYVI9hUYCT9RFjp3gDDIndFWJJiYmDjeLQciNIKTypnY0UCcehmKtFOGvCh/p6eUSJllrbU5Aca/KqPqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB2766
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-19_03:2020-02-19,2020-02-19 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18.02.20 11:13:15, Rob Herring wrote:
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> Cc: Tony Luck <tony.luck@intel.com>
> Cc: James Morse <james.morse@arm.com>
> Cc: Robert Richter <rrichter@marvell.com>
> Cc: linux-edac@vger.kernel.org
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---
> Do not apply yet.
> 
>  MAINTAINERS                     |   6 -
>  drivers/edac/Kconfig            |  14 --
>  drivers/edac/Makefile           |   3 -
>  drivers/edac/highbank_l2_edac.c | 142 -----------------
>  drivers/edac/highbank_mc_edac.c | 272 --------------------------------
>  5 files changed, 437 deletions(-)
>  delete mode 100644 drivers/edac/highbank_l2_edac.c
>  delete mode 100644 drivers/edac/highbank_mc_edac.c

> -EDAC-CALXEDA
> -M:	Robert Richter <rric@kernel.org>
> -L:	linux-edac@vger.kernel.org
> -S:	Maintained
> -F:	drivers/edac/highbank*

Once upon a time in Texas...

If Andre wants to keep it, let's keep it.

Otherwise:

Acked-by: Robert Richter <rric@kernel.org>

Goodbye Calxeda...
