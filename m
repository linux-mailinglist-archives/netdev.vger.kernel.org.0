Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B247C6CF1A4
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 20:03:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbjC2SDl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 14:03:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229909AbjC2SDj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 14:03:39 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 681774C0D;
        Wed, 29 Mar 2023 11:03:29 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32TDTR10008928;
        Wed, 29 Mar 2023 11:03:13 -0700
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3pmdqhm22h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Mar 2023 11:03:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PNpAof1dIfG39uZEaWH7m0g72PjMjURuOc47QkA5X/fXhun0cqvOKxDYwY9GkEonneRutbHNkORZeLRLJrh3ZJaYAetR1Pk19i1e8HKkTKwxDEb4pYGboP28mmM7gqnR9lg/KMbxavQ4B+zM1AoKkx5cM50LjaxePcCpTYMrTmgqMN5c8sSUhlA2PSsdoVx9AxzUfDGPr4LP44HrZzg5xCW2QH0+qciPfu1dw/mlxcFrSrmedfcl1epoy9g+y+K7qq+bqTZrHLPAeu/gMXq7yhVimn9CNs5b9m75a3MGFKu3yxrUi7DmFlU8KR9Yi0mQs84nroXgyH+tNNB8O5AVMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H1UYMogB/IUZpaBEV0iGLZ842NpbqcsddFs+TH2MN6o=;
 b=Hc5hiYtmPedGN3hToLNH2flbAEIRc/S3sMfr9bynkrQydvQZ/mve8PlPAHlwH78oQaPOyLFb1Ru+IyV43nObuXPCVFUUIA+IEqW5SEr3M5u3NB/zT3HjTPoELO+eU+pCn260+0MFunYlrVW8GIr9+6uPm8eorgs2kaVptcMVfGphzTB7QU6BQbx9iSZ9lryvlxXOwqj91jHUFHuBcqFzwqPLFXu1Kkq8cOZb/g472mTD0tv2no/Elw3MAdbXW5uPUg/poWpx/nuWa+Pb4Rn/6rZb63Sv5a6xSxQV27WFFKIgszVKXMggXKNoQhAh+LJrh+0eyz1lFUkdz+sTSluVVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H1UYMogB/IUZpaBEV0iGLZ842NpbqcsddFs+TH2MN6o=;
 b=OG7oyMXPmbKgg+g9GMbBiwrQG2e2SCqCAjAlaI4RWhUHbh2MgjkYs2Fd94Mvju5HQCWaAThpn8H4fC6mawq5YGWyQGNXNNi2iWd5ApOr2mXUdFcSnHuWCHRI0yjDIgEvJOaxeI98DCA05FpAUOnremDrQcJ5MBhQ7TLRecHWln8=
