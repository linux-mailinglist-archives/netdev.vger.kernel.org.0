Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99122502C14
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 16:43:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354640AbiDOOp1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 10:45:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354601AbiDOOp0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 10:45:26 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-centralusazon11021014.outbound.protection.outlook.com [52.101.62.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B6E74476A;
        Fri, 15 Apr 2022 07:42:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dU+oGgKPed1ELr43gT2SMyTsdXS6Oo5d8BsG0szBf8ZFt4aR/uBBqqcK9LDdlQG1ScjGsm+52OasX+Uf13Pqr9RqmEk6a7G4LJ5BmB9IJO6u90tpNgCNmHPKFmA09+Sgbxp5SxPPugvA1AJZqeQMEKuLDk1mCTH9AvrsUaDGt1YtAkUV23kpopquSJdM2u+yv0YqrsXtdjbFa11ybCht/86i5bzDIBWhWwCYIcmVisfhc6SqRUVPL1ELHv7fFSw9JbTzkbmlsY2u9MsOc2A7FZaoOyHefdmQd0+jrzofkw9qJTE+jkXJaxewMqaaeqNIeszcYyDRVMOVCn4WWEiVdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9YapCafICZL0nUoddUMofulRReXA1vYs1snepQkbvUI=;
 b=PvsrzmDq49M0vTZ7kWti0rhs3Ao6xl/jymIR0sUTMqJfwkGwmqXuYC1hFB2O+EPiuZ8GAckgvdXVp60Bi7XkJA47BkxUZ9IbDeAYGAJfvRelC6g8OMwdUIqXooQuv/UBbdbzOC1UnUFgRbGg98rnoHt0DmpZCTnYs/i21qnWnL2EFZNYLsttNYApuzEH37VorifiIoBildCwBf4wLwctfsa5WffCmlccnmcvt/LT+Hiagc1v705Fn8pwGvnZZ6CqhEQnWaTN248eDXisCYl1ja1oJ/ziXAclLGhX2ElnYDqcnIcFEddVbBhBoNJdSlEUPQbqwzbfSBnrw9xgynAzpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9YapCafICZL0nUoddUMofulRReXA1vYs1snepQkbvUI=;
 b=CTHsMZ/0qGJnuVqNBiwxCadEdFw1+8o+puEMfAq1MwuPDHEiShjLJlCTypAmk/ZW/X9+wjjHVcxYTk2w/dnVz4UKPBQVv5pLJC2P4Os7NjQGfF6EbOqszlnf/eFQFHVPvVsUYdyqLaP6fFbgL9Y1Ym+ibbtUIECJWJ2Y8PqlaZY=
Received: from PH0PR21MB3025.namprd21.prod.outlook.com (2603:10b6:510:d2::21)
 by LV2PR21MB3350.namprd21.prod.outlook.com (2603:10b6:408:14e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.6; Fri, 15 Apr
 2022 14:27:38 +0000
Received: from PH0PR21MB3025.namprd21.prod.outlook.com
 ([fe80::ac09:6e1b:de72:2b2f]) by PH0PR21MB3025.namprd21.prod.outlook.com
 ([fe80::ac09:6e1b:de72:2b2f%9]) with mapi id 15.20.5186.010; Fri, 15 Apr 2022
 14:27:38 +0000
From:   "Michael Kelley (LINUX)" <mikelley@microsoft.com>
To:     Andrea Parri <parri.andrea@gmail.com>
CC:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [RFC PATCH 1/6] hv_sock: Check hv_pkt_iter_first_raw()'s return
 value
Thread-Topic: [RFC PATCH 1/6] hv_sock: Check hv_pkt_iter_first_raw()'s return
 value
Thread-Index: AQHYT3fFI5IGSfWvX0SxiF7md4+Se6zvlcGQgADzAICAAIEKsA==
Date:   Fri, 15 Apr 2022 14:27:37 +0000
Message-ID: <PH0PR21MB3025F31739A0480F66639ACAD7EE9@PH0PR21MB3025.namprd21.prod.outlook.com>
References: <20220413204742.5539-1-parri.andrea@gmail.com>
 <20220413204742.5539-2-parri.andrea@gmail.com>
 <PH0PR21MB3025FA1943D74A31E47B7F8FD7EE9@PH0PR21MB3025.namprd21.prod.outlook.com>
 <20220415064133.GA2961@anparri>
In-Reply-To: <20220415064133.GA2961@anparri>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=bb8a42da-3d9c-4fd7-af98-95b6f67f39f4;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-04-15T14:23:23Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: edb51455-e429-4035-ac72-08da1eec1765
x-ms-traffictypediagnostic: LV2PR21MB3350:EE_
x-ms-exchange-atpmessageproperties: SA|SL
x-microsoft-antispam-prvs: <LV2PR21MB335073F4C56C89D1553BC15FD7EE9@LV2PR21MB3350.namprd21.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VTnEBjU1uytnZ0b9FolZjyTci1afw8BMra7BvDyDgRVxJpY2L+sBEzb1cktM5Vry7dCazSqkj3/B/y4a3ghrn2RCmOOyjxR55xGU+J/gRUDRf1yFGO6LOa/sweSiWvfof1aCO/fkwugd/5EbOEjg2WDw86tGrWjcTLBlwBr8V54cIQO6GLJ0vm2kUC8/0LjaSU+fuTotx/t2MD9UtJ20a6DHY4UUUOaqDjpNcI+GHIHM6JKPoQg3pwkXKWv4bV9RK+V67AHCLJhrdkYVzlw5tN6qyk76uW+FXwfWKvAAUTtU4tlQtbVjIC8/TDtO6GQj00NzU/sIXAuv2tBk6DhowWXR/ub2b2VjUxSsE7r4zbsfd7yMqgYih8/CVqF86QthMv2bw3e68pnvO1QeyuJRwILuvchIjn3aB9ljugcxq8Mvp+3couVBcFpAjzfpYLGn0k0npAnlDsFmblvjylxcNz1i0abHfg/kduIaC0wXAaTpt3QPb57UPYJHy/LfHlayFMJltt2mLcps3DPe6wsa9t+bI8fhgJ15f3z7rh1Rl0vOcn9e8IhZpOXwRTM9qXcE1irxp3iHnKKb0mFqZ1v+swdw3gibp6lRsvgWiD/TT1cXiU6H0zGt883kAXa4KvB8br20WzsiAFG2HaKeYyGGu85tp+gY1g2Ss1JS0XZfS6UF0/xkQ1bMNdOHwBT+8ctLBiyhVWp6eQfCDDuYJAbrKnOEcWkDPorAaQpuey5QXyIJpEGtb6YCzMZ94400frif
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR21MB3025.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(451199009)(10290500003)(86362001)(122000001)(71200400001)(6916009)(54906003)(52536014)(508600001)(316002)(8676002)(66556008)(64756008)(5660300002)(76116006)(66476007)(66446008)(66946007)(55016003)(7416002)(82960400001)(82950400001)(8936002)(4326008)(33656002)(38100700002)(186003)(9686003)(8990500004)(26005)(7696005)(6506007)(38070700005)(2906002)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?0hr/BbkbpZvBeQvpLg/yRNLALze1uZYznVHqhAfmHqt/l2Bjnoy8vuJJ+xgx?=
 =?us-ascii?Q?SBGgb4vLwboSK0AgU9xhRmkcbEhClodufcZeZ2J2ZkoQRpNTrZyZuUt1rUlh?=
 =?us-ascii?Q?fhJHuToq9/FB36GmOMeji3xWHg1+9GgnaP/hht6o2P8Z9mEIxK63Lm6cGFKp?=
 =?us-ascii?Q?0MJKPW2OHOP6EswK/VsaW4xF5ZB82+jwvRGDLiI9Z/rS4yXhHJ3ZZjrFMmAl?=
 =?us-ascii?Q?0szgPyXrCQFEVZnUBbHOzdzWDb0fWUGxe7EnfwSCljjdE+dwC2Qk5+S5l+WD?=
 =?us-ascii?Q?nV+doX6YzKPtD0+MR3kF7X+YdhzgG9kkWD2gXgV0wfGi8zqsbiB1WvpwZYAp?=
 =?us-ascii?Q?GngE6BgnABa01I4HdHhHLrkcvvxvj9dr1wA3p3vbKimjfFV+MFXDlsx+Zic6?=
 =?us-ascii?Q?G4hwI/327xTU4LB/gmhkNjCN4hK2bCOplZVb6vlyur+nZXQ14oDkSQvfVcUO?=
 =?us-ascii?Q?qPkChE+7jp8swLmcfLX23VTJJ/4RKU7YufyqieM/kbR5ibH0hRn7HPLE1EEF?=
 =?us-ascii?Q?Ak54ocJZrU0IIFym5QZogWXfyJBywylgeBbMQ8KHy3A6GN/L/76hxYE0xIxo?=
 =?us-ascii?Q?B4+V1/DcKR6m3AkRbkIwm9whATD9sDKV64D/qtL0xTj2W1e4VWMGbBUSOyY/?=
 =?us-ascii?Q?j22ODF5jURmTaYIgzlp10YfeZAbuCokEVCN7AG38ZHWyADCopmIfHUkB7wYO?=
 =?us-ascii?Q?vXEN4hZT6I0ParYeW+z0Y92wP2zBxOeBPsCU+aks2qM4rqMnytsWpIC+zmLq?=
 =?us-ascii?Q?fiZWE2jyRpETSeU73yGmAjvZneg+7L/ezYOepMaA7oyhGoNXtmJH4wFoAv8S?=
 =?us-ascii?Q?3IoWq94lWOS4HqUjLRWQSb1S/MUG/DYPiV2el4CVV0YZ/bcNAD3U3LAnVXU9?=
 =?us-ascii?Q?jI9ENL8T3fd+XpUBf0tNL489YAcOkwgK2LbToSAIn7DSgpJrJMNB7RZW/PNH?=
 =?us-ascii?Q?AChbOTRIsLCFPVQ/29LvTk7wyFShZxBIX228J4C4s34HJESAwIHO6ygO/COH?=
 =?us-ascii?Q?j4S3Yag02AVMi+i72uYU3b3m8jxNeJ/hbreDlxQhwaQ3WiJLhXVbQ5AenlwJ?=
 =?us-ascii?Q?GfgP5yLlcROfGapuxwBzXEPz6JwHjlykahLeB41p6BjwP6rBbX7ENd89I87y?=
 =?us-ascii?Q?0VEikjK0riVPBcbxkwEh9/qIrv1Xw6CPyM3h67uijfHXPLuB1A78Wu/WWwDR?=
 =?us-ascii?Q?ubWa2MIzC09NQmL+3YL3chWodIfUL/Nm/dCGJQzkeS72O5Z3FbIo/pFwU9pD?=
 =?us-ascii?Q?vlcOzyAu69AAIv1TMr4Z/mUXyIvL9aAJPIQKiiyF1WCcYSjBPkUjRTZU/J52?=
 =?us-ascii?Q?wKy/uBqhaZeqHv7lFQ+pkgOhfNYpnpLGSNk8wYVYUZdaQY0OzrS7NyrePW+x?=
 =?us-ascii?Q?1nV/GZm/3/z1PENyLSs7v1QNc5RpNEBZZUb8VCXpXTC1PMaoOn2o4C4KQCPy?=
 =?us-ascii?Q?8sJ/Nc3fDhY5Hk/leGAMfIhXLOIik5eVzzC4bKCdA8lC318eUpiyOYmdnH6U?=
 =?us-ascii?Q?EHrLIpPWIncV2cbeQjj9AkQltYJkPVyfK9Xk3DZS1nvh9NA6xjxOTD8uR+Rs?=
 =?us-ascii?Q?d2ZLAfq+QRef2qOdwbm4k8ucOTvfnpcgGPxEbhUHzCpKoGFE7izyIC8kVQKa?=
 =?us-ascii?Q?Q2pC/NUSKNodc5agvFynXuDhinrbDrKNMBEzFXl4To8aJzNihkTQKqWdQTAS?=
 =?us-ascii?Q?wHukXu57tlIAnLpZALaIQMjuIQeRH+qol1ZmOv7UNNoKajFUjWNlF8sodRQy?=
 =?us-ascii?Q?SerDVL2yyFzwKw5AMTSf2voc/odM4uI=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR21MB3025.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: edb51455-e429-4035-ac72-08da1eec1765
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Apr 2022 14:27:37.9600
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wtL2YJ6ktdD/yNaMLdLD4hm0o85viT8yNTVsFHUawx04Q+t6vepXezadqcFDgdIvp89/XDh2Qcqs1UULx/bWgfAbUGGCnZHcJvKN4UHLOmI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR21MB3350
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrea Parri <parri.andrea@gmail.com> Sent: Thursday, April 14, 2022 =
11:42 PM
>=20
> On Fri, Apr 15, 2022 at 03:33:23AM +0000, Michael Kelley (LINUX) wrote:
> > From: Andrea Parri (Microsoft) <parri.andrea@gmail.com> Sent: Wednesday=
, April 13,
> 2022 1:48 PM
> > >
> > > The function returns NULL if the ring buffer has no enough space
> > > available for a packet descriptor.  The ring buffer's write_index
> >
> > The first sentence wording is a bit scrambled.  I think you mean the
> > ring buffer doesn't contain enough readable bytes to constitute a
> > packet descriptor.
>=20
> Indeed, replaced with your working.
>=20
>=20
> > > is in memory which is shared with the Hyper-V host, its value is
> > > thus subject to being changed at any time.
> >
> > This second sentence is true, but I'm not making the connection
> > with the code change below.   Evidently, there is some previous
> > check made to ensure that enough bytes are available to be
> > received when hvs_stream_dequeue() is called, so we assumed that
> > NULL could never be returned?  I looked but didn't find such a check,
> > so maybe I didn't look carefully enough.  But now we are assuming
> > that Hyper-V might have invalidated that previous check by
> > subsequently changing the write_index in a bogus way?  So now, NULL
> > could be returned when previously we assumed it couldn't.
>=20
> I think you're looking for hvs_stream_has_data().  (Previous checks
> apart, hvs_stream_dequeue() will "dereference" the pointer so...)

Agreed.  I didn't say this explicitly, but I was wondering about the risk
in the current code (without these hardening patches) of getting a
NULL pointer from hv_pkt_iter_first_raw(), and then dereferencing it.

Michael



