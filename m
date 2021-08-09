Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96C973E4AE8
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 19:33:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234388AbhHIRdp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 13:33:45 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:7224 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234208AbhHIRdl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 13:33:41 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 179HV34x003567;
        Mon, 9 Aug 2021 17:32:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=4Dh6JzZzbnyt05DwDSucryAXc7HHgWFMtLWPMWXr//c=;
 b=eAdrywGsbd+Fjz6dmL2xAMAxDq7yF7PS+srXTWcVVkXvgnlZWhb7CMkzg0FHSPMKe3RT
 I30TQmAk2guqHDGrKbY3kpFXlPlAeGgodAVi9k6C5fn6S/VdFC+44xcoD8Pr8JbTgwym
 z7DOhYh+h8CJSi8I1qQWzx9NSvAS2kpx+FXVvOxMLShupTkElDWn/sk/xlxscmgqYbzB
 Ht7TfNCh3vDhvsDVEbPtYPc2GA2cmOzDZUJNqpLEB3FD+Ql4DOZ5z4/x348d3/WgWpsN
 w4lVhksUgEVTsOQWlzdUqd73oBqoJx+mavxAs3r1OB0hXZiBUuJt1pSUpXOe6EcpQJnl kQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=4Dh6JzZzbnyt05DwDSucryAXc7HHgWFMtLWPMWXr//c=;
 b=JSrEs7lu3pfiFnbCyk2oUJTubiV+CLJQLSWhR+m+oJ90a7pUdR3VTN0DoG2DWn+Iu+zg
 g93CwiysFEh2lmKRE6xPgpXzMMNFx7w8Tpsl2lz/cNL1MPK0/NxJEKhphh4ZNvQjYdhk
 GfXHjmvZjxZ7bphnV0N2TJG0Lom+ioAauWXfEDF4ALjdfGqaiCdVwrW4s5gMjFoi6rNP
 NHJptHW5yBUddxeRCp6OL525k7vi2+FjRIHRPUjZRScYOespXquesXmD9uvJe8EUL1Ln
 jhOOdoPsahqGuk3/c+59wXMeSFxqNQt7gPU4/eX5jv1u4RwICziXFRbLkmMjPID2QMZE rQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3aaqmusxmf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 09 Aug 2021 17:32:55 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 179HJ7CR125637;
        Mon, 9 Aug 2021 17:32:54 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by aserp3030.oracle.com with ESMTP id 3aa8qrpmpk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 09 Aug 2021 17:32:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oYwZtQbS3+9qkBJt6a+jxx0u/6rSraCNaXMdxG8+dZfvhweOM8SxfohF6rUWXhuf8eHdJpy/5IlhJbcD8myOukVU7H0gZrmjwVQlIiIJT3NLKke6hN9igk/7qJR50/78fWLQ8/cWwedWVNWV/4qBYIK8L4K8x5tNKDxCM8uA4Lenlv3jS92Y6Tc8SeLrJs85nGvE/5ksVMx5O0OACHIIzQXMQ2li1xQ7EwKLG/Jk9Xd+wStmmWxYQcvCFDKAO8NtVB+CSRO3oVd7b2oGwMJoI7jjCdl5NDBD9lPcfayF/nIJRAnlhLnZuYAL2J96K9o8bY0YkqppRAScLHC2yBBqLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4Dh6JzZzbnyt05DwDSucryAXc7HHgWFMtLWPMWXr//c=;
 b=Y/fXcaFVaXKF9f6/9SZkHx2YHd34kAm8A3ZyRUYEOonrVkKn6p5HAQdSyehDozY9HC+f1SrbKBFkSlmw/ZXSskNgmHIp6v6HOdwaeShRmGxjL8HbFhBg0ZrlIr8+gxyU3MIf0WS1sYSbsIeQxgv0e1kcjIfXJZNSD1A1CNt7laV78/FYCBvxztpbb1D9QjIOMKYBBHwp3V8vPiYu3LvVcTy0T4z0UVJpVIDkzLofPnmlYMs+u+1341qDzrxYSZOApiABMCduLFvrABO1UZw/BPBe2RHN0Emzd0KqUpinyHKoUmzRNis2/k8UcDoD5jZXwxkiW3Zu7Rhwpno66tLHlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4Dh6JzZzbnyt05DwDSucryAXc7HHgWFMtLWPMWXr//c=;
 b=pqwdY2mTXBXV488EZLr3S4bOr0wTpwXM3LOuEzl73mmzOLnXg4foXLkzLlkJGLy5BAPdr9ogKEBtotIn5jXK9QPyvCHC4igfBVHcOrsV/mXyzUg/w29CWmNJsqI5W4OX87k9JO39lymyTIExeb38dD+kxjHDW7UMnkwyXm8lvg8=
