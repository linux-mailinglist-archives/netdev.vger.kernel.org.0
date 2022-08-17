Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91813596893
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 07:28:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236800AbiHQFYY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 01:24:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbiHQFYW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 01:24:22 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 052635D12E;
        Tue, 16 Aug 2022 22:24:19 -0700 (PDT)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27H0Jglr009857;
        Tue, 16 Aug 2022 22:24:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 content-transfer-encoding : mime-version; s=facebook;
 bh=LIQFJeipEtsccSKdOTjgBOby6lZMBYOcYlwgv3mturE=;
 b=S5ZM12Psws24JUkr8U9QwujS5jRnm6xyFwsA/FcSh2jmmEKQ+OFcA3zEEcictWsZo3uy
 otzBPDTXh88DuaofQr25nnBplXsZubFlkrLhZ1uXnvZqMy2c0a4rdqsgWCrj+t2FbrFo
 caqgIo8GDrQu0jw7THQSvZpPQMzhhv9IUFc= 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2109.outbound.protection.outlook.com [104.47.55.109])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3j0npd12ht-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Aug 2022 22:24:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B3tB33earuHRL5NQw/L9Y9lH/XOi6dtASD3wfJWFj25McoF2pUCzFU3ANCdIIR6n9ldMUmNKbS4jMfjCma0tnTZdLFPmvibDA2T18a8imCOP2F3IrZn3dQG7rSl86d42z//eDiuTmq3YQPrkXMrZEGiPci9Pd0OZ18xQlPERdmDTUk+e/xxKKoyJoKC13B6nLq3KcHlV/tVzwUGM6nX1YC9fL/lfknxG/0i/cH12Ao131im0QsbnzheY4qKbuyWus36JsPE+GmVYbOHg6ygFxF9WYyZ18sQgE0n6ZixxmPFWjeC6cwBa/QwzyVfqZAyd1g4WBtHH83y94IvQvZYuMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3Z6WWroHH1Lr1Dm4x7FlamQsefzl7O06dq7RLwSLw90=;
 b=fjNraMjg+evJwuqpkiL/w0Ag19q9LuY1eKl/rWjDHiIXEiRutFnh4J/nxspoqLekqgIWFhRwLi24bwUwDDAdKv5xyKGtT0E9A3nsoDBsyt+OMjW8Yhoa5bfAttDTXi0p8FV/d9xR4T+ZlQXMix+7rKheIHTUCY/sRdc0be0IPmkiyxqxbL4INbEPeVtPCZx2OrIrlERGlqSBwL3hjeE/3StOXH+xeGXY+hdPhluir8CAruzeAWG+ZNrjc87RtIVmFzU3PSyUPPZytUojXE3sFl0ewiL6AOkbc/Hf5gfKzXysoj36Qv5tH+p2K7yzHHCHmjNmdA00Ws8fi0HrUxXeWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SJ0PR15MB4472.namprd15.prod.outlook.com (2603:10b6:a03:375::17)
 by MW5PR15MB5171.namprd15.prod.outlook.com (2603:10b6:303:199::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.17; Wed, 17 Aug
 2022 05:23:59 +0000
Received: from SJ0PR15MB4472.namprd15.prod.outlook.com
 ([fe80::91e1:d581:e955:dd3a]) by SJ0PR15MB4472.namprd15.prod.outlook.com
 ([fe80::91e1:d581:e955:dd3a%9]) with mapi id 15.20.5525.019; Wed, 17 Aug 2022
 05:23:59 +0000
Date:   Tue, 16 Aug 2022 22:23:57 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     sdf@google.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, kernel-team@fb.com,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH v3 bpf-next 00/15] bpf: net: Remove duplicated code from
 bpf_setsockopt()
Message-ID: <20220817052357.dcci7uqqlhsfabik@kafai-mbp>
References: <20220810190724.2692127-1-kafai@fb.com>
 <YvU2md/W4YSlnkBH@google.com>
 <1b791103-1f8d-bc08-3f65-7c1b2316e2c3@iogearbox.net>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1b791103-1f8d-bc08-3f65-7c1b2316e2c3@iogearbox.net>
X-ClientProxiedBy: BY5PR17CA0012.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::25) To SJ0PR15MB4472.namprd15.prod.outlook.com
 (2603:10b6:a03:375::17)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: edf2d1b3-1e6e-41e4-da8b-08da8010b035
