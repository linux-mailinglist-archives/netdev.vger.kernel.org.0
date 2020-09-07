Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E4882606C1
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 00:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727989AbgIGWCv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 18:02:51 -0400
Received: from mail-bn8nam12on2105.outbound.protection.outlook.com ([40.107.237.105]:48325
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726446AbgIGWCt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 18:02:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SdK//SOE0DSbNL+fnxIVgzVYWnmfXLTMZRsuoDFKrNUUW6BOUcCNWbZGMUt5SS2OV8yHxRwGHLRTaSB5gG7I+CAC3daNLHBnjY34a5MnfXBxB1vopLmSC6JkTeBIggm0EsTm2psQg/zw3yZrd7NnXbB5+a4gxrLXpim5on92oYegZdHn/gyu9UXSTUTymxEMEi9VXJiL24TPA3Br7HmmmJ8+1JZxy0hkBq2XgmtmhX1TIWtjnCdIltNCJPDiuvCNKJIIgYOPBiz86ZZrjYpltbhaURH0EhdpXvCyWd5CjV7zXblqhhrn2tcfEjlTT+Z3J0+6C2tMXx5+jHbcvjhe2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5vTjbZ1Gb7HyOvS5IKj7j7IMEu6Jn08fWlCJVvyPclA=;
 b=nlrrjfYMwGOVfKhpi8tT5EIsywWvbZT+1v5twa6I0azx6BSWo1u315l+sEdpDGf/KFkqNWc5iGgZ0HYtrI9gBIh8rNUfBGUkitiWLlKuYjddriH2E5MdHWaHv+Cy0vjnSgQTTWh0bzlKNgpJocYHsUDI1DjAnzAjGcnjDfaVVqt5RRMQ0Ijh7ExxODZGm2Tzgol/X62da0bmyMcb2o2MKC37FroJU/WxWlwmTUSkrBhwNm7OVTpLA+f3l7RrfiPKZR3Z/v2T+cSDIgWoOaMSMZ99Tk2qMwJR2Ef89EPn3Cy7v1Br1/Po+X9v3rb63Z/TykkTpxK1v4sjxdokCWQ7aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5vTjbZ1Gb7HyOvS5IKj7j7IMEu6Jn08fWlCJVvyPclA=;
 b=Iza9ZEFibe+WawA45EEjnZBgf0hJQGkbsCd0ehyuu3fbWsZiB0wgfQsCCsN/pNz+fBCjWeIFk9UgYP2slOzFMLI78cMFjnOLtDgcXE41TpTlZ3p9r6gi6iYpz+7hbMc3H9rhgHRrGyQuavfn1UAssMAS0rOHVXcG/pcsmP+2eVk=
Received: from MW2PR2101MB1052.namprd21.prod.outlook.com (2603:10b6:302:a::16)
 by MWHPR21MB0190.namprd21.prod.outlook.com (2603:10b6:300:79::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.0; Mon, 7 Sep
 2020 22:02:45 +0000
Received: from MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::d00b:3909:23b:83f1]) by MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::d00b:3909:23b:83f1%5]) with mapi id 15.20.3370.015; Mon, 7 Sep 2020
 22:02:45 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        Andres Beltran <lkmlabelt@gmail.com>,
        Saruhan Karademir <skarade@microsoft.com>,
        Juan Vazquez <juvazq@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH v7 3/3] hv_netvsc: Use vmbus_requestor to generate
 transaction IDs for VMBus hardening
Thread-Topic: [PATCH v7 3/3] hv_netvsc: Use vmbus_requestor to generate
 transaction IDs for VMBus hardening
Thread-Index: AQHWhTK7m/4rhJUWEUa9HqAKMju5XqlduqeA
Date:   Mon, 7 Sep 2020 22:02:45 +0000
Message-ID: <MW2PR2101MB10528D1E843B7C2972C95CF3D7280@MW2PR2101MB1052.namprd21.prod.outlook.com>
References: <20200907161920.71460-1-parri.andrea@gmail.com>
 <20200907161920.71460-4-parri.andrea@gmail.com>
