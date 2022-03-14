Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E0BC4D8A11
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 17:44:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238231AbiCNQmM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 12:42:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244008AbiCNQig (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 12:38:36 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2F0613E23
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 09:37:25 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22EFSqN3001444;
        Mon, 14 Mar 2022 16:37:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=/IRqnbAoUvNbaKDKZiSMmeZncKWl52eEysFn7qubxFM=;
 b=hbLLVOFzAt7yYbTK1r5kHtanhqbpabc0lcJGQgSlU6z1iG8MOGMo83I0Xb4RG0AHcnjL
 0C1xzpq6jVi4xiWb9E6/yRl2cwCcYGPuHIBZbwou3hZmX/RLUjhQ4jo9FdxTaAyHoJJ/
 ZyyrrMpGSqQSaEgDh9FDurF/xQjL5Khl+VRLlqU//kanKAnobLJXQBtrd69cZkMemTY4
 cfuN6Dq0x4PIuToSW3FiLXdrBIz0OD/w3T1/IowG+1dEXeEPCcJHRoLYnq+Do8r35Zvb
 xmqK+qLXLTAXpAyReXPRTVZn+bHFILb2JvnGZLKmyUcPeyELRNwd0B27hiBZNknpiYvq KA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3et5fu0v67-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Mar 2022 16:37:10 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22EGQCcR125164;
        Mon, 14 Mar 2022 16:37:09 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2106.outbound.protection.outlook.com [104.47.58.106])
        by aserp3030.oracle.com with ESMTP id 3et64t3vy4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Mar 2022 16:37:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VnXTxfenAgU+ja/oMoTRVecePaTuY37oxIzDmVVroq5eKeQHZDSH/VFZitHB+F7W158xFbQdaOEut/UzphvtzqA0PiY1GoyXOALOdRQ2sakTvleRNOuZV9cnuNiB3LG9gDk9xUuuLtqrCFhrdZIjll/eKNnORFcBIH10DBX41qb0hPgysqwuP4XFEqjacyAObUKEbc9xgxYuKxjyjE7D3lki4MaS9UvhAC5D7o4vBrmDo+BEloBnVM5OUlbGUzQB85vdwMpMfY/ytzzXzhPKS72wS8gkuz+DvYXuvZhp5+uPSCg5cHuAThFTxKTbbnff6hWqm6/TlO9IfW5xEGI5Gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/IRqnbAoUvNbaKDKZiSMmeZncKWl52eEysFn7qubxFM=;
 b=F+7ehKQ0UTAnUSp6uRW+Ab4lKEArojMusMLaUhaFpqlv7BWzWUmPKCCTpv1rBCw0WqK/TVwuavRoYAmxsAkWlC4wK+jxVBi3JMMXo4dls6qN5DX/S84JtasGwbyI/bq9dy9Z56zNYrjAkMuuYO4QEH40/CJXQ3TLAMy+MT8SihS3h2Ygl5LXmKpE87g49FgUdRU7UJnuY/h5byOgz2pLELtpbtCyGlo5wVGE2SXWm7t/Q7/zQQFd/2aX8JffHlPRnJ5Q/HP3U4dMvlRoNuGOzKrRhprt0RI+oQEUPE4ZVJTtUcBawPo/OquiqxxmU4dc7ihOY0/Z0jFKjT0Wd61mjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/IRqnbAoUvNbaKDKZiSMmeZncKWl52eEysFn7qubxFM=;
 b=q2C9E/uUsgU5vAjYGewgOObZFEWy+vBgamY8W96diuhSXCC/ynYFVllpMhTdqGpNz8lNX8piWAj2dzuRfiBslHq7SM/Lpntu5QS0l1+oC/tkYvGvpN6wPYLfdHdgdOPlvUUGXBrrkCA1rljbdVC8RmDF0FyTu3xaSuK0P/DuFnA=
