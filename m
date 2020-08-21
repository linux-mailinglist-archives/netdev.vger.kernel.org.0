Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83AC524D90C
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 17:48:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727891AbgHUPsu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 11:48:50 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:45746 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725828AbgHUPsr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 11:48:47 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 07LFikgR021795;
        Fri, 21 Aug 2020 08:48:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=R7TeV4J89w8vI67eeHEWgj1PEbIjWhxPHugW9jqVD4g=;
 b=CtqYjC0JnZw9wgy9hY2iowTRs1caHSnmBX7cwLUCT5nVTdrvMhx+PAtWDE3lviq1C9WZ
 6WICtOIsSAl8i6T0n9FbkNFYUP+ay5hp9h0TAPrpxfB6NRsY5S72B1SC2SRyqmIppe8Y
 ENZ7/akeftNP57N74zEhgEmc2vD4R5dUHvw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 331hcc19j1-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 21 Aug 2020 08:48:31 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 21 Aug 2020 08:47:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zhy8w9bawHNu2II0rlQQEiPgKc+gV3NGdEy7kyXtzM9x6q169j/dpyvolgn28MrQzCXuaEIne9cCMu2hwrGVoUEnN9DcWkMjGdpLQCO+qjHR+lbmkuaEJFNlGJZdruP1XMr7x1+1IOZsnY4dVlrCvVhxKNISTbQh7sfOkgT89acL0WcpBA1LZoGcYwjrhjejCsM7+EZ4OS6nCLr4dz1/H05/xbcuLAmOzBKrm5I6UqCMOfl0oYNEmomdspkrNOzjcUoDM2ZV0OoPhNMHwcVvzvNSOkn5xV41/eSGpOFhiN2FyN8sdUcb2y6kre2Eae958F2tJsQOni00imKT1sUY7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R7TeV4J89w8vI67eeHEWgj1PEbIjWhxPHugW9jqVD4g=;
 b=n321gafFhyN/FqJ+MO5mOEYOVL8wTkj2jKec+4gZIdZ/QHCo2P9jWNN3dg1WaWOAjWKg9ygHiU9ZLDdmRhKoKRjIJ6erV8ioVxnXeWdz49l+My+N+pF1P7dBu5pXwYbw64PUrntJgKMrkeHMTEnQsFomLLGVP3tvhg4T9a955QYTwbiSqTEJEGCEn7eDCeE8gdhbGA4J/WnDoAhxrDNmNnoMCjXPzPyrL6wNRFqG5XbEqWd4B4eSHxuy/2AGIbEgYNw3Iss4W9LUiuwNjbCm3czDMwYx/uJA91ES1+E4RU3VBZGvsqTyw99pz2+FLQ1axolF45q7nxNK6ls7otUTLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R7TeV4J89w8vI67eeHEWgj1PEbIjWhxPHugW9jqVD4g=;
 b=CP3UxVHM3C48fxjH3rtH7Dos6fdmDBHtzzPy9WSkUC3sBMStc4nSg50UkSdH3c4iE1xzBMPq7Lu+5T+ux/UNsGwqiyOQpbp9NIx6WARUxO/Uv55PBcK+zy0d/Si16CsKkrCN2d0OidwXgImA593owfFAWGrny/bzk7//kBBafmo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2949.namprd15.prod.outlook.com (2603:10b6:a03:f8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.26; Fri, 21 Aug
 2020 15:47:59 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80%7]) with mapi id 15.20.3305.026; Fri, 21 Aug 2020
 15:47:59 +0000
Subject: Re: [PATCH bpf-next v3 5/6] bpf: sockmap: allow update from BPF
To:     Lorenz Bauer <lmb@cloudflare.com>, <jakub@cloudflare.com>,
        <john.fastabend@gmail.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <kernel-team@cloudflare.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20200821102948.21918-1-lmb@cloudflare.com>
 <20200821102948.21918-6-lmb@cloudflare.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <fc988cf8-e039-61f5-3d73-0ecf8f27308f@fb.com>
