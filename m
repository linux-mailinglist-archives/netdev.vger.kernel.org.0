Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91CC9583431
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 22:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233995AbiG0UnR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 16:43:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbiG0UnP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 16:43:15 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E10A2501A1;
        Wed, 27 Jul 2022 13:43:14 -0700 (PDT)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26RI1r9n025987;
        Wed, 27 Jul 2022 13:42:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=zpd5WGEmHbec8Y5UgMLx/rRWhybB430CUvAmBvafSlY=;
 b=MPiNo11WKla+/IPlfoqJaTgghNrqR/VR9AX5lS02vkT8Y6mk/YmBDDyMqyXN/TrXmfyX
 /zvI0a6X6/+DhmRdbz/aZc6NwA8CVTToH+w76pTTn97x+5mZVuvX1YouJq4QFi/+zv+f
 iIloSjQoVxI6Ba5GnAZhiMTLkSV+C9Lpmms= 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hk4stvbq6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Jul 2022 13:42:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CZANYhJwxZp4I0MykGcI/K30b7T+l4jDhQg2YjKACbEpAg1MF42XmecErFztRR3zEuwrX4QriDdcCiASn0asSgx2r5JXYOy7LvfG/QVxKwYILTMOmABW1JDS7/zbtT+yOgYqjxiU/0V9hBxaWxOoQhKiPBY/BFclvkic0S+zHKOBFXoBgMPAVukQbNTkjl/m8tXKgVuDQFiZzLoAh+iRJj7n5IN54rNKW+vqi6dUlViQYWVrNfQKF0q4HUfmrSMnOMudoTe26kiLOH2y+7PwkfkLUXUdWs4Tp8taGkc/brPt5YR+cy8ErSnHX0/f8jtoL36C9CCKTomCXWaH+Kj/AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zpd5WGEmHbec8Y5UgMLx/rRWhybB430CUvAmBvafSlY=;
 b=Q14A2E7x3Hs9XuizYsVHpShK+4YwcVk75+WrGivVuLYeug0/zqdjul1HUTTDpkFryY+ai7kFVFgue18EciWeeyFxOqt/S+u1eGWQXzxEoIRcGKbMe4Y5iSiJQJ++iJUtxmRKWgsCemBZGZ7J5i+Q1uS8H3NG7smDbTv03GrEx/zovUz3bassPt2VUFPvLwI6M3CSCdzMRqtzrP45dL8y6A/4E46qkB+uGQZ/nIPgMnxYyKQCpAU2yLgUeqeHNpLd4/t7K7o1zI6s7P6htJv/ZpvdJhOvjTlQSDPtwDgIkyNqUzNXRRl6jHYRd+ScSikHXCQ5+znN3Cf0qY3YHQdZjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4475.namprd15.prod.outlook.com (2603:10b6:303:104::16)
 by DM6PR15MB3289.namprd15.prod.outlook.com (2603:10b6:5:165::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.25; Wed, 27 Jul
 2022 20:42:32 +0000
Received: from MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::4428:3a1e:4625:3a7a]) by MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::4428:3a1e:4625:3a7a%6]) with mapi id 15.20.5482.010; Wed, 27 Jul 2022
 20:42:32 +0000
Date:   Wed, 27 Jul 2022 13:42:30 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, kernel-team@fb.com,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH bpf-next 00/14] bpf: net: Remove duplicated codes from
 bpf_setsockopt()
Message-ID: <20220727204230.2gdl6wkm7earpjjr@kafai-mbp.dhcp.thefacebook.com>
References: <20220727060856.2370358-1-kafai@fb.com>
 <20220727101405.6e899947@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220727101405.6e899947@kernel.org>
