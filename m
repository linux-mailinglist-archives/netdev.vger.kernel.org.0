Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 470192F64E6
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 16:41:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729283AbhANPjY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 10:39:24 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:42584 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726810AbhANPjX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 10:39:23 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10EFXv7H135902;
        Thu, 14 Jan 2021 15:37:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : in-reply-to : message-id : references : mime-version :
 content-type; s=corp-2020-01-29;
 bh=xtyJOIpC3yf4fwfzRoQF6f+Q0gNVE1ikAyQo7SM5oKQ=;
 b=NbzGUEj3eg0fgAgKmoE//IruSmV5dVb0r+K4vf6Fng0MFe9ncJr++Dn8eo8XOYjuewm/
 1jPzSz5cHMDU6IShrtXg6UgNXkiQIzNgslI4T29G3A6j9Cq4h2uYonlsnWWDKv8hRJ11
 uKVXesHhlJ7Bu4UWCnrsv+5HRIBAQuCw8N1RPenCWNCpALgBuhVksGtYEPqek8/QnT5k
 x9FDusOnf//u1gHC7P5HE9PYlssc/2KjBWFLsuhCxS/GR2zlPvCmrMXQ6ySHYShA2uUJ
 or3W0+ApF6DIfOGwHl7tgd1KtshL94mKUOoXZ95qrTL3U5qvHENy0aMldzl5Ya1zdeAC hQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 360kg20tdv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Jan 2021 15:37:53 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10EFa0IP096057;
        Thu, 14 Jan 2021 15:37:52 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 360kea2d8d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Jan 2021 15:37:52 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 10EFbpfQ008344;
        Thu, 14 Jan 2021 15:37:51 GMT
Received: from localhost.localdomain (/95.45.14.174)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 14 Jan 2021 07:37:51 -0800
Date:   Thu, 14 Jan 2021 15:37:38 +0000 (GMT)
From:   Alan Maguire <alan.maguire@oracle.com>
X-X-Sender: alan@localhost
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
cc:     Alan Maguire <alan.maguire@oracle.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, Hao Luo <haoluo@google.com>,
        Jiri Olsa <jolsa@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, Shuah Khan <shuah@kernel.org>
Subject: Re: [RFC PATCH bpf-next 1/2] bpf: share BTF "show" implementation
 between kernel and libbpf
In-Reply-To: <CAEf4BzZu2MuNYs8rpObLo5Z4gkodY4H+8sbraAGYXJwVZC9mfg@mail.gmail.com>
Message-ID: <alpine.LRH.2.23.451.2101141426320.30025@localhost>
References: <1610386373-24162-1-git-send-email-alan.maguire@oracle.com> <1610386373-24162-2-git-send-email-alan.maguire@oracle.com> <CAEf4BzZu2MuNYs8rpObLo5Z4gkodY4H+8sbraAGYXJwVZC9mfg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9864 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101140090
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9864 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 clxscore=1015 impostorscore=0 spamscore=0 priorityscore=1501 mlxscore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101140090
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 11 Jan 2021, Andrii Nakryiko wrote:

> On Mon, Jan 11, 2021 at 9:34 AM Alan Maguire <alan.maguire@oracle.com> wrote:
> > Currently the only "show" function for userspace is to write the
> > representation of the typed data to a string via
> >
> > LIBBPF_API int
> > btf__snprintf(struct btf *btf, char *buf, int len, __u32 id, void *obj,
> >               __u64 flags);
> >
> > ...but other approaches could be pursued including printf()-based
> > show, or even a callback mechanism could be supported to allow
> > user-defined show functions.
> >
> 
> It's strange that you saw btf_dump APIs, and yet decided to go with
> this API instead. snprintf() is not a natural "method" of struct btf.
> Using char buffer as an output is overly restrictive and inconvenient.
> It's appropriate for kernel and BPF program due to their restrictions,
> but there is no need to cripple libbpf APIs for that. I think it
> should follow btf_dump APIs with custom callback so that it's easy to
> just printf() everything, but also user can create whatever elaborate
> mechanism they need and that fits their use case.
> 
> Code reuse is not the ultimate goal, it should facilitate
> maintainability, not harm it. There are times where sharing code
> introduces unnecessary coupling and maintainability issues. And I
> think this one is a very obvious case of that.
> 

