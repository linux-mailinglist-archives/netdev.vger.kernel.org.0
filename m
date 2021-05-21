Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74F7B38CFF7
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 23:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbhEUVij (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 17:38:39 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:46350 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbhEUVii (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 May 2021 17:38:38 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14LLVpQp032307;
        Fri, 21 May 2021 21:37:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=6slKrpY0ejGHZ7i2sgzEK1wpxVqf65rT9JknokU/Bzg=;
 b=l3kLyAT6cSI7wgx17qrPN72AMH5/GIfW1S6PnhAM1JlXk8sWqSH0RqEzHB+CeO9iE1HJ
 z1KbLI5/0mXnBNnBPyAJ6pVu9VHb8S6chWe3POD8WHoOn/ZKhgyUpgbAm8gNHnwMqs2o
 Xolsq1XvqLyrzQzlST5ZTWVJsw3XhTuzZhDVzxe21i/oekCJJ5NaPp/PcqpdLM1PIt/z
 4Fk89yjiIjFWqMxxtrijQNHuF1njBcXeQWYQYyLf4yQEdWRMlySjMTZLpkOwU5uIbIX7
 DjtqiGqr8etHUE1w7RxSkE3uizs+xiKGEWw78v2MbTGq+YZJeYWPy+o18I7LVSRAuHah HA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 38j6xnrr5e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 May 2021 21:37:09 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14LLVaAh014472;
        Fri, 21 May 2021 21:37:08 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2109.outbound.protection.outlook.com [104.47.70.109])
        by aserp3030.oracle.com with ESMTP id 38meej32mm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 May 2021 21:37:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DkBRA1kbh9qyq8HsmwhAuiIgFRzpTTY35M/tb2Fm/npZemCOlr75bXqkRL3Yau0x7eYQG6pKxCRg8JU6bOXovPEqYN7hn2HgOwXNn4i/MIWS7dKOOkfhN0kw7GVDLtppFIngtiGy5mVsNMt/4Sxy9mOv6aGfmsFn2FvwhNnr2tJuyhYwakpCf53F02M4oJsquXuTFw3WE5oQGowffkvAUCIOWgLuRhwWriPxpYMydfkCy9XjWPVJPzzU5SZ//z3ylmt0UAjvHA1DqZcmP9NFMHQP5MW16uyXb3qJDl3pfAn1dj/jDoAbmhmrQRd+Ll5Bq2M/fTj9KgfA02zsm1iLDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6slKrpY0ejGHZ7i2sgzEK1wpxVqf65rT9JknokU/Bzg=;
 b=eZix59VmMf/u/r61D1jDxfVRXZ08Sw8aRbd73dXu9aBm569l3gSrt3uihf0/9Q/ldQuVW3pKghb06El6tYQAdAo+hsbTGmvqs1occILppnUwOsZGGQ1DZr97ivkb3rI/HPpdHSsWWk4KUtxiK7wZyxumv6tKjT5pmEXsxoWL+pzAjs7qTaFn1Lgpms2BJskiVSBfRN8sewQ89A0mzAgdHkpZglVjAWjR8G9px01bv+G16WtjRxhqlw+F6gKvLS4HUy8AKy4KW1CNHGvLr4VGUHhTc///5w2WzEUxsXhnMJnHRGw3zXWFCXQuH97Jnmanb1acneE/pxC3ifKNUQ8doQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6slKrpY0ejGHZ7i2sgzEK1wpxVqf65rT9JknokU/Bzg=;
 b=l+I3pNOVNHbqgAcWUZo+RXSZnoKJfTgQUEodKHuhI8gy0wp5QhxmCfBdqecDBfwt3Oi+geHUOfGwLYEpisqXjFkxrsqDDhpEzKl9AlHWvq4jrZq2R+WwSVAsj6O7I03gkL42/WI87Ens8y9LKeSX69I6la1zI77aejR/EiiX1Ao=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB4494.namprd10.prod.outlook.com (2603:10b6:a03:2d4::12)
 by SJ0PR10MB5406.namprd10.prod.outlook.com (2603:10b6:a03:305::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Fri, 21 May
 2021 21:37:07 +0000
Received: from SJ0PR10MB4494.namprd10.prod.outlook.com
 ([fe80::103c:70e1:fefe:a5b]) by SJ0PR10MB4494.namprd10.prod.outlook.com
 ([fe80::103c:70e1:fefe:a5b%7]) with mapi id 15.20.4150.026; Fri, 21 May 2021
 21:37:07 +0000
Subject: Re: [PATCH RDS/TCP v1 1/1] RDS tcp loopback connection can hang
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
References: <20210521180806.80362-1-Rao.Shoaib@oracle.com>
 <20210521.142535.305654298687081579.davem@davemloft.net>
From:   Shoaib Rao <rao.shoaib@oracle.com>
Message-ID: <2354795f-25d7-14d4-2e2f-3fc5ec22cc90@oracle.com>
Date:   Fri, 21 May 2021 14:37:03 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
In-Reply-To: <20210521.142535.305654298687081579.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [2606:b400:8301:1010::16aa]
X-ClientProxiedBy: SN4PR0501CA0069.namprd05.prod.outlook.com
 (2603:10b6:803:41::46) To SJ0PR10MB4494.namprd10.prod.outlook.com
 (2603:10b6:a03:2d4::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2606:b400:400:7444:8000::bdc] (2606:b400:8301:1010::16aa) by SN4PR0501CA0069.namprd05.prod.outlook.com (2603:10b6:803:41::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.12 via Frontend Transport; Fri, 21 May 2021 21:37:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d73c5184-42dc-47c9-012c-08d91ca094f1
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5406:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB540632F3C25FB7E623EFECEDEF299@SJ0PR10MB5406.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: II2XRrBN2oOvEINvkMZN9BKlrbpERx4E9oP3CcUjHLTh3r2Sd/CkHO0hwfVoaK9stIg5EfEXMYr3UGPcmECARaoGqFwD+WmJgYTOrzkcm4HeZUOZ71Rx8mLz1UHw2+oTmOY+BU3Wl2cLNdDst4fr8YATk0TkoZPVNHIkToeaBXPnoK07N0bNLcAQcc5xs6k2QF0VUCC/oFLvwVU3A3IZjAMhMaoLKjBY5ZzeVJwEF4x9wjGEzZ9TcCU9KUbNA12f3mcWsp5W+g4gLhG4TNztu2LAx1QddbLoDZ0AiiHuC4TRGASADOGhunb6AS0pwvar+JkC8Xl/2pDEFsvhbrgN2RNrW0D3i1KIPOjQd+uoJ99L3wrx0SZN5axEzRRHDKjUxeDiRzkjEVaFqBYyAapa5BiZoRx2qNxS8ZSBq2m9dHttcVTdkRQZ+VBBO2deRvzFhNWRHWtfQaEMmruGn3o/PbadOyVjp6533HCPOLW4b2TE3PVp+hBt6LIydLwgHoq2tmjGGrhIFmD514NNyTseDx0sETK1OJNnAY1j6YZJhIDwGbRiMElmEHOgSbtcVADQny/jtWfTTafaYv9aM/5m4IbkOAN7Po6k51VIJEovMQvs1EcHNb59+u7S1LbxqimEqFq2FMX5E/KNLkEueu997MoC2pRhSeYO9XVtRrNNM/xJHCRMXJIOlAK43okC1gf+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4494.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(346002)(376002)(366004)(39860400002)(36756003)(66946007)(16526019)(2906002)(66556008)(4326008)(8936002)(316002)(186003)(4744005)(6486002)(66476007)(8676002)(478600001)(86362001)(6916009)(38100700002)(53546011)(5660300002)(2616005)(6666004)(31696002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?NzdqeHJKVWZpZlpWZTh5a0ViSFgwbU92ZktYSHd5SkhSQUxFTkNlR0R6ZkZT?=
 =?utf-8?B?a284NmdNK2puZ2ZSejNpRGJpTDdxWUpsZXppSVhodHFHdWtadTdYSTlNY3hE?=
 =?utf-8?B?K0xBWnBaTnIxU1Mxb2xUOWlrZUc1ZUlVcmNaRldYdTZ0NXh4dG5JK2ZBRS9y?=
 =?utf-8?B?aXIvUkdTNFlwRXhRbjZzb0JmTzRXUGN3SUdSL3VRdlF0MWtJdHpoKzBzdGNl?=
 =?utf-8?B?dXhKYzRkSjBoU2FUQmUzSmNKb2w5a3pYcmxnQTVLMERzM015a2VLYjRQaTJW?=
 =?utf-8?B?em1ZSTRsOFdzYXV2OU5ZUUc1NmpHbklYTy9SZGtsTHJ0U1A1MkJxMFQyRk4r?=
 =?utf-8?B?dGRpQmJocDZJNEpEUHZkT0ZPS2padzgza1RsUXVtNStsK2JPWUx3ekNqZ1BF?=
 =?utf-8?B?VU15eEJRSkFkM3MvYWJkd0dYTWU0dy9kMHhBRXpWY1lKazFRNzlLTmxyNU8z?=
 =?utf-8?B?Vi9vNFM2ZnZUVGR2WEh1L2d1RWozQXMxeS9RQlR5QXp2bHRSbzFMYStsQVEv?=
 =?utf-8?B?NzM2MzlLQjBBY0JEbTh5dzdHaFhBQlc5cjNzQUlKTFhmVWtoWnJoQmliLzNR?=
 =?utf-8?B?U3lkTDkrUVc5U1g4S3NQWUdhRmpTT1NhR0o2eHRnTy84Zjkrci96bGtpTG9o?=
 =?utf-8?B?N3Jnd1VmRGZvRTMrYjVQZjZId1pjems2VzFCME53R3FGdmNHNnFuT1hicUhz?=
 =?utf-8?B?VGVkdm1yUkVEZ3UydjQ2aU1LcmlJZXlsWExOUWVCUjgybmQ4bXVucGE1UU5n?=
 =?utf-8?B?VlZidUVmbUt6NElnTS9SQXFUSHlYNE81RnVzVVZJV0ROaWNKQ2tnL2s1bjIr?=
 =?utf-8?B?M1NJdkdKeHpabjRPUzJNQjBUamIyVFJWTm1pTmtzTHRzR253N1V0bEhNRWow?=
 =?utf-8?B?VHVHNVVMaS9Mc1o1dXdPb3pxSFUwcGgzQ3RxRkNmdnlyR0p6aTVscTlwUHRu?=
 =?utf-8?B?VzhMZnJpTDAzTlJIOVZGTGVwWkdCU2hFeXM5VUNIaHVaYjN5R3hjZlk1SVNS?=
 =?utf-8?B?TkhMSjcxZTE1S2oxTjVKekNXRjU1cTh5NlJjSXpLbkN5d0dyRW1jWUl2dmk5?=
 =?utf-8?B?cjJpR1FDU2Rna05aRVNFV25jN0FUNVBrQUk4cVA0ZHY4Z1FlNUdzVElnUWQw?=
 =?utf-8?B?M2dsZHBLZlBzZVN4QXlDckM0QjZ2Y3lNMml0TDYyb3BsVmlxQlZrRlhaVjBw?=
 =?utf-8?B?M3VUdkJMbjB1WCt5dit6T1FVQXErNU5lc3libkowZFVWRSt2d01idVVJL3ov?=
 =?utf-8?B?U1pxNGdOVU9kWXR5V3VlOFVBOWZMZk1BZWhqak1KS1YvdGFvSGhnd29RaFk1?=
 =?utf-8?B?WlVmcDZWb29uOFY4VkNUMUdaNnY1cHhpYktwTTNKSFZIMFZhbXZqUHBXQnJJ?=
 =?utf-8?B?akwwWlVYTm5IeHBYU0NyRmhkLzdwNUF6RHpJWUNPU2x6dWpGUEYycitTMjdz?=
 =?utf-8?B?M2FEeEtjOHhjYWw2SzNnSWIzVHY3UDFYRmJXa3JUVGJycE51MjFsK05aak5F?=
 =?utf-8?B?dmhWeTlMWWtSdXF6MEk3TnNSSE12YVlLQVdpeXloZkN0MnVWTkJ6R2tJNmtH?=
 =?utf-8?B?bXMwWTJaU2Vmd3FnS09ZY2hNazg0WUNpby9YMTZQUWM1TkcxcmVzRXVmYkRJ?=
 =?utf-8?B?bjNkYUJ0MmpSU3RwalVkOGhUeEhyMG1GTmVaYlpLL0JUbWRyTGZ4Mlp5Mllt?=
 =?utf-8?B?QWxtdlhnZUh0K1Mxc2J5VnJUSnZaa3U0RnlMQ1loa2t6ci84NXNpdTlEcmdu?=
 =?utf-8?B?NXVSR3A0S0ZlRG5yWG01YUVjVVpJcHNwbHZMU3NUby9rOENucnRxYm5WdkQ4?=
 =?utf-8?B?WmIyVDYyRVZNbTNVbDZtQT09?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d73c5184-42dc-47c9-012c-08d91ca094f1
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4494.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2021 21:37:07.0794
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fBWVLEgKd2OOYlU4cw4iZMHetiq7uBsYu8Af/rNpTNaCOrUhCdjvaH1MAHTevNlhKJYFTRf6mMBcu0FO6LsL5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5406
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9991 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 adultscore=0
 phishscore=0 malwarescore=0 bulkscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105210117
X-Proofpoint-GUID: 2hCZ18ssZNPhGhpZOY2t9zucDga1MyTl
X-Proofpoint-ORIG-GUID: 2hCZ18ssZNPhGhpZOY2t9zucDga1MyTl
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9991 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 malwarescore=0 priorityscore=1501
 phishscore=0 suspectscore=0 lowpriorityscore=0 bulkscore=0 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105210117
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 5/21/21 2:25 PM, David Miller wrote:
> From: Rao Shoaib <Rao.Shoaib@oracle.com>
> Date: Fri, 21 May 2021 11:08:06 -0700
>
>> +				/* No transport currently in use
>> +				 * should end up here, but if it
>> +				 * does, reset/destroy the connection.
>> +				 */
>> +				kmem_cache_free(rds_conn_slab, conn);
>> +				conn = ERR_PTR(-EOPNOTSUPP);
>> +				goto out;
> Is thosa all we have to do?  What about releasing c_path[]?
>
> Thanks.

rds_connection object is created before c_paths are populated. The code 
is killing the creation of rds_connection object, so there are no paths 
to free.

Thanks,

Shoaib


