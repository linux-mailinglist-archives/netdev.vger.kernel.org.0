Return-Path: <netdev+bounces-6832-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 116B87185DC
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 17:15:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 930971C20E62
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 15:15:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B20C1643C;
	Wed, 31 May 2023 15:15:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB76416438
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 15:15:18 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85A97123;
	Wed, 31 May 2023 08:15:17 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34VERHdU031545;
	Wed, 31 May 2023 15:15:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=DLT3nLGkBnr4440mVYZhr5Fum7yk612uNkqxs5BQI6I=;
 b=XwLGV5fUxi4o7IvWmoF6Sctz4Dou4ze+UdB6MdVN3ag3uHC3Dz4De2+ntgOuU8Auws23
 +zBxI/riEwVu9p9jenwxY7dWf3T5+fZZodpylociP0091U9VcBSUZ3ZilFJmpL/Mdre/
 lo7uut6pIRGjKucFrihlAlRFdVMIEtCc/7HZo0HlkhS6L0NswI6yRgmXiY49jwnhHNec
 23Sqfy4NVBXfsvM5ISW/drNSQTbEB+stQc19wodhh25XwuvKgknzxS0ERRSKDfKHC2N6
 jZSv+1A6XENpYuZS5hDVwI67Tzab1rssJpxDmRkeTz/G38+SYR50EfRfF3zRiRqwpDkb 3g== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qvhj4x4e5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 31 May 2023 15:15:11 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34VEa97l019825;
	Wed, 31 May 2023 15:15:11 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2048.outbound.protection.outlook.com [104.47.74.48])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qu8a5yet5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 31 May 2023 15:15:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g3tU480wHML/JOnuVfckhnEfoGOlaTbJstd2yqE5IvvTot45CrS9GyyYxnb3Ms0mG29fWD6jLGEJq8Z0jXK+ZBxEtbHedtz5yPtDcIB0bF0S7whlCJmk74IHKmaz/zWGyjK8/4lGqe7PN90STuGpmjMg3EK62mFNWX8wxq/bGQw7/99JF1Zk3AkZ2eYDkdziEMhYxFINURXiF4H+iGQ7sSnu4ihbXYuMoUXhhRZnxXXoD6MjuETpbtBQfAYLXFjHUSD4HfmmIi8yngtD5+QzDjO+0vgkApGMqxb/1IjlX7EZ/YMwpwrIcjB2XeJXUpJtZUaOe7gY/+/63OBMZBaPEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DLT3nLGkBnr4440mVYZhr5Fum7yk612uNkqxs5BQI6I=;
 b=JCXS1eWzVy2Zq8fj1FrxSWFhImhdvaTCe2CWdvygp1U2pyV4vfD8FFd7pKZE22cLwBkcVL/eLi7TMaMw3GJow/ccvstMray+XGLPK6PCLjSt5Zc6ibuZnpVeb6M0fi4oModsGZ0qnyVZ5UicfvVysZJWzXJiMpcEFp9hK4sbMeNGtcKATmcD6hNQRgIfUi6va5m4I4Nf5H6guYLi/ynwydo89fu8MJBsIO8ypk8Zo4sQjprHNiTfS75fG0lmB3zA1Ic15JuKPHNRU50NS8Kuo5YJANDpGCChklZCsXJF7HOF+LHwWJ8goueH9rkoMLpcKACEQpBKt3hhyJr6GOE1Pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DLT3nLGkBnr4440mVYZhr5Fum7yk612uNkqxs5BQI6I=;
 b=bL8MrYMNcnebWbdsqF3tyAo6u59AcBzb9ehTCh57fxe7LlnITsDlrEYXqAgasZPFCim/QB9OodekUONcvIdW6s9dspA361oGo3wg8HOUj/A2TNiKbivrq5r8vSxK1tTWjI/Z0H+YAsCzXtilJ4ScKLQNgifOTc4MmWeCIU81kJ0=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by DM4PR10MB6136.namprd10.prod.outlook.com (2603:10b6:8:b8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.24; Wed, 31 May
 2023 15:15:08 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::13d6:c3f3:2447:6559]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::13d6:c3f3:2447:6559%5]) with mapi id 15.20.6433.024; Wed, 31 May 2023
 15:15:08 +0000