X-ClientProxiedBy: BYAPR07CA0103.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::44) To MW4PR15MB4475.namprd15.prod.outlook.com
 (2603:10b6:303:104::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d1426b7f-ddba-45fe-2db8-08da70108765
X-MS-TrafficTypeDiagnostic: DM6PR15MB3289:EE_
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QpnZbsSv1abnIsyvoIyi6GGmc9N02dxzW6ffcf+QixK8ie/68KKVHnJu6QXKOVUpHo67K+Ajvh6kXCPz/f82HcZ9zBe8NwXqpxH49KlKXGT+zaYuyLOg65hvml0uU49PeqrBeLbRwA7dbFfIXs0wkQVDWmUMqrxg8x5zQTAR8fginA/rJLbKHKEaauVkNXTwRjvsqk9wnU9OB/WlHqX0NxTcR1Hu4gH/HIp8FelPflhsQGaohWxEl1gVWELP0HdefuU0EM3zHwATApPYNn7Zo1BKx6ic390GtFoczT0SjrlVKVJSYn52mTPONw9vmeG/Y4htz0Io1x1BEeL2unc80UrzCqppMfj8toxOkcC4oEADLRnW4JMq9I/9GLjnHVVWdPdDtcHgUIptOrcvAxJoAurqsT2CabrKnvNlcwtibEl+jjZehTHxlOEAEdVkgB9+sxKus9PuAOsiWYNB/QrOotgU+9iLTVkdE0BiQ0NTL+HcPX1EOWI9JVgpb/sCLuId3GgZD6I98fkN3criFrzEeeGzuq9PYoAbG+6TbmFv6neYUt5lGCaiLOxdhueQrBgzKLMv/ZOfuM0ISp2o5UcZrwzA9Pn2lgtmd1hThbUPFYKEXG8X5dH9y1STXVVbdYN0SN764uoTBrGWsYM9JTHl1tnfBUgIl0mqzlZQ9vxEQeTOsBVwbE3RtEUOh7E9Y63Q6tFJO8Uu+hycmyQXTNbiPkWzyWjwISWLW/JgMqGys6yG4AAAg3O+h3RXseeG3QDm
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4475.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(366004)(39860400002)(396003)(136003)(346002)(6916009)(2906002)(54906003)(558084003)(41300700001)(86362001)(1076003)(316002)(5660300002)(66476007)(478600001)(6506007)(38100700002)(6486002)(8936002)(6512007)(4326008)(8676002)(66946007)(186003)(9686003)(52116002)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XitmjWEB+HFrNvGxQpq9ZIATu/lgkSi2Rd9CkHNBVpC0h7jIbGfiVrf/83kY?=
 =?us-ascii?Q?wHYAemK5wty9Syp0PLJpLG3omJgE/lvG2pni1QIZs5Ns2wdmm1CYjtFN7h+1?=
 =?us-ascii?Q?KhhzoRr5Xi8K1Fwcjk8RD8lkG6JpgKpexD7D4g+acc+4mF3VeNmmR9m5BoB3?=
 =?us-ascii?Q?KXgF7frhTzmp8FVxEqDV60VcMCzeCkdQoWTrSkpCrnPf6cBufLvg2mZMkMFV?=
 =?us-ascii?Q?4CCb+9iQzkR0+iBEY7pZnyHkobdlbOwWrithXswa6B79ASeHWb0lpRTEEvMU?=
 =?us-ascii?Q?uY5pPCfQ2GfDdryviroqXgcoLasHwnYkxsf+/maOqr8btr6LDbZd/1nbJEHP?=
 =?us-ascii?Q?cBpObCtYvrzF9vQZg++OweZyDAmpOfneLVVeEuykw0bEQX+qab0M9DuJik+2?=
 =?us-ascii?Q?17RAy7o2KFcyWawVjkXE6wJ+KHKpIlhLh0zITP0FBqZbVbM8cWQKKCoenSRF?=
 =?us-ascii?Q?RSR9TaX1wB1eVL70bk0d24KYmHqucAWO5BenKncdM5OQZ9IbtYsfXE80+ITU?=
 =?us-ascii?Q?jbSBMPsS8PriCRfnAH63vfYEizznE1NW9okOUI5fo91/RCS7BKewcfYeVtUa?=
 =?us-ascii?Q?/5UOlgknDkjxCiGW98JlwE2V7iE0acmlbS1dDForM8IyDoVG/82Yk862OXT9?=
 =?us-ascii?Q?cMFikFiTBS+r6v56VGQwRHVzKQm+QEvB6ENZEq4wou03LWe9oCmzswk+vmH8?=
 =?us-ascii?Q?EV/APPDgnqTm72bG8v6hMGu+MpzMBpIh3+KvWbyHmGnUCqbov5uvZBvFo6zH?=
 =?us-ascii?Q?8rx7NsByGNlbsm0D4umoGLwziHnw+2EN56tX+IV6b6Pd6NZ/lEIGEazYpOq4?=
 =?us-ascii?Q?J8OszaPt0vXuuYOGttjwNPo6FzYt0DWUlCgQgYilFUttuqba3wvYht0T5mPh?=
 =?us-ascii?Q?Ul8s7pc5coMjnIEhfJwEmBbNXz1Bt3f8LI5C6AdQt8TnU4ErtZQAnAoogT1N?=
 =?us-ascii?Q?BAD1bg3TGkO+ei4ssl0XUGNqFHPcS9evzwPAhoIvoQcSb5mONZGmrBf13I/g?=
 =?us-ascii?Q?uPZfdrrKXYgsYkbTXfmSRbnWgrLzB5e8WJjONhnfniV0y7keQWJsto8ZQMaX?=
 =?us-ascii?Q?ljHnUN6/oOyS6QYmjPrIcnDyvtgn0ZoHtFBC0w1EIvzaKu4MubCLt1MJ5ktr?=
 =?us-ascii?Q?RuCiq+CsSEAmSzw4E1s1fob78smslFjhohAwNVjN5wPWustvztYMF6unMHjc?=
 =?us-ascii?Q?XkouehKDb7TraL8Q+D5/P8Y9f6zmcWErms8CM5cyh91HbkRPqejjTUZea/wA?=
 =?us-ascii?Q?uVCUtaOhR3X5CYIbErsfPSXTurbpo5Civvw4X2773Fm3GT48YogMnbyl2O4g?=
 =?us-ascii?Q?U0UOREHY//TP3VWAFEaHkS5BdKeyHY18ALBCKbf+hb8eXdY93zZg6t6WVvj+?=
 =?us-ascii?Q?bgwostZZ1iQxngdI+znXAJO06+fLvZL4uRw73d5htmCk8pZoxVEkv49NznCC?=
 =?us-ascii?Q?HqOXuS59XlPwGKDpKPoIm4ePuvL84FFt4DpOr8sq2bOSJIOEPVx3YU9ZpbK7?=
 =?us-ascii?Q?EMonxGWwWHFpAX5HPV21a68lPEiPmvC/Z+P0R8nATULyWLJOrhlVlu0Ztg5O?=
 =?us-ascii?Q?QRTNgRsPMQre8AIUvE9yp/9avE/yozVfbflHRJL/oXZG9q8ygYhn51XlBh3T?=
 =?us-ascii?Q?9g=3D=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1426b7f-ddba-45fe-2db8-08da70108765
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4475.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2022 20:42:32.0782
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l1+TF6/R3csAi+WK6Kbz45pp/5vdQO7ftmXSjODK/qRQ9Uird0hejLnsGDn7ZOTo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB3289
X-Proofpoint-ORIG-GUID: cP2N_ocAReCf3hJ8ZlzAbqS1O3_w8Hhg
X-Proofpoint-GUID: cP2N_ocAReCf3hJ8ZlzAbqS1O3_w8Hhg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-27_08,2022-07-27_01,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 27, 2022 at 10:14:05AM -0700, Jakub Kicinski wrote:
> On Tue, 26 Jul 2022 23:08:56 -0700 Martin KaFai Lau wrote:
> > bpf: net: Remove duplicated codes from bpf_setsockopt()
> 
> nit: "code" is a mass noun, uncountable and always singular
will fix.
