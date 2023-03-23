Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AD266C6FA3
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 18:47:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230374AbjCWRrb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 13:47:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230072AbjCWRr3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 13:47:29 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A09815174
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 10:47:27 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id d13so22196959pjh.0
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 10:47:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679593647;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MrBZ0nz68uE3t6xSRgI7OHtKH0JjKMui2GQsaqCY+sg=;
        b=IkDstmOdzk/q+esDvki1hLUwLhy7jviXIUGf6R0VCLCDEUvH9/vniskofyMlpNn4p0
         tF58XNQRalKjjOy6zREkk4ljIbuoXW8ecj1TAHpFxaCUZsmEHfv1znfr72GyoYb1D3EU
         2JD3F6x4R1XyYVQ+FH3DH9TK2VPR/2hEcOr0giJg508qh4EJDXQcQ0O2FqmEvHEKyayz
         4mXLsQdBTb+h2Dkz/Nab4zrxDvYNpddUGesPdWCS9FiC7apY3CaSh7iToi+nPYtDiTgA
         CtCEVac7PEfrT8MOARgEyaDSKVKQZ8/e9SDQ0Ff0ZzHI00eJgI5IlJtMGUgmTtOPQsrb
         Nzhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679593647;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MrBZ0nz68uE3t6xSRgI7OHtKH0JjKMui2GQsaqCY+sg=;
        b=B7LlFiCbX8VN3+t+8id9tCR1QS0kiN/846Sn80yxb+Hr8BnYuu5o6xpwyortaqM5Dm
         E9goI62yPoIXOge+QEVtHiAtXRqbd0cRssrnDyzX3e9pXsDBC1Suffu2qdEpE9hFXN3S
         KLC9ghtAqP62jZQlLPGFi2H2e9KxG2J5SIo/UFWFvF8utffHfL2MQioWJ5IRb+zr5U7f
         qfAd+EXtcN7+SA73xDL5h74eg+pA3Uy4c6J3vH4UoTON//tnGDFadMmlZ2lZhicRzHZp
         Hvq0vAf2lKx6tno1WUeCU0Z/pp7CrtKAK27D/DjWK7qDGLtY8ZYFyi1yHR9rdmZkRXhw
         VtXQ==
X-Gm-Message-State: AO0yUKVnDpweEddIvwd/jieZlil+eI3NklSxg0f0O964BvQk/avLJ8A1
        DuMcqKURUm6SSFUncJJi4/0PUTAaHtOPTFXWDuujIg==
X-Google-Smtp-Source: AK7set9SsDjpHXXpn9LybZrBkAmTip5nn0QPvC1h5az6Nb7PCBmYe/cQbiygXksd8ubtpKveTf+sRaaIHcJNuJ71lrg=
X-Received: by 2002:a17:90a:684f:b0:23b:4e6e:aed9 with SMTP id
 e15-20020a17090a684f00b0023b4e6eaed9mr2613896pjm.9.1679593646774; Thu, 23 Mar
 2023 10:47:26 -0700 (PDT)
MIME-Version: 1.0
References: <167940634187.2718137.10209374282891218398.stgit@firesoul>
 <167940643669.2718137.4624187727245854475.stgit@firesoul> <CAKH8qBuv-9TXAmi0oTbB0atC4f6jzFcFhAgQ3D89VX45vUU9hw@mail.gmail.com>
 <080640fc-5835-26f1-2b20-ff079bd59182@redhat.com> <CAADnVQKsxzLTZ2XoLbmKKLAeaSyvf3P+w8V143iZ4cEWWTEUfw@mail.gmail.com>
 <CAKH8qBuHaaqnV-_mb1Roao9ZDrEHm+1Cj77hPZSRgwxoqphvxQ@mail.gmail.com>
 <CAADnVQ+6FeQ97DZLco3OtbtXQvGUAY4nr5tM++6NEDr+u8m7GQ@mail.gmail.com>
 <CAKH8qBvzVASpUu3M=6ohDqJgJjoR33jQ-J44ESD9SdkvFoGAZg@mail.gmail.com>
 <CAADnVQLC7ma7SWPOcjXhsZ2N0OyVtBr7TzCoT-_Dn+zQ2DEyWg@mail.gmail.com>
 <CAKH8qBuqxxVM9fSB43cAvvTnaHkA-JNRy=gufCqYf5GNbRA-8g@mail.gmail.com>
 <d7ac4f80-b65c-5201-086e-3b2645cbe7fe@redhat.com> <CAADnVQ+Jc6G78gJOA758bkCt4sgiwaxgC7S0cr9J=XBPfMDUSg@mail.gmail.com>
