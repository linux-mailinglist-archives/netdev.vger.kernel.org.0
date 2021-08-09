Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42CDF3E4CE8
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 21:17:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235987AbhHITRY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 15:17:24 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:53788 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231439AbhHITRX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 15:17:23 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 179JFWGC012759;
        Mon, 9 Aug 2021 19:16:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=3D7mp34YzCKI1iQp/qhPscuW5WfQpNidZZxIUwyxZC0=;
 b=uVu7VjPa+PCQ9DqK/OhrNpRw8mBIqB0NK8uQYCdOBkxLliANkpxO1vCn+5H4MOfkBF05
 I/5vomurLDkMKK1qjPEmWX9Nx+B/aLQs2JyzNld/UMsVrLxNQTv7fZkSUW2jkfO8wv6v
 kWiJYSYKVNU61KHXUdT0RuNONQp7FjVR9Yobjhze8KXqgraqFgUSkSlrGk0rO6hVdJvM
 aEwzcOa4qkQr2DIHSxres/qxZ7hz7ZvGwAE4JYWstDEwgOeltAPeffiKY3D22QPeT3Bi
 1X6DA3fPUROlOZL+Fuzq1zQIrltHr/DuBswT78P+jYgR8Ch5k3FQAL8ABDc0Gygts1Rd nw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=3D7mp34YzCKI1iQp/qhPscuW5WfQpNidZZxIUwyxZC0=;
 b=kQWWQ+QlDRQTk4cEgLedZteNHZJFStfb4RtiKodoxtrWQRd08j0XVzGGEhZaOqx75V89
 WO9JRla7uDcJ6XYmcoKslq8wSfZqtvVDkaQjbPn1afTe3h0bQq1YL8eEZk3hfB4ZtbGs
 YvsbYRgfcB7Mtg9idSqIXYXaz5P14zqfvqPHD7AUeJ0RXaxG/4/5eQbD+x9dqah2AhPA
 HJpcdRRygFKDzqSE2qjAmPptb4/eKKAVLgjknjq6gAGYXH/cZe/UUmP2+9IaRvnvJXGC
 S9nXY8sPxiW+ZCc82LQ7IKn/wvnzWcrsjtDusYWkc/7Gir5xvrFvXR4MdO/QyL4BcJ7G eQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3aav18j48k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 09 Aug 2021 19:16:36 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 179JG7xv057572;
        Mon, 9 Aug 2021 19:16:35 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2044.outbound.protection.outlook.com [104.47.66.44])
        by userp3030.oracle.com with ESMTP id 3a9f9vhnrn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 09 Aug 2021 19:16:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O8rzdUE/PSm5BpiFlL9ThylpYOmHujinTCIjLHlcmGK9cjhLSkQ+FXGb/afSBbAZZTZVRSN+PN6L62AmeqEIZxuH0D5bQFiWpTpJ9eFq3Eooabi2+IjsBxhZjT9Ybijy7iSPc7/62w0oHDQXPOVowb+8Xz4747nahZ3Vs1RCO7gAOYvgw6yXvZoGWLoXelEj8+HgrCNt5vz0E7gNNmn6zk/pRML2R8/37MqsHdOdLg+HR0AEUkGW3yBi2gvaaEx+Ymt+lZleOXQgNOd0plMQ+PQC7MrxCfR7Jnm4a3pnSnGajejmtrgcDioh1TyU8PQLduL/jK9AHfna5ytjNfvcjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3D7mp34YzCKI1iQp/qhPscuW5WfQpNidZZxIUwyxZC0=;
 b=QAfm88HuUsni9jRLfl//aXwHFxpvRCKo2UfPq6zrraGkPx+/1/dKjV0d4je6W13yhvR+3tEBBj68xjxaMXzJRc9fKmwqucu/mGqUUtTvme8IuaaRcBGQau/Oz9cw55hpdtrsZmhkTPn7tKf9BSjpeXgDVTPn4BX6XnyweTIL2kso9wzWCTVXvOeQH93Kktvh9U6L1KffqZtXUYtsgiVzD4iZ/Gg0DZ+/b5koX7NuBROLyQIdXGyxtXqIBwtko7lPhPRi5FuS2JUduTfVCjreUwc4Va7ieinFedrPNJrjtVT51Ya2dCW4I1XOUuv3Ys1AOFTxP+M/ZuyCMt0Zk4SIAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3D7mp34YzCKI1iQp/qhPscuW5WfQpNidZZxIUwyxZC0=;
 b=tA/FtBM4L0Yi7sD9iHM+KL3XhQePWtP+LBBdOPZtIBCynFlmtB9PuLxzeVfy0uA3/4tIuIe6bC1h3odRdTunRo9xXnjpzpKLHbDybpKI6edgx65MDEqzhGvrjdN7dUmHFwjzzNSzQJ9Za2i5ro8hNzXdEib3OKpZf1rzL9mSmes=
