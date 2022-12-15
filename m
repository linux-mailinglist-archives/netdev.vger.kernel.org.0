Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 510B164DF8E
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 18:19:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230305AbiLORTa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 12:19:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230269AbiLORTX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 12:19:23 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2057.outbound.protection.outlook.com [40.107.237.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9AD1419BD
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 09:19:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c2wR5B8nWBCsrER4JdMK7SYD2oswmUCvpa8f3WsZ6tUcLTsx00Dz0bjLSLGoF4P+bXfcoIlUosVGNPbMBGgd3M2sT6KMIA/7diXYKm3QSQactLgMYnfPUzmfp+iiWJPzVu4T0Ig4yeXtjrSHLhda6TQVQjQkf1hOid2LXFPo6u9WPcqDxiOpYHSg/xJ7GMYog3QXmMLffJqy4NjAMiBpYPUc2B/s5f3vQXE+A3t4b+EmF+LJnY7vyd9PwtOdBfjv4eIAqGRmpMhWFkfZPNduBEd9d3a7GVwqgDqWSZFGwzpshqUKG5CYWU71YmFXvHKYvDg4aylR3PjD2PL6gs0KqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l96368fH/kZB3bkZzBO0q8mI9CI3UbP1TQqeiX3JP40=;
 b=Or+L2TulloxJ0xHQ4wqhvxxIjZKygVSPWcQGo3MfdX5+d4K5kV4rc2fjObJ9EuD1ynQtG0b9BrJHf/pGGePLO4Pgfmukz1PMTQXvnuZ1IUkVY1bCb8p1jgNbYRArdDDliJadScgiTf7uz5L/yXb2cpbvIpIwiUJ2VGkFYGs5ucl+yUSMQzEBNqMpuq8flT0Kd9TgX1GTx5Q4hsETVaroZU0FGdRGJOwC27O9okoaWd2VdMFAaDl7W0Rn1MCBDRXMh/vsuHb/tWZWk2x5Q+7HQHQqlchrdTUlrr0F+pZ19+0gWUEyyPGB2fdjOK34VpIngZBX03nWrR2HrgdjYLg74g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l96368fH/kZB3bkZzBO0q8mI9CI3UbP1TQqeiX3JP40=;
 b=bv+hr2ZRwu4s4cCMrTqFjIypNlw4oIUdSBHebbLpzxl0e4mMLW/q6EghGAQhh/2gz1tKtH1UOmgVMFKMur0w2XyTEVFc0I2gjVu9jI+e41gO4x1+7OPaOjc5m40u6kgu5oebxdel9PiXIBrePQxTORqmEzdQTPVnHz+DSwNXYvzrmR3bF+HiPYPtC8n3zsJ6kEsTgxGIVBI7oWquLm/LLSAReJ26UpSLHKN+KBsjSduZgpIXMe3IAVbP/O+pfozGv0BYSlUaKXH1zFj050yKEXwO6VXCOcF45Av44XoIXz/xz/Kop1zF0jlv0NszlXcc5J9ngIb4S5yVmNnCnHKQVA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by CY8PR12MB8363.namprd12.prod.outlook.com (2603:10b6:930:7a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11; Thu, 15 Dec
 2022 17:19:09 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a%3]) with mapi id 15.20.5880.019; Thu, 15 Dec 2022
 17:19:08 +0000
Date:   Thu, 15 Dec 2022 19:19:00 +0200
From:   Ido Schimmel <idosch@nvidia.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org,
        dsahern@gmail.com
Subject: Re: [patch iproute2-main] devlink: fix mon json output for
 trap-policer
Message-ID: <Y5tXBGsSohbPwYkR@shredder>
References: <20221215170056.170827-1-jiri@resnulli.us>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221215170056.170827-1-jiri@resnulli.us>
X-ClientProxiedBy: VI1PR07CA0178.eurprd07.prod.outlook.com
 (2603:10a6:802:3e::26) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|CY8PR12MB8363:EE_