X-MS-TrafficTypeDiagnostic: MW5PR15MB5171:EE_
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pa4l9OiQT5B1vopaav3DqvyQJBvHkalpIzC1iEiYodxKfLCFAAXOIcTEBHVh9p3/8fBqZHgWFUP08+3yMSdKwnqF8mfoiUPoLTlU7M6VMsUa7SvyXRoIzwim9/ZEu6j9umt4D4ppmCqGaBeIsHFVLUuGDmMjgxzenqQxaK/k95ovXE2iwBy2GMCAlNzJV+2hphBd3uHUdEtAQgPIi80Y9KNDrjevYcEd1F5YzDYRgCF8Hy4AxSgQUiHn1dkovRuos8omDy5G6qp1hVE8V0zwlHQXbp50CtCQXux38DWkZSFa6ZXw0W75isp1MLKQ1dAl30PTG8tV6JoxC1v0NEhvgJQ1QkVqbKfMdSoetV3nlzmBFTp1to1nl9otLsp6mVg/FyPSZMDqpfIC6TAcyDCdhuRC2nq1eXYLGgdldUDzbo17OFQbL/eXuJNkMYZUQ/uxXXx8MRWs125dIZUIk0dzc8NDZoyFtMHqeBbAU2ne5FLY5yI9vNFNnahmIM0SuoO5/arAhA5BeXOhOC3l7cfiaLsSTwwqjA3WEZ444fG5BHlb/IwMYGjSxw2P7mIk2oDQ6NOBFk7gK0/pa6c5Ax2luminM4IfmEr6GAjcGZbccZq1liNfi7ng/iIqma7LVnLHMfzi6fTDMATw4PzgpkabxIP9X9oBPaPWif1s5dgzbAws1Pra+MZAVfiV1alK8LDfqVsVHP7zwZLTOGqeTD98LiMfegb9aUngrgjvWpmgZwdjzqZiS+u+ZeWELnE83UXris00AxXWq1c+ptzSYT9Vuw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR15MB4472.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(396003)(136003)(39860400002)(376002)(366004)(346002)(41300700001)(6506007)(6512007)(9686003)(966005)(38100700002)(478600001)(33716001)(6486002)(86362001)(83380400001)(53546011)(52116002)(6916009)(186003)(8936002)(7416002)(5660300002)(2906002)(54906003)(316002)(66946007)(66476007)(4326008)(8676002)(66556008)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?W+uBeXdG8/ahUlAM22svIhvN+6NzvbLtzbSN3aoFT0lTOnD8MedzwmYF28?=
 =?iso-8859-1?Q?9ZA4LxgtQ0jbD06R+ZppxVT5XhjBDwimDjL1xKjjndoJ3n2R+A8j2Cbazr?=
 =?iso-8859-1?Q?dVM5L+TmRDZRp1vddxtmmlfRloymIeG20NtaIEUkRZyyZGDu7sr9pn3iot?=
 =?iso-8859-1?Q?CL6PscuI2IqQTYXuWUrSY7Ap34r1Nzip9MLlxRvTVobsyQzKZa8Xqw46Ml?=
 =?iso-8859-1?Q?tOztUreS2DuAt2C45h2OEmz1NJu6z5uIBtFlia8c4znR9oUkdFg+mwcWq2?=
 =?iso-8859-1?Q?lkN+VOZtmQGHP3Qbec04SAmkN1JCHYgUo6A3T21oEx53+S6YMJbBmmZUcV?=
 =?iso-8859-1?Q?PYFegiXLt8PXuNhwL0UxJV7Qp6ZykFPYr0uJiSUBkt+1IBIgXZNTOsRuFR?=
 =?iso-8859-1?Q?JkLWKwIW/X8wnMhrXSnCHKnnzMQBqeWjc31B8p0hzqLvQ0iPBNWXeXd4jT?=
 =?iso-8859-1?Q?qBE8WQ22y1sfr7FSMKLQPV4JpCOO9LLiof/w/q5G11moMgSiK6NbU82fyb?=
 =?iso-8859-1?Q?Aw0EpH4zsrhsHImTjr0l4QB2JeuZkMeiBmoMJuUaGHzsM/1fGzyVlp59tl?=
 =?iso-8859-1?Q?1pD3I3QWKYqd3atefOyOb75JRxK+MqEkqXhbYUiQZBrgbDZsFeOwZvb6je?=
 =?iso-8859-1?Q?NlRlHZwEolHNmWwYB024x2DCdo5wsiR2cj1SRuzeHGSuorpr6Y6EshjdzG?=
 =?iso-8859-1?Q?NkHOyKE8/58sDe7KoZb2iML6tL5Nob/+ytW0ravTBwRZji3Kr9WFSq1eVk?=
 =?iso-8859-1?Q?dsLydcpmXPpq7oXB7ty3V7zRcJrOaAxOLTg83D41mFQYWfuBMMfYLKR/9z?=
 =?iso-8859-1?Q?6l6YbyUe0BcILswN9Z7I9lwfjdiQXuoKbWD9WTciaPo6Ue8lo9BoNIWvaJ?=
 =?iso-8859-1?Q?KaGSaN4rDUqbbIk5FAtsnanppiku5gw5/OptDDoL9779DGjgeSvSEC4Isa?=
 =?iso-8859-1?Q?oSjct402r1k0bjWqp6Iobzmup96cO1dLtGWY1RCSamAqxJRDYRHB9d4QgR?=
 =?iso-8859-1?Q?F4FA0jMyT/t3ZgBST5ejVrjCugI/DAZNqVhiImP0ABzIbA6UyJOhoB8zFN?=
 =?iso-8859-1?Q?dRw4tDlDmQQHoeTWkdDkJFu1nkp3O4w11vQ9cVzS6mOBtTkruFV/wwAV/d?=
 =?iso-8859-1?Q?b/394U5/kA4KaiWPIx9VxH2s5XVpXQCnRezrIK+JGGnbbKEqef6Vr+TGQz?=
 =?iso-8859-1?Q?gNxXK0zsXx3xHA8GqnAbZTZisgo9A1+nNebN1LOgy1xJkw0zQXDCELCTZd?=
 =?iso-8859-1?Q?XCZoSeZaVt5deZj1L0EEdI4BkYYqyxkjolX0/cgVPzpKpWqS/6XAldXkk4?=
 =?iso-8859-1?Q?anXhpV9ROYuOyx6MCeY95oFImrfORjk3hVNa1bj2CCFhA8S0KR8kiVFZ+R?=
 =?iso-8859-1?Q?m5pkmFIraERyvXMQh+wbysTBpsco1AVz1zDyTBPRaTwnM7LwacjjkRtcBL?=
 =?iso-8859-1?Q?QImTj2/7+5DGkRdZzYshFDLSBFZkDM54rjXJN+W1q6pwvISk3HWVYTvulA?=
 =?iso-8859-1?Q?7pmIlkEn+OFzoJ8JJxexA3syJ9HCS3Bl3Co1P5it5HS7H2iCEbys3c4S4u?=
 =?iso-8859-1?Q?UJpthSqMahJiM4B2key1AIeiyIUNbtQWWLHz3Fo10T1/6MDyO+CRn+lVCu?=
 =?iso-8859-1?Q?FuPeXSnwNn/iUj9QMmQLNWC0lj2LaPsnIE5LDibV+s/+WhF1CELF4MWw?=
 =?iso-8859-1?Q?=3D=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: edf2d1b3-1e6e-41e4-da8b-08da8010b035
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR15MB4472.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2022 05:23:59.2216
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2rjCD5i0bL+mRkqI8w8QLgeBudSN9dBvziqYU02GEQSU/JMNpF8IDz41YvAv4csW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR15MB5171
X-Proofpoint-GUID: flu7ltptofVYbRPkynzFZt9bfh5wjQrR
X-Proofpoint-ORIG-GUID: flu7ltptofVYbRPkynzFZt9bfh5wjQrR
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-17_04,2022-08-16_02,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 16, 2022 at 12:04:52AM +0200, Daniel Borkmann wrote:
> On 8/11/22 7:04 PM, sdf@google.com wrote:
> > On 08/10, Martin KaFai Lau wrote:
> > > The code in bpf_setsockopt() is mostly a copy-and-paste from
> > > the sock_setsockopt(), do_tcp_setsockopt(), do_ipv6_setsockopt(),
> > > and do_ip_setsockopt().  As the allowed optnames in bpf_setsockopt()
> > > grows, so are the duplicated code.  The code between the copies
> > > also slowly drifted.
> > 
> > > This set is an effort to clean this up and reuse the existing
> > > {sock,do_tcp,do_ipv6,do_ip}_setsockopt() as much as possible.
> > 
> > > After the clean up, this set also adds a few allowed optnames
> > > that we need to the bpf_setsockopt().
> > 
> > > The initial attempt was to clean up both bpf_setsockopt() and
> > > bpf_getsockopt() together.  However, the patch set was getting
> > > too long.  It is beneficial to leave the bpf_getsockopt()
> > > out for another patch set.  Thus, this set is focusing
> > > on the bpf_setsockopt().
> > 
> > > v3:
> > > - s/in_bpf/has_current_bpf_ctx/ (Andrii)
> > > - Add comments to has_current_bpf_ctx() and sockopt_lock_sock()
> > >    (Stanislav)
> > > - Use vmlinux.h in selftest and add defines to bpf_tracing_net.h
> > >    (Stanislav)
> > > - Use bpf_getsockopt(SO_MARK) in selftest (Stanislav)
> > > - Use BPF_CORE_READ_BITFIELD in selftest (Yonghong)
> > 
> > Reviewed-by: Stanislav Fomichev <sdf@google.com>
> > 
> > (I didn't go super deep on the selftest)
> 
> Looks like that one throws a build error, fwiw:
> 
> https://github.com/kernel-patches/bpf/runs/7844497492?check_suite_focus=true
> 
>   [...]
>     CLNG-BPF [test_maps] kfunc_call_test_subprog.o
>     CLNG-BPF [test_maps] bpf_iter_test_kern6.o
>   progs/setget_sockopt.c:39:33: error: implicit truncation from 'int' to bit-field changes value from 1 to -1 [-Werror,-Wbitfield-constant-conversion]
>           { .opt = SO_REUSEADDR, .flip = 1, },
>                                          ^
>   progs/setget_sockopt.c:42:33: error: implicit truncation from 'int' to bit-field changes value from 1 to -1 [-Werror,-Wbitfield-constant-conversion]
>           { .opt = SO_KEEPALIVE, .flip = 1, },
>                                          ^
>   progs/setget_sockopt.c:44:33: error: implicit truncation from 'int' to bit-field changes value from 1 to -1 [-Werror,-Wbitfield-constant-conversion]
>           { .opt = SO_REUSEPORT, .flip = 1, },
>                                          ^
>     CLNG-BPF [test_maps] btf__core_reloc_type_id.o
>   progs/setget_sockopt.c:48:32: error: implicit truncation from 'int' to bit-field changes value from 1 to -1 [-Werror,-Wbitfield-constant-conversion]
>           { .opt = SO_TXREHASH, .flip = 1, },
>                                         ^
>   progs/setget_sockopt.c:53:32: error: implicit truncation from 'int' to bit-field changes value from 1 to -1 [-Werror,-Wbitfield-constant-conversion]
>           { .opt = TCP_NODELAY, .flip = 1, },
>                                         ^
>   progs/setget_sockopt.c:61:45: error: implicit truncation from 'int' to bit-field changes value from 1 to -1 [-Werror,-Wbitfield-constant-conversion]
>           { .opt = TCP_THIN_LINEAR_TIMEOUTS, .flip = 1, },
>                                                      ^
>   progs/setget_sockopt.c:75:39: error: implicit truncation from 'int' to bit-field changes value from 1 to -1 [-Werror,-Wbitfield-constant-conversion]
>           { .opt = IPV6_AUTOFLOWLABEL, .flip = 1, },
>                                                ^
>   7 errors generated.
>   make: *** [Makefile:521: /tmp/runner/work/bpf/bpf/tools/testing/selftests/bpf/setget_sockopt.o] Error 1
>   make: *** Waiting for unfinished jobs....
>   make: Leaving directory '/tmp/runner/work/bpf/bpf/tools/testing/selftests/bpf'
>   Error: Process completed with exit code 2.
Thanks for the report.  I also see it after moving from clang 15 to 16.
I will address it in v4.
