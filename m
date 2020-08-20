Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB99124C06A
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 16:18:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726911AbgHTOSK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 10:18:10 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:54582 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726431AbgHTOSH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 10:18:07 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07KE9YaV010838;
        Thu, 20 Aug 2020 07:17:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=mqUGaJ5F22kc08JKHM57LPjSM1W/OU9OBaDuckxy62A=;
 b=m4LQoNLLFqEhrA9+p5X3q5ML62Q3FxSq6H2iowIk9n51Cje2+aKxqE7MAolyL7kD0C6p
 TJRBJ31FRmuyeELrZqY8Rr9488kN89924wzZoUJ7t+zr8dwm/tSM80cmn7n9evmxrIDG
 qGpeVvlUH50xqsNGIn/hOb8n4mOurau5UmQ= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 331crbbf88-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 20 Aug 2020 07:17:54 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 20 Aug 2020 07:17:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dyleKk7tRAYFmC/T+OC7uwLW6o22O45Gz5mX59Xgtf6eT71WfyKg3YQqDFIr4R95X1Nf/W2a7/H7GNTnqQWuOKKxGraQQh26/J8XQqX7lZl1Vju5XERsJW3+5a0znIfy1KaHrVn7XQqHtQEHSv0m5FAvYUdLms6GYJbWimID0cwsVSC2++BvYLl4nu+ZEsRhWC865g4EMCfTmtwbEYs5SFG86G50lLpBUu33P5mX1DttQGV0LcVKvfVDbM6vAbZiIjMAiaD8/QXVRGxy3zGmoUJEmJ8QAGO/gApyuqzlgNYY5a2J2Y/YcywIBqwrK//EcnnqSsNgyHjM2rL5Zo/EPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mqUGaJ5F22kc08JKHM57LPjSM1W/OU9OBaDuckxy62A=;
 b=S8g5m39VXqI+yOzxmDGyvqgV/aq21TmA9Q1Uu57hJFqJihUT6W2gUOrY+EMILLFtgrAb/+DYn9SV2H84ujvrO0qMrOWxTDvAmV1Zko19cyxRUFzjjYs3MfHfhuk5FX/oCpPGPKg3VtjxA3+aaBESJqnyuGwG7z4/SkcYmz1kJDTULVoPja2jIgGl+xC0Hv7pkQZ6w7CmehhUNN+wjsRpMcunBLULbepJrnz2dAUXm1rTQlbCDdVYt1T0uHYNaWN2O4VSd+jIUrJkMQPpj7eMboE/HGjlAMiug47qRbh7msZ3NzDtVK5BLN9lIDqn4IPODuJXiQdkdRrtID2eyM1tww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mqUGaJ5F22kc08JKHM57LPjSM1W/OU9OBaDuckxy62A=;
 b=EgXUFtO1BFH4vliKGJkbhB2szMOmk2Bm1LF+0O+kwfUJxFERK7rhsX/eQQCbbRhi3FVJNjrJnJO39M9cEosOChJbt0RkKb+CTUhNsvtU27sx4R0T0c3ouQD14/NI1Ag983tBafZbdgM1WTTv9AxKH1FhbtDfZjkKQf5+HDPx9dg=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2648.namprd15.prod.outlook.com (2603:10b6:a03:150::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.25; Thu, 20 Aug
 2020 14:17:53 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80%7]) with mapi id 15.20.3305.026; Thu, 20 Aug 2020
 14:17:53 +0000
