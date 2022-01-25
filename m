Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7D7449AA24
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 05:35:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356843AbiAYDec (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 22:34:32 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:38120 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S3412235AbiAYAgU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 19:36:20 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.1.2/8.16.1.2) with ESMTP id 20P0RTJs025814;
        Mon, 24 Jan 2022 16:35:33 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=5QFRWaTomNGn+DnKOTBCEpQ0T+ipCnRvEE/t9deysME=;
 b=H2wySkLICtON4zeIwrSeKTghUj5fbQe8rut+3g47YY/z8cNcC1g+fZaLArxi2HHCvPbO
 OIMbiJ1CMLvF69jqPIlLYbRC6ytKY5cZavqQTPO6fxi7FlGpgI/y+Dap6Nyv+vL5Xvo/
 ghaFVFjG3BAKTI7onsEpLhLZTxL57sOZ0Sk= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net (PPS) with ESMTPS id 3dsk2q73mt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 24 Jan 2022 16:35:32 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 24 Jan 2022 16:35:29 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aWXvNxminCwL+DTEkH8re5sWY57+xnOQi0cBrpzhhEdduTLV0cjJt2pVIneVBREwvobImYUq2+QShu9r0oLxbtJT7HsO6elZ09ufX8uzVw+2q/ql80hpexaQz5HQQF624f0ZBo0oa28/gwyF+y1nt8xZKGP2EM2R9HkKHzr6wahdolVhIX54KzJ5CMlu7WE89p74eT1v1kalTNCagEeKz65zbqEB+VQ7fmGtKpcWeoXsmeRrQw9EbhyeH0uQzanA4EfiJkyddMJT+PA53ROh9hxjtLhSaaXxt1JkTZC0SkL3TaBwH+1yCwB84Zyoc/TqzsZTiH2cPhx4Yxkpfh/yzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5QFRWaTomNGn+DnKOTBCEpQ0T+ipCnRvEE/t9deysME=;
 b=Kx/HpBjE38zg220raz/ZjeRjfwKXZAjudeAXs8trSYzB+UtTHzMkKdybIFpy8T4yUmPZDaO+/FNEDU4KSoc1vZ437KXjGQnJBcCmpURPIeoSU7ygDSlEI6CxI1QgfJxWjrPkBtyhLaafSoMmOhCYo8pi/4dKv8gK8vGNkVhBbEg8oZHN2WjC6Gxuxt1JGmkjNNTG8goIQeTYr7i8b7vCiI5KYN0CedPky/KwhC7SzYOXheozZ3a25/1tlC7Wknrdty/kvjWFcJ/I1JJ0sS7FXRqp4xjLbTmH+3TZM87xVDWjh8IY5YdUM2dt5N945pkb0CZfdVrazjiT+E+MngKKZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by BYAPR15MB2887.namprd15.prod.outlook.com (2603:10b6:a03:f9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.17; Tue, 25 Jan
 2022 00:35:27 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::b0ca:a63e:fb69:6437]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::b0ca:a63e:fb69:6437%6]) with mapi id 15.20.4909.017; Tue, 25 Jan 2022
 00:35:27 +0000
Date:   Mon, 24 Jan 2022 16:35:22 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Menglong Dong <menglong8.dong@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Jakub Sitnicki <jakub@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Mengen Sun <mengensun@tencent.com>, <flyingpeng@tencent.com>,
        <mungerjiang@tencent.com>, Menglong Dong <imagedong@tencent.com>
Subject: Re: [PATCH bpf-next] bpf: Add document for 'dst_port' of 'struct
 bpf_sock'
Message-ID: <20220125003522.dqbesxtfppoxcg2s@kafai-mbp.dhcp.thefacebook.com>
References: <20220113070245.791577-1-imagedong@tencent.com>
 <CAADnVQKNCqUzPJAjSHMFr-Ewwtv5Cs3UCQpthaKDTd+YNRWqqg@mail.gmail.com>
 <CADxym3bJZrcGHKH8=kKBkxh848dijAZ56n0fm_DvEh6Bbnrezg@mail.gmail.com>
 <20220120041754.scj3hsrxmwckl7pd@ast-mbp.dhcp.thefacebook.com>
 <CADxym3b-Q6LyjKqTFcrssK9dVJ8hL6QkMb0MzLyn64r4LS=xtw@mail.gmail.com>
 <CAADnVQKaaPKPkqYfhcM=YNCxodBL_ME6CMk3DPXF_Kq2zoyM=w@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAADnVQKaaPKPkqYfhcM=YNCxodBL_ME6CMk3DPXF_Kq2zoyM=w@mail.gmail.com>
