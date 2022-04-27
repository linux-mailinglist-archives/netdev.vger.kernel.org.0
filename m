Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C76075116F8
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 14:45:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233565AbiD0MKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 08:10:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233534AbiD0MKV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 08:10:21 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C8BF6D194
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 05:07:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1651061227; x=1682597227;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=kpxIQbvFgwx+RYyOu3X/QnC8c75HgtDNSdefPoOV3OA=;
  b=fMLY8dG28jnLNFH1ndJElMVrb4hwFsjb2TRL3qAhWVFc1OeOJWjHfCFq
   /8wEOAMxkZ4fD7C+hbEucAMMAs062RDibxczxnk6QGkDgy5XOS0xEXO7u
   T6L+Iw/Zm65zwlPhwcJs+QDVjqbwzG9fd4FmpRd3H97J0+bpudmgOpj/r
   S8hr3CawAcEFFz+qNnCMihHP+6LTotM9qby4QjHQfU2a53ILaVr4dI91A
   Hf3yHNmhfBhLP1iCF3q96ted6jldSguhHvemkJpQ/1qmgJi9ftBDQH9t0
   nwd5EcVhjW9ncBNAAM8r80jeF7TNfKoWO5uQbszZ/TTqN1v7/x0GhXX5p
   A==;
X-IronPort-AV: E=Sophos;i="5.90,292,1643698800"; 
   d="scan'208";a="161498591"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Apr 2022 05:07:07 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 27 Apr 2022 05:07:06 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17 via Frontend Transport; Wed, 27 Apr 2022 05:07:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HdwCPbT3sHyKffM7NBqd5fT8k/56QL3C0qBUMkyM0+4IyklnokycqNwgPwtJf/KQix02zkFyhbGpddweO6uXaTc5sw4NbpfTlwrwPgG4vUjH76WWj+otcAbJauWbtDdSKGfv0qn1aLwYolfEAG7joARG4coNmRzYh7amCrf+oqZh86KRLoe+gbTzwHDCYUgq7v1ilciC5kyhwiMZ2h+pyhthan/LTv1Gcmd/hrJgoGrw/JvjwRVLlrYgF2ma+461AEYIJzI9+S4A3Z8waq52K6y93tfN/j+m2xCJrSrYcoR5/eb/gLC3Pww8uVUnQKbzhW6A8xeAi7fkhepKBDGXrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SlEhobnxcvMA0a6nFPmox8lkMiHPDiwQFt8DQ5qXC+A=;
 b=QxWgm08Ll5nw7hAcLDSI+koOB2oIHejz2hrrTxPY/1AhV5ly4hfl5ZutL598EMd8lN3dLMxYM+4Ct2Aktxsh7176NlPhqUDEqC3f/f9nlp/XgWzn4Y0U+LXLlBbY35i5d25IaNWPaRTPDWP28RX1tnOvZFXhaBVCafpKPguUcJ0Y8MO7jCEDb/GPgZUSBHc46x1vZ+BvLzeieHF+AVXb7xH+knBWAKzRHr7E4spqhEXSK0oRzebiyyhimtU5K5Ro9NgvXHQnrYKyqh9QnMEyo/OmfBsjcTwUgI6NbPMpxbTmFEOlllVGx9LdKmnUdzNY9Koa7liG7965SwJcgtHUSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SlEhobnxcvMA0a6nFPmox8lkMiHPDiwQFt8DQ5qXC+A=;
 b=YwL5jGT0KLk2TsDfrAfuVQlvmd6SB5zq9Toa8U3kPuRwSbUaWwJpvWDCVNKtThZqTf9ug3Av5FCYgqL7Q9Ednt5WKuAH7MBa4buV2DRrjg9k1R+bYMEjTD0vTq6GdHbJobcBU5MGwCwHYYht9m8XDg8d08QThPX+NB3bvM4nyqw=
