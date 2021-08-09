Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A967D3E4D35
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 21:41:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235001AbhHITlJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 15:41:09 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:5382 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234135AbhHITlH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 15:41:07 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 179JawEb015298;
        Mon, 9 Aug 2021 19:40:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=pXvbK5biu1KcX/hXyH7JEJBFbKuJL6gAZaY+3m3CVhE=;
 b=sLBXGiPUzkAaBw7dwCfJtpn5nK6uu5JMEDSBIwkdfClAguXRf6brLDcNqGqM2giQA5QW
 YWCtn6svbpHhZ2Y0P53rK82rHzVI5SFsOam50EAtG9yqfM7Xm8BD5eIspAZKGlsPqgDS
 ZdMn20DTaQiB5nGrNVyTeywLBbEvqiIt+IIMbTcCg2W5u/FwFTY+26Ki82zg4fSA8A4R
 6nS7PrY1er3RKK9w7NmC8fJGaMgQDbsrqHex/inD/GV7DkaxkFQLmxAQqkAkItKiwxmw
 4hUZwaLWbTwR5QtaGSJ9ASCTkW+Z7eui8raRcTLvTM5k+AEThHInuATrlvnWFvtwYz1c pw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=pXvbK5biu1KcX/hXyH7JEJBFbKuJL6gAZaY+3m3CVhE=;
 b=RehGcXAN/sW1AYGtJs3Fn0BgsbETfDkKb2UVlmN9TI0zgFy7XjyiIkFpJG1x6X9DHECB
 VD+TWSXq2KWhkPrA3AP2EiFiKZg9nmzqFwmnu/RkQwYK/Rca4sOsVxHcO4PXavUCmHF/
 baff6eaHCTsoYcxc1Zjx8khcnjw+YMp9STxmSupSJXGsPOvWWlgAnlkIyQxgvZgXO7m+
 SF/F4+nzz7+fEOX069bNPOeTUIoCqNAbNjHJADgXpZmmUKXXUw4AcBdxn5keFbCFZdRN
 QZC5PQ+mDx28to7CBndI5rQx8ly5yoKWunuc2yByhCntBY+mF0wamUg6Pa9gbnAB5vC0 nw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3aaqmut7jn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 09 Aug 2021 19:40:18 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 179Je7Vv136974;
        Mon, 9 Aug 2021 19:40:16 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
        by userp3030.oracle.com with ESMTP id 3a9f9vjpkb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 09 Aug 2021 19:40:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T4/4MC5j06B+F+HpqMXht/3a+rEHoNZzrR4hTXO1xNyeYgDwlLzO1H/hUR91nnXoeNTk+8Y+TW6+rbVL3XGREdcClL/oWzSstRiD/p97pqRxW5BSrBl75Uw3o0V4r7qqjrqsrDT7X2pOGRSgEA4rnpNozI7egrtUxJ/xbovFnUUEwQfNBYfNQQsKxQC/mCVA7E9RWNoWz6iMhp3xWqlCviSsPjjYeT2Oe4kn3A8BIhBIKt9Eh1OsxrWiwBqK2Ovmpao/gu3B/Ds+d6e+QNQ3HPonKGDR2+z/nhDLJkq3vo60uo3LqVk80egYdBoHbdiWVCGoXzBGCosZGXXtq42kxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pXvbK5biu1KcX/hXyH7JEJBFbKuJL6gAZaY+3m3CVhE=;
 b=lTOyiGd5cVLiYIpD29oj3QhgXAanAwwyaQ3srabxHzeBFnPIE1CmjRz6TvdQ/LLbjGRhPtK0viXke0/t6JBNXoEjjykU0GJVDWyTP0WGBobR6c80g7mpVnrBaYWHbYTtoDT9ynlqstIMGrpvnqV9Qs/50mhbxLnFPmr8eMoGTxSGcOpWX+VDTza2/PGTOflCbITcfuT6Yu3buQ1eX8Iga9gIWLoxV/2690WRKe+Rh6aQ07+mrqetf5VnZmTOpnyUKZ3lZDITBOXKtz/OaMvtx2Nuyba/RaONgswSuVsQa8jWVCNqqHhzm/rcGgFgswoEOPPQ1SswKqGUflm1i4KJ0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pXvbK5biu1KcX/hXyH7JEJBFbKuJL6gAZaY+3m3CVhE=;
 b=S2Q3qMS4HKhWkRoQ3ipqDgKtHxeaRhq8zTQduzs88MdeAeaNguPyxSTeH45DPs0QvFhNfNB6j2a1VekDD5g8WGidGXg9baU/bT3KQAHm+MiiUIrVVxKVngHqJZ3y7KlLNwGfUf64kJxUO4TiouKf6Y9vW+weCbvaqTbsgktgTWs=
