Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 393A61E5B86
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 11:12:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728162AbgE1JMn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 05:12:43 -0400
Received: from mail-db8eur05on2080.outbound.protection.outlook.com ([40.107.20.80]:11872
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728062AbgE1JMm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 05:12:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bmCp+DwqBLJhIqYbZ83zDR7bLeJeeBMnHn0RwdaVarRPByof5h8eckCxtvPAOYtn5mxeL2i5O77sLNSjIAN3sn4gszr5ugRL920z0Ps87qc2ZQWCRq1ciDT0Wy7PGaHHbF+E3IWtV+VGImjudvyZAbrqEu17zNhkQbXDlDX7cUWxY0kS1eJauP1bN0hOVGztgLmUXDFtTIZto1/yZSxuCGv1o2u0tYmUdwSGZN8qmA1lT2LzdqcVro9xV+0gP/X8JidnfhA4Y3s4tGlmuwyVMwgTmrC6Cw+lNPe4ztuuJFL1PDiGBzKYn4sucxEhv1eL3TxXohprdiAQ52ySpHsSpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z64tG6iQlqdvjEBlq71nGZqjmOJXFB30Bu5jXohY2fs=;
 b=YnTRY8kZEpcj2Sq0n/B08MxkCkCf0q37mUYjq7EVjVW2BUAsqLXBRi7XIE03IhrNaMquVOYdwzRXKiy2WBYCN/v/zjWikTpgDthlMLgnG9fp+YPo4pxwCX6KfIAbUmj2V6UUwMY497CUCy59E/PeSIOuoWnSf19kVyOYtwbPogruz4dyfq2VD8THiFUbHTAsni7h/mL8HUMjJ2XRSYAJH62QVIc3MjGsgHRcf+bw+jRDBVRmlyHC8W3QRgAkljO7CKZy3uLRSg+sbwvVH1thsmBgdBLDikPiKPiOXcf3YK8lMKzjTDWBYE9mGjLObLLnX7/Bt138FGm+Tcag8+oyAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z64tG6iQlqdvjEBlq71nGZqjmOJXFB30Bu5jXohY2fs=;
 b=jBB/Jkq7zEUcxF2SrngzJOSCqeUHFrlYH3XYthOPOhIXgdTYe5wzr3W/NrvJYdsjRPjx148ZKcMC4HcJ7EorXqrBUxNwCr9adz3TiGnhhLfsAy2l2NqI/UQR/fHRGuHr7C2B4QYF5Vs7tLRtoNCJyrz7N0SRRFI5TezghRxTUCk=
Authentication-Results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none
 header.from=mellanox.com;
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR05MB4763.eurprd05.prod.outlook.com (2603:10a6:7:9b::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3045.17; Thu, 28 May 2020 09:12:38 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::9de2:ec4b:e521:eece]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::9de2:ec4b:e521:eece%5]) with mapi id 15.20.3045.018; Thu, 28 May 2020
 09:12:38 +0000
References: <AM0PR0502MB38261D4F4F7A3BB5E0FDCD10D7B10@AM0PR0502MB3826.eurprd05.prod.outlook.com> <20200527213843.GC818296@lunn.ch> <AM0PR0502MB38267B345D7829A00790285DD78E0@AM0PR0502MB3826.eurprd05.prod.outlook.com>
User-agent: mu4e 1.3.3; emacs 26.3
From:   Petr Machata <petrm@mellanox.com>
To:     Amit Cohen <amitc@mellanox.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, mlxsw <mlxsw@mellanox.com>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "o.rempel\@pengutronix.de" <o.rempel@pengutronix.de>
Subject: Re: Link down reasons
In-reply-to: <AM0PR0502MB38267B345D7829A00790285DD78E0@AM0PR0502MB3826.eurprd05.prod.outlook.com>
Date:   Thu, 28 May 2020 11:12:36 +0200
Message-ID: <87zh9stocb.fsf@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: FRYP281CA0003.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::13)
 To HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from yaviefel (213.220.234.169) by FRYP281CA0003.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27 via Frontend Transport; Thu, 28 May 2020 09:12:37 +0000
