Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 983544C659E
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 10:23:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234298AbiB1JYK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 04:24:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234308AbiB1JYJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 04:24:09 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2080.outbound.protection.outlook.com [40.107.93.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB0CE4755C;
        Mon, 28 Feb 2022 01:23:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c0OQCfT3y9fRLBCjOraAsne0Y4AoWnZYPRWW4OCxeSgVXfFZ+tzUifBy9w+1O+eC8ZrA9uiNpCyjJiACoR0P9wijxvEuA3uYUJVhSjq8fKZNfZzsdIM62NoRR8XxO5yisItuuxWMlXECOVx5ZeKdM4J3EloUsfSPbidfKa0bkH5bkKjJQ3pyAeYYBT+vP86LBVCJyagyf/GM+hoE0C/AVWBGWi0K0/pHNuBiu9E8CVMp96YC8UcU04loUEsdhKNxo1N8rleAmtPNhJcbhBS2rTpcqxxyqzY+8iiAL29J1fzM5EkA6q5WbPwtfd1CBRiIakkWh3ZKno6CJh99sjrIMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BPAyam8+jUzsK7sQLMLOngTcfISD3EqhKVoGm/vKXL8=;
 b=B4i70e5AozJVMEF/t4FUMcYtbVG+ZTltjpGP81mKmlQh//ptDslk/DFcZREdHo3tUDe+/ExBwlHaZjac11xeQ+qlHj+lSzllnuOxqVKQxHqpM1aScxAwrzSRPi+SAM9r0OU2DwmBzHUMWVehiXJfU6D5zaeiCs/d86zOsyLoFy0M6GLxzLJfgTaJpusEfV9syrw33olWx86DpzfyPor7WGVfhsFaJnuDho2np4kWEYQ7UjpYwKsZSRUgcoAUKnMmYhtEwuG4ZubX0L/OBpUMTUYNz5FZLsmhprs6ntXlcTR/nqC9jwRmMkEjv26Y33WNgAFkgfZjCqvydW87K6cyDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BPAyam8+jUzsK7sQLMLOngTcfISD3EqhKVoGm/vKXL8=;
 b=qR35vpjw6vI1rzHPSik0bEO6Sm9uxzltAdPzVscbh8QJY9DCB9AmrYSEabpatyNQxUIASxG49VzmLCoWS00iF8iWMRoTWb3giA77gJt6lVUjbZvi2Y+zfOzzi6gGeR4wONgIZWBhAcAa/ZgNEEfstUJ3z4FU7bUWGp9IGc1d+NtlubgwaFrBBrgBcs6oUKdeLVUh8Y8+TJGvvSclAM5kb6l9ST1xeYFQzl/ZNkiUh6x4miTrgrNNAN0t8VqCXGUlVHi56K12ThIXKyhl156mGcmvWN9JT9LeacF/itILKzAdYxw7l3fyHprYM5FAAmMmYZ5iQLBoZWrS3Nr+PWuTkQ==
Received: from PH0PR12MB5629.namprd12.prod.outlook.com (2603:10b6:510:141::10)
 by CY4PR1201MB0165.namprd12.prod.outlook.com (2603:10b6:910:1c::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Mon, 28 Feb
 2022 09:23:28 +0000
Received: from PH0PR12MB5629.namprd12.prod.outlook.com
 ([fe80::90e8:9f22:94d8:6f6d]) by PH0PR12MB5629.namprd12.prod.outlook.com
 ([fe80::90e8:9f22:94d8:6f6d%8]) with mapi id 15.20.5017.026; Mon, 28 Feb 2022
 09:23:28 +0000
From:   Paul Blakey <paulb@nvidia.com>
To:     "dev@openvswitch.org" <dev@openvswitch.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>
CC:     Oz Shlomo <ozsh@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Roi Dayan <roid@nvidia.com>,
        Ariel Levkovich <lariel@nvidia.com>,
        "coreteam@netfilter.org" <coreteam@netfilter.org>
Subject: Re: [PATCH net v3 1/1] net/sched: act_ct: Fix flow table lookup
 failure with no originating ifindex
Thread-Topic: [PATCH net v3 1/1] net/sched: act_ct: Fix flow table lookup
 failure with no originating ifindex
Thread-Index: AQHYLIP2ps3NM1XoqEyY1SJJ7oKvUayosDeD
Date:   Mon, 28 Feb 2022 09:23:28 +0000
Message-ID: <PH0PR12MB56295725EA49323E5E8A8884C2019@PH0PR12MB5629.namprd12.prod.outlook.com>
References: <20220228091646.3059-1-paulb@nvidia.com>
In-Reply-To: <20220228091646.3059-1-paulb@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: bf60b4d1-b956-48b6-68d6-0e5f068ae886
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 58c8d437-9e0b-4620-febf-08d9fa9bfad8
x-ms-traffictypediagnostic: CY4PR1201MB0165:EE_
x-microsoft-antispam-prvs: <CY4PR1201MB0165539C2BDC20692EFC5DD8C2019@CY4PR1201MB0165.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VCrJ8dumS2zpNb+88qsDn3GjP2+VHJkH110XK95G257O7fTnQbeipFInzsxDFy8rCgQ8jkIpjyVK1y90L2ave01mqfL6jq8uJojkx+OPB2cT3y9JODUw2RgHdVoRn2vYtTSj5JLdhjsTclWt5jnaNLMxsRY/MWbiyw2/BnBuyChtxGlgdxWlQWYDPPolwUuJOz1PdaghgUbioYYSKsBMGBmEBmjXwFrDdlXtgwstPqMQsYvwr9aOFm40EXLmYKYzrG9PVgqOc8dF6J6Acg+mqkH7qkBZkZhXYnLDxAcSpEBa3dnQx6FGYBka15G/h9wckzM2Koejv81tey8FZReaQligWe+tDSEpY0OCNvg8fzkoAUWhWAxnkZ4FMS8q7tZk0gQO5fV7MjjZgBkBx6xbZNwF/nu/qUdpd7/Et+c5gb9OF7iufX7+WVSr2fXSvRNRhPkkqges79ggPmatgXlP2sloW6ZABUmqrgVRBDCQNNM634qcOUt7dNEpLtAL+OO5+GeMyrPGGMzN8Yle8Lf5dUsYkwwQO8sIyiIgdyP9h1DX9XplKZuhsHac8ZIeuxEJLRDU3WTv0p0yIupQc4M6ABQpNEQvJZs0yEh0bWqOllZ0HOPU7vzytjJVigVKuW3OOxSnLv0TuBoeKhpvA0q3NoCNu81IEIz8qpUr2nifCCvkyfJ6a/YU/l8Q3KOtRR3hHDO8FElC5QUpthUsGX5+THNys2Y3JvvmLt5Vq5TSbRc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5629.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(7416002)(33656002)(9686003)(921005)(38070700005)(38100700002)(558084003)(8936002)(2906002)(186003)(122000001)(110136005)(52536014)(54906003)(26005)(316002)(5660300002)(508600001)(4326008)(8676002)(64756008)(86362001)(66446008)(66476007)(66556008)(91956017)(66946007)(76116006)(55016003)(6506007)(7696005)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?TSzfkMXSmimRyiMJnBGI/P/7mNgTIumgOsIQDmKQHChMdm88nNeXsz0dhy?=
 =?iso-8859-1?Q?SkQGOdVBg1j+S45uJf5XAhAWuH2QfHMYb1X1Nm6WkE6gArYtZDhDYlk+lY?=
 =?iso-8859-1?Q?7u/ut1BSuWH1236YEC/4MaKo+u9v3V+sgn8SNEUdvwliOg3RFQlvCd7vfL?=
 =?iso-8859-1?Q?cFkb1hJQ7AWd1Yc5B7AYBB/TXfiLpXGexW+2w5UP6bViF8pVLsUBMECGqN?=
 =?iso-8859-1?Q?vfWT7Orv0hwo/BdpznWWtKwrs/zdpk6A7z7JZtjVzPDl6KhpHOBKcu1Rf+?=
 =?iso-8859-1?Q?rEbOIGGwdiOebDc7kdcQ59SD4KeRgjGM1IPzvqzQJLIBjTkVff9vwBOUwj?=
 =?iso-8859-1?Q?Lmnt1RAhi8uHErOhfuplu6APMV5LZOjZLkiLTYPdlWLAjOc+poqu/DIcwq?=
 =?iso-8859-1?Q?KkqkQ5f/d/jDwr9kcBzVS7bQwYHvIRLV2tlk6Z0GMmrIre1pvsIQC9HLDp?=
 =?iso-8859-1?Q?jCUTiCiq7S17Ub1dXfeqw9V4rmJbrGolqYcmDvZk5cWkWrGbyx5VerXbya?=
 =?iso-8859-1?Q?ofmvmRcZJlexFJSj1aT0B1cUYJIqIRYJUoceClQ4GwzmHYiqSP6HoVl88r?=
 =?iso-8859-1?Q?L3pebEHYdy0Dciq6ACejP6/Zc2NoLtg2bdMWUR3Qa1UCh3RHB7isL7jvQ2?=
 =?iso-8859-1?Q?IEjJXwzj01UW85J3Kxb67BzWU3pU99OgWOwOMKwlG65C1hFa8ql3UGiUqf?=
 =?iso-8859-1?Q?HfqpuCd5di45pxWBuIC/NErU1WSSVOpAxiZl67YZqxT0xWgzecJ24X9+/X?=
 =?iso-8859-1?Q?kyj9xgN19f9HzXt1kmsMfg6UdmqPXht6J5Z7RnGOh6OpY3NeyahqjBInfM?=
 =?iso-8859-1?Q?rGsexVZGgUGFOEEYnAiX9l2udAYqV/w9YSvXYG4wWipSJd24b8eHZWyJMm?=
 =?iso-8859-1?Q?9hPAIoJTgD/eCRHLISvVUfYb2NrCSffISDMii20SYODMUUUM6wWSTJk5AJ?=
 =?iso-8859-1?Q?nRSC2NNhItCP4ZAD+JSkgocv5hcVJDl46Pz/ef8v/ORVBJT1x1pvby5YC7?=
 =?iso-8859-1?Q?4BjBgyvtvWD84V0JmqYSh0R+U6onJ9h9iB/L0HxeuCcnA3NRpYwYKWwnfW?=
 =?iso-8859-1?Q?kz1J3Bradvk54Wc9SwOLgAnLWUaScwmtORO37/BbmUoSV2EiHlSFmbvxcP?=
 =?iso-8859-1?Q?MIeVPelHZtR2DFPsdML82r7qQOsroWfdmUSBdMKLTgv1YqdkMXrnNB3SO4?=
 =?iso-8859-1?Q?zwxxDg5PFtLnO9yXxDQunfu/TTzTMUTOCR/R04h5vuuHWD3Rs3DKdmJSVZ?=
 =?iso-8859-1?Q?ppIuDxmLubMVoU8achNrnYj7ZGIdQ5t151UOEyyINI9/yP5Yj0vE8XNgJk?=
 =?iso-8859-1?Q?c0Jnm3vwL+d/1+T1W/ijMn1XjGks0qoxwzpjuu9J+Kawbsxf0E7Ua1Ftut?=
 =?iso-8859-1?Q?sOGP7wCcyFZLtrdXCedNiK0/A6wCxK9mz1r1aU4FgVeY4Eqkhq6/TfwLb3?=
 =?iso-8859-1?Q?nmbz2Dsl5n6ja0ajpol6I2XbYEAn2EmnEn2qmrR4m9TR4sGU/fy9MyZpga?=
 =?iso-8859-1?Q?0Xo1uvJyClWZnlXivOtQn/jiwOgDvj87UkADNStVz4hhJRytRGmKQ14j6W?=
 =?iso-8859-1?Q?yKmUbbVh3RQiwWO8XTuuDJhu2qOqkyltZS6vt/0oibDtl4eJtSEW6tjj/B?=
 =?iso-8859-1?Q?k9Jxwo+cZR2o3X40jNy6jOByv09FGBC/YtX13CL5+5ZTm2+gzL8L9Liw?=
 =?iso-8859-1?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5629.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58c8d437-9e0b-4620-febf-08d9fa9bfad8
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Feb 2022 09:23:28.3473
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NeAwqrl3Lp63+/hLa+zVm35ydnZOJxQ1mVtGWPfoxDsDNctPzXKtV//So7shcZ6k8DQSnpNbbjI8bQTN3tqKJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0165
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sent old v2 by mistake, please ignore, resending actual v3 as v4.=0A=
Thanks,=0A=
Paul.=
