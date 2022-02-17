Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16E304BAA93
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 21:05:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245654AbiBQUFd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 15:05:33 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237756AbiBQUFc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 15:05:32 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E00654F8D;
        Thu, 17 Feb 2022 12:05:17 -0800 (PST)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21HHOWxM002959;
        Thu, 17 Feb 2022 12:05:17 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=OqGuImuRaMEZd5W0CraoNNCxmkjUelTvF5tT3I3/QX0=;
 b=SMcwNYD5eiNyrek3XS2x9ypB87D+8uoKPTWN3rCMMh7weGYwqhcO8Ta0j+VvIJi2/ZQ6
 23xZVg/OdBXVafmVIS2C2gROmDhB93fr0vJvBcgKZxH81Djg+XqUMUiHvYIMjNC0lqcE
 70+VZ8f2qV/HAyVd8TU/OWiHBPlSg09++fY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3e9g4y58xe-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 17 Feb 2022 12:05:16 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 17 Feb 2022 12:05:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=knLipYn5wgwi/j0bYIO8xOtmUaKTSrFmfL3Dn2362X453GTxBHSk9De3XwA7dfABH7lHhzkbpEvcz8/KxND9oT2OCWun/F//ju7KwFEB/3Rc4KfXwytuTdxxILLLbxIkeetJbYZJ487uoUvMexnUc6y+T43XDjTgVgsILEzF0J8bAeU5+pA6yHSbZyR+jD6tWopsNQG8Dc6gVAmu8Hni8zE2KU47ChrRiwJwzutwt2nwNqqibw7bZ4LYxTMsrlxnfactpRotnGaM0AE+iSOJhLgBU/vzgkurhQQiqklYe0Nfz+NxCM9J5itcDymapr+3ggnHRirNBQ5pBbr6ZKvxLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OqGuImuRaMEZd5W0CraoNNCxmkjUelTvF5tT3I3/QX0=;
 b=ekxw5lA5mwGCpGkjof8G7tBDJROPp9x385nYggU1hz1gi8RU5K2ruWWQntUo4gyeKb48OIo86ZTZG2iAqdNsRu9ydCj1jF40VGpMn5wgnXZ1ynqX+fwrCKchOjdikVeHr++OQnVQExHcJY37ilIVjArHvVnT8eTxomxqxo8vIJjHyvXZDdZ6Ff2fgApZ6p5mh8uaYpvwEJuy3yMFERll1mQ5uNUVZLSHVT43pUj/E3VuzInXc31it+lnum5cZLsAvXXwATQe6U1HAsop0c1aDSvMqHEgmiOxyj8Pm9uz+aCx0ttx/6VsSNntnorPhbdyclFtrBV2KPs5engduOQMzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by BN6PR15MB1187.namprd15.prod.outlook.com (2603:10b6:404:ed::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.19; Thu, 17 Feb
 2022 20:05:11 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::7da4:795a:91b8:fa54]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::7da4:795a:91b8:fa54%6]) with mapi id 15.20.4995.016; Thu, 17 Feb 2022
 20:05:11 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Aleksandr Nogikh <nogikh@google.com>
CC:     Song Liu <song@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
        syzbot <syzbot+2f649ec6d2eea1495a8f@syzkaller.appspotmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        "Jesper Dangaard Brouer" <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin Lau <kafai@fb.com>, KP Singh <kpsingh@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "syzkaller-bugs@googlegroups.com" <syzkaller-bugs@googlegroups.com>,
        Yonghong Song <yhs@fb.com>
