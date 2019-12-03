Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFE0510FB6C
	for <lists+netdev@lfdr.de>; Tue,  3 Dec 2019 11:09:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726363AbfLCKJu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 05:09:50 -0500
Received: from sv2-smtprelay2.synopsys.com ([149.117.73.133]:58480 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725773AbfLCKJt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Dec 2019 05:09:49 -0500
X-Greylist: delayed 571 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Dec 2019 05:09:49 EST
Received: from mailhost.synopsys.com (badc-mailhost1.synopsys.com [10.192.0.17])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 1A621423C7;
        Tue,  3 Dec 2019 10:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1575367218; bh=p4fNW1DhwZ6b5GUS8EdoAe3HfsVHzWMGiWcLSWI1Fo4=;
        h=From:To:CC:Subject:Date:From;
        b=baztmieFmE1FUL6CCVnIByp+i0NL68vnMmV2DSILJ0fRbyGGscS/L7wS52Tawbjry
         Umvds+7qDWyXR8yuXYHy7QcMtoHwHFCYQA8bYok9o7DbogVbSJkViMlNqUGh/kJr8f
         yneY3vM8gDlAtPxAxHht3GxlPPf9cFqTTUaOsdnLTfq4FzPGE3xCLxOMEP2/0+HGhL
         axPwRUAXXNTezixuPyqljNS83Qxe+JXXngV7qDVCFZhv9grdFzwa4wDVQGLo2UEj68
         8Cxbk2PF+36a4MDHaVlu0Eh97ciepbUjalKlGnb/VjJ+zyeX3PTM7dWm0b3+NVfHd7
         I9te/VRCvDIUw==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id CC462A03B3;
        Tue,  3 Dec 2019 10:00:17 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Tue, 3 Dec 2019 02:00:17 -0800
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (10.202.3.67) by
 mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Tue, 3 Dec 2019 02:00:17 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ludMbu4IztGeKt67yN160/TY7SJereyoFFJI1enVkyqgCCkg4IgzLZHwzgKWFwoCYN6Vll+snEj5ZvV5sHTU5IaIr+zhL0sUuDpIYDVYI8J/lTvYI+PWPIXWGEu4NMQwiSu08HdIR7lY/OZZeb2nMQI6rNk32ho/JgCL9xoCWd5+WG1rCKx01HNDaGawN1texwjMd6gCZYd0zDrYHF0bpb5g6SwZkKx5e5fjd9lYt9GndRyEtLpD6E9GgkN1+bMTJ18wd57M0bN2DEP3cGvriun0YYNxYqEbyKkbwbU3+cVBTEvUDh54wO5hzn6Bh1YrlG5q9huKDiVD26drhP8Vpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3wzxAzP2WqKHEGQEYVCIqLbZpZAueRZVcaZQaCyq4zI=;
 b=Hcb5E52r+YyGhTI3F9nMiapDvUPkFpu6oWG+W8C5S17UVIXirY2dWhfLRdCMk+tCB172jbO8WaMSJgzQnpV5IDFgL6DJiEbFMI0fb6c6/MwPudznyoSSjTWVQpcUBTW5BvoZ+mYmsLsDBiAcuUAgYUV3QNROVO43Sd/oPXBgM/ZoicQC2s2a8A7yiJ8G7Rc2xcT7uOseBKLLIu7E35Y/vApQtBvCU7vsSoYOA5MbRkBKbGNEAeOTewFPsZV35qUebEtu9N7I212M1ii4uh0x6ABQG2fjBSFwFM41Rs56Ul1vonSSMQD+svTij7ZxXJzy21YvQ7rE8xo25IQcQDk+7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector2-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3wzxAzP2WqKHEGQEYVCIqLbZpZAueRZVcaZQaCyq4zI=;
 b=TPk4Jj7EQf+CV5ASSymIU7J4OeLG63MDSgf8Y3z2856mGukTgJv6yVTczmN60JNwyfq4+1LywNa+Apgr33apUi3Q6HMnOenkRQLgJbY15OsUlBDedp+oe6t7G4UifupSsVQ8BPldrabnL8g8nWXKzNY7NdE9lU9Ivc2xwXyjbb4=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.67.145) by
 BN8PR12MB3089.namprd12.prod.outlook.com (20.178.210.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2495.21; Tue, 3 Dec 2019 10:00:16 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::3d20:3a36:3b64:4510]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::3d20:3a36:3b64:4510%7]) with mapi id 15.20.2516.003; Tue, 3 Dec 2019
 10:00:15 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jesus Sanchez-Palencia <jesus.sanchez-palencia@intel.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: tperf: An initial TSN Performance Utility
