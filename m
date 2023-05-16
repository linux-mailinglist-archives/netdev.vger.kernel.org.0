Return-Path: <netdev+bounces-2957-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 96DC1704AE0
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 12:39:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 959621C20E26
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 10:38:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C742C34CD1;
	Tue, 16 May 2023 10:36:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B325334CC0
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 10:36:06 +0000 (UTC)
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2070d.outbound.protection.outlook.com [IPv6:2a01:111:f400:7ea9::70d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87F1661AA
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 03:35:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CdH6wuWNBtsvmOY7bs2PvSX3ZR3KfS6dVAqDULd7fnTZCFQXuJwePzZZSJZu8QojJIN0pft3xZug3RP1syfasPsPfLbfaOynw+5/MD7kJNbClGz5DPyjchPqvB4DUep1ufq5p3S6Hie49TM29coPQ5CWLuCE2aEgiUiraFrergLXc7GIxVQau2qJyRqiP+6MZCPx/u5hEwxKk1AS8GYzkx6ut5qyZSTyCLihOnoL5U46tTQuAqbRve4s0c8bEvq2fX8jca4HNvJML9FB/IVz89jTH6FgkjZqjKExKjw7cFWHZroeXHKwpFE5uWNSZTaofAQ1ym529C1LsOVqNTt8sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KGJpsAT8VHC8miga3AktnyU18rUBYGGsC5/WZFqAa+o=;
 b=DXzyg24WPekBD2ku558BnnfuWM5PXpBRjWEDYzsNOY5iXqydHBhdavQ+j3r19b/eDJNQ8eL5oW7bar0R0pHMKuXLn80wDaxCuiJjv6wkJEZlW25AnQXW/s/JcRytytLhzKdZf57E+NXqMekp4pZpuF8phOMhiNDThDzouPnEtDsraZL5yEytJMeayLDooHvHOwhk3mIHQP57blS7tMKOHgPGl/217GtkEkTIvoe2I3rUBxMtdmvgXHdV8oY04NoujrT/eUy4QnUDdnFwb0VCCCpH7CgRvkYEsNePqOv/pK8NXo4r1R0Jrlv4v7mPzBtAx7CkWQHFKblYVBsRSDSDPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KGJpsAT8VHC8miga3AktnyU18rUBYGGsC5/WZFqAa+o=;
 b=X271tidhXdXD6RXS5RH6AkGxEat5IN85c9BRxZLLG8cKXkrBAVnKynlkjDAnlMlqd/zPthQ+6sjwoz7LS7l3okc5ijP/ti2oH8rnJ/9dCpLng4mPvylFKU/wAjowg1B2hkmr2UVgfYNir3z7XJPJZx3MgKeDOVRculOIYttJAXE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ0PR13MB6073.namprd13.prod.outlook.com (2603:10b6:a03:4ee::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.33; Tue, 16 May
 2023 10:35:22 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.033; Tue, 16 May 2023
 10:35:22 +0000
Date: Tue, 16 May 2023 12:35:16 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Shannon Nelson <shannon.nelson@amd.com>
Cc: jasowang@redhat.com, mst@redhat.com,
	virtualization@lists.linux-foundation.org, brett.creeley@amd.com,
	netdev@vger.kernel.org, drivers@pensando.io
Subject: Re: [PATCH v6 virtio 09/11] pds_vdpa: add support for vdpa and
 vdpamgmt interfaces
Message-ID: <ZGNcZHUAC21S+uSK@corigine.com>
References: <20230516025521.43352-1-shannon.nelson@amd.com>
 <20230516025521.43352-10-shannon.nelson@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230516025521.43352-10-shannon.nelson@amd.com>
X-ClientProxiedBy: AS4P251CA0008.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d2::16) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SJ0PR13MB6073:EE_
X-MS-Office365-Filtering-Correlation-Id: e7ffa2f0-1417-47a2-9966-08db55f940b2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	RqtZSZE0O+z+ZxWJOolsFwcOzyeS3w9fJRlPoQE902UQcObcbsqF10QQDnuoAAgWcv2vIe5Pbevlv1dRmv+Y73YvRp9BYlCRI1Bq+dFif7LKqw3nkS+p8alwvTaIE0dp7cem9ifdO/BNbcFkPe2eNz9dEdO4bF4Bk+89fAM4IlwZ1tHDnfZnz1PSHhcV719qpbqMCln30FKgIZ3u3DO68DJoQURFgXIzVGPXTuw/nCXQM0jsbWWkzCmCsinbWgNCRhB2FXvzUzwJOvtsK7SjW9gSzUz9uOSudJn51YRJkm8ltueMSZddJ3m32lcHZc7P8AZtEV/X8mZJktFk6sSiCZe8ZWJiTzrPqND8ezjmoVlX66JHF3X2K7YGWPnDs4aYrmamu+pcfi5otMqQ7ohIfV+ABQnim354UGpmWXOMLADoBid53bGscIU6Qhmr1L2P4NYLpfFXknFK0/GeqoEtCHyQ+XkDKe5MQQjVzslHfhxX7O313lvJOO/PwIgjsVGgPJG/gHd19KQeNVztIKkFL3d/B6XfEpQa+9e+V3Y8iUZqtKEQNdurEsgzSPz1hQDxZIlzflJVqt/+P2Knxo6k6jWEof2a8DIwykqM73QhLODJhREke9Y0O9cSm4tnsqqmYrCLGfReurAjxBS6Yvk7JoUQXzAZeO4h0l18dQX0RHo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(39840400004)(376002)(366004)(346002)(136003)(451199021)(6512007)(478600001)(6666004)(6486002)(186003)(2906002)(6916009)(316002)(4326008)(66946007)(66556008)(66476007)(41300700001)(8936002)(8676002)(5660300002)(44832011)(38100700002)(83380400001)(36756003)(86362001)(2616005)(6506007)(66899021)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?PwURugV/EBkhWt3sifjAFDsANsbWa8ceFgjJQtzTHUAEtFjQw8lYivQYDC2Y?=
 =?us-ascii?Q?QcyPOZNJS39U8ClEdyjrRdOZH7D/3hKJIDbUslIkM9Dl7mmSK7cbpm2C+Xl6?=
 =?us-ascii?Q?1kgPszYK8sg9SelP4muZjP891p0BkFhQuKJpV080uAf7orX92Undpiq+Mrjv?=
 =?us-ascii?Q?t4JmdYr8av70/N8DWnUd9SGcPk6SY8dyrjgGhQgGkheN6iLo0i4ILRypxSTq?=
 =?us-ascii?Q?qCRjEb9xjhEkqd+yni8PprQCKvI+7M/biLVuBEEdPmom2FecwdvVa/IaXxHr?=
 =?us-ascii?Q?iUxZbot+hz4kckOyHdb8F9uIekEPdxlg0OXYsxIujLkqKORHgU1Nqvx58XMw?=
 =?us-ascii?Q?h5m9/xxpLVM3vNq107qkoEEBPbKgwVaYzucNuErWFbfol8UgZBjULPWx5jWI?=
 =?us-ascii?Q?30sVAuG60OwOCpOc8ssDxyiuf6r4c5FmfeANGx7fOrRb50JdnPlZzZiWJJ2R?=
 =?us-ascii?Q?JaxxYTV8l3abi75dN4qVo78TRtLFw8ZJjS1mnJlNC+hVWHSX9nlt4qwiFmjz?=
 =?us-ascii?Q?XjqlKsBs06JXt4CZvsYj9JUhkwt5aSU3un/AEMCJ/hKoU/sAEOXSDkRYtWjZ?=
 =?us-ascii?Q?RwsPDz2I6IpAiXS+30qoB8a4O6AFfYS3jenbqiBqGhklVuOxkoQWd9TFGdhi?=
 =?us-ascii?Q?ICPUDgNx3IyASnPnla4SkSYtrYRGRcn5ojNagCvsJXn8qKk+gYZWlxZZ2vBc?=
 =?us-ascii?Q?i7/wfYxAmw/XBipJ22OrM/EzTXlPi9RAny+RWB3z6lLZcbNBsDcpeK5u94sg?=
 =?us-ascii?Q?5SKrWV/O9DRs8chcoAzoszljyHePR4hKyuCaAyr6QnXpy5wyK6wlu9DC6UZp?=
 =?us-ascii?Q?IMERZjk+wY9X3OWZ8baqYfQtI9gVuii2i6g5pWz9iEXciMHYH1PM/YygGUb7?=
 =?us-ascii?Q?65kVDtYOx5FYXeTSNPlqXF2LWiMiuKUZay73OGQEF/JtgrVPg3FpqIeFz34j?=
 =?us-ascii?Q?tflK65PQvHaU+z0LxmA6asQKtXK4S8wNRc6EcRyUP4MQCWmD0DbSEejAFC6K?=
 =?us-ascii?Q?W+dyRcshpFxX0C+UW9w4+HTm29VkmFoTQai4JBFFEFF0ktbRJPZ/mL67L/C7?=
 =?us-ascii?Q?qj1xrYOo6xj6J3hbsPQEf6HfsWJ+nufnEhfCBQBOq5QJTTBGJWuW2Q2OyEYh?=
 =?us-ascii?Q?A6Ix2tQY11tSIPoOp+RlpL7DbhJJCqnC4TK0IthvvPZVu2rIE8O40WblRS/w?=
 =?us-ascii?Q?uVxE218vonDRZEkSxqPJXYGuWu7jaVpS8YGEgQO2MQ9SaMe5hivuu8bdpSYV?=
 =?us-ascii?Q?F3q4NyHRSvKmll8VXPlkkvAAUYP6S+hZkCiuFgb1mL9EJKV5y+g4TKHYfFaX?=
 =?us-ascii?Q?1lMZxKPxPCrPvab7YCvG43AqllfRrjwdzwGNxXL/i9eFca2Xn2wFDGQ1Py1g?=
 =?us-ascii?Q?WJheMoIOM6A/sl3q2fimKGZN0V4N7f49dhH1DYD0fFdniO3XItLJJ0B9Bxct?=
 =?us-ascii?Q?uS1YikckW+1sIerbZxaYVPD9PsQbkLKmKbXg10rS0tV7HUrdsWnTbWwXOhjr?=
 =?us-ascii?Q?3ide2F/8iQ8dkChBC6IejxQOYaix/Gu4fZ3bbgyHn9gQq5tWYhNePFIya/uO?=
 =?us-ascii?Q?HRq/m0bS5BoL21mL6+G3DjORD/sjWxj6aNFzS4c9Rqrf1xwdMISyU9cqrK0F?=
 =?us-ascii?Q?4SKWg5EFZkZPI1HR/Oc2HH3PnQG6WDMj3HnlZ9/9JYSHrDX7A5y25qtzK6ti?=
 =?us-ascii?Q?ai0unw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7ffa2f0-1417-47a2-9966-08db55f940b2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2023 10:35:22.5507
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I34jyRNd5Q2tQKtIRaaho6o1EWMXoClgXR/f5V8XrOn2jlHce6phT7N55jT4dxXBSAA8A7wbpryJmZDzz5kJaBa1n/bjNdkQMaQVqgxZ8EA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR13MB6073
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 15, 2023 at 07:55:19PM -0700, Shannon Nelson wrote:
> This is the vDPA device support, where we advertise that we can
> support the virtio queues and deal with the configuration work
> through the pds_core's adminq.
> 
> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
> Acked-by: Jason Wang <jasowang@redhat.com>

...

> @@ -21,12 +479,156 @@ static struct virtio_device_id pds_vdpa_id_table[] = {
>  static int pds_vdpa_dev_add(struct vdpa_mgmt_dev *mdev, const char *name,
>  			    const struct vdpa_dev_set_config *add_config)
>  {
> -	return -EOPNOTSUPP;
> +	struct pds_vdpa_aux *vdpa_aux;
> +	struct pds_vdpa_device *pdsv;
> +	struct vdpa_mgmt_dev *mgmt;
> +	u16 fw_max_vqs, vq_pairs;
> +	struct device *dma_dev;
> +	struct pci_dev *pdev;
> +	struct device *dev;
> +	u8 mac[ETH_ALEN];
> +	int err;
> +	int i;
> +
> +	vdpa_aux = container_of(mdev, struct pds_vdpa_aux, vdpa_mdev);
> +	dev = &vdpa_aux->padev->aux_dev.dev;
> +	mgmt = &vdpa_aux->vdpa_mdev;
> +
> +	if (vdpa_aux->pdsv) {
> +		dev_warn(dev, "Multiple vDPA devices on a VF is not supported.\n");
> +		return -EOPNOTSUPP;
> +	}
> +
> +	pdsv = vdpa_alloc_device(struct pds_vdpa_device, vdpa_dev,
> +				 dev, &pds_vdpa_ops, 1, 1, name, false);
> +	if (IS_ERR(pdsv)) {
> +		dev_err(dev, "Failed to allocate vDPA structure: %pe\n", pdsv);
> +		return PTR_ERR(pdsv);
> +	}
> +
> +	vdpa_aux->pdsv = pdsv;
> +	pdsv->vdpa_aux = vdpa_aux;
> +
> +	pdev = vdpa_aux->padev->vf_pdev;
> +	dma_dev = &pdev->dev;
> +	pdsv->vdpa_dev.dma_dev = dma_dev;
> +
> +	pdsv->supported_features = mgmt->supported_features;
> +

> +	if (add_config->mask & BIT_ULL(VDPA_ATTR_DEV_FEATURES)) {
> +		u64 unsupp_features =
> +			add_config->device_features & ~mgmt->supported_features;
> +
> +		if (unsupp_features) {
> +			dev_err(dev, "Unsupported features: %#llx\n", unsupp_features);
> +			goto err_unmap;

Hi Shannon,

clang-16 W=1 reports that
err_unmap will return err
but err is uninitialised here.

> +		}
> +
> +		pdsv->supported_features = add_config->device_features;
> +	}

...

> +err_unmap:
> +	put_device(&pdsv->vdpa_dev.dev);
> +	vdpa_aux->pdsv = NULL;
> +	return err;
>  }

...

