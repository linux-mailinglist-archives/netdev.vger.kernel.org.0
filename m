Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F5964B1F3D
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 08:20:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344350AbiBKHUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 02:20:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230521AbiBKHUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 02:20:15 -0500
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B16B10E4;
        Thu, 10 Feb 2022 23:20:15 -0800 (PST)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21ANrJp3013617;
        Thu, 10 Feb 2022 23:19:59 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=facebook;
 bh=6/XUd8rJLIQAp8TUJb6sJc0DzlLFD0pZaNZKYxcp6Ng=;
 b=nzXtyynAJXfnVtNgxnXf75sYQ2gmMGNIPab66CIZD0y3qu8uEfDt33k1p9YUMORucz/2
 VsCYVRP6xp8Qa1sFnRzoTHuL9PNHHLf4BsU8y5VxsXHmrZ055PTtV9/m8HrYPoSbtjeE
 kW5fQglOUbj5Hm41n7LqXXw3UHMHWd4zZSw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3e58e1kyaq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 10 Feb 2022 23:19:59 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 10 Feb 2022 23:19:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HDEn4G62/ltY9ZfggNZKLu73MiL/9ibuqAg2Iggan7Jup6gbImG4r1yKx/J3G+mCb2xkYKYROLdS8n2fu0hn48h/G5ULFCir2BcuQaRoLLbG+wku4LK15j2lt6b9gXYOO3ohKd9pbkR1yI4wEGucvsJWcMmX3KOgbUFx6Zmz5sr7yFGRrdFQnARcnpZ4A8F15VDcYyZ/Ss8sApvOv3zhBLOQXA56eqVnGofmStV3x6R1zeVIjFvndi0k5BTd8rrSOkqUvPuyk1ZwtWoYk28bAMTXGV4qh/5nD4o+lFU629xA7LsNhIXeHHZZdNcPQZE24nxWkJMBKgU8F+2ZpJI7LQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s22ODws8rht+ZgxvNyRRRtDnfoHt33ZFRyRawikQ9WQ=;
 b=L8SmDIKm+8iZ1WUCMr/xQNdh4KZjsBAKi7nT04OwVBwxUVZow2rSaeFPbshBTr/oUdBF5tmEZjtBUat2ehCJnZEArXzEm5mkvlpy6xQN+MFBVociuqzQfBB9wHPWCZLLsBwqJ+i8VILmT3GEk4JFKY7TvApvlyH11O5o/lz0UOsK3gNHTk2japKX0j4GZxlPh+8apm2XkLKDdTpTcOSv3VwjRjVv0lMWVOG7BS0zvdTeoZjaeEuhhoJy7T/P9BLm900A3fnKcU7zMekZ7ZvwxkR0ur+636Sc+H3GXK0mY2Ab99jaC4e/1+GBNX9O7uS8BCL6fgE1E7prdVBD+c7D2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by BYAPR15MB3430.namprd15.prod.outlook.com (2603:10b6:a03:107::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.19; Fri, 11 Feb
 2022 07:19:56 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::7d65:13a6:9d7a:f311]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::7d65:13a6:9d7a:f311%6]) with mapi id 15.20.4975.015; Fri, 11 Feb 2022
 07:19:56 +0000
Date:   Thu, 10 Feb 2022 23:19:52 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
CC:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next v7 1/3] bpf: Add "live packet" mode for XDP in
 bpf_prog_run()
Message-ID: <20220211071952.t7e6shipuc5shblv@kafai-mbp.dhcp.thefacebook.com>
References: <20220107215438.321922-1-toke@redhat.com>
 <20220107215438.321922-2-toke@redhat.com>
 <CAADnVQ+uftgnRQa5nvG4FTJga_=_FMAGxuiPB3O=AFKfEdOg=A@mail.gmail.com>
 <87pmp28iwe.fsf@toke.dk>
 <CAADnVQLWjbm03-3NHYyEx98tWRN68LSaOd3R9fjJoHY5cYoEJg@mail.gmail.com>
 <87mtk67zfm.fsf@toke.dk>
 <20220109022448.bxgatdsx3obvipbu@ast-mbp.dhcp.thefacebook.com>
 <87ee5h852v.fsf@toke.dk>
 <CAADnVQLk6TLdA7EG8TKGHM_R93GgQf76J60PEJohjup8JaP+Xw@mail.gmail.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAADnVQLk6TLdA7EG8TKGHM_R93GgQf76J60PEJohjup8JaP+Xw@mail.gmail.com>
X-ClientProxiedBy: MW4PR04CA0170.namprd04.prod.outlook.com
 (2603:10b6:303:85::25) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e40b7284-c7cd-4a9c-533f-08d9ed2ee7f6
