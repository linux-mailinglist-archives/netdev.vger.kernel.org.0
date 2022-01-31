Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAABC4A4FF7
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 21:15:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378330AbiAaUPi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 15:15:38 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:49954 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1378373AbiAaUPh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 15:15:37 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20VJxNeq015676;
        Mon, 31 Jan 2022 12:15:01 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=gXemu6upQDRpgbDP7KcQFyoE7sAHf/w0L2bY55QOQTY=;
 b=IyYGJOiVQCOn08Dz3G6q+IjXlNJwuPEuF8VDhJXn3GmUDfZiYPT+gHQfGSd5YbaiTZDn
 2arZaWslk3BxEy8hfvdMwQFF+9TiaNYtFJh+zI1snSPO+cnLpo+myWgQ7VGpYiKvewfu
 DccX452Ke4srYtRRC5EvLQ06nSUzmlShn3U= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3dxjtrssgx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 31 Jan 2022 12:15:01 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 31 Jan 2022 12:14:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dcwPMlc/ETJIR4/N1SDITKTAwVGdaBgYDKA7gudxYl8gvZerWu7/FefQj4PQ3iOYKR9wsYxtc/RCWPv9XpD5DJT3yt3rTx55LlFckj4dHHQa9j0EYzORnGTz+lELbkH1SpLAtdsJ391d9fWBnubkYeCCM8avQj/ANlV0+YDYIYgcOa9qdlYuOYN9iS6oi7B6miHBpFABDoaMdRtJBDPHpfqpaTq2I3efVnbAoPEq+zX/9973XZqigXVLBJ9n2OT1JAgmrUnd8BxLxKAOX7NnMpcqnqU2pHptdxgUH0q4XIarVxbmyFd5aijerUq8Sw3xvxbsvfz5R3UdhlfmKIveFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gXemu6upQDRpgbDP7KcQFyoE7sAHf/w0L2bY55QOQTY=;
 b=cRkmuvy+dQBUqVmcKCiTqMQFSjGTrxQ8bM0DFzsova+uNGNmMbROFp5DXSM/rdg3T3QBYuzdtkrWzFGsnQLnVtZr9mj36r7osGaEEawlfl/JBdvutlF2D2Sun1BumBzqPO0UT69NUffsypegHD4TBibygybeGQOLw/hGNZeLVCmXDzHHjB9CAyTXbAh/0gq0ymLu6LIcUw2MvrnBj5zQmts5bc3fhTzkyXJS735k7c02ZN0g5SA1YvwLzsHkQ5JHWHEMJ0hbmDURZqucD3gdo/hmPvoXwBahe13QfDiAJ1QkKE1oWvOSxGmK5We/RSz0NAZSYu+Uf7VLiCDX5ARXsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by BL0PR1501MB1971.namprd15.prod.outlook.com (2603:10b6:207:32::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.22; Mon, 31 Jan
 2022 20:14:58 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::b0ca:a63e:fb69:6437]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::b0ca:a63e:fb69:6437%6]) with mapi id 15.20.4930.021; Mon, 31 Jan 2022
 20:14:58 +0000
Date:   Mon, 31 Jan 2022 12:14:55 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Menglong Dong <imagedong@tencent.com>
Subject: Re: [PATCH bpf-next v2 0/2] Split bpf_sock dst_port field
Message-ID: <20220131201455.v3hrrovmskjnwma6@kafai-mbp.dhcp.thefacebook.com>
References: <20220130115518.213259-1-jakub@cloudflare.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220130115518.213259-1-jakub@cloudflare.com>
X-ClientProxiedBy: MWHPR12CA0046.namprd12.prod.outlook.com
 (2603:10b6:301:2::32) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0fe800c6-ccf3-405a-84e6-08d9e4f65a9f
