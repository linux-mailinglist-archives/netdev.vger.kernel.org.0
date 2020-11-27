Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F7B72C604B
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 08:05:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392677AbgK0HDA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 02:03:00 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:3308 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732332AbgK0HC6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 02:02:58 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AR6x4rS013931;
        Thu, 26 Nov 2020 23:02:42 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=o7od1NBCWqY7m7v4yWLDNWXHgpUOMZWFtqhDzbG+FaU=;
 b=HUqkYAHkf9NEHGDV77J4ODwAIf9ZPeQIDL2cw8Yi/ZisY7I8bm28QlOe3SeihO4/3ZUF
 aVMD08odV7XXOsjRpgK/Umft3SQ0sX4qJyTcjvDuuEJ+TAve5EjfU4zKtDIjLRpGZj8S
 l5fllzoq6K6G4cLpPanDVfxHCyqlmmpEXxI= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 352s3n0mmt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 26 Nov 2020 23:02:42 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 26 Nov 2020 23:02:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k9cW/E3QpHOuxziOFd1drIyyE5orKv3TVh3JiYoLeP6C+aCUTJs/S/6p4/r0bs4+7KCxrranG7SqWKN0oczEVAohi6V/9LEM3+WlzS28rBzUXUkZncgT11VZFGRtZDa+kZE+0duR6vDHxl8c8YEG/ibs3hRpElA5/m+1HdPiBlvuT0aur6MLlxoUNnpzXAjaBHEEJo6GLyWvliPIsJrkUmNJsTSmguGCnRT9qRneFnQcSIyuhNTHr71iqs4ed7MOTfNoYi+6/i3PIHFfewXRg+f42IldoN+qSW67g39sTpnp4kORhX33psm6NvWtcf1rZBgVxfK9saPe/w+LUFDtXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o7od1NBCWqY7m7v4yWLDNWXHgpUOMZWFtqhDzbG+FaU=;
 b=H+XPeG3QG26Lg2WredGY21q9T4MjLk8Pm9f5TOsyH8fi5wBFFtjYvMqTaiwYtAner5QQKnwtIwPULMRUc5xlGuzRoVxeMm2Xc1ym2DxSitu189771RS/QBufwGvUClsR4JoAbLM3jKR29/IbCsk33miTvP7xanHDA60hoxQKszwE+WuYih6c5pI+33ke9ztDyfHGFk1m2gfU+3MV3fk/+mifGx7B8FXInUEUypP0ZVFqrZat9nXE51VTegtsBwF+dGpeWvOwuvo0M71bvoVZBlYOcj2jGmhg0ftqu8P6kqBeKSLnICywxk097r0IR7a4OpyxktfWcj+tn11xqO9D1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o7od1NBCWqY7m7v4yWLDNWXHgpUOMZWFtqhDzbG+FaU=;
 b=eNvmQTtnZk2JJlyy8nC6iV6epSyxJvK1vOcif7l6o8rG3QC4SNUJv/n7fsq53RZe2VC/4DoFbSOqVEAve0k3WG9vnFNwcdUR9MoJyQLcAeP/vMXYg703UvOljbSISi7OEHfytbJcTiKy47phXkOMZlNqoSz3DUQ098lQM3dGWNU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB3208.namprd15.prod.outlook.com (2603:10b6:a03:10c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.21; Fri, 27 Nov
 2020 07:02:37 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03%7]) with mapi id 15.20.3611.025; Fri, 27 Nov 2020
 07:02:37 +0000
Subject: Re: [PATCH bpf-next v3 6/6] bpf: Test bpf_sk_storage_get in tcp
 iterators
To:     Florent Revest <revest@chromium.org>, <bpf@vger.kernel.org>
CC:     <viro@zeniv.linux.org.uk>, <davem@davemloft.net>,
        <kuba@kernel.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <kafai@fb.com>, <andrii@kernel.org>, <kpsingh@chromium.org>,
        <revest@google.com>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>
References: <20201126164449.1745292-1-revest@google.com>
 <20201126164449.1745292-6-revest@google.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <28d9c6e3-6919-e969-998c-fd1b62cb849c@fb.com>
