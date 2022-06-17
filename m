Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2808B54F0D9
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 07:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380227AbiFQF61 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 01:58:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380221AbiFQF6Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 01:58:25 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56DA624F1E;
        Thu, 16 Jun 2022 22:58:24 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25H4Hu97010399;
        Thu, 16 Jun 2022 22:58:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=6TvzV46JxNfTNnV2eJTEaeuVjeBZ3+eLpJ9YQ8Ph6IY=;
 b=QkMuF2SaBPpXkZNUCreUDhgHv1UMEiau/IlVXhCoyxoB9j8qo0CJGrJuYXBAT727Nu4O
 0BzFRUv0mADVZUt7e4xQiRLqektAfNvwl3EfLkRVzrC0cF2sD+QuYS5ZG8saGLhRVToA
 /q6UwvAxVTiqlUc92kb9om1zFHaArtyfL9s= 
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2045.outbound.protection.outlook.com [104.47.56.45])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3grjet8bhq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Jun 2022 22:58:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MRsVj8d6hH8iKz+gPx9l1vuIoryygdevwzZOMlPSKjlZkKRhCWRlAX2HxF4O/oXXy5XIggX9unDyw8W7uNla2xlGhx/gsz/F7FLqOnm6DNi1mxW9iwEduqk9vOCFHTFQXrIMamGH4vLnKUf0VFwiG1GOd4K6csBkBih/MKXo4LveQNivFsCbqk458/j+EbImKWX437i0Ca8DsTQ+adC0YU0i9fEpxvMaECH8wTbOEzzLBESLctnH39DWPYvpbVy40WnjZ17X96ECJyK76MlF/D3n8U7MTUjrOh/L/7kH+x0RmWwnIoPZfDTe5admi42RfIR39EKGdL16E9uMiQquyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6TvzV46JxNfTNnV2eJTEaeuVjeBZ3+eLpJ9YQ8Ph6IY=;
 b=hLPNdlvTbTAYjjXaM2bycHGMJuTVP3ToCp2RbJTiZgBq2QuzWG3080HH246zuVlnwIjFoYsZhvbQuL0buOUQSDePe4l9t6KuL+hQNuMAI/EKcRU/1onydqJLQmIco7JkwH3AmdfuD6PEpcRC2ywOFkZetEsl52hrwiNdFbVdx2eQ0+5gUYx6KJNemVdLUiHR2c46PAhgb9OPV1SxljoQkVoLWZiCWQbSyiZh4epIfZTido7e5Y/wxdLwyY9SoQ1vs8uptZ3hkgMJG/sLiQj/bvkmpSW5Yopyk2O87ppDytV5ftg0vrPGV3wyqlKkg3a/86Q2IWiJlvDQIybejvDPNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4475.namprd15.prod.outlook.com (2603:10b6:303:104::16)
 by BYAPR15MB3078.namprd15.prod.outlook.com (2603:10b6:a03:fe::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.14; Fri, 17 Jun
 2022 05:58:07 +0000
Received: from MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::3941:25c6:c1cd:5762]) by MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::3941:25c6:c1cd:5762%7]) with mapi id 15.20.5353.015; Fri, 17 Jun 2022
 05:58:07 +0000
Date:   Thu, 16 Jun 2022 22:58:06 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org
Subject: Re: [PATCH bpf-next v9 09/10] bpftool: implement cgroup tree for
 BPF_LSM_CGROUP
Message-ID: <20220617055806.q2a74mmllxbrhknc@kafai-mbp>
References: <20220610165803.2860154-1-sdf@google.com>
 <20220610165803.2860154-10-sdf@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220610165803.2860154-10-sdf@google.com>
