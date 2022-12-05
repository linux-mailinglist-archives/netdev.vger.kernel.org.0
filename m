Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB4DE64225A
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 05:46:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231261AbiLEEqq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Dec 2022 23:46:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230501AbiLEEqo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Dec 2022 23:46:44 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA73C10C7;
        Sun,  4 Dec 2022 20:46:43 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B4NRLMH032413;
        Sun, 4 Dec 2022 20:46:35 -0800
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3m84pumaux-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 04 Dec 2022 20:46:35 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=erb3oYOE2asvM/pgXxIS9qD8HmQ0ILCt2E40lYAoKo4t03H4IqfgAdDC2+Lt/mQngChbu+o5IfIph2dilpueB1DrLK4awbGo9afCnShDvDi7gF7zYCXZamDF59OFKsLPmYKg8Z3itIzJQlmmXdWS4/lpMLWI0SjG8rQWXNNrzYr2njyyoxYlcs907lWg0J6BQOzoVGa0u/69qMkiXTZ/dOMFZ2kkbuRroNW9oVeNawA85fBOd5WrlkiUZQH0VeE178ruFYf8jvwV7+htoNP1LrsxxPpEFN019yDuF3BC5ID9K1mj8q/7m3fQ0eOiEZNvidV/DV6KpFJZ+pOZRkYOug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J3T12EqTyTgAfIYhc1LOCkDvm+IO3FJxilOn4Xhi6jk=;
 b=HyB9VvQAkICnUM59p1go/s7fz3wW1ZdL5pTCBCnLUNj+56WbjlvYVA3xued/7N1+QhddDXg3ALbgy1YWMKC6acQ+EmB3kiSPon4ohRaZIHX5oR1b1IV4DtCrxfQnyoZyUnZEymFmo1YYqdY58Zah/qknCujgsJ2dO6ipOogVjBWMyWBXckoPpqOe8c4o7CaHXZhp9pTlzkdFVwx7gfsIMRflraPiMgMLNv5OWasqDEs/IitECxkyu3T9+PDq7JOsHsLrsYW3JCF0TkZJyGUprII4ZABjFmP6R9bZQE1OFB+JoxXCpDpTX/FUzAt0tqgotEB07EDP3HzMW20y3ex9rQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J3T12EqTyTgAfIYhc1LOCkDvm+IO3FJxilOn4Xhi6jk=;
 b=cdRdUvata3FmoeA9G18+nh1CTAWzXSTDDKtthKtDUZiWlUGRC6wGZw6VxLCjYNrZT1SnVvWhlyM/0RMf3nxqxfVYtWXPzd99NnNS4kmfFb+7GYlvAJVPBmWN30y2kt/yx0hlxoQHYh9EYlzFl6A9YXq87iSPDe1/+dV7nExYUYY=
