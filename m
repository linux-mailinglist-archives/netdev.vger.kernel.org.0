Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF44E40884A
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 11:34:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238683AbhIMJfO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 05:35:14 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:47948 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238444AbhIMJfL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Sep 2021 05:35:11 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18D6hfN1009075;
        Mon, 13 Sep 2021 09:33:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=XZPsmBMwyvlwSW/l7pGMrT3gRtS3YsMG2E1ZSDfSvRw=;
 b=wPP2l2XgB4FvdcuqtvlzVcmdQUZY9kf34W1kXNFPZ+/yQyg1ajZDEqypjfQr+UIdkJSc
 Le9yO1aUsYsWRaFzdO3msEzOBjyOWcgrVBZUKytS1qS745WvV6P8x1egLuzwF6IwiNbQ
 tabxHCsO9CfQFVi9xZslKYmVc1tYUlqQeo+BklX66WLjbiMm88r3zmi4jPsviYZQdnqD
 oJrCDZGAOsRm3PQjeM3BG63YYGesDQoo7Q6d8rXwpRe+0PSBOUCCJAqn//zA6D28GGZz
 EHv2CJqwB5hO7ShBk6SAMuqqXdgStNb6WyaM/J4IMOfUhc4G7tsYXkAFx3Q/obl5xPVD Ug== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2020-01-29;
 bh=XZPsmBMwyvlwSW/l7pGMrT3gRtS3YsMG2E1ZSDfSvRw=;
 b=G52FJCkzZUZoB/AUdPQncFiMXzx7QKtaacCOtMQ7r3wLwKhG0kUKnKLBT7esXrSnhk3r
 hHYsqHNNjn7Rq/1lSZ5NE18jasqyH0oMrtpGeQKPvwhVGmRP2Z/nkF5oP+KSSs5R/PXs
 quSUbQyF/SRvbdBw6WM87qw7A6AxdBuQogp5T2hxCmDSuIITeLhYVddZahluWkLinYFe
 bmGEAvBmgaNKItiQq6uNt+QSD+OhjRwJ56UhV2v+uJ2Hgm7AuL0mI2Le8CfwFlHfmJS0
 na6FpLC/EaEaTq2mkMPYfigoYwlPPRhTOn0B1dN4FZVy5gbmu+bVSX1MdSb8DtwysxLc 0Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b1k9rsv0c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Sep 2021 09:33:49 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18D9GTcU042251;
        Mon, 13 Sep 2021 09:33:48 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
        by aserp3030.oracle.com with ESMTP id 3b0jgb94d6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Sep 2021 09:33:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N0n3HGXuHw8I9RzFgnM5ds59VEBnWDe3ZZtwANPiOtW9c/PkaOCGRQ8ubZtpxx6369EfLlh3zkD2MvL8Tp4YNR7tnQLFpP3faC4peTfR8ATMn/uX1m9sSXWK1DgR6m8po1E+cJy1oyF0zkeCmeAQyT9nLqsZ6vT5ZbtIQA1oFqhE2GQir+0F7df4mZ498dzA59SXvhjiO8Iv2y0jxhCjrDc9LD4mgvqDfRBXyCiFw/JhyWdrZiniDOcbY/K3fJn40kaq0V8N5RmVc3+1JDK7fFbj78kYugoAyDem+7GRyAhNaYsAUnGIHqANTuHFkvE+F+AHbIzKXA1gKh44uk5txg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=XZPsmBMwyvlwSW/l7pGMrT3gRtS3YsMG2E1ZSDfSvRw=;
 b=f8nsTxaj3IFmeozI52Q3x/+VztWQ6oghH7+SDfLWLjzrCJ+ErpuNVg+5kKhXiGSs9+VBXNHkZwH3NddGZ/2dFta8NxinayiDwb85U/9n6vaHWjR3BfsB+3/2q0x6aLgz9d+nTKonH9R9uxzejAbwakh0oUgwEwX14eEm9b4rlrUOF81arhfMWY9tziHDPc9CDUZabuVWL95wY2l1QXBfLtjoym5X0yFOP6r6dYnB0PLF/lYIVgMk3Us0Sd8fS1gpFcg9SSDq1N6Zemg8Tsv8vvRT71ARZD5HsgfVs2qvDzjLRB7yPNxDD1T5K9MtP39fqia6IRQVEN1oxvibTWAIGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XZPsmBMwyvlwSW/l7pGMrT3gRtS3YsMG2E1ZSDfSvRw=;
 b=qLZtJvNTNyOGKS4QDGXVFPubLsRCJwY/R6Xh1w1rwXc7zFHpdCWsBxnZBNUK9R+S1XK0HLq5BHpnseQu4jwbvrJnZzSdSdpHw51snnNcgoPUfxxDfRhjstVA6EfQYId6ceLIhxyDTwS83Vg1HXzmR8AIGcDVjKIIBTXPX2/ieAU=
