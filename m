Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6DC8542E99
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 13:01:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237085AbiFHLBv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 07:01:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236041AbiFHLBu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 07:01:50 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2079.outbound.protection.outlook.com [40.107.220.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D34BB30D;
        Wed,  8 Jun 2022 04:01:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=crjCysYPsHD6VThU3UXXhaC4b9/kO/s51rGGIH/Mwy1Ql5EEPqRyZdDwc1//nHMcLsUC4Dnn2aX+KqPM2hhcyZFKYPZ+PlQ11u68ty+nz9Yn8jYQjnFiaHIAv+FJ8CTc1GaARKUkB3PQMSdXZ1CKCfXZQghn52hHaoDsBsVVSy59fkaua3d3jawh4K+u9f+YerSe5Mou3VwYfnZkGhn+PgUwB4ss+YVKsKkAk2EpYP5nbKkM95g2MjPzvpsJApPJg1iLwE3FUHTlfa5mC/hmJqu+aastEn3kqISxigZ3J2Su/aS+EUPAB8/z4ueyDQPKmUCQi80rxazrIDFXaghe/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=loOhDSpfgWyJlW5ow/tSDjyGutdsrG2O2FnNWOp+pvI=;
 b=n3pCMPAT3PqsSZtuRU4FI3uMNdqOUB6LVR2o/GkSJ0NubuYmd/AuYHnm/OJDMDpC7cZE1kUW6rsZMeyan/O2MB5ryYa8Gr1kaNV4WE2bdQJgqxglfs50TWJhuFdORZ4yI60xhhKW1jb/18MqWLLI4Saec1jm6quaaoX4N1Wu2WMGXAlWtFRWntEOrQxljpy3f+8UJUnMDEqt0bRYKIJlZSYr22HnUC5mlPLbCoD40Peehe2PUEyt3QDTwpNf7oR7speb3utV6DXcPKHCefWJbmPm3mDma9l0DVYM8Y8uZQVS3pkDTAWZmsaKfVsvh96KWmnZsoz9ibuUTBWeKnqP7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=loOhDSpfgWyJlW5ow/tSDjyGutdsrG2O2FnNWOp+pvI=;
 b=AoImtXv7simDBMFq70TH6XQGgYN9N5Dvk8AAa6XRQEMN9i+skjZRD0Gl8etROUqWaQRMCwjiHe2e9zqhQ+kFO3zbtoC4o2aTF8Dp5iAMd0PYpQkiyjstBj8yC3pToRqrnxiJlOMCAWOKGtaSdGlCCGO6w21ibt4PxBepG9I/HRCZAOxOV0GVbEVgYPoSq1Wx0ObeKLrxjj3mxnP534kv/8k9NYpydKI32V5j9QLT7uyw3SBXAEmBBCbRjPS8S6B4Az789yMkdpBSV0r8CW5F+JaVUuFG95p+YZGG3bhk6nbIKMAkkV2Wq3uhv7kyqyaTtMzqXH/6JeEV0ujLAZs6KQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by PH7PR12MB5655.namprd12.prod.outlook.com (2603:10b6:510:138::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.19; Wed, 8 Jun
 2022 11:01:45 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::2484:51da:d56f:f1a5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::2484:51da:d56f:f1a5%9]) with mapi id 15.20.5314.019; Wed, 8 Jun 2022
 11:01:45 +0000
Date:   Wed, 8 Jun 2022 08:01:44 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Aharon Landau <aharonl@nvidia.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH rdma-next 2/5] RDMA/mlx5: Replace cache list with Xarray
Message-ID: <20220608110144.GA796320@nvidia.com>
References: <cover.1654601897.git.leonro@nvidia.com>
 <b743b4b025c5553a24a0642474583fb3de8bf0de.1654601897.git.leonro@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b743b4b025c5553a24a0642474583fb3de8bf0de.1654601897.git.leonro@nvidia.com>
X-ClientProxiedBy: MN2PR03CA0028.namprd03.prod.outlook.com
 (2603:10b6:208:23a::33) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 14c64b67-3512-4a2f-ae17-08da493e4718
