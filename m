Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 589061BD4B7
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 08:35:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726511AbgD2GfI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 02:35:08 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:4628 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726381AbgD2GfH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 02:35:07 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03T6Yp3N002627;
        Tue, 28 Apr 2020 23:34:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=ditRo9+BX09/ExBgnQVKU1yvBOOWK9K1i9cc5TgytUw=;
 b=cOA49fgz5AqEnPnbCCnzKclV88DxYal1lYqjnsJ0Qrn62Qrsp1tDEne3TfSukq1Pho6Z
 5n1SuBD1Phb+yHLh2tQw5EDl+7Gs3T9rXKokCmqSEs1tnIZmJ8pNWPB5p2dp5GdCWNS2
 uzuvrOt4Oe46LuSrotCN4MnT3zDw5ZHsJ20= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30mjqnhfmr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 28 Apr 2020 23:34:53 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 28 Apr 2020 23:34:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HNzPAscgfeapgbve27EW6lzp+8qmot+UrkT0ekvFdWQOz0VhMdhl9cQXB0oUhDVUvMbh0zQPsP7fJfhyODIDySDBQAiMpi0MCinpjXhOBlk8Rhe4lmZvmTagczQKS8b9jorMRBV4nNfoZh6qqucAkwo19OUuGoUHaU74qEC5tDUOHqmosV5qXPXBm53GL2jn57cayFxOhCMt3NqXgZ4bX40ibzv01Hm8oeIU/sRW9/kys2RUR+U5BpJGCU/ZUVEd20oFegKH3cbKmNUF/yBZ+FXFleCPOFe6UCvksvNauccqYU8drM+sl4O1PRoroacimI2X9nYH+/PsPmHplc2lKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ditRo9+BX09/ExBgnQVKU1yvBOOWK9K1i9cc5TgytUw=;
 b=emca+/o6BTCv4lNbKwAFpOlPs4nqg4Q/HE7HPbosM/4Zct1sIC1TtbMXgMXrgBEkY0qcWR8PCnXAEsJhFmDD8V/QJ2QBZ8NEwVV38UvDJ84YMiyoZfkhttTRgJpG0/z144x7Y0SogHRQRQSiUIlo00LBa2scAl5mDzVkGv8OEYcPJ7FlQlVVVgD8zj6yenaE7AbgdRlkkwxXIvVcN/T0u15MoZdp8WySUTNT9yRo0iD4qBWHKXuJa9IilfU2v4QRY14IibYzc2xXPRbIo8TPTvdWm4xiGgwQIQjjTsN7U0d4ys/gDg5DNe/kdfiYVZPXnU3Gk9q5NvO5SMZ7SY8ICg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ditRo9+BX09/ExBgnQVKU1yvBOOWK9K1i9cc5TgytUw=;
 b=Ag4XJa9U+3b+acofAvHBzqQ4JUwBychNRQ7LW1F4ze1Cg4Of2FEIuDUuvGMfEVJRlnZyrZkJhIcAPwjsNqKw6tIufIXwR5SQcnvGkig/jzNlUYLw0rXt9wEhZVv3qRMYrVArPByelS0S4yueoGgUQD5FSyTcmCJpDZKKxv2AznE=
