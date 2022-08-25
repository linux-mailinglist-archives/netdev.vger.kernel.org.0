Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FDCF5A0829
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 06:43:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232525AbiHYEnN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 00:43:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232527AbiHYEnL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 00:43:11 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5A2C9E0E4
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 21:43:09 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27OLS7wg027280;
        Wed, 24 Aug 2022 21:42:56 -0700
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3j5a67dssd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 24 Aug 2022 21:42:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CPawz0xxT68uZ9RcdXndUdz94H7TDqfBGlnsiWIeUcTRLR9DKlcpqaQnBKuT2J7xKNrWA+J5Mf4XlPYVzog1KInS5SI6HblKXPaTEqx1FNncXNgs9j30kkLQhare1gUMINKY0YY+dY0MdKxYH5aqDiwnFhMZepKiZqnYgomt+W2PrMWfY5I58zZsNahpfQMD4EG8uacftQzU3HQ18HOS77dJrV3RLYClQC1XKykU4brj6MB9Rq5EIZVSKlOZo/XWIQinMl48TE40FmcKcp1ohLM83A5O39MUeqEHUCb33uqaP6Q5sIOTCZHm0al9jH709Jg9uTvt2mKUvn0x0zkG9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j5vxCTcs87CO6LFnKJDbZF/hUnROsMVqNBOBUAkhD6g=;
 b=L8mZqQAPuzLPUamusO15bqbhdPV0XZJ4Wk/DiRmUElRVs6kZXe+H4REkDrrn40KjsnWxMVygbzo9VPgSe93J9WOeqtSmvWp5ptEqrQ+U/VRcZx2oSdUNxG/oSUEqt3FZglDV4kwgivxS3W9geYab7nXGJ7wBwazES39nrqvoIIHuUmRCq0ldGI3kwJ4R6UloyKKu0LlcqR1yYAOZ2HPuoT8LOmqotjgG/oS+iYdRtG3XpKTRVqtsPZd0JCDgudaYcgk9MPli54CHuApb5eB6XeJ0ln9BKqzf1ChnffJ6kh5Ahr5XDyZKMfWn3mIeQNkI5HiYOB5tJlDsNGuExbhCEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j5vxCTcs87CO6LFnKJDbZF/hUnROsMVqNBOBUAkhD6g=;
 b=Epe6PGk5EPxex+rblevnjo2/4NfiLbVdsP/8BCSv8KXymOXYHsUpZG+2YUpQmx0stTTsH4YnI+PkjzEkPnFjTs9q6QDOi+F425H9/3XFfMhxbP1/WBshBWbp8uwbhUEk17EBrPPeu4ZtZifliwwJnE/UhTZotY/q48uEpMsfO7o=
