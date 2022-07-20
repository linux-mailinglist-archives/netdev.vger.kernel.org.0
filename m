Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57FF957B6AA
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 14:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235109AbiGTMn2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 08:43:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232190AbiGTMn1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 08:43:27 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2075.outbound.protection.outlook.com [40.107.223.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1E7D6BC27
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 05:43:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WxFROr18mNUyGMaXo27KzfvcazkkYlDnxyB917h2QHgr3Ij/UPm5Xp+udVOgYLg70lO5GNZDm4xNOt96xw/QA6EQJWgCQeBqqlDs8GkBrOG+k1Q0aNnrvhJMHO1AfCDWfUuSgqBThPHhEIk0zMWVBNDQRthfnRTalP6mkhI5FII8heAsfW3Ce6hD0+5L7nxcM21ifqa523403x7JL80JlSv1JdrtqdtyE+UINwLvY60yj1OR4svft95BDh5R6NlsFPePcjxtd/m2EbdFiBJZaMIxQ+WTPmBNFtyNPEgJkdt3mb66ybtDB/7SIg7ve0lSl0Po94Cwk0WVGlZAKCHE/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pQHDd51JnEQQYhKBbnjQNJWSkARPKSyEInzTeQB8vxY=;
 b=biwVUl0Xu2JTJt+92DcqtdJODf5dk8ll53vIaaSGCpdxztEYOiTIoAAu1f+cKYmBvqmKYMHaFKcrl4/Ry6XPgYR0D51tKqcLcPsb6wKSol++HXkaYe5zTAzPSmIKDc72nkT5cvgeCjap7T24e7oVoYAz3kbKRh6IJSQnKylolsGlWt06hww5oSJLD23icn3Y3JV6EwhzkYVJndBoj0KbS57Ke5x+jpHE96Vnn59IbXABsksPwSb6TiWXLHSgJ3oV1fqyMJlLha/Ipb1WzXhLHvE02GW1sJjDdqXd/gNExxSSokiSvjIanN2NFnoZLIQrmd49vXre0nSaIaj+6R+uLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pQHDd51JnEQQYhKBbnjQNJWSkARPKSyEInzTeQB8vxY=;
 b=VHaAgDr9eHSS9IPQMQKC01uwdi5BUQlMbpq3qpaQTgwLEkPMrLa1smeCQL40OkD+JhwnQWeUUh10rmEVHMjFmQvIZKY2JBuO/O60iKiIaym5KCAMRGFGYvWzKGUaT/VsPdduqr17bD53O7EK+o0VidUhTUPTOvm1UXcFFpTb04DwztsfN0ee8Vghsz9A7y5FpDZE8E2UZlHvDIGghN2DLE3XxsWkGpoX3tvoLKiz0flz/wH8n1F7/Iht7nMdfgnsU/C3WIN0Qz2Pq6xQzyaD8iZooy+D8/lzaGPULlKMFOQYkfZG03L+QTLfIlFcn80RMgINNPjchXHkrdfgMJOwDw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by MWHPR1201MB2559.namprd12.prod.outlook.com (2603:10b6:300:e0::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.20; Wed, 20 Jul
 2022 12:43:25 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad%9]) with mapi id 15.20.5438.024; Wed, 20 Jul 2022
 12:43:24 +0000
Date:   Wed, 20 Jul 2022 15:43:17 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com, saeedm@nvidia.com, snelson@pensando.io
Subject: Re: [patch net-next v2 05/12] mlxsw: core_linecards: Expose HW
 revision and INI version
Message-ID: <Ytf4ZaJdJY20ULfw@shredder>
References: <20220719064847.3688226-1-jiri@resnulli.us>
 <20220719064847.3688226-6-jiri@resnulli.us>
 <YtfDQ6hpGKXFKfCD@shredder>
 <Ytf0vDVH7+05f0IS@nanopsycho>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ytf0vDVH7+05f0IS@nanopsycho>
X-ClientProxiedBy: VI1PR08CA0124.eurprd08.prod.outlook.com
 (2603:10a6:800:d4::26) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: de815bf7-fe23-42fd-d766-08da6a4d6fc6
