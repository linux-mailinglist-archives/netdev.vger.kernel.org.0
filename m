Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFF9057B917
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 17:01:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231962AbiGTPBZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 11:01:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231796AbiGTPBU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 11:01:20 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2057.outbound.protection.outlook.com [40.107.92.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9A4553D0B
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 08:01:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=COgVjDghYAum7FXld1P+9XCcek7VUQZVk7lhPeg0RQBmqoedco6aMKRBU/O0MTteDrZ1C0mL3CM6ykT+ZNma/JnCf0NpDcQp2NoM0L1NbiF8lkL6t8pT94FMk+2fdGIzM1fxYhogHNZ7k5HHVEXaegwuISmik9qS2b7dMd+i2OcGCohKZgVodsnNzHWogQgHSNBLlmK+lJNwG4jIw4kE+TwoxeNpqlpuk7pcsvVbPBcQq5glusGmNOj2oHXlI5eClL/vhhUt1lHtfT4+CUEvOGxafbgp7c85LCWui1Yl49eNXFxbZbOodBoE7zjV9TCdNhuvSolQ3VqdPVpgmXzWDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6050Kq5IwTjs4Hsa/PJYFiBqKsSIVfyI+FwMNfoSnvA=;
 b=CJfn0PSei/POZU9lJwXxtceM6N5Txl5evHN14oz541VYopu7RJrlOFq70gKt46ihxuo7G5PlE63FrZNMbfhHirBnXIytebg/a/aCZFC3/EM9zUkRSXWrlDFUp4Nzk0itpAyzu5Q9IdylJernX/JwUy37zfLtOM2diCntQqV8kMukEVb1EtcgumqEbk9EDOJgZLQi4WoI/cW7v6bUdKIEgg1y0nN3b2T7fhnVvnxaGBPXCHo98GnGyc51GynmkQAQZH5OQqSWzSyZde0WYpfaDNjBqHqyTYmqBmwIW8LdXXmvbvZflzgKpyboYBc1LGFUTWRhnduwi5InEWrYoH3KsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6050Kq5IwTjs4Hsa/PJYFiBqKsSIVfyI+FwMNfoSnvA=;
 b=YHauaXV787B06rPWNxXTMKZ56Go68pw2mrjsf++0UoPR9GY+8+uKbc6Rbg6iAVUdstTMsD0I0NYdA3galYnatnFjLaS19SrOn3nua5B9g3fmlsE7iQrbnAUYgivFHCBgBL8aPS0qEWrXiXyvRk6ZkiyvoQAU8NCWzdxKMUBquzF4ESv9duTpM0QvZX0H3SBAunamz7FMKF0mYZTXfujAJeUY0GzTzkm1BTalKv5StATeZI7gOBSkujmXw6rW5zoJaqZ01IWcUakDLTSfTKiXDlRcUrn52/y+y+vYyatUt2ng5D2rPpfwdOsX5RQWqzuzFY8xSjUCltHXkbbJzA51MA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by BL3PR12MB6449.namprd12.prod.outlook.com (2603:10b6:208:3b8::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.21; Wed, 20 Jul
 2022 15:01:18 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad%9]) with mapi id 15.20.5438.024; Wed, 20 Jul 2022
 15:01:18 +0000
Date:   Wed, 20 Jul 2022 18:01:12 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com, saeedm@nvidia.com, snelson@pensando.io
Subject: Re: [patch net-next v2 05/12] mlxsw: core_linecards: Expose HW
 revision and INI version
Message-ID: <YtgYuPrO6gw0nR3b@shredder>
References: <20220719064847.3688226-1-jiri@resnulli.us>
 <20220719064847.3688226-6-jiri@resnulli.us>
 <YtfDQ6hpGKXFKfCD@shredder>
 <Ytf0vDVH7+05f0IS@nanopsycho>
 <Ytf4ZaJdJY20ULfw@shredder>
 <YtgYN3vi6MyTTT0K@nanopsycho>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YtgYN3vi6MyTTT0K@nanopsycho>
X-ClientProxiedBy: VI1PR06CA0091.eurprd06.prod.outlook.com
 (2603:10a6:803:8c::20) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9e78242a-3e34-45f7-ba86-08da6a60b316
