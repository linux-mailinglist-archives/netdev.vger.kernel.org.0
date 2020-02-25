Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDE2216EC43
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 18:13:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730890AbgBYRNw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 12:13:52 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:46130 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730460AbgBYRNw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 12:13:52 -0500
Received: by mail-qk1-f196.google.com with SMTP id u124so12546480qkh.13;
        Tue, 25 Feb 2020 09:13:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=/IxlTtwEg8zi+QmSOZxjTfJWmhKRQK0zQGdeCH6cfpk=;
        b=bNpyyqe0IPSH4nFUQJwmQ+pJ+cJ4fVNK+M/IWCX83m+vM3SGNfBFlonsA4GBUQOxZt
         vVNwxYgrvDHhn3jvnMq6RqqqjMEa8ilyR2ynNtnZurdnAPTwL1sP45RLCtIi5gpOyDxN
         703IzUBxrS1QglYlMz8dFy74aQoGAfgZTsEHHjE3A2jSvLswM6nhImui430M7mSLcd8+
         c+ODbedvR3zWDOT4LG+b/sIG+6I1OFI16H8YlnyzXlr54D64EmIaS55y0DKQiNGFVUOf
         1+eiMlF5tIR7sqcAteraf3heVkXL7jlEHMtlPSL6QKnKRvIF2RbhriKGCBYrn2PbIIaR
         jG+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=/IxlTtwEg8zi+QmSOZxjTfJWmhKRQK0zQGdeCH6cfpk=;
        b=NTDnPqyIPDhcYqDqy3GBLIHf4gj8pp5WNJHB3iYETWtxBHWwuTxvYKHd70TOJIk3R7
         MXGv/n8ma+tXVd8EE5DIWeo/Jj+MOQllC1zGNFm51+PN0kjITxK9a0bV50dhpxXNX0Zw
         9ZDFxoMZB3LuIbmVf1bID87MpbPsn1l06kwQC5Y0YOW34P8EX8PgH9JeF1V/6cOMDc62
         AL95ffykX3wwnZ+kACx/otAR8GcN9oDDoP4ZXhR8N906BPMsuDzXbi/Knlrrm7nBnRge
         kT2t/O75xWUtHTxaGvqilfROB/BXn/MLVVRfHJEDg+WPUTNc9b/+6ALkyrKEuwWAzgVD
         waEA==
X-Gm-Message-State: APjAAAXJqnaBfGPO/jnR+48Iflot0z7hJdRUr0F0ekSwrjWVAiEucleZ
        DnR7j7yY9EpKHtWW/kDv85gcBSI0UgAWz7WR+QM=
X-Google-Smtp-Source: APXvYqyg03eBS2emfwjt3uaVnLeRLX9IcgTkWa3y8uPDu0TutcNXuEtbKrhzfs6d9ZVsl6FyS8NPLGQVzJQi1Zq2PDI=
X-Received: by 2002:a37:9104:: with SMTP id t4mr61498015qkd.449.1582650831011;
 Tue, 25 Feb 2020 09:13:51 -0800 (PST)
MIME-Version: 1.0
References: <CAPhsuW6QkQ8-pXamQVzTXLPzyb4-FCeF_6To7sa_=gd7Ea5VpA@mail.gmail.com>
 <20200225044538.61889-1-forrest0579@gmail.com> <20200225044538.61889-4-forrest0579@gmail.com>
 <CAEf4Bza5k92bxYH=c1DP_rcugF6z3NLos7aPS7DPoi9-3B_JrQ@mail.gmail.com> <CAH+Qyb+rQeebkb1TtLuNHPLmf-VRLqj1yvsHXtaqfzHKMA4azQ@mail.gmail.com>
In-Reply-To: <CAH+Qyb+rQeebkb1TtLuNHPLmf-VRLqj1yvsHXtaqfzHKMA4azQ@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 25 Feb 2020 09:13:40 -0800
Message-ID: <CAEf4BzbM3ey=vUobB=H+j9bzAT+H1TgsNFp88MCB3BkOYQ+0Yg@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 3/3] selftests/bpf: add selftest for
 get_netns_id helper
To:     Forrest Chen <forrest0579@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Petar Penkov <ppenkov.kernel@gmail.com>,
        Song Liu <song@kernel.org>, Song Liu <songliubraving@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 24, 2020 at 11:20 PM Forrest Chen <forrest0579@gmail.com> wrote=
:
>
> > It would be nice if this selftests becomes part of test_progs.
>
> You mean the whole tests of tcpbpf or only the changes I made in this tes=
t?
> If you mean the whole tests of tcpbpf, I think we could fire another thre=
ad
> to do this?

Yeah, I meant entire tcpbpf test.

