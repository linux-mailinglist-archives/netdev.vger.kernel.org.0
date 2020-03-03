Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EA23178528
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 23:01:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbgCCWBe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 17:01:34 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:43982 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725932AbgCCWBe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 17:01:34 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 023Lwtc5029467;
        Tue, 3 Mar 2020 14:01:18 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=174sRP3w6o7kVhtxFMc3j8DlHtrMAJsYyQjCVj3Wnus=;
 b=UdowaZ9/sk0zEnasB4WcgEefycwS3BoXqSesl0CaqDAh7K0T3Ix+uvWtRDOODD+bKoAp
 CtnsGS9tFAYFSmzohnsSYa1tfKfUPgj+aNDolatFkge/qlurQDbezY2h8ZTRMsFkK+Ah
 mQNsUJ2HktvvXmC1B16jPD9gJqwgBvRgj9A= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2yhpfwkarc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 03 Mar 2020 14:01:17 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Tue, 3 Mar 2020 14:01:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YO5E0WouidVtEr7/sVyP4vvl37X289kCSdA+acxSqyVTIObRPXC6hhbS1Kv1IAoUPKkReDNEvLhs+0H9uzjnOR02IvPLMhg3cYgv4zKasDGQLvY5Qf36mCTAaEuBxKO8ZvwZS2dnaCzo8nKgqN3PsthhMn5Ug5ZpWj9dhFttDyMgGoDsBY3ZPcOYVx2v2uP/RH7VmxoxqgqS4UZ2eYjeat4iR0Qaflc6vkjDb5JgbzhoT+L/k8M2cxBkJgkS62AxJ1uLlVllaC7pPDD0ol8qOuheJzEeqGKOGi0O1Qg6R4oFdUj5+8O+r9N+i+a6u7ZpQ8ti6UG55flrKM6zYxyTlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=174sRP3w6o7kVhtxFMc3j8DlHtrMAJsYyQjCVj3Wnus=;
 b=ghM9TXR6JRYSjNKZOt0nxL/vSOC6o2eScWahP6HtF1+q+PsDy123XepId1gzTJSnfL6grzVXJL+KsHLMmkdV7XfsCK+FlPzT4a7LKFgpD86E/UCsHqFHkP85wY4GBDy2BsrOwPv4+/DkL2t3eVBHZAEZx+HcHCMUZ1g9JSceiwQO2Z7apBxM1fit+e/7nvv2W9o0JSTeHU0I+Y8ey39jz2R+SSX2RHV7bkvVjOOJ5A1MepH1MqAn5EzhM42NP2pTIQ8+bdK9mJXKeckj4Sza7qgn6lHEcj4Yj4SP6r51jB4dKE3T6A5I2zY4MjskxK1B65FsPKlGjKlUxpXTzzS0pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=174sRP3w6o7kVhtxFMc3j8DlHtrMAJsYyQjCVj3Wnus=;
 b=Tm47h+YbKzRpR8+RXqGVL2uvmJJS19afybbQv7P6ePLmFkH/0ofmCqpiC5BKFZGnLZ32b6uf4MgVs1CdeSDSg+3Sn/MQTiWgrpgNFHixpF2t/aWvGARfrGH/xRh9VF7/W0xd74SBRZq3sLRKx17Dl30cEUJkiK5ml/RSUxrvSHw=