Message-ID: <43f67549-fe4d-e3ca-fbb0-33bea6e2b534@oracle.com>
Date: Wed, 31 May 2023 10:15:06 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [syzbot] [kvm?] [net?] [virt?] general protection fault in
 vhost_work_queue
Content-Language: en-US
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        syzbot <syzbot+d0d442c22fa8db45ff0e@syzkaller.appspotmail.com>,
        jasowang@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        virtualization@lists.linux-foundation.org, stefanha@redhat.com
References: <0000000000001777f605fce42c5f@google.com>
 <20230530072310-mutt-send-email-mst@kernel.org>
 <CAGxU2F7O7ef3mdvNXtiC0VtWiS2DMnoiGwSR=Z6SWbzqcrBF-g@mail.gmail.com>
 <CAGxU2F7HK5KRggiY7xnKHeXFRXJmqcKbjf3JnXC3mbmn9xqRtw@mail.gmail.com>
 <e4589879-1139-22cc-854f-fed22cc18693@oracle.com>
 <6p7pi6mf3db3gp3xqarap4uzrgwlzqiz7wgg5kn2ep7hvrw5pg@wxowhbw4e7w7>
 <035e3423-c003-3de9-0805-2091b9efb45d@oracle.com>
 <CAGxU2F5oTLY_weLixRKMQVqmjpDG_09yL6tS2rF8mwJ7K+xP0Q@mail.gmail.com>
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <CAGxU2F5oTLY_weLixRKMQVqmjpDG_09yL6tS2rF8mwJ7K+xP0Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM6PR05CA0052.namprd05.prod.outlook.com
 (2603:10b6:5:335::21) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|DM4PR10MB6136:EE_
