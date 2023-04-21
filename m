Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34E5B6EA365
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 07:54:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231394AbjDUFyi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 01:54:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230151AbjDUFyg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 01:54:36 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C57BE269A
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 22:54:35 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33L32sV8007982;
        Thu, 20 Apr 2023 22:54:26 -0700
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3q3djpjcxm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Apr 2023 22:54:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JDxZD1rJgy3GdVHTujrLuH+wszGYhfB3ASZ3jf47qlQX4CbiTgeEbr2jeVqClu7Z9bRJV8H/TRIvygehQNjnK4OOKXRHWuXxDc842LJgS99XlnmVP/f2owU3m9qULVNgMaJOX8iGj5HBQptzl6Yy6NOUTct7yoceXn98QEJOx57UdNlboESgrw7HZjaHKshmTEGnMh3JYI1m1DOFeNUhpgxihtZVAb+MeB+qyMcmNjmeYjh/0VvxdLm1zHF465OoAeNQa+goT/gvaZAttDU+vfjbSAfN3e3o3XdUTFOy0o0PjuxFWE7mNb3iyMs+/69b2koZbGzb886sG961CK0AWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Sr193SFAyvmdcitIDp7cEN1hcpbONUA9d0d4Jg4SrRA=;
 b=fDeEFrOX69NCzsMXqSKQpMFP/cRdcacnTxii5hbz7RW8DHVPLqOme1gZqgdO5lIOzh0wi+mnwTg1UeMXlWsm/LHyoqm54i6UwEgaqP/ykAqPKOXKDwbw5VHUts+Np27SpK7ezemCtr+MWj12urLRTN26ZS1VRVYq/twHFbzUSsVksr7pgUAa5msjRKnBZw+JGfHR6itWfdXLBqh2SOSP16LlCA4PSSNNvQKFQh3sciefIaawUA4pVMEoMvFNG2/Tk5iZsLM/ugA1t1iNykmeXDr9wrvaID1V2fL+gV/UG44DLSz1WEdSB/5roEJG8BBdKesSoziV4y65rCwe1z/MFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sr193SFAyvmdcitIDp7cEN1hcpbONUA9d0d4Jg4SrRA=;
 b=giFRGZR5sy5GaSb1ZAxZpov9hcFRMP2CNB6mR0n52PLrgdoGD9Kx6mACW9iftPVDts5BNeXasaqOFX7haH1uSVZ1T4P28ZLNsY263TduFtrTPGfdqi07b+OzaPzs+d24chvmjlKNUjpDRh5QJjWPLHa/6EtfW7y2b+4xiCbwmNM=
