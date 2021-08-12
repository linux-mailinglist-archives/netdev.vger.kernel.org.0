Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB0C33EA995
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 19:38:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236543AbhHLRiZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 13:38:25 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:36590 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236519AbhHLRiX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 13:38:23 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17CHasSJ020206;
        Thu, 12 Aug 2021 17:37:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=0MwAk3SXv8aC+RB/PdOuDJwkBhaftiqVw11wNykyngU=;
 b=yX22BCtrqZy93+MZGWuTTnvJdVEPkRqUy1bJm2okfDVr4Kh98BLcXm+EnelwIpTSi9SS
 Ni3UAz494rlBLd0WctnwuEG3kNRvff7KWEyQ7uknlHziqCflXjhWmDOQzkvi30/1HXXX
 Af2v1goTlbM/yPa7bO/VBaMC+8n5zibiNP9GFwZ1Nf64xe85djfKCXEXMhuD45p/iUjO
 dZ0GbJGXe4dGcFsSTT9qJXM6UxQ4BLeLwhOs0PS2t0sQAmHQ+UwKZygeifgaowcZS+el
 KBTRLscQS6tVJMl9J6RMjskZ6wP3/INS8TOgGercprkWFbpYbch2fgZyHhmeLfm3kk/s yw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=0MwAk3SXv8aC+RB/PdOuDJwkBhaftiqVw11wNykyngU=;
 b=wBWU+eOu/QsZjgQkRL/dIIG9jY8ZgOi+b08XMvU41Ulz+VmC//+1OnAYDH8bKhAtziBo
 1GtUalKbLIOojtUiK8M+kJg39W2nRc2BHO7GnaCauIbFgJPiXpwIQ8QIS1pRI799zbla
 DY9HZUuuUgQIEkmCferO3tGwViheNDXb4bY2vQMHEnS+67xOQ9vA4c1IDBauVp02o5eD
 do3O2wcTZSk5SQ7eJhw7ycnP1GCXjjXj6BG9A1SDltq+qHBRZ12bnsxalD3FLelZI+/c
 LLl6f96Gf/39GLPp8ANTi3HgGBkUf/Vf3nPj/RzhIi6G3gdn4thBvdXe7hLCojPnns0a GQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3acw9p1j6g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Aug 2021 17:37:56 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17CHarTQ041307;
        Thu, 12 Aug 2021 17:37:55 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by aserp3030.oracle.com with ESMTP id 3abx3y86ug-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Aug 2021 17:37:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Iy97USFXF+8+nDV40G2sUoO1cAqrIrxoJCL8UMq9BANMK/uvnTuvX5BatGbNRsu8azGLrwPGmau3GFtLp7CGU/hB8+tTWEw6GEQwlgwzZPBjTtKgBQ+FFRNDW8JnXSdm5W0XBPsUM5doD3I458KWrjZOpjN5D2t2RqZqHzhkNcO6+GRn/vCfuqbT9fE+4UMN/TK2Stui9Q3rVjuYgbwA6P8QMjLJ+is3Utk4giTg6KeNJw1BeMdJhXe5dkBjwyEfH5BjPIU9KwqW93Xg/WUiYIi3dB1zsggN5D5mT8inS+/b0JP0amW+VCFi7GBrJ3TVWUJwUMqAz18rnmIa2xKA+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0MwAk3SXv8aC+RB/PdOuDJwkBhaftiqVw11wNykyngU=;
 b=bxKIv5ImRLPb+Jw0NKLVECLwSJWJpUu15fHDD5zfJ5hKT1/scTXG5AfQubEmkWCb0KDlNL155KWc/f8vHJ0TEaSFGXQuBlCnr7X5jJsNco4Adxx9Mf4YWz8vlQCCvEvR8AatqHpFgP1/xNstNFVEzXWY3MwXaMxZ0L4FI9MI1Zpycb5rWWOOivhnTKuxYSYsWxa0KxBovKNO9m3BGp5UIQHtRGhtvnljl9EG86xEYdH/BpIRjRAHb2JauPs8W8Xs0tV3jCxB0z1Wb+EwF5tB2bIfjplElfFrE2gQ0avtRheqCFejtiCPZLXuD9nzbh427BhcOWUW55Ja3bNx3pnfVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0MwAk3SXv8aC+RB/PdOuDJwkBhaftiqVw11wNykyngU=;
 b=c4bdcMgpMrbA5I1V+gaiNVUINxAxDTuA9SJiz9GEmObARlqevSLnf/pdonm1nslybqaIDvm1sdpqAOckLPk2dUtLUwMuE9c8c69WcgiPRZH+Wutdz3Or5kaxwxPz32vsKXC9s+HI7OS+lBZO5asylOIAI1cBPEmYh4pl+lrezJQ=
