Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6E8624A796
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 22:13:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726853AbgHSUNt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 16:13:49 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:55628 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726435AbgHSUNr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 16:13:47 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07JKA0gx022260;
        Wed, 19 Aug 2020 13:13:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=LpJzrv9ijRDddLWSu9x9Ux5pj2N3nYBd84+e4MbAJVQ=;
 b=SZpHi4zouzlPfs8v1Yd1TqYxLIIvYW9mjvuaNHDvJYT0TRP/BVi9PYFF52xNeSJDsmwj
 FURQRFs5Lfk0zUfk653mRbJ2BTFI6jbyMjuWlov/oPYMDZgCckkaxC2aYvPjA8AHe6ld
 gN4NbuLaNPM5Ipjd6nx7CX5DPSX4GbRv0CM= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3318g0gsa1-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 19 Aug 2020 13:13:32 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 19 Aug 2020 13:13:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qh7VarsxnsM0jGuKfISfoTAucVdSc/KWrynqqrhcz6RVnkFPMlcrJ7iJrAwl842E4VHrQnpNq9h2FlGvrZxDxP3/gC3ScfUjSu+QMIHiPz9LZ6oOmGU9pHRbJ0OAvlbQNG0T1EJrLC5UxfxPPci+ajFlyV/fe3QEl4gqRuk1vWBaGCkPo8YkGJu/ctJ4k997nknUxN/4f5eurKAnjKsZGCZtNZxRFk9T2tqXIbkoa6NotI+YBU1pmkahpF+3rZT/T4OTlllsUMfp7HVA5xbb6f+zwNT9K9dHxcsi9Mao7ZilVgzoMQxxvTo7s71hjna0QaGAqR6baF7illkUu3Yglw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LpJzrv9ijRDddLWSu9x9Ux5pj2N3nYBd84+e4MbAJVQ=;
 b=REENorzz8vt/S1birQOW1JcdQRiWNFkJv+/lmmS7MSzy8mPunbMIS6VnB263+T9+ozc0NFoZEwVXVzcd4RIOUFfH6e35pB0aYKEko8cz4mC3q3jBCSh6wzQAjqHBaGDKdkehb59isiNZ7Wm1l/R0R5S44MzYFCGBKtVz+ajd0nAvHQ1u01n04C6Ia5G3bQMhKcfeyFE6RLYyfdyLxYVMAcye72Sbat16K6uY7keEEv8pkPhLix9v9323Ma8qRaFN91DLlKDOI8wHQwoXkCPvl0iUrRJ3d/x8CzDwCgikoJGQpzByAqRIxeVIGrpQCp5F3g3F3UPZydDJxJvcO/6Vhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LpJzrv9ijRDddLWSu9x9Ux5pj2N3nYBd84+e4MbAJVQ=;
 b=KkieMGIL01/oVJouLEBrHQr+GAdSZyim8QJBcuQWnPPYgmNPI8VwleGwCkGlO3WvfRsws+xX04IkZqdoW5+w2ZgT6QU5S2m8raiS714hqY6FxiIPhQ2YOc8peflxBqEU0bjXqe3o3CHZtOP4haCRzOlSkWT1P/12/l/O+cjMuUE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2645.namprd15.prod.outlook.com (2603:10b6:a03:156::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.22; Wed, 19 Aug
 2020 20:13:29 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80%7]) with mapi id 15.20.3283.028; Wed, 19 Aug 2020
 20:13:29 +0000
Subject: Re: [PATCH bpf-next 4/6] bpf: override the meaning of
 ARG_PTR_TO_MAP_VALUE for sockmap and sockhash
To:     Lorenz Bauer <lmb@cloudflare.com>, <jakub@cloudflare.com>,
        <john.fastabend@gmail.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
CC:     <kernel-team@cloudflare.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20200819092436.58232-1-lmb@cloudflare.com>
 <20200819092436.58232-5-lmb@cloudflare.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <5d64158b-35ed-d28d-9857-6ee725d287f2@fb.com>
