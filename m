Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4605212E6C
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 23:01:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726323AbgGBVBj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 17:01:39 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:33210 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726028AbgGBVBj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 17:01:39 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 062Khpi7005541;
        Thu, 2 Jul 2020 14:01:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=rdlE3BxLox0eriDfYZZdeUQbYpQe8//VnbKGOsLz/iE=;
 b=IbIoxZE0EqHb5wUqXUzmKTLSzMfWm65NdhKWf7vHctEnmzGaeN5sexg05a530sp/hAyM
 dFy25xGNKYYnAAndkPNxNzxOBoTbu0y2u1TKauJfQnq6nAR3dR69xQtkAGDnkwhV++Ez
 782oUbmYRt07O5+cl5pRI4oqsV8nHgLa4es= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 321ncg8knf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 02 Jul 2020 14:01:24 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 2 Jul 2020 14:01:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lBs2vMNE3MEeDlHGRWZzDoqVJGSaTncnGQt4k1lUniYqFMNHiVqP2AJ+NLjzUcccFEZpbCNLZ3HSsyTFrxdfHSF0vsWikyFKsRJSYAQLmxkPjCn0vJZhmmgQ608ArWD8ih94oQXT+PHtHSOeRlDKle2pSMhQAJFW38CnmHHcz03VXw1AWYOv2SPJupu/qnetVeZGdf3BkHeDfQQ7HqfyEY0KDE+OV0XXWMe3riI2SjTZ21pZMmQkO7Jk4AeGCXFqWZ1vC6/7j7G8UQ9Tfw7UJdjmR/UFM/BQj4jYwMFFW9js8ZeQ65vYFYyAUGOkDbWUt2bbsC/b18oJP7U+7hmZdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rdlE3BxLox0eriDfYZZdeUQbYpQe8//VnbKGOsLz/iE=;
 b=bmZp/5xgYI0gvppyUwxK3qD9qcUt3i2tmqVnBoAtTlFsHXfqtqEdYHjPdjpZzmYw707uGcNRHL5wXYbRGzcGC7DfT4PGkN3SXAsfWQrjx6OJxtSEYfuiprvmTIeEil3ftWefR2RO1iYu9c1mhGzIEl89KBqcyoYr4+NSLtfTW/sgsHtHxrKrXv2NlwZcbtN0SSZdmSaT4N6Ur9kp8JuhMtTgR3yci2Xw9mVVzl/OczuzxZ/ZIPdibZB/ESJxExD3QUqFHGnEpQ0cXp+li9LR46DcZD331VF4WuI9ebFJQktzn1NhMEkhIpe3dHjXsfSv3Nt+Y+TqQalFHYjAUj8loQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rdlE3BxLox0eriDfYZZdeUQbYpQe8//VnbKGOsLz/iE=;
 b=B8pgZKvJSblDBA9ASge7s2Ei525ZVa6ZOneHWlNzXC8a2eN3hT213GkxmP+keO64b91cmdcSC78RMCIUAiqfVhqujUk5RUFnjCsjxPq2c8ql9wWxxDQkWRKFFch16HZjOjX1yJLr9aMCuBaxruxvR3MyRhQD3M7fLNawDvAu8pI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB3510.namprd15.prod.outlook.com (2603:10b6:a03:112::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.23; Thu, 2 Jul
 2020 21:01:22 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301%7]) with mapi id 15.20.3131.036; Thu, 2 Jul 2020
 21:01:22 +0000
Subject: Re: [bpf-next PATCH] bpf: fix bpftool without skeleton code enabled
To:     John Fastabend <john.fastabend@gmail.com>, <andriin@fb.com>,
        <ast@kernel.org>, <daniel@iogearbox.net>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
