Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F8EF6E8B48
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 09:22:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234036AbjDTHWD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 03:22:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234033AbjDTHWB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 03:22:01 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 703041713;
        Thu, 20 Apr 2023 00:21:57 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33K5hnKx005280;
        Thu, 20 Apr 2023 00:21:43 -0700
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2045.outbound.protection.outlook.com [104.47.57.45])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3q2917xxe6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Apr 2023 00:21:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ae/BIQ9z4AxQHNk0JUhKklJgb8hErgcjXG3rWRvqLWgtCpuK6np/3IfGfruaUDKlKveBUXnERMl5mLUidl9E4BvlzhfHB2ShZ7HepnPMFQO5J25EtE/eOBylqXukNDFQqXnGJEvRYQgcXZ5wAlQfQhl38iD93dIrSYsFvbHMaixRru8mo+QsMyM6jvVAjtRhVo+lGLMWCVFjuGqk2HKSo+xDcx/lYuMm6X3rRLM1miMlbaF+geAenWqxfgj1cJfJ05GnNS6JTLsbcN1M59mnYuhSYhTNQUuFUTcgQTBD4XknrrI025wl6HCiLHP3I0mQgpMo0LZHVtnrwieqH8BXbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Tp2Or4dZBxnhZ1YchOVOqzJLkxgnExjS5Vop3Hdq7KU=;
 b=j4ReAoqv7su/ri4Z3iE1AcE86oixnKnnEx8ZJ8U25v94UJkqmnzMdEmPLZYiXHQ7fZKBhNVrm0oSRsw3bLlBRUzarArj4nz7u5BxVhohbneJ1nc8eK4Jxba93EX7RukQAvrFXAmi1qtu2fQ3ufBk81yT6P5F2mGF/1R//7xTbTXrMf9g+yb8PzzpuIgsQe0A4m8eO8bk8MatkWQW6yEGN8OhBg0gu79z5afT2IJApW3HUZx443iSjIgw99xtlMe7Cxa6Nhs3GJ9lltgELiTt33mE/QR5GJlrFBG2XakJwvWdmIU7doDBgBW1Bh8xRpJnvTwpRzLjzVwptXRX9Q8T1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tp2Or4dZBxnhZ1YchOVOqzJLkxgnExjS5Vop3Hdq7KU=;
 b=FyZ9LfJWvgXpc7MWOtMyLM3JVMAlb7RVh9ZFiUymeSAGrJJd4PEv2jDVy4VQH1hflZyBXYM/3ZzxfVkDiWRSoJKkm/XhbNK50s4IFROgSv3tyaHUNGBzEzASxUBpVCjQodpuLHdJw1CDrd3gd/bsYm5XZCHq/ZfbI80EoHcHC6M=
