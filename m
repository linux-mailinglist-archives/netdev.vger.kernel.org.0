Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4611E84511
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 08:58:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727541AbfHGG4j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 02:56:39 -0400
Received: from mail-eopbgr1310100.outbound.protection.outlook.com ([40.107.131.100]:9136
        "EHLO APC01-SG2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727281AbfHGG4i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Aug 2019 02:56:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T5g/3+yNxb/zgcMIO0AQ3RISiX8ssmFzCcreSK0VhEGdi7qXerowxsWDIEXAbORyTH9k26NGRMyzYUGF2dCI1lE3lZZvYp4zitE1s81pqQ4toRk+ztkU3O8vDPPR1bO6NoWc9thiMO1YucU/E9lXlHOFH/PcLxnyAK6TS8qbMXcM1qkZFfV0egg9NpaV0p142uNEOSI3nEczgynWnxOZ94AlNNLMvTndbMRBMUTPOLdUkK3uabwdMRNtU/7xYiXSN+DwvmsD02WA8DYBvl3MJzlLRa2vJTX91HLy7ZWHPIzGk55IzUlszrkEusv0AhKx+9GZTa8WoBubEsTU64bFDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NmuflkPpMi8zfU7PGiKZXEUyI9dC1fJj3eCZCsICeAE=;
 b=RuNV3saHbK9RKhYYJEedwoe5YaHj/TkkmIHWH0GCNf+Uy3bOKoILsUmk156I8YPs3MaTIG/aVt9AmNvHWK/gWJUJK5d//J9IQGLGZrUrZB5oCbjeWtgTmazBEoBLzVR039a7JV5z9rk+msoP5odccGJNDeujKdR4e6sOj4O0WPgzHbqpqbn8yM0k/XdObnR5qYSDyMC28SPG2dUEp0dPTSNe2hHXFlxVIf/zD8TL/bglAPUXHOANCS7JMfaRVDA5bccvbvdkGQeCUxBpWu8sGaBbbE7saH/QOh5uqMaP4Nw4cUZBFT2+VemE+b7bzJnbzkxi0Pn/Qba2AsSOQawzIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NmuflkPpMi8zfU7PGiKZXEUyI9dC1fJj3eCZCsICeAE=;
 b=KVjos8LSIIDPxspPIbtbn/ErKa1O8tpzU4Q19eXyDKkxoLTfHc6g2Ch8MRYbg1eKjzfCa9vYTGX7ZQFIbw4mC8OlK7TuSO5YfPm8oJyzvYUvTT/GYunVEU5U3y7LFc9ElPVP0UuqZTFnrmZcP7mZwsLzRIw9bZKdr8NFWby0Ito=
Received: from PU1P153MB0169.APCP153.PROD.OUTLOOK.COM (10.170.189.13) by
 PU1P153MB0153.APCP153.PROD.OUTLOOK.COM (10.170.188.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.2; Wed, 7 Aug 2019 06:56:12 +0000
Received: from PU1P153MB0169.APCP153.PROD.OUTLOOK.COM
 ([fe80::d44e:57b7:d8fc:e91c]) by PU1P153MB0169.APCP153.PROD.OUTLOOK.COM
 ([fe80::d44e:57b7:d8fc:e91c%7]) with mapi id 15.20.2157.001; Wed, 7 Aug 2019
 06:56:12 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Stephen Hemminger <sthemmin@microsoft.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "sashal@kernel.org" <sashal@kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        vkuznets <vkuznets@redhat.com>,
        "marcelo.cerri@canonical.com" <marcelo.cerri@canonical.com>
Subject: RE: [PATCH net] hv_netvsc: Fix a warning of suspicious RCU usage
Thread-Topic: [PATCH net] hv_netvsc: Fix a warning of suspicious RCU usage
Thread-Index: AdVMFVwGFODpycnVS02FuESxq+YKEgAdY+cAABfZVkA=
Date:   Wed, 7 Aug 2019 06:56:12 +0000
Message-ID: <PU1P153MB0169F8B31B25E995742CCB0BBFD40@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
References: <PU1P153MB0169AECABF6094A3E7BEE381BFD50@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
 <20190806121242.141c2324@cakuba.netronome.com>
In-Reply-To: <20190806121242.141c2324@cakuba.netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=decui@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-08-07T06:56:09.1298538Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=a5d92f6b-b5aa-4b3e-805f-73ee1cb38d23;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=decui@microsoft.com; 
x-originating-ip: [2601:600:a280:1760:d40f:1221:5def:ae65]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1065dff6-d59e-45d1-ee93-08d71b04558f
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:PU1P153MB0153;
x-ms-traffictypediagnostic: PU1P153MB0153:|PU1P153MB0153:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <PU1P153MB01531A97D333EC42C6A6FA09BFD40@PU1P153MB0153.APCP153.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 01221E3973
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(136003)(366004)(396003)(376002)(346002)(199004)(189003)(446003)(14454004)(6246003)(9686003)(7416002)(53546011)(6506007)(486006)(229853002)(476003)(11346002)(14444005)(256004)(6436002)(102836004)(53936002)(55016002)(46003)(66446008)(64756008)(66946007)(68736007)(10090500001)(8990500004)(66556008)(66476007)(76116006)(5660300002)(186003)(4744005)(2906002)(74316002)(10290500003)(478600001)(7736002)(305945005)(33656002)(6116002)(7696005)(76176011)(8676002)(71190400001)(71200400001)(316002)(54906003)(1511001)(4326008)(25786009)(81156014)(81166006)(8936002)(99286004)(86362001)(110136005)(52536014)(22452003)(6636002);DIR:OUT;SFP:1102;SCL:1;SRVR:PU1P153MB0153;H:PU1P153MB0169.APCP153.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: YN/IsYnS09xEOV93iWlK5JwicLQJBnseLb3Tja37SeOxl0qsdbvRGgDDtVyuxZIZf8ivgzy1z7mPcFnzWtJo1uBybaBxI0duKif+YbPADph7zHvIAV78Znkak0Cxr/SpsB5dPXksadZfmyNp8cBvdwXAY+ZW1s3nwXKIfjtri5NVcn3z+XXQA17DdXXgaMKeh1OsHkkAJwUCd1WveKzbZEXJko/Y9nvIKF4Q004Ty0O2+q6C335puLP1FApqiwd0bcw1cRmo/jwJtbf9fmW4/RrZScrbGO98M57WJ9rzkpBBY9eOtV5bm6+8FFrOBxX7er86VXDWY3SF7pzOrL/Kn5WMJosWheS1R+ylkNMxOsn9BL4ZMIt6T+chDWFrRDd3A70PQfrc0BTp1Q6ZWNEBs1roFrz5pkPbeXVmp1RfYkg=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1065dff6-d59e-45d1-ee93-08d71b04558f
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Aug 2019 06:56:12.1132
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ukUhvCu00a86KJybLZBjGEIUzP4JHT32gQerYAJFpfFzO4wop30Hny0puNqhpKhsKI3kmjy9CtIY8OeL7g7tfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PU1P153MB0153
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Jakub Kicinski <jakub.kicinski@netronome.com>
> Sent: Tuesday, August 6, 2019 12:13 PM
> To: Dexuan Cui <decui@microsoft.com>
>=20
> On Tue, 6 Aug 2019 05:17:44 +0000, Dexuan Cui wrote:
> > This fixes a warning of "suspicious rcu_dereference_check() usage"
> > when nload runs.
> >
> > Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
> > Signed-off-by: Dexuan Cui <decui@microsoft.com>
>=20
> Minor change in behaviour would perhaps be worth acknowledging in the
> commit message (since you check ndev for NULL later now), and a Fixes
> tag would be good.
>=20
> But the looks pretty straightforward and correct!

Hi,
Yeah, it looks the minor behavior change doesn't matter, because IMO the=20
'nvdev' can only be NULL when the NIC is being removed, or the MTU is
being changed, etc.

The Fixes tag is:
Fixes: 776e726bfb34 ("netvsc: fix RCU warning in get_stats")

If I should send a v2, please let me know.

Thanks,
-- Dexuan

