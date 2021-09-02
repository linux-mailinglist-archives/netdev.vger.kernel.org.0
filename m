Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D28093FE66A
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 02:34:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243129AbhIBARb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 20:17:31 -0400
Received: from mail-oln040093008011.outbound.protection.outlook.com ([40.93.8.11]:14503
        "EHLO outbound.mail.eo.outlook.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S237130AbhIBARa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 20:17:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KGAn2gkXLvg78HCCerBkBhMhLZoyWLysIfeZ+Ycba87QcVB+i5iLtrRBa6gn6CbS1SXCXF6Ewo+LTuT9LBkBIE1z03i3ZibaU/qn8kxzOygYma5ywT72gcs7wSFhAY9z370kmvFuI0UmENfKF+3oUgDb2ix+F+JlaTyC5ybRXpe3sUOP3mdVoCeVP+80pslikegdsyBvAqQUpNdRkl054lhkApv9Cw59AiG3SXwaOKeRpRxedtdjXCPkQ1tW0DDcwM5+PYz3e4UYjTEML+984mZxNv3zprtDpO8hUuKaPsRlWvOJBqjChFGJVt5NvT/rJ8/f8E1OKKAwO4++0tu/KQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=ZsJOr4kyEAGLrRyISSvV2Je5WoxgIWKjnUHMyo9gxD4=;
 b=KvjdTzSZzQufHmrmg+hRQuj7RidpLh4gtHdua0DsBS8EryBfqhe3xGJMJG/PzXJ7Sqalis0eQdyPYU44sbuZT4kKURK3U/uoy/L6mZiirizwmCglqfNJS50OAI8F/4LNnhBZW8hqM4YNHZSsx+ewU4bonpNz9FibnlZIdhGUrm/I/G8uhzvs3f3pXoCpTy4OxLDHM+0BdM5JPYQa6EXyJTQSpJ65tbfo2JQEvhezyb80FQeR/R/ld5fJ12FVmU53tmkDFH4fUOLsm7WQR66JeLjNfz5o2FQagv9twCwhM0Or3gbU/+G7cnJr/EDaRGBsAZw7MzH/HgTsBoNIDPbR4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZsJOr4kyEAGLrRyISSvV2Je5WoxgIWKjnUHMyo9gxD4=;
 b=ZL5Z8+pBXbDMPOJGozgPpryIENcCTYHj7wyIgQMomvpFuo0CfS6Kn0B+36220njKAKnEVpyUqcGkm5y5KpJuC5haoFdu+f7FUVEOjR//qiVwFLF3BDXa1Q+E7vPJy70A5ldfiQsMEI278cLJImgp9Q9h341EAn9ujAqzuBBhAeA=
Received: from BL0PR2101MB1316.namprd21.prod.outlook.com
 (2603:10b6:208:92::10) by BL0PR2101MB1762.namprd21.prod.outlook.com
 (2603:10b6:207:1d::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.1; Thu, 2 Sep
 2021 00:16:31 +0000
Received: from BL0PR2101MB1316.namprd21.prod.outlook.com
 ([fe80::64b6:4ca2:22ed:9808]) by BL0PR2101MB1316.namprd21.prod.outlook.com
 ([fe80::64b6:4ca2:22ed:9808%7]) with mapi id 15.20.4500.004; Thu, 2 Sep 2021
 00:16:31 +0000
From:   Saikrishna Arcot <sarcot@microsoft.com>
To:     David Ahern <dsahern@gmail.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        Mike Manning <mmanning@vyatta.att-mail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: RE: [EXTERNAL] Re: Change in behavior for bound vs unbound sockets
Thread-Topic: [EXTERNAL] Re: Change in behavior for bound vs unbound sockets
Thread-Index: Aded9liCI+QX/nn6SXqyC7ZHygI2fwAWlI+AACIfXIAALVx4wA==
Date:   Thu, 2 Sep 2021 00:16:31 +0000
Message-ID: <BL0PR2101MB1316DCC9FFC2B0BBA9F66815D9CE9@BL0PR2101MB1316.namprd21.prod.outlook.com>
References: <BL0PR2101MB13167E456C5E839426BCDBE6D9CB9@BL0PR2101MB1316.namprd21.prod.outlook.com>
 <06425eb5-906a-5805-d293-70d240a1197b@molgen.mpg.de>
 <e8ea879b-7075-e79d-5da8-0483e7da21af@gmail.com>
In-Reply-To: <e8ea879b-7075-e79d-5da8-0483e7da21af@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=8f319cbb-ab31-400f-8dfc-7906ce4889c5;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-09-02T00:08:04Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 581e354b-306a-4493-ba73-08d96da6ea58
x-ms-traffictypediagnostic: BL0PR2101MB1762:
x-microsoft-antispam-prvs: <BL0PR2101MB176262D525EA5A8D06D7CD1BD9CE9@BL0PR2101MB1762.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7SCdDFPzcj8KyOG/EILWwRlvRdz4J6AFF6XdiINvFvz6aLGxBUpRB6sCmIOHNcYCPafz2JQhNPv71yIxg+yEqGmN4cZPDkM0pisgVtNKIAnlkYgP46GlIKsGLhd4UudCRN8nlGFYL4bLqu3oA4d5SL9GT+oYMK2kNKAJjgCrLRCwURyYQV+5PVoEo+TDMT4MwVn7lY2luCfasl1yLeHonHnnuIPka6LQz91HleqvxQhJs/rRpD1ZwiQRQaZKjTSAKH58bRXKVn7wyRkKascHbychOBgqSFNMd8PJKP8vGS0Vd9UHaVxdqIKaX2wl/Zm1w9O1k29o81zETr0kK27hgIIZQat1w2G+0DI4+QofcOX34i7+rETDmuxrJSQL+FyCsHYKZFIwX8LKppCkUTpEaTmUqeFN8BYD/9pQg1UlfUNE/3rg1mEXUIgbKrPcj+ZoE6jukn6pzaZXsbXjDiICC75oCVt4OMFV2y3NGVNilIxjk02j2DLIBDj77zWWlHpL7VV1thskP4DUW886pHvnhnMWUXDBwf9/41WCVTfJzKf67FLuHr88BX+Y7o6ITi1ZjV60ZMU58LoCFJ0RUnFkttOTC+pHwG79Kv6xg2D89CDLgmatIfJUCLeV3vmDqUVfRo/+uu15mBAZs7POTanTK06gcqHGPIpR4fcza3+941hrwTJTa1OsSeXFuBG9QaNLcRvdmHC0TaT5S7r+VSyTsA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR2101MB1316.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38100700002)(82960400001)(82950400001)(508600001)(8936002)(186003)(122000001)(54906003)(76116006)(83380400001)(7696005)(8990500004)(38070700005)(8676002)(6506007)(66556008)(64756008)(66946007)(66476007)(66446008)(55016002)(316002)(5660300002)(86362001)(4326008)(33656002)(52536014)(9686003)(2906002)(10290500003)(71200400001)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?T7Er3MCCHlbhVIa+49wDD3C5p7N1R7Wm+RjvgTcEzGDknN2HgrgiZplmg2ty?=
 =?us-ascii?Q?HSapVPYAFN26NbbbNPua3lYvt9XirGrn6XMANcX+MyymJhssWDJY+VPpN4gf?=
 =?us-ascii?Q?YN+cJ1x3J+zF46dN1N1axDcZDH7ezks4LVMBUj8Y4CqfzJ0f9ho1Om4eRu78?=
 =?us-ascii?Q?tN1PnNBeX72V/NDxVp1hw/UzfOysRfs82/JOWQdqX96hzphQupsMW+Mf/Wb7?=
 =?us-ascii?Q?RaEnhmwJDGBHP1SdvkmtxmdiVcYokJ3qHrVE/pXWxCyebw9BEu7GRwjbuCCL?=
 =?us-ascii?Q?jfamZlp5nBgqrfd5SCUVFqui6e48LiaAAJuN5KvxqU+FTKA0Q4AwNc4VupmQ?=
 =?us-ascii?Q?DV7TZFQNinpCyhBG4LBOtaTr39gFhRspwINJSRiaLy3B74xzoes0N2hP143p?=
 =?us-ascii?Q?wIQqFxa7d58tJ1FmpW/ku1yeshK0Iu7w6Xxnl/0FTYtq0bTcMwFx7tIKIfrJ?=
 =?us-ascii?Q?6INTwbqeR6yw2cdyQfFs4quDPeiuObhjCclnWpwvhMsPjAMEyOMn4NN6jwS5?=
 =?us-ascii?Q?eJJEHTp4E9j9W3qPsZK32ohOx/9F2tNKYUX9fzQ5GeFuVpUpzkVZ1ffJXFEw?=
 =?us-ascii?Q?aGH4Kl858DDS4oMrKj8yOt/lUa4KisxuNZHKeMXGd2W7qkvWwfg6v0bD+wrE?=
 =?us-ascii?Q?CpO1nxUwyuqL5trE2yG/AWs9bbyJVgnQLA7nMBEpf08OBPOV7IawNRn87fag?=
 =?us-ascii?Q?rmJtJECyepSnrLFHjnzLBgRfriOqXqMHHUr3lJ7lVbvvZqrrtlUwjSnSKk6Y?=
 =?us-ascii?Q?o9DlGOQ68gRliJ5Ss+INiIOGTVfgaVsgqfaJy0/t2sJEeUcCLit1/vvcb2KX?=
 =?us-ascii?Q?hB5Olrl8ime1CoAIoguOuxfuqSSRMEBxjR8pQFJVF4/gPGYH7AdfH+MhDCmd?=
 =?us-ascii?Q?vnKi7zRNknND1IcXprMZKRRxadX8BGO9F6PI+eQBnQ3VaVF6GjVlsC1V26iD?=
 =?us-ascii?Q?U3egdifI0MRWkKx9Qofzrm3bCKdb6jqrzGh7yixhXMbx1UOKqRv8EyT1fo6/?=
 =?us-ascii?Q?TKSPQhtQPpLhxgJxqs13ROB50Bh6AQ1EYvRIgICmGctubDcJKfqVrU0ymlk0?=
 =?us-ascii?Q?kyfqRJzOfgrNxtIBdSX4PUaiug21PYzoDc5gnlf7QEh0A61xceQ1loUFqfUX?=
 =?us-ascii?Q?6HXECsGr1Wuz1HE8PN24zVBvjNZVgUsmymliEsQJbf+ui046A8mcquH47Iwg?=
 =?us-ascii?Q?6sjovqJFjAsKHuieswUuJ0OElQt1546Bp1aQx1c486PU4MbG3Z+1mNAbU0Jt?=
 =?us-ascii?Q?5laUgRbPoYgcez10SWLReC0FihShEmasVlEq48HcOX8B/61gCi1Apcn9h1JO?=
 =?us-ascii?Q?Jew=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR2101MB1316.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 581e354b-306a-4493-ba73-08d96da6ea58
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Sep 2021 00:16:31.2312
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: O9zknaunXewVTVqaU32NQYGX+5ZiyeMMdWq7zjVEIP6tdKP5V8ju8roiU0tKsRPS17hKxilaSvgmRSyC2jUt9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR2101MB1762
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


>On 8/31/21 7:29 PM, Paul Menzel wrote:
>>> Is the intention of those commits also meant to affect sockets that
>>> are bound to just regular interfaces (and not only VRFs)? If so,
>>> since this change breaks a userspace application, is it possible to
>>> add a config that reverts to the old behavior, where bound sockets
>>> are preferred over unbound sockets?
>> If it breaks user space, the old behavior needs to be restored
>> according to Linux' no regression policy. Let's hope, in the future,
>> there is better testing infrastructure and such issues are noticed earli=
er.
>
>5.0 was 2-1/2 years ago.

Does that mean that this should be considered the new behavior? Is it
possible to at least add a sysctl config to use the older behavior for
non-VRF socket bindings?

>
>Feel free to add tests to tools/testing/selftests/net/fcnal-test.sh to cov=
er any
>missing permutations, including what you believe is the problem here. Both=
 IPv4
>and IPv6 should be added for consistency across protocols.
>
>nettest.c has a lot of the networking APIs, supports udp, tcp, raw, ...

Let me try to add a test case there. I'm guessing test cases added there
should pass with the current version of the kernel (i.e. should reflect the
current behavior)?

--=20
Saikrishna Arcot
