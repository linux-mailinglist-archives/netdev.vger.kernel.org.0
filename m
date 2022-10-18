Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92FE2602461
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 08:28:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbiJRG2y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 02:28:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230041AbiJRG2x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 02:28:53 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2051.outbound.protection.outlook.com [40.107.244.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16376A6C2F;
        Mon, 17 Oct 2022 23:28:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RQ+AsMfrn+m/UuBBB8nrg1VluBi/uy0GewVHS5J3vK5aVisr04USYpFVpqccmx1fAEOSXKZEJ8hcFmgSuYsfjbbxuhU6KW7ltXFkeMm+KWXDqQzqthuF+H8YpZLwiR8zm47DffhtRgAuzs0RXCbVlc1CGg3v81Zy6R6W560dmoC4OcV1Doduym/f88wLU5hrc0s7tHbsj3+WcSR36lTBpynISbA329wFQs7lKqtXwQ8vPsI71VWnZluvilFfZ1EJr3IUmMzbU6HPGstcRJVwukznsS+vIu6FBEUAailnq0Pnl/qAA1URw6aV6gp8C3Zc3M0Djqsp8S6sLhhuzcJjEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h6663stms4r+/0zJnTWfk/sS662jrSPS+J8IcYAH/2s=;
 b=XZsG8ImsgETYABp6PmVt9MzHLkwUg9K3MM0B66dQV6CbOwGO2dBdCej2tgroHucgqUPW8plg5LzSqdbGRXZGlyuv55DKw5MDAUMJoblUU6QN972//dV94bS3wybhLS2fjJTzCwA5gVryTbmXn8634b1mA+lPJS5ykkkmQKwlXzKfPNdEped7P27DyvAMxADmmviuhzlheYTY6pCmNKLCQZwYIzY5LYsPTw7YmcUxyH+D+9qC2wImFrUrB3l/9TWup3g+f+XcfZA8IcixRDQwAJZXqFFadetZy1YspAQhZwgoT/XOeVv4k/hKo6TqlcwTBVjVlb0TcaDIRX6yZ7u1Og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h6663stms4r+/0zJnTWfk/sS662jrSPS+J8IcYAH/2s=;
 b=TXnT0nIwYcSGr54K9eDcgy1YfKAOwxFwwU8l6PmtW6EZAF6P4UgzK0cJv88VE/Xo2aCQMd3vxihmGDxcpI9KdgIov1QGV9FNL7VayFnE9NiaKd6jfWysLOCQ1JJpbWMijfC2u/tVMWnsQSYNOeRZmAWmc4s2oIrCmeMMLcxQJs8FMHS3AvbspAV4m+KUA+KUc8dCCvHEd8D5rOtBX6r5htnlQ6ottyDE4DLKkjvTkH2xQnSIS5fISYrRKIu0/R66i9TidPPDMQFTO2zv3DHGV7twjBlUN3FdxPvyAKNsAoYlvKsjcA7cTUfB6vZOVPARuPj21QYQIGZspI4AflV5FA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by CH2PR12MB4133.namprd12.prod.outlook.com (2603:10b6:610:7a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.32; Tue, 18 Oct
 2022 06:28:49 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::4ff2:d93e:d200:227e]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::4ff2:d93e:d200:227e%7]) with mapi id 15.20.5723.033; Tue, 18 Oct 2022
 06:28:49 +0000
Date:   Tue, 18 Oct 2022 09:28:42 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Daniel Lezcano <daniel.lezcano@linaro.org>, vadimp@nvidia.com
Cc:     rafael@kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Petr Machata <petrm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "open list:MELLANOX ETHERNET SWITCH DRIVERS" <netdev@vger.kernel.org>
Subject: Re: [PATCH 2/2] thermal/drivers/mellanox: Use generic
 thermal_zone_get_trip() function
Message-ID: <Y05Hmmz1jKzk3dfk@shredder>
References: <20221014073253.3719911-1-daniel.lezcano@linaro.org>
 <20221014073253.3719911-2-daniel.lezcano@linaro.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221014073253.3719911-2-daniel.lezcano@linaro.org>
