Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D29D570BCD
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 22:31:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231438AbiGKUbM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 16:31:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232018AbiGKUa5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 16:30:57 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 348768E1E7;
        Mon, 11 Jul 2022 13:28:48 -0700 (PDT)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26BJHNZ9031065;
        Mon, 11 Jul 2022 13:28:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=aKK/gzqNSPUo+r3xM+GYvX5oFBDMvkgq9L8yTDHBjsQ=;
 b=PQigtw6zDn5c+kYF8RSLpfQpyTtwqkzo0aYYyuWnpV4bP1FtOTmNqnkJ4JenwW/bx8cd
 +Az8iR2uKVWTYg/hp1mYrPuYYFcqN2IDgH7QkpsL0TUEUQISOcO66T/NGS6NiwN69E88
 +ehWvwRh1Xan5h2eMzZQXy77g/jtOTErNFE= 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2107.outbound.protection.outlook.com [104.47.58.107])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3h77gubhcp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Jul 2022 13:28:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MrECMwH5TsmHxe3zC6Qn8jN+wrW+R68TBz3qmzm9OmRI7oZIvitVxstT/Pa4I58hcbSmW3SOUfZvGX007J58GcO7/CiV6jSmTtKjq1TLxgeGgs3VWmOnAV+uoUZeVqhttA4xHEpWGKnnZ8Z/Ch3eqzADO9QgFEo5hvso/NSIMIn9PmuT9kzcft9wGH0Z6R3vIFRwAvZo7fW79fruOoMRvO/xRtRovoN97LA7Ku7xDup7L5vTJEizjjehdYnoon68sJHCAnLdcwLexdZ5lhc1uC4x2SzeCmzlmPUeatbEcR4g6tTN75shAItJBO39EtOJQRV05ZhBkA+r7C9qgVvtOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aKK/gzqNSPUo+r3xM+GYvX5oFBDMvkgq9L8yTDHBjsQ=;
 b=LnBJDR89K8EOW3GT3GqRranWRDZOGgA0V63faL0UwU2tKrAklz51XTS+EAHEb6+5dbzrtPboinvsP6aV06f1dx/BFYby88bgwSx1vxpQnqDv+iiep3nRAJHPhLooVR7ap1Ln2WQy6WNfh/bfjJz5Ha9Py6cfHDVC2CqNY4vtGNzO+AATq/U2pEf7ilTIE4MxRdZozmAUBxEj05aSin3Th3YZPRJZtfZciTXI2ZDRDWRxzDgItZS9nnii84C3xiX5+j8EkIihDSbjgtL1in9+5L6rxpQCAuPC8CjP20ewPZ/2AEb2q34R0UYvhItshsn0DkuuvxmVKXtcC3ssblvn8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4475.namprd15.prod.outlook.com (2603:10b6:303:104::16)
 by PH0PR15MB4815.namprd15.prod.outlook.com (2603:10b6:510:ac::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.26; Mon, 11 Jul
 2022 20:27:59 +0000
Received: from MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::3941:25c6:c1cd:5762]) by MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::3941:25c6:c1cd:5762%6]) with mapi id 15.20.5417.026; Mon, 11 Jul 2022
 20:27:59 +0000
Date:   Mon, 11 Jul 2022 13:27:56 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Geliang Tang <geliang.tang@suse.com>, mptcp@lists.linux.dev
Subject: Re: [PATCH bpf-next] mptcp: Add struct mptcp_sock definition when
 CONFIG_MPTCP is disabled
