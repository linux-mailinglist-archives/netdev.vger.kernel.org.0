Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7C425FF2DA
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 19:17:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230089AbiJNRRV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 13:17:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229994AbiJNRRT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 13:17:19 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D1DD189821;
        Fri, 14 Oct 2022 10:17:18 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29EH7kiD006149;
        Fri, 14 Oct 2022 17:17:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=k9kBGVdlvVGTrQn/lIQlNRvlJ90TbOBIUYv1PM0u/VA=;
 b=QRMogGwbeajzQFH3Hre+sMlbMnRX7J2wTW3906CK0lt6QNHImQjS7y1707AuR1X+3MsQ
 6X2JTTu+aZq9StfWq8VsoqRdMvJWqGlYo/yAEFsKu1MskjY9zBMNh3+AO1zLOAsopD0G
 t10y0Wxpcwpb1aFZN074fbFH9m4cx8eeWuTleI0z72o6zUNMi+ZBdvsIbxUX/DpRKAHF
 Z3Hse+kDz9HKnlQAGjOE1uefJKHRJF9gm7GHPbNlWhlZTnFv2W0u44nvGsxkd6d5yimd
 F/QucRXWZIk/FNwQDZTcbhY1uurc5OpN9vzgXKaRp61CYnkj68bi2haj5WfxjXxTZq2Y jQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k7acvg9c9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Oct 2022 17:17:12 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29EH474a004045;
        Fri, 14 Oct 2022 17:17:12 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3k2yndy33k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Oct 2022 17:17:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yv1m6vIarCiVDvNVSFgva3CgEZepk+Xc03jFS/pmWnKmBeFG/QYQZdg3crr7gamACwO3ENKABhupvOx9NjYZZ16HPzvOTDeK773txDp/UgdoQmBpJW3+Ww6kpnUYyD8tV1Abiu2na/7ipMUMNGRs80Pso0MFlDGuvaTqNJG8+ZJ6DApSkcC9+VjNGutd5ywNUo4w3duLgsPJdov+yZ2a5RWaFACfbBV1vodwTeli/ZDx0jdhKGMw6wnqjB87gi5gB/eMlEa2uDg5poNqD5JJnaHBGgvLVJzJmCkYYbdUej9VvnUEZOCb7jVUit5e/X/Vct+v7RefO7xQb/kKWsVrdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k9kBGVdlvVGTrQn/lIQlNRvlJ90TbOBIUYv1PM0u/VA=;
 b=Zg3LYFGsqE1ZnU08KIAsMfwc5RHCvq/0O0UfYxSMkQAqXIqqGsdJ6nCrLc7pksRpimZ1FGwhcnNkBV7IwaUPegJq6oQf2X1O/v/5sK6Dy4mi6X7/L9SEqSSJN72X+RudjA6EheY7ZTQDzR/GanrkSrMKTGKCL6F/0m+kQB+HiM/MoTdSiOlp6Frd4lWQigCPxSb5YOsy6rtA1zulzWQ7ZihmGUNVbyngNIcoF/hhL50cXbgVA/fZu3ZPamQnoHN3r1IdhAwgZ51BXfz5X3hdPdm1NEdHscdh3314N330k3W2luC+7GTHx4teulDN4vnPg0zSwHvbx7QQsRkgWu13jQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k9kBGVdlvVGTrQn/lIQlNRvlJ90TbOBIUYv1PM0u/VA=;
 b=O7eS0a013BKULNuFF1p4J8c90kaB3s1up4dkgd/KQZyhNvnVB1eP6Tshdhb7OBNweBDsRDsTPFiZbSuRgYq4vvE1twdrAEjsH4wMJp7MVmexpuc2+ze+3C9MTSs0Dxc5roeGZw/rGIQJua6beu+kMQs8E3F008n8qs4t+cttF8E=
Received: from BLAPR10MB5267.namprd10.prod.outlook.com (2603:10b6:208:30e::22)
 by CO1PR10MB4451.namprd10.prod.outlook.com (2603:10b6:303:96::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.26; Fri, 14 Oct
 2022 17:17:09 +0000
Received: from BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::d327:4c14:61d:3efa]) by BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::d327:4c14:61d:3efa%7]) with mapi id 15.20.5723.029; Fri, 14 Oct 2022
 17:17:09 +0000
Subject: Re: WARN: multiple IDs found for 'nf_conn': 92168, 117897 - using
 92168