Received: from SJ0PR10MB4494.namprd10.prod.outlook.com (2603:10b6:a03:2d4::12)
 by MN2PR10MB3888.namprd10.prod.outlook.com (2603:10b6:208:1b8::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.24; Mon, 14 Mar
 2022 16:37:07 +0000
Received: from SJ0PR10MB4494.namprd10.prod.outlook.com
 ([fe80::48af:b606:c293:9cc2]) by SJ0PR10MB4494.namprd10.prod.outlook.com
 ([fe80::48af:b606:c293:9cc2%7]) with mapi id 15.20.5061.028; Mon, 14 Mar 2022
 16:37:07 +0000
Message-ID: <58cd72c7-a777-821b-1a29-ad71a10b0fbb@oracle.com>
Date:   Mon, 14 Mar 2022 09:37:06 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net] af_unix: Support POLLPRI for OOB.
Content-Language: en-US
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org
References: <20220314052110.53634-1-kuniyu@amazon.co.jp>
From:   Shoaib Rao <rao.shoaib@oracle.com>
In-Reply-To: <20220314052110.53634-1-kuniyu@amazon.co.jp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0233.namprd13.prod.outlook.com
 (2603:10b6:a03:2c1::28) To SJ0PR10MB4494.namprd10.prod.outlook.com
 (2603:10b6:a03:2d4::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 053cda12-e88c-43c7-1733-08da05d8e12a
X-MS-TrafficTypeDiagnostic: MN2PR10MB3888:EE_
X-Microsoft-Antispam-PRVS: <MN2PR10MB38885875354DF8B65DAB7DAAEF0F9@MN2PR10MB3888.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Vv1oYvt1tSj5epmKN0X604uWbd8QAz+qGRODo71L1ghOZOEn37p5Fj8jJfK90qY//FDeeS/LblLvTxAbVykS/e+ItFk0HeE6gJBoN3X03QhJ3O3pcmDKIPFOiY8/0YzlgLfEtNXwPx+RmnElboJuYL/Zp7/Y6/wRSTHhPmmhT6O9wx36YG4prEOpafCsQrajALIhX9TS5KsB7TluBeOLsJKFXLbE2o63lDXUADfx4RZ6gwegssGud6rOcF0CAs15kEqwJOneDl5acaxQ0+TmATaepB9lJlt2r/33hgMSUEoBZDcDRS4KvclhlLIVibaoOMEhRkSa5AjZ+vh9rpXfNn/9tnpieUo0Cu7sW+c4UZwssmAql6rOs0u1xcfBpFx/OPPtROaVMB8jWjHNLYy+K4uAoY3CUB6oJS2Ri1IL4RHE01CMqbKv2XleVzWLtt6UevcUysKgRQtnjnSIu6UjbYRRYzZtFbzqhY4FTT83KXYNaz+gAZ+ETIjPJ/5T0i53UBt2Q8x2Q/0p22d9vY6sJoJlSqgobCKCxq16DjKH9u+2m7QlpZJi3RI5+uCmPiqd/G4Viq4QfPNzN9cdq95wSy8XzHkFCn/aqXReT6lN8EDqlq5G9TcUcIzYbxXDqWmj5Z3JG7hIcF/mC2vI1ZFfQV3Ee9ROBo3VK1oQdJOkOrmhxZPl5a+3ScFUN7ijfzPC7lTFAnZgkaA59jo9Nst0EKEdPsU0k2fMMjfEs71hQFA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4494.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(316002)(8676002)(4326008)(36756003)(2906002)(31686004)(110136005)(66556008)(66476007)(66946007)(53546011)(6512007)(6486002)(6506007)(5660300002)(8936002)(508600001)(86362001)(2616005)(186003)(83380400001)(31696002)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S3ZTM1ZtZ1lWdkxnSXEza1NwQ25HSGJZSDNCR3ZXaU41YWJhL2lWazE0ZFZK?=
 =?utf-8?B?aURmRlBtdHBqL3oya0Uvem5oREZZTWJKTzQ3bFYrYUs3ckV2Q3hXWTA3Ylh5?=
 =?utf-8?B?WXVZaTBRdk41Yk9KSUw5SE9pSkNCYzV1eURheXloL1hZb0RBMnBYeExkWk9l?=
 =?utf-8?B?TFNLd2pEVUJFekNnRUZaK21HejRjZW1uVXlBSnIwblN5Y0RUTzJ0anVwNUlY?=
 =?utf-8?B?cG5CQ0hYTVN3RnFhWTg2bDZKc2dWb1V4clNEdDlkM3oxTGlyczhMSEtXTXZo?=
 =?utf-8?B?dm5XdFV3bkRORXN1YWtKRGJhckgzRHFTaDhUc0daazh1bnoxbUVaMWNVMUsz?=
 =?utf-8?B?YzRkZ3dtdTMyT2w5R2ZMTS9GSUVvQmZ1dW9Ha3B3eU5EYTVXS1FoQ0J2d1pa?=
 =?utf-8?B?L2IxczA5WEJzNmQwVUQxamtRME5UTXRBaGtRVlpCeGFmaUxkYk9RcmxYMmE0?=
 =?utf-8?B?d0Q4NDBSNTQ5NnBHUTlySVhxSWhHM3l1eGFXQW5BOGlmL3NIRmRibGNxZTJN?=
 =?utf-8?B?d0VRMVZpZlhtNU1ud0FydXJ0YnNkZEdWTjBKbDNNYjRMempFOUNtUGp6cWlW?=
 =?utf-8?B?NHV6NFUrY2tHN29yb0ttd2psc0JKVmJrQjJtTjZmcWRDVldCaUJsZDE4STIx?=
 =?utf-8?B?dzliSjlWYmVSZWNXbTVpZEI1S0hONTZMNDhvS1dFUFdTblNtTnBHMW5JNFp3?=
 =?utf-8?B?RDh2TUp4T0xwZzlWSGJpN3RqRHlVQ2YzR1d5Vlg5RFpEdjZJaFBybUdnL3hV?=
 =?utf-8?B?MlJBVHptK1ZMMzd1dVRkK0NkeXFHVWhrQ1lXbnRGeUI0TlV3dFJnbng5OTJ5?=
 =?utf-8?B?TDhJTjBhNWZWNGtWRTFhVS9GNHJBMWZkZVVMRHBHbGNaeTZkaUhiajR4MTE2?=
 =?utf-8?B?TFVkM21KYm9rNXBYclZ6aTFacGVtcFlrREVrK0ZkOGFqRjh5MUdLaUluZHl1?=
 =?utf-8?B?MzNqY2FpaElFQnFNQm9PcnFBckxRQVlKeVhrVStnSW5lclhXQTR2Vzcza3dQ?=
 =?utf-8?B?TDNVSUNxb1dZRG1JSXpMWHJBQXlMRk5VZTJETWZmU1BwN3pwM2NWem9IMW93?=
 =?utf-8?B?YXV4MlhjRzViUmdpUStQeVNMRnhxS2xpeERqbmsxbi9EOWFWOTh0RmNWdnAr?=
 =?utf-8?B?clhDVW1kc2xIODIxQWtYdGlEMy9ENWhLV29BeVJiQnVJdHYyTEpRcHdiNDhm?=
 =?utf-8?B?UGdBeUMwdEtQQXFZSjQxQy9RMXFHY3JqRFBzYXdYQUJMeFZ5bFdKbjFoL3ZY?=
 =?utf-8?B?SDVIMVVyVGxLNnk2cEd3eW1XSzlVOSs5bDl1RjNqbmo1WnJ0TElIUmhsbEpO?=
 =?utf-8?B?eFpqNXcxM2ZTWTBGN2FHMTFFZkRRb1ozU0FOWkpDc3hnQnBmeGZpSmxyU05V?=
 =?utf-8?B?dmtLa0FWVWtVVlhibUVVcDN2ZmdBT0FRbUdNVVlBdktqazdybkt4RWFYYitx?=
 =?utf-8?B?eDJiRjBuOVFHRzJiSEd2VTFkWFl0ZEpJdEV6Z2tjUjh4bWJ4N1YzcHNBcGR4?=
 =?utf-8?B?K2RaMDM1R2pWSW90ek82Y3ZBSFdzN0cxMWRwdnl2RWQwYlJBMU15U2dzcHl3?=
 =?utf-8?B?M3NWZUcwaDljY083YkRFRFpDR3RlSFdDQTltaUtJMzFaMk5BRFZWUmlZTm1w?=
 =?utf-8?B?d2l3b2NqNXRVUXg0ckJBckRHTkdIZ0M4cjJXVENoRG4yVEt1UFk3QTZOeE9U?=
 =?utf-8?B?QVdiSE5KcGg1TzY2b05Nb1grbzdHOUdUNmsyQUZYbEZ0K3NSamRPbXdHVnA5?=
 =?utf-8?B?bEJaMDBEZmlLTHUwVkk4eXZDa1RCcFhYNXU1N0gvcWxyM0RoUEh3MmtlVFVa?=
 =?utf-8?B?RnFxdlM5RGc3TmY2QU5HOXNSdVZsbTQ5NkpPcDdUZXlGakZyc1RKS0d4VllL?=
 =?utf-8?B?b3FzWXpYUFloKzl1U0x2TW9Qd1A2T0ZmNUwwcTdjY0ZFREtzb0xPdU13MmpB?=
 =?utf-8?B?d2ZqZnEwRERsNUc1QmxqK1ZrL1RTbUo1WGdwSHBxQXAvTUQ3Qy9IOFgvQnU1?=
 =?utf-8?Q?3U/UOxfuXaLgqULulvdzz0j2jErF30=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 053cda12-e88c-43c7-1733-08da05d8e12a
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4494.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2022 16:37:07.6615
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nruIuKrE4i6D+N+lnEJJPMX00aFba9PncvKXyI2YBVAfNl+ZFky8pnqkV8wx15iLMISBGDrgdbJx7OpVyFH8eQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3888
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10285 signatures=693139
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 phishscore=0
 suspectscore=0 mlxscore=0 adultscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203140103
X-Proofpoint-GUID: nVzfYjwV4wF7bHies0Cj1e6VIgfjkYkb
X-Proofpoint-ORIG-GUID: nVzfYjwV4wF7bHies0Cj1e6VIgfjkYkb
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 3/13/22 22:21, Kuniyuki Iwashima wrote:
> The commit 314001f0bf92 ("af_unix: Add OOB support") introduced OOB for
> AF_UNIX, but it lacks some changes for POLLPRI.  Let's add the missing
> piece.
>
> In the selftest, normal datagrams are sent followed by OOB data, so this
> commit replaces `POLLIN | POLLPRI` with just `POLLPRI` in the first test
> case.
>
> Fixes: 314001f0bf92 ("af_unix: Add OOB support")
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> ---
>   net/unix/af_unix.c                                  | 2 ++
>   tools/testing/selftests/net/af_unix/test_unix_oob.c | 6 +++---
>   2 files changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
> index c19569819866..711d21b1c3e1 100644
> --- a/net/unix/af_unix.c
> +++ b/net/unix/af_unix.c
> @@ -3139,6 +3139,8 @@ static __poll_t unix_poll(struct file *file, struct socket *sock, poll_table *wa
>   		mask |= EPOLLIN | EPOLLRDNORM;
>   	if (sk_is_readable(sk))
>   		mask |= EPOLLIN | EPOLLRDNORM;
> +	if (unix_sk(sk)->oob_skb)
> +		mask |= EPOLLPRI;
>   
>   	/* Connection-based need to check for termination and startup */
>   	if ((sk->sk_type == SOCK_STREAM || sk->sk_type == SOCK_SEQPACKET) &&
> diff --git a/tools/testing/selftests/net/af_unix/test_unix_oob.c b/tools/testing/selftests/net/af_unix/test_unix_oob.c
> index 3dece8b29253..b57e91e1c3f2 100644
> --- a/tools/testing/selftests/net/af_unix/test_unix_oob.c
> +++ b/tools/testing/selftests/net/af_unix/test_unix_oob.c
> @@ -218,10 +218,10 @@ main(int argc, char **argv)
>   
>   	/* Test 1:
>   	 * veriyf that SIGURG is
> -	 * delivered and 63 bytes are
> -	 * read and oob is '@'
> +	 * delivered, 63 bytes are
> +	 * read, oob is '@', and POLLPRI works.
>   	 */
> -	wait_for_data(pfd, POLLIN | POLLPRI);
> +	wait_for_data(pfd, POLLPRI);
>   	read_oob(pfd, &oob);
>   	len = read_data(pfd, buf, 1024);
>   	if (!signal_recvd || len != 63 || oob != '@') {

Reviewed-by: Rao Shoaib <rao.shoaib@oracle.com>

Thanks for fixing this.

Shoaib