In-Reply-To: <20200907161920.71460-4-parri.andrea@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-09-07T22:02:43Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=1ea0dd16-a758-4250-82cc-d2594e992bcc;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=microsoft.com;
x-originating-ip: [24.22.167.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b19f5815-71e2-443d-de8b-08d85379c01e
x-ms-traffictypediagnostic: MWHPR21MB0190:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR21MB01904B186BD6ABCCC001F9CFD7280@MWHPR21MB0190.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4XCDiKLD2S6MoFBh2vcqI5uigMUjxt0utswJ/g/JoH6zUDtibhX2x9hMqIMP91h2SZejL+MXNj5Lpbdc1SBetQIK1LU/fqXF1djdlSsiJb/UzlK6itq3+pOj0UlFekwjdh1hbrVDwGhK9kAaaC1qGpsGpEzbNRxSyi8x8jywgwpubVI8f0dVQyzW9zjkGwm6TxTPeeD4VhMM/nvTWg6+HecsfpVOPeg6uUjKPr/iD3f47Vsrh5XhZ/sbeRM6aUjcQA8nUnPnXsEHIfaXc2Vq1cWak7GH1HVppcaosGRlBLXHzoeqv38aUyElLL2sDtq5aFYKgQZ2EPObkXBVBB2Lli9ifdINHrHIkwNwFcAAdoK8fDrIcbr/iEaRV4JsLaMI
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR2101MB1052.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(136003)(366004)(396003)(39860400002)(7696005)(55016002)(2906002)(8936002)(83380400001)(478600001)(6506007)(4326008)(10290500003)(9686003)(8676002)(26005)(71200400001)(33656002)(186003)(86362001)(110136005)(66556008)(316002)(5660300002)(66446008)(82950400001)(64756008)(66946007)(66476007)(52536014)(82960400001)(76116006)(54906003)(8990500004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: Jp3qjSche1Z/QaZFNZz+dTJIKl9pPbL7yB96zwUefqCB+q84khrupQAoSAsrzhl02ggHKIz3sU53TLhRb/KE6qdphGT2/RkQqUNfxFKcvmouDUZqCoLuePSrrPJJTVrihBcS0/j7Fih7rA0bfIYm0csmysimejzrSjeWY0OlTn1IJ0zu+d7K/7cKz1TzmE85wuNM+LOICjOxlTbKF/uHqXBF/ppiF6qK6ZULroyXldbhTM2vCtNi+eF6gqRwoVkE55L1KXFaxP04z+gf2kncTm1ra5sEzA2NIwwNsrzNfMJhIgoeRLztnXAvp602yzr23GagxTzXD++RwllqbO9AT5sZnP2UuGEU/1Wr37cyIWeXYPK7mYweKVd+023bqrljmBbfSdVWnISBnxjDgdHyOZTPqpZC+RAS01HT9japTiRanWjeNaRPNsqCzdTmlVQocGsrdsN65iJMS/vMKQk2E2PVcxC2mkx4ciBWmu6GYUVgngJoqdS/mNQ9DggDTp66lw5J1/DyYoFNjWgYIowI4HSK+rXHoP2wuv+PvrKJXPaScQA6y2u3pVtRRx1rGmPPzUe4R8d0Ezhcu862lrjpQhXjwbZxZInFvW6dk01UekGaZQ7nVV6NbYobt0VgKAHFak5hL2GU5udcI72sa6CrBg==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR2101MB1052.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b19f5815-71e2-443d-de8b-08d85379c01e
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Sep 2020 22:02:45.1142
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: B5ivHHcrBqXTThELkKqp6s7gIhxndpRZ11lv8bcoOBGOiLz5V8ntBh1ZCvULSvOWPfsvKwx6yPN3Ahw4Qs2B7RDVTgxYuoIyMNDQyZ8MJsk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR21MB0190
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrea Parri (Microsoft) <parri.andrea@gmail.com> Sent: Monday, Septe=
mber 7, 2020 9:19 AM
>=20
> From: Andres Beltran <lkmlabelt@gmail.com>
>=20
> Currently, pointers to guest memory are passed to Hyper-V as
> transaction IDs in netvsc. In the face of errors or malicious
> behavior in Hyper-V, netvsc should not expose or trust the transaction
> IDs returned by Hyper-V to be valid guest memory addresses. Instead,
> use small integers generated by vmbus_requestor as requests
> (transaction) IDs.
>=20
> Signed-off-by: Andres Beltran <lkmlabelt@gmail.com>
> Co-developed-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
> Signed-off-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: netdev@vger.kernel.org
> ---
> Changes in v7:
> 	- Move the allocation of the request ID after the data has been
> 	  copied into the ring buffer (cf. 1/3).
> Changes in v2:
>         - Add casts to unsigned long to fix warnings on 32bit.
>         - Use an inline function to get the requestor size.
>=20
>  drivers/net/hyperv/hyperv_net.h   | 13 +++++++++++++
>  drivers/net/hyperv/netvsc.c       | 22 ++++++++++++++++------
>  drivers/net/hyperv/rndis_filter.c |  1 +
>  include/linux/hyperv.h            |  1 +
>  4 files changed, 31 insertions(+), 6 deletions(-)
>=20

Reviewed-by: Michael Kelley <mikelley@microsoft.com>
