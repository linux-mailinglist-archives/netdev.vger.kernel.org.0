Return-Path: <netdev+bounces-6517-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D178716BEA
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 20:07:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8BB091C2090F
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 18:07:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA69E2A9F0;
	Tue, 30 May 2023 18:07:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA7B61EA76
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 18:07:02 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2130.outbound.protection.outlook.com [40.107.94.130])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45D41A3
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 11:06:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MR2lDf5lDlztEzxfm33sXxiw2TKSQOjHs+whWDffxXc/U5XPJgHgxkU2s+lEJ7dq9AiQgqgeZ9vkG2SwUY/xYlcpWnYsLnqy/UvLI0EQk7Lblh3xIwfG7go7jroOSc0iRNJD41bJxDA1uRoehiWUXUivoqAG42dKqUpG5Z05EDLbkl3zhEvK0LEIZQcWmBaLIuDwQ9lbf6pPUdHt1QcuIIi4m/dLeJLjWKFhxY/+CcIa4DigBnfGzXOsEY14RDCm4IQfnMpG7s9qcreZcDPdaH4HvbxqXr9EcOKYqcxncMm1R0YlTSfKwfTfgTb0+IZ6CviQ5yvCg7vga97h5/dkBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aztsZksNVRmITZvE80rVuZtwqdHxCi7hl8aHGj1U2xc=;
 b=V4yM+Rt00GupMxwgXb0FzeTeWD8UCMMXjFnFw+lUJQAn5LjRAxxNtNZLkONbAkq+J1YNC8BHmCkb7k08+tDhz5xCAD1GDl2JPCUtAilePqxCNmoAITlwgClfuocw3wk2cXcnObKTh4kgAyvcqL0bN8wc2ZfxLKbCS7e9hLB8mxlvvjuq2leMBy/qvT7A5GBv8h03nfDXV3bOhBLGdIYVOaUkqmJfuzFb0jJb4n5K7lUVqV35oZfmHr+DLGqNjQX9VxM3SsMD96moIR1HvKcxwVd8vfi/Tpw9dC1AsSRoaM/4CG21CidS+1zmvhwXgjruFbH3Og5VXS57klctuZmbeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aztsZksNVRmITZvE80rVuZtwqdHxCi7hl8aHGj1U2xc=;
 b=Oc9SI0Oe14+IXoZBWzj/2XuVlnDfU3AWu0NyMMhl9YHIj9+V+8L6FWtqt+KDQWuLTzfp/bIAZQe27IdV8xVoW3F0JQgpyZ+DQNOXPzXfq3SKB+VW838EzsNxaH5Ywet4lRnyelDOS+yl9WzSv46HfNZ8uw26mBkH7mKIoh+yMo4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DS7PR13MB4591.namprd13.prod.outlook.com (2603:10b6:5:3a1::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Tue, 30 May
 2023 18:06:55 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6433.022; Tue, 30 May 2023
 18:06:55 +0000
Date: Tue, 30 May 2023 20:06:47 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Cc: intel-wired-lan-bounces@osuosl.org, netdev@vger.kernel.org,
	Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
	Sudheer Mogilappagari <sudheer.mogilappagari@intel.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Subject: Re: [PATCH iwl-next] ice: clean up freeing SR-IOV VFs
Message-ID: <ZHY7N5zVWhzHCIUg@corigine.com>
References: <20230530112315.20795-1-przemyslaw.kitszel@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230530112315.20795-1-przemyslaw.kitszel@intel.com>
X-ClientProxiedBy: AM0PR04CA0056.eurprd04.prod.outlook.com
 (2603:10a6:208:1::33) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DS7PR13MB4591:EE_
X-MS-Office365-Filtering-Correlation-Id: 03cef8d4-7554-459f-9f3b-08db6138a6f4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	tD4qefULwgJw+Wn/+SvGy4GRrtPOpxz9JpWjsRsLOYEBnnRoeQbA4Y8zxhgc5CbZ8bpuAd80h+YPSZyMNl7Vs3m1JV8gDaepPTa8ofkNG2FbYxjDR6vG1J8Ro1OB52vqu1V+vT+kfyvRXymXmj4mdgsD4ngXmatuH70dBQ82fjsQgo8fOvbcRyQWyyj+Ds0IPvW6uO1vmzQKM2+L9kzbd7iSLCR4rE2kg2l5cTLkVvYORpyo6rcd5+PhFmYBFsLkzWXOufbWXhXM2L/dNRzZmW8leqrtT4CKeqqx2w7pD6E2qufhgORaXcalBYiYUk6/iv3zzPGoHb78BJgYcuHipmWF6N3UQvBTzvBrKUDtPWexwgY2dTRLd4WpngR5x3wcvDAJFnDQfpOG3fJLh39mfo3tNeDdYf4XQRapBZfrbnpnDDm5Atay08mpsjBAvZFFhYanbpj3qiG/GYrjCeal0lY9p5gAMyeo1MwOcOQwAuk1IUvJZYdT8h19oX+pT9CGZl7MwROOrqc8sVCOGod/DskkqeeIKcnUieHESBxT72W8sS71tNTdtCK5rOdLupH8VnF9VPlSPk51VsRzjIxKiC19NGxWPY5auvHIiojJKoM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(396003)(39840400004)(366004)(346002)(451199021)(6486002)(86362001)(41300700001)(478600001)(6916009)(4326008)(6666004)(316002)(66946007)(36756003)(66556008)(66476007)(44832011)(5660300002)(2906002)(4744005)(186003)(6512007)(6506007)(2616005)(8676002)(54906003)(8936002)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QYRrlnYdVrMKzEbh2Jw4s0/WoNfDId/2zTE4Ln28EkNoE3+CJSuM1qy3FTVS?=
 =?us-ascii?Q?JaKx9AyZ7V9C9BFUeFris2I0W0KSwaB5ZfM6z/gGt1r+PawbI9N/riWdpNC1?=
 =?us-ascii?Q?HlxlD63yokPdaPoQGy/6f9VZaABnuntV7z26d6JLTLpVUTjeZjK/qhUUIkML?=
 =?us-ascii?Q?kYeS++odh/jCQBOz+NIrd2vDCizg1MG26a2fIYbg98BDlCIAUaPqLnZFgV2O?=
 =?us-ascii?Q?BbmEQw/kk1YL4gHUdh84N1z3/t+COZ2JQCEP89Tt1HdY0W2FGedj3XSfRFh/?=
 =?us-ascii?Q?NastJYFXKldQ2dgMvaad46LjfbgwVmvGN69ptU8nnguf4ndbl6wanavlramE?=
 =?us-ascii?Q?PL+ICvxLBlXS0QM9QX1ihSpJP9P8JpYwV9oyq2wcnzVxK2dE50M132nLHeSk?=
 =?us-ascii?Q?J+pNgYFwPCGg3s8EOZHKxvk1HWa84DDg39GU9CS+J/aKBtxT+pdyG+xe3cno?=
 =?us-ascii?Q?I2xapPH2BKXKs2ML7z4sXBN7z6W+hQ/BT5XyUszFRgkRFBbCTwhvKl7B0Yof?=
 =?us-ascii?Q?ormgS5Fzb+xCfBn3DDBhbwRmgX80+1vTwDxfiUAq9rhzcs/e/udS7sUIizUo?=
 =?us-ascii?Q?aKEbBG/ZwELapezy8kyochlPpgTVh9mG/TLlBdYvHUDaWqvUNhxRxjuFIfhk?=
 =?us-ascii?Q?QNHUa/G7cTXRsfRheNKJ/SrZifbzjS9v+lWX0ia0vHL+0tOImhtzF/zPwpjO?=
 =?us-ascii?Q?3Nr9CM45L8NXRwLft2IEaTUsnm9CDGmQxT8zXlZePzAbLzMcJJlP0fFnmqkO?=
 =?us-ascii?Q?ca4Xh/13/sP8DBKwv/XjAWmnGaSZlwdw5iyct2JYp4UBU3Giy8GWS3frb4Kj?=
 =?us-ascii?Q?An7lUJbV5cqFRcthn9u7DUbUxVgQhKhTlcoiVCEJ2De24/ik1UN6/5ZoOo2c?=
 =?us-ascii?Q?riMjOZKHAjn/JskTRtAvKD5o+CC7iXzQYEdCG9CIA2RYW1n4jzsAVx9Vl58x?=
 =?us-ascii?Q?5VBMgzpj0OysMrYW2EGG7EKIadxqTXtrNGgw+guAF8oDnTvo/hxHVZKHK0KJ?=
 =?us-ascii?Q?Klu+T/TyGCVa/v5AYu+I1299fhFgaiL4WXlJ/kjcZ4nN3O5i8iSaer/bwJZX?=
 =?us-ascii?Q?44NA3dJ9aAGCcTh2WFd4L6Ctbg0uACKrfsYOPQ8fpq/w8TLzUavkI0JsfBTg?=
 =?us-ascii?Q?Dso6hIu8WXdv0z6VsI0b9G6yYvlcXIYcIx9OHIDmoAWUSF8YNP4SFW3xEPVP?=
 =?us-ascii?Q?LsBL05swp7uT+OCqDEYIEgnt7QB9ztH0j9geuhbMfIWYOqkxEYGFbd+n9TcR?=
 =?us-ascii?Q?4HXDOt7zANszmbAipby8yP0oe8qOhI7DjVKeVwDwdidGXIHq8bnruWgVT0N8?=
 =?us-ascii?Q?KRQSio7Ka6JD15eM9k18aBJxDxCp1pbmkDX0ZMG7GKGk336kwT7y3qP2vrNo?=
 =?us-ascii?Q?e0AfKiDxOSbPJDY1Wbpmaw2Kq1oto9WONelHU2iPzFIdYUnLNCFbDy8xAuGf?=
 =?us-ascii?Q?69yf62lehQeFQ0rwswePB7Mw8383A/3g1f9W29P1ZRTnqbCjjZUuH8+/gU7u?=
 =?us-ascii?Q?uchPE1T7s2HhGg3ZoBOamcf9x6aAOj2m1Wpnnn3fv6pR91EE4dcARiTWAqwx?=
 =?us-ascii?Q?yDw8ARlqDyEB7u3Lbtc0X0fQ2JZakzx9+0sbFY7pUzKAOalZfENMLiW9iYYD?=
 =?us-ascii?Q?iYQbJ/Sc/+zA/NNVMJtO8i0R+jpJP7OH4R+EnW4Yg3AEC4D8fDkO/MBCiRjr?=
 =?us-ascii?Q?KBt8RA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03cef8d4-7554-459f-9f3b-08db6138a6f4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2023 18:06:55.3936
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fx5YPQTRQi2BpLZ18tsLpend5dBLQw8ObMkMc6qyftqfNSGuAb/r8qh+OPoIxY62xjnBaxctWikWJaHaMZ5CSX+RLyuRMfJ0GKhxdExYjVI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR13MB4591
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 30, 2023 at 01:23:15PM +0200, Przemek Kitszel wrote:
> The check for existing VFs was redundant since very
> inception of SR-IOV sysfs interface in the kernel,
> see commit 1789382a72a5 ("PCI: SRIOV control and status via sysfs").
> 
> Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> Signed-off-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


