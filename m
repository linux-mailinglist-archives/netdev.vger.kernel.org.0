Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 558FB47D1A4
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 13:27:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244848AbhLVM1u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 07:27:50 -0500
Received: from mga11.intel.com ([192.55.52.93]:39409 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237774AbhLVM1t (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Dec 2021 07:27:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640176069; x=1671712069;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=boDlxveUnz3U8jdEjih+uLd6LpOT80FsZAH3xVVvJUE=;
  b=DlbsxKRfFp3w0Is2sOcx/9L6LqJpzWF0EA33EuemDN5m501pHsWrDY5A
   ZO/jjlaL9i1DuguRQ8N//fjVAfMng/KTw0wAbFIu90scv2mzZqtuLbAQ/
   67xsg7Vay09nl/fLF7gLLfK3B/4LePuAePNGXQPqlfHXTaatlq/CJPiOj
   k9Vagmq+3ciJhhEB/XJpIMSqY+lA6TBQz956Vj8YMa7lwQReFKLXKheFh
   J68XnzIGwm1AnmFMnsfHhi4rGfcsxSblVnS43eUcMJq0srrudgKY9Ontv
   W0rXHjb5Yvlmru8YSjBgfTmk0xIn07+5MkUcOSp6vR+uVrcAy8KDynZLA
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10205"; a="238143610"
X-IronPort-AV: E=Sophos;i="5.88,226,1635231600"; 
   d="scan'208";a="238143610"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2021 04:27:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,226,1635231600"; 
   d="scan'208";a="613809420"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by fmsmga002.fm.intel.com with ESMTP; 22 Dec 2021 04:27:49 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 22 Dec 2021 04:27:49 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Wed, 22 Dec 2021 04:27:49 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.44) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Wed, 22 Dec 2021 04:27:48 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lgSpEXEnDMZhZO0469glL+OEtsw0icwZoUzVLIaDZT9bZJvZ221qbpXnoAxLM8JI+lHBmJcyhYjf4LUo886mJ23s52l8lqVRQ6C1gBF7+yl8NpRHy/K6MutO44+Tf2gQWdDx5qMX/E2Ennwap3WrrGFvH22QdoRDSh++EjBKfia9uXQvt67lYOQe6kZ9vAvgWtzEo3O2TbM5c16Q7LSwbm6Xu2gMMM8iSX6Wpx6aqW0mfFfIyJ+7Izmp+nE9yT/4BC86X3lsPT9yumSzuNP4ogscf6mrtCDCudTNV0+KFGyrvUWo76IlRp4YjSTXV9pRJciiXb8zriNNwPIX7WzSOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GjWnSd1ZGE5LzEpOBVj58GNXhqD1Gu8HfGt+JK5gHNg=;
 b=lQwZ7D5tO0mZqxmOskrTjJgfpi5b2kagMR0/UvGqBe3N8JbeX/LH8GtE1zdrTf/x3NuKRud9kjmhE6QzjvBDYh08jV//ZeHTIG4gD4qQWsJm6dnRKi5NExXBxZNYaGd4x1j/hCGlP5PHgCR7iHh7xsCRqkD6LIDu25EmfNcdC5nHA6FeWncdQIKSZneUIKPljuyDcDokWt8mvjrHMmiKWsDEPbMVB5iHYgQyQ/QGBFB6Mk+7gjHlEn84oUQIXT6GHo1qe5zOXlObaFbY7h+bkS1/Uhstr7sqN0DD8xZY7QwtxUNA1Er3xkR1JnOgVGcUHIA/hadSCFJtUhVZGBDWBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BN6PR11MB4049.namprd11.prod.outlook.com (2603:10b6:405:7f::12)
 by BN6PR11MB3987.namprd11.prod.outlook.com (2603:10b6:405:78::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.17; Wed, 22 Dec
 2021 12:27:47 +0000
Received: from BN6PR11MB4049.namprd11.prod.outlook.com
 ([fe80::cce3:53d5:6124:be26]) by BN6PR11MB4049.namprd11.prod.outlook.com
 ([fe80::cce3:53d5:6124:be26%4]) with mapi id 15.20.4801.023; Wed, 22 Dec 2021
 12:27:47 +0000
Message-ID: <bd0d2737-8fc0-050a-435e-8e4837c87ea5@intel.com>
Date:   Wed, 22 Dec 2021 13:27:38 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.3.0
Subject: Re: [PATCH 1/4] RDMA/irdma: Use auxiliary_device driver data helpers
Content-Language: en-US
To:     "David E. Box" <david.e.box@linux.intel.com>,
        <gregkh@linuxfoundation.org>, <mustafa.ismail@intel.com>,
        <shiraz.saleem@intel.com>, <dledford@redhat.com>, <jgg@ziepe.ca>,
        <leon@kernel.org>, <saeedm@nvidia.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <vkoul@kernel.org>,
        <yung-chuan.liao@linux.intel.com>,
        <pierre-louis.bossart@linux.intel.com>, <mst@redhat.com>,
        <jasowang@redhat.com>
CC:     <andriy.shevchenko@linux.intel.com>, <hdegoede@redhat.com>,
        <virtualization@lists.linux-foundation.org>,
        <alsa-devel@alsa-project.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>
References: <20211221235852.323752-1-david.e.box@linux.intel.com>
 <20211221235852.323752-2-david.e.box@linux.intel.com>
From:   Cezary Rojewski <cezary.rojewski@intel.com>
In-Reply-To: <20211221235852.323752-2-david.e.box@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LNXP265CA0072.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5d::36) To BN6PR11MB4049.namprd11.prod.outlook.com
 (2603:10b6:405:7f::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cc7c2d2d-8383-4ffa-cce6-08d9c54675d8
X-MS-TrafficTypeDiagnostic: BN6PR11MB3987:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-Microsoft-Antispam-PRVS: <BN6PR11MB3987F3B8D53C2A2AF7A8E0B7E37D9@BN6PR11MB3987.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OPcnomukZv2g5hXYdie7bp7IkXKaWU9TycEAf1Tv2JHHvKeD7WNJmRFZpJhcAONP6i/QVG78PppeB8yFUmrroB9XudgU6C6d6XSL94AQVPolIvHTcxeaCtG8NU7sqCRRfeL/volB7hqDkkTZ2xboJRinbCKRSngvSq7DpwelNZ34dWzOKtPF37Ng5OGDyM5g7pz+xWU15TNeBFnYfuWcEGJZpbrJaTTfcEYTV2MhEicA5ZAEkC35Umocs6bSSCUWrBRLkDNabiqVyRNT9VpzL7MPtXqCos9DeGnILq6mzz4zhxIFKLknfXzS9S1I6Uj5M2b5LGZeVlI1c7BQJNKr3Ccv9pbG9QvCpt+F2GOxxF8prZ2cYNLWvQOpXLDuMotGcNfZpVSw+9jbPHcgJyzieuge4zawdmszVUgp5mEtAvmnGdva7g9L2mvYBKXa0O2TgcEuccdNsvT38Ii4GSRRLhN08YeMov0emm6wDbHw2/JbFhfs/wQloxM/n2VmcS+f7P1YigNp9Zv7OyXxm9xt4jwwijBhj8+vTUXA3sWAj3w1Awrfvt9eNXbIxyusp3o/TCnL52SWY0P4gxUxUTv4K4U4tJfjoq1VOwXE0UR0d3or5fo6zhu8VLn6FRUQTRx/VrTnjRM90ITfDcnQLw/KpeATvM662rsadcw+AAl/M8feMel/CrWqsmEUQhVESUPysW7pvP3eq/Vm02MG/m/E9J9I/7git6XNAe8IVE6FMmNP8fZvNnAa/dxkr30HEyGL
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB4049.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2906002)(26005)(186003)(82960400001)(86362001)(66946007)(31686004)(6512007)(2616005)(6506007)(53546011)(8676002)(5660300002)(44832011)(4001150100001)(6486002)(316002)(36756003)(83380400001)(8936002)(31696002)(921005)(66556008)(4326008)(7416002)(508600001)(38100700002)(66476007)(6666004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TGd4Ulh3SzZHZmVLSzZ0T3NhOHVMbFBsOWx5NXljMHRWZWZMT2FOVHNOSnhX?=
 =?utf-8?B?QXozNmx4aGk2OCtkSDVGa0ZFRmIrVVhlazZjZDFzN3E3S1pMa2lhalM3MTd5?=
 =?utf-8?B?bmllMFkycmVFTWJ2MXY5SXMwTC91YVgveUZnRzdiYjZzNHM3RStJSzJodlBO?=
 =?utf-8?B?L1VoS0hzdHo3U09MMXROTFZGVFFaekFqWXhieEhkVG4rbmpXMlc2ZUU2dkEw?=
 =?utf-8?B?NzlYR3N5N3pNK2JZc3Nvd3NvdHFlRmtyYXI2TU91dWFJdk5yYjB6REE4TjVt?=
 =?utf-8?B?QVBkc0FVVVJYQ3B0OGNPaFo3VzQyK3JFK3RyVXZDY01NakxmTkRyeGpVL2VU?=
 =?utf-8?B?ZFc2WGJZS0g2Z1paa0JNQXFnQXJzMVVWN0Q1bEhGclpyeVdMblRhVDNZK1JX?=
 =?utf-8?B?ak5ndWFzOU5ueGF6S1JrSXpiSXBLTFJWcWdEV1ZRWFpYWm0zNzFuSXFxazQv?=
 =?utf-8?B?Uy84YUxxdzJMeUc5SUlSU1h4UFBwMmlCbjAxTklqYUJZUVJjbSt4aXZpblJE?=
 =?utf-8?B?VlZkVWJ2dVVmMkI3QUNTUUR3Z01CZmNlelVUNjRoM09hYnRkaTFDVzg2bTFu?=
 =?utf-8?B?aVNxWkFMYUg3aVZBNzkyaUVUcVBGZVZuT2l4L3JXUGI4SjlpQnFKTzRtOXRa?=
 =?utf-8?B?MGt6aDJxNFAyLzQwTk9sVFFvZm42UHJQa3FkcHRRSktQblQyaHUwWjdGdnps?=
 =?utf-8?B?aEpFRUMxT2UvOUFmQjR4RnFNQUIwTVNsejlNVjhBdjcvb3BUcjJ0QkhWb2NT?=
 =?utf-8?B?OFZPR1hndlA4dW5hY0JCOVIxR21GS1Jydm5nSkJsaHdUSFlxRmlyUHJmNmxu?=
 =?utf-8?B?eG9RcXg4anhyOEdQWnc0b1BwdjBvdlYyTGdma3pmcGRQVDUwR1EyUi81QkZ5?=
 =?utf-8?B?RU1qZnhuYXA0cUM0blYrdjlUQm5xSWxhbm0yWmwweExKbWQxeWhzT2xWKy9V?=
 =?utf-8?B?NjNPVTdKVGJ1dGNZME1GU2FueDZEdjVpb2NNWHUzeEVmcEQrdW1LNWI5cWdh?=
 =?utf-8?B?L3lLQVBtamRUelVBVFpwRVVBU3BYSUllUFNTNW1oNk0va1NwUGdzbCtFY3NX?=
 =?utf-8?B?ZjhaOFBrei93Z2tQZmpaTi9LVEU0eEZWOGxuR3BZSG92MXpZY05qRWhKdlpN?=
 =?utf-8?B?aGNkK05VS3daSXpNcjM5WFllaW9KR2Q5MmptTHBZc0I2R2dZUDJ2STJ0VW5Z?=
 =?utf-8?B?emJzeVpwWWhKekJIc3BUT0JTYTdzUC83YVpXRG8vNjMxMk9RdjZES0xqdktI?=
 =?utf-8?B?Y0VOazQxck9oaHJwUVFLSEcyWWZlV2JtVXc3K0tjaGgxMEJRU0xOaEEyaS9I?=
 =?utf-8?B?bjRiN3pLOU52ckw1eFY1S0VMdHZxMjZsazg3eXZ3VDRwUlo2V3VrU0Mra1ZT?=
 =?utf-8?B?SkcwUDhxRVdhYjQyR3ltZUpmdERmbmovaHR0NUw3VG8rWmJHVVFWcXk4Q2tX?=
 =?utf-8?B?N3lmcXRlb1FKUUc1OEJjS0tFR0lBeTdrQWJCeS9rd1RZdkJNUnBFTko4UnJs?=
 =?utf-8?B?ZUc2OWtkSHFaNkdudk9mU1Z3R05hOGg3a2JLTnNJMStLSlYyNVBWcG5PcXBo?=
 =?utf-8?B?ZWhoZG4wNzdZbjJJRWgzNE1QQWhrQ3BLYytkcEZWQkZ2eFVMQlhMNTNEL2Zw?=
 =?utf-8?B?a2pZWEtLNmI3dkdrVWNrT2RWVUJvQ1FmU2Q5WTVRNnFVQy9YeGx1Tjcrd0RV?=
 =?utf-8?B?QWkrTkZVOFBldk9zVzk1b1pSeGJnbjVaMDY2Q3RCVG1JZWxaWDFXNTAvdk1T?=
 =?utf-8?B?dVlGYktDditVNUtzRisvMDBJUm5lYy9hZmxDOHVaVndSb1J2T1orWFVOVFZF?=
 =?utf-8?B?UXN0ems2VXZsQzQ4RDg2T09vcG5uaElUTXdCSGNISTU0bUQ3MlMxY1BlcFpI?=
 =?utf-8?B?Y1E2SDBvazNZU2JEZ21ZbDdMTkhQTGVKSjRDZTIvUDZPaVRUKzhGcU8vWHd0?=
 =?utf-8?B?YWF4cC9TZG5TVS9rL1ZLL1BaS3J4c2hPQXU4ZGU0NFh1OStyZVI3eHJTMzg0?=
 =?utf-8?B?VnF0NmhnMFp6TURMdEtHMW5DQmlNNXZUd1FZeFpQVmo2VFczZkVEdmRXWk85?=
 =?utf-8?B?dCt6S0NUV1dLTlNZaDFaTFRnUXFUd3JFVlhackJKOEhDOGFEUmxTK0g3bzJ3?=
 =?utf-8?B?WGVKM2dNbndSTCt6ZXJVK1FjUkgyWW1CQ1BsajRxYlBxKzloRm1hemxqVWZW?=
 =?utf-8?B?ZGdBTUplUUFsS1F4VUtFM0cyajFFazUzZHdGS0tjbGlmaUNBNEFTVW9jelpY?=
 =?utf-8?B?ejFDVm1DWEk5WWdIN3o3VWNwOFd3PT0=?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cc7c2d2d-8383-4ffa-cce6-08d9c54675d8
X-MS-Exchange-CrossTenant-AuthSource: BN6PR11MB4049.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Dec 2021 12:27:46.8509
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lNvGxAaWBqvec//CfQ8gSCJ6Ev3V0cQTKjZr+48hbtqd8UkAdWiROQf0znLwGKLtcCGrTBWapceWeT7JhhN9YsICvCdJ7R6hqcwpVjUPSx4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB3987
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-12-22 12:58 AM, David E. Box wrote:
> Use auxiliary_get_drvdata and auxiliary_set_drvdata helpers.
> 
> Signed-off-by: David E. Box <david.e.box@linux.intel.com>
> ---
>   drivers/infiniband/hw/irdma/main.c | 4 ++--
>   drivers/infiniband/hw/mlx5/main.c  | 8 ++++----
>   2 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/irdma/main.c b/drivers/infiniband/hw/irdma/main.c
> index 51a41359e0b4..9ccf4d683f8a 100644
> --- a/drivers/infiniband/hw/irdma/main.c
> +++ b/drivers/infiniband/hw/irdma/main.c

While two occurrences of aux_dev->dev have been addressed here for 
irdma/main.c, there is one more that probably could get updated too:

static void irdma_iidc_event_handler(struct ice_pf *pf, struct 
iidrc_event *event)
{
	struct irdma_device *iwdev = dev_get_drvdata(&pf->adev->dev);
(...)
}

Note: the declaration of struct ice_pf reads:

struct ice_pf {
(...)
	struct auxiliary_device *adev;
(...)
};

leads into suggestion:
	struct  irdma_device *iwdev = auxiliary_get_drvdata(pf->adev);


Of course, even if I'm right about this, such change could be applied 
with a separate patch and does not block the current review.

Regards,
Czarek
