Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDCC05B5DFA
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 18:16:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbiILQQH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 12:16:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229929AbiILQQF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 12:16:05 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2068.outbound.protection.outlook.com [40.107.102.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7326015FF9;
        Mon, 12 Sep 2022 09:16:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m9YKEdi5kqyxxI55nkLwaDG9LPfangACstwLjjfeJjSlVWwheRgzI7EDTmbkDDRvjhS9yiMMiv/Y75kuDlUpyHllhvMlO3s2eWyrmFpKSg6x7YC5CYCthx0mSJdggR3lF7nHHa4ev59pdm6bZyeYpmIKY32pKY1NSPkQLoEmvXCxbFEXWV/egJvKvejCnTXcIRc8HEiXTPYbCeLOJ7BOeKSJAg6bzu8qsJkoOCJeEgYYnEkIjSoD2ylOJt+x4Sq/j0kx57WtV6QT7pRV9DEVYUwNJDeQ66F2bhPzvrAYYRCSs/MoJrWAwqLqX7/EiO+TfDC1Uc/d05Kk6wci1C1hPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nOtub1rWH+ZyIq/zmrrrYD3Dim3Lp8Svdmlf0byTDxQ=;
 b=kYzGC/nSPLrJLpwWXqbg2av1PAxYYJXYFh3jkVcZyK5/GmWD1VARzvhIYfOlXTJysaDODo6wzGaslxSbNuGaLAGmBrEnqZTYkqBKjdHrOIsUkt2YL+ycG3SRlI3YWta11hFV5vVnwVUqWpjOtSBhWmOoWzxopX5TlV34DSkEkKqSU8hYTsoqEGT+q2TjqNrGlhfDKsL+zLvytDDMmBAwO3cgxGHnUIM6Msx91DkDdI4PRIRW+q0m3JGYqGw0cZHPItHKGw0Iop49++xgUMVJtgUpLZyHBKyouJcAIlsZu4WEK5+eDCsfCt0ElZ9e6T2Lvn/9TFRDzD8x6dA0meG66Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nOtub1rWH+ZyIq/zmrrrYD3Dim3Lp8Svdmlf0byTDxQ=;
 b=ou2d3oSHQ/PQZDmakxQhvLwif5B9xxckbbRy2rWIYMKwMGz5ft7mL5EpuTy9h/K0Hat0TAlq5xdqixTGuPPpre3FY4A6t8BAzGR6vKLxl/ylIq0vVgcRzU7qV8CbBn8PBlFBaxgRITyKPwdTIynWcsYlJGNjn63BvJNAz/4Y0Fo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=silabs.com;
Received: from DS7PR11MB6038.namprd11.prod.outlook.com (2603:10b6:8:75::8) by
 IA1PR11MB6465.namprd11.prod.outlook.com (2603:10b6:208:3a7::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5612.16; Mon, 12 Sep 2022 16:15:59 +0000
Received: from DS7PR11MB6038.namprd11.prod.outlook.com
 ([fe80::b091:dffc:2522:afcb]) by DS7PR11MB6038.namprd11.prod.outlook.com
 ([fe80::b091:dffc:2522:afcb%5]) with mapi id 15.20.5612.022; Mon, 12 Sep 2022
 16:15:59 +0000
From:   =?ISO-8859-1?Q?J=E9r=F4me?= Pouiller <jerome.pouiller@silabs.com>
To:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        =?utf-8?B?UGF3ZcWC?= Lenkow <pawel.lenkow@camlingroup.com>,
        Lech Perczak <lech.perczak@camlingroup.com>
Cc:     Kalle Valo <kvalo@kernel.org>,
        Krzysztof =?utf-8?B?RHJvYmnFhHNraQ==?= 
        <krzysztof.drobinski@camlingroup.com>,
        Kirill Yatsenko <kirill.yatsenko@camlingroup.com>
Subject: Re: wfx: Memory corruption during high traffic with WFM200 on i.MX6Q platform
Date:   Mon, 12 Sep 2022 18:15:53 +0200
Message-ID: <3193501.44csPzL39Z@pc-42>
Organization: Silicon Labs
In-Reply-To: <16b90f1d-69b4-72ac-7018-66d524f514f9@camlingroup.com>
References: <16b90f1d-69b4-72ac-7018-66d524f514f9@camlingroup.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-ClientProxiedBy: MR1P264CA0209.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:56::9) To DS7PR11MB6038.namprd11.prod.outlook.com
 (2603:10b6:8:75::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB6038:EE_|IA1PR11MB6465:EE_
X-MS-Office365-Filtering-Correlation-Id: 47d1171a-5034-4493-4f18-08da94da146b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7c2q+i40gKm8K1TU/dqLvl+dnmVOSUiVnHhO2V1/1ohl4DlYrUz03dmEp34ZHtCNzKJwoiVk53+kRNRLplzsR6rhK3Gu7hAsUslNL3KF3HTynOeN8y2Cng9f5CRvHy6AtEkQ9uKRl6/1L6HiiaToqrkLWE4hijlsOuBv2eBTiz3JR3mYUt9LSKBneNXjR90xJhWQaw9YHgjSsaDHApgYlcM3eO5tSgBxDfPQMK8CPa8rHEx3FxdKESgFBDGAemqQjxbzJhFoVjYcMoBfPe/iUwoZMPlF5wpYRZ9si8XK/J/ihGNUxeotk0K71doUYgGI9aad0Y+1NgL6hVlYK5doR3Sg+TG+HGhuTlzvXc83uYcAqBJs3AkbussZmnEug6dvSl5Gb/Ghg8TOViYOD0TMLYK9C+mwLCfWSv6ikeQLiwYk+WfMAi5cC6qZJ25Pn4JHqgeeolaV6vS+yid838jdTJDqvsJF/o4VhSahWlx8B/vAEXVsJklTABJrHrfAldScVXiQBTmp2KGfkChL8/HE0EIWD+DVE5lHsXzIwpXPq9Jay2lmkua3nU2ZoheBrv40ofsSrJFG4tFBcrXAJbIJmQbxeAYLZP/F9MjDldaY94zKILJqpHI3d+4EXtOjNLfl3qcCHMhH4YG4E2keE0ixKZol1AqslBbdP/H1drzbCjoBmZ1AD2yFFHp1+ZNgVUSIkgZIpCyQfvOvrjGH89lg5YWQVXHnaC1xbpWemdQZ5GhGVO4j7EVjypwlJAk2ODuh8p8zM4dI991QoUKmzubdNPimuBu22828asvrT6tr6ks=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB6038.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230017)(7916004)(366004)(396003)(346002)(39860400002)(136003)(376002)(66556008)(8936002)(66476007)(86362001)(9686003)(186003)(6506007)(8676002)(36916002)(52116002)(6666004)(478600001)(54906003)(110136005)(316002)(41300700001)(26005)(2906002)(38350700002)(6512007)(66946007)(33716001)(38100700002)(6486002)(5660300002)(4326008)(39026012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?fTQP8ikTRTSquB21p9SBNu0PQSGzqj1jonzPVAwe+AsJJKNvxlH/xfQ3To?=
 =?iso-8859-1?Q?WXwAGPkAp6Q1HcImApewxWUSSv9LwVcjEIzQeYV+HTf7mZtV2uoLU2pc63?=
 =?iso-8859-1?Q?OfM8dZ6o0soXlTVmWERAKhQ4d9MzfHpCgIC5ktdIPU6S1i6FTN39qgk31e?=
 =?iso-8859-1?Q?NMnVePJIJi+iYsJt1b9Nh3pmuirvWEx2ZvG4C7YANTTWBa1UuzQidSWMOD?=
 =?iso-8859-1?Q?F+lKXgezOnVckaUKZjWyvJqAAGKz+Ig0IaBMTTt0bJ3R6Sxv9UcQKm0eG6?=
 =?iso-8859-1?Q?UzwmxRw4qnBeVAuCu7Er/J1WtNg2wufFX9vCAu7ixZBJ6UJtf+ThWqD4wn?=
 =?iso-8859-1?Q?dFZWrLTplusnR20OSFmPKnppAlKBXlOsgjSgbGweL8ikHkXom+DU4ZjU9q?=
 =?iso-8859-1?Q?H3CkOUR+FvM4IiWxQHiFz+Tf8/0Q4TR2i9BDNSCr+lsiq2j62R8Cjp6ZgM?=
 =?iso-8859-1?Q?6pVoGaDPF9aNgoptq3LUK10J1P2+S4NxyGwMBM0wSF2FESbEpVjf5Smp+S?=
 =?iso-8859-1?Q?Jl+P1GF2+qRSHawLbNRCJdV9K5xQ8Rs+gLPSzQJICp92qaJahIZr/pw9C2?=
 =?iso-8859-1?Q?bYhv2LDmKix9MVVNuPJsSfy3SS/IZP0vMbwg7Nl1X6m0dIRABoey0LzJMW?=
 =?iso-8859-1?Q?iLMthBl+mPl37OUgDnqS+EJczPQjcWTcJjmEPVoEvKm9t4/F4R1NRj7fMh?=
 =?iso-8859-1?Q?mwDmiFIB0vLyaz2Ty68w/AzJtizFESDzBDCZOtUSPzc34O38+hHh+D1liL?=
 =?iso-8859-1?Q?nwrAnPEQ0bDbW0YGrMtCoC02M8yb6w+zvXWBAT8FshCQL3RQJsJH6d6OUS?=
 =?iso-8859-1?Q?8X4rDhVSKtZ9+tJvAfayn6PY+H1+iFK/1hHo83TqJhUQszmXCHck3+OcgS?=
 =?iso-8859-1?Q?yPgA5iAK7D9djd1WbuN0XQbGly/otgKrPvfmxHCCKupdZPFuWTxj4z/Av2?=
 =?iso-8859-1?Q?FlfZ9POQP6yciM/8fqQYKKv1Gbp3hIEboVYbcN/HbKrhSzh5uBidHa91JI?=
 =?iso-8859-1?Q?JN9SyjYizcqu0NilOZIE5WRq5wpE4ToHvY1BRYodXE7EsCmGpJnNWsuNXM?=
 =?iso-8859-1?Q?5t1uIOpQSX9F/eOPlVNWHLouC9JS7l5csK98inBySRsAfpVyjGUqK/OSdv?=
 =?iso-8859-1?Q?KxP55slMBPPX59bWDIpWGjj0Hu4tFxQb49jwNrJKQQMtx9ENN3kcShI9V7?=
 =?iso-8859-1?Q?6IakZchHePYZgQ8F8TqbkoCuofxtiXJc2ormZTGAUJtMREJBEMRkapQ5tz?=
 =?iso-8859-1?Q?iqDB9zu08xvKu+agDxMp2koJZfqJQcqKAxt4e8nOUyoTMuLQLPABw3h9Q2?=
 =?iso-8859-1?Q?rSAO27ZtIYMEG6XphLBCZQVZzdpkTj7kHvtFH4WWg4r6ZcLr59C1VUtEAt?=
 =?iso-8859-1?Q?jZkfwMjweJHsS40udiYYDuvmgAdOqnnWEfV/JNH0OIOhNViGMdnBTexpzZ?=
 =?iso-8859-1?Q?W7AgJAn/7N6AXi5kdHscnQS8UD/TY8Km46tk//n0SLSaN3+4Ti3UzUo5lk?=
 =?iso-8859-1?Q?a99lSCpf2CjMp1ohu+UG1wb3D7rn+w04W7ZtfpPkNH8ihuvZF60gANx5Wy?=
 =?iso-8859-1?Q?C57vxlT0EKJCW1fNECb5axoLwK3FtBJHt9X5lev3Xv8yX3nQfVwtHCb47h?=
 =?iso-8859-1?Q?iW1NGB7by4VFpM2OMIwNTgToFQsaMV6ahT?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47d1171a-5034-4493-4f18-08da94da146b
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB6038.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2022 16:15:59.4891
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ujgpX7uIENWQU+wN/PzPoe6BL1ftqzTpfTPAPLd72kUS2eWzUsg7MEgiYSug+fjtbNFNMeH/pkFNxqy6KDq8dQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6465
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Monday 12 September 2022 17:16:24 CEST Lech Perczak wrote:
>=20
> Hello,
>=20
> We're trying to get a WFM200S022XNN3 module working on a custom i.MX6Q bo=
ard using SDIO interface, using upstream kernel. Our patches concern primar=
ily the device tree for the board - and upstream firmware from linux-firmwa=
re repository.
>=20
> During that, we stumbled upon a memory corruption issue, which appears wh=
en big traffic is passing through the device. Our adapter is running in AP =
mode. This can be reproduced with 100% rate using iperf3, by starting an AP=
 interface on the device, and an iperf3 server. Then, the client station ru=
ns iperf3 with "iperf3 -c <hostname> -t 3600" command - so the AP is sendin=
g data for up to one hour, however - the kernel on our device crashes after=
 around a few minutes of traffic, sometimes less than a minute.
>=20
> The behaviour is the same on kernel v5.19.7, v5.19.2, and even with v6.0-=
rc5. Tests on v6.0-rc5 have shown most detailed stacktrace so far:
>=20

Hello Lech,

It seems that something somewhere (Ms Exchange, I am looking at you) has
removed all the newlines of your mail :-/. Can you try to fix the problem?
I think that sending mails using base64 encoding would solve the issue.


[...]

--=20
J=E9r=F4me Pouiller