X-MS-TrafficTypeDiagnostic: BL3PR12MB6449:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Dp5FMQMn1vZUJBVjY/lAS8ygJkhltmbjSLqvDma/2tuIyLz6QMMjWbbKtVoZXGP4jRcGvfuMABjdI8sQhnACQs9S6Et4ZW+4L1rxowwSHpVo6JUM6qMsOJX7MI/AlQJVAKmztYatdtb9p9ialJtmgqRLdB7JIeTHmwITnnjd49DZxCU0R1mYIzvghpLW2hiZCaE8Dvkg1LrRVS0HOQAzCoVdIJ0kVwAEeuCdgU16uIOIqu9y2nrdCrXhoNja41w5R7WhPJZ2y1n2Fw33TeVzdjpG0+DGsOPHczKbiOOkaRK7huHikfJksSVtzgQQ9wwbo6Mzsjw0Ji2bY+sIg2AcCTwDuUHVJzPpfxJLe5q+1tz2GgucmDTvnYp6u7tdOTCs2uZkd9ej4PN6aBoxUfU1DKyFBqI6ChjEDspuHEXsMaB4gGob2R2b5hv3S4POMDwhq6N05jXw0BPWM5jlXjJhwtNkXOYMmR8meggJxPPrduiEPV/dGBGxJxVXS1yyjdml2/G5qwRTtuD2zXJmsgotCQzU056quGQe0wKeBYiug8XR4YtSwxQeHnR7q3Rth0QguiVbBT+u/sz5H8dftSitY2XMjgHX3EtFikBX93Z/uQf6dvwKOj29dLZmSoXL86uuUrAgH3mtCK1HwTQjoQGQD2YPl2bIrlxQRop6D8a07nmXmXyrBlu5D4UmdcrmgQxUkUlzHzjwUDnODZ8TE3VVKYKnHxml76WwGi6RcA/YQDiaRxRP1SRDQlo9KogPpFKJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(39860400002)(136003)(366004)(376002)(396003)(346002)(8936002)(66556008)(8676002)(5660300002)(33716001)(38100700002)(6506007)(66946007)(66476007)(2906002)(4326008)(6486002)(478600001)(86362001)(9686003)(6512007)(83380400001)(41300700001)(186003)(316002)(26005)(6666004)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/niqdtATtNbrRQqdFsz4geyZk5T4bWPfzyg57fBJMZJcQahZ36musoTTCEEN?=
 =?us-ascii?Q?cTFHj9QALL5xlRXIZJxjz5lRQJwwXZdV8ZZpDv5O4gZCRtavvON0Ug1NhBBd?=
 =?us-ascii?Q?yXyBwtdL0X7lfju9iAmA8AhLt4Sj5QJLr11iJ2d46+n9+9xhKcx9OEeAGP3J?=
 =?us-ascii?Q?VkwJ61HwAmHKL8HTnXve4CnfktucduD7xdGqf0B081uFlwjLolhvrpRxAAHW?=
 =?us-ascii?Q?UuyMylt8fKdURntSBj1P7R3tf0+NFBj8c4PCKzXXf5HUuWiKNSrFGPD0WjdG?=
 =?us-ascii?Q?sWUJ1Mj5LEk3LWe1JXdKDSChKB7hIcrJ7697eNRofxHTCs6XMw+3D+U1BRB1?=
 =?us-ascii?Q?OB6IIF+y4xsFeHHQ+JStWC1bYP6MKxU5yNhpZbLgLTvjxfp51SD5Qdmo369m?=
 =?us-ascii?Q?+g0KpZO5CvQMxFFhXqUI/GF9Z4FlcEPVsj9dEuj88KjVUB95L0S+K7TnAygo?=
 =?us-ascii?Q?YQD80owlOEOiKzkLCwP7kXP7K50REtsLMxRNqzZ9SdEkSxvgVW+vaZTpzn2X?=
 =?us-ascii?Q?kN0T7F5o6IqqE+7R2nStQYdKMp8gK4q4sUG5CxEoLiHT0Iin/VXlqmvanYZb?=
 =?us-ascii?Q?n81XqwDOAkFmf36P7gz8KhVUOKmr9rs+QNTO3t67jF6bGtAdiYU8y+qHFmP8?=
 =?us-ascii?Q?aoFf5WSDuNzmJMW4FAaAut1QqXAhjvMpj8BSz3GNbBko+HDRafT8JEcLHW/X?=
 =?us-ascii?Q?iGZbKJoUMTsuSqzQeQBfol5ubfqPJsGLn3WJEJUsknRrGENkpbjwkInaJec3?=
 =?us-ascii?Q?Lkm8dnnhQwx1gGrMrFC8eCPZFtSgAeYi+GcV4x/AKQjVYyOLOWXuG8b7hAHi?=
 =?us-ascii?Q?PyDvkc0X4MEZIIVk78c2CmbK6jqpA9YJu/Et9JFkoh8dDZmLBkI5FEe5MkxO?=
 =?us-ascii?Q?IpF995g2NMr9baJZ1vXoRp65erjAnQ7/w3lE7qkY5/X1qp7SbjtthkELnXo+?=
 =?us-ascii?Q?WswTzQSXX4yASR3Zmvdkx0IT5TjTSmVa69aS0izKc1BTNTH/eWzK364u+2K0?=
 =?us-ascii?Q?iHQHc0Nk1dxJ0djTv2MhmLcyHR8U6GDI2yuDaQXTD5foJWUbxvVvi/ndaRKb?=
 =?us-ascii?Q?Zadsylg2tzdxu/axiHHPDStc/psYN3WIIC6Fl7gqkV7pJgwKc5npCqp14Bqk?=
 =?us-ascii?Q?qnX+vnvakKS7zFltSEFDpPq0QXgqhR1v2npbQ1Sc04i+0KfNd38Jy0WKwE1a?=
 =?us-ascii?Q?HW/awxMHX/HDrzO/pl4VNNW6TXv+LWUdX+1yNMl6J4RvJS15LlXAM0/Q4Htw?=
 =?us-ascii?Q?oDMblXXc/dEpAVIb1xGWWufh1726qIlH6bT1Uiw/j7gAlpT7pXygKBtoOLKW?=
 =?us-ascii?Q?HIQ+qdkO+0nVhT4LPEH8I1wyoUy+XGp4rakixJkfCo5M+WW8uL/XiebZgUEM?=
 =?us-ascii?Q?dFyEUCIk69Kzha1TR4jHvQg5eLU0J3FQkb6QZ8flWtCYTtTFhxYHW/NFUn5y?=
 =?us-ascii?Q?bpKPE2rdELkqPjQTkG+7bfx+/XCnVxsO03NDtzo3/uTaq8lXTwL497Nr+s2G?=
 =?us-ascii?Q?Tl/2Uj05FBU6G0tC6Be39mthF+gE7ET5KF/9ArNQ4QF7dGx1F7TcQWx12xNm?=
 =?us-ascii?Q?pYe2ZafrxV7oLG1pUnwr2nf5oo42C3R2tYFeXp2A?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e78242a-3e34-45f7-ba86-08da6a60b316
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2022 15:01:18.1299
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g4oD9DCEbvLMyP+Zy2kQap7sOvoYC9Qn6rZ7kedCNbhbPuHWjrvU0LzRIwSrF4ZtsBd+FRYd8r4QPAkfcPIA8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6449
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 20, 2022 at 04:59:03PM +0200, Jiri Pirko wrote:
> Wed, Jul 20, 2022 at 02:43:17PM CEST, idosch@nvidia.com wrote:
> >On Wed, Jul 20, 2022 at 02:27:40PM +0200, Jiri Pirko wrote:
> >> Wed, Jul 20, 2022 at 10:56:35AM CEST, idosch@nvidia.com wrote:
> >> >On Tue, Jul 19, 2022 at 08:48:40AM +0200, Jiri Pirko wrote:
> >> >> +int mlxsw_linecard_devlink_info_get(struct mlxsw_linecard *linecard,
> >> >> +				    struct devlink_info_req *req,
> >> >> +				    struct netlink_ext_ack *extack)
> >> >> +{
> >> >> +	char buf[32];
> >> >> +	int err;
> >> >> +
> >> >> +	mutex_lock(&linecard->lock);
> >> >> +	if (WARN_ON(!linecard->provisioned)) {
> >> >> +		err = 0;
> >> >
> >> >Why not:
> >> >
> >> >err = -EINVAL;
> >> >
> >> >?
> >> 
> >> Well, a) this should not happen. No need to push error to the user for
> >> this as the rest of the info message is still fine.
> >
> >Not sure what you mean by "the rest of the info message is still fine".
> >Which info message? If the line card is not provisioned, then it
> >shouldn't even have a devlink instance and it will not appear in
> >"devlink dev info" dump.
> >
> >I still do not understand why this error is severe enough to print a
> >WARNING to the kernel log, but not emit an error code to user space.
> 
> As I wrote, WARN_ON was a leftover.

It was a leftover in patch #10 where you checked '!linecard->ready'.
Here I think it's actually correct because it shouldn't happen unless
I'm missing something
