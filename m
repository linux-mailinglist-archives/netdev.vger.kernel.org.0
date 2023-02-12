Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7998C69390E
	for <lists+netdev@lfdr.de>; Sun, 12 Feb 2023 18:25:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbjBLRY6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Feb 2023 12:24:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbjBLRY4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Feb 2023 12:24:56 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C9C910A9C
        for <netdev@vger.kernel.org>; Sun, 12 Feb 2023 09:24:55 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31C5XqhM003515;
        Sun, 12 Feb 2023 17:24:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=7EPnR/sqA+fXr/Enr8a9/BYphTx0ApSsluEplnOc2d0=;
 b=s/aeMHzUptgVfiYgc3AowIjspu9ehjsA1GjKJ1lsGkC8H3jrjvQMKp4H82+OWlRfmhgA
 xfRmkZr54U9TL1msQIfNskM4pScODLI/eS7YG55vu8S/Mx4R7sbJFoA9vo435znk/3Xi
 6YPJcyudACRc3XxYjkXcWodX9yPBiyhSphjAG3bGqrZldwHMkTE1sqgdVR2GTFx9KjrW
 kKvSmSTy11rQNQoBmkso0kF2axahinz7xObupxecW/OKRsY+vjpHHvlPrZepMzlhffoE
 WPnp2vygU3u4GnPpuXJlbwsiF25k1PLr4jvEmWWuZCrF+i5vlYZMhR2XkWop6NMceFdt jw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3np1t39fgj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 12 Feb 2023 17:24:36 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31CG0a9h028867;
        Sun, 12 Feb 2023 17:24:35 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2102.outbound.protection.outlook.com [104.47.70.102])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3np1f30k5n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 12 Feb 2023 17:24:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B41JRN2JKUXIzqUb4QVpyK0a4QkYFDB3QhDHHPfywWQTxylcCbZ+fqEqDsejtJ4+PdmvMjir3boli115J8kQWba77zggZDJuhi7Q1XZX0eU7sGecMCdUmsC2+rFmq/6gmERGAHHZLiAB3+pOIbsH/98e0tUJks+cy2nclh4j1pFn5INebhcjM17pr+47AY0rxjVPq+fKPSEVfXM0lBPEi9Hbxn3H3Ik0dmx9zAJk46jnwgv/2vRWE0jYrHcchHep785SYnHBr4D2ba2ELfowNRv93QA83h2Qt3hiSMdumMjMCkIaHLNdAvEWnExIfaRe7X6E63fNbDlXTWznc1AZJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7EPnR/sqA+fXr/Enr8a9/BYphTx0ApSsluEplnOc2d0=;
 b=m7sYK9SB4sTUDHYmO/QFEia5uhyCvuEw+bfKaR9caFYraFOjItlNIXBbqCafDa8wRMdYYFgY5Vqqe3yQ4xoAkQwIwLywoXUMSjZfQZoYOKNwk7Y3G4WQNUcJKURkpFB2DE6A6obxw5SityR7NeJnAYfewz9dimQB7Fccz2oR3E53dulsBo2JdBkddZZucy8KsZteRAQz4LWQIGo9UYM/zR1kmdfBrYg1vMzNHVu7CAtyVs3USdF1caTxW7AWxTNADX8UxZ9TpfkfX6QeRaQ8wetdUsjhG3YPmKOEfhFSg70qMQD7ioUYQJ3jOybU8VKM6DYT7f2FwI/FDpZWceQ/rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7EPnR/sqA+fXr/Enr8a9/BYphTx0ApSsluEplnOc2d0=;
 b=HAnPJGuBIhBGqCo4c4m3KPXj8WSzJLXQYNHE0TyhqjanLcQlE4uEa98TNBJXAQo0LN0n63NJGxd7OFY4sF/I0PETZApAvno+UuCgYfC38HaqS15OZi0OU9OT9IkIH0XkJxIDJRoz+dGYesDRE86QB1Sa8hWAahbf788jfYhK6eM=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by BL3PR10MB6113.namprd10.prod.outlook.com (2603:10b6:208:3b8::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.9; Sun, 12 Feb
 2023 17:24:28 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::5c2f:5e81:b6c4:a127]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::5c2f:5e81:b6c4:a127%6]) with mapi id 15.20.6111.009; Sun, 12 Feb 2023
 17:24:28 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