X-MS-TrafficTypeDiagnostic: BYAPR15MB3430:EE_
X-Microsoft-Antispam-PRVS: <BYAPR15MB3430E9F5E0FEE8E25E4A5EA2D5309@BYAPR15MB3430.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1ELN0JNo0O9ZA2zcxri3eSrxSyNX9tkWcw+Y28b4WgH1q/1pf3ELbRC6iNq+qRCvmbPGAH7nUzhF2oAyIjNM73yU1G5chNh0m0pPfP4CHRaPIFa9tnIAHk/xH7WaUEcWWL1/feOURr+9R99QVNzX2d+F2DI62UzqL/tYGnb1Pi4rtdK1kCCgkL+uR55slkMJOzJmvB8E76BWMxECT/oDz7K8RTR+ZApAZDYnk2MCatrE/gxUJ8o1HbDk84uI/y1a5fqb+wCw73m0ezGGlh4gN59aVfiSW7i5igzpsk1m02cWAt4UaVqnSCPnGJ8huhpnqvFp3O4+N8us/y49cbJRbOLhR1QpzSpP0gzxPNPl27W/yBjr+R+3C8im/tf6uPeuG+fel4cNrz6MnwUofRwbKNu832Xfrc/cAneV+vC1pcjphHQ6pTwDkRP3U90XO6yJYfBy9YEB6AMsLgccT9dSXJVRaZ6j0iPVEkzYmNt2yUckSKszWx1u/Esb87iwoP+/BHnvTr2W7gYhL22TKhy5Y8eS8TRizkqARF90Di+RHR+CRaRdM1GAo7261dO5+55+zPhUPyflQtQLOtyChxMen2puHFTG9NBMMVqGRWdmVJf3HSpHIvilOPnRrROxk3kderKM17W5erx/Gt3h0q1NWw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(5660300002)(6666004)(66556008)(9686003)(6506007)(86362001)(54906003)(66574015)(53546011)(52116002)(7416002)(38100700002)(6916009)(6512007)(2906002)(8676002)(6486002)(508600001)(186003)(8936002)(316002)(66476007)(4326008)(1076003)(83380400001)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?mGcCL5NGalpLO2sOMYj70McXQx3Dp/4QoVN7eNQFKd/wfUQo6NzxOZzas6?=
 =?iso-8859-1?Q?x4rX2GYqxV2l2JTQm5rBlgokEz5h/0h7hKs6NVArgZVUJYRgGGUVPF5atu?=
 =?iso-8859-1?Q?FVUNl5qpgv+Dx/nnn+z55L2GA9Y9cOLLUVNuWzItDWSFtYxAzN+LBWAvMl?=
 =?iso-8859-1?Q?2sLCamIINrw2Ay7XeoZNWpOkwrAJfw1DSZzBHoIqTmx7C6o1WLvSwI5Jg1?=
 =?iso-8859-1?Q?BUD836fKjbrbUk2s50Dlq1+PqHIVbsd2N+/1C1rZJqwknmw/7dX7uVIKPN?=
 =?iso-8859-1?Q?DSUgNDEhNKXj+vYEN0is0IeW79w0jqnma/cj4GSJBZiPhI4jNVQC+JCany?=
 =?iso-8859-1?Q?7uA0vacOzmujgkqB9pGs/CeddgyKbRmmjiFxmGdfHbzd9z9hOfTezfOB4G?=
 =?iso-8859-1?Q?dup2Kly+ZIpNS8P5lGRta+K7FmylrUR5kqn+r3QNWtHCrMxYWbiD9949Ut?=
 =?iso-8859-1?Q?HLTyh5GD5+Dui6SiJwxKd0abNT+HF8uXYXT8xWBvfcmQ3vZz41nImI+5Kw?=
 =?iso-8859-1?Q?kaE+JAPPSU1B7m4LNDAesItrZkO/NTNEifND2tK5+oKrLXD4RoZ8j8moYV?=
 =?iso-8859-1?Q?1VdQbbNZFPcgcTElCZLk1Q95+Ewy1xT5Leq7RHk7QeUIhveOUd+QtoZH5Z?=
 =?iso-8859-1?Q?eRL9TWJyg7ZpkRr3xZay25wB5Nper7acPcjfxJCU+pgLoTbEWemk9IKD2n?=
 =?iso-8859-1?Q?DxtkLUy4wK84My3RLf0me9pV/f06off9USJsmPGF9n7QtCHPbowO/tTfW7?=
 =?iso-8859-1?Q?1wU0A3eB6wnw6zSh918Zr4+HWJxKhdtD4mCedSZ0h1p+nptvAD2X2fJ6Og?=
 =?iso-8859-1?Q?F4GdnT7z2Zqgz/hRM1aYA03HcdYkHnTC/eU758IBaMULXzs2y7h2UJtSxO?=
 =?iso-8859-1?Q?tLS/Y/gxu4yx19Vh+jzTWPEtQoayT/MLlBoEr7NfUp5CD/JSygdTq6gSov?=
 =?iso-8859-1?Q?Jay3w5JxY+y6rk6ivLvlSOqqPZfCkFECApZtorJSXmugWcmaZx9INqE/AV?=
 =?iso-8859-1?Q?BNshxaGOCzp4sOsbx+8eBDY5Eco51WKu+KdhJOR+5pfRfDyg8JDq7rpJ/P?=
 =?iso-8859-1?Q?8kExMY/9dVLxij6cpHgkb69eE3VSBkywtU89oFQB30xtxtx5ep6Y6DDqD5?=
 =?iso-8859-1?Q?DuDEnTcSp+7fzafMhOb0lYFD+10qxXTmNXZceyuIFlURScZ9YRppJ5eok2?=
 =?iso-8859-1?Q?L04BNp7GZgpn10EXI/6f6sWUSI8ugJRc4RblVF6D1J/G6ls5/8+AunW5cq?=
 =?iso-8859-1?Q?2Oil0DhD35ZwLKyfv/plq8OIkYMjnestBC9XZbcyx+Z/z77ZwcZkkmGd+H?=
 =?iso-8859-1?Q?MuFA17fWIE+Jip61GDzYfG8oawK2Tryp5eTWvk0Rgfq1lS99+yzxxJUxPj?=
 =?iso-8859-1?Q?DZlEPgUK/u8Zdu/tHGMKNcrNjAt/3Dwlw8WEYSkU3WI3BnNMr+2hBfQK/J?=
 =?iso-8859-1?Q?9okw1HMphvRT188ho42RtFoVC+NUfwcKeakU4ovcz3AA90TupTWZsc38XQ?=
 =?iso-8859-1?Q?Nya28ZFwzWAyjIe9n+SOGueLVGsiSi9f6UtBYknsawFXSsKY99LaKGiC24?=
 =?iso-8859-1?Q?znNKk15rUXty3/wp4ICCbUnZu7mVog2OdQ5uVY4bLelWChOq78QlLtF7mL?=
 =?iso-8859-1?Q?9aDqmQK8y1KgfQXXxH333AKGiQExBIwZVY?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e40b7284-c7cd-4a9c-533f-08d9ed2ee7f6
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2022 07:19:56.8250
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ruWsIquiiZlI4dIJROavWJmmQjd63KTzGtDKKe+fqk7FHL6ONszIScPqoDsjIEsx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3430
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: vjY_z1-xBRDDQxkFl28tNqG8PT88uquD
X-Proofpoint-ORIG-GUID: vjY_z1-xBRDDQxkFl28tNqG8PT88uquD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-11_02,2022-02-09_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 phishscore=0
 malwarescore=0 clxscore=1011 bulkscore=0 mlxlogscore=516 impostorscore=0
 mlxscore=0 lowpriorityscore=0 adultscore=0 suspectscore=0
 priorityscore=1501 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2202110041
X-FB-Internal: deliver
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 12, 2022 at 05:37:54PM -0800, Alexei Starovoitov wrote:
> On Sun, Jan 9, 2022 at 4:30 AM Toke Høiland-Jørgensen <toke@redhat.com> wrote:
> >
> > I left that out on purpose: I feel it's exposing an internal
> > implementation detail as UAPI (as you said). And I'm not convinced it
> > really needed (or helpful) - see below.
> 
> It's irrelevant whether it's documented or not.
> Once this implementation detail is being relied upon
> by user space it becomes an undocumented uapi that we cannot change.
> 
> > I'll try implementing a TCP stream mode in xdp_trafficgen just to make
> > sure I'm not missing something. But I believe that sending out a stream
> > of packets that looks like a coherent TCP stream should be simple
> > enough, at least. Dealing with the full handshake + CWND control loop
> > will be harder, though, and right now I think it'll require multiple
> > trips back to userspace.
> 
> The patch set looks very close to being able to do such TCP streaming.
> Let's make sure nothing is missing from API before we land it.
Hi Toke,  I am also looking at ways to blast tcp packets by using
bpf to overcome the pktgen udp-only limitation.
Are you planning to respin with a TCP stream mode in xdp_trafficgen ?
Thanks !
