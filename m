Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEF511E67D9
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 18:55:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405225AbgE1Qyz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 12:54:55 -0400
Received: from mail-vi1eur05on2051.outbound.protection.outlook.com ([40.107.21.51]:56800
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2405105AbgE1Qyx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 12:54:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=af76WyXklX3R0D21SKHiKgGwSZz5OM6HXq0kBgxjhzX8VsZs6kPNJbKyYNZiQjdttc83mPwHENPEC1ysc6mSB5uBZgq0v/FGJb839X74cKPwhRzHCHFkITG3OurDOIQLkv4UDsSfu1fGnsPeTiTkG62gdfNFuQ5c4CDE5YGI+e9oc7V29bhmhQ3exl1mgnf35PhXxiPfy+63LgLtuwj7otn7wYiXA94HYMlptHsTVjHlHkpzJinvf6xh3+/zqJ364I934X27+Kb5SOq9fo1WvXOEduixpTV/fr46RcT8TtgH+gyF94Vn5gnlF4g7Tn0BbLIqOKU3ICLdhyWOmLe40w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=klgEudrBym9jMJnS+aUN0gBSuyK7tMSq3Omma7msgSU=;
 b=ATnO6yXWEuPZPoqFphftzKAlLenMPU+uwbMccvTOOCTnUDgrHT636Jh213WA8rImyuDkyoMWB+ZSjakNKlyu53a5VlyE17css1ZKLSAJxDTuQULD3JTcDa8JRaL6sP3csPvbMOipQqMpRJk57lCeAzVvCcznGVsC7hA8QkRyGE5/m5BfK4tOP0WbtpV39T56mk5DoYCyYZq/oPAbS14WzE7AN3tHZ14cFkx2TbPtbl8pJMxizjHvNzd6HOCqbJpNExSQdptNjoiYcpg+P7FKKcF/EMARf6X7JUlCIg/juXSYjnmj17Q5im4BtHzelJ71Yk1yIOYi+3oGvbdmU1J5/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=klgEudrBym9jMJnS+aUN0gBSuyK7tMSq3Omma7msgSU=;
 b=Af7oH4MRMli+jZhqFTDcn5A0LAnoPgLcxJU4/BQbkHL/f6y+5oT6oJ2ihdKzSh9XgB9jHmmuOic0k9LoXJSkPfkPSB14YXzL9rCWE90FDsCg8MWWof2IyDlvelgsURng3N1Y8l+2upQIZ7Cvn7Q/E8KQHnfR6vTVxNjX9qWwJ88=
Authentication-Results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none
 header.from=mellanox.com;
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR05MB4651.eurprd05.prod.outlook.com (2603:10a6:7:a2::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3021.27; Thu, 28 May 2020 16:54:27 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::9de2:ec4b:e521:eece]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::9de2:ec4b:e521:eece%5]) with mapi id 15.20.3045.018; Thu, 28 May 2020
 16:54:27 +0000
