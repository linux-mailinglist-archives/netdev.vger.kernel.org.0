Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 357C6567C91
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 05:38:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbiGFDiD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 23:38:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiGFDiC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 23:38:02 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D35865D5;
        Tue,  5 Jul 2022 20:38:01 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2660SddE030829;
        Tue, 5 Jul 2022 20:37:37 -0700
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2049.outbound.protection.outlook.com [104.47.73.49])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3h4yvr0h5g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Jul 2022 20:37:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aeyf1nAjnuIL5JnG2kWyQi4YNunXyc0YKiUFg4CWLfFjjlO7cBG+pG+ruPEGeYwaAWMtpbD2z3D/qQVxQ6ftbQsl97S5VLoqE11aHg/iDaArPDAOrBNkFUQj3I62wLkeqEQpz7KAu3J4oS6laRMaziFZnIJkkrXGQCprmzFQoKrAsV+GhTPEdORMrdmaBclCSNELjJckxTt84NzShaUvRB6mYVaROZwQiTo7x71v5LfhMLBnchzB9X9zWnFeTdS5ae3Ona4++WJ0JF90McjDF8M7qEJJCRVjrs8p1ZmMDwrHQ7GRZoHv4f+AjWHoGC6E7lWmiV6exDt0JDnBex/7pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2lS5fMYmE2G7df10DgmpPuWeiwCbx2/PHzZlDN81yGs=;
 b=YjCHx7nObCqt3JJcaJoabnPsXClS92aTRHMZS1TCv/1Sk4rk8NlsT7YaDAI/jyy81cVS8WThjBweUm3TM4BxK2ncwfs+/53tVEzTHAMtrxsxb0mYw2BACHrJHD0VkH8FDt5or5go8O04VsNEm64T7qWwl7XYEY0sIdJc9fARxzk4nS3MNqkzJwzTzfE9TJAmPpykCotrOVoktoXq28Ofk2si3/TS9u5DlljO8mwtHE9mpOC+WPLM7cUnKxBCQug3WzuKlW0LkMlfnFF/ZO0B1qg3OgxoKL6u1Q7ur+ThXgqqb0pEeyWbMxPMANua+/2XKeMq84M3Wtfw64fXBaPheQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2lS5fMYmE2G7df10DgmpPuWeiwCbx2/PHzZlDN81yGs=;
 b=OjUvJ4vsk2EgNmGeRJKJv7KB/5hhQCABRFXfMgt8dsRHVuDfYg5JhvivbgH/InrkHQS+qMcWVrSu7YAuBOHHFZrZgbBdZCM6PDWJa+Pe/FGDcBR1UC9oM3ff8hFteQF3yQW6JdFr6+wFMOfDTtUdq228znoCJWOCHtf782i7sjc=