X-ClientProxiedBy: VI1PR0401CA0003.eurprd04.prod.outlook.com
 (2603:10a6:800:4a::13) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|CH2PR12MB4133:EE_
X-MS-Office365-Filtering-Correlation-Id: d8ad1dd6-3e4f-4f7a-0e51-08dab0d204b2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 29/v3DmH1Zde4hT6mTcsSaLcH7/wQ3SgjNZ+PwFUl6c12W8upHDFt0fpMkf+YOyM0NwQA+hY+8bOul/SkwKTAi8vKICs3tAj6ngEaF1hisPuB4CgNwUyaXI1ztUxoyBH0UIq9paBRL4j/lysklxew2699tDo9TaBz+Y9SLciaZRoXZbZhYnyy/eoShcuPiH8zr1XoVXUWJ3RQaMjB7an98CQwCzCXjYqsF/x11xKHD7TDIOO5RiIdZ32+7tyH1eMDpwLRi0P3DDPWC0CBxWOQL40VWWZH9xDX74zlL9+NZmhQUCDEIAEzhEOdg09izLb61s1nFcBFVRns38g4HCjxTbXiBjDaeY+ihdWWIikec1zUQBFIomwJaG9NLOO357hCUTxrwDtKdLi7jXY4Ks91bTGs1crcfPyPms5Fu9xZabGgERpEiVbUTRUi7eX0zkCR4RgBGWTW1pOmKpuk60O4KOCcbOJ4hJ+soiMZI3ipyHTVlpVT0s310L+wEnhjrop938JLbXd4VPvmha4fe1RPDt3zIihtl0+D1E7JVB1H/Ve6PJZqKEbia13JchQm57SHvlY76ESplQa99Ku6/WoRa3pV8WjteZgwuHst9aSQ0BnGlr5LLsR49o8mfa5c1Oi5H1f0770amJ0+ZaF/uH8pMLB1kkef2kNnwRqaD69IK2scZFJn9O4GojXQHnVWpSfOA87NZlRpHr8dmsYtIY0a11qL1JnrlXyuUKX1mmUihZ0IzVIOOon3ZUiDxCBukgaJwF5rKxF5ZZoWwVHmyDp2g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(136003)(39860400002)(346002)(396003)(366004)(376002)(451199015)(6512007)(9686003)(26005)(6666004)(478600001)(186003)(2906002)(4744005)(5660300002)(33716001)(54906003)(6636002)(316002)(6506007)(6486002)(4326008)(8936002)(8676002)(41300700001)(66946007)(66476007)(66556008)(86362001)(38100700002)(41533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Mdhj9AI1rs03h8XFmL5a56Qw2p7ekmOMCKNlup+rgFW3sIGj0ej8zDdIPRKm?=
 =?us-ascii?Q?a8IT3aNS2U6/MMrRBjcFe9qGvWF0GO9iI0xXBoQDEV5dVqpCGewygkRCEUWh?=
 =?us-ascii?Q?1Mhkh1gsaAKz3lV3Snqga8g3iR9GH7G8QAxxESVWaYZOI+h5gYhQBdBo4aqk?=
 =?us-ascii?Q?7qeocOw34i6BFPfFVqJQR+9Uydx/CYORDoxdoqvOAZbHH0rIhZB025F12bqh?=
 =?us-ascii?Q?W5XnmuVCQfT4GINkE5MBy3XwyYAKr0EdPI+8gWEjDnEJvGtnk/mctvuWUahD?=
 =?us-ascii?Q?hOHoaUnSv8+0pFDWbgz4QIbjHXN/a4hphBtvq6Z90xooiC0NlWEB//GV161q?=
 =?us-ascii?Q?8nPa9SHmFjkGUvrBrCtaPJDuBqJS4FekCEzR4o/lk3xqXf6axnk4R+plrE8+?=
 =?us-ascii?Q?k2nVEYtytiOJBZSnyjJHilbI59nATKkieIJtXMEIhys23Zae6GedYIqJA2ZW?=
 =?us-ascii?Q?/EyVrjzhULaiu6Rw4gxkWp25oInomvJ/JsaVi76HwbVyEgXx5EvRa0Kx8I7Z?=
 =?us-ascii?Q?ddv16AXgGTGp5PGZaMcDVxhzkKNYhDX8K3pkJaLeQ7YCSUeP7MDnnTE0Z8IU?=
 =?us-ascii?Q?0B2+ZwPj+fc4/rsYvusjDPL0qMOu3IV7QnQ/+qM1WeHbk3ph9KwqwDBqCfPx?=
 =?us-ascii?Q?XZlW29cmDwoHICxIoSvXQA6WWSwkkvqUQiHV3/RULCZF9ThObax2/B6JALqc?=
 =?us-ascii?Q?k9L1q4h13ctOapoTEjOg6Q8zOxAm5QLviuSobSlkbtad9mwBFEnVrCJqj0dj?=
 =?us-ascii?Q?Cyv9AN0MQBM+twTNvfz+7faCkPpwFmmczp431SA3ml7zlLJyCVPJjX7O8dtX?=
 =?us-ascii?Q?B5/4/Iiscfsk92fbyChF/e9CjFjbYnZq3QuRA5qKjWi+CLlrtxtcJOoANFbJ?=
 =?us-ascii?Q?j+nvTOHQqYQ/JYWDMycXFqY0mE6zV4Cb5qlAPc2wZlcXc4DKS8ESFoeWYNJ6?=
 =?us-ascii?Q?HZ12DM+0d+c7qsYhYyWbJ8UXlSidUt/Qcavha3pAyRil+NBz/aG8XRs7H8xm?=
 =?us-ascii?Q?xigXt/Hs07NaM1Tug/Bke6BsIuV8k76T4+1QVQt8iDPIXW4B7u0A1Pt3XV0S?=
 =?us-ascii?Q?Fll8XrQIWuynN9ZYtzvTqeNyKUeQttRmrdok/ev1eC/RxF37gsoJfhqI1C7k?=
 =?us-ascii?Q?9s6jTATbeWX2u+5gLUnhHTuwXiNkj9CTTbPXkzwiVFPMkkY/U5mKk3Eh7jCv?=
 =?us-ascii?Q?UczeIO+baAIonJuZ4l9eEijP45F9Shfr2B+4NmOZWwWGXNfHUM6T7OUx7IVr?=
 =?us-ascii?Q?diCMZqkzt472WT1xSQ+oQ1Vrddn8DO1ltJp8h+16iWazC+sXugEJvZldsUdC?=
 =?us-ascii?Q?+YuXaQp//5A00qeyBlIXZVyc205iQhtNC8KEQD7cIwveNaDzivaw7OxA3xqh?=
 =?us-ascii?Q?OorbPmEl30o05ZiqQuysQx4NUYJsyXpaKDeJ89vj5ITcpfeO0T0ZRJXqk1Xu?=
 =?us-ascii?Q?TtfJBDYfwcCyDhXIDda2040QpYm4dCHOhFfF4QFhgl4z0KYjtA2Efh6J9rrI?=
 =?us-ascii?Q?AoalPYWLnPyMVxPxo/FSknKNjpFn7Ci5hWfFYc6xtRWmVdjlhGVN4XrTm9Ai?=
 =?us-ascii?Q?BdpOmXu67Q6wgJnFSdPIOT80mBXMLu5xn/jIaVQb?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8ad1dd6-3e4f-4f7a-0e51-08dab0d204b2
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2022 06:28:49.7712
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lLDrnk8xVEhgvfljvza0daqnGvAEtSC18iYG9Yn2qiSwKk+166gKnY2Xr1wFQsFFrit+gePf+LOSGNd/hrMODA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4133
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+ Vadim

On Fri, Oct 14, 2022 at 09:32:51AM +0200, Daniel Lezcano wrote:
> The thermal framework gives the possibility to register the trip
> points with the thermal zone. When that is done, no get_trip_* ops are
> needed and they can be removed.
> 
> Convert ops content logic into generic trip points and register them with the
> thermal zone.
> 
> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>

Vadim, can you please review and test?

Daniel, I saw that you wrote to Kalle that you want to take it via the
thermal tree. Any reason not to take it via net-next? I'm asking because
it will be the second release in a row where we need to try to avoid
conflicts in this file.

Thanks
