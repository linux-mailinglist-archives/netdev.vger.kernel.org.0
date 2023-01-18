Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3B196712A2
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 05:32:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229528AbjAREcF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 23:32:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjAREcD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 23:32:03 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2047.outbound.protection.outlook.com [40.107.237.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDDB7539A5;
        Tue, 17 Jan 2023 20:32:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jkhhjXowehr13XZdMVv5vp6mJFDKRY+yOUdR4V8z7zbDCoYWmlaC0oaDDxQJoqYRIjKUG4s7fLj+NV1Sgocrk6t/WjfmX+a2A7VsPbQyyfPh8t0dzaEt/g1/P2NgGqiIq4vpveLViDAeYpf8uBwZvTEGgm5lW8YTN/a1xj/fEaeO7/LHxYfFW4BoneVhkX+MWrvjtSGuoqsmB+DYhPcwFlECMjrDokiFV6Y35CDMFuRiPgRbhl9/3a4iECOqbSx4W4wB9nGh6MW3tApVL1mQJtTlfc4UrhH5NSF18W9sjWRPYIhLa4222rLr+OgdoGi8oJvuuO2DRJ9IGwUdHcHogw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IiZYIJi/8102XrJZtdPZdoZHyjZ9xr8Kv17zBJG6TcY=;
 b=i6SSWbzra/ifziO+DdDGfA9m8qX2U3PCUWsJvrILs5VB7byqQD1hX/8RLESL/mPbLSm3620FZFWXF6WCH3sSnUM+A0TH9dJc2jHIIjuqFqYIZuVIdZyOL4xmju7I54LB9XfMLlR47k3oiNjp0YRGAYILs6kboe/ZM5hfy0h1MBZ0AoEFJMDopFHvqT9Fp2Z6P1JM8KrW115JnFVGzwirxOwXDMf3HtAUbpqnyOZkztOWnO4tdiu3qxe2NcI5/xNryYlJjnkVNsD2Ws7/qj1TvWXruiXglyr49NbntD2WT0GjhvSiG3pP3USy09lJJym9K7LUNvrEhALCshrVcNtp5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IiZYIJi/8102XrJZtdPZdoZHyjZ9xr8Kv17zBJG6TcY=;
 b=HvbRB1mKU7njyQ+f1HhXaZ1GEUCINqnnYa99ry7B4HeQuCKOilU0Et4sWNQQfWSKvYDxrFdCaPz+3ThBXv91v51cFZN9iocZc9ROHvIwjUkE8vCRS0vLhkuPGVxJwaN8Q2TkMzw71/ZY+uslOstKivaPnzTDgZ/CgqmK/Uns9KwoftkPYf/yiJwJkgtVgCi79e8shCpwcBcWGMZnyP3FgjjsOxwNfPEqWrJuDDEp5ZyB/gqeYGL0iObys3QtBBz0OB1buQiZNtXO2o4fjzcPn8J0Zl55ARVYlimBEZO+TX5HsuaHUX/a4aN7BnUw2ZqDMQyk1ztUREZlsT4j1+U6fQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB2743.namprd12.prod.outlook.com (2603:10b6:a03:61::28)
 by CH2PR12MB4905.namprd12.prod.outlook.com (2603:10b6:610:64::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24; Wed, 18 Jan
 2023 04:31:59 +0000
Received: from BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::8031:8093:2f25:f2ab]) by BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::8031:8093:2f25:f2ab%7]) with mapi id 15.20.5986.018; Wed, 18 Jan 2023
 04:31:59 +0000
From:   Rahul Rameshbabu <rrameshbabu@nvidia.com>
To:     Hariprasad Kelam <hkelam@marvell.com>
Cc:     Maxim Mikityanskiy <maxtram95@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        Jerin Jacob Kollanukkaran <jerinj@marvell.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>,
        Naveen Mamindlapalli <naveenm@marvell.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Gal Pressman <gal@nvidia.com>
Subject: Re: [net-next PATCH 1/5] sch_htb: Allow HTB priority parameter in
 offload mode
