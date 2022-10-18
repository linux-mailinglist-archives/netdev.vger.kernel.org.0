Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2859960291F
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 12:10:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230423AbiJRKKx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 06:10:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbiJRKKc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 06:10:32 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE5C0B2DA1;
        Tue, 18 Oct 2022 03:10:24 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29I7QGcN003536;
        Tue, 18 Oct 2022 03:10:16 -0700
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3k7vcpapn7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Oct 2022 03:10:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UBhS8P8E3QjWo/OHa6NEb+QyXYOhQUVtHBopK5HlCc8RuWuUf8FiXvRhKKHizP2SOae3v2M6wOOfENZ+C827K2Ow+iBUgia9htu27TKBnORAItINrCD68/mjb1kyYnrt8U3ozlzyHj6aUZFy7oLCYTMPNjzZbFRhzVJXJdCqduuAMMAfIv6YXvICEzyTrgfEN+EkVyZr05iXApfvoVswsbPL+esVU/MiB7frudCVIpequzyNmFFjHG9PE/uuQLJVzsw0VsSE75DhVheBfCDbgoxJbgN2taiiD52I2M3YjGJRb2e+cMGY+m7zRlXa25fQPWYfI1574UKAt2kFlaaNzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=enrN9NQq/1csiOJ6ljNEL2NeGdZLCon+pS7t6BodtXU=;
 b=Fp8cmEC69VDon7vIMKBmQpKK7AmSBYG4r61+IFal8cioBeJyiLZwGrShkKX62wi2TtFGLcQzrQ/IoiHCcMAozm3+ASjzudfCYdEHblpx8QEaHqvz35kCl9nelfITERGZ1b9JR9vo1zHa8b8zcMzGau4ZkHzgkE6lyrV2INV+udxdCCRASxnKXTsCQMHfYCutarSWG1M/DtMr5O6XpZADZBLmyI5V1lLvfwXDTpBJHIrg/AUAsKhviJk1pV8oqPkhL9kN6tMd1PeBSXZHdDuwQTh2vjaq3clEvBrEQo5vl0SLW9TIZvPbUWNGZ4HyDg9r9CshJqQQ7Uwa3glTLTAn0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=enrN9NQq/1csiOJ6ljNEL2NeGdZLCon+pS7t6BodtXU=;
 b=F5zgQZAOOfDS+xWprB2gaG2fmGaWicOLfFukAOJ2NJvN2694I4pugVCYYecd7YPEBZsr85fVTQpnGtn9HURjpeD91240LJALB9fnD8BDq3surUeyHTANySIwZUGJ3TqeHQ30i2hLzIIoJ3XqP5vw1b+Y1n1Qfx6HsZyjrFR7u0k=
