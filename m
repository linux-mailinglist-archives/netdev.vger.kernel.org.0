Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 868C82F5891
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 04:02:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727211AbhANCly (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 21:41:54 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:11418 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726612AbhANClr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 21:41:47 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10E0OeKm000406;
        Wed, 13 Jan 2021 16:50:05 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : references
 : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=9jAfBnyRiJ1NqwlagwlVGKuPY6hZ308Gf8XgYW385lU=;
 b=i+k56pSr6R3fFT3fLBYioRmgE/9h89eCMO4l5QX7UEuB7Qbi2QGXrto/4TKgg4de+MI9
 CkrZQtdA6038vWuYYLWq4DJ4/IJqUU9y+qL0jJd7Bi49PJGEwcJoMMajiFEUwH1Tnliw
 Zx9fvFAROUE74ji4YRFpw49/AogSRNlNRD8= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 361fpjg9hm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 13 Jan 2021 16:50:05 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 13 Jan 2021 16:50:03 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V1VAyuvvCor6x6lxmDFCYTPP/h0rJfzHl7bMDxApyQvMURNYwo3o1a82y2Z+uEVL6vN+MQgCT4a1ZYgUJ1Pw6coq7fz1TTp3eDsUbaHYx8hn+iJ1SuYxfi0FdzqCQL8Pd1a2fMGnZcic7YxdmEN3rK19BUXBFaNiOsAG+Fs6ikAwn86XphL56YwHOlLLgw/yLEoxgyD1WKj0B/Y2NUnVvtax1ZAsbJ3yEw/ojzNgZ4q1SqLN3q0lHzd4NhkVMkyJYnN1LTskFUT/vbA0TbqD9Y//P44k6qsrjV3vtiIuoOY7+pSIg4AJN/7UDoYGtZWBw4dVY3Wf58ZL8gm8XbSDVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9jAfBnyRiJ1NqwlagwlVGKuPY6hZ308Gf8XgYW385lU=;
 b=cc/uXWxpBGq6+/M6NyX04sTwP6bK8EJiwAE00JXID0/m9sOOJWIVllYB1L7NAOeSdOto9s3pyzVLPaie0cUx7Nld4WepJlIe2cAT4PM3mw15oJ3UxvxQq2BMeAOLoYbyn/egm3HvDmP6ao8ApqexKuKeSdLgelg4kqNO1s0CXRSzrq6gSBwFNuHSFtIbpRGd666a9sDM2Npkb3Zc6BVEq/LpQwIffpNVZG0RcGKAYOvRz62gpJUnuJnvc9K041W0iIYVu5tbfcwF0Mpi8SX1pzC4FH1+L4Kx4t08+g5KuHzhwXXDXcq5mV52xwTUcz/iFSsSbwZz2p1kHLtsrkiCrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9jAfBnyRiJ1NqwlagwlVGKuPY6hZ308Gf8XgYW385lU=;
 b=f8NC+ROJbbLHy+UGZrfRF1VCg/8RcLtSYNz+V3J1/iRxOgbzO2subTWusxRk91wPIZ+FACHjFEyfIFdKvaD4Qc+SfGHFxiTIf4URIy9eHfZEckcNaPDkCck3Ov6j0HFCWX7aljjQTj/y1uIOTx8UWkJsW17IB39cVDjX0PUJzKM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2263.namprd15.prod.outlook.com (2603:10b6:a02:87::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.11; Thu, 14 Jan
 2021 00:50:02 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03%7]) with mapi id 15.20.3742.012; Thu, 14 Jan 2021
 00:50:02 +0000
Subject: Re: [PATCH 2/2] tools/bpftool: Add -Wall when building BPF programs
To:     Ian Rogers <irogers@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Tobias Klauser <tklauser@distanz.ch>,
        Ilya Leoshkevich <iii@linux.ibm.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20210113223609.3358812-1-irogers@google.com>
 <20210113223609.3358812-2-irogers@google.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <634b8800-a0cc-d3fd-bc36-bd36162f40ac@fb.com>