Okay, so I've been exploring adding dumper API support.  The initial
approach I've been using is to provide an API like this:

/* match show flags for bpf_show_snprintf() */
enum {
        BTF_DUMP_F_COMPACT      =       (1ULL << 0),
        BTF_DUMP_F_NONAME       =       (1ULL << 1),
        BTF_DUMP_F_ZERO         =       (1ULL << 3),
};

struct btf_dump_emit_type_data_opts {
        /* size of this struct, for forward/backward compatibility */
        size_t sz;
        void *data;
        int indent_level;
        __u64 flags;
};
#define btf_dump_emit_type_data_opts__last_field flags

LIBBPF_API int
btf_dump__emit_type_data(struct btf_dump *d, __u32 id,
                         const struct btf_dump_emit_type_data_opts *opts);


...so the opts play a similiar role to the struct btf_ptr + flags
in bpf_snprintf_btf.  I've got this working, but the current 
implementation is tied to emitting the same C-based syntax as 
bpf_snprintf_btf(); though of course the printf function is invoked.
So a use case looks something like this:

        struct btf_dump_emit_type_data_opts opts;
        char skbufmem[1024], skbufstr[8192];
        struct btf *btf = libbpf_find_kernel_btf();
        struct btf_dump *d;
        __s32 skbid;
        int indent = 0;

        memset(skbufmem, 0xff, sizeof(skbufmem));
        opts.data = skbufmem;
        opts.sz = sizeof(opts);
        opts.indent_level = indent;

        d = btf_dump__new(btf, NULL, NULL, printffn);

        skbid = btf__find_by_name_kind(btf, "sk_buff", BTF_KIND_STRUCT);
        if (skbid < 0) {
                fprintf(stderr, "no skbuff, err %d\n", skbid);
                exit(1);
        }

        btf_dump__emit_type_data(d, skbid, &opts);


..and we get output of the form

(struct sk_buff){
 (union){
  (struct){
   .next = (struct sk_buff *)0xffffffffffffffff,
   .prev = (struct sk_buff *)0xffffffffffffffff,
   (union){
    .dev = (struct net_device *)0xffffffffffffffff,
    .dev_scratch = (long unsigned int)18446744073709551615,
   },
  },
...

etc.  However it would be nice to find a way to help printf function
providers emit different formats such as JSON without having to
parse the data they are provided in the printf function.
That would remove the need for the output flags, since the printf
function provider could control display.

If we provided an option to provider a "kind" printf function,
and ensured that the BTF dumper sets a "kind" prior to each
_internal_ call to the printf function, we could use that info
to adapt output in various ways.  For example, consider the case
where we want to emit C-type output.  We can use the kind
info to control output for various scenarios:

void c_dump_kind_printf(struct btf_dump *d, enum btf_dump_kind kind,
			void *ctx, const char *fmt, va_list args)
{	
	switch (kind) {
	case BTF_DUMP_KIND_TYPE_NAME:
		/* For C, add brackets around the type name string ( ) */
		btf_dump__printf(d, "(");
		btf_dump__vprintf(d, fmt, args);
		btf_dump__printf(d, ")");
		break;
	case BTF_DUMP_KIND_MEMBER_NAME:
		/* for C, prefix a "." to member name, suffix a "=" */
		btf_dump__printf(d, ".");
		btf_dump__vprintf(d, fmt, args);
		btf_dump__printf(d, " = ");
		break;
	...

Whenever we internally call btf_dump_kind_printf() - and have
a kind printf function - it is invoked, and once it's added formatting
it invokes the printf function.  So there are two layers of callbacks

- the kind callback determines what we print based on the kinds
  of objects provided (type names, member names, type data, etc); and
- the printf callback determines _how_ we print (e.g. to a file, stdout,
  etc).

The above suggests we'd need to add btf_dump__*printf() functions.

This might allow us to refactor bpftool such that the
type traversal code lived in libbpf, while the specifics of
how that info is to be dumped live in bpftool.  We'd probably
need to provide a C-style kind dumper out of the box in libbpf
as a default mechanism.

What do you think?

Alan