In-Reply-To: <CAADnVQ+Jc6G78gJOA758bkCt4sgiwaxgC7S0cr9J=XBPfMDUSg@mail.gmail.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Thu, 23 Mar 2023 10:47:15 -0700
Message-ID: <CAKH8qBupRYEg+SPMTMb4h532GESG7P1QdaFJ-+zrbARVN9xrdA@mail.gmail.com>
Subject: Re: [PATCH bpf-next V2 3/6] selftests/bpf: xdp_hw_metadata RX hash
 return code info
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jesper Dangaard Brouer <jbrouer@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Larysa Zaremba <larysa.zaremba@intel.com>,
        xdp-hints@xdp-project.net, anthony.l.nguyen@intel.com,
        "Song, Yoong Siang" <yoong.siang.song@intel.com>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 23, 2023 at 10:35=E2=80=AFAM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Thu, Mar 23, 2023 at 1:51=E2=80=AFAM Jesper Dangaard Brouer
> <jbrouer@redhat.com> wrote:
> >
> >
> > On 22/03/2023 20.33, Stanislav Fomichev wrote:
> > > On Wed, Mar 22, 2023 at 12:30=E2=80=AFPM Alexei Starovoitov
> > > <alexei.starovoitov@gmail.com> wrote:
> > >>
> > >> On Wed, Mar 22, 2023 at 12:23=E2=80=AFPM Stanislav Fomichev <sdf@goo=
gle.com> wrote:
> > >>>
> > >>> On Wed, Mar 22, 2023 at 12:17=E2=80=AFPM Alexei Starovoitov
> > >>> <alexei.starovoitov@gmail.com> wrote:
> > >>>>
> > >>>> On Wed, Mar 22, 2023 at 12:00=E2=80=AFPM Stanislav Fomichev <sdf@g=
oogle.com> wrote:
> > >>>>>
> > >>>>> On Wed, Mar 22, 2023 at 9:07=E2=80=AFAM Alexei Starovoitov
> > >>>>> <alexei.starovoitov@gmail.com> wrote:
> > >>>>>>
> > >>>>>> On Wed, Mar 22, 2023 at 9:05=E2=80=AFAM Jesper Dangaard Brouer
> > >>>>>> <jbrouer@redhat.com> wrote:
> > >>>>>>>
> > >>>>>>>
> > >>>>>>>
> > >>>>>>> On 21/03/2023 19.47, Stanislav Fomichev wrote:
> > >>>>>>>> On Tue, Mar 21, 2023 at 6:47=E2=80=AFAM Jesper Dangaard Brouer
> > >>>>>>>> <brouer@redhat.com> wrote:
> > >>>>>>>>>
> > >>>>>>>>> When driver developers add XDP-hints kfuncs for RX hash it is
> > >>>>>>>>> practical to print the return code in bpf_printk trace pipe l=
og.
> > >>>>>>>>>
> > >>>>>>>>> Print hash value as a hex value, both AF_XDP userspace and bp=
f_prog,
> > >>>>>>>>> as this makes it easier to spot poor quality hashes.
> > >>>>>>>>>
> > >>>>>>>>> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> > >>>>>>>>> ---
> > >>>>>>>>>    .../testing/selftests/bpf/progs/xdp_hw_metadata.c  |    9 =
++++++---
> > >>>>>>>>>    tools/testing/selftests/bpf/xdp_hw_metadata.c      |    5 =
++++-
> > >>>>>>>>>    2 files changed, 10 insertions(+), 4 deletions(-)
> > >>>>>>>>>
> > >>>>>>>>> diff --git a/tools/testing/selftests/bpf/progs/xdp_hw_metadat=
a.c b/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
> > >>>>>>>>> index 40c17adbf483..ce07010e4d48 100644
> > >>>>>>>>> --- a/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
> > >>>>>>>>> +++ b/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
> > >>>>>>>>> @@ -77,10 +77,13 @@ int rx(struct xdp_md *ctx)
> > >>>>>>>>>                   meta->rx_timestamp =3D 0; /* Used by AF_XDP=
 as not avail signal */