References: <159371070880.18158.837974429614447605.stgit@john-XPS-13-9370>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <fe42b22b-c3d6-136e-a659-8bd189302afd@fb.com>
Date:   Thu, 2 Jul 2020 14:01:20 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
In-Reply-To: <159371070880.18158.837974429614447605.stgit@john-XPS-13-9370>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR11CA0088.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::29) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e1::10fa] (2620:10d:c090:400::5:1771) by BYAPR11CA0088.namprd11.prod.outlook.com (2603:10b6:a03:f4::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.23 via Frontend Transport; Thu, 2 Jul 2020 21:01:21 +0000
X-Originating-IP: [2620:10d:c090:400::5:1771]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 44035a99-c621-4f7c-7a1b-08d81ecb1314
X-MS-TrafficTypeDiagnostic: BYAPR15MB3510:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB3510EECC485D15F5D86FF778D36D0@BYAPR15MB3510.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-Forefront-PRVS: 0452022BE1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xbfxtOTZf7NhctYgFf3dWS3708eT0+yOEvEAOZSL02Q4cecOB3RgZhsYAVBiEa6RJrW45c/ChqN3Rd9+91SWofP4TRg+aytKkqil8wqKUV0Dat3jvJsQWiuc2wuN2kAv4riZ8v6vqLCZbKH0Ka6vYg+2vj07qRtf2SehMEhaURC4SE54PmQfKsdSdcZSk5UvR8JYnCVTmSsLk1HlelbTMwbJKb2HMS4gDlvCrpyAtv8ETnJBzWrCbQB3mdnBV7x6C9ZHEQoYTcZb6ImdfNLxkRdgaMcIOf5y+qXOwUINFFiZ87BPzWwNYmxo5zu6AlVX/Rt4QoRjp4pCm7wedM8zzdM/MwN9zQpoMlQUOFyCvAi/8r2xW8Aun/01cf18yW4p
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(366004)(376002)(346002)(396003)(39860400002)(136003)(186003)(16526019)(316002)(36756003)(2906002)(6486002)(31686004)(478600001)(66556008)(66476007)(66946007)(8936002)(5660300002)(8676002)(52116002)(4326008)(53546011)(86362001)(2616005)(83380400001)(31696002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: O++ra+ef57VpEAI677l1QHSm5j/4ShdfVitVoyDCk4y6AcqQk1QAEb9TmfKLX3dJ6FqYE5G8MRk3JK3jbNPe04Ch81h49o27BWpS7/A/YAzmE5jsK6scq5cfdVyiLuGNOtaZEcg3OL/oCq9hUWMlP1w2TqzHfPrtU2vX6iMWOq08WJu1RLVE7oZLOgtn3CMK0GnI+jCgOWDciQguA0utxGGJjtvkcuogHP2kcc8theMMDTbISMDkXnvtmX1vMr9zbAXssqULKfVLypZgmSFO9yENiyWQSr2KMKLG1VOSbM6eV2+h5fQDlYBX1PzKI1uLL1fdetn71/PV+5mxHPtyrc2S2lN1lizZnVXJsOYHN1H0w2uukOUV2HsyCYG0XuFor6p3iExOOVVADTevRVl6uCeK2ffzUWKhv5d48M4U7GiornfZATb7Ad6Z/Dca03wix+jSSjlJqbGbXe0YU9aiPGkW6f2cw/LuGe1xxutI4xzQlmBgTR7YaZVv32+bqxZ4mSV7TVExkqRe/hE84ABSCg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 44035a99-c621-4f7c-7a1b-08d81ecb1314
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2020 21:01:22.3446
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vc1nSdlxjWaRpKqUIzYWfp4rnwr6fv5i3l653WsSoeiz75yD5/HUyXo5Nt0C1Ob0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3510
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-02_09:2020-07-02,2020-07-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 phishscore=0 bulkscore=0 adultscore=0 impostorscore=0 suspectscore=0
 spamscore=0 lowpriorityscore=0 malwarescore=0 mlxlogscore=999
 cotscore=-2147483648 clxscore=1015 mlxscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007020138
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/2/20 10:25 AM, John Fastabend wrote:
> Fix segfault from bpftool by adding emit_obj_refs_plain when skeleton
> code is disabled.
> 
> Tested by deleting BUILD_BPF_SKELS in Makefile.

You probably hit this issue with a different way, right?
Old clang, or anything? I would be good to clarify in
the commit message. People in general do not tweak Makefile
to find bugs, I guess.

> 
> # ./bpftool prog show
> Error: bpftool built without PID iterator support
> 3: cgroup_skb  tag 7be49e3934a125ba  gpl
>          loaded_at 2020-07-01T08:01:29-0700  uid 0
> Segmentation fault
> 
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>

Ack with request for better description in the commit message.

Acked-by: Yonghong Song <yhs@fb.com>

> ---
>   tools/bpf/bpftool/pids.c |    1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/tools/bpf/bpftool/pids.c b/tools/bpf/bpftool/pids.c
> index 2709be4de2b1..7d5416667c85 100644
> --- a/tools/bpf/bpftool/pids.c
> +++ b/tools/bpf/bpftool/pids.c
> @@ -19,6 +19,7 @@ int build_obj_refs_table(struct obj_refs_table *table, enum bpf_obj_type type)
>   	return -ENOTSUP;
>   }
>   void delete_obj_refs_table(struct obj_refs_table *table) {}
> +void emit_obj_refs_plain(struct obj_refs_table *table, __u32 id, const char *prefix) {}
>   
>   #else /* BPFTOOL_WITHOUT_SKELETONS */
>   
> 
