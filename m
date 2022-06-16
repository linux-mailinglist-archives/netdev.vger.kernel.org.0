Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 990B954EA65
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 21:54:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229898AbiFPTxy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 15:53:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378299AbiFPTxx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 15:53:53 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62FAE546B0;
        Thu, 16 Jun 2022 12:53:44 -0700 (PDT)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25GIemq2031683;
        Thu, 16 Jun 2022 12:53:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=Bca4tw3u/RDW7qa6RxN1S8T82AHBip+/tZvFAqs+JTw=;
 b=bvjE128sr05gFTx+gcnljK0h07OzkOPVmhUm3eRjyrkI5IXjieYOtx1x3BIX1PwmdaoN
 tgQVe5gnzICSg9ZsCBeghlYsexcYtAB3wLhMJK5CapCOGVaA5Ry5/O8GHZwAvIOUIYRe
 JeQV3HJttOYdcLWoKz5UrbqvtP0OjOi/p9I= 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gr4xmjw5y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Jun 2022 12:53:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BTppAFSEYvjtnAK0WCyfTA9Izs+szA4/Nz2afo0hvuADklvc6W2OnuyrHrY9Y1EqR21QWWa0OWM6ct+0Aue4isQuPsyO/EANiW20bf+iANSgge0Epm1O5oeKqV0sLUuhsuylwFL19/YAvtk2zKV1OmYVSp2v5bAprYj3eS0hGoya03EoFybuUnNeU1bLNA66INznrF5fpmOMwbhPKX+a1mBQu90UVc4V1zmFA0olnz3jOOhyuGOSD53jOaAF6IrXubaxT3FVa5H4s/BH+fRQgDtBMJU6p+j42nc83f+jPd4af9C4U7eKllUdZfTWVq06Ec+oOMt3epJ4mChO/GsPLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bca4tw3u/RDW7qa6RxN1S8T82AHBip+/tZvFAqs+JTw=;
 b=cWXvDA10V8lfwpqPCML0c8nKHLR8eYSNUICs8Gh1Oa6PUuOhiIE46HJxM+k95XKTfgmA5PDXReCP428ZKfX1WFndAA2YOe2NiioAO006jTeNlxcUIOQnTz16Tp238XCjXXHIq2zS7EhFpJUsKjRFkb888V1M1fI21Q+9RRDBgR8FuOPgofX/bFcZeYH+ZTp8myVpGdtZEn7IPxElzUbMu26mS4ilIprc3kSdTA/dOB55FRnjPPQXXdZzS2DsXMUVLXaIeEuTmRbhtFrVEFQC3+lFD0+wsmOY+zu+pJJSGTjrpw/FxHmh2fgeJ0fyjehJ8rfTWRUwokZoVbRoFq6OQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4475.namprd15.prod.outlook.com (2603:10b6:303:104::16)
 by DM5PR15MB1721.namprd15.prod.outlook.com (2603:10b6:4:59::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.15; Thu, 16 Jun
 2022 19:53:26 +0000
Received: from MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::3941:25c6:c1cd:5762]) by MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::3941:25c6:c1cd:5762%7]) with mapi id 15.20.5353.015; Thu, 16 Jun 2022
 19:53:26 +0000
Date:   Thu, 16 Jun 2022 12:53:24 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org
Subject: Re: [PATCH bpf-next v9 01/10] bpf: add bpf_func_t and trampoline
 helpers
Message-ID: <20220616195324.idodbt43ubqkzeww@kafai-mbp>
References: <20220610165803.2860154-1-sdf@google.com>
 <20220610165803.2860154-2-sdf@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220610165803.2860154-2-sdf@google.com>
