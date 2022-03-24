Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A20754E69D2
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 21:29:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244138AbiCXUaq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 16:30:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237832AbiCXUap (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 16:30:45 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2BD93E5D1;
        Thu, 24 Mar 2022 13:29:12 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.1.2/8.16.1.2) with ESMTP id 22OKQJ4h027161;
        Thu, 24 Mar 2022 13:28:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=l3NDD6OXqb9y5JigxsgI+hf76p+zo27H72JGFSFuyFE=;
 b=ehXJGQWZ2n7iFH50Gfds34FS8w/vcnKA9vMsfX8uW47NROPbnOJP9z7EgVpp835Ls4A3
 7J5BXGYfuhkaGkevrtn7tUqpsTnHT1zfeo6HsqoMV9o8tgQBMCIx0H4vHoCsyphgDpIh
 veSF4A720g2bWyNUrbYck4ZqQbjRaX52o00= 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by m0001303.ppops.net (PPS) with ESMTPS id 3f03ft3uer-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Mar 2022 13:28:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SvwzueU6oUSiF5lFc4UXVEqpLVxbPi6NPSSzJgzIg0XX6gYMcksEDvAo+fWYasZfT6r5Prfjd8eNNSGq2eFkCZxtYKQNahOoBN/TKRhr8xEn2mMjWYgsUkq+2TNF+vtSfUaYs7tWALkKQ1LjSjLXtx3w8MlY5D+DtSS7G/nv5IRnU93eZBKhrC8Opqn7NKXKV1qTarlKOsn/jzVz7cGcxjKbstzXHUYA9rxMfZbHQR3Rk33c8XSseLf84SQUODBZzfQa0Z92qHnwTephDmPF3k/vjefO3DLhlGFOgqmaf/86gX0TNn+yLXPGODg9jhUGzy9M1vgqroPUHPT9qIqBNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l3NDD6OXqb9y5JigxsgI+hf76p+zo27H72JGFSFuyFE=;
 b=NRByVwBA0yVOtUHLeFI33neYojBUqu9Io4Oa5rWPVrI0FKLNrC5FxTKJqjnst3Eqsg2AOXM2PfMGKuP50py43yupD8NF3sfljQrUll0rw6OT1FHq/x2/hzdZtAcmAppTN4ib0SzBqs8S/OF396JqsfJuNqETOygzY2Yt6JVve4ctRCG+cJWaGiWyrWraqlpQugG9aj4O2EYXt7FN3mkvtHjoQ9XMg04W1NfOIsgCF9oRpVJt+bpJeIp6CManWEktW6H1Wmp6saSgVzKpJvonGIB42lcfM2rygCBSBXfdwCI+HoBmUYq6QUwBeASgqKGM0/rOKgZYkRyF+/hs77BBdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by DM6PR15MB3800.namprd15.prod.outlook.com (2603:10b6:5:2b5::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.17; Thu, 24 Mar
 2022 20:28:52 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::708c:84b0:641f:e7ca]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::708c:84b0:641f:e7ca%3]) with mapi id 15.20.5102.019; Thu, 24 Mar 2022
 20:28:52 +0000
Date:   Thu, 24 Mar 2022 13:28:48 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Haowen Bai <baihaowen@meizu.com>
Cc:     shuah@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/bpf: Fix warning comparing pointer to 0
Message-ID: <20220324202848.2ncrqbzv3dv5qifo@kafai-mbp>
References: <1648087725-29435-1-git-send-email-baihaowen@meizu.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1648087725-29435-1-git-send-email-baihaowen@meizu.com>
X-ClientProxiedBy: MW4PR02CA0005.namprd02.prod.outlook.com
 (2603:10b6:303:16d::14) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b7a572cd-ebb3-4a1b-e473-08da0dd4e935