Subject: Re: [syzbot] KASAN: vmalloc-out-of-bounds Read in bpf_jit_free
Thread-Topic: [syzbot] KASAN: vmalloc-out-of-bounds Read in bpf_jit_free
Thread-Index: AQHYIdMZmszE60+5XEqWDNWLJ01p1KyTuCKAgAByS4CAAT2VgIAAhjoAgABySACAAbVWgIAAGdaA
Date:   Thu, 17 Feb 2022 20:05:11 +0000
Message-ID: <2AB2B7C8-5F07-4D41-8CC3-04BE7C74DCCC@fb.com>
References: <00000000000073b3e805d7fed17e@google.com>
 <462fa505-25a8-fd3f-cc36-5860c6539664@iogearbox.net>
 <CAPhsuW6rPx3JqpPdQVdZN-YtZp1SbuW1j+SVNs48UVEYv68s1A@mail.gmail.com>
 <CAPhsuW5JhG07TYKKHRbNVtepOLjZ2ekibePyyqCwuzhH0YoP7Q@mail.gmail.com>
 <CANp29Y64wUeARFUn8Z0fjk7duxaZ3bJM2uGuVug_0ZmhGG_UTA@mail.gmail.com>
 <CAPhsuW6YOv_xjvknt_FPGwDhuCuG5s=7Xt1t-xL2+F6UKsJf-w@mail.gmail.com>
 <CANp29Y4YC_rSKAgkYTaPV1gcN4q4WeGMvs61P2wnMQEv=kiu8A@mail.gmail.com>
