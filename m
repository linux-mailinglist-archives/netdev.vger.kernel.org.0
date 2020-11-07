Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BFB12AA75E
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 19:09:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728555AbgKGSJg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 13:09:36 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:2626 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726333AbgKGSJg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Nov 2020 13:09:36 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 0A7I8rif008493;
        Sat, 7 Nov 2020 10:08:53 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : references
 : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=TwqZxM++hfBd73X1KRRlxvntiJFNd3xpmL+Pi1QahRk=;
 b=V4eBkDLveg2EcTOb+S6i12LakWRt1CayP/HQzyl3NanGZALChmMU1d2XDlegAtQ/oTTd
 l7rM7V0gQUx3BKFnTEQc1vM6XiYNNaBCigqCjqlz1VbUT8c9mgn3gVwW0ELMSQ58D2fA
 +c6BmdgD/JiHxYz+U/l3hWMMRDmNnBzpWmM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 34nr4phcj3-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sat, 07 Nov 2020 10:08:53 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sat, 7 Nov 2020 10:08:48 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H7PM8jk/oaVdAVZg7zdeRiCcCoX0oourRaITPZV//05IIlHr0bz9Ft+Q1JLh20aZEBeAyhDZ+AUVingSdR4Vls+lkaO+CzIN+sb7rOB83xmTT2ahVAnHJbYSDgqZeY0k6CgWDwrqa/41JFXUizEY+/RlpXYrhVPOegkW8EXViT8EGeGqTTqp0kCZRuQ2l3gfpeU7LhJQIkzHqOlmbkhHgubDDG9N0Nk6gSPt3lxCSOmFaKW9u4dyStBSlJz87jKdVj1L3kgow+2cOP2ZvNdax40hTFeq7T7tiHJ1MLOmMntWy86GCN6apuaNOEj0nkFMKCMGyraDyb4fVseNOyMAjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TwqZxM++hfBd73X1KRRlxvntiJFNd3xpmL+Pi1QahRk=;
 b=iWdMqjBXlLsp4tMcvrEjynW/TWcz7tcoS1sgSrxi0cWQzWnD4kuMjJWk08Yqea32e3vR33yVsqevz+HivxYd6acpGObhRFcCz1TP5jvVftI3kDM8pwowBPtcyFQP2c6NxJ/AxsHjbWfhP/EryKkk+qzQpZhGMmeCb0GT4fbUM2vzXCC4FOd3uyBkrDUOE//aLM3BpfhgpUzKBJXcFO4QfvdaMjo4CZs4gkyYu8ADMI98uAyrg2EPPnHf1vZTMfI6nQgcuzlTIlzHl7/qfONe8T5/fCOqUY++HAWOKT5FiyYFhmpgpC238SDKO1XIaEFlrsT4ijdXVN44YwA3bMkxBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TwqZxM++hfBd73X1KRRlxvntiJFNd3xpmL+Pi1QahRk=;
 b=Cdsh4AnHNwTRFK6OdqrqVRO2SkwcXGOUhcwCSI85MlQV8syu3UPObYnwZ2bV1ZOtXXSgM+cWE4LbUw8txMLM2T2+kcW1tsGqsArjEAGJ7SYSaEtqwF7loYflm/dlYbxYf1EM9B7jylP+pQ0wC/JTedow94EBawqbDSWi9t//8As=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by SJ0PR15MB4204.namprd15.prod.outlook.com (2603:10b6:a03:2c8::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.29; Sat, 7 Nov
 2020 18:08:47 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8887:dd68:f497:ea42]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8887:dd68:f497:ea42%3]) with mapi id 15.20.3541.021; Sat, 7 Nov 2020
 18:08:47 +0000