To:     Jiri Olsa <olsajiri@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        bpf@vger.kernel.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20221003214941.6f6ea10d@kernel.org> <YzvV0CFSi9KvXVlG@krava>
 <20221004072522.319cd826@kernel.org> <Yz1SSlzZQhVtl1oS@krava>
 <20221005084442.48cb27f1@kernel.org> <20221005091801.38cc8732@kernel.org>
 <Yz3kHX4hh8soRjGE@krava> <20221013080517.621b8d83@kernel.org>
 <Y0iNVwxTJmrddRuv@krava>
 <CAEf4Bzbow+8-f4rg2LRRRUD+=1wbv1MjpAh-P4=smUPtrzfZ3Q@mail.gmail.com>
 <Y0kF/radV0cg4JYk@krava>
From:   Alan Maguire <alan.maguire@oracle.com>
Message-ID: <d2007ba9-3c95-858d-7a73-df83de63fe5c@oracle.com>
Date:   Fri, 14 Oct 2022 18:17:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
In-Reply-To: <Y0kF/radV0cg4JYk@krava>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM3PR03CA0056.eurprd03.prod.outlook.com
 (2603:10a6:207:5::14) To BLAPR10MB5267.namprd10.prod.outlook.com
 (2603:10b6:208:30e::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5267:EE_|CO1PR10MB4451:EE_
X-MS-Office365-Filtering-Correlation-Id: 78dcb122-2799-4da1-12d8-08daae07ed03
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YFVJKUMwh9O5UdzuNIh92NUfXj5BOJ5n3X64Lj+72pKadMar4TVvjjKn5yxdwCBskmXlMKwsh4nj/N3v5SqYH/90SLSpBmWtE2GzEzYFTx7/FIfrOwGjJKozLsfET9cwF75GC/IBgWhb/TK9EvsHYsbv2XVlSxhQ8zzlq4JbWaYW2S0Q+RygaPEdBB4RhUvLPqQih3w7XoI/J94reEXMKl308Kad81NhDmAj17fu/AqaHkjk9CRxX/3rmkoXc9yBFZSQ2ntL+ysvxAeIQcjirnZNztIM4iIQ9458TuJrI0EebOnMTgdh3uI/UfCoRqnGMy/C4qdg6tp5I2ncwZhAmgnG/RAvKBUuUtpu5nH7sR1Ol0eeodwfpLJhLfgZnqWzOcSrPGHI6h19eE+CpyeICyWWd5SYE1ET6yXRQUn6AMXoZ8VOzCoUN+0NGN8XDbhwIqw5LcMf5o/7xw9iQcU00AQ+ra2wAYhkxR+QhJC76x0WIWjwcMzHXNBcnaTtGijBxHy32OjfjvhUten+ZsrTdQCsvfYNjvhn7xJajeEhOLszhLpbCmbIpuqNOt6De29JSMZahLDpAzuRAXzkonRNw5gh2DYia/MQxLfYQK7bOTAxlJZtdFdHjLUbsV3+EJ5fw3IaglP86KAYWW499ZVEFInO9hzre7nu6DWL4iWzISuqY5HLUbbJbQAA9ssXPkmpksRWiQGvwN9y6pwvXIns/t79ZOHiXbnGso3zdm1pKODI2mp+hCDvFmfoYRZZI3rM8bOO1buPMRwcWdtD3hDsUByOzhs8VYWzAxQXsOsEh8E=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5267.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(366004)(136003)(346002)(39860400002)(451199015)(36756003)(31686004)(44832011)(86362001)(31696002)(38100700002)(2906002)(5660300002)(186003)(2616005)(83380400001)(6506007)(478600001)(6486002)(6512007)(110136005)(54906003)(66556008)(66946007)(66476007)(53546011)(6666004)(4326008)(41300700001)(8936002)(316002)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d3NqZTJoUitzRTdMNkthdFo1UDlHYzNJMWszWkk5UWZNdElJYTVGTHNBWjBO?=
 =?utf-8?B?RlpYUUg2dW5OTDlzMzlOTU1la0p2U1c4Ky9Rdk5NR3BOSmo2ODJsa3U5YUFR?=
 =?utf-8?B?dFpWc1NMK3A2VEdoRlNRY2RKblZhUlNZTTE0azhUeDduQU1pOEkvMVdLZWhJ?=
 =?utf-8?B?NnhZOHVVZ211dWVmV09YQi9LL1g2STNQZUtnckNiWHc1OVQ2aWd1YjV1d2VB?=
 =?utf-8?B?SEpTaEt5N3dibW00NTFHb3lDbkZNY0tBQjZEVHJ3MlpldFFuUHZVMHdSYS9j?=
 =?utf-8?B?S3dGckpNTXF0QnhwZ09EWWxDRnF6cmFzOTU2UDRHQ1JkRVFZN1Z1YjVDZU9Q?=
 =?utf-8?B?cy9aQ05NbG1tVjdIR2JpVkx5dGN6M25aNEM2WWJhS2hDTnJIRWdpOXltNll2?=
 =?utf-8?B?UytnZCtWWmtNRzlqZ0lFZktMRC82bkxwUWlVMk44d2ZZcFJqUzNUWkthVlRk?=
 =?utf-8?B?bC92VGtWaFVXVzA4NTRFU1lscHF3NWVTemlpaU1ITE94MkU0bHNMVmgvakNk?=
 =?utf-8?B?MUQxMlVrUUlNZnNaWnZhN0FvSUZBZkZWU2dDT1FaeXJDVUplblloMW11eVNk?=
 =?utf-8?B?R0dFWUZTbktscEorUGZDWXBIRFhMN0JSRzQrVDErMkRpOGYzbG5YZ2M4bU8r?=
 =?utf-8?B?V0RDWDVrUncwdFVnb0FYZlFtcngrWWpJWU1oTDVKdEJsaHdNam84a2RrVjJI?=
 =?utf-8?B?dmp3UDcwd2h6UXgxWHl3Z25pYnZDSUd2WW9pQVB1cU9uV3loZ1RYWmRGSkRK?=
 =?utf-8?B?Z0t2ZHZ1bUp1eUIydkNxRk15VlcrWFNoY3dYSlFxWDFMaW13SEdsR2NCQ2Fa?=
 =?utf-8?B?M0ZwN3l0U1ZvS1RVSkpBV0IzTDdqRklwV3NPRzdKSFJHOUtFb3VFMjVyTmVx?=
 =?utf-8?B?cnd4dG9mdDN4U0RXY2g5RWVBMWJ3YzNwbEpGMk90SXJ6TkdwVk84d3dWWFBE?=
 =?utf-8?B?WlhONlJERUdZUHNmcnROU0t5WEw2b2c1dmRNcWl2cURsM0QyeU5haTVXWFQ2?=
 =?utf-8?B?MHEwMUZiZzlQbmQ2T0w5U3FiSnk4SWJUMTBSMXRzYkZ6bWxjaFAreUZGV1dD?=
 =?utf-8?B?anJhb1lESFo2dkcxSjZwcTdyT0xRNFlGOG1uTjZCVGVDKzA5aTkvZlIzRE5F?=
 =?utf-8?B?YXhpUjkxRjZxZHBrT1Q5WHU2elE3YTlhZXVCTm40OWU3QWw0Kzc5RkR1angy?=
 =?utf-8?B?MzRKbVpKZFdvc2syMTgxUTBEem15OXBpalVJM3NndTl5bkJxQ01mOGdGTmVy?=
 =?utf-8?B?V0ZnQ1RHeWxETmRFUTFlZWYwUEx0c0NPanRBL1pQdXFVeXQ0bS9lYlpzcGVC?=
 =?utf-8?B?SFB4OFZBMVN5cjNLamV2alk3M0JYY3lDWG1hNy9udWpHRnIzM2I2QjY3Mzlt?=
 =?utf-8?B?RUxsYS9CNzFCOHlRNElqOVl3dCtIbFg3emlsNVpEZjVrQUdoTXNaZzNjTjFh?=
 =?utf-8?B?MHRhMUwyaklKbXF3aGppY0IxSldwT3RtQ05NcFAzWjM3WlVsTUo2MUhRQU9p?=
 =?utf-8?B?R3cxcFVXVVF6RGcvV3o0R3dERXI3ejErRE40Z0hiSU9oL3N4N0grS1NMMGo3?=
 =?utf-8?B?MTFtOFhqWmlSSzNpMW1Fd2lScVJ6b1FkaWtreXgwM25TZ2JIR3V3ZnFoUFgz?=
 =?utf-8?B?dTRKenlZbGZWVjZkTkI4c2JSS0s1aFFyUFY4dVdjQmhrRitxaEp3TDZTS09P?=
 =?utf-8?B?VHlwTytWMzVDelVsQmQxWVNIOEtJTkhETWdZem13dkpLRUpFRHhLVEpZRWh4?=
 =?utf-8?B?aG9DNnFzeGFRVkRoOU0xQWFrUGxDWFJUTmhzRno2REI4MVUxWm5ZRGl2YTVJ?=
 =?utf-8?B?bk5vM1Y4dkU2cmJ2c0ROMGxXN3hMRFZPc2d1UmNKK2RzWHVCYlFpK2ZLb1RJ?=
 =?utf-8?B?cDU4ZFE2dVFCYzVOeU1kSW9kSmpjK1MzODIrL3RiSnhjai9aZlFMS0tubmRU?=
 =?utf-8?B?eXJBK0dhalN5NWRFaHpKMG5FRVE5T2Y3emNrQ29nT3QyZFpveTB6YldNNlFi?=
 =?utf-8?B?UE9hcWJlUENYdCtud2NPOHJOMU9oeDVnSnEvRU9Fc0haTnltTnN3amZreEYy?=
 =?utf-8?B?Zm5aSnhXZ3RFMjRqN1pIRk9nNkJRcFkzSXZjLzJrc0dlUkZrRThXZG42K0lj?=
 =?utf-8?B?VmthVVJ6N1krejRjdUw5bTQ2ek00UFhRMDBrMkpYM2FpMUFaYTJsNFUzSHlS?=
 =?utf-8?Q?TDn7tpO/wZy4bBUUODPkxoo=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78dcb122-2799-4da1-12d8-08daae07ed03
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5267.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2022 17:17:09.2158
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rj509X9lxEpA6QHWBjGK+Xm+80UzV56qzzkGah9FAzh/5/ypSwcgGt7cJwJa/FdeqoFfYGB83h8cmVhTAU1aXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4451
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-14_09,2022-10-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 adultscore=0 mlxscore=0 bulkscore=0 malwarescore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210140096
X-Proofpoint-GUID: jcX3SbKv8-CbqUCdSnj3AllgNDL--efk
X-Proofpoint-ORIG-GUID: jcX3SbKv8-CbqUCdSnj3AllgNDL--efk
X-Spam-Status: No, score=-5.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/10/2022 07:47, Jiri Olsa wrote:
> On Thu, Oct 13, 2022 at 03:24:59PM -0700, Andrii Nakryiko wrote:
>> On Thu, Oct 13, 2022 at 3:12 PM Jiri Olsa <olsajiri@gmail.com> wrote:
>>>
>>> On Thu, Oct 13, 2022 at 08:05:17AM -0700, Jakub Kicinski wrote:
>>>> On Wed, 5 Oct 2022 22:07:57 +0200 Jiri Olsa wrote:
>>>>>> Yeah, it's there on linux-next, too.
>>>>>>
>>>>>> Let me grab a fresh VM and try there. Maybe it's my system. Somehow.
>>>>>
>>>>> ok, I will look around what's the way to install that centos 8 thing
>>>>
>>>> Any luck?
>>>
>>> now BTFIDS warnings..
>>>
>>> I can see following on centos8 with gcc 8.5:
>>>
>>>           BTFIDS  vmlinux
>>>         WARN: multiple IDs found for 'task_struct': 300, 56614 - using 300
>>>         WARN: multiple IDs found for 'file': 540, 56649 - using 540
>>>         WARN: multiple IDs found for 'vm_area_struct': 549, 56652 - using 549
>>>         WARN: multiple IDs found for 'seq_file': 953, 56690 - using 953
>>>         WARN: multiple IDs found for 'inode': 1132, 56966 - using 1132
>>>         WARN: multiple IDs found for 'path': 1164, 56995 - using 1164
>>>         WARN: multiple IDs found for 'task_struct': 300, 61905 - using 300
>>>         WARN: multiple IDs found for 'file': 540, 61943 - using 540
>>>         WARN: multiple IDs found for 'vm_area_struct': 549, 61946 - using 549
>>>         WARN: multiple IDs found for 'inode': 1132, 62029 - using 1132
>>>         WARN: multiple IDs found for 'path': 1164, 62058 - using 1164
>>>         WARN: multiple IDs found for 'cgroup': 1190, 62067 - using 1190
>>>         WARN: multiple IDs found for 'seq_file': 953, 62253 - using 953
>>>         WARN: multiple IDs found for 'sock': 7960, 62374 - using 7960
>>>         WARN: multiple IDs found for 'sk_buff': 1876, 62485 - using 1876
>>>         WARN: multiple IDs found for 'bpf_prog': 6094, 62542 - using 6094
>>>         WARN: multiple IDs found for 'socket': 7993, 62545 - using 7993
>>>         WARN: multiple IDs found for 'xdp_buff': 6191, 62836 - using 6191
>>>         WARN: multiple IDs found for 'sock_common': 8164, 63152 - using 8164
>>>         WARN: multiple IDs found for 'request_sock': 17296, 63204 - using 17296
>>>         WARN: multiple IDs found for 'inet_request_sock': 36292, 63222 - using 36292
>>>         WARN: multiple IDs found for 'inet_sock': 32700, 63225 - using 32700
>>>         WARN: multiple IDs found for 'inet_connection_sock': 33944, 63240 - using 33944
>>>         WARN: multiple IDs found for 'tcp_request_sock': 36299, 63260 - using 36299
>>>         WARN: multiple IDs found for 'tcp_sock': 33969, 63264 - using 33969
>>>         WARN: multiple IDs found for 'bpf_map': 6623, 63343 - using 6623
>>>
>>> I'll need to check on that..
>>>
>>> and I just actually saw the 'nf_conn' warning on linux-next/master with
>>> latest fedora/gcc-12:
>>>
>>>           BTF [M] net/netfilter/nf_nat.ko
>>>         WARN: multiple IDs found for 'nf_conn': 106518, 120156 - using 106518
>>>         WARN: multiple IDs found for 'nf_conn': 106518, 121853 - using 106518
>>>         WARN: multiple IDs found for 'nf_conn': 106518, 123126 - using 106518
>>>         WARN: multiple IDs found for 'nf_conn': 106518, 124537 - using 106518
>>>         WARN: multiple IDs found for 'nf_conn': 106518, 126442 - using 106518
>>>         WARN: multiple IDs found for 'nf_conn': 106518, 128256 - using 106518
>>>           LD [M]  net/netfilter/nf_nat_tftp.ko
>>>
>>> looks like maybe dedup missed this struct for some reason
>>>
>>> nf_conn dump from module:
>>>
>>>         [120155] PTR '(anon)' type_id=120156
>>>         [120156] STRUCT 'nf_conn' size=320 vlen=14
>>>                 'ct_general' type_id=105882 bits_offset=0
>>>                 'lock' type_id=180 bits_offset=64
>>>                 'timeout' type_id=113 bits_offset=640
>>>                 'zone' type_id=106520 bits_offset=672
>>>                 'tuplehash' type_id=106533 bits_offset=704
>>>                 'status' type_id=1 bits_offset=1600
>>>                 'ct_net' type_id=3215 bits_offset=1664
>>>                 'nat_bysource' type_id=139 bits_offset=1728
>>>                 '__nfct_init_offset' type_id=949 bits_offset=1856
>>>                 'master' type_id=120155 bits_offset=1856
>>>                 'mark' type_id=106351 bits_offset=1920
>>>                 'secmark' type_id=106351 bits_offset=1952
>>>                 'ext' type_id=106536 bits_offset=1984
>>>                 'proto' type_id=106532 bits_offset=2048
>>>
>>> nf_conn dump from vmlinux:
>>>
>>>         [106517] PTR '(anon)' type_id=106518
>>>         [106518] STRUCT 'nf_conn' size=320 vlen=14
>>>                 'ct_general' type_id=105882 bits_offset=0
>>>                 'lock' type_id=180 bits_offset=64
>>>                 'timeout' type_id=113 bits_offset=640
>>>                 'zone' type_id=106520 bits_offset=672
>>>                 'tuplehash' type_id=106533 bits_offset=704
>>>                 'status' type_id=1 bits_offset=1600
>>>                 'ct_net' type_id=3215 bits_offset=1664
>>>                 'nat_bysource' type_id=139 bits_offset=1728
>>>                 '__nfct_init_offset' type_id=949 bits_offset=1856
>>>                 'master' type_id=106517 bits_offset=1856
>>>                 'mark' type_id=106351 bits_offset=1920
>>>                 'secmark' type_id=106351 bits_offset=1952
>>>                 'ext' type_id=106536 bits_offset=1984
>>>                 'proto' type_id=106532 bits_offset=2048
>>>
>>> look identical.. Andrii, any idea?
>>
>> I'm pretty sure they are not identical. There is somewhere a STRUCT vs
>> FWD difference. We had a similar discussion recently with Alan
>> Maguire.
>>
>>>                 'master' type_id=120155 bits_offset=1856
>>
>> vs
>>
>>>                 'master' type_id=106517 bits_offset=1856
> 
> master is pointer to same 'nf_conn' object, and rest of the ids are same
> 
> jirka
> 

I tried digging into this problem a bit - in my case I was seeing 
"struct sk_buff" duplicated in kernel/module BTF. Here's what I found..

Consider a situation like this, where one header file defining a struct s1
has a pointer field, pointing at struct s2. But struct s2 is a fwd definition.

$ cat s1.h
#include <stdio.h>
struct s2;

struct s1 {
        struct s1 *f1;
        struct s2 *f2;
};

$ cat s1.c
#include "s1.h"

int main(int argc, char *argv[])
{
        struct s1 s1;

        return 0;
}

Now consider a separate program s2, that #includes definitions for both
s1 and s2:

$ cat s2.h
#include <stdio.h>

struct s1;

struct s2 {
        struct s1 *f1;
};

$cat s2.c

#include "s2.h"
#include "s1.h"

int main(int argc, char *argv[])
{
	struct s1 s1 = {};
	struct s2 s2 = {};

	return 0;

}

In this case the generated base BTF contains a definition for s1,
and a FWD for s2, but the "module" BTF for s2 contains a full
definition for s2, so the dedup fails:
 
$ bpftool btf dump file s1
[29] STRUCT 's1' size=16 vlen=2
	'f1' type_id=30 bits_offset=0
	'f2' type_id=32 bits_offset=64
[30] PTR '(anon)' type_id=29
[31] FWD 's2' fwd_kind=struct

$ bpftool btf dump -B s1 file s2
[36] STRUCT 's2' size=8 vlen=1
	'f1' type_id=38 bits_offset=0
[37] STRUCT 's1' size=16 vlen=2
	'f1' type_id=38 bits_offset=0
	'f2' type_id=39 bits_offset=64
[38] PTR '(anon)' type_id=37
[39] PTR '(anon)' type_id=36


So we had to redefine struct s1 in the "module" because the
FWD wasn't resolved in the base BTF. This is by design as I
understand it; in effect we can't supplement base BTF with 
info we've gotten from module BTF about forward resolution
(at least that's my understanding of the reason).

Now does this sort of thing happen in the kernel? It looks like 
it; consider struct nf_conn; it contains a possible_net_t:

typedef struct {
	struct net *               net;                  /*     0     8 */

	/* size: 8, cachelines: 1, members: 1 */
	/* last cacheline: 8 bytes */
} possible_net_t;

...and a struct net * contains pointers to structures
that aren't in the vmlinux BTF (because they are
in modules); for example:

	struct netns_ipvs *        ipvs;                 /*  3912     8 */

$ pahole netns_ipvs
pahole: type 'netns_ipvs' not found

...and in vmlinux BTF it is:

[2983] FWD 'netns_ipvs' fwd_kind=struct
[2984] PTR '(anon)' type_id=2983

...and in struct net we can see the fwd type is referenced alright:

[2021] STRUCT 'net' size=4288 vlen=52
...
        'ipvs' type_id=2984 bits_offset=31808

So we'd expect any ipvs-related modules to not dedup
struct net, since they'll have the full definition
for netns_ipvs. In xt_ipvs.ko we see:

[111924] STRUCT 'netns_ipvs' size=2176 vlen=78
        'gen' type_id=21 bits_offset=0
        'enable' type_id=21 bits_offset=32
        'rs_table' type_id=4044 bits_offset=64
        'app_list' type_id=83 bits_offset=1088

...and when we look at 'struct net' we see:

[111786] STRUCT 'net' size=4288 vlen=52
...
     'ipvs' type_id=111925 bits_offset=31808

And then if we don't dedup struct net, it seems likely
that structures referencing struct net (like skbs,
nf_conn etc) won't dedup either since they'll point
at "their" version of struct net.
	
Not sure if that's the root cause here, but it seems
like it is happening in other modules at least.

More subtle effects are also possible I think; if a type
is in a header file is defined but not referenced anywhere
(as might well happen for a module-related type in vmlinux),
it might not always make it into the DWARF description,
and as a result of that might not have a BTF
representation.

Alan
