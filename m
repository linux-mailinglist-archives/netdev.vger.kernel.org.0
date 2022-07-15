Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22A795759B2
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 04:50:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240663AbiGOCuN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 22:50:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232744AbiGOCuL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 22:50:11 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4B0E3192C;
        Thu, 14 Jul 2022 19:50:10 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26ENcYcl000688;
        Thu, 14 Jul 2022 19:50:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=99JuItuT8BIvNhZR5zzbUlf0FKzz+TuRLgCkWdK/BBM=;
 b=C9jc08+B4h01cSrwFwEcAxLUGGrdVh+M2TeO4x9RRqux8WH7CzZzXnM4QaadsyBjf905
 K8/iUHAnLNJjs5ZiQX5vHepsHEY34y+8j62LMiJ5ZUu/hdMPqC3ndilAwbOZKcwVDZXf
 CRi3wlr5ps1sHA6Z5ZMVIhCohbtswEVQT+U= 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2104.outbound.protection.outlook.com [104.47.58.104])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3havksgs56-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jul 2022 19:50:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I9oAPGFFFltWwWeTMEjBciR3witGNqQpEhbctfOGas3zAOfCZ7DJ6y92cxnQTtdAZpm9oihTnNrvtnaXmuk7SHhfQ6/GphHZAcni04UgOJyO9o9uJ85V2+Njh40zfeGgWuwUB25xo9X3ISTCwzpRMXSh2Q0Ped3u5dVv+aqL9JwOWAI3Mpc0iAfSbuk7LC2wakbtrErEIAinfBGsdyIFX2n8OupEGZFEKm5jJNqbxzA3Y1Qqrn19rQnW1VtIoniw7PMZC+SOXSxdu7a72u3gUSmY9tQBVtU6Dol6c84zU6RA+qcSeIkAOd4O1efTYUkNoSco6pIk3p/5IH8nz2lU5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=99JuItuT8BIvNhZR5zzbUlf0FKzz+TuRLgCkWdK/BBM=;
 b=OF4S+lxio37f3FkXhM4z/jSctNmSmS1vs+GS4O1GRe7L/7vL5sYsiZbj8pjynF3G+ndb3EgrMif+3W5R21G8Ne1627mq7jyjUFe4xQ/q2bR1ZuSRCJt59QfqjI0y3OMesWHWX4DJD4VTjLur77rXRSKSsZ/I1HTpz1/4hL3a6UUM5ZpQb6E0fjeah08/dvl2UJywZpUv19hQrjwjnfu2sJHqwiC3BL6+xtYaTnRQEXyvmiu9z+Ee4WF13LpyPonAGB1J35jJ89wuf22FZ2PW7s9IA8IKEyJTZZsiPWImTNRo5sjR14h8vmEkycT1RCSCrK8Bb/JHnp9zT9grA2a48g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by DM5PR15MB1465.namprd15.prod.outlook.com (2603:10b6:3:d2::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.14; Fri, 15 Jul
 2022 02:50:07 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::5de3:3999:66df:42d1]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::5de3:3999:66df:42d1%4]) with mapi id 15.20.5438.014; Fri, 15 Jul 2022
 02:50:07 +0000
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
Subject: Re: [PATCH v2 bpf-next 3/5] ftrace: introduce
 FTRACE_OPS_FL_SHARE_IPMODIFY
Thread-Topic: [PATCH v2 bpf-next 3/5] ftrace: introduce
 FTRACE_OPS_FL_SHARE_IPMODIFY
Thread-Index: AQHYdrjyXTiiEgEgK0K1BTZfHuJgSq19RUuAgAGMyICAAAmfgIAAFU+AgAALzACAAADvgA==
Date:   Fri, 15 Jul 2022 02:50:07 +0000
Message-ID: <170BE89A-101C-4B25-A664-5E47A902DB83@fb.com>
References: <20220602193706.2607681-1-song@kernel.org>
 <20220602193706.2607681-4-song@kernel.org>
 <20220713203343.4997eb71@rorschach.local.home>
 <AA1D9833-DF67-4AFD-815C-DD89AB57B3A2@fb.com>
 <20220714204817.2889e280@rorschach.local.home>
 <6A7EF1C7-471B-4652-99C1-87C72C223C59@fb.com>
 <20220714224646.62d49e36@rorschach.local.home>