X-ClientProxiedBy: BLAPR03CA0141.namprd03.prod.outlook.com
 (2603:10b6:208:32e::26) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 14857ee4-3985-409d-9612-08d9df9a952e
X-MS-TrafficTypeDiagnostic: BYAPR15MB2887:EE_
X-Microsoft-Antispam-PRVS: <BYAPR15MB28879B37B5DAE02DFC2C6FD7D55F9@BYAPR15MB2887.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +e4cGvn73QJXLG1+umBbBqqz+Msn/ycHbWcs3+MjXRTbZiLKwsZLanQ1YbVC0LoiVgTDE9Ur/gTfSC+n3yvNrfgPTDjYXFR1R28XgdRKnUpRkcS1lzrsWt5aBVVSSWzcH19IAba8UQgMoTVQNHhrMeUyYiZbBgXUJefvGadFOMEPJ7Y+4XhIOurITGPCfHZq5XAtzWQms01R8PBW8zRDV58/xMEZgAC+uwM/fBYxa1yhOVzHAMbv1RCHLPJxavQgZrwMlnc2VJb+m4SZCKRCWodv8zaRqtKHFb85aOroMkZNsgn9t5zgQXuTsVLXS8RhJj7f7AVmur1qecXJnRUIaW/fKJ485lWNYRAA76s6jVgEM0mZAzDZio5ZATY+RIV6l5lCOdtFSGaHdPIQygBpv56NVApdeby/yGv83jgiC8c/KO7SJY1AuNngrdc/ojKjtG7JMfvmUzZIvtMeLOTTkltltknt16HJaH2tOJczLA4WvvEifVOzgNKISrkpLPpXing4r1XdqEopQ3hzJc7umsqIdyFxFfzMTtZhuhhqKaOkCLCTyxC5Sgv3YQLY1CNqBOxVGQZ60lcTDx3CIacMgxk4Pm3Ml0OPUH5DU9RIeHYwIqVaY6BkuHvyznd1fC7xUQ93vvMdc46LrNM14d5nsQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38100700002)(54906003)(6666004)(7416002)(4326008)(6506007)(53546011)(2906002)(66946007)(86362001)(316002)(83380400001)(6512007)(9686003)(1076003)(508600001)(5660300002)(110136005)(52116002)(66556008)(6486002)(186003)(66476007)(8676002)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?f5UL7Rd52KCvv0QusOdnG9IREZl0NLV7PDGI+RxvMQQvb2H9TK6P8HB9cF4s?=
 =?us-ascii?Q?Z8voo8+m8wMWmQedzX1Utd+UGFek1Iv65A8qY8qcP+7f1aAL6xBOHdRQm8LC?=
 =?us-ascii?Q?1dcjCWdg7AG2/w54AtFSPhocX5JNEmv787Z30w14kqLi/PSQEgoKwlpZoQkm?=
 =?us-ascii?Q?Jut1o8sQKfTGMk7nkTZodwFnzlOax8fZ4qkoJKvDgxveXVrs0/O8rHVnKSwr?=
 =?us-ascii?Q?l4eCJA/ESdpibAjMaTu1H2sZIv3lxFke5iz97j8tw9HNg5GJINchA3PANPsp?=
 =?us-ascii?Q?4eBNqN1AFDgNhx1Fd2lLHZqRp1frvcAdVaayLLOyCACO99f7fyzh8caLj2Bs?=
 =?us-ascii?Q?N9YdxBAo0R6RsHl4T/B9pZtdN5HkwArjMrzHQiQj45t3cX0wqpN2XuXDT+b/?=
 =?us-ascii?Q?PLLYifAuRCNotOO8QNcyEmQPkgmh+VaSS1yFsZ4cjnrSjDQyewI6zoY17F7f?=
 =?us-ascii?Q?jBysNuONsRHfT1Lrqg+D0oxCQ6zYIptju7YswPspY7rxx1KPg337IPd5b7le?=
 =?us-ascii?Q?nnRD/7zRN3jeNBHP+6rj8R9G+F+SI11cu+c6n3Qh+EN9XsZ+9MxQ7Cec6zcv?=
 =?us-ascii?Q?aAalf4xnAs4tz6Afp7pt9/gydxQ3jGUrQffYYjuSynsgi62/8CK793m1QECR?=
 =?us-ascii?Q?RNdAbG07cIamXvnpEdIkzmJAV82ERZJpx0Uv3m9rnWflStHnr2fWgYVj0wC3?=
 =?us-ascii?Q?diUuUi9qJCi7cabyvOVOsPLXZXL7sIlQsVCUG5JTlp4a/MF3RKCbsz5xQAEX?=
 =?us-ascii?Q?pgMsRqOKfRFgWf++f2+/ZCN7XrgP6T9Z63ZmM/5fFmF0K7vXSGD86uOkycIp?=
 =?us-ascii?Q?g6g14h0WFuTzEqXORAswpnpbXWLFA70GAx6orQxUPd33Su7fBLzwl12i9bAj?=
 =?us-ascii?Q?KJ/hQkpuNnfcUNPGPFFCO2KcfWcTwgCjvD1P5eywYTUnxCTFWY8Is7f8gnoR?=
 =?us-ascii?Q?kJ0jlvG1cRVQlDMRsdo06xZ71vjv/tvjsN+hZTN/ZugR1OWYzqxhSR2QA/Kl?=
 =?us-ascii?Q?2uhCSN2sd5uu1JxQ+VTXdTGQm3B+pPcrkJ3kkbCb98JnWf4CsRPunRKcJS41?=
 =?us-ascii?Q?DWHugrnwx3KuBsBH0+EqT9rDsS2LROcSJaxFxUIgbEjsFEZLim3IO39WbFDQ?=
 =?us-ascii?Q?nKkfuX24XBqUgAKINW9vlkRz7HFTN5cQv0dK1ASuYCkwdiyTB2wyd3Xd9i3q?=
 =?us-ascii?Q?MxMpg1PnQwqNsUZwyl938sL6/HgBUg69Z3a9lGzOpha6klHYuCSIszwuPAVN?=
 =?us-ascii?Q?bNryil98U33vap+9FS6U+yPLgnuULOMcCukpmiBT9gvhGKI3ugw11Hf+HGqp?=
 =?us-ascii?Q?jSDhm4VQ8mVUQW8VfHHnpmfU6nyNruEkA2vTWPjul2gzBGaGj0PAqjpfEfAR?=
 =?us-ascii?Q?ucihzIgR/AaEtNEjPd7VPzeTuulToeFC3VxefWJrYKdB/9pKGEjXtNZgXPnp?=
 =?us-ascii?Q?bz3li+mQu/BlWRCNRX7d4crYoK0vFrp6EuayVJWf2YPwwEQZVylF37fyxnU9?=
 =?us-ascii?Q?yhabHqW/XDgiNKZkfdGHHdwt6XuIqGIgd4lZ/t8s7c60Aw3ME5Lh8tCh8hvL?=
 =?us-ascii?Q?Ye1pX2a94MjzZQSl8suE/gxhcb6VvAum6PLqbhBA?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 14857ee4-3985-409d-9612-08d9df9a952e
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2022 00:35:27.3107
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fUAAfqsMk/K2Qo8Fp01zIrTtmbYnspHhwPnDdTtoqkbMCB5V6cE1UPEAxK19muK4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2887
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: lYD258_-UuPoUYsME-gKjmyGNwxZzdL1
X-Proofpoint-ORIG-GUID: lYD258_-UuPoUYsME-gKjmyGNwxZzdL1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-24_10,2022-01-24_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 impostorscore=0
 spamscore=0 bulkscore=0 mlxscore=0 suspectscore=0 adultscore=0
 lowpriorityscore=0 clxscore=1011 malwarescore=0 mlxlogscore=999
 priorityscore=1501 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2201250001
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 20, 2022 at 09:17:27PM -0800, Alexei Starovoitov wrote:
> On Thu, Jan 20, 2022 at 6:18 AM Menglong Dong <menglong8.dong@gmail.com> wrote:
> >
> > On Thu, Jan 20, 2022 at 12:17 PM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > On Thu, Jan 20, 2022 at 11:02:27AM +0800, Menglong Dong wrote:
> > > > Hello!
> > > >
> > > > On Thu, Jan 20, 2022 at 6:03 AM Alexei Starovoitov
> > > > <alexei.starovoitov@gmail.com> wrote:
> > > > >
> > > > [...]
> > > > >
> > > > > Looks like
> > > > >  __sk_buff->remote_port
> > > > >  bpf_sock_ops->remote_port
> > > > >  sk_msg_md->remote_port
> > > > > are doing the right thing,
> > > > > but bpf_sock->dst_port is not correct?
> > > > >
> > > > > I think it's better to fix it,
> > > > > but probably need to consolidate it with
> > > > > convert_ctx_accesses() that deals with narrow access.
> > > > > I suspect reading u8 from three flavors of 'remote_port'
> > > > > won't be correct.
> > > >
> > > > What's the meaning of 'narrow access'? Do you mean to
> > > > make 'remote_port' u16? Or 'remote_port' should be made
> > > > accessible with u8? In fact, '*((u16 *)&skops->remote_port + 1)'
> > > > won't work, as it only is accessible with u32.
> > >
> > > u8 access to remote_port won't pass the verifier,
> > > but u8 access to dst_port will.
> > > Though it will return incorrect data.
> > > See how convert_ctx_accesses() handles narrow loads.
> > > I think we need to generalize it for different endian fields.
> >
> > Yeah, I understand narrower load in convert_ctx_accesses()
> > now. Seems u8 access to dst_port can't pass the verifier too,
> > which can be seen form bpf_sock_is_valid_access():
> >
> > $    switch (off) {
> > $    case offsetof(struct bpf_sock, state):
> > $    case offsetof(struct bpf_sock, family):
> > $    case offsetof(struct bpf_sock, type):
> > $    case offsetof(struct bpf_sock, protocol):
> > $    case offsetof(struct bpf_sock, dst_port):  // u8 access is not allowed
> > $    case offsetof(struct bpf_sock, src_port):
> > $    case offsetof(struct bpf_sock, rx_queue_mapping):
> > $    case bpf_ctx_range(struct bpf_sock, src_ip4):
> > $    case bpf_ctx_range_till(struct bpf_sock, src_ip6[0], src_ip6[3]):
> > $    case bpf_ctx_range(struct bpf_sock, dst_ip4):
> > $    case bpf_ctx_range_till(struct bpf_sock, dst_ip6[0], dst_ip6[3]):
> > $        bpf_ctx_record_field_size(info, size_default);
> > $        return bpf_ctx_narrow_access_ok(off, size, size_default);
> > $    }
> >
> > I'm still not sure what should we do now. Should we make all
> > remote_port and dst_port narrower accessable and endianness
> > right? For example the remote_port in struct bpf_sock_ops:
> >
> > --- a/net/core/filter.c
> > +++ b/net/core/filter.c
> > @@ -8414,6 +8414,7 @@ static bool sock_ops_is_valid_access(int off, int size,
> >                                 return false;
> >                         info->reg_type = PTR_TO_PACKET_END;
> >                         break;
> > +               case bpf_ctx_range(struct bpf_sock_ops, remote_port):
> 
> Ahh. bpf_sock_ops don't have it.
> But bpf_sk_lookup and sk_msg_md have it.
> 
> bpf_sk_lookup->remote_port
> supports narrow access.
> 
> When it accesses sport from bpf_sk_lookup_kern.
> 
> and we have tests that do u8 access from remote_port.
> See verifier/ctx_sk_lookup.c
> 
> >                 case offsetof(struct bpf_sock_ops, skb_tcp_flags):
> >                         bpf_ctx_record_field_size(info, size_default);
> >                         return bpf_ctx_narrow_access_ok(off, size,
> >
> > If remote_port/dst_port are made narrower accessable, the
> > result will be right. Therefore, *((u16*)&sk->remote_port) will
> > be the port with network byte order. And the port in host byte
> > order can be get with:
> > bpf_ntohs(*((u16*)&sk->remote_port))
> > or
> > bpf_htonl(sk->remote_port)
> 
> So u8, u16, u32 will work if we make them narrow-accessible, right?
> 
> The summary if I understood it:
> . only bpf_sk_lookup->remote_port is doing it correctly for u8,u16,u32 ?
> . bpf_sock->dst_port is not correct for u32,
>   since it's missing bpf_ctx_range() ?
> . __sk_buff->remote_port
>  bpf_sock_ops->remote_port
>  sk_msg_md->remote_port
>  correct for u32 access only. They don't support narrow access.
> 
> but wait
> we have a test for bpf_sock->dst_port in progs/test_sock_fields.c.
> How does it work then?
> 
> I think we need more eyes on the problem.
> cc-ing more experts.
iiuc,  I think both bpf_sk_lookup and bpf_sock allow narrow access.
bpf_sock only allows ((__u8 *)&bpf_sock->dst_port)[0] but
not ((__u8 *)&bpf_sock->dst_port)[1].  bpf_sk_lookup allows reading
a byte at [0], [1], [2], and [3].

The test_sock_fields.c currently works because it is comparing
with another __u16: "sk->dst_port == srv_sa6.sin6_port".
It should also work with bpf_ntohS() which usually is what the
userspace program expects when dealing with port instead of using bpf_ntohl()?
Thus, I think we can keep the lower 16 bits way that bpf_sock->dst_port
and bpf_sk_lookup->remote_port (and also bpf_sock_addr->user_port ?) are
using.  Also, changing it to the upper 16 bits will break existing
bpf progs.

For narrow access with any number of bytes at any offset may be useful
for IP[6] addr.  Not sure about the port though.  Ideally it should only
allow sizeof(__u16) read at offset 0.  However, I think at this point it makes
sense to make them consistent with how bpf_sk_lookup does it also,
i.e. allow byte [0], [1], [2], and [3] access.

would love to hear how others think about it.
