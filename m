Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0527262F007
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 09:48:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241691AbiKRIsi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 03:48:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241623AbiKRIsK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 03:48:10 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DA0D8E0B1;
        Fri, 18 Nov 2022 00:47:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1668761260; x=1700297260;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=11joARQ+HisLrnUfXQT9pzKyEW/kT7ypiGx+YE4v8Sc=;
  b=hSmICDLAP2og0JhlML5F7aBJpPE4sVsfjZPBKZAecbrj2+A5uHcp3gX8
   fJ9T40c/5M5aRtUz2A8CbER3CawH3HHlYdDc735MEVkBm2iLEhL1IvlkF
   kj31wo9b/qiq9WASKKtRsT6rLJaQU6IHQveqcY9+REhAeHsWvGQjrXjk2
   t8lBsiD94idg2uyTQbR/GHKuTmv/rp16g49o0doWYQryAOfsw5m2y/dbM
   nFfiWZ6RZEHM0P4AVsnlj6O4T/XuNAraoYTzYR/kewxj2RmfnY+rKLwQi
   nrsw2nDf6V+NbzlqFBcWVKPLl1hefSCKJOVhHxOWXEOwdE6RCh35Bf33I
   w==;
X-IronPort-AV: E=Sophos;i="5.96,173,1665471600"; 
   d="scan'208";a="200355099"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 18 Nov 2022 01:47:38 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 18 Nov 2022 01:47:37 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12 via Frontend Transport; Fri, 18 Nov 2022 01:47:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VipZCG8pQyP1JoLBKQg4Bx+ocx4/v4u1teezHp47NvUORH2MhoLsp+4eIzuxl0EujEhrZCF4yHFT66cey4oOQCF6YtEsLGhKV9WoL8wqBpx6joUKj2C6W/k6qitG96+x8HM99hpNK/IFjv7ySfAn7oPTGZq5h7zwaGdjAOq5NbC47l9i9foGjAtcCQg2GWmd/QI4YYzHz6SzAOaXC2PFnpiq5j9PKbuJUvAKlKB1qRKLb46WAvr3sBiPRFxJlgfR5QRSQoTpbYfshV4XDmus1fBT6tIXtvWrj4SdOZpG1lvhPyjI8+Um6xcYSM5YNu6w4qoIPqo2Io0yzS67xDAZFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AsCEfim4CP5Y8QopyNgMJDlHwBRStBH6YxsiVspa6JE=;
 b=EZXw2UJu0VfCXyCC4UkPi/J/+TgezWCqC2gsvsHtu0MMh6dnDJEU6EZksrzJGqi2uYmfVSCU7pO52F2fz/ZCbONdiN6XhEk90NjvLnZYEpLAx85q0/kjxF8cR0w6UW8T2joRS1bZ7ynkTjwedqGqrXObFbI4j0m2coY6m26pfqIJNmo7JvFRo6aW5RDr1eV2J2L2aZRBMh0ZhHmawdxOGGRTd3A1fvxhSMz7j5Xc7De+Ji69WrmgnlNj8q7FhWKGz1WlmVwKg7JRpNIg7Bq/SKG7tvokolGu2OXqIgLbyganfZQq8r7d42wRN5bOG5KC/iKVzXqHJypTQh4aUhGmXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AsCEfim4CP5Y8QopyNgMJDlHwBRStBH6YxsiVspa6JE=;
 b=XtJZAnfB71/yPA5fJ/wpFIBNX6E18Z6T0DWSedLVj3OaPtUWCe6NqCuN7INIQi4+jZ1+VDPLk0sA04Vq8idS3q62BCjei+gFcbx7nfl3KpFgV+CniOTIvyZSG5Hxbov9J+rkcgJ8GKD0kkDFOnZAQ7uS6PvOAp13AIhUdDulZNE=
