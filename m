Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3AA624C28A
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 17:51:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729371AbgHTPv5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 11:51:57 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:28154 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728209AbgHTPvy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 11:51:54 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 07KFgR4C002213;
        Thu, 20 Aug 2020 08:51:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=RXIGmGBzq0cniGsP+T8sXiyur8XpDWLRd5q+UNsQ1DY=;
 b=iW584+hCuXa/wzfM+epwFB1gmPVC5GldoMrdkXa0qt7/3fDgnuroUwZBvfpyQEOg4B6C
 cMdKsdR2U/xMw1WM4PuxwsP+Ps1eyfDuLO1/7I9ryFqNam5pws5YjKZ62FHFu5/yF062
 t0+iZKyzTQVMbt3A7ga7NZI43oegIcl6zl0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 3304jjevft-10
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 20 Aug 2020 08:51:35 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 20 Aug 2020 08:51:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MwHyLHeoThsPaR+IKMUP4U+knH1Gb8C3Owff0L1PCATx3b2MXquLvGH3r/w7UDVWYskMscOXBzgYzA/JHNbGoZs7W0WxIus+twH0ACMB8Cn0bNR5OtHY6R00eelp8PCmQEmsZCmr5pnxEUVO5HkkRepgNWqBU4kqHXTgmpW0t5TE5Yftk0X5N008j/ZrCnLm5IVinmi9gQjMr9wjgvr/3NpUtSGDC2SR0AiVwVQbRs+mdxJ8i/RmDZDs5sTs14UDSrQI9ydd5eZ8RQklnR43i/66kzx+U/Yt9Ly4fbGRVi4x9Ng9fnyvCR0yIqXqJSkqNXc4qR7ascMJIwileQ8NXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RXIGmGBzq0cniGsP+T8sXiyur8XpDWLRd5q+UNsQ1DY=;
 b=MkHEpP3EwinGgprzME8dXhvXm1xX1pvs8S2J1d+3f5W89eDg6+I+/353IuhCfESPyN1VZeUBa6+2HcDg+8616Mi406pmNdla6DV7jvaPytlvcMdE4aMaTs9j8heVh532fLOQLaa1tUojQYiyydXpCvLS5D2GDOJyODohsBe+lck57nVN83+eIjnuLfi7+EVoR4fl1GTzKin6J3GSmZPbYqslXkCC7kWq9GDiuwMZ8m67OV0VciKI+KizFwdUS2cuDSnRySVpKiMvYLiCYtnIILvW9eSzlnik9/fcGiM84Ylr1QrLSn+VthjZnxJ4J5CqgZ0qYzHzN9SPGPGDNOPjOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RXIGmGBzq0cniGsP+T8sXiyur8XpDWLRd5q+UNsQ1DY=;
 b=AtESGWdvRudOG5YpI74EvhWAS6/lx6peF9yBiymgvxQ5wVpZEvl4+9bjYai5PPaZ+4tglyU+4kbyga3ncWu9X3sNFLpo9TVPOItvHdT6CiYyVR89tqxehPCYxpHGWvNuyirPNTaqo/LKxOHS6VN0oAtb82aMDMnoM3vGz8YoMfw=
Authentication-Results: googlegroups.com; dkim=none (message not signed)
 header.d=none;googlegroups.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BY5PR15MB3667.namprd15.prod.outlook.com (2603:10b6:a03:1f9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.15; Thu, 20 Aug
 2020 15:51:25 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80%7]) with mapi id 15.20.3305.026; Thu, 20 Aug 2020
 15:51:25 +0000
Subject: Re: [PATCH bpf-next] tools/resolve_btfids: Fix sections with wrong
 alignment
To:     Mark Wielaard <mark@klomp.org>,
        =?UTF-8?B?RsSBbmctcnXDrCBTw7JuZw==?= <maskray@google.com>,
        Jiri Olsa <jolsa@kernel.org>
CC:     Nick Desaulniers <ndesaulniers@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Nick Clifton <nickc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
References: <20200819092342.259004-1-jolsa@kernel.org>
 <254246ed-1b76-c435-a7bd-0783a29094d9@fb.com> <20200819173618.GH177896@krava>
 <CAKwvOdnfy4ASdeVqPjMtALXOXgMKdEB8U0UzWDPBKVqdhcPaFg@mail.gmail.com>
 <2e35cf9e-d815-5cd7-9106-7947e5b9fe3f@fb.com>
 <CAFP8O3+mqgQr_zVS9pMXSpFsCm0yp5y5Vgx1jmDc+wi-8-HOVQ@mail.gmail.com>
 <ba7bbec7-9fb5-5f8f-131e-1e0aeff843fa@fb.com>
 <5ef90a283aa2f68018763258999fa66cd34cb3bb.camel@klomp.org>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <7029ff8f-77d3-584b-2e7e-388c001cd648@fb.com>
