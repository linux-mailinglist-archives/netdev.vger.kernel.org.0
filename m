Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2224B44D61A
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 12:53:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233162AbhKKLzs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 06:55:48 -0500
Received: from mail-vi1eur05on2072.outbound.protection.outlook.com ([40.107.21.72]:13633
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232570AbhKKLzr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Nov 2021 06:55:47 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=efcDaMbocuM06mU8G0stClXFCIj9sHhqiH1jJOfREzu5ttBEvxoB5iDCfP1kDBHa+cFp1ZlO+x39eFFD9yP1X7eQ4/eH/3bX3Nw1XYBSBCmtF3mEJn8hgxeStJXPn++X7q64omegEdzlgKThWZoSXxUM7yMOH99L/LnxtoqEWGUloEa729XXu/82E5jyQB5BejrrLeuZ8ETEXxJ8MNEJFkw99mCSEuHI8Lw2gsmFeAKs0EZyCC/q2DFd9btYZBtYw6Wksx//nnQvwlaIXd54QNuc8btmJWf6uz2UtqEcFZpbodKTqpNs4mVlEWGt3ic2AXqwtrIUkodA2ZQlzw7mhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ez5b+QQoLMPjCHhVp2UU802jWjYoCw6PMdWi6qXGBfs=;
 b=numGFJHW0tdbhkXCFLrE0tXlsPG+0dSt9hKYph91r3qlkFSpLJ+iGW9qMbzXAX41KVNnv4Q7JdvYuMWjrkgtH0WeDfeLqEf3H8GZNLqb7fxixIrfXqCppGY0BRsJvCQ64zCLNq47fTkvypO87GY6jelBNShmkFVLcSfN7PfWh1kcfWSgUffI4Y8rTUGTbBFBj4ejyjlE4r4z0fqX3GPmGX5ZrfnTQ/HwkaAzYUJvHclz/UcUk9ZoE+YUgeIv3KLWacxn7A9IA6t7hO5OlZ4aP1Dy2bzUtto02YlVxUvQ7HWA4b1pfigfUxz5+Wq/8NVwPRuAp2w5NJQkbkgWkt0uBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ez5b+QQoLMPjCHhVp2UU802jWjYoCw6PMdWi6qXGBfs=;
 b=CleYoUH+KmJCAeul97vWWzY/RC/NZBvjb29kdkgucl+fuPnjojuBVTa9w8cGfL3EZKMJK5/tk/XXTXBpTxOA3nyU1F1JMJoUm6QMnqerrWFl/YpBwLa6lop1/Z/PSKaw6KCzm+zlXUlwWDySIGTQF3mKc9EdYKP30sdUh11PChw=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7374.eurprd04.prod.outlook.com (2603:10a6:800:1ac::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.18; Thu, 11 Nov
 2021 11:52:56 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4669.016; Thu, 11 Nov 2021
 11:52:56 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Ido Schimmel <idosch@idosch.org>, Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: Is it ok for switch TCAMs to depend on the bridge state?
Thread-Topic: Is it ok for switch TCAMs to depend on the bridge state?
Thread-Index: AQHXz9lSx2h62F19RUufp+eb+7u3yav3+6cAgAZJ+AA=
Date:   Thu, 11 Nov 2021 11:52:55 +0000
Message-ID: <20211111115254.6w64bcvx5iyhnz7e@skbuf>
References: <20211102110352.ac4kqrwqvk37wjg7@skbuf>
 <YYe9jLd5AAurVoLW@shredder>
In-Reply-To: <YYe9jLd5AAurVoLW@shredder>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 95afe1e2-e641-43fc-9fde-08d9a509cd40
x-ms-traffictypediagnostic: VE1PR04MB7374:
x-microsoft-antispam-prvs: <VE1PR04MB7374227B552542F362F1AC84E0949@VE1PR04MB7374.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ce+1xXYy9zQA6f1YV2VYJFe55OerYh4dsZRvfSqU4j/Fj5fhgEOiSRs4OZDQxy+u+CSm5WK+TQUSFGAfA5HM4Y/Gjx5IPoCMZBlgOioJ3mTzWrRiHsAeAN3kTV10w6uhc9SUMB3F+EtKIQ0qzLLlmZDCCTjNMKpBz13u0sTJfiCXqT0qiAXEsLTI/+kAZ9JfKe3I7YUIZzbDQItMkz8PU66Cm9Z39z61lI+QluZSRVxQyEhpq+dzhrT1G76uLfVBXLsl5uCFwcJKqMpK7H2KxLV4VF0Cdf2vdY00aBFToU39d1IC7pI/r9RSbdeyp6gWcxwo8TOv03DrnYVyR/Fq3ZmYbFXlIMQ9WHtcj6JSDFefCXgUpsKQLxccpi45OlNbsxOww8Wv2XNIYicSotiCIe1k0zujJr9ua/jjrxwSU+ranJV4BBCNrtjWPgo8Oebs+E3oKDmWFOnQb9wgvzrk/XnMjVJ4HF7MJCO+zX+IM2ZvVWregxnyUT9jB/eKmY9+BQS3uJkVK3OTb3hzeZmTbHNeux8+9/tcw+RnK7WTQ32sVNvuoWN4XEI/cR63eE0JSjsCsRVvkOtO4ortNGE++NuHG9gZ8ayyWYU/28oZhgK1Zei1b7EjwogdB42vd2170jHnlppJ6c+GXLk+0BJ85jXlzIcghnC9zMqyQ6oSHa6qsevZ6T85TtpoF8OvVm2QdFZ4HaX0yRtBLeZkFF+ufA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(6506007)(2906002)(6486002)(71200400001)(76116006)(66446008)(66476007)(66556008)(44832011)(4326008)(64756008)(66946007)(86362001)(8676002)(508600001)(83380400001)(316002)(186003)(26005)(1076003)(9686003)(33716001)(110136005)(6512007)(122000001)(54906003)(5660300002)(38100700002)(38070700005)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?bhNIH4d4hzOlbLbnrSaUSTjuDlc06b4wiP7u4ZVbjft88wQRDtxEsanwQiix?=
 =?us-ascii?Q?mo9FKfhP282gbwoL18NtjfhCQOhSt6ALYiejCwLdxC2+T6lBTX8HoNCgjeKN?=
 =?us-ascii?Q?PYhUvERXuViVMxXlv+Za/aJVPHFdyYFPBvbdoQ1gVDGe7VukbgOnodzcvg7A?=
 =?us-ascii?Q?1KdHvLyNQUwjtt/zEAV2fmufuH16WBaAU2YzbcGo3z2J54T/u4KJIcDSBnAw?=
 =?us-ascii?Q?jl8jtFGf9Rk4r3RM+D8XOQ/JpIBQ7MyzDiaoCorBPVnZ0jPa6gLBGp4Yt/fR?=
 =?us-ascii?Q?ddIgZSKj90VgIUtS4RkEJU79RLQvakxsHmk2friHKbi5GCGAzJJusRut7fiX?=
 =?us-ascii?Q?gVtGiGTFzboL/+Fr0C4hHiXWzrZd2YnOFwu8mOM6112ovouRHpqDctORG0+4?=
 =?us-ascii?Q?eGUb4iSE/egyFZx8ew8DDqIpaIv2NxqubCzqmp1vRQUdstbi+LdmNOUAfYTn?=
 =?us-ascii?Q?lnJpIpDCmFGHx5ObzYhOMX8ubo51VAa5tl2QvX4qqM4IZHMQ4as1WuSKedVa?=
 =?us-ascii?Q?UOBea/i0TCmi4wu8OpbCpLGxQSEfjXbdBdFbE1acTN4Q//la3gyPrYnn9rFy?=
 =?us-ascii?Q?qmJFawXqrHtLOGyHpDFXQmwlDvCHBgDYGC0dJFjTq1HZcJZqA7wu7PpatGYw?=
 =?us-ascii?Q?Prc2k6Ir7e9Pp49adzggVsHm/kB8GkVSj+k04/Te9YQY4gxxQQg2Fq+MWmxw?=
 =?us-ascii?Q?1owErsKZjmFM6cpUwe/feNWE31POOt5i4G/hckPxn4dT/P5gyPimxAvCkY+S?=
 =?us-ascii?Q?OxbZIalh9cMcCeoetE1ZH+VAp0E4hABd231vAMW6dARUVx6iecl4fkTY6fsv?=
 =?us-ascii?Q?KvbZV4hDBfhw4KukpliMCbirx0NXr4Yb+slhViw6T+FUEIv496latAJ0hdhL?=
 =?us-ascii?Q?MtacROlqMq+lpWq8h3immzeAEr4Fx19F+BSZTSAfbs58x12AV1JrQwjh/GIw?=
 =?us-ascii?Q?rFgCY1ouLNBbUFur3bo1RyXws4H53u++9kSKPNqZ7sVa64ZgOU5jnJwIKSwq?=
 =?us-ascii?Q?7dEL9DEV2bZE/kF/xRLSVSUO1cffAbUf2knDubsL7klsfMPaY7X19AS/u+Pz?=
 =?us-ascii?Q?Rzic9nr4/3+UkkmwVZwR1MVRfelmqL0i/N8ERIJs4WEvrghR9NmvIp5vYkhK?=
 =?us-ascii?Q?WttTDs/wtmliP1TDeuMQCoye6Q/rqeqgnM8sQflYCtKargTrpzO76LWGpwuT?=
 =?us-ascii?Q?1MtCtOeO+XVHP5Q0Q4Vp1PMVBj4SNSzUm8YTMshNYdwJhiPFK9TYLNhoM0FE?=
 =?us-ascii?Q?xWoe8oGXelofQEfF3K02uKXqyosYRHC3j8YYiuGSFBZVi9pVam7s3hCMUqud?=
 =?us-ascii?Q?Jc7pT0wci4+91WpniVXGoE7Ap9wJRSH+3EO9dPRwtPdAJqm3h2wx6FUXf8Yc?=
 =?us-ascii?Q?FrTAIjIvRdoIZOmdL5KDmvB1IacFk8csvtpoEqfUSCLdx/iwBxkCM53H46Qw?=
 =?us-ascii?Q?eogk99FkQVo+Tukvcl3yvbPjZZ+UvhNiQCfLeE97MUnCFfIpG1+m88ev9evI?=
 =?us-ascii?Q?QOMTdUZB6Gzz7PJXJYGZVK1+kcWtIIKRPMlssxNYyGjD7EyFox+TNEb/Xzx2?=
 =?us-ascii?Q?tMWzrsLF2xSipQjBaK/anQc9lVhXFmexbbM5qxYdk62KFusQvfF/4MEM3KCd?=
 =?us-ascii?Q?Bu2vKq6V9Rne8UWPqjV3x84=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8A9BCAFA8E54FA43960892CDD77D784E@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95afe1e2-e641-43fc-9fde-08d9a509cd40
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2021 11:52:56.5669
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4risjMA2y5M9TOkqRGEVVzMB8JsE8mbgWHPxYqL9YN+2I8GoQgJFQ8GQbWYMGtiKUYBMtdkZaKK+oAt7/dS+MQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7374
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 07, 2021 at 01:50:36PM +0200, Ido Schimmel wrote:
> On Tue, Nov 02, 2021 at 11:03:53AM +0000, Vladimir Oltean wrote:
> > I've been reviewing a patch set which offloads to hardware some
> > tc-flower filters with some TSN-specific actions (ingress policing).
> > The keys of those offloaded tc-flower filters are not arbitrary, they
> > are the destination MAC address and VLAN ID of the frames, which is
> > relevant because these TSN policers are actually coupled with the
> > bridging service in hardware. So the premise of that patch set was that
> > the user would first need to add static FDB entries to the bridge with
> > the same key as the tc-flower key, before the tc-flower filters would b=
e
> > accepted for offloading.
>=20
> [...]
>=20
> > I don't have a clear picture in my mind about what is wrong. An airplan=
e
> > viewer might argue that the TCAM should be completely separate from the
> > bridging service, but I'm not completely sure that this can be achieved
> > in the aforementioned case with VLAN rewriting on ingress and on egress=
,
> > it would seem more natural for these features to operate on the
> > classified VLAN (which again, depends on VLAN awareness being turned on=
).
> > Alternatively, one might argue that the deletion of a bridge interface
> > should be vetoed, and so should the removal of a port from a bridge.
> > But that is quite complicated, and doesn't answer questions such as
> > "what should you do when you reboot".
> > Alternatively, one might say that letting the user remove TCAM
> > dependencies from the bridging service is fine, but the driver should
> > have a way to also unoffload the tc-flower keys as long as the
> > requirements are not satisfied. I think this is also difficult to
> > implement.
>=20
> Regarding the question in the subject ("Is it ok for switch TCAMs to
> depend on the bridge state?"), I believe the answer is yes because there
> is no way to avoid it and effectively it is already happening.
>=20
> To add to your examples and Jakub's, this is also how "ERSPAN" works in
> mlxsw. User space installs some flower filter with a mirror action
> towards a gretap netdev, but the HW does not do the forwarding towards
> the destination.

I don't understand this part. By "forwarding" you mean "mirroring" here,
and the "destination" is the gretap interface which is offloaded?

> Instead, it relies on the SW to tell it which headers
> (i.e., Eth, IP, GRE) to put on the mirrored packet and tell it from
> which port the packet should egress. When we have a bridge in the
> forwarding path, it means that the offload state of the filter is
> affected by FDB updates.

Here you're saying that the gretap interface whose local IP address is
the IP address of a bridge interface that is offloaded by mlxsw, and the
precise egress port is determined by the bridge's FDB? But since you
don't support bridging with foreign interfaces, why would the mirred
rule ever become unoffloaded?

I'm afraid that I don't understand this case very well.

> As was discussed in the past, we are missing
> the ability to notify user space when the offload state of the filter
> changes.
>=20
> Regarding the particular example of TSN policers. I'm not familiar with
> the subject, but from your mail I get the impression that the dependency
> between them and the bridge is a quirk of the hardware you are working
> with and that in general the two are not related. If so, in order to
> make the user experience somewhat better, you might consider vetoing the
> addition of the flower filter or at least emit a warning via extack when
> the port is not enslaved to a bridge. Regarding the FDB entries, instead
> of requiring user space to understand that it needs to install those
> entries in order to make the filter work, you can notify them from the
> driver to the bridge via SWITCHDEV_FDB_ADD_TO_BRIDGE.=