X-MS-TrafficTypeDiagnostic: BL0PR1501MB1971:EE_
X-Microsoft-Antispam-PRVS: <BL0PR1501MB19715B912B9067EC44D3F092D5259@BL0PR1501MB1971.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TV+nYb8Z9GHMAuXkSup/FZ5CppRyc0K7h1XyiczP6yZrbVb7n2gKLT4edF96q+d3DClYhjEGZ13EFHHdjshCBVC9bULNNgUf1zKY4k+W1gUpNgLgNMAEf609DOUAP6omSthL9CmcY+aJDOB9GYIS4V94G34fDULPjRgziyoLi/qRCiGKZZgoJVxLSzqMGX0dsC7hJrCO933CfF3Cu9O4e64hY+44RDR54U74kKLOiHxDSTaosVGJbOSzg/ndUTupjBRQ6D8gy1xu9iqH6GLBeXqYmrdhheqXPgs+M40uBrr/l6fcl83xZb+a1QJ9CekyEzUgKFR+yYwkoW9tnDx3ojEN6B5jaPvn8ke3ALIfv7D8VDyMTUGYsn0KqBCCHESRjxEp5TzI9LYoW2HYqh+28IPJ/qwHZ7g2U1H5N8l6Fw41C4WgBOCYvfJ+v5j4WaiMyFApvw69HYOSvOKqnMGmFTwb72UgSTa9L/m84gvxj2Ejo6QpT2cITRMiSdR3trFvMxggMK95nI1Iv5KnCi62jA7WCyaWcMtDKdZrcQiOiJgr5/CQXkJBCsKfpHKamv+FCgmgNXPIAakhotVA+8jovB5GdtHe6JqWAx9k1P+QAqh81JgVsH2+CVFT1MmTg1YS
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(66946007)(86362001)(8936002)(316002)(6916009)(66476007)(66556008)(4326008)(8676002)(54906003)(5660300002)(6486002)(558084003)(508600001)(186003)(1076003)(52116002)(2906002)(9686003)(6512007)(6506007)(6666004)(20210929001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?puSgGWbC8SYtcL+W6b0kdAFnF6ulpct7VNr8qGwg+4CmxQQKsZ+EVOxUkuvP?=
 =?us-ascii?Q?ebdatS5Kx0XnBBLoQX6WjmuK91GzwZ6TjW0MdNdwbepRLQt8TZEq6VbQRoJc?=
 =?us-ascii?Q?DY1TnMs5K4UMFrRM2WP8rDISvW9Gfm6vSWGIlMsPosYdsEzQObRZR6jvyLfN?=
 =?us-ascii?Q?qCYc51zIshFWUDEPlF6z6d9mI2obb+0bD8au4DBOBqueS3//XAgql+GjAepJ?=
 =?us-ascii?Q?gEEF411gUvuGetczJdNgaZZA35RvPScC8nv13vDUje0tTALnBTo9oVt4O+mc?=
 =?us-ascii?Q?Tp1gDC7LyZPgJuC1sSp4EySuihBNf2Lud6q6QabXZnvzux0dqMcb5OSLLGyP?=
 =?us-ascii?Q?xbBC5D+ZvE6eobIAeD+xedcduuBUxErcZ2rghLVLWVmf3Q8t4PiytBeIaw4l?=
 =?us-ascii?Q?59O4uGS/9w6JRM8g5HgnSYett17G4ZZgfWDU3awjM7hqwmLzb1zhmBIEHoYY?=
 =?us-ascii?Q?8BYUFAvZSu8sY7mWudBtrnVyfgYMdkwBrYIplaR7dZZhFRLsUMIZ/5H6i19x?=
 =?us-ascii?Q?r63d4Ifbix0IC9a6roDXmCaYHgVCI5I2bWYgPwTZCjxxC2ieQA4FDVLwdjBN?=
 =?us-ascii?Q?hMleW/WWJ1dKIU9NQl2uPmznE9/KbVU4Z1hUd/Oz5ECNSBEAg2lGGNP/qNYF?=
 =?us-ascii?Q?prLMWRLSBt95B37WcOGSLKOFfZat3S/p6vw2zOpiv/mSdgm1tobk/q2xNaeJ?=
 =?us-ascii?Q?3Cc/dZ0sj+5vU4TEbCro1pV4Ap1OKFLagCH8P2kJJGdfR7zTwe5UAgwKtNvi?=
 =?us-ascii?Q?Zf0fvpPT4AX0I63SCByN4732MUUBLhc5bfGFIHay+Gxc4Mac/n/b0oFAhYZH?=
 =?us-ascii?Q?iz6zKI2SR84JwLE/A0HoXD09thJKIDz9C0QNvxpTyOuenSZj3zXROPlPpMmd?=
 =?us-ascii?Q?/c15o4/sNvatgovqNBTxUiJLrrTV4NaBhJYyJ57mi1TNfSib4iJP1tC0Gmbs?=
 =?us-ascii?Q?gNtO/APogX2Uvt/n4NcpsCiUWNXcL6xmdZvtlQG9w2GrshJFzEp/3/5DlATV?=
 =?us-ascii?Q?cGhfUa3BbvyLyQeocN4r/vOV1ba4j5rSMdQRzVEjd6JN4X0Lq5v5+4uKPHXC?=
 =?us-ascii?Q?LxJ0eWHpIgsII2tiQPZJTAvTW2qh4AZxDksz+DnX1BAvS/bE2HHtKo9XTkYX?=
 =?us-ascii?Q?dsVFqZls8dtAmbvVCk7+2GIcIsPevHHgdza7wCpqCw/uJw17ffj02BeLehnw?=
 =?us-ascii?Q?OGCsBHMTp+0SJWTw3MEKzuBG0wVVWYTmy2bvblb0UTVs3+eKp0k1BYDKhzt1?=
 =?us-ascii?Q?T2ubxSboDOu131KVIr7GycLApKnlf6LazJGb3YjYrNFaENRhtnYomwIKgSWM?=
 =?us-ascii?Q?CHuURdl8tZt1djiCp9QKnO6P6ZnLm7VQAQ7xjnJ14pCBWaYOPhaf/EXCMUIc?=
 =?us-ascii?Q?yUQtIug15pVluDuR9K8xM69P8cUrfbjK8Jd02Ac0Za5anv465jj9ggqkrTC9?=
 =?us-ascii?Q?w3nSGYIbHB1TxJBVXiTuy+QS0uYCTujPaZDj89N6thocFdkiF10w7r71PgBm?=
 =?us-ascii?Q?CK4hw6XlTxsgYCV2vzMT+ORKdAcm6PtvUX0z/sWLvKI8ilina3EzbhyU4jDM?=
 =?us-ascii?Q?KD+loh3LyzwelE0QDMeptNIgu5Op5Nw21MRFsHqj?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0fe800c6-ccf3-405a-84e6-08d9e4f65a9f
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2022 20:14:58.5643
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1cwroG4bczUX8kDIGxqvKc+WaqRObsjAxXUa8xZonqjDp40AUKbxSON5kAfua2oU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR1501MB1971
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: cqZKdxCYtHBciqbb9voN7g0x5D_DH3zI
X-Proofpoint-ORIG-GUID: cqZKdxCYtHBciqbb9voN7g0x5D_DH3zI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-31_07,2022-01-31_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 clxscore=1015
 priorityscore=1501 adultscore=0 suspectscore=0 mlxlogscore=546 spamscore=0
 lowpriorityscore=0 mlxscore=0 phishscore=0 malwarescore=0 impostorscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201310129
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 30, 2022 at 12:55:16PM +0100, Jakub Sitnicki wrote:
> This is a follow-up to discussion around the idea of making dst_port in struct
> bpf_sock a 16-bit field that happened in [1].
> 
> v2:
> - use an anonymous field for zero padding (Alexei)
Acked-by: Martin KaFai Lau <kafai@fb.com>
