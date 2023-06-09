Return-Path: <netdev+bounces-9692-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E817072A358
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 21:48:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7760B281A13
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 19:48:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD4C72099E;
	Fri,  9 Jun 2023 19:48:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97C8E1800E
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 19:48:02 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2066.outbound.protection.outlook.com [40.107.243.66])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D932211C
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 12:48:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c9yZR8xN3lbBXyp4Fk5PnLyjBRNQiCzjqPjB1TkfgwMkawPOV0C3tLoPGz0MJgJjN5QXOgrw9Mkgda7YAjzAuxlef+K/Advby/HuhM9jQ4DR68oHfeoXGC1iqIsnJT2ofZc06jSRxkxJAwSPkJdJxsfYKpoPhspb7PtLlo75tIgIaJr+2kgP34n9V1ege59tvvPzC92WQFMMC18Iy6B0A+q85nsFnqm4Q27STEcIQ0DoCf7V8wKmsEDMieoRgSfV7q4TTfXJiWsTVPhQKOHY2idDAPBlMfjfinJMNpm6HngKWGOC1hNCIjSOoFoLYnF/IjwZrlIz0Fal6a0RH4czCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rT4dCcOBEmhQNXPo/FOf3tivz3Bhjf9pjP+lb0KQDvU=;
 b=dsyhmLSatTptTIjdKCY2+hzwL6wPFT5Wzko6GuktBitM4g0UesYHUA34ZrHm5AvJ/VGBhuGbiL+LuamYuInCeB9yiA7epKn9CleEHkg7wO72fdPF5hZpPnx+DGkZRTR1rGQo+z6WRme2231ahkgEwKHdrDoqhgIugDETJI9HY6+JHJpxQtDgfEDted4An1+tqoNAKPxMW0pSySPiljThJP8xo/TZ0njEIYmpDlHeXHLVQqArJdSSWQ3Bt8h6SuP78kZLCZlIzP/Vmg+nGA9whc1eBzqSQMdLq2PLLvcI3GilEn3TYj5JB/RvdzNTfQzfAMX85AkKb/QbvE2lODtvyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rT4dCcOBEmhQNXPo/FOf3tivz3Bhjf9pjP+lb0KQDvU=;
 b=PryByGbjYZrjc4hFi7ig1VyPhS5Ns2iMIwP7G5Ll/1j2aajBHR8UbpoaEWt8txUaAV+2jPEX32sPFNriUzdp5J6Tk9M3Grl5u/4+G+zi4tdp9ECMrjhCRFbG1DHTkt/nXWNeAPUIdazyQtxiAzqyFrU5BWgoXYncRX/tOfaAFm6Ia8bZBUG6K4j5n4ad7NDyWLyikgyIPrDoiOL3sU746C31KrGzsKoHem6kgSxXIK2xzqEX9WL/tc9AmM9/p32iWhYtCRWFYZ/hnOJnxLsqGroK9uIkGZSIkDGKo+4DYX86iSQfDiNe7pKgg4vncYGSkrlJHZgSP8GpsRbEMewQ7Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB2743.namprd12.prod.outlook.com (2603:10b6:a03:61::28)
 by PH0PR12MB8799.namprd12.prod.outlook.com (2603:10b6:510:28e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Fri, 9 Jun
 2023 19:47:55 +0000
Received: from BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::ecb0:2f8e:c4bf:b471]) by BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::ecb0:2f8e:c4bf:b471%6]) with mapi id 15.20.6455.030; Fri, 9 Jun 2023
 19:47:55 +0000
From: Rahul Rameshbabu <rrameshbabu@nvidia.com>
To: Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org,  "David S. Miller" <davem@davemloft.net>,  Jacob
 Keller <jacob.e.keller@intel.com>,  Gal Pressman <gal@nvidia.com>,  Tariq
 Toukan <tariqt@nvidia.com>,  Saeed Mahameed <saeed@kernel.org>,  Richard
 Cochran <richardcochran@gmail.com>,  Vincent Cheng
 <vincent.cheng.xh@renesas.com>
