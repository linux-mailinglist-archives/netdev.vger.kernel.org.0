Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51FBF267C10
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 21:37:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725949AbgILThb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Sep 2020 15:37:31 -0400
Received: from mail-dm6nam12on2130.outbound.protection.outlook.com ([40.107.243.130]:5600
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725838AbgILTh2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Sep 2020 15:37:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RzAGZLL6sySKc+ctr8O6tEMHvBByr5kiuIKXpkdMjsvUW7a/yzTty1LuyZG8jUcWbw4Hi7NsePtaSa3LbvUS5SZbFJUR06vPHtbMm/amq3kAs+65xZM0ikn36m/3vnvbt1yWlehi7fsLsvFKHcO/lWStvWQmrVEuBQd49hozZXx/smWzL+mGUzLbH18YhEwOTuNpSHEkiAEkpVhtaQBYECe524PGg1W4mXReljp/NCGUxJWgp9vb3kE8Rtck36i1ipbNEPbo3MAP95wRGR4hZRbrFKR4k7OsFOUYpGa1E+7QV09CjnPc8I3ftIRoE+WLxiwD8/kgUc6HghxdsofDhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fUuLmnzjvI0BG/BQNg39aJHDHOhZ/y0mNkTbYrGxEHg=;
 b=WK1u0dkEEL4OB9BCSaxXmhJ2lMsVbzW94dH56WQF8sF7GXPXnckycvhox3tkTy6t/zoDVRnXX4mDdik1f1KMksqry1NNgG/OqqGP/tcVg8AHmofte909HPV/aXAMHJ5fpW8BlVRo3mDCjFw91yBp0P5ECShJTP9QefjqYn4ZMZtm/F/qbQf3u1lRYO2gbcigmex5FNusrW6O05sfQsCA9QZObTUsPDTJkxo4XAKqK8zD85Kw3aYrLqrcFGp2TpViHYuH7PVHbWEXy5Efd+FMVf0JQZ9n0JGQ263mOlyrH7K9JOwj2wHQOuPB1S8j8R3jH3t/lp69iWQagM0Ht7cpeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fUuLmnzjvI0BG/BQNg39aJHDHOhZ/y0mNkTbYrGxEHg=;
 b=GRuwArJbMIv9CS43Rn0i1puUilLvbDfUpr/7RWJ+8JRrazFX24kmxpFJlB7NE9GS72GiNOqlP3NBvpJNGNciqCSPEd2CpygEMgwSYsNjfRzAbnGk4DsSqmYqRPHBBQkaiI2+RYkhU13qA1sThouGjEcU1PuBWre2F0EoEEtS4bo=
Received: from MW2PR2101MB1052.namprd21.prod.outlook.com (2603:10b6:302:a::16)
 by MWHPR21MB0512.namprd21.prod.outlook.com (2603:10b6:300:df::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.0; Sat, 12 Sep
 2020 19:37:23 +0000
Received: from MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::d00b:3909:23b:83f1]) by MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::d00b:3909:23b:83f1%4]) with mapi id 15.20.3412.001; Sat, 12 Sep 2020
 19:37:23 +0000
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
Subject: RE: [PATCH v3 08/11] Input: hyperv-keyboard: Make ringbuffer at least
 take two pages
Thread-Topic: [PATCH v3 08/11] Input: hyperv-keyboard: Make ringbuffer at
 least take two pages
Thread-Index: AQHWh3+dlnyMvoM7NEmmN9vJRegPWKllaRWQ
Date:   Sat, 12 Sep 2020 19:37:23 +0000
Message-ID: <MW2PR2101MB1052688710B98D8C31191A8DD7250@MW2PR2101MB1052.namprd21.prod.outlook.com>
References: <20200910143455.109293-1-boqun.feng@gmail.com>
 <20200910143455.109293-9-boqun.feng@gmail.com>