In-Reply-To: <20220714224646.62d49e36@rorschach.local.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.100.31)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f9d94879-d386-4e05-44a1-08da660cba4d
x-ms-traffictypediagnostic: DM5PR15MB1465:EE_
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9kxt2pn2XvtQiJO1XeC58X8CD6nF+doRbt+k2XzuFnNN6Du+7WSzkLEVeS3ZwDU7kblfMYhP79pzUHYBdF4d6ycxV+stE/qBm2pe1WBvGarJCbgHLk9b3vFpPREvg7HZA7MxZOxp7YkMc7CCGReI7YUFWl6qfdnEUezDwlzpbEHifeRPdaEoZNGUciDLjR0G+WUaX4mgWFQ37ybanu22VmK/qxd457mGSzwGUNSW+EtNeFavWtK0re7ttmZJR51ij8/ayhNPEwUhygoOEE66gXrsQktEi6W2pgj4S0Wm/q5YQpRBxRvIl0lwUkQrtVrKP3qS5ksv0ZXZTguFXEW4D9WBJibYlg2ZUfJT5n4PtKv/xKq08tY3/N1UzNQI24H2Vys9ERXWBfp3LjqVA+ZSS8Tt+Pp/9T3KI/BLsUqMzijSB4iLBuvWPZRZ0BLsEOBy2usoHAJDDWQ2JnErx9wM+AYwd/E/jQ6LdMhORoBVJXA3T4dNGYdTnLzA+8v1HmC9o2p+czJapyQTzgh3XVFy9+1+ND2cVJwTp0DdJCpT0tyHzBga69oQtHbPxSHj+g7OkXyf5DF3+L6ITc9NllenV1+RMGLzFXpyO5quvg06b4F5NjZHegpy9hbQogy+NDAybeLyqOy5yerL0DB69zWWaQGbG8+BXHips2HxFyf7TKbctJEIkKGxosM7kVsJfphtpXy4x8QPC1HxfAyX5XLkf6EX6FuWC1ba2Iwnd409Yf0DO+xZfB+yh3LI5wRFy2fpMVAHe7zG0fT1VuVhcIqMiAJxY9yfgfV6sevZGIydBI5xxHj/dWHTmIXvCl3vDsVIVLH/1lqZ8JFL8spvTBZVr3U6yuIL2Xc4xbF2/uzUxZg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(366004)(39860400002)(396003)(346002)(376002)(5660300002)(8936002)(2906002)(6512007)(53546011)(6506007)(4744005)(8676002)(66556008)(66946007)(64756008)(66476007)(66446008)(91956017)(4326008)(76116006)(38070700005)(38100700002)(7416002)(36756003)(122000001)(33656002)(316002)(186003)(86362001)(54906003)(6916009)(71200400001)(478600001)(6486002)(41300700001)(2616005)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?x32inKYopflxjKUkkjv1DeAsyH+4X3yOiGJ5yIUAHrE6Hxamzj1G4yI1k6fz?=
 =?us-ascii?Q?6RCPq7Vc/GKdTwJcEsquE11NzThjp6Me/210iqWVXlF5u8BL6zmEAF83DtFA?=
 =?us-ascii?Q?Q3RfrdKRSaTe0uzKplgwVD5o53twdtsLugGPsc4cWfeaV4fzxXR3vO7RXYl2?=
 =?us-ascii?Q?Yl8Nsaq949IMXHtDUyGrzgc59c98t3k9Cu/rHbl6DlgJbvcYgxviXWZ328ok?=
 =?us-ascii?Q?IY/74531Zb04xuoUjpbvX2qoR0xwaOyFDeAB7Q6IDKdogtCZuhc9Ph72b5lZ?=
 =?us-ascii?Q?UeY7yYgBoZ53Z18fuO9W3GgeT2j5LdxWNZGM+TjDQBF6ThQ7hfDDY2WtkHkJ?=
 =?us-ascii?Q?2KxQhpbRtYgGAxd/8j8txZ6i07O74anmOz8AIBgoYFykTOCSbJe/sQP0R7xy?=
 =?us-ascii?Q?rvInNX6SA/iYFsuDIQOnmm/tUBj3Ac4xvKFgizv6vL63Uqj89xd9lXXpwd//?=
 =?us-ascii?Q?f7RAeLdCn4qfBIPt1H5LIG5f5Og5zGVrZtplsNAcvNiCu6nkfE48YcslRTYA?=
 =?us-ascii?Q?/Lps1mLvfLeZ6o6mZPv+zr35FonpmL5Lpngr8S7sFeG63fbjUTsM8hE6lGu3?=
 =?us-ascii?Q?3CkXhhIZcYMbyoY9xoOaVyF3w1CFZIuFW221oRFZboBlaPy8x6dqT0UaGuMp?=
 =?us-ascii?Q?6/Mu8TtDMmiuyf5Jk3FD/etfy9v3nmi7Q8JyLZeDYJONkWq7qj235f2VxDCO?=
 =?us-ascii?Q?gWJ33TTkJXxg14I5EFuMnml+8xuFVcnhUwc0BuQ+C1DbB+b+vP96y5ygUl+9?=
 =?us-ascii?Q?tkRQVy8Kd09eROQq4oqc3bHAgpH3mexYO+uuoeJiHQMWn0CHq0r099BJgu6j?=
 =?us-ascii?Q?CaMzUJBo3iORAjlkEb/SsoizS+wHQSPIbh3mSt/usi87KXuBgOl2Q7q35gzI?=
 =?us-ascii?Q?syrByvBJPi413mPl4YCuZpaLzIM+7Fat/HrI/XJSZ6b0dPtfzTjUCh9A+3yj?=
 =?us-ascii?Q?BfmyEdjYKiwtnxNEoCXLsFx4UaRgKWsAX7OKiHK8l5518msFXgliafLZQyVG?=
 =?us-ascii?Q?OrLq1lkL2z79NRYAGJkUdAyXRdLXh/XHPCpNgiNVhwTYotitkAWVIwwGB/H0?=
 =?us-ascii?Q?EzAHw6jQ6na3U75Pw/0rx9g7tOpDiF+DYltYVRYjdLpS+C9kv9qeBaVXkyU+?=
 =?us-ascii?Q?JrL5uBIYdChPZuMyYUfOthykUcJNZIzMfisORnpzXFTM9lzFif/rMZYsW2wX?=
 =?us-ascii?Q?SIYqz8NN/VDUbmJFwl/ksVVQCvNiY1b+VJylloFmRRNALss7oMU9ZuKfKwvX?=
 =?us-ascii?Q?o07RlnO3JWNxfNPoZpR69u90YPqdodOzPjCNEg0X3lPi4t4LtlBciYd1r3Fj?=
 =?us-ascii?Q?Hnz6OakZF4qtfJLqQTCq70z6xgzGvNYWyaDQ/RKRBQOkjJPCNIJWqkWHgZnE?=
 =?us-ascii?Q?MGwZEYeRCeHnUPKycMsDxtWzo942TFe/P/XEa3Eu9PWnAGnmOONoOXwrvIqy?=
 =?us-ascii?Q?5a4oBY774wXth+KklOvrG7cg9t1mACqdGFQZOre5jj2+k+O6iNGSLcXQlF3T?=
 =?us-ascii?Q?SbC5FquimIWD9lrKYtt5PBxpDZvsXm+bVREYt9sb+KUrcf5xvDb7+ahVtMxH?=
 =?us-ascii?Q?1SiKKoRpfHRdr5+4KTDVa5PXO1TMvgi67W/eew0Zwo4zp0YsIwlgHhx8fx2m?=
 =?us-ascii?Q?Wh1w4kmP6IR7eruer5M5sgk=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4A2339C06145954EBF7D2DB95ECC5BE4@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9d94879-d386-4e05-44a1-08da660cba4d
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jul 2022 02:50:07.7144
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: L7VBUtkuiuYtzVJon1MrcdgMY95Y1yM/OP4cJ5sZ9kpbCXgByzgSv/PsDDjhUnLKAJ7XQczO003h8BR9SynUdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1465
X-Proofpoint-ORIG-GUID: vLn4PDFCaJb9vMzG-r_PorTJzXRAylE6
X-Proofpoint-GUID: vLn4PDFCaJb9vMzG-r_PorTJzXRAylE6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-14_19,2022-07-14_01,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jul 14, 2022, at 7:46 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> On Fri, 15 Jul 2022 02:04:33 +0000
> Song Liu <songliubraving@fb.com> wrote:
> 
>>> What I'm suggesting is that a DIRECT ops will never set IPMODIFY.  
>> 
>> Aha, this the point I misunderstood. I thought DIRECT ops would always
>> set IPMODIFY (as it does now). 
> 
> My fault. I was probably not being clear when I was suggesting that
> DIRECT should *act* like an IPMODIFY, but never explicitly stated that
> it should not set the IPMODIFY flag.
> 
> The only reason it does today was to make it easy to act like an
> IPMODIFY (because it set the flag). But I'm now suggesting to get rid
> of that and just make DIRECT act like an IPMDOFIY as there can only be
> one of them on a function, but now we have some cases where DIRECT can
> work with IPMODIFY via the callbacks.

Thanks for the clarification. I think we are finally on the same page on
this. :)

Song
