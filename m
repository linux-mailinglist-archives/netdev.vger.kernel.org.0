Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6D55485658
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 17:01:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241772AbiAEQBi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 11:01:38 -0500
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:55558 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241756AbiAEQBf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 11:01:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1641398493;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kg6voqSLeXjxloQMpoPwCAPsTBjG1QiNl5oztge+bec=;
        b=nnQb7/HqGy3+Ylf4LSzbAdfvMWaC7BqPyZuo46Hu5a27ao66L89icWNmx1yMDEoABDjNVS
        55Ubfudp/S3Wvz/9Td0wK8pis1ubLKl/xex3MQNMHpekBsgwsAL/ova6oi2rpFfrbQ4l70
        C0yjjPUMR4WiV74Z9rGFUloif1yNXGE=
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
 (mail-db3eur04lp2059.outbound.protection.outlook.com [104.47.12.59]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-17-TFAZpPQmNVipB6czbjsd6w-2; Wed, 05 Jan 2022 17:01:32 +0100
X-MC-Unique: TFAZpPQmNVipB6czbjsd6w-2
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=igNq40s8EhoxY3rlyH+QpFxWjXQk+J6LKhkucqzJNl/KA66f+Z5zYQvu4hzMIQE6Um04CIHqGVSc9D0PMw8caxiUNWLjDrBf8GlWVTe4Dpp0GoKUyy9fJjkOsjpjs5tG3O7zwpms6JkYPIJ2socTFZWHjXLodsg4cNsaSDF7gPeHJBtRiqKildhtTZGAXKX70fPJP3Z+GJArawfc8PKIJuYssti6rMdFh+l/4RTcc6CU22NrbxtqjHFul8/2nAVVMZeRggVFIR6TatwtY0DguZU37wB347iaYX2zgNF0EkSZU/LjcwJ6TqIilnuweksL5Yz44aFPRjao9JcK9pIRoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Er1H+TKMZKSFZxFos1bJ89VKkDRiNUthspDEZYxQVu8=;
 b=ArrIsrQm8t0z0Y2q9RCiFUNdbkWOh7O18UQs6WKqx3KSNqAJSBAZ05ypEu9t+teJFjjZdhBcg/ud1klim84dIadM3kf2DJXem5vTdmuXzy6fut5J/m0+xx9JGgY0JQ3M/7IUEKqjL0ndFUWF/B2n6ulUmcTXZwFvnk69EH+qU0qglw/mGjN4rgqymlufMn8ux5VGLh6WictyGpQQL4cPw2ZDmCjt8eZpP/AfOq0gk7T0IcWaLQQTsCkgT2Msz6G8wl8Mc2/2yKMYo/oNimRd8ianUkJsbOYPN+AeZ5Cx4zDyRuLBLMgCwdx1yyZ8D+rrikRJfyHpE2OENEn2pEnsOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB5050.eurprd04.prod.outlook.com (2603:10a6:10:22::23)
 by DBBPR04MB7897.eurprd04.prod.outlook.com (2603:10a6:10:1e7::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.15; Wed, 5 Jan
 2022 16:01:30 +0000
Received: from DB7PR04MB5050.eurprd04.prod.outlook.com
 ([fe80::e9d6:1be9:d046:af1]) by DB7PR04MB5050.eurprd04.prod.outlook.com
 ([fe80::e9d6:1be9:d046:af1%7]) with mapi id 15.20.4844.016; Wed, 5 Jan 2022
 16:01:30 +0000
Message-ID: <394d86b6-bb22-9b44-fa1e-8fdc6366d55e@suse.com>
Date:   Wed, 5 Jan 2022 17:01:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH] Revert "net: usb: r8152: Add MAC passthrough support for
 more Lenovo Docks"
Content-Language: en-US
To:     Aaron Ma <aaron.ma@canonical.com>, kuba@kernel.org,
        henning.schild@siemens.com, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
CC:     davem@davemloft.net, hayeswang@realtek.com, tiwai@suse.de
References: <20220105155102.8557-1-aaron.ma@canonical.com>
From:   Oliver Neukum <oneukum@suse.com>
In-Reply-To: <20220105155102.8557-1-aaron.ma@canonical.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: AM6P191CA0016.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:209:8b::29) To DB7PR04MB5050.eurprd04.prod.outlook.com
 (2603:10a6:10:22::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dbdff89e-3a04-43fc-474d-08d9d064a332
X-MS-TrafficTypeDiagnostic: DBBPR04MB7897:EE_
X-Microsoft-Antispam-PRVS: <DBBPR04MB7897782108E88C8E7ADFFECFC74B9@DBBPR04MB7897.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:241;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LhjibfcY3RIJ7ieEIpKPag5IYEQjQwxz9kviv4TvG8VF2sshL1xSbfFaQ8Jj+OPcPALXrEmRm4YAJBjCr2+/ZgLQipPmHsnAiNQnHdCL72BAy7J60oMfAOkwx50AvKHAvJOuKkbTptMvLy+Z72ERE8I9mlAFPX7yEnPIJvGZkZRJLf3Ow0K/cg4+i7VPa8fuYHFQ9pNWbI5Td5ePURxWJ2BCdtKKKH940iRN42xJt63bslkbs32CKERSowe6rIEh46bprzLVpNC3DU5Q4jQz7ACwE4+Qr12nzKIqCAKvWP+ZBqbXbWdV0gwvkTCQeY/1ZmCNYPdERYBb4R10WdDmhRVaV8SvvnX/Ny5Lk3rYMT3avTqZjuGvX1Znu0F4IVrYorcQvj7JbY0Ziz3SalfVxOMZF8PLTFuwsmaOaHO3Phwuz/u9Qzs7MzsquIK1rZgkaem5IKNyMdUdYiAoyXKKdL+NLkstViJvL4n+niKH8DPQ4yTS/6EvoKF6t9l6UUpY7/i/7KTKyjafXTin19UbViCd94zop44EE73aXOu56mw9dNE7/T+1wZztwlGDMIPVwLFWTOelYxsJ/NPuGK2kcQlomkmJtprBhM5ETvfj+pgKlWoTKabDvqVove5NFzwbu5NfnicCpTg8RupF9QLWJpDlpjOIPqKaYC+vi2xp2s0HldrnJJOHPZkA52+PijDujnUCzdkZdrR59DVJC2881nn+oPg96F2+oZb9ZudGekg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB5050.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6512007)(31696002)(186003)(53546011)(6506007)(36756003)(5660300002)(4744005)(86362001)(2616005)(4326008)(8936002)(31686004)(38100700002)(8676002)(508600001)(316002)(66946007)(6486002)(2906002)(66556008)(66476007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZBM/B+X/Auc0opAAhoTSoNa1uRxr3veI31MwWyaqXsRstKqi850MtZt/QshG?=
 =?us-ascii?Q?APHZyBCZxkQ0GgBo57lfrI7qtmMnF+fUO+uzEBXfir2ZaUdoUSmxpTYUOxRK?=
 =?us-ascii?Q?TJUij4lMSYjh90BxRUegqfAAj6+NELaAlHtLHyQ9a0D4XCSe5/kuRR14VQZE?=
 =?us-ascii?Q?taY8/jYFzae4YDerKYGkjiLVNwy7du+UtJTlZKf4U9XpeRob/rIQdhneZtI5?=
 =?us-ascii?Q?ogr9baHGfCvmOngboijOHg52YHV6sQt4d0dsA1ebesOBVu3tuEcwy3ihvc8G?=
 =?us-ascii?Q?2Bfv6Y0Gjfw7EvZAhv9DFnnVyVg+ZqD9NqtIhX1q471/7ZeZoj/B5JiEo3pX?=
 =?us-ascii?Q?WsREBUn0YjQEQkVrX19YrZsUVOJqG6X99HKi1vKmMMC3KgUExoU5TjF756yG?=
 =?us-ascii?Q?N5VQ3FGh8xB08ixWl9WzcXGfZz3IdyFZt567ZlhEg8nz7RFSJhQn6kHvmIjR?=
 =?us-ascii?Q?KXeNugRo/Q0R3IOd4f2TcGGB6HCOKJh1TLqmK6k+JGCbnUqP3IgDIkRYDVj8?=
 =?us-ascii?Q?9Nt7pLawvVf3mQRlrhg3tB6xqPDyGFwGOfpqgcwEyp4uYHOEEUar5csP34T8?=
 =?us-ascii?Q?n/lBH96+LJCyBL1oolG+/GngNl4J7VTBLVCbJYwcmRIZbq/CV1yC2faA5X2u?=
 =?us-ascii?Q?1KhZfivrHKhBbEuvf0kxf+LBoqj2UrarNLEJFlgqXThPCNACisBlid49NvVO?=
 =?us-ascii?Q?bCjttkR5TpoqOxUQfcwwogIdqO9kwth15HsHfN97LrVbxLw7QOdutAq0hrHC?=
 =?us-ascii?Q?EnHeNHXSHAFUb1ql23uIaW7HBnV8CTXDLrzrnzfDCs8Ki0V4HNLD5FwZJC15?=
 =?us-ascii?Q?i1TVL0z4aDQhACT3ug37jQ8Di1wfpFCoXLHwrXCXLz0BzhvkWhfxjYmpD5ps?=
 =?us-ascii?Q?PwaCS7DKn5+kV+mMk7mhihCuKOHxQcrG8tLLJ6uB+O7TP6TdrR9JyYgz0s4X?=
 =?us-ascii?Q?iEyR6mzDWij+mwMj/y9LZKH7LVpXfivq5RxDk7WSPmTI7+zBYG7j6jqY8hzu?=
 =?us-ascii?Q?9/AD2ILgUYXlMx0qxPyo+sQkrzx+Fca1ebKPRTeGxFxh+T0RcYDU4xWaspGc?=
 =?us-ascii?Q?Ul/xj6ouDBDQZ2BrYDtk4r9gGb11DtMsfg0kR6sheWbTSLTWHeimu4g0R3LF?=
 =?us-ascii?Q?fqxhwFxyCmruL3WezuUQ+UCAP/zyM2Bqe6goWGEKu/flFmYOBd2TPHZ8AGta?=
 =?us-ascii?Q?6DWCjlSmog+Dsrk+yKSu6pIc0CWdcbm7+wYiVY5ZS/qCrDPwvPEN6PVAfF2+?=
 =?us-ascii?Q?FLw4rrbwLyF6H1n88HO+TivEPsjo94uQeII+qMlMkZG6FGCl6xaEvRCuOH2N?=
 =?us-ascii?Q?ZQhswJeWfjGrHtIfNx+ovG+hAPhJxa4e1SQ8reI3XiXviu6X39zLaEeKHzI+?=
 =?us-ascii?Q?yxN+lBevK5Uo8BFITwEmad1Sx/ujKIXLtSI5zccpxxdYeZZLZSw5a7Jb6JEB?=
 =?us-ascii?Q?jS3IbvUV+6Gj+EQgBCTT87gBDbb9IBqLULtWumQvv9iA9sxXZjFiro8ofUvs?=
 =?us-ascii?Q?zCe1UxL5UB3/Xphb0vLA/zEndVs0Kd1JXDfkFyEVAQ5jNMlaqLyfxb8O8e9K?=
 =?us-ascii?Q?7iQTdMnBYJqiyenAuIx4Os4HyTNryrW352I+SUKP7ybZRDJ/eZO28lOSI29J?=
 =?us-ascii?Q?skwICF0lFfmvQJHKy8aXROz48IOmtkC/RVCWgIJemrnGWJdkHgnqluLjc3nL?=
 =?us-ascii?Q?ucIpnnKGMAtI7hYhZtPpgX+vrtI=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbdff89e-3a04-43fc-474d-08d9d064a332
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB5050.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2022 16:01:30.4423
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Wt15SDHAcCGMIG2xj9dUdI4IdFEhyHfyh7gN/Ed3XjtAOqBuWK/UVJbeH5AuD/2Q5gzLQiMbzQlYclMkk+z65A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7897
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 05.01.22 16:51, Aaron Ma wrote:
> This reverts commit f77b83b5bbab53d2be339184838b19ed2c62c0a5.
>
> This change breaks multiple usb to ethernet dongles attached on Lenovo
> USB hub.

Hi,

now we should maybe discuss a sensible way to identify device
that should use passthrough. Are your reasons to not have a list
of devices maintainability or is it impossible?

=C2=A0=C2=A0=C2=A0 Regards
=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 Oliver