Message-ID: <20220711202756.he4wdhb6zx6ipjge@kafai-mbp.dhcp.thefacebook.com>
References: <20220711130731.3231188-1-jolsa@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220711130731.3231188-1-jolsa@kernel.org>
X-ClientProxiedBy: MW4PR04CA0109.namprd04.prod.outlook.com
 (2603:10b6:303:83::24) To MW4PR15MB4475.namprd15.prod.outlook.com
 (2603:10b6:303:104::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f1a53cf3-5613-45e7-bb06-08da637bd8a3
X-MS-TrafficTypeDiagnostic: PH0PR15MB4815:EE_
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BevNdtQRXD0W1L9LZv//NOn+ZbSucmrZsue5p0OY+2kNPoNHnPWIsmG3XchnZG+kvsalROMHVtUsor6pZLIT7nrQroyPiXoLUlnxR/21Mo5dS1+eSBcK6iy06XC1ij4YJ8ry8V54+SeBI9kLWDXfswzS6o8xIqIkNhqD9C+UT5LLYOy7WPzzvKQLY0WR/c0kAjf6LfYSNas4AcqEykALWi1Ed5+6YBZ4e7iRlRMCuPiELeunhJiApouH3ddeJm6DDKF5TvE2Cm5Zd5ttkypo8w8y+79b4fmQEQvJhNrdfHtvmnOGuPO2nlqYXRa8PN4DCsjjFU9k/6FWaDhsISHq8V+wXYlMSV36atTvFDhOYqzFdPpeKsI9zdCPFl0Gw9KXUiyXavE49HFJGdseWyWyjwI+hyhXgX6DBfxkN146Bi0ArYOxJ+fAAhwT7n1etMPHRmP/4loA+mKRmHa4Xp2oSo8lT7vfYRMUxKHrfBMkX+9Y0euyTrvoim5YuVJXKPYDGgXkiuNFNRlmroZEkQ4+81K7OU4pqMA1oj6QBQYUt8nnBxNjsDt5ghyMWjdM8mlTVodlgRH6hiEfWGeNgQaSj5/ETCjd1oU5/qs5dbafgrqXM/EC2hRpIdlfAhIKaViMbrdd0GNSk+CBGVw0STDjlkEN4hCuA2lW9hYWw1BoTsrDXKZ4pzE0m3NzNeBp0D+6XuopSqz6S+Vou7s28U0CYR0+00SMQdVM06hkKXlWqG2q89M+Z/uBINH/XXjHLaKw
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4475.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(39860400002)(346002)(136003)(366004)(396003)(7416002)(6916009)(54906003)(316002)(5660300002)(6666004)(478600001)(1076003)(186003)(9686003)(6512007)(52116002)(2906002)(6506007)(41300700001)(6486002)(83380400001)(86362001)(66946007)(66556008)(66476007)(8936002)(4326008)(38100700002)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VL3N8lSY5wmTRCJ1gT1In0ud5lePyZ7nKHdsS7UPM3pfdP3JK+5ckztoP5/E?=
 =?us-ascii?Q?KKHX8vTh2G4UN6opVdllozGRL9WYh5bZMmeJP6HkBIatoMjZPzcVaiuMZgiE?=
 =?us-ascii?Q?Lw271SazrK0L9HMdzEgDRoaLlBDeU6t2zVnw8Mn2VkPmdvo0SLi140xuRyTH?=
 =?us-ascii?Q?EDcBPfj2MQaPERdg2C6t98xKCx+F7Ql4YJrO1+64QY7aIkA2b+cSwTELBkZ2?=
 =?us-ascii?Q?A8P0A26sfNb7jrAJgzNtg0y/Ye8hTuQaGGOXrZwEQJXNI+gup07/5xZHyykx?=
 =?us-ascii?Q?GihvVJ1d4o7UUFYi9XdHaYMXF4gyGKYjrCimIQKSrEMYnB9E/aAx4dYegA3K?=
 =?us-ascii?Q?tp1GkJH+pGK1S/TybkrIw93zhhcloF1KVCL0etnfeHsspiQ9ZJTRX0xOmZSY?=
 =?us-ascii?Q?7rtNUWq9YsKXUub/pXvP2izRbwm3gaUY18m34Lah1GtzkdOiGscYhasNuu6M?=
 =?us-ascii?Q?TIVlqLwwzoBSwo+b6YBML/k0kG94DfRYqtGkkSZLgZ40KPS7vf1PmP475HXx?=
 =?us-ascii?Q?jKP9EjrDrK4X/zih3v/NuouyuS4FwgD6XGu5X8pyqH5SeYbhB3bsxNB7/WHY?=
 =?us-ascii?Q?W5kzxgXfEkae/iRHRqNxzgeVJQoV5gsHJ5p7W1iHKh1PB7izeQljZixyco7S?=
 =?us-ascii?Q?x1b8jl8OgwFsmI/7t1Lj9MGQVPw+T5HVaKg30SDOWiAeJfc99lkoGg9GrjmF?=
 =?us-ascii?Q?UTTP/wNOgf5ewvkNUeKcg0HTJKT2eI+oLBVQvDBSUMH3tHvvcAuZC9ZXDJYo?=
 =?us-ascii?Q?YvzukuZE5bsL5Xl3q5vmNd+VL6gUQe6p4vlUaEdew9jSMrKEzJdBwKj4PotA?=
 =?us-ascii?Q?xqVepobyfe/H0QN0REAXgRs3+AMICeBPzVPg2xJ2cknv3xWveTcu8hI6d008?=
 =?us-ascii?Q?aUQVzpWZ5M9VI03PL35346CZvEqoSXKjZIqKihfEqnvd+LJWJFta7dyjajaS?=
 =?us-ascii?Q?0Z5sPhvYPc2aVejSxqx0yQth8rnT5AG6Gr40nFBBfEoPAsjw2zQQxE88XhUX?=
 =?us-ascii?Q?cnfhf2msTlxwDzP4hXVgaBv/hIAVyaCUzsAc5hm0jJ7AdZir0NC4u71DUGCi?=
 =?us-ascii?Q?/42ryZj8EZh3Zs+taeIYqQQjNarsVvsGVesLuQlE35SDNJpkKXhz1uJ2jxte?=
 =?us-ascii?Q?TrBApZdD0NGzWtTVFYRQs6Ug9DH99KmeEVQeyVeVKsrfgKnCZs7BtjDOwyVd?=
 =?us-ascii?Q?skhS4YgZF0jpEsjw+Ph1yy67o37zDOXRNgIEy+sEWYGi/y4f62SR2ARGohWG?=
 =?us-ascii?Q?FEkQNSjSBKhcKgw2837Qv+ZlN00tTCuNQEyUKpXeQHODhgAXRuxvIuvGSln9?=
 =?us-ascii?Q?UE3gni0OIaIZIlXg5LrPK5VT4pdxg2BX4RBrkEtOCV56CDjqA1Dl12BTz5T4?=
 =?us-ascii?Q?0Dm5yT8KLgJZxxtv2g7TRznui0b4QGZ85Ra7Wl7bLzi11OGqltEuOBwOQaaO?=
 =?us-ascii?Q?wnEKpO1XL5Hcj3NHnBQTRYki0JiWgMTcFSdC6xYQw49ZwqoLSNBEmitPfgP0?=
 =?us-ascii?Q?PMoelLLzBUYtpki+BFh6ACMRDtKHinhz5Xn2zp6mkHhO9wGLG5k/IraMY08b?=
 =?us-ascii?Q?GJ2vDEcd18FWA9GsQ0g48jMT0ihhIYKBp9FvEXSZFweB9n22OtxMuiEQoCyl?=
 =?us-ascii?Q?UA=3D=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1a53cf3-5613-45e7-bb06-08da637bd8a3
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4475.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2022 20:27:59.5269
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G2lWl42gmeQ11zah2+eQKizBXVSaXf2l9kzVFmOPS18wK+OuSG/up1ms8rW+JsIL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR15MB4815
X-Proofpoint-GUID: _MmnkALJxQE0QnxcGe6GYJcH5PkCOyJ0
X-Proofpoint-ORIG-GUID: _MmnkALJxQE0QnxcGe6GYJcH5PkCOyJ0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-11_25,2022-07-08_01,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 11, 2022 at 03:07:31PM +0200, Jiri Olsa wrote:
> The btf_sock_ids array needs struct mptcp_sock BTF ID for
> the bpf_skc_to_mptcp_sock helper.
> 
> When CONFIG_MPTCP is disabled, the 'struct mptcp_sock' is not
> defined and resolve_btfids will complain with:
> 
>   BTFIDS  vmlinux
> WARN: resolve_btfids: unresolved symbol mptcp_sock
BTF_TYPE_EMIT(struct mptcp_sock) did not help here because
'struct mptcp_sock' is not defined anywhere in the include/ ?  :(

> 
> Adding empty difinition for struct mptcp_sock when CONFIG_MPTCP
> is disabled.
> 
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  include/net/mptcp.h | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/include/net/mptcp.h b/include/net/mptcp.h
> index ac9cf7271d46..25741a52c666 100644
> --- a/include/net/mptcp.h
> +++ b/include/net/mptcp.h
> @@ -59,6 +59,10 @@ struct mptcp_addr_info {
>  	};
>  };
>  
> +#if !IS_ENABLED(CONFIG_MPTCP)
> +struct mptcp_sock { };
> +#endif
Considering a similar case in the existing 'struct mptcp_out_options',
this seems reasonable.

Acked-by: Martin KaFai Lau <kafai@fb.com>

> +
>  struct mptcp_out_options {
>  #if IS_ENABLED(CONFIG_MPTCP)
>  	u16 suboptions;
> -- 
> 2.35.3
> 
