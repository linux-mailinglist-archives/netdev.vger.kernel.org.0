Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0C585694B1
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 23:50:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233962AbiGFVuj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 17:50:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233419AbiGFVuh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 17:50:37 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AB5A1A810;
        Wed,  6 Jul 2022 14:50:37 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 266L6kX4018409;
        Wed, 6 Jul 2022 14:50:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=TEj04unjBrxztJfHJHtmyG6T99Qhe0N42r4PaXy/Dpc=;
 b=kYoTGtcEcTzLINI+T1vp5x23SN/fJJzbJgBk1YqT+btusmqx2ediVD7wxiFxgq6iff7w
 w/EnQoyy/aZOdw4hkVzCG3JFWzeRvUfNeU/k6No7cu09fNnQtbEH/Kyh132Ae5ZkGLrt
 VZutQgeijjYma4OQQ2Q1qG4RW8qLak2ozK4= 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2172.outbound.protection.outlook.com [104.47.56.172])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3h4uaqha7u-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 Jul 2022 14:50:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OwIBpq7CqhFRjF5soArIQFC9uwDTlEOQs4YEJxBCCMiDhqWRBbPdk1swtvQnO7Z/BZEQu+dnISGD8CsmYxm45wHRaTtghBqVS/dz/rOgFuw2HnzgRFLN6v81mVzhxk6PT1NgfykS6WrmCqT3tiFxcvpYOOQMVkzCPDmC0AfiGvw+RjpEpiX8DUxEsnwuETJ8HDanp3GOOh/87VGeBXugBqtk2/wTqBwp4bOh+FAyALgAUz3Hl/9B01L3IA0dNqmt5+cwnNMs/Uklw0ho0U55UrQPN/15ATVu4CGRTMPE5vAcFdS3J2FEObTtDj3uyydBLwN/kSmzRQ18eMIAOWQi8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TEj04unjBrxztJfHJHtmyG6T99Qhe0N42r4PaXy/Dpc=;
 b=gonpQ8T6lEQv0XcU/F6lG9y0aj4ttLukNCuLk0LeTHkJ8HbebiJetTlguOQGKsBD8yL0t+p58eGjYx8jUYQkMgLpKk4CpBnArQXv+WBE7RnuvREoCBjGFzpom/jjt1Hhe5g6/q7MAI6ncIsVO5tqPwfaW5nF5LY2IZZx9YdBnn7/57Bk6Kn/f+9TPgYETraAjPm+VOvVsqBujXod+x0oqHGuhY2zI+XERvOSZJ/3uNT2RSx6bhl+NqrOu1Zggv8er9ROJGXJ10ZybERlTiXZdMKSE/RwtPzfGwSYnQu3C0muwhPuybKguDNWJqCsFZJkcd0WH64xjpcycZmHYWyGuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by MWHPR15MB1245.namprd15.prod.outlook.com (2603:10b6:320:23::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.16; Wed, 6 Jul
 2022 21:50:34 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::e8cd:89e9:95b6:e19a]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::e8cd:89e9:95b6:e19a%7]) with mapi id 15.20.5417.016; Wed, 6 Jul 2022
 21:50:34 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Steven Rostedt <rostedt@goodmis.org>
CC:     Song Liu <song@kernel.org>, Networking <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "jolsa@kernel.org" <jolsa@kernel.org>,
        "mhiramat@kernel.org" <mhiramat@kernel.org>
Subject: Re: [PATCH v2 bpf-next 5/5] bpf: trampoline: support
 FTRACE_OPS_FL_SHARE_IPMODIFY
Thread-Topic: [PATCH v2 bpf-next 5/5] bpf: trampoline: support
 FTRACE_OPS_FL_SHARE_IPMODIFY
Thread-Index: AQHYdrj21zA3ifq/PEC7Yw0zyJbSw61x8o6AgAAhSYCAAADUgIAAAriA
Date:   Wed, 6 Jul 2022 21:50:34 +0000
Message-ID: <C319735F-9782-4AA4-AF63-A110A43E5597@fb.com>
References: <20220602193706.2607681-1-song@kernel.org>
 <20220602193706.2607681-6-song@kernel.org>
 <20220706153843.37584b5b@gandalf.local.home>
 <DC04E081-8320-4A39-A058-D0E33F202625@fb.com>
 <20220706174049.6c60250f@gandalf.local.home>
