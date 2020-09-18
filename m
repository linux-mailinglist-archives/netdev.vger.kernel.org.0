Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54F1C26FF03
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 15:45:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbgIRNoZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 09:44:25 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:5308 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725955AbgIRNoV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 09:44:21 -0400
X-Greylist: delayed 428 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Sep 2020 09:44:17 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1600436660; x=1631972660;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=3fxeMydRj5LITwpOTJ8/5qGWnkDlQFvKc/JWPdaDvPg=;
  b=knz3cvFZmu6aWoNx7lAksSxiCckqB28xQnxk+03HHiVndotMc2HP6KDB
   L1ZWAJZOTYqk2PVmrTorPQ9/vFiCYcbAKu1vt/8iBiaZk8Hpl1z7qZY66
   CxaCx65gKdHdIaTiENy6aMpypF93Hzypb129npz5CyZud/HoFgdtBXHzs
   YfTgO0xNpKTl7RYqEXyF7UC6KORe9D2BUWI7dpLnB3E2A6vkrWDeiHITT
   J97gVW3TqRjT79hPFPdk1kGLnAbMRPGgaqIYcVq1XJ0m+b7K6O2tLyFRN
   JvLVNGxK9qfkUel1CqvT+P1i3bxIgN8b5o7sy1L9V0PtUDMUTDB0RUFDR
   Q==;
IronPort-SDR: CPLMGknDk2ZgueAKF8+r7NJjRrHOsMekEBPp4J/ivWXsRpgzeWBwzpohEgC2YUnvo1QxaIoRDR
 AJNJY9J8UD4tqRTJH49nQx65Qe6gGNRaDrbSW2MW4h1YoKeSiGbCkjoKEoY6psHL7D2UgFTIjS
 pzmy/0f1jpIzkBRaOJ27hPSoaqc4RXXCQTDqIZhTAY+isqw+VbJN4OG1hGKRMcymITix8hG17n
 ulMGOmqFK9d961odT2W55IvxcEAXN0ZX3qXKXIiRyLGlp9jsxNApIKJIHaAXb6nfKZtZ/x08dG
 c78=
X-IronPort-AV: E=Sophos;i="5.77,274,1596470400"; 
   d="scan'208";a="257396423"
Received: from mail-bl2nam02lp2059.outbound.protection.outlook.com (HELO NAM02-BL2-obe.outbound.protection.outlook.com) ([104.47.38.59])
  by ob1.hgst.iphmx.com with ESMTP; 18 Sep 2020 21:37:07 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iLygZ3AenipCl8s0sqzldZbz19KiqKMdsmpj+wu9yzA3XdkHF4kdg0VImaygY89jRn182FQlARrs61ma8dOO6qoEmXGzTpoUu+U8s4NBeaP2WdDmZ6Q7ONm7tFJv2Q0P7BEVpRl0MLsHR8FvBmC3ljfpJZhVcMsO8CERC0Jn8GDrKI1uOwcDKfQomWIV317IL9AsvCzbjvTkWfZpFyTcANlD9w9fP2tZ8xKdePUoXqZ/d6qFDF+vSlbbfVlyKTGGKpOfgIFAMw2rv0yImQkyOHlHiYRXO4eGwgxxJSeB0NvwNyZLspttLZWNBwLBnP2bNDzGr9S2RkDgSwrzGS1h3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3fxeMydRj5LITwpOTJ8/5qGWnkDlQFvKc/JWPdaDvPg=;
 b=TXeSn6r2MjGNBlh4C8XMQ/U3HnMqb61iZIq6LH1YOYF20DVnCWeJ4jr+V7jE2/CBC9C7rJCIg16zpuX8ZjyXPAiV6QoXBMwrj2q6w2uewAuwudGgqMMxqQJ3q7kZajMOoIH2ckfVHde+wPN2npjxIuNFuEkhtJNCPogKnShNLFP5NX/ZKb7CNnKa5U5US41CiUowavm5vsLYTv+hSf6XIA5sr00pMHnWgbkEmWLi6DI81XXXBtfd00KY0C243Ewz2cAdOheyRF0RLshNfMe5r/AlcR2JlV01soARfpLkA/vnfbQPr9xlc52z8H31CqB3IB/bcEpwHXu9Kcb7oS3JTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3fxeMydRj5LITwpOTJ8/5qGWnkDlQFvKc/JWPdaDvPg=;
 b=qKi5FalZqOEFK4w7rb6IGXToAGpRjdZVDXpyEI/VKxNnbdE6py64DiRwMegLmbFr7vmaaiyV0ymMyPOdUs43z6p5lIx6vfCFM0qEnzcjrNxq4x30HVAqCCesK8zvyOUMYGHsQATJV91a1L3Q+nIFotJ7Vap9rYUGwgIAGyr/0Xw=
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 (2603:10b6:803:47::21) by SN6PR04MB5325.namprd04.prod.outlook.com
 (2603:10b6:805:fb::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.13; Fri, 18 Sep
 2020 13:37:05 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::457e:5fe9:2ae3:e738]) by SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::457e:5fe9:2ae3:e738%7]) with mapi id 15.20.3370.019; Fri, 18 Sep 2020
 13:37:05 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Christoph Hellwig <hch@lst.de>,
        Alexander Viro <viro@zeniv.linux.org.uk>
