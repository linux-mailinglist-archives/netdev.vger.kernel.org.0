Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 997E724C2FF
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 18:11:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729603AbgHTQLE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 12:11:04 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:18674 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728600AbgHTQLC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 12:11:02 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07KG4GI9028660;
        Thu, 20 Aug 2020 09:10:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=YDa6ei30AXGNTT8KPFLi9LzPyxCmC06GvCXhx4eNMLY=;
 b=ZmwdMvzKsWpt97155ycQ69A8bb/6/k/XVGQfv0SfofmnaZ6B26XCF864OO04EXu+UR/q
 8+qP9yCAQ2BnrEhJN5P/YiJ0U4PGvxw9xTSDxSA72gZ3aBs8mFMf/0yjsFLmx1VyervW
 nP+28U9U0B+Rrn9s9O4MpH84/pYZx5uIlD4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3304nxxyrm-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 20 Aug 2020 09:10:47 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 20 Aug 2020 09:10:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KGIUaEK90ZfTsuvm39qolUcjUukboXJApuhOO9roya+N7xkoWhLRXzgW6HMkaDiFQJJY6BxO/4fhfLSY1gM6L6Wum/fIMu1hEoxknqQJo9c3dgjV9DOwcDArPMuHjyLcJVrkgfHBKvP6soIwPGMVfiwmRTs0PoPn34Si7xwkP1fXlfVdMV1QH38SHFPxRGZ1cF/I7kXJCeJVsRkajRVArQUk1eUMmWqK88uevknF+peIR4pd/KNwjW9pTk6deSeGBAphP23PSvz0F3YC2lawCT/BuKs6K39hBkN1+7Uaut91biCPa5SlTFUZDZh1jgnlWrfoyiB+uKWvVr0JtXRyMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YDa6ei30AXGNTT8KPFLi9LzPyxCmC06GvCXhx4eNMLY=;
 b=bj7mwxf4iR5jWmSMNEFjMxIUK1UpBFWYYGTkJjgpqhp8JaLGo2d1C5GfCqC5i9CD5HThk/vSP78KJ2lMsIl2DRVgAUs5STY60m2tyj2UOuwBLDsl7LyazTRzQZJMc9t1TmW+/wdo2tmXmnyDjrBbufapVQrSpyYOrlipwig7wcIcIKVOIqwropqLHUqNe2YRrF10xaTMuNSWhPGi+QJpBrT1mife+ZzH5+UzITD6yN+vNBkmtX9kCh0XPHOxmatm2u96rJ1ubGP352JtBPuPLNj+6f/KSjUT7oToYiiZdJDZN/yzkq/4B4PS8eZk5X9rD+zj3hcKH1SckK8ZWidNag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YDa6ei30AXGNTT8KPFLi9LzPyxCmC06GvCXhx4eNMLY=;
 b=UjQEHS5XW5tW6DI0XVncHzHnBBZq8UfrfdLu8PO949Imw9YefaGJv4aKAJy8iCI/JYLBOBpknODUyQ0Bhf7+atyYXxQW1fS+GVjYA7l5VeNWlv6qEc206+A6FYeij74m+ktZ9yUbZxBuaeU4J8rt6j4xOh60gjoyKhFbhICF25k=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2454.namprd15.prod.outlook.com (2603:10b6:a02:89::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.20; Thu, 20 Aug
 2020 16:10:43 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80%7]) with mapi id 15.20.3305.026; Thu, 20 Aug 2020
 16:10:43 +0000
Subject: Re: [PATCH bpf-next v2 4/6] bpf: override the meaning of
 ARG_PTR_TO_MAP_VALUE for sockmap and sockhash
To:     Lorenz Bauer <lmb@cloudflare.com>, <jakub@cloudflare.com>,
        <john.fastabend@gmail.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
CC:     <kernel-team@cloudflare.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20200820135729.135783-1-lmb@cloudflare.com>
 <20200820135729.135783-5-lmb@cloudflare.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <34027dbc-d5c6-e886-21f8-f3e73e2fde4a@fb.com>