In-Reply-To: <20220706174049.6c60250f@gandalf.local.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.100.31)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 83df15a3-2414-4913-1e99-08da5f998df9
x-ms-traffictypediagnostic: MWHPR15MB1245:EE_
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Si++ieD39762QwF9G42oqVSM/jJiTwxqA08dPqMVOBoX9uhDBTJtEtdlHIZnoGWmWuryPm1eOPgbGRIOrCeXjhRg9oYkItzc9dMourAuXtBjWnc9AWv+2zncWaqt0mkKhlwZU4JDoFiJSMgkRhyggFfPZzOM27c8+ddV9hQGPcEnRAi2cnWaPAUWcZLzBH/S9If3uZs20zlINBsQHIYu+dsW4rtHppNQpkVGZG+ZyUsZ55tQ9OVKSLmmoShI06KTO3zlvXDkuNgxzCxXDL6dq3fbJMbFcaQKQBDu2oSpu8Y8letkWRZtk51JhUGVqMm45+YOOHw0t7nZTQTl2RTt8zFhwDETwIl1KWYRxjGfRFDEVepSEFDywVb2SH3KFQzy+wv4Oo6wDXbfGuH5WLBR+ojfPM6ou1ikk1at9o/Fy7YqQrC08Ik3grdmHm7yXdLcriqPiPNImFmtgT7dmIRcJXU3kv8SB0NZo4LdP0G+QVQVmZsrakMXjCbaAKi7E6hFziAA/w+pG12V1RATH8RNlXwYcXwkqvwqdDpoOZYeZTBamJT1vSQ3dgG9E1Eh87a0MDg44OGTuBAA/ZiPQENtouS3fJYG5dF553XUrQBl1EqRddtc9KJmtkps8ukSaCPHLITc7t49klEt1y77pX76cPQGudv1NtKHH1mRjaLlAIvqZJ9SPD8amQz1GB2BI8kClP2mCTCtcW4KSQdxHat+tllEpF9fkkltuFuDDc9oxJkn9Fhcpp7D2gKk3Dz3++KvKNlyAaf+bt/W1xRdTj2VbhaGxHG7noo1gZ+L5FPp2INj4swtZvIpFro88QcugRZ0aP1fF/Hh9KvhjofaS0KhgSCeKgzjJjofgWvXZBI7+eU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(136003)(396003)(346002)(39860400002)(376002)(38070700005)(122000001)(83380400001)(38100700002)(54906003)(316002)(71200400001)(5660300002)(8936002)(91956017)(76116006)(8676002)(7416002)(4326008)(66556008)(64756008)(2616005)(66446008)(6512007)(66946007)(66476007)(6486002)(478600001)(6506007)(53546011)(41300700001)(2906002)(33656002)(6916009)(36756003)(186003)(86362001)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ye2PAEKpC1hJhlzbLgQZ6omisXH+ekfcvWF0ylWBohG1fbUd0mo5XR0QFpUi?=
 =?us-ascii?Q?oNCZmz1cEfaR7BEaTnLIlQSvWxYkdqTzoCSy0/oyWiDhlJuSIOJXtWv4mguJ?=
 =?us-ascii?Q?lbolJqm6HQyTkYYVt5UOjjLdjz2GuhM8HaX9iOz+6mH/z72M4uOhqY3FZO3S?=
 =?us-ascii?Q?b1J8Q8LuCm0YaGKFqKTn0Q/8BADVAt9LoRhwJrPmVUNlX5BsiRLGhJrZmqsd?=
 =?us-ascii?Q?fcM8kOENVJSJbe2b3+afyOtztPiqvwSEiGKV8WRMxTBeBRkpyozza6KP/JuR?=
 =?us-ascii?Q?2Y8NeQbB7axoGNxC/cXjkxor/ieJSy9Y5zHeRcuYhpwt4XNptydVejmNTOdG?=
 =?us-ascii?Q?yGR3DxsCAC9tJeg328gdB1MYmK8kgslJBhpHZX+PDIG0eelJr0QnU6eAPAW7?=
 =?us-ascii?Q?6Mzue3HJkZVC21gdEFVGtNGqaYq7VMLU8Naez7ZDtZMtWlCzIxhum5DQEE+J?=
 =?us-ascii?Q?d78QQlxWHc+2a2BWO2JSRWOAf7yqAlZmSd7FX6t4XqaPKItdZj+/2Oqbx3jP?=
 =?us-ascii?Q?WsJEj1XCU95fk4n1xrnKly7N9uFpwQ9qXgoF27r5ElRlXpdimlJgCcL358EW?=
 =?us-ascii?Q?TJTvYRNswxy+CiJ2BO7ay2yIMCpd8FrjsPUV2CA/ZIG+FZ5UYhx+Q7tDyWad?=
 =?us-ascii?Q?jy2V4hRjhatb3U7f2Kz+iRUxaklq4fjtczlzACwJj213mMXzRK9dCA4iMLAr?=
 =?us-ascii?Q?t3f5SJI1qLNDstGdJ4CcRiRg7ZQ55rfnjLmP9YykwVOokin88rvkWrc5rXAV?=
 =?us-ascii?Q?68nsEjRBjyr2CzI8/U0nEDrKGG8+5/fnmvhJnexFe+Bm6DMA9ZI8u5Zu+A/Y?=
 =?us-ascii?Q?0sumIoxeCRePL921kYmVuZ7Gr+ZVnzC/+EBZD0rNKRW5iRY4G7l0UzkgCjUG?=
 =?us-ascii?Q?DfNpuDCoWT7RE5JSVpBqYJ9AYp1xWzLJEvv7ZYUAHX6ILkz/BRuTC2QeImuY?=
 =?us-ascii?Q?gR+cRyZBilWqrnlG/XMtueDM8zBP2rvP6ka1/Ke67f6KO83eI218kAR11D6M?=
 =?us-ascii?Q?vLwoFbVw2EqAN2AZFI+g5Gs/8C5KiWxZ5znrC4igPQbuF2r94naYx3GbrSYL?=
 =?us-ascii?Q?nnntdu9mpRYjUtPj6Zs9JIEImKaYuP/lnuSoxcGE1BlW+/RjwAXC4snQcjI5?=
 =?us-ascii?Q?v5M/sUmIKPp13qa8oL+kWekKGK7fxBQ/jGo4EagShWgjYbE3QFDPhojth7Kk?=
 =?us-ascii?Q?G8k/PvP6lCwOUdvfPuL7bqgIV+8wKQgOTK6cRKUNFJlend3VGvPer3vPExTL?=
 =?us-ascii?Q?dnEiWixGX4ExUz+Inte1zb4/655PF6OJkaB9jk55hq4EkAfcXcZ+I5JPyRiQ?=
 =?us-ascii?Q?PhFicMIEdqppEgi7izFA4HlcS15iE3rBtAUxzsOTC5RPfWskffRhqvyj42YF?=
 =?us-ascii?Q?zKPYn/GMlIk3XFQJsqAqgnNEde4vA1OIY+rSwV1B0wR0aALCJ47ZnklGSYdG?=
 =?us-ascii?Q?IdNgSGmloEMWbO+JQFk39vZBJGXrVHET6UXyrVV6r3NWlqEpv3r6G29IC71z?=
 =?us-ascii?Q?os74XyvPiwietfjN4hKZXa7dcpJ/OXEaRKKnaIuI1V/C95yyuENp3cCT6HGh?=
 =?us-ascii?Q?RxLbkr7FGV/ch1OBUkk3TByVKMOAarnHxInk17Rp2HdNvAcOKeE/j+e7Ve9A?=
 =?us-ascii?Q?mCfzvS+zNLl60P5eE3fW1eQ=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1DD1D6FE5341A24CBC15BE93C3995DD4@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83df15a3-2414-4913-1e99-08da5f998df9
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jul 2022 21:50:34.2582
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6TgFhub6/qBJfrGLBNtWMhNqerbMeF/U+i936YiXS+5dWVnVb5ODUszX1/pDgGbVwpS+alilgr/QGXahwDMRsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1245
X-Proofpoint-GUID: 4sC_hQA7t8i-3fI8jqcPMwxODdk8iaQx
X-Proofpoint-ORIG-GUID: 4sC_hQA7t8i-3fI8jqcPMwxODdk8iaQx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-06_12,2022-06-28_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jul 6, 2022, at 2:40 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> On Wed, 6 Jul 2022 21:37:52 +0000
> Song Liu <songliubraving@fb.com> wrote:
> 
>>> Can you comment here that returning -EAGAIN will not cause this to repeat.
>>> That it will change things where the next try will not return -EGAIN?  
>> 
>> Hmm.. this is not the guarantee here. This conflict is a real race condition 
>> that an IPMODIFY function (i.e. livepatch) is being registered at the same time 
>> when something else, for example bpftrace, is updating the BPF trampoline. 
>> 
>> This EAGAIN will propagate to the user of the IPMODIFY function (i.e. livepatch),
>> and we need to retry there. In the case of livepatch, the retry is initiated 
>> from user space. 
> 
> We need to be careful here then. If there's a userspace application that
> runs at real-time and does a:
> 
> 	do {
> 		errno = 0;
> 		regsiter_bpf();
> 	} while (errno != -EAGAIN);
> 
> it could in theory preempt the owner of the lock and never make any
> progress.

We can probably workaround this with some trick on tr->indirect_call. However, 
I don't think this is a real concern from livepatch side. We have seen many 
other issues that cause live patch to fail and requires retry. This race 
condition in theory shouldn't cause real world issues. 

Thanks,
Song
