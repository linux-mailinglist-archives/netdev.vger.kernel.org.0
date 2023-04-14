Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E25F6E1CB1
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 08:32:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbjDNGcq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 02:32:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbjDNGcp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 02:32:45 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22A1B9B
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 23:32:44 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33E3K76n013721;
        Thu, 13 Apr 2023 23:32:31 -0700
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2042.outbound.protection.outlook.com [104.47.57.42])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3pxxu88q8s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Apr 2023 23:32:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B5ggBpdSiHoWTqovC1eDmNkFRsBwXvEWKjZFFoXaxtW49C65us5CJ9DI2ucf+f6jDgpVOQvhRbVYa8BUJ5TqvnfXr22DaSZmGFeR0HHOlSUBE6whBimXaM/va9DmQtKFLZq8moEw4fjYm9GKhGqBUYQf0mwfT3zHyIEER7nSj6Y6j336n7DRBt89jxX+6MoNH4msmnKvfk5IrpEnNu77W2rT2UYOUWseoRBF0G2eZxEf3VGcaKCdyWAzTErTZR/jhJKxGrfmv2h0HX5X4iaRExXw3danRuzBz6F50LrvUo11hzhiy3mpfPGUDU1kMyPw+2Vd1phFSzcNyZtj8bmnbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VEkZLVYXnG0v/jhc5D4VSfQO4mDgp/ok5VRo4UbHR0o=;
 b=fQzmMpwCC9cMeTOLFCWg9bzPTrmlfnRpj+5b45kSVTZEaP5m5j+DSQXVZEycGokNzaV3lulesOGZ2LW4xqNKwlPnaiy/1mgbOExZNODzJFts1T6vpW/Uml1u5MS+K2Pudd+gHxaRMmOYN/EqDltOhSASq979p8J6pk140CAJ669CB/qit47H/t7Tp+V2md2YKynw6oRyuTE845CWLwStQlW6R/CH4Q8nMfzroZyVNCiBKyPqSOyUqac22KyEtEF8yuQI557ResHv0mXMI5nPhLaIep5a+2JjE/jTh0AGrkW0VTsDo8bRGOrE/qpLhOQbFffFqw/Eiq0WCgB2tgNV3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VEkZLVYXnG0v/jhc5D4VSfQO4mDgp/ok5VRo4UbHR0o=;
 b=TYxM3OuC0ziGtLBP+kaApSeOjqCkgg3G1Qf0hVoPgZOLXRfMCngI3Nqn0QBsmelbYcAgUNyJLEwK0VpbV3S/LtaJA0tijKi+ZlxAWX4fBw2rFTzo2Tjy+txaVsTpDO70z5AdX/aq3wuYYwHSdboDSaxcgE5aMH7tkJhfBCMIF6U=