X-ClientProxiedBy: BYAPR21CA0024.namprd21.prod.outlook.com
 (2603:10b6:a03:114::34) To MW4PR15MB4475.namprd15.prod.outlook.com
 (2603:10b6:303:104::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6da33a40-96fa-4dd9-cc90-08da502659df
X-MS-TrafficTypeDiagnostic: BYAPR15MB3078:EE_
X-Microsoft-Antispam-PRVS: <BYAPR15MB30784EB71D32321B7D6F639ED5AF9@BYAPR15MB3078.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SZdcK/MddXEYmiAQvXzFFUpi6Xn6+ZKGXeRThqYY380n1BcpTHNhNM/uyDzzpPnMH6cKdN7p4VNJVOKw5/Xopf5lZdUXm1PFBlCQvKB+j+JKOeS7U6LBZwlpvVmEes/0fbDc3DaE5EOW7OxjcFISOPOzwAMeAY+Utdp3pjuA7/yret7Vt869CMp4zKhaLtk6cswgzw0p8UkEy+Wik/Ja5BJpy0tG4HECAT4k87lkmAreOyHzuVGvJvNgoHAE07KYLRU0GcckHiGQIHm2DbeNkWwVz6dUNdDCF3BHoJI3Qyc3v3Llod4U0DXl5gFW4WIAGkER1T2ehRPL2cecDf4rrOs/qGDqlcN90hxx0JULEcUhS59PiTRX2u53n98QHaM6FuKPbwPPOsjy5ymS1Hlbe4qnC3wuWDNOLPWEdLFZASOs7hMUSm4Q5fyKX0rRy2AoehPwunaCEkYrVLU74cPtdUQTzGnFC3DV55/I2/EsAD1uxVIN4AnHoK446oNjSqmOYwNegrfEmwdPNEG64LBk3Y8bVVK46YLsz+OGElxlSaJMDYtM14zslNDvrDxiGW+MUn5ZtQoMq7HTaFaGmI99OrG4aiMGen8MoUcOBwatoUEoraoDSPGaZNuUCmvc6Ib4RfM3T4F1t0bkydRAa/J+Kg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4475.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(366004)(6486002)(9686003)(5660300002)(508600001)(6512007)(52116002)(33716001)(6506007)(8936002)(4744005)(38100700002)(66556008)(2906002)(86362001)(186003)(1076003)(8676002)(6916009)(66476007)(4326008)(66946007)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AVD0XgNQUyQTC/t9CJug51COs8NrfheRQK6zbCL1pxuviB/lYHJChdl58Nvm?=
 =?us-ascii?Q?wrjbVINk0+m8F0L8TRtjUkMEiyS2eve/0cVAHcCTdPkSNScJLPEVRyZ4x+YJ?=
 =?us-ascii?Q?I0NPTJtGj3z7h7jMNlbsYpoXJtJgKMLDR5RQYbqi/PDNbVCCZdvrmkZgGadM?=
 =?us-ascii?Q?n62zmJfHY+0w2PpKsOId3yR2V58WEn/BHxbd44nUtnCifXSjN8qQOgSh8Kfp?=
 =?us-ascii?Q?0DPHK3ZE/LpUUXs4UaiMDYl+wvxSpGbhFo+SRPH7EOPTBfFxpbJQXfV6OA21?=
 =?us-ascii?Q?g+mtEVEk1mJ3HIpIxZTdS+ePZgbY7C58us5qPNhrDZwWh1eSxDfluUdmP8PV?=
 =?us-ascii?Q?QTutudrpBBa0evAu6cTybxXU4Bajeu5oSX9Xy77G0xsnlyaE3sw2Br8tBy9M?=
 =?us-ascii?Q?IGbnPC9W9fBkkSJPtcsMx6mA0o/U0kdy6l+L6K/4voVb2q8RfCjGQ7aLnEyJ?=
 =?us-ascii?Q?cS8teFokCaUBMnv4fpN8AzuK+k694MsHqjbeXbT7wPdzNlAtRGzT/yQw2pS6?=
 =?us-ascii?Q?bISxscx6mab0ai21BidAYNfE+Wp7wKcDGfHGic/szHsO69j9omgMLEn6F1M6?=
 =?us-ascii?Q?Lfno03Y/PZ38ZknzZGCWw7s1xR6q9cv7DCeJNP49lISX1Nil0PwJ87ULxrky?=
 =?us-ascii?Q?aHhgKjac+Y+Te3dgQECOgMyJahicBLdLb8hMoe/LdGLCPAY35q1jhPL80vpS?=
 =?us-ascii?Q?cD3UA06nY6gtLKpt6Kf9lZoAWI7uyF8Gk8AM0xM9CPAKsjVA4s4FgquRBcJA?=
 =?us-ascii?Q?adL1VeYE2AxDDpHoWF5sYl5YMfLGolKq9UWw2+PiBYMUkSk2VEUoqRCFw2TP?=
 =?us-ascii?Q?iurHH229BPmmXLb2iMnRf7/R07FivB6xIYb1HQt7v2lYW+IMT3u2pYntrLej?=
 =?us-ascii?Q?/uVeHEeVb280ClKrTk40/K2cbQy6BGLAsm5YqxSt44E1Nz0hw3c72tR7fd1C?=
 =?us-ascii?Q?v0fHWLtT94V9PaWpXfzs5cBkmFsy5H4xYo0KJw+fDKOolrsoD+fmrie81j4c?=
 =?us-ascii?Q?xlOBTsJTkZQS4/G4Ku7QK5Yya0ro+u3nj+BGku9dUwr5yTh8AswylGEWPdIM?=
 =?us-ascii?Q?erJhunLPunvxs98DxVfBgvz/y2PqdzcoKVSbv0XyybFBKXuAUy8tpdi7xUah?=
 =?us-ascii?Q?EmKguP2X9NC7WVkARyEpTf/SDwUUypNqvC6i/rxEssXRA4r/zsSgES5qkPZN?=
 =?us-ascii?Q?xQ8RI5xxMPlySk9sLGDJjuMpOVqs3Gr3mH3JWOtKK9u/50ZWPODN+TvRObRd?=
 =?us-ascii?Q?RZnjcitToaK+uNjelR+FFYst/oz7bE8vv4jBq0zFwfuaqGwLjedz1exuLW5Q?=
 =?us-ascii?Q?mYPDSHr2j6VIbxUNspxRFXSXaR/RHKgct4hM9tRSzphCkymBOifC2uk66cEw?=
 =?us-ascii?Q?h1+O70sT02SAj0pgzC3apJ74RUydc52YRaMszZ4HrdXVFm8kFhsMsPXxaZIg?=
 =?us-ascii?Q?hQLtMv8I/WFOYIEles4U7zHAGjQNobWbR1WhIT9Jm2v8jQ0ETQPeSN8kHRmd?=
 =?us-ascii?Q?aBDV5kJyJz5wrLCdJh1C4AYOF+IxIWF8qdbfqOyqmdc6qAG/MrB4yOd4sixl?=
 =?us-ascii?Q?BpQV3KKzq1y50LlUx/oDTXWKvtQebdlud93Chw/QFjPlXtSdVd36M6x45yR/?=
 =?us-ascii?Q?Y4Xhptw0YBAvu2nGtGZpoxHZKvqNHvbMde9zWo9MP/i83XP5yFHMI+BnHw1u?=
 =?us-ascii?Q?+aGmIR87HtGZddhtZYyL8Kv7YC5x5HMkD/U6Di11quexM+4ylk3eaAelSwBf?=
 =?us-ascii?Q?oK8YH1AnTNEzUA27hxXZawJh9LWGgIw=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6da33a40-96fa-4dd9-cc90-08da502659df
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4475.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2022 05:58:07.4258
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bmB9XTrWRG9VqO1Iz5vLYGuUBI3AziuDrlyNRTq6SQvASim9wBT/nYe/XQyVSfaU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3078
X-Proofpoint-GUID: iV1AdjX8boUMbPG4plAYQI8Jj7CfZTdZ
X-Proofpoint-ORIG-GUID: iV1AdjX8boUMbPG4plAYQI8Jj7CfZTdZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-17_04,2022-06-16_01,2022-02-23_01
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 10, 2022 at 09:58:02AM -0700, Stanislav Fomichev wrote:
> @@ -84,6 +87,19 @@ static int show_bpf_prog(int id, enum bpf_attach_type attach_type,
>  	}
>  
>  	attach_type_str = libbpf_bpf_attach_type_str(attach_type);
> +
> +	if (btf_vmlinux &&
> +	    info.attach_btf_id < btf__type_cnt(btf_vmlinux)) {
> +		/* Note, we ignore info.attach_btf_obj_id for now. There
> +		 * is no good way to resolve btf_id to vmlinux
> +		 * or module btf.
> +		 */
On usage could be using it to get the btf_info by bpf_obj_get_info_by_fd.
Check for the kernel_btf == true and name is "vmlinux".
To be future proof, it can print <unknown> func for anything
other than "vmlinux" btf.