Authentication-Results: silabs.com; dkim=none (message not signed)
 header.d=none;silabs.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1821.namprd10.prod.outlook.com
 (2603:10b6:300:107::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.16; Mon, 13 Sep
 2021 09:33:46 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268%7]) with mapi id 15.20.4500.019; Mon, 13 Sep 2021
 09:33:46 +0000
Date:   Mon, 13 Sep 2021 12:33:28 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Jerome Pouiller <Jerome.Pouiller@silabs.com>
Cc:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH v2 03/33] staging: wfx: ignore PS when STA/AP share same
 channel
Message-ID: <20210913093328.GG7203@kadam>
References: <20210913083045.1881321-1-Jerome.Pouiller@silabs.com>
 <20210913083045.1881321-4-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210913083045.1881321-4-Jerome.Pouiller@silabs.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNAP275CA0023.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4d::16)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kadam (62.8.83.99) by JNAP275CA0023.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4d::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Mon, 13 Sep 2021 09:33:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: febbcee1-aa07-4dac-798c-08d976999590
X-MS-TrafficTypeDiagnostic: MWHPR10MB1821:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB18210385EF10127E690A4FDF8ED99@MWHPR10MB1821.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kPuSXIcJFzveG7iibj3STScm1B/8JtLM8cQ0bzDgyeFOWHuND7mxeEs3iKH4/vC4fNTboJhRyvgaeE4Bk5eKDMz6a3UvUMe5CRlZDfsKHpOYQtQvvNuUXJB5VQ7swCNHyQ1FxmJp/fCdcNWbgRpdI3hn1uBHsnMEorAVdegnCXzVfducr7pTnQ3c1a88olm+nu2qYjGbIpzIXVVKul88Vxn2HtZ8A2qeN8uCSG9N+rgVNnUvuQYoe10zJjuUUlCsXT+sPeNY0sguUInaAusKi9wQ3R3H0vA6W0eusj+xPzol/C24yMjycL4WbcfIs6VWF/zIsMCrdTv0Mp3+LvoonD7P8jpzT+yR61vFJkp39+y65gh/ZOsXfiG3htlWvXyCI8jT7XODoHfxUPdt3jk2Tb0E5BaxoTRaqoZSg5tkdzVSgUPdZRVTgoHFVeH0F8R871XXDvtm0JVJeLTYZI66gJoVTsQ8HLDcVZkc5r+XKxAl2XROWKYIQJwr5fGfWGHaUqz+Vr+viHRWKXLoLIHSU/Pp1DLx2mx+bE2yZVZtPIn7SCsH8C9c7b1wlWjI+CnuT/QwznW8SYRibQGNIRfnIPmBtrt3sKhVplyAruJWWNRagcRdlvoshqGRF/cNf8F31UiunSEZGf2bKW2Flg7mExs+Jg0PKBr3rUJMX8Me1p9FyKq/N13/OuH1yDXjqbpMckRnqED6ynFnES7J73uxkQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(376002)(39860400002)(366004)(396003)(4326008)(2906002)(6666004)(26005)(9686003)(38350700002)(8676002)(38100700002)(44832011)(33716001)(54906003)(6496006)(5660300002)(52116002)(478600001)(55016002)(956004)(66946007)(9576002)(1076003)(66556008)(66476007)(186003)(316002)(8936002)(6916009)(33656002)(86362001)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PaNi9Xq3fUSn2QIyjGH5SCYQxheJFhvYupYe5rjNL0V2v4RoMPZlLUp79ABh?=
 =?us-ascii?Q?IlJG/YZ1d7S0s6csQ2EwpUr2PABm6f015lLUbDOz9IsZ6AEvSeo4veCnYMCD?=
 =?us-ascii?Q?f1BpoDRpGZzbJ+Uxh70J+TfDep/NJO5n6RqMBy3tH+ecDN4EKdnX4DktzrvD?=
 =?us-ascii?Q?e8jbtAJ3ZIB6pJwyd0C5BUcMFLPLVI78H3HTxj6Dmw573wRBTUHw0LdFklQ1?=
 =?us-ascii?Q?kJ8tA2q4/3mWBNx9r5GpjPnR4rc412GdWe6tzcuIn8oc5oXz2ONfcNHbfW7c?=
 =?us-ascii?Q?ACsdBgJr98RkvM6ZVm33RwGZQhRE/SjWL1SNYvaHAE/yRzo/EvumJO6u+bXq?=
 =?us-ascii?Q?y55xLNaBsD34yf6LQe5h2LksoexGoo49e3+BRJQTVczh3kI0kxLwKCqrKVls?=
 =?us-ascii?Q?+lfKP1/qW1J6SDSCZWi8ZDA3lpXgVU3HfuJzILd0rlU5AQeG8c2Z0iGw5fuY?=
 =?us-ascii?Q?TSCLS2z+lhgSkobLSa+i7yA1M+kLwJHakkKSiefY/lfz0oZlzqWuHrW3ZNLY?=
 =?us-ascii?Q?gnHcwEfytiJcHGOYLgjNA4i8YdAOezcARFhsZFssVEqQcXi75ql4jHO46lnd?=
 =?us-ascii?Q?kgI0bMT6EL4U/NakNbu6lnTTFNRMYG++3fay9phOZ+CfijKpOWSsYUPPD9hO?=
 =?us-ascii?Q?Ak0XmeByAm5M11y5YjUaVkb7DxX1og1xHIdVqxca5d97Xwid8NXxw99vrX2p?=
 =?us-ascii?Q?pxy95t2P858GxXLS7I9Q/t0FFG1pPnAeeb9sQkop3qCzeZ471u7PXuGgDG6d?=
 =?us-ascii?Q?cjm+ILAnG/9ydr8aQ7sbIo/uUT1ATGpKdDl+vl7Zd9viIcmolV7uSE+bKgN2?=
 =?us-ascii?Q?bbfSK5PbtNRDfOsgHVnNMI7bCH2dsCyepi6CU98jI0VMQMExxgOoWVULe/vM?=
 =?us-ascii?Q?X7gzx1M2iqJBPTIFgPixhIsothP9lr8GucnzeZneKWGpwAPWrx7v5G3cKS05?=
 =?us-ascii?Q?ex7HHDI0u7fa/XY9OGY8rVJLkmE0F4clTgl4rwpzQeFSTbxKn/vHq6W9HFSZ?=
 =?us-ascii?Q?smrSakDoEQJmf5PTDKgBL8i4Z43uQFxCqZhmGs6YXATbMNN8wma/aU45/nsR?=
 =?us-ascii?Q?Hmo4ktr6b1X/v9SEiuJjqW8M6w60Dx8w8Xxr5/tMyXRFunG6XGmDGJtO54Nh?=
 =?us-ascii?Q?q6pB1kz77xXKM8hRTqfgZzH16MsgIb1SNURI/fUSP4nkIyCMB7KtEbBECynT?=
 =?us-ascii?Q?Bt8qkKd9FE1/e5DGvf5cLlEDvk+fCpA9wVgHzSA31FkZUXWjqHSpCuh0gVIO?=
 =?us-ascii?Q?Wx1Ux+GyiN0w2mf1L7Kkj0nR5+1NSiSWWDVXh2fALxuF4lhLQ0E258ehHLDA?=
 =?us-ascii?Q?EjS9y/3G63sgshcndfWpJwD2?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: febbcee1-aa07-4dac-798c-08d976999590
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2021 09:33:46.3711
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m3bQpFQ4Y384yK4Hi0DbWfpO9z1ULTTFKQ22MC87L1c9hKZ3LXo0QP0pVZsevL/j+NfarxtmdZY7EfOI1qCkwF9teRci8IthGjJIHt04zGw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1821
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10105 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 spamscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109130062
X-Proofpoint-ORIG-GUID: qF_nCmx7jfBezNcWKKpUdJhbVDhe4wE8
X-Proofpoint-GUID: qF_nCmx7jfBezNcWKKpUdJhbVDhe4wE8
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 13, 2021 at 10:30:15AM +0200, Jerome Pouiller wrote:
> diff --git a/drivers/staging/wfx/sta.c b/drivers/staging/wfx/sta.c
> index 5de9ccf02285..aff0559653bf 100644
> --- a/drivers/staging/wfx/sta.c
> +++ b/drivers/staging/wfx/sta.c
> @@ -154,18 +154,26 @@ static int wfx_get_ps_timeout(struct wfx_vif *wvif, bool *enable_ps)
>  		chan0 = wdev_to_wvif(wvif->wdev, 0)->vif->bss_conf.chandef.chan;
>  	if (wdev_to_wvif(wvif->wdev, 1))
>  		chan1 = wdev_to_wvif(wvif->wdev, 1)->vif->bss_conf.chandef.chan;
> -	if (chan0 && chan1 && chan0->hw_value != chan1->hw_value &&
> -	    wvif->vif->type != NL80211_IFTYPE_AP) {
> -		// It is necessary to enable powersave if channels
> -		// are different.
> -		if (enable_ps)
> -			*enable_ps = true;
> -		if (wvif->wdev->force_ps_timeout > -1)
> -			return wvif->wdev->force_ps_timeout;
> -		else if (wfx_api_older_than(wvif->wdev, 3, 2))
> -			return 0;
> -		else
> -			return 30;
> +	if (chan0 && chan1 && wvif->vif->type != NL80211_IFTYPE_AP) {
> +		if (chan0->hw_value == chan1->hw_value) {
> +			// It is useless to enable PS if channels are the same.
> +			if (enable_ps)
> +				*enable_ps = false;
> +			if (wvif->vif->bss_conf.assoc && wvif->vif->bss_conf.ps)
> +				dev_info(wvif->wdev->dev, "ignoring requested PS mode");
> +			return -1;

I can't be happy about this -1 return or how it's handled in the caller.
There is already a -1 return so it's not really a new bug, though...

regards,
dan carpenter


