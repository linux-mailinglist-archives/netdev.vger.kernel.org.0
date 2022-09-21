Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 062AE5BF5F6
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 07:42:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbiIUFme (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 01:42:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbiIUFmd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 01:42:33 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFD465A144
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 22:42:32 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28KJXUoC019588;
        Tue, 20 Sep 2022 22:42:25 -0700
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3jqksa9w9g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Sep 2022 22:42:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RAoUzzgvwu9A21+17aDic5B0c4sZv9lj2evu+81zQuV2y8M+mExqQTd8Wy17vKZDcKYL6ctjwp0P5qJmLhB703RQpTmcTmMwxgjX2wwaCkcffNhy4pf1k7u0ozzrTMjKBKfT+2vjJ/KXQvrMLlbUbqPUwpW8ZjaUGPN+zfzRtw7g+nShL9psUOklK4eerWb0ARWsGOleQAZoKh7I3+RlhOGXc0I16hqNALdhXTja8Dbd0Td1Jn7kfF3zQ0buogjVbWK5rnxJBfNdZZANUaEUrdc8206cZmqH3hTJ1YbM0d3PClnph7mUP34yAF8zLKiqpbo7XfBq8reNyT865x5D9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zYmN2QCSm7I/fJcKUOVS73vusXkci2ylD2199elTkQ8=;
 b=VGCxMd1W5YonDJ/egmIKHaCyzV8bNOduA38FYU+MfDJeObdRydujMNxedxp3OeZb3behR8q1CjJEk9AkJbnPvk8eBbyB+oGTdAC/QYblxH8slRlcLZNyIf2EJ2Mx74oTZSdjqqmUr+aiGG3XeC5LDTy3fnJppDv5vazaNBLElGavzia9/YgpwwoqGSgPse6ol1UXoHi0lIhPN3e553ZteacvHLuESHctkExCrdIOv3BXr6O57WWM1TEYvIidzY1JbVcX4UVkNHLAsk06RgQ2JsyMsd7mFbON6d0fXbAUeH9vkiNpP9IcsKWWCZQRTGBexfJwpzVjtSku9ZQJSd0lkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zYmN2QCSm7I/fJcKUOVS73vusXkci2ylD2199elTkQ8=;
 b=kKgHnBVeRz00ur0pmj+2GNvKSMuWKd9dmeu+aRntzq8E1S2X5JvY53/hPoQRyw9PXk7sJ1d1yYiQOk2ifKfraq2v7Uspzj1wYpHZ67YWGSjtJrcLKJdIlqcuCbrijnZ6uszHtZpP2IBKgPVOGLb0EYKISTzOlRtknNyiCL5cXa0=
Received: from DM5PR1801MB1883.namprd18.prod.outlook.com (2603:10b6:4:62::23)
 by SA9PR18MB3776.namprd18.prod.outlook.com (2603:10b6:806:1d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.16; Wed, 21 Sep
 2022 05:42:23 +0000
Received: from DM5PR1801MB1883.namprd18.prod.outlook.com
 ([fe80::866d:e19c:c2c2:80a8]) by DM5PR1801MB1883.namprd18.prod.outlook.com
 ([fe80::866d:e19c:c2c2:80a8%3]) with mapi id 15.20.5654.014; Wed, 21 Sep 2022
 05:42:22 +0000
From:   Bharat Bhushan <bbhushan2@marvell.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [EXT] Re: Are xfrm state_add/delete() calls serialized?
Thread-Topic: [EXT] Re: Are xfrm state_add/delete() calls serialized?
Thread-Index: AdjGub/fR70yQVpJTS+eN+GwmjB17wFUJ+KAAFxKz8A=
Date:   Wed, 21 Sep 2022 05:42:22 +0000
Message-ID: <DM5PR1801MB18836F4BB4032F8654A35BD2E34F9@DM5PR1801MB1883.namprd18.prod.outlook.com>
References: <DM5PR1801MB1883E2826A037070B2DD6608E3449@DM5PR1801MB1883.namprd18.prod.outlook.com>
 <Yyg2kYNeGxWSCvC4@unreal>
In-Reply-To: <Yyg2kYNeGxWSCvC4@unreal>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR1801MB1883:EE_|SA9PR18MB3776:EE_
x-ms-office365-filtering-correlation-id: f393ccc2-cd3c-4a70-1d9a-08da9b940e87
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: W9ITfKrwJ8qM+xg5lizZNdl3NID7ZIpkzUrukiK5tLasXNAco5rSMwU1o6hQiaPDTWr7T3OAh4UKnCxuQ2ULpY3UGK4wF4RtshKYPf2RiiLhZvqjOdR54yV1UwvxLo+6uBo3AIZs1IDwhx3EgD4KA4UU9Or1OIP9RhS0CbhOVavtawH2QbukK2YGk748snM2wrS5y0tX/ZTxNUn3IUj30JjddgKf8SZjmpIG/PA1w6xWmpfKrKZsOANGHPMMMm/xvXo9MhZR+/t25Izt6iwTbVLr5/GuZYVihQLDdPiSDtICh0CXE1OYULgC2HRF7LR7VPnl9k15B/TUEOIGjIJrIp0jL30CeunqArDxhRm66tj75CJ1qiZlToKLX3g4G9E4T4S8Z+8yY4FHUatXEZefaWhRy+ZEETmyruJihc0Oz9Fo1EHReDJpWnl04lZ9pymS6h7BAmn9fYZw//W/Uhy1z5B/zOXcF5462QTtXLYRbyBeuG+Bq2L+aNX0A2dc+uBhG7mnOMLy4nLqslcwLKikjQrOmTmF/4fQpHWXGxAj7uiIAGEjLd+0XVShX/ACHAojeNrISReeqF6azE/MO9lSi/9YUnzXpQN/Ber1ij+U26ojjjbGoYCoWi8MMjUVZ0j3aiCytbYTk1ps+awdu6C3dk1g8g1L1USLC3ZNdSvP7iIo+mY97nby5tfrzWfBX1G7dHVjRfeW13+Mvoh/TXo6lzlpcjdH66EKZFoZb7JFzd72mF+CPcV7ODsHgnFfi8SRvE0Na8pUt+hYVccQsSbRvg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1801MB1883.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(376002)(39860400002)(346002)(136003)(396003)(451199015)(122000001)(38100700002)(38070700005)(33656002)(2906002)(478600001)(71200400001)(6916009)(8676002)(8936002)(66946007)(66476007)(66556008)(64756008)(66446008)(4326008)(76116006)(316002)(52536014)(5660300002)(9686003)(26005)(55016003)(41300700001)(53546011)(6506007)(7696005)(83380400001)(186003)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?szVaKjLWysEDa5jYTs6tCHaJyvaeCKbB6UxhqbVyhqARv1E0KuKjA1xoVJXd?=
 =?us-ascii?Q?a5j7SacEFhz/apOzyfv+R1tUezdWFMLcqiqmfZpMw+4LHs6QEWbF7pjYdsEO?=
 =?us-ascii?Q?v6JUVcOATxeJ2bI1bUuuvbfImEi5OEUpmBP+8p3fdl92wrOjqC5W+375p4sT?=
 =?us-ascii?Q?DeXPz0W+OAD5+Mn6V1b0pimVfEJYdbpVficQ5LyNY4Xb6TRsu9JK25sBj/L/?=
 =?us-ascii?Q?Ac0Go3s9rNovhycq4mS7LqxMzo0Joo41Gnw6NmSB5NnHM0aXxOPR1+UAyHwX?=
 =?us-ascii?Q?Uquc6u6asGTVelxgeKKkFzpb4RsRyFTHaVfTrfGEXYqhmBGpGxluEKOidtEo?=
 =?us-ascii?Q?Jz2c5Y4l3CJVIOv0a+K/7tSpD+7tW/SIaSpLD4RDtaTcJIpfhW4WQY9y3N3f?=
 =?us-ascii?Q?K8kQh2fwzVpsK665tQeL9N/9clRjUyRVOY613ll/7jRlPxdthFwkZi6iGV07?=
 =?us-ascii?Q?SHRZNM1xQeBmt4LLlLBnEVOxvLFP1J2ikRdbEQ4meVk7g9VhLiWpWpnpO1EC?=
 =?us-ascii?Q?qrisiz3VGes5tQY17UnqMRjfRUktYYPQMwUMwaCvmpO4XnAm8mawcVhieB5j?=
 =?us-ascii?Q?hOat4iqdKzJrJwPO8gcx5javIMRowYehCSzTuhhr+QLhcFfzTTY/vYEz5nWV?=
 =?us-ascii?Q?cegTzVFrPcAsLW7j1XpZCAOWp4tbbKOZwTR7bOJ/aVNtveNX4Lkhjlj6J2UW?=
 =?us-ascii?Q?MD949g8HuNwgQ18NEbsF5WiRnIeh6ga/zLWZ5MNcYuRNalWFZKpgcfO06F5E?=
 =?us-ascii?Q?ObAA9LprDFrWl6S75c/bjiUHpw/Q5OADd9dNWchgH7MIO6sIYkDylzrzZMFK?=
 =?us-ascii?Q?nGKajes2ptBQKY42NYbDLCIG538eqv8A0rrTtv0xEtPPVQfKrjEKx9FXgAR2?=
 =?us-ascii?Q?7dnr4tJuYK9p7SzBxtimWx4kDfqBehQEGWW94XdW83mW2NGSOC07NcFH+EUw?=
 =?us-ascii?Q?0A2RqEgcdth9I0IR4nd18FiiJIx6QOPz3/aHtN29YV5TeB7/XpZpCSL9bGkI?=
 =?us-ascii?Q?EGww+n/dkwaI79mRFxBvsb6USHkCjhif2wDfOST5qgLA4fMR18XxhrjSon9J?=
 =?us-ascii?Q?VdhMsBJu957X0lXt0RsvhH7jvoHXKPR63ZanmruLzTWoUh/VDRzpJpBC1C/t?=
 =?us-ascii?Q?bpVdl+MAuk15FI0cgoFCrlzCVCW8XgSiigwnvYFtZKYk3PvoVg4NxBMYZgtH?=
 =?us-ascii?Q?wBcgiLMA9pwPu7ouZA8LpwW0vYB1TJVv4K1iNa77Pf5LhYC5j5Syn/Cy/+UL?=
 =?us-ascii?Q?8Oz3aASSpFOX30KGbrta3AhzPgc+MfNKXeBWVMVe4ZXKTVvVE6i5rquUfXij?=
 =?us-ascii?Q?HE4BS+55/kXm3OJ9gUECSF+Br6NkCV0HIA2eovdw6Mtam5QCGr6HPXH6qslz?=
 =?us-ascii?Q?fjCpz1FcRbWnVgr1HNNwvwSKmPtuRttjW5Czbs3YdijFFvKPKiagdOkCUWJH?=
 =?us-ascii?Q?Bd5ZPet3ZRDZi7jYJa2KhQ+pKo5Yy5CV44s0mSAhbYEkwf+tcXorrToyQ8ks?=
 =?us-ascii?Q?f9ZZYRC9emKT+IWymjqGTYhH53qd0Gh/5uNrvSEjLSfeO3V2+jx3+rvMRTVs?=
 =?us-ascii?Q?HPD+opPXKm/JpCd8FRSu0XPUTahzNtmoBaJTpmON?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1801MB1883.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f393ccc2-cd3c-4a70-1d9a-08da9b940e87
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Sep 2022 05:42:22.7078
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0jsg5aV7EYtUan96GS/aa9YBneyCsBRRvrTu2zAjTq4PkHG4YYG2b01T1CcpJk8gg0xMB4W8IRxKZfTBqR3Dmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA9PR18MB3776
X-Proofpoint-GUID: ftBu32vbdKFJgdY8fBmgEQLm25hu2KWV
X-Proofpoint-ORIG-GUID: ftBu32vbdKFJgdY8fBmgEQLm25hu2KWV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-21_02,2022-09-20_02,2022-06-22_01
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please see inline=20

> -----Original Message-----
> From: Leon Romanovsky <leon@kernel.org>
> Sent: Monday, September 19, 2022 3:00 PM
> To: Bharat Bhushan <bbhushan2@marvell.com>
> Cc: netdev@vger.kernel.org
> Subject: [EXT] Re: Are xfrm state_add/delete() calls serialized?
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> On Mon, Sep 12, 2022 at 03:10:12PM +0000, Bharat Bhushan wrote:
> > Hi All,
> >
> > Have a very basic query related to .xdo_dev_state_add()/delete() ops
> supported by netdev driver. Can .xdo_dev_state_add()/delete() execute fro=
m
> other core while already in process of handling .xdo_dev_state_add()/dele=
te()
> on one core? Or these calls are always serialized by stack?
>=20
> It is protected from userspace callers with xfrm_cfg_mutex in xfrm_netlin=
k_rcv().

So all *_state_add() and _state_delete() are serialized from user.

> However, stack triggered deletion can be in parallel. There is a lock for=
 that
> specific SA that is going to be deleted, and it is not global.

Just want to confirm m understanding, xfrm_state->lock is used by stack (ex=
ample xfrm_timer_handler()) for deletion, but this lock is per SA (not glob=
al).
So _state_delete() of different SA can happen in parallel and also _state_d=
elete() by stack can run in parallel to state addition from user.

Thanks
-Bharat

>=20
> > Wanted to know if we need proper locking while handling these ops in dr=
iver.
> >
> > Thanks
> > -Bharat