X-Originating-IP: [213.220.234.169]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7d358547-3c71-4189-2240-08d802e7444c
X-MS-TrafficTypeDiagnostic: HE1PR05MB4763:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB4763EDDD5190093E8432EF32DB8E0@HE1PR05MB4763.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0417A3FFD2
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9B7Fc94Ql0ScHPbzHiT8Z4l0wKfFvC0RkqBpviACu/xtGRCUV3RVQZ8l2vno4OdLOmxnnWbCYjeRrMQeJCHLYratI1zC5BZtVbOPiTEV+Cef9YegNN3OdJ7K7wzECzT4W2tpWkoyyHWSGsrhX/e5Oy+eAbN2wh4aBIvV5c6b1NlB2s2sunen38QPlulOPH72XfdEEF+IDKbTsl/NYp5GkGI4u3ft4Fh5IQUCD1I90xa+OYnFyPPaSF1kCwRlEqroHkf2iw9hgAwbQ+yZlBZuHtg3GNW0vtoDtk2IXfOfIT343DBegifV1H/IqFPH8k1gq4MQsRqu39yLzpCnY0/tTA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(346002)(39860400002)(396003)(366004)(136003)(6486002)(26005)(37006003)(36756003)(54906003)(316002)(66556008)(66946007)(66476007)(83380400001)(3480700007)(86362001)(6862004)(4326008)(6496006)(8676002)(2616005)(16526019)(186003)(5660300002)(52116002)(956004)(8936002)(7116003)(6636002)(2906002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: tlrdSQnsyRK/3XHm7qHRb8OCFIbDfPsOcJ4fUXB84tj06KfRISEWNL4lxghUc//8Drk8QASGWbjzhHtUS5z6oYCGVnJQ0j5FhWGx7AtTxRGFCRI6USxqDUouW5bwZ0SrHdfAeZsAylKDmZANN92by/b63JYlmMouSepgZOneOmXt2dkDf1OZ3YU6sYn0g47bltD1p1DWP6PEzOqat2dNhXBLqG34NO/T98qd4Zmp+CUDL2Z0TOFYAOgKvduj7jWhom2oyHwhpiT0cAgK8F7e594cGFfX7Kd4z/IdDc2L5EGcbh/1csK2hxwcBR/HQAsCJwDts8inv/W/tumofKANeVpPAcuMzHQAffisyiZt3FEEXpeMUOK7l/kcAGy5ZxOgkVMuTF5DnCaZYOtFPt9Ty1cc/sDPpriao9Ozz5+P90g35TL/C1V6kgUm/gTgkhMMp5ptQOZ5+yGklfMsgpPzDChN7QxR7onZrWIDfRr2UY7eEROenTRupi3W/W5/XGKR
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d358547-3c71-4189-2240-08d802e7444c
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2020 09:12:38.1005
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rvz5d525YNBVQnMS6ScY7LDs120SmTr1TjkyF28jD6VQFMit5GW1f6RcK0lswQb5UxTPlUdNdokhzhSzvry63A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB4763
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Amit Cohen <amitc@mellanox.com> writes:

> Andrew Lunn <andrew@lunn.ch> writes:
>
>>On Wed, May 27, 2020 at 03:41:22PM +0000, Amit Cohen wrote:
>>> Hi Andrew,
>>>
>>> We are planning to send a set that exposes link-down reason in ethtool.
>>>
>>> It seems that the ability of your set =E2=80=9CEthernet cable test supp=
ort=E2=80=9D
>>> can be integrated with link-down reason.
>>>
>>>
>>>
>>> The idea is to expose reason and subreason (if there is):
>>>
>>> $ ethtool ethX
>>>
>>> =E2=80=A6
>>>
>>> Link detected: no (No cable) // No sub reason
>>>
>>>
>>>
>>> $ ethtool ethY
>>>
>>> Link detected: no (Autoneg failure, No partner detected)
>>>
>>>
>>>
>>> Currently we have reason =E2=80=9Ccable issue=E2=80=9D and subreasons =
=E2=80=9Cunsupported
>>> cable=E2=80=9D and =E2=80=9Cshorted cable=E2=80=9D.
>>>
>>> The mechanism of cable test can be integrated and allow us report =E2=
=80=9Ccable issue=E2=80=9D
>>> reason and =E2=80=9Cshorted cable=E2=80=9D subreason.
>>
>>I don't really see them being combinable. First off, your API seems
>>too limiting. How do you say which pair is broken, or at what
>>distance? What about open cable, as opposed to shorted cable?

Under the proposed API, open cable and shorted cable would be two
different subreasons of "cable issue" reason.

>>So i would suggest:
>>
>>Link detected: no (cable issue)
>>
>>And then recommend the user uses ethtool --cable-test to get all the
>>details, and you have a much more flexible API to provide as much or
>>as little information as you have.

Yeah, the API that we are thinking of makes this possible.

Andrew, pardon my ignorance in these matters, can a PHY driver in
general determine that the issue is with the cable, even without running
the fairly expensive cable test? I.e. is it reasonable to expect that
the driver can tell us, yeah, the cable is baked (=3D> cable issue), but
please run the cable test to learn the details?

Ideally we would just use the cable test when trying to determine the
link-down reason, but the peculiar reporting mechanism and the fact that
it is a lengthy operation prevent this.

> Link-down reason has to consider cable-test or not? In order to report
> "cable issue", we assume that the driver implemented link-down reason
> in addition to cable-test?

Note that the "driver" here can refer both to a MAC driver as well as a
PHY driver. Ethtool can in principle do a cascade of callbacks to
different subsystems when trying to figure out why the link is down.

> I'm asking about PHY driver for example that implemented cable-test
> and not link-down reason, so according to cable-test we should report
> "cable issue" as a link-down reason or do not expose reason here?
