Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD545BC419
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 10:14:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbiISIOR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 04:14:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229885AbiISIOL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 04:14:11 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC2B913F0E
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 01:14:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1663575249; x=1695111249;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ijijmSdcKYLA3gGbJxZ72cLPS0Gz/+Q1lY/HNPglu9s=;
  b=wD5BfKrc5qXLwzPwHIDdw3cVm8tV4zwz21ggl9EFHYKy/M5omuhqvYEx
   xxcjkVoqvJ8fv64HzYbNC7UQaMLvZ9C45kAfcdoJvFA0K3Slb6qaC0H4g
   2RZdZYLyrgcidZB3j8M4l9Q04teMOT5J+358ASPooA1x4vgOrjk6g2SmL
   mPR2GIEX3YM60JPnMA3ODxf+J4iLTAyScsUJ8zTm1kZBIrOvs68iph4T7
   9of2a/JBH4GrZl3TthLkN2ieHmXQNTnVcQ3wisf0K4v7VFG//4I+wjlHt
   mWACMVWYLpIBb9I8OTXXyP2qBB/DGX0aMZtATVQzgZ6p4Al+p+hdUSXsj
   Q==;
X-IronPort-AV: E=Sophos;i="5.93,327,1654585200"; 
   d="scan'208";a="181049225"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 19 Sep 2022 01:14:08 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Mon, 19 Sep 2022 01:14:07 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.12 via Frontend
 Transport; Mon, 19 Sep 2022 01:14:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gL32h0mNoZN8lOHQ463BLUlzsI0fvdxITBbxJAs6rY9e7KYS1nuJueS0WaLU+GghSj6d4tX3XMaKoCIIVUWOQ/fyHwQJawMIzD0J4tM8hzu7DijIF36KmCyJRZCvxoleQX3NCDmy6ppMylOI6e5lbRbpdCjKaHRyLbjfv+QdeBViBfIvRpqmLLTJcBI9evh9p0VoLRDI/ZIiIGwzGoMPEuSoRV4A5TjDtTnRXKs942Uz2i1BzHx61mDHuQKFusxL7znfudfWSmgcyOS+FpsEhZizwQKm6DHw7nZlzUl3surMNL0Ii0roNg3mUI+tQl14n6qvEWaIrUPsDOAUX+6u5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ijijmSdcKYLA3gGbJxZ72cLPS0Gz/+Q1lY/HNPglu9s=;
 b=DQ5XmsaWqQkbyCo5pP05hSzkQSeh+PY6Dmz4P85ey+BJ8dvjGl8h11wZPuEHCAujWhtmuXHFUR4ym6tIAZI/fuwC1noeXAfoIfIJy9hcgQzIkuEEy4h9xFkQiM/sQ+vdyj/QoHD8NobgE+4J20RXqyQG0d6hUT37bLQG9F9HOY6MCntNqrIMcmUoXJ58X0k4mA2MFtOSu3aNVFI7LhtM5cYqEz+5xIosl94BF1KjdUsbylopTUtXCF6VoW5TkHKhD7JiHHBfttRt0T7zjhVom2eU4pcDRUmsdZf0hvCmXRPNdBUX98iuXL98AdotHB7C8newl9XerKeMaXR+TEHmFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ijijmSdcKYLA3gGbJxZ72cLPS0Gz/+Q1lY/HNPglu9s=;
 b=Yrtb81n4Mxy7i1skgWDI+ZPpxLoh+RIaHdOZrQw0rsteJ6JDpbhqEIAL1Qh2GDWyA6Y6G264MCP3zIQea+b4bKXAK3UfgbrFtOu42qaz9vxd1LPUKRMd8mbqAqCt1GLZEztIdUrDWzi+g/UwzBYk8c3K9toTL1u/AFq7ly8C5ZU=
