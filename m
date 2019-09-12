Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59719B0BAC
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 11:41:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730870AbfILJk5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 05:40:57 -0400
Received: from mail-eopbgr20084.outbound.protection.outlook.com ([40.107.2.84]:54247
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730237AbfILJk4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Sep 2019 05:40:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/nP8FXwR+G1/LMly4kJOk/ZnZvDitqw+XV1729vDn34=;
 b=WTu/HCbc7ofhhm6RYMMxQYU3qGQAAOTaUZPLiQgB+oJuj/vhpSO21hZ/ujacj3t1blAt+/nFJho2DnGvvh15TwAUsqu1Xrk1jgzLw8lvSvxFoLAeq6dwcAW4z087oAL5gEvlXkmjzSzi4buMZmDWM8tLr3cKZooEWMkWGv7zzlo=
Received: from VI1PR0802CA0003.eurprd08.prod.outlook.com
 (2603:10a6:800:aa::13) by AM0PR08MB5412.eurprd08.prod.outlook.com
 (2603:10a6:208:183::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2263.17; Thu, 12 Sep
 2019 09:40:49 +0000
Received: from DB5EUR03FT025.eop-EUR03.prod.protection.outlook.com
 (2a01:111:f400:7e0a::203) by VI1PR0802CA0003.outlook.office365.com
 (2603:10a6:800:aa::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2263.15 via Frontend
 Transport; Thu, 12 Sep 2019 09:40:49 +0000
Authentication-Results: spf=temperror (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=none action=none
 header.from=arm.com;
Received-SPF: TempError (protection.outlook.com: error in processing during
 lookup of arm.com: DNS Timeout)
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB5EUR03FT025.mail.protection.outlook.com (10.152.20.104) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2263.14 via Frontend Transport; Thu, 12 Sep 2019 09:40:47 +0000
Received: ("Tessian outbound 41a5ea8a6ffd:v30"); Thu, 12 Sep 2019 09:40:45 +0000
X-CR-MTA-TID: 64aa7808
Received: from c6ac6b2b3854.2 (cr-mta-lb-1.cr-mta-net [104.47.12.56])
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id ED5793BC-4888-476A-A8E7-13CDBFCD1A85.1;
        Thu, 12 Sep 2019 09:40:40 +0000
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04lp2056.outbound.protection.outlook.com [104.47.12.56])
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id c6ac6b2b3854.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Thu, 12 Sep 2019 09:40:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k8QvU8lJ7gAJFjzovTsrvt8sKv0U//LEvW9HkHNnpz7WfKU3v27p8HlqUca2MObManIEVgb3G2FAyCHdWf6H2Kc9JuCdP7LPSbpElCs1DH12WOaYb7RUUnR5Q/lKjsUlSa73X5yiQZEsL0+I1EH0v3BQAq48i3dFhXq61QzJLxPGHdQPsAhSd/av9azfaU/3k8/FyqMNFJGxwho/Eh3cenfnsy1eiq4SQU+C8XlKdz1nO7PzCTstJUg0qGM6BMVwcF27tQeW7UH1h/RuqypSRyUgs3zZITB0uXFZ0Fm1mAxQtpE400Sn81QBjJClWuUgwtso04ws7epQyp+VP3mpKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vsMvwQgfoPzwvBKJsUmbHOtqdL+nfmCPoho62Bik24w=;
 b=jm45yN+BLc6jRVwntWCwYgpVxTkh1QnrKuRdrTbFZk06oSQGHKOvLLDaKSdXKHETvSDiy9GGgyEonUHXeRyBm3Wxdw8DzlPIfhlq80xKzxzqEiubHVfMo9oZEvJLgYyE1pkr+G2O48VmkOyOSU963GyxkVi5P6QzDi4juJlU/8U/cqOAYsq369DiLI9uHS48oSPbmG91LematDNwjmiRFnlswxfY9uZ7bhtAdFmP+YTUsKsb1fwNTujoX3lycqIiLeKl2TDWm4EpyaY3CT0mqU3iTl8N8KpbeG8NhlubgxHlM59Ko03SDZ4NeJQrtUw+/5HRzGlmAPDacDAtHm4Ubw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vsMvwQgfoPzwvBKJsUmbHOtqdL+nfmCPoho62Bik24w=;
 b=dEHp5vjOsDgjT5B2ToXeiTWPbbi1C3+x6Hx74jn7KSjS70t8NUNG+aSa9+TUn5byk9sMG8eXySa2SgFmYg6OFetJsECgQB6uyERLXeechDqKsOuvuyHG7Iq6CW8bXWnK0clCXWdbAqepRQ0553nrlmwxieJEgeJIYEAKP6mtW8c=
Received: from HE1PR0801MB1676.eurprd08.prod.outlook.com (10.168.146.150) by
 HE1PR0801MB2076.eurprd08.prod.outlook.com (10.168.93.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.18; Thu, 12 Sep 2019 09:40:37 +0000
Received: from HE1PR0801MB1676.eurprd08.prod.outlook.com
 ([fe80::40a2:f892:29a7:2942]) by HE1PR0801MB1676.eurprd08.prod.outlook.com
 ([fe80::40a2:f892:29a7:2942%10]) with mapi id 15.20.2241.018; Thu, 12 Sep
 2019 09:40:37 +0000
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
Thread-Index: AQHVXjSmk4aR/CraEk2ZVbEHwQusoKcR7cKAgAyZL9CAAXZNAIADI2mAgAAlXYCAAYC68IABgBYAgAAlaoCAAW7M4A==
Date:   Thu, 12 Sep 2019 09:40:37 +0000
Message-ID: <HE1PR0801MB167691A9F288F65DC6F44156F4B00@HE1PR0801MB1676.eurprd08.prod.outlook.com>
References: <20190829063952.18470-1-jianyong.wu@arm.com>
        <20190829063952.18470-4-jianyong.wu@arm.com>
        <4d04867c-2188-9574-fbd1-2356c6b99b7d@kernel.org>
        <HE1PR0801MB16768ED94EA50010EEF634EAF4BA0@HE1PR0801MB1676.eurprd08.prod.outlook.com>
        <86h85osbzz.wl-maz@kernel.org>
        <HE1PR0801MB16768BE47D3D1F0662DDC3C7F4B70@HE1PR0801MB1676.eurprd08.prod.outlook.com>
        <86blvtsodw.wl-maz@kernel.org>
        <HE1PR0801MB16769814863B26F3B5DC708FF4B60@HE1PR0801MB1676.eurprd08.prod.outlook.com>
        <HE1PR0801MB1676847C0A84473797BF4346F4B10@HE1PR0801MB1676.eurprd08.prod.outlook.com>
 <86ftl3rrxg.wl-maz@kernel.org>
In-Reply-To: <86ftl3rrxg.wl-maz@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: 6bcd65ba-a632-48c1-b2a9-cd27758a1814.1
x-checkrecipientchecked: true
Authentication-Results-Original: spf=none (sender IP is )
 smtp.mailfrom=Jianyong.Wu@arm.com; 
x-originating-ip: [113.29.88.7]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-Correlation-Id: 9dc2949e-3384-4f1c-4751-08d737654a7f
X-MS-Office365-Filtering-HT: Tenant
X-Microsoft-Antispam-Untrusted: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:HE1PR0801MB2076;
X-MS-TrafficTypeDiagnostic: HE1PR0801MB2076:|HE1PR0801MB2076:|AM0PR08MB5412:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <AM0PR08MB54122DBBB6F8C739F6C50CC5F4B00@AM0PR08MB5412.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
x-ms-oob-tlc-oobclassifiers: OLM:10000;OLM:10000;
x-forefront-prvs: 01583E185C
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;SFS:(10009020)(4636009)(346002)(39860400002)(376002)(366004)(396003)(136003)(189003)(199004)(13464003)(3846002)(66476007)(66556008)(66946007)(8936002)(6916009)(186003)(53936002)(2906002)(99286004)(81166006)(53546011)(14454004)(6116002)(55236004)(4326008)(256004)(86362001)(5660300002)(25786009)(102836004)(54906003)(6506007)(81156014)(8676002)(508600001)(26005)(446003)(71200400001)(11346002)(64756008)(66446008)(7736002)(71190400001)(66066001)(14444005)(316002)(76176011)(305945005)(52536014)(55016002)(74316002)(33656002)(229853002)(476003)(6246003)(486006)(9686003)(6436002)(7696005)(76116006);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR0801MB2076;H:HE1PR0801MB1676.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: arm.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info-Original: CeABzmh2rRvGksFnb2/g8cQJvaSysy2nqvktxmh3oMlzkz/xwi1SfXPh1xIdgUgiK4czhcQd8BL6pueU6Aq3aiW/qrgzD28wJGrrCxUaWo2fnv1w81wrtpbJYcf57ZrDHTemWkfdccQIjLq2wJQglXAKQNcIm2YNkdLPIYSMs9MmMt5Pi+eFZSeyuj3mgksN0BynZbxwHHBqBIHNa3p33GtrKazeuJHmaAeWJ3CO8nSEMAumzogNJ8e4kR3uc9MpHrR2n8Sp3FPb1Lt+jAW7XIMK2vhazmyKPBhXD6hfLjYf4tBye7eGyyAWeZjjcreFvlfI98++v3jEy+vO90AuhkvqmjenycWOH8itPIpaVKGLeVbHT95KjJ38d1RUT2dErL6EWnZTDSMPgAZ+ciegy/70nRF2n7IiU5foejuwGko=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0801MB2076
Original-Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jianyong.Wu@arm.com; 
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DB5EUR03FT025.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123;IPV:CAL;SCL:-1;CTRY:IE;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(396003)(39860400002)(376002)(346002)(136003)(13464003)(189003)(199004)(40434004)(46406003)(23726003)(229853002)(25786009)(6116002)(3846002)(97756001)(6862004)(9686003)(22756006)(6246003)(126002)(476003)(55016002)(5024004)(14444005)(450100002)(4326008)(99286004)(5660300002)(50466002)(86362001)(356004)(47776003)(336012)(11346002)(316002)(54906003)(446003)(7736002)(63350400001)(14454004)(102836004)(53546011)(6506007)(7696005)(76176011)(186003)(74316002)(26005)(486006)(26826003)(305945005)(33656002)(508600001)(81156014)(8746002)(8936002)(2906002)(52536014)(8676002)(81166006)(66066001)(76130400001)(70586007)(70206006);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR08MB5412;H:64aa7808-outbound-1.mta.getcheckrecipient.com;FPR:;SPF:TempError;LANG:en;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;MX:1;A:1;
X-MS-Office365-Filtering-Correlation-Id-Prvs: 48aa215f-2f7e-41f5-f0e8-08d737654497
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(710020)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:AM0PR08MB5412;
X-Forefront-PRVS: 01583E185C
X-Microsoft-Antispam-Message-Info: 5LQxpOOa8s9sWg/vquL+SedMK//Il/cKBdhEHI5qAAOHPPdkQZKScK5OycjkCJiPRedRky/nzxBUuTu/rBUb2po2U9UaD18sfmHBlaimrMVNsMLsUCCzc1Um1Ah6WHrUoSAO2Pzt2Y+aLiaMqp5QldMNkTXiarDol+VK6R+J8l50drFlhz94BtiD4bR3uaWupNum4DqAGdglUcoRpO9n10Izq8+9dzw2WDBzSoTLygwln5U52vYPl1qxTuPcWl9AigLZSa7xKeVWpRYfV62cx1ZtLUgAO4u6ZwznXoBqSKPoViUyAl5xVWibsC1yxYuO3AtV4y3V5kbDb9xlUfAeRWUQ1dNyxtnurmS7+JHgYW2JueAlFl4MDwsz4/dSFbbZsarRDiyCdqjm2TgS90u122qYccRd/YLtmueS6TQhfn4=
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2019 09:40:47.6543
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9dc2949e-3384-4f1c-4751-08d737654a7f
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB5412
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marc,

> -----Original Message-----
> From: Marc Zyngier <maz@kernel.org>
> Sent: Wednesday, September 11, 2019 7:31 PM
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
> On Wed, 11 Sep 2019 11:06:18 +0100,
> "Jianyong Wu (Arm Technology China)" <Jianyong.Wu@arm.com> wrote:
> >
> > Hi Marc,
> >
> > I think there are three points for the migration issue of ptp_kvm,
> > where a VM using ptp_kvm migrates to a host without ptp_kvm support.
> >
> > First: how does it impact the VM having migrated?
> > I run a VM with ptp_kvm support in guest but not support in host. the
> > ptp0 will return 0 when get time from it which can't pass the check of
> > chrony, then chrony will choose another clocksource.
> > From this point, VM will only get lost in precision of time sync.
>
> "only" is a bit of an understatement. Once the guest has started relying =
on a
> service, it seems rather harsh to pretend this service doesn't exist anym=
ore.
> It could well be that the VM cannot perform its function if the precision=
 is not
> good enough.
>
> The analogy is the Spectre-v2 mitigation, which is implemented as a hyper=
call.
> Nothing will break if you migrate to a host that doesn't support the miti=
gation,
> but the guest will now be unsafe. Is that acceptable? the answer is of co=
urse
> "no".
>
> > Second: how to check the failure of the ptp kvm service when there is
> > no ptp kvm service, hypercall will go into default ops, so we can
> > check the return value which can inform us the failure.
>
> Sure. But that's still an issue. The VM relied on the service, and the se=
rvice
> isn't available anymore.
>
> > Third: how to inform VMM
> > There is ioctl cmd call "KVM_CHECK_EXTENSION" in kvm, which may do
> > that thing. Accordingly, qemu should be offered the support which will
> > block us.  We can try to add this support in kvm but we are not sure
> > the response from qemu side.
>
> It doesn't matter whether QEMU implements that check or . The important
> thing is that we give userspace a way to check this for this, and having =
a
> capability that can be checked against is probably the right thing to do.

Ok, I agree.
Adding a new capability item under "KVM_CHECK_EXTENSION" in kvm for ptp_kvm=
 will do and Using ioctl in userspace can check if the ptp service is avail=
able.
I will append this patch in this patch serial.

Thanks
Jianyong Wu

>
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
