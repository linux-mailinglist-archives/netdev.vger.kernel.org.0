Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCDCC15BBAF
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 10:29:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729657AbgBMJ3f convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 13 Feb 2020 04:29:35 -0500
Received: from m4a0073g.houston.softwaregrp.com ([15.124.2.131]:48444 "EHLO
        m4a0073g.houston.softwaregrp.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729636AbgBMJ3e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Feb 2020 04:29:34 -0500
Received: FROM m4a0073g.houston.softwaregrp.com (15.120.17.146) BY m4a0073g.houston.softwaregrp.com WITH ESMTP;
 Thu, 13 Feb 2020 09:27:17 +0000
Received: from M4W0334.microfocus.com (2002:f78:1192::f78:1192) by
 M4W0334.microfocus.com (2002:f78:1192::f78:1192) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10; Thu, 13 Feb 2020 09:19:01 +0000
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (15.124.8.11) by
 M4W0334.microfocus.com (15.120.17.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10 via Frontend Transport; Thu, 13 Feb 2020 09:19:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hFbnatmROmxA2R1pdC6Hkgnb7/S0ECZsQiuMN1C5KWASTvh8uDT+uqeTo+Vn+3YO9Z/oXOI+44IiFJUnRRjVmMDHjdfFxfgK+Ltp2dflxFfV3H/5e4ARh3yzH9e0FXtQzKJYigKxo3v0NINQDEwEofbMdPpSv4Wk9RIf/K9Y8ZWVgrDUjlRk1A3kCLIsF8NwvlukLJCciE1pxs2V1P1q9Na00bV7/4gXgpZq4xb7XvYj7/WZm5uT7ljhESCvKFTRGZ3MyAOWOpwlSh5E2GGKihwAB2pzsFOd6G6UEnNhuAYgrAI6gfW6sOygRx7sCUNuH9kebM0loPkpFHu4jXan7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tiyzJvQc1tCyA7OBK0thFTgRNeY452iy2o6s7wZVB/Q=;
 b=jr2HB8CJIFhRgAghuhXVJeptvJJKTSmt70rRwM1Qe3BnV+Gf86MICrYXEeEwICrwHM/VgbnfwC/xGu15i4OIlJaTgCkslrnthVCb5FkoFOofvSusPaqJUSftQ/LRJ18IHTK+Iz5GeMmlQDLe6EvN87apuWQOuZ53lvYgNW+8yznh3HJE2/a5IjteU6QxJYqgJ2q590ymGeXYKQlMGqOiVV07wevpQisBXxD+05+MPmQoLM2gRhFMwshtqKizKjalWleeCmjltgl80qxCv261O1nNscUl5CA/rCm7WV6s6oeYRudY0NACXdyU3NuUqjwL2oRswPmmKMXuytud/VhJIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Received: from BY5PR18MB3187.namprd18.prod.outlook.com (10.255.139.221) by
 BY5PR18MB3395.namprd18.prod.outlook.com (10.255.139.96) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.22; Thu, 13 Feb 2020 09:19:01 +0000
Received: from BY5PR18MB3187.namprd18.prod.outlook.com
 ([fe80::c1f6:c296:bddf:20e4]) by BY5PR18MB3187.namprd18.prod.outlook.com
 ([fe80::c1f6:c296:bddf:20e4%4]) with mapi id 15.20.2707.030; Thu, 13 Feb 2020
 09:19:00 +0000
From:   Firo Yang <firo.yang@suse.com>
To:     David Miller <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "pkaustub@cisco.com" <pkaustub@cisco.com>,
        "_govind@gmx.com" <_govind@gmx.com>,
        "benve@cisco.com" <benve@cisco.com>,
        "firogm@gmail.com" <firogm@gmail.com>
Subject: Re: [PATCH 1/1] enic: prevent waking up stopped tx queues over
 watchdog reset
Thread-Topic: [PATCH 1/1] enic: prevent waking up stopped tx queues over
 watchdog reset
Thread-Index: AQHV4WKkvGCh+ZzoDU+6Zqjup33oe6gX1TkAgAEB9no=
Date:   Thu, 13 Feb 2020 09:19:00 +0000
Message-ID: <BY5PR18MB3187AD3190CB6C1E20BA84C2881A0@BY5PR18MB3187.namprd18.prod.outlook.com>
References: <20200212050917.848742-1-firo.yang@suse.com>,<20200212.094356.734697556409905980.davem@davemloft.net>
In-Reply-To: <20200212.094356.734697556409905980.davem@davemloft.net>
Accept-Language: en-US, en-GB, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=firo.yang@suse.com; 
x-originating-ip: [113.226.141.151]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9b6a4336-2c3a-4cb9-39bc-08d7b065c314
x-ms-traffictypediagnostic: BY5PR18MB3395:
x-microsoft-antispam-prvs: <BY5PR18MB3395E5BBC2ED41896487B391881A0@BY5PR18MB3395.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 031257FE13
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(376002)(396003)(136003)(39860400002)(346002)(199004)(189003)(81166006)(81156014)(8676002)(8936002)(44832011)(6506007)(26005)(86362001)(186003)(7696005)(558084003)(316002)(54906003)(33656002)(9686003)(5660300002)(52536014)(6916009)(478600001)(55016002)(4326008)(2906002)(76116006)(66946007)(71200400001)(91956017)(64756008)(66556008)(66476007)(66446008);DIR:OUT;SFP:1102;SCL:1;SRVR:BY5PR18MB3395;H:BY5PR18MB3187.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: suse.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vdOp/wza/jFQUsFDz4l7TKZ/vZ1fVG4MmbbNDl75nF3eGSYIKmniKnNxaXF5B9tUGInXG413EPwE1jhWhDv75V779RaNHcq9KfRXLP4ebLkzjodIIT76AvN/Q9sfchpRlPtLWtl9YqlFMvX45ag8UJfq4dKZsnc1OsoyXfUTJGpLmbv5Jfr2yBCMKTU9q4UVkKswKyoiIW4FxxG1XMln2osRMQwoiYFPB30tVuaW/cntv1LodvQSCDRmM8h+NqCDybPQrsqr6Xm41PIUg2hix4QlNQtkCrnNYizlO/6bE/IUoeVrRyK7p1fvnrd0tu4ZQMzOFctCpSsTkZVWtGDkEtZbZXS2r9YhYI1Ka24O6gwjzhER3mMrK0z8hipAhDrgbt+JWljVLZ7j15ccc/KV+WJ/sq7imfzeHhKVyRwpS/xg1kefSSZuMu5tblYsh4LN
x-ms-exchange-antispam-messagedata: x/pvl+5S0vhJKS0eIO6SPQGQo9VjjKgdlWx7VtJp5TR5fKAPZW78OGJncG57Y7Yyfib43hcviDuo3cumAFd92865aGM8zYPve9Hl51Elhi64C4oxoOK7pamJBGT/JqNAm7vf3gzWjcfF+ejZI5KGRA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b6a4336-2c3a-4cb9-39bc-08d7b065c314
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Feb 2020 09:19:00.5223
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 856b813c-16e5-49a5-85ec-6f081e13b527
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qOI/OayMN4UfK4IG+ZURN4co57MCrEPwfoJ2eMt5jl3+2NvKFq5+xt/olkNWePdv2HLBwQyD3ni07kznh7yXzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR18MB3395
X-OriginatorOrg: suse.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Applied and queued up for -stable, thanks.

Hi David,

Sorry. I forgot to add 'Fixes:' tag.  Is it possible to 
add the following Fixes tag to this patch in your repo?

Fixes: 4cfe878537ce ("enic: do tx cleanup in napi poll")

Thanks,
Firo
