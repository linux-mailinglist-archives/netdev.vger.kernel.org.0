Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93D9A549D6A
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 21:21:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349064AbiFMTU6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 15:20:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343931AbiFMTTy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 15:19:54 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30F032716A;
        Mon, 13 Jun 2022 10:17:26 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25DFSt4g011655;
        Mon, 13 Jun 2022 10:17:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=facebook;
 bh=O9P6H1J00HU0NdlYvkPwC5ZMSEVbd3bLPUm7UUi9UPI=;
 b=qURybeqH5DwVQeIIrya1m//DsKLoMshXGH4X339pXfJkpLPlrlwv+kt4t0iK/+IrCQvb
 IDX1RNJ99pJdUPPK4avntT5Eaj9qEs15UGnweGQhHqR9TrHGgkMpeTWeYQzq+W6nloxy
 axaEB+i1VrqdQxbME2xmwI6d2L/puJxD5hc= 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gmrsxstmf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Jun 2022 10:17:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R157viO21ikdpqG9BiMnVb3XkeMIBQ14Nj26DkZnrbmcH5qf5juPytBZESY78NZ5lA/OOHfhUjDO4VYf1t8lPsJk6B3vTDbYjJgeEA/IQ6lfKMhp7T8QJx0MQT9JJmni9YFCz1vi50pa+8K1aZXhni2vcIhpwCTUMw/ug8AddTkTd2Yfego/X/1pWKudJPwGlDFShzqvlSojm3o/SyCgHkTRpTXgSDffYZjsGriWVfUhl3pb55DI+yjVM1mCpcW952XZapwk6SykjOJgKSOBleKmBbTuaz8JKkktveZoZUVBiL1APX6xE4fJIJGPX2WqEMrO3K3nE3QK3FFuwAZpSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=56vbe5s8tAJjxWUGqNGdArqBWQZ8nkTa/gPFkpV/ZXg=;
 b=GVDAVGTFXuOtOL1XcLYrshJHNwHXT2g4Mn+nmfVMf0HFl8/DlQry/VSWPszmPs/h2fTXc6li8xUH1qtwvD1Ae7PndC1niuCAg7Hd/ouaj1Zbn/yMudFN+nsBAwduyDGwMJY9+WpkOZ2ahoEWjRdE6xAuTC44mgHNo1ehb2VUPgtiORKuo+zy72W6F5nmEuwM/R8NFFeCujQTmySTQ/ussaZySNVpyopnYTgjZZYpfc0+PuHaRTM5pgQLDw7FlMGI1O3PD8y8sPTxY3k7bGYJ8fSjqzfXsN9lelS/4DktWGpe6C0DMPAIP9TZa/LYO/WBCf4XaGoG4Aia3qSt2UZw2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4475.namprd15.prod.outlook.com (2603:10b6:303:104::16)
 by BL0PR1501MB2146.namprd15.prod.outlook.com (2603:10b6:207:31::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.20; Mon, 13 Jun
 2022 17:17:06 +0000
Received: from MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::3941:25c6:c1cd:5762]) by MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::3941:25c6:c1cd:5762%7]) with mapi id 15.20.5332.021; Mon, 13 Jun 2022
 17:17:06 +0000
Date:   Mon, 13 Jun 2022 10:17:03 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     =?utf-8?Q?J=C3=B6rn-Thorben?= Hinz <jthinz@mailbox.tu-berlin.de>
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next v2 2/2] bpf: Require only one of cong_avoid()
 and cong_control() from a TCP CC
Message-ID: <20220613171703.xoetc7dlr4qkss43@kafai-mbp>
References: <20220608174843.1936060-1-jthinz@mailbox.tu-berlin.de>
 <20220609204702.2351369-1-jthinz@mailbox.tu-berlin.de>
 <20220609204702.2351369-3-jthinz@mailbox.tu-berlin.de>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220609204702.2351369-3-jthinz@mailbox.tu-berlin.de>
