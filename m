Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AC0535D215
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 22:32:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239898AbhDLUas (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 16:30:48 -0400
Received: from mail-mw2nam10on2124.outbound.protection.outlook.com ([40.107.94.124]:7648
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238367AbhDLUar (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 16:30:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bMIgRZXPcYJeQbKEdofVKO96HJETg4wN7/cVdM/E2K7Lu5203VLNygfkeXsokx4+uS+2pNybstXdDYS/btyC2JRUJurEsGq1WMNKrOUJdGNNXRzKsi4+vT80NBlS9jIGL0QyyUJzkfTgxNznHFNCqaWYvwhzb8OWz0uTgjoY+P0eiEnxmoWLID3XyajgpYYa5rMAPXPQssm9ymTxbu+TzY7iIEi2L9ZT7GZJ2FZVOa/JP1nddoe45QjF0sIqbB2Wca+QPb+dtb4uEUg8jNTspXbzgK5MLyyXqwLAP98mfEksA6zkRbS7ntXkScI1kSBxXXz3+zzh7sDSNyJUVsMxlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o8cgHDCOmoEeJaXM1EesibwNghJ5ZdKHXVGm004+5f0=;
 b=OEbxBQ6cuFvcFNpNPLuZ8kPL8wivxICJx0G/v/r9y4Phh+sjC0MwDiM9LACYCygS6372EWFZ0UAmL8OlR0ivLoxcYMCIBZoN7MDa9obBPrmO8t37GJ8awmIOeXczTnWR0OcBIlG1cd0oEM6fBz2RSaRjp5PkgbJe77L8QavVN9Lgm6YW3YjpkCOyxr0cejtoHJDcufXXuSk8EJSd7b+EFkqo9+/j0fvWEW10ME2roMncu5jn8whtLZtxxPM/fAL94AEkgoYBqzY2FcvqCd7jnAdpXbAwaTk673LjwCPSpw0+moCE2ZUlz/1wzW2+YzMj4Xqwner/0u6Z6lYYm6tr5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o8cgHDCOmoEeJaXM1EesibwNghJ5ZdKHXVGm004+5f0=;
 b=Buy2lSXT9wnTFHqxODjqlGQON1nAA7pF/3bgQ2B02iz5ywAImjW/RtJB+MBxTwP0cKSYOtvOdWnnPuxM5vvIJDUuRTMDvZ2ILPucN9Y0qqjVWwa1D1u3nD5xeHSUsZe7mH5F1NkKS+1Sw7oifn/x9d4f9Rza3mNQ07m5OUaaNXI=
Received: from MW2PR2101MB0892.namprd21.prod.outlook.com
 (2603:10b6:302:10::24) by MWHPR21MB0510.namprd21.prod.outlook.com
 (2603:10b6:300:df::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.2; Mon, 12 Apr
 2021 20:30:27 +0000
Received: from MW2PR2101MB0892.namprd21.prod.outlook.com
 ([fe80::5548:cbd8:43cd:aa3d]) by MW2PR2101MB0892.namprd21.prod.outlook.com
 ([fe80::5548:cbd8:43cd:aa3d%6]) with mapi id 15.20.4065.005; Mon, 12 Apr 2021
 20:30:27 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Haiyang Zhang <haiyangz@microsoft.com>,
        Andrew Lunn <andrew@lunn.ch>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Wei Liu <liuwe@microsoft.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "leon@kernel.org" <leon@kernel.org>,
        "bernd@petrovitsch.priv.at" <bernd@petrovitsch.priv.at>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        Shachar Raindel <shacharr@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>
Subject: RE: [PATCH v4 net-next] net: mana: Add a driver for Microsoft Azure
 Network Adapter (MANA)
Thread-Topic: [PATCH v4 net-next] net: mana: Add a driver for Microsoft Azure
 Network Adapter (MANA)
Thread-Index: AQHXL6mpok+TxRuwHk2RzEnwF60u5qqxS9kg
Date:   Mon, 12 Apr 2021 20:30:27 +0000
Message-ID: <MW2PR2101MB089208BBB9DA1AFCCC7229D9BF709@MW2PR2101MB0892.namprd21.prod.outlook.com>
References: <20210412023455.45594-1-decui@microsoft.com>
 <YHQ9wBFbjpRIj45k@lunn.ch>
 <BL0PR2101MB0930AC7E5299EF713821FC76CA709@BL0PR2101MB0930.namprd21.prod.outlook.com>
In-Reply-To: <BL0PR2101MB0930AC7E5299EF713821FC76CA709@BL0PR2101MB0930.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=f9c20ac4-18ce-4841-81fa-9dee29306b51;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-04-12T14:31:36Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: microsoft.com; dkim=none (message not signed)
 header.d=none;microsoft.com; dmarc=none action=none
 header.from=microsoft.com;
x-originating-ip: [2601:600:8b00:6b90:6473:731a:ac25:3e78]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c3e16268-0cdf-46b1-0009-08d8fdf1cef4
x-ms-traffictypediagnostic: MWHPR21MB0510:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR21MB05104219A78F2FE5F2D66D81BF709@MWHPR21MB0510.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: a9ztV/+bukw2roeD/Tiov3PjFGDfKCf4LwrhN8ueQmaYtSI36/ploiTOuvb0cfexSYsv/t8GwMDAmJWXXrjdQ0wnkTFNL5uvbcbu5t4A/GvQb2ItgC8Rq4HbsMeW7g8ZaVnhqJHJgDSmKPTC8gbprsFOoLgcxRhWA7iciALApUZ71lJkgfBOoXNGAQ2ou/4m3cP85nM96TZ91lHk59+7XIHOxZ7D1hjs4EoyLoG79c1oFE+pvT5miH7KkabW66tzGJIfvDaz41QVqn9uYwkvEnU9k/wDyDwkAKb3jXuBvoYGF3gSBtN0m00lMUdGgjDC8OcFnPrFwr4fRe4Rsq2rrXiSvugXFetGLgdf+UIEPwblMwMi0FdUpG6IJp/pT3yO/lB0OMjlyj5ubZiVrkY5Oo4cbEIHxUhbmCf2FdrfzLHBAyhKijmnjlAp4XbQhOdP6NLhaXVK2m/EANCXtMohb0LEZSHv5ChSgEpcGXezXrcpalZoYDvCCG1Sbz0UB0JNOkblOFRqT7O2+aqqaPn6y0sfRRNcAJH2OA0pXachKC5Fudm0oyzotbr9462yTzxkY3uxlFqTHrz6KNudP8g1jdhoK6+TMJYEucbl/qec/Og=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR2101MB0892.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(346002)(376002)(39860400002)(396003)(47530400004)(82950400001)(478600001)(10290500003)(186003)(76116006)(52536014)(6506007)(83380400001)(4326008)(55016002)(7696005)(33656002)(86362001)(64756008)(316002)(38100700002)(66476007)(66446008)(110136005)(66556008)(8990500004)(71200400001)(8676002)(54906003)(66946007)(9686003)(5660300002)(8936002)(2906002)(7416002)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?6raczCMQ47UrAMZ4iKx+uGrazx0A3OUMEZtBucLhfMP3lEp61g2k47Cz3P0K?=
 =?us-ascii?Q?H3S84p8SVa/pfJpOQcQeX5Y7ktZFATMMvrlCheiejFxNLpiCqKXWkZBu1GlX?=
 =?us-ascii?Q?2c7YbRjLE06akPVCjr/KUeOwjyOXExwsjcMFGRAxo5f6Iot2aKr3GzGdtukk?=
 =?us-ascii?Q?25r9qdTZB5yTlbsie7I8LRMq/FbspF0bxfWdkAOLyp1VOPDqIBg4JyoQ6WgE?=
 =?us-ascii?Q?VBU2j+MPwOtRT3J4nb1KZ/jQA4wbYtYzoWY0rPvOj5pxC3tiKNbp980iVLlQ?=
 =?us-ascii?Q?A1wo1VBiFKEDA1CNV+DVSefWDZheyjzQwT43uv+LCZ2eZrDRfj5S56zGl071?=
 =?us-ascii?Q?mDWUM3pdenC4pqkwKFoBZnI8V4Zi60/iiI2Tg6lpmEXe2GTXwrqHP3S5pJ64?=
 =?us-ascii?Q?jkmkHqiAgpeoqZX7451mMd5vRu6O3ZK6l1gWtDganIzgMpDXvmsUVYeyPh89?=
 =?us-ascii?Q?v/7MfNvr0B3b6Yqbv3CkSu3tp5XFqx0XK9BVoQb8vXQ9C2j1ShVqNSBGj0k8?=
 =?us-ascii?Q?eFNJahoJnlc8WDROs0FTueNsAa+gJm9uziY1u5qfiT3gAGkPpn0Eg6dJC575?=
 =?us-ascii?Q?3w8mkUkyWISCrd/ei/QuHuRY//GN9v6KK7y1ZxS0LhKeGZq1lPSTpcdJwl6V?=
 =?us-ascii?Q?cYBhQ6C2UnFs+25ywCcdioGWdVqxhtPuf7VjJIMJV3unFlPRWJDgiUnG1ENB?=
 =?us-ascii?Q?8CCrNKCg05TAjZfqPgSbW3uwM4nvPA96fX478khCxDwzmHJtAoAOg92OXCjc?=
 =?us-ascii?Q?kEwD0PgwivGA6OlTxPR62z5puaHYeFAE6Fly8+L7ytxUz2wx2yfzTvk9Pp2w?=
 =?us-ascii?Q?FS82Q1lsJQ6FR7GG21xPJbwQcZUAN1g1CipnX7XCGKZN7ip8Wl0ISURhUbne?=
 =?us-ascii?Q?1dDBxVO73J/Cwxzed2lhiiv2uEfKDZ8EwhcD3250+Jh6QpKZ70tvb5XPvsjm?=
 =?us-ascii?Q?dOut37XznJ/x6sYCeiyba+BEXvQvLceK8D1WdMdpwWIJWPjsZB+8YTSAsefq?=
 =?us-ascii?Q?rCM6OY9FfOFkgBgm/NjK0jy165PnQ+ivf/+L+V9+5Nd9145Mor0ysd2qjk1E?=
 =?us-ascii?Q?IuGuEyomzosl3aj0BIpEF4kTs22XilXqMFpi2xS+ctfuYCUffe952tFOEDbO?=
 =?us-ascii?Q?LWQ2pS+VSOklDNegy0iSvraflU9QT2CttXwxJQXyQS6MrjKcNgEsodVaaS7W?=
 =?us-ascii?Q?bwlaDE4EwF2Y4/pXZWbxi7a6x4vmYUDlq3Ma+an0DHpRbjn7ss4cVNyJOjas?=
 =?us-ascii?Q?uT2ImKvgCs9EyIgi82Z3DsSNVI+iZv0FFwciULMQTrCsCQwHMWxj0VxN0NaD?=
 =?us-ascii?Q?CkEWFFZklBBYn/uw6G8t4z3csDVRjJY9c/7FVT/0a/NmANfXNlvEsXV+5Md/?=
 =?us-ascii?Q?egUqtm/UHOzSCVEzJ/T1/OuHf+20?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR2101MB0892.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3e16268-0cdf-46b1-0009-08d8fdf1cef4
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Apr 2021 20:30:27.2818
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: M5hOkf9JgiieK3LZGhk6rDO9atMbuK0FF8dBVYJTUenth00FYoGRFmb03hoL8oipEEbDiqFe5c8jBWUUCz8iNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR21MB0510
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Haiyang Zhang <haiyangz@microsoft.com>
> Sent: Monday, April 12, 2021 7:40 AM
> > From: Andrew Lunn <andrew@lunn.ch>
> > Sent: Monday, April 12, 2021 8:32 AM
> > > ...
> > > +	/* At most num_online_cpus() + 1 interrupts are used. */
> > > +	msix_index =3D queue->eq.msix_index;
> > > +	if (WARN_ON(msix_index > num_online_cpus()))
> > > +		return;
> >
> > Do you handle hot{un}plug of CPUs?
> We don't have hot{un}plug of CPU feature yet.

Hyper-V doesn't support vCPU hot plug/unplug for VMs running on it,
but potentially the VM is able to offline and online its virtual CPUs,
though this is not a typical usage at all in production system (to offline
a vCPU, the VM also needs to unbind all the para-virtualized devices'
vmbus channels from that vCPU, which is kind of undoable in a VM
that has less than about 32 vCPUs, because typically all the vCPUs are
bound to one of the vmbus channels of the NetVSC device(s) and
StorVSC device(s), and can't be (easily) unbound.

So I think the driver does need to handle cpu online/offlining properly,
but I think we can do that in some future patch, because IMO that would
need more careful consideration. IMO here the WARN_ON() is good as
it at least lets us know something unexpected (if any) happens.

> > > +static void mana_hwc_init_event_handler(void *ctx, struct gdma_queue
> > *q_self,
> > > +					struct gdma_event *event)
> > > +{
> > > +	struct hw_channel_context *hwc =3D ctx;
> > > +	struct gdma_dev *gd =3D hwc->gdma_dev;
> > > +	union hwc_init_type_data type_data;
> > > +	union hwc_init_eq_id_db eq_db;
> > > +	u32 type, val;
> > > +
> > > +	switch (event->type) {
> > > +	case GDMA_EQE_HWC_INIT_EQ_ID_DB:
> > > +		eq_db.as_uint32 =3D event->details[0];
> > > +		hwc->cq->gdma_eq->id =3D eq_db.eq_id;
> > > +		gd->doorbell =3D eq_db.doorbell;
> > > +		break;
> > > +
> > > +	case GDMA_EQE_HWC_INIT_DATA:
> > > +
> > > +		type_data.as_uint32 =3D event->details[0];
> > > +
> > > +	case GDMA_EQE_HWC_INIT_DONE:
> > > +		complete(&hwc->hwc_init_eqe_comp);
> > > +		break;
> >
> > ...
> >
> > > +	default:
> > > +		WARN_ON(1);
> > > +		break;
> > > +	}
> >
> > Are these events from the firmware? If you have newer firmware with an
> > older driver, are you going to spam the kernel log with WARN_ON dumps?
> For protocol version mismatch, the host and guest will either negotiate t=
he
> highest common version, or fail to probe. So this kind of warnings are no=
t
> expected.

I agree, but I think we'd better remove the WARN_ON(1), which was mainly
for debugging purposem, and was added just in case.

Thanks,
Dexuan
