Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FB4DAF9E7
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 12:06:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727623AbfIKKGm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 06:06:42 -0400
Received: from mail-eopbgr60048.outbound.protection.outlook.com ([40.107.6.48]:16841
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727289AbfIKKGm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Sep 2019 06:06:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k4+yKeF5BnmoWVt2jCRF2seKsNmMGjv7s5yFOIWGvWg=;
 b=l4UXG0o1z2SArjaxhNznxzg9JdWtiAQcuShAA6Ftrwsj+FHS9vqMZXncH6llNOYdPs5o1VMEgOkxz0aNDuskrVHpzDMBHq6+EggcexxfoohqUh3CtXntK09DLdcMgWeIulDotwXgTeeWpAZ1LMcqpWw7OBOWDmnMQ5OelR/ic/k=
Received: from VI1PR08CA0204.eurprd08.prod.outlook.com (2603:10a6:800:d2::34)
 by VI1PR08MB3837.eurprd08.prod.outlook.com (2603:10a6:803:be::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2263.15; Wed, 11 Sep
 2019 10:06:30 +0000
Received: from VE1EUR03FT035.eop-EUR03.prod.protection.outlook.com
 (2a01:111:f400:7e09::203) by VI1PR08CA0204.outlook.office365.com
 (2603:10a6:800:d2::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2241.15 via Frontend
 Transport; Wed, 11 Sep 2019 10:06:30 +0000
Authentication-Results: spf=temperror (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=none action=none
 header.from=arm.com;
Received-SPF: TempError (protection.outlook.com: error in processing during
 lookup of arm.com: DNS Timeout)
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 VE1EUR03FT035.mail.protection.outlook.com (10.152.18.110) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2263.14 via Frontend Transport; Wed, 11 Sep 2019 10:06:28 +0000
Received: ("Tessian outbound 46f6b453ea6b:v29"); Wed, 11 Sep 2019 10:06:25 +0000
X-CR-MTA-TID: 64aa7808
Received: from 8408d4696d8f.3 (ip-172-16-0-2.eu-west-1.compute.internal [104.47.2.59])
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 946BC100-4F00-4B4B-82F6-67B4CC59CAD4.1;
        Wed, 11 Sep 2019 10:06:20 +0000
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-db5eur01lp2059.outbound.protection.outlook.com [104.47.2.59])
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 8408d4696d8f.3
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Wed, 11 Sep 2019 10:06:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mHOJf4qGMp7wjJV6RB7BcBi5XuAf/GicEIvIs/QVejeoAFMECwzSfQr2Xsn+ygS2+GV1t3eom64aPA+YIJ21nQ6mBzvnsgqd5wLxt+noF0AclniZXrbrC38oBcqavmOIIGVkG1263Z4lOJDAnlLpONh4nzdkjrXUWQit0eK3N2zeLwkwO6EMKPmdTvT0MuOMLRME6AwQbmGqrF3m2nSlpsNjvVmbKu/Qz/dZrrPyc7I3KzCrPeTnsQp8ghYdgt4sw3h2Ah5yQIh4lg3K1Z6XuFdfHgUaANzzi6Fe48tYitc6NGzpFt53QXacTWjXZJCbm9MzdJ/McH9MBceAJhCfIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KbTkqNZ0cEiGG3aUv14A9ruDcWA8kfRS65d39Lw5rGc=;
 b=chm8qpv7x6Gep/WMusG7Dxe/hgR6fXi4hVcoppyHiSN2qPRZEBIOcoIHt3+dAoo/MO5hJua/jendfHmYSqbj8CYLwuIuZLeKxCi2N+FTqIkWXLuj4seU5E49Cz8HC8vyaXfnKfJMMGAEIE90JGiJVRkEN8Ta+rmE9ZLsJlktfC4BIsUQy+rhGer4tEyccUwfNtNCyyFQDfemPxUtjwRUxWiSszgmrAe3jmqcR6WLR7tkuqjwZLy1TSJhhI28xKC8rUOWkWcLRRMUj/LRh7+76Ajw5JwM9VdCcIIqsLeWaFi3FcUZFDv9xx5whYWPGSeMQRf9EVIaGIULsFPcv1+/8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KbTkqNZ0cEiGG3aUv14A9ruDcWA8kfRS65d39Lw5rGc=;
 b=sxW+5V/uaqgsZ9NhWMUd7a90DmvVg2yglOaUkyvo3s3wen6CMXogWOYh2E/U5UNNplDqrrH9V6PG18phB/gKdvBfM2kPROvfG24lLlmTh6ezuhHvHW4u4k64ibNqN4hHs53l6l7ra9uFLyS4xyAuBQfKMbe0prSj26QygMs5pSg=
Received: from HE1PR0801MB1676.eurprd08.prod.outlook.com (10.168.146.150) by
 HE1PR0801MB1786.eurprd08.prod.outlook.com (10.168.145.146) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2263.14; Wed, 11 Sep 2019 10:06:18 +0000
Received: from HE1PR0801MB1676.eurprd08.prod.outlook.com
 ([fe80::40a2:f892:29a7:2942]) by HE1PR0801MB1676.eurprd08.prod.outlook.com
 ([fe80::40a2:f892:29a7:2942%10]) with mapi id 15.20.2241.018; Wed, 11 Sep
 2019 10:06:18 +0000
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
Thread-Index: AQHVXjSmk4aR/CraEk2ZVbEHwQusoKcR7cKAgAyZL9CAAXZNAIADI2mAgAAlXYCAAYC68IABgBYA
Date:   Wed, 11 Sep 2019 10:06:18 +0000
Message-ID: <HE1PR0801MB1676847C0A84473797BF4346F4B10@HE1PR0801MB1676.eurprd08.prod.outlook.com>
References: <20190829063952.18470-1-jianyong.wu@arm.com>
        <20190829063952.18470-4-jianyong.wu@arm.com>
        <4d04867c-2188-9574-fbd1-2356c6b99b7d@kernel.org>
        <HE1PR0801MB16768ED94EA50010EEF634EAF4BA0@HE1PR0801MB1676.eurprd08.prod.outlook.com>
        <86h85osbzz.wl-maz@kernel.org>
        <HE1PR0801MB16768BE47D3D1F0662DDC3C7F4B70@HE1PR0801MB1676.eurprd08.prod.outlook.com>
 <86blvtsodw.wl-maz@kernel.org>
 <HE1PR0801MB16769814863B26F3B5DC708FF4B60@HE1PR0801MB1676.eurprd08.prod.outlook.com>
In-Reply-To: <HE1PR0801MB16769814863B26F3B5DC708FF4B60@HE1PR0801MB1676.eurprd08.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: d249a7b4-d46a-411d-97bd-249a7116e337.1
x-checkrecipientchecked: true
Authentication-Results-Original: spf=none (sender IP is )
 smtp.mailfrom=Jianyong.Wu@arm.com; 
x-originating-ip: [113.29.88.7]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-Correlation-Id: 6f05adae-613e-42b6-42c6-08d7369fb688
X-MS-Office365-Filtering-HT: Tenant
X-Microsoft-Antispam-Untrusted: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(1401327)(4618075)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:HE1PR0801MB1786;
X-MS-TrafficTypeDiagnostic: HE1PR0801MB1786:|HE1PR0801MB1786:|VI1PR08MB3837:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <VI1PR08MB3837DC6638FC8C7BA3963617F4B10@VI1PR08MB3837.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
x-ms-oob-tlc-oobclassifiers: OLM:10000;OLM:10000;
x-forefront-prvs: 0157DEB61B
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(346002)(376002)(136003)(39860400002)(189003)(199004)(13464003)(51444003)(14454004)(3846002)(25786009)(486006)(86362001)(476003)(66946007)(186003)(6246003)(99286004)(76176011)(7696005)(6436002)(256004)(71190400001)(71200400001)(14444005)(76116006)(5660300002)(66476007)(64756008)(66446008)(52536014)(229853002)(26005)(9686003)(74316002)(6916009)(478600001)(55236004)(55016002)(66066001)(81156014)(81166006)(53936002)(66556008)(102836004)(33656002)(8936002)(305945005)(7736002)(2906002)(8676002)(11346002)(446003)(54906003)(316002)(4326008)(53546011)(6116002)(6506007);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR0801MB1786;H:HE1PR0801MB1676.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: arm.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info-Original: pjwXO5FSGD5AeZK9zQ4hRBREccrAq2uI9IAugROKh2oi2n865LAu+mrkrONyhFQcdGKRMKa6aL+uTu6lIY8Ii5heDE6930TjqlphAnsuEyoa9i0xWHn2293ftTuryx13dkQMHH1odOKBHM0Wo75DNZkGzT0QYoQ70l2xUJnGR8g5+G3Mb2AlHt5VjeU/S7Aywehg3jWb+D7S3+PxaLuVn69awdWGtPlouko4ja46bfq/rkVLu44Lk9wgOnmhslsfXCl9Wm6XrCGHbrPHAbvlPF7kysJXWFU3/kUC/hsGrZchGVz6+yI0PAilX+b2WKqjJ5cCA3JGDooP57DRRMZiAUcoKoTkNOqoQ4d184O0dubG8NX0LAdC+RkcHCg46AcaD10Qzz5CR+BA886j/hC8Vgyldck9qgpkhkiqEXK+RnA=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0801MB1786
Original-Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jianyong.Wu@arm.com; 
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VE1EUR03FT035.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123;IPV:CAL;SCL:-1;CTRY:IE;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(346002)(376002)(396003)(13464003)(199004)(189003)(51444003)(40434004)(99286004)(7696005)(52536014)(97756001)(36906005)(316002)(356004)(229853002)(5660300002)(86362001)(54906003)(55016002)(9686003)(2906002)(66066001)(14454004)(47776003)(478600001)(26826003)(50466002)(22756006)(23726003)(6116002)(3846002)(25786009)(102836004)(53546011)(336012)(8936002)(476003)(446003)(126002)(63350400001)(11346002)(186003)(5024004)(486006)(14444005)(6246003)(26005)(4326008)(450100002)(6862004)(46406003)(70586007)(7736002)(70206006)(305945005)(76176011)(74316002)(76130400001)(8746002)(33656002)(81166006)(6506007)(81156014)(8676002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR08MB3837;H:64aa7808-outbound-1.mta.getcheckrecipient.com;FPR:;SPF:TempError;LANG:en;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;A:1;MX:1;
X-MS-Office365-Filtering-Correlation-Id-Prvs: 50ab1a98-e595-4456-358d-08d7369fb067
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(710020)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR08MB3837;
X-Forefront-PRVS: 0157DEB61B
X-Microsoft-Antispam-Message-Info: ZQ0o6Z9F+8p6ce0MhEvljVEc2TO//KtGycCo7Gykid18RsxaHpvtkf8r1+YgiOasB0s9RYu8Kc0eB7GaW6a6k9qY87pjgJv3AEkMev3ZTgmVys+nksEtuyJwp8eu5/kKjVFL4BMm3jkSbXs6lM2DeoqbqTS2dWI052jmXMcr8I2CooDXAwodbFAsJCf/wa91V3zCne831VSmZPpQsEh5zWXAV/CZ0LojVlxh630T86R0ZOwIUAHXVNMViyxTRTjyw0viFk7dixI9FP4UBdeiRDuWAg+3Hp8wZYoKQ8OXg5TVaJN4V3Vl+NTkztDiw0J0wplq38U9u8+PzPF6+fF8TepyEmlrC9hyCQPUHmn4w37YlUxY3/GYYIHNToPKD8LQHs99q30rZaziUAFEVpVXT1HrebiTZuveTZo7uzBZ1h4=
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2019 10:06:28.4486
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f05adae-613e-42b6-42c6-08d7369fb688
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB3837
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marc,

I think there are three points for the migration issue of ptp_kvm, where a =
VM using ptp_kvm migrates to a host without ptp_kvm support.

First: how does it impact the VM having migrated?
I run a VM with ptp_kvm support in guest but not support in host. the ptp0 =
will return 0 when get time from it which can't pass the check
of chrony, then chrony will choose another clocksource.  From this point, V=
M will only get lost in precision of time sync.

Second: how to check the failure of the ptp kvm service
when there is no ptp kvm service, hypercall will go into default ops, so we=
 can check the return value which can inform us the failure.

Third: how to inform VMM
There is ioctl cmd call "KVM_CHECK_EXTENSION" in kvm, which may do that thi=
ng. Accordingly, qemu should be offered the support which will block us.
We can try to add this support in kvm but we are not sure the response from=
 qemu side.

WDYT?

Jianyong Wu
Thanks

> -----Original Message-----
> From: Jianyong Wu (Arm Technology China)
> Sent: Tuesday, September 10, 2019 6:29 PM
> To: Marc Zyngier <maz@kernel.org>
> Cc: netdev@vger.kernel.org; pbonzini@redhat.com;
> sean.j.christopherson@intel.com; richardcochran@gmail.com; Mark Rutland
> <Mark.Rutland@arm.com>; Will Deacon <Will.Deacon@arm.com>; Suzuki
> Poulose <Suzuki.Poulose@arm.com>; linux-kernel@vger.kernel.org; Steve
> Capper <Steve.Capper@arm.com>; Kaly Xin (Arm Technology China)
> <Kaly.Xin@arm.com>; Justin He (Arm Technology China)
> <Justin.He@arm.com>
> Subject: RE: [RFC PATCH 3/3] Enable ptp_kvm for arm64
>
> Hi Marc,
>
> > -----Original Message-----
> > From: Marc Zyngier <maz@kernel.org>
> > Sent: Monday, September 9, 2019 7:25 PM
> > To: Jianyong Wu (Arm Technology China) <Jianyong.Wu@arm.com>
> > Cc: netdev@vger.kernel.org; pbonzini@redhat.com;
> > sean.j.christopherson@intel.com; richardcochran@gmail.com; Mark
> > Rutland <Mark.Rutland@arm.com>; Will Deacon <Will.Deacon@arm.com>;
> > Suzuki Poulose <Suzuki.Poulose@arm.com>; linux-kernel@vger.kernel.org;
> > Steve Capper <Steve.Capper@arm.com>; Kaly Xin (Arm Technology China)
> > <Kaly.Xin@arm.com>; Justin He (Arm Technology China)
> > <Justin.He@arm.com>
> > Subject: Re: [RFC PATCH 3/3] Enable ptp_kvm for arm64
> >
> >
> > > > > > Other questions: how does this works with VM migration?
> > > > > > Specially when moving from a hypervisor that supports the
> > > > > > feature to one that
> > > > doesn't?
> > > > > >
> > > > > I think it won't solve the problem generated by VM migration and
> > > > > only for VMs in a single machine.  Ptp_kvm only works for VMs in
> > > > > the same machine.  But using ptp (not ptp_kvm) clock, all the
> > > > > machines in a low latency network environment can keep time sync
> > > > > in high precision, Then VMs move from one machine to another
> > > > > will obtain a high precision time sync.
> > > >
> > > > That's a problem. Migration must be possible from one host to
> > > > another, even if that means temporarily loosing some (or a lot of)
> > > > precision. The service must be discoverable from userspace on the
> > > > host so that the MVV can decie whether a migration is possible or n=
ot.
> > > >
> > > Don't worry, things will be not that bad.  ptp_kvm will not trouble
> > > the VM migration. This ptp_kvm is one clocksource of the clock pool
> > > for chrony. Chrony will choose the highest precision clock from the
> > > pool. If host does not support ptp_kvm, the ptp_kvm will not be
> > > chosen as the clocksouce of chrony.  We have roughly the same logic
> > > of implementation of ptp_kvm with x86, and ptp_kvm works well in
> > > x86.  so I think that will be the case for arm64.
> > >
> > > Maybe I miss your point, I have no idea of MVV and can't get related
> > > info from google.  Also I'm not clear of your last words of how to
> > > decide VM migration is possible?
> >
> > Sorry. s/MVV/VMM/. Basically userspace, such as QEMU.
> >
> > Here's an example: The guest runs on a PTP aware host, starts using
> > the PTP service and uses HVC calls to get its clock. We now migrate
> > the guest to a non PTP-aware host. The hypercalls are now going to
> > fail unexpectedly. Is that something that is acceptable? I don't think
> > it is. Once you've allowed a guest to use a service, this service
> > should be preserved. I'd be more confident if we gave to userspace the
> > indication that the hypervisor supports PTP. Userspace can then decide
> whether to perform migration or not.
> >
>
> It's really a point we should consider. let me check the behavior of chro=
ny in
> this scenario first.
>
> Thanks
> Jianyong Wu
>
> > Thanks,
> >
> >     M.
> >
> > --
> > Jazz is not dead, it just smells funny.
IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.
