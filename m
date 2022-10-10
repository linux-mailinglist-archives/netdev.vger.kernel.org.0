Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30AD65F9F7A
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 15:34:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbiJJNeH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 09:34:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbiJJNeB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 09:34:01 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2089.outbound.protection.outlook.com [40.107.21.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F88F72B44;
        Mon, 10 Oct 2022 06:33:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fXIUGOVB8KTDRgES+82lPvKtRhYlUxeClTVzgel17/+Kb4cXjdgnnOQzz4hl44dap5ZFiO21kVfxBJw8MlEaLMY9n+ySjS/cUFLydMlhHJDHoCP4N/ezwI4dXdjvVO7B+K7UFmsBp7X8L01LH4l2jPgTjtxrsa4DjoX3T39Gp8PpAcIp8FK34xQsOpyz6kXtLlLiYeagJNAT2Z77/ZZUTosSnOUJ+EDJ9vWefQxYogBs2npOT7H0kPUE5x7GkJ2KtppIWiJp+V8aoN0EZrDH+s0OPKV59BOLoNIWL5ABOQhddE8E4JH9XteB7YWQV9TrEfJR6eaSHbswLBnaSMvW5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rvc2Fu8/1rf9ksu38ZWQjr+Ln2i5H73bLawRfNTWA6E=;
 b=kCmo8KYkhPtqOs5mqoveepWHlzTyz0PesKDx/mqECDPFfSij8zwrqRqmVVHfb2JDCjug4h8Tp9k1JQrbyQ+eb88M4t1LV06SVxVar/SDRS4t7n2kswaoVNipjHxX9C977uuJXIMGliCIwLIFBAndiXQkmBrERXKcjuHnxuok7VEIZOdaY3KQWJbtZOjeVij22gyWKzh9pvDQTwB+GwnRZX5nA6Cg/R4YzUoPPH6FCBDzc3zCbkMeWlno54BkypGdvH1u5xOF17tVwuqY4koA900K2hQCqk9G3kcfwVgxegW0+1+n64M/zEIiqHWEEp4h8VBkgxqZ5dGCAHB4T2Iwlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rvc2Fu8/1rf9ksu38ZWQjr+Ln2i5H73bLawRfNTWA6E=;
 b=TUh59nCPnLtuKmCxp3u4bRCd45aHeXcoIzrMN6hXaG2ntw+90KWF2VsTmUepnuacEsOUfQefkphi+8bjzrDeycDRxfuMKZUQmccEQm0GWlbNDXmfyaYySLGaJchyEraCPbyI3bSQ9/Qk5F+2VIMnM8BYnxncQQbf5+cneORT1xQ=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DU2PR04MB8808.eurprd04.prod.outlook.com (2603:10a6:10:2e3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.15; Mon, 10 Oct
 2022 13:33:55 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5709.015; Mon, 10 Oct 2022
 13:33:55 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Sasha Levin <sashal@kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH AUTOSEL 5.15 33/46] net/sched: taprio: taprio_dump and
 taprio_change are protected by rtnl_mutex
Thread-Topic: [PATCH AUTOSEL 5.15 33/46] net/sched: taprio: taprio_dump and
 taprio_change are protected by rtnl_mutex
Thread-Index: AQHY3C1mLcUASdgrrU+ah+y5EcGORq4HoYiA
Date:   Mon, 10 Oct 2022 13:33:55 +0000
Message-ID: <20221010133355.hev3wc3l7q2iof6k@skbuf>
References: <20221009221912.1217372-1-sashal@kernel.org>
 <20221009221912.1217372-33-sashal@kernel.org>
In-Reply-To: <20221009221912.1217372-33-sashal@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|DU2PR04MB8808:EE_
x-ms-office365-filtering-correlation-id: b66a5749-e112-491a-601e-08daaac41458
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 361SD397MV9ztyKyH85FJQnwBJan0IzbZDzYYXNI9D11F6abAzxDZ0/n0HPSg6AUvzwNgLef2eq4JKMhoctEK1CBdoDWcLHAGNUzI/87dFMfKOCzHY0yl2nZemt/boHjyvDec7ryPsLAqwfK4sb+wEvTynCF/x+Jn06kJivy17IuJN1g5oSnMHDR6EcGhMxvuqgOdTVtp6SD5nUVGXqgBY4JkhWI7uEMnArls80tEIe/xJhVvdkcI3tjQ6BrCABboNeYV2CxVyW2+LcZv9ezJUtD81FeKKEhmbzEk2R8rypEzDCp3cmLfXj3PpuuhNOH9z43JL0nLfllnNRSB0G6fuxiNwZ7i4u10V2LOvjEjN6jFmWYz/6QylKo/oKME/PRQBcVfB1R16tjCITX+AZ8362eOvy1Bbfki2OKqy+9hE6ElwIi578AM8RUjnI5glEiJ9ooTXrMG1kkzThEzTj/XWBZmoS+y5+OfZf0hWIuDiDsON27vtl7GRkevSeb40WBQBL7Weg74eXb7ZTit37IaegkS1BDBRsxl/ZS8MJlhqxzP1eWSyDLlTgv5qy3CSX+UFKet4nYrfiBGpHwHOamS9TZ1Pv/jEgtEIhcWNNprGd8hK3ZQf8f3Hxe4K1v7Ygtd45LP1YGSwpKIG+mL1SRydQap641L3kh7GTo4jfl7Z2yn1nGgGdPlrjLLCZxKUtUrAqRq0l0eb+1Kd6LZBObBQfbGf2yP7eJzTDyZO8ESyC/bdTP6IBPDkeDv5Glpqb8AIjddr/vf1OEWKtrkvtUgg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(376002)(396003)(346002)(366004)(39860400002)(136003)(451199015)(6506007)(26005)(38100700002)(122000001)(66556008)(316002)(86362001)(71200400001)(8676002)(66446008)(4326008)(64756008)(66946007)(76116006)(33716001)(66476007)(38070700005)(83380400001)(186003)(1076003)(478600001)(6486002)(2906002)(54906003)(6916009)(5660300002)(8936002)(7416002)(9686003)(41300700001)(4744005)(44832011)(6512007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?bIs+CbswiOAduKdWOMziwG9jHfa+UJe2Ca5uRYQnCeaWKH4D5bHAsScZxNcL?=
 =?us-ascii?Q?rjvf4aDh2qptNYJKIGuFVTVNVbr++J2k5kEUF4LpUFPSP4KbKiusJGS8rd1y?=
 =?us-ascii?Q?eGDzJ7HpbuLrZYgOZsGmc3YlQ4ec84+uXBXFxz+bKk8X+r/o/r4vmMFgV8K8?=
 =?us-ascii?Q?Zc9YOrTKbhBMS2Aa+Kupg4rFcjHAvd7SmSA7618rLeUZXeNzkL30l7qqmIJB?=
 =?us-ascii?Q?G4R7emahNX/NuO0ZDaeCDmrmg1XgzTs2CHhJ0Ibx5xAI2JBqySIYE2qefg6p?=
 =?us-ascii?Q?Wyd57okDaOmwGMMPLfptOZYnMmUpi1OKfwZDodhW4JgdXG2gYBmU5T0FIG/s?=
 =?us-ascii?Q?MRhpHbqKmNlVWJXDszpODR6jHNNTAaq9/3rC6bz3zQMZX6eH2ebXRDOXjGBv?=
 =?us-ascii?Q?GzloTebtpJfQv9mYcw6DurZVp61NcOpjsCL30ygu9VoOZDsbgJrqDwz1Cedq?=
 =?us-ascii?Q?kt1tWanVToD2DbNeP6cLj5zsg4KfvLLsYEGST4pakPmTGz10Velud+AjmqFh?=
 =?us-ascii?Q?0ubEniNdJsngD5/T5R+qM3xLe1JpDxzwSFMldTAaBtBfbukg+3epF7yOVrif?=
 =?us-ascii?Q?tmEGHPdjZF2PS2w6iwRBkyC5c/RE/zgQPAKUblB2Hv3ysN0rzAq4cq0RBwgp?=
 =?us-ascii?Q?vtjnU0mQSjI3jFxXyAlmwb69LBI9ciGjpnJj/qebLdv4/Y2hzaWutxCR8M2l?=
 =?us-ascii?Q?AbbymMpv9ub9cqOTUzUuH/gmHtfcKmPcXSdofwb8r1ykWnAyhkc0Oqgc4eS6?=
 =?us-ascii?Q?VC6uzf02582ysPKWOxRk42rfs7Y0mgZgEle7PIEcwwvO1+cByh9/JCN66Fpb?=
 =?us-ascii?Q?Fsag0he84sT5Zim3DDujP2pGb9sb7TeM+7Wc0+M1VGLdEqH10B8GxiD8GmxN?=
 =?us-ascii?Q?S+fGZkUyF5+Q57ugPinTXUk9f+8GI34F1ujzjbMWOirjoO3ieEc40GCuhxD5?=
 =?us-ascii?Q?85Ut0l94kw9Ucjw3nc7GuJL0uhkUJ0IiLhKYz8s7o6Rewd3cPr83mifyWKVW?=
 =?us-ascii?Q?4Btj0BBJYUSX1NKV+MFWLcq1jWS7/tUdNZDlNsgCOpkH+RsXxUyeQXl+12/5?=
 =?us-ascii?Q?jbU2+IprMjBEv9SM/A1y75BTuV3lWWRrlTINSAjY3r4ufAYXz4XW59MU1G3W?=
 =?us-ascii?Q?oEYgIbsHs45WNx10LmwTCo17GkIjbfaIBugqPRHwvqxcRM/RAdArGsE410IK?=
 =?us-ascii?Q?eHxmhWEFTjbXvu+RUjSd65+8Dq26VV+QrsKSB+B1SUmqTFZMT+PdSmPOtpOC?=
 =?us-ascii?Q?iYhWtJN5VFCn5LbCgtN8bmE9aVQe5y+qVoKn4f5vlaaE0LVxGjQog/jOGDxV?=
 =?us-ascii?Q?TviP1rT81g96Acf8OvVLf43wayJE5V+fvZBLrYYs/zAW0Y4RnAwfAGqw+S6V?=
 =?us-ascii?Q?OIz6JWw56UpqXxeYPN7AxtyEOyg7C087q6q7AhOujAglmltbveFPOY7tZsrq?=
 =?us-ascii?Q?C8h5wUupPoTneqKxsyek2F0eH6Vysl8gKGm2EGvdaqS8Dyj+tUPX9N3bE6oz?=
 =?us-ascii?Q?/+lAcSVf9gsZGysoHmFoGi/sij+SqrvKDQK2Iu1w3HgOByhOVXmSwIHMGVtj?=
 =?us-ascii?Q?tX791qFfHH2Vuby/CNYb0xGx4EkeznVFjJXvvwQbcJQ9tQav+J85vrysXRmJ?=
 =?us-ascii?Q?0w=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <FB1A44C0C743374DB5E5877630454CF6@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b66a5749-e112-491a-601e-08daaac41458
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Oct 2022 13:33:55.7682
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fh8+E8tieZYV1ZaWHdSPHrbVUiczNr9mwUWATEJief6mPYwcSNeED3I5bHtCJ8wIeMRmsEXLvmgBA8HOm/Q6Fg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8808
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 09, 2022 at 06:18:58PM -0400, Sasha Levin wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
>=20
> [ Upstream commit 18cdd2f0998a4967b1fff4c43ed9aef049e42c39 ]
>=20
> Since the writer-side lock is taken here, we do not need to open an RCU
> read-side critical section, instead we can use rtnl_dereference() to
> tell lockdep we are serialized with concurrent writes.
>=20
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---

Not needed for stable kernels, please drop, thanks.=
