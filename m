Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37052611584
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 17:08:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbiJ1PIz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 11:08:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbiJ1PIu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 11:08:50 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2078.outbound.protection.outlook.com [40.107.237.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DA8720B126
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 08:08:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ddG2MlHA8q3ODyyiPf3FeSGs1LBinbBt+ITbblmcoc+RnQAgMV+6C6VBXQu5WmH8q/fk/D4WNGF1HESROWzK1ZwceIS5TpnRrDUhfIE7JoxYgOMGfhmSFQjLe2T1y1TGc/9O7GgewlKJVI6Jt+jR6TET2vai5qcVMaOhF7TA6nzCv/UqQlW9c99UY6O0ZNBgHUZEyACmfm+4CetSGCdHoa3wqBowbAka7GA2pzsl5Y/qdSRbYdofHOHq1wnT89UuILnM5TPnR9KG4CuCsWCnX8HW+9l8wdihcw8799L4Pb1RUcsfa8hzFThwhop3riL4AOfwsTmNqlkGnACeYBbf8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/7GILU86h+30zuQ69tGrCIGBkbzUFKr6nz6i5XDqq24=;
 b=Bepr0LLkj6gpMP04vZ4ih6pQB3J/TAI1ohXksAiw3kP0VbpGB5egq8L7vvSxyZsVR2pbZ69h8lfOln8iZ+6fyTgPJs9PgWCwp/0kjfo5lhJ7fxnypyNtGqv/BAfvWTETH3yABZDUfhOWO7xf42ajvAgDOU3pqUwgkGhD+XShILMjsq0GjvMWQCRyQ8dpgv301xiY/wpqCudGz0ciDge9ZY4y3MOUQ/BlbFrWpyIzIqx8SZdklW6I93JahjzKlO8AnwhKS7g2aW/el+t4xXqfWPFdUmeOIZS1yXm3detLLq1co+IAG8DYmEfWbUGURN/o6rKnSs+WdP57k8Yp6fdl8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/7GILU86h+30zuQ69tGrCIGBkbzUFKr6nz6i5XDqq24=;
 b=iLHdyh53kB3IOrq9DOxdohJdoQSYzOiWxrq4/z30oXA8O1QArDh82e7TZ3HC4fPcEW/tSpFLlnQ5oPpEfLGPxTtXrzM7u/tFuah6TVThbtm45IzI567HevE6/l7VK06ObAM7+LC1h3wAlbnDMmO+SDW0N97F9yNbTP6h9mP5mm4z3ZQlssxl3AITo9JRoBzbC58ZKh6VGNUJEtfNz2CH5sVOPl5SGeEiJtGDQDcljmUJZ9UkOkna3BZPEJKBokeJscvhS6kaEoEVWAYdsJBUBWSyEClHnJu0VAnB6GeA2uyVqLx/RAl0VOqx7p2T2hX5FApQQA1xe9DezEhB3PLK2w==
Received: from CH2PR12MB3895.namprd12.prod.outlook.com (2603:10b6:610:2a::13)
 by SA0PR12MB4432.namprd12.prod.outlook.com (2603:10b6:806:98::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.15; Fri, 28 Oct
 2022 15:08:47 +0000
Received: from CH2PR12MB3895.namprd12.prod.outlook.com
 ([fe80::93dd:ccd9:2b9c:8bdb]) by CH2PR12MB3895.namprd12.prod.outlook.com
 ([fe80::93dd:ccd9:2b9c:8bdb%6]) with mapi id 15.20.5769.015; Fri, 28 Oct 2022
 15:08:47 +0000
From:   Asmaa Mnebhi <asmaa@nvidia.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        David Thompson <davthompson@nvidia.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "cai.huoqing@linux.dev" <cai.huoqing@linux.dev>,
        "brgl@bgdev.pl" <brgl@bgdev.pl>, Liming Sun <limings@nvidia.com>
Subject: RE: [PATCH net-next v1 3/4] mlxbf_gige: add BlueField-3 Serdes
 configuration
Thread-Topic: [PATCH net-next v1 3/4] mlxbf_gige: add BlueField-3 Serdes
 configuration
Thread-Index: AQHY6k+Suy3iXvnzHkKtQ90PPv89x64i4jmAgAEHchA=
Date:   Fri, 28 Oct 2022 15:08:47 +0000
Message-ID: <CH2PR12MB3895BF1DF9793B183AE7E68BD7329@CH2PR12MB3895.namprd12.prod.outlook.com>
References: <20221027220013.24276-1-davthompson@nvidia.com>
 <20221027220013.24276-4-davthompson@nvidia.com> <Y1sTc8zJ7bCN85bK@lunn.ch>
In-Reply-To: <Y1sTc8zJ7bCN85bK@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH2PR12MB3895:EE_|SA0PR12MB4432:EE_
x-ms-office365-filtering-correlation-id: d83b1caf-5c85-488a-91cb-08dab8f65068
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Eu67sMiBq9FQe+qvlfObVCJcOXZpKZKBfjWtIJztnhl/BTcv1jQddicN5zQe+w9BLVyOruRt8Kjt9kgglNFY9jw01wyGUCafjSFKXRFZ2E4XCU5RPQhgRGSMCqRHNXDXehU1IQucLpCMlx5xBglC8rqA8s3qP5+zGYzmx9fzuirePTz9DS23k/dUnLOrJ9LCpav1vi6Z685Lc86a41VCbDKGvieCTR1tJ91ezW8mxMRcSgr2fKZyuOug1+jheQ4To6RYR73sD06DC1SDd8r1O277NP/89UzFcRz/lFbkk18v+N4ninUcllKEzrcNEua2C5z2ZXxTVR/Yfmw8N3hF4np+2FCu2xe1UDYNvokoeviYRyEIi5VfDJE+tsAeAQhaBEh/+bysdPYsBtEgsr5LDey0/pAbuxSob1RzNSgJcj68lYfVVzAOTXu518Hh926IdgyZ2khLqx3s4iKyxU45mViMS87xJyWgSaVTOTviFN2FovkvMAbuh+wLc7MothoIy9JPYo6p1S16uVItDcigFcYtFaKrBCElfNJBb4uXhwxaHWKdsa3hX4RCyocMmYCf0ODFw7G8nHmZg7dXFKUZatQTdPrIEDK9/kajgPbt2nRyqNS8VzuNcorHE69fdf1MJ+H5l+ELrXAa3OQWVP23cQ2luZFt2iN4FBLwZSR/CaZK219q17N2xNQt0aKw/IJYwlidvbJ8P+9K0aI80VmUlkXV5Y+7uhYMe1JVRv7wmday49YN9qdWkJPUIFYkeNe5pTUNB85gYDuX4/h0IMQo9A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB3895.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(136003)(376002)(39860400002)(346002)(396003)(451199015)(478600001)(7696005)(6506007)(107886003)(41300700001)(8936002)(52536014)(38070700005)(76116006)(66946007)(4326008)(66556008)(66476007)(66446008)(64756008)(8676002)(86362001)(2906002)(5660300002)(38100700002)(122000001)(33656002)(71200400001)(110136005)(54906003)(6636002)(316002)(186003)(9686003)(55016003)(26005)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?/lOHAmt86f2ba/LPoSJ2ELQ2O6oVy8MIm+Kw2vOqmagzsxzGzvbeANreLWeB?=
 =?us-ascii?Q?dNXXROIErgCr0UrDNi3wBK8UJ6v0e3OkaJxYJF998QEu7GhsbQjB6/aDKllx?=
 =?us-ascii?Q?ceU52myUrxHcHY/uedeNJ1xwAdiWk1aYbr63BDZP+6XmxXP0QVYl5RzkY+Ia?=
 =?us-ascii?Q?pQKx9svg78cz7/YhXQ/yXhFAEs4DGZH6g/EvZ3XZAQRO39oVJv/ee5X8s8c3?=
 =?us-ascii?Q?FB53ZUQPWj6dO6Uveol9i2/B39ZuoUvm+ycsRkK8KG7YgYOFooPuxlB6KMEk?=
 =?us-ascii?Q?jloyE+7Uq5GCzN/mMYS01F8Ll0cD5+5SOTgWcFlty2CmI1IfXCL6YEPTOgGL?=
 =?us-ascii?Q?Lj8rsVXVMw7r0HcahYeQicICB90P6EJXgtD7bpKybhJXjKP5JECaxdpSy8l5?=
 =?us-ascii?Q?zfzpKuKmgAOKcr0ofhkvUL/08tfXhfTRAp4R+5pbYyWKqGEUVNrjSogGSROJ?=
 =?us-ascii?Q?yurqo4Miroscr8Ck7aNb9Vj9Pj22zdmolnmQ8E36WTyBZHpVd1tKqalCqYhd?=
 =?us-ascii?Q?VGXndF2ts4ovr1XvTS5jmV/ZFPoKv93cZ8pBQz6BzQN3Fm4Gga9UL+OpripG?=
 =?us-ascii?Q?CJzmAQzSqw+homlUfT47rtmKBJI0hKxYvnJf1L73pkZJOb0dGQd3DUyCG2sn?=
 =?us-ascii?Q?neYl9U/+s/ipM+Vf4vk21L79BOzdQeFZJeEeoqiz118pvBWVWksiMGYZExqh?=
 =?us-ascii?Q?Fz4tdtq58xL5bGEFZSbo8aFpClw005tGIwHKr6KoZAt5FX01+jAzMpW0Nle0?=
 =?us-ascii?Q?FOka5Xy8AQehMoCwt85euHFu/yZXVLBDJVOhw+LyJEjdaLS605+cQA6cbczF?=
 =?us-ascii?Q?/1/xnD0n3BPwt88cbufg4eKzYUFHkCr+VeJxw/dfh0l+9nwX8dwQYxwM0xpv?=
 =?us-ascii?Q?8laviZWhx64uwPljKYMBjZDkE7XJslF46PjoZ3IarB5cHyaTc5rQTLfgiB2A?=
 =?us-ascii?Q?4uzR8A0w8N3K1TYnrQGXMi99M7p8TKQVVcxp7SILdwXf+xEbyK+5iYPecquX?=
 =?us-ascii?Q?gNejPfwLvSj3fmH06qLXVTUC0HNvl9AAeNwvPJUCzB/lio2xgTUlkM+dRjBd?=
 =?us-ascii?Q?vc07dvfDhLigrpuKkz62IefrqDykbjQdlL95c2RAzIWZ8H8/WqJfzteU1T5U?=
 =?us-ascii?Q?dKDC1mvE0hwrd2zS267DRN7xyk9m9mLxCfNcauoNN8aavmNkDSdUnUaN1xx6?=
 =?us-ascii?Q?hKkiMEQQUsBxzBECjSCtJP47VGUxjvRaoA2l4qjMlv2CaG8eRRSE5jDJVGGO?=
 =?us-ascii?Q?HvwQw4jIQ0ue709gMKdk7zIFND9qKvsSZtbNtSz2BHtUEpdOzFHv/YWfQfQO?=
 =?us-ascii?Q?tCZeQjOrrTTF1Ltok7dUryKYGzQhvzotYlb3b7V4OR8V2HmxyYoFYmwT+CmE?=
 =?us-ascii?Q?M5HISI5M0fo+ghyrKiY1HMC9qdEUzdVdi/8IEGoSOl5IxYdray77Zo6WAYp5?=
 =?us-ascii?Q?FiMakq2xarA3aUu0S5YddOf4ljnjzVlkxjImBHSXKXaW5KWVV9IAeAHlsNHz?=
 =?us-ascii?Q?OxS6Wvq0/RlMnbTzMTErYRt6l6od6TFtY3l4XK45wKjSQHfV++xWECPJbDfE?=
 =?us-ascii?Q?KfTZfUwI25UsjFwxXIQ=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB3895.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d83b1caf-5c85-488a-91cb-08dab8f65068
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2022 15:08:47.6686
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0xTi29CvZoBZWBpFXjHp+ST9ATeKAYSiDXAHx1hlBHwxscU/hmA9R+cJIshXl2ogANjGZgLM1GIcUlv86UpwKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4432
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +mlxbf_gige_clm_init[] =3D {
> +	{.addr =3D 0x001, .wdata =3D 0x0105},
> +	{.addr =3D 0x008, .wdata =3D 0x0001},
> +	{.addr =3D 0x00B, .wdata =3D 0x8420},
> +	{.addr =3D 0x00E, .wdata =3D 0x0110},
> +	{.addr =3D 0x010, .wdata =3D 0x3010},
> +	{.addr =3D 0x027, .wdata =3D 0x0104},
> +	{.addr =3D 0x02F, .wdata =3D 0x09EA},
> +	{.addr =3D 0x055, .wdata =3D 0x0008},
> +	{.addr =3D 0x058, .wdata =3D 0x0088},
> +	{.addr =3D 0x072, .wdata =3D 0x3222},
> +	{.addr =3D 0x073, .wdata =3D 0x7654},
> +	{.addr =3D 0x074, .wdata =3D 0xBA98},
> +	{.addr =3D 0x075, .wdata =3D 0xDDDC}
> +};
> +
> +#define MLXBF_GIGE_UPHY_CLM_INIT_NUM_ENTRIES \
> +	(sizeof(mlxbf_gige_clm_init) / sizeof(struct=20
> +mlxbf_gige_uphy_cfg_reg))

ARRAY_SIZE() ?

You have a lot of completely undocumented black magic here. And these table=
s are quite large. I'm wondering if it really should be considered firmware=
, and loaded on demand from /lib/firmware ?

Hi Andrew,
We can add comments to document the "black magic" tables. The NVIDIA serdes=
 has a lot of speed features and lane configurations. The lowest and simple=
st speed is 1G/1lane (the only one we support in this driver). there is an =
internal microcontroller which needs to be configured to implement all this=
. These tables were given to us as the hardware recipes to program serdes t=
o operate in 1G/1 lane. We would prefer to keep all this code in one place =
i.e. as part of this driver.