X-MS-TrafficTypeDiagnostic: MWHPR1201MB2559:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VFpBHhqyTvBeZwwCtNZjZ7k5iId5Pka5vkISrjC/XtLoel7gWqrQ6qpDJBKb3m6/WnUYrOKKwsIKDIrTILXCGkWAHevWQznT/jMB0EQIGCjlBsWG/SdSLYOqAZ8O4CeWDuma8/fKA3trNY1i5WKwQUsgYxBFdOI0tz4wZqDHyfgXiuhQiGTqxuNjk/HlWsBPzwcIt2RDwcfMvJQq+C7TPMVWIo6e3eYIp66ScAu9dTvjQDFUutYZ/vabBDVo84mhyPReL/vnKoZqfPInYTCG65eoXH0ED83ZmIXGUcK/iqS9VNbInm/m8NqHSzo/qHWGKfNAej01hyp1oHnyeyetYdjLfdndrrptuCWIKPECeMczyvbwQGQcgSfOeo7kvZ0YO46liTDprSkwr2otrPQclXYHYMrBxzYHcRpUG6UiN1oAyRP3K0kUrjZeQJjlDEWOkY8lRAbdDCGW4aJMSl6fyOAEdhE7XiwQJ6gJmtCFKk2nmVaVAnta0bNz6Kdgq5u4xwjre+8FjPoHYPSV2Z8DNxK9PwL/Qujb80Bn6KGFFsWvYnfJXaw4uOPICH9zNrA/8zXnAbZ4itPPmeowcpYQLIW1zraSxBThnrcR8l31TZa0P8o1IL0q9g8FyN1pqrnLnapvHY7aB9zlPU2AwdZSpoUlIz58PLQfpdlA5XNfdBFeXiPTsvZj+GEfnaTfUJ4WkVZO6TiomOiAfaMw3l/fEM/Ti9VhtZpE8WwtcMLljDOHSqjOw/evqsGxtYn/Tqqq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(39860400002)(376002)(136003)(346002)(366004)(396003)(9686003)(38100700002)(6486002)(86362001)(478600001)(6506007)(6666004)(186003)(41300700001)(316002)(6512007)(6916009)(26005)(2906002)(66476007)(8936002)(5660300002)(66556008)(66946007)(4326008)(8676002)(83380400001)(33716001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NDsPBwYWET2hi+1R6fy9LrM19vmEVin7SyshPp59KnICbvc0LtuVMbTvLfAv?=
 =?us-ascii?Q?qmu+l2D02EOeiyz4IpkBNAf5cSNaghqgN5YP1kVAxRdZvEakJ1RwCAwNFJaA?=
 =?us-ascii?Q?KaRZWRK7kl6VMnNMRLRigjGGPqCyfmqgtAxgJwM4NhmfFSV6j/1ljgfQwpOV?=
 =?us-ascii?Q?TUwTSuT7jKHduyGudZKpFMbf6N4xuksPURYHc1xaVyW5/rebzOTEp9i79OOF?=
 =?us-ascii?Q?lHmUMaXFboHqecew6tNVwVecVe+wKDgnIV4vm815UlI+dhxWZFD0eaGi3IYa?=
 =?us-ascii?Q?kZ/7baNWN8HoAIGB6tiOrR+bB6OkS2/awh8qzCKNSvmVSVBjIaZMJdmvzl+S?=
 =?us-ascii?Q?qhWTt6IIkZ/Cicw4UbUMxkeDh+1snLqUdhdcupXF7g5FNJxa/ytWDfpXqdsv?=
 =?us-ascii?Q?YWphiF9OCZALpSXtyq2LOJ9nhOqVs8kNfxnRcW4DhvQ5JsXgbNmMyVsLBye7?=
 =?us-ascii?Q?wIv16gjlGWD4KGGxMFSEBs2atAiRgZuoyXBYqFb0Nr8ZkdbU/8iUerclT2O8?=
 =?us-ascii?Q?01KLmsy48N5+ys5Esf5CbLZQmtp4R7p0iG0jXv+hcN6z+KohVBrvgU+Aqq4/?=
 =?us-ascii?Q?OmVEp6l14VVsUBA52Hmm1ZQ3XKdhyrnXCejdf9i6WQjvvqvFnf+7u3Zg4uxu?=
 =?us-ascii?Q?yn8K8XMbeCZ5kPPxrG4XHr+BS3Q0Emj8WxGUOLBo+LxvPkG5AHvtBkyANuCy?=
 =?us-ascii?Q?mNiHjTDxGc6b8QWS/Xg4w8A7uaN0fX5jIAi84+s4NNhXrIOc+w73T1huaR7O?=
 =?us-ascii?Q?wTwDkHuC+JoZ0cr7Tk4bHMFxd7WppjtoBCK9weohGV295Ak8yyu7FZSn/dhI?=
 =?us-ascii?Q?REdt9cAoz8i2/4rPm26F73CeBrEfGmo8folZ6oxrqIy0b9AVzIDIu9yLQPuX?=
 =?us-ascii?Q?n/ZBMg/NFnrKry0R6qNELfDzjwUaJZGdoezkrOvq9nCQMMJrCzVKGaWucDDy?=
 =?us-ascii?Q?KX6DHnGDH+KDJ3lcTHckgFigYhGNHx8sT/JZak+bEPgUkoQpyHvXQc3xvliQ?=
 =?us-ascii?Q?Etg3gabVH5VeyY708+Ia65UjrwE2TirRmorBs3PpJqJR+B1XOL30QLfgQ/FQ?=
 =?us-ascii?Q?yna6JwfJQR7ofDpOEdL9MWUfZjy2tgcF3/peP6JeMlNNJBYLJ3uNGObJUd2Z?=
 =?us-ascii?Q?HsQJWU7HSYSL9IA9fmovvnys3SuArgMMWtO4vQKsfWRnG55eGLdEHTgWfj9Q?=
 =?us-ascii?Q?20o39+UVfFHMbjasBu6OqSM3VR4FQLJneOzPO6ii5zSCdl9bbDucTB9k/BIk?=
 =?us-ascii?Q?Syo9/nSU9izqKfrN4YhGhMaMuE+Oz8VvJxO402Vu+vDyVS7cbW2ODbbPSQJr?=
 =?us-ascii?Q?jN1tNLMDV+X1UaM/Y1hfncjv+ggfL986cRY15Q6c8CV40QTjjYaH2bv2fkh4?=
 =?us-ascii?Q?awGli3PvrRLvID8b7AToMUyVu5PJqZLIUqYFbiZioadgNbVCx7wdBFPuT6zq?=
 =?us-ascii?Q?Yok9Q3YnaH98Gdtu9tjw0f5n94ZVDkrjXKL4ycEdTwiyz7bct3gE09kZuDul?=
 =?us-ascii?Q?5DdLb+PbdWqOfXPtOniid45P1K4HM2jmZUcYQwk2phFm0o7SwxFgLOZgMInQ?=
 =?us-ascii?Q?2s6PCOXANmTyDpPltJN6oMB17eXYIYIwyiSoL+y8?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de815bf7-fe23-42fd-d766-08da6a4d6fc6
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2022 12:43:24.7924
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dbshy90cM5I6t2FQG0qPWjNpr4acF7LPcBAQ5vGPaxjlYWEzXx7hrKdbqG2rMp/JyMHPjCoOihZgUyKSV61kJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB2559
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 20, 2022 at 02:27:40PM +0200, Jiri Pirko wrote:
> Wed, Jul 20, 2022 at 10:56:35AM CEST, idosch@nvidia.com wrote:
> >On Tue, Jul 19, 2022 at 08:48:40AM +0200, Jiri Pirko wrote:
> >> +int mlxsw_linecard_devlink_info_get(struct mlxsw_linecard *linecard,
> >> +				    struct devlink_info_req *req,
> >> +				    struct netlink_ext_ack *extack)
> >> +{
> >> +	char buf[32];
> >> +	int err;
> >> +
> >> +	mutex_lock(&linecard->lock);
> >> +	if (WARN_ON(!linecard->provisioned)) {
> >> +		err = 0;
> >
> >Why not:
> >
> >err = -EINVAL;
> >
> >?
> 
> Well, a) this should not happen. No need to push error to the user for
> this as the rest of the info message is still fine.

Not sure what you mean by "the rest of the info message is still fine".
Which info message? If the line card is not provisioned, then it
shouldn't even have a devlink instance and it will not appear in
"devlink dev info" dump.

I still do not understand why this error is severe enough to print a
WARNING to the kernel log, but not emit an error code to user space.

> 
> 
> >
> >> +		goto unlock;
> >> +	}
> >> +
> >> +	sprintf(buf, "%d", linecard->hw_revision);
> >> +	err = devlink_info_version_fixed_put(req, "hw.revision", buf);
> >> +	if (err)
> >> +		goto unlock;
> >> +
> >> +	sprintf(buf, "%d", linecard->ini_version);
> >> +	err = devlink_info_version_running_put(req, "ini.version", buf);
> >> +	if (err)
> >> +		goto unlock;
> >> +
> >> +unlock:
> >> +	mutex_unlock(&linecard->lock);
> >> +	return err;
> >> +}
> >> +
> >>  static int
> >>  mlxsw_linecard_provision_set(struct mlxsw_linecard *linecard, u8 card_type,
> >>  			     u16 hw_revision, u16 ini_version)
> >> -- 
> >> 2.35.3
> >> 