Received: from PH0PR18MB4474.namprd18.prod.outlook.com (2603:10b6:510:ea::22)
 by PH0PR18MB4799.namprd18.prod.outlook.com (2603:10b6:510:c3::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.33; Wed, 29 Mar
 2023 18:03:08 +0000
Received: from PH0PR18MB4474.namprd18.prod.outlook.com
 ([fe80::6968:a4c6:1f37:3ec0]) by PH0PR18MB4474.namprd18.prod.outlook.com
 ([fe80::6968:a4c6:1f37:3ec0%8]) with mapi id 15.20.6222.035; Wed, 29 Mar 2023
 18:03:08 +0000
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     Maxim Mikityanskiy <maxtram95@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "willemdebruijn.kernel@gmail.com" <willemdebruijn.kernel@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        Jerin Jacob Kollanukkaran <jerinj@marvell.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>,
        "naveenm@marvel.com" <naveenm@marvel.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>
Subject: Re: [net-next Patch v5 5/6] octeontx2-pf: Add support for HTB offload
Thread-Topic: [net-next Patch v5 5/6] octeontx2-pf: Add support for HTB
 offload
Thread-Index: AQHZYmi3xSBKWpq1IU2gGBddmWJuiQ==
Date:   Wed, 29 Mar 2023 18:03:08 +0000
Message-ID: <PH0PR18MB4474927B5C173ED2DAFD2C92DE899@PH0PR18MB4474.namprd18.prod.outlook.com>
References: <20230326181245.29149-1-hkelam@marvell.com>
 <20230326181245.29149-6-hkelam@marvell.com> <ZCM1Ld4VaUVfR1nV@mail.gmail.com>
In-Reply-To: <ZCM1Ld4VaUVfR1nV@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-rorf: true
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcaGtlbGFtXGFw?=
 =?us-ascii?Q?cGRhdGFccm9hbWluZ1wwOWQ4NDliNi0zMmQzLTRhNDAtODVlZS02Yjg0YmEy?=
 =?us-ascii?Q?OWUzNWJcbXNnc1xtc2ctZjJkNzJlNzgtY2U1Yi0xMWVkLWI2ZGUtZDQzYjA0?=
 =?us-ascii?Q?N2UyYmEwXGFtZS10ZXN0XGYyZDcyZTdhLWNlNWItMTFlZC1iNmRlLWQ0M2Iw?=
 =?us-ascii?Q?NDdlMmJhMGJvZHkudHh0IiBzej0iNzE4MTkiIHQ9IjEzMzI0NTg2NTg0MDEw?=
 =?us-ascii?Q?OTkyNiIgaD0iSy9LMlVNaVNxQXVCZmdHeUFmeGhidnpiRE1rPSIgaWQ9IiIg?=
 =?us-ascii?Q?Ymw9IjAiIGJvPSIxIiBjaT0iY0FBQUFFUkhVMVJTUlVGTkNnVUFBSFlJQUFC?=
 =?us-ascii?Q?bWFUQzFhR0xaQWIyTEcxMXZVTjZOdllzYlhXOVEzbzBOQUFBQUFBQUFBQUFB?=
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
 =?us-ascii?Q?QUFBQUFBQUFBQUFCQUFBQUFBQUFBQUFBQUFBQVFBQUFBQUFBQUFDQUFBQUFB?=
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
x-ms-traffictypediagnostic: PH0PR18MB4474:EE_|PH0PR18MB4799:EE_
x-ms-office365-filtering-correlation-id: a28e6673-a484-447a-efdf-08db307fda1c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZwCSXPAv0Z2YKHRRbTgKLuYlEL+i2BCmLFqmyd1+UwJBtQJ7Gczg2THMf7+N/qdqWZsXVaq12QwdYh9LVmhT5eKfPoOkks4UXAzKfUIiLB10yPZjZgwkzrqVexj6CJQx9UYK9xZOwpYqXZsDQX+JbgbuPc0bQOPaQC/2wnfeX7nPQxB13TTjSWlxVRJqNjGHudrtcEkTihxiB0w+E/aQZurQUpo4y26MU8h8ZahegepLH2dRfENBeUOMtZ4iAp9RIB1ouYQxC9vAkgrgh/itxhQZ15XgrUu9l1D4l0YlB0loAYKfBpxx3Q0ErC9WyKzfnHLAciLb5XYo28ygv5wrCSUP6YzhcTFFdU9hShcyVa2BH1pkJyJA9ribZCwVMsJ3oLj3hAZzVdulZDf62Mu3k6WATlfXb8SPfGOLNs3rjwiaIGMA2Dq1c+gXFYppuzSUUHyYNIWvRFgAqvmEuTM1xWvoBXpJG5a2Y+B00oxtsP62d9IBffmEYdeHeIo6UxI53Fk/wjIMQz69YJv9N/afH73dQjxYHibPYS9LRjZ/BQiYKfeScUZzj1WY2jZhW5EB94ZclEonDbF5X+7DO6oHW4L6A0ayQRWVeUDxU6iVu9NImeYGu7Wg/ZPxMXsOZAMr
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR18MB4474.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(366004)(376002)(39860400002)(396003)(346002)(451199021)(41300700001)(4326008)(66946007)(66476007)(66446008)(6916009)(8676002)(66556008)(8936002)(76116006)(186003)(38070700005)(2906002)(38100700002)(7416002)(86362001)(83380400001)(30864003)(122000001)(33656002)(5660300002)(55016003)(64756008)(478600001)(7696005)(54906003)(71200400001)(52536014)(6506007)(9686003)(316002)(26005)(579004)(559001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?r6R79I0l0Eymqf0YnUGKTjW85FiZy3hmZLkSwGLpRQPrpWT9SwxsrdzRWQWA?=
 =?us-ascii?Q?jcR4m7zLxSMNpClDv68bKOVL3djd/chKbYWeIAuHRQuiz2HXRamMTNHBWN6i?=
 =?us-ascii?Q?g/2c9CSz/aSZpfOzmmHtJhIdWjQsNX4q8zkv4kqIJd0hWmMXFAEUm58iyyOT?=
 =?us-ascii?Q?SX4qXp/4he3ryLsBjAaksiIc2SYhhhzxtPTwWD2CGfrfUPC7zbUblf7Sr9SM?=
 =?us-ascii?Q?jkaMtUXyTvFHn9TE84TR04UesQaRpl7WeZmC0GfEQRYpQvspj4oLVtEbCgDS?=
 =?us-ascii?Q?f8nL4EJzoxyFgzfniChP+yfhj3vbleadAG9XztuXEZkVdCpb98Ouvbo3qk2i?=
 =?us-ascii?Q?MWnbXY3tUNP4FvAKrJBH66IW3mdaSY+zPBP8jfTPNxj+se99A2r1EN0Pm7tK?=
 =?us-ascii?Q?A0QcYgGfJIhGgYBckEWNiIzFW2e3SWGK65+R+fmxP+jIDlfB9y0F9XuFHMSL?=
 =?us-ascii?Q?99hhJM/J1gJiJXWXZpdA84Iwtcd+byMWi9JE5ncA/qMqB+o+9/WJMVQfl9JT?=
 =?us-ascii?Q?zsI6EiY9QPWmc3vO4dP63qoiF34vHN+v0yLhmqp2RZ0ETt9FYJF+9Rwdzxhe?=
 =?us-ascii?Q?tksETvh0qOtKSHFEdYTEa/kDV0gAZaY+h0Avi8CQJ1GluvllknTpOPZ7588R?=
 =?us-ascii?Q?W/1gnmNwGxahO9LnC47yqJ83CR9EK3u+wdyRr1Gl9sTAWsKSdWERuL5j+GcV?=
 =?us-ascii?Q?wgeWof8dtBNgiz8/NTfDdKM8iIrZn2ghjLq0rSJP+mc+xInrnMJlqiYZy/bg?=
 =?us-ascii?Q?lqWgC2L51nP+JpCipT3tmJkkmGc7FQ+JN90Ll+Eog5QIeQhh0P+SKnvY1ZVJ?=
 =?us-ascii?Q?2YXAKfm/ClS9CYg3LI9Px9XKKXVcswdOPUiRmIsrrbDY10yo12IpIdiF++V0?=
 =?us-ascii?Q?9+IRuB8Xzh+4Q4Ve7+kC1aaRuG1wm0PmWIxXkf69XmG1ckAb8HsEAyT1BhnS?=
 =?us-ascii?Q?FJJGpVfn6vUuFxYO0AanjqvERX/BWKm937nfDadxDUVyQYkgWORMI0o6Sz+H?=
 =?us-ascii?Q?1TsZNBMLHOsl8Qf/sRGGT5nox9Ocoi7dZiiwVuKv3UUiIC1Q50FVhA6N2JGF?=
 =?us-ascii?Q?621vzMRIInqdcu8HDF6/hsmWW38FeHMKvtLeDF65jMOixC/wmpTofiXdg9c3?=
 =?us-ascii?Q?goim5hZVZhniqgGcc+V7samYEa8F+dAjPE9ZNEorTrdSsgH1rjMbpq1ti/I4?=
 =?us-ascii?Q?cMLO6AW4jaIjpcTXqqBTRzQeMjFrYOes9qmOLdZgXMuoLQaqYhiLxhxyyqaa?=
 =?us-ascii?Q?hrwm4kKPQXda6bbtb0HEDQ4uK0NPOLhSdNum/laIh8PxxlwZQFC1wnzrjKHI?=
 =?us-ascii?Q?GH7/rYfULYdBje8Lc42jSTiAPRI7dUg5YxodY97JzG+T0PZGI6sRuPmY+ENV?=
 =?us-ascii?Q?qlRnEw9TSWKViV/rGufDy39ZyN23GX9sAHas5bo5QoYtGjCB1Cs01U5R9FKp?=
 =?us-ascii?Q?ILK8N1BbIHBssRiT7n0wwHX+AmA3r3a3lM7rZWDQPobUSWVwoc+qVdyHiFlR?=
 =?us-ascii?Q?T2N/JcgVU7G4vTF+Q5Odhe3avWbJ32Oizy39p+D5T3GUVuGqVMgJtXL60dVD?=
 =?us-ascii?Q?2Y7HP9zMD0bvDKzdWmU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR18MB4474.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a28e6673-a484-447a-efdf-08db307fda1c
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Mar 2023 18:03:08.1363
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: M/aXJJnJY0wuUIy+m0cqFy2bl8AziYBe+8nN71PYCBAaiMdJ2nwyfiKUmDxG5rSlT7RX4gSDeZfM9sp0oGTVZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR18MB4799
X-Proofpoint-ORIG-GUID: E6kKsQ-cSB9b2L3JKKVcavV7AXNpFd1D
X-Proofpoint-GUID: E6kKsQ-cSB9b2L3JKKVcavV7AXNpFd1D
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-29_11,2023-03-28_02,2023-02-09_01
X-Spam-Status: No, score=-0.7 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Please see inline,

> I have a few comments about concurrency issues, see below. I didn't
> analyze the concurrency model of your driver deeply, so please apologize
> me if I missed some bugs or accidentally called some good code buggy.
>=20
> A few general things to pay attention to, regarding HTB offload:
>=20
> 1. ndo_select_queue can be called at any time, there is no reliable way
> to prevent the kernel from calling it, that means that ndo_select_queue
> must not crash if HTB configuration and structures are being updated in
> another thread.
>=20
> 2. ndo_start_xmit runs in an RCU read lock. If you need to release some
> structure that can be used from another thread in the TX datapath, you
> can set some atomic flag, synchronize with RCU, then release the object.
>=20
> 3. You can take some inspiration from mlx5e, although you may find it's
> a convoluted cooperation of spinlocks, mutexes, atomic operations with
> barriers, and RCU. A big part of it is related to the mechanism of safe
> reopening of queues, which your driver may not need, but the remaining
> parts have a lot of similarities, so you can find useful insights about
> the locking for HTB in mlx5e.
>=20
> On Sun, Mar 26, 2023 at 11:42:44PM +0530, Hariprasad Kelam wrote:
> > From: Naveen Mamindlapalli <naveenm@marvell.com>
> >
> > This patch registers callbacks to support HTB offload.
> >
> > Below are features supported,
> >
> > - supports traffic shaping on the given class by honoring rate and ceil
> > configuration.
> >
> > - supports traffic scheduling,  which prioritizes different types of
> > traffic based on strict priority values.
> >
> > - supports the creation of leaf to inner classes such that parent node
> > rate limits apply to all child nodes.
> >
> > Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
> > Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
> > Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
> > ---
> >  .../ethernet/marvell/octeontx2/af/common.h    |    2 +-
> >  .../ethernet/marvell/octeontx2/nic/Makefile   |    2 +-
> >  .../marvell/octeontx2/nic/otx2_common.c       |   35 +-
> >  .../marvell/octeontx2/nic/otx2_common.h       |    8 +-
> >  .../marvell/octeontx2/nic/otx2_ethtool.c      |   31 +-
> >  .../ethernet/marvell/octeontx2/nic/otx2_pf.c  |   56 +-
> >  .../ethernet/marvell/octeontx2/nic/otx2_reg.h |   13 +
> >  .../ethernet/marvell/octeontx2/nic/otx2_tc.c  |    7 +-
> >  .../net/ethernet/marvell/octeontx2/nic/qos.c  | 1460
> +++++++++++++++++
> >  .../net/ethernet/marvell/octeontx2/nic/qos.h  |   58 +-
> >  .../ethernet/marvell/octeontx2/nic/qos_sq.c   |   20 +-
> >  11 files changed, 1657 insertions(+), 35 deletions(-)
> >  create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/qos.c
> >
> > diff --git a/drivers/net/ethernet/marvell/octeontx2/af/common.h
> b/drivers/net/ethernet/marvell/octeontx2/af/common.h
> > index 8931864ee110..f5bf719a6ccf 100644
> > --- a/drivers/net/ethernet/marvell/octeontx2/af/common.h
> > +++ b/drivers/net/ethernet/marvell/octeontx2/af/common.h
> > @@ -142,7 +142,7 @@ enum nix_scheduler {
> >
> >  #define TXSCH_RR_QTM_MAX		((1 << 24) - 1)
> >  #define TXSCH_TL1_DFLT_RR_QTM		TXSCH_RR_QTM_MAX
> > -#define TXSCH_TL1_DFLT_RR_PRIO		(0x1ull)
> > +#define TXSCH_TL1_DFLT_RR_PRIO		(0x7ull)
> >  #define CN10K_MAX_DWRR_WEIGHT          16384 /* Weight is 14bit on
> CN10K */
> >
> >  /* Min/Max packet sizes, excluding FCS */
> > diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/Makefile
> b/drivers/net/ethernet/marvell/octeontx2/nic/Makefile
> > index 3d31ddf7c652..5664f768cb0c 100644
> > --- a/drivers/net/ethernet/marvell/octeontx2/nic/Makefile
> > +++ b/drivers/net/ethernet/marvell/octeontx2/nic/Makefile
> > @@ -8,7 +8,7 @@ obj-$(CONFIG_OCTEONTX2_VF) +=3D rvu_nicvf.o
> otx2_ptp.o
> >
> >  rvu_nicpf-y :=3D otx2_pf.o otx2_common.o otx2_txrx.o otx2_ethtool.o \
> >                 otx2_flows.o otx2_tc.o cn10k.o otx2_dmac_flt.o \
> > -               otx2_devlink.o qos_sq.o
> > +               otx2_devlink.o qos_sq.o qos.o
> >  rvu_nicvf-y :=3D otx2_vf.o otx2_devlink.o
> >
> >  rvu_nicpf-$(CONFIG_DCB) +=3D otx2_dcbnl.o
> > diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> > index 32c02a2d3554..b4542a801291 100644
> > --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> > +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> > @@ -89,6 +89,11 @@ int otx2_update_sq_stats(struct otx2_nic *pfvf, int
> qidx)
> >  	if (!pfvf->qset.sq)
> >  		return 0;
> >
> > +	if (qidx >=3D pfvf->hw.non_qos_queues) {
> > +		if (!test_bit(qidx - pfvf->hw.non_qos_queues, pfvf-
> >qos.qos_sq_bmap))
> > +			return 0;
> > +	}
> > +
> >  	otx2_nix_sq_op_stats(&sq->stats, pfvf, qidx);
> >  	return 1;
> >  }
> > @@ -747,29 +752,47 @@ int otx2_txsch_alloc(struct otx2_nic *pfvf)
> >  	return 0;
> >  }
> >
> > -int otx2_txschq_stop(struct otx2_nic *pfvf)
> > +void otx2_txschq_free_one(struct otx2_nic *pfvf, u16 lvl, u16 schq)
> >  {
> >  	struct nix_txsch_free_req *free_req;
> > -	int lvl, schq, err;
> > +	int err;
> >
> >  	mutex_lock(&pfvf->mbox.lock);
> > -	/* Free the transmit schedulers */
> > +
> >  	free_req =3D otx2_mbox_alloc_msg_nix_txsch_free(&pfvf->mbox);
> >  	if (!free_req) {
> >  		mutex_unlock(&pfvf->mbox.lock);
> > -		return -ENOMEM;
> > +		netdev_err(pfvf->netdev,
> > +			   "Failed alloc txschq free req\n");
> > +		return;
> >  	}
> >
> > -	free_req->flags =3D TXSCHQ_FREE_ALL;
> > +	free_req->schq_lvl =3D lvl;
> > +	free_req->schq =3D schq;
> > +
> >  	err =3D otx2_sync_mbox_msg(&pfvf->mbox);
> > +	if (err) {
> > +		netdev_err(pfvf->netdev,
> > +			   "Failed stop txschq %d at level %d\n", lvl, schq);
> > +	}
> > +
> >  	mutex_unlock(&pfvf->mbox.lock);
> > +}
> > +
> > +void otx2_txschq_stop(struct otx2_nic *pfvf)
> > +{
> > +	int lvl, schq;
> > +
> > +	/* free non QOS TLx nodes */
> > +	for (lvl =3D 0; lvl < NIX_TXSCH_LVL_CNT; lvl++)
> > +		otx2_txschq_free_one(pfvf, lvl,
> > +				     pfvf->hw.txschq_list[lvl][0]);
> >
> >  	/* Clear the txschq list */
> >  	for (lvl =3D 0; lvl < NIX_TXSCH_LVL_CNT; lvl++) {
> >  		for (schq =3D 0; schq < MAX_TXSCHQ_PER_FUNC; schq++)
> >  			pfvf->hw.txschq_list[lvl][schq] =3D 0;
> >  	}
> > -	return err;
> >  }
> >
> >  void otx2_sqb_flush(struct otx2_nic *pfvf)
> > diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
> b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
> > index 3834cc447426..4b219e8e5b32 100644
> > --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
> > +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
> > @@ -252,6 +252,7 @@ struct otx2_hw {
> >  #define CN10K_RPM		3
> >  #define CN10K_PTP_ONESTEP	4
> >  #define CN10K_HW_MACSEC		5
> > +#define QOS_CIR_PIR_SUPPORT	6
> >  	unsigned long		cap_flag;
> >
> >  #define LMT_LINE_SIZE		128
> > @@ -586,6 +587,7 @@ static inline void
> otx2_setup_dev_hw_settings(struct otx2_nic *pfvf)
> >  		__set_bit(CN10K_LMTST, &hw->cap_flag);
> >  		__set_bit(CN10K_RPM, &hw->cap_flag);
> >  		__set_bit(CN10K_PTP_ONESTEP, &hw->cap_flag);
> > +		__set_bit(QOS_CIR_PIR_SUPPORT, &hw->cap_flag);
> >  	}
> >
> >  	if (is_dev_cn10kb(pfvf->pdev))
> > @@ -935,7 +937,7 @@ int otx2_config_nix(struct otx2_nic *pfvf);
> >  int otx2_config_nix_queues(struct otx2_nic *pfvf);
> >  int otx2_txschq_config(struct otx2_nic *pfvf, int lvl, int prio, bool =
pfc_en);
> >  int otx2_txsch_alloc(struct otx2_nic *pfvf);
> > -int otx2_txschq_stop(struct otx2_nic *pfvf);
> > +void otx2_txschq_stop(struct otx2_nic *pfvf);
> >  void otx2_sqb_flush(struct otx2_nic *pfvf);
> >  int otx2_alloc_rbuf(struct otx2_nic *pfvf, struct otx2_pool *pool,
> >  		    dma_addr_t *dma);
> > @@ -953,6 +955,7 @@ int otx2_pool_init(struct otx2_nic *pfvf, u16
> pool_id,
> >  		   int stack_pages, int numptrs, int buf_size);
> >  int otx2_aura_init(struct otx2_nic *pfvf, int aura_id,
> >  		   int pool_id, int numptrs);
> > +void otx2_txschq_free_one(struct otx2_nic *pfvf, u16 lvl, u16 schq);
> >
> >  /* RSS configuration APIs*/
> >  int otx2_rss_init(struct otx2_nic *pfvf);
> > @@ -1064,4 +1067,7 @@ static inline void cn10k_handle_mcs_event(struct
> otx2_nic *pfvf,
> >  void otx2_qos_sq_setup(struct otx2_nic *pfvf, int qos_txqs);
> >  u16 otx2_select_queue(struct net_device *netdev, struct sk_buff *skb,
> >  		      struct net_device *sb_dev);
> > +int otx2_get_txq_by_classid(struct otx2_nic *pfvf, u16 classid);
> > +void otx2_qos_config_txschq(struct otx2_nic *pfvf);
> > +void otx2_clean_qos_queues(struct otx2_nic *pfvf);
> >  #endif /* OTX2_COMMON_H */
> > diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
> b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
> > index 0f8d1a69139f..e8722a4f4cc6 100644
> > --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
> > +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
> > @@ -92,10 +92,16 @@ static void otx2_get_qset_strings(struct otx2_nic
> *pfvf, u8 **data, int qset)
> >  			*data +=3D ETH_GSTRING_LEN;
> >  		}
> >  	}
> > -	for (qidx =3D 0; qidx < pfvf->hw.tx_queues; qidx++) {
> > +
> > +	for (qidx =3D 0; qidx < otx2_get_total_tx_queues(pfvf); qidx++) {
> >  		for (stats =3D 0; stats < otx2_n_queue_stats; stats++) {
> > -			sprintf(*data, "txq%d: %s", qidx + start_qidx,
> > -				otx2_queue_stats[stats].name);
> > +			if (qidx >=3D pfvf->hw.non_qos_queues)
> > +				sprintf(*data, "txq_qos%d: %s",
> > +					qidx + start_qidx - pfvf-
> >hw.non_qos_queues,
> > +					otx2_queue_stats[stats].name);
> > +			else
> > +				sprintf(*data, "txq%d: %s", qidx + start_qidx,
> > +					otx2_queue_stats[stats].name);
> >  			*data +=3D ETH_GSTRING_LEN;
> >  		}
> >  	}
> > @@ -159,7 +165,7 @@ static void otx2_get_qset_stats(struct otx2_nic
> *pfvf,
> >  				[otx2_queue_stats[stat].index];
> >  	}
> >
> > -	for (qidx =3D 0; qidx < pfvf->hw.tx_queues; qidx++) {
> > +	for (qidx =3D 0; qidx <  otx2_get_total_tx_queues(pfvf); qidx++) {
> >  		if (!otx2_update_sq_stats(pfvf, qidx)) {
> >  			for (stat =3D 0; stat < otx2_n_queue_stats; stat++)
> >  				*((*data)++) =3D 0;
> > @@ -254,7 +260,8 @@ static int otx2_get_sset_count(struct net_device
> *netdev, int sset)
> >  		return -EINVAL;
> >
> >  	qstats_count =3D otx2_n_queue_stats *
> > -		       (pfvf->hw.rx_queues + pfvf->hw.tx_queues);
> > +		       (pfvf->hw.rx_queues + pfvf->hw.non_qos_queues +
> > +			pfvf->hw.tc_tx_queues);
> >  	if (!test_bit(CN10K_RPM, &pfvf->hw.cap_flag))
> >  		mac_stats =3D CGX_RX_STATS_COUNT +
> CGX_TX_STATS_COUNT;
> >  	otx2_update_lmac_fec_stats(pfvf);
> > @@ -282,7 +289,7 @@ static int otx2_set_channels(struct net_device
> *dev,
> >  {
> >  	struct otx2_nic *pfvf =3D netdev_priv(dev);
> >  	bool if_up =3D netif_running(dev);
> > -	int err =3D 0;
> > +	int err, qos_txqs;
> >
> >  	if (!channel->rx_count || !channel->tx_count)
> >  		return -EINVAL;
> > @@ -296,14 +303,19 @@ static int otx2_set_channels(struct net_device
> *dev,
> >  	if (if_up)
> >  		dev->netdev_ops->ndo_stop(dev);
> >
> > -	err =3D otx2_set_real_num_queues(dev, channel->tx_count,
> > +	qos_txqs =3D bitmap_weight(pfvf->qos.qos_sq_bmap,
> > +				 OTX2_QOS_MAX_LEAF_NODES);
> > +
> > +	err =3D otx2_set_real_num_queues(dev, channel->tx_count +
> qos_txqs,
> >  				       channel->rx_count);
> >  	if (err)
> >  		return err;
> >
> >  	pfvf->hw.rx_queues =3D channel->rx_count;
> >  	pfvf->hw.tx_queues =3D channel->tx_count;
> > -	pfvf->qset.cq_cnt =3D pfvf->hw.tx_queues +  pfvf->hw.rx_queues;
> > +	if (pfvf->xdp_prog)
> > +		pfvf->hw.xdp_queues =3D channel->rx_count;
> > +	pfvf->hw.non_qos_queues =3D  pfvf->hw.tx_queues + pfvf-
> >hw.xdp_queues;
> >
> >  	if (if_up)
> >  		err =3D dev->netdev_ops->ndo_open(dev);
> > @@ -1405,7 +1417,8 @@ static int otx2vf_get_sset_count(struct
> net_device *netdev, int sset)
> >  		return -EINVAL;
> >
> >  	qstats_count =3D otx2_n_queue_stats *
> > -		       (vf->hw.rx_queues + vf->hw.tx_queues);
> > +		       (vf->hw.rx_queues + vf->hw.tx_queues +
> > +			vf->hw.tc_tx_queues);
> >
> >  	return otx2_n_dev_stats + otx2_n_drv_stats + qstats_count + 1;
> >  }
> > diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
> b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
> > index a32f0cb89fc4..d0192f9089ee 100644
> > --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
> > +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
> > @@ -1387,6 +1387,9 @@ static void otx2_free_sq_res(struct otx2_nic *pf)
> >  	otx2_sq_free_sqbs(pf);
> >  	for (qidx =3D 0; qidx < otx2_get_total_tx_queues(pf); qidx++) {
> >  		sq =3D &qset->sq[qidx];
> > +		/* Skip freeing Qos queues if they are not initialized */
> > +		if (!sq->sqb_count)
> > +			continue;
> >  		qmem_free(pf->dev, sq->sqe);
> >  		qmem_free(pf->dev, sq->tso_hdrs);
> >  		kfree(sq->sg);
> > @@ -1518,8 +1521,7 @@ static int otx2_init_hw_resources(struct otx2_nic
> *pf)
> >  	otx2_free_cq_res(pf);
> >  	otx2_ctx_disable(mbox, NIX_AQ_CTYPE_RQ, false);
> >  err_free_txsch:
> > -	if (otx2_txschq_stop(pf))
> > -		dev_err(pf->dev, "%s failed to stop TX schedulers\n",
> __func__);
> > +	otx2_txschq_stop(pf);
> >  err_free_sq_ptrs:
> >  	otx2_sq_free_sqbs(pf);
> >  err_free_rq_ptrs:
> > @@ -1554,21 +1556,21 @@ static void otx2_free_hw_resources(struct
> otx2_nic *pf)
> >  	struct mbox *mbox =3D &pf->mbox;
> >  	struct otx2_cq_queue *cq;
> >  	struct msg_req *req;
> > -	int qidx, err;
> > +	int qidx;
> >
> >  	/* Ensure all SQE are processed */
> >  	otx2_sqb_flush(pf);
> >
> >  	/* Stop transmission */
> > -	err =3D otx2_txschq_stop(pf);
> > -	if (err)
> > -		dev_err(pf->dev, "RVUPF: Failed to stop/free TX
> schedulers\n");
> > +	otx2_txschq_stop(pf);
> >
> >  #ifdef CONFIG_DCB
> >  	if (pf->pfc_en)
> >  		otx2_pfc_txschq_stop(pf);
> >  #endif
> >
> > +	otx2_clean_qos_queues(pf);
> > +
> >  	mutex_lock(&mbox->lock);
> >  	/* Disable backpressure */
> >  	if (!(pf->pcifunc & RVU_PFVF_FUNC_MASK))
> > @@ -1836,6 +1838,9 @@ int otx2_open(struct net_device *netdev)
> >  	/* 'intf_down' may be checked on any cpu */
> >  	smp_wmb();
> >
> > +	/* Enable QoS configuration before starting tx queues */
> > +	otx2_qos_config_txschq(pf);
> > +
> >  	/* we have already received link status notification */
> >  	if (pf->linfo.link_up && !(pf->pcifunc & RVU_PFVF_FUNC_MASK))
> >  		otx2_handle_link_event(pf);
> > @@ -1980,14 +1985,45 @@ static netdev_tx_t otx2_xmit(struct sk_buff
> *skb, struct net_device *netdev)
> >  	return NETDEV_TX_OK;
> >  }
> >
> > +static int otx2_qos_select_htb_queue(struct otx2_nic *pf, struct sk_bu=
ff
> *skb,
> > +				     u16 htb_maj_id)
> > +{
> > +	u16 classid;
> > +
> > +	if ((TC_H_MAJ(skb->priority) >> 16) =3D=3D htb_maj_id)
> > +		classid =3D TC_H_MIN(skb->priority);
> > +	else
> > +		classid =3D READ_ONCE(pf->qos.defcls);
> > +
> > +	if (!classid)
> > +		return 0;
> > +
> > +	return otx2_get_txq_by_classid(pf, classid);
>=20
> This selects queues with numbers >=3D pf->hw.tx_queues, and otx2_xmit
> indexes pfvf->qset.sq with these qids, however, pfvf->qset.sq is
> allocated only up to pf->hw.non_qos_queues. Array out-of-bounds?
>=20

We are supposed to allocated all Sqs (non_qos_queues + tc_tx_queues).=20
Looks like we missed this change in refactoring send queue code,
Will update this change.
> > +}
> > +
> >  u16 otx2_select_queue(struct net_device *netdev, struct sk_buff *skb,
> >  		      struct net_device *sb_dev)
> >  {
> > -#ifdef CONFIG_DCB
> >  	struct otx2_nic *pf =3D netdev_priv(netdev);
> > +	bool qos_enabled;
> > +#ifdef CONFIG_DCB
> >  	u8 vlan_prio;
> >  #endif
> > +	int txq;
> >
> > +	qos_enabled =3D (netdev->real_num_tx_queues > pf-
> >hw.tx_queues) ? true : false;
> > +	if (unlikely(qos_enabled)) {
> > +		u16 htb_maj_id =3D smp_load_acquire(&pf->qos.maj_id); /*
> barrier */
>=20
> Checkpatch requires to add comments for the barriers for a reason :)
>=20
> "Barrier" is a useless comment, we all know that smp_load_acquire is a
> barrier, you should explain why this barrier is needed and which other
> barriers it pairs with.
>=20
ACK, will update the details in next version.
> > +
> > +		if (unlikely(htb_maj_id)) {
> > +			txq =3D otx2_qos_select_htb_queue(pf, skb,
> htb_maj_id);
> > +			if (txq > 0)
> > +				return txq;
> > +			goto process_pfc;
> > +		}
> > +	}
> > +
> > +process_pfc:
> >  #ifdef CONFIG_DCB
> >  	if (!skb_vlan_tag_present(skb))
> >  		goto pick_tx;
> > @@ -2001,7 +2037,11 @@ u16 otx2_select_queue(struct net_device
> *netdev, struct sk_buff *skb,
> >
> >  pick_tx:
> >  #endif
> > -	return netdev_pick_tx(netdev, skb, NULL);
> > +	txq =3D netdev_pick_tx(netdev, skb, NULL);
> > +	if (unlikely(qos_enabled))
> > +		return txq % pf->hw.tx_queues;
> > +
> > +	return txq;
> >  }
> >  EXPORT_SYMBOL(otx2_select_queue);
> >
> > diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_reg.h
> b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_reg.h
> > index 1b967eaf948b..45a32e4b49d1 100644
> > --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_reg.h
> > +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_reg.h
> > @@ -145,12 +145,25 @@
> >  #define NIX_AF_TL1X_TOPOLOGY(a)		(0xC80 | (a) << 16)
> >  #define NIX_AF_TL2X_PARENT(a)		(0xE88 | (a) << 16)
> >  #define NIX_AF_TL2X_SCHEDULE(a)		(0xE00 | (a) << 16)
> > +#define NIX_AF_TL2X_TOPOLOGY(a)		(0xE80 | (a) << 16)
> > +#define NIX_AF_TL2X_CIR(a)              (0xE20 | (a) << 16)
> > +#define NIX_AF_TL2X_PIR(a)              (0xE30 | (a) << 16)
> >  #define NIX_AF_TL3X_PARENT(a)		(0x1088 | (a) << 16)
> >  #define NIX_AF_TL3X_SCHEDULE(a)		(0x1000 | (a) << 16)
> > +#define NIX_AF_TL3X_SHAPE(a)		(0x1010 | (a) << 16)
> > +#define NIX_AF_TL3X_CIR(a)		(0x1020 | (a) << 16)
> > +#define NIX_AF_TL3X_PIR(a)		(0x1030 | (a) << 16)
> > +#define NIX_AF_TL3X_TOPOLOGY(a)		(0x1080 | (a) << 16)
> >  #define NIX_AF_TL4X_PARENT(a)		(0x1288 | (a) << 16)
> >  #define NIX_AF_TL4X_SCHEDULE(a)		(0x1200 | (a) << 16)
> > +#define NIX_AF_TL4X_SHAPE(a)		(0x1210 | (a) << 16)
> > +#define NIX_AF_TL4X_CIR(a)		(0x1220 | (a) << 16)
> >  #define NIX_AF_TL4X_PIR(a)		(0x1230 | (a) << 16)
> > +#define NIX_AF_TL4X_TOPOLOGY(a)		(0x1280 | (a) << 16)
> >  #define NIX_AF_MDQX_SCHEDULE(a)		(0x1400 | (a) << 16)
> > +#define NIX_AF_MDQX_SHAPE(a)		(0x1410 | (a) << 16)
> > +#define NIX_AF_MDQX_CIR(a)		(0x1420 | (a) << 16)
> > +#define NIX_AF_MDQX_PIR(a)		(0x1430 | (a) << 16)
> >  #define NIX_AF_MDQX_PARENT(a)		(0x1480 | (a) << 16)
> >  #define NIX_AF_TL3_TL2X_LINKX_CFG(a, b)	(0x1700 | (a) << 16 | (b) << 3=
)
> >
> > diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
> b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
> > index 044cc211424e..42c49249f4e7 100644
> > --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
> > +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
> > @@ -19,6 +19,7 @@
> >
> >  #include "cn10k.h"
> >  #include "otx2_common.h"
> > +#include "qos.h"
> >
> >  /* Egress rate limiting definitions */
> >  #define MAX_BURST_EXPONENT		0x0FULL
> > @@ -147,8 +148,8 @@ static void otx2_get_egress_rate_cfg(u64 maxrate,
> u32 *exp,
> >  	}
> >  }
> >
> > -static u64 otx2_get_txschq_rate_regval(struct otx2_nic *nic,
> > -				       u64 maxrate, u32 burst)
> > +u64 otx2_get_txschq_rate_regval(struct otx2_nic *nic,
> > +				u64 maxrate, u32 burst)
> >  {
> >  	u32 burst_exp, burst_mantissa;
> >  	u32 exp, mantissa, div_exp;
> > @@ -1127,6 +1128,8 @@ int otx2_setup_tc(struct net_device *netdev,
> enum tc_setup_type type,
> >  	switch (type) {
> >  	case TC_SETUP_BLOCK:
> >  		return otx2_setup_tc_block(netdev, type_data);
> > +	case TC_SETUP_QDISC_HTB:
> > +		return otx2_setup_tc_htb(netdev, type_data);
> >  	default:
> >  		return -EOPNOTSUPP;
> >  	}
> > diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/qos.c
> b/drivers/net/ethernet/marvell/octeontx2/nic/qos.c
> > new file mode 100644
> > index 000000000000..22c5b6a2871a
> > --- /dev/null
> > +++ b/drivers/net/ethernet/marvell/octeontx2/nic/qos.c
> > @@ -0,0 +1,1460 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/* Marvell RVU Ethernet driver
> > + *
> > + * Copyright (C) 2023 Marvell.
> > + *
> > + */
> > +#include <linux/netdevice.h>
> > +#include <linux/etherdevice.h>
> > +#include <linux/inetdevice.h>
> > +#include <linux/bitfield.h>
> > +
> > +#include "otx2_common.h"
> > +#include "cn10k.h"
> > +#include "qos.h"
> > +
> > +#define OTX2_QOS_QID_INNER		0xFFFFU
> > +#define OTX2_QOS_QID_NONE		0xFFFEU
> > +#define OTX2_QOS_ROOT_CLASSID		0xFFFFFFFF
> > +#define OTX2_QOS_CLASS_NONE		0
> > +#define OTX2_QOS_DEFAULT_PRIO		0xF
> > +#define OTX2_QOS_INVALID_SQ		0xFFFF
> > +
> > +/* Egress rate limiting definitions */
> > +#define MAX_BURST_EXPONENT		0x0FULL
> > +#define MAX_BURST_MANTISSA		0xFFULL
> > +#define MAX_BURST_SIZE			130816ULL
> > +#define MAX_RATE_DIVIDER_EXPONENT	12ULL
> > +#define MAX_RATE_EXPONENT		0x0FULL
> > +#define MAX_RATE_MANTISSA		0xFFULL
> > +
> > +/* Bitfields in NIX_TLX_PIR register */
> > +#define TLX_RATE_MANTISSA		GENMASK_ULL(8, 1)
> > +#define TLX_RATE_EXPONENT		GENMASK_ULL(12, 9)
> > +#define TLX_RATE_DIVIDER_EXPONENT	GENMASK_ULL(16, 13)
> > +#define TLX_BURST_MANTISSA		GENMASK_ULL(36, 29)
> > +#define TLX_BURST_EXPONENT		GENMASK_ULL(40, 37)
> > +
> > +static int otx2_qos_update_tx_netdev_queues(struct otx2_nic *pfvf)
> > +{
> > +	int tx_queues, qos_txqs, err;
> > +	struct otx2_hw *hw =3D &pfvf->hw;
> > +
> > +	qos_txqs =3D bitmap_weight(pfvf->qos.qos_sq_bmap,
> > +				 OTX2_QOS_MAX_LEAF_NODES);
> > +
> > +	tx_queues =3D hw->tx_queues + qos_txqs;
> > +
> > +	err =3D netif_set_real_num_tx_queues(pfvf->netdev, tx_queues);
> > +	if (err) {
> > +		netdev_err(pfvf->netdev,
> > +			   "Failed to set no of Tx queues: %d\n", tx_queues);
> > +		return err;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static u64 otx2_qos_convert_rate(u64 rate)
> > +{
> > +	u64 converted_rate;
> > +
> > +	/* convert bytes per second to Mbps */
> > +	converted_rate =3D rate * 8;
> > +	converted_rate =3D max_t(u64, converted_rate / 1000000, 1);
> > +
> > +	return converted_rate;
> > +}
> > +
> > +static void __otx2_qos_txschq_cfg(struct otx2_nic *pfvf,
> > +				  struct otx2_qos_node *node,
> > +				  struct nix_txschq_config *cfg)
> > +{
> > +	struct otx2_hw *hw =3D &pfvf->hw;
> > +	int num_regs =3D 0;
> > +	u64 maxrate;
> > +	u8 level;
> > +
> > +	level =3D node->level;
> > +
> > +	/* program txschq registers */
> > +	if (level =3D=3D NIX_TXSCH_LVL_SMQ) {
> > +		cfg->reg[num_regs] =3D NIX_AF_SMQX_CFG(node->schq);
> > +		cfg->regval[num_regs] =3D ((u64)pfvf->tx_max_pktlen << 8) |
> > +					OTX2_MIN_MTU;
> > +		cfg->regval[num_regs] |=3D (0x20ULL << 51) | (0x80ULL << 39)
> |
> > +					 (0x2ULL << 36);
> > +		num_regs++;
> > +
> > +		/* configure parent txschq */
> > +		cfg->reg[num_regs] =3D NIX_AF_MDQX_PARENT(node-
> >schq);
> > +		cfg->regval[num_regs] =3D node->parent->schq << 16;
> > +		num_regs++;
> > +
> > +		/* configure prio/quantum */
> > +		if (node->qid =3D=3D OTX2_QOS_QID_NONE) {
> > +			cfg->reg[num_regs] =3D
> NIX_AF_MDQX_SCHEDULE(node->schq);
> > +			cfg->regval[num_regs] =3D  node->prio << 24 |
> > +						 mtu_to_dwrr_weight(pfvf,
> > +								    pfvf-
> >tx_max_pktlen);
> > +			num_regs++;
> > +			goto txschq_cfg_out;
> > +		}
> > +
> > +		/* configure prio */
> > +		cfg->reg[num_regs] =3D NIX_AF_MDQX_SCHEDULE(node-
> >schq);
> > +		cfg->regval[num_regs] =3D (node->schq -
> > +					 node->parent->prio_anchor) << 24;
> > +		num_regs++;
> > +
> > +		/* configure PIR */
> > +		maxrate =3D (node->rate > node->ceil) ? node->rate : node-
> >ceil;
> > +
> > +		cfg->reg[num_regs] =3D NIX_AF_MDQX_PIR(node->schq);
> > +		cfg->regval[num_regs] =3D
> > +			otx2_get_txschq_rate_regval(pfvf, maxrate, 65536);
> > +		num_regs++;
> > +
> > +		/* configure CIR */
> > +		if (!test_bit(QOS_CIR_PIR_SUPPORT, &pfvf->hw.cap_flag)) {
> > +			/* Don't configure CIR when both CIR+PIR not
> supported
> > +			 * On 96xx, CIR + PIR + RED_ALGO=3DSTALL causes
> deadlock
> > +			 */
> > +			goto txschq_cfg_out;
> > +		}
> > +
> > +		cfg->reg[num_regs] =3D NIX_AF_MDQX_CIR(node->schq);
> > +		cfg->regval[num_regs] =3D
> > +			otx2_get_txschq_rate_regval(pfvf, node->rate,
> 65536);
> > +		num_regs++;
> > +	} else if (level =3D=3D NIX_TXSCH_LVL_TL4) {
> > +		/* configure parent txschq */
> > +		cfg->reg[num_regs] =3D NIX_AF_TL4X_PARENT(node->schq);
> > +		cfg->regval[num_regs] =3D node->parent->schq << 16;
> > +		num_regs++;
> > +
> > +		/* return if not htb node */
> > +		if (node->qid =3D=3D OTX2_QOS_QID_NONE) {
> > +			cfg->reg[num_regs] =3D
> NIX_AF_TL4X_SCHEDULE(node->schq);
> > +			cfg->regval[num_regs] =3D  node->prio << 24 |
> > +						 mtu_to_dwrr_weight(pfvf,
> > +								    pfvf-
> >tx_max_pktlen);
> > +			num_regs++;
> > +			goto txschq_cfg_out;
> > +		}
> > +
> > +		/* configure priority */
> > +		cfg->reg[num_regs] =3D NIX_AF_TL4X_SCHEDULE(node-
> >schq);
> > +		cfg->regval[num_regs] =3D (node->schq -
> > +					 node->parent->prio_anchor) << 24;
> > +		num_regs++;
> > +
> > +		/* configure PIR */
> > +		maxrate =3D (node->rate > node->ceil) ? node->rate : node-
> >ceil;
> > +		cfg->reg[num_regs] =3D NIX_AF_TL4X_PIR(node->schq);
> > +		cfg->regval[num_regs] =3D
> > +			otx2_get_txschq_rate_regval(pfvf, maxrate, 65536);
> > +		num_regs++;
> > +
> > +		/* configure CIR */
> > +		if (!test_bit(QOS_CIR_PIR_SUPPORT, &pfvf->hw.cap_flag)) {
> > +			/* Don't configure CIR when both CIR+PIR not
> supported
> > +			 * On 96xx, CIR + PIR + RED_ALGO=3DSTALL causes
> deadlock
> > +			 */
> > +			goto txschq_cfg_out;
> > +		}
> > +
> > +		cfg->reg[num_regs] =3D NIX_AF_TL4X_CIR(node->schq);
> > +		cfg->regval[num_regs] =3D
> > +			otx2_get_txschq_rate_regval(pfvf, node->rate,
> 65536);
> > +		num_regs++;
> > +	} else if (level =3D=3D NIX_TXSCH_LVL_TL3) {
> > +		/* configure parent txschq */
> > +		cfg->reg[num_regs] =3D NIX_AF_TL3X_PARENT(node->schq);
> > +		cfg->regval[num_regs] =3D node->parent->schq << 16;
> > +		num_regs++;
> > +
> > +		/* configure link cfg */
> > +		if (level =3D=3D pfvf->qos.link_cfg_lvl) {
> > +			cfg->reg[num_regs] =3D
> NIX_AF_TL3_TL2X_LINKX_CFG(node->schq, hw->tx_link);
> > +			cfg->regval[num_regs] =3D BIT_ULL(13) | BIT_ULL(12);
> > +			num_regs++;
> > +		}
> > +
> > +		/* return if not htb node */
> > +		if (node->qid =3D=3D OTX2_QOS_QID_NONE) {
> > +			cfg->reg[num_regs] =3D
> NIX_AF_TL3X_SCHEDULE(node->schq);
> > +			cfg->regval[num_regs] =3D  node->prio << 24 |
> > +						 mtu_to_dwrr_weight(pfvf,
> > +								    pfvf-
> >tx_max_pktlen);
> > +			num_regs++;
> > +			goto txschq_cfg_out;
> > +		}
> > +
> > +		/* configure priority */
> > +		cfg->reg[num_regs] =3D NIX_AF_TL3X_SCHEDULE(node-
> >schq);
> > +		cfg->regval[num_regs] =3D (node->schq -
> > +					 node->parent->prio_anchor) << 24;
> > +		num_regs++;
> > +
> > +		/* configure PIR */
> > +		maxrate =3D (node->rate > node->ceil) ? node->rate : node-
> >ceil;
> > +		cfg->reg[num_regs] =3D NIX_AF_TL3X_PIR(node->schq);
> > +		cfg->regval[num_regs] =3D
> > +			otx2_get_txschq_rate_regval(pfvf, maxrate, 65536);
> > +		num_regs++;
> > +
> > +		/* configure CIR */
> > +		if (!test_bit(QOS_CIR_PIR_SUPPORT, &pfvf->hw.cap_flag)) {
> > +			/* Don't configure CIR when both CIR+PIR not
> supported
> > +			 * On 96xx, CIR + PIR + RED_ALGO=3DSTALL causes
> deadlock
> > +			 */
> > +			goto txschq_cfg_out;
> > +		}
> > +
> > +		cfg->reg[num_regs] =3D NIX_AF_TL3X_CIR(node->schq);
> > +		cfg->regval[num_regs] =3D
> > +			otx2_get_txschq_rate_regval(pfvf, node->rate,
> 65536);
> > +		num_regs++;
> > +	} else if (level =3D=3D NIX_TXSCH_LVL_TL2) {
> > +		/* configure parent txschq */
> > +		cfg->reg[num_regs] =3D NIX_AF_TL2X_PARENT(node->schq);
> > +		cfg->regval[num_regs] =3D hw->tx_link << 16;
> > +		num_regs++;
> > +
> > +		/* configure link cfg */
> > +		if (level =3D=3D pfvf->qos.link_cfg_lvl) {
> > +			cfg->reg[num_regs] =3D
> NIX_AF_TL3_TL2X_LINKX_CFG(node->schq, hw->tx_link);
> > +			cfg->regval[num_regs] =3D BIT_ULL(13) | BIT_ULL(12);
> > +			num_regs++;
> > +		}
> > +
> > +		/* return if not htb node */
> > +		if (node->qid =3D=3D OTX2_QOS_QID_NONE) {
> > +			cfg->reg[num_regs] =3D
> NIX_AF_TL2X_SCHEDULE(node->schq);
> > +			cfg->regval[num_regs] =3D  node->prio << 24 |
> > +						 mtu_to_dwrr_weight(pfvf,
> > +								    pfvf-
> >tx_max_pktlen);
> > +			num_regs++;
> > +			goto txschq_cfg_out;
> > +		}
> > +
> > +		/* check if node is root */
> > +		if (node->qid =3D=3D OTX2_QOS_QID_INNER && !node->parent)
> {
> > +			cfg->reg[num_regs] =3D
> NIX_AF_TL2X_SCHEDULE(node->schq);
> > +			cfg->regval[num_regs] =3D  TXSCH_TL1_DFLT_RR_PRIO
> << 24 |
> > +						 mtu_to_dwrr_weight(pfvf,
> > +								    pfvf-
> >tx_max_pktlen);
> > +			num_regs++;
> > +			goto txschq_cfg_out;
> > +		}
> > +
> > +		/* configure priority/quantum */
> > +		cfg->reg[num_regs] =3D NIX_AF_TL2X_SCHEDULE(node-
> >schq);
> > +		cfg->regval[num_regs] =3D (node->schq -
> > +					 node->parent->prio_anchor) << 24;
> > +		num_regs++;
> > +
> > +		/* configure PIR */
> > +		maxrate =3D (node->rate > node->ceil) ? node->rate : node-
> >ceil;
> > +		cfg->reg[num_regs] =3D NIX_AF_TL2X_PIR(node->schq);
> > +		cfg->regval[num_regs] =3D
> > +			otx2_get_txschq_rate_regval(pfvf, maxrate, 65536);
> > +		num_regs++;
> > +
> > +		/* configure CIR */
> > +		if (!test_bit(QOS_CIR_PIR_SUPPORT, &pfvf->hw.cap_flag)) {
> > +			/* Don't configure CIR when both CIR+PIR not
> supported
> > +			 * On 96xx, CIR + PIR + RED_ALGO=3DSTALL causes
> deadlock
> > +			 */
> > +			goto txschq_cfg_out;
> > +		}
> > +
> > +		cfg->reg[num_regs] =3D NIX_AF_TL2X_CIR(node->schq);
> > +		cfg->regval[num_regs] =3D
> > +			otx2_get_txschq_rate_regval(pfvf, node->rate,
> 65536);
> > +		num_regs++;
> > +	}
> > +
> > +txschq_cfg_out:
> > +	cfg->num_regs =3D num_regs;
> > +}
> > +
> > +static int otx2_qos_txschq_set_parent_topology(struct otx2_nic *pfvf,
> > +					       struct otx2_qos_node *parent)
> > +{
> > +	struct mbox *mbox =3D &pfvf->mbox;
> > +	struct nix_txschq_config *cfg;
> > +	int rc;
> > +
> > +	if (parent->level =3D=3D NIX_TXSCH_LVL_MDQ)
> > +		return 0;
> > +
> > +	mutex_lock(&mbox->lock);
> > +
> > +	cfg =3D otx2_mbox_alloc_msg_nix_txschq_cfg(&pfvf->mbox);
> > +	if (!cfg) {
> > +		mutex_unlock(&mbox->lock);
> > +		return -ENOMEM;
> > +	}
> > +
> > +	cfg->lvl =3D parent->level;
> > +
> > +	if (parent->level =3D=3D NIX_TXSCH_LVL_TL4)
> > +		cfg->reg[0] =3D NIX_AF_TL4X_TOPOLOGY(parent->schq);
> > +	else if (parent->level =3D=3D NIX_TXSCH_LVL_TL3)
> > +		cfg->reg[0] =3D NIX_AF_TL3X_TOPOLOGY(parent->schq);
> > +	else if (parent->level =3D=3D NIX_TXSCH_LVL_TL2)
> > +		cfg->reg[0] =3D NIX_AF_TL2X_TOPOLOGY(parent->schq);
> > +	else if (parent->level =3D=3D NIX_TXSCH_LVL_TL1)
> > +		cfg->reg[0] =3D NIX_AF_TL1X_TOPOLOGY(parent->schq);
> > +
> > +	cfg->regval[0] =3D (u64)parent->prio_anchor << 32;
> > +	if (parent->level =3D=3D NIX_TXSCH_LVL_TL1)
> > +		cfg->regval[0] |=3D (u64)TXSCH_TL1_DFLT_RR_PRIO << 1;
> > +
> > +	cfg->num_regs++;
> > +
> > +	rc =3D otx2_sync_mbox_msg(&pfvf->mbox);
> > +
> > +	mutex_unlock(&mbox->lock);
> > +
> > +	return rc;
> > +}
> > +
> > +static void otx2_qos_free_hw_node_schq(struct otx2_nic *pfvf,
> > +				       struct otx2_qos_node *parent)
> > +{
> > +	struct otx2_qos_node *node;
> > +
> > +	list_for_each_entry_reverse(node, &parent->child_schq_list, list)
> > +		otx2_txschq_free_one(pfvf, node->level, node->schq);
> > +}
> > +
> > +static void otx2_qos_free_hw_node(struct otx2_nic *pfvf,
> > +				  struct otx2_qos_node *parent)
> > +{
> > +	struct otx2_qos_node *node, *tmp;
> > +
> > +	list_for_each_entry_safe(node, tmp, &parent->child_list, list) {
> > +		otx2_qos_free_hw_node(pfvf, node);
> > +		otx2_qos_free_hw_node_schq(pfvf, node);
> > +		otx2_txschq_free_one(pfvf, node->level, node->schq);
> > +	}
> > +}
> > +
> > +static void otx2_qos_free_hw_cfg(struct otx2_nic *pfvf,
> > +				 struct otx2_qos_node *node)
> > +{
> > +	mutex_lock(&pfvf->qos.qos_lock);
> > +
> > +	/* free child node hw mappings */
> > +	otx2_qos_free_hw_node(pfvf, node);
> > +	otx2_qos_free_hw_node_schq(pfvf, node);
> > +
> > +	/* free node hw mappings */
> > +	otx2_txschq_free_one(pfvf, node->level, node->schq);
> > +
> > +	mutex_unlock(&pfvf->qos.qos_lock);
> > +}
> > +
> > +static void otx2_qos_sw_node_delete(struct otx2_nic *pfvf,
> > +				    struct otx2_qos_node *node)
> > +{
> > +	hash_del(&node->hlist);
> > +
> > +	if (node->qid !=3D OTX2_QOS_QID_INNER && node->qid !=3D
> OTX2_QOS_QID_NONE) {
> > +		__clear_bit(node->qid, pfvf->qos.qos_sq_bmap);
> > +		otx2_qos_update_tx_netdev_queues(pfvf);
> > +	}
> > +
> > +	list_del(&node->list);
> > +	kfree(node);
> > +}
> > +
> > +static void otx2_qos_free_sw_node_schq(struct otx2_nic *pfvf,
> > +				       struct otx2_qos_node *parent)
> > +{
> > +	struct otx2_qos_node *node, *tmp;
> > +
> > +	list_for_each_entry_safe(node, tmp, &parent->child_schq_list, list) {
> > +		list_del(&node->list);
> > +		kfree(node);
> > +	}
> > +}
> > +
> > +static void __otx2_qos_free_sw_node(struct otx2_nic *pfvf,
> > +				    struct otx2_qos_node *parent)
> > +{
> > +	struct otx2_qos_node *node, *tmp;
> > +
> > +	list_for_each_entry_safe(node, tmp, &parent->child_list, list) {
> > +		__otx2_qos_free_sw_node(pfvf, node);
> > +		otx2_qos_free_sw_node_schq(pfvf, node);
> > +		otx2_qos_sw_node_delete(pfvf, node);
> > +	}
> > +}
> > +
> > +static void otx2_qos_free_sw_node(struct otx2_nic *pfvf,
> > +				  struct otx2_qos_node *node)
> > +{
> > +	mutex_lock(&pfvf->qos.qos_lock);
> > +
> > +	__otx2_qos_free_sw_node(pfvf, node);
> > +	otx2_qos_free_sw_node_schq(pfvf, node);
> > +	otx2_qos_sw_node_delete(pfvf, node);
> > +
> > +	mutex_unlock(&pfvf->qos.qos_lock);
> > +}
> > +
> > +static void otx2_qos_destroy_node(struct otx2_nic *pfvf,
> > +				  struct otx2_qos_node *node)
> > +{
> > +	otx2_qos_free_hw_cfg(pfvf, node);
> > +	otx2_qos_free_sw_node(pfvf, node);
> > +}
> > +
> > +static void otx2_qos_fill_cfg_schq(struct otx2_qos_node *parent,
> > +				   struct otx2_qos_cfg *cfg)
> > +{
> > +	struct otx2_qos_node *node;
> > +
> > +	list_for_each_entry(node, &parent->child_schq_list, list)
> > +		cfg->schq[node->level]++;
> > +}
> > +
> > +static void otx2_qos_fill_cfg_tl(struct otx2_qos_node *parent,
> > +				 struct otx2_qos_cfg *cfg)
> > +{
> > +	struct otx2_qos_node *node;
> > +
> > +	list_for_each_entry(node, &parent->child_list, list) {
> > +		otx2_qos_fill_cfg_tl(node, cfg);
> > +		cfg->schq_contig[node->level]++;
> > +		otx2_qos_fill_cfg_schq(node, cfg);
> > +	}
> > +}
> > +
> > +static void otx2_qos_prepare_txschq_cfg(struct otx2_nic *pfvf,
> > +					struct otx2_qos_node *parent,
> > +					struct otx2_qos_cfg *cfg)
> > +{
> > +	mutex_lock(&pfvf->qos.qos_lock);
> > +	otx2_qos_fill_cfg_tl(parent, cfg);
> > +	mutex_unlock(&pfvf->qos.qos_lock);
> > +}
> > +
> > +static void otx2_qos_read_txschq_cfg_schq(struct otx2_qos_node
> *parent,
> > +					  struct otx2_qos_cfg *cfg)
> > +{
> > +	struct otx2_qos_node *node;
> > +	int cnt;
> > +
> > +	list_for_each_entry(node, &parent->child_schq_list, list) {
> > +		cnt =3D cfg->dwrr_node_pos[node->level];
> > +		cfg->schq_list[node->level][cnt] =3D node->schq;
> > +		cfg->schq[node->level]++;
> > +		cfg->dwrr_node_pos[node->level]++;
> > +	}
> > +}
> > +
> > +static void otx2_qos_read_txschq_cfg_tl(struct otx2_qos_node *parent,
> > +					struct otx2_qos_cfg *cfg)
> > +{
> > +	struct otx2_qos_node *node;
> > +	int cnt;
> > +
> > +	list_for_each_entry(node, &parent->child_list, list) {
> > +		otx2_qos_read_txschq_cfg_tl(node, cfg);
> > +		cnt =3D cfg->static_node_pos[node->level];
> > +		cfg->schq_contig_list[node->level][cnt] =3D node->schq;
> > +		cfg->schq_contig[node->level]++;
> > +		cfg->static_node_pos[node->level]++;
> > +		otx2_qos_read_txschq_cfg_schq(node, cfg);
> > +	}
> > +}
> > +
> > +static void otx2_qos_read_txschq_cfg(struct otx2_nic *pfvf,
> > +				     struct otx2_qos_node *node,
> > +				     struct otx2_qos_cfg *cfg)
> > +{
> > +	mutex_lock(&pfvf->qos.qos_lock);
> > +	otx2_qos_read_txschq_cfg_tl(node, cfg);
> > +	mutex_unlock(&pfvf->qos.qos_lock);
> > +}
> > +
> > +static struct otx2_qos_node *
> > +otx2_qos_alloc_root(struct otx2_nic *pfvf)
> > +{
> > +	struct otx2_qos_node *node;
> > +
> > +	node =3D kzalloc(sizeof(*node), GFP_KERNEL);
> > +	if (!node)
> > +		return ERR_PTR(-ENOMEM);
> > +
> > +	node->parent =3D NULL;
> > +	if (!is_otx2_vf(pfvf->pcifunc))
> > +		node->level =3D NIX_TXSCH_LVL_TL1;
> > +	else
> > +		node->level =3D NIX_TXSCH_LVL_TL2;
> > +
> > +	node->qid =3D OTX2_QOS_QID_INNER;
> > +	node->classid =3D OTX2_QOS_ROOT_CLASSID;
> > +
> > +	hash_add(pfvf->qos.qos_hlist, &node->hlist, node->classid);
> > +	list_add_tail(&node->list, &pfvf->qos.qos_tree);
> > +	INIT_LIST_HEAD(&node->child_list);
> > +	INIT_LIST_HEAD(&node->child_schq_list);
> > +
> > +	return node;
> > +}
> > +
> > +static int otx2_qos_add_child_node(struct otx2_qos_node *parent,
> > +				   struct otx2_qos_node *node)
> > +{
> > +	struct list_head *head =3D &parent->child_list;
> > +	struct otx2_qos_node *tmp_node;
> > +	struct list_head *tmp;
> > +
> > +	for (tmp =3D head->next; tmp !=3D head; tmp =3D tmp->next) {
> > +		tmp_node =3D list_entry(tmp, struct otx2_qos_node, list);
> > +		if (tmp_node->prio =3D=3D node->prio)
> > +			return -EEXIST;
> > +		if (tmp_node->prio > node->prio) {
> > +			list_add_tail(&node->list, tmp);
> > +			return 0;
> > +		}
> > +	}
> > +
> > +	list_add_tail(&node->list, head);
> > +	return 0;
> > +}
> > +
> > +static int otx2_qos_alloc_txschq_node(struct otx2_nic *pfvf,
> > +				      struct otx2_qos_node *node)
> > +{
> > +	struct otx2_qos_node *txschq_node, *parent, *tmp;
> > +	int lvl;
> > +
> > +	parent =3D node;
> > +	for (lvl =3D node->level - 1; lvl >=3D NIX_TXSCH_LVL_MDQ; lvl--) {
> > +		txschq_node =3D kzalloc(sizeof(*txschq_node), GFP_KERNEL);
> > +		if (!txschq_node)
> > +			goto err_out;
> > +
> > +		txschq_node->parent =3D parent;
> > +		txschq_node->level =3D lvl;
> > +		txschq_node->classid =3D OTX2_QOS_CLASS_NONE;
> > +		txschq_node->qid =3D OTX2_QOS_QID_NONE;
> > +		txschq_node->rate =3D 0;
> > +		txschq_node->ceil =3D 0;
> > +		txschq_node->prio =3D 0;
> > +
> > +		mutex_lock(&pfvf->qos.qos_lock);
> > +		list_add_tail(&txschq_node->list, &node->child_schq_list);
> > +		mutex_unlock(&pfvf->qos.qos_lock);
> > +
> > +		INIT_LIST_HEAD(&txschq_node->child_list);
> > +		INIT_LIST_HEAD(&txschq_node->child_schq_list);
> > +		parent =3D txschq_node;
> > +	}
> > +
> > +	return 0;
> > +
> > +err_out:
> > +	list_for_each_entry_safe(txschq_node, tmp, &node-
> >child_schq_list,
> > +				 list) {
> > +		list_del(&txschq_node->list);
> > +		kfree(txschq_node);
> > +	}
> > +	return -ENOMEM;
> > +}
> > +
> > +static struct otx2_qos_node *
> > +otx2_qos_sw_create_leaf_node(struct otx2_nic *pfvf,
> > +			     struct otx2_qos_node *parent,
> > +			     u16 classid, u32 prio, u64 rate, u64 ceil,
> > +			     u16 qid)
> > +{
> > +	struct otx2_qos_node *node;
> > +	int err;
> > +
> > +	node =3D kzalloc(sizeof(*node), GFP_KERNEL);
> > +	if (!node)
> > +		return ERR_PTR(-ENOMEM);
> > +
> > +	node->parent =3D parent;
> > +	node->level =3D parent->level - 1;
> > +	node->classid =3D classid;
> > +	node->qid =3D qid;
> > +	node->rate =3D otx2_qos_convert_rate(rate);
> > +	node->ceil =3D otx2_qos_convert_rate(ceil);
> > +	node->prio =3D prio;
> > +
> > +	__set_bit(qid, pfvf->qos.qos_sq_bmap);
> > +
> > +	hash_add(pfvf->qos.qos_hlist, &node->hlist, classid);
> > +
> > +	mutex_lock(&pfvf->qos.qos_lock);
> > +	err =3D otx2_qos_add_child_node(parent, node);
> > +	if (err) {
> > +		mutex_unlock(&pfvf->qos.qos_lock);
> > +		return ERR_PTR(err);
> > +	}
> > +	mutex_unlock(&pfvf->qos.qos_lock);
> > +
> > +	INIT_LIST_HEAD(&node->child_list);
> > +	INIT_LIST_HEAD(&node->child_schq_list);
>=20
> Looks suspicious that some fields of node are initialized after
> otx2_qos_add_child_node is called.

" otx2_qos_add_child_node" tries to rearrange the node in linked list based=
 on node priority.
Here on success case we are calling INIT_LIST_HEAD.=20
Will move this logic inside the function.
>=20
> > +
> > +	err =3D otx2_qos_alloc_txschq_node(pfvf, node);
> > +	if (err) {
> > +		otx2_qos_sw_node_delete(pfvf, node);
> > +		return ERR_PTR(-ENOMEM);
> > +	}
> > +
> > +	return node;
> > +}
> > +
> > +static struct otx2_qos_node *
> > +otx2_sw_node_find(struct otx2_nic *pfvf, u32 classid)
> > +{
> > +	struct otx2_qos_node *node =3D NULL;
> > +
> > +	hash_for_each_possible(pfvf->qos.qos_hlist, node, hlist, classid) {
>=20
> This loop may be called from ndo_select_queue, while another thread may
> modify qos_hlist. We use RCU in mlx5e to protect this structure. What
> protects it in your driver?
>=20
We did not came across this case, as we normally wont delete the classes on=
 the fly.
Will test the scenario and update the patch.
> > +		if (node->classid =3D=3D classid)
> > +			break;
> > +	}
> > +
> > +	return node;
> > +}
> > +
> > +int otx2_get_txq_by_classid(struct otx2_nic *pfvf, u16 classid)
> > +{
> > +	struct otx2_qos_node *node;
> > +	u16 qid;
> > +	int res;
> > +
> > +	node =3D otx2_sw_node_find(pfvf, classid);
> > +	if (IS_ERR(node)) {
> > +		res =3D -ENOENT;
> > +		goto out;
> > +	}
> > +	qid =3D READ_ONCE(node->qid);
> > +	if (qid =3D=3D OTX2_QOS_QID_INNER) {
> > +		res =3D -EINVAL;
> > +		goto out;
> > +	}
> > +	res =3D pfvf->hw.tx_queues + qid;
> > +out:
> > +	return res;
> > +}
> > +
> > +static int
> > +otx2_qos_txschq_config(struct otx2_nic *pfvf, struct otx2_qos_node
> *node)
> > +{
> > +	struct mbox *mbox =3D &pfvf->mbox;
> > +	struct nix_txschq_config *req;
> > +	int rc;
> > +
> > +	mutex_lock(&mbox->lock);
> > +
> > +	req =3D otx2_mbox_alloc_msg_nix_txschq_cfg(&pfvf->mbox);
> > +	if (!req) {
> > +		mutex_unlock(&mbox->lock);
> > +		return -ENOMEM;
> > +	}
> > +
> > +	req->lvl =3D node->level;
> > +	__otx2_qos_txschq_cfg(pfvf, node, req);
> > +
> > +	rc =3D otx2_sync_mbox_msg(&pfvf->mbox);
> > +
> > +	mutex_unlock(&mbox->lock);
> > +
> > +	return rc;
> > +}
> > +
> > +static int otx2_qos_txschq_alloc(struct otx2_nic *pfvf,
> > +				 struct otx2_qos_cfg *cfg)
> > +{
> > +	struct nix_txsch_alloc_req *req;
> > +	struct nix_txsch_alloc_rsp *rsp;
> > +	struct mbox *mbox =3D &pfvf->mbox;
> > +	int lvl, rc, schq;
> > +
> > +	mutex_lock(&mbox->lock);
> > +	req =3D otx2_mbox_alloc_msg_nix_txsch_alloc(&pfvf->mbox);
> > +	if (!req) {
> > +		mutex_unlock(&mbox->lock);
> > +		return -ENOMEM;
> > +	}
> > +
> > +	for (lvl =3D 0; lvl < NIX_TXSCH_LVL_CNT; lvl++) {
> > +		req->schq[lvl] =3D cfg->schq[lvl];
> > +		req->schq_contig[lvl] =3D cfg->schq_contig[lvl];
> > +	}
> > +
> > +	rc =3D otx2_sync_mbox_msg(&pfvf->mbox);
> > +	if (rc) {
> > +		mutex_unlock(&mbox->lock);
> > +		return rc;
> > +	}
> > +
> > +	rsp =3D (struct nix_txsch_alloc_rsp *)
> > +	      otx2_mbox_get_rsp(&pfvf->mbox.mbox, 0, &req->hdr);
> > +
> > +	for (lvl =3D 0; lvl < NIX_TXSCH_LVL_CNT; lvl++) {
> > +		for (schq =3D 0; schq < rsp->schq_contig[lvl]; schq++) {
> > +			cfg->schq_contig_list[lvl][schq] =3D
> > +				rsp->schq_contig_list[lvl][schq];
> > +		}
> > +	}
> > +
> > +	for (lvl =3D 0; lvl < NIX_TXSCH_LVL_CNT; lvl++) {
> > +		for (schq =3D 0; schq < rsp->schq[lvl]; schq++) {
> > +			cfg->schq_list[lvl][schq] =3D
> > +				rsp->schq_list[lvl][schq];
> > +		}
> > +	}
> > +
> > +	pfvf->qos.link_cfg_lvl =3D rsp->link_cfg_lvl;
> > +
> > +	mutex_unlock(&mbox->lock);
> > +
> > +	return rc;
> > +}
> > +
> > +static void otx2_qos_txschq_fill_cfg_schq(struct otx2_nic *pfvf,
> > +					  struct otx2_qos_node *node,
> > +					  struct otx2_qos_cfg *cfg)
> > +{
> > +	struct otx2_qos_node *tmp;
> > +	int cnt;
> > +
> > +	list_for_each_entry(tmp, &node->child_schq_list, list) {
> > +		cnt =3D cfg->dwrr_node_pos[tmp->level];
> > +		tmp->schq =3D cfg->schq_list[tmp->level][cnt];
> > +		cfg->dwrr_node_pos[tmp->level]++;
> > +	}
> > +}
> > +
> > +static void otx2_qos_txschq_fill_cfg_tl(struct otx2_nic *pfvf,
> > +					struct otx2_qos_node *node,
> > +					struct otx2_qos_cfg *cfg)
> > +{
> > +	struct otx2_qos_node *tmp;
> > +	int cnt;
> > +
> > +	list_for_each_entry(tmp, &node->child_list, list) {
> > +		otx2_qos_txschq_fill_cfg_tl(pfvf, tmp, cfg);
> > +		cnt =3D cfg->static_node_pos[tmp->level];
> > +		tmp->schq =3D cfg->schq_contig_list[tmp->level][cnt];
> > +		if (cnt =3D=3D 0)
> > +			node->prio_anchor =3D tmp->schq;
> > +		cfg->static_node_pos[tmp->level]++;
> > +		otx2_qos_txschq_fill_cfg_schq(pfvf, tmp, cfg);
> > +	}
> > +}
> > +
> > +static void otx2_qos_txschq_fill_cfg(struct otx2_nic *pfvf,
> > +				     struct otx2_qos_node *node,
> > +				     struct otx2_qos_cfg *cfg)
> > +{
> > +	mutex_lock(&pfvf->qos.qos_lock);
> > +	otx2_qos_txschq_fill_cfg_tl(pfvf, node, cfg);
> > +	otx2_qos_txschq_fill_cfg_schq(pfvf, node, cfg);
> > +	mutex_unlock(&pfvf->qos.qos_lock);
> > +}
> > +
> > +static int otx2_qos_txschq_push_cfg_schq(struct otx2_nic *pfvf,
> > +					 struct otx2_qos_node *node,
> > +					 struct otx2_qos_cfg *cfg)
> > +{
> > +	struct otx2_qos_node *tmp;
> > +	int ret =3D 0;
> > +
> > +	list_for_each_entry(tmp, &node->child_schq_list, list) {
> > +		ret =3D otx2_qos_txschq_config(pfvf, tmp);
> > +		if (ret)
> > +			return -EIO;
> > +		ret =3D otx2_qos_txschq_set_parent_topology(pfvf, tmp-
> >parent);
> > +		if (ret)
> > +			return -EIO;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static int otx2_qos_txschq_push_cfg_tl(struct otx2_nic *pfvf,
> > +				       struct otx2_qos_node *node,
> > +				       struct otx2_qos_cfg *cfg)
> > +{
> > +	struct otx2_qos_node *tmp;
> > +	int ret;
> > +
> > +	list_for_each_entry(tmp, &node->child_list, list) {
> > +		ret =3D otx2_qos_txschq_push_cfg_tl(pfvf, tmp, cfg);
> > +		if (ret)
> > +			return -EIO;
> > +		ret =3D otx2_qos_txschq_config(pfvf, tmp);
> > +		if (ret)
> > +			return -EIO;
> > +		ret =3D otx2_qos_txschq_push_cfg_schq(pfvf, tmp, cfg);
> > +		if (ret)
> > +			return -EIO;
> > +	}
> > +
> > +	ret =3D otx2_qos_txschq_set_parent_topology(pfvf, node);
> > +	if (ret)
> > +		return -EIO;
> > +
> > +	return 0;
> > +}
> > +
> > +static int otx2_qos_txschq_push_cfg(struct otx2_nic *pfvf,
> > +				    struct otx2_qos_node *node,
> > +				    struct otx2_qos_cfg *cfg)
> > +{
> > +	int ret;
> > +
> > +	mutex_lock(&pfvf->qos.qos_lock);
> > +	ret =3D otx2_qos_txschq_push_cfg_tl(pfvf, node, cfg);
> > +	if (ret)
> > +		goto out;
> > +	ret =3D otx2_qos_txschq_push_cfg_schq(pfvf, node, cfg);
> > +out:
> > +	mutex_unlock(&pfvf->qos.qos_lock);
> > +	return ret;
> > +}
> > +
> > +static int otx2_qos_txschq_update_config(struct otx2_nic *pfvf,
> > +					 struct otx2_qos_node *node,
> > +					 struct otx2_qos_cfg *cfg)
> > +{
> > +	otx2_qos_txschq_fill_cfg(pfvf, node, cfg);
> > +
> > +	return otx2_qos_txschq_push_cfg(pfvf, node, cfg);
> > +}
> > +
> > +static int otx2_qos_txschq_update_root_cfg(struct otx2_nic *pfvf,
> > +					   struct otx2_qos_node *root,
> > +					   struct otx2_qos_cfg *cfg)
> > +{
> > +	root->schq =3D cfg->schq_list[root->level][0];
> > +	return otx2_qos_txschq_config(pfvf, root);
> > +}
> > +
> > +static void otx2_qos_free_cfg(struct otx2_nic *pfvf, struct otx2_qos_c=
fg
> *cfg)
> > +{
> > +	int lvl, idx, schq;
> > +
> > +	for (lvl =3D 0; lvl < NIX_TXSCH_LVL_CNT; lvl++) {
> > +		for (idx =3D 0; idx < cfg->schq[lvl]; idx++) {
> > +			schq =3D cfg->schq_list[lvl][idx];
> > +			otx2_txschq_free_one(pfvf, lvl, schq);
> > +		}
> > +	}
> > +
> > +	for (lvl =3D 0; lvl < NIX_TXSCH_LVL_CNT; lvl++) {
> > +		for (idx =3D 0; idx < cfg->schq_contig[lvl]; idx++) {
> > +			schq =3D cfg->schq_contig_list[lvl][idx];
> > +			otx2_txschq_free_one(pfvf, lvl, schq);
> > +		}
> > +	}
> > +}
> > +
> > +static void otx2_qos_enadis_sq(struct otx2_nic *pfvf,
> > +			       struct otx2_qos_node *node,
> > +			       u16 qid)
> > +{
> > +	if (pfvf->qos.qid_to_sqmap[qid] !=3D OTX2_QOS_INVALID_SQ)
> > +		otx2_qos_disable_sq(pfvf, qid);
> > +
> > +	pfvf->qos.qid_to_sqmap[qid] =3D node->schq;
> > +	otx2_qos_enable_sq(pfvf, qid);
> > +}
> > +
> > +static void otx2_qos_update_smq_schq(struct otx2_nic *pfvf,
> > +				     struct otx2_qos_node *node,
> > +				     bool action)
> > +{
> > +	struct otx2_qos_node *tmp;
> > +
> > +	if (node->qid =3D=3D OTX2_QOS_QID_INNER)
> > +		return;
> > +
> > +	list_for_each_entry(tmp, &node->child_schq_list, list) {
> > +		if (tmp->level =3D=3D NIX_TXSCH_LVL_MDQ) {
> > +			if (action =3D=3D QOS_SMQ_FLUSH)
> > +				otx2_smq_flush(pfvf, tmp->schq);
> > +			else
> > +				otx2_qos_enadis_sq(pfvf, tmp, node->qid);
> > +		}
> > +	}
> > +}
> > +
> > +static void __otx2_qos_update_smq(struct otx2_nic *pfvf,
> > +				  struct otx2_qos_node *node,
> > +				  bool action)
> > +{
> > +	struct otx2_qos_node *tmp;
> > +
> > +	list_for_each_entry(tmp, &node->child_list, list) {
> > +		__otx2_qos_update_smq(pfvf, tmp, action);
> > +		if (tmp->qid =3D=3D OTX2_QOS_QID_INNER)
> > +			continue;
> > +		if (tmp->level =3D=3D NIX_TXSCH_LVL_MDQ) {
> > +			if (action =3D=3D QOS_SMQ_FLUSH)
> > +				otx2_smq_flush(pfvf, tmp->schq);
> > +			else
> > +				otx2_qos_enadis_sq(pfvf, tmp, tmp->qid);
> > +		} else {
> > +			otx2_qos_update_smq_schq(pfvf, tmp, action);
> > +		}
> > +	}
> > +}
> > +
> > +static void otx2_qos_update_smq(struct otx2_nic *pfvf,
> > +				struct otx2_qos_node *node,
> > +				bool action)
> > +{
> > +	mutex_lock(&pfvf->qos.qos_lock);
> > +	__otx2_qos_update_smq(pfvf, node, action);
> > +	otx2_qos_update_smq_schq(pfvf, node, action);
> > +	mutex_unlock(&pfvf->qos.qos_lock);
> > +}
> > +
> > +static int otx2_qos_push_txschq_cfg(struct otx2_nic *pfvf,
> > +				    struct otx2_qos_node *node,
> > +				    struct otx2_qos_cfg *cfg)
> > +{
> > +	int ret =3D 0;
> > +
> > +	ret =3D otx2_qos_txschq_alloc(pfvf, cfg);
> > +	if (ret)
> > +		return -ENOSPC;
> > +
> > +	if (!(pfvf->netdev->flags & IFF_UP)) {
> > +		otx2_qos_txschq_fill_cfg(pfvf, node, cfg);
> > +		return 0;
> > +	}
> > +
> > +	ret =3D otx2_qos_txschq_update_config(pfvf, node, cfg);
> > +	if (ret) {
> > +		otx2_qos_free_cfg(pfvf, cfg);
> > +		return -EIO;
> > +	}
> > +
> > +	otx2_qos_update_smq(pfvf, node, QOS_CFG_SQ);
> > +
> > +	return 0;
> > +}
> > +
> > +static int otx2_qos_update_tree(struct otx2_nic *pfvf,
> > +				struct otx2_qos_node *node,
> > +				struct otx2_qos_cfg *cfg)
> > +{
> > +	otx2_qos_prepare_txschq_cfg(pfvf, node->parent, cfg);
> > +	return otx2_qos_push_txschq_cfg(pfvf, node->parent, cfg);
> > +}
> > +
> > +static int otx2_qos_root_add(struct otx2_nic *pfvf, u16 htb_maj_id, u1=
6
> htb_defcls,
> > +			     struct netlink_ext_ack *extack)
> > +{
> > +	struct otx2_qos_cfg *new_cfg;
> > +	struct otx2_qos_node *root;
> > +	int err;
> > +
> > +	netdev_dbg(pfvf->netdev,
> > +		   "TC_HTB_CREATE: handle=3D0x%x defcls=3D0x%x\n",
> > +		   htb_maj_id, htb_defcls);
> > +
> > +	INIT_LIST_HEAD(&pfvf->qos.qos_tree);
> > +	mutex_init(&pfvf->qos.qos_lock);
> > +
> > +	root =3D otx2_qos_alloc_root(pfvf);
> > +	if (IS_ERR(root)) {
> > +		mutex_destroy(&pfvf->qos.qos_lock);
> > +		err =3D PTR_ERR(root);
> > +		return err;
> > +	}
> > +
> > +	/* allocate txschq queue */
> > +	new_cfg =3D kzalloc(sizeof(*new_cfg), GFP_KERNEL);
> > +	if (!new_cfg) {
> > +		NL_SET_ERR_MSG_MOD(extack, "Memory allocation
> error");
> > +		mutex_destroy(&pfvf->qos.qos_lock);
> > +		return -ENOMEM;
> > +	}
> > +	/* allocate htb root node */
> > +	new_cfg->schq[root->level] =3D 1;
> > +	err =3D otx2_qos_txschq_alloc(pfvf, new_cfg);
> > +	if (err) {
> > +		NL_SET_ERR_MSG_MOD(extack, "Error allocating txschq");
> > +		goto free_root_node;
> > +	}
> > +
> > +	if (!(pfvf->netdev->flags & IFF_UP) ||
> > +	    root->level =3D=3D NIX_TXSCH_LVL_TL1) {
> > +		root->schq =3D new_cfg->schq_list[root->level][0];
> > +		goto out;
> > +	}
> > +
> > +	/* update the txschq configuration in hw */
> > +	err =3D otx2_qos_txschq_update_root_cfg(pfvf, root, new_cfg);
> > +	if (err) {
> > +		NL_SET_ERR_MSG_MOD(extack,
> > +				   "Error updating txschq configuration");
> > +		goto txschq_free;
> > +	}
> > +
> > +out:
> > +	WRITE_ONCE(pfvf->qos.defcls, htb_defcls);
> > +	smp_store_release(&pfvf->qos.maj_id, htb_maj_id); /* barrier */
> > +	kfree(new_cfg);
> > +	return 0;
> > +
> > +txschq_free:
> > +	otx2_qos_free_cfg(pfvf, new_cfg);
> > +free_root_node:
> > +	kfree(new_cfg);
> > +	otx2_qos_sw_node_delete(pfvf, root);
> > +	mutex_destroy(&pfvf->qos.qos_lock);
> > +	return err;
> > +}
> > +
> > +static int otx2_qos_root_destroy(struct otx2_nic *pfvf)
> > +{
> > +	struct otx2_qos_node *root;
> > +
> > +	netdev_dbg(pfvf->netdev, "TC_HTB_DESTROY\n");
> > +
> > +	/* find root node */
> > +	root =3D otx2_sw_node_find(pfvf, OTX2_QOS_ROOT_CLASSID);
> > +	if (IS_ERR(root))
> > +		return -ENOENT;
> > +
> > +	/* free the hw mappings */
> > +	otx2_qos_destroy_node(pfvf, root);
> > +	mutex_destroy(&pfvf->qos.qos_lock);
> > +
> > +	return 0;
> > +}
> > +
> > +static int otx2_qos_validate_configuration(struct otx2_qos_node
> *parent,
> > +					   struct netlink_ext_ack *extack,
> > +					   struct otx2_nic *pfvf,
> > +					   u64 prio)
> > +{
> > +	if (test_bit(prio, parent->prio_bmap)) {
> > +		NL_SET_ERR_MSG_MOD(extack,
> > +				   "Static priority child with same priority
> exists");
> > +		return -EEXIST;
> > +	}
> > +
> > +	if (prio =3D=3D TXSCH_TL1_DFLT_RR_PRIO) {
> > +		NL_SET_ERR_MSG_MOD(extack,
> > +				   "Priority is reserved for Round Robin");
> > +		return -EINVAL;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static int otx2_qos_leaf_alloc_queue(struct otx2_nic *pfvf, u16 classi=
d,
> > +				     u32 parent_classid, u64 rate, u64 ceil,
> > +				     u64 prio, struct netlink_ext_ack *extack)
> > +{
> > +	struct otx2_qos_cfg *old_cfg, *new_cfg;
> > +	struct otx2_qos_node *node, *parent;
> > +	int qid, ret, err;
> > +
> > +	netdev_dbg(pfvf->netdev,
> > +		   "TC_HTB_LEAF_ALLOC_QUEUE: classid=3D0x%x
> parent_classid=3D0x%x rate=3D%lld ceil=3D%lld prio=3D%lld\n",
> > +		   classid, parent_classid, rate, ceil, prio);
> > +
> > +	if (prio > OTX2_QOS_MAX_PRIO) {
> > +		NL_SET_ERR_MSG_MOD(extack, "Valid priority range 0 to
> 7");
> > +		ret =3D -EOPNOTSUPP;
> > +		goto out;
> > +	}
> > +
> > +	/* get parent node */
> > +	parent =3D otx2_sw_node_find(pfvf, parent_classid);
> > +	if (IS_ERR(parent)) {
> > +		NL_SET_ERR_MSG_MOD(extack, "parent node not found");
> > +		ret =3D -ENOENT;
> > +		goto out;
> > +	}
> > +	if (parent->level =3D=3D NIX_TXSCH_LVL_MDQ) {
> > +		NL_SET_ERR_MSG_MOD(extack, "HTB qos max levels
> reached");
> > +		ret =3D -EOPNOTSUPP;
> > +		goto out;
> > +	}
> > +
> > +	ret =3D otx2_qos_validate_configuration(parent, extack, pfvf, prio);
> > +	if (ret)
> > +		goto out;
> > +
> > +	set_bit(prio, parent->prio_bmap);
> > +
> > +	/* read current txschq configuration */
> > +	old_cfg =3D kzalloc(sizeof(*old_cfg), GFP_KERNEL);
> > +	if (!old_cfg) {
> > +		NL_SET_ERR_MSG_MOD(extack, "Memory allocation
> error");
> > +		ret =3D -ENOMEM;
> > +		goto out;
> > +	}
> > +	otx2_qos_read_txschq_cfg(pfvf, parent, old_cfg);
> > +
> > +	/* allocate a new sq */
> > +	qid =3D otx2_qos_get_qid(pfvf);
> > +	if (qid < 0) {
> > +		NL_SET_ERR_MSG_MOD(extack, "Reached max supported
> QOS SQ's");
> > +		ret =3D -ENOMEM;
> > +		goto free_old_cfg;
> > +	}
> > +
> > +	/* Actual SQ mapping will be updated after SMQ alloc */
> > +	pfvf->qos.qid_to_sqmap[qid] =3D OTX2_QOS_INVALID_SQ;
> > +
> > +	/* allocate and initialize a new child node */
> > +	node =3D otx2_qos_sw_create_leaf_node(pfvf, parent, classid, prio,
> rate,
> > +					    ceil, qid);
> > +	if (IS_ERR(node)) {
> > +		NL_SET_ERR_MSG_MOD(extack, "Unable to allocate leaf
> node");
> > +		ret =3D PTR_ERR(node);
> > +		goto free_old_cfg;
> > +	}
> > +
> > +	/* push new txschq config to hw */
> > +	new_cfg =3D kzalloc(sizeof(*new_cfg), GFP_KERNEL);
> > +	if (!new_cfg) {
> > +		NL_SET_ERR_MSG_MOD(extack, "Memory allocation
> error");
> > +		ret =3D -ENOMEM;
> > +		goto free_node;
> > +	}
> > +	ret =3D otx2_qos_update_tree(pfvf, node, new_cfg);
> > +	if (ret) {
> > +		NL_SET_ERR_MSG_MOD(extack, "HTB HW configuration
> error");
> > +		kfree(new_cfg);
> > +		otx2_qos_sw_node_delete(pfvf, node);
> > +		/* restore the old qos tree */
> > +		err =3D otx2_qos_txschq_update_config(pfvf, parent, old_cfg);
> > +		if (err) {
> > +			netdev_err(pfvf->netdev,
> > +				   "Failed to restore txcshq configuration");
> > +			goto free_old_cfg;
> > +		}
> > +
> > +		otx2_qos_update_smq(pfvf, parent, QOS_CFG_SQ);
> > +		goto free_old_cfg;
> > +	}
> > +
> > +	/* update tx_real_queues */
> > +	otx2_qos_update_tx_netdev_queues(pfvf);
> > +
> > +	/* free new txschq config */
> > +	kfree(new_cfg);
> > +
> > +	/* free old txschq config */
> > +	otx2_qos_free_cfg(pfvf, old_cfg);
> > +	kfree(old_cfg);
> > +
> > +	return pfvf->hw.tx_queues + qid;
> > +
> > +free_node:
> > +	otx2_qos_sw_node_delete(pfvf, node);
> > +free_old_cfg:
> > +	kfree(old_cfg);
> > +out:
> > +	return ret;
> > +}
> > +
> > +static int otx2_qos_leaf_to_inner(struct otx2_nic *pfvf, u16 classid,
> > +				  u16 child_classid, u64 rate, u64 ceil, u64 prio,
> > +				  struct netlink_ext_ack *extack)
> > +{
> > +	struct otx2_qos_cfg *old_cfg, *new_cfg;
> > +	struct otx2_qos_node *node, *child;
> > +	int ret, err;
> > +	u16 qid;
> > +
> > +	netdev_dbg(pfvf->netdev,
> > +		   "TC_HTB_LEAF_TO_INNER classid %04x, child %04x, rate
> %llu, ceil %llu\n",
> > +		   classid, child_classid, rate, ceil);
> > +
> > +	if (prio > OTX2_QOS_MAX_PRIO) {
> > +		NL_SET_ERR_MSG_MOD(extack, "Valid priority range 0 to
> 7");
> > +		ret =3D -EOPNOTSUPP;
> > +		goto out;
> > +	}
> > +
> > +	/* find node related to classid */
> > +	node =3D otx2_sw_node_find(pfvf, classid);
> > +	if (IS_ERR(node)) {
> > +		NL_SET_ERR_MSG_MOD(extack, "HTB node not found");
> > +		ret =3D -ENOENT;
> > +		goto out;
> > +	}
> > +	/* check max qos txschq level */
> > +	if (node->level =3D=3D NIX_TXSCH_LVL_MDQ) {
> > +		NL_SET_ERR_MSG_MOD(extack, "HTB qos level not
> supported");
> > +		ret =3D -EOPNOTSUPP;
> > +		goto out;
> > +	}
> > +
> > +	set_bit(prio, node->prio_bmap);
> > +
> > +	/* store the qid to assign to leaf node */
> > +	qid =3D node->qid;
> > +
> > +	/* read current txschq configuration */
> > +	old_cfg =3D kzalloc(sizeof(*old_cfg), GFP_KERNEL);
> > +	if (!old_cfg) {
> > +		NL_SET_ERR_MSG_MOD(extack, "Memory allocation
> error");
> > +		ret =3D -ENOMEM;
> > +		goto out;
> > +	}
> > +	otx2_qos_read_txschq_cfg(pfvf, node, old_cfg);
> > +
> > +	/* delete the txschq nodes allocated for this node */
> > +	otx2_qos_free_sw_node_schq(pfvf, node);
> > +
> > +	/* mark this node as htb inner node */
> > +	node->qid =3D OTX2_QOS_QID_INNER;
>=20
> As you can concurrently read node->qid from the datapath
> (ndo_select_queue), you should use READ_ONCE/WRITE_ONCE to
> guarantee
> that the value will not be torn; you already use READ_ONCE, but it
> doesn't pair with a WRITE_ONCE here.
>=20
ACK, will update the suggested change.

Thanks,
Hariprasad k
> > +
> > +	/* allocate and initialize a new child node */
> > +	child =3D otx2_qos_sw_create_leaf_node(pfvf, node, child_classid,
> > +					     prio, rate, ceil, qid);
> > +	if (IS_ERR(child)) {
> > +		NL_SET_ERR_MSG_MOD(extack, "Unable to allocate leaf
> node");
> > +		ret =3D PTR_ERR(child);
> > +		goto free_old_cfg;
> > +	}
> > +
> > +	/* push new txschq config to hw */
> > +	new_cfg =3D kzalloc(sizeof(*new_cfg), GFP_KERNEL);
> > +	if (!new_cfg) {
> > +		NL_SET_ERR_MSG_MOD(extack, "Memory allocation
> error");
> > +		ret =3D -ENOMEM;
> > +		goto free_node;
> > +	}
> > +	ret =3D otx2_qos_update_tree(pfvf, child, new_cfg);
> > +	if (ret) {
> > +		NL_SET_ERR_MSG_MOD(extack, "HTB HW configuration
> error");
> > +		kfree(new_cfg);
> > +		otx2_qos_sw_node_delete(pfvf, child);
> > +		/* restore the old qos tree */
> > +		node->qid =3D qid;
>=20
> Same here; might be somewhere else as well.
>=20
> > +		err =3D otx2_qos_alloc_txschq_node(pfvf, node);
> > +		if (err) {
> > +			netdev_err(pfvf->netdev,
> > +				   "Failed to restore old leaf node");
> > +			goto free_old_cfg;
> > +		}
> > +		err =3D otx2_qos_txschq_update_config(pfvf, node, old_cfg);
> > +		if (err) {
> > +			netdev_err(pfvf->netdev,
> > +				   "Failed to restore txcshq configuration");
> > +			goto free_old_cfg;
> > +		}
> > +		otx2_qos_update_smq(pfvf, node, QOS_CFG_SQ);
> > +		goto free_old_cfg;
> > +	}
> > +
> > +	/* free new txschq config */
> > +	kfree(new_cfg);
> > +
> > +	/* free old txschq config */
> > +	otx2_qos_free_cfg(pfvf, old_cfg);
> > +	kfree(old_cfg);
> > +
> > +	return 0;
> > +
> > +free_node:
> > +	otx2_qos_sw_node_delete(pfvf, child);
> > +free_old_cfg:
> > +	kfree(old_cfg);
> > +out:
> > +	return ret;
> > +}
> > +
> > +static int otx2_qos_leaf_del(struct otx2_nic *pfvf, u16 *classid,
> > +			     struct netlink_ext_ack *extack)
> > +{
> > +	struct otx2_qos_node *node, *parent;
> > +	u64 prio;
> > +	u16 qid;
> > +
> > +	netdev_dbg(pfvf->netdev, "TC_HTB_LEAF_DEL classid %04x\n",
> *classid);
> > +
> > +	/* find node related to classid */
> > +	node =3D otx2_sw_node_find(pfvf, *classid);
> > +	if (IS_ERR(node)) {
> > +		NL_SET_ERR_MSG_MOD(extack, "HTB node not found");
> > +		return -ENOENT;
> > +	}
> > +	parent =3D node->parent;
> > +	prio   =3D node->prio;
> > +	qid    =3D node->qid;
> > +
> > +	otx2_qos_disable_sq(pfvf, node->qid);
> > +
> > +	otx2_qos_destroy_node(pfvf, node);
> > +	pfvf->qos.qid_to_sqmap[qid] =3D OTX2_QOS_INVALID_SQ;
> > +
> > +	clear_bit(prio, parent->prio_bmap);
> > +
> > +	return 0;
> > +}
> > +
> > +static int otx2_qos_leaf_del_last(struct otx2_nic *pfvf, u16 classid, =
bool
> force,
> > +				  struct netlink_ext_ack *extack)
> > +{
> > +	struct otx2_qos_node *node, *parent;
> > +	struct otx2_qos_cfg *new_cfg;
> > +	u64 prio;
> > +	int err;
> > +	u16 qid;
> > +
> > +	netdev_dbg(pfvf->netdev,
> > +		   "TC_HTB_LEAF_DEL_LAST classid %04x\n", classid);
> > +
> > +	/* find node related to classid */
> > +	node =3D otx2_sw_node_find(pfvf, classid);
> > +	if (IS_ERR(node)) {
> > +		NL_SET_ERR_MSG_MOD(extack, "HTB node not found");
> > +		return -ENOENT;
> > +	}
> > +
> > +	/* save qid for use by parent */
> > +	qid =3D node->qid;
> > +	prio =3D node->prio;
> > +
> > +	parent =3D otx2_sw_node_find(pfvf, node->parent->classid);
> > +	if (IS_ERR(parent)) {
> > +		NL_SET_ERR_MSG_MOD(extack, "parent node not found");
> > +		return -ENOENT;
> > +	}
> > +
> > +	/* destroy the leaf node */
> > +	otx2_qos_destroy_node(pfvf, node);
> > +	pfvf->qos.qid_to_sqmap[qid] =3D OTX2_QOS_INVALID_SQ;
> > +
> > +	clear_bit(prio, parent->prio_bmap);
> > +
> > +	/* create downstream txschq entries to parent */
> > +	err =3D otx2_qos_alloc_txschq_node(pfvf, parent);
> > +	if (err) {
> > +		NL_SET_ERR_MSG_MOD(extack, "HTB failed to create txsch
> configuration");
> > +		return err;
> > +	}
> > +	parent->qid =3D qid;
> > +	__set_bit(qid, pfvf->qos.qos_sq_bmap);
> > +
> > +	/* push new txschq config to hw */
> > +	new_cfg =3D kzalloc(sizeof(*new_cfg), GFP_KERNEL);
> > +	if (!new_cfg) {
> > +		NL_SET_ERR_MSG_MOD(extack, "Memory allocation
> error");
> > +		return -ENOMEM;
> > +	}
> > +	/* fill txschq cfg and push txschq cfg to hw */
> > +	otx2_qos_fill_cfg_schq(parent, new_cfg);
> > +	err =3D otx2_qos_push_txschq_cfg(pfvf, parent, new_cfg);
> > +	if (err) {
> > +		NL_SET_ERR_MSG_MOD(extack, "HTB HW configuration
> error");
> > +		kfree(new_cfg);
> > +		return err;
> > +	}
> > +	kfree(new_cfg);
> > +
> > +	/* update tx_real_queues */
> > +	otx2_qos_update_tx_netdev_queues(pfvf);
> > +
> > +	return 0;
> > +}
> > +
> > +void otx2_clean_qos_queues(struct otx2_nic *pfvf)
> > +{
> > +	struct otx2_qos_node *root;
> > +
> > +	root =3D otx2_sw_node_find(pfvf, OTX2_QOS_ROOT_CLASSID);
> > +	if (IS_ERR(root))
> > +		return;
> > +
> > +	otx2_qos_update_smq(pfvf, root, QOS_SMQ_FLUSH);
> > +}
> > +
> > +void otx2_qos_config_txschq(struct otx2_nic *pfvf)
> > +{
> > +	struct otx2_qos_node *root;
> > +	int err;
> > +
> > +	root =3D otx2_sw_node_find(pfvf, OTX2_QOS_ROOT_CLASSID);
> > +	if (IS_ERR(root))
> > +		return;
> > +
> > +	err =3D otx2_qos_txschq_config(pfvf, root);
> > +	if (err) {
> > +		netdev_err(pfvf->netdev, "Error update txschq
> configuration\n");
> > +		goto root_destroy;
> > +	}
> > +
> > +	err =3D otx2_qos_txschq_push_cfg_tl(pfvf, root, NULL);
> > +	if (err) {
> > +		netdev_err(pfvf->netdev, "Error update txschq
> configuration\n");
> > +		goto root_destroy;
> > +	}
> > +
> > +	otx2_qos_update_smq(pfvf, root, QOS_CFG_SQ);
> > +	return;
> > +
> > +root_destroy:
> > +	netdev_err(pfvf->netdev, "Failed to update Scheduler/Shaping
> config in Hardware\n");
> > +	/* Free resources allocated */
> > +	otx2_qos_root_destroy(pfvf);
> > +}
> > +
> > +int otx2_setup_tc_htb(struct net_device *ndev, struct
> tc_htb_qopt_offload *htb)
> > +{
> > +	struct otx2_nic *pfvf =3D netdev_priv(ndev);
> > +	int res;
> > +
> > +	switch (htb->command) {
> > +	case TC_HTB_CREATE:
> > +		return otx2_qos_root_add(pfvf, htb->parent_classid,
> > +					 htb->classid, htb->extack);
> > +	case TC_HTB_DESTROY:
> > +		return otx2_qos_root_destroy(pfvf);
> > +	case TC_HTB_LEAF_ALLOC_QUEUE:
> > +		res =3D otx2_qos_leaf_alloc_queue(pfvf, htb->classid,
> > +						htb->parent_classid,
> > +						htb->rate, htb->ceil,
> > +						htb->prio, htb->extack);
> > +		if (res < 0)
> > +			return res;
> > +		htb->qid =3D res;
> > +		return 0;
> > +	case TC_HTB_LEAF_TO_INNER:
> > +		return otx2_qos_leaf_to_inner(pfvf, htb->parent_classid,
> > +					      htb->classid, htb->rate,
> > +					      htb->ceil, htb->prio,
> > +					      htb->extack);
> > +	case TC_HTB_LEAF_DEL:
> > +		return otx2_qos_leaf_del(pfvf, &htb->classid, htb->extack);
> > +	case TC_HTB_LEAF_DEL_LAST:
> > +	case TC_HTB_LEAF_DEL_LAST_FORCE:
> > +		return otx2_qos_leaf_del_last(pfvf, htb->classid,
> > +				htb->command =3D=3D
> TC_HTB_LEAF_DEL_LAST_FORCE,
> > +					      htb->extack);
> > +	case TC_HTB_LEAF_QUERY_QUEUE:
> > +		res =3D otx2_get_txq_by_classid(pfvf, htb->classid);
> > +		htb->qid =3D res;
> > +		return 0;
> > +	case TC_HTB_NODE_MODIFY:
> > +		fallthrough;
> > +	default:
> > +		return -EOPNOTSUPP;
> > +	}
> > +}
> > diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/qos.h
> b/drivers/net/ethernet/marvell/octeontx2/nic/qos.h
> > index 73a62d092e99..26de1af2aa57 100644
> > --- a/drivers/net/ethernet/marvell/octeontx2/nic/qos.h
> > +++ b/drivers/net/ethernet/marvell/octeontx2/nic/qos.h
> > @@ -7,13 +7,63 @@
> >  #ifndef OTX2_QOS_H
> >  #define OTX2_QOS_H
> >
> > +#include <linux/types.h>
> > +#include <linux/netdevice.h>
> > +#include <linux/rhashtable.h>
> > +
> > +#define OTX2_QOS_MAX_LVL		4
> > +#define OTX2_QOS_MAX_PRIO		7
> >  #define OTX2_QOS_MAX_LEAF_NODES                16
> >
> > -int otx2_qos_enable_sq(struct otx2_nic *pfvf, int qidx, u16 smq);
> > -void otx2_qos_disable_sq(struct otx2_nic *pfvf, int qidx, u16 mdq);
> > +enum qos_smq_operations {
> > +	QOS_CFG_SQ,
> > +	QOS_SMQ_FLUSH,
> > +};
> > +
> > +u64 otx2_get_txschq_rate_regval(struct otx2_nic *nic, u64 maxrate, u32
> burst);
> > +
> > +int otx2_setup_tc_htb(struct net_device *ndev, struct
> tc_htb_qopt_offload *htb);
> > +int otx2_qos_get_qid(struct otx2_nic *pfvf);
> > +void otx2_qos_free_qid(struct otx2_nic *pfvf, int qidx);
> > +int otx2_qos_enable_sq(struct otx2_nic *pfvf, int qidx);
> > +void otx2_qos_disable_sq(struct otx2_nic *pfvf, int qidx);
> > +
> > +struct otx2_qos_cfg {
> > +	u16 schq[NIX_TXSCH_LVL_CNT];
> > +	u16 schq_contig[NIX_TXSCH_LVL_CNT];
> > +	int static_node_pos[NIX_TXSCH_LVL_CNT];
> > +	int dwrr_node_pos[NIX_TXSCH_LVL_CNT];
> > +	u16
> schq_contig_list[NIX_TXSCH_LVL_CNT][MAX_TXSCHQ_PER_FUNC];
> > +	u16 schq_list[NIX_TXSCH_LVL_CNT][MAX_TXSCHQ_PER_FUNC];
> > +};
> >
> >  struct otx2_qos {
> > -	       u16 qid_to_sqmap[OTX2_QOS_MAX_LEAF_NODES];
> > -	};
> > +	DECLARE_HASHTABLE(qos_hlist,
> order_base_2(OTX2_QOS_MAX_LEAF_NODES));
> > +	struct mutex qos_lock; /* child list lock */
> > +	u16 qid_to_sqmap[OTX2_QOS_MAX_LEAF_NODES];
> > +	struct list_head qos_tree;
> > +	DECLARE_BITMAP(qos_sq_bmap, OTX2_QOS_MAX_LEAF_NODES);
> > +	u16 maj_id;
> > +	u16 defcls;
> > +	u8  link_cfg_lvl; /* LINKX_CFG CSRs mapped to TL3 or TL2's index ? */
> > +};
> > +
> > +struct otx2_qos_node {
> > +	struct list_head list; /* list managment */
> > +	struct list_head child_list;
> > +	struct list_head child_schq_list;
> > +	struct hlist_node hlist;
> > +	DECLARE_BITMAP(prio_bmap, OTX2_QOS_MAX_PRIO + 1);
> > +	struct otx2_qos_node *parent;	/* parent qos node */
> > +	u64 rate; /* htb params */
> > +	u64 ceil;
> > +	u32 classid;
> > +	u32 prio;
> > +	u16 schq; /* hw txschq */
> > +	u16 qid;
> > +	u16 prio_anchor;
> > +	u8 level;
> > +};
> > +
> >
> >  #endif
> > diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/qos_sq.c
> b/drivers/net/ethernet/marvell/octeontx2/nic/qos_sq.c
> > index 1c77f024c360..8a1e89668a1b 100644
> > --- a/drivers/net/ethernet/marvell/octeontx2/nic/qos_sq.c
> > +++ b/drivers/net/ethernet/marvell/octeontx2/nic/qos_sq.c
> > @@ -225,7 +225,22 @@ static int otx2_qos_ctx_disable(struct otx2_nic
> *pfvf, u16 qidx, int aura_id)
> >  	return otx2_sync_mbox_msg(&pfvf->mbox);
> >  }
> >
> > -int otx2_qos_enable_sq(struct otx2_nic *pfvf, int qidx, u16 smq)
> > +int otx2_qos_get_qid(struct otx2_nic *pfvf)
> > +{
> > +	int qidx;
> > +
> > +	qidx =3D find_first_zero_bit(pfvf->qos.qos_sq_bmap,
> > +				   pfvf->hw.tc_tx_queues);
> > +
> > +	return qidx =3D=3D pfvf->hw.tc_tx_queues ? -ENOSPC : qidx;
> > +}
> > +
> > +void otx2_qos_free_qid(struct otx2_nic *pfvf, int qidx)
> > +{
> > +	clear_bit(qidx, pfvf->qos.qos_sq_bmap);
> > +}
> > +
> > +int otx2_qos_enable_sq(struct otx2_nic *pfvf, int qidx)
> >  {
> >  	struct otx2_hw *hw =3D &pfvf->hw;
> >  	int pool_id, sq_idx, err;
> > @@ -241,7 +256,6 @@ int otx2_qos_enable_sq(struct otx2_nic *pfvf, int
> qidx, u16 smq)
> >  		goto out;
> >
> >  	pool_id =3D otx2_get_pool_idx(pfvf, AURA_NIX_SQ, sq_idx);
> > -	pfvf->qos.qid_to_sqmap[qidx] =3D smq;
> >  	err =3D otx2_sq_init(pfvf, sq_idx, pool_id);
> >  	if (err)
> >  		goto out;
> > @@ -250,7 +264,7 @@ int otx2_qos_enable_sq(struct otx2_nic *pfvf, int
> qidx, u16 smq)
> >  	return err;
> >  }
> >
> > -void otx2_qos_disable_sq(struct otx2_nic *pfvf, int qidx, u16 mdq)
> > +void otx2_qos_disable_sq(struct otx2_nic *pfvf, int qidx)
> >  {
> >  	struct otx2_qset *qset =3D &pfvf->qset;
> >  	struct otx2_hw *hw =3D &pfvf->hw;
> > --
> > 2.17.1
> >
