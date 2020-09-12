Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22CC2267BF6
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 21:30:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725907AbgILTas (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Sep 2020 15:30:48 -0400
Received: from mail-dm6nam12on2139.outbound.protection.outlook.com ([40.107.243.139]:25825
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725838AbgILTap (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Sep 2020 15:30:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ngYQWItTvwVQXqTST6LzUqAAKnFTeV9RekgXD0wItrhL+JS7hH2HT2wsdv7DK/SKdrLukJU/BOR3SlFxHzchzChNbCG+SEt3zhMpy6FFPFS0xwbxFm1FLpoDCT1ZXZjQ6p6pGsv/WrXR364WwL+5lGgZxLdS9CMpLJJFbFFuFtrw6ZyR6cK1tbIHNT63slWcqvYCA67EWhOwibOosAfnxepO44DtBcWFhMUuuqWUyeLa1prMjpFkYN0htTTMv/Be3XTxuw58TwcAyTJSw+qA8LefRtwBbN9inFloRaHxblLADcn0ki33ebXeoc7msEsTVoOZztFZWd/xeicA4DtFhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=258XMxvuFQim57epNDeh46s6ByY45CgOfSCJMhPyeNM=;
 b=mDwYvbhqaVm9hMFdSQXnbwPE1JQyoqsl6NNM2g9XnrR0LW4nELSMVZya+t8kVchrugK/iRPAC433JZPVczoOOFZ3qDsihFUdmtwrhC1GDUKn6h85ji+rgyyOGNPmQpia3EOAewlWClpstPIA/KpMmwUbTvVIFHUC5l06ZmuL6eVkHX6VphIDF1fYqv+Oq3MRBQ5gz+D40mqGaBrhW9n3ZTjnlrzqfdloD5hfbiloy3VWW65JnuJoJzM1++myIzGrMFidRRjO/EUwUrPd2e2OyHgKsh9NPW4JComrnP8+RIAqyJ+r9Uz+YzS/sOeyIw63qnYWC0N8G6GqaIYAAzbVrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=258XMxvuFQim57epNDeh46s6ByY45CgOfSCJMhPyeNM=;
 b=I2/xhhWBbFG0UVZPU+zYnVttQWb4MGyiZMakkdHklHXFee4V3PAfCJIZ+kKKqdoaq1SM+ddSNQt+bse15aGlXJyJF2YUbjb+16wpnD6zsPkdjT57GxkrbgSTJ5u7x+pEyUlYVD/BGi8C3BbsEnNv9pn48CBdaBu9Rnh7o9HWQy8=
Received: from MW2PR2101MB1052.namprd21.prod.outlook.com (2603:10b6:302:a::16)
 by MWHPR2101MB0730.namprd21.prod.outlook.com (2603:10b6:301:7f::39) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.4; Sat, 12 Sep
 2020 19:30:42 +0000
Received: from MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::d00b:3909:23b:83f1]) by MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::d00b:3909:23b:83f1%4]) with mapi id 15.20.3412.001; Sat, 12 Sep 2020
 19:30:42 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     Boqun Feng <boqun.feng@gmail.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
CC:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "will@kernel.org" <will@kernel.org>,
        "ardb@kernel.org" <ardb@kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "Mark.Rutland@arm.com" <Mark.Rutland@arm.com>,
        "maz@kernel.org" <maz@kernel.org>
Subject: RE: [PATCH v3 04/11] Drivers: hv: Use HV_HYP_PAGE in
 hv_synic_enable_regs()
Thread-Topic: [PATCH v3 04/11] Drivers: hv: Use HV_HYP_PAGE in
 hv_synic_enable_regs()
Thread-Index: AQHWh3+c5b7RbVBUk066bqfxWTfl+allZyQw
Date:   Sat, 12 Sep 2020 19:30:41 +0000
Message-ID: <MW2PR2101MB1052CFB7C909D667EFC6FBDBD7250@MW2PR2101MB1052.namprd21.prod.outlook.com>
References: <20200910143455.109293-1-boqun.feng@gmail.com>
 <20200910143455.109293-5-boqun.feng@gmail.com>
