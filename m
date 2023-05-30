Return-Path: <netdev+bounces-6518-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B6F54716BF0
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 20:11:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 69F402812B1
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 18:11:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F70A2D247;
	Tue, 30 May 2023 18:11:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F32A1EA76
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 18:11:15 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59BB8A1
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 11:11:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DOD1v+x7BJBM3I8fl2Jqa0axzySzEoGtrNkRnH8aKOjKWg38M1WcSL01apwLf7EHWeJYUPI0mYEWuGdJNaQ9bEsnlu2FL9PUcEJTLhc++0/oAYb36YthRRMgERmsyTU9M9pv+K/WxpqJy9C2MT+NcJECSyyVjA3EBloEuj8ZV+lrEY/eZqLpcMvZjpWh9DfBBIfK/82SFmgHb++KYOYDWScM8cpjBeHbiotaHit8MWWF3optm6xrZN4H4dw2jyCT1ypqJFr7PIb3K5xPAMHYQSfqF07wxbfH78YoCiRYRBVgD6SkRA00Xxdwi5STbN83zraKx1ahK3QIL76V8Lc3gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t7oFw3YPivRoBOxn+Q7Scs5U8Bp2jRYSohAirykwhY0=;
 b=m1NMoVQR9YwODz14d9DaIKaYMbfpfyQsUQr83sKNGRAapMb55Ubde0yF+tWRMOeZwYGmwj92OIr6RKrRn/gPR5ya4nxlWTcbthVopZ7L6puUwlYp6X/2K8mHXN8ydgriLfAPyz+M83Yzwn0ZITDXgwLw2MzaZuwxob9K9TKOEfqcm9DY81j2L+QjWN9p521jYT1THedU1M+wcUWcuDmhqGt2DzHLf9v4Wqd/Yztdiqx8prW4/zWp8fibT1/8nKl0lcVrmwOxlE8N33IoJzPfEV1rJFuNcXe1BhfIFyfP5PiyvbgB4xmSVQBlsq73Yjy4ihR3X47u27nA/ekM3Z6fSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t7oFw3YPivRoBOxn+Q7Scs5U8Bp2jRYSohAirykwhY0=;
 b=GLH/1yR6D6W4C+Q1X77OdyW1fVwX66GVsk9dmIS2UkW4YQI+Ppd74CqQl2HVxVtkfA2ChStYkOSlVEQQ5xbLeCmPubIZOlz828zv/fJe8JakEEIWgM4NB/gyjZ6DKDOEGqT5tx6/WBpBjAPoUh28PQhHPItjFj+ul5dDb3GMF4c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ0PR13MB6110.namprd13.prod.outlook.com (2603:10b6:a03:4ee::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Tue, 30 May
 2023 18:11:05 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6433.022; Tue, 30 May 2023
 18:11:05 +0000
Date: Tue, 30 May 2023 20:10:58 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Cc: intel-wired-lan-bounces@osuosl.org,
	Jesse Brandeburg <jesse.brandeburg@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
	Victor Raj <victor.raj@intel.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Martyna Szapar-Mudlaw <martyna.szapar-mudlaw@linux.intel.com>,
	Michal Wilczynski <michal.wilczynski@intel.com>,
	netdev@vger.kernel.org
Subject: Re: [PATCH iwl-next] ice: remove null checks before devm_kfree()
 calls
Message-ID: <ZHY8MqU4Kfb+aTIP@corigine.com>
References: <20230530112549.20916-1-przemyslaw.kitszel@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230530112549.20916-1-przemyslaw.kitszel@intel.com>
X-ClientProxiedBy: AM3PR03CA0055.eurprd03.prod.outlook.com
 (2603:10a6:207:5::13) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SJ0PR13MB6110:EE_
X-MS-Office365-Filtering-Correlation-Id: b9a1281a-eda8-40ac-dbdb-08db61393c11
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	6Q5okZLhFwCH4hEPytNjCrU5GkZss/9/8Dr2wxk+uphKaYzW/kVZeaEkhQei6qrPKtwxcP9SCuHdPxTh9/lC5yas8OR/1QMG2oarkPb7kDF/nCMPmbk+p1hb7xsd98saxTlHpwYfyRPmGN9dcK357MNZ1O6wpQesHjRu4IOfuaWF4EllQMBujzP35JVuZoz0ANiBHoG2UNZXODaJfTYKR4UurOmcTuGYrfdnn8D7FtOTWEjtLO72kBV3KhMwOBSodET5smRUoSqr0sgm+R1oSDII5b/tMuqUtChvw5Yvy57geKR+SNIf7Ihg9nLZgE7nq6tB2lLL+mLG+4gyQRyIqVRk3wm1RYO27RgtC6LkIzTdFuyYfFh9gFoIZvgTt2sd8kXOhfqTSDP1dlZZ4t7commFQ8BfwPR6Fat0mlkrtekgZoYubNJNUu2bSF3ZnoETGVy9DSHQ5vVn+WyXW6y4BJmtYCNfBEdxs4hzaE4n1MaG+fuotujVkgSNl+8VAOx3TLHYKZrx12+uXBMO2nGOHrxMmSp1j8GRl3HQ/Gi3bh572gGSRQ7JBYVdzCmteatBFsLJlypN8ftEnQZbswbuKc1iO6W2JDjMqPcdNrkjN6M=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(346002)(136003)(396003)(39840400004)(376002)(451199021)(6486002)(6506007)(6512007)(6666004)(2906002)(186003)(316002)(5660300002)(41300700001)(44832011)(36756003)(7416002)(8676002)(8936002)(478600001)(38100700002)(54906003)(6916009)(86362001)(66899021)(4326008)(2616005)(66946007)(66476007)(66556008)(83380400001)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?fzvi86wSv8V/JMa3SbAvsSmkCk3NJ5w5oBI7iTZ7eSAudEccK8tr2tL+eL/E?=
 =?us-ascii?Q?ga2xDPHdQLlt7VYwmTj7k4w714zYNbrC0OaaAcglH04VvoSmCVOYddrXppcq?=
 =?us-ascii?Q?NcTDbPDA3dFXeZRoWy5z5vWLU96RJGx9dmC7nIBX2zFy0KORc1a7BhpVbdJC?=
 =?us-ascii?Q?5jYb1fWECA8gjE5/rrNgbIy+nw4+7gBjX6O/YzT5gYR4d5YtHv2Ekn4YAa4s?=
 =?us-ascii?Q?2SpVbgjEzBJrzLtDs8ShOAsbRxIdt+vo6TynFltaRa21lEANEFb2VxnQbwJF?=
 =?us-ascii?Q?Dj+EoALf6wJslN6/mUydIqvrJlRI//B/N9vDJ/nfldgOEA1e+FJSxIOawUvX?=
 =?us-ascii?Q?3oqV+4dxX0GriuDVyYAD7TSYhx2dye2rzRz3fxkXkMAlqZ92xhMHQt3gb3O5?=
 =?us-ascii?Q?FsB1s6C4lT75pYyrciZ/1MrSqb5Hay4OaPESa9DqKMQDL92Xyu7xhMVbALqX?=
 =?us-ascii?Q?a7fGiNV157j2JVrY9BuS4Zjg97NxWbKfqToBDIHNBtbBmHhSGLq4QUeKmQpT?=
 =?us-ascii?Q?Y/dP4f5c4H5uddZIs1jtxpa9ALeaPyp8czEAKTdI4kqOWXMkEbvzSlFzhyi4?=
 =?us-ascii?Q?rO1tgX2PAEeZ15SBrZ6ToXFi38SPGxlza5xw4bqPZx7gqNn1rY3T3JBhQX5Q?=
 =?us-ascii?Q?6Mw9V63OcR0V63HpNFLbQJPJW6QTEX/Ms0mDOAs7WFwdIy/VP36fNOPKFP0G?=
 =?us-ascii?Q?zBosU5xuOZ/9HJdVUPrRKssC9Nnn4X5bXqjNgcby3+1Xu01DZdkvbVQ3HIMr?=
 =?us-ascii?Q?/rg8bdRnArtdux4FXiZOBRfm8sztsLnI+PLylgoGupFUaPJ0RgIgPz1X62Ev?=
 =?us-ascii?Q?dSa7Anhju/GeX9h6CH4YeGoWehufh6zGG1oiIw4lKoeIEDDdRK4cP5L+EP6V?=
 =?us-ascii?Q?YEUqoSoYC0AsfJgbFFXGUPu2SLsE3cqQj8sVQ61VlrRm/LJWiFV2W3tmKihY?=
 =?us-ascii?Q?r5jBQZuM1iP0hCDfymngail92l+HrQmTOhSLsD6IfrhEyTKXLIkMhw/Yw54j?=
 =?us-ascii?Q?pnB1+qR76nekUo1cQvWvjl3ScI9PxiZRiZQKZDeh9S4+xJDjz9KpffYNUrZ5?=
 =?us-ascii?Q?CM+IHvyAUMpYkUOM4rKFNAFHlsJN8Fhw6vUrC/lvuvoqYiiE230wBivduXvb?=
 =?us-ascii?Q?YrrX1yhwH15BepReOYx2VgkDeh3MD3E12MplOMDs+KMlbkRHB3kPIe0L4fvX?=
 =?us-ascii?Q?o1oj7v+AJPKYu0JBUTKPRHFr1RjwFBK2XsFbEX+enb+iYiIchKrovPCylXN7?=
 =?us-ascii?Q?h7c38IY27bZGlyDguhwTG+yQIiHjcDra0iLmXc43AvwTraFcfZSfxLjDJc0G?=
 =?us-ascii?Q?9SM5i+8G5+Ut6JMKx433Jb2RchrVmL9Da0/eWshGJTo8kwrGCtLK2cxr2lhQ?=
 =?us-ascii?Q?EGBT/vHEwe5DqaQr4LZUisAmzlmF/E/TV6CspPaSzrMri3hmQkai5gtkNP4T?=
 =?us-ascii?Q?GE9lLABCg6d1a3ORH50Tc9Q2W6GQ8nIhPJogwTjtasPOIOdb1yyN1/W7/6Iw?=
 =?us-ascii?Q?6p8XtHHjN7iq3PHGrXMZs15Ax37fx1f4IE67JMnYE9eGIQwsnG1NX/1g9Khg?=
 =?us-ascii?Q?UAhVFzdXaUf5BRanjiOF1biOyxZaENZkbmXBcHmo21bkvzvDcn4AynaW9Vua?=
 =?us-ascii?Q?vVJpCD8vh1QpSxGxqlBt7DBlxbq9V1ldeda0Ync+9EoRUmxpoTHPGIVqgYiY?=
 =?us-ascii?Q?JyXtnQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9a1281a-eda8-40ac-dbdb-08db61393c11
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2023 18:11:05.3915
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XEVw5prsGJqs/DULIAF9M4GgTeY8YF1d7I7dS3TNJHzY4kOg/BJXYoS8ZFWDL4MVhg/NO3Vk9yxQDRzPjusst9CllZnA94pBpz+C2UEKKuU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR13MB6110
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 30, 2023 at 01:25:49PM +0200, Przemek Kitszel wrote:
> We all know they are redundant.
> 
> Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> Reviewed-by: Michal Wilczynski <michal.wilczynski@intel.com>
> Signed-off-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>

...

> diff --git a/drivers/net/ethernet/intel/ice/ice_flow.c b/drivers/net/ethernet/intel/ice/ice_flow.c
> index ef103e47a8dc..85cca572c22a 100644
> --- a/drivers/net/ethernet/intel/ice/ice_flow.c
> +++ b/drivers/net/ethernet/intel/ice/ice_flow.c
> @@ -1303,23 +1303,6 @@ ice_flow_find_prof_id(struct ice_hw *hw, enum ice_block blk, u64 prof_id)
>  	return NULL;
>  }
>  
> -/**
> - * ice_dealloc_flow_entry - Deallocate flow entry memory
> - * @hw: pointer to the HW struct
> - * @entry: flow entry to be removed
> - */
> -static void
> -ice_dealloc_flow_entry(struct ice_hw *hw, struct ice_flow_entry *entry)
> -{
> -	if (!entry)
> -		return;
> -
> -	if (entry->entry)
> -		devm_kfree(ice_hw_to_dev(hw), entry->entry);
> -
> -	devm_kfree(ice_hw_to_dev(hw), entry);
> -}
> -
>  /**
>   * ice_flow_rem_entry_sync - Remove a flow entry
>   * @hw: pointer to the HW struct
> @@ -1335,7 +1318,8 @@ ice_flow_rem_entry_sync(struct ice_hw *hw, enum ice_block __always_unused blk,
>  
>  	list_del(&entry->l_entry);
>  
> -	ice_dealloc_flow_entry(hw, entry);
> +	devm_kfree(ice_hw_to_dev(hw), entry->entry);

Hi Przemek,

Previously entry was not dereferenced if it was NULL.
Now it is. Can that occur?

> +	devm_kfree(ice_hw_to_dev(hw), entry);
>  
>  	return 0;
>  }

...