In-Reply-To: <20200910143455.109293-9-boqun.feng@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-09-12T19:37:21Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=9320e114-46de-484f-8c0a-dc74b563b882;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=microsoft.com;
x-originating-ip: [24.22.167.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: cc7fc7b2-64d5-4f7b-6d1d-08d8575345d4
x-ms-traffictypediagnostic: MWHPR21MB0512:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <MWHPR21MB05121FFC38C41FD9F3DB05DBD7250@MWHPR21MB0512.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6mKeZ6c9AGgsvazkNOUdoKaC/M/MNV3RebnkBJuR0LOngZTNL+q9xbXCvPhlt8Z4C3890NaqF+3HXqVRLgOXJ0VblJZOf/rswFqoE+jBGXlK8vN3I0MQMYkUVgkJG+9bPmG1lik06C3nwVgKXl+oX4agY7Z4vJM0kOUDgMiWuI6dpcHa2VPxCZKo6Cf/SqaC7pC2YwnJRNKBa6BLtwLeINasx8qxPeJoFRIIYH4hB1RYgigAsZ6RcKQcGOY/KqHZWEheMn8+KNLAt8+OzkRLOrM4UtaNKerHzLGakZGQ/IlSY+qA5MT7GrJ9mGCEuFlUIk1d4Fa5NSSCDamSjAb/ewTO/NNN6rrgfd7NKS9s4Gm4yXJMUAS07qEeXuLQpXCF
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR2101MB1052.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(346002)(39860400002)(396003)(136003)(33656002)(83380400001)(316002)(4326008)(9686003)(10290500003)(2906002)(71200400001)(52536014)(8990500004)(86362001)(66556008)(64756008)(66446008)(66476007)(6506007)(55016002)(4744005)(82960400001)(82950400001)(186003)(5660300002)(8676002)(66946007)(26005)(110136005)(76116006)(478600001)(7696005)(54906003)(7416002)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: YBVPHIG/rXN5IrUafmFcNKQ5BN297poU4NMEPqc7djSj/3SpXk2lb9lk1fu9MJJgE2aVJ8chKWTbd2g92nA75fOb0F5HPYBXIDNZY1MloTuPB3ABM2gY220htodqAT2FN5V3INUoPEokPthbvWtTO1DpMOfus+N5VUaTn1HoS/+6b4H9bRO8qbmVKPEeUMSrXNYtQN/zMs375rjHyZutf8DlNdWSIx+v3pnfx6vHXpYprXMaBp1bckfgT//rhl1v5wO5hieGm55hOWDPKfJh71nU49KpE3d+OWqmA7mn5Meacekuyi+ygUAeVPTsd5PvtjkLPS523pSzPGEHKx7KEjoW0660fo7rMobYKvR5rJp8/kSZsiDIlYClWsWEg7Mh9W2AgPYlWXzJLkPIuSi1vFvETtIpkYsxFugyTPwZTtlbncpVk3V0z6ZpoLLiebLXr1oI/AKgUDlrwR7f8sOjQ6098fkWvIuJQSahEUigB7a6IdziCzlXCPOZVXOHq0R1CSs1eNNMwNz00VtO305zexMWK+jxnfQJ8Xz9Mfl/DRPbx4PxVQ7+JRYB6JAI4SB/z1PjwdhMx0gJ1f8S53CkMmwdBc6qzhpn+HUQnQdJ0PaXWjZBQpINDnteAjILj8Flp9+ViBqVQK+H/HN7C19CsA==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR2101MB1052.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc7fc7b2-64d5-4f7b-6d1d-08d8575345d4
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Sep 2020 19:37:23.5118
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RlF6jN0Qdl8wH7reNYkdvDbXQ/FUCgt/umhO/On+MFd1C2OvxCCWFm42anXfb37L4bMkxEUMai4J+kLU+iepWRMLfJy871JErSmzPH7uer4=
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
>  drivers/input/serio/hyperv-keyboard.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20

Reviewed-by: Michael Kelley <mikelley@microsoft.com>
