Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC0E35F3CBF
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 08:29:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbiJDG3R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 02:29:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiJDG3P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 02:29:15 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DFE845F56;
        Mon,  3 Oct 2022 23:29:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1664864952; x=1696400952;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xbtliXU8Dk9vA7pKtmGIxz7L+J7aS9RJwD6Anm58pAc=;
  b=2W6+Hxmh+gB+LajMeX0MyOuDtqBoIRLi1BeEHvInUVcWv2/KxKlpDuZp
   JbGraFqKt3aQnPXHlSE5M1N4hlUsLi43zWuBiIW4lZy7lajxOdlun0ZlO
   2CGwmJcI1WK2tWC1ZlC7wPMgbGrhDnoFfO7cb5VKBpVyvV8simDMAIpIR
   T6jDj2Z5WntuV51drMofMvjRZoEZ0vWGNt66m+ztssQUzq0NU+7zk6wsD
   dNOgTc0SJZoskNCYN4c40UAt2NyhonfHWTDztm5FpRWqPEr3S3hc3ExA4
   zdqSlyXQC7FQ5yysAvzIl9JuE2akxu1Qwyr/mI4jZaMgUFp4GSAHkm/fk
   A==;
X-IronPort-AV: E=Sophos;i="5.93,367,1654585200"; 
   d="scan'208";a="193687563"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 03 Oct 2022 23:28:49 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Mon, 3 Oct 2022 23:28:49 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.12 via Frontend
 Transport; Mon, 3 Oct 2022 23:28:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gcE+CG4kNzh46x+MH2PXFHo+Sn4QojOoHOxEzFXsX06Hm5utLsFR9tElZoMDZvwd/BAT57792iClA6NBAfHmuyq6rZr7Mpi9jV08feDtUdQCgnVGl19K/36KaEyl0CPaBjHBhOpnrAbHy0RowtqpJ4PAayPHg1c1o3OrKkPlIT9Jgnvhb6kbur6odo1Fca919j194xr9EIEbFvmH8na5ftZQZArXKvNWG1Moi5OoS8BBv/iorA/QJycMqmumDY9G5WLbK75K9Ah3Imq+28jE+fb/G09Ve6RoYC0QJbVHy84dcca+H5cOniKPvJAVCreezx281NfuPcZp1xptXLIBaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xbtliXU8Dk9vA7pKtmGIxz7L+J7aS9RJwD6Anm58pAc=;
 b=i4++f3z2Z4YmqSQpTthdsNPNgXhMeyOtTEr4e8nYb3ht+h0NiB/X8bJqLO66C1SS/R9gYuTHzP+4CCEy/XJcm7uwBqceJ2SsB3yXzZI5JIDG8zRu0f6VAnQzZIhRmKsRGMaRfOqHDVLYxhhCiTtgBhFYDfWB9OiYZjNMqMb+OCXeNoZwAUoOdGOyibOmZs7CVv8K24xiKMUNYPoo00KGtPV9myglNvaYbrFmqSHir8HcmRjrFY4k2NBmMoxHI6I2cEMG/IFazNEXzjicj/N3OPHz8k6MXlwJDNv2TPIQpjF8lpzyR/fsUKlbZS16WvH1GtyJbkobmJY86IRgkFGaEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xbtliXU8Dk9vA7pKtmGIxz7L+J7aS9RJwD6Anm58pAc=;
 b=QRiyM0JaWrOiSuIL5/3g40YVNgPiwXkgHeFX8/Nkakr/NfF8AB6EWEWBxLlZjMHtebi6nawrWRNwKTTH1riyDsfeA0LgGeo098NVZPipSRtH7W9hRe+5BDHJjL7BqIaulDHcxi9cKUlBr2+88J7Bx8qZdB7SGq5ujWzosqsX01M=
