Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BB1622A328
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 01:36:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733053AbgGVXgb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 19:36:31 -0400
Received: from mail-dm6nam10on2093.outbound.protection.outlook.com ([40.107.93.93]:64672
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726447AbgGVXga (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jul 2020 19:36:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DOJR7fbLwpEwaEaKmKTE7PRQO0ZPaW6nVtVSyyLczOSLnJVdvftDTQp02lk72xvIW8FKRWPNzB0+sFKgUEQNgWHEHYvefBpdrKbW+X356QUcs/950fat9H0vYci0PjZdnPqYKCyTuGzc/K4BQsew8IVobwhjcGwhpAmtyFo3Hznpxi4jSYp57WXKqH4Y6uvtdiyOpiko+LE0e/HWhV8QoUu+d49F2gj9Fijjx8P15iYaVZeuAQm+LHRlBoztB9+GTvkXwUE07DOmJo5uru9NyeUEnzqUqnhU+8Sz9EkSGYYBO+4JGCUVZsrVT+Dg1WUI6RMyIG31HwCPs4jbv0DkWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GwVZouGpBSEgbqRjpcHlHpYAkJzK9W/s6rqvMshw0Y4=;
 b=IQ/t9EO7v0twslPA+PQcoXFJ3XDfK452uSO03nYMzZI9Y3MXv1+YYj/Z4j/HRxm6wOvB0CVrtlgYmC9ajamhR4crJJiNMixE7XHtgfWY3plKr95PzGW2cZj42wg/UaCdnUOi1EhhGopyekujFrwGkkSGCOSuIrqLJSi5R4LMDCcUGJY//vH/FL5qK9qHzxPSju2spYRNUllKjfLLmPVMs/QR9cuswdEtw+XfULZfNyIQPe5hSMqqLzkaLk/r+bg+yeH7UJHPY30VrvLfJIi6BMioXeiOoZw+jfDrN8CoXlNl1JyEgiGJRL2MZb4OilICom4XM2vNz0f6sDfZpdauCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GwVZouGpBSEgbqRjpcHlHpYAkJzK9W/s6rqvMshw0Y4=;
 b=hDqogZ5tIS6tT/H45FgRNOvahoOS/NyHnlsTal36WMIx6g0tE8zSWTAD+uqcMFFNFPcTEI1hs8rN9nY5e7TQg46938MlHlBiPgMmw8Z+jeDHKqpZ99P3JxcuiyZTeuVBRcYSUAM84LGzWJ4F4lx2Yw4HPHJWa0JLW7zulq+0QAY=
Received: from MW2PR2101MB1052.namprd21.prod.outlook.com (2603:10b6:302:a::16)
 by MW2PR2101MB1849.namprd21.prod.outlook.com (2603:10b6:302:7::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.5; Wed, 22 Jul
 2020 23:36:20 +0000
Received: from MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::fc14:3ca6:8a8:7407]) by MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::fc14:3ca6:8a8:7407%8]) with mapi id 15.20.3239.005; Wed, 22 Jul 2020
 23:36:20 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     Boqun Feng <boqun.feng@gmail.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: RE: [RFC 09/11] HID: hyperv: Make ringbuffer at least take two pages
Thread-Topic: [RFC 09/11] HID: hyperv: Make ringbuffer at least take two pages
Thread-Index: AQHWXwAnmlUu9XIV40S6+D4F8ioDMqkUQ2XQ
Date:   Wed, 22 Jul 2020 23:36:15 +0000
Message-ID: <MW2PR2101MB10524E4C2DB9FBADEF887165D7790@MW2PR2101MB1052.namprd21.prod.outlook.com>
References: <20200721014135.84140-1-boqun.feng@gmail.com>
 <20200721014135.84140-10-boqun.feng@gmail.com>
