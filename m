Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C42F51714D
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 16:12:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376812AbiEBOQT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 10:16:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244582AbiEBOQS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 10:16:18 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 573F01572A;
        Mon,  2 May 2022 07:12:49 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 242DK5KL003197;
        Mon, 2 May 2022 14:12:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=kqNDN0nkaeOETA2wjHn4R7jGLKFOgxrPCtV7zpwcm0k=;
 b=z64nuo9V7PBX8B53TqXVefcdjutah5aZ0p0NA1dmiJN1frZ2m+vKRPNbeiwXHNy2hiqy
 YzAWKEO8WfzUyexJgokapR9vUlL9yF+BtxWiygyujQvWSAka6dm18xEwBToSdQTEidiI
 yGYVJOtu6odE8r1C46ciCDiz8R+KBK3iwYWo+7Ie/wzC7nIGQJ7Gbf2UguMLC0t9CLMG
 sRFcfoinmWst1CiYxi9CH1qkbQuZS+KOGgLkqvUx6CcBtWl79sP+T06mXtKxvnvJlM9x
 QOdGXgoJjAcOQx2NNQ4U5UxoVBac8yClLHrBGllKyLgS+wHmNaosX7YtBxscHehJmCkn pA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3frw0ak8h1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 02 May 2022 14:12:37 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 242E5NBr011906;
        Mon, 2 May 2022 14:12:36 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2106.outbound.protection.outlook.com [104.47.70.106])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fsvbkdeum-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 02 May 2022 14:12:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HM4rK+x0x0SPPpd9oO7i3b/vaHce8GD7LkPXlCikWxqwHNR26VQvN15t3Ig8OuMvINTh/OAP4A4SQrEO+DtjRgVAEVJTqnFg/t/LfQ+W/ZoO3SsnSBa8s05f1TwM9b5I6vnasfQz3G5Mvvv8SU3gDK/OliZmMcqY9eYwwbLPlTBExZ4WsujqJlIOribnax8rP1FYN9yFPzf5LU9DagqR/4byMuW8le+Wjrq0HY4IJkZ/waDy4fV5Ldz9pfBdHSOUul9jVveZlchG2v2g3ICp3Y5qutLRYdoAy2zHOrYneN4D1u429E86xIJW9pOWaV6YqsJkck2KKjWw1R6Q8Oq8vA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kqNDN0nkaeOETA2wjHn4R7jGLKFOgxrPCtV7zpwcm0k=;
 b=AzgG/cfe4zo14/35LBEBSQAzTejoAxWgJDgd+rFYcUhALg7ads9nzNOkcDf0JPZM63TCsBjw5hN9FkqY7yGxibXfF/w7DU0xz68RtZfArZlgi2AIyX/QNG7/D9gROL1NgGq4XzrgW4ynNPMAcgo/+eQfHjgEI2uxEErUx+fxS/7ebqFyCilSZr74dmKZrWTOC8us8vsz8T9+ZQ05/5x3beR8l5PoOQZZYmteLBcdDKg0KUF4q6d3RVO8QD1Uiyxb7s6XSq3gEPNHlTg8Ckj2VhSoWJXPbirbMKtQ3cOF0lJZ6kGc3tijb11+2gW4X3+VHN5vbFPYDCWyV7ebMqVWvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kqNDN0nkaeOETA2wjHn4R7jGLKFOgxrPCtV7zpwcm0k=;
 b=YL09EvOrJoJaOIz70F4pGXZcZVp44/9kM/ntSjLEk73vrw3zBUlrhkRIhcqLa7u8yeezHvRaRVsF6WYrXTjulI0rfCZdUlw3c+9QEeAIPVmRoBtQfbjeK4O8n2FMdWbItm/qUAXsdQg3sfzlMFfG4vnP53xlZ4uV9cZTiKarZBg=