Thread-Topic: tperf: An initial TSN Performance Utility
Thread-Index: AdWpvq0AbHwx928HRWCrJZjwLL/Eqw==
Date:   Tue, 3 Dec 2019 10:00:15 +0000
Message-ID: <BN8PR12MB3266E99E5C289CB6B77A5C58D3420@BN8PR12MB3266.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b3cf1a3c-92e7-46d3-5edd-08d777d79895
x-ms-traffictypediagnostic: BN8PR12MB3089:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR12MB3089E432BB45B08835C02AB5D3420@BN8PR12MB3089.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 02408926C4
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(136003)(366004)(396003)(346002)(376002)(52254002)(189003)(199004)(81156014)(33656002)(8936002)(81166006)(1730700003)(71200400001)(64756008)(71190400001)(66446008)(2906002)(305945005)(66556008)(4326008)(7696005)(6436002)(7736002)(2351001)(66946007)(6116002)(66476007)(74316002)(9686003)(5640700003)(3846002)(6306002)(76116006)(55016002)(6916009)(102836004)(4744005)(52536014)(5660300002)(186003)(316002)(54906003)(26005)(86362001)(256004)(966005)(14454004)(25786009)(2501003)(6506007)(99286004)(478600001)(8676002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB3089;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: k1iOLZln5M8wABp6lenKSK4r7H+TwCODssxbv1giTDRLSOkjOQ7C5jtp+9F0GAS60MTCPMl/7o0q4HQk38alMUxmbPUZW1wYFZ8Bc3zs0tbxGXYY4zouBZyOVRh6q8As6XvlLpWqAgH5U32wopM/AO4rEvECxFctWFwM6Y8w0n6pgJpgK6vWEzDWNiKmwbo0jCACAUaWxOc6yRhXfhYmE3WY2jkC0Hnexkr7rO8qNj73yhckJVWkl9y4k2ZIG3gg0nkVclCdsUppZizfIfdQIDt1bIIrPtwe2NCQvqYKh4xjNYBLbwUT82uuvuX/RuksX/4OOqNh4dd4RleyQ6KAtz8W3+vAUaFuUzdxT0GzcXm9zEXG9B9eJMoBB27yHtuVoNwWFcvj0YrSShWcjmo57VBplyorq7pTj7wJ1z2+S7wHPZw1kyJvtb8P81MTQx1w4KnThRWmcadW0dAwR/W3hFcorah7yzgzvlDzQXeRbdM=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: b3cf1a3c-92e7-46d3-5edd-08d777d79895
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Dec 2019 10:00:15.6315
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ipL7SDEhOGb+iz2k6/opI4kQ4Ec6hV+TIbPcPIHpiP42qSYKNEfErfX3vahpuOod0jYA+lJ7nyWcMy7q1kKuMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3089
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi netdev,

[ I added in cc the people I know that work with TSN stuff, please add=20
anyone interested ]

We are currently using a very basic tool for monitoring the CBS=20
performance of Synopsys-based NICs which we called tperf. This was based=20
on a patchset submitted by Jesus back in 2017 so credits to him and=20
blames on me :)

The current version tries to send "dummy" AVTP packets, and measures the=20
bandwidth of both receiver and sender. By using this tool in conjunction=20
with iperf3 we can check if CBS reserved queues are behaving correctly=20
by reserving the priority traffic for AVTP packets.

You can checkout the tool in the following address:
	GitHub: https://github.com/joabreu/tperf

We are open to improve this to more robust scenarios, so that we can=20
have a common tool for TSN testing that's at the same time light=20
weighted and precise.

Anyone interested in helping ?

---
Thanks,
Jose Miguel Abreu