X-MS-Office365-Filtering-Correlation-Id: 22fffa49-ec6e-4c25-9fdb-08dadec079ee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +2f3I198tl839s1ltawTRJGiNbLBC1dXNpNY3/60k3Ppke8P7lwW+rl8UFLYU3Lyk4vA/9nQzD31c7NKucy9Rk6OF4uDQQOXnORmj1dCqA57GldhDjJYh9amDN34SfONZHRExauteriF37wSxk4aGs5Npk/J/742tX4ARvdbatTFILddeTowcbdUUxRaFJja0xLa9CGttP9Mo9tEzOqyl5ceIXxA8LZAlFbxRkO3xzQluuprmjHyXwOp6Sy1yGw03qIxKsi1ckCog7ohGxkv0WDZ99v/0cUuva4HcLVTr6ITQ/alVZ/VlXSiJS4sx7K25YCiX1fn/0M7Mhk84NYuTIpkrrg7roGfynFv4iNgk41SgekpqZmCcnK+jBVPeoQfHcBsPlc+i6e0Y3RQwNgXV+okfTBRoY+MLTNYHQ7Dqgsa5blt1+Qj8eG9PCAVOKBh18iqo7Sn4XVhQdA16tccMIZ4a51jTFaH72BQNi7wsTlrSCjVrTsAEg9w2KqlGgDqkAwHSdUlaLkruQ8ydqFE9plpSR4u1xX1/FCbfZbYVZdBj3bOsJNzu8oblvO6TRJHuiJ1HNhNJLujkoDxZ5wrfqZWIZQEM+cpHhTmkJyiZkAa2/PtGyux8H7n1AZoQ+ei8DLihMWwN/pG12UWELvHNw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(396003)(366004)(136003)(39860400002)(346002)(376002)(451199015)(41300700001)(66946007)(66476007)(8676002)(5660300002)(4326008)(66556008)(2906002)(316002)(8936002)(9686003)(26005)(6506007)(6486002)(186003)(6512007)(6666004)(478600001)(6916009)(33716001)(38100700002)(4744005)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SAjJzrJDDKmBxs1HmFpo6tspZuU7dII23jD1+vfc6bi0mQCSbBIDD1GRzO9q?=
 =?us-ascii?Q?dkGHzDAkVx2gmIWPqo+CWTkPpeFrvyH4rF8GuY6SLZ1cYpzuyfcqAygCrQ/I?=
 =?us-ascii?Q?W4rCM88YtrnPdW8MmU2Sd07jcBYsCoR/nMHxw6MEQbnQ5JJZVN1peA7X4Jfe?=
 =?us-ascii?Q?RJJcNggK/ZIbVzvTJ9qeuenS4kCFYj44KWaOLvzB7FVqBnRIMKvUM6ges4w5?=
 =?us-ascii?Q?5sHL+u6It8od6L7FPpDz1vhx9HSTCfKzoXrP1i1f+VZzLlyNkRXarmt/IqrK?=
 =?us-ascii?Q?mf4a+0QQgcimIP0YLRNuphaNlerXqdm0B1dQ0InEor/p2kcGkBYj9GSbDRFb?=
 =?us-ascii?Q?9wxIpzzTlhARbBxb3VQmu6TX0kfz9hRWOZm1Sv0zoHe5Cly42QzlO/D8IoZX?=
 =?us-ascii?Q?yN9+Q2gQ1QOrYtmcnhGi6e4L6H3OiDH3Z0i5pKOkNZLfoX4NglkzlzSSXIEW?=
 =?us-ascii?Q?NxWdxQw0ABlfJobMlXTiRARICg+SUQEvNW8wafSjz+0N+FaZh5ogtaw2aZly?=
 =?us-ascii?Q?N91KYV9ucI4d1dDH6cp6//KV3baN7dVXiBSTEJNWLaFQjdKHhruWMjYzb516?=
 =?us-ascii?Q?UC8RKWJA97Glj5flp+v7MtW0hRp5r814CbhxhPdfKbwOikTHpyalxAFvbZuh?=
 =?us-ascii?Q?j33P+h+cWvedS+jQN0F86hUK5rylZ+urGqyqv0ocMo/HyuhU5cctPgRQtqvm?=
 =?us-ascii?Q?SWB+OJTQ1bnMwm7Onu2KQgHvrsS6TJoUGe0lBiBaqxG5qXYecTIUTAv7OM/g?=
 =?us-ascii?Q?Dcr6Y+VmOpe9ASkk/ZAj84mCrF9S6GH7WI2eq61aLFnX4l8r9bwrJJ0XyHvc?=
 =?us-ascii?Q?/gWT+07KjonFMoIknGXp5kN/r6ub8WQAU/nz/1HnHLn52mCXe3zf0eUk2D5N?=
 =?us-ascii?Q?qLgoAn3a6JHrHlANoDlqCwEd7E0CgDb40IfMc4xLxQ/Y07jKRDF3lk1fIu6z?=
 =?us-ascii?Q?XrAW/u2RIzN3qENhvQ0HlCs1hHgC0cDFWQ5ZPFlgtJYwyYhZeqJg4JlwkMD8?=
 =?us-ascii?Q?sU2ivJ4dR98ot0PGsaEyG3wlbZZesPNrBHtXrQ54kYhhz3eHmLvSZyiQW9Xh?=
 =?us-ascii?Q?dGVLc86KqF0Z0nS5aDoU1g6ifPIpBp9ykeIfA1/8sGYIKUOBFfnr0zdjrK5Y?=
 =?us-ascii?Q?E0VtKujfaH3TdahOdvMPzHOtcJR7cEBWhVuHd6ZaIjBjJS9QN+OIC8McWFD8?=
 =?us-ascii?Q?D0yPBep7D+sEQ3Pp00758ldYgQ0gfXZMOVDYMtkBLG7soJAYFIePa4MR+y7V?=
 =?us-ascii?Q?079Tv5xQecXFJ6T5cefgoE9kddDJGPXWtLUTc8UswD95fHQTEwYxFlPgh/tl?=
 =?us-ascii?Q?NN3rv8dApw00ABllruKC3SilNgIq7IV1gq9T7ymfVd/sXX/rmB4j4UE8DVDA?=
 =?us-ascii?Q?9O2aJhh7gPjogD1sxdw7yYUFtyChR8SjlAKzfS0dYwdbkDtxx8rY5Kg8kdqk?=
 =?us-ascii?Q?FkbnYz0RvB3sLYWTJnPyNLyPt/PXD/vL53LPamA2z/tQrJGeeGwG1Vam28le?=
 =?us-ascii?Q?6sby5HHZlVVjqoP9IeO6jFMSqulk6t35i9+NfyBOULG9rZEF/ZbmQXHu8c6N?=
 =?us-ascii?Q?qxY1Adu4URmQUqMk6zxnqpPfd+UzmG52Gehd0/1q?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22fffa49-ec6e-4c25-9fdb-08dadec079ee
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2022 17:19:08.8521
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IvIQajyNDijEdfgtdpWGVqqVhQ51lfPw7aaI+Rsp3poVtEt5vIYGltRepude0WXp7H43RdWg13RrO5eRDNGuIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8363
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 15, 2022 at 06:00:56PM +0100, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> There is a json footer missed for trap-policer output in "devlink mon".
> So add it and fix the json output.
> 
> Fixes: a66af5569337 ("devlink: Add devlink trap policer set and show commands")
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>

Looks like we missed it in commit c4dfddccef4e ("devlink: fix JSON
output of mon command")
