Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB19D1BECD6
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 02:06:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727109AbgD3AGM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 20:06:12 -0400
Received: from mail-eopbgr760137.outbound.protection.outlook.com ([40.107.76.137]:17734
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726481AbgD3AGL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Apr 2020 20:06:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TH9OIkQILnFepIOBi34HwDTwnpeSR9pbCz6G9Lfe1fgQdeDjlfpaWs8vi7xVCCT0kHRvqkkPyCMaGNkz6Gi2eQGEkx79ydk+QDr5CRaXvQV+/VhJqDjjf+1Y8R+Wj7U5J1QTl+ZwWAbR+0b3zSrvz/3S3V06XIhKDUY5iqnF3IV2w2PsARN0d3r9NHRTW1Px0J78BUzvwKCm16t1cSXcIfMCSECjwM5vF/J/XmFUS7u69sozvNKZE4PwKP5N2WzgI3DA+awxeSTJrSSaxLyXCBr42hjEEwAdte/yqWhXVMujxs6guwaV+bvnmKQCM7mhC4Oylymjpa2Q7R/TtfCrjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ctpjImKYcbtW+n3GN8WP80+T5+SaBnVtH9iDhiUEIEw=;
 b=PU8ddetmOAOI6xZtNEa6PN1vBdy4KQ25w2VjTRowgrsl8AXcKDyxE5auH0SejqLBK68VNa8NI+TvLnId2NADha+2FCtNCmRnt5/tfxGv0acwJsuKoyi5cbMNacHyw9QUzC2yqjbLR9fJ+k7xPRyOLxPc7sNIWXnY0qXqHp/NM8VdtIJ9JZPwapoLequXDsaovGZLyCTh/VoTnp6Hd4FHXegLPk6KbsvUxXxMAz4C5ftFcte7cgys46xyYkP0UpV0Wi9D8dmrfq0wl2L+xIAEX3rHkLnPBnsgs2UF8C2PHOv08DSivi3XytiX1aBi8Vuut4kIZOWkhWlhzhVuOI3Oyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ctpjImKYcbtW+n3GN8WP80+T5+SaBnVtH9iDhiUEIEw=;
 b=B+QTyIAYFKH1JRArDx+uiqcnJwNm7xvr3uMtZ2JzmYmtF2FssDS4m2KA4huieOYPwxx8yhihhiMfmIXLxiWM/7Y4w6XpBHabxPkmuHiafgALK99XsWCEcgW/QhvHEyg3nsB0eZWqlRiOnw7qurYIBMHPWk1KdgpaoeYuJEdl5l8=
Received: from MW2PR2101MB1052.namprd21.prod.outlook.com (2603:10b6:302:a::16)
 by MW2PR2101MB1065.namprd21.prod.outlook.com (2603:10b6:302:a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.4; Thu, 30 Apr
 2020 00:06:09 +0000
Received: from MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::5a3:a5e0:1e3c:e950]) by MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::5a3:a5e0:1e3c:e950%5]) with mapi id 15.20.2979.013; Thu, 30 Apr 2020
 00:06:09 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     Nathan Chancellor <natechancellor@gmail.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "clang-built-linux@googlegroups.com" 
        <clang-built-linux@googlegroups.com>,
        Sami Tolvanen <samitolvanen@google.com>
Subject: RE: [PATCH v2] hv_netvsc: Fix netvsc_start_xmit's return type
Thread-Topic: [PATCH v2] hv_netvsc: Fix netvsc_start_xmit's return type
Thread-Index: AQHWHYZG1Nlm2xaz8EKxX/yhRvOanaiQyLNQ
Date:   Thu, 30 Apr 2020 00:06:09 +0000
Message-ID: <MW2PR2101MB10522D4D5EBAB469FE5B4D8BD7AA0@MW2PR2101MB1052.namprd21.prod.outlook.com>
References: <20200428100828.aslw3pn5nhwtlsnt@liuwe-devbox-debian-v2.j3c5onc20sse1dnehy4noqpfcg.zx.internal.cloudapp.net>
 <20200428175455.2109973-1-natechancellor@gmail.com>