X-MS-Office365-Filtering-Correlation-Id: 3f0c4e90-f696-40a7-cc3c-08db61e9d214
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	lmu/820h2+WGJfrXXrrHcQ9OIQ0FAMxEDQWuBt8ujrSL4KVWrUG3R0OCez0isHpG7uzLw8uqLe+DpLThCkL5kSNyOMYR/zgQiPMgN1rNk3NyV+9Qnfdc+mFoJ2J0FHWevgcV7mHG3twBdCPt+NnL63Z6bdsy4/P/hj93LJMp7Ypg5vNsBUJshu4wMdWHMWwCq/1fDK1PlzXwcdAGhSOZLMKYpGn7x1Ipq2NT88/jBMzJAO98v28+wIFb/wD03aQYBjayz66IWvwSjBlqHNDGqAyAAA4bJUnIbHZWJJdV1VT8t9rt0zRp90SzSsF4cyB7PGKgIu2au0h2aWkJjfs0n8I+vBfuaE5hTEte2VKaVua7CR/Yzxyz28mNqwXZ1cIDCa3ASlDFv0QChpDJd5p7k+SifZqsVGd++EpMUnUAmWzuURyKQS9qRfWqgYUxWCQTM07E1lDBvLl6ZSH89X/zeHDXJRcRaPnOj9WgXvTYl0fmrs7mixhKwPT7B6iIu2la90ag/CXKHpwhfjLVOuCxcIeC1HMCJx+w/zDmaz5yCWUl/HHlsau3x8iORUGez2ciLuS029AjMIW8Gz60SEEG49pLRtYInBcoUf7RSWTTXDv835C0NtqcpTwpobeZ5D//kMJKYTl8Qmb0JgKl3pt/7g==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(136003)(366004)(376002)(39860400002)(396003)(451199021)(316002)(66476007)(66556008)(4326008)(6916009)(478600001)(54906003)(5660300002)(36756003)(7416002)(66946007)(31686004)(8676002)(6486002)(41300700001)(38100700002)(8936002)(86362001)(2616005)(6512007)(53546011)(186003)(83380400001)(31696002)(6506007)(26005)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?TmtJUHBQbDhHSEppbnkxVlhPanp0WGVJSFZXd2lVeHhxelVGa0FjQzVvRjVq?=
 =?utf-8?B?OU1yT1A4QzZDblZ4bXpyMkwrMEUybXlYcEFFZE1Edm5MMy80TlpMK3hNYWZq?=
 =?utf-8?B?bzVSbmxjeS93YTR1cmpuMTY2aHNkakQyZkpseEZhNkdyTXlOLzhRR0RWdWUy?=
 =?utf-8?B?NU1ycjBBQWxLUkpsMDlwSUlJQVE5bnZXYVprazFURnBjTlNTWEJRVGkxTFlY?=
 =?utf-8?B?S0tVN0hQc0V0SnVQYzIzUUFwTzllK3VMMGt5S05WVWNpcVJkRjZjVTZLK0ox?=
 =?utf-8?B?UjZBaGZXM20wL0M5bEdjcTVGUzhPdFVuTFdtR3B2OEVHaENoVkpXOWlxd0pO?=
 =?utf-8?B?eXVOa2FuYXNQbUpuWnY3TTM2M0FNOHBHU052dnU5L0xpYktpNzFYOGt5UFZq?=
 =?utf-8?B?Mmc1ZDZKcFVRWVRpUSs0c21ESHk1WVdFRW8xT2hyQlVjOTFVdzNLc1hsWS94?=
 =?utf-8?B?N245Y09qbSt6VTlFdk4yeVBCb3cycHJwVWRtMW5qYlpseGxPaHhBQU5mKzMr?=
 =?utf-8?B?SEs5Vm9LYWgrdk9xcm8wTFlwbXlEa3dQK0lNblRKYlhaY21ZVVBZN0pMaXBW?=
 =?utf-8?B?Z1dUcmdFZ3VNMDgwM3pTd3REUGM5NXM3dXhWZFhGVEx6eFBNRUtXeFdVcE1i?=
 =?utf-8?B?ZUQ4NGg3bTE1QUJjZEc1S0k1ZjQ2MllUVE5XVU1IRndjK0RIUkoxNk5YSUZj?=
 =?utf-8?B?a3lmRDJnNUxJenhhU09XS3BleUw3aUx1S0hKanZialRuc081bTdJK3pyd2ZI?=
 =?utf-8?B?dm5uVVZHSENhZ241ck9VeVdWdTBkczZZd1RNSW5TUUFPN1I5L2ptaVovdi9i?=
 =?utf-8?B?T3NGbnJ4ejUyZUhKRFk4ZFRQVG9pelRIZ2VrTE53Skx3eFlmOXpVT3hlS1Z3?=
 =?utf-8?B?MFNrWWhrVkZ6S2tVb1NvVDVTU0I3MmdDa0JTUG4rTklKUGRqMGNQZFdUM0M1?=
 =?utf-8?B?QzROaFhBZTMrQ1NHTG0vakMxZEJMY1R4aENlZFpSdGM2MlpkNUxsSjNBMXBy?=
 =?utf-8?B?R01qMUVNWmRsYkZOM2ZpL29zbzVuNXJ3bEpVeXpjQmJhekgyUHR5M0Zzb2Jy?=
 =?utf-8?B?ZDZ1MjkrU1IrbWgzY2FvNWZPak8raG5ic2J4aTRvOGwzUGRaZ1JsUUlOeTl1?=
 =?utf-8?B?TG1ocmduWXhGS283RFZ2YTJlTU1ESjFtY0wvaStURzFrcjNtemp6d1l6ZTlt?=
 =?utf-8?B?NnE1SzJuMTBsSWFUc2tPd2xUZGlIcDl2TDA1YjJlUVNGc292U004VWlxaVdr?=
 =?utf-8?B?Vkc4Q051T1hRUXMrWVhyVUF0aGVxd0pqMEdPU1lnME53WnA4OTdMQUIwc2Zi?=
 =?utf-8?B?Tlh3N2JHeFhHdWVCeGthOUp3SFFuUFluanZwa3VEVndQSU5ZZ2FlUW5vNjVB?=
 =?utf-8?B?YW82NG5UZXllUUNrRXpNa2FWTEZsaGtDZGlFaDhBVzA3SHdjYWVOQTE0U2Vo?=
 =?utf-8?B?NVJ4YXE4Nk5YUFA3bDVoRDNvb2lhRWxSVjU1RUU5OFE0ZzZQQXA2bi9XdTZx?=
 =?utf-8?B?dmFZTlFFcUdLRTF6clo5akxwRTAvQ0Y4dmhoOEhEK2hiMUhsRmxzcXhMVmp2?=
 =?utf-8?B?dXlTZnJFb3lSdTQxUm5zTnIwWDh4cmdjdG1VTlozNzE5eGkwL1JjQW9aaGl1?=
 =?utf-8?B?b0tsVWVXMkt0SnFWcmM1OU9OM1B5R25maXlGQUZUbjNvOFhnWm1pSVRnUmlh?=
 =?utf-8?B?SlNUNmR1WjBkUFcvaGdWU1VyMzF0a0g1UFJMeHhBei8rZDZYNnVqM2RIQUIx?=
 =?utf-8?B?ajB6cUlVbFI4OW1iU0o2UUxxVmp6UWlpc29MejVZaTFQWUZDYUVJRzNPdlo0?=
 =?utf-8?B?d1Flcm83ZUhYRlFIUVhrNldnVm1pVlp3NGJmcy9Ba3A2Mklyb3c2UnlxMFJl?=
 =?utf-8?B?K3RINkM0NFpYRGxvdXN1czF5MXhyN3Voc2NQL1VrelppQ3lzZGVNejRNSnFo?=
 =?utf-8?B?RlVWdzEwY1BaVjhPTXJPeTF0K0Z6SlBlWFA3WldWai9QcWtYYWhQVTQ5MWx1?=
 =?utf-8?B?YmZ3dzZaMGxjUTQwdllzZGZSM09vdWxHQlBtdkF1aTdCVUtxWG5IaWtsYWMz?=
 =?utf-8?B?M1JBSnQzaTREMlZGZEMvNzJqTkdITVRvaHVRaXFub3AxVHdaRW92MTc3UGpk?=
 =?utf-8?B?RkUrMS92RnRjQVRTL3Zod3VJTk8yWFVCaHRKWWh1MU1jS3l0clhDNDlaUVJM?=
 =?utf-8?B?ZkE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	=?utf-8?B?S2t4V0VKV1BGUlhqcjhKa1Q2SVEzcm9rdFUxUUF4SUkyUkFGVVlXQUFGWXpj?=
 =?utf-8?B?bW4zSlUwQ09yQWN1MW5QUHRNYW5XVWRJNTc1NHliWnMvaFduTnZXYjg0cmxR?=
 =?utf-8?B?ODMwZk9KQzJoWjFUSGRpTGRUdlNzWVI5a0dEc0lsSFV4b0doUWwyajVZZkZ5?=
 =?utf-8?B?Unl3dlVnVnVKdXF0aFQySGdOeG5wRk9EWnV0MlBuZHR3V1p6dmcrYWtxODNW?=
 =?utf-8?B?ZkE5eG1adWpNQXR1TGpibU9aaFNJT0NZVVo0N0xvekMraEJlMVFGQ3dkbFJD?=
 =?utf-8?B?K2ZRcThpMGFGNGllM0Q5YXNOSWo2dGFsOXFTSDhoeWRzNldabWRDdWpUaTdj?=
 =?utf-8?B?a1Yxa01vNTREcXFXWVNOT013ZXdmR0xRaFlYeXpvcE5HSDNrVndYOVlaeTVW?=
 =?utf-8?B?N291V3ppdTQvL1VYS2dwdDNsaHB1ekozUUtOWHNCTXc1T0lmZlZsSHlVeEts?=
 =?utf-8?B?d0Evd3JZL05vNUprWGtsNWIreDMwQ3JaM2dpV2x6a2UvYnRJWis5K0g3ZXNG?=
 =?utf-8?B?RmNOQXFUZVVQUUd0SGpQRzJCa01ZUE1HQlBYeHkyTmJ1aWJLRE1lOEJ0aVl0?=
 =?utf-8?B?S3VnUDB6N2ZnT2UrQWJDTjd1T1dzSjFiU2V6aTZFQTZGZS96ZVN6MjQrenpn?=
 =?utf-8?B?ZkVQamdMWlJWYm5PZnd5YjNTdnh0Wms4cFFENCtJU1FaS2dPMXM4WHBkQzBo?=
 =?utf-8?B?RHNYV3ZqWHBXUlE2MGJNc1I2RnJzQzhBUElCWWdDcUFuNGE0dXJlYVpLVVFC?=
 =?utf-8?B?NEVSTDVRenM5Uk1jQzdyV3pGMW44dGdUNExFVkZObFByK3A2K0lVYURJZGVl?=
 =?utf-8?B?emh1bzQyaWpBVW1OYVlKK1dKN0FLN1dPVXlNNW9BZlZNRW9zd0w3SC82RFFj?=
 =?utf-8?B?VUFncmgwYTU1dHJRQ09BTlkzRmxxTWRGczY0aHdRYTZJSWF0MkhDQlR5ODB0?=
 =?utf-8?B?bFN6a3MraXRWTWVsbnpzT0pBOUdFeVluWmZncFRhRU4vNnd1SGRZQ2Q5SzRO?=
 =?utf-8?B?K0Zsd0o4RGxPMVBtRDJYQ1M5eVlIUVpDV2tkQWZ4V2NvTnd3c2dQbmNRMjNS?=
 =?utf-8?B?SWR0ekVWTXVYWCtZSERNN01pZFFoU05YUUwrTThMczBPTE9QTnZsd0ViUm5S?=
 =?utf-8?B?VzR1WVp4UnZFYkMvdVUrbC96UmwwYXhMMnhJdXE3Y2R1SUpUZmFRdzFzV25j?=
 =?utf-8?B?c28vdW01UDVkOTgvT2pVektibitvZjU1NG9ma0p4Qk1MeGdxNkxkQ1M2SUJo?=
 =?utf-8?B?WmhQSTNqY2V5bzhTdU1RVVByTWRtcTgveTJJeXJkZDZUa0pKV2FvV0FpQ3Vx?=
 =?utf-8?Q?nSlCbGG5c7kCE=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f0c4e90-f696-40a7-cc3c-08db61e9d214
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2023 15:15:08.3872
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8Xd2l0QhMCyDz+fGmSAALQosdOcDqzEnkPErYdWPtqgYyvWJeNFTD/qA3UUn9txx3vfWsTVXDBpCGSeNUFG9XisweH40DyRgZ+vMMCNrPKE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6136
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-31_10,2023-05-31_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 phishscore=0
 bulkscore=0 adultscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305310130
