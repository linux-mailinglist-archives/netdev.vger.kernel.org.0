Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5381690F0C
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 18:20:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229537AbjBIRUO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 12:20:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbjBIRUN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 12:20:13 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84B1E658F2
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 09:20:12 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 319BO1Ki014280;
        Thu, 9 Feb 2023 15:43:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=vv7QJdxmMQpxc2g8vpdb8kLz6X6qAzum5NQQXQp0X+M=;
 b=TFWDMoUAgeqU7MD/VmwG3iFLgjwITTeArb1nTawS7IV5EUu3rNNuAwYBw5Sp1pJIq++e
 95dzUXlny2DSkxvbog16UA6/mGf4DSfvdC+lCbexoHxBHRkjIaAp+Z1eKsMUASZYc2XT
 UKWPd4tHUjGEl2nQ9/Gj4g8Vgc9VoQ5fzqwowFBaGGNUcKYTNn3wZEXUIybFV4GO3T9X
 KvGmYOjMVt74+5p1KUVW+fJKlrtNITJXsXHefO6SJGXOwsjLU7bRnX4rboIvV/FDyPdI
 7e2nRabxWtc0Un/L6Jw8RcXgHfclTmW4tNl+ouHexyJzP0S26EZxqytomRZqg3umpJ4s mQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nhfdck3qq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Feb 2023 15:43:08 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 319FItmI036138;
        Thu, 9 Feb 2023 15:43:08 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2109.outbound.protection.outlook.com [104.47.70.109])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3nhdtf9rk4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Feb 2023 15:43:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dPEMc0nsuYR2lL+cyzdE9HfMiN1qfEhYahQGCZoUsIggOuzoG7ZTV+958n5BIcMphWhu234nJtzKHi3HT8UfFnwJAgGnTC4qYxD4v9IlMCH2LZMuyWMv2pM3UMN/Ec3Yg2T25PfVWr5tnXysMuMxiRmL05TgU32hpe4yTShfDBwF4Ee9mzHY7A6zHhWSk4s8s+fikZ7ayEiDJmEZWB1SJ3z9VJQTQ4WhQSdvTJ1zjeUJkMTYj4q/I/LqQfh9tL1lXCSrqIhMB2iWeP1Auu9GVqfB3rPvqmty9I/YWhxnYqnIsL0WJjzccs6F6TONtvi60Xi5kzwKa0CsxIMtjejQyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vv7QJdxmMQpxc2g8vpdb8kLz6X6qAzum5NQQXQp0X+M=;
 b=X5MmLtyVs6s84jFpHxDs2osMlNXrgGF+3KqVFSnUk9Zt/UF9qVxU/a7ZMoTd7A57zZrKOk+XVbT4+GrS6JwtI7OiwS5mA41vVbalFg/+4jAH06hcx9WtoMPP2qB2+OFB6YCi2FpilslS6Ccd50hSlzfuQ4aSpy+7zo5AdPYIScURZckFKn3R6jDeOuQqU126C/S7n44xf/sBk8f05j1dhgdsocfjvxVErJbEQcVzHwfXgIax97ulZau2fDHcNaPRIjfELx69OLNTz8ngx5mwqKQWxPw+clH3Nv/f+y/ZmHPcfe+4kDReAfsNNNaBewxZ18jAhS9LnsOw5yQgD3B6Uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vv7QJdxmMQpxc2g8vpdb8kLz6X6qAzum5NQQXQp0X+M=;
 b=ykz1zO1zSwsQhY7qW7vTj/cClL31/GNBukSVv15i1yBZGVo2exMqPOKqqwiIbFaez5Iv16cYdeg5sLuh4JZ6AyL450l3jiOM8RTtsD+fM78iSXDC+uMz04LbuvjzEBw5g+ErVOX6OKCO/Rk/Tj9WBgwlxu8IXXvhnYFX6zlh83k=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by SJ0PR10MB4704.namprd10.prod.outlook.com (2603:10b6:a03:2db::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.19; Thu, 9 Feb
 2023 15:43:06 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::5c2f:5e81:b6c4:a127]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::5c2f:5e81:b6c4:a127%6]) with mapi id 15.20.6086.017; Thu, 9 Feb 2023
 15:43:06 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        "hare@suse.com" <hare@suse.com>,
        David Howells <dhowells@redhat.com>,
        Benjamin Coddington <bcodding@redhat.com>,
        Olga Kornievskaia <kolga@netapp.com>,
        "jmeneghi@redhat.com" <jmeneghi@redhat.com>