Date:   Thu, 20 Aug 2020 09:10:39 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
In-Reply-To: <20200820135729.135783-5-lmb@cloudflare.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR02CA0098.namprd02.prod.outlook.com
 (2603:10b6:208:51::39) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by BL0PR02CA0098.namprd02.prod.outlook.com (2603:10b6:208:51::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.25 via Frontend Transport; Thu, 20 Aug 2020 16:10:41 +0000
X-Originating-IP: [2620:10d:c091:480::1:7ec1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3da81cee-2200-4d34-3c63-08d84523971d
X-MS-TrafficTypeDiagnostic: BYAPR15MB2454:
X-Microsoft-Antispam-PRVS: <BYAPR15MB2454E32AABBBEFEEE770AE0ED35A0@BYAPR15MB2454.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /4ONZB19JpHWzhND+1/nPm5+KLOMlxvcfEqef4MLSOz7R25/poIrLpaMaIr8L3zk6KAs/n7SQwTvih1Z+k3MTpFG6o80G5fyIzuaRHTlU+mh2aRUPz3VCOX14+4oIP4kcCu02f3srOlmctngPWpFjcReuvx5PhvnKeVxYFQdIz0cVUBViOp7ZCksU9EYTV/jdPpiUoYdcAT/tILOMsQW1TcxzgNX26xYvzcHyRxFP4ZqVd8EYbQF8BKqoiziZ/BKbTHs2zfORVMTuA9qntYbVd3gAb4hp+VbZOr/K32d+R2DDxVTXZIiTnfzAGOl2jsR6qJEUl7lqSFUTwrO4hCfIyZ5ZnKq07Q247rxxyTj/IeLFAschv2qpRLkRlUjqBd0EeGib41Cxe3GaB+1RUXd2OsQOf/qLzgoJmqmffeEATM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(396003)(346002)(136003)(39860400002)(66556008)(31696002)(86362001)(2906002)(478600001)(53546011)(6486002)(36756003)(5660300002)(110011004)(52116002)(186003)(66946007)(110136005)(4326008)(2616005)(8936002)(8676002)(66476007)(956004)(316002)(83380400001)(16576012)(31686004)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: QfgA3gGAnAP3te4iJez0P1YXaiUeMHbjO1pVIRoMS69PS54SHl1spWhulG5RdPj6CmNFnpcHLks22fTUO3uvQI8d8FNQSLpNh2Q0h65i6v7kARW/p56bzIP0XkTw6gf+uWTLCm/LwqrMwKn2REhThrTgb291+1A2BidH2sNLTAdR7WFRnqoaKeLEM6Le9WruCAwIoSEtcG9oqE7ovS4NCPnTbE+V+CBXq/pIY5ZmTWN4EI0mmy08sFiygNT2ziKeUYHYmIZPGA9YOMssJL6xnjJQf4eaEa6HbhLVeASjPvzV63KmNww1UF3S8sYXXcNrdS7E8QdkqqU1Im3IQRRUyso5CynPC03PYlZL9vRBsqIxANaVn9HxnKFw7Zj9rMYaTrBfnU/hCHfy2bynWBYKDDKzp0SOqzoOGdVxEsB9aiughs3PhzsNKsE+UfNfgQRsZvsTQR5TBka1fiG4fFsmg1VtVrSB181JD2Vg4lmQq0v76cFg3AUoIxm/Q/eirSYal6eJh0gT0F/tnSB58mwPEzBSrAd8NMepY0edMlBCKxrYWV7R3VfVe26qgoD5BuGr8iY1ZSC3s24nOUCICh/CwBbDjsHrQFsUH7+J6FeNe370GKsaiKfVLBxsTOT8Rzi4ZyFaxR96qLnSUpi6+stYgtt75jeS/tcFWT5XCXDjrcoqFV5z3piOm0Noj+SdFwlx
X-MS-Exchange-CrossTenant-Network-Message-Id: 3da81cee-2200-4d34-3c63-08d84523971d
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2020 16:10:43.7011
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QLnpgu30DKizKgy9JPZjaisHmRY7tXUhbJxwxZoOp4YQ2Ge8mp9STOWTObJAw3j5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2454
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-20_03:2020-08-19,2020-08-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 impostorscore=0 spamscore=0 bulkscore=0 mlxlogscore=986 clxscore=1015
 priorityscore=1501 malwarescore=0 lowpriorityscore=0 suspectscore=0
 mlxscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008200131
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/20/20 6:57 AM, Lorenz Bauer wrote:
> The verifier assumes that map values are simple blobs of memory, and
> therefore treats ARG_PTR_TO_MAP_VALUE, etc. as such. However, there are
> map types where this isn't true. For example, sockmap and sockhash store
> sockets. In general this isn't a big problem: we can just
> write helpers that explicitly requests PTR_TO_SOCKET instead of
> ARG_PTR_TO_MAP_VALUE.
> 
> The one exception are the standard map helpers like map_update_elem,
> map_lookup_elem, etc. Here it would be nice we could overload the
> function prototype for different kinds of maps. Unfortunately, this
> isn't entirely straight forward:
> We only know the type of the map once we have resolved meta->map_ptr
> in check_func_arg. This means we can't swap out the prototype
> in check_helper_call until we're half way through the function.
> 
> Instead, modify check_func_arg to treat ARG_PTR_TO_MAP_VALUE* to
> mean "the native type for the map" instead of "pointer to memory"
> for sockmap and sockhash. This means we don't have to modify the
> function prototype at all
> 
> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> ---
>   kernel/bpf/verifier.c | 37 +++++++++++++++++++++++++++++++++++++
>   1 file changed, 37 insertions(+)
> 
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index b6ccfce3bf4c..24feec515d3e 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -3872,6 +3872,35 @@ static int int_ptr_type_to_size(enum bpf_arg_type type)
>   	return -EINVAL;
>   }
>   
> +static int resolve_map_arg_type(struct bpf_verifier_env *env,
> +				 const struct bpf_call_arg_meta *meta,
> +				 enum bpf_arg_type *arg_type)
> +{
> +	if (!meta->map_ptr) {
> +		/* kernel subsystem misconfigured verifier */
> +		verbose(env, "invalid map_ptr to access map->type\n");
> +		return -EACCES;
> +	}
> +
> +	switch (meta->map_ptr->map_type) {
> +	case BPF_MAP_TYPE_SOCKMAP:
> +	case BPF_MAP_TYPE_SOCKHASH:
> +		if (*arg_type == ARG_PTR_TO_MAP_VALUE) {
> +			*arg_type = ARG_PTR_TO_SOCKET;
> +		} else if (*arg_type == ARG_PTR_TO_MAP_VALUE_OR_NULL) {
> +			*arg_type = ARG_PTR_TO_SOCKET_OR_NULL;

Is this *arg_type == ARG_PTR_TO_MAP_VALUE_OR_NULL possible with
current implementation?

If not, we can remove this "else if" and return -EINVAL, right?

> +		} else {
> +			verbose(env, "invalid arg_type for sockmap/sockhash\n");
> +			return -EINVAL;
> +		}
> +		break;
> +
> +	default:
> +		break;
> +	}
> +	return 0;
> +}
> +
>   static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
>   			  struct bpf_call_arg_meta *meta,
>   			  const struct bpf_func_proto *fn)
> @@ -3904,6 +3933,14 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
>   		return -EACCES;
>   	}
>   
> +	if (arg_type == ARG_PTR_TO_MAP_VALUE ||
> +	    arg_type == ARG_PTR_TO_UNINIT_MAP_VALUE ||
> +	    arg_type == ARG_PTR_TO_MAP_VALUE_OR_NULL) {
> +		err = resolve_map_arg_type(env, meta, &arg_type);

I am okay with this to cover all MAP_VALUE types with func
name resolve_map_arg_type as a generic helper.

> +		if (err)
> +			return err;
> +	}
> +
>   	if (arg_type == ARG_PTR_TO_MAP_KEY ||
>   	    arg_type == ARG_PTR_TO_MAP_VALUE ||
>   	    arg_type == ARG_PTR_TO_UNINIT_MAP_VALUE ||
> 
