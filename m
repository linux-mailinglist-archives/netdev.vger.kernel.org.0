Return-Path: <netdev+bounces-9327-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 991F8728746
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 20:33:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DDB191C21078
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 18:33:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 987541429B;
	Thu,  8 Jun 2023 18:33:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85EE3200C0
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 18:33:40 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2078.outbound.protection.outlook.com [40.107.237.78])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C513C2136
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 11:33:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WzHPkExTmVYF7aRE+uwjqWLi9XjLMyG8wZUB+nKf2IUcVxr/z7Ad6afBUlxtLaUPZnW6JbIhyEX07dtYcLXQ5WpWYCYYhWApQkaKYzjOEZuMLxBg0Qgi+dnkhpTRNMIeSmE9tZtqPbWv10A1dp5EriYRImq9U+4WRly7rD81ao786bt9bTnwcvKWnnil9O42yvJsPFQGc8E7mH1DD7xQtD8ZY+PPgzxPVFOEW5wY92lQ1fWAFLxUlxJ9VbiCxFLA4xg7yJlItl2JTaapxw0ugDYkCwGQ+Wi4pwCgUB9GdJ9BzBxY7goqycI/PIBWh1wSyKjcnRwZTciBYs6n+/T4ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qu+adsXDPx7gk841XHIBVVVEiO0LS34MOASbhwN7gkk=;
 b=IVo6fcitXzBGPEU7ugA6b+s030l5oCLw4xlwXk03cOXteUOK9DDBTLP1p+APQuIwQ0wPDV2ULVTUvGD/J6Mmlnr0Xec3iJjDS+gsZ+ZBtm1ExdphE82+j1OqGoIhR1W/RG6pJmG8hzExbMjl5trp/niLZZLQz0nOlgL0JKpbFb0AiYy/bbTupoxbIy+THAo5UkEgzZ1xqESobOLzHFRiGVd0sneKPSroQKtAznUG2Ldp/LauK5Rc4538ITtdccZ26umxoPopc6W3lxVnQNFbt81savDcHduTzIp9Ft4f5xY7IUIdhE1zqDEkCODdVBheKK0TT+g33B7GWGJO/vF4IA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qu+adsXDPx7gk841XHIBVVVEiO0LS34MOASbhwN7gkk=;
 b=fHlJwP0KMuE4Dubq58cY9tWBSJgpOKyV98gbOwQCW6Cv1O7Efa2qqoNdA06ZDlkJn484ScLlu8tCtZgJT1CdPlOjTJgFWYyaN6ZDVdWuqt1mk0plkzf6TMDGJhNyQnxn5mejv7sCVSc3sN/6CyONsyUWBbSaDsRTANRRWph3LqB+hE5kQZYNeWEUx0DXMBlya71Vm1VNK7e1NV70ffx9payLswA8ORMOZb8a+/kHFZFT5oWfDJ4EgSn/yzeTGTRg78RSprIDoOfUFX3QwCdzgz0KdQf8/GS2etMj2ZhteleV+pmxaZA2jiskLx3U3bjHR3btT3LMYux1eb4X/BY6Tg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB2743.namprd12.prod.outlook.com (2603:10b6:a03:61::28)
 by DM8PR12MB5464.namprd12.prod.outlook.com (2603:10b6:8:3d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Thu, 8 Jun
 2023 18:33:33 +0000
Received: from BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::ecb0:2f8e:c4bf:b471]) by BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::ecb0:2f8e:c4bf:b471%6]) with mapi id 15.20.6455.030; Thu, 8 Jun 2023
 18:33:33 +0000
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
Date: Thu, 08 Jun 2023 11:33:13 -0700
In-Reply-To: <87r0r4l1v6.fsf@nvidia.com> (Rahul Rameshbabu's message of "Thu,
	25 May 2023 11:09:17 -0700")
Message-ID: <871qilg5xy.fsf@nvidia.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0174.namprd05.prod.outlook.com
 (2603:10b6:a03:339::29) To BYAPR12MB2743.namprd12.prod.outlook.com
 (2603:10b6:a03:61::28)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB2743:EE_|DM8PR12MB5464:EE_
X-MS-Office365-Filtering-Correlation-Id: f7d07998-9212-4e96-cea8-08db684edd4e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	gZ9Yn2sbACUQfpEVTtdHtPzRAUWW9X0w8tfWrcEu/Skd2FxnX8ZsL7o1ToZbuZnSY/MlmQM3MaHgGgEwNiAGZafE6KSEQz84BY6FFGNq4Pai+boxP4cTLXllU1BVz3zkJzKXSBgEoUc/dgWTPWKjFwlGr5vx1r68ABLfJqDmfMG1g7tL2RkWTLkhmwmwGcROpw6IWeTcqNq9rtmmIR4dKNam6CKJshg6/6kbaSKqna5EDn6IoyvsyLW1bOoI/YyKEnD0JT1J9kbdw8x+M4+Bh4NFdCrVa8mXGFl/008KUW9CXQWRvg7jmEEd4ubrkG+gz/rIg120z7uDmf09jsGoNmPJI7JQxrO4uelxx2w1f+srMLxiQI9V++RnFkIQ6qdtfaDb+EBUPBHg/lU52K1rsTDZz0+xbGXzRv+BS8ReljDxIg1pJv6gbCr7+xT4T2D1I66vbnFtFyeCmIgVk6FRGNv+X/CuHyZ/qOn5vlmZgyl3tcHDtB8b0JOaZu1MvV8+Hmh9XMs6WpRP3G1TVaLaMxURHXLwU5sHCWvXSArluRSZwkOoNixO6orSL3jDxU7LNBNAXHQ2u/f2stTuWZgP+CXZubwXI6laMDCbn9W9aKvBXXe2y6VmM6T9QLzuPhxW
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2743.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(136003)(366004)(376002)(396003)(346002)(451199021)(66476007)(478600001)(66946007)(6916009)(316002)(2906002)(8936002)(4326008)(41300700001)(8676002)(54906003)(66556008)(6666004)(6486002)(5660300002)(26005)(6512007)(6506007)(2616005)(38100700002)(186003)(36756003)(83380400001)(86362001)(142923001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6O0MjRi796qwp0k/XHfp0rvra1PbPKT3gzkgiQpnat9JxJehjD/2QKp0ARue?=
 =?us-ascii?Q?MOpIlAvjTZnBh6oQgFUfX/sz823CQAle0m8D/iE1KGtBFWfSF1AYEZcDO43Z?=
 =?us-ascii?Q?fzAN6q4/BHrCAwqszkhvBbtYzYDukOAghvoi+asE3ehtxkoBV1k1UhvCjDB5?=
 =?us-ascii?Q?uwgFY/YTUU8u47GxRq6Oo7vSzDnX8G38UUbGZQhwj2lBeZ44WTrT71w9NwET?=
 =?us-ascii?Q?hqusKaq63nerp3Y1W+j4xagFKL1kbeMuJdpaMVrGoS/8h+0h/L9/YtbymU7g?=
 =?us-ascii?Q?a+W4crPAsD8qIPN3NaFZEdc1a4YC9QiGHaxqJipQOvf7TkhXxWKcq5Gx7jrT?=
 =?us-ascii?Q?Z/ZbdVkrGsGg+DHq5kU1UzbpBajh+oigLENiQvKmfB5nPhAYQfsL1FAqPCAo?=
 =?us-ascii?Q?55YySi0dDVLytE9iu1jgWY0CNUbyR+C3lK9zRcyZQ70XIGAJT1KCWLhn8Czg?=
 =?us-ascii?Q?fZMOjN/ZQNCsiaqU0VP70NxaSz8TN+TZkkE72M06uPHrzmtLDxzB8ofVQV+Q?=
 =?us-ascii?Q?9Md4CLdxa2efBQ/fInd4A1Vgw5zpTh3Do4KzsilMGNMjzVYwb33XOMS26Ql6?=
 =?us-ascii?Q?AALXIivoM4Wk1ebCJl4HkgQbdFnSYmjXo7Ef2vovfNBQODiYpTUEsZaArvdU?=
 =?us-ascii?Q?sUMDVZyLTjtsdJQ2cXM+k3unfVvoj6dTG/U+nYJQdrNESgZAjZcAVX6qxpl2?=
 =?us-ascii?Q?BJ1Zb9MxzTObR68zSQg+RSXFACLXK2D1ojyubC7MebfAQnTKS3CZph5DFtrZ?=
 =?us-ascii?Q?jf39IdkQgo81nVtd6tVj7uD+K626a0p8QA3u081oI0Rs7UKwuWv/SgxeJpuh?=
 =?us-ascii?Q?Mx9PctzaRFxY2JPreAwb/YN6aLJpmqedmX738XRi21kXHBzcNc6OehJ9GWQc?=
 =?us-ascii?Q?1oh8WxomvJLGf9Y+MK6QVykbIWMvbd++2LyYlycxF0kbgVnA2347gF/IPPRz?=
 =?us-ascii?Q?wbZOscGg+5pw8YY7grFYZ/EVoYKx1BZEev0pSKlSffokkiM7bMMeOXoyUZ8x?=
 =?us-ascii?Q?MN1veHDJcRAF5R0XYurG6vA81QGrpFmUTvmdxK8Tkzb8URB13SmBGFOM/nXD?=
 =?us-ascii?Q?mNoEm5ZFAjcEhSZv/wRoRtW2Ne6ATEOXhP97HlxrugVI0JC0O4o6+iwdDk7U?=
 =?us-ascii?Q?moaBuuscU+Pxp3YDe+0Z/plU2CO0pnI4zCwQtzoEYjK3eRAxvLaqdEgiyqb4?=
 =?us-ascii?Q?XQMmcBNRisnnLZnpqTlNwHbMBHapwSPwU7SOTQBgeRXpUVoBH/+ocO6FJGeH?=
 =?us-ascii?Q?QjsHQsQ/DHtTGsYeE+3M0RnsKN7bLv3Ej8uQ9jO5Uq/3pB42nErSzMhn+rT4?=
 =?us-ascii?Q?Ftnk7sjnJ5oT6sROWMsuRVkUrBsaCx6UrrQLvHrfaOoLYp8dSk4jhq+KDkyx?=
 =?us-ascii?Q?3/1nIhNXG15sinngZRtt04voJkic2Qu6OsZjgbdsviLCNFlfcWPwLP6KQXO+?=
 =?us-ascii?Q?D0rM4L/OUB6ZY726/jW+qvwtXU8v7aNg4G5It1AoqjmqCLBrl4sCmslL4UG3?=
 =?us-ascii?Q?DtlwQdmVB3wXTKcbEwyM7DU+ND8CiX8IbR9JzyUnybeTU+DUYHA1Aj4siCTQ?=
 =?us-ascii?Q?QTJzsIXrH9njidwhFAZat5NPVUlZzOsj4sdLySncNFKx/8Z5CTiHaoIiJQ6K?=
 =?us-ascii?Q?3A=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7d07998-9212-4e96-cea8-08db684edd4e
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2743.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2023 18:33:33.6130
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f4Y4Brjs+zt32tFqVOLkNpveIFd7phre90Hv0qPrSHQ0h2cgD0zvMFgIKzCode4cE8teD5HQwNWHvsJikfgnHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5464
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Paolo,

Any comments on this follow-up?

On Thu, 25 May, 2023 11:09:17 -0700 Rahul Rameshbabu <rrameshbabu@nvidia.com> wrote:
> On Thu, 25 May, 2023 14:11:51 +0200 Paolo Abeni <pabeni@redhat.com> wrote:
>> On Thu, 2023-05-25 at 14:08 +0200, Paolo Abeni wrote:
>>> On Tue, 2023-05-23 at 13:54 -0700, Rahul Rameshbabu wrote:
>>> > Advertise the maximum offset the .adjphase callback is capable of
>>> > supporting in nanoseconds for IDT ClockMatrix devices.
>>> > 
>>> > Cc: Richard Cochran <richardcochran@gmail.com>
>>> > Cc: Vincent Cheng <vincent.cheng.xh@renesas.com>
>>> > Signed-off-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
>>> > ---
>>> >  drivers/ptp/ptp_clockmatrix.c | 36 +++++++++++++++++------------------
>>> >  drivers/ptp/ptp_clockmatrix.h |  2 +-
>>> >  2 files changed, 18 insertions(+), 20 deletions(-)
>>> > 
>>> > diff --git a/drivers/ptp/ptp_clockmatrix.c b/drivers/ptp/ptp_clockmatrix.c
>>> > index c9d451bf89e2..f6f9d4adce04 100644
>>> > --- a/drivers/ptp/ptp_clockmatrix.c
>>> > +++ b/drivers/ptp/ptp_clockmatrix.c
>>> > @@ -1692,14 +1692,23 @@ static int initialize_dco_operating_mode(struct idtcm_channel *channel)
>>> >  /* PTP Hardware Clock interface */
>>> >  
>>> >  /*
>>> > - * Maximum absolute value for write phase offset in picoseconds
>>> > - *
>>> > - * @channel:  channel
>>> > - * @delta_ns: delta in nanoseconds
>>> > + * Maximum absolute value for write phase offset in nanoseconds
>>> >   *
>>> >   * Destination signed register is 32-bit register in resolution of 50ps
>>> >   *
>>> > - * 0x7fffffff * 50 =  2147483647 * 50 = 107374182350
>>> > + * 0x7fffffff * 50 =  2147483647 * 50 = 107374182350 ps
>>> > + * Represent 107374182350 ps as 107374182 ns
>>> > + */
>>> > +static s32 idtcm_getmaxphase(struct ptp_clock_info *ptp __always_unused)
>>> > +{
>>> > +	return MAX_ABS_WRITE_PHASE_NANOSECONDS;
>>> > +}
>>> 
>>> This introduces a functional change WRT the current code. Prior to this
>>> patch ClockMatrix tries to adjust phase delta even above
>>> MAX_ABS_WRITE_PHASE_NANOSECONDS, limiting the delta to such value.
>>> After this patch it will error out.
>
> My understanding is the syscall for adjphase, clock_adjtime, cannot
> represent an offset granularity smaller than nanoseconds using the
> struct timex offset member. To me, it seems that adjusting a delta above
> MAX_ABS_WRITE_PHASE_NANOSECONDS (due to support for higher precision
> units by the device), while supported by the device driver, would not be
> a capability utilized by any interface that would invoke the .adjphase
> callback implemented by ClockMatrix. The parameter doc comments even
> describe the delta provided is in nanoseconds, which is why the
> parameter was named delta_ns. Therefore, the increased precision in ps
> is lost either way.
>
>>> 
>>> Perhaps a more conservative approach would be keeping the existing
>>> logic in _idtcm_adjphase and let idtcm_getmaxphase return  
>>> S32_MAX?
>
> I personally do not like the idea of a device driver circumventing the
> PTP core stack for the check and implementing its own check. I can
> understand this choice potentially if the precision supported that is
> greater than nanosecond representation was utilized. I think this will
> depend on the outcome of the discussion of the previous point.
>
>>> 
>>> Note that even that will error out for delta == S32_MIN so perhaps an
>>> API change to allow the driver specify unlimited delta would be useful
>>> (possibly regardless of the above).
>>
>> What about allowing drivers with no getmaxphase() callback, meaning
>> such drivers allow adjusting unlimited phase delta? 
>
> I think this relates to the idea that even with "unlimited" adjustment
> support, the driver is still bound by the parameter value range for the
> .adjphase interface. Therefore, there really is not a way to support
> "unlimited" delta per-say. I understand the argument that the interface
> + check in the ptp core stack will limit the adjustment range to be
> [S32_MIN + 1, S32_MAX - 1] at most rather than [S32_MIN, S32_MAX].
> However, I feel that if such large offset adjustments are needed, a
> difference of one nanosecond in either extreme is not a large loss.
>
> The reason I wanted to enforce device drivers to implement .getmaxphase
> was to discourage/avoid drivers from implementing their own range checks
> in .adjphase since there is a core check in the ptp_clock_adjtime
> function invoked when userspace calls the clock_adjtime syscall for the
> ADJ_OFFSET operation. Maybe this is just something to be discussed
> during each code review instead when implementers publish support to the
> mailing list?
>

I am pretty open to revising this, but I wanted to know if your opinion
is still the same based on this response I provided.

>>
>> Thanks!
>>
>> Paolo
>
> Thanks for the feedback,
>
> Rahul Rameshbabu

Thanks,

-- Rahul Rameshbabu