Subject: Re: [PATCH v3 1/2] net/handshake: Create a NETLINK service for
 handling handshake requests
Thread-Topic: [PATCH v3 1/2] net/handshake: Create a NETLINK service for
 handling handshake requests
Thread-Index: AQHZPEvN++FMdi3fdkGdZmQw8wcosK7Gwc0A
Date:   Thu, 9 Feb 2023 15:43:06 +0000
Message-ID: <5D62859B-76AD-431C-AC93-C42A32EC2B69@oracle.com>
References: <167580444939.5328.5412964147692077675.stgit@91.116.238.104.host.secureserver.net>
 <167580607317.5328.2575913180270613320.stgit@91.116.238.104.host.secureserver.net>
 <20230208220025.0c3e6591@kernel.org>
In-Reply-To: <20230208220025.0c3e6591@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.2)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|SJ0PR10MB4704:EE_
x-ms-office365-filtering-correlation-id: 161b8e6d-c10f-4eac-9d8d-08db0ab4565b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: y0I7SyoVN/0ASt++53I8hW5NYacgVE223D/m+5bjAPGuDnJy3U/5PtZDXjhLO+bVGdmpwZK3krLigTp4BX5sPOPgRTFi3LR6VhZSnnTZM88a0mUd3NFUBfCo00iI/bYxLxl1pLKj1/oUDa0PDAWbTo+dX7mXTx7C24uyLOo9Hi+hkM/Qd7AuBMO9ZdFvA227qGKiU2C+Nz5ZBcmer100htqnlgS3YEJxMWvFCs+/RSTIFE2crypHKkeDD0t2GbGAvhuSpxslbxQvj7jYHrVwUIQ+ym6wkqhhxN0oOu21Dbl23WmanXh1Eude1iAbiVSxoFNhakJGnnT0MHgZztSMzwKTlCkhZ1Wrho1I7OQ1YSrfRxLVTXGauMfC8G2kChJEwZMNWX61QIv6Ls6b3A44Ftb8jdo8GEBoGCgbEnY9QI5r2Duakt12id7+q/kkC5QYeUOKPLqhVZl7eLrnf/n0JXk8H4NvXN+VYnz3s+aDs/0+/SouM4WUn8f6JIcX9KWts+y5iS8mRxPRD0rI27oBrEH21297lGjA9VoLjGaaoOqUb+BBwSxTYptY5liV1cPnd2roGifMs3zQnM38OS/y98YmdXesMSOVLQLjzUnOdg7KKGP0/1zXMnc5Qx0KvNMU36bGYEZrgF/6uHM1GlQT19MU8Muz2R8PCRjJFQpl06lwBcqsYsZZTVODP9UwAdsknEYjMAB0VCY4D2xQQyCxC2phLaI8LrJca7/5FBlvCCI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(346002)(376002)(396003)(366004)(39860400002)(451199018)(122000001)(38070700005)(186003)(26005)(38100700002)(6512007)(2906002)(4744005)(41300700001)(86362001)(6506007)(5660300002)(8936002)(53546011)(8676002)(2616005)(76116006)(4326008)(6916009)(66946007)(66446008)(64756008)(66556008)(66476007)(33656002)(83380400001)(54906003)(316002)(91956017)(6486002)(478600001)(36756003)(71200400001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?k5UqXD+GpiEk8BZAaI8VhO7NoyLdPITFMz5u6takPm9hhSRvc7CjDzF2Jy5E?=
 =?us-ascii?Q?aQDl5yL8/TNfE0+Jt+EM8TZo8LF99vrxj+EutXt/5e76LORAx59uIcATr+Ou?=
 =?us-ascii?Q?JlLQ4r1YqbvXZDwJDITekySOvkvUjiJsQv2qk/9f5NX+rcI9sNeYkD5pgeCJ?=
 =?us-ascii?Q?b2MTste14eq21RIHVP6ioI53SngIIf2MQankKyA55JinCKYuEXvHBgZDwJ4u?=
 =?us-ascii?Q?Yqc4XdnF/VP8KVvv/8mvM/aXl61DO8MWuhj1doUB4gTg/UHtM/gElEYjjNOX?=
 =?us-ascii?Q?LSn3gPn+xftlNVVHjSdQO/AsAenGtN19gtO1VY5kk/07zz5/0wmMAc4uu48q?=
 =?us-ascii?Q?HyM0b4jD3drxdrYkxyswadt56TPGmznqoCPTV8H0N0C/8glZkdAIAhHQSUB4?=
 =?us-ascii?Q?BZ9ffu0BFtv20BxstHMJy/CUghEE73+kaIAiAqcP9OKCy6Yi1oHoa2wAOT9S?=
 =?us-ascii?Q?r4Y+lW5l6mhDY3+DWHvjY5JkaCapBT2f1N3+IUIQIyQl2DPjTY19rn7PDvp5?=
 =?us-ascii?Q?7Flqyqu/Vqo4VlrVaFlUsFJnQkoaU5juBfc8/JfYYEQoDHWXH0uTkBEa7ep8?=
 =?us-ascii?Q?c6YVyiJuViRv7twEfd3XHFPqDXiLkrKSgyw5iU8GqBVqswc+iPFaf2zuhtpP?=
 =?us-ascii?Q?5XKTfcNMF/F/a7Tlk5l/WIW7gYf/rK4crqvX5Y45ndLoPypqzgcoZulA7XBk?=
 =?us-ascii?Q?LwMKR4mf93jKGghA6WeoUhQ1RIsP+9xsOaaIx2ALH6FrFC4mrDduDBZ0e5zA?=
 =?us-ascii?Q?6EJ4wvcbTtgFurHePx12+RqxXpXoqoLxGkxRqbqSEb1htccPL/HAo0gTy5CO?=
 =?us-ascii?Q?2Lq0dLFlyI05yAWWvOo27FLbii9XfSI0EJ1L9rGNELsL3+KR5YyP3HvtdvPT?=
 =?us-ascii?Q?53fge+NZ031a2HYMlWDC/tbrqRAt6SohRL1zIjGTvZq5275y+Ji06o+1GBIu?=
 =?us-ascii?Q?/CVnX+l58NvkcaOEfnZ0wXOlkdgfwCyJILExJ/x1Kc8E8R+cqyzbIRg3zSVu?=
 =?us-ascii?Q?r4+1UpYVMAPD4ZGY2ie4oQWTXYU5uKNo/oVLclgBWlD+3gLERgMRifmspcwQ?=
 =?us-ascii?Q?bnRK/GJ7BMVZnhddG7NBjQD73dNDfKVhoNDZ86kMh5xmW9HG0ABJSpfLgrud?=
 =?us-ascii?Q?SAVG+mvskEKnwZ/8nqXiJO8fHQWtLfl38WxO2rI0LWIThQPXabCgIXh61/Je?=
 =?us-ascii?Q?qTzBm/Dx7Itfz1StAZiyii1EsTIF3CS51cZR/fHXBkF5p5SNkkNwnpwuJxSC?=
 =?us-ascii?Q?ZO1tESSwLlC6vAIbz5XcTGFlzIVWluZzbcA7JO1EIrevs+zHsK7NnztQtk9Q?=
 =?us-ascii?Q?FfgoQuvRCrlhJzGkvJQ0bhtCyKC9VkpLwGfMaVADavV6BZWDq21CuCEXTVyO?=
 =?us-ascii?Q?zlrKIem5nXBOIymtixkikjSzQUmQud3Rh9irbNWtKTYJk0n0SnjfI1eq9f71?=
 =?us-ascii?Q?ZcC7zwUwiMN0z6dDzNjDSe56LITW0OtcrU8TOrXus4v+r08Ki0mqRuCxAkGU?=
 =?us-ascii?Q?HtiOJnXFpORVbO5ov1LERf2pf1us+JZhYL9Tl5HMmZoleX9MjvjJq04TUQpO?=
 =?us-ascii?Q?eIDNArUe20Tc56XeUB87nt+hN6XS2au5oKyijQ3oUhCokUESILWy9B785loc?=
 =?us-ascii?Q?0w=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <AD220E8AC8EF4E428CA401292B5B1F26@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: MIEnlmeeQLxa68VbBDeXvnn+bt1vpH6NNRAxQzPUcpCveJT4VCGxbR4FZrTtQ7eNxuLgr3ieeyw3OaKHLYOngBeOiswdnBudBhGT01vuPY9L7NfHU/D6+lFFaJZMerHXnb7K6QWFZLGqFNuRbnxB40YBOORjyxnPvPzp2A02qWJ1Ov9xIbTM0x/1rKABDc43mYp3XEjoAoIICgsmf6QqG+7EEsIw1wWsI3Tugf2+hrel+O0BN4EJKjYiLRbRgpTdsg/8PTMuZacUrGf4+jya4C98sZSSQEzLX6zK+9s7gGUwwfAbbKRkd0pcn7jcYWahgdParePkR4SfPZSZk6uqFYNCx5rpERwQ+5ItBtID7HXGglS89Yw7NzjnuQjG4iLr6Z2pQaoevlzxFG0jhDcmaFXWCQyGkPOQ/hGQH0a9gRtUqdp9AE8ShtxTnHkszkdHWdXYleJPgWohs+LzhzK/tefT3zjvwDCrAeAAF5y95erd6j+0PZJlJtvtl4r1FLrHwtr0oKdnzwOhZYi9OMWQ2xlp2eOtxdFDteEARF19pS8qe7HrJl8p5kQUyoXxP3E3O6V3LzLjyheEyWnfjTCICAGjOfVlXnB/tjOnEkzlafEf01dq2iawb/fBDBfnE6Gl2wGEDIWBoHUjN5KkfCZwVVie/eryYZ9lnKpL6dnl4I/6DQPwXrxSaWWQrpmjUNhCrfH+QTpoIf4ejF34FH2ZgjVELQk4mYx5q8QHzn806/Fewc/yX+MIfREXfKL1UQ+2X5fLZAfDAJTTRptfVTMrSkLzJBlgVrJ6g3w6tT+Dw531SGHb2/rmD0nUq0zdaEHXDq/8FeekiNtqvcIGYSWuL3dWSCOybILUY3FKe/QDdHYkaerpVUJ2VOdA2CiXljYRzEsGqdmUGHQHKcMlv7cGKg==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 161b8e6d-c10f-4eac-9d8d-08db0ab4565b
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2023 15:43:06.2136
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WSCttlEVY7cCIdiWjNIMjnLzahU0BKZam/lj59P1YtPo6SPtP2SOzw7Oy2E2ktjpsHHFx+w6M8de+9UknRuQDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4704
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-09_11,2023-02-09_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 adultscore=0
 malwarescore=0 mlxscore=0 phishscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302090149
X-Proofpoint-GUID: r1hj01jG3ZglduUBy1CDbwYRZexX7J4w
X-Proofpoint-ORIG-GUID: r1hj01jG3ZglduUBy1CDbwYRZexX7J4w
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> On Feb 9, 2023, at 1:00 AM, Jakub Kicinski <kuba@kernel.org> wrote:
>=20
> On Tue, 07 Feb 2023 16:41:13 -0500 Chuck Lever wrote:
>> diff --git a/tools/include/uapi/linux/netlink.h b/tools/include/uapi/lin=
ux/netlink.h
>> index 0a4d73317759..a269d356f358 100644
>> --- a/tools/include/uapi/linux/netlink.h
>> +++ b/tools/include/uapi/linux/netlink.h
>> @@ -29,6 +29,7 @@
>> #define NETLINK_RDMA		20
>> #define NETLINK_CRYPTO		21	/* Crypto layer */
>> #define NETLINK_SMC		22	/* SMC monitoring */
>> +#define NETLINK_HANDSHAKE	23	/* transport layer sec handshake requests =
*/
>=20
> The extra indirection of genetlink introduces some complications?

I don't think it does, necessarily. But neither does it seem
to add any value (for this use case). <shrug>


--
Chuck Lever



