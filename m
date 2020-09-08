Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA0C526186A
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 19:54:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732127AbgIHRyr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 13:54:47 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:47214 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732142AbgIHRyk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 13:54:40 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 088HpVFR011342;
        Tue, 8 Sep 2020 10:54:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=T7vNS1ufIbjEQw6tFpcDSA8AyTeAF2JNbnupEtab4sY=;
 b=Y2yxUqSAb8SubsXYbe9On5UNjLbuErFBV9wxBNxTSLJSOctHMt6pD7Z4ShQ+0gtYghcu
 gD1D4zHDRX0JUhmccJT88zicGgjTYRKDmQFKorFh7ifmv6+P4W0nnKoYSEVPmHY3ZnET
 cIQzVsXBhn1krGW7m5ddvFhCuPtioJmlAUA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 33ct69jrkm-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 08 Sep 2020 10:54:17 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 8 Sep 2020 10:54:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=izVHDn69NsFEp3jzQK4tSbK6KEYyRJz1ROIzImEiAwle/pIAK0CUSBS6ooGdnQV0huJjusLBd5tX1tV46x93xxOXzyktvquM98rnUGwt4ncaKlb1kcqxrTAI7RVSoqKf3j2U8CTQFro30rrV48W2aOMilwj6dr7HlZLh/j1Cfou8xVlVwSMbyHimmTrO8c47+S5/6iKezu3m9eICuOC48L0Ewvzketx3P9qVYp+8nF9o17jdXLoZcqOZ4RUqXT5yEbKP45xrLH4rApogdwF/Pb7eSCjPhYMd4diJ37r9VU0LcY/JnkiH/e0r2DGEzZY6qCqkNOX0WsAxjgpXtKCAlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T7vNS1ufIbjEQw6tFpcDSA8AyTeAF2JNbnupEtab4sY=;
 b=mmS2NVBr4oucQ+veqA5it300O8cIKHjs3AfuP3LbZakqXsbck0JwMh3FVj94wft8OWpktfSa7DtlCuA4hGvoLiQGWcdj9scZNpoSM5bz8OiEMOg3GaUf1oZ87ERYulfN+V2AGlbTM6pRZjfij9xnJXoaGHEW/bc9q/NcU598ljtlet2Rg1qQCqhfp9WOh4RNg8azNGPHXqB2BaeFTGJ5OjBttJ8aZe4O5EsndnTvs/7Jr0SAyHGI8RrOAXEbJnm68XLN5VkyY69scCg8vCy6CZjmC9uoqvbIGyHewkhwSbIOY8o5hdnsQDQ1AP76QrMwX0OB4FffNNuCcuQjXw70JA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T7vNS1ufIbjEQw6tFpcDSA8AyTeAF2JNbnupEtab4sY=;
 b=M41iVLeuwpzDNO3cqGuEuPCUWuwNVwrXQC6SccmwW2a03Y4SxyERdFjAsx/csvwzakFLFsTlc2UhCyqFN39G/R641+g9X6xpgxBAFCS9ls18lcWtU1YIRk6blwnRDHA2qm/nVXsvBNBiw1DTzL2YyYKmJxVYDz1aUrlpfTMyRgI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from MW3PR15MB3980.namprd15.prod.outlook.com (2603:10b6:303:48::23)
 by MW3PR15MB3865.namprd15.prod.outlook.com (2603:10b6:303:42::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Tue, 8 Sep
 2020 17:54:14 +0000
Received: from MW3PR15MB3980.namprd15.prod.outlook.com
 ([fe80::50ac:a9fb:9a0f:126f]) by MW3PR15MB3980.namprd15.prod.outlook.com
 ([fe80::50ac:a9fb:9a0f:126f%6]) with mapi id 15.20.3348.019; Tue, 8 Sep 2020
 17:54:14 +0000
Subject: Re: linux-next: build failure after merge of the bpf-next tree
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>
CC:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20200908130841.21980cd9@canb.auug.org.au>
From:   Andrii Nakryiko <andriin@fb.com>
Message-ID: <e03e59ab-7bf7-3a69-77e8-35ffff6bb3bf@fb.com>
Date:   Tue, 8 Sep 2020 10:54:12 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
In-Reply-To: <20200908130841.21980cd9@canb.auug.org.au>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR17CA0059.namprd17.prod.outlook.com
 (2603:10b6:a03:167::36) To MW3PR15MB3980.namprd15.prod.outlook.com
 (2603:10b6:303:48::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:2103:51:fde8:f2bb:1332] (2620:10d:c090:400::5:7730) by BY5PR17CA0059.namprd17.prod.outlook.com (2603:10b6:a03:167::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Tue, 8 Sep 2020 17:54:13 +0000
X-Originating-IP: [2620:10d:c090:400::5:7730]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4d8d6a87-9e95-4bcb-ace8-08d8542032e6
X-MS-TrafficTypeDiagnostic: MW3PR15MB3865:
X-Microsoft-Antispam-PRVS: <MW3PR15MB386501FFFA10C399A3CAB2C2C6290@MW3PR15MB3865.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HbhybVbDwSOQkBDPFgpvo1CrahyO4WmwmCroaCO+fUkYrOpFmYD3ObN4/FSURY4y92wU66lk2nf2Ev7PeSN3Ekv5qFGnbE6+pMX1S+hBt5x2O3uViUtca2gbheqE7sfWb4ZkuluRXnxgK2EBmSsxFgZwn/D7aB3srvo4XVGx3emCf+8jjZLsDDN4egpsAqVBIkYPa507t52X1C40mUW/eJMY7+h8969qlNzzzPT4z6FtbqpBEJhxEznx6bTsHA9aSB2fd0pYgCB5j9kWzG4R7yQ1e3ugf2nEBt4NPc8IRT25wLn2u+VO/gDd8O/cLAY7xSGi+hOxfvbftL/P9njyewLSfTptgHrh5FX+mHZ3MnJ/3F32gpYNGkfacaCE5OYn
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR15MB3980.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(136003)(39860400002)(396003)(366004)(8936002)(66556008)(66946007)(66476007)(83380400001)(2616005)(5660300002)(52116002)(316002)(53546011)(36756003)(186003)(16526019)(2906002)(6486002)(8676002)(31696002)(110136005)(4326008)(86362001)(31686004)(478600001)(54906003)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: pFeqYtOlbvbcAX/mc3Bofkd2NZoUDmNClJcVuYbOsw8OX4EyopKIi5LavqNjcOJT2hK0jpBSDCksw6Y3tibUxhMVtR4kDmXL5/ViobVJCNVmcuN6T/ZAQ5PEgxMaR9bZxiXIo58w70tyfWXOXguEVJIHXFeR2dWSIR44/dSVE+Mijlw90RZy5L/blyrXcuDDh7bJzhqFK3WzICGLvmZp5vmJXjX8+lj1qMb4TeA02klhqm0WDIjPDu/6mYAeB6HbGi0YXjZDJxV35r8rdoCP52+/faWtZzlAtCul2TqEQsVJAQnN8rUAe1r/xXtpCcTFKzhZoD57qv7NqTXwQSVwTiWdnnY7aNOUxJgwU+4SiAd9QxSPl4T/9MtVO2HxpvlfcDIB3AAmJ0aV6L4j0ea3vTsRf97UzS/1z0Jw12PZgmkA6RJmtjexJ3DwnoJVRW+Ag4HO/ED6r2+PoBt94qBmh2VWPXbCKDSRKJcvlBRYePxb7DkyDie2AqHs1xUxRADAtnD4acyxs0++5qZ91W7WXJf/nI9+vHsLyD86Th7SGoh/FUOeHIz3zOgdP/eq/+QJ7Ylm+RMIKA2/sLnoeWekqtHUDnPGtnXSkHHma2sGzjAQPdvIMBR5jQTCCTXaTsIQwOiTmfmMTPmaQ032+0Z09ucxdVnr63REnVHFmwh4ar8=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d8d6a87-9e95-4bcb-ace8-08d8542032e6
X-MS-Exchange-CrossTenant-AuthSource: MW3PR15MB3980.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2020 17:54:14.4232
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MNJRrUXn8dx9Qnu1SD6Rj25BUOLamtF0ghYZXaNCozT+usAsAap+b/qecjIDQR/t
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3865
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-08_09:2020-09-08,2020-09-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 priorityscore=1501 mlxscore=0 spamscore=0 phishscore=0 clxscore=1011
 mlxlogscore=999 impostorscore=0 bulkscore=0 malwarescore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009080169
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/7/20 8:08 PM, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the bpf-next tree, today's linux-next build (powerpcle perf)
> failed like this:
> 
> util/bpf-loader.c: In function 'config_bpf_program':
> util/bpf-loader.c:331:2: error: 'bpf_program__title' is deprecated: BPF program title is confusing term; please use bpf_program__section_name() instead [-Werror=deprecated-declarations]
>    331 |  config_str = bpf_program__title(prog, false);
>        |  ^~~~~~~~~~
> In file included from util/bpf-loader.c:10:
> tools/lib/bpf/libbpf.h:203:13: note: declared here
>    203 | const char *bpf_program__title(const struct bpf_program *prog, bool needs_copy);
>        |             ^~~~~~~~~~~~~~~~~~
> util/bpf-loader.c: In function 'preproc_gen_prologue':
> util/bpf-loader.c:457:3: error: 'bpf_program__title' is deprecated: BPF program title is confusing term; please use bpf_program__section_name() instead [-Werror=deprecated-declarations]
>    457 |   title = bpf_program__title(prog, false);
>        |   ^~~~~
> In file included from util/bpf-loader.c:10:
> tools/lib/bpf/libbpf.h:203:13: note: declared here
>    203 | const char *bpf_program__title(const struct bpf_program *prog, bool needs_copy);
>        |             ^~~~~~~~~~~~~~~~~~
> cc1: all warnings being treated as errors
> 
> Caused or exposed by commit
> 
>    521095842027 ("libbpf: Deprecate notion of BPF program "title" in favor of "section name"")
> 
> I have used the bpf-next tree from next-20200903 for today.
> 

perf code is using deprecated bpf_program__title() API. I'll send a 
patch for bpf-next to replace it with bpf_program__section_name(). 
Thanks for letting me know about build warning!
