Return-Path: <netdev+bounces-3686-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DD87E708541
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 17:45:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 944F0281970
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 15:45:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5BC821092;
	Thu, 18 May 2023 15:45:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C292953A8
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 15:45:39 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2126.outbound.protection.outlook.com [40.107.93.126])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83357D7
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 08:45:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AZ5twR++MI8qlY5UbzxdNxv9tplThAvnfZPUtv5Ndeh2+kIdUGWFrn4g1n9CWVaAqAMpv4FZ8esj3jGsmATX2k5eORSCNBswy49XDGkDwIguPhSU85qbkEvBa1g57ZaencTCmS3qVZxVju5zwgfmyX+AXnrHdOBJ61S6C8GwQKVogcT8JsKK8kVNTslslee0na0lV8cKBgj06CIqSJf/x3DV8ZMhzVpP/ZOngVSHI0FJP6EgdYt4hBCobBbg5+Q7+aHwv5IH/kIB4NfYszQI/nuVxZ8pNPiUtd4eyMrBfTClf4dtnMtNOWuQVRb8Z1uOF5Q/v909xCIQ6qW5jqyjEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2sTz252I2NHm+YmLbXIBo7zX6mjhG2da13twMPdMVcM=;
 b=hoA3ut7CReRp5SQOWIGrbTzQktzhoP2oqIb46ehEjmpuZUI8g0HtCcojIHGudxtmFnh36bEiWow8dj9oS7mpxiA2owfDelKWW0wuDIrZd34dqbEdaedjSUwmTHjCX97XwPWiOG5gm8+u98zMKKea9cq2Cdo+9ZvGqVEp5EpAnkBWPiavYA4qTU+x7j3ebSZ2NEzSBG+37ayAcopZWOmdh88H3T02RjghwmXHwH/Gov1sSjkkUD9IJImA0PNgiYI3WllTPd4+zl8TT1PfCg0DWdYCUmkzC0A9SitAyZHEwiCIDvFkJXCXUP4F6Ok8ih83567/9aZvNkRzKByVstz76w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2sTz252I2NHm+YmLbXIBo7zX6mjhG2da13twMPdMVcM=;
 b=gEfSKcjpMGNExv/krLyDmuG8//Aocmy1dAb/EYqJR1eZ3IzqqR1VTzD3cbFmmxyW/g1N0nTdEiwTpA/RvgtZ29hEyOZFvhbiBQNs9XWcQ85YdKG19Y2RhQ4gT1twEu8lHVZUXcuytCq3ehlgghzBMOz7HHq5Bj2erKjRmcbRQOc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5495.namprd13.prod.outlook.com (2603:10b6:510:12a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.19; Thu, 18 May
 2023 15:45:34 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6411.019; Thu, 18 May 2023
 15:45:34 +0000
Date: Thu, 18 May 2023 17:45:27 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
	pabeni@redhat.com, borisp@nvidia.com, john.fastabend@gmail.com,
	tariqt@nvidia.com, Shai Amiram <samiram@nvidia.com>
Subject: Re: [PATCH net 5/7] tls: rx: strp: factor out copying skb data
Message-ID: <ZGZIF3nD6O8gdASA@corigine.com>
References: <20230517015042.1243644-1-kuba@kernel.org>
 <20230517015042.1243644-6-kuba@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230517015042.1243644-6-kuba@kernel.org>
