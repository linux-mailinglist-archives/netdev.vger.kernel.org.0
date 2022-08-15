Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34FF7595222
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 07:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbiHPFkL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 01:40:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230054AbiHPFj4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 01:39:56 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2042.outbound.protection.outlook.com [40.107.21.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB6B46C11E
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 15:26:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JCv9mMBfD8XqbsaxItwuab5jwjFUGoAU3sgBhNDL6sxwf8EUn20TU/0f5N+bdc6h4vwjmWHQ6dWuhyyjPlOlEHVvROKfVpJV8U7g0YFjH0Esxe2bpHhdMnd9yJnzrBbIBZYpT5m5okgOmh3zCxL9kzrELhop2BXEKKWP7Ukgz2F0fzEVSrq7H64nEY2c3cNAI3jyWvg9o1nf5OS7GnqXb5ibI9ruDu9uZEpFpOVHS8fU0zqOTO8dvSHLz3IOFeiM7XRy9iSXJG41HSexrJLEjft1nN2IfY7tbwVDC6UHGULusForneEaOrc3Y//VJPo6Nf91Eyd0IJtGZM0JZkQxJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GTifngPDUgTBwwLCxfzU1Pd0jCfT9beO0EhPgcHAHJk=;
 b=bpBRnGApuMiNq88669qryf3S3Rtx64FH1Vxi4qqTQflab6AnCKhR/Uub8p4fg//gYhWVx6NoajSooJc8+tGSZ8ef/aax67WU99t4WC4e+pL3vc9VoHbBq/AX3RlcWPV4ODouIwQ63I1u2fNk9Shm9GNsLBBz3IONTNq85TRAAWr3iETY3Hvj7as+1h88B7EtQl0gvrNNLh2eSaE38migqkWMhjyruC6ci3np1A7BVkffzlKNyfYtXwOYdYS0knfpdY5knfaTZ9RN0YlyD5uHgR/xDTcyRAZ6/dVRUryn12DeuJTi72xGyBwXOCX/3Cg8Umzb5sCnNlyXV+Pm8S/SJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GTifngPDUgTBwwLCxfzU1Pd0jCfT9beO0EhPgcHAHJk=;
 b=RfVhyF/3yVtCKcMj8zBrLD3vHW3pTpxAl2K8tAk5ZOF51V9JpBkzyWbTca7PL8JnNKRvJzbnid+fKxcjISBQmY4lywmxl23fMwKt9RpfwyTr1WsjSvqV0h/B3IXHNvfOKpyWzJuQgVi25f/kTsboC3xJwJQ1tAmWV3k0a8ehhEg=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB6PR0402MB2903.eurprd04.prod.outlook.com (2603:10a6:4:9b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.10; Mon, 15 Aug
 2022 22:26:39 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5525.011; Mon, 15 Aug 2022
 22:26:39 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
CC:     Ferenc Fejes <ferenc.fejes@ericsson.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "marton12050@gmail.com" <marton12050@gmail.com>,
        "peti.antal99@gmail.com" <peti.antal99@gmail.com>
Subject: Re: igc: missing HW timestamps at TX
Thread-Topic: igc: missing HW timestamps at TX
Thread-Index: AQHYmepVJYOkQdQn8k+cRlOb7lKNfK2wqy+AgAANKIA=
Date:   Mon, 15 Aug 2022 22:26:39 +0000
Message-ID: <20220815222639.346wachaaq5zjwue@skbuf>
References: <VI1PR07MB4080AED64AC8BFD3F9C1BE58E18D9@VI1PR07MB4080.eurprd07.prod.outlook.com>
 <VI1PR07MB4080DC45051E112EEC6D7734E18D9@VI1PR07MB4080.eurprd07.prod.outlook.com>
 <87tu7emqb9.fsf@intel.com>
 <695ec13e018d1111cf3e16a309069a72d55ea70e.camel@ericsson.com>
 <d5571f0ea205e26bced51220044781131296aaac.camel@ericsson.com>
 <87tu6i6h1k.fsf@intel.com>
 <252755c5f3b83c86fac5cb60c70931204b0ed6df.camel@ericsson.com>
 <252755c5f3b83c86fac5cb60c70931204b0ed6df.camel@ericsson.com>
 <20220812201654.qx7e37otu32pxnbk@skbuf> <87v8qti3u2.fsf@intel.com>
In-Reply-To: <87v8qti3u2.fsf@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: db793db0-be9d-4b8b-e343-08da7f0d3925
x-ms-traffictypediagnostic: DB6PR0402MB2903:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HHPyrWYUcjX732chqctHaxGbvGa4y9FyJ7v0HF/WpqoOLfYRRUgjKj5vlPpiYigTIqocUKpriOqaOR80SCnb8RNn2rSKtkqFbB4nBpUC8kd8tNKJ7TsbxrRk1DyfHTUs9RNplagntlK5PdbbwAxE444G4ah6+XyuV3gL06G4M99Zk+cl4NXdr96z5qMYGhE81Ft8y9yAQ9qRNgl9wLpG7WUXIgqSttvURuwVCKWWa26BUmtHCCEtIbbzytGH7vldx2XIbK0TKJnLGW8Y+JA8kjlLOw/o4vEnVGTJWILv6SJlJoZWSPjz2TWrNLbQrM9F8zqVlMB2lJMkxsQQpkPdAXZwi5nQ1T4db6QJNsdqaj2OhK9LgVlQUIXOVh1iBsfsetzy4QwnUBslGv7ob9qFpcG5OBtwVj0gPWdfhJuxc0yIfE1QmY8dMl4C8+AeaaFjpy+ee0z7rMoAbOvu5o/cXo76F9vP+Wo3ny2UZtlPj1Ed0sgTij/IVlpwuuwzZQQZLadDQiqnA5SjMBEq/CKpAwGmVm/VFubhW0nydyalNqdToxqorsWQRClr7HK/g6tdeMNDDxF2wH3q9Ro7WOAHFoPFKg9/B8o7ulu6FP1PbNxqNDsbevLkpk1WworVU8Zm9G8yNy7NLP0UgA5sWE/TaDfn1uetFo61LEqU9AZ4C3KSIrb14S/2pJMzSw6xEYCW+QryXkkudvHdWFk2P2xb3O5PQHg7iuoKJsgkISE/EGGBRNmPTHirdDO2WZk2vRF2+37WCDd5r01fQjJN8abZuhP8n1ElfBFwKRpUkwlHz4E=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(396003)(346002)(366004)(39860400002)(136003)(376002)(33716001)(316002)(54906003)(8676002)(76116006)(66476007)(5660300002)(6916009)(64756008)(66946007)(91956017)(4326008)(66446008)(8936002)(38100700002)(44832011)(66556008)(122000001)(2906002)(26005)(6506007)(38070700005)(86362001)(186003)(478600001)(71200400001)(41300700001)(9686003)(4744005)(83380400001)(6486002)(1076003)(6512007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ugxFF1ImWXunlVb8gaZdGw3ijC8pZQvPvDrRDmawshWgHiY5QjLXCqlBe5MK?=
 =?us-ascii?Q?k9tyYsQt3OpbayTYY+McJOaYmVQ5JoxtWJn1FI6eFzzaG09K9lOtG9gmqRHF?=
 =?us-ascii?Q?nhqImd38UloZtzh25g9O+Wiy1urK5OYqXpg2xLpKfiWEJxEdiT2OUyV+o0kd?=
 =?us-ascii?Q?JGx3TqJatOJd0ChwjEkBRTmr8x68TIf3mgpK5YRHTOYXIqTIKfxHSwm1BN4y?=
 =?us-ascii?Q?YM4VXSa2aZXQzSn9KvNsgQ4t/Pubh5TuRNaALV2RLqZAPtIgI7X6sdRFPWIg?=
 =?us-ascii?Q?pEYNzen5lruKjoNTjiqhvAKzvb9at9sDjahGGvAKlVJMkDMPo8XUI5/PHa2B?=
 =?us-ascii?Q?n7uVz2TD2gw6mFRNypVYt75KZEsKxmIbGpD5GSjDPT43djnw6V5zwW0CyYD+?=
 =?us-ascii?Q?b7QHzXkTmUtPUVv1eDHjfnlD8ttFKApi0LSK2nEVJR37cZZersd33ga5ZJOk?=
 =?us-ascii?Q?T4Nx5HayjvXz4AQxnGV7YgRWxYjxP3GqVjyn6fijjHzBuIipG2EyAOmAxeln?=
 =?us-ascii?Q?1WU8WJXE3Ki3KzqdnTJq6fBUJ0yQaFV2KIhJcOBvwf0aqwbiOxFbG6A3xNpn?=
 =?us-ascii?Q?XlCfH1cbyiGwLdBBRvpEtGgC/L1PzEoKvEeOGATYwzWNT3VfX+zieeHlI20G?=
 =?us-ascii?Q?HYYnLkLOrQyefhZBgeL7ch7PTArPRVvkZSvg5jOBlse/hx6dups3944vpg5A?=
 =?us-ascii?Q?TIan2ZVkby76bmQVisB9CHViopuhkH0mi4i1kFDvGYSQ5dCiB3G6qfwsbQdK?=
 =?us-ascii?Q?r2bTG0QF6sAEa3+XD4a+7joNUlxRFAExRFc896HbhXDrzS34AhEU9YIO7vw3?=
 =?us-ascii?Q?HKWgTViEPxcJNGb4PPerIIbTtg+8StFYrKjBMLNz9ZoXw9B3BOLMXVEzUP6Z?=
 =?us-ascii?Q?Vsghlbw6xue9jVH5NUAyYR6R8/72/TOPUKIAvIHlx6oUUinLn+TatNO768+v?=
 =?us-ascii?Q?5s/4PkpD1hNPGY4/hklOUwBt4PcTK6z0Qe0rAe/Gf7IZLKN+9pf7GLJP0+td?=
 =?us-ascii?Q?x77ANcstF39KObCmJS0fC2CWyf2F9GgP0yq5aTI+403FVgADzDzKJWJe1lTX?=
 =?us-ascii?Q?HGSZYK/G9dw1TlicFuFviykXw0yWFjVnujkxnZEdnC818q7sDV9UKQrViBwV?=
 =?us-ascii?Q?imYITYmMj+7i/I3DOivrPOmad5+V/vJUVqzk6pf2BmDIXzJome3GfUQvRPIX?=
 =?us-ascii?Q?rZ8mkHjfa46Ok1K5qAHA963/yTm1dm4wp+t5BVRMwLZ49Z7hV0oT9Jw0j76x?=
 =?us-ascii?Q?AzwZl4M1LA3/CgZUKzRpHkzNa1iKHpHTpOjbSeKxKPFl52qqibYm/WuqtvaA?=
 =?us-ascii?Q?/nLdFtMf7i29lHpDDxSWU5d6sDzC6Mh51pEu2t5hXao3v39MYphlAZrUs2vN?=
 =?us-ascii?Q?EvUbYVn0C6+N9UKfwUSqAwsx3bY1zQk2mJPLO4dt8lhiKJrW+6TMtB9lznzP?=
 =?us-ascii?Q?nyQ1U0k21O6CexrJ68MEuhfYtS1vgZRBxH5WlfsKJp8GGPaoYzCBUoZKqvlo?=
 =?us-ascii?Q?BJ3+Kkd3Xodq6887b6PBkbEVvG6yM+mloenxc41A/FetqXtcu4bp2Oe0Ql8j?=
 =?us-ascii?Q?G8HzJbwC1bkqKTqJBPE0lDuvDSHFS9RynwRHEz6TAuhoBTxZGJcB+kxvrHQr?=
 =?us-ascii?Q?EA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A4195A377C442A4C8605CA0846EB94CB@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db793db0-be9d-4b8b-e343-08da7f0d3925
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Aug 2022 22:26:39.6276
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gKBOShFztUaKP4/BwqDZ1tSQJDNFiVg7qKLJS0yKGpqBn1LRVDbOQKhRYuRnMCjj+hlSvMhfEqbsLHQ1wckTkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0402MB2903
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vinicius,

On Mon, Aug 15, 2022 at 02:39:33PM -0700, Vinicius Costa Gomes wrote:
> Just some aditional information (note that I know very little about
> interrupt internal workings), igc_intr_msi() is called when MSI-X is not
> enabled (i.e. "MSI only" system), igc_msix_other() is called when MSI-X
> is available. When MSI-X is available, i225/i226 sets up a separate
> interrupt handler for "general" events, the TX timestamp being available
> to be read from the registers is one those events.

Thanks for the extra information.

Why is the i225/i226 emitting an interrupt about the availability of a
new TX timestamp, if the igc driver polls for its availability anyway?
In other words, when IGC_TSICR_TXTS is found set, is a TX timestamp
available or is it not? Why does the driver schedule a deferred work
item to retrieve it?=