Date:   Wed, 13 Jan 2021 16:49:59 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
In-Reply-To: <20210113223609.3358812-2-irogers@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:bbd5]
X-ClientProxiedBy: MW4PR04CA0234.namprd04.prod.outlook.com
 (2603:10b6:303:87::29) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e1::13f6] (2620:10d:c090:400::5:bbd5) by MW4PR04CA0234.namprd04.prod.outlook.com (2603:10b6:303:87::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.11 via Frontend Transport; Thu, 14 Jan 2021 00:50:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: db61bbdd-173d-40fd-2e1f-08d8b82653dd
X-MS-TrafficTypeDiagnostic: BYAPR15MB2263:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB22631DD79C0B676D15A7C2E8D3A80@BYAPR15MB2263.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:546;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FrjVDCLN20SrL3D5VELsaJ576W8BQIZ/PBtTtBNM2ApouD4NrLsN+Szk+E9iiAw5JLh2C4HaD7e7FnpTJHjgVuYwd7Bm96rNo4uavNCvEw19P5Fp7WE8qEPsHMwwBJESmJqWZyDAkqaSMlWW6I4hFQPPF7g/iwy1qLds9Jr3MA4WPKehsXd2JshwvilWyLgCkyOFDD8XSQmjsNvXk8hHNn6APFeQ3EqA2oDleBO8AfCvDS3JoHD5OQthQl0EClAMeaJKPmp6VctgohJIYGKCl/8W/gsQUNpr0K/YD7m+KP97j1ubs9z1bxkpfJrgOkSyTNpHwAnbudWd6VWRwQtPgbcBtTNMWSCK7Uj8yDMClFnWNVpsruh94duWhIyYUJfx+dRIbWBWiIQPq6uiA2WtJE/vz6si+PbF98exq8xKOW0NZ3RI2u8KHAqK2c6M9qXDh6ShAYrnk1WEuFOanrYHpACefjNdZ4ek9nUHNRhsBEYvJgb2Cvl9spM4eGfQVjWz
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(366004)(136003)(376002)(39860400002)(2616005)(8676002)(52116002)(31696002)(31686004)(110136005)(66476007)(5660300002)(16526019)(2906002)(83380400001)(36756003)(558084003)(6486002)(7416002)(66946007)(478600001)(86362001)(921005)(316002)(53546011)(66556008)(8936002)(186003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?eENnRHU1bWg4UzFuM3VhcGJrQ08xRll0OFJxTHBPUDEzd0NwazNUVjN2TTFn?=
 =?utf-8?B?Y3cydkxPd3BKZStyUDZoTHJUekkyNVMyY01QVmhoR05NOFZIUjVSUlV5M2o0?=
 =?utf-8?B?dmN0dDl6K2drRksxTEgyLzh1ZGNpRlRxY2Z3YVVtTWRMRng4YlZOL0xkQzVp?=
 =?utf-8?B?MW9LYjVjV1MvOTJtQUJkdUs4U0dySGJQZThISzBpN3RLU1ladkVJTHpscUVo?=
 =?utf-8?B?VFJOUUVaN3h2UklPOGhmSUZNUEFuU0haSmJyRXVVSUZFVFoyVU15V09jZGIr?=
 =?utf-8?B?OWZ2aHhheE41OUU1NkhhZ3dTNGplVzE1QWRiN3JlMGdRaXVyZVEwSHNhQzhR?=
 =?utf-8?B?SGwyOG84MDdEZHl5TUZoYncrSDBWL3NsQzZKM0tQdCtGQ2loNVVTVTk2VUdW?=
 =?utf-8?B?Zkc3TFkvS2RvNWFydGovYzBucFk2SGttMW1CdHkzMm94cHBFNWwwOVd6T0xm?=
 =?utf-8?B?YVVES1ZiWVZ0aEVBeExNZ1BxRGNhQ2syVXJGTjgrK3MzSUFyMklDYmlEdVcz?=
 =?utf-8?B?TXVIWHRiVGtuSDdtRFZobFl4VEFiQlNHQmlKVHZWcEZrUE0xdDMzYXZReU9P?=
 =?utf-8?B?bXowVHBFbkZGTmJiaUZQYkdZTktWNVR0MlpZcUFjWmFsZUp2NlpvK2ZlNkZX?=
 =?utf-8?B?M0QrQVhqRm14Q1NCQWxEU3RSVGV3YkdpMWtvQitlcHI3NHpyOEtaZlhSMkFJ?=
 =?utf-8?B?SlpWZjg1cEtWRzhyWXlhU21ZOXlUMzlJWmU2K0NpNUtsMkFWZ3JDS2VQZWxo?=
 =?utf-8?B?c0ZaTzdkNFdGYlJZWjJ4bTNRbFFXWTBaZVBqdnl2WDJBbTZScUFiSHJURFVH?=
 =?utf-8?B?R0FvKy9PK3p0bHgyYWIra3BpdkxiZVdJRU5sbHZwM1Z0L3RQZGtFcmFKWklQ?=
 =?utf-8?B?bjVtV1Q4QjZwUXRDM0FQOVF2aTF3aXVTT0xvR0g0T0tYbmtnS2J1R29BMlVM?=
 =?utf-8?B?TmlNZXhlR3MyVTBtSHZuSVp2WXQzbXdiT2FHd3YwUHMwZHNWZGdQUkFSYXI3?=
 =?utf-8?B?aFJZR2ZSTTd2czhpV2RZdG9kQjh5YWJXTU1na0UxQlM0Z3pnT0NUdTNPKzRU?=
 =?utf-8?B?bnNsQnlpczhEbjZ6Q3c2WnEreUZjWHpjeXZzcTJNQXZ2a0tZUXpZc2lhMGl5?=
 =?utf-8?B?ZGlGei92K3lMM2R1WWJ5MTNHbTVTOEN1aXEydlNqUlZQY0hwY2o5Tkt4SnQx?=
 =?utf-8?B?ZFJHcnkzbW1CcnBpb0N5VU9rME1aZis3NURqeExWYUdpUkxwYUxnYmZCdGNw?=
 =?utf-8?B?bVVVamtMTWlCc3IvSDI2VzhCdWVKVWY3ajdZTU9QZlVEOUhMOVhVYkFyYm10?=
 =?utf-8?B?WmtRSTByNXd6dVEwVVFybjJ5N3UyVkhvYVpGMFhkOC9VZnEyQ3cwMHhXVXgr?=
 =?utf-8?B?T0FFMXk4OGw5d1E9PQ==?=
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2021 00:50:02.7098
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: db61bbdd-173d-40fd-2e1f-08d8b82653dd
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xBoOs+3tjn3VbpENmDJxMej5icmChYlfw0mHzzwnUoJlMSOh+6XXfgTRiiroj/3/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2263
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-13_14:2021-01-13,2021-01-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 lowpriorityscore=0 phishscore=0 clxscore=1015 adultscore=0 spamscore=0
 priorityscore=1501 mlxscore=0 suspectscore=0 mlxlogscore=879
 impostorscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2101140000
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/13/21 2:36 PM, Ian Rogers wrote:
> No additional warnings are generated by enabling this, but having it
> enabled will help avoid regressions.
> 
> Signed-off-by: Ian Rogers <irogers@google.com>

Acked-by: Yonghong Song <yhs@fb.com>
