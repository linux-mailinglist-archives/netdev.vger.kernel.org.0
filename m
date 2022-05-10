Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29E05520F51
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 10:01:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237691AbiEJIFN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 04:05:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235701AbiEJIFL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 04:05:11 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2054.outbound.protection.outlook.com [40.107.21.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1EAF27154;
        Tue, 10 May 2022 01:01:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kWZFk7q0EJL4FBPJuhqDUW0GsMotki/vYb5trantBxGtNHSlej3oX7JK/aWsNAtea8FChdsoPIgoHlc6G5F8PRAGT+fj4QxRUF06f0RxbX2d6cQsa1DgXQEKSd6UN4hDSo7lujv+HxKGepkO4ZGBl+4+pO0zAGrzWFIsOWb5GyOpDcX2I9oVRtZFtgfm4C/m/Vu4YW0THVO1MTlhjSEPVQiCJzUkys4xi0lMPYYrSOZZUZ/dxpPMOJgqTV1D7cOAZPmLMCvcIrk7JR/K8BRGxRgBCezqVDH8OfexAzV643a0wD9iC5o40cbt3eOun7P88uoyBkLmrwN3aKetSZ1Lzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=irmghXwUcEGZT2RaCJUif28z8Bm89JpgqyhRZxDBJz4=;
 b=MNgW9mvov/pwJdUMfAg2KBOGEXYt0jfto8AbF+7B9YEuDHAQpyfJx4TkC1u6p+ERsX0vo5AOeiUN6mJIMkis14kzs6zJFbEkqjz/+dOvZ4953tniLdLmFkHOI+lBMsh/DUSUDMZ1yMSaNZN5vg9ogPO1HNGlB8c5MEJokv4tU6Bg45qFkVgBFsMsorw5u3dPURP7x3TtqZqjPbNEXSA1xKPL7sswQxdGo2QNRAScCJbsZLPLeI1GdqRQRzD9m3RAvXAn2fBz/rrQqBptZVvBg7DBGMbv8/Un29thrhCcPTSiYuGkZ8ySTPlW6GrtQ5EqWKolsGeEpU/m/FygxwWY0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=technica-engineering.de; dmarc=pass action=none
 header.from=technica-engineering.de; dkim=pass
 header.d=technica-engineering.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=technica-engineering.de; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=irmghXwUcEGZT2RaCJUif28z8Bm89JpgqyhRZxDBJz4=;
 b=doBb2ySLdVYYcVTk4JX9mShJs6i8Cu3S+K2FNwKAqVq2y95FRf0WlmxARhlRqj8nPwOu5Cj6ia0PrTjE/mdZIxEOy6ynbwCf5G0cikPTOQuNZNAnnfQtX0bJwpRbTKlrkJrylaWsaSizGf2PD30GmsGN2qcGhFBIhwX7OOri2nY=
Received: from AM9PR08MB6788.eurprd08.prod.outlook.com (2603:10a6:20b:30d::24)
 by AS8PR08MB6757.eurprd08.prod.outlook.com (2603:10a6:20b:39e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.21; Tue, 10 May
 2022 08:01:07 +0000
Received: from AM9PR08MB6788.eurprd08.prod.outlook.com
 ([fe80::8443:249b:921d:345a]) by AM9PR08MB6788.eurprd08.prod.outlook.com
 ([fe80::8443:249b:921d:345a%5]) with mapi id 15.20.5227.023; Tue, 10 May 2022
 08:01:07 +0000
From:   Carlos Fernandez <carlos.fernandez@technica-engineering.de>
To:     Paolo Abeni <pabeni@redhat.com>,
        Carlos Fernandez <carlos.escuin@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net v2] net: macsec: retrieve the XPN attributes before
 offloading
Thread-Topic: [PATCH net v2] net: macsec: retrieve the XPN attributes before
 offloading
Thread-Index: AQHYYTfXh/kHUW8MQEKwzGN89ZB7660Xt3SAgAANtKg=
Date:   Tue, 10 May 2022 08:01:07 +0000
Message-ID: <AM9PR08MB6788116C170D7127F77AC864DBC99@AM9PR08MB6788.eurprd08.prod.outlook.com>
References: <20220506105540.9868-1-carlos.fernandez@technica-engineering.de>
 <0b66ddcc8428231632e7e1050045b2c282dc92d7.camel@redhat.com>
In-Reply-To: <0b66ddcc8428231632e7e1050045b2c282dc92d7.camel@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: 7e036b78-4d82-93c5-310a-05d4b1189314
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=technica-engineering.de;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6d372d07-e359-4e72-2e26-08da325b3d47
x-ms-traffictypediagnostic: AS8PR08MB6757:EE_
x-microsoft-antispam-prvs: <AS8PR08MB6757A0F2B95217846B5B5C85DBC99@AS8PR08MB6757.eurprd08.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZzzqGWF7rOs1u2kKkjSfVdDZ80pVUyO/sfnj4Qu36PmwtvIPkyc+G2YkbdO3+uZIOtf9kkl0iJZyHTpq1Do8W2Py00hEPWkd2W8bWBVL46k0AdGG7JbuLFdQlA63rGM+PkWOlxHeLDAAjylL86kZMPiHCiQ83GE7sZXTYukwTw0AmopakrAMGpUEUctdIcIZoOPboaflpKeI2qnGPYB8JNS750BVBO6t2z20gPLxksnJ69dM9Hk0mO3YuwjyOkqxwFV1sJ2/vGPfFuwzNUA8lK6brxu3iEu/OEM/4Vf/oQSOPHKsNnmci83Rnnzs2w4r4MGpzOyaKfX6E/6Hiyj09fVTIH37YAIB/0DdtixoOhPsrLRrMIHQjOHG3jvX53ufbiPHw9m4i1ICFkutBNF+LEQQjWOmTHW/cc8W88AfYQVFnNVRVrIIDGiwWT5aEnRLY2uRrqdi3YUuhJoiPIjmbtRHu64h8BRET9KYcDlxTc6N5eFLyxfhx7vB0U4XZoNrymIGwaP6fyLBkn1pnNE2dxqt53UTHH5PvOtusz0uo/H0HOQ1wVMG1e4hyuqmM314hXrGHy9b1F2f2rSOKdhyHz5r6L4S8RgeUyUxDKBB6kq4klHyh5k+9KBZr79+/EMVBM8mEvp2SvJRb0aRJ2FrYDomUpY7c5cg+RUUTtlbcMPdcsGTEwI9uwfSu99vLL+Iw6wDUqW1ttLwZ1mYHenAkA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR08MB6788.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(55016003)(71200400001)(52536014)(33656002)(8676002)(66556008)(66946007)(64756008)(66446008)(66476007)(122000001)(91956017)(76116006)(110136005)(86362001)(316002)(9686003)(5660300002)(38100700002)(38070700005)(26005)(6506007)(53546011)(7696005)(186003)(2906002)(44832011)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?TR1VMRird4c/GssphRsUarDS79TsLskvdSp1HqeO3E3kJaz3t24bST95H4g2?=
 =?us-ascii?Q?LDmwm5vjV087UKDz1Tao1/h4VgzxLZ2uuBhAxpSk3i377eIFRVCpFFUQarpF?=
 =?us-ascii?Q?ZRp2FZm9mSkaUzifRKWJupk0lYCUi5yOejnJj6TAnikZ5yrBBa9UDNhB6+UC?=
 =?us-ascii?Q?ABP4jXYla+nI27ZplS3bac/rMBT0HcxbUm3nzgnK6sNi7DXf3tS8JwohVwb4?=
 =?us-ascii?Q?teNFocnfCnnF+n9klSgZ++TVyGdJNAPrSanUzHAbgSAY2eaoeXM+R1XjAHHX?=
 =?us-ascii?Q?aUMZPHUX8C2OYaAKXElS6wFh6b/NTGac5JGXemG4YAID0esUc+DzeEX8qMxU?=
 =?us-ascii?Q?wTRohCsgQmPXwhnCYCUhwy9uaillUlOuTurdqsXstmu7aq8clb1CFbzVqI/Z?=
 =?us-ascii?Q?pZvzKcQG3UHvlswu27EaZIM4FBlWJ4xZuBPKGXGbaALFUHzxWeqUAysHO4S5?=
 =?us-ascii?Q?ITW0K1uGeC/iGiNz9ybfvBwQzrYtBnsAGhMHdefwBzuelXCkahRluA7i6Obn?=
 =?us-ascii?Q?EduZAhs8iRJMy0GNAi97v4DGdeMykXeU84lFilbuG5CYhSK8D42fK5yPLz5k?=
 =?us-ascii?Q?IGUjdzjLT4Bzq73VAJqXuHLvj70xJM8Ab+prIxGOpf+gWi2sBd+MH1ghWWDH?=
 =?us-ascii?Q?oUXoegkfiy4kGR0+biJleVH6oSxpbAAn3JrS4U6zRMrGcqSHsuLUsWfe3YH4?=
 =?us-ascii?Q?NtxJqYY+siN34/3P5p1UDi5dkr7FB8h5CG63Rw79RpFCLfgr1+XuZK6od3hZ?=
 =?us-ascii?Q?wEkybj4Y9Ro72AZkLBdIBzVvwh+cTStXovcjr25uxOJFJEPrus0Io3WGAERy?=
 =?us-ascii?Q?jG9SkUhxlV88VjSAO0Ym+m1zhcCqDx9Ol/8sxuFu6CDIS9B391JqVLI7HgO2?=
 =?us-ascii?Q?xfn8S8Y1F1ZJkfxMxTQYTNt82h5EbG4wxB+qOT1uj84PVREXxENQdtcHgR23?=
 =?us-ascii?Q?ZOPCHMxQ7tpynai96VwfeJT03wc5L7sXAX88niyS9twK2bgFLzJ27qkl3uI1?=
 =?us-ascii?Q?5GLVJk1gpY7nJF/mMLAoQEgV6/FeV+qe9uOHXEPeKSX3tRl5K9coLTh6wodz?=
 =?us-ascii?Q?0MT6cldazjHEoSOzGdmjArXFJ56DadYer0UUMsqvTJIL6sp2FyafgVnPhSlu?=
 =?us-ascii?Q?sA1wpR42OtUakMZVI5tdzkZMczPOKnLCbgxZd1oz+5ZPyEESIXeC4ZEW5GVW?=
 =?us-ascii?Q?KZY6HZOovfnqx/0DexT1eWAIDnlf0jFJf3NcWGkoAt6FR1ta9OgV4OsKO5Xt?=
 =?us-ascii?Q?qEd+J2mjgWqjJz+8/bTPj9w0+u1MaoTG8lBL/VqxiwAeUEH1IYLVwAhcQb4n?=
 =?us-ascii?Q?WjZj/sT0h9VIqckmog2dO2ERZCTteHX2HQdp7H8kY8UQQHhTUqY0Ft3BRMoV?=
 =?us-ascii?Q?rQWFyShM57NSehS6/unCrsh/KkVeht5S/8pw3kY4y0OvI8NMwbU5gIUngtYZ?=
 =?us-ascii?Q?mtL4kLxGuysdZR5AylnemcKjemK9GotfyLrcA568X940qdcjAFlA3bN4c3vf?=
 =?us-ascii?Q?WQMVCMuIvReb4YjwMj3wFAz23toYMvyxcY1Mrre1yVgc4lhPdGfc8glWe2yd?=
 =?us-ascii?Q?AqbFIMZrGYbxd28WCZYOQpOiEBfqXV0+TopONTQHKbSCdrfv3sLVWFsFPNZB?=
 =?us-ascii?Q?IaX1uPQhj18nRi8c6n1oXaW4IjiTHIRGsD0zaTGdIphYUUh4MlMfIfnaJCH7?=
 =?us-ascii?Q?T3sm0AcQqonLeCNhc4gHWAaF+gBoMybK25BLE+GTij69SLIgkDEbyqhTFGqJ?=
 =?us-ascii?Q?o7Bd2HjEYGXo4NaeZ8PlJHHJw3eGzhHCpt7TFzqRl2FOS6UcbEUs?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: technica-engineering.de
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR08MB6788.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d372d07-e359-4e72-2e26-08da325b3d47
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 May 2022 08:01:07.7209
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 1f04372a-6892-44e3-8f58-03845e1a70c1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7ejDH1wIzi058hO9dtFQRPAvOir95SfC4S9z+r1G5ZzqKEFLG7LZosoFHhdZ3diOAk2RK66wY1VyVboA6IVmB51TtlVSW/qpfA4uhHBWyFWvueypGbxGCO+Da9vc2L+CaXNQ0Dh5TvsWTxuOP6ov0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB6757
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks Paolo,

I'll redo the patch and send it again.
About the changes between the previous patch, there're only changes on the =
description and format of the patch, but none on the code side, maybe refer=
encing them is irrelevant.

________________________________________
From: Paolo Abeni <pabeni@redhat.com>
Sent: Tuesday, May 10, 2022 9:09 AM
To: Carlos Fernandez; Carlos Fernandez; davem@davemloft.net; edumazet@googl=
e.com; kuba@kernel.org; netdev@vger.kernel.org; linux-kernel@vger.kernel.or=
g
Subject: Re: [PATCH net v2] net: macsec: retrieve the XPN attributes before=
 offloading

CAUTION: This email originated from outside of the organization. Do not cli=
ck links or open attachments unless you recognize the sender and know the c=
ontent is safe.

Hello,

On Fri, 2022-05-06 at 12:55 +0200, Carlos Fernandez wrote:
> When MACsec offloading is used with XPN, before mdo_add_rxsa
> and mdo_add_txsa functions are called, the key salt is not
> copied to the macsec context struct. Offloaded phys will need
> this data when performing offloading.
>
> Fix by copying salt and id to context struct before calling the
> offloading functions.
>
> Fixes: 48ef50fa866a ("macsec: Netlink support of XPN cipher suites")
>
> Signed-off-by: Carlos Fernandez <carlos.fernandez@technica-engineering.de=
>

I'm sorry for nit-picking, but you must avoid empty lines between the
the 'Fixes' and the 'Signed-off-by' tags (or any other tag).

Additionnaly you should include a summary of the changes WRT the
previous patch version, see e.g. commit cec16052d5a7.

The patch contents looks good, but it's better if you address the
above, thanks!

Paolo