References: <20230112173120.23312-1-hkelam@marvell.com>
        <20230112173120.23312-2-hkelam@marvell.com>
        <Y8FMWs3XKuI+t0zW@mail.gmail.com> <87k01q400j.fsf@nvidia.com>
        <Y8IKTP1hf21oLYvL@mail.gmail.com>
        <PH0PR18MB44748B397A3C1BCBFD57D9D5DEC19@PH0PR18MB4474.namprd18.prod.outlook.com>
Date:   Tue, 17 Jan 2023 20:31:40 -0800
In-Reply-To: <PH0PR18MB44748B397A3C1BCBFD57D9D5DEC19@PH0PR18MB4474.namprd18.prod.outlook.com>
        (Hariprasad Kelam's message of "Mon, 16 Jan 2023 05:18:32 +0000")
Message-ID: <87wn5kjwer.fsf@nvidia.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.1 (gnu/linux)
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0076.namprd13.prod.outlook.com
 (2603:10b6:a03:2c4::21) To BYAPR12MB2743.namprd12.prod.outlook.com
 (2603:10b6:a03:61::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB2743:EE_|CH2PR12MB4905:EE_
X-MS-Office365-Filtering-Correlation-Id: 1dccce01-4dd1-46f7-28cb-08daf90cf074
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kyd4S9IivkrE1c5j49vhaHbTEIyxOFA66hhSvDEw4m83RyvPd03FTvxaPfINfeVs5TOFs7PVcRpIaKQxWqzXxHtja9Gp0BGdN/0C5m6NuR0lUZGcdpQYxYxEbpHxZbuHEuMYmpFcF3rYV+DFXjh+qFFU4ENHlAamI7JTVFIfRyEgAbZM53KQaUHTNQgGnpN6AeHwC3AM2+iC0Oad9+OsJoYLnk8YlqCHlWcOE33GPf1nhdSIBWS3RsPAvGABAPaPalzaRB6tIl99kI0u9BD4gl7nfZldx7ezz48gHB1bDLsgZ2HzniuayY9s7oTYRbMbhNDpK/DIFwkNDU3tOE89Eyb4QTj+0yhsas6GaLyrTg7r9lJQ+8Zk2A1+QoNUd9ik5WLCp4A/vTGT3M+wnFLw856VRpRr3/NX81Bv5TbCgfPTU4JyZIOsG3daZ46F/YeudyEOB7RiraaGW1dtvLwHiDf7/JUsOj/NX4nbUK8I5Kxuru5cUQ3ohBAAw8mgFrmQwABq8zBCWsbSGk0qkREdEzla+iPJIu6t9re0CSwElZemVmAMOiI00I8c69opF9QPFiMoroE/NNN+ksRAzDscNp3bq/6dlt8fdMY1ux+vYcC9s8053lmCiP7wwewk6coTH/8qLF2J5C8qVPFn9IdaKC7dC6o2/zSW73uv3A98sWIFQzLMy474KKm4MWWIeWTD9+/mxtt3bn+lA0PTOqfaCapiA5S5ch77Ivg4CGg3XZozeEZH5HEut19AoQJZOGZ/ttvSd0o+PgosS6h2187eLQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2743.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(366004)(39860400002)(346002)(376002)(136003)(451199015)(8936002)(5660300002)(41300700001)(6916009)(8676002)(66476007)(66556008)(66946007)(4326008)(36756003)(2906002)(7416002)(478600001)(966005)(6486002)(86362001)(2616005)(6666004)(107886003)(186003)(6512007)(6506007)(316002)(54906003)(38100700002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?d1cBZs+JCGisaJg2lbPSkhxDcLDe1H3Rm2Bu/jH1QcEKuagHacV1UaS24ZX6?=
 =?us-ascii?Q?33ph6IqXjFEwge1tFK7ahgBvZ79bWT+NRv9gyjIHmBGy1hoxcrCFlorVg5ho?=
 =?us-ascii?Q?D6lE+SQWJ+ayZBqaNEGTmbCbm0VqmtofJi7gUbrG6bt8vBvoBQ0m1T5GF/Sg?=
 =?us-ascii?Q?dp7Yz9A3vXHjkIIqSZ0jvILDRX7uhg2U9IbMTZzVSafpcrNliP6EHlOljUh8?=
 =?us-ascii?Q?o/oI1E0LQz4ZQXDUQETXn24MTlxA3Awv90WqEs5JScx+Lea74NDYsn4DEJ9I?=
 =?us-ascii?Q?2DeztZlE/w+guYr4BG+tHmDSrH1nlNfeHhhQY3F1vMCVn/Yqoln8I62BEFwb?=
 =?us-ascii?Q?xMk0Svgq+zzyVEIQ2jP88A3wuPCQRxMaGuy2FBtN8Q03ENK6B2DmHmIIIMaC?=
 =?us-ascii?Q?2FO/JGT2BFYqVnkxsdj1cjT7p6BNk28YkHaaurNlSTg0K+HGHOhVPHe7u31f?=
 =?us-ascii?Q?dmqkPqcKwgctFzgnT/dgtX/Q4/IJvtF6izrfWhq8C/tNQfufXPHA3V3VdSYw?=
 =?us-ascii?Q?0t+obhy5kV10X8lA+Jm/N4KxTcqelC/ZVqtpN91yKOOu55h6k5CKMgKdd8S/?=
 =?us-ascii?Q?BPlT5yLVwMhaIcoz+gwpbP8Pdku68bp1WHmepy1ppfcQqyCSFzsYmqXhqmfm?=
 =?us-ascii?Q?JSCt0XiT1Tl+QX9Wy/HONY9nMJ3X/NArfehR8KJXk+tkI8cGcoXUsFeFxvRH?=
 =?us-ascii?Q?nfCoWSSdkP5Dub+7lD2/0DNF6MiabzEoM22ZeKgeUJxGYfB0VHk0MWGRKkMh?=
 =?us-ascii?Q?+mIJEVsSnqSs+NrUinlaeTxT5hL4l2vm5YBySRUAUGcOhlhi0eC+dr84UHXN?=
 =?us-ascii?Q?gGyUtI2gLlkSPOJRWecm4SX2nJ+hG9gPFY+w+PDxkF9JFxxf6fTtbuwPYCYc?=
 =?us-ascii?Q?PIuYzLWxnXYlcOTeKIjVeseOm9errdFXE51G4/lV/KKD1dCA13praPZhue0Q?=
 =?us-ascii?Q?jIOGL+pkfn/8pmNznQjyjLfH45cBfqwXTq3rPmDF9HHS/kKV+GssYxIUEk3Z?=
 =?us-ascii?Q?WIXk0QvpxkU3iUWlnJBZKmMvl/csc9DuJR6+ewHMMbVYGzF7XV3f3k/G0x6p?=
 =?us-ascii?Q?Nup0AwED9XytOIyWGWglrqrVeFJUQI/uqZe5+Jg7HUDhGZdHKZ9fHDeWExK7?=
 =?us-ascii?Q?NTGwlEHZ5MkQcYncWgcWvJEQHSezKj+9VHqQlj+OAHrwreOyXscf7L0CdAIw?=
 =?us-ascii?Q?wVE7vumGdFTI/SAD+Hjygbv+ci6s9GiAH/er2BxUtB3PIfyLr7ijTZckwJ6W?=
 =?us-ascii?Q?d5Rwfp4ZX0BCVGbgBYUJupJhFLt4hW6c+KQqt0h44xKkA0GXeRdpM2DPMQ9z?=
 =?us-ascii?Q?DpCm+O65qucTaBc0vqKF4Gfjxllg5Jrf2r5fFGMbRgxhkB/RCML/4OnRPpDv?=
 =?us-ascii?Q?qe1S/DE/CCt5mGKBbeJSnoKOEACLWqj5W2PvX0sMknxiSRdzLioMfoM5GmPh?=
 =?us-ascii?Q?U4udovJIjR69xV5SOWxx4qcpWFwBlYb/fe2AZNNpaN5nkMFpqcJSj7AbkLxv?=
 =?us-ascii?Q?AJak8Ve+o/9HbpSfZCIcDF5cZlchSXy/ty4RGePz3WkpDKD9UgbJWi5oZHyZ?=
 =?us-ascii?Q?53z7Ow5eyxctrAM/PLQvOUuxG1hcBkiApPmiQs3IeXT5uqqeKWe9S1pEevwv?=
 =?us-ascii?Q?ZvTY7ahITavmm2tJrPrurnpg/Z++zJ+ivg7c+7kvddV+gQN6NfVAoaMYRhN3?=
 =?us-ascii?Q?5rDiNA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1dccce01-4dd1-46f7-28cb-08daf90cf074
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2743.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 04:31:59.7289
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +bLG4eXzE46tTIAiLstHGEEjUfZFwLk8LgawXwj4izv8NnoeJa50NoykPVNZUCOk3xngdn2jqUQIKj76UiyIJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4905
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 Jan, 2023 05:18:32 +0000 Hariprasad Kelam <hkelam@marvell.com> wrote:
> Thanks for the review,
>
>>> If you extend the API (for example, with a new parameter), you have to make sure existing drivers are not broken.
>    Sure, we will add checks in existing drivers for the new parameter.

Just sent a patch for mlx5e that should be applied in a v2 patch series.

>
> Thanks,
> Hariprasad k
>
> On Fri, Jan 13, 2023 at 01:06:52PM -0800, Rahul Rameshbabu wrote:
>> On Fri, 13 Jan, 2023 14:19:38 +0200 Maxim Mikityanskiy <maxtram95@gmail.com> wrote:
>> > On Thu, Jan 12, 2023 at 11:01:16PM +0530, Hariprasad Kelam wrote:
>> >> From: Naveen Mamindlapalli <naveenm@marvell.com>
>> >> 
>> >> The current implementation of HTB offload returns the EINVAL error 
>> >> for unsupported parameters like prio and quantum. This patch 
>> >> removes the error returning checks for 'prio' parameter and 
>> >> populates its value to tc_htb_qopt_offload structure such that 
>> >> driver can use the same.
>> >> 
>> >> Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
>> >> Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
>> >> Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
>> >> ---
>> >>  include/net/pkt_cls.h | 1 +
>> >>  net/sched/sch_htb.c   | 7 +++----
>> >>  2 files changed, 4 insertions(+), 4 deletions(-)
>> >> 
>> >> diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h index 
>> >> 4cabb32a2ad9..02afb1baf39d 100644
>> >> --- a/include/net/pkt_cls.h
>> >> +++ b/include/net/pkt_cls.h
>> >> @@ -864,6 +864,7 @@ struct tc_htb_qopt_offload {
>> >>  	u16 qid;
>> >>  	u64 rate;
>> >>  	u64 ceil;
>> >> +	u8 prio;
>> >>  };
>> >>  
>> >>  #define TC_HTB_CLASSID_ROOT U32_MAX diff --git 
>> >> a/net/sched/sch_htb.c b/net/sched/sch_htb.c index 
>> >> 2238edece1a4..f2d034cdd7bd 100644
>> >> --- a/net/sched/sch_htb.c
>> >> +++ b/net/sched/sch_htb.c
>> >> @@ -1806,10 +1806,6 @@ static int htb_change_class(struct Qdisc *sch, u32 classid,
>> >>  			NL_SET_ERR_MSG(extack, "HTB offload doesn't support the quantum parameter");
>> >>  			goto failure;
>> >>  		}
>> >> -		if (hopt->prio) {
>> >> -			NL_SET_ERR_MSG(extack, "HTB offload doesn't support the prio parameter");
>> >> -			goto failure;
>> >> -		}
>> >
>> > The check should go to mlx5e then.
>> >
>> 
>> Agreed. Also, I am wondering in general if its a good idea for the HTB 
>> offload implementation to be dictating what parameters are and are not 
>> supported.
>> 
>> 	if (q->offload) {
>> 		/* Options not supported by the offload. */
>> 		if (hopt->rate.overhead || hopt->ceil.overhead) {
>> 			NL_SET_ERR_MSG(extack, "HTB offload doesn't support the overhead parameter");
>> 			goto failure;
>> 		}
>> 		if (hopt->rate.mpu || hopt->ceil.mpu) {
>> 			NL_SET_ERR_MSG(extack, "HTB offload doesn't support the mpu parameter");
>> 			goto failure;
>> 		}
>> 		if (hopt->quantum) {
>> 			NL_SET_ERR_MSG(extack, "HTB offload doesn't support the quantum parameter");
>> 			goto failure;
>> 		}
>> 	}
>
> Jakub asked for that [1], I implemented it [2].
>
> [1]:
> https://urldefense.proofpoint.com/v2/url?u=https-3A__lore.kernel.org_all_20220113110801.7c1a6347-40kicinski-2Dfedora-2DPC1C0HJN.hsd1.ca.comcast.net_&d=DwIBAg&c=nKjWec2b6R0mOyPaz7xtfQ&r=2bd4kP44ECYFgf-KoNSJWqEipEtpxXnNBKy0vyoJJ8A&m=BHYls0vs10PjYQd-g7Lv51bPiN5Ay-x1lca_mGg_S_tH2pfwR7uADDykRTMmtVcU&s=FQPgPEhy6I2JRBqOmbyX8xAU69oNnUrl33ZR8QY8ZuM&e=
> [2]:
> https://urldefense.proofpoint.com/v2/url?u=https-3A__lore.kernel.org_all_20220125100654.424570-2D1-2Dmaximmi-40nvidia.com_&d=DwIBAg&c=nKjWec2b6R0mOyPaz7xtfQ&r=2bd4kP44ECYFgf-KoNSJWqEipEtpxXnNBKy0vyoJJ8A&m=BHYls0vs10PjYQd-g7Lv51bPiN5Ay-x1lca_mGg_S_tH2pfwR7uADDykRTMmtVcU&s=wHguR00zCQGIop1-2XwsXa_PWXD-J8hMRKhtIuWXjOE&e=
>
> I think it's a good idea, unless you want to change the API to pass all HTB parameters to drivers, see the next paragraph.
>
>> Every time a vendor introduces support for a new offload parameter, 
>> netdevs that cannot support said parameter are affected. I think it 
>> would be better to remove this block and expect each driver to check 
>> what parameters are and are not supported for their offload flow.
>
> How can netdevs check unsupported parameters if they don't even receive them
> from HTB? The checks in HTB block parameters that aren't even part of the API.
> If you extend the API (for example, with a new parameter), you have to make sure
> existing drivers are not broken.
>
>> 
>> >>  	}
>> >>  
>> >>  	/* Keeping backward compatible with rate_table based iproute2 tc 
>> >> */ @@ -1905,6 +1901,7 @@ static int htb_change_class(struct Qdisc *sch, u32 classid,
>> >>  					TC_HTB_CLASSID_ROOT,
>> >>  				.rate = max_t(u64, hopt->rate.rate, rate64),
>> >>  				.ceil = max_t(u64, hopt->ceil.rate, ceil64),
>> >> +				.prio = hopt->prio,
>> >>  				.extack = extack,
>> >>  			};
>> >>  			err = htb_offload(dev, &offload_opt); @@ -1925,6 +1922,7 @@ 
>> >> static int htb_change_class(struct Qdisc *sch, u32 classid,
>> >>  					TC_H_MIN(parent->common.classid),
>> >>  				.rate = max_t(u64, hopt->rate.rate, rate64),
>> >>  				.ceil = max_t(u64, hopt->ceil.rate, ceil64),
>> >> +				.prio = hopt->prio,
>> >>  				.extack = extack,
>> >>  			};
>> >>  			err = htb_offload(dev, &offload_opt); @@ -2010,6 +2008,7 @@ 
>> >> static int htb_change_class(struct Qdisc *sch, u32 classid,
>> >>  				.classid = cl->common.classid,
>> >>  				.rate = max_t(u64, hopt->rate.rate, rate64),
>> >>  				.ceil = max_t(u64, hopt->ceil.rate, ceil64),
>> >> +				.prio = hopt->prio,
>> >>  				.extack = extack,
>> >>  			};
>> >>  			err = htb_offload(dev, &offload_opt);
>> >> --
>> >> 2.17.1
>> >> 