X-ClientProxiedBy: AS4PR10CA0023.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d8::15) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5495:EE_
X-MS-Office365-Filtering-Correlation-Id: 1708895e-33dc-42ee-2025-08db57b6eace
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	4Vq77ArSvATLxo2b7fxmfprPKLpJphi4xT3uGx0Dw9fJLb2y5MhEHsCdFOObwXwIb1Y5BoA1yRpdMBQw4ljSiG7tRB5yQ+CYCKfaVGcDa4o+aNPMcyTduH3TOd54OE/ZvuMkX/+ulVxax2xNCVc2IzUJelvADFoQH3Qtb2jOxbdR0+MamBUn+7o62WShaxO+VDo8ws8OhskUu8YBOHIUBpGi7f+j7n5rWz+qXi4zyKwmDMUlwSamlkdmfLYllUD5quCxkq4Dr9UufY+vFcdFoscbNUQmI7mOr0GlwF/LQyCOkhGvKKogiaGK4fjrv4y8yzIBVsiIpwkx8vl/oi8oBSS67/temK6gG6Q0A8VyProuh7oiZKkBYIIMd1/jvPMBnQ1DOd3Tg37KcOG0htX2g9xct87stXSNJiwWes5jm8Ogepz6trrscNQqmy/xBXc8NoCP4fDz1AQP5a2ncCwYBaJVFtYrRSuPDXJ5TznNTAVociz245r7G0rQc1b5penOdUVb87aLJJXmNmLKRjZNYmPqH6uOST8aDByJv2Nw7xiiaILgf4aS5rUZcNIMInTT
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39830400003)(346002)(136003)(376002)(396003)(366004)(451199021)(66476007)(38100700002)(66556008)(66946007)(316002)(4326008)(6916009)(44832011)(5660300002)(6512007)(8676002)(36756003)(186003)(8936002)(6506007)(2616005)(86362001)(4744005)(2906002)(41300700001)(478600001)(6666004)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?U6+LRY/v143ieeEW3ydRiP3fG/QUyOaE6ly7N8BVwCsJf7VVebPFJik0F508?=
 =?us-ascii?Q?QTHaT9MyNprgn6YN6XookaZe9AGxyCGTODWMXHimT/ndZbXAa4TQcp/AnWCp?=
 =?us-ascii?Q?cSIdSf5zpphbEdzhrpeg4f7rakUOZMV/scfEjwy2GUU9Ye9fJ43jkfijTfhf?=
 =?us-ascii?Q?IhbgNfHIABYYw7kERtGHPNu2mWCXd9LTIsz8Hde65Ao0VOBfFjdBEgr6qJKM?=
 =?us-ascii?Q?jaTp50EpHVFZ/zZqp2C9an8I9ctxzihFY1KE1n+Tnd8M+d8x79+XKJU+v/rG?=
 =?us-ascii?Q?M3SUJuk4qNHL1hMjPfNBFgUJ+08ZNCIgKWx6yGtNGCFjVpQ3158WC1fZ5fQw?=
 =?us-ascii?Q?WUUhsqGHCPF5w48g/HaQTWWmwru4gHyMCusF+UeD93fvE6W7UDrhdudxLdQY?=
 =?us-ascii?Q?297eL3gm1XW504wkDApBlp9klx5/1RRVA3RVDUql/GXzYFQ0N1FlRwjHkT7b?=
 =?us-ascii?Q?HSeMC4C+PafNJGAm+Gd8ALm1TXeGDr7uha43f5ysPGOxuP2KHYy39+JCQIR0?=
 =?us-ascii?Q?l+aI9PhHTMGyJMSYoeadTf4PFezn7v2E9/a1NMHiJfSgPhs7qRwpbWEnNbZc?=
 =?us-ascii?Q?rOoRGrOXwJPIHo+WvnxSh+MqeZbZEZD4iCzWXvvUHG02vAp5nGPxyKjNbdzo?=
 =?us-ascii?Q?5741QnIEzInqTXrRN5VSyQUmrsA4h4uI1xpFa/kOBumUSDTPGHpv9fYS+fD3?=
 =?us-ascii?Q?4wwbQTZhtWJgRykSGh1WeVGFp+GNz92drypWWh44lz9hOXXulqxSmp9U81FJ?=
 =?us-ascii?Q?C+nXEcyZ2S7o0+kp8z7Rvnwk6rXa2FnTmD8AVJoO8B9WvDlfljXRWh5Tw5Ma?=
 =?us-ascii?Q?2oJErrV66/A2ndy209sPasu3KJ7LgwX64HbEQpPLgttkGtQVjGJ4OvP8EILV?=
 =?us-ascii?Q?TQGDKUA0JquyxZF2lGnaqVTXlMI7laHjUHamCwuCdZB/L/w3LY+6GzA1bbav?=
 =?us-ascii?Q?xJT3AEEvU0O3EGBscAWHmaq/YUkWLTAxI0wZ0zLt17s7+45AdimAWmwTr9fn?=
 =?us-ascii?Q?2nu+rRgHBCZCfBhzUhYim25pTtl8oJHqsBknMpFyS4gSekEVzucmlrBIegX8?=
 =?us-ascii?Q?h+hIBGe4/Kb2HxNXZyHS8S42jPYB/bLcQenjO+g/fjeZ9Nh9JNitci1ews2Y?=
 =?us-ascii?Q?3c+tike436W27nag+jJ1xZOcSa+rFG+58xJWgbQWevtlrSU9yCFmWiL+izA/?=
 =?us-ascii?Q?lRLCjEgzD1VSx2/FNvOYBfWmmilApUYvcnjpLew7z6ga+/SNOq3LEiP23tBR?=
 =?us-ascii?Q?O0Ub07ZSK+am6JRISBvOmmIe/703D9SJsK9Q14piefA96p0uTP4JhNPommqn?=
 =?us-ascii?Q?Pg/RnDdy1KLEmhYASUF7xbOFJW2RBInPCyeau+u0bUBmvqS0QXos/EJHPOMB?=
 =?us-ascii?Q?SZtVq7LJc8agYIhbqxfKOwO+WNFmG81Bvy7eLbpG4fZF95Q4OfRciVSIeTbD?=
 =?us-ascii?Q?ZqkxswDMNakCkkFPphro82cZJeiCN3HHX+ionN3Crn8X2QjoUSzeWXjWqJmY?=
 =?us-ascii?Q?m96S/M3/MNbwY9QmLM6Ufa9czmkaMKO/A1MoIBltk7srI8+JBjjfHXaiN3iM?=
 =?us-ascii?Q?h2jm9aTp+K2CoBqVqJ2ToaBAyQszm93u4EBIKbJ3Qn/dOVi8A6Ki17T3YL1I?=
 =?us-ascii?Q?R6jj4rdoamRU1nSUAJXzA3QMUSsWYzFh4QEm6BcC8UJOUinmgsUdh9NfmXqh?=
 =?us-ascii?Q?+g/P8g=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1708895e-33dc-42ee-2025-08db57b6eace
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2023 15:45:33.9904
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xotkJVx+EMzUrmbqtx85L9uJiAYwWVjkFiEro86cfun4089FoxnmRDpBlelpU8NcoVQrbk9zjEgkLBWPt4qONB39ZFOvWdnm8VqPlWBR1WU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5495
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 16, 2023 at 06:50:40PM -0700, Jakub Kicinski wrote:
> We'll need to copy input skbs individually in the next patch.
> Factor that code out (without assuming we're copying a full record).
> 
> Tested-by: Shai Amiram <samiram@nvidia.com>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