In-Reply-To: <20200910143455.109293-5-boqun.feng@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-09-12T19:30:40Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=4e20c100-a6d9-4ead-947f-48a6703a23db;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=microsoft.com;
x-originating-ip: [24.22.167.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 93c2e906-a273-4b63-22f0-08d857525677
x-ms-traffictypediagnostic: MWHPR2101MB0730:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <MWHPR2101MB0730D2BA0A8D7CB8D8E90CA6D7250@MWHPR2101MB0730.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1186;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wdGPtj17byfCXxvApw7FSpSA0m7Syckas/Sh5D9BZU2BcLxC13eHRsuY+vR6N8bK+G40kvdYt5gT3ZaEUcBd0jgjBk1CYwOA+74wRG94T/LanMlwXzie6rcNJuz5z9AZxX5ivbctXj6Cb5FgZMM6X58odepz3hzeHZJHgoB/FrclM4D09WmqaJX8FHVP3Lb6mksJmLLRZSna3nwFvPKREX9EBTTPgbn9THiDL4EuzBt8JSOkTRr0lHFD6bJn6T3at3/0USx1eKx+xFq4dgF4MQUbxBO8/TL641vfU9jtD9pVWYcE4WDAmkyTFF1unjI6qNOnOjQuCRMO4VhlzxjHu8C8xYSnOENQSV4bTCVROVyZ2XgQxwzAQ/VmC27pOnnO
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR2101MB1052.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(346002)(39860400002)(376002)(136003)(54906003)(316002)(110136005)(478600001)(10290500003)(26005)(7696005)(7416002)(6506007)(186003)(86362001)(4326008)(55016002)(9686003)(82960400001)(2906002)(82950400001)(52536014)(5660300002)(4744005)(8936002)(64756008)(66476007)(83380400001)(8990500004)(76116006)(71200400001)(66946007)(33656002)(66446008)(8676002)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: DG2gGXg9Lu4AS7drw/28iJrfBQswrpe0f3je06kyDdGbRHaUDaPsumwXfYzrYfQFV7Ucm7+km6PHhXgnwthZ7m/FzUmbxCpoOMw9FZlucgcZOiAcE8aZWpeWNkH/ldERuwlen2OMQN3zwEheXVda0SBfjsUFLQ2wNCvFJ05c/FrhIltVIbhkcbBP2B4Smn9vKyUwl6OMA1EsbqW9UKJidXqMDvgYGUgFk2nwI52NiqQs/7uUSgtodwfp8Ya618jjsN9NdwzxKugZj1xVqdhbtLd8ZFb2KQzNxmFEVH2naYu29wuBvi5ThJ0J6r24qohZ1AuZy2nWcvQWrwEexdaiaBEuICwS0jPH5bC/cOhiUaYXpXic6bwrzaZzK4vrtAWIHq/v8w2xQpMLKim+XceKQffY98+AKJEBZevPDgy59bSwtpTj/42J4fWJOtzCaaOA3HDjcdTmOczwEf3LhSYWAuuRDn0youwLDuBUX1+NOP5UDuInEvIEmrnDs6eV5tbQbYYFxO18wQ/LxH2bQOS8Ho0LACMB3U8JNPf05abAhBXTLUDoWEl2IwznZvwAiMhHPfrzfjN83A1YFY4dp33VOISt30vco2zCCgt/W0RjLGSGFhkB4520bJ/7U/v3m3hXBcQERpc0+Er3cVy1UH+ruA==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR2101MB1052.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93c2e906-a273-4b63-22f0-08d857525677
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Sep 2020 19:30:42.0029
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: q6m7PGwQCqZ0VCv5iK9FNHUN9oOgPAZ7m4/tgRUtYIY4USIyLPJl4cFs414Vdbvw2Zp9CeE5VFUoXf8ARxjG/sz3jKMW2mKu9oeTJHLzBMk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR2101MB0730
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Boqun Feng <boqun.feng@gmail.com> Sent: Thursday, September 10, 2020 =
7:35 AM
>=20
> Both the base_*_gpa should use the guest page number in Hyper-V page, so
> use HV_HYP_PAGE instead of PAGE.
>=20
> Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
> ---
>  drivers/hv/hv.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20

Reviewed-by: Michael Kelley <mikelley@microsoft.com>
