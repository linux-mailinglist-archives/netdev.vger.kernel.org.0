Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B1F059BEFE
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 13:53:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233249AbiHVLxe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 07:53:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234192AbiHVLx0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 07:53:26 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2072.outbound.protection.outlook.com [40.107.237.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 122B66372
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 04:53:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IQRcfLkdZBSlzLNDpwkzIWOu2iqcmNti9YeNWB/yTwy204/yhAEG4rJwauSsx3ZmmdNEgEbaKdy1SbxzC6uFws6cdLJ6HoVntgPUE0mF13CKAQOAOtuMfhZMk4OZsMe3Ge4O5ldp0pUK1w3DyHCm3U1HEzn2iwdR5acMRXz4JJ9QFtdHUQscBDWQuFZG66WbYsZqqvVVnrmbi4vTLPIoWYN7Ww4Khu7lSHEyimv1ZjzEz92ZuCaf1v958l3Ddthagev14owgbzF5AxqhCeypu3maNr1O96oUDWVzB1w431W2JILtgWNSokFHpj6Iql6AdmlReRvtDc8JP5PGc/SMZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=13h8yIBEa/0N/055lDpobIEfcsGHcuRFZxHTrAa3boI=;
 b=gNJpCDEXhcxKYakOIANpxkxIJjY8QT0avc6DznKQunBF31PqpttEVhdh2IPnu+ZMrMYf+RU8PbiCrxeOfhIPn1GRVmOS2UA+MbXlqkJriMKzbLZi6qAz9IfjPCFaur+7R+KJ/fLM/13jQBeO+9A9NYSeRuZSEJ5CUUaNVNLWPZ6cFQfk43INLn8ELpgjRAZbARmeyDobdJ2LUZFO+3/sUFpTsgSo6Hz1AFDdIcm8t6JzabJqAhLjYwcBIMOzBFyR3pUg9F7+Wmgg217jUIZ/LLKGzKYYpvHdFNCWg5+mZ5Wk/BRPa8HF2Gs93T1iZfTbtKCgicqaidfkliijK9qGjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=13h8yIBEa/0N/055lDpobIEfcsGHcuRFZxHTrAa3boI=;
 b=pt9jTnS3tkwu0Pv3b4TuBoUbJle+TaV7Rts7jBVeENLAcTIDYrdPUrS6Ee9UE3UwD4M1jHdyAy2Zra+IkePQDB4A7IOQbUNqi38pVjIBnGDZ7IwLAJ1QVe4Zu3JhlQ+0XRhdwGjotenB+SI5V6Qd7os4Qm4f8IDAoyek5qngAKTLbZTlp2XCB0SlHYe7NBp1U/IP7r29odrTuCG+CSO3T/V9xlvX9SscmW0VtAzBtC+7ql4/2KKWrX3Li5Mr4Ewftw61v+r+9lDPpXnnRfNOg57zDiOi4voMFIjMvs8UgYnHdcAauK4rLSjAfEBVCMIB+gmdPMHGMd7DikjSttOirQ==
Received: from BN9PR12MB5381.namprd12.prod.outlook.com (2603:10b6:408:102::24)
 by MW6PR12MB7088.namprd12.prod.outlook.com (2603:10b6:303:238::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.18; Mon, 22 Aug
 2022 11:53:20 +0000
Received: from BN9PR12MB5381.namprd12.prod.outlook.com
 ([fe80::600b:279a:19f2:a1f7]) by BN9PR12MB5381.namprd12.prod.outlook.com
 ([fe80::600b:279a:19f2:a1f7%7]) with mapi id 15.20.5546.023; Mon, 22 Aug 2022
 11:53:20 +0000
From:   Vadim Pasternak <vadimp@nvidia.com>
To:     Andrew Lunn <andrew@lunn.ch>, Petr Machata <petrm@nvidia.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ido Schimmel <idosch@nvidia.com>, mlxsw <mlxsw@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>
Subject: RE: [PATCH net-next 4/8] mlxsw: i2c: Add support for system interrupt
 handling
Thread-Topic: [PATCH net-next 4/8] mlxsw: i2c: Add support for system
 interrupt handling
Thread-Index: AQHYtXn4svClOURgdUy7tXjOzSjXaa26J6WAgACm+JA=
Date:   Mon, 22 Aug 2022 11:53:20 +0000
Message-ID: <BN9PR12MB53815EAA1B092A309471CB1AAF719@BN9PR12MB5381.namprd12.prod.outlook.com>
References: <cover.1661093502.git.petrm@nvidia.com>
 <96b0d90c1ed9fa5ca2b3ba5e3ba572155ad01b87.1661093502.git.petrm@nvidia.com>
 <YwLgdxKwsBONjgZf@lunn.ch>
In-Reply-To: <YwLgdxKwsBONjgZf@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 773350c2-d852-4d75-5ab6-08da8434e896
x-ms-traffictypediagnostic: MW6PR12MB7088:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1RtVPnksIAUB398WE0RE61ibmwPIwiXC+podXbSJw65mI5VpkwYVDypT3KFMG/vlWaaVnry8aDOC4PK0NK+Ce3xgro1AfE6n0Kx4iqP8I/OQDQMNL2zZCN56bepXuXjKdG1jKE8MLt8quuJJOt6nny9MWozsUZJUAL8+qalddrP3Ycyr6TfBaI1xTaOm/bURKC7yz1JXI7uDuUybH4CEbpxY11MQuXWZsCHoeqI2b6xp+LrGF9ki8t+ZpFHWrggMYy+OVvk2eJPL88//KuxJs5l7UHuIPPdptRK9kDPP+pThIU0c6hgIUMRaksJbrsv6Wd33tqpOp2l8IDkhN4bw8hOushxbxVLxreIdNhDtCUf/NNbYYyXjTa2cgmSytiUAgGJOyJXZmLwoyZtuwm3vREO1dYEQrd8CZG5b8s6bqSSYhOpnmCxABSXKjdzntTQJP3DTaUrNH/hpPWjLuHBjBBMtbyN9BVvdHeEe58z7B/6RyJM1q3ib16Jkh5ncQHizsGIhNvouBTgYGRBUY/gLzzK7alA8CRUcdOOwPBxDeoA1yFVvciyJQoM6HRy1Vg0TFlNlznQs+9iy49suDNLxGoA5v3lUghqn2ABuIMChsI+wnEE1q1QkvrI0K5r9Rsl13s6st+YVlJcuLoQgnR37hrllpLxJqqUXy0tGroVuAhgysAlWEcPkdQAOzlf6nB1lFR7QOseYPawUd3veJcyCVte+LiPTH1CPpSJdaHi7eeXkCdQ6LoNSU94CYK0z77zrrGtUXe2vGzM06RDsKo5Mww==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5381.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(396003)(366004)(346002)(136003)(376002)(186003)(26005)(2906002)(86362001)(53546011)(6506007)(7696005)(107886003)(9686003)(33656002)(38100700002)(122000001)(83380400001)(38070700005)(5660300002)(55016003)(54906003)(110136005)(8936002)(52536014)(71200400001)(316002)(6636002)(478600001)(76116006)(8676002)(4326008)(64756008)(66446008)(66476007)(66556008)(66946007)(41300700001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?oqbagjEwzZ2GeEp0SHoUCRpNhEr/UVfZpFqakm6MeyUL9690BB8FFWN9QxB+?=
 =?us-ascii?Q?35uTyYkp4BxEAPepdde1/nCWbn4d14SZKTWiorsuBTazrP4ZuWH/wvI/x5En?=
 =?us-ascii?Q?Nx6D0f7HZjnEhYjsM2pty+ne8HyvMvklkLFWtuTb9+0ib+imbxPn8T173RWC?=
 =?us-ascii?Q?dk47Op8npx6I7jzVoDgBshY5/nNrYO2APAndDGTfMV0W/eNLC6ng2fhveQe+?=
 =?us-ascii?Q?BnpxbwfLnS3Hx8b0zF+4hXLwKnxLZY1FGyQ2BPdrJ4kLrzp2KDP92qBDwAfD?=
 =?us-ascii?Q?R92YRMLuFGIYaIa4m9SHeitwZJVLa+G8VEVWg72c7mWJMgpobFcyTPd3Y138?=
 =?us-ascii?Q?R6ofOu2JZ9aFq1AWfQK5ygBhf4ZSXYflkbu9gMxpfMW4L6vBRLiIQi2JBVyA?=
 =?us-ascii?Q?alWpvjJxjba04Yy4vCRcRtx1W+sFodvA2m/rXMPcyF/pFd7W1FtGMcYJrXJM?=
 =?us-ascii?Q?oM26R9cb2IVPDjaWj+9FyapAMqw2CQYWd38jvqPUDvDg8LFao4SyI6F4kFGo?=
 =?us-ascii?Q?feSAMnLDdtjwks3Qsm2a+Ret6/HINSMc/UWCsGKK0KOjcxgbFz0dLjJIXOlW?=
 =?us-ascii?Q?IdpSad1fq7AkWLvBCEgWE2ayuzCYGuamiPgmNw3UOKSGHqqzmV7NS45fmrsX?=
 =?us-ascii?Q?SvvpXYF165eLIvu+BOnS9kkcgPyjuRuV/FemEmMFEOmzFcLvlmH6OJ6SK8Z9?=
 =?us-ascii?Q?sUq9swJqtOQJWYHhjDU75Dn1JE+xaalZPf958UgICG/dE3YnLBLp5kU8FMf7?=
 =?us-ascii?Q?iub2EfT4W7BE05W67dcJkYQx2iTkXTHJ9rRm5fRXBbPGIey6BzVU4TCN/dLd?=
 =?us-ascii?Q?GU6p6iLYimMJXY+7H892g86q1iqJ5p8xfyqG7C81UNrwrdZj0t1hxCnk+qI5?=
 =?us-ascii?Q?AWaU5oHxSgNDDUAfcNMCuVAwbrfeYfxB62XYJgVFR7aJGCDJ7R7npBx7KQgR?=
 =?us-ascii?Q?ZH/itdKH6ESub9/BHbNm1r3MGaBo9JEr9ySSgPO/yH8iNd28igmo3gh2fhSn?=
 =?us-ascii?Q?b5Mc3/gTV0ISIYEALlbNsiD9qGwegVmreR5XIXe4kFFxTVlZuoOh/A7bJTEK?=
 =?us-ascii?Q?VG04niv38wkrAP3qe2I5S7UGyL61NhYF0i6br6N/uFWs20OgR59VmenrBDa3?=
 =?us-ascii?Q?+X0dpcKd6eOJD5GVA+NKV2FxIYWRJGQPmkikXWO2PBLWHRcX0ZStQuCeVaAB?=
 =?us-ascii?Q?oELfd4pgISh5a1h3+NeikE3O54U10PE8q/VOjLwrK7lvw1hPTNKXZJgtEeqJ?=
 =?us-ascii?Q?9pGx6mH/DxHb+U2pbxZPG3gM2XaTt2X2TM5oLxBhdXvXQdcYvHFW+GqbsB1p?=
 =?us-ascii?Q?xAzUobjKjwn3d/qnBSNjtnQK6lPNTOfij3MSwrhDHsjNreA2r+pEb8RtXWjw?=
 =?us-ascii?Q?YTwO7Dnqqyuxu0Og7Xm+MrZOS4caIpoA/4WZskbTTo1pbF4EbJZTLSp4IXOp?=
 =?us-ascii?Q?3LRCW74i3nQG7Pk5ktY9HeoPepzJE4ZyxN+9w+to18vkr3zuZnqjA97r0Ai6?=
 =?us-ascii?Q?f4A0LYwQMzggwptiNNKUN2j1leLzGCptpb232O0HsEIzw/z5i2T56EVNHCkD?=
 =?us-ascii?Q?/3UQCIKDv6zh76jOQgo=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5381.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 773350c2-d852-4d75-5ab6-08da8434e896
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Aug 2022 11:53:20.1211
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uRHRV7fV7hN0zUg7KxagA6IjheE1d3Cg6oVVDS92J7UVENoWImh/v+Jg2iUzlr7JjJj+x5ReRQ25lqsARNhkCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB7088
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Monday, August 22, 2022 4:49 AM
> To: Petr Machata <petrm@nvidia.com>
> Cc: David S. Miller <davem@davemloft.net>; Eric Dumazet
> <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>; Paolo Abeni
> <pabeni@redhat.com>; netdev@vger.kernel.org; Vadim Pasternak
> <vadimp@nvidia.com>; Ido Schimmel <idosch@nvidia.com>; mlxsw
> <mlxsw@nvidia.com>; Jiri Pirko <jiri@nvidia.com>
> Subject: Re: [PATCH net-next 4/8] mlxsw: i2c: Add support for system
> interrupt handling
>=20
> > +static void mlxsw_i2c_work_handler(struct work_struct *work) {
> > +	struct mlxsw_i2c *mlxsw_i2c;
> > +
> > +	mlxsw_i2c =3D container_of(work, struct mlxsw_i2c, irq_work);
> > +	mlxsw_core_irq_event_handlers_call(mlxsw_i2c->core);
> > +}
> > +
> > +static irqreturn_t mlxsw_i2c_irq_handler(int irq, void *dev) {
> > +	struct mlxsw_i2c *mlxsw_i2c =3D dev;
> > +
> > +	mlxsw_core_schedule_work(&mlxsw_i2c->irq_work);
> > +
> > +	/* Interrupt handler shares IRQ line with 'main' interrupt handler.
> > +	 * Return here IRQ_NONE, while main handler will return
> IRQ_HANDLED.
> > +	 */
> > +	return IRQ_NONE;
> > +}
> > +
> > +static int mlxsw_i2c_irq_init(struct mlxsw_i2c *mlxsw_i2c, u8 addr) {
> > +	int err;
> > +
> > +	/* Initialize interrupt handler if system hotplug driver is reachable=
,
> > +	 * otherwise interrupt line is not enabled and interrupts will not be
> > +	 * raised to CPU. Also request_irq() call will be not valid.
> > +	 */
> > +	if (!IS_REACHABLE(CONFIG_MLXREG_HOTPLUG))
> > +		return 0;
> > +
> > +	/* Set default interrupt line. */
> > +	if (mlxsw_i2c->pdata && mlxsw_i2c->pdata->irq)
> > +		mlxsw_i2c->irq =3D mlxsw_i2c->pdata->irq;
> > +	else if (addr =3D=3D MLXSW_FAST_I2C_SLAVE)
> > +		mlxsw_i2c->irq =3D MLXSW_I2C_DEFAULT_IRQ;
> > +
> > +	if (!mlxsw_i2c->irq)
> > +		return 0;
> > +
> > +	INIT_WORK(&mlxsw_i2c->irq_work, mlxsw_i2c_work_handler);
> > +	err =3D request_irq(mlxsw_i2c->irq, mlxsw_i2c_irq_handler,
> > +			  IRQF_TRIGGER_FALLING | IRQF_SHARED, "mlxsw-
> i2c",
> > +			  mlxsw_i2c);
>=20
> I think you can make this simpler by using a request_threaded_irq()

Hi Andrew,

Thanks for your comment.

I'll validate whether it works fine for me.

But I'd prefer to make same changes also in mlxreg-hotplug driver, sharing =
IRQ
line with 'mlxsw-minimal' driver.

Would it be OK to send the changes later in follow-up patch?

Thanks,
Vadim.

>=20
>   Andrew