Authentication-Results: fb.com; dkim=none (message not signed)
 header.d=none;fb.com; dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB4494.namprd10.prod.outlook.com (2603:10b6:a03:2d4::12)
 by SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.21; Mon, 9 Aug
 2021 19:16:32 +0000
Received: from SJ0PR10MB4494.namprd10.prod.outlook.com
 ([fe80::588f:a774:17de:1d1b]) by SJ0PR10MB4494.namprd10.prod.outlook.com
 ([fe80::588f:a774:17de:1d1b%3]) with mapi id 15.20.4394.023; Mon, 9 Aug 2021
 19:16:32 +0000
Subject: Re: [syzbot] BUG: sleeping function called from invalid context in
 _copy_to_iter
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     syzbot <syzbot+8760ca6c1ee783ac4abd@syzkaller.appspotmail.com>,
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
 <0c106e6c-672f-474e-5815-97b65596139d@oracle.com>
 <CACT4Y+bK61B3r5Rx150FwKt5WJ8T-q-X0nC-r=oH7x4ZU5vdVw@mail.gmail.com>
From:   Shoaib Rao <rao.shoaib@oracle.com>
Message-ID: <e99cc036-2f83-ff9e-ea68-3eeb19bd4147@oracle.com>
Date:   Mon, 9 Aug 2021 12:16:27 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <CACT4Y+bK61B3r5Rx150FwKt5WJ8T-q-X0nC-r=oH7x4ZU5vdVw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: SN4PR0601CA0002.namprd06.prod.outlook.com
 (2603:10b6:803:2f::12) To SJ0PR10MB4494.namprd10.prod.outlook.com
 (2603:10b6:a03:2d4::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2606:b400:400:744d:8000::918] (2606:b400:8301:1010::16aa) by SN4PR0601CA0002.namprd06.prod.outlook.com (2603:10b6:803:2f::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Mon, 9 Aug 2021 19:16:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4442ff17-c1b6-4459-4deb-08d95b6a3250
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4429:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB44292ADB825765F12F9E0CA9EFF69@SJ0PR10MB4429.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: twx4kWIn3CiELpAZhVTubBzonOG0CYM/oSXGqx5l+6hOTVTHc51XQ/GubHIXK09u37q7PcAKZE02KcU/vu0eUv0pLKGagiihOBDkiEnP0O3K/QvgpkcjEqnTJwOMWeteqUbhXHh6cmhamlNBQHVVkFwlyN9SIf6MfoyZb4qdDevjAqno8eDNZOjVWFm6nARpTCvmnt23Cr9BbNBZAZvsxqJyqlqnC2sYbtQ3fYudqpm6svU79ohtB5ozdBX0LCVH3y6/iABY96Hh5iYf3EkWMQCQPkKt5BYR4fiO1rhqX1dFe97dIdIBvRzPt58Zl4Ezoezbb3cHbBF4FgFOZsk1pqqMnUYQgs3KPFXWAS6gSPkfl+AeoSSh/P8viZ5uQR7aqihu+Iikuw2aK0MQoPAqHEoVlVqujM1F/zgj1mkvyl//L04D7PCBd4FJG/9KJC4Ug4yyOYyQI1rYXrkj/KD3P9Rnhzn6mI3yjjTAzCxZnqLGY8veOU4Rhl9UJMNKBBl/IMhnL+UJm03RdCQBCG3jEhX2ZB7tXxuOLvrDIpKK5qMc9JUltOST/aVy77mu6pGZY/OxRdginxqQvnX34RWubu+y99PW+sxevEjxu90wPprT6zVV/TEgi4PyR/SZfv3exQi1eY9dEdRwbg+IhKR3BH8+kKItu6ytjoW8hfvO5K+mwdav0AS2lJ2LIozocXv4/alrpKLxBRPjd55WXa7V9ShmhpjwYHZy3rWvexUNi7t6Q/yz1cHImEoXPOKUKCQpQbT00isw6nogNW/W4zZ36YCOU3AzmsnT8vXJff4T4aEKxK4Me9+SDGwKIpURmKDHxlHwf+w2iSr1H5vGTQXg37wBz9wDALa8grR4FWd6ThgL5aIAnZ6kA7Wyfa7k1SI4aBpd4cZmafKw2LDnoESSDw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4494.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(39860400002)(136003)(376002)(366004)(31686004)(31696002)(2906002)(186003)(66556008)(6486002)(66476007)(5660300002)(66946007)(30864003)(36756003)(966005)(83380400001)(4326008)(6916009)(478600001)(38100700002)(7416002)(8936002)(2616005)(8676002)(53546011)(86362001)(316002)(99710200001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YXQ2cFdFWmZydTZvRVpVSUE2RjhkRzBHVmtkcVdWOFpWR1BJbWQrLzBUTkdk?=
 =?utf-8?B?cWw2bDBzRXl6eUZ4RGRnZStyOVR5dFgzcDVpWXBpb1o4TTRKY2JMYm16R0dP?=
 =?utf-8?B?MGlLTWlnNGxCeTBDVmozZitHWlVxR2tpRzZ0SkhNVnFxOWF3bFYxUEV6N2tT?=
 =?utf-8?B?MXhVTlpsRVp5cVRsRkRTcmRkdVY5UDhEWjY1bGduczZCY2psS21JSzVwcWdt?=
 =?utf-8?B?MGg4VTQrSVU2SXJjOERCMmV4SC9jZFh5azFtUklNQTQ5WWRJVnN3NmJGWkJr?=
 =?utf-8?B?OCtXK1prWE8vS012L1VPQUFZbm5ad2pqdk02UGVPaDViOHY0Z3QvTC9qL3E1?=
 =?utf-8?B?elp1d2NDMGRhbCsxajF6MGhIaURXQks4bUdiSWdDU3M2NHFGcWNORHBieGt0?=
 =?utf-8?B?a2t1UWliaXVoWWc3ZUdXT0tYTkRnZFRPRzBOMk52YUQwUENaWXdDdCtlOVo1?=
 =?utf-8?B?b3VRVnhGUVFLaTUrZDZOdUQzWFYrd1JqM0lQZWV4V2UxdU15cVNuTTk5M08x?=
 =?utf-8?B?SnpXekhlQ0tKL0J4NzRtRzd2M2pCT0xxUEdOMjRaYS9KUWIzdXZHQm91RjRB?=
 =?utf-8?B?U1NtL2ZFTUpMZ2htOERtMkgwWEhPZFhaVlFJb1ozYUdMY3VCV3AxZWEwd2c5?=
 =?utf-8?B?NjNJakdiQ2d1QjBBVndVUUwvOHBvTFAxRnIzM3RVckNJUnpKazNpRjBQQnhO?=
 =?utf-8?B?OHJUMFJVMlZSdmxGODZxdEQxaWxQK2J3WWtjS1BUYUtSUWpMaTc5SlJVZWow?=
 =?utf-8?B?R1VuaGNVMFpqRXlWMWN5azVwOTFjSGZFMm5oMFZaUEsrR3d4ZjNsK2RGeWJh?=
 =?utf-8?B?eXpJQjNXeWZWemt3YXNCRXh6NTlLOHpnaURxS0NGUllzZTJZZElTbHMrRFRK?=
 =?utf-8?B?eWRvRlRyK2NDMDZsbFhJQVZ0ZXVIZFRCQU5JK2FQTm1wQnkrcDlHV2RnLys1?=
 =?utf-8?B?SldORlNmT3ZXVUpVK0ZBRmF6UlU2K0ZTdXJxY3VoN3lYNDI1WUxSeVdxWEhW?=
 =?utf-8?B?ZzlMQ0RNMERaRGFGajVXaXNTTGFKamNnbjVON2NhTGJ3UEhvTTFRRkJOT2hr?=
 =?utf-8?B?ZFNJaUV2blNaNHpjd3ZpMTAxL3ZJbHgyZDhoVWdjVlRsQ3F0dkVuV1JVeUR4?=
 =?utf-8?B?YXJBZUV2bkJPV3FRSHFSZ0tHaEY3OE42anVnaUZHWGxwK0ViTzJQMzFqdTY1?=
 =?utf-8?B?R2lqVTIycFgrT3EwSlhCNEN6eUZ4N3N0cmJsd0pwU3BHUElqbFlIdjVvOXhu?=
 =?utf-8?B?aEdQT2tPL0pLQkRJNGpxajhmeXFaMDVuNTAzMTFKMWxPWjZGT1RpQ1ZwaWli?=
 =?utf-8?B?Ylh1eDBkVVNnbVpoTVJFOUxYbDA2Zkd3K1RnVTJXRG0xQ01LQUVmUXQycXYz?=
 =?utf-8?B?Wk9QU3dUOEhJQzA1VkU1VDlxUmlOb3N1ZmZMR0pkZjdUcjJiRDJTeVJGNzNz?=
 =?utf-8?B?eW1DRnFEVElSb20vUUhSRWNmRGJ3UDJOU3BReXozZTZTWDBKTWZOM1A0NEh3?=
 =?utf-8?B?OWd4eHphVDc0elZUSUlJVTM5TEMyMis5TUlSRmhxSUtoS3RNYmdjYnVXNVlZ?=
 =?utf-8?B?MTkwYkpHczJkVkkwYmlkNzRIMXFoZGtpRnNDa2JPUE1sQ25sMnZMUXQ4TVpB?=
 =?utf-8?B?UmFEU1ZFaXFqemtQVmdOYnNMUk50OWhLSmNMZEpuWDdnNHY4Y2FtSTcxMEhJ?=
 =?utf-8?B?cm5HQmJxRkxBbm1BSjNrZnkvZmhLcnVxZDZxeHBHMTBuTVNJQWNVYSs0NmJS?=
 =?utf-8?B?L2xodTNvUDk2V0Z2YUNRckdOMTRyaUdSTEdGa0dKWHY4bitkL0I5NVp6V3VT?=
 =?utf-8?Q?hhEUSFVKlgFU8nP5/alKPyWUUvMvfDJKUtrFE=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4442ff17-c1b6-4459-4deb-08d95b6a3250
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4494.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2021 19:16:32.0889
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dmsE24KA6uRMKdmRqjdf7VQblNkYYhV5sj3/+JEgB5862lRNy03XfdFCY+yO3CcCNJh9xkaqFRMsKn+12Xrodg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4429
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10071 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0
 adultscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108090136
X-Proofpoint-ORIG-GUID: Avl4WzAeuXCdb_xe_0dC2BaAysFlsd_R
X-Proofpoint-GUID: Avl4WzAeuXCdb_xe_0dC2BaAysFlsd_R
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 8/9/21 11:06 AM, Dmitry Vyukov wrote:
> On Mon, 9 Aug 2021 at 19:33, Shoaib Rao <rao.shoaib@oracle.com> wrote:
>> This seems like a false positive. 1) The function will not sleep because
>> it only calls copy routine if the byte is present. 2). There is no
>> difference between this new call and the older calls in
>> unix_stream_read_generic().
> Hi Shoaib,
>
> Thanks for looking into this.
> Do you have any ideas on how to fix this tool's false positive? Tools
> with false positives are order of magnitude less useful than tools w/o
> false positives. E.g. do we turn it off on syzbot? But I don't
> remember any other false positives from "sleeping function called from
> invalid context" checker...