Received: from MW5PR18MB5199.namprd18.prod.outlook.com (2603:10b6:303:1ca::16)
 by SA0PR18MB3645.namprd18.prod.outlook.com (2603:10b6:806:9f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.32; Tue, 18 Oct
 2022 10:10:15 +0000
Received: from MW5PR18MB5199.namprd18.prod.outlook.com
 ([fe80::6660:188e:7728:73a5]) by MW5PR18MB5199.namprd18.prod.outlook.com
 ([fe80::6660:188e:7728:73a5%2]) with mapi id 15.20.5723.033; Tue, 18 Oct 2022
 10:10:14 +0000
From:   Michal Kalderon <mkalderon@marvell.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        Manish Chopra <manishc@marvell.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: RE: [PATCH net-next 3/7] qed: Add support for RoCE hw init
Thread-Topic: [PATCH net-next 3/7] qed: Add support for RoCE hw init
Thread-Index: AQHUgVHnV5rTUYh2skSo+eKWU7aIiK4LxdoAgAUaggCAC8/FYA==
Date:   Tue, 18 Oct 2022 10:10:14 +0000
Message-ID: <MW5PR18MB51999D61F954FB61B7791739A1289@MW5PR18MB5199.namprd18.prod.outlook.com>
References: <20221007154830.GA2630865@bhelgaas>
 <20221010214440.GA2940104@bhelgaas>
In-Reply-To: <20221010214440.GA2940104@bhelgaas>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcbWthbGRlcm9u?=
 =?us-ascii?Q?XGFwcGRhdGFccm9hbWluZ1wwOWQ4NDliNi0zMmQzLTRhNDAtODVlZS02Yjg0?=
 =?us-ascii?Q?YmEyOWUzNWJcbXNnc1xtc2ctMGQ5MjgxYTMtNGVjZC0xMWVkLTljM2MtNTA3?=
 =?us-ascii?Q?NmFmMzM2Y2NkXGFtZS10ZXN0XDBkOTI4MWE1LTRlY2QtMTFlZC05YzNjLTUw?=
 =?us-ascii?Q?NzZhZjMzNmNjZGJvZHkudHh0IiBzej0iMjM5MyIgdD0iMTMzMTA1NjE0MTMx?=
 =?us-ascii?Q?MzUyMDg5IiBoPSJiUHFZWFF6ZHdTY2ZZa3l0c1FlVXBzSzExTEk9IiBpZD0i?=
 =?us-ascii?Q?IiBibD0iMCIgYm89IjEiIGNpPSJjQUFBQUVSSFUxUlNSVUZOQ2dVQUFQNEZB?=
 =?us-ascii?Q?QUFaMHVqUDJlTFlBUzlwZW5uTmMzV0VMMmw2ZWMxemRZUUpBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBSEFBQUFDT0JRQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBRUFBUUFCQUFBQTZQcWVsQUFBQUFBQUFBQUFBQUFBQUo0QUFBQmhBR1FB?=
 =?us-ascii?Q?WkFCeUFHVUFjd0J6QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFFQUFBQUFBQUFBQWdBQUFBQUFuZ0FBQUdNQWRRQnpBSFFBYndCdEFGOEFj?=
 =?us-ascii?Q?QUJsQUhJQWN3QnZBRzRBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBUUFBQUFBQUFBQUNB?=
 =?us-ascii?Q?QUFBQUFDZUFBQUFZd0IxQUhNQWRBQnZBRzBBWHdCd0FHZ0Fid0J1QUdVQWJn?=
 =?us-ascii?Q?QjFBRzBBWWdCbEFISUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQkFBQUFBQUFBQUFJQUFBQUFBSjRBQUFCakFI?=
 =?us-ascii?Q?VUFjd0IwQUc4QWJRQmZBSE1BY3dCdUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-refone: =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUVBQUFBQUFBQUFBZ0FBQUFBQW5nQUFB?=
 =?us-ascii?Q?R1FBYkFCd0FGOEFjd0JyQUhrQWNBQmxBRjhBWXdCb0FHRUFkQUJmQUcwQVpR?=
 =?us-ascii?Q?QnpBSE1BWVFCbkFHVUFYd0IyQURBQU1nQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFRQUFBQUFBQUFBQ0FBQUFBQUNlQUFBQVpBQnNBSEFBWHdCekFH?=
 =?us-ascii?Q?d0FZUUJqQUdzQVh3QmpBR2dBWVFCMEFGOEFiUUJsQUhNQWN3QmhBR2NBWlFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFCQUFBQUFB?=
 =?us-ascii?Q?QUFBQUlBQUFBQUFKNEFBQUJrQUd3QWNBQmZBSFFBWlFCaEFHMEFjd0JmQUc4?=
 =?us-ascii?Q?QWJnQmxBR1FBY2dCcEFIWUFaUUJmQUdZQWFRQnNBR1VBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBRUFBQUFBQUFBQUFnQUFBQUFBbmdB?=
 =?us-ascii?Q?QUFHVUFiUUJoQUdrQWJBQmZBR0VBWkFCa0FISUFaUUJ6QUhNQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBUUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQVFBQUFBQUFBQUFDQUFBQUFBQ2VBQUFBYlFCaEFISUFkZ0Js?=
 =?us-ascii?Q?QUd3QWJBQmZBSFFBWlFCeUFHMEFhUUJ1QUhVQWN3QUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-rorf: true
x-dg-reftwo: QUFBQUFBQUFBQUFBQUJBQUFBQUFBQUFBSUFBQUFBQUE9PSIvPjwvbWV0YT4=
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW5PR18MB5199:EE_|SA0PR18MB3645:EE_
x-ms-office365-filtering-correlation-id: 8839373f-c047-4c03-31be-08dab0f0f368
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hMaOXQGHnIO3a+TehUaTUae3WbpYg+pHyxHBlKHcL/PMr5pTjfVmY70izewKHMkgXaHcM18prxPzwUqfzXcIvcKLNeFbeTEnMs1WIgX0eyWqCHW7JJyOiGFaFAXG5oELWWWGraWlWDc6RBNgmh14c3im0jph+1mrLcdTCbvB2AXlD9DfRsqYe/vTCYIN82LOi5kzlC+o2NeKg6dCxvuS1uw3Sr06VD7YrFul1UhD5txixoBs7e2MwWjvKQN861Z0klq+XeRa8gWm+aLE7v2AICgcLVFxCnexU3BZPhg32FG9A7bgqAj6MeHY0LvfHgeQays6QSkR3M0z87D1At98e8lZBXwaoCLzjzbDQQaT0wV8AXNDJLhCEeAUd0adyktGXS1XfXVSezH/GpMyc2qyzsh/5UaUUNjN6C2uwXoCKQ7n78PruiaAeoqUac+au6677kY+f1gNwslmWPwPmMwQhxGl6XOHlFafVlfdUfjM912YErsKw3zXh+/ZDmiHZXZOS2T1TtLFiJCXjx4woKMxeMM7CGIbY3WeqboSimZv2yTsgm8HIRsoCY0lPimv4RG2nxLK5DCWBytfeyVGBDjG84gadEA79G7hzA5nWpcCy7fs/VXSVvoUI93jUePo7HnKqxnEkI9yOwQGQrjkc3A9uhKbHyvEACvKIuVr7tvhq2A0el6mvODH4KgiyjMT9MsTA4JeWM1zNpYwm47Sy0fHkJc1pJMfet9WwH7l+sRf95evmLCjbBGRg5+CJIIMlDDoxOiuapiXiAAsV96xb8q58g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR18MB5199.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(39860400002)(396003)(346002)(136003)(376002)(451199015)(8936002)(52536014)(478600001)(66446008)(55016003)(122000001)(38100700002)(86362001)(38070700005)(7696005)(76116006)(186003)(110136005)(6506007)(9686003)(66476007)(8676002)(83380400001)(26005)(4326008)(66556008)(64756008)(2906002)(316002)(66946007)(41300700001)(6636002)(71200400001)(54906003)(5660300002)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?se7l9t4TDxcH4fVwlKCu+D3XfWkPN0TGk5UIfsw4AcUVEL2uhYVTWLnuNVP/?=
 =?us-ascii?Q?cjQzbY4gNetxhmrDzPyWvWQgG2f4N7DpB4cR+orrmyObGrpKjAhKfJlFDBcn?=
 =?us-ascii?Q?B+NFhvOqfLpyyDe+owRuqZPJ6fGWigOj1ojW3MOO5rPDGu7TQ8oZwcZs67VJ?=
 =?us-ascii?Q?DHU8RVM6bOQa2axyU0xJKY78pJrpBDJUkNkmSLTQerTMCuR7HlN6HI3e7MCa?=
 =?us-ascii?Q?0oz5irMAjt67Ozcbu3b1dl1YVZhjDiE61ux8V9PInWOy//HzbBEAWIAHRQ1n?=
 =?us-ascii?Q?GBRPPgbxrln8bq/95xXOvJ4NcvsUa5VMQQY1FTovb1aakRLcQSfW1MvuSN5b?=
 =?us-ascii?Q?3wKGJu5RwSOhZIV/NdPB74LSHlq78H6ITiLt1eAKzil+yI2do+CLHWmYRlbi?=
 =?us-ascii?Q?dHNF02k2/qLozFYNH62NcIUg5pDpst4ZaaVgs7gvCNn0y5jnSVWzqHsXMV3G?=
 =?us-ascii?Q?2gM36U+JURybeAQBgGtiMnWV3Bv+dvk13Kk/OKQKfnkY21fh4rYFgBRnYRk0?=
 =?us-ascii?Q?/Tiaj7oR/wc7W4OgO+jmSIHIbqRlnI14wdkg7UlQ7ueG4aNIVUq/ijBDjWFd?=
 =?us-ascii?Q?m2c9AvYtbmD6qHjPpZtTjOAovHm/Y4wT5n7Deq2jKUwjiOt5SM8815M/E4ih?=
 =?us-ascii?Q?83SY0h4hjkyq+Wpv4kj7wyD1ikSNRjO1VrR3waalDJuqkXk0JBVToLuraOLq?=
 =?us-ascii?Q?yZfdzL5AZLHYfZ4H20ZV7bsE6uyLv05DbJrXV8KRr69ptGETqa81DVpTd3Dy?=
 =?us-ascii?Q?zx1BKuoJnNOuwU+XY+O7+7mfteSkAkCFkPStFFu5B9rS1xZRZMe6Kc7T3sz5?=
 =?us-ascii?Q?xHLG1t30g2T1G/6/QZfow7CfkzUjh9M8lM7Si8bmLj+9MVl9+wEw2lXUlS7B?=
 =?us-ascii?Q?8irGPcqtPcvaHBLZUb6FJDtPr7XS/osMRlt2eEWNkohyhvQazyqY877pQk3I?=
 =?us-ascii?Q?DrYXkQb4Ma8taKvNwxlCqvHskVpWzmkX4jnv1rJK3pFmveCWUsCg92QcqRrx?=
 =?us-ascii?Q?iBATOO9VJcjZP5gpaQaI6gjD0hSwYXgJuhGWH74eALhv8bP7LcYOTuql9375?=
 =?us-ascii?Q?hsqABFdVw4tS2PwyylEdcsXAM+9B79cLVr3Je2kMlAldRuF/3SXtROO2H5Ia?=
 =?us-ascii?Q?+THsMBaF7NYuuAmOU55Kdpqbt5vxIhk4X/P3RnLCEqLycWAmcti+DgZEPXcM?=
 =?us-ascii?Q?jB0YYcXi41pP1ed/sbnMJrEm3cR7Nfhujyq+VRWh7KsniY0nrjlX2m1lNSFt?=
 =?us-ascii?Q?HC99ZEAxQubMNxX3sgs3lW3jcW8jQqIN98wC0w0ofVhn1Ma89uupGcrWgIEK?=
 =?us-ascii?Q?SWCCxr0rsijJO4aoH/nxc+Bb0fEZ5rAwGBuW54IDoSuRQaIxfO7hr+JF6I4X?=
 =?us-ascii?Q?OzgbY3hOPo7wXHB39rYdFhCIniB4SV/RSy2h1V9V3zC5w3pFfLl3BeTiRwUy?=
 =?us-ascii?Q?dU42f41eJf/qUAueJIU0W/CB++3ethCIVIXb7c4BqS6QyATHkbtgN2RxSYE1?=
 =?us-ascii?Q?JjFQEJQ55YO9yp62AJ0sqolei2OjKwNFgY82zLl0ebcFEUh/AtqFks+G55kO?=
 =?us-ascii?Q?uFHqTsrkUwVa1gUGz4GM7fC1EvzmXp2A8/PQ2Npb?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW5PR18MB5199.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8839373f-c047-4c03-31be-08dab0f0f368
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2022 10:10:14.8365
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3BAU90/Q941RatlpJiozuVChQvjzm0k0SxtdUkmhNnjkI1ttf5Vp3zklrnFAvUxOKFWmsb8DxK26Xg8GKBIjyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR18MB3645
X-Proofpoint-ORIG-GUID: uvJEx8WeaZiZEopfCtgS5dvR8EyvlCxm
X-Proofpoint-GUID: uvJEx8WeaZiZEopfCtgS5dvR8EyvlCxm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-18_03,2022-10-18_01,2022-06-22_01
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Bjorn Helgaas <helgaas@kernel.org>
> Sent: Tuesday, October 11, 2022 12:45 AM
>=20
> [ping, updated Ariel's address]
>=20
> On Fri, Oct 07, 2022 at 10:48:32AM -0500, Bjorn Helgaas wrote:
> > On Sat, Oct 01, 2016 at 09:59:57PM +0300, Yuval Mintz wrote:
> > > From: Ram Amrani <Ram.Amrani@caviumnetworks.com>
> > >
> > > This adds the backbone required for the various HW initalizations
> > > which are necessary for the qedr driver - FW notification, resource
> > > initializations, etc.
> > > ...
> >
> > > diff --git a/drivers/net/ethernet/qlogic/qed/qed_roce.c
> b/drivers/net/ethernet/qlogic/qed/qed_roce.c
> > > ...
> > > +	/* Check atomic operations support in PCI configuration space. */
> > > +	pci_read_config_dword(cdev->pdev,
> > > +			      cdev->pdev->pcie_cap + PCI_EXP_DEVCTL2,
> > > +			      &pci_status_control);
> > > +
> > > +	if (pci_status_control & PCI_EXP_DEVCTL2_LTR_EN)
> > > +		SET_FIELD(dev->dev_caps,
> QED_RDMA_DEV_CAP_ATOMIC_OP, 1);
> >
> > I don't understand this.
> >
> >   1) PCI_EXP_DEVCTL2 is a 16-bit register ("word"), not a 32-bit one
> >   ("dword").
> >
> >   2) QED_RDMA_DEV_CAP_ATOMIC_OP is set here but is not read
> anywhere
> >   in this patch.  Is it used by the qed device itself?
> >
> >   3) PCI_EXP_DEVCTL2_LTR_EN is for Latency Tolerance Reporting and is
> >   not related to atomic ops.  I don't know what
> >   QED_RDMA_DEV_CAP_ATOMIC_OP means, but possibly one of these
> was
> >   intended instead?
> >
> >     - PCI_EXP_DEVCAP2_ATOMIC_COMP32 means the device supports 32-
> bit
> >       AtomicOps as a completer.
> >     - PCI_EXP_DEVCAP2_ATOMIC_COMP64 means the device supports 64-
> bit
> >       AtomicOps as a completer.
> >     - PCI_EXP_DEVCAP2_ATOMIC_COMP128 means the device supports
> 128-bit
> >       AtomicOps as a completer.
> >     - PCI_EXP_DEVCTL2_ATOMIC_REQ means the device is allowed to
> >       initiate AtomicOps.
> >
> > (This code is now in qed_rdma.c)

Thanks for looking into this.=20
This seems like redundant code and left-overs for supporting the atomic ope=
ration verb.
Atomic support is handled by: qedr_pci_set_atomic and introduced with a pro=
per implementation by commit-SHA 20c3ff6114b0c

This code in qed_rdma.c can safely be removed.
Thanks,
Michal