Received: from BYAPR18MB2423.namprd18.prod.outlook.com (2603:10b6:a03:132::28)
 by CO6PR18MB4500.namprd18.prod.outlook.com (2603:10b6:5:356::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.11; Mon, 5 Dec
 2022 04:46:32 +0000
Received: from BYAPR18MB2423.namprd18.prod.outlook.com
 ([fe80::81c8:f21b:cf9e:df2d]) by BYAPR18MB2423.namprd18.prod.outlook.com
 ([fe80::81c8:f21b:cf9e:df2d%3]) with mapi id 15.20.5880.011; Mon, 5 Dec 2022
 04:46:31 +0000
From:   Veerasenareddy Burru <vburru@marvell.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liron Himi <lironh@marvell.com>,
        Abhijit Ayarekar <aayarekar@marvell.com>,
        Sathesh B Edara <sedara@marvell.com>,
        Satananda Burla <sburla@marvell.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: RE: [EXT] Re: [PATCH net-next v2 2/9] octeon_ep: poll for control
 messages
Thread-Topic: [EXT] Re: [PATCH net-next v2 2/9] octeon_ep: poll for control
 messages
Thread-Index: AQHZA/PZs+9RX6z1+0m5ZGIy8eBWva5XNNSAgABoFsCAARQmAIACoOYQ
Date:   Mon, 5 Dec 2022 04:46:31 +0000
Message-ID: <BYAPR18MB2423229A66D1C98C6C744EE1CC189@BYAPR18MB2423.namprd18.prod.outlook.com>
References: <20221129130933.25231-1-vburru@marvell.com>
 <20221129130933.25231-3-vburru@marvell.com> <Y4cirWdJipOxmNaT@unreal>
 <BYAPR18MB242397C352B0086140106A46CC159@BYAPR18MB2423.namprd18.prod.outlook.com>
 <Y4hhpFVsENaM45Ho@unreal>
In-Reply-To: <Y4hhpFVsENaM45Ho@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcdmJ1cnJ1XGFw?=
 =?us-ascii?Q?cGRhdGFccm9hbWluZ1wwOWQ4NDliNi0zMmQzLTRhNDAtODVlZS02Yjg0YmEy?=
 =?us-ascii?Q?OWUzNWJcbXNnc1xtc2ctYzdkZDI5MTUtNzQ1Ny0xMWVkLTgzNzItZjRhNDc1?=
 =?us-ascii?Q?OWE1OGFjXGFtZS10ZXN0XGM3ZGQyOTE2LTc0NTctMTFlZC04MzcyLWY0YTQ3?=
 =?us-ascii?Q?NTlhNThhY2JvZHkudHh0IiBzej0iNDYxOCIgdD0iMTMzMTQ2ODkxODk2NTM2?=
 =?us-ascii?Q?MzMyIiBoPSJmMUU4emgrbUU0MDVYbWYvSjBidFZ6ZEY5dTQ9IiBpZD0iIiBi?=
 =?us-ascii?Q?bD0iMCIgYm89IjEiIGNpPSJjQUFBQUVSSFUxUlNSVUZOQ2dVQUFQNEZBQUFN?=
 =?us-ascii?Q?dlhDS1pBalpBUWU0Ky9BNEg1V3VCN2o3OERnZmxhNEpBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBSEFBQUFDT0JRQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?RUFBUUFCQUFBQStSRzhlZ0FBQUFBQUFBQUFBQUFBQUo0QUFBQmhBR1FBWkFC?=
 =?us-ascii?Q?eUFHVUFjd0J6QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFF?=
 =?us-ascii?Q?QUFBQUFBQUFBQWdBQUFBQUFuZ0FBQUdNQWRRQnpBSFFBYndCdEFGOEFjQUJs?=
 =?us-ascii?Q?QUhJQWN3QnZBRzRBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUJBQUFBQUFBQUFBQUFBQUFBUUFBQUFBQUFBQUNBQUFB?=
 =?us-ascii?Q?QUFDZUFBQUFZd0IxQUhNQWRBQnZBRzBBWHdCd0FHZ0Fid0J1QUdVQWJnQjFB?=
 =?us-ascii?Q?RzBBWWdCbEFISUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQkFBQUFBQUFBQUFJQUFBQUFBSjRBQUFCakFIVUFj?=
 =?us-ascii?Q?d0IwQUc4QWJRQmZBSE1BY3dCdUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-refone: =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUVBQUFBQUFBQUFBZ0FBQUFBQW5nQUFBR1FB?=
 =?us-ascii?Q?YkFCd0FGOEFjd0JyQUhrQWNBQmxBRjhBWXdCb0FHRUFkQUJmQUcwQVpRQnpB?=
 =?us-ascii?Q?SE1BWVFCbkFHVUFYd0IyQURBQU1nQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFRQUFBQUFBQUFBQ0FBQUFBQUNlQUFBQVpBQnNBSEFBWHdCekFHd0FZ?=
 =?us-ascii?Q?UUJqQUdzQVh3QmpBR2dBWVFCMEFGOEFiUUJsQUhNQWN3QmhBR2NBWlFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFCQUFBQUFBQUFB?=
 =?us-ascii?Q?QUlBQUFBQUFKNEFBQUJrQUd3QWNBQmZBSFFBWlFCaEFHMEFjd0JmQUc4QWJn?=
 =?us-ascii?Q?QmxBR1FBY2dCcEFIWUFaUUJmQUdZQWFRQnNBR1VBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBRUFBQUFBQUFBQUFnQUFBQUFBbmdBQUFH?=
 =?us-ascii?Q?VUFiUUJoQUdrQWJBQmZBR0VBWkFCa0FISUFaUUJ6QUhNQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFIQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQVFBQUFBQUFBQUFDQUFBQUFBQ2VBQUFBYlFCaEFISUFkZ0JsQUd3?=
 =?us-ascii?Q?QWJBQmZBSFFBWlFCeUFHMEFhUUJ1QUhVQWN3QUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-reftwo: QUFBQUFBQUFBQUJBQUFBQUFBQUFBSUFBQUFBQUE9PSIvPjwvbWV0YT4=
x-dg-rorf: true
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR18MB2423:EE_|CO6PR18MB4500:EE_
x-ms-office365-filtering-correlation-id: b1758dff-dc34-4b6a-91e9-08dad67bae36
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: io5GASzIMOjJLIdcGP8kyWqPpng9W08w1tcLVbhnwEvdhuIRcFJrgmDtL1cWxD19U6F5DQ3xefiz4vlNC4yjyGM4fLXnCNuaUPFDqrhMXltZ9OWztmTzdm6LawFwBnl3s/Ryz5Djtzxx/oVFzsHRgOmCGPi9YDlod86kxnmG0p3qaPDspuME540pQEAzoRdDEAG0QFyzLq8ZLjjSnNN7mvf+/qFjRf4fp/4q3jdJTz9UeFmd+GOKL8kJHRpsk47T4AQJrZ0jAqsSaBErcxU7MXpZzQrjs/w/B7Hq1QvgStJNluX6yhfW/AxmQraHPPSubFZSKImOnNk/wLis5AqtS21e+TYTQqxRgFVJ5OUlTYCZENyfYScO4Tyvzc6TazRiY/dakLr+8v6NOOSRtjoLW0/OaT/2kPA4bwsyDGnonHPD+AkXEhGnWTIWhFTMkSGxbdsaKWqGuvHT+RYj4F94ljHXjJfEavg9QFhZi0PXhUSHwKlHWP01y2WnHllwfUV91Bq5aQy/8jWVkc6PYPfRFfipfi8nWyTaKLzqca4rn+UPoJuIjVh0zBkDAD5VxiDdScxdhrqebt/ilOdmhJh79iuO12tbrj3V5Tx3rqpRxTf+dlsIO8mbwXSVfUuRoaRcJC9+j7Oc54XC8P+t11vC/PZT5CtnmOvNpo0ePRamk8md30yHs1dCiXs+tXnIoRyhNt3m//7BV4FfhC0AcOp4Nw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR18MB2423.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(376002)(366004)(346002)(39850400004)(451199015)(38070700005)(55016003)(86362001)(33656002)(71200400001)(6506007)(53546011)(478600001)(7696005)(26005)(9686003)(8676002)(4326008)(5660300002)(52536014)(41300700001)(8936002)(66446008)(54906003)(64756008)(6916009)(2906002)(316002)(66946007)(66556008)(15650500001)(66476007)(76116006)(38100700002)(122000001)(186003)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?XBRp5rkEZk/e79ZbXjHasT+H1ZJ9ghZUmB+LrpeEQHldt8sWrkmlQBe81jK4?=
 =?us-ascii?Q?LgtSzxK5sd3W5R7ozIGjgvD0OiHY4LXyjblITwcePPdjKf8rDvFY3dS/hvU8?=
 =?us-ascii?Q?r1uD4DC3icRUzWBAtfv2Wc9qL3DMbu1bwv33VT3/4zlspHXq+KwKbLhRCjAF?=
 =?us-ascii?Q?cSJ4tlT401DxJMfagFGWzCbgblXRoPhKj0pBRGP7ph03kybPw4G46BdVvawl?=
 =?us-ascii?Q?A+kb313mggLk7xVlm71NBPn4LvGp7TeAoS5KUqdBkzvsBf0wsm49ku9VMx7j?=
 =?us-ascii?Q?SW38xoon7XDH9r1SiJMEV6LVb4MOP/PN/bMx6RjHaIDp7JqhDiPIBXxiSbo8?=
 =?us-ascii?Q?JX0DQYVtqlgBDvIVm00AHNLKsOmi8ixK+RZa7vlB9FAcfm64RlR1A54HjEfa?=
 =?us-ascii?Q?4YCXQJ9b+f00ju4yWMuuq3wHXFSgiJru9mGVeAnWXr6DbjAXPXD0lBPGD3gV?=
 =?us-ascii?Q?WwEF+SSYpTjuxehwjkIDM0EYDW3QuIH0OKbzJO/bQEhKhEt14DayDfiM8Orb?=
 =?us-ascii?Q?c5PSLCS+i4Uuksvz0ILlTTS+/1NXVqYrxG8/l4+PXOBV5MemL7fVATrjzLLp?=
 =?us-ascii?Q?u+U7OZDpNVpCJpOEo5XR01x4pI+iILTKn58fGMJFdWUNPo5KoJLmSw5bPc5Z?=
 =?us-ascii?Q?DXrWRt0YFGEbeYZLz+OHpdFIisD7K8a2oMVX4n6bJhY1Z7C0Vb4GgPIfO+ui?=
 =?us-ascii?Q?csdm7F824UJSuDsnTIM0i26ofB0uM7CrEWqXSRwNsbIIfSI3hhcL5vfZYTyl?=
 =?us-ascii?Q?wMsTu7WUhZfpagY5K/u/4gnzJW0I3R4PbNqjLUdDm27gAaAY9q1jlCN0sgmX?=
 =?us-ascii?Q?AmLDo6wapQMsVZoEglS5OPMkGekFLAkx9SbvFgtPX1onQvncp30dDUQcpOlh?=
 =?us-ascii?Q?LpXHNB3w3S5hyxR5ip7YCTl+qkU92buV9b7/c5cGPkdV2e8DzejdFNb/Ztj5?=
 =?us-ascii?Q?a5PNIdPFRMryqNbKGXVCUc1DIs3GOL9UCuXv1eDr5r8zAOz3oWbUHVuFEuom?=
 =?us-ascii?Q?2JVeG17fYRPHKNoTwwgy22/90NUf5FXrYIo8GLYyLAuV0mjP8bz/mFpqA2eu?=
 =?us-ascii?Q?iAXzaQEUKjnd6+Zpb2hCFs19JPoQp1sd9E0didXHZ2ebauCq8waJIP6bA3Mz?=
 =?us-ascii?Q?naYfpkt4DBRn09GWowha79jPFONsu74cv+WUqF8u7KsxK/XMp3xJwdvpc7Ou?=
 =?us-ascii?Q?0/PFYCSDoNbPw1JT70WRMNTx0gHVxJvIpF9r0yt/P5wQnNpbLzZzovNqgaCO?=
 =?us-ascii?Q?IdLyJgrn8ly0CaK33wXaJoOgcB995K5JldQP8nkSGU7jI/26upwlFdNrWRy4?=
 =?us-ascii?Q?uB7lPtsZmyvCC2CSmS6rdsdbtOn3A2gQGfBeiFgjQ96z6M2YS/NQzbQW/O/+?=
 =?us-ascii?Q?ENFdvxnpO+cagq325xSi6F33eljA3ClS1/8SOSIiTi0Rg+O9aqynh29z48FV?=
 =?us-ascii?Q?5TxrJdjX8cU5hwg6yeV2/NcO+M45n1VsJ97eTuOkL8Np1Sbf0AHlynMFmMiq?=
 =?us-ascii?Q?/qYpeL54zT3zHvcISX35PbUYatiu3xAfFMEZJURzE72vZ9GRLYVrNDGVt1sM?=
 =?us-ascii?Q?UB5onK0M4cSohbVk0ik=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR18MB2423.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1758dff-dc34-4b6a-91e9-08dad67bae36
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Dec 2022 04:46:31.8323
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7nlDpTh/i4EjBmaIseIRnB3sXA97s7oJtMTcniGm7bVa5HFyxAtyLEcE0JIwFLXGwA3ggnV5aZkg6wNUswypTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR18MB4500
X-Proofpoint-ORIG-GUID: nRsWKkzG4WcBUvpqSACymvYVH_PXyoFk
X-Proofpoint-GUID: nRsWKkzG4WcBUvpqSACymvYVH_PXyoFk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-05_01,2022-12-01_01,2022-06-22_01
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Leon Romanovsky <leon@kernel.org>
> Sent: Thursday, December 1, 2022 12:11 AM
> To: Veerasenareddy Burru <vburru@marvell.com>
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Liron Himi
> <lironh@marvell.com>; Abhijit Ayarekar <aayarekar@marvell.com>; Sathesh
> B Edara <sedara@marvell.com>; Satananda Burla <sburla@marvell.com>;
> linux-doc@vger.kernel.org; David S. Miller <davem@davemloft.net>; Eric
> Dumazet <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>;
> Paolo Abeni <pabeni@redhat.com>
> Subject: Re: [EXT] Re: [PATCH net-next v2 2/9] octeon_ep: poll for contro=
l
> messages
>=20
> On Wed, Nov 30, 2022 at 03:44:30PM +0000, Veerasenareddy Burru wrote:
> >
> >
> > > -----Original Message-----
> > > From: Leon Romanovsky <leon@kernel.org>
> > > Sent: Wednesday, November 30, 2022 1:30 AM
> > > To: Veerasenareddy Burru <vburru@marvell.com>
> > > Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Liron Himi
> > > <lironh@marvell.com>; Abhijit Ayarekar <aayarekar@marvell.com>;
> > > Sathesh B Edara <sedara@marvell.com>; Satananda Burla
> > > <sburla@marvell.com>; linux-doc@vger.kernel.org; David S. Miller
> > > <davem@davemloft.net>; Eric Dumazet <edumazet@google.com>;
> Jakub
> > > Kicinski <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>
> > > Subject: [EXT] Re: [PATCH net-next v2 2/9] octeon_ep: poll for
> > > control messages
> > >
> > > External Email
> > >
> > > --------------------------------------------------------------------
> > > -- On Tue, Nov 29, 2022 at 05:09:25AM -0800, Veerasenareddy Burru
> > > wrote:
> > > > Poll for control messages until interrupts are enabled.
> > > > All the interrupts are enabled in ndo_open().
> > >
> > > So what are you saying if I have your device and didn't enable
> > > network device, you will poll forever?
> > Yes, Leon. It will poll periodically until network interface is enabled=
.
>=20
> I don't know if it is acceptable behaviour in netdev, but it doesn't soun=
d right
> to me. What type of control messages will be sent by FW, which PF should
> listen to them?
>=20

These messages include periodic keep alive (heartbeat) messages from FW and=
 control messages from VFs.
Every PF will be listening for its own control messages.

Thank you.

> > >
> > > > Add ability to listen for notifications from firmware before ndo_op=
en().
> > > > Once interrupts are enabled, this polling is disabled and all the
> > > > messages are processed by bottom half of interrupt handler.
> > > >
> > > > Signed-off-by: Veerasenareddy Burru <vburru@marvell.com>
> > > > Signed-off-by: Abhijit Ayarekar <aayarekar@marvell.com>
> > > > ---
> > > > v1 -> v2:
> > > >  * removed device status oct->status, as it is not required with th=
e
> > > >    modified implementation in 0001-xxxx.patch
> > > >
> > > >  .../marvell/octeon_ep/octep_cn9k_pf.c         | 49 +++++++++------=
----
> > > >  .../ethernet/marvell/octeon_ep/octep_main.c   | 35 +++++++++++++
> > > >  .../ethernet/marvell/octeon_ep/octep_main.h   | 11 ++++-
> > > >  .../marvell/octeon_ep/octep_regs_cn9k_pf.h    |  4 ++
> > > >  4 files changed, 71 insertions(+), 28 deletions(-)
> > > >
> > > > diff --git
> > > > a/drivers/net/ethernet/marvell/octeon_ep/octep_cn9k_pf.c
> > > > b/drivers/net/ethernet/marvell/octeon_ep/octep_cn9k_pf.c
> > > > index 6ad88d0fe43f..ace2dfd1e918 100644
> > > > --- a/drivers/net/ethernet/marvell/octeon_ep/octep_cn9k_pf.c
> > > > +++ b/drivers/net/ethernet/marvell/octeon_ep/octep_cn9k_pf.c
> > > > @@ -352,27 +352,36 @@ static void
> > > octep_setup_mbox_regs_cn93_pf(struct octep_device *oct, int q_no)
> > > >  	mbox->mbox_read_reg =3D oct->mmio[0].hw_addr +
> > > > CN93_SDP_R_MBOX_VF_PF_DATA(q_no);  }
> > > >
> > > > -/* Mailbox Interrupt handler */
> > > > -static void cn93_handle_pf_mbox_intr(struct octep_device *oct)
> > > > +/* Process non-ioq interrupts required to keep pf interface runnin=
g.
> > > > + * OEI_RINT is needed for control mailbox  */ static int
> > > > +octep_poll_non_ioq_interrupts_cn93_pf(struct octep_device *oct)
> > > >  {
> > > > -	u64 mbox_int_val =3D 0ULL, val =3D 0ULL, qno =3D 0ULL;
> > > > +	u64 reg0;
> > > > +	int handled =3D 0;
> > >
> > > Reversed Christmas tree.
> > Thanks for the feedback. Will revise the patch.
>=20
> It is applicable to all patches.
>=20
> And please fix your email client to properly add blank lines between repl=
ies.
>=20
> Thanks
>=20
> > >
> > > Thanks