In-Reply-To: <CANp29Y4YC_rSKAgkYTaPV1gcN4q4WeGMvs61P2wnMQEv=kiu8A@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 90c41203-0b3d-4bd1-fdcc-08d9f250ce1b
x-ms-traffictypediagnostic: BN6PR15MB1187:EE_
x-microsoft-antispam-prvs: <BN6PR15MB1187C504A7AA7DE0FDB5BC15B3369@BN6PR15MB1187.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: e+in7FHjXklWvgnXBVf4GcE3FjDpLTZKH+eK6UIhNz7woE0vIwUAhS9CreLgLwR6TnOuF2G37m3YKCHxlnxzvivw6y2uTwhfDzkbtGYU8nhBOV5ejjEdkREiJiTM+OQqFlzPE+/U9iwOv/W1foq5lscbmhoGvFGK/SSNUYMPmLybmZBWfIto+Ca1QYSV4X38m6+GO/mdN5Meaw00vx7qkK/4hXo5Z2QtMx2PUKxlAgQrE5w176mEmlL1adWmEynqxjc0fsfEo8rbtwe7v9a6ucb1yO40Ai6Npq+FKZMkroISA731YjaPZgnr0J+9NrMY8hmW0+/WhjawpygWDlbxsgzOZ6/Bk51nt5X4GJSCF0LeIxqfJd/YniFjMbMzxev7fLysxgm5cy3UcPpl5cM4ZRA4AvFRdPXaw1OYQT//Bx8ygRd1r5L2+J8T6WHbqQndT1xhGLyHRGKhtMwiWY39PxVIGxD+hQkYzWFwsCeXrFM2GLGiNIKCAVXmjcW9TH6OyMKrJBFV4cfjIxt1XnuwMFwKZurUuTlGFgpxi99ST2C6c/h3RO2KXD/RzWoN5z5hl2di+FDiLpCZ8PSBfex6EZKb3wOJhLTzwTXOcVMg/H1TlYGjzdGu6tFQENII2sVtCZ9fuyCrygIjNKq/x26hn+E1aSWKSrI9vbOCQ+5tsgH9btyHoVWB/FZfovhk7ei9VwqxmldAKUYQl3ltUoeMxdzrTGCuIU939x9oPj1X9iVNMjdAGtVJln1+FPZVM+k2j8hBN+ZVZH4JnS+5ViEvIsz7KupLwV7/DPt9288HKT4VHK6Z/p068nhaJ4IPtDUA414pnbyRErukGPmb9qI7fm9gzlJP4cEjn0qz3DBpeHu+OlQXDaES0ChQ8+jEMu+ffREdHbgvQZ+xg0sw3oRAjw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(66556008)(86362001)(91956017)(83380400001)(76116006)(966005)(6486002)(33656002)(8676002)(66946007)(66476007)(64756008)(4326008)(36756003)(66446008)(316002)(6916009)(186003)(54906003)(7416002)(122000001)(2906002)(8936002)(2616005)(6506007)(53546011)(38070700005)(6512007)(5660300002)(71200400001)(38100700002)(99710200001)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?P/jMzYNYGTF6US2cNPEp4MwOwXhB9etAIvEROnz10poUfnmXh7qEvaakyAMN?=
 =?us-ascii?Q?gJGwm8Gg8FPXV5b5LZnkmx8RyAH2KnTJd4EqxiM1X9QaK0sDkG2+/kKoJjhx?=
 =?us-ascii?Q?+d5P1X5/Gq+2Pkvyr1piFI3tFnGzjx3EsLNfJzv/LwezYO285N9sUY3ndcFP?=
 =?us-ascii?Q?ieJTreAPUs5+wkOhc3mSzMFq3HJAbdRZFQNmv0+qOf4giN7yPWrjf3EYeC+w?=
 =?us-ascii?Q?NtKL/nEMXKqhTn9Uv/MIyUoi8UfsNL1yQ8yj1pmNUPd4La2vimX2K/xObHLB?=
 =?us-ascii?Q?OBWrRd/G9JoIfg99S5osmlCRB1sOvrHMaOvwXO3fkOqN+JQ/72BLiB0d6cOW?=
 =?us-ascii?Q?pJXobQuGRdiJZ1vGAJuS1+Kh06x0836LyLksfaBP04ulngnkBM07jA+41+UA?=
 =?us-ascii?Q?WHvalULDOgAyYe/ZNfdBuy3dPKK72kIrPbsiHf8vr0aQreEvUf1pHhCssTru?=
 =?us-ascii?Q?4+5QM8SG5PkNHnmqj85MCs4rIRF+iwbespwnA1yYhXl3EPjUvF70KWodtMd8?=
 =?us-ascii?Q?K6CBLpUson6aDa7t/rveNNWTji9BeEi+kDrgA1gKcF3KkkdK4MMIjpLGKkuP?=
 =?us-ascii?Q?PHJ5tJtIQmfKSnoy4AvS7EeiLkZWlAu6TqCE4sE6FRv3zq9saeSXmHGILD4n?=
 =?us-ascii?Q?c9Tm4VKaJbwqV+Xtg62RONetpchkCW7ppIRb6eB8HoyX+Dnj33FWmqMOoK8I?=
 =?us-ascii?Q?vrsfpY08qySmmZ9Yvxlfw1Tkf5aE/jeUsKUZetiCX2pOh5qY7jzVQ1yU6inF?=
 =?us-ascii?Q?s3IpJExF2YRKoD9dOgt+RYhmMzZP+t0vdF25K+8MWPhVXKJ/Q+/lvXwzgCsC?=
 =?us-ascii?Q?Y2Mid9o8SFUCfuJ8xVHLFEH46Da+HD3oPg6n2Jh3/d9KOFi7DmJR6oeabR10?=
 =?us-ascii?Q?gNAvROZDqWtycZxj4YBil65eUQlREUonPXHWGizsJsWU2rPIvPanaqXbo02T?=
 =?us-ascii?Q?/A+RuYAXmteGW43Ddl/J/LelElfpcD4nDd5KRxyxt2N5VteakxW32Czql2C6?=
 =?us-ascii?Q?fvcyL6765Rjlq1CZo2Lmstr/HOGImdAJRV6e9VBp6C7ANa0xd0X5Wv2m4H4U?=
 =?us-ascii?Q?pI+CiTQTXHWfbUbMyNte5O2FnUmzKjSIxvZ+pdgwAnvrayoGHqo/oquiA42t?=
 =?us-ascii?Q?bnHwGJyGMVSA43lD3QtG28am+jagGVnOS77ZJ1m1zEURHf2zC2bdHUa2lgdk?=
 =?us-ascii?Q?hA09VsXyrafjN0lYQ65cAIoFgPZ+qUn4j8uOLM+fulbhWuo7e7HuiTG5Fphp?=
 =?us-ascii?Q?m+N6aDlVmW8xJN4lLGQBa5I8P+C9itxWa2nxDRQK94yV5oQg5C/0m9rMjfAo?=
 =?us-ascii?Q?v6ueCOGHqD/ulC5dVVHPvYWXHyYQ9YkONj1VgDzTpk6wUvi502hoJ6Y+WZyX?=
 =?us-ascii?Q?nkCTVPAc0OrgxhZrNRNvz/Q/aIsixZviq6GeLgFc/U10E4Gmi0WOuBLNiGRm?=
 =?us-ascii?Q?bxZ/WrPR0miJOzuz/MM0gLs0mkj6qxNQd30eyvOH7gRHUOnbx6xF8Gp5r30x?=
 =?us-ascii?Q?kIS3u8IF19Iz8TLnEr5YiDHgW2s6z6+LYcDpUCZFRShqMhuVW35TDt9C6pWn?=
 =?us-ascii?Q?1oBhQhyLD1yQg8+WxjajWldrk5/8DMACldyf5/QHoStzahvUzop4ZFOu/00h?=
 =?us-ascii?Q?MdqSJ/RjaGV1Ks4mE7AuUo/hHlNDw6Pkm4YgzaIlh6yr+yYxQCw/z18SqmuZ?=
 =?us-ascii?Q?c+FlBg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <930988874630134E82733BC2CB78D595@namprd15.prod.outlook.com>
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90c41203-0b3d-4bd1-fdcc-08d9f250ce1b
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Feb 2022 20:05:11.8257
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: i4NNFl4ehIAngfpiKnz21Vhzt0X0IqeywyNsO/WlaC/FPaCJIR3hFx/MP07CuDKD6EXyGzjFbaw/FVccWHLlVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR15MB1187
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: PHZwyiaEnaWQLKYCCnRky1X9BRbdZcmP
X-Proofpoint-ORIG-GUID: PHZwyiaEnaWQLKYCCnRky1X9BRbdZcmP
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-17_07,2022-02-17_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 priorityscore=1501
 mlxlogscore=848 clxscore=1011 bulkscore=0 malwarescore=0 adultscore=0
 spamscore=0 impostorscore=0 lowpriorityscore=0 phishscore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202170094