Received: from CO1PR18MB4666.namprd18.prod.outlook.com (2603:10b6:303:e5::24)
 by BN6PR18MB1282.namprd18.prod.outlook.com (2603:10b6:404:e8::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Fri, 14 Apr
 2023 06:32:28 +0000
Received: from CO1PR18MB4666.namprd18.prod.outlook.com
 ([fe80::ead5:44bc:52e0:bf88]) by CO1PR18MB4666.namprd18.prod.outlook.com
 ([fe80::ead5:44bc:52e0:bf88%6]) with mapi id 15.20.6298.030; Fri, 14 Apr 2023
 06:32:28 +0000
From:   Subbaraya Sundeep Bhatta <sbhatta@marvell.com>
To:     "ehakim@nvidia.com" <ehakim@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "sd@queasysnail.net" <sd@queasysnail.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "leon@kernel.org" <leon@kernel.org>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Naveen Mamindlapalli <naveenm@marvell.com>
Subject: RE: [PATCH net-next v5 5/5] macsec: Don't rely solely on the dst MAC
 address to identify destination MACsec device
Thread-Topic: [PATCH net-next v5 5/5] macsec: Don't rely solely on the dst MAC
 address to identify destination MACsec device
Thread-Index: AQHZbpanPkt7PvMy10aOTW/zQoAOSq8qWJVw
Date:   Fri, 14 Apr 2023 06:32:28 +0000
Message-ID: <CO1PR18MB4666A6E343DBB5A1CCD005D4A1999@CO1PR18MB4666.namprd18.prod.outlook.com>
References: <20230413105622.32697-6-ehakim@nvidia.com>
In-Reply-To: <20230413105622.32697-6-ehakim@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-rorf: true
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcc2JoYXR0YVxh?=
 =?us-ascii?Q?cHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJh?=
 =?us-ascii?Q?MjllMzViXG1zZ3NcbXNnLTFmMDk5MGMzLWRhOGUtMTFlZC05YzU5LWJjZjE3?=
 =?us-ascii?Q?MTIxOGI3YVxhbWUtdGVzdFwxZjA5OTBjNS1kYThlLTExZWQtOWM1OS1iY2Yx?=
 =?us-ascii?Q?NzEyMThiN2Fib2R5LnR4dCIgc3o9IjM2NjIiIHQ9IjEzMzI1OTI3NTQ2OTQ0?=
 =?us-ascii?Q?MjQ2MCIgaD0iRFEwdEtvQTF6bWFKbmRDSXRCKzRUaTRRc3M0PSIgaWQ9IiIg?=
 =?us-ascii?Q?Ymw9IjAiIGJvPSIxIiBjaT0iY0FBQUFFUkhVMVJTUlVGTkNnVUFBSFlJQUFD?=
 =?us-ascii?Q?Y3pXSGhtbTdaQWRjSm15REFvRHJRMXdtYklNQ2dPdEFOQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUhBQUFBQUdDQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUVBQVFBQkFBQUExRkgzYUFBQUFBQUFBQUFBQUFBQUFKNEFBQUJoQUdRQVpB?=
 =?us-ascii?Q?QnlBR1VBY3dCekFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?RUFBQUFBQUFBQUFnQUFBQUFBbmdBQUFHTUFkUUJ6QUhRQWJ3QnRBRjhBY0FC?=
 =?us-ascii?Q?bEFISUFjd0J2QUc0QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQVFBQUFBQUFBQUFDQUFB?=
 =?us-ascii?Q?QUFBQ2VBQUFBWXdCMUFITUFkQUJ2QUcwQVh3QndBR2dBYndCdUFHVUFiZ0Ix?=
 =?us-ascii?Q?QUcwQVlnQmxBSElBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUJBQUFBQUFBQUFBSUFBQUFBQUo0QUFBQmpBSFVB?=
 =?us-ascii?Q?Y3dCMEFHOEFiUUJmQUhNQWN3QnVBRjhBWkFCaEFITUFhQUJmQUhZQU1BQXlB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-refone: =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFFQUFBQUFBQUFBQWdBQUFBQUFuZ0FBQUdN?=
 =?us-ascii?Q?QWRRQnpBSFFBYndCdEFGOEFjd0J6QUc0QVh3QnJBR1VBZVFCM0FHOEFjZ0Jr?=
 =?us-ascii?Q?QUhNQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBUUFBQUFBQUFBQUNBQUFBQUFDZUFBQUFZd0IxQUhNQWRBQnZBRzBB?=
 =?us-ascii?Q?WHdCekFITUFiZ0JmQUc0QWJ3QmtBR1VBYkFCcEFHMEFhUUIwQUdVQWNnQmZB?=
 =?us-ascii?Q?SFlBTUFBeUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQkFBQUFBQUFB?=
 =?us-ascii?Q?QUFJQUFBQUFBSjRBQUFCakFIVUFjd0IwQUc4QWJRQmZBSE1BY3dCdUFGOEFj?=
 =?us-ascii?Q?d0J3QUdFQVl3QmxBRjhBZGdBd0FESUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
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
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-reftwo: =?us-ascii?Q?QUFBQUFBQUFBQUFCQUFBQUFBQUFBQUlBQUFBQUFKNEFBQUJrQUd3QWNBQmZB?=
 =?us-ascii?Q?SFFBWlFCaEFHMEFjd0JmQUc4QWJnQmxBR1FBY2dCcEFIWUFaUUJmQUdZQWFR?=
 =?us-ascii?Q?QnNBR1VBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBRUFB?=
 =?us-ascii?Q?QUFBQUFBQUFnQUFBQUFBbmdBQUFHVUFiUUJoQUdrQWJBQmZBR0VBWkFCa0FI?=
 =?us-ascii?Q?SUFaUUJ6QUhNQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFDd0FBQUFBQUFBQUFBQUFBQVFBQUFBQUFBQUFDQUFBQUFB?=
 =?us-ascii?Q?Q2VBQUFBYlFCaEFISUFkZ0JsQUd3QWJBQmZBSEFBY2dCdkFHb0FaUUJqQUhR?=
 =?us-ascii?Q?QVh3QmpBRzhBWkFCbEFITUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUJBQUFBQUFBQUFBSUFBQUFBQUo0QUFBQnRBR0VBY2dC?=
 =?us-ascii?Q?MkFHVUFiQUJzQUY4QWRBQmxBSElBYlFCcEFHNEFkUUJ6QUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFF?=
 =?us-ascii?Q?QUFBQUFBQUFBQWdBQUFBQUEiLz48L21ldGE+?=
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO1PR18MB4666:EE_|BN6PR18MB1282:EE_
x-ms-office365-filtering-correlation-id: 28452918-a189-48a4-35d4-08db3cb204ce
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HxAH++U7l1TW2ZYy+BeStb7Uk8SEp/0f2g5RWRkqbLSyU9a7MwjigR3OHa7m84tBUXTz7PrZFmYAGoKNqn7YxOb+aw1Kvhv44OH+cDAqR5U5mmrKMoq2J3ozFYNXSTEkhGwAaaxS5w6IoUujPffJ22fB9DO9uWiKsZ85HD6eP9HYk/hn7aTvG4djLEzQ5mj6sF6VhkJ+2ATtLY5NdYFnEmwokpkRvW6in7PJDHGD5HUWTgfNKJTB8dtLyqGJFfagCz0E/Nx4XYpA3pqAK0LXgYRhRG86Y6FgovTqV0t8plMT045G+GMy1lJpJn35K47ARHahLR/bF5v3VYgMw2arvMgfJ+R3qk7xoILVAhG2eW9EEzlVS5GbaZY/ZgrPuZqzzGkaz1SblhKYIOi+s7NkYlCFLUXv72gWq3HrPVMzObqj2q7xCn5yZho1cY3+rFfQbhLku4I8f1t8Ri2S5JeeVAiRtPVAf+UKaIURGjxgpB8ZwnBtmrI0tg+vnhw58TqFVj3zNvvlh8KedbnrHNzyaEx4Z3QhmA72VLDiw7l1k7i9g6TNTrvRKF0xVf/SbLvvrt8+Hw3t4hbXIgzsCulhWdLf3pahAYXj6dviV2Jekg8G5ngn+KZA0KgN2eK90pQf
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR18MB4666.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(396003)(39860400002)(376002)(346002)(136003)(451199021)(38100700002)(107886003)(478600001)(83380400001)(110136005)(122000001)(316002)(9686003)(26005)(6506007)(55016003)(186003)(7696005)(33656002)(71200400001)(41300700001)(8676002)(8936002)(66946007)(4326008)(66446008)(66556008)(64756008)(66476007)(76116006)(38070700005)(2906002)(54906003)(86362001)(52536014)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ua3i+8MqXduE5GJIl3ckNXzfkt/Ssi1C1zei5b7u7LEUBiu7ILa39Sn0f3xQ?=
 =?us-ascii?Q?JOPW585XyIDnOee06SMt1TsTAgbqNEsK4oE363mgF3ShOUkhcI2FS2G2wzG5?=
 =?us-ascii?Q?zwoPudRHAjADdkgsyGi8+StzfkNUc0tiKxwYGbmLFyRONjkGHusODk31RmwN?=
 =?us-ascii?Q?USRt68GeLf4dBF3uJddx1eiSrkQ1FSm/CArC8sNDj4Kx6ob6geNHFWsL32Jf?=
 =?us-ascii?Q?BuG0iHNjpeS5KqTnVus/D6UfpyIuGCQ2ftn7VF1PTW+mEJA8cNvRT6qqVgrV?=
 =?us-ascii?Q?hrOF477sownSEcd9l2lQ+gYv+m7/YRm85FK26eqDIE61IrA6EXT6gv+4FFGb?=
 =?us-ascii?Q?RlXnyZTnmfiuWw90lEkAq87mGsl8DbXMyK+Bbwa1mq12hEK5p8+NC9pvNupm?=
 =?us-ascii?Q?5nqzRO1S33KQ1VI1anX4DyjzsFOCXb0rcUNNaL6hyPs2l4mSqEm0XKYMnPxN?=
 =?us-ascii?Q?fC8H8P/YbDyLeUa5M3n6yJOni6Regr4HAZz/vmLbShC+DaH+W4gA+baMqZr/?=
 =?us-ascii?Q?WP8IZT9nm/kxNKZNA02CeexhLGZoAPvoJvcyrzglPVFaZCnT7J4YzgdD5wis?=
 =?us-ascii?Q?zy8NyKpCF3OequKGbrJXq3pPmZVfianL5hohG8pCNbHuU/byN0CNBOIrtoax?=
 =?us-ascii?Q?BljmWWPizZsfRO1jvHoeVKiHJRN8fy3t4TOlLxAv+pXDDoGhH4ViCvOY4Ixc?=
 =?us-ascii?Q?ImRtUTeyKO61vIwX/dds7AxhC0jEa9br/c+Hob84vCbJ/XIui8gIV8xGA/nf?=
 =?us-ascii?Q?C/MVrc2R9F7fip6f2zpVb8UwStndM/qIizgerxvDAKy5TMrGGE+MhSctceMv?=
 =?us-ascii?Q?UynvtAXqkel3YO0jWLZpLepNXadVUMV9hiVjOz7j2okCtj1gd4VnAbMqp/y3?=
 =?us-ascii?Q?vxurc4vcld3W1HzU0JQPBTRQjqW3HZZBHnLV0TFPRrFBsJZfD8d93Zf93Ezt?=
 =?us-ascii?Q?punpn4Sv1FQZnX3TuEgQpm0EyoNWCwBJ6pCXpKpk9UzOUKhc8DBxcueDG1QN?=
 =?us-ascii?Q?O+qCZwL+yyYSfodFEonFX0or5Wi4KrYuZFfIYag47vQ5tv4xn4mls44/ICTU?=
 =?us-ascii?Q?1L2AFVGhKu60DmTIpMWZDdxy33+o/+4Mzy/SQWPKr22H0zmo/7akfdoeDAWM?=
 =?us-ascii?Q?f90c8FrXO6U1g762r9h8PmA2mAoYJUndo/zX4sYOekhjSj4YaUH1/Nc7J5Rl?=
 =?us-ascii?Q?S2FITcM3yyv1tDk/4rxgZlO1q94809l1DX1fV8PEaxg8CriLX13C3oIyVQMC?=
 =?us-ascii?Q?NlwDbPadb33i/Y5R/DHaMGvWUyqPQG0tHWfeJmqrvGSnGvHy6vq+kK4fAKtR?=
 =?us-ascii?Q?783zW3izVWNT4RnoCJZPFi/f6AgpOhI/lB7L2ZuA3bWK8Xwl9iMQd0pzznYT?=
 =?us-ascii?Q?46HG0W+UGl0oh96wk5ageF0zzLzG4cyDHajSOK+eS3F9l1XGh4eNRX/+/wvD?=
 =?us-ascii?Q?j5MmKL6prEpyfSwB/UtrfE1jcaD6clG7WUoQAQg1xwfR4C5a8cwK74Qzs7j9?=
 =?us-ascii?Q?QbUuijzDPnDtn+9izp8i65MGVFUl470Aki923/ibxHYAZlsvsd8f1W/k7zm4?=
 =?us-ascii?Q?HU4hlAtTqdU0fGEv1JrZgTaicigywCiV9iop2mV/?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR18MB4666.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28452918-a189-48a4-35d4-08db3cb204ce
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Apr 2023 06:32:28.5372
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2Y4McPmN7mbPQFBE0iYUdPoFDOKHt568w5ezqRRDezBDpNNZwJgyfDiXDbKXTWY4VWspFCYZorXYtsis0HLSmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR18MB1282
X-Proofpoint-ORIG-GUID: _xmkaek7VskFjoHw_WZubs7-UJnRrKGB
X-Proofpoint-GUID: _xmkaek7VskFjoHw_WZubs7-UJnRrKGB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-14_02,2023-04-13_01,2023-02-09_01
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,PDS_BTC_ID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

>-----Original Message-----
>From: Emeel Hakim <ehakim@nvidia.com> <ehakim@nvidia.com>
>Sent: Thursday, April 13, 2023 4:26 PM
>To: davem@davemloft.net; kuba@kernel.org; pabeni@redhat.com;
>edumazet@google.com; sd@queasysnail.net
>Cc: netdev@vger.kernel.org; leon@kernel.org; Emeel Hakim
><ehakim@nvidia.com>
>Subject: [PATCH net-next v5 5/5] macsec: Don't rely solely on the dst MAC
>address to identify destination MACsec device
>
>Offloading device drivers will mark offloaded MACsec SKBs with the
>corresponding SCI in the skb_metadata_dst so the macsec rx handler will kn=
ow to
>which interface to divert those skbs, in case of a marked skb and a mismat=
ch on
>the dst MAC address, divert the skb to the macsec net_device where the mac=
sec
>rx_handler will be called to consider cases where relying solely on the ds=
t MAC
>address is insufficient.
>
>One such instance is when using MACsec with a VLAN as an inner header, whe=
re
>the packet structure is ETHERNET | SECTAG | VLAN.
>In such a scenario, the dst MAC address in the ethernet header will corres=
pond to
>the VLAN MAC address, resulting in a mismatch.
>

I did below commands:
ifconfig eth2 up
ip link add link eth2 macsec0 type macsec sci cacbcd4142430002
ifconfig macsec0 hw ether ca:cb:cd:41:42:43
ip macsec offload macsec0 mac
ifconfig macsec0 up
ip macsec add macsec0 tx sa 0 on pn 5 key 02 222222222222222222222222222222=
22
ip macsec add macsec0 rx sci cacbcd2122230001
ip macsec add macsec0 rx sci cacbcd2122230001 sa 0 pn 5 on key 01 111111111=
11111111111111111111111
ip link add link macsec0 vlan0 type vlan id 2

ifconfig vlan0 hw ether ca:cb:cd:21:22:23
ifconfig vlan0 up
[ 7106.072451] device macsec0 entered promiscuous mode
[ 7106.077330] device eth2 entered promiscuous mode

macsec0 entered promisc mode when upper_dev mac address is not equal to its=
 mac.
I think we should check if macsec device is in promisc mode instead of omit=
ting mac address compare.
Also all drivers/hardware do not support md_dst->type =3D=3D METADATA_MACSE=
C hence if macsec is
offloaded and in promisc mode then go for another round.
Correct me if I am wrong.

Thanks,
Sundeep

>Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
>---
> drivers/net/macsec.c | 13 +++++++++++--
> 1 file changed, 11 insertions(+), 2 deletions(-)
>
>diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c index
>25616247d7a5..c19a45dc6977 100644
>--- a/drivers/net/macsec.c
>+++ b/drivers/net/macsec.c
>@@ -1021,8 +1021,11 @@ static enum rx_handler_result
>handle_not_macsec(struct sk_buff *skb)
> 		 * the SecTAG, so we have to deduce which port to deliver to.
> 		 */
> 		if (macsec_is_offloaded(macsec) && netif_running(ndev)) {
>-			if (md_dst && md_dst->type =3D=3D METADATA_MACSEC &&
>-			    (!find_rx_sc(&macsec->secy, md_dst-
>>u.macsec_info.sci)))
>+			struct macsec_rx_sc *rx_sc =3D (md_dst && md_dst->type
>=3D=3D METADATA_MACSEC) ?
>+						     find_rx_sc(&macsec->secy,
>+								md_dst-
>>u.macsec_info.sci) : NULL;
>+
>+			if (md_dst && md_dst->type =3D=3D METADATA_MACSEC &&
>!rx_sc)
> 				continue;
>
> 			if (ether_addr_equal_64bits(hdr->h_dest,
>@@ -1047,7 +1050,13 @@ static enum rx_handler_result
>handle_not_macsec(struct sk_buff *skb)
> 					nskb->pkt_type =3D PACKET_MULTICAST;
>
> 				__netif_rx(nskb);
>+			} else if (rx_sc) {
>+				skb->dev =3D ndev;
>+				skb->pkt_type =3D PACKET_HOST;
>+				ret =3D RX_HANDLER_ANOTHER;
>+				goto out;
> 			}
>+
> 			continue;
> 		}
>
>--
>2.21.3
>

