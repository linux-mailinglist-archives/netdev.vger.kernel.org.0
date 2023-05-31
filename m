Return-Path: <netdev+bounces-6867-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 25FE17187A0
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 18:38:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6175E1C2082A
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 16:38:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69944171C4;
	Wed, 31 May 2023 16:38:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46B6B14294
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 16:38:50 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2091.outbound.protection.outlook.com [40.107.243.91])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32B3818C
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 09:38:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a8N5U4QkQas4i9cFAr7iPOXG/XIrKQs0DzJpos28RbMxw/L24y+nSP7MyvB4vjV9v4zQqsz/WkHTJ4VCH3ULlxtnanIxTZ1b6VTvRE0leptlxR+gjASCOLdTckW/+bPXAuCnicEJaGqA3K1Pi9ea64KlTWkafpqoic3mMR6JjBXY34Umy6H2j9+4xtp1XrntlLA5kli+FnTKNAuGYPKAWIQSg9bkloCcrz3H3RaBszJF2NVjeTScsF7F5y1x0aGSFtACPUz32llzEqhOKREES1fzhjb2UeG0pvTPGC0qYaSmyFqX7tkTH8xHcQh8jxyzjyXOr5r6JOPT8BzNVqcg2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LSEczkqYyPLbgmSFVgORVtbvfEGUKGhQebJGLQwR34o=;
 b=Ml83bvi1f355bKgNTUX9q3ieb+Ve5eQVqZy+DJuC0yvm7n0kKsbOTfM6/Vxx8GDbdYRq1aF/Ba4qSHetZkmXW+j/lJSSph47SplgniWXj2zAQt0DN3Nlxwri7FUoPb73IAnqVGiyurUqwbvMEke1dvAb9qkKd6EXni7hSHol/s3124kQKn1IcQtbMeNEzv/JH2BeWTnJZxQ0AGDnazwnDojJC21b86bkQ5WSY+trOv4zYayCkV5DIbtMsuuaWlORvBarX4e26R4dtFcOrLjHZPDRuLxA+LZ2kmGzGDlT2Lqz2q1EPL2KtNhwLzkVb2rIYQMKU5mRu5F6QRMl/fvDlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LSEczkqYyPLbgmSFVgORVtbvfEGUKGhQebJGLQwR34o=;
 b=QZLiZVWVT+i2fEc/B4dxD5I34h0ZOG6hPWaPeGkK9ZJR9K7MhNTyxu8msOm2E454j3fdYNRISOyTA8SNsygImMQZgJAIKhtiI+TuZCnIzp6Vv9s3MlPEAItkLw+P6ynFuKu8/DH1Jq/cVGOb2HecvuHH8yT94k7ELLo1YTTE1bU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ0PR13MB5368.namprd13.prod.outlook.com (2603:10b6:a03:3e0::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.22; Wed, 31 May
 2023 16:38:42 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6433.024; Wed, 31 May 2023
 16:38:41 +0000
Date: Wed, 31 May 2023 18:38:36 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Michal Smulski <msmulski2@gmail.com>
Cc: andrew@lunn.ch, f.fainelli@gmail.com, olteanv@gmail.com,
	netdev@vger.kernel.org, Michal Smulski <michal.smulski@ooma.com>
Subject: Re: [PATCH net-next v3] net: dsa: mv88e6xxx: implement USXGMII mode
 for mv88e6393x
Message-ID: <ZHd4DJa7ha2Szne5@corigine.com>
References: <20230531055010.990-1-michal.smulski@ooma.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230531055010.990-1-michal.smulski@ooma.com>
X-ClientProxiedBy: AM0PR01CA0075.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::16) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SJ0PR13MB5368:EE_
X-MS-Office365-Filtering-Correlation-Id: 2eb703d4-a1e8-427d-7237-08db61f57e3c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	GVsVWNJb+GmvkRvbOIVrnpjnDgVZg0br/Qyk/5W3fONopoT+ohtub3nZQlw4Oodf+HouDzrExNeTNyF6C7PQEKlIMtMomJ8CEEMJk70pffnLcld4rnF8JL9L6AR574vTuCoTLTkGm3QlmfEdXu2jpfIcP922BSlKKicJUq+Qz2AdGLnlLGfbaAr9MDfa2u1Oki5Yturvx6hWkIC+ku4Q9atxPHMAbRVJq4lpM5qixtBBdI9ghpXH7mInEZm5la1Y/96s8W0d/3CleNP0jb/zQHxDflq+7j18HwgmRStDZxm1Gsr+SKegJG2/ITzEMd46jVDUhtLaVKMcnm+9iDtBNN+05pvcSu9Fm01NAs85D7FidvbURJW3oaBJd8SOty9RlBcKdlNhFwU5y8c2N2ASKo4kxHt20U+/wrbaL5u103jl4zEP3uio8opxvKwkf+v0wreX956iKpenTLaL9LKNr5+02tszr0F4C6eDWvNuH2wdf7cplyKP3znrtxz2P4cF9Qil8IIWGdZWLQpGFeGt+UVlSQUvxM4rhnBEVjMfkTFuIewVTTFSduEMqOdReOL63xhmjNHje8+C4Sk5Xr+7dioFvFFRq5b7CJ454Fsb4Igeo2Isy5o1ybEkJZj6PEqWSjt789bYXiBq6Ha9RuFrpklFpemUCS8FpNtG1Ek6774=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(346002)(136003)(366004)(39840400004)(451199021)(38100700002)(2616005)(66946007)(66556008)(66476007)(4326008)(86362001)(6916009)(2906002)(4744005)(316002)(186003)(6486002)(6506007)(6512007)(36756003)(41300700001)(44832011)(5660300002)(6666004)(478600001)(8676002)(8936002)(138113003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1CWWdfKSHFGwKc9Ve4Ts+b0VXz1gV+ew+bamD08DbuuzGmF2HtWFgCS7LkDZ?=
 =?us-ascii?Q?/fj+iUFOSCQY7VSsEv6VN2s7OQquR7jK2H7Tv/EYY++ECwyJ1uOtZ2ICicBt?=
 =?us-ascii?Q?pdxrEZryGroq9YcHpUQoT3e+GXC3xNRUpnaBgU/AqdX/IOkCEHHomSV8op3a?=
 =?us-ascii?Q?baba6NfKvmOexNzWLx2PnhdZQi5zEf3YljDJTO1Gt2GOMjHLbodhaKHzds//?=
 =?us-ascii?Q?d64D54mYIiqHgSfQBw0/LEe4AUqjLHZcSn4X5SUbi2KlTaUyMHKBpvsslu16?=
 =?us-ascii?Q?m0a8Seyw/aM+FMESJZNIT82+9J2hAYGFpfhN6bvzdCctx1tTi19seAo3b44l?=
 =?us-ascii?Q?Z8NfbhtdIfeojWKFRCls24s25Ie/U5xMp2P4AvyouFfSnhYSfDMvtXm+mCQp?=
 =?us-ascii?Q?oRZawAqgpgUmvV4CUIP1SYbE3O8rLWYHN0oaMQmq6no/yYlekT29F3nlE6nC?=
 =?us-ascii?Q?PYXo13J6VklEoQjcQnMX3giJOgdLSaUBPZ5xc54De+qeZtRMy+Tv9COJmh+q?=
 =?us-ascii?Q?YtryKb2IjH5UVyReaYqboZX6vV6ynnEt6pUVnT/tRGWNzalr4hluU5lJzav7?=
 =?us-ascii?Q?kNwKnHyzYmVEx8mkGtVpH9hmwbB5OMdqTBlP26MkeFNNiQtQiJSmfEqoQDRB?=
 =?us-ascii?Q?OF8wANS3wPkrFeUm9TPYZtS1TX5B6Jb17as/zS5RMiXvFwYMDHbsQBJNDnN7?=
 =?us-ascii?Q?/9ZyO32WnWgtqR3GMButcCXALopIOICynBQ5Z8mDyho8R1hQQwXaZq46akya?=
 =?us-ascii?Q?9Br1j797j5GEAhi0s7bsSiqO11oM3rSYpkTXjKZu/nw1/fG/HvvqLDQIE/iI?=
 =?us-ascii?Q?orcb2nola1nGWoNm6QRK8ZHeOrDssN5es3eEPMvuZxZ8LMl5msGpXrYYbOB6?=
 =?us-ascii?Q?zcbzVPbhd4c/EQE3u6kNQhkkvsP4CezsXZ1Rntmev2R6EEExrXog6ev62QGg?=
 =?us-ascii?Q?M0uM/RGbeR/uM1mU/woX3L2NAgo8UHs2c4Kzztyd3lSVEbdzbhuI+3HCGRMV?=
 =?us-ascii?Q?8iK48dCqVtJ3mBeaSr508wgvdGITWep+AALxjUMbgxyVRBaXCMlsLSyIB+2M?=
 =?us-ascii?Q?cE5yBXeJeSoCRl672XojUifRCRDG+Ogu2vJUf73PyrTU92uUflT135t8B1s2?=
 =?us-ascii?Q?6HB7dtYNGzCxpLUWv12L5hkewMEjYy4bVj7n+FAWdyOQCJc86izkpA2nQzM4?=
 =?us-ascii?Q?xtCCugIo67RFJz1SU/JL3xcIhRL4a0CHuVynJTOTZUrG4FFYyiI9dW/bbW4s?=
 =?us-ascii?Q?5MGa/cePFkrsuacraJJn6iFbEKCPAb+BLd7rkDPc8zbqJyxJX1BIsVEME5ij?=
 =?us-ascii?Q?z31uAMlFmXYcfFDdhIpLxYIUpcR5OsUlkTaS6RuKcp6Zg4HSHJilIqR+8J5h?=
 =?us-ascii?Q?jzk4ZL6sNCFA/1Lg4FTF3DTO25Vv6pckd6zJrrjfDT4Qiru4yOirLfMv795h?=
 =?us-ascii?Q?kzKECe4qVWnL2SolqT0rlfcNWVGfwN3FDu/nFZY3lTNOnKW414H0hocOILfM?=
 =?us-ascii?Q?e/AuF/CDpGFwXFMw+0HvT1mcsOwMDR2NoeyixG8kmo2XjjeiAOccPaSTPk69?=
 =?us-ascii?Q?NA+fkjHinf/bQAkL3IWoeGGZGNNwZQEpYXZveV14A1rsSn3ETNV/EHQ5fY1r?=
 =?us-ascii?Q?00KWEIxDYnJQUYPD2HQ2hwadNgOxxa9zxw2qmQw6FJsTMyT/NSUhwN1gznh6?=
 =?us-ascii?Q?hRhOOg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2eb703d4-a1e8-427d-7237-08db61f57e3c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2023 16:38:41.8837
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4zRe7Wmf0u2Azf8kKrh4LbewO/Vnu0s49xV1xpfTcPwLmEQ9bap6GB2jP+FGjovB7/c0Bnu8KOSYblNFB272n9vfii8JboPgQM9tLaidDkM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR13MB5368
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 30, 2023 at 10:50:10PM -0700, Michal Smulski wrote:
> Enable USXGMII mode for mv88e6393x chips. Tested on Marvell 88E6191X.
> 
> Signed-off-by: Michal Smulski <michal.smulski@ooma.com>

> @@ -984,6 +985,64 @@ static int mv88e6393x_serdes_pcs_get_state_10g(struct mv88e6xxx_chip *chip,
>  			state->speed = SPEED_10000;
>  		state->duplex = DUPLEX_FULL;
>  	}
> +	return 0;
> +}
> +
> +/* USXGMII registers for Marvell switch 88e639x are undocumented and this function is based
> + * on some educated guesses. There does not seem to bit status bit related to
> + * autonegotion complete or flow control.

Hi Michal,

: checkpatch --codespell suggests s/autonegotion/autonegotiation/