Received: from PH0PR10MB5593.namprd10.prod.outlook.com (2603:10b6:510:f5::16)
 by DS7PR10MB5248.namprd10.prod.outlook.com (2603:10b6:5:3a9::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Mon, 2 May
 2022 14:12:34 +0000
Received: from PH0PR10MB5593.namprd10.prod.outlook.com
 ([fe80::f156:a704:b758:5054]) by PH0PR10MB5593.namprd10.prod.outlook.com
 ([fe80::f156:a704:b758:5054%5]) with mapi id 15.20.5186.028; Mon, 2 May 2022
 14:12:34 +0000
From:   Haakon Bugge <haakon.bugge@oracle.com>
To:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
CC:     Eric Dumazet <edumazet@google.com>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        syzbot <syzbot+694120e1002c117747ed@syzkaller.appspotmail.com>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        OFED mailing list <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH v2] net: rds: acquire refcount on TCP sockets
Thread-Topic: [PATCH v2] net: rds: acquire refcount on TCP sockets
Thread-Index: AQHYXcWizMCdIVYry0uC/6mK5jGMAa0LocmA
Date:   Mon, 2 May 2022 14:12:34 +0000
Message-ID: <F8AED695-D4EC-4560-9EEC-5DF0CEFD88AC@oracle.com>
References: <00000000000045dc96059f4d7b02@google.com>
 <000000000000f75af905d3ba0716@google.com>
 <c389e47f-8f82-fd62-8c1d-d9481d2f71ff@I-love.SAKURA.ne.jp>
 <b0f99499-fb6a-b9ec-7bd3-f535f11a885d@I-love.SAKURA.ne.jp>
 <5f90c2b8-283e-6ca5-65f9-3ea96df00984@I-love.SAKURA.ne.jp>
 <f8ae5dcd-a5ed-2d8b-dd7a-08385e9c3675@I-love.SAKURA.ne.jp>
 <CANn89iJukWcN9-fwk4HEH-StAjnTVJ34UiMsrN=mdRbwVpo8AA@mail.gmail.com>
 <a5fb1fc4-2284-3359-f6a0-e4e390239d7b@I-love.SAKURA.ne.jp>
