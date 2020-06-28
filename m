Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7C2A20CAAD
	for <lists+netdev@lfdr.de>; Sun, 28 Jun 2020 22:54:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726438AbgF1Uy3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jun 2020 16:54:29 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:59100 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726104AbgF1Uy3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jun 2020 16:54:29 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05SKnUfD007597;
        Sun, 28 Jun 2020 13:54:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=sUKXPb35vLtamw4SaXzT2P40LdUk+1fQiS8vDGiUvc0=;
 b=hFRTuKuMxbV8upMZikuiEbEE4Z4zHhgWNGMBmigmGSgnK/w7yT32n7nG2UtrellFUvyp
 yfn8yjnWFqpvdy6CtMvKO9DUUC5lYOsC4dcoUfsJ1QaT1AEfjXhHr/VJXsiJ/Zm1qpT6
 dc4DlSXysVYyR+kssP5hP6G94xUZaoWWnNw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 31x3upc8e7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sun, 28 Jun 2020 13:54:11 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sun, 28 Jun 2020 13:54:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hyrgKX7SQ5KEO2I26GqiFUtR8pO9orYL3OOkHwnFlMHEFQY0YPWzE8aEUNkQH8sNk7lMRxyOGMfiUSy6IkWIJXjh6l+yLoBwpW/4QaM9tgE3oNnFJZug0Z3A4XCisTK1uapGrvTJrQFbk0nIekFDtNXacZG2mn1hhlQeFvpGF4g5nRHrviHc93TWMd9rI4aWsZanqZ01+QLFVRL5LEKUMJldw+30DprbSblA4IjP4WhxWnmLaMuc6JKfb8r9mONEhVHbBU2ReYJQqRBozqOsbUsS059eDKADSmEX7NE8nEtjeviFoUeWjhlYrWeQgW7hYiX3yR1av9yasVDi996M3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sUKXPb35vLtamw4SaXzT2P40LdUk+1fQiS8vDGiUvc0=;
 b=VyCrxBOtD9SYK0KGTKqe9eyx5FOX7liEVXvzyo3Rrc2snPE7WtBpO4vZ5CHQz6r35qkLUBTD7ttfwrBQhAe8rFKCtjKKB0iI0DsWXLZ/sFOBI3bWWE2Q/BcHLpLpT5Totly7gxLLI2Yjle3Q/4RS1P4X0yfse5Dgk4n4v+PP89fET5xhIBJSwzpX0Jxc5J9BPjfKb2eCKUjhTTjuzGMyahqykCBjL4ceuSawhLxL8Q0NGqKKUncjQIf0t/A4O5u+WIwf38kxIfcC8L2yEnBapXii8lyldf85su0ion62Db3jZ1OVFYuZJkmKhGynNJZZL+hx9Ka8/3/70dTEKilJJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sUKXPb35vLtamw4SaXzT2P40LdUk+1fQiS8vDGiUvc0=;
 b=GjnGrFujrij9VvaTHTLlvGV1PWvoYMJpQ9sOQpBnQOr3ucnuXN2xTrT0NaLs3aljEM/P1WkJG4uYDq4VTKw7klrLcrcbZxmohNAJ4nG0etqWLu8NYaSVTqaW+CMZ2Sb3yMZ/AvBSasSMhbYPT/k6Gs6b48e1FijNFJWW3bCXnKY=
Authentication-Results: zeniv.linux.org.uk; dkim=none (message not signed)
 header.d=none;zeniv.linux.org.uk; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2582.namprd15.prod.outlook.com (2603:10b6:a03:154::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20; Sun, 28 Jun
 2020 20:53:49 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301%7]) with mapi id 15.20.3131.026; Sun, 28 Jun 2020
 20:53:49 +0000
Subject: Re: [PATCH v4 bpf-next 01/14] bpf: Add resolve_btfids tool to resolve
 BTF IDs in ELF object
To:     Jiri Olsa <jolsa@redhat.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
References: <20200625221304.2817194-1-jolsa@kernel.org>
 <20200625221304.2817194-2-jolsa@kernel.org>
 <d521c351-2bcd-2510-7266-0194ade5ca64@fb.com>
 <20200628190927.43vvzapcxpo7wxrq@ast-mbp.dhcp.thefacebook.com>
 <20200628193513.GA2988321@krava>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <e3791cb7-85cf-328e-73f7-e290249fd8b5@fb.com>
