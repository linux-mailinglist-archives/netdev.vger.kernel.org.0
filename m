Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE7B8179EB3
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 05:47:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725953AbgCEErd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 23:47:33 -0500
Received: from mail-dm6nam12on2049.outbound.protection.outlook.com ([40.107.243.49]:6036
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725852AbgCEErc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Mar 2020 23:47:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GgrP+posPI+OpI6YxoQlj7RDWdVPbbSaJyNVbkKfs3RFp6jXNrEUoTwDJS6IqHcbAaTgEYo5ekdvVXEMN4Okxz48thFiHUhgfAW/PnBztiyaeWKFw5scnsRPolZxcN201eu8vZgBs/XkB9cHqx8rQwOtntOLHbIenwBF0HUzJWm+EtkZW9Ygaz0fOcorj5K9jJCqPyh6+9UkWLvoPngmzZ0GmrVlmbzYdnSzCPh9hzVE0OTWeUGUNoT2NywihEFilkR/0kqucKqb4MoXzJds5S1nnSyD0qjTZsbDaQiBni/JfgRwiQG/regRnjzR6PfGOI7Yr0cKhd/ZKmDPXBBkjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p2zTdGeolJ8wlOEGU31tl39xvfHxGJ3pxbvQaBeOmo0=;
 b=QkdHFbxfKDO0IFwXlW7jWYWbAy6eT4AL6mF1nVehAJ2Ix1ooWdM5SIbjGsGPVhVakRfqrx8SSU1quLao734tOOunVS6GIySjanNQV/PP0giZD6i8+rSn0/Q/zer58VreGm4uWLhYoCKtRNKtFMtOGxWwCLNHZR2zfIFXEAe+hUVGrUV5kBFTqOxXqyvb7RH3y3kL68xDkhbMPWDDtliSAT45FX1RqmpAUuJBLgbpfoRBrlL5fLf7CF6W8Ov5lfkYuR+vnFLEpv6TTPZ9EAHbpKexknfxJ5lndNN0bG/6ibyXipPWT7YaEcPz0iuj9ovHTPajyLljON9Dt7oWeDzhZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p2zTdGeolJ8wlOEGU31tl39xvfHxGJ3pxbvQaBeOmo0=;
 b=YJgXceowAyhxGGF+HSuaxr0vZiHrniloWBA9NxTVnzfVNMvh3c8sIPaRHsmedgvb1LZZAUXXOLcGHGHKQ3dM/yrDICOVGH8kzqLH3ZGM0FngimOsQmz624Nn/UC5K/W+9Mpy2nkpkn8WnQta8blK2iR57ZzWe9kRl1FW46CJBwg=
Received: from SN6PR05MB5326.namprd05.prod.outlook.com (2603:10b6:805:b9::27)
 by SN6PR05MB4992.namprd05.prod.outlook.com (2603:10b6:805:df::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.9; Thu, 5 Mar
 2020 04:47:29 +0000
Received: from SN6PR05MB5326.namprd05.prod.outlook.com
 ([fe80::8482:b122:870c:eec6]) by SN6PR05MB5326.namprd05.prod.outlook.com
 ([fe80::8482:b122:870c:eec6%5]) with mapi id 15.20.2793.011; Thu, 5 Mar 2020
 04:47:29 +0000
Received: from sc2-cpbu2-b0737.eng.vmware.com (66.170.99.1) by DB6PR1001CA0022.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:4:b7::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.16 via Frontend Transport; Thu, 5 Mar 2020 04:47:25 +0000
From:   Vivek Thampi <vithampi@vmware.com>
To:     David Miller <davem@davemloft.net>
CC:     "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Pv-drivers <Pv-drivers@vmware.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "x86@kernel.org" <x86@kernel.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        "jgross@suse.com" <jgross@suse.com>
Subject: Re: [PATCH RESEND] ptp: add VMware virtual PTP clock driver
Thread-Topic: [PATCH RESEND] ptp: add VMware virtual PTP clock driver
Thread-Index: AQHV7fh9sGmTv3Q/nkCcjzOFcD8fwKg5BbgAgABwnYA=
Date:   Thu, 5 Mar 2020 04:47:28 +0000
Message-ID: <20200305044713.GA173879@sc2-cpbu2-b0737.eng.vmware.com>
References: <20200228053230.GA457139@sc2-cpbu2-b0737.eng.vmware.com>
 <20200304.140410.731261448085906331.davem@davemloft.net>
In-Reply-To: <20200304.140410.731261448085906331.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [66.170.99.1]
x-clientproxiedby: DB6PR1001CA0022.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:4:b7::32) To SN6PR05MB5326.namprd05.prod.outlook.com
 (2603:10b6:805:b9::27)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vithampi@vmware.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 968b98a2-6bdf-478a-758e-08d7c0c04eb6
x-ms-traffictypediagnostic: SN6PR05MB4992:|SN6PR05MB4992:
x-ld-processed: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR05MB4992271151650FE414581012B9E20@SN6PR05MB4992.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 03333C607F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(396003)(39860400002)(346002)(376002)(199004)(189003)(7696005)(55016002)(66476007)(1076003)(66446008)(64756008)(52116002)(8676002)(66946007)(66556008)(5660300002)(26005)(316002)(478600001)(16526019)(54906003)(33656002)(71200400001)(186003)(956004)(6916009)(2906002)(86362001)(4326008)(81166006)(81156014)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR05MB4992;H:SN6PR05MB5326.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: y06snQYR8TAAYGVjlaxyxi8N0S3mrJm66x93S8kqbGP1Sr9QFr6+Gw3irazbV2emA1ZfYgTDAmEwCM6RB67jR4Ts7xeNl9+CnayzdbRSrCrIsOvz6VjUN8wCmqv6THf7FGHHUWmcIuA5KE9NG9vLGTADRcYVUrVoPlSH20ecvaTb71CwaYc3QmrPx7pHodhTqR99/X91u/W3GvJnnTkb5kO3TKont1RvF+v5o9PcoO8e8wIgKrURNQ6yhwqSAAIbMz8g6FfkvKqyV+iZ4rbw6ymvXatf4YUQ3JUTafVMwPV8kwJWxGZuHetrMDdJO3OX6EI4ClL2gFyod8aWr/HzqL44X2KA/aalIozRXL6YNr99j9hcRMZ4lWGUAiBkBZffsx/JsznKAIItO5kAhfgOO5KiU+ck9Mig3BJmx+HfYkL1WHqLIVwDM6z8VrGP2jwo
x-ms-exchange-antispam-messagedata: 6bJxoQttOsJGHSAHMcz37ZcEaBgwNLS53BxM/tBD1Js25QopnvtiYaQkqIJpmo+UWn5UaKqIYtPpWXcEYjOnKcEfG3eakd/9Q2nU7nfAq6W5b+TKZrFApbluQCdDdjjDLOy0zyb6+ilaIoJxjBTn0w==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C0CC8BFB48469A448048072E8EA83764@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 968b98a2-6bdf-478a-758e-08d7c0c04eb6
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Mar 2020 04:47:28.7876
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xhm8nGB6qxeCvwwg8TB8v5CWVT6nWfn/KtYZoRCAETpUXttDHZqTZ8SEfC9zAANDN9Iz22czZVgfXGmAcZX07A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR05MB4992
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for taking a look, David.

On Wed, Mar 04, 2020 at 02:04:10PM -0800, David Miller wrote:
> From: Vivek Thampi <vithampi@vmware.com>
> Date: Fri, 28 Feb 2020 05:32:46 +0000
>=20
> > Add a PTP clock driver called ptp_vmw, for guests running on VMware ESX=
i
> > hypervisor. The driver attaches to a VMware virtual device called
> > "precision clock" that provides a mechanism for querying host system ti=
me.
> > Similar to existing virtual PTP clock drivers (e.g. ptp_kvm), ptp_vmw
> > utilizes the kernel's PTP hardware clock API to implement a clock devic=
e
> > that can be used as a reference in Chrony for synchronizing guest time =
with
> > host.
> >=20
> > The driver is only applicable to x86 guests running in VMware virtual
> > machines with precision clock virtual device present. It uses a VMware
> > specific hypercall mechanism to read time from the device.
> >=20
> > Reviewed-by: Thomas Hellstrom <thellstrom@vmware.com>
> > Signed-off-by: Vivek Thampi <vithampi@vmware.com>
> > ---
> >  Based on feedback, resending patch to include a broader audience.
>=20
> If it's just providing a read of an accurate timesource, I think it's kin=
da
> pointless to provide a full PTP driver for it.

The point of a PTP driver for this timesource is to provide an interface
that can be consumed by Chrony (and possibly other applications) as a
reference clock for time sync. This is admittedly a very basic first
step providing just PTP_SYS_OFFSET functionality (which gets us to <1us
VM-host time sync). Down the line, I also intend to introduce
cross-timestamping for more precise offsets.

Using the PHC infrastructure seems like a good fit for this, but please
let me know if I'm missing something or misinterpreting your comment.

Thanks.
