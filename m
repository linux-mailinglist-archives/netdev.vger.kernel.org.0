Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DCEE4B2972
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 16:55:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346932AbiBKPzI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 10:55:08 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240763AbiBKPzH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 10:55:07 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68FD6196;
        Fri, 11 Feb 2022 07:55:05 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21B8ORS3012985;
        Fri, 11 Feb 2022 07:54:58 -0800
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2105.outbound.protection.outlook.com [104.47.70.105])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3e5134e95r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Feb 2022 07:54:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BhvKYRf6R7kZFeTzw0caD9a7DBiX+W6rh+vUyZyTC3wOs9XPK01YTaqEVXnlsrvm+3kTVnUEX895S/sFTE53Qn2YpiKkeMXqq0XZQvqMueMrPO4a9opjCQ1463v+fFD28m5pK6PIQqo1DPRPwiOTZCCoSUzt5XVOQVkglV+xJbSEdY8jjpeqBULWVGUPuDKjMG7UfNHGMPPLF5gFiNv+iR8PYzPAIglIYNmefCUrRjHz4ZSk5I9A/U+LhbRCLfJwrXT4CJkH6yWyeiJAmRccMvVb91pDOcYkJe/eSj23UFwAKrlkyosUOi5Ni8LaDhh4NRuwPnQjz5bu/K1YmM6wsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o+WSl8uByVzxK6cxrdD9STCFMLNuDxx8QfNsYJ+Li8I=;
 b=L7e/WA2hDVl+12LYbleTEdPfDqpkzJ132UfHw6e+N9KnTVzwSZBfeYgUFeWB6/gHF30T+nbEjb6emmU8EK/n65yd/K8yUhYUcgXBsvR4vTMUaKEKjLQeNg6ghW5CtEbUWFSlors1VxA9vwruh8gbGEdokAJ2YnKcYOgCQmlZE6vAkFXCFYmVZIiO+fBIXUHJCI1CucrQBzXWprHJ12Pnw8NrSdrRtL+mMyrxnFlEqbAnz2vtt02iUZeXsHOzsA1GMZ1h7fMOLPKqV1xcWxZesVmK09/EGt96KUs7Qk7gj1vklnGO1MRNpEr/w/BfgcFskPwOJ1t+Hhj7mLBiN1GkQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o+WSl8uByVzxK6cxrdD9STCFMLNuDxx8QfNsYJ+Li8I=;
 b=l168qkCP7/C0m/F7GGm6kPsnz7xIrpq6XNJNnxU0MAki1HEtysiw2BKojBApl7jyarrFeIvmOIK2jONQL9by3QsaXIXuKWJdCkSQE6aR/H9TofjVspfYW/XmPMs7mTtSF5RPsGl7LkJ0EgpCXqmE33zi8//60TI/fNG3sGs+vsA=