In-Reply-To: <20200428175455.2109973-1-natechancellor@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=mikelley@ntdev.microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-04-30T00:06:07.5267853Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=6e5aa217-5279-40b8-8e26-8f27ea312146;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=microsoft.com;
x-originating-ip: [24.22.167.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 2e8663b2-a869-47b1-226b-08d7ec9a4953
x-ms-traffictypediagnostic: MW2PR2101MB1065:|MW2PR2101MB1065:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW2PR2101MB1065C0D8F420157828B300F3D7AA0@MW2PR2101MB1065.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:972;
x-forefront-prvs: 0389EDA07F
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vqsn6jd4vEJyUYKF00+K8zDFSvvXhowo4Edfrepk43qrnZIYkX00StAUQmha3khIJ+7xo1+JnOD1Uxlgvl7OlBoY59Gz4TUrsLEtUExtIlOhAw/vmdoWIqYicRtNulkje5xtC1kEX/gSDsfY0HiSqkTdUh9J0ZdL43JIZnojkbQEFlxPYSJgWeZ8vApHp3ClOhEW/h4f7aJCK6mhJld9SAB8vczi0FSCzcONhagof2ruvOO5DThODbCwk4dVsH0b1qGkI4DQKVRQZ1Hz4Pz88ZWyI24vVgBA3zcm77ixaQBlAnCXt9ksx+Zgl+XqZB6/DKs6C/GJwTetv6ENHVe/LIL79LtJcz9PEqR70+THcasAfu5rsEk+ciDlJ0bj+eWFX9ewJRNdRQjfW1CIGK0nzAKuJb5UBmufRLfc9Q123TgY6gX+70Oia2ncTdhMS/Bl
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR2101MB1052.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(366004)(376002)(136003)(39860400002)(346002)(316002)(8990500004)(2906002)(52536014)(55016002)(5660300002)(9686003)(71200400001)(33656002)(7696005)(10290500003)(8676002)(76116006)(54906003)(110136005)(26005)(478600001)(186003)(66946007)(4326008)(66556008)(66446008)(66476007)(82960400001)(6506007)(82950400001)(64756008)(86362001)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: gqebTXqY34CfjHtu+sj9zxo+dKGO8yH254f2R8+fJZ+FScGNZt8VEHt4sNtwGXnW15i++fjS2gPuitBnzHIx4ce8ljw4x0iu/PP/3z1aVZ/4nM7yYXES/5JBzwkOxSi1YkezfvBh4CY96G0ibJYwl5a+ZTizKyXmwt9yFI3M63werfcQl2HWjbZ3C6t4E1w9f7oNpzerFCtz2Li6BXlqGOVwRvc6ykWUCCc5ZbOQUG+n3TuyUG8+76wOmJCdFNBsaQJl3uJdCjjmFTr1NQTVGp1814vIV2xPcsaOcdfryE0ub6bCxFzMG9DnxuLMN4SdDcyWs/vB4CqNt12/dQjL4IZqNrIkoBQEvMl+6cBnGny9e6XN+co5NQptm3E4sLWxcNHLmB29QlHPDP0IbRLQSIa6RRxzejT/2162FiCjXQH3yfBqHDepFl8ptFgBfV1Loumyfbwxhz6jIX33+8t2NYXeqkIfJ2a7ICPNi81CjbsgkluudGFkpYwwhNQT0u0WR1NVPzS3pOyt41ISAwLlO6Y7jM5MuDz21ZO88DwKcGvftaDPhzTLSHO1ga0IVCATBdeMyiu4qXD0eB38mJ4M/2FJhfhXrQ+onBlQ+vUWH4OfCh3B/2QFqXwTmG2U5OBiJh0r77mrPDnd4jy66QUp3XIbjX8ind33YFbzUMNraAlEQ1yiqrc6n1aYDooZynd4eVrdABFJr2a9sWtqxy9uerU/plZixw5aQHqzkJkDLkAdla8WGlB15zMIaf3sGJfraHEtJy39/cRrFjenuqpZd9UIbU8ZgyVfwg57IR/AhQ8=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e8663b2-a869-47b1-226b-08d7ec9a4953
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Apr 2020 00:06:09.3509
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LWB3v8/CKqkxXyCynlfo+mT3SbGthOnxRfo3U+XNiuBt7kVwA3bP0eSprxKsHshZorniVTK+6oVl8ScPeC2998ik5BGbLkbrIEWErvchRH4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR2101MB1065
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com> Sent: Tuesday, April 28,=
 2020 10:55 AM
>=20
> Do note that netvsc_xmit still returns int because netvsc_xmit has a
> potential return from netvsc_vf_xmit, which does not return netdev_tx_t
> because of the call to dev_queue_xmit.
>=20
> I am not sure if that is an oversight that was introduced by
> commit 0c195567a8f6e ("netvsc: transparent VF management") or if
> everything works properly as it is now.
>=20
> My patch is purely concerned with making the definition match the
> prototype so it should be NFC aside from avoiding the CFI panic.
>=20

While it probably works correctly now, I'm not too keen on just
changing the return type for netvsc_start_xmit() and assuming the
'int' that is returned from netvsc_xmit() will be correctly mapped to
the netdev_tx_t enum type.  While that mapping probably happens
correctly at the moment, this really should have a more holistic fix.

Nathan -- are you willing to look at doing the more holistic fix?  Or
should we see about asking Haiyang Zhang to do it?

Michael
