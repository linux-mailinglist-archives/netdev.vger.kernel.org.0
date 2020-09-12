Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD9E0267C15
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 21:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725961AbgILTii (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Sep 2020 15:38:38 -0400
Received: from mail-dm6nam12on2116.outbound.protection.outlook.com ([40.107.243.116]:8028
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725880AbgILTid (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Sep 2020 15:38:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lca1lVMbCWfsMbumWPVcoRjNHRMNaglSTvY+EjkivbePqK4n3BcR3d/IClDesB54/i5b6IRU1y32hdZOMKnUGQIL0PEk7Rz2RG56kKdfvePahzNhKjcNLW7OZd+o1Q0x7Hf9n+RfqAa3vgmAIdQ8u3Ln2bgqGGT0r7mMFplrUw8pnBhD0bbCne1v1FoXaFeWXL5TSvA8kIk2CsUO+snrsKEures1G+fLvhrfFyHp6EUdL/0yq/xpcUjO69kHpVeM0M6SAS4aJ9SEyw8qvF4UK0jmmlx81dSWEav4BVm+IGRmV/xAyAfjksyLs7mu0/CWCqgoqDYX9mdHPySpBdGc6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SrdrjvLwvCqaCh37M/cNumF4lvknpC+pbkVdcdM45Zg=;
 b=XJDvy90jj+0XWvEpur/ybB1SLpft1nXLSUnJ1jrpkAOW3NsWgZBHV46Nvd6dEpVzLhGJPROyaYgA+m+5/217NhSBmRO+W39zg/crJp7f6ouM6uCYq4GUIaVFviUw0tKD7uAS3I+BhBigRKXiL/b7gAT9tuHf5PPmlqSajZIBIEJoXz8cbqmpeGdvZEK8LW3Jdd3UDmFf6P2OYjrF0m45DYiGwtnw1+sXABM4GCYSRvEqaY0a0jEJKsG9SXpmXQL0KPNC5KFHT0uvMk2q1RRsKFVpemP/dpBeSVPLkiRBBMkpaMrDqm3ZGK0TrT8c8CFZ7RvCOSOuhxGMds0EdaVUBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SrdrjvLwvCqaCh37M/cNumF4lvknpC+pbkVdcdM45Zg=;
 b=jUbEHk/CiKa+7DRbVq8tDJlI2bbzOOiWUhfpGd4Z0Bq8kW/zqDMrapFpmu6hTdzO0blx1J3EeB3UYDgJv9RDtCMiYGTf7sAyTvcwZbqbugxxKLWXSlPWk75WBfelqa330RzfZ74u99cChPe6ZW5dqKFG5HA93B8qx6lDel25tl8=
Received: from MW2PR2101MB1052.namprd21.prod.outlook.com (2603:10b6:302:a::16)
 by MWHPR21MB0512.namprd21.prod.outlook.com (2603:10b6:300:df::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.0; Sat, 12 Sep
 2020 19:38:30 +0000
Received: from MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::d00b:3909:23b:83f1]) by MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::d00b:3909:23b:83f1%4]) with mapi id 15.20.3412.001; Sat, 12 Sep 2020
 19:38:30 +0000
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
        "maz@kernel.org" <maz@kernel.org>, Jiri Kosina <jkosina@suse.cz>
Subject: RE: [PATCH v3 09/11] HID: hyperv: Make ringbuffer at least take two
 pages
Thread-Topic: [PATCH v3 09/11] HID: hyperv: Make ringbuffer at least take two
 pages
Thread-Index: AQHWh3+f/4bg/Indg0e/CaDSEiSWnKllaUlA
Date:   Sat, 12 Sep 2020 19:38:29 +0000
Message-ID: <MW2PR2101MB105240A1A966F42DCF9B5724D7250@MW2PR2101MB1052.namprd21.prod.outlook.com>
References: <20200910143455.109293-1-boqun.feng@gmail.com>
 <20200910143455.109293-10-boqun.feng@gmail.com>