Authentication-Results: fb.com; dkim=none (message not signed)
 header.d=none;fb.com; dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB4494.namprd10.prod.outlook.com (2603:10b6:a03:2d4::12)
 by SJ0PR10MB5408.namprd10.prod.outlook.com (2603:10b6:a03:3ba::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.19; Mon, 9 Aug
 2021 19:40:07 +0000
Received: from SJ0PR10MB4494.namprd10.prod.outlook.com
 ([fe80::588f:a774:17de:1d1b]) by SJ0PR10MB4494.namprd10.prod.outlook.com
 ([fe80::588f:a774:17de:1d1b%3]) with mapi id 15.20.4394.023; Mon, 9 Aug 2021
 19:40:07 +0000
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
 <e99cc036-2f83-ff9e-ea68-3eeb19bd4147@oracle.com>
 <CACT4Y+bFLFg9WUiGWq=8ubKFug47=XNjqQJkTX3v1Hos0r+Z_A@mail.gmail.com>
From:   Shoaib Rao <rao.shoaib@oracle.com>
Message-ID: <2901262f-1ba7-74c0-e5fc-394b65414d12@oracle.com>
Date:   Mon, 9 Aug 2021 12:40:03 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <CACT4Y+bFLFg9WUiGWq=8ubKFug47=XNjqQJkTX3v1Hos0r+Z_A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: SA9P221CA0023.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:806:25::28) To SJ0PR10MB4494.namprd10.prod.outlook.com
 (2603:10b6:a03:2d4::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2606:b400:400:744d:8000::918] (2606:b400:8301:1010::16aa) by SA9P221CA0023.NAMP221.PROD.OUTLOOK.COM (2603:10b6:806:25::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Mon, 9 Aug 2021 19:40:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 95671815-70f7-46ea-1ee8-08d95b6d7e11
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5408:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB5408B1CD1E9C75EFD30C4F0DEFF69@SJ0PR10MB5408.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KUcrd6o4TM1YUm0bPL/rRmhJp6wWhIlXphFy+3+U8w805OR322oXedEK8ju7Rj/5RMcOE1666uN5n4F48ziYaL2DPT2rYMbwYnGs3Sj0FAqW/A/dGnijVRsL7OwCRD0xLUUnAw4HHDT3ucKoqvyTbt3gktf1MrIwpbyBLk0iXz4MgxCamSJZkPAKwKWQyWY5gUeE2D3wnmSKLGl7abLftjCA9s8CQAWIQ/DgyTubw4GCSPiE7DbWt8bY79R8YPDam84dR3BioIulxPlwGsOCo5+cDm6Kr/r2yRjz4hjLgD9vfe/48qc2akadWPLSu2K+Az91tPUb/aW4QiNwLo1HP+nBipJ/KVn6ucxYzYBwaKMaIL49fk2dyOlRUrrANepiQm5faDHiscHsCJGiszw95o5fo0KT2y+R3ugHIDmECAWhnuKHAssQhdamiUzvJfpBnXjyZc+qi5vjJVy0MMZdrPnNVHRHjzorPR3hkbl2DvnamVlKugzrf6wa/3mxs+1DPGMrnK/g4sDz/NRK99NUDOZ5C+W5793iSpIp5Xp/HhhHPkCmtu422Yp1Zb2togCfqUERBcCWuATZGkl818pxSIvbwdBOmlqvuV4KDNcJ/bp9c3EqEDV/gMrpxoeCW0t9SF5JSGwnyU9Gwhi6wTivbDjt+I4qIoWeLKxa4xdVupFMTvaglnii90w3oXV1b33nWP+/igC68gY9R5i4P3UcVKqtaKiL4MzuIuUU4CDH8J7kudx+bMoZ+lV97jPtVlu1jHONmygL4KcwoKF376GwI6KBhCQMfwdtyFRCu6f/gzrayqm7AAfXveePMQ6QdNtFNDUrQykvifdl/a4m5rvttOLMAdfP8Wt/PTBte63YsTfRw4vFmv+3NF3B6CGYQAVnE0gAjjOaOzvYzRadRoq3QA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4494.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(366004)(136003)(346002)(396003)(6916009)(7416002)(4326008)(966005)(66946007)(316002)(5660300002)(66556008)(53546011)(8676002)(66476007)(8936002)(186003)(6486002)(478600001)(38100700002)(36756003)(30864003)(86362001)(31696002)(2616005)(2906002)(31686004)(83380400001)(99710200001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b0hsb3MweDNpZTZLcVFuVHRxUTNGM3VaK1p6VUltRWl0aTJoL21iM09aUGJB?=
 =?utf-8?B?S2ZtbCtDVmR2MzZVUW5DaklJVURSeSs1MDNjM1RUVUROTVFkdmQza2NyTTBD?=
 =?utf-8?B?SVJCd0lkejFPWTFpOGUyNTBJdzhweUhWamNkaGlsS0JRNmtoNjdzRXJRN1NP?=
 =?utf-8?B?VVFsNXJVRW9zU2wzT3RsWmJ5S0p0KytIclZIRFBnTzVNV0Rxb0Z0MTMreEFK?=
 =?utf-8?B?MDZsWEIxRDZuSTJYSGZXY05GN091d1pnekNPWUtiVGNBL25VcGlOV3k0WElm?=
 =?utf-8?B?UkVEcUg3aUhJcjdhRjFOazltaDBFekRVODA0aXJyamR6S2tyY1BtYWk1Q0RF?=
 =?utf-8?B?ZklXSEZKMlJaVVFGWGphdWs4Y3NaWUhORFFOYUdtME1ySWdkRnY1SjJnaVVO?=
 =?utf-8?B?TW1jTHJ6NmpRckZRUXBiYVNsZEtMUFI1eVFJQ3NjUU1SS281VlJwZUtWZ0xL?=
 =?utf-8?B?bkZjY3Z5ZVE4K2ZGTzZaUzdzTVp2alFmaUJubFZKd0p3WXR1MzQxNi85NWUx?=
 =?utf-8?B?RSs5MHg2MmxRRkwwK1g3c2tLcXpLSk0yRDV4SFBRODkzL21NZUN4cWJKU2kv?=
 =?utf-8?B?UDgvSHlPek9Oa0tOeEdobkpPZTIrcGZZY3VnaHpvYzdWeFgzYTZKMnY1TXhq?=
 =?utf-8?B?UVZsMm5mMlJuSmI2QmNySW1HRzlVSHNMMlozTnZtR2EwYzVDQVZzR3dFeGdV?=
 =?utf-8?B?NklMV29peFEydmVDdXppTHhhU29FQWIrMC9lMVFDWW82enIyVU5XUERETkF5?=
 =?utf-8?B?NXkvdjd4djFBbGFUWmtDcThwWHdmZktDdVVsVTYwODZkYXBSVlluV09UY0ZD?=
 =?utf-8?B?THlvS25OOUViODV6YVhOUFoycEtTa2JvRWV3ZUVqRHZsLzZDWWRPL2NZT0hq?=
 =?utf-8?B?N1I4TlAzckRUQURUUGU0OGFNeUliLzJ0eGl1NEtzb3hGY2NFc1ZlM0lUb3Zp?=
 =?utf-8?B?OUJ3TGVlRTN3d3VXcDgzMTFIcUJkczc1cmdlcUJleTFrUDRYT2E2QUh3N0VO?=
 =?utf-8?B?Y1NjRng1djk4MWRBUnNMazRRTGcvLzYyY2lFTzFQaS9TcDlaUE1uTDFhK3FY?=
 =?utf-8?B?Ly9hVTVBQXNiYjBmVzQraFRqekRsSDlZZ3kxSVBxRlJ2QW5Tb045eXo0anpr?=
 =?utf-8?B?b05WYVROOVRWR3N2WjlDNUljb1hFSmNFTTkraS9DRHVtdXlDenNOdVVOM2Nq?=
 =?utf-8?B?a2dmOTlBSWRabHFXcWREcmV2Q2xFNCszVm9kbmN2VU5ydDlFUXF0MFd3bVBq?=
 =?utf-8?B?WXZXRG56cktOeVhOcTRtQmlQZHFyY2F5SGZzQmRXSEprTEdWTEF2K0FKU1BO?=
 =?utf-8?B?SUozV0hKc05jeVhqbUZXUWJoWFp1a0lIL0JzS2Y4V2NNSW1WZ0xRM3crQ3NW?=
 =?utf-8?B?TC9XdU5mNWJaKzduM1U1clNPWkdlbXJlRnF6aSt0NFRMOTNSOW9JenZONTd2?=
 =?utf-8?B?WEtkVWFxQUxHS3liL3l3bWpWMjlzZStRQVNUR096NmFqUlRIbWtIRTAxaDA4?=
 =?utf-8?B?STA4YVNjNDNjZ290S01aRmZ2SzJ1OUg2enE5TTBCdmxTSFFZZzhXbmFLRkpB?=
 =?utf-8?B?M01VSFhWYTdmbXlGeGl4K1NaQUNwdTRqN0FPVXRaenM5dWdaOUlEYkpWTXBF?=
 =?utf-8?B?Q1I0VVJoQmYwNnZQM0w1YVZsZVJaUTJlUVNUTVhrVnd5eXd5Sy8zWW43c0FX?=
 =?utf-8?B?WVBDRENoSGJFVFFXOEMvTy9xdUVwT3NUYlBRQU1WYkdmUGw4clNQbDFFZVJQ?=
 =?utf-8?B?VVJuZHpaUHBiZzJNb0o3MGx4TUhUZlJMSHRRU2h6T2dEMkYxTkQzQll2UCtX?=
 =?utf-8?Q?vXY7TcX421Kng60LSCEDjaK6Jesgw8KRaNsGM=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95671815-70f7-46ea-1ee8-08d95b6d7e11
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4494.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2021 19:40:07.6131
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dBiPBJnJ/Qv5qDissu4JJyYDziTLNVeA1sI7hlkAMrZJ0wIQsfP1B6xf227yVJuQQYrS2ZMc2hJQtEZkIAOLSQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5408
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10071 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0
 adultscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108090140
X-Proofpoint-GUID: axijSOUBLzaa4GHhTtscO4debM1xAU22
X-Proofpoint-ORIG-GUID: axijSOUBLzaa4GHhTtscO4debM1xAU22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 8/9/21 12:21 PM, Dmitry Vyukov wrote:
> On Mon, 9 Aug 2021 at 21:16, Shoaib Rao <rao.shoaib@oracle.com> wrote:
>> On 8/9/21 11:06 AM, Dmitry Vyukov wrote:
>>> On Mon, 9 Aug 2021 at 19:33, Shoaib Rao <rao.shoaib@oracle.com> wrote:
>>>> This seems like a false positive. 1) The function will not sleep because
>>>> it only calls copy routine if the byte is present. 2). There is no
>>>> difference between this new call and the older calls in
>>>> unix_stream_read_generic().
>>> Hi Shoaib,
>>>
>>> Thanks for looking into this.
>>> Do you have any ideas on how to fix this tool's false positive? Tools
>>> with false positives are order of magnitude less useful than tools w/o
>>> false positives. E.g. do we turn it off on syzbot? But I don't
>>> remember any other false positives from "sleeping function called from
>>> invalid context" checker...
>> Before we take any action I would like to understand why the tool does
>> not single out other calls to recv_actor in unix_stream_read_generic().
>> The context in all cases is the same. I also do not understand why the
>> code would sleep, Let's assume the user provided address is bad, the
>> code will return EFAULT, it will never sleep,
> I always assumed that it's because if user pages are swapped out, it
> may need to read them back from disk.

