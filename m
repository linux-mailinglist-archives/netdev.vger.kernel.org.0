Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C14E3267C1B
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 21:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725905AbgILTkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Sep 2020 15:40:19 -0400
Received: from mail-eopbgr680119.outbound.protection.outlook.com ([40.107.68.119]:5649
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725875AbgILTkO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Sep 2020 15:40:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QCOhATMaJg9c441kQa32I4i6L+XEY93hH/JzBFj6W7nC4zazTXSraVa285NC/S59s0B8G5uplW96VUPmoV3c4uW+Vp1A8RnqYp+hDZMVibIz2SjTophP7qtQO8BNyE8uDvxdoffI4ZJ/NvBhdoidbHhmvfouHudReZGjKtYxIGedTA05KTftWvJ3xPzGx3ZnBofksISr+8TOVnEFBmPPQF8ypd028Mv6EtaG8U+s16RCr6/IvBySPV2uF7VDdWKYDeH+DZ2i5vVOd/Xk0JYx0K+RoNnXBD5pDgBQpv4w2voM52xbs8jFIimFu48du9ctTzA1N3PUgV1MNM60iKVBjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wlgkdn5CDOdH6FSTekCWfxQT8n9lHfHNKIK4lvC1AVk=;
 b=WgOoi/D15xcE611cH7Rg/tXqOq2rdJD8xiI0VsJ70ngaqup/UnYKLGP7NjiD/D2ayWQQzfP8AdToA+W/1GmGoJLHNIPtMY93FRNxNeBONf65UE6dB3esA3pOf9oDlAUZWDAOdtsUXicUhQQsC5hFVQmTklziwAysi5kadvGJFBrWCEBZcwTD3TqlyjjA/4BJIPqOW5RBmKsO3vBypPuwKO2bHlNMh8elIBbiJoHr9kuD7jbsMdz26dqDmhATTFnM8fdGVdIXu66l9EdQx3n8qllpM7R2rKR+8DLczWZt9z8rwUIGGxg0FkSxBZu+fPb1RZIcMsdB0/YzWRulSXiw9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wlgkdn5CDOdH6FSTekCWfxQT8n9lHfHNKIK4lvC1AVk=;
 b=TFcnjocO8fFCF37kxAoaxxBiNMHtWW/gIH7FCMShFxdVj5y/4YbN0RzxNLHwR0DCTjUKuFJyaDIAl2SK6c3xdRv9HSomECXOMwGrHiwKbQA5hCF4f0IH6/vaIK65yXrEgf9QoUpkecPu11+dqJV5Zb4MtJfoO2uLG+Vv6WTFZBs=
Received: from MW2PR2101MB1052.namprd21.prod.outlook.com (2603:10b6:302:a::16)
 by MWHPR21MB0512.namprd21.prod.outlook.com (2603:10b6:300:df::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.0; Sat, 12 Sep
 2020 19:40:10 +0000
Received: from MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::d00b:3909:23b:83f1]) by MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::d00b:3909:23b:83f1%4]) with mapi id 15.20.3412.001; Sat, 12 Sep 2020
 19:40:10 +0000
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
Subject: RE: [PATCH v3 10/11] Driver: hv: util: Make ringbuffer at least take
 two pages
Thread-Topic: [PATCH v3 10/11] Driver: hv: util: Make ringbuffer at least take
 two pages
Thread-Index: AQHWh3+hQ6vBrx8PX0uTZJ+Hvwiqh6lladsg
Date:   Sat, 12 Sep 2020 19:40:09 +0000
Message-ID: <MW2PR2101MB1052A7D9692511183D074DB4D7250@MW2PR2101MB1052.namprd21.prod.outlook.com>
References: <20200910143455.109293-1-boqun.feng@gmail.com>
 <20200910143455.109293-11-boqun.feng@gmail.com>