Subject: Re: [PATCH bpf-next 1/4] libbpf: fix detection of BPF helper call
 instruction
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>
References: <20200820061411.1755905-1-andriin@fb.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <2801a3a2-81a3-c3a9-9e9c-3fc5153334b1@fb.com>
Date:   Thu, 20 Aug 2020 07:17:48 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
In-Reply-To: <20200820061411.1755905-1-andriin@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR0102CA0072.prod.exchangelabs.com
 (2603:10b6:208:25::49) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by BL0PR0102CA0072.prod.exchangelabs.com (2603:10b6:208:25::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.25 via Frontend Transport; Thu, 20 Aug 2020 14:17:51 +0000
X-Originating-IP: [2620:10d:c091:480::1:7ec1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 70c7b74e-a3d3-4085-1709-08d84513d360
X-MS-TrafficTypeDiagnostic: BYAPR15MB2648:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2648DBF294106C42DE81A1A6D35A0@BYAPR15MB2648.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:2512;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ILIR/9NVd3yTPWJLttaGH5krIJRASdy2BlX7uXTAoqVgtvTjgLCqnQijvdqABi+OxZBHkVMTNXwE+7b54ts9SKyPp/HLQ2BoZcdjkRbDVB7J79PUF4i4Y6Lh8TFq6kaPUtT7NCKvocRbX1f2jDG39JR+w02T8WaT4D3g4ZIn2kbL+TF1ee2+0oKPXXM8/SWPsK3JWZG9YVjem5TcOS7sac5RkL4Z15J03JrkjA23pRBT6enhk30JzCoZbUYLXwcOe5X39SAK3TIzthy1/XyTyH+qKF/GAbXYkdSYwJObJ8oRomC9F+g9S+qHCz3bPR5l19zzESB/7B33E+3sfe6NM1RAu/XDDHqDftCK82ulIe8EHtvhCYmFYL5B1HOHR7BDfUEz3gvCKZ5kal6cTHy0YX8QvcL+aS8h1VTOciT/uTM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(346002)(396003)(39860400002)(376002)(6486002)(4326008)(2906002)(8936002)(8676002)(316002)(83380400001)(31686004)(6666004)(110011004)(4744005)(5660300002)(52116002)(66476007)(66946007)(66556008)(186003)(31696002)(16576012)(478600001)(2616005)(36756003)(86362001)(53546011)(956004)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: RC6ybLYcXY/sMhXo+caOUnhNOdjOncPHWyJPwtHyUfjbgYUWtH5R4X8qmQKhxcWn2VZooNK1rD+kRA+sqsnZnmKR0QHfZ+6R19ai/qplon8YyvVjnvbO71DWAmWuQJY3kd39Ylp6E5xg253rlaOB59gW4cLiQeUelN+jA8hhEpl5Or7MlT5nZJe6bnTuI+AWkej8rxreSdcPSUUfVjNHl51gFOMABN5X6Yz1ON2CUm5OEqYN+0zmh1tiVx22EnSvpArC8RaWp2g6Jhpf1I69Qo8oaxqGov2Yi3nZWITMMu+3sjdmjzEdr8rdynD3sWYSehpXxTzH3UnPYknNiNLzdSpsfl1mmavggHrA+UwPHhf0u6J+C+wl46/NvHp3c0SatTiocL/K9v9ozejwPOpJ/Vjjxv6RR6UCNYmP/CNS6ZJommOX6Gat2/pA4LaZwx4Uf32aT9jj9mK2w3UvKJWVpw7HEPG7zB1JiHInncojDPvwKm91+JayQTMtXmLoJuTbxwRmd/OZjaQaD9wY/znGY7/8UoOujCm+47crMa13cur9WzeAyYEHxO0hRGKFlzb/pecWynycRpDzVGwRR96VwJB0ePRlNUxeATthbbSiSZBA7pDWYVl/3FIskdfrsO7tQ7XyYGMxkScmbe8FKk66km+SFv5AkxfByCd3MWIyc/g=
X-MS-Exchange-CrossTenant-Network-Message-Id: 70c7b74e-a3d3-4085-1709-08d84513d360
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2020 14:17:52.9478
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k5lHpPU8S1kZ5R4G48ytXlgrxnOwnK2cUQouEM2mP1OOYP/d/TZo52RxItBLBPp8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2648
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-20_03:2020-08-19,2020-08-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 lowpriorityscore=0 malwarescore=0 adultscore=0 mlxlogscore=787 spamscore=0
 clxscore=1015 bulkscore=0 mlxscore=0 priorityscore=1501 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008200118
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/19/20 11:14 PM, Andrii Nakryiko wrote:
> BPF_CALL | BPF_JMP32 is explicitly not allowed by verifier for BPF helper
> calls, so don't detect it as a valid call. Also drop the check on func_id
> pointer, as it's currently always non-null.
> 
> Reported-by: Yonghong Song <yhs@fb.com>
> Fixes: 109cea5a594f ("libbpf: Sanitize BPF program code for bpf_probe_read_{kernel, user}[_str]")
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Acked-by: Yonghong Song <yhs@fb.com>