Date:   Sun, 28 Jun 2020 13:53:46 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
In-Reply-To: <20200628193513.GA2988321@krava>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR02CA0061.namprd02.prod.outlook.com
 (2603:10b6:a03:54::38) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21cf::1085] (2620:10d:c090:400::5:860f) by BYAPR02CA0061.namprd02.prod.outlook.com (2603:10b6:a03:54::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20 via Frontend Transport; Sun, 28 Jun 2020 20:53:48 +0000
X-Originating-IP: [2620:10d:c090:400::5:860f]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8ec7ab88-2d8b-43a6-cf47-08d81ba55b78
X-MS-TrafficTypeDiagnostic: BYAPR15MB2582:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB258225668CF25F5DC4D92005D3910@BYAPR15MB2582.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-Forefront-PRVS: 0448A97BF2
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fPpR/4Vkv6VKvdtDDivhlscjur3M+dMagfGZRzo/atF5pL+ZRBUlHxAx45XCmW+/u7u7CqAkPMEVJ47nM8LNeamUAKU0jsZO/QfR3iF2Xa2KtBOg78cgyZ28eeW0jB6SAoUmBL7ddoEwCm1I6s0tIMpMmiyW7Dwa7BbtP1k15mVDMlO6yKjg2WG6d6aP484njvemMTK3+UkYhBOrnrlrbbFFCO+SrBd9UcT4W4f9aG75FOFzmC9cZ/sQqJQe9vrulYR+eWn7XtXDZe6Zz6KrpzWtFE5710NZicF0WbiGDQk7PTMQsmrius5PhRR7p3S0NpB/UPTB3ozUFPHtZAxHu6fTvti73AB6xxmxTXVpCiSVHWGvfhhYl6Rl/+1aQFDg
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39860400002)(366004)(396003)(376002)(136003)(346002)(4326008)(53546011)(7416002)(36756003)(8936002)(2616005)(31686004)(478600001)(52116002)(316002)(66476007)(66556008)(66946007)(54906003)(2906002)(31696002)(186003)(86362001)(16526019)(8676002)(5660300002)(6486002)(110136005)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: +lgPrCF081R8pfhTJ91Kv7A5l7TtF3UUtshrjKGBgF8JHBgNYXVSfTO/cMY7CJN3zhvFILacHugmR7opO38X6MkdAECuYQ73lB/c0KPBl9rp5mTEvGVLa++kPgOmAxIL38wUTm9e3+02XSwOiZ+Oz0ltZOiRvtdqdbhjZtqFrB0Y0HZWOvJ7g/0sfKJdKsdPoFbdabX5AnmTz0ErVT9BpLV3bXASr2EkqcEaGKpnDt+4Dba/sWSdIjGFCvH0ao1HllB54D9v7t3kScTy2p7CynJhiY4ippGMQgVgbxSIphd9iB6Mnliz0M2sCbn/439zpaewnN1lkW7JultwhAiC2lHaNJap++qeZnrCKuCsfKwwwhxIGu6zd8jnfRdkpzBLd1WiCpvM9CneoUiZGk2ytNcmAZZakJXd6BsGr/ELXjHT7mIX6n/44D7YPZxRDPsjBnbbS5L4Yx4D5Fg3Q1ColFTVV9vr9X8tnJyANMTZUN3roc4Vej5LCiJ0n9wpiSICb4JCJ4BMCxHNAsLq7OKLbw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ec7ab88-2d8b-43a6-cf47-08d81ba55b78
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2020 20:53:49.3881
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VzrwDpIkNugJFcrlKvw/ksUbEsvcExSAsWrJJ4O/SrGeZ70GPHMNfhUhC/MwE4OE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2582
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-28_11:2020-06-26,2020-06-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 mlxlogscore=999 lowpriorityscore=0 impostorscore=0 phishscore=0
 spamscore=0 bulkscore=0 priorityscore=1501 cotscore=-2147483648
 suspectscore=0 mlxscore=0 malwarescore=0 clxscore=1015 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006280157
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/28/20 12:35 PM, Jiri Olsa wrote:
> On Sun, Jun 28, 2020 at 12:09:27PM -0700, Alexei Starovoitov wrote:
>> On Fri, Jun 26, 2020 at 02:09:53PM -0700, Yonghong Song wrote:
>>>
>>> After applying the whole patch set to my bpf-next tree locally, I cannot
>>> build:
>>>
>>> -bash-4.4$ make -j100 && make vmlinux
>>>    GEN     Makefile
>>>    DESCEND  objtool
>>>    DESCEND  bpf/resolve_btfids
>>> make[4]: *** No rule to make target
>>> `/data/users/yhs/work/net-next/tools/bpf/resolve_btfids/fixdep'.  Stop.
>>> make[3]: *** [fixdep] Error 2
>>> make[2]: *** [bpf/resolve_btfids] Error 2
>>> make[1]: *** [tools/bpf/resolve_btfids] Error 2
>>> make[1]: *** Waiting for unfinished jobs....
>>> make[1]: *** wait: No child processes.  Stop.
>>> make: *** [__sub-make] Error 2
>>> -bash-4.4$
>>>
>>> Any clue what is the possible issue here?
>>
>> Same here. After applying patch 1 and 2 it doesn't build for me
>> with the same error as above.
>>
>> But if I do:
>> cd tools/bpf/resolve_btfids; make; cd -; make
>> it works.
> 
> I already got this error from 0-day bot.. I tested on fresh
> Fedora installs on x86/ppx/arm/s390 archs and all's good
> 
> what distros are you guys on? I'm installing debian and
> perhaps I'll try some other

My system is:
  CentOS Linux release 7.8.2003 (Core)

> 
> thanks,
> jirka
> 