References: <AM0PR0502MB38261D4F4F7A3BB5E0FDCD10D7B10@AM0PR0502MB3826.eurprd05.prod.outlook.com> <20200527213843.GC818296@lunn.ch> <AM0PR0502MB38267B345D7829A00790285DD78E0@AM0PR0502MB3826.eurprd05.prod.outlook.com> <87zh9stocb.fsf@mellanox.com> <20200528154010.GD840827@lunn.ch>
User-agent: mu4e 1.3.3; emacs 26.3
From:   Petr Machata <petrm@mellanox.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Amit Cohen <amitc@mellanox.com>, mlxsw <mlxsw@mellanox.com>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "o.rempel\@pengutronix.de" <o.rempel@pengutronix.de>
Subject: Re: Link down reasons
In-reply-to: <20200528154010.GD840827@lunn.ch>
Date:   Thu, 28 May 2020 18:54:24 +0200
Message-ID: <87r1v4t2yn.fsf@mellanox.com>
Content-Type: text/plain
X-ClientProxiedBy: AM0PR10CA0038.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::18) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from yaviefel (213.220.234.169) by AM0PR10CA0038.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:150::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17 via Frontend Transport; Thu, 28 May 2020 16:54:26 +0000
X-Originating-IP: [213.220.234.169]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 53ceff18-1e7b-4dad-2024-08d80327c812
X-MS-TrafficTypeDiagnostic: HE1PR05MB4651:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB465181903EA78A0E9FB07AF9DB8E0@HE1PR05MB4651.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 0417A3FFD2
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9BbE3trzCbrbkVeou71i5uepv/aeOaDbKxOF/xds7munVWKAbonQBnYa6GJEwYYAZEsPXD3TmcjDM9/GNHThxJkkkcWmwmn6rCrUrY8tYGhtc5J6Oizz06ebzsPKasW5licWQ2LW1m8TM6bzv+MZHoaQu0PhhwfYdVnJ4wetALjASxfsJWBXigyfPnNO2oI7Ey+FzkGEk/m8lJUy5+g1168bIz5KsrBqikvWtuw0wvGu+6o3uXJgTvn6rN04TEU2WbuTlxtAHFUCOjpzvkppJ/jqTcaurxMzvANHD0WIXpGFuoYKxdsuS6EMYfvnL+4bJ5uclR5WhKYtKATLhOBzKQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(39860400002)(346002)(136003)(366004)(376002)(8936002)(83380400001)(16526019)(7116003)(6916009)(52116002)(6496006)(4326008)(26005)(66556008)(956004)(66946007)(8676002)(36756003)(66476007)(2616005)(6486002)(2906002)(478600001)(186003)(5660300002)(3480700007)(54906003)(86362001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: HlVivRpV5HEEMBUzq4Yo2JmUtnsPNGVGz90X/a9/lJVIE1bXMhQnQAr7kbICacbwUp8Y7z4D+b4JnE5Knt4pbxvXtiF7zaIYDb9MwDJNM6/yxm0p5p0KQTeUmEVwmXPcd0CoH8KpXSRI6z//ZNWaMIet25Tf7j/DuxBRSO3Z0WsybeRLdipGxA5Tr17DsSnQyGysmMpv4Y+1pucN7Rrfta8Rlow0HRrPVDRhVm8NP9llE3wHS5XT95xFQvJ/FPtR3FBZTVEVxtLmy6Oyk9GFZmdW9OHtiB5aCXl6IB21UuBes/t6Uarar7epKBDKKvHZXqu4Jii/4XMzLh+00g00+fh1LlFfmZQZult1nKBnCv7bNnYtkFF+UobWAUQJdA4LhdF05TA9ndqaXuuGAYDFanAfuEbNJeVxY1G94Qnnr1o4eS396mTHtzgJLj7UKGRigPYqCkPwHG4lC/8XIGrOrA7ao34AluTGN7ccIy+8WtG/fwJGuYz0viBObjlLItUb
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53ceff18-1e7b-4dad-2024-08d80327c812
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2020 16:54:26.9743
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jqO9IZdjFehOIEi7uKWTZeAP8tPgXa0fWzOqDzEziB5wT0aGGxBYvyyuo8dIaZthWvitUNARse14Ew46x1uBag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB4651
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Andrew Lunn <andrew@lunn.ch> writes:

>> Andrew, pardon my ignorance in these matters, can a PHY driver in
>> general determine that the issue is with the cable, even without running
>> the fairly expensive cable test?
>
> No. To diagnose a problem, you need the link to be idle. If the link
> peer is sending frames, they interfere with TDR. So all the cable
> testing i've seen first manipulates the auto-negotiation to make the
> link peer go quiet. That takes 1 1/2 seconds. There are some
> optimizations possible, e.g. if the cable is so broken it never
> establishes link, you can skip this. But Ethernet tends to be robust,
> it drops back to 100Mbps only using two pairs if one of the four pairs
> is broken, for example.

OK, thanks. I suspect our FW is doing this behind the scenes, because it
can report a shorted cable.

In another e-mail you suggested this:

    Link detected: no (cable issue)

But if the link just silently falls back to 100Mbps, there would never
be an opportunity for phy to actually report a down reason. So there
probably is no way for the phy layer to make use of this particular
down reason.
