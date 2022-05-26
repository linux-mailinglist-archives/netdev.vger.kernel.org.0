Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5053053480B
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 03:23:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245030AbiEZBXz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 21:23:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241151AbiEZBXy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 21:23:54 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A51266EC4F;
        Wed, 25 May 2022 18:23:50 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24PGth3w009996;
        Wed, 25 May 2022 18:23:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=mKnSbkrUXUqz6mb4KbR9teftMfynHY07kRXWnTxTCP8=;
 b=AiDzez+43zq3ojbIUD8oBB4LSrPpiEBW5TvulZ6DpkLPg1qUyQFZQYJbYt5tl/1786YY
 uLKd9j2tRO2HUDf6IGjw52sX2Vc3qjwtRNPLdERzjZDxMVR9rTngoyHPz+jRlvEx4Ru2
 Umc0N/rrq/vkUS+AcxUTz/jHoGceP581wDU= 
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2049.outbound.protection.outlook.com [104.47.51.49])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g93upj4ac-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 May 2022 18:23:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nxzxqM35QWV7g71MPcqjTnzzhOv30PvVTXuhbOY9SAOP1SD0UJPQHJQhJ/A8YqpCfBprWspkEbcSdFc+l5aYIySkP1BxzbRQkI20Nb+xUYFBMtmRHpQW/5o1v8NH2K1OeupQDzh9VtodIWj61t1T5iuT8yW0Y3qOkAncuvOzjs/ty5+sFSr3fAtEoBFBpSKQPuxLLmdKuXU4xP7rjXecGrSAs2bCzYqxl30kUMNNA2wWZcjpbppUFrnraL2fIe8derF20RoiCUg3XtrQ8jcdaxM5NVTyZ6yhiRQe0KG75u/hxGRJ2frsOnzKqurjce2NSTUT5ARkkNygq5x2BF6geQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mKnSbkrUXUqz6mb4KbR9teftMfynHY07kRXWnTxTCP8=;
 b=dcf7jlzbJaBgx9BWO4v5lB/cJKaiXJnpMpmsoGxCD1TM1WXTfkXE4ORIKO5e1wUq0Gz9118AJiRy2/9BD/e3ixKn7DJEgYoHvimpQRj1pEdj4O2KRV4ghHe2oWJiHBnRUHt+OnytLRA2SCX5Oo723R0hYpiQ8viBX3x+dru5pg3sn6RRdOLx6AJZaPc2u6Z+IqtZI/jDsvUAof8LPUVV7ReMFxDiz15okTWuCfaeyMecg48hmPAnwnIETdxq5qYq2+Kxu3OO6RK1zVsVsSYy5liLdO/jrsqatVtetUaeNFlYFKRwN8xy4qP0opHnvewXTlyfV9Xsatr/5jwVs65oag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by BY3PR15MB4868.namprd15.prod.outlook.com (2603:10b6:a03:3c3::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.13; Thu, 26 May
 2022 01:23:32 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::44a1:2ac9:9ebd:a419]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::44a1:2ac9:9ebd:a419%6]) with mapi id 15.20.5293.013; Thu, 26 May 2022
 01:23:32 +0000
Date:   Wed, 25 May 2022 18:23:30 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     sdf@google.com
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Subject: Re: [PATCH bpf-next v7 05/11] bpf: implement BPF_PROG_QUERY for
 BPF_LSM_CGROUP
Message-ID: <20220526012330.dnicj2mrdlr4o6oo@kafai-mbp>
References: <CAKH8qBuCZVNPZaCRWrTiv7deDCyOkofT_ypvAiuE=OMz=TUuJw@mail.gmail.com>
 <20220524175035.i2ltl7gcrp2sng5r@kafai-mbp>
 <CAEf4BzYEXKQ-J8EQtTiYci1wdrRG7SPpuGhejJFY0cc5QQovEQ@mail.gmail.com>
 <CAKH8qBuRvnVoY-KEa6ofTjc2Jh2HUZYb1U2USSxgT=ozk0_JUA@mail.gmail.com>
 <CAEf4BzYdH9aayLvKAVTAeQ2XSLZPDX9N+fbP+yZnagcKd7ytNA@mail.gmail.com>
 <CAKH8qBvQHFcSQQiig6YGRdnjTHnu0T7-q-mPNjRb_nbY49N-Xw@mail.gmail.com>
 <CAKH8qBsjUgzEFQEzN9dwD4EQdJyno4TW2vDDp-cSejs1gFS4Ww@mail.gmail.com>
 <20220525203935.xkjeb7qkfltjsfqc@kafai-mbp>
 <Yo6e4sNHnnazM+Cx@google.com>
 <20220526000332.soaacn3n7bic3fq5@kafai-mbp>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220526000332.soaacn3n7bic3fq5@kafai-mbp>