Received: from CO6PR11MB5569.namprd11.prod.outlook.com (2603:10b6:303:139::20)
 by BN9PR11MB5243.namprd11.prod.outlook.com (2603:10b6:408:134::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.21; Mon, 19 Sep
 2022 08:13:57 +0000
Received: from CO6PR11MB5569.namprd11.prod.outlook.com
 ([fe80::e9dd:3bcd:855f:dc9f]) by CO6PR11MB5569.namprd11.prod.outlook.com
 ([fe80::e9dd:3bcd:855f:dc9f%9]) with mapi id 15.20.5632.021; Mon, 19 Sep 2022
 08:13:57 +0000
From:   <Daniel.Machon@microchip.com>
To:     <petrm@nvidia.com>
CC:     <netdev@vger.kernel.org>, <Allan.Nielsen@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <maxime.chevallier@bootlin.com>,
        <vladimir.oltean@nxp.com>, <kuba@kernel.org>,
        <vinicius.gomes@intel.com>, <thomas.petazzoni@bootlin.com>
Subject: Re: [RFC PATCH v2 net-next 0/2] Add PCP selector and new APPTRUST
 attribute
Thread-Topic: [RFC PATCH v2 net-next 0/2] Add PCP selector and new APPTRUST
 attribute
Thread-Index: AQHYyOhr0eLaKBLPH0OLQdjmRTAnr63maD+AgAAIHIA=
Date:   Mon, 19 Sep 2022 08:13:56 +0000
Message-ID: <Yygm/ZjoIc3yhPso@DEN-LT-70577>
References: <20220915095757.2861822-1-daniel.machon@microchip.com>
 <87illjyeui.fsf@nvidia.com>
In-Reply-To: <87illjyeui.fsf@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO6PR11MB5569:EE_|BN9PR11MB5243:EE_
x-ms-office365-filtering-correlation-id: 8296fef9-17fe-47fc-c725-08da9a16e646
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QNHnbdG7vBF7Jso6lL9bkDMHQS2Omk3tVM23sNxOj85+cJGpHp49IMRGv4lPJ884wDycAG/CK5o9t8A7+ER9n+TEh6zYqCEqO5UuXQmAeXDJ/Df7cHEFDi/4otfZFiw0TTFzOEbN88mn/uxfFb0iBY8QRR4eELGvKlRIvnTQK+ZArNL33BRtzwjP0mu26OuGWiTOh4Ymi+yVCpi8ButsznYmP1lwpf3xI+MdCTyz21pa1wofnDr1Qs+gkCpzMj5gaFyMMsIjwcaoO597l+Z6lhi74mJxED7hIaZw2wM1+7CQnhR1OncZvZXzM3qbdtCe0C6pM4MDZkH46OEH4vEC/F8uIM/YVg1H7GOUxXyXiUNoCfg6V90SmJ1Qjk754x5YHxPqUltNiY7e79WOd9gMc7WdDdof74EQ8drWOZyQ15zOiQdeNsmPghaSIIvrtVC7sgrqXLSOcMupgyS94X6DvIIfHDUiNN8WJAZKCwc6cQOM1eMXl30b8FlbwWll1snPlyLvvo/STQzv3Bcvt1xc0A45meug4xPFGAS75LgQ+YVCRwo08V3Quedh9G77WYGs5MwrprRiYVA71VBYhTRoAfbdh06bpudwU9zcctbdA57JcykHeWA9nm8I9ARdOQHopBB/UFtvv0OSOjXb8ri6x3OeKx27IAiN8rBy0/eb5GOj4xVYc9hVs9ZiAZfqbHo1WV4w8ucb8hZF7rrq+EBWgW6+o6mlN7NnPDM6kP4hEXDUz6Iqs09XjEr8IqJeZW+DjoT96JE3DYzyMBXSP06p8w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR11MB5569.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(366004)(376002)(39860400002)(396003)(346002)(136003)(451199015)(38070700005)(6506007)(4326008)(2906002)(71200400001)(38100700002)(86362001)(8936002)(9686003)(6486002)(6512007)(26005)(76116006)(66556008)(66446008)(66476007)(8676002)(122000001)(66946007)(64756008)(91956017)(41300700001)(478600001)(186003)(5660300002)(54906003)(6916009)(316002)(33716001)(4744005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?EyiJczH/R+pK0qJ8LNYkItwRC/7mQN4tD0U0aQDKiSxMLuoWFJNDR5xMCXQ8?=
 =?us-ascii?Q?LxZ8Mr7ICL3GpyRluHYWB3vPzyAq3qQzvSxkKveKBo51l3SNttoPLm0R0Vyk?=
 =?us-ascii?Q?Aihze6a87uaIBFiBPwFWcgP/A5C+ZTpKxkVih68ZYl6Hk4OUbfF0A+p3AIFD?=
 =?us-ascii?Q?140Ca+LdWwycPFzRWWw82SVlaH8G4J4DGal4uj4e8y1y3UapNiYDHbXni9kf?=
 =?us-ascii?Q?hSNh3x3HkSDYmHMXOLBkQNlAfiw26IQSI1jkOBUADFGP/b21EMgGyb63abWS?=
 =?us-ascii?Q?DhsJnSMewrWOf6DmhD6GUY1hm5KTAAQ8jfLfWYtjwVb2fs3I8MCmW+MHFold?=
 =?us-ascii?Q?Mnz831K/BBT3THpJFb6XYri0trCgWLDXguJxnS+cDDnlorlh7bOKhD9bhVwv?=
 =?us-ascii?Q?HAQ+XvaaNYb6wbN2Lh1PfCnLJH6guDY699bW38UtnSSUmfAdhnPQGOPgLtbk?=
 =?us-ascii?Q?Nc3+gnYWXutsu5dt24cIn1AQ4TzlIJJ43htC3p1PHpMpqP113V++2RUIMoiz?=
 =?us-ascii?Q?T/z0roqtYPnyIK9uYdFnny+V39fsoNY5GWNHOEjiBVieJCa6vQZX+hQuPgKx?=
 =?us-ascii?Q?v0L0lqTITK/wB5/6OeblRK1otZ0F89w2cP0IsnrbRTJ6WlKUR07U4L5so4yr?=
 =?us-ascii?Q?xP2ztlveDZyMFAOoe8Wo2R5McORjJKMvCBnohu+TY8b2iTVFouwZ4j5UnXIi?=
 =?us-ascii?Q?1U9+8Y7SrNcdD/z5G7+cQJifMyc9vlH+eIF3L0i0xcbCGsdcNRmXAGsXX7cA?=
 =?us-ascii?Q?XJCZgy7Rrr2GKBbW2Qm4e9IUvb2ZhzuceceJti6L+bgLnReB0nKHD2ZkTcLC?=
 =?us-ascii?Q?7jLJR5dAhrPv8JJ60j8p0wJxOvjuHYZm7vunSAXlxERd4WQBJV75NV/LtG9m?=
 =?us-ascii?Q?ISTQNgOH2123KAAcwQ/Mmdmyjb/oG3m9TQyH5mKGnUIDKjvg74lUd6pqzsyl?=
 =?us-ascii?Q?d4C02ueI+v4Wd2Oecv6snqPbgPKM47c1yVJXnu6IhEu3XlBvEqW6Ek18iaxB?=
 =?us-ascii?Q?qI1VQN2zz1VKsbpNKIVSIyj0nHmgyTgjf95fQMMqxVbxAd59En2XMegQcSr0?=
 =?us-ascii?Q?WoHqTzjGrIbrD8ZvEgjgiZdSUm/kl+D6FQ1tyx1BFYwZK4dm+T9KYbhxYfol?=
 =?us-ascii?Q?FKGS9/Q3/ur5fM6dXMdsmunPI99drgjB1bV5loEUh312EGkA3+vGD3C+kIpl?=
 =?us-ascii?Q?kqg1i6NRza1tZ38hniJ+3IMmPw49NlgYvtC0RwQanNUJ3mW7L5yyR25eKCdP?=
 =?us-ascii?Q?4mZk8GeF9ch/NtkO69CnEBdmD4pULHIq7knXc3xevO4lzPo4bFfZ/n6XbgY1?=
 =?us-ascii?Q?5+8hTI1LHH6wRg9oP+yma7fqcnDDNQwyCKZU+MRhDSm120ZxmR87Q7fZmaX0?=
 =?us-ascii?Q?2qqgHE0eME4ge8qFqicBBrWpsQF0lN+6B4zoi93xhfBHqSTcAtmd85BC61KS?=
 =?us-ascii?Q?TQs630N+bxlupziZXzfobcA3yF8uQAihzgGSp1vlQS8jz+cGKJjHwl/8xJpE?=
 =?us-ascii?Q?MoRVUUjn3ZU39HMArUtv9n1BCvgTPzO/m7Nq6Jomo9qyV/X+mFNcWu6qvbrk?=
 =?us-ascii?Q?eHmm6Qow8SrosMEcnFj6olyl8fDk7jD99J9+1ZYChCiUGREN6yPNGUmMAYu2?=
 =?us-ascii?Q?i8hw+2EIJIjJjf3Jgvv1HC0=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <04B9E9A4C28E8A4088571AB60FB4059C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR11MB5569.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8296fef9-17fe-47fc-c725-08da9a16e646
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Sep 2022 08:13:56.9546
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ecHeNc+Cbxb7vMvDla7ocUqxs1ZWGxKvYw9WBg2/QsHmX1smjIh0NgNW4qaRbIjgVUEaKP2Ae+A0dZxnilioSSnZ+QkUhGzRFKqGPZl06XE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5243
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Den Mon, Sep 19, 2022 at 09:54:23AM +0200 skrev Petr Machata:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know th=
e content is safe
>=20
> Thanks, this looks good to me overall, despite the several points
> Vladimir and I raised. I think it would be good to send this as non-RFC.
>=20
> Note that for the non-RFC version, an actual user of the interface needs
> to be present as well. So one of the offloading drivers should be
> adapted to make use of the APP_TRUST and the new PCP selector.
> mlxsw would like to make use of both, but I don't know when I will have
> time to implement that.

Sounds good, and thanks for reviewing to you both.
I will go ahead and add support for this in the sparx5 driver - most of it
is already implemented during the tests anyway.

Should the driver support be posted together with said non-RFC patch
series?

/ Daniel=