X-ClientProxiedBy: BYAPR07CA0055.namprd07.prod.outlook.com
 (2603:10b6:a03:60::32) To MW4PR15MB4475.namprd15.prod.outlook.com
 (2603:10b6:303:104::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4cfc18eb-d795-4325-7943-08da4fd1e06b
X-MS-TrafficTypeDiagnostic: DM5PR15MB1721:EE_
X-Microsoft-Antispam-PRVS: <DM5PR15MB1721058A18ED97724EDF4CACD5AC9@DM5PR15MB1721.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JURZ3sZAZmVTeIlB/8Pitblwi2S3PWDinoJ1Id2KEna3O4404kGmHH7Gj+Jq/B8SEUYwU1be71UjmtCdZv3DeqmzBMbNIFQ97xMeZ7lqY1bjkiek6/V7axsezcg36FV0I6OtQshPdhUuiAFe1NkXKOv2mo752xeHWoAkOME4mdelHL16a8ClmsRk25vYLuyCUxbxemSnZ3oPfYWESkAVK+zVRZOuRR/DuKp3qwzw2xyh3hdnwZPIAJp3+BJGK6Tp3Cd3tgA8024NNOfT9vNNbHmNCdoDLJEIYI+TyH7AiZln14gHW2XUZsTIK/RoDaClWwacFuf0uNNRyTMs+UJA23dLSNFObLbZ64rfZn3h66mSfumZtABZ/VXCWZbt02T8uT7mQ9lCGEeq5C45sRec8WPoxeSVAKq9iYJjFblW/Z+YQViCNQ3hOSBDNuRhShQUoQF9mKKXp/dr05lhMZtd+zvOwOP9V8tdHRu1dVdmwc5reGdv2joiG45hfwfsppg3i/2jHIrR6DahmiCNUStz7P47slEKiBwb+kNrtqfw4ZPfq80cCvOGFBoYkZWdh/COP8h8D6qKGSGptCbl2F5A3mbnRiNcANkPDFibBIY7shAxXZdRIrsOmeZDRlSV38eIvyU81/Vm513uKHuOUPdy6Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4475.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(366004)(8936002)(38100700002)(33716001)(6486002)(498600001)(5660300002)(4326008)(8676002)(66946007)(66556008)(66476007)(9686003)(6506007)(6916009)(86362001)(52116002)(316002)(6512007)(186003)(1076003)(2906002)(558084003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Xx/vjsHAYX1BXmp5r2rTZBEXL6sHE7ihpkALHqPM4Kp8GK6IHVNVeBVOTbLS?=
 =?us-ascii?Q?15zMUnb95Dq554pWXGk1IKPBdUG87IVYRoWw8GvglZ40BH7BB3gCoEy9csrv?=
 =?us-ascii?Q?yI6h8poMfGNYf2ibYmMX5e6mkIkTkne8J3cqp7mb3cJOBKB6TL/s1csy/bg2?=
 =?us-ascii?Q?pwYn+Nb49g0qKZPoqK4BBnAxAswS+ShG2YYrGh2QsTudkm49y+l3fumAHHT2?=
 =?us-ascii?Q?Pf73gvvqkzOWjUPMHDd3NeIeptemHIrfKXVDv1JQvx0uEw6m3llH6DSCIshn?=
 =?us-ascii?Q?VYbBMdDbMfZtHnpcjxS1vxJvlfqqmL2fY+lnErmukg5Z0tmvwsoJMx21iUsn?=
 =?us-ascii?Q?p4VWGNqSuPvIkgbneDYgXEVqg6woC8LFcvAA1N/ad4wmQxgeNuby1QsN7GVF?=
 =?us-ascii?Q?s17FKsd86atIBnY1x4IU4/Sbx+22CPW+HIX1WCqTkGDE6BGtofpXfuN4WIh0?=
 =?us-ascii?Q?R8Ai+KzBHSImvzYVkwucx6+f0LQ/cTg477/oLd+5jD48oe3TLU8tIrnhTvdy?=
 =?us-ascii?Q?fvCpgXrPoOrsaNxNvqRQR1CBF7WBgFoloI3rwo1rTK2dY4naSe2kiso34nmP?=
 =?us-ascii?Q?Q98//5vuVkXWcDUoOye6LYU8L5kn1IE8dH16FKDTBpANUaagfGzrI7H8TgQY?=
 =?us-ascii?Q?HVDKxCamMEeu62YRMPkXdNuhDPLtQrMfcYriwLlPAOZ7+nhWYubksJPLnQkb?=
 =?us-ascii?Q?WeGbaixoscZTNe4w52ks66QuO59TtcnZwXEiLYxcxdGWmt0S04jJXiWxVTx8?=
 =?us-ascii?Q?cg6Ev6uCZtCP5VzO+CfKI0ikzU28gVCWTKfeZ0NukkT9TW4eeBBiuAjT+7zc?=
 =?us-ascii?Q?aRlsZ+pN1He90+EfjeiUAcOpOm+PPX8fgfRAKrED5KaBtnsyhFH3ef44VmVn?=
 =?us-ascii?Q?iRxEmuzOsjYcjKPX7mrsws4eC+JRp0BQ4hG5hyR3Zw5KM3aRAGOE5BfmM8ra?=
 =?us-ascii?Q?X/GD88r8iGq3x9+hFK8wt7Muh1z6msTw0o0fgIDcMAlfdlhLOre+OqPV7MCV?=
 =?us-ascii?Q?Uy/SDagdbPMrYaabbkIY3knBFjjjdSe3NXU9UdjPw3dpUwYhX5tV99txJo3z?=
 =?us-ascii?Q?vqo7NjWGrjaesdevMDSMJuXWDToq1XN9hcPns5EXATYftgnyQKmaOzowCyBY?=
 =?us-ascii?Q?3060VF5WiurbXB1tuJVTfkVbyy8MViy++00UWYyeOwEMf8pYT+pGLeoA5f5b?=
 =?us-ascii?Q?1VfR5kGsMvT8i7ERWGq+xC58GtlJ1qF95g9G2HwRzSsvTFQQNMX3c1+Unie5?=
 =?us-ascii?Q?iBP3tWvaZGLkSru9wQt7CCLygof7KLcT/Urzhuv0xj9n3FBBD1Wn8SFn8LiT?=
 =?us-ascii?Q?th3RuXMuhzek2Y7boFmfx5xfSaHgvpjq6GtyvQes3WnuvJGj7VPXWSiq05A8?=
 =?us-ascii?Q?pIe+XIoxBr7Dn3v36bn0E7Lp4G4irmawMfAXwLTdYzZMvChD+m0zXLWQWTI+?=
 =?us-ascii?Q?M2+L8frCqPGJOPu20hJO7VWgrM2lGqEaUNkRcxNjPJ/ljkoVgBLbZklTK3Dy?=
 =?us-ascii?Q?I43zVI5bmA2yw41yXluhnR0uZlJdc6/LThTiKfIeMYPh7r7FxK2gb13J1TwV?=
 =?us-ascii?Q?rdAzcKrCvKVkcjL5LzzXVB7Xb9BgauJRMunBx9MvrN18Ye2EvsY745+O1Krj?=
 =?us-ascii?Q?5BwMGaoXY61UEcUyEc2kSrNNvlf/gz4JWwPCXWoJUpHNk2Q9l9VA+xEaJ6Bj?=
 =?us-ascii?Q?D0JveOfub78A4JgshPtg74zbkC8fPQznPdfyb6hwzn0DFlsWqcngg4iKPlM9?=
 =?us-ascii?Q?CMT9JVDUjzmTodQ40Rj6aZP5DQF+C2Y=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cfc18eb-d795-4325-7943-08da4fd1e06b
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4475.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2022 19:53:25.9807
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4G8xEJY4r/WD/aEWS1GJzDDs2Gxw9ap3niyxXwq8cHSAhtxXR/K39GKe2N3KH7U+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1721
X-Proofpoint-GUID: 7XwO8z0dGMUAUpvuLoEcSJ-i6XsZXKzb
X-Proofpoint-ORIG-GUID: 7XwO8z0dGMUAUpvuLoEcSJ-i6XsZXKzb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-16_18,2022-06-16_01,2022-02-23_01
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 10, 2022 at 09:57:54AM -0700, Stanislav Fomichev wrote:
> I'll be adding lsm cgroup specific helpers that grab
> trampoline mutex.
> 
> No functional changes.
> 
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
Reviewed-by: Martin KaFai Lau <kafai@fb.com>