Received: from BL0PR11MB2913.namprd11.prod.outlook.com (2603:10b6:208:79::29)
 by SN6PR11MB2864.namprd11.prod.outlook.com (2603:10b6:805:63::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Wed, 27 Apr
 2022 12:07:00 +0000
Received: from BL0PR11MB2913.namprd11.prod.outlook.com
 ([fe80::a1dd:3f69:584c:4f94]) by BL0PR11MB2913.namprd11.prod.outlook.com
 ([fe80::a1dd:3f69:584c:4f94%3]) with mapi id 15.20.5186.021; Wed, 27 Apr 2022
 12:06:59 +0000
From:   <Woojung.Huh@microchip.com>
To:     <Yuiko.Oshino@microchip.com>, <Yuiko.Oshino@microchip.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <andrew@lunn.ch>,
        <Ravi.Hegde@microchip.com>, <UNGLinuxDriver@microchip.com>
Subject: RE: [PATCH net-next 0/2] net: phy: add LAN8742 phy support
Thread-Topic: [PATCH net-next 0/2] net: phy: add LAN8742 phy support
Thread-Index: AQHYWi04QmuO2Pa4FUGqD7CciFNMm60DqiUQ
Date:   Wed, 27 Apr 2022 12:06:59 +0000
Message-ID: <BL0PR11MB2913C98C6182BA7E75B87934E7FA9@BL0PR11MB2913.namprd11.prod.outlook.com>
References: <20220427115142.12642-1-yuiko.oshino@microchip.com>
In-Reply-To: <20220427115142.12642-1-yuiko.oshino@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5b6c315e-0769-44eb-bee0-08da28466ece
x-ms-traffictypediagnostic: SN6PR11MB2864:EE_
x-microsoft-antispam-prvs: <SN6PR11MB28647543F86198F3493EA9C4E7FA9@SN6PR11MB2864.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eJN/NX11718H7HZ25FIp5AJCgUDVFLrxr5QUxVraRpAPAIAj3yxJjARIWzxXmkz1bNKfiidAfx4pM4EpxtaEBGlSc1gL/i8mF4Yw5gfliH6te0h95xzjXl6qyI//UerkCZzbywmzR0ufY8aKy8i5kDo5TNpV7c8krO5RdrRiwcv7jmE/btfCiZXeXEl1P5uYEIk01yaCE8fXE1MqBWhekxZ/5lb9AdUihyQO5Fir+ZjcZpJxy9cqz+o2bNKfsufWr7OeIsUjtiPZseyNw/WIW56yQBDk3nl79924GF4oUvvICRLPEWtY5nRz4Y87ycx9TGtWWd7YQ7+0TRMjvNhgzZCdb3GQNz2B/TwtCfEBjHFGHa7NPmOOt0ZyLL/DgJ9U+GHsJZSaKIaNlOTggpO+z+bBgn4ZZj6UuT5GABcpFScdzUxaKPVBP+EQsoDP3PpUqmDaf72S+5BzGGFP66J1PlZvDf7n7AA2pL2qCdJOfsQ9fSDEOWmr1RlMwUgrDxWpM3gvk/Z7997HJkFg77rGUncaYiXhXz0DlB2KsX5epKAc1UQ6weQwY/mCtj9p8ARoxsjM7fkA1i1OYmFNyxfBepCq9fXSG76U5bVps6uXSnH0GnkqRX/qDl0hhgwF7WC8Frh0+L+fhQpNq4RfceM2lQcw7b/KwONvwfisut1UBEoF+Hj1tfPEE2ad4/iRJH8wsYoYozxACDcz8RDo/tl1NQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR11MB2913.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(5660300002)(316002)(8936002)(122000001)(38070700005)(38100700002)(4744005)(186003)(2906002)(7696005)(33656002)(53546011)(55016003)(6506007)(71200400001)(52536014)(9686003)(66476007)(66556008)(86362001)(76116006)(6636002)(66946007)(64756008)(110136005)(66446008)(8676002)(83380400001)(26005)(508600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?GkhDL1KnsizOI0l6i3YqrUEqp1j3Wslx25Z44fhaaGDmeURclMin0RriqxWd?=
 =?us-ascii?Q?K4XvoeXO1Ku6vzx0i9Qn+uB4Qp13mL1buHDT41aYshAZt8Nbyoa60dbOzrYY?=
 =?us-ascii?Q?Mi0HHKWJz2UKDLKfoybIjrI7KNT35HfT2SIZMG5LoAzikAXyycT1VU95JJA3?=
 =?us-ascii?Q?QrdIOqHHnN9TNdmz9+oIrWZp+67dg7y+0WpQiXBKr0c0473C6YplpAGk66wK?=
 =?us-ascii?Q?sAsl/f30/TG5H8xdCSxgcNcTZqzhP0oSYhnKEwVwsO2g9ZjlIYqLZqo+ccFe?=
 =?us-ascii?Q?Qt7iWtOtutf04Junu33dcWqeP0F4mS2zFTxL6DlyRkEipfkKEQlYlQNY0yyo?=
 =?us-ascii?Q?IYBRLlB0bSj34DA6vCBP+A2dvDVdv3IoQY5IlCh9Q0dTLpBpUsKlE0FKS5xG?=
 =?us-ascii?Q?CiKTntn1pLME7JmobRScFA+qVOEeiyOtNPTISqyELMz44I+z5/k3NLfCIo9w?=
 =?us-ascii?Q?STicCpKuTX+x5c9RgxSMxmr1IoDCLO1JIrUg0jS5C9VjiyMZ46VrliW9OYyY?=
 =?us-ascii?Q?YhewkhrCGTxTQeRQxthHOqRr7rmt14TdIyqrDU4WvSRS/qpra/sEETltskTE?=
 =?us-ascii?Q?cX1KqL76UTJMREZQ1DRFCpuWo0pAsM/73I7eCQy7Q4hszoltowP0zgkXtHgl?=
 =?us-ascii?Q?n7L+gF78sDb4xxUktdEAPTJRI4Ho0RCWjVuTJPoh7TT1S4gwHh8rssjVUNAJ?=
 =?us-ascii?Q?a0BO0AnpqNk19ZqyQ/sdFsDIsDxu5ogu5QREqFUbe76acwvzATpIP1nFR8OQ?=
 =?us-ascii?Q?Vx6XBwI8ekDmHv/N1vf0Cj9QuwlSMe0dLw8aZyG1KtcL9NktKggLq80SHrmU?=
 =?us-ascii?Q?OesQKoj3AxrZNqp4e0IBD0EeuMc3BcHgUn5YkS5gBTQcCqOjagfxO3fEOwtT?=
 =?us-ascii?Q?f5UVzdiUz1ObqeBcDrzMiuZuboOuHsFNuZu375QQPC4XyLuIN2BzUh74RJHp?=
 =?us-ascii?Q?FjTWjasNT1prDcqEzdfbyBnGtpjF+XnseqUXPrkEAWtvy8BUhZgSKTJ8VtjP?=
 =?us-ascii?Q?cH89DTWwjvAnDUOnK3/UPdzLZSKEiuvHfy8qcO6Lw9Sx++6vNy1jgShbaz7y?=
 =?us-ascii?Q?ZwKfjTZfLkEZwppwKe5aGVxXGRdFHx80ROzYEYcFQ8aK3TumkZaj3ALzqZLc?=
 =?us-ascii?Q?4gqeSp0rSod/Z//a0FNFC13bBMO0EKeGdMGDx3Fs8Yr0DrdSJtB3jN5jzw8B?=
 =?us-ascii?Q?zAbNkhYxg/k7JKoEzcJN7GkWH/Fm8foSc1oExy72qmw8kMj/prLWcwvmez3p?=
 =?us-ascii?Q?ZQGqHRlykdQuBgL3LH5dHKRjaKghs5P+UwI7AZgsfTt7am82nhznHmQO92C8?=
 =?us-ascii?Q?5ziJU+bYbOb0ToCXpJ/ONYrrzSot6MuXc1qZhC3qe44NGCQ6euqurTtGBpuo?=
 =?us-ascii?Q?MHKy+eqcCyg5Aytx5/CmY3yE+wWjkFMdWhWQ/AouYrh5XnFFq0EM71aJ4CwV?=
 =?us-ascii?Q?OTSGlcJAykuJSMqxbl6pE4pcC4fyQ4DMSAVaGsuG3ARO+VsQIbolCGECOqx9?=
 =?us-ascii?Q?Nb7iGmsuiL2Rqmndc3K8VStCcVyRml0qUKKlyUyvNFciw9i+7Ql5ocUNSZ5B?=
 =?us-ascii?Q?NZXVSEtw4HaHTaT212NLfHJ0Ijm8E0V4Zyea5mRT3rNmN9GuIUSaHOUNtOoT?=
 =?us-ascii?Q?7z4SV7YQQP/LSspDz2sSy+SvAYuBF3egDscBc5y2b2MzoCRW9XCIe8fQiZsW?=
 =?us-ascii?Q?dZW+L6m5SOX4GqR4XcjWuB5vh88uBf9akJ5HuzwOEAngozCiad4cBPirZM9p?=
 =?us-ascii?Q?52wfrflW8q9nJf4G7kteTUH+8WX/Wks=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR11MB2913.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b6c315e-0769-44eb-bee0-08da28466ece
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Apr 2022 12:06:59.7898
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1hXKWLAmnW3ajoPKbzwljjqkc+pErYnKvkSrRQEOB05P3mWTTOdXWNmMonvrD+sT0CJ8hwnLHpyyWHuyrw872TWBpbEXT0sXEGuLLVGPqT8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2864
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

HI Yuiko,

Thanks for update. I think it's ready to submit.

Woojung

> -----Original Message-----
> From: Yuiko Oshino <yuiko.oshino@microchip.com>
> Sent: Wednesday, April 27, 2022 7:52 AM
> To: Woojung Huh - C21699 <Woojung.Huh@microchip.com>; Yuiko Oshino -
> C18177 <Yuiko.Oshino@microchip.com>; davem@davemloft.net;
> netdev@vger.kernel.org; andrew@lunn.ch; Ravi Hegde - C21689
> <Ravi.Hegde@microchip.com>; UNGLinuxDriver
> <UNGLinuxDriver@microchip.com>
> Subject: [PATCH net-next 0/2] net: phy: add LAN8742 phy support
>=20
> add LAN8742 phy support
> update LAN88xx phy ID and phy ID mask so that it can coexist with LAN8742
>=20
> The current phy IDs on the available hardware.
>     LAN8742 0x0007C130, 0x0007C131
>     LAN88xx 0x0007C132
>=20
> Yuiko Oshino (2):
>   net: phy: microchip: update LAN88xx phy ID and phy ID mask.
>   net: phy: smsc: add LAN8742 phy support.
>=20
>  drivers/net/phy/microchip.c |  6 +++---
>  drivers/net/phy/smsc.c      | 27 +++++++++++++++++++++++++++
>  2 files changed, 30 insertions(+), 3 deletions(-)
>=20
> --
> 2.25.1

