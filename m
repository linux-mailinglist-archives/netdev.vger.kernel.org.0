Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC74F520CA5
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 06:24:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236370AbiEJE2m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 00:28:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236647AbiEJE0q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 00:26:46 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77ACC1E1233
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 21:18:47 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 249NHWZU032643;
        Mon, 9 May 2022 21:18:43 -0700
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2172.outbound.protection.outlook.com [104.47.56.172])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3fycgerwws-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 May 2022 21:18:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ctZOWNp+b3PZbzII62dq5eIfFGo9qAkXXA0HOj+jZ5vy298W6MRsWVxe5JnQtAFQq9eTMuTHBBb1Pe0CF0d/UCluejKoY/hdZ5wccnVoXcAhdSRtDJaQlspivotdaCgRW4vWDY7ByakSHrX2FcR/x9/JNVxEiozLnAt8yj6l+HlFPbIDB6ktbqSo/FsfuZ2HYN3oEDcC+t5lS3nW9gGDkyw5k3vKLuiQn28IG2BTJrOV8qVCvCuJUfJzydecM7SUQVI75voogVyQ1JKs5K0SI1VqMNfYPbW4AsYKCbo9BYvocCvLOr8Hf476OT2HP1wE7vbACZ+Y5u87TODQB/ggUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hqDAVw+aznE+wlshGQzbEsEOTDkoT4qDMXGFCrQkUl0=;
 b=AI48IEPaO9xxvSX00o/QEquJnp52mPkgNKgPrzU94crXI1B2E3pz6FEOnV/6azIpfJmJ2AqFRh7maSefqUfdunrYlz4knggro7rvg4sX6z98dWu9FVRd5wuRV8osIAtIXdqL5FjcY4idq8seDl5872w+uOglp2+eqK4cM8mgikxKiN3f96fhXvq7LmyDeewY15jtK5F7dW6E7GQOHWzzyms0u1kAsOrz2VlxV1io2MFG07Fq/qEW9niEEhL6DAPXZbO2Ip10et7G6y03Y4eFjOO4p9zDpYBgSUUthVKSQKvRfd7j8LgixOJHlAycgWJvK6NjFg25JmoU/ipV7RJOgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hqDAVw+aznE+wlshGQzbEsEOTDkoT4qDMXGFCrQkUl0=;
 b=hoa761AU/0aRct2XqaE1WX4kJ0+INApusIP5SK0DmjODKwBF+5/XOgRj6ZW7/VcdeYBDGRj7YBcRlWVsKyOyaVdMhCseRnWYOrtUgZ4c/DuDkF8hF3Jeu9/nK2MQUJcKYRcqAv/ojACCU1Tj/CLUC/6fd22HjYehFgp1Azcqoq8=