X-MS-TrafficTypeDiagnostic: PH7PR12MB5655:EE_
X-Microsoft-Antispam-PRVS: <PH7PR12MB5655E6E8F82487C1E0BF88D8C2A49@PH7PR12MB5655.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SpTs3R7tbmDE32ZbBnoLyxrAKWfeCt+dxTANHezzDt3R4w8oV35rmLzjFCpVGDJo5r8P5eMKSKN+XWvIBjuPkNDcvDhpwiGrB6dy165iWZa6/N2t6fz0aIERw6LGS2Gx5Iqt3AMyupgvJe6JKZb01+MLRyf/0ruGzqt/xBsPU96c6am+5mym9xTXaZu2/k0N29Xq2EpZVFCItFUj0BHOGJnJmKrUDlgB4j+BrSl2mEhWOsZXoCTi/L1MOqXZUyKHD41Jvxsis70A/J0cj48e91o6vMwyRBCCrb5j6f/DO4uBqhfLPel5lPWaRcYYxrID+ilL+8sda+jn7zpHX8+j7uQGWzGFdBjjpBa0UwUp0C3ssDsBxY6Vd/DOQa0vW1Q8f5s39CIW1HRtiCsZ2UjZTiJljrpgELrd0HPUpkHPsn5Kep+V/rC+NX3tz+3G0CvU2JqP9hLpEZafiPQfrq6gZqMI1AtPQMMpw1ErRDZYzRBJXPyKO1JR4WYIUs0z186rx+VJ2rNh61B3jyBx+vJfv7xuo6FnG5WvAfJzR+dIG/BaDN7I/HgvwyMcLRS6eFAkAqLANENDM+bpwoNMts5VeBddYvwabt++I7MCM1tf+kaiqzZFMXRPaqVCKIbq4kdA3tsEmwMKVdX9b55AVkjoejNRE4cITtR3mgxTOYJ0RlmBucayVa/bVRl+MCwT2gUIDv2rC19rDe5huZLXQhPMkA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66946007)(1076003)(186003)(2616005)(86362001)(107886003)(54906003)(8936002)(26005)(6506007)(508600001)(36756003)(6512007)(83380400001)(6486002)(5660300002)(38100700002)(33656002)(316002)(4326008)(66556008)(66476007)(8676002)(2906002)(6916009)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tuhhjMF1TRbZdtWLMSb7K+zkn7TLtpJsR6mbXvLD2ta/KWb1OOnBs2ANskkA?=
 =?us-ascii?Q?JrUKKQKnyLxnr7HbbiiZzMqGJDRNPoy1PcRO34rhIO8nOffrzfgwSB7leRqT?=
 =?us-ascii?Q?MMWCvXq0epb1yiFGQX0HgUfzhEhRTKZ8qrwvCzd+grd1x2EclJCRq6IJV6T7?=
 =?us-ascii?Q?Rb+GS1l/bFiEP6hi6T7n/x/AZTWWcGy/zHmkJ1TMdfxlEDxQ+UP2XW/CEu2P?=
 =?us-ascii?Q?+Y7J4Q1lK6gp2diPu2Gaa0K3NYq7o01n50xOhRzIsd5EGXK/1ipdZIq6eWVV?=
 =?us-ascii?Q?3Ve6R5oSIfE+0UAMumK1Dy6JGOkWvVRgHSU20Byc2LOI466XLhD65cCrtRGh?=
 =?us-ascii?Q?NqvQTmUzATc3uc2B5pUxFX/teFlhqZcRFddJbwBvqQNaq77RRPHSWVT3Ebsq?=
 =?us-ascii?Q?k6SCrZsKGWhgljKunP1h6hkII+Iy9N8nyt1XnhClgEr+Ay4MOLlaAyL6/S2U?=
 =?us-ascii?Q?2ynvbN3HTDWvqAUvmp6A8NzokU7fuSV24co6XKeHZN6ttZWHWyegXChOE5Nq?=
 =?us-ascii?Q?Sq0VGv6M/Q78B6wic+vKDMuNuo9FPBhqK0i1u/DfaNiDwMuAz676PpUhmHMr?=
 =?us-ascii?Q?9mX63LaLdnsRrsEL76qC2kt8OuT+6b7cZHdosAG2Vj6itSgTe/CKGZ/RoYg5?=
 =?us-ascii?Q?oyWaniMavlqhsiZe6Yq4+5gAcWMTeeNSd2RUZ3RhU3VKs8dXMHj1utgvlJGx?=
 =?us-ascii?Q?axMH5c/omNUnNlF3GPqG92b1iPJEtBBCHGZ1XGnS5aZsBNrU+ZZE+PJ7yvB5?=
 =?us-ascii?Q?udi44Q5m62I3X3xVY1CntcrjEOdq4vZeSByDktls6QYjm126IxVzsXuL/MTw?=
 =?us-ascii?Q?6iX1TI/wDjeSxDNgCmL4REIRM7nUUKqMVQ+5lz5DR6GvUxYhwHdzvGs2bmih?=
 =?us-ascii?Q?n6RVJUwHknaSlAX/eD1tXVaFWjWWEAlbJiwLAHw+5lUpxDw0KevJiLtVxgEI?=
 =?us-ascii?Q?xIMGmdCcGXjtx8CxxwdR34P5SgSJDB+d4X3Rb5+bYVLxPFqUuDVYaP2X7J9x?=
 =?us-ascii?Q?7oaEOlVnvIXexbrwrPk30S7PQWIGvKyUPsNgvR2+Ub4bsx4RuksrK4OCDbzq?=
 =?us-ascii?Q?uGUYLK4omnD2P6T0xLy8XBxRLnR+eVTuuMyhwBEBP3MnJLXiMiwmbtnVJpC+?=
 =?us-ascii?Q?5cB8gepKkLtZ3k6zwNI/Ma9hi3cSt6qUBCWI72u+tkAtxV05Oq3E8R2rE9UM?=
 =?us-ascii?Q?x3aEZOZV7+gNN8AudnhktZQ/fMLdaa4HOMEKH5q+j97rrudu+WdEA25cLIWe?=
 =?us-ascii?Q?A4m+XOqy9lP/YMQycFA/ZLs8CFdzb5Rz01QpTbt9Q2UJZmOzbtJ0lIOcj1xJ?=
 =?us-ascii?Q?C1BR1FNheh7d4pHnBeOUJF3SZx5VF65hjT8lwEoy0VAiL3ysxYDj1DphDiM/?=
 =?us-ascii?Q?qaWxhOhn+0MrkORJQvhvwT5y4QQDwIQh+8H1MpXctSLlc8ExZyyNrQrajP2E?=
 =?us-ascii?Q?/xAcG7/1Dao9cKCN+ZV2hX+mAoYclxONjDmAsaOU9ohVEDrzZmI6P6erjfuW?=
 =?us-ascii?Q?qW7buXH7o1aK2mmtiEiw2Y5PvBTDpQBgkewZwtzFpLBtHY61K3XZTLf7Qrg1?=
 =?us-ascii?Q?pefF8TdRGhjiVOCEJ62+rmXkmbvPKpv2WxTuu+sJohNIHs1VBbzww3uEuSsY?=
 =?us-ascii?Q?oFO73aDqVMRor7CBbZRFVMJ3Q5Psokgc2f0KeWGhN6uH6XTnvmMDzJuGsTEz?=
 =?us-ascii?Q?puuX+hbFTipkVxzqmePd2yoQ17vYbQMdPeGvUpbDEe6nM3FzBNDx50nwL71y?=
 =?us-ascii?Q?y4mmohm4KA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14c64b67-3512-4a2f-ae17-08da493e4718
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2022 11:01:45.7643
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ce1CiqJO7BgXSxAeXD1deuV1h3mMgRZroY2NoXalkGdCP8oalXYI0/zBJMMd+1QU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5655
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 07, 2022 at 02:40:12PM +0300, Leon Romanovsky wrote:
> +static int push_reserve_mkey(struct mlx5_cache_ent *ent, bool limit_pendings)
> +{
> +	unsigned long to_reserve;
> +	void *old;
> +	int err;
> +
> +	xa_lock_irq(&ent->mkeys);
> +	while (true) {
> +		if (limit_pendings &&
> +		    (ent->reserved - ent->stored) > MAX_PENDING_REG_MR) {
> +			err = -EAGAIN;
> +			goto err;
> +		}
> +
> +		to_reserve = ent->reserved;
> +		old = __xa_cmpxchg(&ent->mkeys, to_reserve, NULL, XA_ZERO_ENTRY,
> +				   GFP_KERNEL);
> +
> +		if (xa_is_err(old)) {
> +			err = xa_err(old);
> +			goto err;
> +		}
> +
> +		/*
> +		 * __xa_cmpxchg() might drop the lock, thus ent->reserved can
> +		 * change.
> +		 */
> +		if (to_reserve != ent->reserved) {
> +			if (to_reserve > ent->reserved)
> +				__xa_erase(&ent->mkeys, to_reserve);
> +			continue;
> +		}
> +
> +		/*
> +		 * If old != NULL to_reserve cannot be equal to ent->reserved.
> +		 */
> +		WARN_ON(old);
> +
> +		ent->reserved++;
> +		break;
> +	}
> +	xa_unlock_irq(&ent->mkeys);
> +	return 0;
> +
> +err:
> +	xa_unlock_irq(&ent->mkeys);
> +	return err;
> +}

