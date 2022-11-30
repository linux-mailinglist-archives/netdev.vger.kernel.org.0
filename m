Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BD0B63D9F1
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 16:52:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbiK3Pv7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 10:51:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230062AbiK3Pvw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 10:51:52 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3AD0218BD;
        Wed, 30 Nov 2022 07:51:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669823509; x=1701359509;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=J3sEqhJ21U6w+hCAeD5vR0sjDIV96bCChLLbNs1gJVk=;
  b=VS40XGseC4Lv4gR7dYYjqJkM+RlAb6wjgMx0D1XUxJUiTJQLx1PtLLGq
   gKb1IFtDwHbd+wqjm29i2iy0mxWz+FecG97lsFH3zyCMrc02nQPzqzKf9
   pjtldoYjtoAHBNfryOiVgdDSRQPtyM9RUrT7UhJy7F0vdTmb49WuNfNKz
   vVI4fOwgMHYuwCDtmZs/E6bifesc2RAAFU4bgDbECkiBkYi2LLJWmeqT4
   +jWe3rkQHHi1RGImVHtccR9wwZCdsBmNoFtT7HzWPb3NLVt1lpK+/aeDP
   bEa86j9q96PgUNXlQ40CtMV7fqO0pvMZWs/LRXWvXbJNGd89SvFr2Wcmy
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,206,1665471600"; 
   d="scan'208";a="189373958"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 Nov 2022 08:51:48 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 30 Nov 2022 08:51:46 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12 via Frontend Transport; Wed, 30 Nov 2022 08:51:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bvt+OG6SNZFIeF1OB1SYBbPrp67Q4KhJrhxolm2p8zeAvtMh7Y3y1ni85/obJryMtcmCxfOyuoqxZq/NgpHV3kGWkplcgcC5c8AV2Q/5JyCzo76EryqD5KQa2usPaAk9d1T6d6O/cL/hktzDhXT6xpWweVnwtknxrxcX7njwWkb1qQqpanzkGkfl0zm2CmxRP6COvZul52p6g3MfZnQpXTevO6CrIXvPw6kmy/dQBqxDb2ADjn1th6prnkmeWR5fAdaVJqS7fkqtXUMp88MvqjAPn4B5rgbyUKrPnCRTcrtWd0nopmUAA3KM/PyJKgT81jk995jxsZt3Q3MOR4W/dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jZLbaCPdGVD3A3v2xyfrXaflsQ3YufIt8srZBrEdAVg=;
 b=Cphcs6th6agmo9cuImujp29LsBvOnLyfXw+GS9z2uv9DFVessmcEallmGErgn5vFmi0WbrOlE3x1rcyIskQlPxgy9lC9Hccd4CpdBRi8xnajbWzO9xuXN+eZ7SmjM6VSPeCLn5hPlWTjVaYAobm8aZ+pFYKdR8qj1/QBaoE5ZkGlgBlkQ6piBq9TQRnfEYrWAOS1gHZoeBoOoxThr/Xn7qJfJOVeKQg4fbO704tEYUxPAxw2ewoFCdW3ecD/j5vsV5fCIMDHDx8VWtgoLa2Ol5oVJjWF3+vMyxzxaOd8hTlp23MAyNcvzfbIMUxXUcbkxtv/cfzjjMn/+RoA/cW6eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jZLbaCPdGVD3A3v2xyfrXaflsQ3YufIt8srZBrEdAVg=;
 b=KxDvWjjo8yAgM+GfUA+J1Ugv5eLHeiE70DJFyFKfLeiXN9Ald8e0hQtWS9l5/vHq9Jc/Qa4f2EcBd/NN/fs4oz0uYTzYEwTgp7GyrnjNfHWK+8melCVtOCqYVC8+qn711AN/oEZ62yCQatUoPzps9knstSbKchyv7Qtl2kkVMdk=
Received: from MWHPR11MB1693.namprd11.prod.outlook.com (2603:10b6:300:2b::21)
 by PH7PR11MB6547.namprd11.prod.outlook.com (2603:10b6:510:211::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Wed, 30 Nov
 2022 15:51:44 +0000
Received: from MWHPR11MB1693.namprd11.prod.outlook.com
 ([fe80::5928:21d9:268f:3481]) by MWHPR11MB1693.namprd11.prod.outlook.com
 ([fe80::5928:21d9:268f:3481%10]) with mapi id 15.20.5857.023; Wed, 30 Nov
 2022 15:51:44 +0000
From:   <Jerry.Ray@microchip.com>
To:     <kuba@kernel.org>
CC:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <olteanv@gmail.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next v3] dsa: lan9303: Add 3 ethtool stats
Thread-Topic: [PATCH net-next v3] dsa: lan9303: Add 3 ethtool stats
Thread-Index: AQHZA2vPxK4eDIuP5kOkg3W32g1dkK5U+YSAgAKmf0A=
Date:   Wed, 30 Nov 2022 15:51:44 +0000
Message-ID: <MWHPR11MB1693E002721F0696949C5DCBEF159@MWHPR11MB1693.namprd11.prod.outlook.com>
References: <20221128205521.32116-1-jerry.ray@microchip.com>
 <20221128152145.486c6e4b@kernel.org>