Date:   Thu, 20 Aug 2020 08:51:19 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
In-Reply-To: <5ef90a283aa2f68018763258999fa66cd34cb3bb.camel@klomp.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL0PR0102CA0039.prod.exchangelabs.com
 (2603:10b6:208:25::16) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by BL0PR0102CA0039.prod.exchangelabs.com (2603:10b6:208:25::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.24 via Frontend Transport; Thu, 20 Aug 2020 15:51:22 +0000
X-Originating-IP: [2620:10d:c091:480::1:7ec1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ccc40fdc-a529-478d-31db-08d84520e49d
X-MS-TrafficTypeDiagnostic: BY5PR15MB3667:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR15MB3667449F2A64063EDDE2D042D35A0@BY5PR15MB3667.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wATdE9ftt66wxkJt95WGAmbpSY63xwUOXHLUAtgUZ9dKZRLzFB64Xeva1MY6yqqV2dY3xbCQxajOZRzdg+rhxaCHbCKXxMrRdc9XGhgFDLjS1nLaB9vfKf9jg2cWhDOF2jKaNqdnEySx3jBQOQi0IggoasKn+pwy6b9G2u17FMeajjHQgDejtL5PGZitaWnomAY6aYUjjj17hUNNhpxIkr1aZMTmeG1jHfjB1dEFx0VAAuimT0QjXEXyfdNO8gqf8IZ3YNXPjiSksT17y4uJTmWv75XQqUq7WllKFRnsKtz1Cqsv0npcMHBUEiXxzAU3vucKpOPM2HTpeSZhqdM48gyLZDqOUYwY8yPTObvfGb38VW2GDeElwQW7HUNGaAEufjdl66uzDsgcTIS2ZGTbxqH9q9OXmzBvBVjkzGiX9W8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(366004)(346002)(39860400002)(136003)(956004)(2906002)(8676002)(66574015)(52116002)(36756003)(6486002)(478600001)(4326008)(31696002)(66476007)(86362001)(66556008)(8936002)(6666004)(110136005)(186003)(54906003)(7416002)(66946007)(2616005)(16576012)(53546011)(5660300002)(110011004)(316002)(83380400001)(31686004)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: gq6TvculH5/1suEkF6sfSlmH35bZCmVTukO9zQFNp4leXhkMudR8BMAcAxo4HPMaYOapPglHw7DkF9Q2u9bCPE0Tu/255kRAme5T0tOP4mHp0RlZM66lmSm7kihKFk+8/AdniDQ3k902qoNZxrOmWRRKug8V/zqrz8dCcby6OLDcxgbF9Z+kFhb9/Ejij0sRbxGKQM6F9QOSLt3EY4bi3wrrm9R9vTMX9/BSg284vo5+iych8BaaBDfcGp8aSdzQbdy5ETbanF9Bb9hGnKBpJbwo9iubQPvR4epf8kkK/Kuhh/RCTlVTLAoxbFiqHbSiTlOzgUwLLRdDeaRALqkWGE0KnZrDNwanrZRD5vMR8hGP4vIPJXwYOuCbkAOKjhOdVp1MJ+ubhqlMtKres4WyOdoXfG53ZkNs/uoIR5yYHCroVW4UcVivwswKBWLBx1X9/mYIshLF8VJcEMDU3hvEE/HiFZL8AeV+y5XzwguF2nw0SICTwPLpotWWMd0czWiZ45tpAOeDhcEuQBwjx8vJ08zOeda735RdL44ABv+OYKacS1tsbLzQiDE3hQAxfVzOVtdEl31Svcej1iwc0MWFeW/DFnpfgH8slTH2WU5K8Rjpsp9bZ7eNJ5GNfyg5V/Ws3WOsSPn/8vBSiWfARKh8CXcqruWfO7gDDNY/tmAnfLoBV8joKvstIWGtb05JMJ1r
X-MS-Exchange-CrossTenant-Network-Message-Id: ccc40fdc-a529-478d-31db-08d84520e49d
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2020 15:51:25.0691
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lyv/9IQOMwRh60+pxg287qrAuUUYWRKGIcXHI2YLT+wH5beTlPm+EueRsHUqoQg2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3667
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-20_03:2020-08-19,2020-08-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 lowpriorityscore=0 priorityscore=1501 malwarescore=0 spamscore=0
 impostorscore=0 bulkscore=0 mlxlogscore=999 phishscore=0 mlxscore=0
 clxscore=1011 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008200128
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/20/20 3:18 AM, Mark Wielaard wrote:
> Hi,
> 
> On Wed, 2020-08-19 at 20:23 -0700, Yonghong Song wrote:
>> On 8/19/20 7:27 PM, Fāng-ruì Sòng wrote:
>>>>>>
>>> I think this is resolve_btfids's bug. GNU ld and LLD are innocent.
>>> These .debug_* sections work fine if their sh_addralign is 1.
>>> When the section flag SHF_COMPRESSED is set, the meaningful
>>> alignment
>>> is Elf64_Chdr::ch_addralign, after the header is uncompressed.
>>>
>>> On Wed, Aug 19, 2020 at 2:30 PM Yonghong Song <yhs@fb.com> wrote:
>> Since Fangrui mentioned this is not a ld/lld bug, then changing
>> alighment from 1 to 4 might have some adverse effect for the binary,
>> I guess.
> 
> The bug isn't about a wrong ch_addralign, which seems to have been set
> correctly. But it is a bug about incorrectly setting the sh_addralign
> of the section. The sh_addralign indicates the alignment of the data in
> the section, which is the Elf32/64_Chdr plus compressed data, not the
> alignment of the uncompressed data. It helps the consumer make sure
> they lay out the data so that the ELF data structures can be read
> through their natural alignment.
> 
> In practice it often isn't a real issue, because consumers, including
> libelf, will correct the data alignment before usage anyway. But that
> doesn't mean it isn't a bug to set it wrongly.
> 
>> Do you think we could skip these .debug_* sections somehow in elf
>> parsing in resolve_btfids? resolve_btfids does not need to read
>> these sections. This way, no need to change their alignment either.
> 
> The issue is that elfutils libelf will not allow writing out the
> section when it notices the sh_addralign field is setup wrongly.

Maybe resolve_btfids can temporarily change sh_addralign to 4/8
before elf manipulation (elf_write) to make libelf happy.
After all elf_write is done, change back to whatever the
original value (1). Does this work?

> 
> Cheers,
> 
> Mark
> 