> > >>>>>>>>>           }
> > >>>>>>>>>
> > >>>>>>>>> -       if (!bpf_xdp_metadata_rx_hash(ctx, &meta->rx_hash))
> > >>>>>>>>> -               bpf_printk("populated rx_hash with %u", meta-=
>rx_hash);
> > >>>>>>>>> -       else
> > >>>>>>>>> +       ret =3D bpf_xdp_metadata_rx_hash(ctx, &meta->rx_hash)=
;
> > >>>>>>>>> +       if (ret >=3D 0) {
> > >>>>>>>>> +               bpf_printk("populated rx_hash with 0x%08X", m=
eta->rx_hash);
> > >>>>>>>>> +       } else {
> > >>>>>>>>> +               bpf_printk("rx_hash not-avail errno:%d", ret)=
;
> > >>>>>>>>>                   meta->rx_hash =3D 0; /* Used by AF_XDP as n=
ot avail signal */
> > >>>>>>>>> +       }
> > >>>>>>>>>
> > >>>>>>>>>           return bpf_redirect_map(&xsk, ctx->rx_queue_index, =
XDP_PASS);
> > >>>>>>>>>    }
> > >>>>>>>>> diff --git a/tools/testing/selftests/bpf/xdp_hw_metadata.c b/=
tools/testing/selftests/bpf/xdp_hw_metadata.c
> > >>>>>>>>> index 400bfe19abfe..f3ec07ccdc95 100644
> > >>>>>>>>> --- a/tools/testing/selftests/bpf/xdp_hw_metadata.c
> > >>>>>>>>> +++ b/tools/testing/selftests/bpf/xdp_hw_metadata.c
> > >>>>>>>>> @@ -3,6 +3,9 @@
> > >>>>>>>>>    /* Reference program for verifying XDP metadata on real HW=
. Functional test
> > >>>>>>>>>     * only, doesn't test the performance.
> > >>>>>>>>>     *
> > >>>>>>>>> + * BPF-prog bpf_printk info outout can be access via
> > >>>>>>>>> + * /sys/kernel/debug/tracing/trace_pipe
> > >>>>>>>>
> > >>>>>>>> s/outout/output/
> > >>>>>>>>
> > >>>>>>>
> > >>>>>>> Fixed in V3
> > >>>>>>>
> > >>>>>>>> But let's maybe drop it? If you want to make it more usable, l=
et's
> > >>>>>>>> have a separate patch to enable tracing and periodically dump =
it to
> > >>>>>>>> the console instead (as previously discussed).
> > >>>>>>>
> > >>>>>>> Cat'ing /sys/kernel/debug/tracing/trace_pipe work for me regard=
less of
> > >>>>>>> setting in
> > >>>>>>> /sys/kernel/debug/tracing/events/bpf_trace/bpf_trace_printk/ena=
ble
> > >>>>>>>
> > >>>>>>> We likely need a followup patch that adds a BPF config switch t=
hat can
> > >>>>>>> disable bpf_printk calls, because this adds overhead and thus a=
ffects
> > >>>>>>> the timestamps.
> > >>>>>>
> > >>>>>> No. This is by design.
> > >>>>>> Do not use bpf_printk* in production.
> >
> > I fully agree do not use bpf_printk in *production*.
> >
> > >>>>>
> > >>>>> But that's not for the production? xdp_hw_metadata is a small too=
l to
> > >>>>> verify that the metadata being dumped is correct (during the
> > >>>>> development).
> > >>>>> We have a proper (less verbose) selftest in
> > >>>>> {progs,prog_tests}/xdp_metadata.c (over veth).
> > >>>>> This xdp_hw_metadata was supposed to be used for running it again=
st
> > >>>>> the real hardware, so having as much debugging at hand as possibl=
e
> > >>>>> seems helpful? (at least it was helpful to me when playing with m=
lx4)
> >
> > My experience when developing these kfuncs for igc (real hardware), thi=
s
> > "tool" xdp_hw_metadata was super helpful, because it was very verbose
> > (and I was juggling reading chip registers BE/LE and see patch1 a buggy
> > implementation for RX-hash).
> >
> > As I wrote in cover-letter, I recommend other driver developers to do
> > the same, because it really help speed up the development. In theory
> > xdp_hw_metadata doesn't belong in selftests directory and IMHO it shoul=
d
> > have been placed in samples/bpf/, but given the relationship with real
> > selftest {progs,prog_tests}/xdp_metadata.c I think it makes sense to
> > keep here.
> >
> >
> > >>>>
> > >>>> The only use of bpf_printk is for debugging of bpf progs themselve=
s.
> > >>>> It should not be used in any tool.
> > >>>
> > >>> Hmm, good point. I guess it also means we won't have to mess with
> > >>> enabling/dumping ftrace (and don't need this comment about cat'ing =
the
> > >>> file).
> > >>> Jesper, maybe we can instead pass the status of those
> > >>> bpf_xdp_metadata_xxx kfuncs via 'struct xdp_meta'? And dump this in=
fo
> > >>> from the userspace if needed.
> > >>
> > >> There are so many other ways for bpf prog to communicate with user s=
pace.
> > >> Use ringbuf, perf_event buffer, global vars, maps, etc.
> > >> trace_pipe is debug only because it's global and will conflict with
> > >> all other debug sessions.
> >
> > I want to highlight above paragraph: It is very true for production
> > code. (Anyone Googling this pay attention to above paragraph).
> >
> > >
> > > =F0=9F=91=8D makes sense, ty! hopefully we won't have to add a separa=
te channel
> > > for those and can (ab)use the metadata area.
> > >
> >
> > Proposed solution: How about default disabling the bpf_printk's via a
> > macro define, and then driver developer can manually reenable them
> > easily via a single define, to enable a debugging mode.
> >
> > I was only watching /sys/kernel/debug/tracing/trace_pipe when I was
> > debugging a driver issue.  Thus, an extra step of modifying a single
> > define in BPF seems easier, than instrumenting my driver with printk.
>
> It's certainly fine to have commented out bpf_printk in selftests
> and sample code.
> But the patch does:
> +       if (ret >=3D 0) {
> +               bpf_printk("populated rx_hash with 0x%08X", meta->rx_hash=
);
> +       } else {
> +               bpf_printk("rx_hash not-avail errno:%d", ret);
>                 meta->rx_hash =3D 0; /* Used by AF_XDP as not avail signa=
l */
> +       }
>
> It feels that printk is the only thing that provides the signal to the us=
er.
> Doing s/ret >=3D 0/true/ won't make any difference to selftest and
> to the consumer and that's my main concern with such selftest/samples.