Before we take any action I would like to understand why the tool does 
not single out other calls to recv_actor in unix_stream_read_generic(). 
The context in all cases is the same. I also do not understand why the 
code would sleep, Let's assume the user provided address is bad, the 
code will return EFAULT, it will never sleep, if the kernel provided 
address is bad the system will panic. The only difference I see is that 
the new code holds 2 locks while the previous code held one lock, but 
the locks are acquired before the call to copy.

So please help me understand how the tool works. Even though I have 
evaluated the code carefully, there is always a possibility that the 
tool is correct.

Shoaib

>
>
>
>> On 8/8/21 4:38 PM, syzbot wrote:
>>> Hello,
>>>
>>> syzbot found the following issue on:
>>>
>>> HEAD commit:    c2eecaa193ff pktgen: Remove redundant clone_skb override
>>> git tree:       net-next
>>> console output: https://urldefense.com/v3/__https://syzkaller.appspot.com/x/log.txt?x=12e3a69e300000__;!!ACWV5N9M2RV99hQ!fbn9ny5Bw51Jl6yrU93iULDBXa_DPjyVIgQuZWyQbCo5IRkAzvYs6JKlPHEdQcWD$
>>> kernel config:  https://urldefense.com/v3/__https://syzkaller.appspot.com/x/.config?x=aba0c23f8230e048__;!!ACWV5N9M2RV99hQ!fbn9ny5Bw51Jl6yrU93iULDBXa_DPjyVIgQuZWyQbCo5IRkAzvYs6JKlPLGp1-Za$
>>> dashboard link: https://urldefense.com/v3/__https://syzkaller.appspot.com/bug?extid=8760ca6c1ee783ac4abd__;!!ACWV5N9M2RV99hQ!fbn9ny5Bw51Jl6yrU93iULDBXa_DPjyVIgQuZWyQbCo5IRkAzvYs6JKlPCORTNOH$
>>> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
>>> syz repro:      https://urldefense.com/v3/__https://syzkaller.appspot.com/x/repro.syz?x=15c5b104300000__;!!ACWV5N9M2RV99hQ!fbn9ny5Bw51Jl6yrU93iULDBXa_DPjyVIgQuZWyQbCo5IRkAzvYs6JKlPAjhi2yc$
>>> C reproducer:   https://urldefense.com/v3/__https://syzkaller.appspot.com/x/repro.c?x=10062aaa300000__;!!ACWV5N9M2RV99hQ!fbn9ny5Bw51Jl6yrU93iULDBXa_DPjyVIgQuZWyQbCo5IRkAzvYs6JKlPNzAjzQJ$
>>>
>>> The issue was bisected to:
>>>
>>> commit 314001f0bf927015e459c9d387d62a231fe93af3
>>> Author: Rao Shoaib <rao.shoaib@oracle.com>
>>> Date:   Sun Aug 1 07:57:07 2021 +0000
>>>
>>>       af_unix: Add OOB support
>>>
>>> bisection log:  https://urldefense.com/v3/__https://syzkaller.appspot.com/x/bisect.txt?x=10765f8e300000__;!!ACWV5N9M2RV99hQ!fbn9ny5Bw51Jl6yrU93iULDBXa_DPjyVIgQuZWyQbCo5IRkAzvYs6JKlPK2iWt2r$
>>> final oops:     https://urldefense.com/v3/__https://syzkaller.appspot.com/x/report.txt?x=12765f8e300000__;!!ACWV5N9M2RV99hQ!fbn9ny5Bw51Jl6yrU93iULDBXa_DPjyVIgQuZWyQbCo5IRkAzvYs6JKlPKAb0dft$
>>> console output: https://urldefense.com/v3/__https://syzkaller.appspot.com/x/log.txt?x=14765f8e300000__;!!ACWV5N9M2RV99hQ!fbn9ny5Bw51Jl6yrU93iULDBXa_DPjyVIgQuZWyQbCo5IRkAzvYs6JKlPNlW_w-u$
>>>
>>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>>> Reported-by: syzbot+8760ca6c1ee783ac4abd@syzkaller.appspotmail.com
>>> Fixes: 314001f0bf92 ("af_unix: Add OOB support")
>>>
>>> BUG: sleeping function called from invalid context at lib/iov_iter.c:619
>>> in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 8443, name: syz-executor700
>>> 2 locks held by syz-executor700/8443:
>>>    #0: ffff888028fa0d00 (&u->iolock){+.+.}-{3:3}, at: unix_stream_read_generic+0x16c6/0x2190 net/unix/af_unix.c:2501
>>>    #1: ffff888028fa0df0 (&u->lock){+.+.}-{2:2}, at: spin_lock include/linux/spinlock.h:354 [inline]
>>>    #1: ffff888028fa0df0 (&u->lock){+.+.}-{2:2}, at: unix_stream_read_generic+0x16d0/0x2190 net/unix/af_unix.c:2502
>>> Preemption disabled at:
>>> [<0000000000000000>] 0x0
>>> CPU: 1 PID: 8443 Comm: syz-executor700 Not tainted 5.14.0-rc3-syzkaller #0
>>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>>> Call Trace:
>>>    __dump_stack lib/dump_stack.c:88 [inline]
>>>    dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:105
>>>    ___might_sleep.cold+0x1f1/0x237 kernel/sched/core.c:9154
>>>    __might_fault+0x6e/0x180 mm/memory.c:5258
>>>    _copy_to_iter+0x199/0x1600 lib/iov_iter.c:619
>>>    copy_to_iter include/linux/uio.h:139 [inline]
>>>    simple_copy_to_iter+0x4c/0x70 net/core/datagram.c:519
>>>    __skb_datagram_iter+0x10f/0x770 net/core/datagram.c:425
>>>    skb_copy_datagram_iter+0x40/0x50 net/core/datagram.c:533
>>>    skb_copy_datagram_msg include/linux/skbuff.h:3620 [inline]
>>>    unix_stream_read_actor+0x78/0xc0 net/unix/af_unix.c:2701
>>>    unix_stream_recv_urg net/unix/af_unix.c:2433 [inline]
>>>    unix_stream_read_generic+0x17cd/0x2190 net/unix/af_unix.c:2504
>>>    unix_stream_recvmsg+0xb1/0xf0 net/unix/af_unix.c:2717
>>>    sock_recvmsg_nosec net/socket.c:944 [inline]
>>>    sock_recvmsg net/socket.c:962 [inline]
>>>    sock_recvmsg net/socket.c:958 [inline]
>>>    ____sys_recvmsg+0x2c4/0x600 net/socket.c:2622
>>>    ___sys_recvmsg+0x127/0x200 net/socket.c:2664
>>>    do_recvmmsg+0x24d/0x6d0 net/socket.c:2758
>>>    __sys_recvmmsg net/socket.c:2837 [inline]
>>>    __do_sys_recvmmsg net/socket.c:2860 [inline]
>>>    __se_sys_recvmmsg net/socket.c:2853 [inline]
>>>    __x64_sys_recvmmsg+0x20b/0x260 net/socket.c:2853
>>>    do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>>>    do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>>>    entry_SYSCALL_64_after_hwframe+0x44/0xae
>>> RIP: 0033:0x43ef39
>>> Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
>>> RSP: 002b:00007ffca8776d68 EFLAGS: 00000246 ORIG_RAX: 000000000000012b
>>> RAX: ffffffffffffffda RBX: 0000000000400488 RCX: 000000000043ef39
>>> RDX: 0000000000000700 RSI: 0000000020001140 RDI: 0000000000000004
>>> RBP: 0000000000402f20 R08: 0000000000000000 R09: 0000000000400488
>>> R10: 0000000000000007 R11: 0000000000000246 R12: 0000000000402fb0
>>> R13: 0000000000000000 R14: 00000000004ac018 R15: 0000000000400488
>>>
>>> =============================
>>> [ BUG: Invalid wait context ]
>>> 5.14.0-rc3-syzkaller #0 Tainted: G        W
>>> -----------------------------
>>> syz-executor700/8443 is trying to lock:
>>> ffff8880212b6a28 (&mm->mmap_lock#2){++++}-{3:3}, at: __might_fault+0xa3/0x180 mm/memory.c:5260
>>> other info that might help us debug this:
>>> context-{4:4}
>>> 2 locks held by syz-executor700/8443:
>>>    #0: ffff888028fa0d00 (&u->iolock){+.+.}-{3:3}, at: unix_stream_read_generic+0x16c6/0x2190 net/unix/af_unix.c:2501
>>>    #1: ffff888028fa0df0 (&u->lock){+.+.}-{2:2}, at: spin_lock include/linux/spinlock.h:354 [inline]
>>>    #1: ffff888028fa0df0 (&u->lock){+.+.}-{2:2}, at: unix_stream_read_generic+0x16d0/0x2190 net/unix/af_unix.c:2502
>>> stack backtrace:
>>> CPU: 1 PID: 8443 Comm: syz-executor700 Tainted: G        W         5.14.0-rc3-syzkaller #0
>>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>>> Call Trace:
>>>    __dump_stack lib/dump_stack.c:88 [inline]
>>>    dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:105
>>>    print_lock_invalid_wait_context kernel/locking/lockdep.c:4666 [inline]
>>>    check_wait_context kernel/locking/lockdep.c:4727 [inline]
>>>    __lock_acquire.cold+0x213/0x3ab kernel/locking/lockdep.c:4965
>>>    lock_acquire kernel/locking/lockdep.c:5625 [inline]
>>>    lock_acquire+0x1ab/0x510 kernel/locking/lockdep.c:5590
>>>    __might_fault mm/memory.c:5261 [inline]
>>>    __might_fault+0x106/0x180 mm/memory.c:5246
>>>    _copy_to_iter+0x199/0x1600 lib/iov_iter.c:619
>>>    copy_to_iter include/linux/uio.h:139 [inline]
>>>    simple_copy_to_iter+0x4c/0x70 net/core/datagram.c:519
>>>    __skb_datagram_iter+0x10f/0x770 net/core/datagram.c:425
>>>    skb_copy_datagram_iter+0x40/0x50 net/core/datagram.c:533
>>>    skb_copy_datagram_msg include/linux/skbuff.h:3620 [inline]
>>>    unix_stream_read_actor+0x78/0xc0 net/unix/af_unix.c:2701
>>>    unix_stream_recv_urg net/unix/af_unix.c:2433 [inline]
>>>    unix_stream_read_generic+0x17cd/0x2190 net/unix/af_unix.c:2504
>>>    unix_stream_recvmsg+0xb1/0xf0 net/unix/af_unix.c:2717
>>>    sock_recvmsg_nosec net/socket.c:944 [inline]
>>>    sock_recvmsg net/socket.c:962 [inline]
>>>    sock_recvmsg net/socket.c:958 [inline]
>>>    ____sys_recvmsg+0x2c4/0x600 net/socket.c:2622
>>>    ___sys_recvmsg+0x127/0x200 net/socket.c:2664
>>>    do_recvmmsg+0x24d/0x6d0 net/socket.c:2758
>>>    __sys_recvmmsg net/socket.c:2837 [inline]
>>>    __do_sys_recvmmsg net/socket.c:2860 [inline]
>>>    __se_sys_recvmmsg net/socket.c:2853 [inline]
>>>    __x64_sys_recvmmsg+0x20b/0x260 net/socket.c:2853
>>>    do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>>>    do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>>>    entry_SYSCALL_64_after_hwframe+0x44/0xae
>>> RIP: 0033:0x43ef39
>>> Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
>>> RSP: 002b:00007ffca8776d68 EFLAGS: 00000246 ORIG_RAX: 000000000000012b
>>> RAX: ffffffffffffffda RBX: 0000000000400488 RCX: 000000000043ef39
>>> RDX: 0000000000000700 RSI: 0000000020001140 RDI: 0000000000000004
>>> RBP: 0000000000402f20 R08: 0000000000000000 R09: 0000000000400488
>>> R10: 0000000000000007 R11: 0000000000000246 R12: 0000
>>>
>>>
>>> ---
>>> This report is generated by a bot. It may contain errors.
>>> See https://urldefense.com/v3/__https://goo.gl/tpsmEJ__;!!ACWV5N9M2RV99hQ!fbn9ny5Bw51Jl6yrU93iULDBXa_DPjyVIgQuZWyQbCo5IRkAzvYs6JKlPG1UhbpZ$  for more information about syzbot.
>>> syzbot engineers can be reached at syzkaller@googlegroups.com.
>>>
>>> syzbot will keep track of this issue. See:
>>> https://urldefense.com/v3/__https://goo.gl/tpsmEJ*status__;Iw!!ACWV5N9M2RV99hQ!fbn9ny5Bw51Jl6yrU93iULDBXa_DPjyVIgQuZWyQbCo5IRkAzvYs6JKlPKlEx5v1$  for how to communicate with syzbot.
>>> For information about bisection process see: https://urldefense.com/v3/__https://goo.gl/tpsmEJ*bisection__;Iw!!ACWV5N9M2RV99hQ!fbn9ny5Bw51Jl6yrU93iULDBXa_DPjyVIgQuZWyQbCo5IRkAzvYs6JKlPJk7KaIr$
>>> syzbot can test patches for this issue, for details see:
>>> https://urldefense.com/v3/__https://goo.gl/tpsmEJ*testing-patches__;Iw!!ACWV5N9M2RV99hQ!fbn9ny5Bw51Jl6yrU93iULDBXa_DPjyVIgQuZWyQbCo5IRkAzvYs6JKlPMhq2hD3$
>> --
>> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
>> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
>> To view this discussion on the web visit https://urldefense.com/v3/__https://groups.google.com/d/msgid/syzkaller-bugs/0c106e6c-672f-474e-5815-97b65596139d*40oracle.com__;JQ!!ACWV5N9M2RV99hQ!fbn9ny5Bw51Jl6yrU93iULDBXa_DPjyVIgQuZWyQbCo5IRkAzvYs6JKlPHjmYAGZ$ .
