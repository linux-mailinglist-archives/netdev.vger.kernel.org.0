Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB593162B24
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 17:55:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbgBRQzP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 11:55:15 -0500
Received: from alln-iport-3.cisco.com ([173.37.142.90]:35606 "EHLO
        alln-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726360AbgBRQzP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 11:55:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=1623; q=dns/txt; s=iport;
  t=1582044914; x=1583254514;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=6skeH2R0SF5MsEVqfBE8eIXA4PVpf7ploWkG9bE6xnQ=;
  b=NWONqOwBtwzbYcmUvU3G3Cnej5gk3MTGIihCkDTaddVYmNvcDtuGamsz
   XEPhdDeDWbp4gbMv5a1RXc9bv4s8BPqMc7GexjPYZTSoUD2qo6Q4MOEZQ
   LlQoVC0ev3l3e8LkPUl5v+zhfAtTGfdixzzqHWJIPIid+wN+iFl56Zms9
   M=;
X-IPAS-Result: =?us-ascii?q?A0DzAACKFkxe/4oNJK1mHQEBAQkBEQUFAYFpBgELAYFTU?=
 =?us-ascii?q?AWBRCAECyoKh1ADinqCX48WiHuBLoEkA1QJAQEBDAEBLQIEAQGEQAKCAyQ2B?=
 =?us-ascii?q?w4CAwEBAQMCAwEBAQEFAQEBAgEFBG2FNwyFZgEBAQECARIoBgEBNwEECwIBC?=
 =?us-ascii?q?A4KCRUQDyMlAgQOBSKFTwMOIAECoi4CgTmIYoIngn8BAQWFPhiCDAmBOAGMI?=
 =?us-ascii?q?xqBQT+EJD6ES4VujVGiPQqCO5ZNKA6bGC2KW4YVmQ4CBAIEBQIOAQEFgVkOJ?=
 =?us-ascii?q?IFYcBWDJ1AYDY4dBwUXXwGCcIpTdIEpjSOBDQGBDwEB?=
IronPort-PHdr: =?us-ascii?q?9a23=3AOwYbOxewGxtzorYfztBzYthIlGMj4e+mNxMJ6p?=
 =?us-ascii?q?chl7NFe7ii+JKnJkHE+PFxlwGQD57D5adCjOzb++D7VGoM7IzJkUhKcYcEFn?=
 =?us-ascii?q?pnwd4TgxRmBceEDUPhK/u/YyU8HclGS1ZN9HCgOk8TE8H7NBWL+C+o4DUfGw?=
 =?us-ascii?q?vyOU9uPuqlRtz0iMK6n6Cq4ZrPbg5UhT27J7RvMBGxqgaXvc4T08NpK706zV?=
 =?us-ascii?q?3CpX4Ad+Nb3ituIk7bkxvn58i29YJulkYYo/878s9cTaj2N781S7BVFnwmNH?=
 =?us-ascii?q?sp/4zm?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="5.70,456,1574121600"; 
   d="scan'208";a="418064968"
Received: from alln-core-5.cisco.com ([173.36.13.138])
  by alln-iport-3.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 18 Feb 2020 16:55:09 +0000
Received: from XCH-RCD-001.cisco.com (xch-rcd-001.cisco.com [173.37.102.11])
        by alln-core-5.cisco.com (8.15.2/8.15.2) with ESMTPS id 01IGt6WS017221
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Tue, 18 Feb 2020 16:55:08 GMT
Received: from xhs-rtp-002.cisco.com (64.101.210.229) by XCH-RCD-001.cisco.com
 (173.37.102.11) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 18 Feb
 2020 10:55:05 -0600
Received: from xhs-aln-002.cisco.com (173.37.135.119) by xhs-rtp-002.cisco.com
 (64.101.210.229) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 18 Feb
 2020 11:55:04 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (173.37.151.57)
 by xhs-aln-002.cisco.com (173.37.135.119) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 18 Feb 2020 10:55:04 -0600
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MIDxhTioCx8aFsOIWpvym3EOEWcmWu+SXbnOd2RqQiI0coWMOrG9+7x3SWIpq7xhXn3hCxz8nRgUf78p5ClQ3KY7ebn9GmCGKnK/Xw7jeIy9HYDuLzfdf4xqfv1PCUlfnoyVqJ1u35auaZD6Q4xzwlRECAeXBkWafJAtNZgldbtv5FyyYQ/WZ30O6yhVfbOsxz/BOl23w+qh2gmzxQoknldVkVtSz35MvW0JRRBMvrKZ2bp/5crRSDqYswki60ffCANcRPp0wnwsGw2zuL/eBr0Op8V+BjXL7imPPHiuvWZml05ZeqwD/1SfIVvCi9B9Th3pNfXnrlb0e4b0y/9j2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6skeH2R0SF5MsEVqfBE8eIXA4PVpf7ploWkG9bE6xnQ=;
 b=Ot6YB1ndptM9TGWJYpMz1y+0dRa+Nh44V1AMIZofv/7JeEqw6cCpVx1SBzfnFm8388yYNPnydqcMbCA3WsPEehEILd5W3WqP11Q0mGqGCpGdMkVHvgbz8qfGA9Wmx62k/YRs0OemUnDRuFMGxjL+BGKBF2RhyMc2Imk0egsK3U/TzWoaOV06DlPfu+O5dE3yblV135OEq03Fhc7O81XWu7a7SddORbhFeFB25YeaAwJ153yz8UwMZBworY40onOFakRcQdIvkCbQolIi+1thDwtv9kKWoJu/wk07hKlVdYGenmT/sEQbEYE2sXKkjBDwoK3wBE4adYZp+LhV5qshtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6skeH2R0SF5MsEVqfBE8eIXA4PVpf7ploWkG9bE6xnQ=;
 b=RVCng7I+TDaJF8kRinkRO6atiFREtKgRv+J7KxYaSmAKUkhgmc/kEFF8yj2NH7H0Nh6hJ9SA+m0fk4Sec34118UiVtnZARnRZ0KzHJ/7GJLDil2dZIdxU6bD1mZ2ajAL32NfqOreGVsjhXw2xO2MGE5b+bggllyPHD6dkUHoCmw=
Received: from BYAPR11MB3205.namprd11.prod.outlook.com (20.177.187.32) by
 BYAPR11MB3045.namprd11.prod.outlook.com (20.177.225.161) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.25; Tue, 18 Feb 2020 16:55:03 +0000
Received: from BYAPR11MB3205.namprd11.prod.outlook.com
 ([fe80::89a6:9355:e6ba:832]) by BYAPR11MB3205.namprd11.prod.outlook.com
 ([fe80::89a6:9355:e6ba:832%7]) with mapi id 15.20.2729.032; Tue, 18 Feb 2020
 16:55:03 +0000
From:   "Daniel Walker (danielwa)" <danielwa@cisco.com>
To:     Evgeniy Polyakov <zbr@ioremap.net>
CC:     David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers: connector: cn_proc: allow limiting certain
 messages
Thread-Topic: [PATCH] drivers: connector: cn_proc: allow limiting certain
 messages
Thread-Index: AQHV5nwq+DdGQHH8Ek2zcI0YYhqOgA==
Date:   Tue, 18 Feb 2020 16:55:03 +0000
Message-ID: <20200218165502.GS24152@zorba>
References: <20200217172551.GL24152@zorba>
 <16818701581961475@iva7-8a22bc446c12.qloud-c.yandex.net>
 <20200217175209.GM24152@zorba>
 <20200217.185235.495219494110132658.davem@davemloft.net>
 <20200218163030.GR24152@zorba>
 <23716871582044372@myt3-4825096bdc88.qloud-c.yandex.net>
In-Reply-To: <23716871582044372@myt3-4825096bdc88.qloud-c.yandex.net>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=danielwa@cisco.com; 
x-originating-ip: [128.107.241.188]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2a592d4b-5ab7-4623-9012-08d7b4934cce
x-ms-traffictypediagnostic: BYAPR11MB3045:
x-microsoft-antispam-prvs: <BYAPR11MB30459182F1A645DBBD2E50A5DD110@BYAPR11MB3045.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 031763BCAF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(7916004)(39860400002)(376002)(396003)(366004)(346002)(136003)(199004)(189003)(9686003)(6512007)(186003)(2906002)(6506007)(316002)(71200400001)(33656002)(76116006)(478600001)(26005)(66946007)(86362001)(54906003)(66446008)(64756008)(8676002)(4326008)(6916009)(81156014)(81166006)(6486002)(66476007)(33716001)(5660300002)(1076003)(66556008)(15650500001)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB3045;H:BYAPR11MB3205.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cisco.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HSs2fr66HIsJ8sUbGoCloKB+yeMI9oW9KASxckDNKkd1GLWXYsS7CbW0m2t/PJ5+VOX1dkqNxuhokjyE0jupi2cuG3MX+4A6QP58vEs9SCDuoESRE2nBnMkg68Kfxxs3+0l/vi+U7v+BnDF7petoxnAn5a8sOJYKjUF+r7hD2o+J5BrraraYqfhwlQsfTaU+Bc3wAfWwewN+LmiaZL78zgFnVHRY+bQuOugbfmbqkLFM9YTvJxzmSn5V1nhxr3JDF+mJ9vW5GyXanQ3lblrZlOTQW7jt02ura1pncDnkjqZn0zozMgpbJCKx3L8ZHm4ixkW0CijJrm8a+OELb63Rl9ZZhARd2gdtKDEgQP8lrJxu03SB23BSg79AMVeOPKIUyUorVoCJh5LBMvpP5AGvljBuxikDhVN0jipeoK7qPKWAMMNWZd2H3Wkb/7yJhvCE
x-ms-exchange-antispam-messagedata: 40h7asDLhuHy1F8oGHnJwjNTh0mYJUSunw9NFqUoxEdpWVo3nrJnM0MGUWYDTCb+zdipgUXeGBFcV18tYAuZxpP+1IgD4ZrV64mIWP2cGfDdL2ZQOeC0UY/WhVNTuvjpcUNyiF2R3fHsi/XWUQKn6w==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <494E756B56439D43B1326EC66FCC3D55@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a592d4b-5ab7-4623-9012-08d7b4934cce
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Feb 2020 16:55:03.5963
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 20fMwpdPRT2S1s1Wj+MsXwKMddP+umsDaj4bE2XmsAqruB8cuNBpFCOM42N2kvSOFtnFWd8GB4t2+8VPUGfdkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3045
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.37.102.11, xch-rcd-001.cisco.com
X-Outbound-Node: alln-core-5.cisco.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 18, 2020 at 07:46:12PM +0300, Evgeniy Polyakov wrote:
> 18.02.2020, 19:30, "Daniel Walker (danielwa)" <danielwa@cisco.com>:
>=20
> > It's multicast and essentially broadcast messages .. So everyone gets e=
very
> > message, and once it's on it's likely it won't be turned off. Given tha=
t, It seems
> > appropriate that the system administrator has control of what messages =
if any
> > are sent, and it should effect all listening for messages.
> >
> > I think I would agree with you if this was unicast, and each listener c=
ould tailor
> > what messages they want to get. However, this interface isn't that, and=
 it would
> > be considerable work to convert to that.
>=20
> Connector has message/channel ids, you can implement this rate limiting s=
cheme per user/socket.

I don't think I know enough about netlink to do this, but looking at it pri=
or to
sending this patch it looked like a fair amount of work.

> This is probably not required if given cn_proc usecase - is it some centr=
al authority
> which needs or doesn't need some messages? If so, it can not be bad to ha=
ve a central switch.
>=20
> But I also heard that container management tools are using this, in this =
case disabling some
> things globally will suddenly break them.

Cisco currently doesn't use this interface at all, the reason is that it's =
too
noisy and we get too many wake-ups. If we did use this interface there woul=
d be
one listener. I would think most embedded use cases would have one listener=
.

Do you know which container management tools are using this ?

Daniel=