Received: from MW3PR15MB4044.namprd15.prod.outlook.com (2603:10b6:303:4b::24)
 by MW3PR15MB3948.namprd15.prod.outlook.com (2603:10b6:303:4b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Wed, 29 Apr
 2020 06:34:50 +0000
Received: from MW3PR15MB4044.namprd15.prod.outlook.com
 ([fe80::e5c5:aeff:ca99:aae0]) by MW3PR15MB4044.namprd15.prod.outlook.com
 ([fe80::e5c5:aeff:ca99:aae0%5]) with mapi id 15.20.2937.026; Wed, 29 Apr 2020
 06:34:50 +0000
Date:   Tue, 28 Apr 2020 23:34:48 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Yonghong Song <yhs@fb.com>
CC:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next v1 03/19] bpf: add bpf_map iterator
Message-ID: <20200429063448.fwqubjdz72uikpga@kafai-mbp>
References: <20200427201235.2994549-1-yhs@fb.com>
 <20200427201237.2994794-1-yhs@fb.com>
 <20200429003738.pv4flhdaxpg66wiv@kafai-mbp>
 <3df31c9a-2df7-d76a-5e54-b2cd48692883@fb.com>
 <a5255338-94e8-3f4b-518e-e7f7146f69f2@fb.com>
 <65a83b48-3965-5ae9-fafd-3e8836b03d2c@fb.com>
 <7f15274d-46dd-f43f-575e-26a40032f900@fb.com>
 <CAEf4BzaCVZem4O9eR9gBTO5c+PHy5zE8BdLD2Aa-PCLHC4ywRg@mail.gmail.com>
 <401b5bd2-dc43-4465-1232-34428a1b3e4e@fb.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <401b5bd2-dc43-4465-1232-34428a1b3e4e@fb.com>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: MWHPR01CA0027.prod.exchangelabs.com (2603:10b6:300:101::13)
 To MW3PR15MB4044.namprd15.prod.outlook.com (2603:10b6:303:4b::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:1f77) by MWHPR01CA0027.prod.exchangelabs.com (2603:10b6:300:101::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19 via Frontend Transport; Wed, 29 Apr 2020 06:34:49 +0000
X-Originating-IP: [2620:10d:c090:400::5:1f77]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: daee409d-d824-4a98-b3ec-08d7ec076b39
X-MS-TrafficTypeDiagnostic: MW3PR15MB3948:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW3PR15MB3948D3DC21CD1CDE03FC5B61D5AD0@MW3PR15MB3948.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 03883BD916
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR15MB4044.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(366004)(39860400002)(376002)(136003)(346002)(4326008)(8676002)(6636002)(8936002)(33716001)(6862004)(5660300002)(55016002)(1076003)(16526019)(66556008)(478600001)(66946007)(86362001)(186003)(2906002)(9686003)(66476007)(53546011)(6496006)(52116002)(316002)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l8gCXH1EF3W+akEaqCSOrb4RgFa445XwTSon3yzcxoxAI8T+JEvqEmZtNc07FRJN/KIEsEUeii1bV5Z8kjfyScUL7sONxrRku/Fxh6vJt+aiIhdr5aanyYu72sWKNrpccOYp/R+VIcIBIv4D3tMjuJrixThUPKXk3dYmKp6t71KkE0T7cG2wGm7EdrD431/caS1PO1c26BzTx4XTBG2ore1jypMyIXmk0uw6sSHp83DeKJ3mO3VGZ/UxOluLPfwYQp/UKRzLdeQ2eemuEeH++8d19J/5BMuEkRBvGAp2ZkHC71Xdn1GVKuVUwxOgMN2P6mo2SDxrEIfwium8ADnJmdrXO03zjUzvPe79j6yCYZCmRqYp5AzYhRiUrGcSJjP6pC5aovjBhHe4Y2qhFV/RrEMNC3FSJzXKMBa5w1tV5jSMu0PW4ehyjLxdxWZFmqCQ
X-MS-Exchange-AntiSpam-MessageData: yRL03ACYWNx6DfIKJKvIKKVaw1IkYwFUlLYkLX2rpxOghP7gbZIDhSosOZwhYXPfvPE/fOy3YRv1/JOaJ3BQu1FgXmNgi+vqEZJn2hCZj10KMGbRn/W6Xo6dUT5Caijn+jt3N2rkTo3Km1/3z/bcmmoP/ESYTDe5C26ea8iTnV/PDz/8muJz45tiRPHiIv3ka+Y+zPj4vf7QnrsMHwtngjCGFQcAAULAg+eFrRqWDpDbKtvJ8JZwldxxRDb/skXDtiH4+gEtcv6ehtj24Ngj5ixxVbdyzrllekEy55iuh5wzdl5ygDEzvw2EMHv1yjJFd9dhwdw2Uqnm/2UsvhGqYw0Ls8RD9waT9SgFwoxWuZdW5vpyP7stZuOQkK0eU/sZcEQwthkoZKNSw7aYpN4vaU2Yw9iIY/4RYPbCSsklJlpR1tNjy8UEc8q2vkjGDO2x7jBG3/ZVP3B2sreIe0HW0QZaFOYLbzrke6N4dnFScDzYLal4lFYUUCtfqSq9mXeedh8CBTnvVitJmngQ0P3dnZj546l1eYEz1XCrWcv3GEPQ0xIpp2jtY23qfZZwfUEPOLUKp324R4fw8hYCFo+d6GWYeyjq7zMj52YfrF6q/DRL+3hLUpIhfLw6dOA6KF4Um/fspBvNr6PyhzQYyKbTcq0+0X4r63bGHHvX68jDA7QnO3Eg+t1sBaNb1y0FtWtAwc2QLaqMU8fN4xFn8woiodTLFM7GOND1YQl2vYdXO7L0ezcgrziU1qaLCadhFc8htgg+CGF7k/qBl6HnVh1/CbOWZKhfjV7yN7DZvk0bKwT+9V5lf4KwyxU/YJxxQVV0SeawLFhNoAoFUUT4cdqKkg==
X-MS-Exchange-CrossTenant-Network-Message-Id: daee409d-d824-4a98-b3ec-08d7ec076b39
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2020 06:34:50.6065
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YzXYGREfTmwnwErdYu+TOS8DMatXYW8RM0n6eIsI4I8kWDLMD4694ztAyMmbQn+n
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3948
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-29_02:2020-04-28,2020-04-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 mlxscore=0 malwarescore=0 bulkscore=0 phishscore=0 clxscore=1015
 mlxlogscore=999 spamscore=0 lowpriorityscore=0 impostorscore=0
 suspectscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004290053
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 28, 2020 at 11:20:30PM -0700, Yonghong Song wrote:
> 
> 
> On 4/28/20 11:08 PM, Andrii Nakryiko wrote:
> > On Tue, Apr 28, 2020 at 10:10 PM Yonghong Song <yhs@fb.com> wrote:
> > > 
> > > 
> > > 
> > > On 4/28/20 7:44 PM, Alexei Starovoitov wrote:
> > > > On 4/28/20 6:15 PM, Yonghong Song wrote:
> > > > > 
> > > > > 
> > > > > On 4/28/20 5:48 PM, Alexei Starovoitov wrote:
> > > > > > On 4/28/20 5:37 PM, Martin KaFai Lau wrote:
> > > > > > > > +    prog = bpf_iter_get_prog(seq, sizeof(struct
> > > > > > > > bpf_iter_seq_map_info),
> > > > > > > > +                 &meta.session_id, &meta.seq_num,
> > > > > > > > +                 v == (void *)0);
> > > > > > >   From looking at seq_file.c, when will show() be called with "v ==
> > > > > > > NULL"?
> > > > > > > 
> > > > > > 
> > > > > > that v == NULL here and the whole verifier change just to allow NULL...
> > > > > > may be use seq_num as an indicator of the last elem instead?
> > > > > > Like seq_num with upper bit set to indicate that it's last?
> > > > > 
> > > > > We could. But then verifier won't have an easy way to verify that.
> > > > > For example, the above is expected:
> > > > > 
> > > > >        int prog(struct bpf_map *map, u64 seq_num) {
> > > > >           if (seq_num >> 63)
> > > > >             return 0;
> > > > >           ... map->id ...
> > > > >           ... map->user_cnt ...
> > > > >        }
> > > > > 
> > > > > But if user writes
> > > > > 
> > > > >        int prog(struct bpf_map *map, u64 seq_num) {
> > > > >            ... map->id ...
> > > > >            ... map->user_cnt ...
> > > > >        }
> > > > > 
> > > > > verifier won't be easy to conclude inproper map pointer tracing
> > > > > here and in the above map->id, map->user_cnt will cause
> > > > > exceptions and they will silently get value 0.
> > > > 
> > > > I mean always pass valid object pointer into the prog.
> > > > In above case 'map' will always be valid.
> > > > Consider prog that iterating all map elements.
> > > > It's weird that the prog would always need to do
> > > > if (map == 0)
> > > >     goto out;
> > > > even if it doesn't care about finding last.
> > > > All progs would have to have such extra 'if'.
> > > > If we always pass valid object than there is no need
> > > > for such extra checks inside the prog.
> > > > First and last element can be indicated via seq_num
> > > > or via another flag or via helper call like is_this_last_elem()
> > > > or something.
> > > 
> > > Okay, I see what you mean now. Basically this means
> > > seq_ops->next() should try to get/maintain next two elements,
> > 
> > What about the case when there are no elements to iterate to begin
> > with? In that case, we still need to call bpf_prog for (empty)
> > post-aggregation, but we have no valid element... For bpf_map
> > iteration we could have fake empty bpf_map that would be passed, but
> > I'm not sure it's applicable for any time of object (e.g., having a
> > fake task_struct is probably quite a bit more problematic?)...
> 
> Oh, yes, thanks for reminding me of this. I put a call to
> bpf_prog in seq_ops->stop() especially to handle no object
> case. In that case, seq_ops->start() will return NULL,
> seq_ops->next() won't be called, and then seq_ops->stop()
> is called. My earlier attempt tries to hook with next()
> and then find it not working in all cases.
> 
> > 
> > > otherwise, we won't know whether the one in seq_ops->show()
> > > is the last or not. 
I think "show()" is convoluted with "stop()/eof()".  Could "stop()/eof()"
be its own separate (and optional) bpf_prog which only does "stop()/eof()"?

> > > We could do it in newly implemented
> > > iterator bpf_map/task/task_file. Let me check how I could
> > > make existing seq_ops (ipv6_route/netlink) works with
> > > minimum changes.