So, I looked at this for a good long time and I think we can replace
it with this version:

static int push_mkey(struct mlx5_cache_ent *ent, bool limit_pendings,
		     void *to_store)
{
	XA_STATE(xas, &ent->mkeys, 0);
	void *curr;

	xa_lock_irq(&ent->mkeys);
	if (limit_pendings &&
	    (ent->reserved - ent->stored) > MAX_PENDING_REG_MR) {
		xa_unlock_irq(&ent->mkeys);
		return -EAGAIN;
	}
	while (1) {
		/*
		 * This is cmpxchg (NULL, XA_ZERO_ENTRY) however this version
		 * doesn't transparently unlock. Instead we set the xas index to
		 * the current value of reserved every iteration.
		 */
		xas_set(&xas, ent->reserved);
		curr = xas_load(&xas);
		if (!curr) {
			if (to_store && ent->stored == ent->reserved)
				xas_store(&xas, to_store);
			else
				xas_store(&xas, XA_ZERO_ENTRY);
			if (xas_valid(&xas)) {
				ent->reserved++;
				if (to_store) {
					if (ent->stored != ent->reserved)
						__xa_store(&ent->mkeys,
							   ent->stored,
							   to_store,
							   GFP_KERNEL);
					ent->stored++;
				}
			}
		}
		xa_unlock_irq(&ent->mkeys);

		/*
		 * Notice xas_nomem() must always be called as it cleans
		 * up any cached allocation.
		 */
		if (!xas_nomem(&xas, GFP_KERNEL))
			break;
		xa_lock_irq(&ent->mkeys);
	}
	if (xas_error(&xas))
		return xas_error(&xas);
	if (WARN_ON(curr))
		return -EINVAL;
	return 0;
}

Which can do either reserve or a store and is a little more direct as
to how it works

Which allows this:

>	if (mr->mmkey.cache_ent) {
>		xa_lock_irq(&mr->mmkey.cache_ent->mkeys);
>		mr->mmkey.cache_ent->in_use--;
>		xa_unlock_irq(&mr->mmkey.cache_ent->mkeys);
>
>		if (mlx5r_umr_revoke_mr(mr) ||
>		    push_reserve_mkey(mr->mmkey.cache_ent, false))
>

To just call

    push_mkey((mr->mmkey.cache_ent, false, mr->mmkey.key)

And with some locking shuffling avoid a lot of lock/unlocking/xarray
cycles on the common path of just appending to an xarray with no
reservation.

But I didn't notice anything wrong with this series, it does look good.

Thanks,
Jason