In-Reply-To: <20221128152145.486c6e4b@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MWHPR11MB1693:EE_|PH7PR11MB6547:EE_
x-ms-office365-filtering-correlation-id: 52b909fb-0bde-4dfc-7c85-08dad2eac7d7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9B3YExuEKQioQl8bFGrmZgiPrWQPEWDUE1s3R66szLYvl3QcRG6I8CcIR+s/OtdkbLveVUJ5aMLYQ10qamW8YzQiWgLNagzUBW4Oy3nhuu7XoSWljXEP9GxbLqPe3gpyd9KJhjaFjWGxCOJfWvgAUK3LC1EvIpw4/imlsc+vtfqmZGnty1gK0dn+MBrogvhs+gUTjeXRaM+jYgVUXkB7AuvVFMwetrKxiGNHDYPurdHEWUD5z3FnTs0f+MT2OwGEQnzkEIUH6z4yKAvMaoa0lrhhHIFivgHpnGpdh3rATY6pK++/QHe2P58fRncZexQ2xIG/r5BFFGtMoS2eIIZjAolRh7lHXnavyK7v33FJMzwJWLP7kDoydE8lCc8z8HujYfezFN6kE05mvFsqf/IeS71KGFsHwFm+7aY3Rbg+7FCQlqiBxPBUMmNn677j+YCPiKE3mJnBFgBrMH7tFNvb68CtXwob/njhGd9+c0pnueeKgOvRR8Zq20oO945WGTW1mSyK90dVNBp22D6nE1Xqx66mur0bTeGU/0POt7/Hi6zaO/ZMAlpyuKoSJm9rHXwlV9nQZcsLQweISz0c0FvlAAh4H9O6RhPZUS5vzfMbjapu69Qfc/NF61tb9J1ZMfuUrCW2CWGdFtiZ8jX1ychEqgxcUfE0ITFOdLZCOqzAF6OzWamcrhQZQ6g1cXQMgajpn5r6ulHuyhSqysPLX+5ScA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1693.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(376002)(346002)(136003)(39860400002)(451199015)(2906002)(52536014)(66899015)(316002)(8936002)(41300700001)(5660300002)(8676002)(66446008)(66476007)(66556008)(64756008)(76116006)(54906003)(4326008)(66946007)(4744005)(71200400001)(38100700002)(26005)(6506007)(478600001)(7696005)(186003)(6916009)(9686003)(86362001)(33656002)(122000001)(55016003)(38070700005)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?w7hFu9DeKn/WWL47n7GfS8DqZMXB5qUCq2iUkLo904JrnDQaQmw+TWy6NG+x?=
 =?us-ascii?Q?N4JpDJeAae9raZ2Dvtm8/IFAcAJyI1DQDcGz9hsoFeGputpw2NO58FLXeTA8?=
 =?us-ascii?Q?NeVfyXRXxMtZzBTPFvxdt/LjUbV0XR7/4dWPlLOxzl4cYlD9z/EfWY68/7wt?=
 =?us-ascii?Q?FAc1BwInxdzuIh858eTOpQUmgkN3IcViyF0WcNUjW/UHNqJkvHRwd8yfUmlC?=
 =?us-ascii?Q?f8gnmAHl92H9l+itWRxvZu5NOZHEiw6RJ7mAZ8XIF38Wdxss25gK4zlFv2rT?=
 =?us-ascii?Q?9BltsiMEQwdcLS1K5kLKLnZ3aVfC6XqvsbeB68WL9h04moSIh0Krn6VbXSQr?=
 =?us-ascii?Q?JjPJ8qMNKSKlOtrLtL7xr/JcBrZ9VhH7c71owOqDqPk8dJU+61k9M+5vN+BK?=
 =?us-ascii?Q?vjNwlgQFZdPXJJqsiipbWFSHaNQQJS66hqTa00JVXv3lb+DxVi5ivE0VLcUA?=
 =?us-ascii?Q?8qBR3BlcpIK9qPZbOAqJvGYluTMIewG3qADewNpEfHD5+5NBN1oXnu5/z2a0?=
 =?us-ascii?Q?4ccLKyFeICKYMaNI55bvAVk0J1aleil2nKHw5kbIj2DfTT79cI70pVCwk177?=
 =?us-ascii?Q?dobebPXl++WVKNIXvK8lu65IQ9lZOaveR2bQw0X+olPWigatKoGyh0iQZyDV?=
 =?us-ascii?Q?g+8ghehbyG9ZhgCNL11lQbiZkyjrBtnp4wkho1un/xe3pksv9kmQN6/OYyfh?=
 =?us-ascii?Q?faLXZdmBmiolAVHG/fSZLd+Aa6sAs6RSRe3o+bPjzsv/ZMFhu90r/btM+v3y?=
 =?us-ascii?Q?arwgZfgV7kidSgiwlp8YAcSREw1Plq8uV94f3wWhP+45OlxlChdxu6OdvWG/?=
 =?us-ascii?Q?ZAuozS+3bfb9eVUIvK3rAm3jyKv4K+qICJd9tIqrK96eg1Nw2zZr7z3mzAsk?=
 =?us-ascii?Q?Ycr8Qd6l5tZyZxbTXi+qDVl6pbU2GnmsHFOnLvd2HCSamAdNB1qbsfCbQHik?=
 =?us-ascii?Q?/IIyFzumW1DEDARB0fMMxakZWKUy2jiT194DGTb0ibabm9qqeN34DTBixcRg?=
 =?us-ascii?Q?WakC0CwspaAihLGhSNCL65gMQnWU03KYx0BfkTkkgNSxLRN+h835bkIZhxoC?=
 =?us-ascii?Q?uWdIlRSU48B+m1/z5i8pMmKqFaJw3u0KWwqmha/KLx2Er0TmjyP+9vF9TppD?=
 =?us-ascii?Q?hoKEPPXNrhEdDOoiSbxXroEw9J4iffJgWdJnGcD+RXBTA2TrDYPpvIIWpJB5?=
 =?us-ascii?Q?WAIx/tw3bsK4LbbS46Tjdi3xMFtkUiM8vWBFdggDb/6+wUr/sttHCoZpA7ur?=
 =?us-ascii?Q?EVIiQb7VkGUIfs0D6V9BTmJgYkyM7UcDbj5nAE7LHcd/lyg3Zm2M8SpSIVKJ?=
 =?us-ascii?Q?Zl82d2OvvlAPArRJvPfUdAIypXpSeQPOCGWV5tFXPI2z9otYmKbWAJitc3pr?=
 =?us-ascii?Q?1T9Jf5tuwJGyABk0AvjImz0KWeWF3MCT3v0o+QUG26skOrau3vhq5XH0fstY?=
 =?us-ascii?Q?lpLRuxVGW2hci81QCiJ+PfuZ3SGdG9zOybfUKdC+aneMZbWYBaYl81MFC7Ng?=
 =?us-ascii?Q?CWupW5Y4bKYWwfz4wsQ0AYNhQok5FXyjshVHjjZ0LYZABRjTLpIXkQu2kxwd?=
 =?us-ascii?Q?oU9YrUWH6sEHmAeiGFnson0p13XLGQikEpl2HTQK?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1693.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52b909fb-0bde-4dfc-7c85-08dad2eac7d7
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Nov 2022 15:51:44.3002
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eIubp9ni6C1WDs//R5PS2HWG56BlN5pu5e7L7BRARc+liKYTPLDWidrVRRbMVpO0Y4KAQ0qYrkINaDD5OmUYPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6547
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>On Mon, 28 Nov 2022 14:55:21 -0600 Jerry Ray wrote:
>> These statistics are maintained by the switch and count the packets
>> dropped due to buffer limits. Note that the rtnl_link_stats: rx_dropped
>> statistic does not include dropped packets due to buffer exhaustion and =
as
>> such, part of this counter would more appropriately fall under the
>> rx_missed_errors.
>
>Why not add them there as well?
>
>Are these drops accounted for in any drop / error statistics within
>rtnl_link_stats?
>
>It's okay to provide implementation specific breakdown via ethtool -S
>but user must be able to notice that there are some drops / errors in
>the system by looking at standard stats.
>

The idea here is to provide the statistics as documented in the part
datasheet.  In the future, I'll be looking to add support for the stats64
API and will deal with appropriately sorting the available hardware stats
into the rtnl_link_stats buckets.

Regards,
Jerry.