I agree, having this signal delivered to the user (without the ifdefs)
seems like a better way to go.
Seems trivial to do something like the following below? (untested,
doesn't compile, gmail-copy-pasted so don't try to apply it)

diff --git a/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
b/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
index 4c55b4d79d3d..061c410f68ea 100644
--- a/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
+++ b/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
@@ -12,6 +12,9 @@ struct {
  __type(value, __u32);
 } xsk SEC(".maps");

+int received;
+int dropped;
+
 extern int bpf_xdp_metadata_rx_timestamp(const struct xdp_md *ctx,
  __u64 *timestamp) __ksym;
 extern int bpf_xdp_metadata_rx_hash(const struct xdp_md *ctx,
@@ -52,11 +55,11 @@ int rx(struct xdp_md *ctx)
  if (udp->dest !=3D bpf_htons(9091))
  return XDP_PASS;

- bpf_printk("forwarding UDP:9091 to AF_XDP");
+ __sync_fetch_and_add(&received, 1);

  ret =3D bpf_xdp_adjust_meta(ctx, -(int)sizeof(struct xdp_meta));
  if (ret !=3D 0) {
- bpf_printk("bpf_xdp_adjust_meta returned %d", ret);
+ __sync_fetch_and_add(&dropped, 1);
  return XDP_PASS;
  }

@@ -65,19 +68,12 @@ int rx(struct xdp_md *ctx)
  meta =3D data_meta;

  if (meta + 1 > data) {
- bpf_printk("bpf_xdp_adjust_meta doesn't appear to work");
+ __sync_fetch_and_add(&dropped, 1);
  return XDP_PASS;
  }

- if (!bpf_xdp_metadata_rx_timestamp(ctx, &meta->rx_timestamp))
- bpf_printk("populated rx_timestamp with %llu", meta->rx_timestamp);
- else
- meta->rx_timestamp =3D 0; /* Used by AF_XDP as not avail signal */
-
- if (!bpf_xdp_metadata_rx_hash(ctx, &meta->rx_hash))
- bpf_printk("populated rx_hash with %u", meta->rx_hash);
- else
- meta->rx_hash =3D 0; /* Used by AF_XDP as not avail signal */
+ meta->rx_timestamp_ret =3D bpf_xdp_metadata_rx_timestamp(ctx,
&meta->rx_timestamp);
+ meta->rx_hash_ret =3D bpf_xdp_metadata_rx_hash(ctx, &meta->rx_hash);

  return bpf_redirect_map(&xsk, ctx->rx_queue_index, XDP_PASS);
 }