X-MS-TrafficTypeDiagnostic: DM6PR15MB3800:EE_
X-Microsoft-Antispam-PRVS: <DM6PR15MB38002CDD34A1C9E698088820D5199@DM6PR15MB3800.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Qfpdz3L9QsLxjeQM7t+a7ycP0wvetaEy4nHhHLmWw6s7D29uXWeBI0QieBxIPc+WpDdk0m96fcTRSb7MGttDQ2P1+XDk55bp3LKJ4XRgW4xY5ApPRRj9fZM4jI1QgIWV6Rfv1Jie1YruULKMqcjzrNN3gYEx45gkymKjvlpYH0AbUe6buhtwjFACdfSovapA3xIa7ceknNOD9PScn4CaWHBroZugpnM5TrjJ1XCzHWOq0qlTLkZ5b3zKRINwVTlN2LLDxFO4ApOzTFVyfG0Ph5PdbyhY98WHYQZZauEwyE0vUw13wokOPeyX+9cc5JAn/oEtYNZtxMyHfMB8tcAhNESeCnKeHHvfssE0qdzjFIPfTsqLDsokVbQGUFgUiHLqcby152q3VdPMJKDrZ5WIsjZbHncfD2HnP1/PwuRbYWWKVV0Pg1DsrAaZN2CwJzVQaVDp8WizoB1j1VpUy4dNMiJZlvoRW4thWsdjt4hadZ2er9GH3PyH+m+HF2h94Igr5PUsrzL/8mR3Ih8Mgxsul/y9C7rK1yNwfm+I3mFYFi5qD/JuauOv8B7yTUiZuoE2kbYKGPV53xT93h5ABRyXg7ZEL+hQ71hCOCt4uU60y9USBbuT0ZJNCQg1skaw8lXIyTSLTKxKo057PRCTHEpO9A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(6506007)(6666004)(66556008)(66476007)(2906002)(52116002)(7416002)(86362001)(66946007)(6486002)(6916009)(9686003)(6512007)(186003)(1076003)(508600001)(558084003)(38100700002)(8936002)(5660300002)(33716001)(4326008)(8676002)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?leuGxFMBqMKfs4wP1zoObe4rGD5RPZRiEP0BdJ4ESCFlFLkWwPYnDFMTFKpb?=
 =?us-ascii?Q?2LTox1FytrPvvRxiLJp8L9ByZU6wTr9KZIacAwyys4+X2XuOX6z4ugh9CpbK?=
 =?us-ascii?Q?e1DxovnIUeY7SH2Wg/TGk3W6XnyOB+QbHZapt48eFyvbZtieBKA1i6hhPxSs?=
 =?us-ascii?Q?5F0m1uHozqTiEEtWj4F/HZkz2/6lGL+H+YqHJzWjmcOZS0AGH/lo4KIl5jTc?=
 =?us-ascii?Q?ikxQ2W4ob1cIweIFBOZqsC7QWwyxiVWdP1Gn0mISYTzbsqBF4i1izm86L93K?=
 =?us-ascii?Q?bxnMAoqs4gry+af2AP3lZqM21oH8pD/MPk1gUf9VX8Gi0H7HdaqI2ZTe2QDm?=
 =?us-ascii?Q?cuDoUboBOLdRPQ91N1P+nsDpHevEQeAaz5lfkP1dS7kbtKohEJdtzKNLRlBd?=
 =?us-ascii?Q?gAALe2IUNxilP1jGQWrYE72cnfvUzBEkjIeyS82+wgl/PlG4ugOyGu+cHk0j?=
 =?us-ascii?Q?PsiR4U6wZ0MHC43JmERZTsldcU4dwb+D9knNyzeHogPXMmAH9zR9DVdZdI++?=
 =?us-ascii?Q?WZGDeQnYZGN8qOwL4H+MqbEgTbwzV5z0zgjT+QKbdAjb6TZ+0AmnOrZaweSo?=
 =?us-ascii?Q?0kP8LrYmItDWpV5HvjrY+MFsQB1w/ScgnEhVa6wJ10K7gF9byDP3SBOdNT+A?=
 =?us-ascii?Q?ykm+2bibcgnVaWjoQKEtb4TOx1+nqlVb3Mec8JTovDnZVyrqwq2u674BrG++?=
 =?us-ascii?Q?E+AKG4OxrGgZK+ro2L87g+qgJ1xQJyaKm9lmg+tF/B/VCbFQQkumFYRb23z5?=
 =?us-ascii?Q?5XLvkHBhr5JT3mj5iZpFI/K9kmET7vddVMfyifpN8Z2T8zi9Y/ANZfz/7SaZ?=
 =?us-ascii?Q?HGPm+z8zY/q5O2zHY8HFNc+t8LfZgIl3bfSI0cjeTCBGBCXmPJUFOEpojbBC?=
 =?us-ascii?Q?WcXGmf1Vo5uonr7HX5x89RDx6u0sOkD4vox2IsDXMIvH8n3Il9iBMtsReKO1?=
 =?us-ascii?Q?jV33GxTixwvathy2WpihthfV4DkW2QHphJTbSd4tdYGwZzCZoUOH34QiirAu?=
 =?us-ascii?Q?S9B3ZNLpNrZTw1VOD0AeVP58JY7cygqpcpfwhsTSPKtvdHToGGDepLIz+nJe?=
 =?us-ascii?Q?3ieBQkyqsNa5nGFRUNXjGOyAjqaxjMtQK9SQhFlWJLx6q0IYhy1UeQgW7g4z?=
 =?us-ascii?Q?+jDkOjCNbbCySLvQs9YpCQ8wY9NSIPY62f0XJIiNAf0NxsA94qggOzLPQB7N?=
 =?us-ascii?Q?Cw5jcZtkQg07CwdEKx1Q2JpFkq3mky8Pl21Niq+RkN7AbOS1jE2DbOBHQXgA?=
 =?us-ascii?Q?Rk4R86MBURs1rcvX9EdZNQYSwr68WhsteFT6flMSxjExH4uX8JQsamK/2yuh?=
 =?us-ascii?Q?P9gzFIS2yMQANVoLEa8eBHbdWz2FCkeWCZVZl1vHnzD0iQmzeximp71PCUzN?=
 =?us-ascii?Q?/4Phq7Tl0+iSccawGXmdlTYHPCo9Bm9xCH7oTskEonm76nNi6Gq9VWO+8t1K?=
 =?us-ascii?Q?axbAx6G0Ldua4EWDancpmbOa7Pk3yAC8E3ZRUe5SXTgwzNwjuzKs5Q=3D=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7a572cd-ebb3-4a1b-e473-08da0dd4e935
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2022 20:28:52.6165
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yfUEz0odBUs7wjqDuHs+4ZzrjKav/P5aIuQpgDStoEdQLZc3xd5SNt+9jUnrr8nh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB3800
X-Proofpoint-ORIG-GUID: LMjYNm7nrzM58ffHNohlkyNRR3zaV1Rh
X-Proofpoint-GUID: LMjYNm7nrzM58ffHNohlkyNRR3zaV1Rh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-24_07,2022-03-24_01,2022-02-23_01
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 24, 2022 at 10:08:45AM +0800, Haowen Bai wrote:
> Avoid pointer type value compared with 0 to make code clear.
Which compiler version that warns ?
I don't see it with the latest llvm-project from github.

The patch lgtm.

Acked-by: Martin KaFai Lau <kafai@fb.com>