Received: from SJ0PR18MB5216.namprd18.prod.outlook.com (2603:10b6:a03:430::6)
 by BN8PR18MB2915.namprd18.prod.outlook.com (2603:10b6:408:a8::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Thu, 25 Aug
 2022 04:42:55 +0000
Received: from SJ0PR18MB5216.namprd18.prod.outlook.com
 ([fe80::a0cb:528f:3593:e24]) by SJ0PR18MB5216.namprd18.prod.outlook.com
 ([fe80::a0cb:528f:3593:e24%7]) with mapi id 15.20.5566.014; Thu, 25 Aug 2022
 04:42:55 +0000
From:   Suman Ghosh <sumang@marvell.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        Jerin Jacob Kollanukkaran <jerinj@marvell.com>,
        Hariprasad Kelam <hkelam@marvell.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [EXT] Re: [PATCH V2] octeontx2-pf: Add egress PFC support
Thread-Topic: [EXT] Re: [PATCH V2] octeontx2-pf: Add egress PFC support
Thread-Index: AQHYt37Q9S/3IZEeKEaDfcZd+W2DOK2+6B8AgAAi6xA=
Date:   Thu, 25 Aug 2022 04:42:54 +0000
Message-ID: <SJ0PR18MB5216A5964361E85196109BBEDB729@SJ0PR18MB5216.namprd18.prod.outlook.com>
References: <20220824060006.1430587-1-sumang@marvell.com>
 <20220824193702.21b14336@kernel.org>
In-Reply-To: <20220824193702.21b14336@kernel.org>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cb975971-1d5f-4f0c-603d-08da865446c9
x-ms-traffictypediagnostic: BN8PR18MB2915:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ET74NMZ+tIszt4qiXliUXfsArxJdC5VFd5v9xrZijY5jJCmMQ5j1o7PaOORzSWJvUGuEDMP3tcVguqe3O4CeMO/acH4dWogIUQMmNHC9eu5WOk5V/GSWrrcBbBulwRyYgDZlgKXmDxvTL7OOL7D0RvZqdBbVDvMCsSnpY4jnPNKCAjEyn95MnM3B9yisS/uVZOpxxAWE/AfUeSjiSe6KkoyYg2UtYNXdTniWIksPw0SXxaXSfkp+T/DjgrZ8u/XplL1VOIJl47L1f6U5dvEF0T9MfI1ZAFn1EmtVsBbs0AFu7hC4rJ0S0Wv//aA3C6qYzUXzl4npx6eSh2prW4S+Ogdshk0KYPoq6ZJOpsnxgSgIl28DvRCBnwgKVwyssIX6SXWfNB4TFUBlZLPMj7/wIJLqhNAAiEv5uRfP8PxMXxJMU0gzd/VvHZ0f8lmJvVVW/SCxlEXmVuHsAqOnnZHfTXYwvR6gmg2xeB0h+x8djevLh15FGhtbeZalAZhTSGxGgQE/tXIfKk4SmASNi6TL6/aZ39UsQKC6G5ncb0f0d9pAhIyVdHR+K1JK0zAP335GvzmwBdwy0mALONaT8PtVFiRcHkgkgxAe8qEGFWy0ncDoZqWIpNPxnWFk/4No2+s6LG5ajgGi2sanxYiwGkVdUn7OD9XlfrF81wAoR4WN97xQ6aXAKr71xMJhPaMblHxqJGPey/cdGjSBwOc7ISDCtjR+S6VScjbdCo09ornxDpeGucp3LI4vCSkLbfttYEN3uEC4pUT/o9yA51II2x6/xg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR18MB5216.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(136003)(39860400002)(396003)(346002)(376002)(66446008)(122000001)(66946007)(76116006)(66556008)(66476007)(38070700005)(8676002)(4326008)(86362001)(33656002)(38100700002)(186003)(9686003)(26005)(478600001)(7696005)(6506007)(41300700001)(71200400001)(83380400001)(54906003)(6916009)(316002)(55016003)(2906002)(64756008)(52536014)(5660300002)(4744005)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?yQcMMreVDASJW2Jkq2EjzDCQkPEOssLlVOqWx9A7LcTEr0fYDQsYt7VNibGW?=
 =?us-ascii?Q?Kt121H4J8sxhZBU9P2YuFt/NqtIulVMFtmVz+4mfSsjC4Yo98CfD0tJCcp5U?=
 =?us-ascii?Q?IsBNeOd+rOQIgaz1ZyTFHHYzREUjLWF/t+EvGBKl8zuWLeuOYHLgVg7fWOTj?=
 =?us-ascii?Q?2SVMpM7ji5JsRTFIizCsEl+YW05biG4tt5h3TqVFWDHl0jiocJsQ7YJ8+dMr?=
 =?us-ascii?Q?K9AjkoUuf7wQWfDrjXLegcQWgru/S/2iJJ+8DW5g76MKr3IOGps4ZB9e/kYS?=
 =?us-ascii?Q?u7+k887I6x/VD85ZH0yy6ivdLVcxm4b61L1DXVs1MfRSv0eoPcIHF707n2S8?=
 =?us-ascii?Q?0h1IVmtu5EPU//KcE5aWpMTVTB/COgQ7OMQOskGUUSG8DBP+e1xau7T7LsoE?=
 =?us-ascii?Q?mke+BKWtxluZXsQoNIsjl0xfnJkB2vkS/u0gk2bB+E7OvcYh76vr4Ae3Vd0c?=
 =?us-ascii?Q?bQcFFrIQi8GjwYw7ool2ZIKBGhslvYVoT65seBQkcSGL3j4mVNFDhRfVqviN?=
 =?us-ascii?Q?JhfvuIlGtWZZZmPQgIqgp1adHzqWT3Y2xYTXU2GykXZrRriBpJ2o526VG53q?=
 =?us-ascii?Q?myPz8UqDIX1scxBMA7+ZS8Y9rbGfNqGxKVuj813FccSobyp0fkfKpEXItuDd?=
 =?us-ascii?Q?zDqVsO5BjoDVF5fjQzC3h/BOt7n9uj31lJXOtWKOYERhfsB+4qQJLbSJ5YKQ?=
 =?us-ascii?Q?6jDdyYl0sge8v3xJySkj0ds4g1k8CdsQ1VyfhLMMjYZSRAVlDn/ti+kGiF1y?=
 =?us-ascii?Q?Uku1RNZLA2kehbG6nA3Kz8Dr6OerriRVRK+bu2/2+fYVnzig/BGhdv6YB590?=
 =?us-ascii?Q?58xFV7jZEBjBStXmToa7lXetL9cYpXkIE2YOR6jOOn5TtrfH5Ib1sH3KAt52?=
 =?us-ascii?Q?v9q0QmGsQoYNB1ymQxwblQug/sINuH0UCTtks5vMCWBdMsxyKMZB9lj+biVD?=
 =?us-ascii?Q?08yk8DmNnnPfgsQTxL1LxvE4N0AKZFXUD1+Cc6urxSSWlax/E8VrTEZcyHMG?=
 =?us-ascii?Q?FQ27ZKa2VrdbSWF69z920LbG+Gld4xeK5KIcQt4C+Pq2FMT4IRxibTB6+rQj?=
 =?us-ascii?Q?hE2P4W9W0wFCKABVoN0Q6tQU0L3YKKqhMeD6gFHi3XCc30PUBeOL0nep9YCy?=
 =?us-ascii?Q?jvuFAc53M8t6QjzBG75hY/judOxI5GAh+dXLRS05/vPzSnPVwUctBH/FxMXv?=
 =?us-ascii?Q?RWS6RqBf8DMxklm+6n+VwyzAUtUMRXyI2DXQ4xJXSSoYZbMT2wbOSAxfIi9u?=
 =?us-ascii?Q?ltlrzKEC2ID9mV3NbhJ06tCxfyCaHaqQSvhLC76AH1lRYW7K+0MyGCnSJSxT?=
 =?us-ascii?Q?YF0Wwcag/oC7+feHbe3rZXmOiyUxWbDuDfuxZaEKjrw+eaP9+WWVo+8f3vyx?=
 =?us-ascii?Q?slE43CbEII5WR4nYm8aqr+PGNSqEFKbVgB9hj3t/D4obUtWHyTuYiUwDc1iO?=
 =?us-ascii?Q?ANRE3rCZTUTOYeiaiREqFj4mqx9Iv4edDKxQEkIQQUVLxGVr4/LX1KfHqmKM?=
 =?us-ascii?Q?5OtOTGjKumo13evN497pcID/FUxtxsh4Q2X6OvyXptvmI6Y+Ruzv+L97vPJ6?=
 =?us-ascii?Q?ABD+WpDBJN3JNtmfhII=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR18MB5216.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb975971-1d5f-4f0c-603d-08da865446c9
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Aug 2022 04:42:54.9011
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0Hz472z7PnavbscJmn9RqfpsZ5bPYgMEQjNWIASi8st0uiMV3NZ7G20pIrSLIyKxhw0aegpMh4jMOuFkJXHTww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR18MB2915
X-Proofpoint-ORIG-GUID: S0p002_zl5ElvhcifdkUuuZFFSXVnKGr
X-Proofpoint-GUID: S0p002_zl5ElvhcifdkUuuZFFSXVnKGr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-25_03,2022-08-22_02,2022-06-22_01
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>External Email
>
>----------------------------------------------------------------------
>On Wed, 24 Aug 2022 11:30:06 +0530 Suman Ghosh wrote:
>> As of now all transmit queues transmit packets out of same scheduler
>> queue hierarchy. Due to this PFC frames sent by peer are not handled
>> properly, either all transmit queues are backpressured or none.
>> To fix this when user enables PFC for a given priority map relavant
>> transmit queue to a different scheduler queue hierarcy, so that
>> backpressure is applied only to the traffic egressing out of that TXQ.
>
>clang says:
>
>drivers/net/ethernet/marvell/octeontx2/nic/otx2_dcbnl.c:129:6: warning:
>variable 'err' set but not used [-Wunused-but-set-variable]
>        int err;
>            ^
[Suman] Fixed in patch V3
