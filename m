Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA0E4532C05
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 16:11:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238094AbiEXOKv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 10:10:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230209AbiEXOKu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 10:10:50 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2073.outbound.protection.outlook.com [40.107.96.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41A5822BD9;
        Tue, 24 May 2022 07:10:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oCE0JUpDni8AKg09fQGyGK0M2lIQXbc6BJsajp1j4/WUf1NToc6Olc86CA7DbaFyMJjqBxHXibSC8quBXWR6aHpoKG7o07ii5boX/JUSS0uXHJLC7fktuMulig5L7qRG7bQT1B/q4Ht1LY59RitW5p7BAN3dnrAuDyPJCcqZkYRhMujOtxbyUWgOvd2/vJwnTPuzxdafSKndQjFe3AH72v7MO3XVL6XUWP5JQTMtmox4RSlY+MDs6ni5tfCvlq/PojsfBnQNVG5rZtCmoqojngHUUPYwAqnmIRN0QVWevt/Vvak2Ze55F8mWRI/+oRcm1PsKKXn9dOoEmiJw3bjtIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ScQemNptloIyZKRp9qK+GESBru8C9w1wwo984Qyh89E=;
 b=kvoPD4ZuVrafLW6Z5YTuzX6TKmiFvwFFbmDYE+dkEbo3lKtmSzijq/snkEOY6FnPq8A35ey8vfZrp90LF/IPU2Hx7IDaKtLZSj499p2mkJz+tjekSGU0ymK5AOVXTwXYNNll+2PA6I8Bu01ifKhNHWVfbjxKJY+aFed2ifgp4nWMikXVX7kxkcL38KU/wNap2mh6U4/+B0zDxGRymH+W5/AZ4uzB/gP0b9koM63kkLwVsmo3M/0slsCJB0rae9kgrKnf/ySQIBjKtf8FCa7luLsvS1sbQR9rlyrZJt7sHvgVIkVGe5yA/lToTHBPRhrHzg3WRr6xeDLGxZ9LxvGOGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ScQemNptloIyZKRp9qK+GESBru8C9w1wwo984Qyh89E=;
 b=UsJk9rkrV9LcGJFDEsssiE6/xsxFwbesZhw9eT6BNT+fMOhGhNRJbRYOgiBYMisAoK1iCV9v0SmOEIhm2fGT5e+h1z3JM51AmFQ9Qe8hLp2G1cBXH5UVVRQRBeEYFCTffcFWRj+TbNNoJSq4iHb2MiaZVUGw6cuD9yHl/Pse13V9By2dQR/jV6iUydsIlR3JqmkETbPjBodZkrx/qnaaG8b/TCkpxRi6D9nz3fTTHUQnITeInVL0HxZNNEQXFygcJYS1/eWCWc6afrG02C4KffomKYd3V1rNI+dz7eEqfxvZ5ujoF5dyQXsZJhhtr1PL8fIA+o9e9BEC4W/Sl1HzfQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DS7PR12MB6095.namprd12.prod.outlook.com (2603:10b6:8:9c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.23; Tue, 24 May
 2022 14:10:47 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::2484:51da:d56f:f1a5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::2484:51da:d56f:f1a5%7]) with mapi id 15.20.5293.013; Tue, 24 May 2022
 14:10:47 +0000
Date:   Tue, 24 May 2022 11:10:44 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     longli@microsoft.com
Cc:     "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Leon Romanovsky <leon@kernel.org>,
        Ajay Sharma <sharmaajay@microsoft.com>,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [Patch v2 12/12] RDMA/mana_ib: Add a driver for Microsoft Azure
 Network Adapter
Message-ID: <20220524141044.GA2666396@nvidia.com>
References: <1653382572-14788-1-git-send-email-longli@linuxonhyperv.com>
 <1653382572-14788-13-git-send-email-longli@linuxonhyperv.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1653382572-14788-13-git-send-email-longli@linuxonhyperv.com>
