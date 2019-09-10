Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36E05AE81B
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 12:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390738AbfIJK3s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 06:29:48 -0400
Received: from mail-eopbgr130048.outbound.protection.outlook.com ([40.107.13.48]:53990
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729118AbfIJK3s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Sep 2019 06:29:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YBm079xAO5aD6unE3iPS65VbYWlYHDmTiwrxAw+k14o=;
 b=mfe9sSnAQg6nF5eVbz4or908UVhf1FAAwolBjAu01qJAavFDDHXn1q9ab0lGZP4w2Zi1CuQm0V6AtVq4N58WJLZ+f/mvoDFU/JT431qerkgiqeSIqefGZwGdOes7LTvDBbnf6i/Cv9YKzgl4NK0+VoqXO7R8K+LQYLhUkkxKoXA=
Received: from VI1PR0802CA0024.eurprd08.prod.outlook.com
 (2603:10a6:800:aa::34) by DBBPR08MB4920.eurprd08.prod.outlook.com
 (2603:10a6:10:d8::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2241.15; Tue, 10 Sep
 2019 10:29:35 +0000
Received: from AM5EUR03FT053.eop-EUR03.prod.protection.outlook.com
 (2a01:111:f400:7e08::201) by VI1PR0802CA0024.outlook.office365.com
 (2603:10a6:800:aa::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2241.15 via Frontend
 Transport; Tue, 10 Sep 2019 10:29:34 +0000
Authentication-Results: spf=temperror (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=temperror action=none
 header.from=arm.com;
Received-SPF: TempError (protection.outlook.com: error in processing during
 lookup of arm.com: DNS Timeout)
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM5EUR03FT053.mail.protection.outlook.com (10.152.16.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.2241.14 via Frontend Transport; Tue, 10 Sep 2019 10:29:33 +0000
Received: ("Tessian outbound 6c75c202b9e0:v28"); Tue, 10 Sep 2019 10:29:31 +0000
X-CR-MTA-TID: 64aa7808
Received: from 0c1cd70de25f.3 (ip-172-16-0-2.eu-west-1.compute.internal [104.47.13.55])
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 89BBF46E-92CF-4BA1-9DDE-AB3BF77EE0AF.1;
        Tue, 10 Sep 2019 10:29:26 +0000
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04lp2055.outbound.protection.outlook.com [104.47.13.55])
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 0c1cd70de25f.3
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384);
    Tue, 10 Sep 2019 10:29:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sv3YrW1WIjjHJiCvk9kNmDERa5SRwKtNnK6utbeMCfuTn72+IBG1sjYL4qd8w3Nc5VrT8qPtKicrFeIY7zb1j/gRxYOhNgNlJ0rEgkdD2wmyt1BbFvwZbOOkrf4kmV3S4eBAf+3TteAVyXK/lt/nOg6O/fpxgMwI3ZTK7uVIsmv+WCpSUGNY0/8tAHlRS9khfn4iD1ZBw/zrs9Nox4c/OdmG/S1ho3qy1liRrNVxNcXRydJG++rgHsAN8C2lHr8zrYyLE8b+1CN6EqN5zPuzgvaTnKS3r7jkAApQ9PcXxWhU5db+KgoLaFKfkvs0SOk8cPvQDyvUHEjrRaSIL6K9Rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3aP1+Xbx8y2v1FLAh3YrzG8m0XzOH/KbK7W2J0YkRAc=;
 b=T3JPgMNW9UM0Uf67D5k/+MO0lghRlQguaR4LBrOAJg43EK7W9IDsOZix3TrjexJRCf3EnF0R5Gl2XYK6ShUmuZlmFIcorxobT1HShWStPe9npkFIQ5Vr4lVhxs3Ez92cf+EbIH6lxYuRvQ4RY6i+hwDik0/ea0RAGdX9nNs2tiwEfzAcsgLh+4Iv9PhGz1rV9rQXFDxdFaytiXtDk7IXCxLugsOOLw5NigUUOeKUrnCN02EtsdQOmKM0CcmFnqtI0ax43fRpiao8XRQn8joRaEjzyThJgO+6+a18UDYpslFjGh8MPXzEz6pkHLzR+CuNzHrU9YrV4/uLOvjH9gdcAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3aP1+Xbx8y2v1FLAh3YrzG8m0XzOH/KbK7W2J0YkRAc=;
 b=j9dfnZAeA3B1iVCRlIVrSeK4mAzAlbU63494vMY58xOAEUmcCZ3ehQIcveno7SJja4+m6vFZnLpbIVszFCIgG2J+thy5Gj92FizAQ/V/wqsQzJTbOeu4Bq910GSJRz1HPYmerVedHzTupMg1fqOFILpX34fI4C8zjVKtoqzYPSM=
Received: from HE1PR0801MB1676.eurprd08.prod.outlook.com (10.168.146.150) by
 HE1PR0801MB2041.eurprd08.prod.outlook.com (10.168.98.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.14; Tue, 10 Sep 2019 10:29:24 +0000
Received: from HE1PR0801MB1676.eurprd08.prod.outlook.com
 ([fe80::40a2:f892:29a7:2942]) by HE1PR0801MB1676.eurprd08.prod.outlook.com
 ([fe80::40a2:f892:29a7:2942%10]) with mapi id 15.20.2241.018; Tue, 10 Sep
 2019 10:29:23 +0000
From:   "Jianyong Wu (Arm Technology China)" <Jianyong.Wu@arm.com>
To:     Marc Zyngier <maz@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Suzuki Poulose <Suzuki.Poulose@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steve Capper <Steve.Capper@arm.com>,
        "Kaly Xin (Arm Technology China)" <Kaly.Xin@arm.com>,
        "Justin He (Arm Technology China)" <Justin.He@arm.com>
Subject: RE: [RFC PATCH 3/3] Enable ptp_kvm for arm64
Thread-Topic: [RFC PATCH 3/3] Enable ptp_kvm for arm64
Thread-Index: AQHVXjSmk4aR/CraEk2ZVbEHwQusoKcR7cKAgAyZL9CAAXZNAIADI2mAgAAlXYCAAYC68A==
Date:   Tue, 10 Sep 2019 10:29:23 +0000
Message-ID: <HE1PR0801MB16769814863B26F3B5DC708FF4B60@HE1PR0801MB1676.eurprd08.prod.outlook.com>
References: <20190829063952.18470-1-jianyong.wu@arm.com>
        <20190829063952.18470-4-jianyong.wu@arm.com>
        <4d04867c-2188-9574-fbd1-2356c6b99b7d@kernel.org>
        <HE1PR0801MB16768ED94EA50010EEF634EAF4BA0@HE1PR0801MB1676.eurprd08.prod.outlook.com>
        <86h85osbzz.wl-maz@kernel.org>
        <HE1PR0801MB16768BE47D3D1F0662DDC3C7F4B70@HE1PR0801MB1676.eurprd08.prod.outlook.com>
 <86blvtsodw.wl-maz@kernel.org>
In-Reply-To: <86blvtsodw.wl-maz@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: 32ac8c2a-0c41-4725-b22d-c1af0835b933.1
x-checkrecipientchecked: true
Authentication-Results-Original: spf=none (sender IP is )
 smtp.mailfrom=Jianyong.Wu@arm.com; 
x-originating-ip: [113.29.88.7]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-Correlation-Id: f5e8c6b6-7d9e-4565-0f11-08d735d9c58f
X-MS-Office365-Filtering-HT: Tenant
X-Microsoft-Antispam-Untrusted: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:HE1PR0801MB2041;
X-MS-TrafficTypeDiagnostic: HE1PR0801MB2041:|HE1PR0801MB2041:|DBBPR08MB4920:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <DBBPR08MB49209173DE89C64370F4C779F4B60@DBBPR08MB4920.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
x-ms-oob-tlc-oobclassifiers: OLM:9508;OLM:9508;
x-forefront-prvs: 01565FED4C
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(346002)(136003)(396003)(366004)(376002)(51444003)(189003)(199004)(13464003)(446003)(476003)(55236004)(26005)(66946007)(66556008)(64756008)(66476007)(76116006)(66446008)(14454004)(99286004)(33656002)(71200400001)(7696005)(256004)(478600001)(14444005)(71190400001)(2906002)(52536014)(6116002)(3846002)(86362001)(5660300002)(8936002)(81166006)(81156014)(8676002)(305945005)(7736002)(486006)(53936002)(74316002)(55016002)(9686003)(54906003)(6246003)(316002)(25786009)(66066001)(6916009)(229853002)(186003)(11346002)(102836004)(6506007)(53546011)(76176011)(6436002)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR0801MB2041;H:HE1PR0801MB1676.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: arm.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info-Original: H3ntVl+X+ed5sQ94sT3anqivXigk2ayNo7MNovNZ19h2TWvDZcfs0imuu+eGGHH9k1I/aZRAdLUxyuSMdyDQZhHeV/4aqzFWEqwKW6V5RJ4ENJSsudpW2hu+2rC9XC5Z33O5r/0OhOZEhy24gHKlhjJpS6GpTbjaVQGog9bscASMdNEeFPbyhUNY19mfW2rVLjZAAPGHFZp4xsCBpYJR7cz8tMED8EDAkqdu8gZYRg1P6RaNL7JbxkNWV2F2CpQaPDeZ4R2ehExwhiDIchdX6DZkZfhs8blYltB84OgZUI2ZV3C8qVem1WOMScRdwALtFIm+HKbmPJlsIcse9a36y+y9rYujBO+7pxsdOLWJcgZh5vSqlcunGCCKg6NhQE/8VWxtO9P9TbhtWcOPECPnNUIk0aFCSH+7kAUh/nJWQjM=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0801MB2041
Original-Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jianyong.Wu@arm.com; 
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: AM5EUR03FT053.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123;IPV:CAL;SCL:-1;CTRY:IE;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(376002)(39860400002)(346002)(2980300002)(40434004)(51444003)(189003)(199004)(13464003)(8936002)(356004)(6246003)(70586007)(9686003)(99286004)(70206006)(55016002)(6506007)(47776003)(23726003)(5660300002)(478600001)(76130400001)(52536014)(26826003)(53546011)(229853002)(14444005)(5024004)(3846002)(6116002)(14454004)(446003)(6862004)(102836004)(81166006)(316002)(50466002)(33656002)(66066001)(63370400001)(81156014)(11346002)(7696005)(54906003)(86362001)(63350400001)(76176011)(2906002)(25786009)(305945005)(36906005)(97756001)(7736002)(476003)(22756006)(336012)(74316002)(186003)(126002)(8676002)(486006)(8746002)(46406003)(26005)(4326008)(450100002);DIR:OUT;SFP:1101;SCL:1;SRVR:DBBPR08MB4920;H:64aa7808-outbound-1.mta.getcheckrecipient.com;FPR:;SPF:TempError;LANG:en;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;MX:1;A:1;
X-MS-Office365-Filtering-Correlation-Id-Prvs: a1bfbdbc-f09a-4d87-b9c8-08d735d9bfd5
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(710020)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DBBPR08MB4920;
X-Forefront-PRVS: 01565FED4C
X-Microsoft-Antispam-Message-Info: DMMYp8+9XVSYV4gjcA42uauT7LvE5jaGbR/uSAaqllcEdxT8nwbZN+92SyDKn1CbwyHrjTgqrCr9ATRynT5w43CYJzCTZ3tZ3SUmfV5ZcP4dT49DitjrWpMu9OZOtAmMR2G4USzSKGA/4cWrOclfSHPxNl9MY5d0Ann2n9OecM2Yvh2FL1pg5fLQt1fl3aVU68RtwqZceS4ajOuAmwxYfvsLK4F+iGmMzNICqhxjq81XSfVG3Z76Y7K00RW+P+9O6rF4sz82aJAGPoSdEpJ1gjnxZATCc+rMvLgWNTWr3gQBWGdNEy5pCb4y5Hv0HV4SvmDaBFiIN3gG3gPE8XRl5wpP/yhqcYDBJH3o6YUWz0u0TW3eYTExAjl+lixzMLI0V1jKPo2yL92U+UYG04TxsdYGuibtCV1o3HnxtmJbohM=
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2019 10:29:33.3726
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f5e8c6b6-7d9e-4565-0f11-08d735d9c58f
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB4920
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marc,

> -----Original Message-----
> From: Marc Zyngier <maz@kernel.org>
> Sent: Monday, September 9, 2019 7:25 PM
> To: Jianyong Wu (Arm Technology China) <Jianyong.Wu@arm.com>
> Cc: netdev@vger.kernel.org; pbonzini@redhat.com;
> sean.j.christopherson@intel.com; richardcochran@gmail.com; Mark Rutland
> <Mark.Rutland@arm.com>; Will Deacon <Will.Deacon@arm.com>; Suzuki
> Poulose <Suzuki.Poulose@arm.com>; linux-kernel@vger.kernel.org; Steve
> Capper <Steve.Capper@arm.com>; Kaly Xin (Arm Technology China)
> <Kaly.Xin@arm.com>; Justin He (Arm Technology China)
> <Justin.He@arm.com>
> Subject: Re: [RFC PATCH 3/3] Enable ptp_kvm for arm64
>
> On Mon, 09 Sep 2019 11:17:24 +0100,
> "Jianyong Wu (Arm Technology China)" <Jianyong.Wu@arm.com> wrote:
>
> Hi Jianyoung,
>
> [...]
>
> > > > > I'm definitely not keen on exposing the internals of the
> > > > > arch_timer driver to random subsystems. Furthermore, you seem to
> > > > > expect that the guest kernel will only use the arch timer as a
> > > > > clocksource, and nothing really guarantees that (in which case
> > > get_device_system_crosststamp will fail).
> > > > >
> > > > The code here is really ugly, I need a better solution to offer a
> > > > clock source For the guest.
> > > >
> > > > > It looks to me that we'd be better off exposing a core
> > > > > timekeeping API that populates a struct system_counterval_t
> > > > > based on the
> > > > > *current* timekeeper monotonic clocksource. This would simplify
> > > > > the split between generic and arch-specific code.
> > > > >
> > > > I think it really necessary.
> > > >
> > > > > Whether or not tglx will be happy with the idea is another
> > > > > problem, but I'm certainly not taking any change to the arch
> > > > > timer code based on
> > > this.
> > > > >
> > > > I can have a try, but the detail is not clear for me now.
> > >
> > > Something along those lines:
> > >
> > > From 5f1c061e55c691d64012bc7c1490a1a8c4432c67 Mon Sep 17 00:00:00
> > > 2001
> > > From: Marc Zyngier <maz@kernel.org>
> > > Date: Sat, 7 Sep 2019 10:11:49 +0100
> > > Subject: [PATCH] timekeeping: Expose API allowing retrival of
> > > current clocksource and counter value
> > >
> > > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > > ---
> > >  include/linux/timekeeping.h |  5 +++++
> > >  kernel/time/timekeeping.c   | 12 ++++++++++++
> > >  2 files changed, 17 insertions(+)
> > >
> > > diff --git a/include/linux/timekeeping.h
> > > b/include/linux/timekeeping.h index
> > > b27e2ffa96c1..6df26a913711 100644
> > > --- a/include/linux/timekeeping.h
> > > +++ b/include/linux/timekeeping.h
> > > @@ -275,6 +275,11 @@ extern int get_device_system_crosststamp(
> > >                       struct system_time_snapshot *history,
> > >                       struct system_device_crosststamp *xtstamp);
> > >
> > > +/*
> > > + * Obtain current monotonic clock and its counter value  */ extern
> > > +void get_current_counterval(struct system_counterval_t *sc);
> > > +
> > >  /*
> > >   * Simultaneously snapshot realtime and monotonic raw clocks
> > >   */
> > > diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
> > > index
> > > d911c8470149..de689bbd3808 100644
> > > --- a/kernel/time/timekeeping.c
> > > +++ b/kernel/time/timekeeping.c
> > > @@ -1098,6 +1098,18 @@ static bool cycle_between(u64 before, u64
> > > test,
> > > u64 after)
> > >       return false;
> > >  }
> > >
> > > +/**
> > > + * get_current_counterval - Snapshot the current clocksource and
> > > +counter
> > > value
> > > + * @sc:      Pointer to a struct containing the current clocksource =
and its
> > > value
> > > + */
> > > +void get_current_counterval(struct system_counterval_t *sc) {
> > > +     struct timekeeper *tk =3D &tk_core.timekeeper;
> > > +
> > > +     sc->cs =3D READ_ONCE(tk->tkr_mono.clock);
> > > +     sc->cycles =3D sc->cs->read(sc->cs); }
> > > +
> > >  /**
> > >   * get_device_system_crosststamp - Synchronously capture
> > > system/device timestamp
> > >   * @get_time_fn:     Callback to get simultaneous device time and
> > >
> > > which should do the right thing.
> > >
> > It is a good news for me. These code is indeed what I need!  So what's
> > your plan about this patch?  Is there any problem with you if I
> > include these code into my patch ?
>
> Just add this patch as part of your series (I'll try to write an actual c=
ommit log
> for that).

Very kind of you!
>
> [...]
>
> > > > > Other questions: how does this works with VM migration?
> > > > > Specially when moving from a hypervisor that supports the
> > > > > feature to one that
> > > doesn't?
> > > > >
> > > > I think it won't solve the problem generated by VM migration and
> > > > only for VMs in a single machine.  Ptp_kvm only works for VMs in
> > > > the same machine.  But using ptp (not ptp_kvm) clock, all the
> > > > machines in a low latency network environment can keep time sync
> > > > in high precision, Then VMs move from one machine to another will
> > > > obtain a high precision time sync.
> > >
> > > That's a problem. Migration must be possible from one host to
> > > another, even if that means temporarily loosing some (or a lot of)
> > > precision. The service must be discoverable from userspace on the
> > > host so that the MVV can decie whether a migration is possible or not=
.
> > >
> > Don't worry, things will be not that bad.  ptp_kvm will not trouble
> > the VM migration. This ptp_kvm is one clocksource of the clock pool
> > for chrony. Chrony will choose the highest precision clock from the
> > pool. If host does not support ptp_kvm, the ptp_kvm will not be chosen
> > as the clocksouce of chrony.  We have roughly the same logic of
> > implementation of ptp_kvm with x86, and ptp_kvm works well in x86.  so
> > I think that will be the case for arm64.
> >
> > Maybe I miss your point, I have no idea of MVV and can't get related
> > info from google.  Also I'm not clear of your last words of how to
> > decide VM migration is possible?
>
> Sorry. s/MVV/VMM/. Basically userspace, such as QEMU.
>
> Here's an example: The guest runs on a PTP aware host, starts using the P=
TP
> service and uses HVC calls to get its clock. We now migrate the guest to =
a non
> PTP-aware host. The hypercalls are now going to fail unexpectedly. Is tha=
t
> something that is acceptable? I don't think it is. Once you've allowed a =
guest
> to use a service, this service should be preserved. I'd be more confident=
 if we
> gave to userspace the indication that the hypervisor supports PTP. Usersp=
ace
> can then decide whether to perform migration or not.
>

It's really a point we should consider. let me check the behavior of chrony=
 in this scenario first.

Thanks
Jianyong Wu

> Thanks,
>
>       M.
>
> --
> Jazz is not dead, it just smells funny.
IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.