In-Reply-To: <20200910143455.109293-10-boqun.feng@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-09-12T19:38:27Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=5368a405-9e94-4d8c-a324-51ddca67ee94;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=microsoft.com;
x-originating-ip: [24.22.167.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c1575123-ba6e-43fd-9208-08d857536d4b
x-ms-traffictypediagnostic: MWHPR21MB0512:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <MWHPR21MB051224C214B7119FB20A161BD7250@MWHPR21MB0512.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sfbXxbwvW7w6r/uacq8tAIgViUW5CQKWnU667s/dKu5dw+Kz2lra3dSYCb9aU18NEuk9gBSKwBFxujKXLPhXniygsgLHJcoepx0K3Bw0NzkZ3DQU2Vi4tt0R9j3mjqkLUUOu+t3uIKDx4I/kJ9NxYKaMlIuzodlMGgzVyd2iCtwrbZ10+pY89DSiqiUyueKtstsUrtKSiSflSsQHl9/BUj62tDDAeKNjpqlxyrdDbuhH/HWkNPPoXVJbNXqYz+scKrkB/414gtAQqbINcnIHtOjg5o0n+rXiKwTXOM7uF5GljgVdsDCYPkB/tMFps35+GSOqgRZLdlBc6cfJRgMo8Md8MNFVCILNHJ953zV26lRX969/YlTK5NxmUzezHzMh
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR2101MB1052.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(346002)(39860400002)(396003)(136003)(33656002)(83380400001)(316002)(4326008)(9686003)(10290500003)(2906002)(71200400001)(52536014)(8990500004)(86362001)(66556008)(64756008)(66446008)(66476007)(6506007)(55016002)(4744005)(82960400001)(82950400001)(186003)(5660300002)(8676002)(66946007)(26005)(110136005)(76116006)(478600001)(7696005)(54906003)(7416002)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: mhzp1E+e5eujuVAeQyY66vh57AESWzEkgbTMqVkIvOhwAUSqZMouqeHTf+hBdQ77NG87HG2B9CMwcm+wlPGUzSlbVIlLHR7IF0YsZHzyflLczdukMjtzeCnyd8kST1JU2D69p30uvw98DYYHieEE46LvWRU9AZUkzigLxkf8BU1Q3/RI6Uqu5q4nN3XHCrOOoXgYnVSh7kdbv1ierxkHOI26vnDnqYaUkzHvs7h43QV4HmyFZfav+zrb+j2CGM8OF1XHs2fLTYYzzoONQDCCeL0XuK21lx7cGXHgXJKpuTFuvCdD9T9WVs1faRpRarGx37E7Dd3DPF41N1J4WMqXZ0WwVUB/bE3Osd2vJqe/Zw5uWGrH0hf40FWKQchg/fbxo2z81QyR/r2xQDdHGaz49HkHySLkLxv1ydoeXAFX2iTuXl4vAr8y5Acf0MbsHVSZPTc6GIW0DY+An6OUGHwoGA/ppPVmAmK+USJRNdl7j50tlr+e/onSbv9BqwwtPXCOwql6MzpexaMN9OHK3tF1FPaVlnzH0W/DW+yB70tI5nY7xzQ5r/duRmXtep+8mHUOJHn/2oUB1qJHmZs5b2RaluRVgyN895E8lKsFO0Vey7VLB7WXv2rKKCsEPNr90EyPXJxqjeMGH5qOs+b/2c6iDg==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR2101MB1052.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1575123-ba6e-43fd-9208-08d857536d4b
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Sep 2020 19:38:29.6388
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sVvf0g4SPz/yGnZaTbsJnwF4AelPiHHIpoyQyI9N/Y1Ru9VIst7p/NtmfOjTl2tjJiZ0xIQ5UYLySGHP076AyPzNqfaeTANgyj0b0Uwh5ho=
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
> Acked-by: Jiri Kosina <jkosina@suse.cz>
> ---
> Hi Jiri,
>=20
> Thanks for your acked-by. I make a small change in this version (casting
> 2 * PAGE_SIZE into int to avoid compiler warnings), and it make no
> functional change. If the change is inappropriate, please let me know.
>=20
>  drivers/hid/hid-hyperv.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20

Reviewed-by:  Michael Kelley <mikelley@microsoft.com>