In-Reply-To: <20200910143455.109293-11-boqun.feng@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-09-12T19:40:08Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=d3ab6d37-93f4-4401-aa92-71c3f78786cc;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=microsoft.com;
x-originating-ip: [24.22.167.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d60cfef1-62a9-4aa0-dcb5-08d85753a905
x-ms-traffictypediagnostic: MWHPR21MB0512:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <MWHPR21MB0512D67714291BDD8015207BD7250@MWHPR21MB0512.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7xaJe/cGOHLGHpXPtohASROO91sHvCTwvnZrcC/JoQyP8ZS17wScKqglWECw/K/LnkJhAixBByq/7+0GZMxrAt2lzLgcRpRwhRbX/PIwJvQ2bO0ozttnUG35WAb9ZsTMyQjOEtJlbKscsKsJw6d5AaGmD/xsdgVzC+gvjBnmAYFpRQU4tYhZMvy5aW4fe3RQrWWRodLgW+TNgZNzWvcV635vjBJcaFcerSF/fuJS6ckijgdsi3Kn6rj6y2WS9EXp+sCzoZlEj+60QhPTvJBKZd/r80cEvl28oUg+nwnK8Os5F7ipARzZcEXV/oRjiqRReMPT6/77a0l/BcgxJdMcHlI3atjOiRvUnUiQneuO2g753EIuHNddm3ePyTeEIBOG
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR2101MB1052.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(346002)(39860400002)(396003)(136003)(33656002)(83380400001)(316002)(4326008)(9686003)(10290500003)(2906002)(71200400001)(52536014)(8990500004)(86362001)(66556008)(64756008)(66446008)(66476007)(6506007)(55016002)(4744005)(82960400001)(82950400001)(186003)(5660300002)(8676002)(66946007)(26005)(110136005)(76116006)(478600001)(7696005)(54906003)(7416002)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 0BHgUCGMWpB9D9d6OpQi4a9hfI+5o8z6q9+BlBXIMQIJkDl923EKmT5jtJ6Xw2/ZtLuAixwbpZqDxJ/H++d0arltQYtY0U9rLJEl/a85GEotHwkPGC2HX4lEN4fVJiM+VfxnBdcVQ5swLSAdYpvZkbppdwnhC7UlNopJB5RelS9TUiXxLy9XEjbYD+38xyF4rq2wbSRPHzcOJ0ARFdN1OKmZXBxBgaVuvUieTSKpm+wqJQj1kBxnFVmIfZDiCtqWs9tqHstaxK5g7E4OcL7K+mH9KFF8UDmyqDOh2d3Grs2wK+d/0kYf0OykLhjyJbdFZYDqR77h2HOJ6vQM35vivsy7m40A9Wh/O9oLLuQMJgHqAXmAd+PtwLVk98PNa4aUiOTuntw8jD6H4LpcJQ6W8KRJ0aqAjZSZsdD0+7p0U5R/V64dlL5BLZSs4odoYC++XOhoYISWMoQgOa+jMw/GpW9kRxuAGzQM8q/Szc4KF0wKBRhIt6VNBd1OxvJ78tS8NWKAUG56yS40lj3cMLhv3GNtY2hlMVayto/XSF/o02/ewhzYDWjR5YnWMHsmukw8xGYZmFGiBlEXU85D5UoABGkkPonnOJ/rrDXnPIkRD9MkDiL3zSoBfLLaWifoS+o111YqBkTTr6vxZECSPR5q1w==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR2101MB1052.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d60cfef1-62a9-4aa0-dcb5-08d85753a905
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Sep 2020 19:40:09.9812
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PFFwrKVmZjTQZLMFaKgrZE/EeBW1w721X9RwFHD4VoIJ/FYPOigoWvLAq3hwaBA69rGK+G5M9J89bfjrUziz6/uymOo/lDgZT3RmbKTDcNw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR21MB0512
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Boqun Feng <boqun.feng@gmail.com> Sent: Thursday, September 10, 2020 =
7:35 AM
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
>  drivers/hv/hv_util.c | 16 ++++++++++++----
>  1 file changed, 12 insertions(+), 4 deletions(-)
>=20

Reviewed-by: Michael Kelley <mikelley@microsoft.com>