Date:   Fri, 21 Aug 2020 08:47:54 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
In-Reply-To: <20200821102948.21918-6-lmb@cloudflare.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0046.namprd13.prod.outlook.com
 (2603:10b6:208:257::21) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by BL1PR13CA0046.namprd13.prod.outlook.com (2603:10b6:208:257::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.10 via Frontend Transport; Fri, 21 Aug 2020 15:47:56 +0000
X-Originating-IP: [2620:10d:c091:480::1:8c09]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 46dc5169-651d-49fd-4083-08d845e99413
X-MS-TrafficTypeDiagnostic: BYAPR15MB2949:
X-Microsoft-Antispam-PRVS: <BYAPR15MB2949DB3358755893D8CE3256D35B0@BYAPR15MB2949.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x76y3isM3wMC8tGV3PsqbqLmTzKCDWXI0lQKKA2yIJTcMGR6CZ2BZoMcOgxAGV0mgaeOgUvPSKPAZTbJYnx/lnQCHNcSN8kGmqx7balQDIU3HI7DX90XH4rEqCRjeOaKntIsj71DKrx+SsfTuPmf5GO+AMmR6rfvPzeZdb8cj+Tc72v8FzFXsbxQ7Yt7iPO8Id0Hxxrm0BMXVaWMu28RbehMId+Is3n8dX9ajIJQpNb1aqkcrQNFoloUI5ZbdjAn/EFWH9nzIT2JiOiiDuNG4g8kwS9vB6vfnOTyRW8Yapbo9KjGj64OU8MvYx6NFiPiRaJSn47a/itD3ThQ23sw3edn+aaGTG/va0sdeWeNAO4WwsZqcFpP1TZ17Av6lAtnM9viiZPclpXCd/GlvSM8t15BgXX6IayvMzygARQidiI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(376002)(396003)(366004)(136003)(86362001)(6486002)(110011004)(316002)(31696002)(31686004)(36756003)(53546011)(478600001)(16576012)(110136005)(956004)(2616005)(186003)(52116002)(2906002)(66476007)(66946007)(66556008)(4326008)(5660300002)(15650500001)(8936002)(83380400001)(7416002)(8676002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: IflrgWtgZ85OvOCm0rIj0i2XcLacw1vMgWlXdhh4oyIrcmGnpQO5OR/ezVgdz/9wHUXr/NZVTzgSatlRquSA+tl9p43jtzQ+rKJvsWRRy+gF2MBJovBP0J63aZkleWCZ8auXwcewG3ijuR283XV1JmLCvw2yujprYat/CIhryVoOUbkXVCfYO4xi8pX3x7qR0HCR5vDJtRcanPcYPXse0HM2ssSS0ZgWrh+aqx8yKAcdhHeeMu9eWp5AFelu+JVuVoEFd0DB/L0WHK6zFfMjpyJB31iwNg1ZjD48YZjtnxSXGFRhw0ghH/zT1FVj1cldgGh4hyZs24LCb1d0qxnlM3PNrMX3MSXWhSltMoTp3dd/KJpk+B5Z1Lc6pzZW6KVQz8a7JVoop06LLIxfeTLE8mhh0AEzNxiG6Z6E/buRx9gtPHWQNPpwbHc3KQy6+UA3MZTV0wkbIFjvdXNFDrEDjvSzeyeYrY/Hz7KHAagNNQmgJmVYTd9/mM4ZDgnSKGzT4+uvBxcRpl+jeAjwH1rzq5s7RkXS1iArmumw+qNF9VvN5dE3VO23SABp32oCngGtPrDGI+WOFl1hlNPtuTv/EGg+sp7jlNXJIWDYa48OnHid+q9AVbFtETgDrR0q+NFTJTaPddCzlUo3VqZGCjrRKiarKiDRHtSctmyD4cTaXejv/ae1uUgZnoxmNx0seWjc
X-MS-Exchange-CrossTenant-Network-Message-Id: 46dc5169-651d-49fd-4083-08d845e99413
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2020 15:47:58.9230
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1Ec4ihKwHEdwt1p8QtWLHi4AjsS46/SWZOCqzC+R+iy4Rre85llsEmOVx5GsbZdN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2949
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-21_08:2020-08-21,2020-08-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 priorityscore=1501 suspectscore=0 clxscore=1015 bulkscore=0
 mlxlogscore=999 lowpriorityscore=0 phishscore=0 impostorscore=0
 adultscore=0 mlxscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2008210147
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/21/20 3:29 AM, Lorenz Bauer wrote:
> Allow calling bpf_map_update_elem on sockmap and sockhash from a BPF
> context. The synchronization required for this is a bit fiddly: we
> need to prevent the socket from changing its state while we add it
> to the sockmap, since we rely on getting a callback via
> sk_prot->unhash. However, we can't just lock_sock like in
> sock_map_sk_acquire because that might sleep. So instead we disable
> softirq processing and use bh_lock_sock to prevent further
> modification.
> 
> Yet, this is still not enough. BPF can be called in contexts where
> the current CPU might have locked a socket. If the BPF can get
> a hold of such a socket, inserting it into a sockmap would lead to
> a deadlock. One straight forward example are sock_ops programs that
> have ctx->sk, but the same problem exists for kprobes, etc.
> We deal with this by allowing sockmap updates only from known safe
> contexts. Improper usage is rejected by the verifier.
> 
> I've audited the enabled contexts to make sure they can't run in
> a locked context. It's possible that CGROUP_SKB and others are
> safe as well, but the auditing here is much more difficult. In
> any case, we can extend the safe contexts when the need arises.
> 
> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>

Acked-by: Yonghong Song <yhs@fb.com>