CC:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        "hare@suse.com" <hare@suse.com>,
        David Howells <dhowells@redhat.com>,
        Benjamin Coddington <bcodding@redhat.com>,
        Olga Kornievskaia <kolga@netapp.com>,
        "jmeneghi@redhat.com" <jmeneghi@redhat.com>,
        Boris Pismenny <borisp@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: Re: [PATCH v3 1/2] net/handshake: Create a NETLINK service for
 handling handshake requests
Thread-Topic: [PATCH v3 1/2] net/handshake: Create a NETLINK service for
 handling handshake requests
Thread-Index: AQHZPEvN++FMdi3fdkGdZmQw8wcosK7Gwc0AgAAFWQCAAAknAIAEp7CAgAAdIoA=
Date:   Sun, 12 Feb 2023 17:24:28 +0000
Message-ID: <1DE06BB1-6BA9-4DB4-B2AA-07DE532963D6@oracle.com>
References: <167580444939.5328.5412964147692077675.stgit@91.116.238.104.host.secureserver.net>
 <167580607317.5328.2575913180270613320.stgit@91.116.238.104.host.secureserver.net>
 <20230208220025.0c3e6591@kernel.org>
 <5D62859B-76AD-431C-AC93-C42A32EC2B69@oracle.com>
 <a793b8ae257e87fd58e6849f3529f3b886b68262.camel@redhat.com>
 <1A3363FD-16A1-4A4B-AB30-DD56AFA5FFB0@oracle.com>
 <CAM0EoMm4KF=Q22D71gELYYZ2eo-s=Gkvovhe+YBSVQ39VmQRDQ@mail.gmail.com>