Received: from PH0PR18MB4474.namprd18.prod.outlook.com (2603:10b6:510:ea::22)
 by BYAPR18MB2597.namprd18.prod.outlook.com (2603:10b6:a03:12e::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.12; Fri, 11 Feb
 2022 15:54:56 +0000
Received: from PH0PR18MB4474.namprd18.prod.outlook.com
 ([fe80::d0b1:c7fa:d04f:f8bc]) by PH0PR18MB4474.namprd18.prod.outlook.com
 ([fe80::d0b1:c7fa:d04f:f8bc%5]) with mapi id 15.20.4975.014; Fri, 11 Feb 2022
 15:54:55 +0000
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        Jerin Jacob Kollanukkaran <jerinj@marvell.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>
Subject: Re: [net-next PATCH] octeontx2-af: fix array bound error
Thread-Topic: [net-next PATCH] octeontx2-af: fix array bound error
Thread-Index: AdgfX51L/rhUbjOQRimZXX7hDwIsyA==
Date:   Fri, 11 Feb 2022 15:54:55 +0000
Message-ID: <PH0PR18MB4474F41E53AA9F2D557088FBDE309@PH0PR18MB4474.namprd18.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b7f3a3ef-6aa2-4f30-9d4a-08d9ed76d96c
x-ms-traffictypediagnostic: BYAPR18MB2597:EE_
x-microsoft-antispam-prvs: <BYAPR18MB2597E973F74D073CBB5939AADE309@BYAPR18MB2597.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: awDA43G3hjXjPhd+qPus5H6V3NvjuFYK/rudR2M6m2X0Zo4DjKq22iznbQb3FXgFrWtEaIRmaIgCWis3R5JDZAOLMsOKB6j45FI41o+sTI5B0iu0kklcgr66HnNZ0KFpSOTduY90MqoF4tOo2GKlINJsEiOjnGlcBI+W0RL7V4VdJ3UH7+j5qhMUlF+ggpj7yDryvqWP+rzBu008leUoSX9WrO+zd2j8PfdodCeBdQepUVlK/DLdufHfa5cvjioWx7MoWFyxjljW0t7d5ru29s1OIqB+kiFDmXQAdEFNeNudK1uy6m5ZoglFuB1YKn3d+szjEbmHflzw7zYZeKhzhe95HnxeIn0Eo5Tq8lWgFEAI272RJpv433JIsLrUjUBY8Y0OiDZXNSDkLBpXMYltjhHiJAQbxy5XanXK87/1Hrc9YgW540IK8J2SLGfBSWkyIBcw7yaMQHWvkMjBmIxbruZAd0DIwUM9w2ffh7VTSCJBlIV9ca6Xt7od0wFkQiMBTTN6IX6XGIKC6teYV+yoZ1Zux/W6aefbL2pqjkLzkkYERSFoCVtRAl+epq178R2Xyd8Q54pAOs0dOnuLxv/MMzeDL/dWDQ7z7DKL1wj07+HZyolm/2YCYMB0MphvdxrmFh/rfEfRkCLvSYwdHmzj/Yi8+3KdP1kSpl0GhynPoNCcYzE023SFI1elCmv8xhHQINOIdE8AK+Xzo4qe5548Nw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR18MB4474.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(4744005)(38100700002)(71200400001)(122000001)(2906002)(38070700005)(508600001)(6506007)(7696005)(9686003)(54906003)(66476007)(66556008)(66446008)(64756008)(66946007)(8676002)(4326008)(316002)(6916009)(107886003)(8936002)(5660300002)(52536014)(186003)(76116006)(55016003)(86362001)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?R/PuGfbMAMh/Zxj7VSqT7Q/o6EO+so2OTxNpHmfLpKnpGWmbDp/aXJEsQtvU?=
 =?us-ascii?Q?1OCHToSynknb5I0W77tcTuzADkrcP9b+PmsuexJiyuJ2aeCdk21GAn7efTsy?=
 =?us-ascii?Q?dYgVtEEnicDps/u0IXQBok7T23t1ywE5YdYZgSMPfKztmXfPFQ5kx2c8WdIA?=
 =?us-ascii?Q?sfcWz/hhbW/SM3GhPhZM+95SdJcslpnTn7mSj7Q3BCiNfoukNOYEabEXdvB9?=
 =?us-ascii?Q?XWddREc+51Wj/fvOUngEu8MHsSz3aS8Tb7GFiR0WCllSR+LcFzriZgH/+msz?=
 =?us-ascii?Q?3JIVIyb+0MIc3tL5f27nXkeEjoh1//zjmWWbAv9RX5dXTBS8ikoFrJmAiWiJ?=
 =?us-ascii?Q?L73pGEvZ0voZfdZKXu/gsYLXQrzVtgx6ik4zxcEoH+uy98/qrsJtCSRfXK8z?=
 =?us-ascii?Q?TxYDvCuPV+uqC0ivMDsOqsQLqkKq5wK2TiefLTBMV3NM9b4rlX5DuJ1XqJQ7?=
 =?us-ascii?Q?HLCZjV+msWqEFFQv7LS+E6kRq2+VYgeD7KDrKPfLqWf2sKeCFVdWPEI8ggYs?=
 =?us-ascii?Q?MVcA9euxwsbDnMNA8JjWJq6sHRTt6eKIh63v+YqqDox5mPR0ZspNGTxSgdy2?=
 =?us-ascii?Q?jMDPPOg7tS/mrXE6y1mOZhP3vqgloq7+oxzvdiyzYbTb6B5p19PMfpwy1iGY?=
 =?us-ascii?Q?pNL4t82PpJ0QN2KBwLGFH0lONaYSyqvWY2yycul73uSdaFMa920Uc5t0uRju?=
 =?us-ascii?Q?gj1BoPwteK5FiXenHr1qE6Dl8OWZbMCN0tsmxRzJlCnVhFYiqz/+89EdnxWI?=
 =?us-ascii?Q?uCJ2VDWRhWZYP+oCJhOCuJS1xbb4jJuh5j7Rn1wwiXXrxg11PNmjbVSw54py?=
 =?us-ascii?Q?1GL2j6oU320ejsbWmzooiScTo+iNaCbkoNJLTUjpLKlk+XiUGpr60Y5IAfnk?=
 =?us-ascii?Q?qKHJso+/31Ekys1PVJ2wdK6m0Dd0gm0R2PWlnOxBgOAxxsXxojEUr7SzCpn+?=
 =?us-ascii?Q?9a32h+7V7+PRm06YsAeF1MOPuaE1Mwfc8/2QzsK5/eI0z8u336Cf8DHscJAS?=
 =?us-ascii?Q?e+awDaRUOshzEcK1gWmOO7bDtVBm6txlhGJStaKdqszBgZP3XG1Pt2BK/ty0?=
 =?us-ascii?Q?pNLNEIHI9j/Cd0ApV0dBo0Dq74adIxus18viAsOd3V+ei23c1J5Mefid/8K7?=
 =?us-ascii?Q?w84D+gnCWFDs86n/zX/DRpLuqvvC7oFUiIiZSgCGFB0lVAK9XgIrESGVDHRM?=
 =?us-ascii?Q?QD72Ftu8LmIPqEqzfWlqhS0LzvQxy//+8DgyH+3oeRIownRw2nrNqIilPD/K?=
 =?us-ascii?Q?mriW+hkH3fK2c0amwrN9NUAVCxrejKiuoppEkGFz2LlgN2p2TFP4JhuE30Z3?=
 =?us-ascii?Q?BVR0XMiRI3ZJ1SjYQIoAq5j24p8T8Er/OE2GAnVZSjEkARzhW+W98rmlGCiW?=
 =?us-ascii?Q?3oEGIN87L95humx2HZHwbqQ5efYMic40beIyNEeq2BCOu513vd26jrx4ifGV?=
 =?us-ascii?Q?S7Rzqih461tW4GsI0sYYtifzgwT7egNPkbnmJfH7vzBSEXsaB5+U865QIA4n?=
 =?us-ascii?Q?dYG0FeVKcI7gVnpjHw7UNm+Y/P9FBMXTfnYlCg7Ks1ej3Fbwk4bwKc3Bgr2R?=
 =?us-ascii?Q?lZ9hqHfgEHaRWo7gGYpiKiz4o84axsMiuktuQ5NnRx8YfcKIVy3Jmif31vQq?=
 =?us-ascii?Q?Lq9XoLnYDZIhS7qqStEPaPA7AfcUO1Uv8Mv9wJVIT/ZWq8zPDcHvmpBzvnME?=
 =?us-ascii?Q?z0eTfCCpkt1nXnvcrGeXdUbIGDI=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR18MB4474.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7f3a3ef-6aa2-4f30-9d4a-08d9ed76d96c
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Feb 2022 15:54:55.8396
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sEkGbpOed2JXkNVy+HT7VGW51s5W3obIhEAxf6ACTeG4J2FK3TZmouHTUAndGFe3yRQjrB2VoZshipu81UYgWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB2597
X-Proofpoint-GUID: JtIi60BYASbFwvNU80a30ShMyaAUGEWd
X-Proofpoint-ORIG-GUID: JtIi60BYASbFwvNU80a30ShMyaAUGEWd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-11_05,2022-02-11_01,2021-12-02_01
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On Thu, 10 Feb 2022 22:05:57 +0530 Hariprasad Kelam wrote:
> This patch fixes below error by using proper data type.
>=20
> drivers/net/ethernet/marvell/octeontx2/af/rpm.c: In function
> 'rpm_cfg_pfc_quanta_thresh':
> include/linux/find.h:40:23: error: array subscript 'long unsigned=20
> int[0]' is partly outside array bounds of 'u16[1]' {aka 'short=20
> unsigned int[1]'} [-Werror=3Darray-bounds]
>    40 |                 val =3D *addr & GENMASK(size - 1, offset);
>=20
> Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>

Could you send the Reported-by: tag? Was it repored by the kernel build bot=
?=20

No its reported by Stephen Rothwell <sfr@canb.auug.org.au>=20
I have added Reported-by tag in V2

Thanks,
Hariprasad k