Received: from CO6PR11MB5569.namprd11.prod.outlook.com (2603:10b6:303:139::20)
 by SA1PR11MB7039.namprd11.prod.outlook.com (2603:10b6:806:2b5::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.20; Fri, 18 Nov
 2022 08:47:32 +0000
Received: from CO6PR11MB5569.namprd11.prod.outlook.com
 ([fe80::72d6:72a6:b14:e620]) by CO6PR11MB5569.namprd11.prod.outlook.com
 ([fe80::72d6:72a6:b14:e620%3]) with mapi id 15.20.5813.020; Fri, 18 Nov 2022
 08:47:32 +0000
From:   <Daniel.Machon@microchip.com>
To:     <andrew@lunn.ch>
CC:     <luwei32@huawei.com>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>,
        <Lars.Povlsen@microchip.com>, <Steen.Hegelund@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [patch net-next] net: microchip: sparx5: remove useless code in
 sparx5_qos_init()
Thread-Topic: [patch net-next] net: microchip: sparx5: remove useless code in
 sparx5_qos_init()
Thread-Index: AQHY+owNFKsLhwrlhky7iF4RkPp5vK5DLagAgABfrwCAANVtgA==
Date:   Fri, 18 Nov 2022 08:47:31 +0000
Message-ID: <Y3dJN/vgBmFfV+dL@DEN-LT-70577>
References: <20221117145820.2898968-1-luwei32@huawei.com>
 <Y3ZF6gLy7hjW0KAx@DEN-LT-70577> <Y3aWLiuC+e03awzx@lunn.ch>
In-Reply-To: <Y3aWLiuC+e03awzx@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO6PR11MB5569:EE_|SA1PR11MB7039:EE_
x-ms-office365-filtering-correlation-id: 718b0219-5123-4395-e480-08dac941881f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UvzaVCaGC4axdIQn1tnXcaqTTGydpzx+3PQutipMe5zK/02CE5vU3xCoa595A2vtd9pSmOxkwatZwd1jJMFKWL1PF0JbNpIttLy+DXKjFrErQFN0C8tEsU+uktoKHIxkGs9z4SnHSQ1Ri0G8JT0mEyv5Zz/E4qed2WCn95wQPBn3qA/t5eyTV6FakOIiK69i65+ldcQ89XjZEEjBkS5WKXWjWdAB0vSbb3Lx/5RkoXA68KDfgtdmZelj5kLkeTMF98zPrbAgNsmHTPU8NaNUyyyz0Q7MDI/+18R3yP8wNUNT71vZqOGpZ8rQMwBHLNVxDbsWtGntlmdqyxBRqv5MMKEtRZ8ExusEx0y/ruqQWW+Xk82hwivJNS9FAiBU3F0Sh5nozARajOZSVTdD/NbJ3Nmnv9Ol0CZXL/mUOW8RFoOwMHUKlPbvg8BaZCQl0XXBUZCK0yQAxvSA6CtbANW0dcII5ocO1El+kcoWk27BDPjbjBhuxhOycvEnMkMq4V93AUlcYaCBHPvNF+gThJQGm1b9BgKCM6w5QmPo0xau+aEOVQKZ03KIzRjRdLAMVqZHzGmHAm+S4EGLfrhNLgH58vOuj3BWkUEParEtDzFa2hnDb4u+Q2EnN7NJalJx3I+lQKFHl7hZpcaeVGyjSxPrt9u811Q0fVfYMUeGsdzPqw6z5TcIc17bMB7A5WStOZxxpeI+cZqinXDXLNTvgyYYOg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR11MB5569.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(346002)(39860400002)(376002)(396003)(366004)(136003)(451199015)(86362001)(38070700005)(122000001)(38100700002)(33716001)(316002)(71200400001)(6512007)(26005)(91956017)(9686003)(6916009)(6506007)(54906003)(2906002)(64756008)(4744005)(478600001)(76116006)(41300700001)(8676002)(66946007)(66476007)(66556008)(66446008)(6486002)(4326008)(8936002)(186003)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?2EYGJjafZMgkAAmmDNe7aGU2BhCgEo/X5Ck7Laez163+jX0R2oXemjW3sy+x?=
 =?us-ascii?Q?gWsYyitBLBAzTG6helaVUquzGskbAJCF9XSKasllw27/qWzyH2+yLM5mmz53?=
 =?us-ascii?Q?D5Gz2auGXs2hHhaR8cvptRHPc6EV8i3dwB5PQUY3D/wPZhV6BUSCOSAUAskB?=
 =?us-ascii?Q?RMQq2tMm7oGRgA+lTtjrrrlQjXOxNZXexv5mEGKPx2Tyv9Ov7i1RFiA+5Evr?=
 =?us-ascii?Q?9zmLQf86BFQSHOaHJTC3dGcMD7wB7XAOLP4O70mmMeR0PgySkNWuqlvsEdY1?=
 =?us-ascii?Q?e33NXnC2tITUUNEmo44PAYV3PEY4Xz1M1tdGuMsBvwWFAcu5GfJJTR+QrmqT?=
 =?us-ascii?Q?qZUvNYkfqJ8EeU6IVl3biaYSRpsJAfBOeWpWnUTnwftCqN3WIDGFYkRpbcdn?=
 =?us-ascii?Q?m3Nb3OdOxNTJzHa/ZxuC7ZujZbcz9dPFyCTyGL30p4hGT5ITdzSwCZVcHP+9?=
 =?us-ascii?Q?c+TwAO8D/mZ7b+EKLJXBRGWwnhfiiZLnKYVJtHzfK/attGQmH1UPG0K+lMp9?=
 =?us-ascii?Q?3cszSbVd6x2okD3vXyGRgslE0ZKvKKCR4R+QYVEUHmD2n/p48wSsraEclDLN?=
 =?us-ascii?Q?emwXN8zV8PJThb9zWLsbhRU2cSrP9iIQdxwmejvyF32LCJpDLxWOCmCMt5SX?=
 =?us-ascii?Q?Rqrvem+0Lm/Awqn3QU6PauR5FfLjRCzhD5SHqm/l6gkgWWWe0tRYHbFJIDAh?=
 =?us-ascii?Q?6JmvzNv1VKL9x6UgmSj5fJw9+XO5omTR717L58pM4muVzG8MBt7zZzthbFmJ?=
 =?us-ascii?Q?OLe8furt+mf0PYhDlpVEhMNi5b/I9vqBNwEhoOy03t4E61IUOVFkRzKCbuw/?=
 =?us-ascii?Q?qOKz9DFIcAoAu91ETWfhpvo4IWC0V464P3CCDRJUosNHDSXRj922tBudi4hT?=
 =?us-ascii?Q?BTzRxRYYfnNMJRkoFEhHvYjw0yaPjR2Kxj6RquOsG2xx2Jdq+a37D6odZ4OM?=
 =?us-ascii?Q?+LkviAoZ3FwuzR3SblaUUaJCMz7uJAXBAi8a+F2zIM1MmWx7bkvqAxCu1BQr?=
 =?us-ascii?Q?nKTos+SQESPBtx4uWJN5St95pCIUJldkf6qwOvyr0ZCF/0MB8eWnaLMeGf35?=
 =?us-ascii?Q?8ebRCCwwwBWr3DRNMusv/MrnwXA5hI7Kh2yKqqta+8rD9rXGiX9NvGqf4NBo?=
 =?us-ascii?Q?qQ0MVMhVC5rGyWrscZ9m1dC6lwB4FOxDGQw7m6lVFOF9X9Tna++jf61M36fh?=
 =?us-ascii?Q?aJzN5V5NhLBJ+wxr5ZB5PimOQQc2VojUtTdSrCKSLlJLARH81ChaKJ0kyV/n?=
 =?us-ascii?Q?mDrKmXMXs32TVOYLgWc6uXmMXC8TlLev4DEMJqVkggYCkKVOO86WARSdN1So?=
 =?us-ascii?Q?ZBENgJCoNyK4F5g44p2FOWqGNWGHB5YGQ46/2iSRhE0t+iLHsdPfKnLFvV9i?=
 =?us-ascii?Q?Mz5JdTd0D/7KkiMTDZZQNxfywKXTbT+/nZ0yRO8IWfxCj00jdKEI27g1k+th?=
 =?us-ascii?Q?SInEmwrEuiMCbzkSkbu8YdMnVhuPKKAE4kZZy7LlYszRreOLnjipta7osdMa?=
 =?us-ascii?Q?PS2dwVNFVfTqBlYxt1q/DAOYc3jVOoQSdnsArXdvyjvd6pUUKiz5xY5HlsVb?=
 =?us-ascii?Q?GHYABbJLcgufwEqdcRLnkCmX21A+8uYdPwN+MgNnxNB9Hv0iY2+1zhNrcZr3?=
 =?us-ascii?Q?TGpgKrNTE7t//Sah74VkGnw=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <AFEFCE3611B26D4E832311ED07CF4BEC@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR11MB5569.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 718b0219-5123-4395-e480-08dac941881f
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Nov 2022 08:47:31.9726
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ITDLznkriACu6jPSzWXDAzzu8yybi7bEZ+j3gOm6z+Nww0Wkviuay9r8EUeXWSFk2Tab/N2Zcc6bXPP0pH9VfHohUXhLxsnvIFH1bc2Ho2k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB7039
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Den Thu, Nov 17, 2022 at 09:14:38PM +0100 skrev Andrew Lunn:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know th=
e content is safe
>=20
> > sparx5_qos_init() will be expanded in later patch series, as new QoS
> > features require new initializations - so this is actually somewhat
> > intentional.
>=20
> When do you expect such patches to land?

Most likely sometime in the next window.

>=20
> If it going to be soon, we can keep the code as it is. If it is going
> to be a while, the bots are going to keep finding this and what to
> remove it.

I see. If bots will be bugging us regularly, then it might just be best
to let the patch through.

>=20
>      Andrew

/ Daniel=