Page faults occur all the time, the page may not even be in the cache or 
the mapping is not there (mmap), so I would not consider this a bug. The 
code should complain about all other calls as they are also copying  to 
user pages. I must not be following some semantics for the code to be 
triggered but I can not figure that out. What is the recommended 
interface to do user copy from kernel?

Shoaib

>
>> if the kernel provided
>> address is bad the system will panic. The only difference I see is that
>> the new code holds 2 locks while the previous code held one lock, but
>> the locks are acquired before the call to copy.
>>
>> So please help me understand how the tool works. Even though I have
>> evaluated the code carefully, there is always a possibility that the
>> tool is correct.
>>
>> Shoaib
>>
>>>
>>>
>>>> On 8/8/21 4:38 PM, syzbot wrote:
>>>>> Hello,
>>>>>
>>>>> syzbot found the following issue on:
>>>>>
>>>>> HEAD commit:    c2eecaa193ff pktgen: Remove redundant clone_skb override
>>>>> git tree:       net-next
>>>>> console output: https://urldefense.com/v3/__https://syzkaller.appspot.com/x/log.txt?x=12e3a69e300000__;!!ACWV5N9M2RV99hQ!fbn9ny5Bw51Jl6yrU93iULDBXa_DPjyVIgQuZWyQbCo5IRkAzvYs6JKlPHEdQcWD$
>>>>> kernel config:  https://urldefense.com/v3/__https://syzkaller.appspot.com/x/.config?x=aba0c23f8230e048__;!!ACWV5N9M2RV99hQ!fbn9ny5Bw51Jl6yrU93iULDBXa_DPjyVIgQuZWyQbCo5IRkAzvYs6JKlPLGp1-Za$
>>>>> dashboard link: https://urldefense.com/v3/__https://syzkaller.appspot.com/bug?extid=8760ca6c1ee783ac4abd__;!!ACWV5N9M2RV99hQ!fbn9ny5Bw51Jl6yrU93iULDBXa_DPjyVIgQuZWyQbCo5IRkAzvYs6JKlPCORTNOH$
>>>>> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
>>>>> syz repro:      https://urldefense.com/v3/__https://syzkaller.appspot.com/x/repro.syz?x=15c5b104300000__;!!ACWV5N9M2RV99hQ!fbn9ny5Bw51Jl6yrU93iULDBXa_DPjyVIgQuZWyQbCo5IRkAzvYs6JKlPAjhi2yc$
>>>>> C reproducer:   https://urldefense.com/v3/__https://syzkaller.appspot.com/x/repro.c?x=10062aaa300000__;!!ACWV5N9M2RV99hQ!fbn9ny5Bw51Jl6yrU93iULDBXa_DPjyVIgQuZWyQbCo5IRkAzvYs6JKlPNzAjzQJ$
>>>>>
>>>>> The issue was bisected to:
>>>>>
>>>>> commit 314001f0bf927015e459c9d387d62a231fe93af3
>>>>> Author: Rao Shoaib <rao.shoaib@oracle.com>
>>>>> Date:   Sun Aug 1 07:57:07 2021 +0000
>>>>>
>>>>>        af_unix: Add OOB support
>>>>>
>>>>> bisection log:  https://urldefense.com/v3/__https://syzkaller.appspot.com/x/bisect.txt?x=10765f8e300000__;!!ACWV5N9M2RV99hQ!fbn9ny5Bw51Jl6yrU93iULDBXa_DPjyVIgQuZWyQbCo5IRkAzvYs6JKlPK2iWt2r$
>>>>> final oops:     https://urldefense.com/v3/__https://syzkaller.appspot.com/x/report.txt?x=12765f8e300000__;!!ACWV5N9M2RV99hQ!fbn9ny5Bw51Jl6yrU93iULDBXa_DPjyVIgQuZWyQbCo5IRkAzvYs6JKlPKAb0dft$
>>>>> console output: https://urldefense.com/v3/__https://syzkaller.appspot.com/x/log.txt?x=14765f8e300000__;!!ACWV5N9M2RV99hQ!fbn9ny5Bw51Jl6yrU93iULDBXa_DPjyVIgQuZWyQbCo5IRkAzvYs6JKlPNlW_w-u$
>>>>>
>>>>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>>>>> Reported-by: syzbot+8760ca6c1ee783ac4abd@syzkaller.appspotmail.com
>>>>> Fixes: 314001f0bf92 ("af_unix: Add OOB support")
>>>>>
>>>>> BUG: sleeping function called from invalid context at lib/iov_iter.c:619
>>>>> in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 8443, name: syz-executor700
>>>>> 2 locks held by syz-executor700/8443:
>>>>>     #0: ffff888028fa0d00 (&u->iolock){+.+.}-{3:3}, at: unix_stream_read_generic+0x16c6/0x2190 net/unix/af_unix.c:2501
>>>>>     #1: ffff888028fa0df0 (&u->lock){+.+.}-{2:2}, at: spin_lock include/linux/spinlock.h:354 [inline]
>>>>>     #1: ffff888028fa0df0 (&u->lock){+.+.}-{2:2}, at: unix_stream_read_generic+0x16d0/0x2190 net/unix/af_unix.c:2502
>>>>> Preemption disabled at:
>>>>> [<0000000000000000>] 0x0
>>>>> CPU: 1 PID: 8443 Comm: syz-executor700 Not tainted 5.14.0-rc3-syzkaller #0
>>>>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>>>>> Call Trace:
>>>>>     __dump_stack lib/dump_stack.c:88 [inline]
>>>>>     dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:105
>>>>>     ___might_sleep.cold+0x1f1/0x237 kernel/sched/core.c:9154
>>>>>     __might_fault+0x6e/0x180 mm/memory.c:5258
>>>>>     _copy_to_iter+0x199/0x1600 lib/iov_iter.c:619
>>>>>     copy_to_iter include/linux/uio.h:139 [inline]
>>>>>     simple_copy_to_iter+0x4c/0x70 net/core/datagram.c:519
>>>>>     __skb_datagram_iter+0x10f/0x770 net/core/datagram.c:425
>>>>>     skb_copy_datagram_iter+0x40/0x50 net/core/datagram.c:533
>>>>>     skb_copy_datagram_msg include/linux/skbuff.h:3620 [inline]
>>>>>     unix_stream_read_actor+0x78/0xc0 net/unix/af_unix.c:2701
>>>>>     unix_stream_recv_urg net/unix/af_unix.c:2433 [inline]
>>>>>     unix_stream_read_generic+0x17cd/0x2190 net/unix/af_unix.c:2504
>>>>>     unix_stream_recvmsg+0xb1/0xf0 net/unix/af_unix.c:2717
>>>>>     sock_recvmsg_nosec net/socket.c:944 [inline]
>>>>>     sock_recvmsg net/socket.c:962 [inline]
>>>>>     sock_recvmsg net/socket.c:958 [inline]
>>>>>     ____sys_recvmsg+0x2c4/0x600 net/socket.c:2622
>>>>>     ___sys_recvmsg+0x127/0x200 net/socket.c:2664
>>>>>     do_recvmmsg+0x24d/0x6d0 net/socket.c:2758
>>>>>     __sys_recvmmsg net/socket.c:2837 [inline]
>>>>>     __do_sys_recvmmsg net/socket.c:2860 [inline]
>>>>>     __se_sys_recvmmsg net/socket.c:2853 [inline]
>>>>>     __x64_sys_recvmmsg+0x20b/0x260 net/socket.c:2853
>>>>>     do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>>>>>     do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>>>>>     entry_SYSCALL_64_after_hwframe+0x44/0xae
>>>>> RIP: 0033:0x43ef39
>>>>> Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
>>>>> RSP: 002b:00007ffca8776d68 EFLAGS: 00000246 ORIG_RAX: 000000000000012b
>>>>> RAX: ffffffffffffffda RBX: 0000000000400488 RCX: 000000000043ef39
>>>>> RDX: 0000000000000700 RSI: 0000000020001140 RDI: 0000000000000004
>>>>> RBP: 0000000000402f20 R08: 0000000000000000 R09: 0000000000400488
>>>>> R10: 0000000000000007 R11: 0000000000000246 R12: 0000000000402fb0
>>>>> R13: 0000000000000000 R14: 00000000004ac018 R15: 0000000000400488
>>>>>
>>>>> =============================
>>>>> [ BUG: Invalid wait context ]
>>>>> 5.14.0-rc3-syzkaller #0 Tainted: G        W
>>>>> -----------------------------
>>>>> syz-executor700/8443 is trying to lock:
>>>>> ffff8880212b6a28 (&mm->mmap_lock#2){++++}-{3:3}, at: __might_fault+0xa3/0x180 mm/memory.c:5260
>>>>> other info that might help us debug this:
>>>>> context-{4:4}
>>>>> 2 locks held by syz-executor700/8443:
>>>>>     #0: ffff888028fa0d00 (&u->iolock){+.+.}-{3:3}, at: unix_stream_read_generic+0x16c6/0x2190 net/unix/af_unix.c:2501
>>>>>     #1: ffff888028fa0df0 (&u->lock){+.+.}-{2:2}, at: spin_lock include/linux/spinlock.h:354 [inline]
>>>>>     #1: ffff888028fa0df0 (&u->lock){+.+.}-{2:2}, at: unix_stream_read_generic+0x16d0/0x2190 net/unix/af_unix.c:2502
>>>>> stack backtrace:
>>>>> CPU: 1 PID: 8443 Comm: syz-executor700 Tainted: G        W         5.14.0-rc3-syzkaller #0
>>>>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>>>>> Call Trace:
>>>>>     __dump_stack lib/dump_stack.c:88 [inline]
>>>>>     dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:105
>>>>>     print_lock_invalid_wait_context kernel/locking/lockdep.c:4666 [inline]
>>>>>     check_wait_context kernel/locking/lockdep.c:4727 [inline]
>>>>>     __lock_acquire.cold+0x213/0x3ab kernel/locking/lockdep.c:4965
>>>>>     lock_acquire kernel/locking/lockdep.c:5625 [inline]
>>>>>     lock_acquire+0x1ab/0x510 kernel/locking/lockdep.c:5590
>>>>>     __might_fault mm/memory.c:5261 [inline]
>>>>>     __might_fault+0x106/0x180 mm/memory.c:5246
>>>>>     _copy_to_iter+0x199/0x1600 lib/iov_iter.c:619
>>>>>     copy_to_iter include/linux/uio.h:139 [inline]
>>>>>     simple_copy_to_iter+0x4c/0x70 net/core/datagram.c:519
>>>>>     __skb_datagram_iter+0x10f/0x770 net/core/datagram.c:425
>>>>>     skb_copy_datagram_iter+0x40/0x50 net/core/datagram.c:533
>>>>>     skb_copy_datagram_msg include/linux/skbuff.h:3620 [inline]
>>>>>     unix_stream_read_actor+0x78/0xc0 net/unix/af_unix.c:2701
>>>>>     unix_stream_recv_urg net/unix/af_unix.c:2433 [inline]
>>>>>     unix_stream_read_generic+0x17cd/0x2190 net/unix/af_unix.c:2504
>>>>>     unix_stream_recvmsg+0xb1/0xf0 net/unix/af_unix.c:2717
>>>>>     sock_recvmsg_nosec net/socket.c:944 [inline]
>>>>>     sock_recvmsg net/socket.c:962 [inline]
>>>>>     sock_recvmsg net/socket.c:958 [inline]
>>>>>     ____sys_recvmsg+0x2c4/0x600 net/socket.c:2622
>>>>>     ___sys_recvmsg+0x127/0x200 net/socket.c:2664
>>>>>     do_recvmmsg+0x24d/0x6d0 net/socket.c:2758
>>>>>     __sys_recvmmsg net/socket.c:2837 [inline]
>>>>>     __do_sys_recvmmsg net/socket.c:2860 [inline]
>>>>>     __se_sys_recvmmsg net/socket.c:2853 [inline]
>>>>>     __x64_sys_recvmmsg+0x20b/0x260 net/socket.c:2853
>>>>>     do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>>>>>     do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>>>>>     entry_SYSCALL_64_after_hwframe+0x44/0xae
>>>>> RIP: 0033:0x43ef39
>>>>> Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
>>>>> RSP: 002b:00007ffca8776d68 EFLAGS: 00000246 ORIG_RAX: 000000000000012b
>>>>> RAX: ffffffffffffffda RBX: 0000000000400488 RCX: 000000000043ef39
>>>>> RDX: 0000000000000700 RSI: 0000000020001140 RDI: 0000000000000004
>>>>> RBP: 0000000000402f20 R08: 0000000000000000 R09: 0000000000400488
>>>>> R10: 0000000000000007 R11: 0000000000000246 R12: 0000
>>>>>
>>>>>
>>>>> ---
>>>>> This report is generated by a bot. It may contain errors.
>>>>> See https://urldefense.com/v3/__https://goo.gl/tpsmEJ__;!!ACWV5N9M2RV99hQ!fbn9ny5Bw51Jl6yrU93iULDBXa_DPjyVIgQuZWyQbCo5IRkAzvYs6JKlPG1UhbpZ$  for more information about syzbot.
>>>>> syzbot engineers can be reached at syzkaller@googlegroups.com.
>>>>>
>>>>> syzbot will keep track of this issue. See:
>>>>> https://urldefense.com/v3/__https://goo.gl/tpsmEJ*status__;Iw!!ACWV5N9M2RV99hQ!fbn9ny5Bw51Jl6yrU93iULDBXa_DPjyVIgQuZWyQbCo5IRkAzvYs6JKlPKlEx5v1$  for how to communicate with syzbot.
>>>>> For information about bisection process see: https://urldefense.com/v3/__https://goo.gl/tpsmEJ*bisection__;Iw!!ACWV5N9M2RV99hQ!fbn9ny5Bw51Jl6yrU93iULDBXa_DPjyVIgQuZWyQbCo5IRkAzvYs6JKlPJk7KaIr$
>>>>> syzbot can test patches for this issue, for details see:
>>>>> https://urldefense.com/v3/__https://goo.gl/tpsmEJ*testing-patches__;Iw!!ACWV5N9M2RV99hQ!fbn9ny5Bw51Jl6yrU93iULDBXa_DPjyVIgQuZWyQbCo5IRkAzvYs6JKlPMhq2hD3$
>>>> --
>>>> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
>>>> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
>>>> To view this discussion on the web visit https://urldefense.com/v3/__https://groups.google.com/d/msgid/syzkaller-bugs/0c106e6c-672f-474e-5815-97b65596139d*40oracle.com__;JQ!!ACWV5N9M2RV99hQ!fbn9ny5Bw51Jl6yrU93iULDBXa_DPjyVIgQuZWyQbCo5IRkAzvYs6JKlPHjmYAGZ$ .