Received: from MWHPR1801MB1918.namprd18.prod.outlook.com
 (2603:10b6:301:68::33) by BL1PR18MB4376.namprd18.prod.outlook.com
 (2603:10b6:208:314::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.22; Wed, 6 Jul
 2022 03:37:35 +0000
Received: from MWHPR1801MB1918.namprd18.prod.outlook.com
 ([fe80::a569:9c2d:1fff:6e58]) by MWHPR1801MB1918.namprd18.prod.outlook.com
 ([fe80::a569:9c2d:1fff:6e58%6]) with mapi id 15.20.5395.021; Wed, 6 Jul 2022
 03:37:35 +0000
From:   Ratheesh Kannoth <rkannoth@marvell.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>
Subject: RE: [EXT] Re: [PATCH 02/12] octeontx2-af: Exact match support
Thread-Topic: [EXT] Re: [PATCH 02/12] octeontx2-af: Exact match support
Thread-Index: AQHYkFzy4oXwuByJ7EyEyusgDH15Iq1wkBoAgAAg7kA=
Date:   Wed, 6 Jul 2022 03:37:34 +0000
Message-ID: <MWHPR1801MB1918173CD1371C60D96D9EE4D3809@MWHPR1801MB1918.namprd18.prod.outlook.com>
References: <20220705104923.2113935-1-rkannoth@marvell.com>
        <20220705104923.2113935-3-rkannoth@marvell.com>
 <20220705183338.375b948d@kernel.org>
In-Reply-To: <20220705183338.375b948d@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5ee52c73-2bd7-4bc0-86be-08da5f00dd90
x-ms-traffictypediagnostic: BL1PR18MB4376:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Cx5EDp3oduRAZYDTbT1mxnP0xXDQVpmd0UqzKy4r9t/dQ31J1Jq9zHTs7csAVeUDzEy7ZY0d7Kg+aQMY5C+ipbTG2s1geVGJWxc7mLr8z51gV/o4+BqQ3Dd2BTksN1RjEl4WdMHSUcKgXARteEupAqb8abGhqzcacQy0a2UxHTbW1LjM7igJaRMdfWUMQIB7CIyiMQMuKzTxPddWEtc6Q221yq3QTlScQbTei4NHkh48P710xevAkm/BSdcbHfjVdeeoLDInFpPzHzIPmQKAkLAukVTdrnAOflVNSREkELAMFEkz6CsuaWHORmcjhx2uYJrkBAtWZawsqfFq+eKhV/glm4/xZSltAmF+NkxGo+ZsgRmitCYluZb3MP1k8+2tktYJErKVtpNEQAMCxETocOQauiTafAPkmBgJrPli3HKTt5a2Sn3dO0dsZKsCbz/lM3AINhfaothZ7q6/dNJnvghCBzzQ+WGqJ6qdCke6Td5Fkc7bn7rnuIYCJA3VIIskpTzUDrb+OmP9GZSXD3klIFSuDeuq9lyx/UIK+ygqYTVETzvvB2yzic0ehbiLhlPO7dfchhHJuW9ZunMXVbZoYXY5JdNfBkjuG5VQSTD8O3hY8STzoG1kJcAkJhErh8QakKyGpZO0RGOlUj4nCVKV9Jwk8xEMie8ptgeIOXzupJlM7+wbrtZRRhynjCo0f6GnUD93DSlHnZheesOucqQTpYLYYV75hHPoEz1pAdoWcjq7znDhn6mTrjzyudb4S+1NqJ/fdjLWESbyZfCvsuetd0EcLdeDITjrimXX513pnQNt1H1WcIKHnp7XQ4PjiliQ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1801MB1918.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(136003)(39860400002)(366004)(396003)(4744005)(2906002)(55016003)(86362001)(478600001)(71200400001)(53546011)(122000001)(186003)(6506007)(7696005)(26005)(38100700002)(66476007)(66556008)(76116006)(66946007)(66446008)(64756008)(9686003)(4326008)(8676002)(33656002)(52536014)(316002)(8936002)(41300700001)(54906003)(5660300002)(6916009)(38070700005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?gnIIhkPIpiZC8z+nxT+8tHJA8zlY7KNClPN9YhfWHEz/Te/7ZJK0LfXpCMpY?=
 =?us-ascii?Q?tB3hJUDNSHx1nD2M5lw/+Ee53H33DpNspfu8filPJqQSBN9avVRmSnjaTDIi?=
 =?us-ascii?Q?6FvSfL7ZigoIKQOPVdBhXIwJK5fmd9gdQZ7rAn3IPWJBjAjKOaVm1YurN1dj?=
 =?us-ascii?Q?96eA6w2zaNHyjLRSUYqHt1dWQP+Z8Sa/ckayYZztGsVeURyg9Czk2QY22W9F?=
 =?us-ascii?Q?t9i0Ksi2HZJKKfH+4MZdZcONxwrKoe07w+rlll7e0upxGs4rshkvYbZQjGvT?=
 =?us-ascii?Q?BpdJK7GE8uL6daXTCCAxRj4D5s2Ap2sAoysx2SXjB28Hcp2IvSwreYhu++Yn?=
 =?us-ascii?Q?nZSmcEYEwkpsiyeOyNaIX5DjxyMTG/R5JQ5TC9XO7QGT4fclAxvgKWcSom05?=
 =?us-ascii?Q?XwHnc5JKxHRwRowJzJeR8FjlYTU1BOot5Ntp/ARtTpc4AZRO3Xv9R8UfQEsR?=
 =?us-ascii?Q?U25My0FTr9DYiGF9sHQk87JqLmPtwBEpalF9YlksoQx0skbOuSF6kx2KdKow?=
 =?us-ascii?Q?/PG5sTnawDxa8OgM+fg7daYCBVoqsnvw7azJiroGsWIxbKPjVeMmbbjsNIz/?=
 =?us-ascii?Q?fUdfyTeKA5aKMlHi50tkN9EgzN+sv4zBhJPEkYp0g9pHwoOkxC4ZNGf/QWvQ?=
 =?us-ascii?Q?LMt0bBDglSdQiCNnorGCLGz6SvkKf0m8J/126pQP+nAKUoUwS17/QGcjTDUB?=
 =?us-ascii?Q?pvegxmW8XzCGS7zAFgpAg5Nr7MZMq32T0b4ea0yuTR1pnjrqN/gxBnUig6J9?=
 =?us-ascii?Q?8UCNkn56oP90cdbMMXUfJzUQO5xXbaipqSqU8fhY6Q+n5vS3ldydaV0HJb2S?=
 =?us-ascii?Q?ShpluaYBIEGuklCFNOvu2DOpucouREojH/gO/daQhEEk0L2oa8hz2gx7A8Ae?=
 =?us-ascii?Q?9t3Vjvve3YdE9ChJNa7Dwhj1fDm52MQz41MG8iaAAq4O5CsR+usZbwv/8SBU?=
 =?us-ascii?Q?m5Eq3l+N9jlIo0CoPHxHsReOaj7Tfiw2xeZtlEJtRX6p6UkL0nwuqaWthTp2?=
 =?us-ascii?Q?4NDDBMP62tLqe8EMeVXVKUdLlFLqe21eYHunbwmE5wH50VrWmnm6Y1M10l+A?=
 =?us-ascii?Q?jmn+8qufUCnlcfP/7SfjjhKMUBPeZ7B5g3L6JQcz6oIc8jcU03CdHMX3AEtf?=
 =?us-ascii?Q?TZ2qHxsiZ3b4QN4JVcvqmNXRDxn0LlAbb5ubkT8/sWXZkZPWeb+RTh1jZpn+?=
 =?us-ascii?Q?DyEZyi/BjkOlbT8sXRYIhFkdmxQMlwHkqldTzTZacpy9+LUFQOlpCBxkfN4K?=
 =?us-ascii?Q?fW8KyqQ2IxKcQlszmgaRufTbv7KP+WNIH1cZedIzo89oHA2+wDiTwHcIdZHs?=
 =?us-ascii?Q?j/msN3+/tiH9FrExqxJi/m6i6Luy6OHnp3kWzXJtwRjVOH/LZaCbB/2yvRZQ?=
 =?us-ascii?Q?V++kcERxF5AkyU4bSxnBVgdGBiA40FQHq4RHs8PjP+ZMx3Z6dqAg2T6KhGDM?=
 =?us-ascii?Q?cziVAduJ7HazWaMWIFLWHdmZtVp6Pwzu/Afbp517uNyr8N7LVp+jUGjq15Cd?=
 =?us-ascii?Q?2n0eYC2NRIMtqUifBnBc6a1mWD6YUos7fgkXbJMy0WntQGslAWMA10uwkW77?=
 =?us-ascii?Q?sE/3H6qHpwXor3sritfBYTyC53UlH9j44xqASwb1?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1801MB1918.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ee52c73-2bd7-4bc0-86be-08da5f00dd90
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jul 2022 03:37:34.7752
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dzYndVWuuLw/JIojZEQpcum0Ts/l9miRu+hOauoyRpO8ueFarzJWurgKLtdZztJLWL/mTS3GBLGmwJEuizN6hQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR18MB4376
X-Proofpoint-GUID: 7u_hkCjHdk69I-evLtVaU7tYkT1qnDZ7
X-Proofpoint-ORIG-GUID: 7u_hkCjHdk69I-evLtVaU7tYkT1qnDZ7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-06_02,2022-06-28_01,2022-06-22_01
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>=20
Sent: Wednesday, July 6, 2022 7:04 AM
To: Ratheesh Kannoth <rkannoth@marvell.com>
Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Sunil Kovvuri Gou=
tham <sgoutham@marvell.com>; davem@davemloft.net; edumazet@google.com; pabe=
ni@redhat.com
Subject: [EXT] Re: [PATCH 02/12] octeontx2-af: Exact match support
On Tue, 5 Jul 2022 16:19:13 +0530 Ratheesh Kannoth wrote:
> Change-Id: Id9f72c1d9e08b44eef45b67e52fe2fd2a0e7e535

>Please drop the change ids
Done. Removed change ids from all patches.