Received: from SJ0PR18MB5216.namprd18.prod.outlook.com (2603:10b6:a03:41a::12)
 by BN8PR18MB2579.namprd18.prod.outlook.com (2603:10b6:408:6e::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23; Tue, 10 May
 2022 04:18:40 +0000
Received: from SJ0PR18MB5216.namprd18.prod.outlook.com
 ([fe80::3491:955:3e91:e5f1]) by SJ0PR18MB5216.namprd18.prod.outlook.com
 ([fe80::3491:955:3e91:e5f1%3]) with mapi id 15.20.5206.014; Tue, 10 May 2022
 04:18:39 +0000
From:   Suman Ghosh <sumang@marvell.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "pabeni@redhat.com" <pabeni@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [EXT] Re: [PATCH V3] octeontx2-pf: Add support for adaptive
 interrupt coalescing
Thread-Topic: [EXT] Re: [PATCH V3] octeontx2-pf: Add support for adaptive
 interrupt coalescing
Thread-Index: AQHYYQx9XI+1LMccrky0huTcPBztMK0XS1mAgAAAOwCAADxEcA==
Date:   Tue, 10 May 2022 04:18:39 +0000
Message-ID: <SJ0PR18MB5216F9A48501F795382D41BDDBC99@SJ0PR18MB5216.namprd18.prod.outlook.com>
References: <20220506054519.323295-1-sumang@marvell.com>
        <20220509174145.629b04df@kernel.org> <20220509174234.4a31ff92@kernel.org>
In-Reply-To: <20220509174234.4a31ff92@kernel.org>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bf9de414-1112-42dc-e541-08da323c2947
x-ms-traffictypediagnostic: BN8PR18MB2579:EE_
x-microsoft-antispam-prvs: <BN8PR18MB25791751314F8273E00585C0DBC99@BN8PR18MB2579.namprd18.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IJWz6HynU94+KEVsCKzDqxM13am7aql3r01gTh9QL/kGAXPbUsvr+f7hY/qOwJ+9Am/5BOBV885fWboNdTyAZutg0Pz+2hUmTueEKJ9hXAedi3BS6s59kjrGEPD5vPvfMYXRDVFUHV/LyJ6iY4qKvDrZ/tzQ5h52QCZdSH4J9AGJMlY+IWrfz9VlbSMlqPsmiZvUSssKz15YeYHUbg1fBQp1WE56Zq5ZK1yl1TgPpUP7PIdgxKRzB5AY1JbvHbOxQrQRSmXJzX66Gn9TtW1IcMsmvsirW4igmrQRlM+3EOkC2tFRXA5lpvJFmADSviDudxpX0cUrQGl5uQHE2wXwoa+0L7NzgaIK2GKlnZOkzylDnhSzV9P9sV9iBhlKH+VKpKNgeMxT7EXD9tFmBAWffu7sOdM09D0J6uSH73C1vSeKrqnAmuxVs5LVn0rTdOcjH3whJ60S+iUOybpQkJG00IdN3T6RexP69acHK7jLce368E3SEoE6QT7C/xdkX55M4dbTbXQUKemLtD/SaZVlpjkgCMCPQZlL/o/bH32ST6lJq+wFOEulWvnA9heJTNjN66sHWJrBBwBr+L3eUxs5tmM/VtDiH9ceySHsWSVtAPknhygKIFIxWbMr3L0GHeeLJYxm4xPRIbkYQKfYlspBsi+86uwAolKPxgToVIakZfvaJDKa5hWjNm4CnwzMCSCvT+n3kpaZfTGXXHHHoyZHcw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR18MB5216.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(86362001)(66556008)(66946007)(52536014)(54906003)(66476007)(64756008)(66446008)(76116006)(6916009)(4326008)(8936002)(8676002)(316002)(26005)(9686003)(122000001)(6506007)(7696005)(508600001)(71200400001)(33656002)(38070700005)(55016003)(4744005)(83380400001)(186003)(5660300002)(38100700002)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?X6xlT5K8afvuS1qSnNoK2jq61Sa1BparZ8tyHPC9xvPm1XbYkuX/r3fAL9cd?=
 =?us-ascii?Q?JIVxlaQbDEpHf9c7f9c2nKL+JgdpNlJtTrWs3SzDLrmZVPmZZ/HMcoJPXPM2?=
 =?us-ascii?Q?yCNdBmPR//5xd9xIxOtQw6ftClZeRh3LK3BjjTT2BbNc+0uUiNdfp6m9q0Mu?=
 =?us-ascii?Q?6rp9gvMSPuIACdm+7fys49dHRqps7kpBspMjR9X61zNicyfwnTk0i8KN7ZBj?=
 =?us-ascii?Q?dzjLWJRpBgubDqh1YxV1cmaCC2wqB6G3Wgp4TCmmjkz7vU2Zhw12cwRey80P?=
 =?us-ascii?Q?cqXp6biBNLp8mi6CAedsubXXLRNrFlfH1N32AqgNT0YjOsC+1mC8muQ8nj2T?=
 =?us-ascii?Q?dYqYmRzfsX5YPO6NWm/LzPrlJWSoZq29L7oPcd9nQfpR3njlAazQCi11nms+?=
 =?us-ascii?Q?2wbpvqEZzv7JNj6kv9jMPEupNstpSr8Qb3P+Zc2EPRpFk+ZdkT4aVOaxKAr4?=
 =?us-ascii?Q?0ql9a9Qcr+cEeqApz/jBtJiOoS9hlTKo+9rJS/ok8s8HZo4LCmM3syElHXjh?=
 =?us-ascii?Q?g7++36ptwLxm0gg4Gwbgq87AaHf5ovGWtFg+vfU+T2+FFKHZ0AXWEnHJPThr?=
 =?us-ascii?Q?8NvcdQzgYo6q60cHkNjyCVNuMfzSASQuw3aEMAR5PlxxSP9XXWX+tmjABy7n?=
 =?us-ascii?Q?ALR6jbaqL3RduYE4+G0oNJgWnJWvoa+Z6NkF3oMd7h7l+zOdjspD7b3wbqLY?=
 =?us-ascii?Q?CPzmvvk/SgAWLSfLCELmZz7yufK7NhgN0gvnXiHVp8qRKE5gNoo1BLmwJSN6?=
 =?us-ascii?Q?7yHeJhoxCL75xp9D7ub+BjkKinB0l2u/hkgupDxx96YCbCDI07a2kV3lTBJy?=
 =?us-ascii?Q?DF4Wq1w6mAcPE8zs6mKCRz5KtEVQuzasbheu6lERhbxaAn9JHE5R+JomerY2?=
 =?us-ascii?Q?/RJN6pvPJTNe27vpB4D5hglJaN3f504j/VM/CG2cdeVC4JTstZTR9N3arXdv?=
 =?us-ascii?Q?a0Xj5HjNX7HwvmoAujhcR3Ns99eDKAqmLl03hKm8SaA1XXBRIZCgfL1admU/?=
 =?us-ascii?Q?TkusoMgsZiWnRLQvw/U7ltMEJMVJfzmvtLZ2oKip5e3gcd2GSRo37LiZk2jG?=
 =?us-ascii?Q?tMxz4nSsKMA1hcNPxrv2AXzccTkYDFztuW4yeUquFoI3+zMxJEuTcj41uWKP?=
 =?us-ascii?Q?Az0hh3BB0215u/LJ9JXxybt8AXyU5oqupSHwfSdhsm8eCdcqQkIGcs7y56tC?=
 =?us-ascii?Q?1zKVqA+Eyr4dHhHrfCI+ZV0+oIilKzWBwCTa2rGPgflixDhLYW+3ac0OSm3i?=
 =?us-ascii?Q?EFGnFBqrybaAWrClFgzRR3zCj1N9HP/eCw/i3qE0dqEsob685hqAmTWxoL7O?=
 =?us-ascii?Q?EozKBH6k84zhzy29JFg4iGjnOlsK05coEwxx7MnpOoyLonyHplwe6Pcl0Dtq?=
 =?us-ascii?Q?5EnEGVut0GSqZWXCro9SkoNWWzjq1KbNI+M7V82c05gkLKkaUbSE+qt8JoMS?=
 =?us-ascii?Q?5bvqG5QK5oo8GgwV10bdodJXtUcpmzfY0E7KE6sWizt+NHjfc8jkdXCq5Mi+?=
 =?us-ascii?Q?fyews+WVq0k4EZ7JoDf1MzphbGqfm/wAY7ohwEZm5UJ0O9DWMKg+gDI/fqkA?=
 =?us-ascii?Q?puP4aP30spmZCXaPxe83ECKEwyqvtWUnBdktTh1/rPim4/uatXrhr+fFDgCB?=
 =?us-ascii?Q?oO5GABQBJfCcavzpaAjmbjESbDO98BTLxFcdgd922My947WDKmkxMaIUXnly?=
 =?us-ascii?Q?Q0kBVIusLt6yiBJsrbjd2nbCB//m6Q6CbOEZBajXPnQXJ5HFFDsvJPhR+pqo?=
 =?us-ascii?Q?XPBBBtq2pg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR18MB5216.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf9de414-1112-42dc-e541-08da323c2947
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 May 2022 04:18:39.8038
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MrSlY3hW3akLiaKnGMOBVKqdECk9ZI4WPzieWsrZ306WiubsMTrMMv3mvS09ouN54i2gQOeGMRUMTMlGhYg4PA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR18MB2579
X-Proofpoint-GUID: mNVdYI6Kjg4ghwJsiY9IVms3dscyMmYy
X-Proofpoint-ORIG-GUID: mNVdYI6Kjg4ghwJsiY9IVms3dscyMmYy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-09_06,2022-05-09_02,2022-02-23_01
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

Yes, this is tested code.

Regards,
Suman

>-----Original Message-----
>From: Jakub Kicinski <kuba@kernel.org>
>Sent: Tuesday, May 10, 2022 6:13 AM
>To: Suman Ghosh <sumang@marvell.com>
>Cc: pabeni@redhat.com; davem@davemloft.net; Sunil Kovvuri Goutham
><sgoutham@marvell.com>; netdev@vger.kernel.org
>Subject: [EXT] Re: [PATCH V3] octeontx2-pf: Add support for adaptive
>interrupt coalescing
>
>External Email
>
>----------------------------------------------------------------------
>On Mon, 9 May 2022 17:41:45 -0700 Jakub Kicinski wrote:
>> On Fri, 6 May 2022 11:15:19 +0530 Suman Ghosh wrote:
>> > Added support for adaptive IRQ coalescing. It uses net_dim algorithm
>> > to find the suitable delay/IRQ count based on the current packet
>> > rate.
>> >
>> > Signed-off-by: Suman Ghosh <sumang@marvell.com>
>> > Reviewed-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
>>
>> Have you tested this?
>
>It doesn't apply to net-next.