Received: from CO1PR18MB4666.namprd18.prod.outlook.com (2603:10b6:303:e5::24)
 by CY4PR18MB1175.namprd18.prod.outlook.com (2603:10b6:903:10f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Fri, 21 Apr
 2023 05:54:23 +0000
Received: from CO1PR18MB4666.namprd18.prod.outlook.com
 ([fe80::ead5:44bc:52e0:bf88]) by CO1PR18MB4666.namprd18.prod.outlook.com
 ([fe80::ead5:44bc:52e0:bf88%5]) with mapi id 15.20.6319.022; Fri, 21 Apr 2023
 05:54:23 +0000
From:   Subbaraya Sundeep Bhatta <sbhatta@marvell.com>
To:     "ehakim@nvidia.com" <ehakim@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "sd@queasysnail.net" <sd@queasysnail.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "leon@kernel.org" <leon@kernel.org>
Subject: RE: [PATCH net-next v7 4/5] net/mlx5: Consider VLAN interface in
 MACsec TX steering rules
Thread-Topic: [PATCH net-next v7 4/5] net/mlx5: Consider VLAN interface in
 MACsec TX steering rules
Thread-Index: AQHZdBSpNo6EfjFuk0S1Sr/zTcjq8a81Q0ew
Date:   Fri, 21 Apr 2023 05:54:23 +0000
Message-ID: <CO1PR18MB4666FA3302F0BEB51D7B23EFA1609@CO1PR18MB4666.namprd18.prod.outlook.com>
References: <20230419142126.9788-5-ehakim@nvidia.com>
In-Reply-To: <20230419142126.9788-5-ehakim@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-rorf: true
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcc2JoYXR0YVxh?=
 =?us-ascii?Q?cHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJh?=
 =?us-ascii?Q?MjllMzViXG1zZ3NcbXNnLWY1YWMzZTk4LWUwMDgtMTFlZC05YzU5LWJjZjE3?=
 =?us-ascii?Q?MTIxOGI3YVxhbWUtdGVzdFxmNWFjM2U5YS1lMDA4LTExZWQtOWM1OS1iY2Yx?=
 =?us-ascii?Q?NzEyMThiN2Fib2R5LnR4dCIgc3o9IjEyODkiIHQ9IjEzMzI2NTMwMDYxNDU3?=
 =?us-ascii?Q?NzgwNiIgaD0iS3hEOEdpS29RM3UvaTdRd0RqNnlMN0tIdWFrPSIgaWQ9IiIg?=
 =?us-ascii?Q?Ymw9IjAiIGJvPSIxIiBjaT0iY0FBQUFFUkhVMVJTUlVGTkNnVUFBSFlJQUFD?=
 =?us-ascii?Q?T2ZnUzRGWFRaQWZRWENobXlrbjk4OUJjS0diS1NmM3dOQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUhBQUFBQUdDQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUVBQVFBQkFBQUFvOWlqZlFBQUFBQUFBQUFBQUFBQUFKNEFBQUJoQUdRQVpB?=
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
 =?us-ascii?Q?QUFBQUFBQUFBQUFEQUFBQUFBQUFBQUFBQUFBQVFBQUFBQUFBQUFDQUFBQUFB?=
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
x-ms-traffictypediagnostic: CO1PR18MB4666:EE_|CY4PR18MB1175:EE_
x-ms-office365-filtering-correlation-id: 88a2c564-26d5-4394-5689-08db422cdbed
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: x+6jqOgqriSGbJAgqm7WjcGBOdTCjvBg9tNM5Z85sbn9oLM5tIdNZ4x7uG/JaNk64jUh2KSYJsPsCvFc7tKJQyj4IbDVh6wRq5nPaoVKVg3inlPKFTzstcHByO9pBW7D0QpPrwK/EGErpa67Uq5Atqg5t4c1OABfR7VgJasDKQmpYZHoG8HNQp0iUbhoA/XRnD6jq9Q+FnHu8WU2er4TAzwtENsiZjDuUZqX4E3wp0SjTQeCBf1rkDC+ArhuPWZ1c5zDYWXAJN7TAmfVBslTYIxdUYvAn+keypMqeoGepFhdxhJAkyrwGu/GfSlP93WF5x2FKBaBR8x0KH2Ld54iUOKhgXbAv6jXq56PTPOwYDTX9n22dIqSHoO7PAzT7un4fVsXRDkn7Tv6ybHtJSHyEBfVzAWOjB9KHdGp7zr7p/JEzxJx8f2TTB5HUW5h5WZN6//Wvg9dsSIHzGG/Buu/sdVczh7oagArh/B8xVyNHjcpaHWsKBt52RCt0ETws0CHDCmg8KDbVZSkBD5oI1kByYWAnWB04fUqVuF/fhbAgBCLfMpqNVwX8NH8gf1OOmbkQHgKFNz1+EIiie/349no2avYb68j3hBGJabOrAMTNr6ZJyYSvcuOF5vBt3qYwLLU
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR18MB4666.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(366004)(39860400002)(396003)(376002)(346002)(451199021)(478600001)(54906003)(52536014)(110136005)(8936002)(8676002)(38100700002)(5660300002)(2906002)(38070700005)(86362001)(33656002)(66446008)(66476007)(76116006)(4326008)(64756008)(55016003)(66946007)(316002)(66556008)(41300700001)(122000001)(9686003)(186003)(6506007)(83380400001)(7696005)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?kz8UctlJP+nzF3KMesREofuzIyICndaJZAcayNpbaeZqgSAIDz99MpF4xxp8?=
 =?us-ascii?Q?rInnWNwgVJOsbWsH/7CyUcV+K9xlV3wvwSZvZ203Mc5ApGfid2I5z9gcsrPp?=
 =?us-ascii?Q?bve+nPcF/1sccDF8p2E7TZzpg13tmjPDxlAwC1JUVNR4ZT0dHr6s8kOAv62Q?=
 =?us-ascii?Q?Zy00qEQWQUJPhLdCw2nt3z4zfL2+AS9/anCli32+Ez2tS0u3FKRcae7ruDsb?=
 =?us-ascii?Q?NHaG5CT8du68AXRFr8CPPHiqtUCA2GlX8xwpJZcTm2aMBe1dGnjZMCmsUd4v?=
 =?us-ascii?Q?iU8blb9t4YL3aka/JbaEKtkJ4ifTVsJ+VOn15P4PkyGBEbHTh+DyEeuzOwES?=
 =?us-ascii?Q?te8nnljjXKvhBZ5WXWfB4wI4CKT8Di6ZfKjwQFIaeFAMDcxZuOqucivgmKBT?=
 =?us-ascii?Q?SuKsSmSlaFC/6zncI1AnEJk2CMRgqb8DYRyxPVBWTWcSutV4XV8NisgSRRbq?=
 =?us-ascii?Q?KuaoQTFD/3UTF/t6O7eH132CaPYCnUh73d8BvODf7QrjgQCqqUJEivEa8K6S?=
 =?us-ascii?Q?lTYlAlhYkdF7OfAEsNzl6DZVc3g4ghdsOMxEiTCa5YfQoc/VbvdS76t7KKq1?=
 =?us-ascii?Q?plQcitF9OylCDoeHCJeqN4r5ldRtEA+JFCq7lDrpIdvnkRm+odXNkIVFR5sS?=
 =?us-ascii?Q?k2IwtRK+yW2S8c8JYXpbntTKrzDQl4uce/e9Kk4pih68awXguYP1VnrUAufz?=
 =?us-ascii?Q?3lNB4kOl/y5RQk6sVucdZWPyNy4QkrB1WnPyhKuOpF2lA5nmWfj7ezO2HjDr?=
 =?us-ascii?Q?r8JJTX/2ge1oHY0r6moMG7+PHxX2o9TB/wXNJkKDeP7sj1pnXFMQQPW+4XIU?=
 =?us-ascii?Q?h/VL3/7j0rVj8hpo0bbFD/YWGc4P1X2CUCTgxA8he4VweHWyOpNIDdLkfXxL?=
 =?us-ascii?Q?wj3jAx9WzQ7ziPZMR3L6RXBOHC1+6cHq0XpPnegUZJqXjy9ZWaAqjeZoL1X7?=
 =?us-ascii?Q?UYMSnQ4naqAwiBrjNpPyKZsj4Tme+dojUatZ5ja16nY93xGiVQsTSrRZkgg2?=
 =?us-ascii?Q?3gwX4LTIvWlvsbTixexXc/tWBugZQMKSfSSWfZd0R8cXWlgxutdYkVam6Rk2?=
 =?us-ascii?Q?g7o4QRfa7ouQZTcpmFbV3nTJDM1p/oug3x2GC6G7IUCdDPKcWcu5KEuvCGEA?=
 =?us-ascii?Q?KZi/U+xBWqfSQUCT3IAJafQ69vuz+e/2M7nYYL+iO+uMrcMyMmOtUyrB5VOy?=
 =?us-ascii?Q?i/zO2lFVp5z7Tbg41EIMkiBhL3nHfjejfQ+8JjFVbt/NzmrlghOivryyBx35?=
 =?us-ascii?Q?kXd4GaZRdFak7UH1jnL8gHSE2J6vtzPEZMV+SzoyNMNK/zCXnVBS/rExErlp?=
 =?us-ascii?Q?C4jDDpTIhn4nbdNTgPJwr+bMzneWcq0vJCz9Ax4LgYfOwpTRgszqet9bQBS6?=
 =?us-ascii?Q?RcOVftUCLR4ULkx3v8+5PUHbaOQt+Rc76oVvYg+cqofu0gGbOm4fuK4tKYrk?=
 =?us-ascii?Q?8o2eb9viYcDXp/s4HUrgYcAK8elsxwomtojUxz9K1qprWNgGA+jKz7euUDni?=
 =?us-ascii?Q?Yg/WOTYTS6vGKqOG0ctBUeFYnxcZPXKTXYGldiVvSXyGQJ5TjxMLKlfycMVn?=
 =?us-ascii?Q?bxYtKpXzpOcL0KC5FaYRJcCzBW/2lyUdbxcuY3l/SenkGaIXAGrT89CC9tUQ?=
 =?us-ascii?Q?O4uBTZV8ULrvbSmQpfrW2vYqs82pWGzZJmfbfKnSSqdF?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR18MB4666.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88a2c564-26d5-4394-5689-08db422cdbed
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Apr 2023 05:54:23.8231
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nZWe00SEyUlKZt4Ru/4i2RbFLMBIsNZfCaGntkQ5L3wZIOz/GpCGWrcXed/Q9Ka7lt5ixewqgaA5i6/rYEAzmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR18MB1175
X-Proofpoint-GUID: QfuU2IO9OjpVPE1QTM72Yh2VPT8R9Ywc
X-Proofpoint-ORIG-GUID: QfuU2IO9OjpVPE1QTM72Yh2VPT8R9Ywc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-20_17,2023-04-20_01,2023-02-09_01
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



>-----Original Message-----
>From: Emeel Hakim <ehakim@nvidia.com> <ehakim@nvidia.com>
>Sent: Wednesday, April 19, 2023 7:51 PM
>To: davem@davemloft.net; kuba@kernel.org; pabeni@redhat.com;
>edumazet@google.com; sd@queasysnail.net
>Cc: netdev@vger.kernel.org; leon@kernel.org; Emeel Hakim
><ehakim@nvidia.com>
>Subject: [PATCH net-next v7 4/5] net/mlx5: Consider VLAN interface in
>MACsec TX steering rules
>
>Offloading MACsec when its configured over VLAN with current MACsec TX
>steering rules will wrongly insert MACsec sec tag after inserting the VLAN
>header leading to a ETHERNET | SECTAG | VLAN packet when ETHERNET |
>VLAN | SECTAG is configured.
>
>The above issue is due to adding the SECTAG by HW which is a later stage
>compared to the VLAN header insertion stage.
>
>Detect such a case and adjust TX steering rules to insert the SECTAG in th=
e
>correct place by using reformat_param_0 field in the packet reformat to
>indicate the offset of SECTAG from end of the MAC header to account for
>VLANs in granularity of 4Bytes.
>
>Signed-off-by: Emeel Hakim <ehakim@nvidia.com>

Reviewed-by: Subbaraya Sundeep <sbhatta@marvell.com>