X-ClientProxiedBy: SJ0PR03CA0026.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::31) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 37b63716-e0a7-4c15-12f7-08da3d8f3327
X-MS-TrafficTypeDiagnostic: DS7PR12MB6095:EE_
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
X-Microsoft-Antispam-PRVS: <DS7PR12MB6095FEA390A57212BF8C082BC2D79@DS7PR12MB6095.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vaxhyyrrUFm6Wi6kp7lutW1wlznDq8RPs3TF32KFtc+mINz5eK/kxAVz+antG0Mxip36fvPRmTcx941Fx/686ug9vE3ds3PLQVd4zlW2oHY59E5cnqb8uezYNAmbaMho9EcEid7xYSXSPnHLUNABSIsHlWi4kJmN1c0ntrbJMVIhUiZN/sfhBfCXVTZf4J/WXHAf0zn+kzBkio62gHXvKD8kx8TZSvQPse0fbxWkI134uo3naBHpP1BV/YWneW+nrzJLhloSna9tlNH6Eve5Uzrk224668PI+A5VaZMAkw2ftpDaTsrlrQZft3dEvEfyfBLVCTNCorEXTBad6pifdmIYXabavm6ipzHx49hrYBC2kHn/s6C2s2PlEueqiIHGpLA0Ph5cn1eQyu6mp9vpjplU1m8vS5fGZ3sh0waCkZ/XuxHJdZAzs+bmMNC1BDBH7l4/NUgrs/t6Pu/MQz5M+AdV0f5q/UInikoxJ/cTHz2INS9LaYQzayGmi1D4QWuCOkNAOQxVHyTyURBj6R79aFSvFMh8BPTGCjGUFox4xZzMYsFc87RtG7hhupKcONfGwZS/f5xVhjsJpHSn428lcHXZMrGuKXYbcFuaoFwIwGaEgb3BnnG7BARMqobBn1cwv10FZFoLfVoiWxK9YN5AXg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(47530400004)(2616005)(6666004)(36756003)(54906003)(66476007)(66556008)(66946007)(6512007)(8676002)(4744005)(6916009)(316002)(4326008)(26005)(38100700002)(8936002)(5660300002)(7416002)(52230400001)(1076003)(45080400002)(508600001)(86362001)(33656002)(6486002)(186003)(6506007)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?C1uNdjrYRSs2EB3stJc8ddLQy5vfKLNJS7yxU8II2SPpcqKQGPb7+xWiucqz?=
 =?us-ascii?Q?KNWUUJ4b3KVVD/F7wVy+2IARBl0dAkZyqKPI1KUqrQa8XnDgl3gJ34vWgRmT?=
 =?us-ascii?Q?HYXxfrg2OyLbs0ChutdQYP2G9Ut/dDLQaV1Sm84NU/O7WUnbIkQQ+WubGDxg?=
 =?us-ascii?Q?GfXNUD9fkfIwHaI5os5autE6ulw2T5w+2FfLjTMHT+6epoUyWXoK0XqrZkjQ?=
 =?us-ascii?Q?tfl3YnG5cBIPpNPg/j2c1Obx7y8ADxiILqeAXP7dJuuQmo63p8APG4XMvyw7?=
 =?us-ascii?Q?yhL0Ry4qRUqicfOLtPzmBgsfd+qjhAhx+H9jSsm6wydlbN7mbLYMVW1PyWGl?=
 =?us-ascii?Q?ZZWaUmlsLzgHB/eqUbL15exbcjhX07h1DGGZE8ryMCcxZ2ekHzlABJ/fb/tN?=
 =?us-ascii?Q?jyX/3zvQY3/YRvTud8k2Huul5019adBRu7HeK/8ZpDgs57JLXx/cBC4+eZAD?=
 =?us-ascii?Q?NF8AOl45O4o9ToALI05kmYTxCLR8bB5UflHlnUaH3PwYrr01VzydGH3gK67G?=
 =?us-ascii?Q?XTpH1PXFqaWQLK3pqLw6SWfFBRJodrRYj/LpQalVFPMZgVNxGkyWq6UiMAVV?=
 =?us-ascii?Q?XD2kVvFaFrSOWhF4qPDG6CN/Qf1fLd8JDGALfSRnZxkMY5N1+C/J/K8j2Pmk?=
 =?us-ascii?Q?6SGss2ewoMNKviV/V7eVVTSC6XzsDa2J6zu8UZdeLX865mHgVTHdYHEKsrcn?=
 =?us-ascii?Q?tPPtGv81JTPEsoF/NrGdjcXTp8XTNURwVAvnl2NzDoNfneAcksmKeJ1s1YYd?=
 =?us-ascii?Q?09kKglm3hXbATlx7u+NU9at5Xu7WkX2sJ1lLu8JbgH65vIT1hzkZT79d7DPi?=
 =?us-ascii?Q?Dr8W8JlgWXYEoRbTcWWDrIRrkQddf2t+J93JNpHKISmGvr78Y2zev88N+Hw5?=
 =?us-ascii?Q?DcS3bR1ytRNgy6J8dkdGyGxPZW5vAloC+lHIQd4BYIpdlc+94qdhzILBlIaN?=
 =?us-ascii?Q?K0mWru/RHK+xG9xQdJ+slIlnXz+w8aRRiJlzlzSLTaaw4XWuslmKYqzSpfiP?=
 =?us-ascii?Q?kzrtIEnreOzK1AhcMbAJgVEAObsdilnNlht/JULgUVxMvEcf3bjR6ocTCsSx?=
 =?us-ascii?Q?2ORxxuzED/EXnsmRM46UP0vrTTtdjWjoEn/BAz2cXMuevXwM5CwMHBVKDAlO?=
 =?us-ascii?Q?hCrY/Jhdkvkj/r7admYIxudWrgj4onjQDZGd9HGyAj2j/a+ziq9yh8TrSkiN?=
 =?us-ascii?Q?nldrGtBq/rP8D9rtON+ZT3FOy9+ijpu74MNOb5F/qZ/8Ro/Ne8K9vp1JTPJk?=
 =?us-ascii?Q?rpM/mAB6VAsS9y6sQ+XVFdF0jf405soRncYF/lHZd4GVfNvwwBGy8w6z3kyE?=
 =?us-ascii?Q?PkkMOImZzxXlt1eoF0eXLQa+0zg1pZ7PLJDZn+XWvebp/IAuj2OE/7npFWIB?=
 =?us-ascii?Q?AhZTZd2Qf8J1vdqTCcf8P/STWnLLcDjHrSfGiswtVwm6QKQXun8lkOn6R5Q5?=
 =?us-ascii?Q?WRAt1zY6ykXzVezgy9ij5NyVE0tzcIAanDSDCl0pKFLRhwvWDkBVYlEX2Urd?=
 =?us-ascii?Q?L7i6jTv99TS0zqvrJewMg0776vyh8EGxFJsAwmiBQDGeypVoOyaBykApUYk7?=
 =?us-ascii?Q?/6U6AR87flhjh09o5/Pf3kRdApf7gMyFKAbMbXsBrC8Po++fcR0kOUXfiW8l?=
 =?us-ascii?Q?PCPH0G4hzs/ta+kBVVcn97AM6Zf2popyCFllBtDe6BupdyCHA9ST/AsaYheP?=
 =?us-ascii?Q?wsmxNEfDikTjWZUN6dJhCvzLIZtib+5n7zsawk1KWkDgl8K4vfHfw1TRZ56H?=
 =?us-ascii?Q?9WSjVXo5fw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37b63716-e0a7-4c15-12f7-08da3d8f3327
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2022 14:10:47.7300
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OzUYrfo1cdaQupoQtV//QChFHLOJJ1abUQBgLos3gqLtTm7m7APMTGJSXYg7y3ax
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6095
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 24, 2022 at 01:56:12AM -0700, longli@linuxonhyperv.com wrote:
> +struct mana_ib_qp {
> +	struct ib_qp ibqp;
> +
> +	// Send queue info
> +	struct ib_umem *sq_umem;
> +	int sqe;
> +	u64 sq_gdma_region;
> +	u64 sq_id;

There are still lots of coding style violations. Can you get someone
from Microsoft to help you make patches in the expected form?

Also, please don't repost until the next rc1.

Thanks,
Jason