X-ClientProxiedBy: SJ0PR03CA0174.namprd03.prod.outlook.com
 (2603:10b6:a03:338::29) To MW4PR15MB4475.namprd15.prod.outlook.com
 (2603:10b6:303:104::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 01c7c88a-c642-4698-1127-08da4d608a6e
X-MS-TrafficTypeDiagnostic: BL0PR1501MB2146:EE_
X-Microsoft-Antispam-PRVS: <BL0PR1501MB214673CDE356A7BD1B912D3DD5AB9@BL0PR1501MB2146.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PlG4o3LNE2uiyrjjxRfpxGNrvyujzn+Eg/PqPTtab9QYg1LXYIxxt51clrCWPwrQJSM8itOa/A8LkboC0/xHZcwHYdD2WgHVCiyEWx+eljXJirc51Q1Y+IA1cHQHn9IzXLNttkTEibXjpHPfe5U0kJ9PUZAS8ho5lCKOoJhN9ms32ZGBAXN4Xl0IRl8Dl88F46eRFC/bGMSL6Luanro3G4igZ3SAzuKDrndyfU/hChXopKAk4munAW4MnGCrLsGzfbDgVlKg1GyzRyUuVyOcLZKJYm1S1RT8gT35iTwyWEIvww2C2UBxOLv/toDaP0oqlog7vR6mmznJwovFTcicg4sRI+whx88I8lQEfZ6TiXC8TbQNnTKv8PhIE7eH10FI3X7jhoB3d0oPF1OsYptXvWFfdBz6N6bFCGxjV0fRODSPDKqK25nll8vexMYH6S5p0xy8u4c0Av7PxIJkIcXOpXGrjhpp/0VheuweB8Yd9eTC1398CtXOdxlFJidwguCO8nYEPtnpNH9fmqHcR4fWow1OMGflAYwFayXgMA9vCB6/nChnN+jw9IKqDqsVnUj/OEWXN6PDJiyWDLyaokQgG4UvlM5/q0z8S1z2gJgqdU25Bt67wuaX+6En2lgdOWAInYPba1+uF1p+dCwXuyP2+A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4475.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(366004)(66556008)(66476007)(8676002)(4326008)(6666004)(2906002)(66946007)(6916009)(6486002)(5660300002)(83380400001)(8936002)(508600001)(6512007)(9686003)(6506007)(38100700002)(52116002)(54906003)(86362001)(33716001)(1076003)(66574015)(316002)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?N8qN566LWSv/GeVv34HpEXlA7YtzXVtAVSAV3cQ09FxcoA0WEcnr9EMOW8?=
 =?iso-8859-1?Q?ZMXsq9PlI9/8LHVd8zskj7WCe+i/aO18ZnJzVpEjRAXJ2hA0sbxPNAgoR8?=
 =?iso-8859-1?Q?TtyCUdT3bosZ7uh9rksADqYCDA/aDXJHuvbd7IHkUB9jE4korLmHvcQoXQ?=
 =?iso-8859-1?Q?wGtl9CNR3AMw3Jw1EOI3KOhVhnSdXw/LhmYAVsx4NHRMTf6PwNnrn0TjgP?=
 =?iso-8859-1?Q?mZYDNCLUa0oA3ZNBZIL4AWFm3bMQfWUF0LZLcA83EdB86Wq3J9JDSVKLg7?=
 =?iso-8859-1?Q?osDedsbsPDzRYsZMpF6IRNXRj/TzjNk6ByidxcO3WSz9zwgW9iZqXgCnni?=
 =?iso-8859-1?Q?l84GPtcLiMjfcTiQQrXNaucA6Rjo7zZo7ruqpeWtm5YaVT9WggVJ+xHJ+J?=
 =?iso-8859-1?Q?CZOzTux7b/O5hnGw/GoWIrRr50+hN5Ayj6T7wgOiLEmG5RRUNMiu5wcWrx?=
 =?iso-8859-1?Q?ty6Lo31U5GW9AfvXy7pI93WubA/zdFGAaKbw2i/El59jFrbAi8cw7GJvRX?=
 =?iso-8859-1?Q?JPnufFzTO79gPamwW+mZnf8vWGw3SOUuJKtvEGEkEAw+8pd/n41wozsLxR?=
 =?iso-8859-1?Q?guBRNZoIZO0A+MTBz6Yn04bR5iKODsdkW1+6vGHMUE4VbBLTVMpY6bBqhW?=
 =?iso-8859-1?Q?18i7ir9ZAl2U3bp2AA/ulk31/CkklViDVWhY5pMJgwT9hWMOfUDl4OHIQS?=
 =?iso-8859-1?Q?ynMaYOBBdPN4sOd/zfMpJOK2UW2IzCgpnTVFN+0rInSGSOZxaeuQr7Y8GO?=
 =?iso-8859-1?Q?A0PakEz1jxWFaZy5PD3v2S5PjyzbcvHsUbSK0oPecGgNpurSefFxHQn9aL?=
 =?iso-8859-1?Q?PTceYh3xK0AJxqAFbAqcx7/hMYDyb3UnNLGi1ZdQ8Wds9GZLJTBFCa2TR8?=
 =?iso-8859-1?Q?jjy5Zui2baaA/MSyDhEjfZUnVtNOTHugdmbpCJ+E6QtFudZARS/h7ebA5E?=
 =?iso-8859-1?Q?1tI/lLftAPwkxEe6ZxFHfZO5UZl+nG3ZRHrvcv1WDx5N4m6X1a9+z4Dkc3?=
 =?iso-8859-1?Q?EOh0WeRc0+fOn31SKtB2sDIzJP91zHDKRDMfe4naSACydrOBSKTUrKgyUR?=
 =?iso-8859-1?Q?J3Jf9KE9ojfWiuadSM+oLzgj0TmWvO5r0JuR7YvOR2eioF4k9SDYUR6pAO?=
 =?iso-8859-1?Q?jtvQuc6sgiVjU+/Xib2Pp9+hCHhk72aDjKBheGZza8SmSOChbF2huUrBhS?=
 =?iso-8859-1?Q?coX59s6Raubo60Fn+CO39ikQdmYUEa0eYQVSm6HCS84Agd1gcAbC+HOTfD?=
 =?iso-8859-1?Q?q0DmubWloqQsOxadTowFBAkDCRpt9k2PSO8RPBaKRtvhJdK0Kx2pQHuX5p?=
 =?iso-8859-1?Q?QX+l3zTEem10x61IHIcZsYC60O0RUG2YU1Ak1fU8gLVIketMJ0x+i5dbAe?=
 =?iso-8859-1?Q?c0ntvPaafVT2Vztsh3Tv3HcvZC+jbopeR6ZuH3g2jPGLljyPs3/tB8zb3K?=
 =?iso-8859-1?Q?sCAMEqRqvA34QBvAmuwS8WbJyL7X+YP9SRXnKVbKboAjaooj8mEDlLxJUW?=
 =?iso-8859-1?Q?a7+Rd+1Fk/AlpyPE4vL2aDp2GWA+iF2w3GaWNQ2su59iLHYtxSML+v7fVU?=
 =?iso-8859-1?Q?FYlGguEZl1Rslsx/dB/cegi0EgQCECHYtW7GRtP6q4S6TrKF+vTQKRCfy9?=
 =?iso-8859-1?Q?drA48qwbGovAatMBTU/v2dLFTQay34peA+99R4l+U6WixBWrQDg2Q3Jc6y?=
 =?iso-8859-1?Q?Py/GB4jRHYJ31Qm6syeGQcfO+43IDJCFt350WFFf2E02Q63LuPLgutKJUX?=
 =?iso-8859-1?Q?UcycMJAN8SsrucnKfM6w28xThnFhYyXVHe0Loi6TZMbEcZdx7Q/RVSaBhn?=
 =?iso-8859-1?Q?Yvw+1SyJPODFCVA7rtkYBM+20pw1fc4=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01c7c88a-c642-4698-1127-08da4d608a6e
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4475.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2022 17:17:06.6002
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mqRgkEApmvmQn59wHKowjlMomhVfrXkx0pp6ypLXsJ9d3+jyni8SukVGvMqi1xbW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR1501MB2146
X-Proofpoint-GUID: 4Y6efSY47QUoVoUzSzbUmNLtdhAmZ0pj
X-Proofpoint-ORIG-GUID: 4Y6efSY47QUoVoUzSzbUmNLtdhAmZ0pj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-13_07,2022-06-13_01,2022-02-23_01
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 09, 2022 at 10:47:02PM +0200, Jörn-Thorben Hinz wrote:
> Remove the check for required and optional functions in a struct
> tcp_congestion_ops from bpf_tcp_ca.c. Rely on
> tcp_register_congestion_control() to reject a BPF CC that does not
> implement all required functions, as it will do for a non-BPF CC.
> 
> When a CC implements tcp_congestion_ops.cong_control(), the alternate
> cong_avoid() is not in use in the TCP stack. Previously, a BPF CC was
> still forced to implement cong_avoid() as a no-op since it was
> non-optional in bpf_tcp_ca.c.
> 
> Signed-off-by: Jörn-Thorben Hinz <jthinz@mailbox.tu-berlin.de>
> ---
>  net/ipv4/bpf_tcp_ca.c | 32 --------------------------------
>  1 file changed, 32 deletions(-)
> 
> diff --git a/net/ipv4/bpf_tcp_ca.c b/net/ipv4/bpf_tcp_ca.c
> index 1f5c53ede4e5..39b64f317499 100644
> --- a/net/ipv4/bpf_tcp_ca.c
> +++ b/net/ipv4/bpf_tcp_ca.c
> @@ -14,18 +14,6 @@
>  /* "extern" is to avoid sparse warning.  It is only used in bpf_struct_ops.c. */
>  extern struct bpf_struct_ops bpf_tcp_congestion_ops;
>  
> -static u32 optional_ops[] = {
> -	offsetof(struct tcp_congestion_ops, init),
> -	offsetof(struct tcp_congestion_ops, release),
> -	offsetof(struct tcp_congestion_ops, set_state),
> -	offsetof(struct tcp_congestion_ops, cwnd_event),
> -	offsetof(struct tcp_congestion_ops, in_ack_event),
> -	offsetof(struct tcp_congestion_ops, pkts_acked),
> -	offsetof(struct tcp_congestion_ops, min_tso_segs),
> -	offsetof(struct tcp_congestion_ops, sndbuf_expand),
> -	offsetof(struct tcp_congestion_ops, cong_control),
> -};
> -
>  static u32 unsupported_ops[] = {
>  	offsetof(struct tcp_congestion_ops, get_info),
>  };
> @@ -51,18 +39,6 @@ static int bpf_tcp_ca_init(struct btf *btf)
>  	return 0;
>  }
>  
> -static bool is_optional(u32 member_offset)
> -{
> -	unsigned int i;
> -
> -	for (i = 0; i < ARRAY_SIZE(optional_ops); i++) {
> -		if (member_offset == optional_ops[i])
> -			return true;
> -	}
> -
> -	return false;
> -}
> -
>  static bool is_unsupported(u32 member_offset)
>  {
>  	unsigned int i;
> @@ -268,14 +244,6 @@ static int bpf_tcp_ca_init_member(const struct btf_type *t,
>  		return 1;
>  	}
>  
> -	if (!btf_type_resolve_func_ptr(btf_vmlinux, member->type, NULL))
> -		return 0;
> -
> -	/* Ensure bpf_prog is provided for compulsory func ptr */
> -	prog_fd = (int)(*(unsigned long *)(udata + moff));
> -	if (!prog_fd && !is_optional(moff) && !is_unsupported(moff))
!is_unsupported() is still needed.

and remove 'int prog_fd' as reported by the test bot.

Test is still needed.  You can copy the simpler "bpf_dctcp"
to another tcp_congestion_ops.  Write+read the sk_packing
and also use .cong_control instead of .cong_avoid.  I think rs->acked_sacked
is the 'delivered' and the 'ack' is not used.