Authentication-Results: zeniv.linux.org.uk; dkim=none (message not signed)
 header.d=none;zeniv.linux.org.uk; dmarc=none action=none
 header.from=oracle.com;
Received: from SJ0PR10MB4494.namprd10.prod.outlook.com (2603:10b6:a03:2d4::12)
 by BYAPR10MB3221.namprd10.prod.outlook.com (2603:10b6:a03:14f::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.21; Thu, 12 Aug
 2021 17:37:51 +0000
Received: from SJ0PR10MB4494.namprd10.prod.outlook.com
 ([fe80::588f:a774:17de:1d1b]) by SJ0PR10MB4494.namprd10.prod.outlook.com
 ([fe80::588f:a774:17de:1d1b%4]) with mapi id 15.20.4415.018; Thu, 12 Aug 2021
 17:37:51 +0000
Subject: Re: [PATCH] af_unix: fix holding spinlock in oob handling
To:     Eric Dumazet <edumazet@google.com>
Cc:     netdev <netdev@vger.kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
References: <20210811220652.567434-1-Rao.Shoaib@oracle.com>
 <CANn89i+utnHk-aoS=q2sLC8uLaMJDYsW=1O+c4fzODQd0P3stA@mail.gmail.com>
From:   Shoaib Rao <rao.shoaib@oracle.com>
Message-ID: <a807dd9c-4f8a-c205-8fa0-01effdd54553@oracle.com>
Date:   Thu, 12 Aug 2021 10:37:49 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <CANn89i+utnHk-aoS=q2sLC8uLaMJDYsW=1O+c4fzODQd0P3stA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: SJ0PR13CA0100.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::15) To SJ0PR10MB4494.namprd10.prod.outlook.com
 (2603:10b6:a03:2d4::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2606:b400:400:744d:8000::485] (2606:b400:8301:1010::16aa) by SJ0PR13CA0100.namprd13.prod.outlook.com (2603:10b6:a03:2c5::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.9 via Frontend Transport; Thu, 12 Aug 2021 17:37:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ff80dcb4-b2d2-4e14-12c5-08d95db7e85b
X-MS-TrafficTypeDiagnostic: BYAPR10MB3221:
X-Microsoft-Antispam-PRVS: <BYAPR10MB32218661DEA7DE98AD9E069AEFF99@BYAPR10MB3221.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FV5z01pnphgFpCP2tLHfnAU77d6XJJec1Cy0NYPZRcyTtQN9ca6v6NftiO4zoL6yvowp6cBKBM0oPf/UhwizzzWgnDYjy2BJoN8e+yZZjy3bJka54IzqykkniPmG4XzfDQmvVg91yMWir8EYtCfqdWK8eKA3S9uQcP3EPA17UrnP8T1jfsflaoTISX8/DMzWFBVugoflK3HyCwcb8EWYEbOR1pTbfmrH0gLIeDTemkcNKeemcZUUZXF5P9VZT1C2BjNDk0naajluLt9C15bmEDmmHjDqUPmDuWMBKAajnXHtxFvsRy8Cf1b5GuyMy11GwwoRvG/VrDCoOuKV3dNG9YRMiUXp9vynzknc2KmVy1tNE6ueBmGnC3/AKdcLKeYPhIN/OnQgyuX94AyKC089YiMWfm4FJ61dyBhIxQsKwwI2DXyLLiRNP0h2d3pmva/RrZZD8vJZlVR8XJsFUK7+N0l+7QqJOPOCfHxt8zE3g/32KscLHW4TuNBWyViGKQEbO1QmsfCBWVTE3KcvEtuiLBhUEQ3ev2Vnf86uy/8UpgpydbdjCWY7DcIJMOZW6Q5TPeUSsLY1PRa8FimLTBZn9L5bFz/JnksoFbeF+5ZX7C3NwGfdKmv1kyxi4VfyCTiZchYyIWdZIXBqMKUrIJNDOYiGMKrd/SyV1R9plbzng2S+PEvFeTl6jno0QmAeRjAwo7ypDjgH7viJKmrdjxvz7OosE5yuTh2T4sLLnWFJqM/eFtMMPX+ULh9IsT5x4BlE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4494.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(366004)(376002)(136003)(346002)(478600001)(86362001)(8936002)(6486002)(31696002)(6916009)(36756003)(66946007)(66476007)(66556008)(4326008)(2616005)(5660300002)(558084003)(31686004)(2906002)(54906003)(186003)(38100700002)(8676002)(53546011)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dGZ6V05nSzN2ZkwyamNYM0NKUzVjcGRSNVlqUHl5ZDBmTVpYN2MrdEp5RUdM?=
 =?utf-8?B?VlpVK1pWUDVyUXF6cFJDbVJ1MWdmZjZFMUgrZEs2ZnhCNHBkTzRHWm9VTzlo?=
 =?utf-8?B?dElXVy9FSXNCZ1J6cTFSK3pQMnFESjBjdzNVMWtaUFdWZUFYcU1nWlIzT1Bi?=
 =?utf-8?B?dnBsdTRHTlEvQTJGUmZaSWx6a0NmeG5iN0RlYXJkbHA3QWpxZGFXQWhZYlRW?=
 =?utf-8?B?OHF2VTFjV3BtOHU4cWdjS29zR1hwS3QxblpNZ25BaDRwRCtBL0d2clo3Sk94?=
 =?utf-8?B?cDZyM2ZndHR5N0p3UXByK0tvcVo1S2NoamdtR3VpVFhmc0ZZL2tEYmlacnZJ?=
 =?utf-8?B?K2ZFTTQ5VjQzT21DQjJqMm1PRXk3M25XV2VvTTFSbE1CSWdmZ3VvNmFrTXBR?=
 =?utf-8?B?a0dnNDdzaXN2dUFzNlJuc0NTaStlc2pVQWZWTXByOG1oQVVQRnZQakpTMHk0?=
 =?utf-8?B?VU9UZ2ZLNzlZSHNOM0JlN04zNWZzZXg3Nm5yakNyNXV3cDF5VFQ4SFd3cnlP?=
 =?utf-8?B?TG5kcktxQStCTnlVZU85dXgxdURXMjhZNmc5T3g0RW5tek93UTN6TDM1TWlx?=
 =?utf-8?B?bjlTc0tyRzAxd28yU3RwaUlXY2FDNkwxZ0FlSGpzZWFBYlo0NDVFOWhLUGM3?=
 =?utf-8?B?RGpXbkFMTmdXTEo4QmROb3BQdFh5cDZ6Q2xJaXV2alFRdTVDdDhIWk1qNjU1?=
 =?utf-8?B?K0VjNkFxS3RqakdWSG9iMGZEejdSdzQ4M1NpVWlTMUVYVFNKWEVZVkUwQUVR?=
 =?utf-8?B?YkFvRGl6dlBLbktXdmQvblFQNWNuSXZsdUNKRGVBZ3FWYUZCcTQ5R0JuY3Np?=
 =?utf-8?B?bTZGTUlQTGNTaFZyU3F6NDhEbTRTYWFwY2NVSjZHc3c4RWZsb3p6WHQ1b0tV?=
 =?utf-8?B?Mkx3VG1MVjY0ODRSWVFLWndJc0EvZjcxUGFocE5KVWVRT3lFZVVoK3RyOGJG?=
 =?utf-8?B?Nmw0NkFuUURDMXNLNWd5OUZUS3ZVWTR2R2RpcmozRWMxUDRSTU5NV3lCaGJp?=
 =?utf-8?B?UnU3U0xiVVREQldkT29GOExXSVBhK3YxMjhvdDFvMXpHaFJybWpNQkdFWmtW?=
 =?utf-8?B?UXZuNHFYREhRK1dLSTIwVzMyeEQyQ1B0VCtHSDRYQk9qTmxWQ01iUUZkSUU0?=
 =?utf-8?B?Wngvb2R5Z2RUNTlQZHlrb1NydWh6RFE4RE1yOGlJK012VHdESkptNG9lUzJz?=
 =?utf-8?B?YnVDWW4zTzRIaC9GNHJsYUZPMHJvaFA3bTVNZ2xTZnF3TTk1YzVraWRqbXdQ?=
 =?utf-8?B?amswSXJYNzB6WVczY0xNNWxyUEM4ZmhWb2J6NHJBaVl0Z2xYNCtJaW9oZDY3?=
 =?utf-8?B?NHJMRWhRcWhPM0tkNTNwYldHcEcyR3hFM2h5WlhwNHgyNTBDQitiZ1ZQb0dI?=
 =?utf-8?B?UFptL3BQSFZ2SWYzTlRwdFV2ZlhXM1J0NTkwUExtVWZrbTRHOURtNWZqQThM?=
 =?utf-8?B?SXpnVUw4QXYvcE5idTdLQWdTcVZvT3hVWUpCUDFEZmdwdzJYZmx1Z1N3bTYy?=
 =?utf-8?B?a2J5cWo0UnpPV0R6TzJCVmkvUis4WVJnZVRueGQ3K29MTndYRzRUWldwa2ZM?=
 =?utf-8?B?UDNGOC9EMmYzaXBYUVArcHdGVTlVZVU5c0RPclNsUVJXY0t3Z2p2cmd1NXpR?=
 =?utf-8?B?b3E2MVQ1QU0rdjVDMEliU0NydEpvRWt1ck16ck00cUFWS3J2aU9BWk5nNmN3?=
 =?utf-8?B?NzhQYzRYRFYyUXFBaUh4cGZ2UkY5eGIySFZJNEY1YnhIWG92dmV5aGxUbUN4?=
 =?utf-8?B?akZjTnpkM3JVdHY1dzc0M2hNK0RVU282aWxVZlR6TFV4bTdHSjlkSUZ6aU9k?=
 =?utf-8?Q?OcYM8/zSUKuvXW0tM2s4iwA5jDo++VPvGP78c=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff80dcb4-b2d2-4e14-12c5-08d95db7e85b
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4494.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2021 17:37:51.0089
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WDnjvjcbEUxufEN3Z4BwrrQGPQkfznCy1BRbPEeBmKyXt8SW/isYfedJMFv/42qHplgdLfrEHjeRp+W9rbVwrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3221
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10074 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 bulkscore=0
 spamscore=0 phishscore=0 mlxlogscore=994 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108120114
X-Proofpoint-GUID: Dcpc8z5T9w2qlOwbBaRCxt2lPEzznPSw
X-Proofpoint-ORIG-GUID: Dcpc8z5T9w2qlOwbBaRCxt2lPEzznPSw
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 8/12/21 12:53 AM, Eric Dumazet wrote:
>          if (ousk->oob_skb)
> -               kfree_skb(ousk->oob_skb);
> +               consume_skb(ousk->oob_skb);

Should I be using consume_skb(), as the skb is not being consumed, the 
ref count is decremented and if zero skb will be freed.

Shoaib

