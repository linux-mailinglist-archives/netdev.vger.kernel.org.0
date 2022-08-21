Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9380459B333
	for <lists+netdev@lfdr.de>; Sun, 21 Aug 2022 13:12:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbiHULMG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Aug 2022 07:12:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbiHULMF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Aug 2022 07:12:05 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2042.outbound.protection.outlook.com [40.107.94.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9F3423BE4
        for <netdev@vger.kernel.org>; Sun, 21 Aug 2022 04:12:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bs23kkA6bhR+KHg1V2GyK8LrgQXgDqpv4WENXa7Ifjrx3jzob2f9sZGLYIZ5bMBODCRaisW23viXPH2iloyWUUMr6B2R3VVwrIFdndV5ZLbh1SVjxAtjPE2lSqBYfiB/Pyl6s7GaGf2O7wp0dRxav7BRznF1PsVDHbDc96A/FOQBlLRlUbPpJ+GtpoNxMnlo1zij6vX6wvQK3GGM7XEsBYkWEaU7NmG4bY1Gda9oRJEzQtU2y+erqohVrWVi4MFyu5f0LRPhaHDwHnunJ4Wi91jUTzDIQ2LT9WK8yGj6nv2DpNnOaiBjY15zKq3xBsQrNdbPEWrtdSnB7PdPsdWM2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AIJ1XFkG6s+E2EUEgiu5q564LQ5CquiQFNJ1ih1f9KA=;
 b=kKXj1V6xzNhaZCGE9mhu9CM4a6T6A51/7pQoxUzuYs7uaGKIy3ItPZ2QjSNuiNyFTc4fzDRm/+eHVm5lYjBpgWrRmkvVrXtXzP8d/zbv75L1LM/DNHGPqplKELJKuPvV0urUdNxhRGP7FjKnKjGZ+3gFfOtoIpIvH689EGiv0uVTWQgjm/fp3eWxnj/8VK8DBxJkaqINE8JuuHVUJry+ZI0uWEYMxaU0WNMWY2AjmXJ1ygKmoGiRE4hOv4ln5cPA9UOJaD9+IUNvQf9cwy+Xx81OKrlKrbe3wAA7/7ACzsxRdwAZJmd7Mw0Pwi7Kt9BwfRACcbxOBuGNLDtjcdoEgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AIJ1XFkG6s+E2EUEgiu5q564LQ5CquiQFNJ1ih1f9KA=;
 b=EuaJ9ypUADAIlFhDszK+V7bjP6a6dqwF5S9eMxw5fyLQ4hrxsQJ7tOHz9TijFz8Ts8OSKaX/NQyOTWhLLMaS82Nth8G/XWIDqSvTimtoEgr2G+g2veX5k28ve26VbK2oeBpMyiOAF3lY0GNgGdo0m5ClGWQKhETeKFKUzYvf1WQJMmczBukYIy0yq6esHDgyyvbcpJw/Y10R25uyqFnOqKE5TT1PdhfFkcJpZAIKgGvKsQ8eQjzWfr6cwxslU/0Cc8gGMj+xXJWtSdNCyIsDKi7SB22Nrwlvym+jJCU2H0WLmd2J0sFmtoNUoe5+0BS5ItX0bbiBNpsg5btmsPh6gQ==
Received: from DM4PR12MB5357.namprd12.prod.outlook.com (2603:10b6:5:39b::24)
 by MN2PR12MB3056.namprd12.prod.outlook.com (2603:10b6:208:ca::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Sun, 21 Aug
 2022 11:12:00 +0000
Received: from DM4PR12MB5357.namprd12.prod.outlook.com
 ([fe80::c800:7c73:ccb7:772e]) by DM4PR12MB5357.namprd12.prod.outlook.com
 ([fe80::c800:7c73:ccb7:772e%9]) with mapi id 15.20.5546.022; Sun, 21 Aug 2022
 11:12:00 +0000
From:   Raed Salem <raeds@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Lior Nahmanson <liorna@nvidia.com>
CC:     "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: RE: [PATCH 1/3] net/macsec: Add MACsec skb_metadata_dst Tx Data path
 support
Thread-Topic: [PATCH 1/3] net/macsec: Add MACsec skb_metadata_dst Tx Data path
 support
Thread-Index: AQHYswXXhsqvJmZB7ke5R41T2k8Rpa21nMEAgAOaE9A=
Date:   Sun, 21 Aug 2022 11:12:00 +0000
Message-ID: <DM4PR12MB5357C54831EB8F1C9C982D90C96E9@DM4PR12MB5357.namprd12.prod.outlook.com>
References: <20220818132411.578-1-liorna@nvidia.com>
        <20220818132411.578-2-liorna@nvidia.com> <20220818210856.30353616@kernel.org>
In-Reply-To: <20220818210856.30353616@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a01a7ab4-aed2-4733-3fc5-08da8365f832
x-ms-traffictypediagnostic: MN2PR12MB3056:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 94L0Tdcl6M6oxidDj1C5QVMqQsBeOUjRCPp/L9ra/ANBnbVFx5Cc7HAInA1Z9KwN11Dfxn2nRKelLybiPH2sZhAmTFisGBr+Ev/0exeP5w+kFK7iNWOfcUGGz52Rztj5e5QL4D3kjqOVjyS5QWH4SycLvFlcDY07qFyUAjrm+bOvD5Zt1fIsXhaVnMKmjLnhPYbr8y/LhH5b+K74Ho7nAlJS+frbNJqbl6JgtQom7thnIzwNSUdmlMXiqo2bCuKIxPML+qEYakQW+w8pzTSe+vM0yL1DD/vCZrT4eqRy6Pf+i/ROUiXBFFToDiP9wURNL8YaDpihS/itYtVhSACtzSWwDHs1gdYuEtcGBkUkCvly0WorF3LgUgPSiSR9vplncqjzrEgWHF+Bxlj1LtclPeWdW+PEqb9Zo0QxJ2YCyFCQeYw+yv7hrBrqUTCkMJhIao52Yvbu1NaZMToNK4I8J4/nebyhL640hsUWU3LvZjzNiLhXu30RWYkRYUxZhSP0d5wJ7pwxQ/45nPOsq2Q1e/4O4di2kiNX/pez4SQTOTVz+5ef01PuFBVcONnBDIbMVS+p97OF0JqClhm3Fact9FC5ueM3NtWN6573chIsWgXbfnuZ6DI7YVJnJf68SYHF3BkgBCipLbf49VwIlRDfItZO82hnpPLTPc8hsBPQ5Gov1+3Ka4KY2SzfX2Ck5X7nv2tjBzxIL2/lGBT+xHd468TMDTbya0YnoNg9H4yfPUXcNzKpPJoXAHw6Fz7UTxckZulhFu1zWobRhTj0IZsTaQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5357.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(39860400002)(346002)(366004)(396003)(136003)(66476007)(66556008)(64756008)(76116006)(33656002)(4326008)(66946007)(38070700005)(66446008)(7696005)(8676002)(6506007)(5660300002)(9686003)(26005)(478600001)(107886003)(8936002)(41300700001)(86362001)(52536014)(6636002)(186003)(316002)(54906003)(55016003)(110136005)(71200400001)(122000001)(38100700002)(83380400001)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?9M1OA5mW8KXkVfEySrAPvtPox16fLMAFYC31IaXc0Xmqh6Dmd3TqUlmo5mQn?=
 =?us-ascii?Q?p6kI2D3jNCPYr9vfzt8niAvrr+TfsO7peaRNmVNjvDsQxsBtJkxC9go4ym99?=
 =?us-ascii?Q?Vc6m/Dzfqh6VBzjToHOSYE57KbNc9gVYJuFHwm7gIIgIDwgTxd+SZ+BwKzBw?=
 =?us-ascii?Q?Xqgy/GIU0h9hKuxKuzJO6PLNrPFkfUSm3hTwcmIQ9YAL2UjKEfq+MXIF7g+g?=
 =?us-ascii?Q?n1HoW3n4rC0KQGvwgQYqRPEA+J2dMeNTC8igKvqCiiRlEnfIsAX2Jwrr82GS?=
 =?us-ascii?Q?Rzt/iU8NG5IqVQ/VnIAEXcimw0gQBXHeMCdkOoSBMo8yekJ09HvhpCTi9RHz?=
 =?us-ascii?Q?QZVYgidaPV941jNuTcYCjc2Fn0pqx3re7jTEne3Kj1F8/9wOKYFHnaXJHftG?=
 =?us-ascii?Q?9Jv45DUFBfNBajjwZpqnYChTV2Zvu9rBeG302ge9EVY4xgbtXc1rOG4cybaz?=
 =?us-ascii?Q?4eGgtEIT7zAgUEEmtEI9sDleNBee2S+d9CNMlMHFG/OMOkA56CTTQnZekL5T?=
 =?us-ascii?Q?QPYkp6C4N/PKqc7AXW1UUS5ypKS4wNU++YQsNhwwpCEPzy7UvBwBYwIQeLeI?=
 =?us-ascii?Q?T87k4DlbRrvHrEn3amCXGQJ6VbKlEqg19TMl3VgFtukFkiFcmnZHs7BAVNhI?=
 =?us-ascii?Q?gYkIKVahcONvYv/9I5KeU/1TAmjVAGXhErhfPFjoE039qo/5KJRLeFVWq0/c?=
 =?us-ascii?Q?nYJCCS2HHjG9CNsuT4742HGNeW2Vil5fZc6lSRRH5X3W1SlsNUvp8JQvdaSw?=
 =?us-ascii?Q?ZI//vf2lmEGSiwePwmMo4AilD2yLmoIRqBS/x7FSx4o3gTPYw3U7zxZvSZ4v?=
 =?us-ascii?Q?wGb4kmBtbQVV0nq0FWf9oxQYzot1OX3+ZJ79AKkNGM86TC2babbA9ibMK6kb?=
 =?us-ascii?Q?AZklscvOkEkRRxZ2lXx543dR6MFOEjVFemUCCJahTUiwe6Zd6q9EphHOE/cu?=
 =?us-ascii?Q?4jZENG5KFFb66WV1ZvpWd6v4HnIsBUv8puuclILs302qXmrEzbrqUkuXTvVX?=
 =?us-ascii?Q?qcDjq4ZL1FussNktL2KEIIRQM6RkicKmUKRaI6ZAAEPXl6ryYHXAyYiR9BXg?=
 =?us-ascii?Q?8xmf3/rKZ34vmIedFmeJD+C/7DDZ1tW6VrRYPbz61F5AZFI+otuRY2UcP5hF?=
 =?us-ascii?Q?RH9Ocn0MroQaoemrqKjBmoVz3MJVNqaSpGESYwk0ILqvEHmkxj4SPYxqzOOR?=
 =?us-ascii?Q?WVhEPQYvjnzttTRbiXrUHC63wu2Pp0XcUaRf/n2TWodhpHOlI0SP3irFWKwQ?=
 =?us-ascii?Q?qGViiRbay/y48tmSwtzXFA9o6t7zmrYPakRJs3DV+T9dGGjLYQuXH+/QN2EY?=
 =?us-ascii?Q?yj236/6wMNWtatDAwf/Co6clJ4NlyUYzLA+3SycFXpyBoz/Q3ImdlopCNCYS?=
 =?us-ascii?Q?z17Oy9w0D34/z+4zocJUToj/beXc5IiSWj87X2jfZQpO1ptg156rEGnQkZfA?=
 =?us-ascii?Q?XQeCnXSyOUFM2Jk+vMPBzt4IiMWOiFTLadTDtKE2eKv60VmGn+xhCUBbCSHf?=
 =?us-ascii?Q?2EtZW8cdgSJN8ALOhpmWhKpx0EDfLa2JyNz1+z3Buy/n17XOQEiASaJNGCYj?=
 =?us-ascii?Q?emfFGZCqXULebfttfPw=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5357.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a01a7ab4-aed2-4733-3fc5-08da8365f832
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Aug 2022 11:12:00.4699
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZOr46QEjlW4DPGIWA1RTOvfm0e/P7iqiVo7KgsHKEYNKtCmaN/bQWYRxj7j9lAfF7B67h/AAQEyNhnXliexyLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3056
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>-----Original Message-----
>From: Jakub Kicinski <kuba@kernel.org>
>Sent: Friday, August 19, 2022 7:09 AM
>To: Lior Nahmanson <liorna@nvidia.com>
>Cc: edumazet@google.com; pabeni@redhat.com; davem@davemloft.net;
>netdev@vger.kernel.org; Raed Salem <raeds@nvidia.com>; Saeed Mahameed
><saeedm@nvidia.com>
>Subject: Re: [PATCH 1/3] net/macsec: Add MACsec skb_metadata_dst Tx Data
>path support
>
>External email: Use caution opening links or attachments
>
>
>On Thu, 18 Aug 2022 16:24:09 +0300 Lior Nahmanson wrote:
>> In the current MACsec offload implementation, MACsec interfaces shares
>> the same MAC address by default.
>> Therefore, HW can't distinguish from which MACsec interface the
>> traffic originated from.
>>
>> MACsec stack will use skb_metadata_dst to store the SCI value, which
>> is unique per MACsec interface, skb_metadat_dst will be used later by
>> the offloading device driver to associate the SKB with the
>> corresponding offloaded interface (SCI) to facilitate HW MACsec offload.
>
>struct macsec_tx_sc has a kdoc so you need to document the new field
>(md_dst).
Ack, will do as part of V2
>
>On a quick (sorry we're behind on patches this week) look I don't see the
>driver integration - is it coming later? Or there's already somehow a driv=
er in
>the tree using this infra? Normally the infra should be in the same patchs=
et as
>the in-tree user.
Driver integration series will be submitted later on
>
>Last thing - please CC some of the folks who worked on MACsec in the past,
>so we can get expert reviews, Antoine and Sabrina come to mind, look thru
>the git history please.
Ack, will be added starting form V2

Thanks for the review