Subject: Re: [PATCH v3 bpf] trace: bpf: Fix passing zero to PTR_ERR()
To:     Wang Qing <wangqing@vivo.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <1604735144-686-1-git-send-email-wangqing@vivo.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <60774a8b-32a5-354d-88d5-cf86be19d51c@fb.com>
Date:   Sat, 7 Nov 2020 10:08:43 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
In-Reply-To: <1604735144-686-1-git-send-email-wangqing@vivo.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:4dfc]
X-ClientProxiedBy: MWHPR1201CA0006.namprd12.prod.outlook.com
 (2603:10b6:301:4a::16) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e1::10a6] (2620:10d:c090:400::5:4dfc) by MWHPR1201CA0006.namprd12.prod.outlook.com (2603:10b6:301:4a::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.19 via Frontend Transport; Sat, 7 Nov 2020 18:08:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b15d04e4-f661-4b43-bcfa-08d883482bbc
X-MS-TrafficTypeDiagnostic: SJ0PR15MB4204:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SJ0PR15MB4204F90B1F604551CF70A6F1D3EC0@SJ0PR15MB4204.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:361;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pst24rQbt6gwKx0CIg4r0hyl8T5RhPvZQX0oDmRcWHGa3YKbcr3EYRKqJxRQELRSbiUVFMluTJhdLdGMBGdMBsUH+FezAT4ou3n6OVIy3lecaocqYZ4BoQizRJHlNJUMXsBp3WwIYLGO5D7qXho0iVuUvqzihRE+IaHm2z85Yp0xWtHyN5U1HqviZUTNq3AsXyxhbivsuQmeQ3HcUhtKezVtIqItfkR2vCMHr6Er4ZWgjf2zzt3EHCS0H/D80wQdrz/FXzdBUeT2tV/WQGd805jSJ4zvK7qT2ShRbdVxIGNPXE0WfBCM/nnD3oi+wSLkPooHE4m1T1WTyNh9MP4B8xkNk3AAOg7moYKbmDk7wRKhehnucj4SCGp/PPcN7fYgdSDteTHvazw96oihejPpsg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(376002)(136003)(396003)(39860400002)(6486002)(2616005)(478600001)(53546011)(16526019)(66556008)(66476007)(66946007)(36756003)(5660300002)(86362001)(8676002)(110136005)(186003)(7416002)(8936002)(2906002)(52116002)(31696002)(316002)(558084003)(31686004)(921003)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: X4ZIKEZtNGZxJbbIugG/joPhEo0h8xbNzJ8emWVxOdDw3j9Y5vVk9eCWT/Fw150q0xPmia0Uyx7CqiatK2FE9N+rUkRkRWbJpXw9xsdLCk/AXVUnFZGKtDhBDC2+KRiYaDN24xS/BgqR2Cln5g2NIwK7NoyLLGBFh8lYmYodCqXs7anPkDspUogsf0nIovLriwxtUqttl5DTgFjkMI+hAhK+1idGjpZUTOGJrTSeWkItjetlAs80wGWJFX61EYSvboMjYNKiLR8OGwJ/5JqzI6KAG5W57lMCEZIihAJSOYepUjNAeTEmxhr+rJbQbOE0k9F+fdPsNsmtqx89OLo4TUqc9vCR6j1gezUXxFriPGVORG7bQrTrNGpWranr/Pby8e5nm9huhiTaRXRz/hm9jQs7f6Id3BF1V04TPUCiruOgIzMrJSXtAI8mt1pyqspLnoGUWr/XcXxR8ZB2pe8DcTpCDAlzFUdirhJYHxNOsUG/ZjEJiTQveY+J6L3ycUwWrZHl5OixTQPfhAN2wyK/KqGxNZpx1scQZkMLqufYY7q9BCiA0pdTGuEQwu92XeJ1yP2SOC5/Pgl6CLqUM3m76jXYBDJqxFVmh/yJ6zNhLEH2sw4YDHkPry2THF/V6rvmVv18AUvF/sUuI9GbtqUgRbaEvladiXkMXkNREgEGqE+e540wpibqx0PFG9bPStzu
X-MS-Exchange-CrossTenant-Network-Message-Id: b15d04e4-f661-4b43-bcfa-08d883482bbc
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2020 18:08:47.3125
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nPEGkhQkZA2XBzXjZXujws8KzFeLjTcrX/ZuNXz+FLH8CheTDrbfBlbhAEj+87bF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB4204
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-07_09:2020-11-05,2020-11-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 malwarescore=0 mlxlogscore=889 spamscore=0 suspectscore=0 mlxscore=0
 bulkscore=0 phishscore=0 clxscore=1015 impostorscore=0 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011070132
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/6/20 11:45 PM, Wang Qing wrote:
> There is a bug when passing zero to PTR_ERR() and return.
> Fix smatch err.
> 
> Signed-off-by: Wang Qing <wangqing@vivo.com>

Acked-by: Yonghong Song <yhs@fb.com>