In-Reply-To: <20200721014135.84140-10-boqun.feng@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-07-22T23:36:13Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=b5faba3b-3e0f-4702-9b21-bf88bb383024;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=microsoft.com;
x-originating-ip: [24.22.167.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 4d9d3e7a-160b-4fca-7c86-08d82e9809c3
x-ms-traffictypediagnostic: MW2PR2101MB1849:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW2PR2101MB18498D9714F4864EBF43AD67D7790@MW2PR2101MB1849.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: e3Ejb98qkyTLx5H2U9E9JLmq2aabRzEE9gMj4WvkJaoMRFmssKHSJU8rwLPxxpN5wq+gJcot8/99ZLK92SkjfVgfu7lXYEXGb2LmOVjHrMUXLVna5ug/+qcPO3JY5H70VOZQI9e+Xfv6lul+2+HewT8U0+hkvrlTosYzRNJjQ0VMV7O/6y4hao5MJzCuCfvB5DuiTf4fNSvxXIIhATOGV7LmKfE9tB1PON4AdqOiWdnfBko+qbfk9sdjGTv8Oo5cPfO5NG6Umq2quBfLWkCrkyHGSeivsJkosbA2s0QvcJM1O+iNPAp9NY9he4Ai7KmeeG5d45H/m1x3N4cWFOzqRw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR2101MB1052.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(136003)(39860400002)(346002)(376002)(366004)(71200400001)(54906003)(110136005)(5660300002)(4326008)(2906002)(316002)(6666004)(8990500004)(86362001)(55016002)(52536014)(7416002)(9686003)(76116006)(66946007)(64756008)(66556008)(66476007)(66446008)(8936002)(26005)(83380400001)(186003)(82950400001)(10290500003)(33656002)(6506007)(7696005)(478600001)(8676002)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: wsliCfEwL1oec4M+7Zm3Rk4IXaGUS7Oq/tzV03hXNu/8oWj2K+1tqheTELOTIcf8jQoImKStKoTOga/rUfOw0fMnAdSSCpo7JvwWwIPmzTf/nq2XAkbHXtlXYI2yNw0cHf+J9ONe8A9Q2xV/bZNGxIjjnlvZHeCZyICDTHirPqPE6eBWkTNJlvOWIAT2nGiD1eM/17bNCkww0j3vSMSDWrJt1sdCy3c5wrM9aVxYGxZAlYUblX9bpafoeR4kjVGu6sHObchucrXQ+I0ImUuvPdssY1nuk8k3z1ZjUT8cwRy30p9h6oXXrz/k/Y9Ii2+0+BaFISzMoDu6icm8Zn+Xs4nd6GPh6eeVyZFmugphfAjO3weq0SfQaxgA9llUZmSf9ZdVr83NLxfabsZHBQZAIampcLHRRohyptX0ko9PK1R48BQIn5nV/XJzJX6ddd21a+1tCFTYxvgjSVzFIRjvsbkygXwSeRwnvorwCU98xeBpleszEbex0ob/KYaisWiKGmGTKPlwb+u9+LaLiRh1FPVyf0JXlTXh0kajCaKivvLXXIVKeblziF8cRyGmfVJTrL649YC61SLaFKBjZ4qKoo1yOtrm/oRNwoLEzWAOPRgcuOZqCuB7elnaHbD6/EqCZlAfUwI9iyR9kv/4+aiLPw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR2101MB1052.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d9d3e7a-160b-4fca-7c86-08d82e9809c3
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jul 2020 23:36:15.8845
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: j4mFeE/6btu381LIiOMjbXPWNHoNh9jqpStGRLgHHObRAa0cBQRRH+3lwrfVmfMTs5yeub+YeKUw/2jC7PCOD9PJKS/9/rjWNY9fC8Ae1Kk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR2101MB1849
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Boqun Feng <boqun.feng@gmail.com> Sent: Monday, July 20, 2020 6:42 PM
>=20
> When PAGE_SIZE > HV_HYP_PAGE_SIZE, we need the ringbuffer size to be at
> least 2 * PAGE_SIZE: one page for the header and at least one page of
> the data part (because of the alignment requirement for double mapping).
>=20
> So make sure the ringbuffer sizes to be at least 2 * PAGE_SIZE when
> using vmbus_open() to establish the vmbus connection.
>=20
> Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
> ---
>  drivers/hid/hid-hyperv.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/hid/hid-hyperv.c b/drivers/hid/hid-hyperv.c
> index 0b6ee1dee625..36c5e157c691 100644
> --- a/drivers/hid/hid-hyperv.c
> +++ b/drivers/hid/hid-hyperv.c
> @@ -104,8 +104,8 @@ struct synthhid_input_report {
>=20
>  #pragma pack(pop)
>=20
> -#define INPUTVSC_SEND_RING_BUFFER_SIZE		(40 * 1024)
> -#define INPUTVSC_RECV_RING_BUFFER_SIZE		(40 * 1024)
> +#define INPUTVSC_SEND_RING_BUFFER_SIZE		(128 * 1024)
> +#define INPUTVSC_RECV_RING_BUFFER_SIZE		(128 * 1024)

Use max(40 * 1024, 2 * PAGE_SIZE) like in patch 8 of the series?

>=20
>=20
>  enum pipe_prot_msg_type {
> --
> 2.27.0

