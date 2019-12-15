Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED57F11F927
	for <lists+netdev@lfdr.de>; Sun, 15 Dec 2019 17:39:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbfLOQin (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Dec 2019 11:38:43 -0500
Received: from mail-dm6nam10on2106.outbound.protection.outlook.com ([40.107.93.106]:4570
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726135AbfLOQin (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 15 Dec 2019 11:38:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HRflOwsvUHsQN2bhi9w+6j6Jq1gJQ0Jxd1lVxgg5hRJmu5qghOuON+vbNL3W4fFDeynNuxqCdrbA65T0CM0M+omxaC4E2kkVgLdiTYOoOYISU5qQbwWTe6s0aMXBT01EXbTDWLNoX65JNqcV4CAUkTUYAKiDKjG6TFrUmdydekZfmEl1Qo6+SkvAYD/5HAo5nlo1N6lZrlVu1SX/+wGCdyG8TCi1gjNHRo26iD5484foMKxyRZdmSaYqebzCxfXG6i0c9k8qV3eDrDiI5W1Gq0gY3Dkf2s6tj6t+zxQLRyrMl9jq28Tt7zVGPmoBjbH6aNOsVhqb2aaEH0jYo4jkhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h4ORSuNMdu2nInMBcaUapu5Su1cZYaqI5wyr0UO4iEs=;
 b=ENAY/70Xc/R4Txq+NEBXKVK9U4aK2aIoK/Wfd9p0b/6iMnAmHKBdjVZJmulecC26LCz+SykFt+Sh2HLTgQyCSE2tEiYde9mbJFydLBt0+EzJijI8hNJ+uHfLXLOqLcydIqUgKImebIOEyEHfl4a4hp8F2QZFxZENAf+1xLX7foPXDFFhOV7GJrOv6Bh4qht6zGY19CqkG/krApRTt6wumU1fLjE5HHcahQYzPWWBH6q0t76Wb13FlcMV7Lp9ZsQNZHnZTNEn5eXTF8zbZiPWyTvo7NbOHrzy6lRqp9kFVuXKQPPVH6KqKx3Q4k8xbb6u4OVoFgtnTtOQG6rw/YCUkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h4ORSuNMdu2nInMBcaUapu5Su1cZYaqI5wyr0UO4iEs=;
 b=KL5DwCvYKk/8vF4bsVs4Dc/XxgxFkIQBmK7I+CtQahYQf4GO89Oz2A8s/kMJTLG1UHtiKk4ofRS6dJQLN71F9+gHa8oExPVKLfzC+VPzTt4yCvkbkECWRMIpzUWZf6vwl1jDPRXw6WR0b6C8HIFKKinY6b+UOCz3uMwWxWKPvDo=
Received: from MN2PR21MB1375.namprd21.prod.outlook.com (20.179.23.160) by
 MN2PR21MB1166.namprd21.prod.outlook.com (20.178.255.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2559.7; Sun, 15 Dec 2019 16:38:00 +0000
Received: from MN2PR21MB1375.namprd21.prod.outlook.com
 ([fe80::d15a:1864:efcd:6215]) by MN2PR21MB1375.namprd21.prod.outlook.com
 ([fe80::d15a:1864:efcd:6215%9]) with mapi id 15.20.2559.012; Sun, 15 Dec 2019
 16:38:00 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     "sashal@kernel.org" <sashal@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>, vkuznets <vkuznets@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2,net] hv_netvsc: Fix tx_table init in
 rndis_set_subchannel()
Thread-Topic: [PATCH v2,net] hv_netvsc: Fix tx_table init in
 rndis_set_subchannel()
Thread-Index: AQHVsHIPR2S1RqkKpkGOALob+Zz3Eae6CPmAgAFYy9A=
Date:   Sun, 15 Dec 2019 16:38:00 +0000
Message-ID: <MN2PR21MB1375F30B3BEEF42DFDB3D39ECA560@MN2PR21MB1375.namprd21.prod.outlook.com>
References: <1576103187-2681-1-git-send-email-haiyangz@microsoft.com>
 <20191214113025.363f21e2@cakuba.netronome.com>
In-Reply-To: <20191214113025.363f21e2@cakuba.netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=haiyangz@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-12-15T16:37:58.2733489Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=9b19c3e4-ad91-4479-b77b-ed5e79b48d5c;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=haiyangz@microsoft.com; 
x-originating-ip: [96.61.92.94]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8a616f74-1a60-47b5-9341-08d7817d25f6
x-ms-traffictypediagnostic: MN2PR21MB1166:|MN2PR21MB1166:|MN2PR21MB1166:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <MN2PR21MB1166BC1ACC28CBC6B633F8BCCA560@MN2PR21MB1166.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 02524402D6
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(376002)(366004)(396003)(136003)(39860400002)(199004)(189003)(13464003)(10290500003)(2906002)(55016002)(8676002)(26005)(6916009)(7696005)(76116006)(66476007)(52536014)(478600001)(81166006)(81156014)(66446008)(66556008)(54906003)(33656002)(5660300002)(9686003)(4326008)(66946007)(316002)(86362001)(8936002)(64756008)(53546011)(6506007)(186003)(71200400001)(8990500004);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR21MB1166;H:MN2PR21MB1375.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qUnMXtxmnoYp2pNGuCvkaOKgrexZev7QoZf/v5vwQIXNSXMktpGz7sFEMaJC9IQ4Jv4qJmkB9P5sKEyxo2vi/+Ic9KZTqzVVsObMzBy66rgywiODgYQylLjiG8+dEzamsHlpAip46i+mD3CdNb+71zP4NlHLvWgTFQM8pzpJ7DQ4dUvBTyLf/ayjP7ZZlayfOgvjVeAutklpfTW3dLzdj7ORF5szOTguQouZseldsl9/BMzCAIvpg7Dk6vEVlSpxvead5H38quBC1Hj/zOZFaiLt5kGi1kf31QhtKVNA5ouDTqD5KRuUvUbi7Sjj2DCMFhXWEKzjBDdpc4CiglttTbjl1rzil8buuwczDsKrQYFwliHe/zEht/9M6Lq2DFjxljY6MnhK+P+i2ykG8daKoyLl/f8NWfYpD5dd6v/N40k2WnkOdpMvHqbAXOUaRMFhuRR5LC0AvxvKljlnfptfFCG6YlUVsGE7usHgGtnDd7qBUsstqgxvpFuOUZowEj0z
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a616f74-1a60-47b5-9341-08d7817d25f6
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Dec 2019 16:38:00.1367
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AvoJVNH0KxaK+vCW6WFvObT2pbCZCL4Hj1SXuJmlWElo9de6AA6m2gBdLVg6lBJHPw6gw3ssUKnzITGEZxWMRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR21MB1166
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <jakub.kicinski@netronome.com>
> Sent: Saturday, December 14, 2019 2:30 PM
> To: Haiyang Zhang <haiyangz@microsoft.com>
> Cc: sashal@kernel.org; linux-hyperv@vger.kernel.org; netdev@vger.kernel.o=
rg;
> KY Srinivasan <kys@microsoft.com>; Stephen Hemminger
> <sthemmin@microsoft.com>; olaf@aepfle.de; vkuznets
> <vkuznets@redhat.com>; davem@davemloft.net; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH v2,net] hv_netvsc: Fix tx_table init in rndis_set_sub=
channel()
>=20
> On Wed, 11 Dec 2019 14:26:27 -0800, Haiyang Zhang wrote:
> > Host can provide send indirection table messages anytime after RSS is
> > enabled by calling rndis_filter_set_rss_param(). So the host provided
> > table values may be overwritten by the initialization in
> > rndis_set_subchannel().
> >
> > To prevent this problem, move the tx_table initialization before callin=
g
> > rndis_filter_set_rss_param().
> >
> > Fixes: a6fb6aa3cfa9 ("hv_netvsc: Set tx_table to equal weight after
> subchannels open")
> > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
>=20
> Applied, but there are two more problems with this code:
>  - you should not reset the indirection table if it was configured by
>    the user to something other than the default (use the
>    netif_is_rxfh_configured() helper to check for that)

For Send indirection table (tx_table) ethtool doesn't have the option=20
to set it, and it's usually provided by the host. So we always initialize=20
it...
But, yes, for Receive indirection table (rx_table), I will make a fix, so=20
it will be set to default only for new devices, or changing the number=20
of channels; otherwise it will remain the same during operations like=20
changing MTU, ringparam.


>  - you should use the ethtool_rxfh_indir_default() wrapper
For rx_table, we already use it:
                rndis_device->rx_table[i] =3D ethtool_rxfh_indir_default(
For tx_table, I know it's the same operation (%, mod), but this wrapper=20
function's name is for rx_table. Should we use it for tx_table too?

>=20
> Please fix the former problem in the net tree, and after net is merged
> into linux/master and net-next in a week or two please follow up with
> the fix for the latter for net-next.

Sure.

Thanks,
- Haiyang