Received: from BYAPR15MB2232.namprd15.prod.outlook.com (2603:10b6:a02:89::31)
 by BYAPR15MB2680.namprd15.prod.outlook.com (2603:10b6:a03:155::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.15; Tue, 3 Mar
 2020 22:01:12 +0000
Received: from BYAPR15MB2232.namprd15.prod.outlook.com
 ([fe80::6536:60f4:3846:e5c0]) by BYAPR15MB2232.namprd15.prod.outlook.com
 ([fe80::6536:60f4:3846:e5c0%5]) with mapi id 15.20.2772.019; Tue, 3 Mar 2020
 22:01:12 +0000
Subject: Re: [PATCH bpf-next 0/3] Introduce pinnable bpf_link kernel
 abstraction
To:     Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
References: <20200228223948.360936-1-andriin@fb.com> <87mu8zt6a8.fsf@toke.dk>
 <CAEf4BzZGn9FcUdEOSR_ouqSNvzY2AdJA=8ffMV5mTmJQS-10VA@mail.gmail.com>
 <87imjms8cm.fsf@toke.dk> <094a8c0f-d781-d2a2-d4cd-721b20d75edd@iogearbox.net>
 <e9a4351a-4cf9-120a-1ae1-94a707a6217f@fb.com>
 <8083c916-ac2c-8ce0-2286-4ea40578c47f@iogearbox.net>
 <CAEf4BzbokCJN33Nw_kg82sO=xppXnKWEncGTWCTB9vGCmLB6pw@mail.gmail.com>
 <87pndt4268.fsf@toke.dk> <ab2f98f6-c712-d8a2-1fd3-b39abbaa9f64@iogearbox.net>
From:   Alexei Starovoitov <ast@fb.com>
Message-ID: <ccbc1e49-45c1-858b-1ad5-ee503e0497f2@fb.com>
Date:   Tue, 3 Mar 2020 14:01:09 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
In-Reply-To: <ab2f98f6-c712-d8a2-1fd3-b39abbaa9f64@iogearbox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR1701CA0017.namprd17.prod.outlook.com
 (2603:10b6:301:14::27) To BYAPR15MB2232.namprd15.prod.outlook.com
 (2603:10b6:a02:89::31)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c083:1309:77:d9e:39cc:ea0d] (2620:10d:c090:500::4:a0de) by MWHPR1701CA0017.namprd17.prod.outlook.com (2603:10b6:301:14::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.15 via Frontend Transport; Tue, 3 Mar 2020 22:01:11 +0000
X-Originating-IP: [2620:10d:c090:500::4:a0de]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 57af3c55-69fe-4a2a-bf0a-08d7bfbe62d3
X-MS-TrafficTypeDiagnostic: BYAPR15MB2680:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2680E3D52B15994345BE1CCCD7E40@BYAPR15MB2680.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 03319F6FEF
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(346002)(396003)(366004)(136003)(376002)(39860400002)(199004)(189003)(66556008)(2906002)(8936002)(4326008)(186003)(16526019)(81156014)(66476007)(53546011)(8676002)(478600001)(81166006)(66946007)(52116002)(54906003)(316002)(110136005)(6486002)(2616005)(31686004)(86362001)(36756003)(5660300002)(31696002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2680;H:BYAPR15MB2232.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UzOilk/4Q79FfNs+ULWgtBaKiygk+qHH4xG6c2uX++bJCebe2PRMv+dk75lxybwOtlielr/Fk7Exmrgj+xgVwOHzmqqgenF4dW15kokM9UA05tUdy+KNCaMwqAvWbbPIMKGveOUVh6uLev/FeQmqnNpTx8wbN87JlvVW104Tnp3zVP83Mu9YvVlxpjVOf1wC081SYsw6Z8fM7Ar7CytvWrL5MnjVQsShwx40TVTeKoyg+7mt6K6XjpczdPc4NrvGCn3EDrT/oesSNaCL+k3zOaTnY1OZ1pc3iegam/CbuLI7kxHRuiQzKRue9mtoCWokIp0ydl5v7wHl/R23A9k7ja4T+Pa0b/M36b5FuukhomqiAY/k3/8NokOhEUHqA2dvQmdB1bXeYCd3DhUz8aVU4zIV79ujXRevJh5mkaAkP+wGN8srY9Fg2qTkmNL5Udjg
X-MS-Exchange-AntiSpam-MessageData: taTFXJWHQa/BRgyrkqE4W2Lml81yxfBEcqmpoM1tTsjW2zkDwe8yAIMUkD5KyuL2RGwXowQ5Wyl1T3ZPN/mbfnReXyYvbwFTTiHUA5yJHn/UeZQA7f30tU8VgtkYaDk4sYDSh75YMEzz83wY0QFePYc/YxMEy6LR4DCH6CfIpDKhgfRMa6y/mgYi5W1vb2BE
X-MS-Exchange-CrossTenant-Network-Message-Id: 57af3c55-69fe-4a2a-bf0a-08d7bfbe62d3
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2020 22:01:12.0139
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +BgZcHbuICLX9uy6pcawnTJzB5x9URQ0mQuJJJtoa9iJQhzqZypLVNj6ragXShWf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2680
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-03_07:2020-03-03,2020-03-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 mlxscore=0 clxscore=1015 priorityscore=1501 lowpriorityscore=0 spamscore=0
 adultscore=0 phishscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003030141
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/3/20 12:53 PM, Daniel Borkmann wrote:
> 
> I think it depends on the environment, and yes, whether the orchestrator
> of those progs controls the host [networking] as in case of Cilium. We
> actually had cases where a large user in prod was accidentally removing
> the Cilium k8s daemon set (and hence the user space agent as well) and only
> noticed 1hrs later since everything just kept running in the data path as
> expected w/o causing them an outage. So I think both attachment semantics
> have pros and cons. ;)

of course. that's why there is pinning of FD-based links.
There are cases where pinning is useful and there are cases where
pinning will cause outages.
During app restart temporary pinning might be useful too.

> But then are you also expecting that netlink requests which drop that tc
> filter that holds this BPF prog would get rejected given it has a bpf_link,
> is active & pinned and traffic goes through? If not the case, then what
> would be the point? If it is the case, then this seems rather complex to
> realize for rather little gain given there are two uapi interfaces (bpf,
> tc/netlink) which then mess around with the same underlying object in
> different ways.

Legacy api for tc, xdp, cgroup will not be able to override FD-based
link. For TC it's easy. cls-bpf allows multi-prog, so netlink
adding/removing progs will not be able to touch progs that are
attached via FD-based link.
Same thing for cgroups. FD-based link will be similar to 'multi' mode.
The owner of the link has a guarantee that their program will
stay attached to cgroup.
XDP is also easy. Since it has only one prog. Attaching FD-based link
will prevent netlink from overriding it.
This way the rootlet prog installed by libxdp (let's find a better name
for it) will stay attached. libxdp can choose to pin it in some libxdp
specific location, so other libxdp-enabled applications can find it
in the same location, detach, replace, modify, but random app that
wants to hack an xdp prog won't be able to mess with it.
We didn't come up with these design choices overnight. It came from
hard lessons learned while deploying xdp, tc and cgroup in production.
Legacy apis will not be deprecated, of course.