CC:     Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Arnd Bergmann <arnd@arndb.de>,
        David Howells <dhowells@redhat.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        "linux-parisc@vger.kernel.org" <linux-parisc@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-aio@kvack.org" <linux-aio@kvack.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "keyrings@vger.kernel.org" <keyrings@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH 2/9] compat.h: fix a spelling error in <linux/compat.h>
Thread-Topic: [PATCH 2/9] compat.h: fix a spelling error in <linux/compat.h>
Thread-Index: AQHWjbn0TGOYh/gcrkCo+5T+LyMUNA==
Date:   Fri, 18 Sep 2020 13:37:05 +0000
Message-ID: <SN4PR0401MB3598AEEC9EC17DC78DABE66E9B3F0@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20200918124533.3487701-1-hch@lst.de>
 <20200918124533.3487701-3-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2001:a62:1460:3d01:8d9e:cb93:a2df:3de3]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a7055d35-151c-42c1-a3ca-08d85bd7eee4
x-ms-traffictypediagnostic: SN6PR04MB5325:
x-microsoft-antispam-prvs: <SN6PR04MB532504408AA7CB391A1C35979B3F0@SN6PR04MB5325.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2449;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sW7O8iy/is8rzBYp3C+pEE1DT1YuUxj4GKzMvIgRa08BemS+/vQ/dkkQQPFinWi+mjyAZsK+AobvbKF9ksjI2uX1omQbzprpH5xOd3aZ1MCuVO9OI0cX+G6t9FKWCutM30I+/6QXVvIXgHS9ETzoG9TlNAb0zJdITBSoC4lvJKUFz0bc5NClo1SdmHZ7IWS6rB2U7f9se7TkrcCtwS/YTMN8u5aZKyJM2x5A77wB4OxVR1Lar7IAiexdUTvgOC0ve+LlMkQe7GlI7wnFLvi7lN2BxVwtzYNngGl0eo8gN4sbvdoKanTc1WCbYiooE8Ag
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR0401MB3598.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(396003)(376002)(136003)(39860400002)(52536014)(8936002)(110136005)(54906003)(91956017)(66946007)(76116006)(8676002)(316002)(66556008)(64756008)(66446008)(66476007)(9686003)(5660300002)(55016002)(186003)(86362001)(7696005)(33656002)(4326008)(71200400001)(2906002)(7416002)(558084003)(478600001)(53546011)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: +4s7mIR9sli1EuC4tBkNBWdTq8BmORqoiZ9VRJdHaRNDvJ71NGpgl3/MABc7lWzZO1Xj9EJyZtQoMTX4VADCXg294C8mGwQHnLdnZu/bhxORLzBInmdOCsaL8aX6QLX0azcjcZj14APp+ORMrtsjpmAu4cw+wunmpPRrLH39BtypYte/df48R8ssiYg/djEiTi9IuF70jvoqxu96Xzk3ay7eZF76Agw0pmNyu6V5p39iICfBUQZCEJAasDUxhMC6tUbm9th7wG0nnG0AuU9kEd3TlNSO9RqET/lNaLYpf7cr94Jco27qpMvDDgwxYxp69hrTAl3uqECd/Q3og++YuAOG6Lzq1JMaeXJEU4MdLG5PpmzsXYMemy/bEeDi8bb6NpvSiX9RHcKMRFa/guA205H3HlF6BT3B5fNozrf/Pm4f3rSR+/c0Zys7ystZKXvLz+IP0kjcOCIE1ELGmIa1jqHPezFV/lyYPG7Ij3ssjYTj88stWATwkm23OJnBIKe/6klzb2SpfL3DekexxrOmHyquT1djWn/GhQyb6WotrfD0cO2Rxf+j8TPhiKyE98d5RiSPJkNJsJFK2CwphDZuU5mughX6alHxpgB9DnIEEULOXMkqEae8mFpoFEIoiNDXweHH6OsyIE3vONoRCnEBupVnBDkunxZQ7HpS0NOiibNcz2pOJ64eJPpdpVY23Yk5uyr0BotCoisyWaFiuJq1yA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN4PR0401MB3598.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7055d35-151c-42c1-a3ca-08d85bd7eee4
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Sep 2020 13:37:05.5213
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5Txd1p36uuGkQs9WEN/G0+DUIyGNPxaMxNayRc9hOeqSRFG9dtxxpSZX+AJhfrs74ZJ2tBecEIIGTxwIgPLEubl21SzBOHz0tbKUc7oAkd8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB5325
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18/09/2020 14:48, Christoph Hellwig wrote:=0A=
> We only have not compat_sys_readv64v2 syscall, only a=0A=
We have no?=0A=