Authentication-Results: fb.com; dkim=none (message not signed)
 header.d=none;fb.com; dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB4494.namprd10.prod.outlook.com (2603:10b6:a03:2d4::12)
 by BYAPR10MB3333.namprd10.prod.outlook.com (2603:10b6:a03:14e::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.21; Mon, 9 Aug
 2021 17:32:52 +0000
Received: from SJ0PR10MB4494.namprd10.prod.outlook.com
 ([fe80::588f:a774:17de:1d1b]) by SJ0PR10MB4494.namprd10.prod.outlook.com
 ([fe80::588f:a774:17de:1d1b%3]) with mapi id 15.20.4394.023; Mon, 9 Aug 2021
 17:32:52 +0000
Subject: Re: [syzbot] BUG: sleeping function called from invalid context in
 _copy_to_iter
To:     syzbot <syzbot+8760ca6c1ee783ac4abd@syzkaller.appspotmail.com>,
        andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        christian.brauner@ubuntu.com, cong.wang@bytedance.com,
        daniel@iogearbox.net, davem@davemloft.net, edumazet@google.com,
        jamorris@linux.microsoft.com, john.fastabend@gmail.com,
        kafai@fb.com, kpsingh@kernel.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org, shuah@kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk,
        yhs@fb.com
References: <0000000000006bd0b305c914c3dc@google.com>
From:   Shoaib Rao <rao.shoaib@oracle.com>
Message-ID: <0c106e6c-672f-474e-5815-97b65596139d@oracle.com>
Date:   Mon, 9 Aug 2021 10:32:46 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <0000000000006bd0b305c914c3dc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: SN2PR01CA0028.prod.exchangelabs.com (2603:10b6:804:2::38)
 To SJ0PR10MB4494.namprd10.prod.outlook.com (2603:10b6:a03:2d4::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2606:b400:400:744d:8000::918] (2606:b400:8301:1010::16aa) by SN2PR01CA0028.prod.exchangelabs.com (2603:10b6:804:2::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.16 via Frontend Transport; Mon, 9 Aug 2021 17:32:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 77d546bd-eb4f-4c2e-b184-08d95b5bb6c5
X-MS-TrafficTypeDiagnostic: BYAPR10MB3333:
X-Microsoft-Antispam-PRVS: <BYAPR10MB333341679325D23C126C5CF2EFF69@BYAPR10MB3333.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: L+pqkmUCH76tx5M5N5SNEnru9R0fwb3uDacc5BXzdDSj56dF25fgN5n3qo307PdgVE3aMCRDonaiXJ5pusRges5PONIzaYRYqLb8v3IM4vCO/xQC3+s9FrnT1wUFyV3ukLUCBrbf94Co9ASkjt46AH8WY883nSa/5IDxBK8+AM7rNU4MyvVDo+UvlE5S4CRvoiHFMQvNzZ13vGMTjHZBcCKU3YD1Duq3iivFPs5yj+IhxRSX9qHwtj+ilQJdPqwYjf0Xt5LfZabfc2synKmi1gZ7lAnpK2anwtTzMgmorgslI6/k1l9GtHwZD/RPx0vGiXYu/0F8v0V7DJy6zHeQZdvzRmtDhET3PT6hq3CfisJqyjNTOYuASVXRJ1sxAUos6kgZkTO+mkpTDVxNeQDZnAqnocZwHsRUA5XzDlx9Go3ZcTwEukKlYIojzWgVGOI52rqmnyvBZ1S/rDS9rk0DuJtx9b0Ec7FiXNKuheUL15u95hEYTHAOfTD3jG1itHYGIMwy1r3bxV50m2J6oT+K0fbUaoTlxx6A7rbsGLXWjbWxIkwhba1cQxlcXivknhp5QJPfN1EtR76cAXHrTBnSQxMWK+MqBuxz4S7tFuTEKOVWH8ErwhBtae4h8C98VMhxHQ2XCwoxhyB2/rP8KjXKq7NnFrxRNt3Mt07zF4iGsuO1/j5xITJ+YLKTcHJObKdn6otRoraX5BhmSUAFmFyApBKcqNkQ+BjL9ERsjSlxRqp9jq0KUhsPaQIlUefXGzOXFXAu4En93YhgltUh3wfDupuhiWmkqj9Pu71P5RsVGVI9wf3VJKQBeVTUrw7RW+VyKOWa6rWRc/BGpPLtPQAeFA1Wg8Xe/7yWsJEa+PWR/SI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4494.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(396003)(136003)(39860400002)(366004)(31696002)(966005)(83380400001)(316002)(66476007)(66556008)(86362001)(36756003)(31686004)(8936002)(8676002)(6486002)(38100700002)(66946007)(2906002)(478600001)(2616005)(5660300002)(7416002)(921005)(53546011)(186003)(99710200001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T0F3Y2tJL1V4R0lmNnF1RnVuMUx6MmlvMWY5MDE2NEdzVXpJN1pmUmJpSjNh?=
 =?utf-8?B?citkR1BuRDU4N1M4NEgyMHo3TDkyZEwrWFNZQ2ZiYkZVMGxvbk03a3VqRHZa?=
 =?utf-8?B?Zm5zMEJrQ2pVcDBTeVdTRlFFaFY2Zy80alloeUZvM1laTW1MZTNoMUZFQWhn?=
 =?utf-8?B?cUJCdi9IRHZObjBPVG1LRVU5QmFMRHVJVlZ5NWszeC81dGdPa0g2SlRnbGRa?=
 =?utf-8?B?SjNmOXE3R0s2TFFHRDRvS0RsZmxVV3ZHL0lsOVVBZDM2dUQ5bUxQbThJZi9D?=
 =?utf-8?B?TS9rL3dFWStkUkFsOHpySHpjVllkeDRHWlM0SEVFRHQ4RlpLZ0U4b2JjUGpm?=
 =?utf-8?B?anJaNkpUdkhBUGJ6YXRCWTYxc2VMaHVKVVRCTXA2SGFSdnFEdUwydVBwVk1L?=
 =?utf-8?B?TVBkQjZDbkpkU1MvR0RuYWhVRHFCWDFXaFdxMDNYZ2xzTzdRM0YrVmhtelo3?=
 =?utf-8?B?eXR3N2hRU1RGTFJxcVl2THBydWtlRzJXY0NnNTdqK0xrKzRhSE84VmtnL2Vv?=
 =?utf-8?B?V0ExMHJ3R1ZRT2ozbUxjYTkvUGlCV2tkYzBudGVYU2tMeUtEM1UyQXRaOWRP?=
 =?utf-8?B?MDVkOVJnWkFWRWtkaTYzWGUwMnF2MlVtcU8xRlFSTHU2bGVoc1pBc09vQysv?=
 =?utf-8?B?VVUybk4wMUVaUTFtS0ZCRk1IRHFReVljOTVvTlNIc2tLUCt3T2h0MEk5UXhn?=
 =?utf-8?B?NlhmVXBuQWxWZExJdTd1NVJmVHlyeDVFU2dGSU93MU9ENjVmRjI4MW9wazlv?=
 =?utf-8?B?OXVYbVdPdHF3ajFCdnhLbUZpcndPdVA4OGpUbkhuZUN4RDJoVExyczVIRlha?=
 =?utf-8?B?VG96SFl5WXBpTUdFOUN6WGVyMGIvemMxcDFOb2NEWFM2TjY4WC9VLyt2N3Jz?=
 =?utf-8?B?WHluOFlNcGQzMHRnMkQvaTZjdHd5TTkreFdwZUs2OUtyZHdnUDBtenVkeFdM?=
 =?utf-8?B?WEZrWmNmdVByR0Q0allIbGw5M3VPcnZzL2ViNHlsRCtia2xtUEtLUlVLcDJR?=
 =?utf-8?B?Q1Rqdytxd1NDUElHODRrNWs1dGVvVUhnUzZLb0ZGaG8yVWNwaFJORjZKZ3Z6?=
 =?utf-8?B?bkVKYklmbThkMXVuK2R3TE40SzFWVWVkVml5eDlUR2lMamlwQytLZnAybDRj?=
 =?utf-8?B?amdrYmJ0V1dzT0F0TEhzT2JTZmJ4KytEOXIxNGNoWlFlNFYxdDl4WFBXaCtG?=
 =?utf-8?B?dmNPVzVIOUdCZ1F6dFludTRQK2RTSVpRS2hWY2xHcmMxS2kvTDA2cUxIQ0tx?=
 =?utf-8?B?TWd1Ris0ZzZPTWVqem10c3M3UnZnSkE4NGhpVE91UGtGbEJLdHVrNEZqUmZz?=
 =?utf-8?B?VU1tRWpUT1ZPNmQwS0NIOS90ZjJMRlk0RWFzdmVlTzNLdWlSUEVMRWVuRmtF?=
 =?utf-8?B?L0xMK3BKMTRjdE56VGpwNm9Na2tWN3lTeXNUUjZyUDlvdjdla3MzZ0ZuVitj?=
 =?utf-8?B?cER1bXF2QzRycUZqTGdEZ2hQNlk1bDBhd3V0M0ZtMm1oWGVZam4rbUhPSnMw?=
 =?utf-8?B?M24yRVdUdkZzV1JVNmcxckhtbmo1czRxc1JJODFBZzJkdk9JT09DSjBsVGFD?=
 =?utf-8?B?RHdFZzhNTFNVaEdwSFJWaDVBaUR1M1U1QU1TZ2hEa3QyOHp1eDdsM1Rwc1Q5?=
 =?utf-8?B?REEyaHlMMHdRK3J2RXprb3k0WGxlenk4cXg5UG0zazliOGQrOWNHc0tCL1gv?=
 =?utf-8?B?cjduTG5aUE5Ed3ozOFpoVDVNRGQwR1JGOEVTNWRuWld6QjNKSmNraFZVSVRE?=
 =?utf-8?B?dkVhcHduSmprNUpoYmZpekQyZlMvNWtieDdiRUJyMFRZdHpERGtNNXYwZUlD?=
 =?utf-8?B?b1cxUjlCUmtqNDdqdko2UT09?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77d546bd-eb4f-4c2e-b184-08d95b5bb6c5
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4494.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2021 17:32:51.9372
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7HszehdxbcrhL00ujL9j/4umt5ONM2PHse+7Vy5iLm9YKtgv7+yMZk3b6bltnKT+2MAgoyOnlZcz+TaocuMCWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3333
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10071 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 mlxscore=0
 spamscore=0 adultscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108090123
X-Proofpoint-GUID: 4mLSC1kwf-WSWlBmwUEw4KQ_jG01e3_s
X-Proofpoint-ORIG-GUID: 4mLSC1kwf-WSWlBmwUEw4KQ_jG01e3_s
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This seems like a false positive. 1) The function will not sleep because 
it only calls copy routine if the byte is present. 2). There is no 
difference between this new call and the older calls in 
unix_stream_read_generic().

Shoaib

On 8/8/21 4:38 PM, syzbot wrote:
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    c2eecaa193ff pktgen: Remove redundant clone_skb override
> git tree:       net-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=12e3a69e300000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=aba0c23f8230e048
> dashboard link: https://syzkaller.appspot.com/bug?extid=8760ca6c1ee783ac4abd
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15c5b104300000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10062aaa300000
>
> The issue was bisected to:
>
> commit 314001f0bf927015e459c9d387d62a231fe93af3
> Author: Rao Shoaib <rao.shoaib@oracle.com>
> Date:   Sun Aug 1 07:57:07 2021 +0000
>
>      af_unix: Add OOB support
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10765f8e300000
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=12765f8e300000
> console output: https://syzkaller.appspot.com/x/log.txt?x=14765f8e300000
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+8760ca6c1ee783ac4abd@syzkaller.appspotmail.com
> Fixes: 314001f0bf92 ("af_unix: Add OOB support")
>
> BUG: sleeping function called from invalid context at lib/iov_iter.c:619
> in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 8443, name: syz-executor700
> 2 locks held by syz-executor700/8443:
>   #0: ffff888028fa0d00 (&u->iolock){+.+.}-{3:3}, at: unix_stream_read_generic+0x16c6/0x2190 net/unix/af_unix.c:2501
>   #1: ffff888028fa0df0 (&u->lock){+.+.}-{2:2}, at: spin_lock include/linux/spinlock.h:354 [inline]
>   #1: ffff888028fa0df0 (&u->lock){+.+.}-{2:2}, at: unix_stream_read_generic+0x16d0/0x2190 net/unix/af_unix.c:2502
> Preemption disabled at:
> [<0000000000000000>] 0x0
> CPU: 1 PID: 8443 Comm: syz-executor700 Not tainted 5.14.0-rc3-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>   __dump_stack lib/dump_stack.c:88 [inline]
>   dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:105
>   ___might_sleep.cold+0x1f1/0x237 kernel/sched/core.c:9154
>   __might_fault+0x6e/0x180 mm/memory.c:5258
>   _copy_to_iter+0x199/0x1600 lib/iov_iter.c:619
>   copy_to_iter include/linux/uio.h:139 [inline]
>   simple_copy_to_iter+0x4c/0x70 net/core/datagram.c:519
>   __skb_datagram_iter+0x10f/0x770 net/core/datagram.c:425
>   skb_copy_datagram_iter+0x40/0x50 net/core/datagram.c:533
>   skb_copy_datagram_msg include/linux/skbuff.h:3620 [inline]
>   unix_stream_read_actor+0x78/0xc0 net/unix/af_unix.c:2701
>   unix_stream_recv_urg net/unix/af_unix.c:2433 [inline]
>   unix_stream_read_generic+0x17cd/0x2190 net/unix/af_unix.c:2504
>   unix_stream_recvmsg+0xb1/0xf0 net/unix/af_unix.c:2717
>   sock_recvmsg_nosec net/socket.c:944 [inline]
>   sock_recvmsg net/socket.c:962 [inline]
>   sock_recvmsg net/socket.c:958 [inline]
>   ____sys_recvmsg+0x2c4/0x600 net/socket.c:2622
>   ___sys_recvmsg+0x127/0x200 net/socket.c:2664
>   do_recvmmsg+0x24d/0x6d0 net/socket.c:2758
>   __sys_recvmmsg net/socket.c:2837 [inline]
>   __do_sys_recvmmsg net/socket.c:2860 [inline]
>   __se_sys_recvmmsg net/socket.c:2853 [inline]
>   __x64_sys_recvmmsg+0x20b/0x260 net/socket.c:2853
>   do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>   do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>   entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x43ef39
> Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffca8776d68 EFLAGS: 00000246 ORIG_RAX: 000000000000012b
> RAX: ffffffffffffffda RBX: 0000000000400488 RCX: 000000000043ef39
> RDX: 0000000000000700 RSI: 0000000020001140 RDI: 0000000000000004
> RBP: 0000000000402f20 R08: 0000000000000000 R09: 0000000000400488
> R10: 0000000000000007 R11: 0000000000000246 R12: 0000000000402fb0
> R13: 0000000000000000 R14: 00000000004ac018 R15: 0000000000400488
>
> =============================
> [ BUG: Invalid wait context ]
> 5.14.0-rc3-syzkaller #0 Tainted: G        W
> -----------------------------
> syz-executor700/8443 is trying to lock:
> ffff8880212b6a28 (&mm->mmap_lock#2){++++}-{3:3}, at: __might_fault+0xa3/0x180 mm/memory.c:5260
> other info that might help us debug this:
> context-{4:4}
> 2 locks held by syz-executor700/8443:
>   #0: ffff888028fa0d00 (&u->iolock){+.+.}-{3:3}, at: unix_stream_read_generic+0x16c6/0x2190 net/unix/af_unix.c:2501
>   #1: ffff888028fa0df0 (&u->lock){+.+.}-{2:2}, at: spin_lock include/linux/spinlock.h:354 [inline]
>   #1: ffff888028fa0df0 (&u->lock){+.+.}-{2:2}, at: unix_stream_read_generic+0x16d0/0x2190 net/unix/af_unix.c:2502
> stack backtrace:
> CPU: 1 PID: 8443 Comm: syz-executor700 Tainted: G        W         5.14.0-rc3-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>   __dump_stack lib/dump_stack.c:88 [inline]
>   dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:105
>   print_lock_invalid_wait_context kernel/locking/lockdep.c:4666 [inline]
>   check_wait_context kernel/locking/lockdep.c:4727 [inline]
>   __lock_acquire.cold+0x213/0x3ab kernel/locking/lockdep.c:4965
>   lock_acquire kernel/locking/lockdep.c:5625 [inline]
>   lock_acquire+0x1ab/0x510 kernel/locking/lockdep.c:5590
>   __might_fault mm/memory.c:5261 [inline]
>   __might_fault+0x106/0x180 mm/memory.c:5246
>   _copy_to_iter+0x199/0x1600 lib/iov_iter.c:619
>   copy_to_iter include/linux/uio.h:139 [inline]
>   simple_copy_to_iter+0x4c/0x70 net/core/datagram.c:519
>   __skb_datagram_iter+0x10f/0x770 net/core/datagram.c:425
>   skb_copy_datagram_iter+0x40/0x50 net/core/datagram.c:533
>   skb_copy_datagram_msg include/linux/skbuff.h:3620 [inline]
>   unix_stream_read_actor+0x78/0xc0 net/unix/af_unix.c:2701
>   unix_stream_recv_urg net/unix/af_unix.c:2433 [inline]
>   unix_stream_read_generic+0x17cd/0x2190 net/unix/af_unix.c:2504
>   unix_stream_recvmsg+0xb1/0xf0 net/unix/af_unix.c:2717
>   sock_recvmsg_nosec net/socket.c:944 [inline]
>   sock_recvmsg net/socket.c:962 [inline]
>   sock_recvmsg net/socket.c:958 [inline]
>   ____sys_recvmsg+0x2c4/0x600 net/socket.c:2622
>   ___sys_recvmsg+0x127/0x200 net/socket.c:2664
>   do_recvmmsg+0x24d/0x6d0 net/socket.c:2758
>   __sys_recvmmsg net/socket.c:2837 [inline]
>   __do_sys_recvmmsg net/socket.c:2860 [inline]
>   __se_sys_recvmmsg net/socket.c:2853 [inline]
>   __x64_sys_recvmmsg+0x20b/0x260 net/socket.c:2853
>   do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>   do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>   entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x43ef39
> Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffca8776d68 EFLAGS: 00000246 ORIG_RAX: 000000000000012b
> RAX: ffffffffffffffda RBX: 0000000000400488 RCX: 000000000043ef39
> RDX: 0000000000000700 RSI: 0000000020001140 RDI: 0000000000000004
> RBP: 0000000000402f20 R08: 0000000000000000 R09: 0000000000400488
> R10: 0000000000000007 R11: 0000000000000246 R12: 0000
>
>
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection
> syzbot can test patches for this issue, for details see:
> https://goo.gl/tpsmEJ#testing-patches