Date:   Thu, 26 Nov 2020 23:02:34 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.0
In-Reply-To: <20201126164449.1745292-6-revest@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:7e72]
X-ClientProxiedBy: MW2PR16CA0042.namprd16.prod.outlook.com
 (2603:10b6:907:1::19) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21cf::1008] (2620:10d:c090:400::5:7e72) by MW2PR16CA0042.namprd16.prod.outlook.com (2603:10b6:907:1::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.20 via Frontend Transport; Fri, 27 Nov 2020 07:02:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f7ed9587-ce37-4989-f615-08d892a26c72
X-MS-TrafficTypeDiagnostic: BYAPR15MB3208:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB32083F52701BF867A0939578D3F80@BYAPR15MB3208.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aZXejZ6qfn/iGyYFt2skd8E02RhO4mRGJxFS0bsRJ+Er09NhboDtvIlKksm33z6Oqd67nDwAqtnIkY0GovlhsBAeqJ9nJ18RsNoT0qI01sjipzAKc5DDmcKpP6rZLWEHtCK+8vOMa4IKGIBFpZHWsQLx5iCy4dFjbD4RKjXGi+jIvzkdhjp1cUSTMj7DvAgddM0tpZwgEmgk7ky74opvkTbUkllINzP3Skp5rKRA4IAJQ24+hnqDpHw9WU+g50x1zPE4ZvxJBMLQWIcQelZpxDJYVeUuv9YHoEdR4uGcf9HOA6LeP1nMBbgBbXVoW5/nQYcpDzbrI0mr1yNIf8ayoC8hyHH+a8wfZBhBJRFGmm6WS75WISWWplS0KdbvIoU8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(376002)(346002)(136003)(366004)(31686004)(66946007)(316002)(53546011)(5660300002)(4326008)(7416002)(8676002)(31696002)(2906002)(16526019)(8936002)(186003)(83380400001)(36756003)(6486002)(86362001)(2616005)(52116002)(478600001)(66556008)(66476007)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?aDZadlRiYkk1WGdBeEF5QTZHcG1GOUx3UmtwYklNOHB6MndpR2pzN0FkcUMw?=
 =?utf-8?B?OHRpK25Ub2pWdnhyZXUrYmtSZnYvb2FGL1pYL0RtWnpYNFF6Z1drWWR1U1BO?=
 =?utf-8?B?Tll1V0R3S3J6ZDVsVU4xM0M0bDNYT3htYlVKSlBZQlpVTVNOc245dExRNkJR?=
 =?utf-8?B?OG9ycFA5RkFoMW1uUzVHUlhhR2dKZXdhWDl6M0dvTVRvZTd0Rlc3cS8vdHF0?=
 =?utf-8?B?a1hyQkVidkZaQ0p5TEE1TFlIdS9SZHArK2pRRElwb2NOR2JsejcxSSs5TjhD?=
 =?utf-8?B?K0Y5Zzg1L051WjVZdC9XazVDNS96NXN2UXJsTkV5V21uNTRTWHN6L3d4SUJ6?=
 =?utf-8?B?Y241ajZtTldON05RSVZBTG1qK1JuR0t2RmppelY1bnVGbThsUkZXcERiY091?=
 =?utf-8?B?dVlEYzd2aUpMU0MvVjA3K2haQ3VyMjZFUnloanp2VXdBdU9LYzhwWXBUaEsx?=
 =?utf-8?B?Q3RWTjRiWmtzdC9yM21OSlhwWExGZS9RMjJING4vVXpxTDQxSzRHTHhPUC9L?=
 =?utf-8?B?eGtaL1cxNjFVcTNCc2lWcHcrL0xZZitMUUtnREdpRGFsb0RPVmpLZWtrbm9p?=
 =?utf-8?B?bjlCMDg4bFdHOGUzT3ZQTGlUeVNtaHYwSmoyeUY3V0RxcEh0YU0wemhrOHI1?=
 =?utf-8?B?Mm0xS3RpSDErWXZzWmRJb1krY3YxTFhhdk5yUWFtdENXVmZTazRDU0dFbDVp?=
 =?utf-8?B?V2kvZ3VkZzdQTUJidUFSZDlpa0pBN1k1YitIc1BOcHViNmtHMWpGNmZYR3JN?=
 =?utf-8?B?SnpudGZrZ0FtVHlxQkJNaTNsZDJ6S1RJSzk0VFZzaDB6RE1CQmxyK1F5bWJO?=
 =?utf-8?B?WS9KZjA4UzEwcW94UTdWd1dEa2FSQWpjQTY3SGpYbytvOU5Scm1Wc2ZaS05G?=
 =?utf-8?B?YWJESklsalBXZk9CdVEzSUpYMHlHdGQ3ZXJSSVN1ZUY5QjFQVUJrTjEvK3ZX?=
 =?utf-8?B?b0VhVTMzek4zaTB1S2tSUlNHNnNOMXlXMUJPQjJ3TFB4dXNGaFc1bnVQNlRG?=
 =?utf-8?B?UXZJMThSRFNROTFXV2tpeTVZWW9ZbUR0cHN6dkVIRFJrQ0pXRXBZcCtVWTBS?=
 =?utf-8?B?WWtBZldtcWk0TkUrNjdyRHZmU0Q3WlhzK0x1cGlXNEdBeS83Q2tnVHkyMW9h?=
 =?utf-8?B?Y25XN1h5NFlhMC94ZFdJb3lGazhzQkliVjF5eXdKNXJsUGRKb3hpK1kyb3d4?=
 =?utf-8?B?MzJiZ1oxNm5zTmF1RWVsbmlkR09CZnlYUC9tU3dsRk5ydy9xRlZDby9kQWJ5?=
 =?utf-8?B?eURZVUphWjBHNWR4SVg5VEs2LzlOamZGTGVaQ3VEM0hTRDVGZk0xQ2pydFdq?=
 =?utf-8?B?a1JsMnBDMWdRL05EYlZseWZGNjB4N1dRb0trKzk0Qkd5TXBwVWdUQ2ZKTlE1?=
 =?utf-8?B?QlZXQXhzUkhRK0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f7ed9587-ce37-4989-f615-08d892a26c72
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2020 07:02:37.5975
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ACjZajbv04ji9vk/YHgBXnu9F44cMhjmJaM28iznoKCztad1j7oNTRnSWTYOd16i
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3208
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-27_04:2020-11-26,2020-11-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 bulkscore=0 malwarescore=0 phishscore=0 adultscore=0 clxscore=1015
 spamscore=0 mlxlogscore=999 impostorscore=0 lowpriorityscore=0
 priorityscore=1501 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2011270040
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/26/20 8:44 AM, Florent Revest wrote:
> This extends the existing bpf_sk_storage_get test where a socket is
> created and tagged with its creator's pid by a task_file iterator.
> 
> A TCP iterator is now also used at the end of the test to negate the
> values already stored in the local storage. The test therefore expects
> -getpid() to be stored in the local storage.
> 
> Signed-off-by: Florent Revest <revest@google.com>

Ack with a minor comment below.

Acked-by: Yonghong Song <yhs@fb.com>

> ---
>   .../selftests/bpf/prog_tests/bpf_iter.c        | 13 +++++++++++++
>   .../progs/bpf_iter_bpf_sk_storage_helpers.c    | 18 ++++++++++++++++++
>   2 files changed, 31 insertions(+)
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
> index 9336d0f18331..b8362147c9e3 100644
> --- a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
> +++ b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
> @@ -978,6 +978,8 @@ static void test_bpf_sk_storage_delete(void)
>   /* This creates a socket and its local storage. It then runs a task_iter BPF
>    * program that replaces the existing socket local storage with the tgid of the
>    * only task owning a file descriptor to this socket, this process, prog_tests.
> + * It then runs a tcp socket iterator that negates the value in the existing
> + * socket local storage, the test verifies that the resulting value is -pid.
>    */
>   static void test_bpf_sk_storage_get(void)
>   {
> @@ -994,6 +996,10 @@ static void test_bpf_sk_storage_get(void)
>   	if (CHECK(sock_fd < 0, "socket", "errno: %d\n", errno))
>   		goto out;
>   
> +	err = listen(sock_fd, 1);
> +	if (CHECK(err != 0, "listen", "errno: %d\n", errno))
> +		goto out;
> +
>   	map_fd = bpf_map__fd(skel->maps.sk_stg_map);
>   
>   	err = bpf_map_update_elem(map_fd, &sock_fd, &val, BPF_NOEXIST);
> @@ -1007,6 +1013,13 @@ static void test_bpf_sk_storage_get(void)
>   	      "map value wasn't set correctly (expected %d, got %d, err=%d)\n",
>   	      getpid(), val, err);
>   
> +	do_dummy_read(skel->progs.negate_socket_local_storage);
> +
> +	err = bpf_map_lookup_elem(map_fd, &sock_fd, &val);
> +	CHECK(err || val != -getpid(), "bpf_map_lookup_elem",
> +	      "map value wasn't set correctly (expected %d, got %d, err=%d)\n",
> +	      -getpid(), val, err);
> +
>   close_socket:
>   	close(sock_fd);
>   out:
> diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_bpf_sk_storage_helpers.c b/tools/testing/selftests/bpf/progs/bpf_iter_bpf_sk_storage_helpers.c
> index d7a7a802d172..b3f0cb139c55 100644
> --- a/tools/testing/selftests/bpf/progs/bpf_iter_bpf_sk_storage_helpers.c
> +++ b/tools/testing/selftests/bpf/progs/bpf_iter_bpf_sk_storage_helpers.c
> @@ -46,3 +46,21 @@ int fill_socket_owner(struct bpf_iter__task_file *ctx)
>   	return 0;
>   }
>   
> +SEC("iter/tcp")
> +int negate_socket_local_storage(struct bpf_iter__tcp *ctx)
> +{
> +	struct sock_common *sk_common = ctx->sk_common;
> +	int *sock_tgid;
> +
> +	if (!sk_common)
> +		return 0;
> +
> +	sock_tgid = bpf_sk_storage_get(&sk_stg_map, sk_common, 0, 0);
> +	if (!sock_tgid)
> +		return 0;
> +
> +	*sock_tgid = -*sock_tgid;
> +
> +	return 0;
> +}
> +

extra empty line here.

> 
