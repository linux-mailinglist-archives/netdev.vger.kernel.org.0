Return-Path: <netdev+bounces-10236-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 36E4672D308
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 23:16:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D09FA2810B4
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 21:16:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 582E822D46;
	Mon, 12 Jun 2023 21:16:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42B73C8C1
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 21:16:00 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2079.outbound.protection.outlook.com [40.107.244.79])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A6013C33
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 14:15:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UyHGV3Tj1WVBmWA0gHx8/juy2eas3lWRfQxy/LmKjZhVVeHTV3lNqQ2J1k4ZTfFZXcNA7fZWC71PeGE9D5A/96t2H84l7/8nELIUvJyGf5Fgpp45yYUOR3I2xz/xzdiifrZrHjFlQMcJoNB+MCFH/SyjGz1dRPPE0CtfRCRQAC3UnUKXC9iekikGjONFUVDhK189DE9ihsvLngH9M33KSoGlYgdKgaiTY+j2fFgjHW6bo+Si1h7WJyQG1V/bTrcZA9xMtdMWGxGS5Sqbh85RJeaeGjvO0M7doeSHKjc5fPgEi4t/91LWDyHWfQp1G8zqrfLm+d25xUc0LGh+iVmeLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9U51ONhcIgQDsTWU/nQiSAI98OKrW9noMphLOTh7fHI=;
 b=fRHAbkEIwoNnh9HWlOSYyq5PQVrPgejvctwfPIUwtEFZL/aF2QqA7J3LjvWqVN+8IEDrh9PDUtvXM+gkS+c/0y5lekICuYdI4f4DR1374yJ/HkoG3JHBy/L3AMc+aey5SKp63+UTjXGc/0WZuC7hJqd9A70kf3tgUwB+NWPgGDezDOZowvt+5rLX3sdKfXLMU05+HFUXP+kIghATHmpxhSpmymehCFYLLwBrv5Z+M6qUgoeHwqD0aigFOqPcRXfDHuUWnJU7KeaK7//MIyeYYJI4v6lcXrOZxDaL0UatMPeC4yDsubkBs0jbMEtRHkjxKydeqQ130hL1H3o4RKQMkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9U51ONhcIgQDsTWU/nQiSAI98OKrW9noMphLOTh7fHI=;
 b=EQBGiSgg8ZCS2qIWICfOZrgFT1ps6lr66DsmI5XBcDsUlSujesG/i9NlskfIp6JQnMkNZf+mbCdoCiGsHwrwFaw6W3ju2txPYCvzyd6Mea2YrCxPtshRy93O/OvLfHqLbywnugr+BjgvgVJu6YaXQsX4QHvS1PrXwdlyTwSHnVSvsUj485G69WewzGTy0HhC3MOaQRvJ3fuaUK/c045Wr/AElAMjCw1QdOCyPnUJWjbjtnwsbOH0zEOqpJhxSajFDLzjQMbAuVndAZKrt14kHE+J4erxejOuO/3CDL1QZsRlO+YrnCnYnn8xutau4dg6CkBUOGh6WtGKw94ffBh09w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB2743.namprd12.prod.outlook.com (2603:10b6:a03:61::28)
 by MW6PR12MB8733.namprd12.prod.outlook.com (2603:10b6:303:24c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Mon, 12 Jun
 2023 21:15:07 +0000
Received: from BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::ecb0:2f8e:c4bf:b471]) by BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::ecb0:2f8e:c4bf:b471%6]) with mapi id 15.20.6455.030; Mon, 12 Jun 2023
 21:15:07 +0000
From: Rahul Rameshbabu <rrameshbabu@nvidia.com>
To: netdev@vger.kernel.org
Cc: Gal Pressman <gal@nvidia.com>,
	Saeed Mahameed <saeed@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Richard Cochran <richardcochran@gmail.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Rahul Rameshbabu <rrameshbabu@nvidia.com>
Subject: [PATCH v3 0/9] ptp .adjphase cleanups
Date: Mon, 12 Jun 2023 14:14:51 -0700
Message-Id: <20230612211500.309075-1-rrameshbabu@nvidia.com>
X-Mailer: git-send-email 2.40.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0079.namprd05.prod.outlook.com
 (2603:10b6:a03:332::24) To BYAPR12MB2743.namprd12.prod.outlook.com
 (2603:10b6:a03:61::28)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB2743:EE_|MW6PR12MB8733:EE_