Subject: Re: [PATCH net-next v2 7/9] ptp: ptp_clockmatrix: Add .getmaxphase
 ptp_clock_info callback
References: <20230523205440.326934-1-rrameshbabu@nvidia.com>
	<20230523205440.326934-8-rrameshbabu@nvidia.com>
	<3154076e84914b061de4147bb69b5fd7c224980a.camel@redhat.com>
	<1936998c56851370a10f974b8cc5fb68e9a039a5.camel@redhat.com>
	<87r0r4l1v6.fsf@nvidia.com>
	<3fe84679d1588f62f874a4aa0214b44819983dc7.camel@redhat.com>
Date: Fri, 09 Jun 2023 12:47:40 -0700
In-Reply-To: <3fe84679d1588f62f874a4aa0214b44819983dc7.camel@redhat.com>
	(Paolo Abeni's message of "Fri, 09 Jun 2023 08:38:11 +0200")
Message-ID: <87fs70wh7n.fsf@nvidia.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BYAPR06CA0007.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::20) To BYAPR12MB2743.namprd12.prod.outlook.com
 (2603:10b6:a03:61::28)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB2743:EE_|PH0PR12MB8799:EE_
X-MS-Office365-Filtering-Correlation-Id: 2568f0e7-a46a-49a7-b5ba-08db69226aeb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	txnETv5TuSV1e5NueUgJuxNpkT1SYCaKhZxyQQBRqHiNyQO8GqV+gmykuK71TcGbAEaPHdbAGABZoHGewYnECCyGS/Qp0XmijENc7fiYZaeBsnWKL4f56DVDlPOh/NowLw1s0dqU2Irs0s2y28SiNmBCDoqd7otnXo9exOdxsFvTZ/+7bldTZSl0NYHekX07fSywdyvIuR2NI8PtEhDn3/R9nRUUP0l8kgr/wtjejB53ZgiBIoW1YtdW5VnhXSva7wXkHhvOY+o6lwm9XdE/DFnyLEXJIZvMNIFurvzuzGkLGJd9yyVrAKYs3V3kS5oBZTL7w4GR0ue8/8HgKo5Y5y7T/S04PJtJcZfHkWOXyo7tlq18AUvssxBaUcymiNmTvlWQFo3y41V9S+8zVZFUXtEGyZY2YDqhFSyMUGteJXr697YBwMloDszZw8it0rKQmxrjX6IInYasVAGdfdQODsNPgFH+oYgCp25YJIo5eDIv/0Qcapu1PQYUJzoG3hRZULmn+T5jq6aHf9U+Cf45pTULhSwd9jhCaIG3z+kp4g9gBejiaynQTHw3DFwnHlsv/BN1xT4r1krgmkrSM4/qMwEpSZr9A17c+um60OZi9kk8gL+cq40gHBrg3a57GADy
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2743.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39860400002)(136003)(396003)(376002)(346002)(451199021)(83380400001)(38100700002)(86362001)(478600001)(41300700001)(6666004)(54906003)(6486002)(8676002)(4326008)(66556008)(8936002)(6916009)(2906002)(66476007)(66946007)(316002)(5660300002)(2616005)(6506007)(26005)(6512007)(36756003)(186003)(142923001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?V3dtdktVd1RrekNVanV3cXAxVFJjZTlsb01YZm84Z2h4RGl5WTdYM1ZvdTNI?=
 =?utf-8?B?T2hHL0V0WWtFc1RJemFBWTh0V1N3M3A2WEdNNGZzM0gvc0ovQUR4dDdOZnRY?=
 =?utf-8?B?VjYwVjVZMWtacCtXYjNaTzA4dHE2TEVhRWdBdzZKNGV3OGkrbVROOEpmdWxw?=
 =?utf-8?B?aHZKaXBxNXorWStDOUFrQ1RZZWhvUnFpMWJJdGN1bXVabk1yak5JZ3JENXZT?=
 =?utf-8?B?V0ROTXd5Z0hJbkJJZTZCVUNLQndHVnhlcGRlNVpOd1puTHBRQ1VocGp5b3Bx?=
 =?utf-8?B?M1Exd0c4K1Vibjc1ZmxkVHRXZ2FnRUY5cFNYT01sWk8yL1NKa2l2bDhYeVV1?=
 =?utf-8?B?KzgrOUFqUXJrbEFRM0hyVS95R0V6QjJHREdUL2pKZzhvRU9abHhmTnFtMU9u?=
 =?utf-8?B?S1ErVU05L0xaOUVlQzFUNWsxVXFWNlZPclVhOGZsT0tvQWZxc2d6bXZ3UXAv?=
 =?utf-8?B?Q1d5SldENUxEblhKOFY2dXBUd05vR3Y5QWRUUUJFbVFKL3d6aHJiQ3BDSjR3?=
 =?utf-8?B?d2hESHZJNkt3c0FvNXQ4RkRLQmp2ZDJyblNjWURnV2VrcHcwR3NLdWNONE1I?=
 =?utf-8?B?MHI0OFBHbG5MZVU2MXEwRlRDSUNhR1kvdlhtNWx2YmQ0RUFkTis5dnU3cXF0?=
 =?utf-8?B?d0VGUHIwcStUcUJETU5adHFpa3I4bUlNSW1SWU85ai9FYytHVHZVS09wTDhQ?=
 =?utf-8?B?bkluaHM3WEpJRnExMkJhUzFqMUl1SDN5d3BMWFZYWGhvMXZmNTBVemx6a0J2?=
 =?utf-8?B?MGlNR04zOVYvL3JManBMaHd0aFAvTEE2QVZnZktObzBGYkNRbVlnWTNuMjlM?=
 =?utf-8?B?L1ZGc0pNSEJMR3NsTDlCVUZXNWllQnVJSkV2aTdFY1UzaklBZVFvejNyRmtN?=
 =?utf-8?B?YjIxaEJ3RG1UakI3S0E4NUxsYkROQ0pjNXVPNUErVkFGWDI5dlFDand4RW81?=
 =?utf-8?B?U3pqMGlXeER2Qis5bGs4V011clZPTGxjbDQwZlBmU3lNdXBNOTBDU0JDbkxm?=
 =?utf-8?B?elZzUVpRWFNNaExLUVhwMG11dCtrdE1kNmd2c0hFamVMaDRXQjdEa2xzQnhw?=
 =?utf-8?B?V3NRb2lxM1lHMWVuTjNzc2FIZUIwdGMydTd2UWhGVERSWDhpMlhCN1lpZndB?=
 =?utf-8?B?b1NNc1p5MHZ3SndZWHBDVVJ0djE5VXB3b0FqdU14bmx3aFVtT0txd0RLN1Mw?=
 =?utf-8?B?SXpTc2F3NVZDWHJibTJSUmdiTDFkVVAvbFE0NjVzaWhteWdXUjlKdmIyaStj?=
 =?utf-8?B?YURVRWtvYmJXZ0t4Y1MzcXh3bFJ0d2FtVEFzRmlVZTNCMm5helZxbmExY2Ri?=
 =?utf-8?B?eXJndk9CcTZXR1hLZlFzUjgrdDRVTWtVTFRrcldzOEZicW05cW5pa01lMGFo?=
 =?utf-8?B?NUtseFVFTmhFTFhUUWNUdWlWSk5DTDQ2TVdxcjNPMVdKWVZsekhkbE1na0F2?=
 =?utf-8?B?cGNSeFk0N3JHQmc2SmlPY3JPSVdkYkJQaDJzSDBMU1ZSUXc0T2hYSHJTMGRX?=
 =?utf-8?B?cm1qVnYrMVplZGpGeWczbFNZQlpCVTNCODVuQWNDaTBJaUJjVWlHeXhWMjVY?=
 =?utf-8?B?US93MjFqS0EvZEdRUUc2c2pwSUZsMXJQMHBiVmpwWTh0ZFNDREZoVTBndEY0?=
 =?utf-8?B?eEdyMHo2eEhBcGYxeEZLM0RwVStuZ1NQWCtTYVZvYTJnWmZqcklvWi9kS2hy?=
 =?utf-8?B?Qzd1Yjhvc3pwL3RLc1V0K092QzN0YjhTcmZWTldUSFhPa0R2bytLVGE1eklG?=
 =?utf-8?B?NVhPYWJMZVBGVkg5WmgrQ2w2K0FabDc5YUpKbGRFamNtR0JSajhWclZPVEV5?=
 =?utf-8?B?S1RnV1kwVEJXZXd4dXpRZ0ZWQXpyb1BkKzZXTlI1cEFmS1ZRSFNVb21UbzFF?=
 =?utf-8?B?ZUpUVUJrQm1tb2I0Nk1RNWovQ2JPQ3hIaDdjM2NBSXFMdktHZU1ZQkkrYnJv?=
 =?utf-8?B?cHFTSFgrUEoxbU1CbXo1Zk5ROGgzSm05T1dlSDI4U0tHQjdEc3F1T0lYSHYx?=
 =?utf-8?B?anFWTElWdU0yZjBMT2FLTDIvYnRMek8yUVlYRCs2T09mNnEvZ21CMjlOMXBs?=
 =?utf-8?B?N2R1QnlpMjhSbDV4cEdHd0xtVVZ0bVNoSW5qbzVLQllTZklnUW9XbUxTU2k1?=
 =?utf-8?Q?mIrviHEaPa+WGDKkNmcamv1V0?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2568f0e7-a46a-49a7-b5ba-08db69226aeb
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2743.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2023 19:47:55.8433
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gz3vwUQ/jrjnuM3Df9CwF/rSGXHn7Wnei6E+4BbeqLTFs9EU59O9AyB2o6Y2JFMIWksc0Vp77Ot0J/yDP7jMLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8799
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, 09 Jun, 2023 08:38:11 +0200 Paolo Abeni <pabeni@redhat.com> wrote:
> Hi,
>
> I'm sorry for the late reply. This fell under my radar.
>
> On Thu, 2023-05-25 at 11:09 -0700, Rahul Rameshbabu wrote:
>> On Thu, 25 May, 2023 14:11:51 +0200 Paolo Abeni <pabeni@redhat.com> wrot=
e:
>> > On Thu, 2023-05-25 at 14:08 +0200, Paolo Abeni wrote:
>> > > > diff --git a/drivers/ptp/ptp_clockmatrix.c b/drivers/ptp/ptp_clock=
matrix.c
>> > > > index c9d451bf89e2..f6f9d4adce04 100644
>> > > > --- a/drivers/ptp/ptp_clockmatrix.c
>> > > > +++ b/drivers/ptp/ptp_clockmatrix.c
>> > > > @@ -1692,14 +1692,23 @@ static int initialize_dco_operating_mode(s=
truct idtcm_channel *channel)
>> > > >  /* PTP Hardware Clock interface */
>> > > > =20
>> > > >  /*
>> > > > - * Maximum absolute value for write phase offset in picoseconds
>> > > > - *
>> > > > - * @channel:  channel
>> > > > - * @delta_ns: delta in nanoseconds
>> > > > + * Maximum absolute value for write phase offset in nanoseconds
>> > > >   *
>> > > >   * Destination signed register is 32-bit register in resolution o=
f 50ps
>> > > >   *
>> > > > - * 0x7fffffff * 50 =3D  2147483647 * 50 =3D 107374182350
>> > > > + * 0x7fffffff * 50 =3D  2147483647 * 50 =3D 107374182350 ps
>> > > > + * Represent 107374182350 ps as 107374182 ns
>> > > > + */
>> > > > +static s32 idtcm_getmaxphase(struct ptp_clock_info *ptp __always_=
unused)
>> > > > +{
>> > > > +	return MAX_ABS_WRITE_PHASE_NANOSECONDS;
>> > > > +}
>> > >=20
>> > > This introduces a functional change WRT the current code. Prior to t=
his
>> > > patch ClockMatrix tries to adjust phase delta even above
>> > > MAX_ABS_WRITE_PHASE_NANOSECONDS, limiting the delta to such value.
>> > > After this patch it will error out.
>>=20
>> My understanding is the syscall for adjphase, clock_adjtime, cannot
>> represent an offset granularity smaller than nanoseconds using the
>> struct timex offset member.=C2=A0
>
> Ok.
>
>> To me, it seems that adjusting a delta above
>> MAX_ABS_WRITE_PHASE_NANOSECONDS (due to support for higher precision
>> units by the device), while supported by the device driver, would not be
>> a capability utilized by any interface that would invoke the .adjphase
>> callback implemented by ClockMatrix.

I see I caused some confusion in terms of what I was focused on with
this response. My main concern here was still about supporting precision
units higher than nanoseconds. For example if a device was capable of
supporting 107374182350 picoseconds for ADJ_OFFSET, it doesn't matter
whether the driver advertises 107374182 nanoseconds as the maximum
adjustment capability versus 107374182350 picoseconds even though
107374182 nanoseconds < 107374182350 picoseconds because the granularity
of the parameter for the adjphase callback is in nanoseconds. I think we
have converged on this topic but not the other point you brought up.

>
> Here I don't follow. I must admit I know the ptp subsystem very little,
> but AFAICS, we could have e.g.
>
> clock_adjtime() // offset > 200 secs (200000000 usec)
>  -> do_clock_adjtime
>     -> kc->clock_adj
>        -> clock_posix_dynamic
>           -> pc_clock_adjtime
>              -> ptp_clock_adjtime
>                 -> _idtcm_adjphase // delta land unmodified up here
>
> I guess the user-space could pass such large delta (e.g. at boot
> time?!?). If so, with this patch we change an user-space observable
> behavior, and I think we should avoid that.

The point that you bring up here is about clamping (which is done by
idtcm_adjphase previously) versus throwing an error when out of range
(what is now done in ptp_clock_adjtime in this patch series). This was
something I was struggling with deciding on a unified behavior across
all drivers. For example, the mlx5_core driver chooses to return -ERANGE
when the delta landed on it is out of the range supported by the PHC of
the device. We chose to return an error because there was no mechanism
previously for the userspace to know what was the supported offset when
using ADJ_OFFSET with different PHC devices. If a user provides an
offset and no error is returned, the user would assume that offset had
been applied (there was no way to know that it was clamped from the
userspace). This patch series now adds the query for maximum supported
offset in the PTP_CLOCK_GETCAPS ioctl. In my opinion, I think we will
see an userspace observable behavior change either way unfortunately due
to the inconsistency among device drivers, which was one of the main
issues this patch submission targets. I am ok with making the common
behavior in ptp_clock_adjtime clamp the provided offset value instead of
throwing an error when out of range. In both cases, userspace programs
can handle the out-of-range case explicitly with a check against the
maximum offset value now advertised in PTP_CLOCK_GETCAPS. My personal
opinion is that since we have this inconsistency among device drivers
for handling out of range offsets that are currently provided as-is to
the driver-specific callback implementations, it makes sense to converge
to a version that returns an error when the userspace provides
out-of-range values rather than silently clamping these values. However,
I am open to either version as long as we have consistency and do not
leave this up to individual device-drivers to dictate since this adds
further complexity in the userspace when working with this syscall.

>
> Thanks
>
> Paolo

Thanks,

Rahul Rameshbabu