X-FB-Internal: deliver
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Aleksandr,

> On Feb 17, 2022, at 10:32 AM, Aleksandr Nogikh <nogikh@google.com> wrote:
> 
> Hi Song,
> 
> On Wed, Feb 16, 2022 at 5:27 PM Song Liu <song@kernel.org> wrote:
>> 
>> Hi Aleksandr,
>> 
>> Thanks for your kind reply!
>> 
>> On Wed, Feb 16, 2022 at 1:38 AM Aleksandr Nogikh <nogikh@google.com> wrote:
>>> 
>>> Hi Song,
>>> 
>>> Is syzkaller not doing something you expect it to do with this config?
>> 
>> I fixed sshkey in the config, and added a suppression for hsr_node_get_first.
>> However, I haven't got a repro overnight.
> 
> Oh, that's unfortunately not a very reliable thing. The bug has so far
> happened only once on syzbot, so it must be pretty rare. Maybe you'll
> have more luck with your local setup :)
> 
> You can try to run syz-repro on the log file that is available on the
> syzbot dashboard:
> https://github.com/google/syzkaller/blob/master/tools/syz-repro/repro.go
> Syzbot has already done it and apparently failed to succeed, but this
> is also somewhat probabilistic, especially when the bug is due to some
> rare race condition. So trying it several times might help.
> 
> Also you might want to hack your local syzkaller copy a bit:
> https://github.com/google/syzkaller/blob/master/syz-manager/manager.go#L804
> Here you can drop the limit on the maximum number of repro attempts
> and make needLocalRepro only return true if crash.Title matches the
> title of this particular bug. With this change your local syzkaller
> instance won't waste time reproducing other bugs.
> 
> There's also a way to focus syzkaller on some specific kernel
> functions/source files:
> https://github.com/google/syzkaller/blob/master/pkg/mgrconfig/config.go#L125

Thanks for these tips!

After fixing some other things. I was able to reproduce one of the three
failures modes overnight and some related issues from fault injection. 
These errors gave me clue to fix the bug (or at least one of the bugs). 

I have a suggestions on the bug dashboard, like:

https://syzkaller.appspot.com/bug?id=86fa0212fb895a0d41fd1f1eecbeaee67191a4c9

It isn't obvious to me which image was used in the test. Maybe we can add
a link to the image or instructions to build the image? In this case, I
think the bug only triggers on some images, so testing with the exact image
is important.

Thanks again,
Song