X-MS-Office365-Filtering-Correlation-Id: 2bf8c9e9-3b1b-46bb-3163-08db6b8a18df
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	fVPvcTKqceLlfnL4ffDpPi6eC3lB2eZVkcoyJBWkUPbaklpb9BW18cnq6howzi25+U2zB6VH+6GNS4mB7FTF/BtRDas6qHhuWLCdEKPxDJKvITYZObmhim0JWD7zm5vOUFha7J5oQui0LkzjpKA7VhvLb3qLLMMWv11BJ5eHiiMVgxeMRK3D33ozw7ZEwgMd2JEQlJbI8JxMn41unyAApdV9alZzZENRVhjrZbaOyiaKkWayd8WbX0RCLZXtG4niybQs5zNpW3sgVz40c2GsvsMuqS4O9rh1Sb4UCwXy63cCDK6VF2Q5AdvfWAihPJVmXNSSU/LtDw9xsWmr2V4TbyRiR72ocsZ2hzHaqztI03QOyyNu0WVr0Lz6q9707l+KGrWgmzVUMFuUO13wIJ1REjD1+x9OoAJTlm3MlRDC/UHIeydmewyibV92zb8ZKUIyse20HjW36beT33KxI0qEUW2QKtgt+wHP9nigjyn3GLwg7jKI8dkjAu5lYbpTy8hTZs6zGnlDD0dMNbWl/FNLBVIdZyEhIk4qz2RTwi2pJxxMoXDVEdGhGULZe/0O9H4vYIVcU2IxBPOaAEhT4kz0y+z3AmroqvrWIyY+AEFHlWUwoEe/LUS1NkCD1SC+rwUOgLEAOle8rIF+FwCA9xCcPyMD91/5GLN7edkhCSXDGYJD/nmXitzr3tZQ6E+ufj3l
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2743.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39860400002)(396003)(346002)(136003)(376002)(451199021)(6916009)(4326008)(66946007)(66476007)(66556008)(36756003)(186003)(478600001)(54906003)(2616005)(2906002)(8676002)(316002)(966005)(41300700001)(107886003)(86362001)(6486002)(6666004)(6506007)(1076003)(8936002)(83380400001)(5660300002)(26005)(38100700002)(6512007)(142923001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5R0LmQiOmmmRpAs9TjA55XcBIbufpGEqdanf747TEifjLKNgRXQzkeQqS0Rk?=
 =?us-ascii?Q?wXTCBOMG3YM+g/8LLD/JITOnS3pr4j9DS0lBwGlb16AcxLO6HeGAAhUMvNxD?=
 =?us-ascii?Q?MLTVc9cHD4mhz4aETKg6n+1URuvhn6vvzL68ejwoz8oENKEbir+RKm+jdn0M?=
 =?us-ascii?Q?Kfgh2yCjqAlRA5BsFBSga3iyP3uclYFtNWsiGRtCP3foVNylLsYTsDqexqLV?=
 =?us-ascii?Q?0AW7g+jC2PIeCiMsQpl/cd2iRXPfOiUbtq1cFvICyXiEG5AkzPQnPGQh2YuW?=
 =?us-ascii?Q?zah5XFDyIERzmmM6prR+H4GOJtOaVDkAxRTNxUou+nx6UXh29PisktBFr+O6?=
 =?us-ascii?Q?Vl8R5usbsP7wiLP9+hWHW9OaCq4sjyh3QMhHX+dUbvaG/5cOj+uO7m7BSSeZ?=
 =?us-ascii?Q?7rAbKdYcB/hhRKdYedoYRywKdZGyQVWcVAqBpUwvAOcy5KoFM4vqu1JslgH9?=
 =?us-ascii?Q?ECj1BKfB1FdoEcb5TmDGVVeLA1QVHvs4Ckjx2cKoqAecJpo2LU+gpxUCJnSc?=
 =?us-ascii?Q?ZhdvERkqdK3VTixvvjZNV4TFwYvb7BGEfkKtv1a2Eog9+yYcae38aO6CfpOf?=
 =?us-ascii?Q?sv1q03HIX3OzBwnx7A6xYEXab7XNdD+ihctij68RA/bZ9OX0M18HxCocdKv1?=
 =?us-ascii?Q?yMyWKqKBZprwPRpsCBu+3qfstBb9Vv82sSVOTNlok2fnnCE69N97VzN77jyz?=
 =?us-ascii?Q?BFnZabrWZktxThxxfhxduwCuFVSluESGoeGGCpJQaI25eWs8D13OnLio+pXu?=
 =?us-ascii?Q?mCpbb/blHbVh+rAstFdMJ4ZpKCjrWwKzoI82d3RK8faj4t5UuCMWDbHrPvjs?=
 =?us-ascii?Q?rZG1IBNlmEzIBgf1dPfRue/SiYQzaczt1rqace1TUgvcxURovKHQx9y6TNbH?=
 =?us-ascii?Q?o9u/bfk4lSUlTSd+c1LWn/V03+kgr9FKnpQAlyehf2V71fhGxPIE7iOiioYr?=
 =?us-ascii?Q?diFGWq6XIt+ul2OF4uIo5wAC70nKdnynmMNhubEfxKQ9IJ41aEBiC95uDKZ9?=
 =?us-ascii?Q?tIXjqLah5g11Hbhz3dhIF8Fw7xnwUMnfeIQzZutWs7xCHp4QnWd8r+8Kf/WX?=
 =?us-ascii?Q?cKEqqflvBk7A6XaPbWH5VuO6Jzj8QSCGZDd00RbmuE011V7iyzHG8v54NCsM?=
 =?us-ascii?Q?4+M1BWbPddALQa/7otss4UDYklxVSX/5NbTXDp55I88/XMwkIDrxR4a5uuVE?=
 =?us-ascii?Q?09f87zJcFbT0vLS+YgzW5AlmmXa7l2nYBU7mvlL4LkZtzqm1wVchpuF6u5rY?=
 =?us-ascii?Q?Ov6qFktKoIOQ0a56U1cu6l3ORKlb8k9pTy/CVr06O8gO8AzQ+VKg2qlXmD1g?=
 =?us-ascii?Q?ckZEP5VhILEjpvM5eV+dDeI1vStS9UGt/g4YAGbfw72HsPxCQV+UV7vKWiuM?=
 =?us-ascii?Q?Faw9Yp0YEHaVrC1/NXeRhKk9W8x2niWhO3yBNVUj4wAuL1vSXuVdULIZ4f68?=
 =?us-ascii?Q?7/J22FM9SLGEFMXswkYZilbUY6nn+jDqtBgEceCj5AL6qxjohVzQH2bHUghQ?=
 =?us-ascii?Q?2t5mXM2B5IuUl1ElX3axHmbeaNo9E7XOXUX3QsCi/s6BvICVp9mr4Pw4zb41?=
 =?us-ascii?Q?lu328A5Llanv1U1f+kA+9oc4m3zZFQVdq7mD+ej9VV/OS+VVeqMZPAt8X83E?=
 =?us-ascii?Q?Rw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2bf8c9e9-3b1b-46bb-3163-08db6b8a18df
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2743.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 21:15:07.1725
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B065Df/fFhzsPeYgSTzTmZik0Gs+k8erZWhoYdfNYFkDgFU3A+8QSMlGzwonS6eNyFRajljLYKq8yXloVwQ3Gg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8733
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The goal of this patch series is to improve documentation of .adjphase, add
a new callback .getmaxphase to enable advertising the max phase offset a
device PHC can support, and support invoking .adjphase from the testptp
kselftest.

Changes:
  v3->v2:
    * Add information about returning -ERANGE instead of clamping
      out-of-range offsets for driver implementations of .adjphase that
      previously clamped out-of-range offsets.

      Link: https://lore.kernel.org/netdev/13b7315446390d3a78d8f508937354f12778b68e.camel@redhat.com/
  v2->v1:
    * Removes arbitrary rule that the PHC servo must restore the frequency
      to the value used in the last .adjfine call if any other PHC
      operation is used after a .adjphase operation.
    * Removes a macro introduced in v1 for adding PTP sysfs device
      attribute nodes using a callback for populating the data.

Link: https://lore.kernel.org/netdev/20230523205440.326934-1-rrameshbabu@nvidia.com/ 
Link: https://lore.kernel.org/netdev/20230510205306.136766-1-rrameshbabu@nvidia.com/
Link: https://lore.kernel.org/netdev/20230120160609.19160723@kernel.org/

Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Richard Cochran <richardcochran@gmail.com>

Rahul Rameshbabu (9):
  ptp: Clarify ptp_clock_info .adjphase expects an internal servo to be
    used
  docs: ptp.rst: Add information about NVIDIA Mellanox devices
  testptp: Remove magic numbers related to nanosecond to second
    conversion
  testptp: Add support for testing ptp_clock_info .adjphase callback
  ptp: Add .getmaxphase callback to ptp_clock_info
  net/mlx5: Add .getmaxphase ptp_clock_info callback
  ptp: ptp_clockmatrix: Add .getmaxphase ptp_clock_info callback
  ptp: idt82p33: Add .getmaxphase ptp_clock_info callback
  ptp: ocp: Add .getmaxphase ptp_clock_info callback

 Documentation/driver-api/ptp.rst              | 29 +++++++++++++++
 .../ethernet/mellanox/mlx5/core/lib/clock.c   | 31 ++++++++--------
 drivers/ptp/ptp_chardev.c                     |  5 ++-
 drivers/ptp/ptp_clock.c                       |  4 +++
 drivers/ptp/ptp_clockmatrix.c                 | 36 +++++++++----------
 drivers/ptp/ptp_clockmatrix.h                 |  2 +-
 drivers/ptp/ptp_idt82p33.c                    | 18 +++++-----
 drivers/ptp/ptp_idt82p33.h                    |  4 +--
 drivers/ptp/ptp_ocp.c                         |  7 ++++
 drivers/ptp/ptp_sysfs.c                       | 12 +++++++
 include/linux/ptp_clock_kernel.h              | 11 ++++--
 include/uapi/linux/ptp_clock.h                |  3 +-
 tools/testing/selftests/ptp/testptp.c         | 29 ++++++++++++---
 13 files changed, 135 insertions(+), 56 deletions(-)

-- 
2.40.1