In-Reply-To: <CAM0EoMm4KF=Q22D71gELYYZ2eo-s=Gkvovhe+YBSVQ39VmQRDQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.2)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|BL3PR10MB6113:EE_
x-ms-office365-filtering-correlation-id: 9e68befa-d062-41f5-33e4-08db0d1dfeee
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: H8jRSkXgPKUoWS9JdLflndbjc+5rpRDfxScmIPh9y+UmvClgjRphqtK4FxGZAmGlJrbElwaHO0zr/5mGd6eUbePvtOz41zma53NfA6UTt5tyl8rN9PyyFuRH3M8fToSPGSaYK95GmR60TlUbXeZtdxmjLPeaowkfqnafqLvQRow8LCj4jofzmgvZJfeJS12t0TkAmTH45P9VVofydluWDL6d1HkezT3cP3OoCu1f3GRxiO125DEL3Kz7/9rdGU8bAmHD2Nh0Ho0OhK6D2+M0SfulGcgxLMwwm/KyOxLKh2q0+aPUVfhrMDKF6Zt0ZPLWUG1G1dH33cf1ztMToTw4J5yQH/iZIubt2kvZLm1/hhg736kUF57xoWteNtYEOtsJucqxc9HwukBMnhcs2vnwGYm9SVcy9Y0effY54ATw0/QsdZ2YzO5WbzHmromCTIrFteLVKJLNlOM9Beim86xPVWi+gxaAo7FzjZ3iFj9EMGKGSy95xiwHU679lo3YxkDaEQLAibkMFk6j0osV20OXhg0DjOHkEPhoJVahFIxJpG/PJuz3k3Lyi8H7nLPu2TtQa80oMTECGbaqp16ptnr7RVBnXUF2oLiYfM6+fKUKnToMeSbWyN5+yGEST9I42rWvllkWJW1oxWDzn/MUXBiPCCI+TrJaZWwsbyfmIqsTxTqc+bSOZAnQwGD47UciQ2lxUV8sgI5/Lzgjr0lE/1yvecBwF0aU9Z58uw70akpQTn8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(136003)(396003)(346002)(39860400002)(376002)(451199018)(36756003)(86362001)(38070700005)(38100700002)(7416002)(8936002)(2906002)(122000001)(4326008)(6916009)(5660300002)(41300700001)(8676002)(76116006)(66476007)(66556008)(66946007)(66446008)(64756008)(2616005)(91956017)(33656002)(83380400001)(54906003)(316002)(53546011)(6506007)(26005)(186003)(6512007)(71200400001)(6486002)(478600001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?lnfYwoQZzBH1YZYcTutXT6yt8+PxP2lRwROlbaVVMkIXM0/OPabtkEBM3SdE?=
 =?us-ascii?Q?jgLV8tF7yUrA4R3XZxRIk3Salc+Ni/YWJNLA3WpPFhFBv2ktfY2CoeiJLKVv?=
 =?us-ascii?Q?wJS+Rqf2EGEuHBW0VrGTb5WsCvBZLTvzjz/iB5DEmEl9o2ddqiBXI/ygsv9X?=
 =?us-ascii?Q?nERcJ3bfmuDr+A7VkrQrnDvuuH4gUNS6nsc3XX+czNwz7hqORosWoFE/thbj?=
 =?us-ascii?Q?0pS2k0E/95WIdREcIAXAgVcyt/BpvZZ/E2vSdOvmzP0AEoXYIcxC8J78ylmT?=
 =?us-ascii?Q?BaXoKgfqSKd2OmMNsgMECvQfoo2KgTno3Pws2WnUV5E4F8xdyqs/uan/ynzK?=
 =?us-ascii?Q?wEFuQagfs5SkttLJrPFGSyBfwtDpimAzeWjFVi6z2pglEw9M7X+zV4aN1jKO?=
 =?us-ascii?Q?nC4mhYvNUVK2hpNJSePFoK5jSnY/BRUuM5bzA/Dx8dpCWpdF3fX4t9gZwiEq?=
 =?us-ascii?Q?WvUULEG3rwBcI1/s3byvGmtWXjYJFgzsU9ed4MTI0dN4OK3n3ybnIRAXYOnS?=
 =?us-ascii?Q?aMyST0hKDdv6Vc3BK5PkQQIhd1N8ov9OveD0PCo+GsWRnaiMGIvpDIG2ucmv?=
 =?us-ascii?Q?UQP0qIaabApYme1DW3U8HiT7/Xm4wD+CP9yHv5qqp6IMlcqzd637g4srH1Hm?=
 =?us-ascii?Q?x1LiU6Cs+rDAkj4utshW5ac5V1LCOUWyZkWWTNK78sca31KJG7eXefpZ5kmq?=
 =?us-ascii?Q?Oy3PdFB+NXncsl+LR3dcuMwGZ62n9NkLXq/2T5W+mwWj9HBgzetMvACHWARg?=
 =?us-ascii?Q?X68oHw24U4068W8D4SM4tSNB+eIQYQLMSxT89g8zQJ1yhIs74mQp/Na2oWLz?=
 =?us-ascii?Q?JPBGs2TDUKYuWl88+zljQPcTvJ9n0kldoFiICERdsC+5BJAKax5ZWmznNPpQ?=
 =?us-ascii?Q?awt7AQcEa22O2JJI63lb/p8N45t5+OF1H7z643EwF7o8VTjAeBz/OUBPPIHE?=
 =?us-ascii?Q?rCC98lf637vCNBjJN6ARflexui8nyKZ7GKxzmRhTSzPXyaaaVPG0/SVYZF/U?=
 =?us-ascii?Q?fWN5XzyNJUqpZyJ9QWo1q1pGBm10rzrmjWEdAdpe4EL4zu6hk8BaFvcnUdzj?=
 =?us-ascii?Q?0S2YgI7IZk/dZAEVPxtgBxOGpO3qvVVbHMBoPjBJrkSR3zW/bczWSt0batf2?=
 =?us-ascii?Q?LNnSua+R6esMEwtG4yn5HhpS90YFibKSNtAoTv2wT8WYyRHMzPGLDDVZvr8I?=
 =?us-ascii?Q?lIHyG4pygnemwZ7fpU/ynqcLqbh319c2Vg/mlGrB/f+RTnFa9UYTKxBwd4gg?=
 =?us-ascii?Q?6LQ2DPYuorkhar5Qsmj5FRiSQrhN4YYF3lHr5k5OeP/Cx5jXHdT6s628r8Dg?=
 =?us-ascii?Q?YWOsPiUfMOg6bvvF9juJjZWOKPBYbn5sMIEFX/BdFnPexXhSdUtg0mKnhcms?=
 =?us-ascii?Q?PeY5JZImb10HyiJ295I7Y6nWkE809r2/DmdxQKgaXzaZddmc2vCTE0twIMpB?=
 =?us-ascii?Q?uP9jUxtBchowsBvOKm+yVpL0ZsRquvaJigGV4ty7TLBqhttU8uZ8RbVJvaab?=
 =?us-ascii?Q?69MfDLCQKjMrdfkcYFajWJaGFkfpW1v1znFLmSV+v9uAMSLvGGi+8VOpKDo+?=
 =?us-ascii?Q?ZSXhj4yZRSKwSuLn31yZz55ozmnSlgetKnXzaebcoxI/b4k+H7AacXSbL/wi?=
 =?us-ascii?Q?6w=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5C34770F8076804FB9DB639954D10A40@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?ho4BlzGotZWYlDff+0WCu/JU4nyh8IdnAvYhfFewOQ+SR/7kF8+db5VFCwpz?=
 =?us-ascii?Q?jfIBQfquvH4m94Do1ts0r0ejOyMPkg+iXj6jGY1AWEurWD04XwFVUKjflaIN?=
 =?us-ascii?Q?ak1yn5vHZZo4YRkOdgFKZINZF4pltCHs+JKMBK+r9t49XFANNW/4d4sqDFX8?=
 =?us-ascii?Q?G4MWD3FkKYkBkjQEpYjC6QsJa8MZFiJZh16+N2koP6F4YsL9YhFkWEJemCZm?=
 =?us-ascii?Q?AacgsDRrljgxEWjdEAQ3hBJbprUEALFQM7w4Yv3isH+VmReNky1ghnLutEut?=
 =?us-ascii?Q?jwBE0m5EiV3ArX6AaLDn0Z+XbPAm+4VT+7jjlUUIQbpUhcXQwkJ+KrMhi7u3?=
 =?us-ascii?Q?ICv2cnuayuSPk5KM0ROlZfUqQlnGbcgAqWEBZ08Mhxng7nEps5NKFy/jMEeO?=
 =?us-ascii?Q?+hTUI19nm14LH3XQfp0L5W/txhWtckJ0TeXfkVaQq7iP3FdfYrh9TwihtQoV?=
 =?us-ascii?Q?gKvzc2dsWzdr9XqtD3GA4KF8A1AkpGdlFtZaAq7HvSxg2XlHrAhWNYw3+U72?=
 =?us-ascii?Q?/Wb3rG+5qtjsVCLdaJhm5yXAW3dPUEx11ZjOLBlyNEYcj6D4TefklqdzvKVR?=
 =?us-ascii?Q?V4CS8cdAO3qIzmVcITMVtciFo9qVcfocUsfb5inPhl4/vwl7/B4LmTHyAS15?=
 =?us-ascii?Q?x750fPgQkmp/+2V67PyL9PLyvTH9EgL9EuSuziQIQiEoCt8ccC14HXt21/Ct?=
 =?us-ascii?Q?gtzb/XwLfZgKPNvRBKNUsZRFEWBaLdtTG0nAI8MTEvXIwzUydUYY2/5oZ/F0?=
 =?us-ascii?Q?ae1wfjlIHMw0OxZQmfcXTgeuJzSGU/ToaqfNrIK93FV4nRdnwiKBK0TSO2VW?=
 =?us-ascii?Q?aZhg9fxI9c13d+eqnXRVSumOY5re9JLzkBDDqOWyLXg7bredgBwzRedE+Cno?=
 =?us-ascii?Q?YQ2VJAah/rrY5TZyvoO+xGfKEx/J0wLbKAS3jP6oAVQT2/gINpKoMGphYdiz?=
 =?us-ascii?Q?Z2sOfXH+QvMxqQpV0Lbmfg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e68befa-d062-41f5-33e4-08db0d1dfeee
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Feb 2023 17:24:28.4981
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: m0ek/Uv4TrrZBoypO/oBrEkQOJvmc9Q+Gs2hkGcZyisj0jCmBEaYQIECaEh70nd1IB7FNvPBsEeBrmUjpq4e2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6113
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-12_07,2023-02-09_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302120157
X-Proofpoint-GUID: 2wGuS_Tuvfw6EjwKKlnrQWy2CyC6cSGs
X-Proofpoint-ORIG-GUID: 2wGuS_Tuvfw6EjwKKlnrQWy2CyC6cSGs
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Jamal-

> On Feb 12, 2023, at 10:40 AM, Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>=20
> On Thu, Feb 9, 2023 at 11:36 AM Chuck Lever III <chuck.lever@oracle.com> =
wrote:
>>=20
>>=20
>>=20
>>> On Feb 9, 2023, at 11:02 AM, Paolo Abeni <pabeni@redhat.com> wrote:
>=20
> [..]
>=20
>>> IIRC the previous version allowed the user-space to create a socket of
>>> the HANDSHAKE family which in turn accept()ed tcp sockets. That kind of
>>> construct - assuming I interpreted it correctly - did not sound right
>>> to me.
>>>=20
>>> Back to these patches, they looks sane to me, even if the whole
>>> architecture is a bit hard to follow, given the non trivial cross
>>> references between the patches - I can likely have missed some relevant
>>> point.
>>=20
>> One of the original goals was to support other security protocols
>> besides TLS v1.3, which is why the code is split between two
>> patches. I know that is cumbersome for some review workflows.
>>=20
>> Now is a good time to simplify, if we see a sensible opportunity
>> to do so.
>>=20
>>=20
>>> I'm wondering if this approach scales well enough with the number of
>>> concurrent handshakes: the single list looks like a potential bottle-
>>> neck.
>>=20
>> It's not clear how much scaling is needed. I don't have a strong
>> sense of how frequently a busy storage server will need a handshake,
>> for instance, but it seems like it would be relatively less frequent
>> than, say, I/O. Network storage connections are typically long-lived,
>> unlike http.
>>=20
>=20
> So this is for storage type traffic only? Assuming TCP/NVME probably.
> IOW, is it worth doing the handshake via the kernel for a short flow?
> We have done some analysis and TLS handshake certainly affects overall
> performance, so moving it into the kernel is a good idea. Question is
> how would this interact with a) KTLS b) KTLS offload c) user space
> type of crypto needs like quic, etc?