X-ClientProxiedBy: SJ0PR03CA0388.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::33) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0ca13cc2-919b-4734-c9ad-08da3eb658e4
X-MS-TrafficTypeDiagnostic: BY3PR15MB4868:EE_
X-Microsoft-Antispam-PRVS: <BY3PR15MB486896AC28B9CC59A89B515DD5D99@BY3PR15MB4868.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q/IsP/HKIQjndgohkSCK2brS6nSDQ8rm8SX+xTCsfsNWSJ27SFYujV6TJlfWncZuHkufKiHIjMPJPXw/dayxYbW9dtiv3SaKGtq9pJJIHdZQpVFbN6g8Ojqf6NpJ8YSwjwLzWYwcUhdkEGBRef878EjUJWpkfHYpHVXyYyFz3uJCySDWLJNFO1vVKgZAl0p4IRPOiQVX5k+DAfxPNTQYfd7BYCRnBySJUfeunX0TfbjYJsZtVc9Y3DGkbmWIjCTxUSX6loqASeGL7i0mKvg4lWyHuwIhMz2lCs8KWVRkkMmJMAr9RivZeEB7MSpl589128hWXy/9sNrqjiacoeWqEe843csDlLhPtmEHx8f8lYmoLCNWRgmJ+zX5PWdjL0f1uNZf0ik7KvyvbGVXRRrcjhMPpaRSs+HXkjkwmeC02mLSHmOwGOWGSJHx/TY93efd/+pJC/OlFK4kFfEUnXBP/EHmpD/kL7+etaz9LAKTcN/TFQwCHyYP7hCPwBMA8vXQU0IxW71zJM7Z7HWUxbu9rIJUocfJVGbrqOBO5R0reqPyohrCoAsgS4cJ5UiYa2xKtndRvyYFdhl9Jq5/UOb8djm88jbsopp4rUbWYVBeu86empRW3TxE8LNaEZ0SjpIH7qxKCspa4/+W6kIfLU87jg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(186003)(508600001)(66476007)(66946007)(66556008)(316002)(4744005)(4326008)(8676002)(38100700002)(52116002)(6506007)(5660300002)(1076003)(86362001)(33716001)(54906003)(6916009)(6486002)(2906002)(8936002)(9686003)(6512007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lsVoXzjhin7aOHRP0JfVriSFYsNgUfTywUSYcqvQmaAEj+luarh4ke20067K?=
 =?us-ascii?Q?IeMgEHtcehsrsYxZb8U9zpkfGP2Yj2TCgxpTFdivIGGtEh1dfMQVyGNwuEwV?=
 =?us-ascii?Q?XFQgYaYn4hVahc2FpkYDm/DXCOKt1qLI+3lEInYJiU6KfYNJ+7zIIlEnsW3p?=
 =?us-ascii?Q?pzKrur1e1h00Y0+HDtDpKnleDmWg6s3KuG356lsx5lJaSrKBC9cLDig2o8rg?=
 =?us-ascii?Q?lUVZEWoc04i5ssxdMFcwzDek3ZSTyX+C3EesIMXYL4aBby68lpLB/KX6wmQk?=
 =?us-ascii?Q?n6IiSyrRfsZ4pYpgXt8SrSaiLg9pK/D3LXsZRwMveAIkd6R8r8j8w+pOvhVo?=
 =?us-ascii?Q?fU0ScHNPxb1WGLdpfFOYbaD5vzj2AnHhyqJ3O2BQrHM5nSxRjWeNRpTHrmWv?=
 =?us-ascii?Q?pQ8Nd38zKtYTG4dLc0QfG8apj5RWs5V1K+a2uuojbvWEW3aiDEqetXlodfLO?=
 =?us-ascii?Q?t+WdQgaqFnofttwVi/MWG3vUtU2MH2nSEmwMIxWVEKfb+Etrfb97S/6iCkcK?=
 =?us-ascii?Q?UG2/PpRqZiNjTA10WaUPNYuUC9FP0jJNHAfv6itpbGmzifSgJNragMtHhOjn?=
 =?us-ascii?Q?K80N8SaoGWoy0g0xi9uOevzDgRXSaW/qoNxrJrx3OGealwVu8z5UqKddHqRq?=
 =?us-ascii?Q?lpUojhIw7gRGUeU8byblDHspG5a/1PkcvaqdkxiTxncE8/a6OmtrLXVGfrcY?=
 =?us-ascii?Q?3+lK1am58ioR7SblKCxvsuKZvcKuqr2HnEDs2CCt9d622vU1PPr46QNjS6Ls?=
 =?us-ascii?Q?NXLe95n7M41DkaKCt08wdnbQysjt5DCaMCFYHczZsKfjV59V/R8MVpUFKzPc?=
 =?us-ascii?Q?oZ5UzqXs2FCD2Iv2n6JpatD0keMioBJ3g9avg6CW/1xE3+aZJY+l/TGoAe+a?=
 =?us-ascii?Q?1ACkDYq0g4Kzv2uyDNXtKCmSb2SIGeBrQXUdYykkSHtslnv+P9dYrU4VQV6H?=
 =?us-ascii?Q?3i/gqkIy2ns1tu6w9r3jz/0aTgJR+2UhhH7zK30Rn+ApcXSjid9EZPSE3SVG?=
 =?us-ascii?Q?pAW6oJZaPyoiC+6a1wPTNL+eGbfoGUBcxeqlKOoUwgWYswbcGDLab/n8QEWN?=
 =?us-ascii?Q?8zdBM/pySCuN4c3BXc143iiO/0N44zJutvEAPUwG+soeF41TXr3Zhz/Eq2zP?=
 =?us-ascii?Q?0bmJC00z8QQwCUQJuv5xNUVN4sRsY/oxGTupud7JwawjzXX7m7PZVhulqTWQ?=
 =?us-ascii?Q?IDaL8i/i/Kieg1yK685dxvXPaZeHDtWj+s1o3J6cXPFSJBh25mvvL81AbGSW?=
 =?us-ascii?Q?0oQTjP+CrWTobGq+JWGEBNEoiu3JCOdHc91wrwWL4EzsFN3N/1pMW4XQkBBC?=
 =?us-ascii?Q?kewxbkPooXxc9FL9L3+hekoDqfFu3jhZL8AhY19QwgCjep1R3U7355t8jLnH?=
 =?us-ascii?Q?s/g4I1HQyFsTxa5VbC3POfxubyHl19Ey+32sOQU1ICRIqA4d2xhh1F2Xu8e2?=
 =?us-ascii?Q?AVr0DE0bJc2Kwtqqqdl0N0Cu2K8Yb/MfOpekrjagpBPfEpTbpi3QH01tcPYC?=
 =?us-ascii?Q?HadOyRr6XN8sp7K+lD7d5uzJnLvsZegWDZVWXpFoSxueEdWfKkc3HA8fuGad?=
 =?us-ascii?Q?a25pEX7f99bJRLhH3tX78Ahcy1bPKKrsmheNqRv6RqrkSt3h32K1P1wedZm4?=
 =?us-ascii?Q?gtCDSzF7kNI76v5iOScADMW1M22bgpDxrdDWkVvjCGZ273dPaDCaQbGPZ9Sp?=
 =?us-ascii?Q?9phpPz/FjYxOjHZoHaQFPtslZo1uX0U/TuIQRwblfJbD3tC2zOFlQTFXjPuu?=
 =?us-ascii?Q?3HT4kPR+hKGSHld9O1/NSGrzHx0uyKg=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ca13cc2-919b-4734-c9ad-08da3eb658e4
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2022 01:23:32.4267
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ev/YOXdBbvoWO6/vy5rcFoSLaH1lJsX55RMZFwrVf19R0IAClKasYZje55V/nxQl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR15MB4868
X-Proofpoint-GUID: BjOlFhuAlD7i3TAmm4TsXMDKndXS8Ust
X-Proofpoint-ORIG-GUID: BjOlFhuAlD7i3TAmm4TsXMDKndXS8Ust
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-25_07,2022-05-25_02,2022-02-23_01
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 25, 2022 at 05:03:40PM -0700, Martin KaFai Lau wrote:
> > But the problem with going link-only is that I'd have to teach bpftool
> > to use links for BPF_LSM_CGROUP and it brings a bunch of problems:
> > * I'd have to pin those links somewhere to make them stick around
> > * Those pin paths essentially become an API now because "detach" now
> >   depends on them?
> > * (right now it automatically works with the legacy apis without any
> > changes)
> It is already the current API for all links (tracing, cgroup...).  It goes
> away (detach) with the process unless it is pinned.  but yeah, it will
> be a new exception in the "bpftool cgroup" subcommand only for
> BPF_LSM_CGROUP.
> 
> If it is an issue with your use case, may be going back to v6 that extends
> the query bpf_attr with attach_btf_id and support both attach API ?
[ hit sent too early... ]
or extending the bpf_prog_info as you also mentioned in the earlier reply.
It seems all have their ups and downs.