Received: from BY3PR18MB4707.namprd18.prod.outlook.com (2603:10b6:a03:3ca::23)
 by CH0PR18MB4291.namprd18.prod.outlook.com (2603:10b6:610:bb::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Thu, 20 Apr
 2023 07:21:40 +0000
Received: from BY3PR18MB4707.namprd18.prod.outlook.com
 ([fe80::e907:e8ce:db04:b353]) by BY3PR18MB4707.namprd18.prod.outlook.com
 ([fe80::e907:e8ce:db04:b353%4]) with mapi id 15.20.6319.021; Thu, 20 Apr 2023
 07:21:40 +0000
From:   Sai Krishna Gajula <saikrishnag@marvell.com>
To:     Simon Horman <simon.horman@corigine.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "leon@kernel.org" <leon@kernel.org>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Jerin Jacob Kollanukkaran <jerinj@marvell.com>,
        Hariprasad Kelam <hkelam@marvell.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>
Subject: Re: [net PATCH v3 10/10] octeontx2-pf: Disable packet I/O for
 graceful exit
Thread-Topic: [net PATCH v3 10/10] octeontx2-pf: Disable packet I/O for
 graceful exit
Thread-Index: AQHZc1i/gnFrwFaccUCAsSMTLCDfZA==
Date:   Thu, 20 Apr 2023 07:21:39 +0000
Message-ID: <BY3PR18MB4707BAD375592CB7441488B3A0639@BY3PR18MB4707.namprd18.prod.outlook.com>
References: <20230419062018.286136-1-saikrishnag@marvell.com>
 <20230419062018.286136-11-saikrishnag@marvell.com>
 <ZD/KklR3coHRY580@corigine.com>
In-Reply-To: <ZD/KklR3coHRY580@corigine.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcc2Fpa3Jpc2hu?=
 =?us-ascii?Q?YWdcYXBwZGF0YVxyb2FtaW5nXDA5ZDg0OWI2LTMyZDMtNGE0MC04NWVlLTZi?=
 =?us-ascii?Q?ODRiYTI5ZTM1Ylxtc2dzXG1zZy1mYzVmOTYwNC1kZjRiLTExZWQtYWQxYy0x?=
 =?us-ascii?Q?Y2MxMGM0MGQ5ZTRcYW1lLXRlc3RcZmM1Zjk2MDYtZGY0Yi0xMWVkLWFkMWMt?=
 =?us-ascii?Q?MWNjMTBjNDBkOWU0Ym9keS50eHQiIHN6PSIzNjI0IiB0PSIxMzMyNjQ0ODg5?=
 =?us-ascii?Q?NzgxNzYxMjAiIGg9IkovY1ArQWJNbzhROGR3bUtocnFZbzBCb0JiST0iIGlk?=
 =?us-ascii?Q?PSIiIGJsPSIwIiBibz0iMSIgY2k9ImNBQUFBRVJIVTFSU1JVRk5DZ1VBQUhZ?=
 =?us-ascii?Q?SUFBQjQyTGUrV0hQWkFXSXNEdDdVYm9WQllpd08zdFJ1aFVFTkFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFIQUFBQUFHQ0FBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFFQUFRQUJBQUFBbzlpamZRQUFBQUFBQUFBQUFBQUFBSjRBQUFCaEFH?=
 =?us-ascii?Q?UUFaQUJ5QUdVQWN3QnpBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUVBQUFBQUFBQUFBZ0FBQUFBQW5nQUFBR01BZFFCekFIUUFid0J0QUY4?=
 =?us-ascii?Q?QWNBQmxBSElBY3dCdkFHNEFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQVFBQUFBQUFBQUFBQUFBQUFRQUFBQUFBQUFB?=
 =?us-ascii?Q?Q0FBQUFBQUNlQUFBQVl3QjFBSE1BZEFCdkFHMEFYd0J3QUdnQWJ3QnVBR1VB?=
 =?us-ascii?Q?YmdCMUFHMEFZZ0JsQUhJQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFCQUFBQUFBQUFBQUlBQUFBQUFKNEFBQUJq?=
 =?us-ascii?Q?QUhVQWN3QjBBRzhBYlFCZkFITUFjd0J1QUY4QVpBQmhBSE1BYUFCZkFIWUFN?=
 =?us-ascii?Q?QUF5QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-rorf: true
x-dg-refone: =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBRUFBQUFBQUFBQUFnQUFBQUFBbmdB?=
 =?us-ascii?Q?QUFHTUFkUUJ6QUhRQWJ3QnRBRjhBY3dCekFHNEFYd0JyQUdVQWVRQjNBRzhB?=
 =?us-ascii?Q?Y2dCa0FITUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQVFBQUFBQUFBQUFDQUFBQUFBQ2VBQUFBWXdCMUFITUFkQUJ2?=
 =?us-ascii?Q?QUcwQVh3QnpBSE1BYmdCZkFHNEFid0JrQUdVQWJBQnBBRzBBYVFCMEFHVUFj?=
 =?us-ascii?Q?Z0JmQUhZQU1BQXlBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUJBQUFB?=
 =?us-ascii?Q?QUFBQUFBSUFBQUFBQUo0QUFBQmpBSFVBY3dCMEFHOEFiUUJmQUhNQWN3QnVB?=
 =?us-ascii?Q?RjhBY3dCd0FHRUFZd0JsQUY4QWRnQXdBRElBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFFQUFBQUFBQUFBQWdBQUFBQUFu?=
 =?us-ascii?Q?Z0FBQUdRQWJBQndBRjhBY3dCckFIa0FjQUJsQUY4QVl3Qm9BR0VBZEFCZkFH?=
 =?us-ascii?Q?MEFaUUJ6QUhNQVlRQm5BR1VBWHdCMkFEQUFNZ0FBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBUUFBQUFBQUFBQUNBQUFBQUFDZUFBQUFaQUJzQUhBQVh3?=
 =?us-ascii?Q?QnpBR3dBWVFCakFHc0FYd0JqQUdnQVlRQjBBRjhBYlFCbEFITUFjd0JoQUdj?=
 =?us-ascii?Q?QVpRQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-reftwo: =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQkFBQUFBQUFBQUFJQUFBQUFBSjRBQUFCa0FHd0Fj?=
 =?us-ascii?Q?QUJmQUhRQVpRQmhBRzBBY3dCZkFHOEFiZ0JsQUdRQWNnQnBBSFlBWlFCZkFH?=
 =?us-ascii?Q?WUFhUUJzQUdVQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUVBQUFBQUFBQUFBZ0FBQUFBQW5nQUFBR1VBYlFCaEFHa0FiQUJmQUdFQVpB?=
 =?us-ascii?Q?QmtBSElBWlFCekFITUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBRXdBQUFBQUFBQUFBQUFBQUFRQUFBQUFBQUFBQ0FB?=
 =?us-ascii?Q?QUFBQUNlQUFBQWJRQmhBSElBZGdCbEFHd0FiQUJmQUhBQWNnQnZBR29BWlFC?=
 =?us-ascii?Q?akFIUUFYd0JqQUc4QVpBQmxBSE1BQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFCQUFBQUFBQUFBQUlBQUFBQUFKNEFBQUJ0QUdF?=
 =?us-ascii?Q?QWNnQjJBR1VBYkFCc0FGOEFkQUJsQUhJQWJRQnBBRzRBZFFCekFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBRUFBQUFBQUFBQUFnQUFBQUFBIi8+PC9tZXRhPg=3D=3D?=
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY3PR18MB4707:EE_|CH0PR18MB4291:EE_
x-ms-office365-filtering-correlation-id: 7d1039e7-a742-439f-3dfa-08db416fe283
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ThlJFNcuZBGcyctJCDEVNjL43LvG3kpFjmsU4A0YW+keH3YMyjGGsU+xd6bXCBMfJoK5M7G0Oae+VbbmjX2V1KIMUagWBCWRfYACN3TRmLTX3Vl9zQVmKhL3Hl6ehZ/47h63kGI6GUigcOSS3eV94l6Z8JuQxUFsHUEDCrMqT7UVuosHPgcPzeXq4g48QpXUoD5nPd9v5a/RfMK1U26FYjIAzCME2VkJrkX+nyMwmL5hqemMp4Oj8U0g/6GOei77T6m98L+DSJTbaxYsBZ88pfTANzr0YcPekazKtIF1zuoeTb3Sk90k1/2Ez2uOd3QGlSL8Oz+Pi97pp304XPIJVN2W/YghRp511JhBq+DkHxRmW74VMlrxE7WllZCHxyVe3Iyggbsggk5Y+H3XoTiTV7XUjQzND17lhS2ppW8Jx7XsCprA4ZFHFVueagdJoP2LYYXqgMb+Evzn2d3x8MQzXlUVc2kp3MeZXkCdtfEt3L4Wtne0V83rweRvwvl3l77xBaTYvPbZKErwzivjmhWMLMEupoCH3KJN9lj+Jo9KG+7RsMhz286ZCaBKWGF4nnG0XNgvw4hwphC26KtPdDz16jbMW3kzOTSOuQHG302Xb4A6gHYWS04RdwX3eUw4HaMg
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR18MB4707.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(39860400002)(346002)(366004)(376002)(136003)(451199021)(66556008)(54906003)(66446008)(4326008)(6916009)(316002)(64756008)(76116006)(66946007)(66476007)(478600001)(71200400001)(7696005)(55016003)(41300700001)(8676002)(8936002)(5660300002)(2906002)(52536014)(122000001)(38070700005)(86362001)(33656002)(38100700002)(26005)(6506007)(107886003)(9686003)(53546011)(186003)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?TlzSa/l1GZrIoWv/FDKJxzz1oUedfSWZ2BStT7x8yWRxQWAmqL7ryTUuKlOd?=
 =?us-ascii?Q?hZu5NXhcCdhvzCDT4fZrEaz/nggCVou3sWorWT76m/WkTCCbRiew20asPd6Q?=
 =?us-ascii?Q?9VnmPzqeptc/QGN3w220FPoesFfIjVip7N8TIcs5lryu6mdECUoEJLxSnKpA?=
 =?us-ascii?Q?YEaC8eUo+kyp01nRVl00IhIqmY7m+DIifEYlEo3eElEoOumMDQ+oWJBfHThH?=
 =?us-ascii?Q?UBQ/iBHH62d6YyGhyleFjPhml+WZkBEAN3CUZnUlx9rNangMbr8e5qOuKZcu?=
 =?us-ascii?Q?QVYzAutZTl6O4ZyfZCg6mcOw6wkQ+SoZT1SRFDMa1/NSg/MXfJndLvnW7Eji?=
 =?us-ascii?Q?9gbDv6B5brlF3SislXJ+9BFafM3BH5V7Vrtiqu2R6hkgyE+qY0k4kxg6+3P9?=
 =?us-ascii?Q?b22AxkOPpyQo52JtG5O8ap09rVyOOMWuhOuyKFFngF/Wlay848Q91IZ2VOdj?=
 =?us-ascii?Q?zz4WBoJYTDi4123Bq6w8YcPn6rcch3hTNBX1qRVFajwumgaFVdlilFyBGOpC?=
 =?us-ascii?Q?47F8LX8ZYoz4gi49hy4UuxlfqJJYFtqWRrvzg0xBtLKA488inf73Mh7QhoOa?=
 =?us-ascii?Q?2EeaVY3VBRfKhWQGfEE3ITesCeF0thIVp1qYCvAhos5lTAL+XrU+YG7CubZi?=
 =?us-ascii?Q?F71hVA3uc/yXXPJJKabJHcB3778MIDUgFzcVQXzEEKi9D8Hi4S1CjeWumsRr?=
 =?us-ascii?Q?Yva3IZPqceeEzsOro/BcNFx0wbzYhWYQmSXQRUpMwUqgcRIjtTThHD4kQd1L?=
 =?us-ascii?Q?auRK4kZog8PJ04xoD2HPTDi0g2t1Icr+pSbq2D8m/j9VjsdICIbxGtlWiIIs?=
 =?us-ascii?Q?t9uTZISpo6kPYDdCAT5kPGMegVKhYJjYL6T5Z9sMaCaJT7UM/U0MHgDHbMaE?=
 =?us-ascii?Q?GqcfmCE/QM8Rrz8YDWdZG3Cgi0ZaWpRMgOegMELm2Cgx0Ta4ByuVfvnaq0J2?=
 =?us-ascii?Q?rhNtPM8NFy0uV5A8sFxaagfnGfuaXb7NbVq1n2tQFaSkXRjJ4Qp+Ao2nX664?=
 =?us-ascii?Q?G7yh9HwUYz6KQYqg/0pAjMGIgNnhi4bHbjNb2qDxAZaaUhKy7HU4w3s5GN4T?=
 =?us-ascii?Q?o1OpNiQpFnYz42u7XCCwgjwM4Oc7AD064R5e1gbmxp13nE9jSKULMz9VK7Ep?=
 =?us-ascii?Q?oKFjIzdRCYVI3krEm/U3hH+ggH7cWHZMmtP4FM8soQbFc302oWX1Jm4mFmjD?=
 =?us-ascii?Q?cTPzM0xJcfECqI7Mwbev2TISLaBIsxb+ZkGL28L9zcgSAiBOx5iS+i8OcU/x?=
 =?us-ascii?Q?Dry67AyCN/w8TJXg0GU5OY5mPiYkNhvEXvzmb5wPPhKdr10yMXl3xPiyYeaY?=
 =?us-ascii?Q?mr7j1xIz8km9HBtCAKaVP0tsKJlbERiGijdRMwA9CNiXVgge9/BBU7g8F3Vh?=
 =?us-ascii?Q?cZwBAPD7s9Muo7nO5sZIDofGfq4ulcUOSQ5nwtss4hpeVYKGUB+ey/8gYE9Q?=
 =?us-ascii?Q?4Cm7GjwK1FIArF1jumKFI0L+pV5V0S1PHa5o+YptPOUPTCMLdUaBkEn5ec41?=
 =?us-ascii?Q?1DHFzLUkXQygLp/geg5+gDCEYBwc1SXdkeGhhFg3hQr7nxpJyfZcyKwE8aki?=
 =?us-ascii?Q?Yj6U7L6vqMsMfZcp78x19HO7cv7wHn+ukYz/5jCQ?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY3PR18MB4707.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d1039e7-a742-439f-3dfa-08db416fe283
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Apr 2023 07:21:39.9985
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ukGsTnAVKZZAJwyqAe35LCDo/x2nJWCrA5ylPiuz6+3qFrpxr2heahzFcwFpzwcrPeIgsb30+y7WHZ3tmYA3Tg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR18MB4291
X-Proofpoint-GUID: WCPzR3f_qly64L5sVJZigh6-FzVKP876
X-Proofpoint-ORIG-GUID: WCPzR3f_qly64L5sVJZigh6-FzVKP876
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-20_04,2023-04-18_01,2023-02-09_01
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> -----Original Message-----
> From: Simon Horman <simon.horman@corigine.com>
> Sent: Wednesday, April 19, 2023 4:34 PM
> To: Sai Krishna Gajula <saikrishnag@marvell.com>
> Cc: davem@davemloft.net; edumazet@google.com; kuba@kernel.org;
> pabeni@redhat.com; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; leon@kernel.org; Sunil Kovvuri Goutham
> <sgoutham@marvell.com>; Geethasowjanya Akula <gakula@marvell.com>;
> Linu Cherian <lcherian@marvell.com>; Jerin Jacob Kollanukkaran
> <jerinj@marvell.com>; Hariprasad Kelam <hkelam@marvell.com>;
> Subbaraya Sundeep Bhatta <sbhatta@marvell.com>
> Subject: Re: [net PATCH v3 10/10] octeontx2-pf: Disable packet I/O for
> graceful exit
>=20
> On Wed, Apr 19, 2023 at 11:50:18AM +0530, Sai Krishna wrote:
> > From: Subbaraya Sundeep <sbhatta@marvell.com>
> >
> > At the stage of enabling packet I/O in otx2_open, If mailbox timeout
> > occurs then interface ends up in down state where as hardware packet
> > I/O is enabled. Hence disable packet I/O also before bailing out.
> >
> > Fixes: 1ea0166da050 ("octeontx2-pf: Fix the device state on error")
> > Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
> > Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
> > Signed-off-by: Sai Krishna <saikrishnag@marvell.com>
> > ---
> >  drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c | 11 ++++++++++-
> > drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c |  2 +-
> >  2 files changed, 11 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
> > b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
> > index 179433d0a54a..52a57d2493dc 100644
> > --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
> > +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
> > @@ -1835,13 +1835,22 @@ int otx2_open(struct net_device *netdev)
> >  		otx2_dmacflt_reinstall_flows(pf);
> >
> >  	err =3D otx2_rxtx_enable(pf, true);
> > -	if (err)
> > +	/* If a mbox communication error happens at this point then
> interface
> > +	 * will end up in a state such that it is in down state but hardware
> > +	 * mcam entries are enabled to receive the packets. Hence disable
> the
> > +	 * packet I/O.
> > +	 */
> > +	if (err =3D=3D EIO)
> > +		goto err_disable_rxtx;
> > +	else if (err)
> >  		goto err_tx_stop_queues;
> >
> >  	otx2_do_set_rx_mode(pf);
> >
> >  	return 0;
> >
> > +err_disable_rxtx:
> > +	otx2_rxtx_enable(pf, false);
> >  err_tx_stop_queues:
> >  	netif_tx_stop_all_queues(netdev);
> >  	netif_carrier_off(netdev);
> > diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
> > b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
> > index ab126f8706c7..53366dbfbf27 100644
> > --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
> > +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
> > @@ -621,7 +621,7 @@ static int otx2vf_probe(struct pci_dev *pdev,
> > const struct pci_device_id *id)
> >
> >  	err =3D otx2vf_realloc_msix_vectors(vf);
> >  	if (err)
> > -		goto err_mbox_destroy;
> > +		goto err_detach_rsrc;
>=20
> I think it would be worth expanding on this part of the change in the com=
mit
> message. Because it's not obvious to me.
> And I do wonder if it is a separate fix.
>=20
We will expand on the commit message and explain about this in v4 patch.

Thanks,
Sai
> r
> >
> >  	err =3D otx2_set_real_num_queues(netdev, qcount, qcount);
> >  	if (err)
> > --
> > 2.25.1
> >