I believe a summary of this thread is due.

---

This is for any in-kernel transport security layer consumer.
It is expressly not for the purpose of adding a handshake
facility that can be used directly by user space consumers.

Today we have several in-kernel consumers ready to use it,
including SunRPC-with-TLS, NVMe/TCP with TLS, and SMB with
QUIC (that one is less far along because the Linux kernel
doesn't have a QUIC implementation yet).

They all happen to be storage-related, but I believe that
is coincidental. It is possible that once transport layer
security is easily available to kernel consumers, other
usage scenarios will appear.

But networked storage connections are, on average, long-
lived. We believe that session set-up overhead for such
consumers will not be as significant as the increased
latency and compute resources used by the security layer's
record protocols.

---

We would prefer an in-kernel handshake implementation, and
for TLSv1.3 in particular, we believe everything is already
available in-kernel (ciphers, certificate management, and so
on) except for the TLS handshake protocol engine. So maybe
not a heavy lift technically, especially because the TLSv1.3
handshake subprotocol is simpler than the ones in past
versions.

We know of at least one out-of-tree in-kernel handshake
implementation, so it's definitely feasible. The purpose of
that implementation is scalable handshake performance for
user space consumers (like web front ends) so what you say
about potential better performance is certainly plausible.
But it's not the purpose of what I'm doing here.

---

Most pertinently, however, the kernel security folks have
stated that an in-kernel handshake is out of the question
because it would be yet another handshake implementation to
maintain and keep secure. They greatly prefer that these
kinds of things be done in user space using a well-vetted
library implementation.

As an example, our upcall TLSv1.3 handshake prototype has
chosen to use GnuTLS. Once the prototype handshake mechanism
has established a TLS session, the user space library
configures kTLS on the kernel's socket. Thus, our prototype
enables in-kernel TLS consumers to take advantage of both
software ciphers and NIC offload today via kTLS (thanks to
Boris and his team).

---

Lastly, there are potentially other transport security layer
protocols aside from TLSv1.3 that will need similar treatment.
Jakub is working on one now, I believe.

I would expect an uphill battle for getting each one of those
added to the kernel.

---

So the solution we have derived is an upcall mechanism that
will be at least a stop-gap, but may become a longer-term
solution depending on the politics of getting handshake
protocol implementations into kernel space. I believe that
activity is also ongoing for TLSv1.3 at least, but it seems
to me like a more distant solution.

We have immediate cloud provider demand for both the RPC and
NVMe usage scenarios with TLSv1.3, and the SMB service in
Azure implements QUIC on Windows (which re-uses TLSv1.3's
handshake protocol). Thus I'd like to see a handshake
facility made available as soon as we can muster a sensible
one.


--
Chuck Lever