X-Proofpoint-GUID: gmWdtDezSndEFaGTwnoxf_4tOUl4ptfu
X-Proofpoint-ORIG-GUID: gmWdtDezSndEFaGTwnoxf_4tOUl4ptfu
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/31/23 2:27 AM, Stefano Garzarella wrote:
> On Tue, May 30, 2023 at 6:30 PM <michael.christie@oracle.com> wrote:
>>
>> On 5/30/23 11:17 AM, Stefano Garzarella wrote:
>>> On Tue, May 30, 2023 at 11:09:09AM -0500, Mike Christie wrote:
>>>> On 5/30/23 11:00 AM, Stefano Garzarella wrote:
>>>>> I think it is partially related to commit 6e890c5d5021 ("vhost: use
>>>>> vhost_tasks for worker threads") and commit 1a5f8090c6de ("vhost: move
>>>>> worker thread fields to new struct"). Maybe that commits just
>>>>> highlighted the issue and it was already existing.
>>>>
>>>> See my mail about the crash. Agree with your analysis about worker->vtsk
>>>> not being set yet. It's a bug from my commit where I should have not set
>>>> it so early or I should be checking for
>>>>
>>>> if (dev->worker && worker->vtsk)
>>>>
>>>> instead of
>>>>
>>>> if (dev->worker)
>>>
>>> Yes, though, in my opinion the problem may persist depending on how the
>>> instructions are reordered.
>>
>> Ah ok.
>>
>>>
>>> Should we protect dev->worker() with an RCU to be safe?
>>
>> For those multiple worker patchsets Jason had asked me about supporting
>> where we don't have a worker while we are swapping workers around. To do
>> that I had added rcu around the dev->worker. I removed it in later patchsets
>> because I didn't think anyone would use it.
>>
>> rcu would work for your case and for what Jason had requested.
> 
> Yeah, so you already have some patches?
> 
> Do you want to send it to solve this problem?
> 

Yeah, I'll break them out and send them later today when I can retest
rebased patches.