diff --git a/tools/testing/selftests/bpf/xdp_hw_metadata.c
b/tools/testing/selftests/bpf/xdp_hw_metadata.c
index 1c8acb68b977..a4ea742547b5 100644
--- a/tools/testing/selftests/bpf/xdp_hw_metadata.c
+++ b/tools/testing/selftests/bpf/xdp_hw_metadata.c
@@ -140,8 +140,17 @@ static void verify_xdp_metadata(void *data)

  meta =3D data - sizeof(*meta);

- printf("rx_timestamp: %llu\n", meta->rx_timestamp);
- printf("rx_hash: %u\n", meta->rx_hash);
+ printf("received: %d dropped: %d\n", obj->xxx->received, obj->xxx->droppe=
d);
+
+ if (meta->rx_timestamp_ret)
+ printf("rx_timestamp errno: %d\n", meta->rx_timestamp_ret);
+ else
+ printf("rx_timestamp: %llu\n", meta->rx_timestamp);
+
+ if (meta->rx_hash_ret)
+ printf("rx_hash errno: %d\n", meta->rx_hash_ret);
+ else
+ printf("rx_hash: %u\n", meta->rx_hash);
 }

 static void verify_skb_metadata(int fd)
diff --git a/tools/testing/selftests/bpf/xdp_metadata.h
b/tools/testing/selftests/bpf/xdp_metadata.h
index f6780fbb0a21..179f8d902059 100644
--- a/tools/testing/selftests/bpf/xdp_metadata.h
+++ b/tools/testing/selftests/bpf/xdp_metadata.h
@@ -10,6 +10,8 @@
 #endif

 struct xdp_meta {
+ int rx_timestamp_ret;
  __u64 rx_timestamp;
+ int rx_hash_ret;
  __u32 rx_hash;
 };
