Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FB1824A888
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 23:32:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726731AbgHSVcn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 17:32:43 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:62360 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726466AbgHSVcm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 17:32:42 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 07JLIAqO032464;
        Wed, 19 Aug 2020 14:32:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=PRjIBh9399z2zwDiP1yf5rQHeX2hWgt3lrgQGCNBX6A=;
 b=HUKhpR44KiHMY3dlxquZ5sukrwiK5ulSNVWjD7gcKCukpo13TGKcayDTVFtfAjB3pWMR
 IGh6Bi4FlnwG5JeSh4+X2gJWx2UnWfs1kP0qJwqm3IWm37qEQaCa/OOIE9oupmZMa4pv
 HGiDSnfI4pQEITW5CsIivUWQJxp3VkJ99Ew= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 3304jjat8y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 19 Aug 2020 14:32:26 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 19 Aug 2020 14:32:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aWjK8Ptjous/dd35a8YreaPHAarK/3gyn62msiy+a9XflheQL4+ecx9mGHtozepX9HHcuIoDWB2a/Dlnv3UquddpqO4QZtG5nTvWII4z2CIhPf056utg8KT0YKTtqHikPgKnq8GhGX3nFQnW21HGWMLKeRP7GpBWueChNFo8K1Rwww8HaLeRm9icqrbtQui+GL1ly9mI8hwIoiT7T/pP6h7pidPCgxvZRVpIhxX8hebUadMtUaCBYNggYl+dlFfNZ3om47wjZne0brE7UA7CQsmiIZsZFSerzdSFUkjU6w30HOpcOD86OjIXonGYKOlTP6xj/mAZZQ/iWCV3e91vfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PRjIBh9399z2zwDiP1yf5rQHeX2hWgt3lrgQGCNBX6A=;
 b=Oei9VqSi3gPxaqx9lGj9NmYM20twqSOyrv29jg95KidSZbb1ropA17gJKgqz2Yv0sp+sMA9iKLy6IRuQPjUzXF4nvXENwBIaPCH26uOw/Rl2qrNmbImQpPtGd3h9qHzr32XBI56BlO5Ch/ZXQ58r/6CmJLqs+p/RRiAHWiG3VMMLOWm7yL2vrtkb3wEwB45dJDLAV2FaEXw57WJEQjFSUpWx7d1SK/fqyu0ZBCj3v8kLmzODwIRSzMeRkX5ya+mO5kd9HjyXMeeaP3I6kwyCv0RRYsrrl3diw9gmEdDwYUt9Mihk/Man/TRLGGX1jfNzalBYYAAYgWbS3S74xSJgcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PRjIBh9399z2zwDiP1yf5rQHeX2hWgt3lrgQGCNBX6A=;
 b=XhJ+X0QIalYTVtdVGNOHCbEaGcz+Kf+SDP3A023W8/9SRQEg/wFYZ3Cc1vhL47c+Vtoqw3pVw4W2+HcnKDMFN+RmH8uktUg/tta/gAmRIR3qjW86zKEMD9u5f+3h0lgY6eTkZ+tTOCaEdHL/XdmecnygsmG9wIKJz5SrPMb52gQ=
Authentication-Results: chromium.org; dkim=none (message not signed)
 header.d=none;chromium.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2453.namprd15.prod.outlook.com (2603:10b6:a02:8d::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.15; Wed, 19 Aug
 2020 21:32:25 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80%7]) with mapi id 15.20.3283.028; Wed, 19 Aug 2020
 21:32:25 +0000
Subject: Re: [PATCH bpf-next] tools/resolve_btfids: Fix sections with wrong
 alignment
To:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
CC:     Mark Wielaard <mjw@redhat.com>, Nick Clifton <nickc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
References: <20200819092342.259004-1-jolsa@kernel.org>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <24314022-71a2-bd9a-17c0-325b20386ff7@fb.com>
Date:   Wed, 19 Aug 2020 14:32:19 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
In-Reply-To: <20200819092342.259004-1-jolsa@kernel.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR05CA0019.namprd05.prod.outlook.com
 (2603:10b6:208:91::29) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c0a8:11e8::10d3] (2620:10d:c091:480::1:d29f) by BL0PR05CA0019.namprd05.prod.outlook.com (2603:10b6:208:91::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.16 via Frontend Transport; Wed, 19 Aug 2020 21:32:22 +0000
X-Originating-IP: [2620:10d:c091:480::1:d29f]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 42474c84-c457-4a4d-f317-08d844875d4b
X-MS-TrafficTypeDiagnostic: BYAPR15MB2453:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2453DDCC15E250037D8C1E85D35D0@BYAPR15MB2453.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5MSQg9+2zP8pvCK69QRe43ck0Kk9eTcoX2ySTbtXa9Rb+IhXXlaKiICQ6SjkP8Tl1BTQHz+NIDGzgooyNqgbu/upxipvI3ksufaF+2EgBtIFeNAJwesk31x77Wfy+b4VF+1ZufSqo0A2ldzkEKVVtlFftaNZKQ36V6IsQDuZ5P6A9U/1t2Gvk40WgxLLelngGzsxHu5srodKFqIF19aS8GWlTORyTDNHucSNqyR/+/OkHhajgCGymkj5EYNzBQH2/5ZK3fKrxuLuA1vkvz7JW4ur1gn39brXZoKiqGPvbnJ6Awhh4etzwMQannuzXP6uvO4opGBY6mxPZTB6ux4ixS2oCun0ey3BXgCYJiMmSx36AFvBAcpKhwnnhJFS9+u/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(396003)(376002)(366004)(39860400002)(31696002)(8936002)(66946007)(478600001)(66556008)(53546011)(83380400001)(4326008)(316002)(66476007)(6666004)(16526019)(54906003)(8676002)(7416002)(2616005)(186003)(5660300002)(86362001)(52116002)(110136005)(2906002)(36756003)(6486002)(31686004)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: gHQdskEcuzmtQol2454jUSde5S/52K4PYthBr0dlluu6ZJZFwhtH8gqMlWvPZ3zMZ3DUNkll1Kf7izFFEvhJshnTN+eYGNwIzgkWStncJU3j40yJxXzDNTg4jPuJEHQdSqLLHr3ohQYA4R4yAdURcWTgBKMEoYJrThzOhJDDPJFXFi31QWc4g7h8EeWB5qEsMDEpZVwMfOffn34RYjphmTDgRnLa19n2kM449aUOZDuGs0vQPdpMwTlKxOpplwdg+qd2fUIlI0F5EXj/5ebK/QoSx84uCIT+NH4+lLHg+PiP8/8Ibv8b4tFX8LGw4jMd22ILLdGUJIUh79C7xWQ5SuLJRWXPZChJgZW8E8pfrUhxfL6xF79rgAOKA4fIwwF8Qpf/feSn7tgabqGJMijgtvTvT25jpKIynuNjCDV3I1nqTuwkkRHDCoPPjMfZstiYm8p61K1aLAcG3YQlEtDmcIydFi453RoXqQFJapiJpSoqh9/6b2xnbXAdLaqiqXlMz1GXEYfXC40dG4JbxaGvwo2IgC2/vrTSvTuhct9Fu6EtSq8ZI1tLEmFMJaBZ+i9RhJZ5pHOEV4PBKic8R6szAFZASNutg5zxHXGFQpxUFG0ETRrMAIUDbcElW5Z6Zv7Hk/O1h97p5qfv1qm8alI4zKYTnf68naHtmuOXUKBGRAo=
X-MS-Exchange-CrossTenant-Network-Message-Id: 42474c84-c457-4a4d-f317-08d844875d4b
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2020 21:32:25.1116
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QIKTjGlthNsGPPIbo5uClRgq69D4B2+OOSXDlsG7Is6YMZBEXPEUTScJKm2V7bNr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2453
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-19_13:2020-08-19,2020-08-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 lowpriorityscore=0 priorityscore=1501 malwarescore=0 spamscore=0
 impostorscore=0 bulkscore=0 mlxlogscore=999 phishscore=0 mlxscore=0
 clxscore=1015 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008190174
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/19/20 2:23 AM, Jiri Olsa wrote:
> The data of compressed section should be aligned to 4
> (for 32bit) or 8 (for 64 bit) bytes.
> 
> The binutils ld sets sh_addralign to 1, which makes libelf
> fail with misaligned section error during the update as
> reported by Jesper:
> 
>     FAILED elf_update(WRITE): invalid section alignment
> 
> While waiting for ld fix, we can fix compressed sections
> sh_addralign value manually.
> 
> Adding warning in -vv mode when the fix is triggered:
> 
>    $ ./tools/bpf/resolve_btfids/resolve_btfids -vv vmlinux
>    ...
>    section(36) .comment, size 44, link 0, flags 30, type=1
>    section(37) .debug_aranges, size 45684, link 0, flags 800, type=1
>     - fixing wrong alignment sh_addralign 16, expected 8
>    section(38) .debug_info, size 129104957, link 0, flags 800, type=1
>     - fixing wrong alignment sh_addralign 1, expected 8
>    section(39) .debug_abbrev, size 1152583, link 0, flags 800, type=1
>     - fixing wrong alignment sh_addralign 1, expected 8
>    section(40) .debug_line, size 7374522, link 0, flags 800, type=1
>     - fixing wrong alignment sh_addralign 1, expected 8
>    section(41) .debug_frame, size 702463, link 0, flags 800, type=1
>    section(42) .debug_str, size 1017571, link 0, flags 830, type=1
>     - fixing wrong alignment sh_addralign 1, expected 8
>    section(43) .debug_loc, size 3019453, link 0, flags 800, type=1
>     - fixing wrong alignment sh_addralign 1, expected 8
>    section(44) .debug_ranges, size 1744583, link 0, flags 800, type=1
>     - fixing wrong alignment sh_addralign 16, expected 8
>    section(45) .symtab, size 2955888, link 46, flags 0, type=2
>    section(46) .strtab, size 2613072, link 0, flags 0, type=3
>    ...
>    update ok for vmlinux
> 
> Another workaround is to disable compressed debug info data
> CONFIG_DEBUG_INFO_COMPRESSED kernel option.
> 
> Fixes: fbbb68de80a4 ("bpf: Add resolve_btfids tool to resolve BTF IDs in ELF object")
> Cc: Mark Wielaard <mjw@redhat.com>
> Cc: Nick Clifton <nickc@redhat.com>
> Reported-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>

Acked-by: Yonghong Song <yhs@fb.com>