Date:   Wed, 19 Aug 2020 13:13:23 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
In-Reply-To: <20200819092436.58232-5-lmb@cloudflare.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR18CA0002.namprd18.prod.outlook.com
 (2603:10b6:208:23c::7) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c0a8:11e8::10d3] (2620:10d:c091:480::1:d29f) by MN2PR18CA0002.namprd18.prod.outlook.com (2603:10b6:208:23c::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.24 via Frontend Transport; Wed, 19 Aug 2020 20:13:27 +0000
X-Originating-IP: [2620:10d:c091:480::1:d29f]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 975ee0cd-1c71-456a-f122-08d8447c5697
X-MS-TrafficTypeDiagnostic: BYAPR15MB2645:
X-Microsoft-Antispam-PRVS: <BYAPR15MB26456C2B78842345B539B967D35D0@BYAPR15MB2645.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7W5HphpCorKomONJ7oNCFwFbJFmfK55yMnw4/xx+ngI0G7xymrhUTuqAI7JNETJ3hOm8xIzaUudQLoZd25pvpYX3wCiavKJwqZtX9hNrkIbT9Bhkag0s6App1aAkbuypssUa9kdDHp/S9SJnqyMg0mjbf/UVFzUZcwlqQalykWcO9gsep7uoX1vASgProipExVLK2g83BCGnKdoB0wyFBV3xCI54iZ+kzbUBV3GOAuRwD21R6QWrsYfv5xFM66z+j0LubeV0p95mMYin+rsydhjCvh7IPb+dGDaKuwv4tpPrvYDiyxDqXUb2zOCi3n/R1jZiGIACHzx54fPd+ye6qHQe7/gtSEHAdME4a2dqWkVSp28xKBuIxFz8e6IoKab3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(376002)(39860400002)(346002)(366004)(136003)(396003)(36756003)(31686004)(86362001)(16526019)(4326008)(110136005)(6486002)(2906002)(316002)(5660300002)(8936002)(8676002)(31696002)(478600001)(66556008)(2616005)(186003)(66946007)(6666004)(53546011)(66476007)(52116002)(83380400001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: kC/+OSKifVu+BtmUH5wemhax3Q+hHaip9D+Z3QpopaA/Pz5TOmvOkDBzhacmwxj+I8Aja5bOY/GO51MiEPg/MfVq21uf3liIgPq3GxlOtPQqWqsyZJdX7eJnkstSwJnpbxEsevflpNk0iH1h1nIH3IgDL977rUNmYsXefshvJBAWH7H3orPto3NSLCm1w/2s9zesw7Xj/atUDMmj4Cr9DRKp8Sns4Y3kvxDsm4IZsuD/mXhzaQuvU1N+G/JzT4K+aUqPSBlZlDDkusmNNJWT3KXH8nTPcutvDZIsc+QwhpUUBncu5Zo9P8qj7q3KJhV/nauJHcKTXzYor5HqeVBiIjimxm0aTOv7OB7nLrSLNiCws5VNw/W3QittuiTCff3LN48pwwujd2kzWFIcR8RFSJA5DQEN1UBXUj4EzzEeZMCybhh4oOq0qM1nus3TUxDnTMNj9haOR0YZ28ObpOwRTqa3BxaftLxcY2fjeFR9J8P03GHOO0qTdJGoqrWzuOrxuC9trSBaV6E5nQ35wTUlusQ4x1OQ1ene+Cusa5NmvEyrnymoSfe0i9dYIhvETkoGsDzdWvo3WLuqzW1RHI1BipUIze5iNeUWLZSTii4iYyq0lX0KaurjCw9VggJSB6QfdxfJgML/wmStcBwQegm0DGoEeuxQCNwFio13LabE+MkpMHKeijLx8AicgyS2v448
X-MS-Exchange-CrossTenant-Network-Message-Id: 975ee0cd-1c71-456a-f122-08d8447c5697
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2020 20:13:29.5065
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IBT3wjijnVvM95ziKdyCvSVV+u2AUozknx5fnvHdMc9FmNbdNiFR/JM/ZDtE1/Qk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2645
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-19_13:2020-08-19,2020-08-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 spamscore=0
 lowpriorityscore=0 clxscore=1015 bulkscore=0 priorityscore=1501
 mlxlogscore=999 suspectscore=0 mlxscore=0 adultscore=0 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008190164
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/19/20 2:24 AM, Lorenz Bauer wrote:
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
>   kernel/bpf/verifier.c | 40 ++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 40 insertions(+)
> 
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index b6ccfce3bf4c..47f9b94bb9d4 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -3872,6 +3872,38 @@ static int int_ptr_type_to_size(enum bpf_arg_type type)
>   	return -EINVAL;
>   }
>   
> +static int override_map_arg_type(struct bpf_verifier_env *env,
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
> +		switch (*arg_type) {
> +		case ARG_PTR_TO_MAP_VALUE:
> +			*arg_type = ARG_PTR_TO_SOCKET;
> +			break;
> +		case ARG_PTR_TO_MAP_VALUE_OR_NULL:
> +			*arg_type = ARG_PTR_TO_SOCKET_OR_NULL;
> +			break;
> +		default:
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
> @@ -3904,6 +3936,14 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
>   		return -EACCES;
>   	}
>   
> +	if (arg_type == ARG_PTR_TO_MAP_VALUE ||
> +	    arg_type == ARG_PTR_TO_UNINIT_MAP_VALUE ||
> +	    arg_type == ARG_PTR_TO_MAP_VALUE_OR_NULL) {

We probably do not need ARG_PTR_TO_UNINIT_MAP_VALUE here.

Do we need ARG_PTR_TO_MAP_VALUE_OR_NULL? bpf_map_update_elem arg type
is ARG_PTR_TO_MAP_VALUE.

> +		err = override_map_arg_type(env, meta, &arg_type);
> +		if (err)
> +			return err;
> +	}
> +
>   	if (arg_type == ARG_PTR_TO_MAP_KEY ||
>   	    arg_type == ARG_PTR_TO_MAP_VALUE ||
>   	    arg_type == ARG_PTR_TO_UNINIT_MAP_VALUE ||
> 