In-Reply-To: <a5fb1fc4-2284-3359-f6a0-e4e390239d7b@I-love.SAKURA.ne.jp>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.80.82.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fffdfd00-d2d7-4836-4c77-08da2c45cdc8
x-ms-traffictypediagnostic: DS7PR10MB5248:EE_
x-microsoft-antispam-prvs: <DS7PR10MB52481E24338CEC0B7A6FE80FFDC19@DS7PR10MB5248.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3m19o7YbKsHuQaNfQboU9b7m8bcK6EOGZ6VRt4Vq7ZwvwhMRYi09E3V22IGr8ASXrRJkAXq0YAOuE+Wp+AZbcTyeiyPbIN6mOaVn9uqn7CM+L2IJBdVShprr/2UMrvKLvTysNkjbn1QEj4MdAjzIeDmBN48lGcrGBqizTNdzCE0kIRHC+QlgjAnsFhleM2BEk1oYl39fuAecLnUJNRXPm0kO68ePXxKzE2y8Rs7NXjj+yrikjfPz1zjzfDaWZsV8CpkziRnU+N+DMD2hcaUIG4V+phJU8FCPjkbTP6scfx/Q33OpTIInXhemMNTHUKEH+x/qz/Oifp24T/A5QJk2uWyQ7+pvl3sFfrIU23A9Kvq6aSUcuNrXWuzVfyH0ZDi+5AmX11d5NTKLcp+lrDnKKdwac5orWYQo8a1uCW1Ap5MESSacm2eGodq1nId90DnFhlIPSHNSC7FRFiXZqR25kzpvvQ0QyRkJSYyrejKZIEdISW93qO/u3kANgGtmGM8iPC6NCBmilq4rx0fpqQrHhLsGKDZ6/IWIdw32syoC6wVnpq43aI/l1X735rlpxbcfiMiMHPQzv8oxw4bymW3hzNgvdlYPxzPvU07Os3AKKozl16+vD2t9rb6DCPbEzl3awY1Yi9+fodnUAGjT1jHB2FGLnLbgC3US98YX5KA+DlRDnaT73CkPGTU0I3B6g39oKb49bhDwC/6/zvEJJUEpGJOAyL5xrhFseqAR36Kq+mHiHctXZfgKUDP+GWozvZdeErg7flrBT7AmzWxV2PhpOXYRfWBr1ZsgvqWPKWSXG8CBCmPr8h9k/JIZ2ITiiTiD4i4Z0ZeDAjau91jNm2e1i7E02Wh6a/IX6Mt3YvBKSMk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5593.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66556008)(966005)(6486002)(2906002)(66446008)(66476007)(5660300002)(86362001)(64756008)(6916009)(36756003)(83380400001)(2616005)(6512007)(66574015)(186003)(316002)(54906003)(8676002)(122000001)(53546011)(6506007)(33656002)(44832011)(71200400001)(76116006)(66946007)(508600001)(91956017)(38070700005)(8936002)(38100700002)(4326008)(99710200001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cklVZFdqdkd5ckZKaFZoS200TXBzbGlDdWhDcWRPR09rSENkUUhTS3EvMUIx?=
 =?utf-8?B?dlBzUWZJcG54bmZ5eHN0aVQ1TkJyYkg3elF3dHppbmhHcjNMKzJ5MDM0eWFP?=
 =?utf-8?B?dUphSXpoUHFWRDIwRWdyRlVLemxvd2VoMVQwV0NlclJzMDdhUmNCUkcrc3Fo?=
 =?utf-8?B?UjIrb1NvWEFiditqZ2ErSVpqaXhla21ZYTZQMGlqK0laU205V0dCT0ErcFZR?=
 =?utf-8?B?NGRkeElCRVZZbkFLZGl1bVFQWHdLbXlLQ0pFRFZMOE9hQXRvdHo0NUhwTy81?=
 =?utf-8?B?N1VkcTV6V3djZk0zYVhwYjVuMXhjYis1Tk84TE94S2w3cFFVUFh2ZmNSMi8x?=
 =?utf-8?B?R2dWVHhDWHdwcWxCR2dkeDZwYzVRYUw5VzJmN0ZIb3I1Y0NDYnQrME1KNEtX?=
 =?utf-8?B?OCtWVVh6ajIwUnd2TEFzTUJiWWlTcERuZkoxc0N6U2RoOFlGcytzSjF3bnNp?=
 =?utf-8?B?eHRob3poUTRYdm1kTHJWcUNMMnBvMjhtZnh4VlRabXllbjF3L2Fjd211czI5?=
 =?utf-8?B?RDJrMVEvT0trSmdCSkowT3FjOUJTWFhQTS9IMW1YVGJzMEdMaFlORkg3VCtu?=
 =?utf-8?B?QnpGTkQ3ZXNrQ0wzMTJKOXRUcWVzZnFJdU10MmFNQlJtMnozQU50OW1pT25h?=
 =?utf-8?B?M0VOOHZyRC93dDhqa0ZCRURFRFkyc3l3aHV5U3AwTDVhRVF5U0hvTmFxV2xu?=
 =?utf-8?B?bmszT1ZEQlZZUXlqWDlhSUlZQUk2UkZYNnVaN1U3V1A5c3VzZ0VwVXdCTTUz?=
 =?utf-8?B?SUdPSlp4TkE2Ym13YlRVall2bFl6NVBDbU8vSkxudEFXaE5KKzlQKzlQRWps?=
 =?utf-8?B?QnQvOERWVWRsZ2pWY3RqdWFVRVFnd25SRlU0OElqSFJraThzN3J3bzBsWDMv?=
 =?utf-8?B?TC9tUHFkZE9iem9pRHNDUVVMM1R5ZUNmNU1Qb3F4YUxrdFRpNHY1K2hnWm01?=
 =?utf-8?B?SVRyVzBrdnVBZmtNdG5odlFzeWJmZytvZmhiME1xMUF5TFpXZHpYcFVlQ2ln?=
 =?utf-8?B?dGV0ZDFCQy9ZYlB0QVpDYmhteDNaNjJYNlcxL2ZLL3UxWmJXK3c2NmhoWWRK?=
 =?utf-8?B?QXlkcmhRV2p5M1hZWldqa29TYnAwR0t4M2dLUHViVHZibUN2OUZ6T0xxaVdo?=
 =?utf-8?B?WUZpMUNKY1AzT1Vqa05hYVAxNVBCbzNNN1BBNmJQQlAxU1NTa3FTZVdCM0VN?=
 =?utf-8?B?aU44VVVzR1NLSzFQWnZGY0hKV0ZXYVBEcnpjbWUyTXNGUnBNUnV4OUdlRzg3?=
 =?utf-8?B?bHNqNXB6K01HbjVzTHdkQ3pOblo0eWRhUS9OdlhDenNmRWwrb0VtU0k4SFVP?=
 =?utf-8?B?Q2VxSDNOTDN2UVVYeERaUVZzazBwRTUrdHkva0UvUUpza093alNMaGphSHhG?=
 =?utf-8?B?THI0dXNudGFJcU1JUGRaS0RzK2pGa0pvNE01OVQyNVJ2QkZaTTF3YTNJN1R1?=
 =?utf-8?B?Tm9rQ2VMQWRHa1hVSCs3c3hvNHNvdXRUN2tOcVAxSmRySUd1U1RQZU5STzBx?=
 =?utf-8?B?K3FobFBGclZiVU03b09mK2lvQ25rQ0FmVXZoWHdocVpXNDZudndjZ05Sb3Vy?=
 =?utf-8?B?RFBVd3ZNZE9qczdtY3NCazlWcGI0V2Jld2JWTjh0ZERaWXJMdFlPb2FuU2d4?=
 =?utf-8?B?cTZ0Mk1MRzdGaDFKREZIWjY4V24rekk5VWF5S3NWbi90a2FSOUhDaThTQlhM?=
 =?utf-8?B?aFFoSDE3NFNqa1RTMEYxZWo0anUrREx2akczZXhRNHNrVnJjSUMvU1pFOWRk?=
 =?utf-8?B?K3VzTGt3VnI3T1JXN2pmWmJsZDJXcTdFaHZYZXJmUmtEVEVYODlaK3BhNTZv?=
 =?utf-8?B?Nkg1Nm9pZ3hHK2pSbklZYXQwVFQ4WWh4dHFmUVNrbzZTS3lJYlNRSHVOMksz?=
 =?utf-8?B?TzQwZkZ1cjhjNGFkbGgwTk9lSXVWaTNaOVFJREhRRUhyRlJhTXN6alhhT1Jx?=
 =?utf-8?B?bzEvZktpMjFMWFJtTDF3YjBjYjRoNmkwTHQzYWJNMERkTDFYb29aYUp3ZXFS?=
 =?utf-8?B?L2tnTHlibjZUOW9hNURTamxhRExDODJwVkJTQ2h5dFlwTEpvVjc4eVJubGc0?=
 =?utf-8?B?eVIvV1Rob05FL2JMYzVjWXc3MWZ2ZVVLTzN6V2xJRE93dTdCcWU0azJTUjJp?=
 =?utf-8?B?R0ZxeUJWVEpaSDFEZWhHSlh4aUFSMTdrNk1VRUdOeWIyM1doazNYSWkyc0gz?=
 =?utf-8?B?WmtabW1kZFc0QVRxbUYzSFZhanJHbXBIalg0OHJIaHVEeVdERmpFa3Q4TEV5?=
 =?utf-8?B?dGMwL0tnRlZCMFBXMlZvTmtscWlUcW9MTDVhSlRRbHZrRFZPZXhnYVlJSFF5?=
 =?utf-8?B?TXFlN0FEVEE5dVhqbWRLZ0J4OEQ5b1FNOHNTTUgvQU43OHk2aVhOenVja0wx?=
 =?utf-8?Q?sa2h8lbySdBuA3AxP5+5aSyfE9LQ1ljyK49IeF/bfnkhf?=
x-ms-exchange-antispam-messagedata-1: JvKnuBPHBYBRlLSIdUdyTxjkQH+GxRy4i/A=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6FAFBA6540EF194296038C524725B976@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5593.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fffdfd00-d2d7-4836-4c77-08da2c45cdc8
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 May 2022 14:12:34.2856
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WK1UBX38HainyriYZxrai9YEXjh2bMr58+zQ3MZbXUmioNOZuSWUcyvIPUh9urmtI2lB9DWtlrVFzpmx1kbo/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5248
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-02_04:2022-05-02,2022-05-02 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 spamscore=0
 malwarescore=0 adultscore=0 suspectscore=0 mlxscore=0 mlxlogscore=585
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205020111
X-Proofpoint-GUID: drbLG5c92-tL9tR6UjwmNLx8Cz9CsQgt
X-Proofpoint-ORIG-GUID: drbLG5c92-tL9tR6UjwmNLx8Cz9CsQgt
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gT24gMiBNYXkgMjAyMiwgYXQgMDM6NDAsIFRldHN1byBIYW5kYSA8cGVuZ3Vpbi1rZXJu
ZWxAaS1sb3ZlLnNha3VyYS5uZS5qcD4gd3JvdGU6DQo+IA0KPiBzeXpib3QgaXMgcmVwb3J0aW5n
IHVzZS1hZnRlci1mcmVlIHJlYWQgaW4gdGNwX3JldHJhbnNtaXRfdGltZXIoKSBbMV0sDQo+IGZv
ciBUQ1Agc29ja2V0IHVzZWQgYnkgUkRTIGlzIGFjY2Vzc2luZyBzb2NrX25ldCgpIHdpdGhvdXQg
YWNxdWlyaW5nIGENCj4gcmVmY291bnQgb24gbmV0IG5hbWVzcGFjZS4gU2luY2UgVENQJ3MgcmV0
cmFuc21pc3Npb24gY2FuIGhhcHBlbiBhZnRlcg0KPiBhIHByb2Nlc3Mgd2hpY2ggY3JlYXRlZCBu
ZXQgbmFtZXNwYWNlIHRlcm1pbmF0ZWQsIHdlIG5lZWQgdG8gZXhwbGljaXRseQ0KPiBhY3F1aXJl
IGEgcmVmY291bnQuDQo+IA0KPiBMaW5rOiBodHRwczovL3N5emthbGxlci5hcHBzcG90LmNvbS9i
dWc/ZXh0aWQ9Njk0MTIwZTEwMDJjMTE3NzQ3ZWQgWzFdDQo+IFJlcG9ydGVkLWJ5OiBzeXpib3Qg
PHN5emJvdCs2OTQxMjBlMTAwMmMxMTc3NDdlZEBzeXprYWxsZXIuYXBwc3BvdG1haWwuY29tPg0K
PiBGaXhlczogMjZhYmUxNDM3OWY4ZTJmYSAoIm5ldDogTW9kaWZ5IHNrX2FsbG9jIHRvIG5vdCBy
ZWZlcmVuY2UgY291bnQgdGhlIG5ldG5zIG9mIGtlcm5lbCBzb2NrZXRzLiIpDQo+IEZpeGVzOiA4
YTY4MTczNjkxZjAzNjYxICgibmV0OiBza19jbG9uZV9sb2NrKCkgc2hvdWxkIG9ubHkgZG8gZ2V0
X25ldCgpIGlmIHRoZSBwYXJlbnQgaXMgbm90IGEga2VybmVsIHNvY2tldCIpDQo+IFNpZ25lZC1v
ZmYtYnk6IFRldHN1byBIYW5kYSA8cGVuZ3Vpbi1rZXJuZWxASS1sb3ZlLlNBS1VSQS5uZS5qcD4N
Cj4gVGVzdGVkLWJ5OiBzeXpib3QgPHN5emJvdCs2OTQxMjBlMTAwMmMxMTc3NDdlZEBzeXprYWxs
ZXIuYXBwc3BvdG1haWwuY29tPg0KPiAtLS0NCj4gQ2hhbmdlcyBpbiB2MjoNCj4gIEFkZCBGaXhl
czogdGFnLg0KPiAgTW92ZSB0byBpbnNpZGUgbG9ja19zb2NrKCkgc2VjdGlvbi4NCj4gDQo+IEkg
Y2hvc2UgMjZhYmUxNDM3OWY4ZTJmYSBhbmQgOGE2ODE3MzY5MWYwMzY2MSB3aGljaCB3ZW50IHRv
IDQuMiBmb3IgRml4ZXM6IHRhZywNCj4gZm9yIHJlZmNvdW50IHdhcyBpbXBsaWNpdGx5IHRha2Vu
IHdoZW4gNzAwNDEwODhlM2I5NzY2MiAoIlJEUzogQWRkIFRDUCB0cmFuc3BvcnQNCj4gdG8gUkRT
Iikgd2FzIGFkZGVkIHRvIDIuNi4zMi4NCj4gDQo+IG5ldC9yZHMvdGNwLmMgfCA4ICsrKysrKysr
DQo+IDEgZmlsZSBjaGFuZ2VkLCA4IGluc2VydGlvbnMoKykNCj4gDQo+IGRpZmYgLS1naXQgYS9u
ZXQvcmRzL3RjcC5jIGIvbmV0L3Jkcy90Y3AuYw0KPiBpbmRleCA1MzI3ZDEzMGM0YjUuLjJmNjM4
ZjhiN2IxZSAxMDA2NDQNCj4gLS0tIGEvbmV0L3Jkcy90Y3AuYw0KPiArKysgYi9uZXQvcmRzL3Rj
cC5jDQo+IEBAIC00OTUsNiArNDk1LDE0IEBAIHZvaWQgcmRzX3RjcF90dW5lKHN0cnVjdCBzb2Nr
ZXQgKnNvY2spDQo+IA0KPiAJdGNwX3NvY2tfc2V0X25vZGVsYXkoc29jay0+c2spOw0KPiAJbG9j
a19zb2NrKHNrKTsNCj4gKwkvKiBUQ1AgdGltZXIgZnVuY3Rpb25zIG1pZ2h0IGFjY2VzcyBuZXQg
bmFtZXNwYWNlIGV2ZW4gYWZ0ZXINCj4gKwkgKiBhIHByb2Nlc3Mgd2hpY2ggY3JlYXRlZCB0aGlz
IG5ldCBuYW1lc3BhY2UgdGVybWluYXRlZC4NCj4gKwkgKi8NCj4gKwlpZiAoIXNrLT5za19uZXRf
cmVmY250KSB7DQo+ICsJCXNrLT5za19uZXRfcmVmY250ID0gMTsNCj4gKwkJZ2V0X25ldF90cmFj
ayhuZXQsICZzay0+bnNfdHJhY2tlciwgR0ZQX0tFUk5FTCk7DQoNCkRvbid0IHlvdSBuZWVkIGEg
Y29ycmVzcG9uZGluZyBwdXRfbmV0X3RyYWNrKCk/DQoNCg0KVGh4cywgSMOla29uDQoNCg0KPiAr
CQlzb2NrX2ludXNlX2FkZChuZXQsIDEpOw0KPiArCX0NCj4gCWlmIChydG4tPnNuZGJ1Zl9zaXpl
ID4gMCkgew0KPiAJCXNrLT5za19zbmRidWYgPSBydG4tPnNuZGJ1Zl9zaXplOw0KPiAJCXNrLT5z
a191c2VybG9ja3MgfD0gU09DS19TTkRCVUZfTE9DSzsNCj4gLS0gDQo+IDIuMzQuMQ0KPiANCj4g
DQoNCg==
