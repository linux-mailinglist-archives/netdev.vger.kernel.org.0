Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74C811797DC
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 19:28:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388281AbgCDS2H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 13:28:07 -0500
Received: from alln-iport-4.cisco.com ([173.37.142.91]:25901 "EHLO
        alln-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388203AbgCDS2H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 13:28:07 -0500
X-Greylist: delayed 426 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Mar 2020 13:28:05 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=599; q=dns/txt; s=iport;
  t=1583346485; x=1584556085;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=6D+5zK9Ir5X2JtzignUf3U164lli3KCKnQ+PlqpXb+w=;
  b=A8yiRrpwrmtdt161JkLfU+O4B4JP5MHsfNWCYixwdwJfoaV8UxHsJE0Q
   fMJzIkB4OAnpRZCLpiXC0O0WhmJtzkixl+bOgTExvhBWghCavJGfaiGsY
   fysCQousQ1NY7LLJshYb9VwlVnk3mjHh4xCDzEqXJNtsVaKJekhPhSW9y
   8=;
IronPort-PHdr: =?us-ascii?q?9a23=3AD6iCxx8/HPnwzv9uRHGN82YQeigqvan1NQcJ65?=
 =?us-ascii?q?0hzqhDabmn44+/bB7E/fs4iljPUM2b8P9Ch+fM+4HYEW0bqdfk0jgZdYBUER?=
 =?us-ascii?q?oMiMEYhQslVcSID1P2BPXrdCc9Ws9FUQwt8g=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0BKAABq8F9e/5pdJa1mHAEBAQEBBwE?=
 =?us-ascii?q?BEQEEBAEBgWcHAQELAYFTUAWBRCAECyqHWwOEWoYQgl+YFYEugSQDVAkBAQE?=
 =?us-ascii?q?MAQEtAgQBAYRDAoIBJDQJDgIDAQELAQEFAQEBAgEFBG2FVgyFYwEBAQEDEig?=
 =?us-ascii?q?GAQE3AQsEAgEIDgMEAQEfEDIdCAIEAQ0FCBqFTwMuAaJ+AoE5iGKCJ4J/AQE?=
 =?us-ascii?q?FhR0YggwJgTgBjCYaggCBWIJNPoIbgjKDQYIssCAKgjyXAoI5mHgZAYQnFYo?=
 =?us-ascii?q?cm0sCBAIEBQIOAQEFgVI5gVhwFYMnUBgNjh1QgyOKVXSBKY0fAQE?=
X-IronPort-AV: E=Sophos;i="5.70,514,1574121600"; 
   d="scan'208";a="442264074"
Received: from rcdn-core-3.cisco.com ([173.37.93.154])
  by alln-iport-4.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 04 Mar 2020 18:20:58 +0000
Received: from XCH-RCD-002.cisco.com (xch-rcd-002.cisco.com [173.37.102.12])
        by rcdn-core-3.cisco.com (8.15.2/8.15.2) with ESMTPS id 024IKwO3031939
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Wed, 4 Mar 2020 18:20:58 GMT
Received: from xhs-rcd-003.cisco.com (173.37.227.248) by XCH-RCD-002.cisco.com
 (173.37.102.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 4 Mar
 2020 12:20:57 -0600
Received: from xhs-aln-001.cisco.com (173.37.135.118) by xhs-rcd-003.cisco.com
 (173.37.227.248) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 4 Mar
 2020 12:20:57 -0600
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (173.37.151.57)
 by xhs-aln-001.cisco.com (173.37.135.118) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 4 Mar 2020 12:20:57 -0600
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LNNE7qNOSv4SHL3Q3g7GOjst84PUs2M+YaU7CuguxCadJetVj58CxHv/B1Cp6XHJxp+2jnZdNSIYbIS4hIkV4Bmo5JCIeStI/3pLQM44qrgFa0ymT33L5JPJLgeB9RMGAjXw/MbhDU6ZleJ5shpq3czmZndBJ5907fXwvZxYvPnk2cq8NBvmUlsMI/6zxGxk8vNzEqhzaKvWS91KACwVclQ6R3KkYR/XNydlySHupjzbYTXKXNq0bXeEhPFOK5+T/3TmQPTRgHgBmO/wYIExcDepuhYmlpLsDbZo9CP75xuqWIuicvWTOfy9D55ghVNbOIw3ylWU30Zg3pptsdukFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6D+5zK9Ir5X2JtzignUf3U164lli3KCKnQ+PlqpXb+w=;
 b=MZLezBq7Fln1pwuUgphn3/S1PE6Xivt7VZ5haOkSOPctuWIDkS9u3s6ZA76+6vn3Pk6fWV/tH9v+4wgTfze7DEp1GLWH+9ZW/T3IqaCFQJb+05MIeiP5r1ni9jc63Jt7A8sVO37DMwau4y9sncUOU5YrRF9NPrxBwPP8AIqAU25ZnM2TN/+edHfFIQjNtLQ90wY0FEyW7IMJ67801yt+DbtABmrY9M1L5/mSRTGqWqwmRd7OE4p0YCRtE+k6uldBODcOj8fo4PdSh5HlKQi9lyLEuIMtOW1+/oaQVk8paVQHYn2vBvI+eXvHWPyxVVyAGaWRmq7aC7u7l6rrSpAbag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6D+5zK9Ir5X2JtzignUf3U164lli3KCKnQ+PlqpXb+w=;
 b=vU4hOimOHzHJ/gLuACQHlhtEtK7YuYuJtr/woRNGD+KqjadTRs55TAKcegTwqzSDwOxamhU1Mht/EdMTolGEGx9/dFv/3/nJVfA/MzMTBmyP8n95+r+ge/SUpct0rf+T5A1l+3im9Xv2UUvksZvMcgrdHn6OHmeecl25YVgyt4w=
Received: from BYAPR11MB3799.namprd11.prod.outlook.com (2603:10b6:a03:fb::19)
 by BYAPR11MB2613.namprd11.prod.outlook.com (2603:10b6:a02:cd::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.18; Wed, 4 Mar
 2020 18:20:55 +0000
Received: from BYAPR11MB3799.namprd11.prod.outlook.com
 ([fe80::d80b:14d9:9f12:ac2b]) by BYAPR11MB3799.namprd11.prod.outlook.com
 ([fe80::d80b:14d9:9f12:ac2b%6]) with mapi id 15.20.2793.013; Wed, 4 Mar 2020
 18:20:55 +0000
From:   "Christian Benvenuti (benve)" <benve@cisco.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "_govind@gmx.com" <_govind@gmx.com>,
        "pkaustub@cisco.com" <pkaustub@cisco.com>
Subject: RE: [PATCH net] MAINTAINERS: remove bouncing pkaustub@cisco.com from
 enic
Thread-Topic: [PATCH net] MAINTAINERS: remove bouncing pkaustub@cisco.com from
 enic
Thread-Index: AQHV8lFH3ti4iTUGz0C5gzDbbKntUag4vljQ
Date:   Wed, 4 Mar 2020 18:20:55 +0000
Message-ID: <BYAPR11MB3799F3078442203A5963BCB9BAE50@BYAPR11MB3799.namprd11.prod.outlook.com>
References: <20200304181753.723315-1-kuba@kernel.org>
In-Reply-To: <20200304181753.723315-1-kuba@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=benve@cisco.com; 
x-originating-ip: [2001:420:c0c8:1005::5b1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dd2b02c6-7de8-412c-1db0-08d7c068c7e6
x-ms-traffictypediagnostic: BYAPR11MB2613:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR11MB2613A850BB98F1510BE8A465BAE50@BYAPR11MB2613.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:241;
x-forefront-prvs: 0332AACBC3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(346002)(376002)(366004)(39860400002)(199004)(189003)(52536014)(4326008)(110136005)(54906003)(5660300002)(81156014)(81166006)(186003)(8676002)(33656002)(107886003)(4744005)(8936002)(71200400001)(316002)(2906002)(86362001)(64756008)(478600001)(66556008)(66446008)(66476007)(76116006)(66946007)(6506007)(9686003)(53546011)(7696005)(55016002)(518174003);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB2613;H:BYAPR11MB3799.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cisco.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bQ46qcyBpqonw9o1USeYpVCormuN3uOPZ+5Qy4+g3fuJnab9r39J1YM5CBjhbN61b1ye6mZFl4wBupD3dc9KYQYaW5Cm4PuCYSqoLT/MtnsbBTew0NDsjRAAssT/v5PoZw2leCeJ3fEIq4ojC2PVbHsNGesWv3J2bWq8V67GN3CeVX3Edeum5A616AwDivljKpTJdA9NdCOgfCW2kA49OGWd/s8leu8cQ3YNKRogRt62B62AhRkPgZVHYjzt0ftGIvOktLckXXOemnc6Jm51buhGpfG7ERIfj4fQmR8C0oQNHXj4cS1oFHMFtHjzi+I9Qh2F4GWR8xBuxjmTOMXk1ns4Cl8+TjnCvy3S2ZjQ/ufh1qWuNgYSO/gHlzwQirhjA8J/N4jpGGg9uGavSfRNfoKKwaPfjRCJb/lClTqdx+SSoHfmKK8yhvjBfFT6oWijBlgudhAzztzsXI0tlQxQwtTBvaT4yfCvptiFbS+PPNKvoGVNbAJMMPGTbSaMTmzO
x-ms-exchange-antispam-messagedata: BsP68Z24ZtHRvzo+PCx7XRKHSrfDMzYffZYAJtsX9ox7thUWT4iYsqt/a/hLWQojit3T+zm08hAzD1b5B7f7dZdhG8BYbAD1/lug9cEUBynbNygwKC8vbxfxuVfjsygBIBFhFqBsxX015FQYEk7F0To9qJVggA/vwlEG/evFZ+U=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: dd2b02c6-7de8-412c-1db0-08d7c068c7e6
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Mar 2020 18:20:55.7484
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2asUEQ9Zs6D1wMjqPfGmFD9pZNH9qgeVa1OXg5+7+ROtAFoBdy86+MgY5P6ttP0v
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2613
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.37.102.12, xch-rcd-002.cisco.com
X-Outbound-Node: rcdn-core-3.cisco.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: netdev-owner@vger.kernel.org <netdev-owner@vger.kernel.org>
> On Behalf Of Jakub Kicinski
> Sent: Wednesday, March 4, 2020 10:18 AM
> To: davem@davemloft.net
> Cc: netdev@vger.kernel.org; Christian Benvenuti (benve)
> <benve@cisco.com>; _govind@gmx.com; pkaustub@cisco.com; Jakub
> Kicinski <kuba@kernel.org>
> Subject: [PATCH net] MAINTAINERS: remove bouncing pkaustub@cisco.com
> from enic
>=20
> pkaustub@cisco.com is bouncing, remove it.
>=20
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Acked-by: Christian Benvenuti <benve@cisco.com>