Received: from CO1PR11MB4771.namprd11.prod.outlook.com (2603:10b6:303:9f::9)
 by SN7PR11MB6726.namprd11.prod.outlook.com (2603:10b6:806:266::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.24; Tue, 4 Oct
 2022 06:28:45 +0000
Received: from CO1PR11MB4771.namprd11.prod.outlook.com
 ([fe80::5c17:f27f:fd3:430c]) by CO1PR11MB4771.namprd11.prod.outlook.com
 ([fe80::5c17:f27f:fd3:430c%4]) with mapi id 15.20.5676.024; Tue, 4 Oct 2022
 06:28:45 +0000
From:   <Divya.Koppera@microchip.com>
To:     <kuba@kernel.org>
CC:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>
Subject: RE: [PATCH net] net: phy: micrel: Fixes FIELD_GET assertion
Thread-Topic: [PATCH net] net: phy: micrel: Fixes FIELD_GET assertion
Thread-Index: AQHY1vHRevzAhEZTnESWHfWEpchRQa39XQyAgABohwA=
Date:   Tue, 4 Oct 2022 06:28:44 +0000
Message-ID: <CO1PR11MB4771D917426DB1DCDB5B50D0E25A9@CO1PR11MB4771.namprd11.prod.outlook.com>
References: <20221003063130.17782-1-Divya.Koppera@microchip.com>
 <20221003170845.1fec4353@kernel.org>
In-Reply-To: <20221003170845.1fec4353@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO1PR11MB4771:EE_|SN7PR11MB6726:EE_
x-ms-office365-filtering-correlation-id: 2d85b016-45dd-4966-3c85-08daa5d1b03b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3i/3da7T87QvGNjDBoNWIEmUL+k7PyWi4wfmNdj4dg2MSErfoTxRrbfvnumfdQ0MxO/4nXHR6OZ+F+ll4kH7eK9DWjqcIiqG1SiqaD17POmBxHRyZjM+3gl41U8dH+t09b1e0sdnfs9kE5RT+2HNVwJX8zqFbC14KCvnflXnW0NreC6XvC/VTT8Yu1pmBnlR/GWrYza35/Rm1x06QwOYiwAWfVvBfzfJ4oLKpn0QiI0vWDnKLucmYpQVjI63K8ZPWnSerolZu/juQK3SwY3prIUS75K8zQpQGYHOeo0nXy3RnMV1F10wEnCEdAB9FB1Xe0fOAR53XTZZGII3IcJAAhRc51mSKGHoLB76+3rCNW3vQojNzc/o7gkVBosclaE8BlngCDukSPGbETz+/dg6t6xQ74Hs7MVY6GaLYh4FHNsg29mZw7AY0/xJSzrdFk7/FUIARlEo65ID764dAH6I+hDej4GSDI7O7opd7oIjW65eXkqzvgXm7EbLrLI9+WYDQfQbFht/DWoZssw9CC0xma7juO8KXDq8uKhiqSby+eytfSPG24g6H4C5ecWcDl8RPToRhWefyHIqN+r76n80Ch022wZT4rOnUQ7TZbIAlPLRYf1BAsFU4AiZAQVNBsOprqErIaaq1SRiXraeOK3sMnghbr3nfjTOCowamObZbGSM87m0OV2TBuAys9Ve87MoBsNxsJpjmJSOY/q9jAPpxAHpg7yRrGRK6pvXIblEl70L7im4ISu5SQCkjScuTqyEZPfxw7y6z3BmET66GSmgGg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4771.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(136003)(376002)(346002)(396003)(39860400002)(451199015)(38100700002)(122000001)(9686003)(26005)(76116006)(71200400001)(41300700001)(8676002)(4326008)(66556008)(83380400001)(66946007)(86362001)(33656002)(478600001)(53546011)(186003)(8936002)(54906003)(66476007)(66446008)(64756008)(5660300002)(6916009)(107886003)(316002)(2906002)(52536014)(7696005)(6506007)(55016003)(38070700005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?8fHyP3GV5txQI4iMSpR2WgQ5ilUd3Vnu7ontv1BqAJHUL1NyXsNbAPVUqntQ?=
 =?us-ascii?Q?INBH9XIktEbP/Oyamuvs3lG0/FK92wCb2pCtJQirXj9nUWL91cGyPJlSumVr?=
 =?us-ascii?Q?Tkc9fCThO/djuT+QU/uaoAmvcaK18KZctRy0w4mzwSLNW3nCW0Xtyu/kEg4h?=
 =?us-ascii?Q?3/PLFodvuwotfIxKdbl/Mb/LwfgV6hkRLHn3n3KRqiAtru7Qrp1b+Ui66O7P?=
 =?us-ascii?Q?kU8tbtn5hqzzJDM0JjUrA8NmU0gCZU+yklsXb7T/i27HUxL+Z9TVHb7mS3gB?=
 =?us-ascii?Q?QJDB5GDE5KEHsFBX48fnaNIIQR93z7/PTGCAccFsUjwDl3SdZyeOldd977Ug?=
 =?us-ascii?Q?V1oG9WSTXk03Ip+8jmrH5Ku+oMLXEBfb5AqZQav7QsTXI7ve14fQ64SuFDWN?=
 =?us-ascii?Q?Gp7xkNBL2yOSsx6lkEsqAVgwbRg9zVE+P8yhIDqu4RdV/++otvEcaDqt1PHL?=
 =?us-ascii?Q?UWYxA7ExSx+9urtiDbVJilXYMFV9fDbSTx8EgmIsi52p4il3PQFW+p2bERsU?=
 =?us-ascii?Q?ykRNR7uoTyZkNTgKJwvnLLqmEefCDIRHcLdRNRR6XEkkHQ19RQo7PKXaq0Ad?=
 =?us-ascii?Q?5MCylv3JYhCR4hSu6PUek4ItTwnIYs4mS26iwaOKLASJ/CotcZLfU9qGP4yr?=
 =?us-ascii?Q?AHLY8zDAcjl40nobmPOs5eOHkrVCeYwJHHF/j2i8j3GzRN23R6YVG/wXI2nA?=
 =?us-ascii?Q?wp47gNbJtQWxtT2m7ijI6fjSha4wcaKFc3Vx6Lzffyqd8thPWzw9zqIGqGNA?=
 =?us-ascii?Q?Pw8j8amL8PgTDshqL/hV/i1uhVO7XgJbJ4ztnHW26hRdLiTgxRmO5G95K2X6?=
 =?us-ascii?Q?jhOlZx75jU6SV5HG3LWmvPG+TGsXsNy4O9V8TAFJVzy1Rrxw7BWUFBK0246H?=
 =?us-ascii?Q?n/wWSls8nnlZLSlD7MPLvnSEzD69tlZmqPpzDvvTvzf2LOK6veUjP/Gp738B?=
 =?us-ascii?Q?MJC+iVOGQasT3Ui8u9iScNAZgYY6qGtJWWLL+e/Wgc/mDM+J0qhlBWj1i55Z?=
 =?us-ascii?Q?kdxgSkgWEYtWW71rtbjH0179yNrZg/Jx+btsRjkggMpGRwy8HZSScpC6FZs6?=
 =?us-ascii?Q?a2mV4h8lsbWrfAUocl43VfDF/zD/NvgSFhgWzxT/+yDVMN8LLPk3iMrKaXLC?=
 =?us-ascii?Q?oEC0OG1/0aY523nsWpZ15VqLCmAjdxmLhs63/QpAmCjq986AlXuTr+YLqh94?=
 =?us-ascii?Q?jq2sDqgRqParmvq8DsNpsVefg5h2urHAFf38vsRKl08pYwPMpFgA78alwL50?=
 =?us-ascii?Q?3ARx3cITO5U2Xubt4w9IgxZXNTSiNRu9Ha/tmh5/PmGUc380lXm6qmSk65db?=
 =?us-ascii?Q?9HehpbTkXAKRGHpq1++jgeAZtcRKV7IhXBWk16RPuS75cY/RoQ+VkMO8hHnX?=
 =?us-ascii?Q?6KzRqHokOCGiRURwEF9bU3N7tyqPrbQGeCe8MEDnGZtr71ltwXe3CveniBmN?=
 =?us-ascii?Q?dsCHTyzjQ5+EqxrPVOiNE8fMb9jfZ70CE2OMjTAWpkY/kKd3V5nHMwYEvbQf?=
 =?us-ascii?Q?a8t3dYqgTrF/jSq7N0Dl+CGVB9r4axqIJXuBrKxj668eNep8mCYTBrhr+bKv?=
 =?us-ascii?Q?nQgl55HIzXqgoO/+hGZGjZWJDsfN6bsboIlwFAzmsWw8/dXM/Z9AjYwymgga?=
 =?us-ascii?Q?rA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4771.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d85b016-45dd-4966-3c85-08daa5d1b03b
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Oct 2022 06:28:44.9454
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: y7p/JbxF9trB1McGIJBR+BICYJ1+U0fvX4tG1F4Oiu2TOnfxILHR+tRWN7+YQ7zqgRbeva9RO+Q6c4ARO+rkFAG7ZehweTSM8T30rhJixIU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6726
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Tuesday, October 4, 2022 5:39 AM
> To: Divya Koppera - I30481 <Divya.Koppera@microchip.com>
> Cc: andrew@lunn.ch; hkallweit1@gmail.com; linux@armlinux.org.uk;
> davem@davemloft.net; edumazet@google.com; pabeni@redhat.com;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org; UNGLinuxDriver
> <UNGLinuxDriver@microchip.com>
> Subject: Re: [PATCH net] net: phy: micrel: Fixes FIELD_GET assertion
>=20
> EXTERNAL EMAIL: Do not click links or open attachments unless you know th=
e
> content is safe
>=20
> On Mon, 3 Oct 2022 12:01:30 +0530 Divya Koppera wrote:
> > FIELD_GET() must only be used with a mask that is a compile-time
> > constant. Mark the functions as __always_inline to avoid the problem.
> >
> > Fixes: 21b688dabecb6a ("net: phy: micrel: Cable Diag feature for
> > lan8814 phy")
>=20
> Does not apply cleanly to net, please rebase & resend.

I generated patch on net-next, as it is fix I kept for net. When I tried to=
 apply these changes on net, this is getting failed as this main patch(21b6=
88dabecb6a) did not go in net. Shall I resend patch for net-next?

Thanks,
Divya