>
> Andrii Nakryiko <andrii.nakryiko@gmail.com> =E4=BA=8E2020=E5=B9=B42=E6=9C=
=8825=E6=97=A5=E5=91=A8=E4=BA=8C =E4=B8=8B=E5=8D=882:13=E5=86=99=E9=81=93=
=EF=BC=9A
>>
>> On Mon, Feb 24, 2020 at 8:47 PM Lingpeng Chen <forrest0579@gmail.com> wr=
ote:
>> >
>> > adding selftest for new bpf helper function get_netns_id
>> >
>> > Signed-off-by: Lingpeng Chen <forrest0579@gmail.com>
>> > Acked-by: Song Liu <songliubraving@fb.com>
>> > ---
>>
>> It would be nice if this selftests becomes part of test_progs. That
>> way it would be exercised regularly, both by committers, as well as by
>> automated CI in libbpf's Github repo. Using global variables and BPF
>> skeleton would also clean up both BPF and user-space code.
>>
>> It seems like this test runs Python script for server, but doesn't
>> seem like that server is doing anything complicated, so writing that
>> in C shouldn't be a problem as well. Thoughts?
>>
>> >  .../selftests/bpf/progs/test_tcpbpf_kern.c    | 11 +++++
>> >  .../testing/selftests/bpf/test_tcpbpf_user.c  | 46 ++++++++++++++++++=
-
>> >  2 files changed, 56 insertions(+), 1 deletion(-)
>> >
>> > diff --git a/tools/testing/selftests/bpf/progs/test_tcpbpf_kern.c b/to=
ols/testing/selftests/bpf/progs/test_tcpbpf_kern.c
>> > index 1f1966e86e9f..d7d851ddd2cc 100644
>> > --- a/tools/testing/selftests/bpf/progs/test_tcpbpf_kern.c
>> > +++ b/tools/testing/selftests/bpf/progs/test_tcpbpf_kern.c
>> > @@ -28,6 +28,13 @@ struct {
>> >         __type(value, int);
>> >  } sockopt_results SEC(".maps");
>> >
>> > +struct {
>> > +       __uint(type, BPF_MAP_TYPE_ARRAY);
>> > +       __uint(max_entries, 1);
>> > +       __type(key, __u32);
>> > +       __type(value, __u64);
>> > +} netns_number SEC(".maps");
>> > +
>> >  static inline void update_event_map(int event)
>> >  {
>> >         __u32 key =3D 0;
>> > @@ -61,6 +68,7 @@ int bpf_testcb(struct bpf_sock_ops *skops)
>> >         int rv =3D -1;
>> >         int v =3D 0;
>> >         int op;
>> > +       __u64 netns_id;
>> >
>> >         op =3D (int) skops->op;
>> >
>> > @@ -144,6 +152,9 @@ int bpf_testcb(struct bpf_sock_ops *skops)
>> >                 __u32 key =3D 0;
>> >
>> >                 bpf_map_update_elem(&sockopt_results, &key, &v, BPF_AN=
Y);
>> > +
>> > +               netns_id =3D bpf_get_netns_id(skops);
>> > +               bpf_map_update_elem(&netns_number, &key, &netns_id, BP=
F_ANY);
>> >                 break;
>> >         default:
>> >                 rv =3D -1;
>> > diff --git a/tools/testing/selftests/bpf/test_tcpbpf_user.c b/tools/te=
sting/selftests/bpf/test_tcpbpf_user.c
>> > index 3ae127620463..fef2f4d77ecc 100644
>> > --- a/tools/testing/selftests/bpf/test_tcpbpf_user.c
>> > +++ b/tools/testing/selftests/bpf/test_tcpbpf_user.c
>> > @@ -76,6 +76,41 @@ int verify_sockopt_result(int sock_map_fd)
>> >         return ret;
>> >  }
>> >
>> > +int verify_netns(__u64 netns_id)
>> > +{
>> > +       char buf1[40];
>> > +       char buf2[40];
>> > +       int ret =3D 0;
>> > +       ssize_t len =3D 0;
>> > +
>> > +       len =3D readlink("/proc/self/ns/net", buf1, 39);
>> > +       sprintf(buf2, "net:[%llu]", netns_id);
>> > +
>> > +       if (len <=3D 0) {
>> > +               printf("FAILED: readlink /proc/self/ns/net");
>> > +               return ret;
>> > +       }
>> > +
>> > +       if (strncmp(buf1, buf2, len)) {
>> > +               printf("FAILED: netns don't match");
>> > +               ret =3D 1;
>> > +       }
>> > +       return ret;
>> > +}
>> > +
>> > +int verify_netns_result(int netns_map_fd)
>> > +{
>> > +       __u32 key =3D 0;
>> > +       __u64 res =3D 0;
>> > +       int ret =3D 0;
>> > +       int rv;
>> > +
>> > +       rv =3D bpf_map_lookup_elem(netns_map_fd, &key, &res);
>> > +       EXPECT_EQ(0, rv, "d");
>> > +
>> > +       return verify_netns(res);
>> > +}
>> > +
>> >  static int bpf_find_map(const char *test, struct bpf_object *obj,
>> >                         const char *name)
>> >  {
>> > @@ -92,7 +127,7 @@ static int bpf_find_map(const char *test, struct bp=
f_object *obj,
>> >  int main(int argc, char **argv)
>> >  {
>> >         const char *file =3D "test_tcpbpf_kern.o";
>> > -       int prog_fd, map_fd, sock_map_fd;
>> > +       int prog_fd, map_fd, sock_map_fd, netns_map_fd;
>> >         struct tcpbpf_globals g =3D {0};
>> >         const char *cg_path =3D "/foo";
>> >         int error =3D EXIT_FAILURE;
>> > @@ -137,6 +172,10 @@ int main(int argc, char **argv)
>> >         if (sock_map_fd < 0)
>> >                 goto err;
>> >
>> > +       netns_map_fd =3D bpf_find_map(__func__, obj, "netns_number");
>> > +       if (netns_map_fd < 0)
>> > +               goto err;
>> > +
>> >  retry_lookup:
>> >         rv =3D bpf_map_lookup_elem(map_fd, &key, &g);
>> >         if (rv !=3D 0) {
>> > @@ -161,6 +200,11 @@ int main(int argc, char **argv)
>> >                 goto err;
>> >         }
>> >
>> > +       if (verify_netns_result(netns_map_fd)) {
>> > +               printf("FAILED: Wrong netns stats\n");
>> > +               goto err;
>> > +       }
>> > +
>> >         printf("PASSED!\n");
>> >         error =3D 0;
>> >  err:
>> > --
>> > 2.20.1
>> >
>
>
>
> --
> Beijing University of Posts and Telecommunications
> forrest0579@gmail.com
>
>
