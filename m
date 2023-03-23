Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7974A6C6F33
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 18:35:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232113AbjCWRf4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 13:35:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231614AbjCWRfn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 13:35:43 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D46F71166D;
        Thu, 23 Mar 2023 10:35:26 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id h8so90079247ede.8;
        Thu, 23 Mar 2023 10:35:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679592922;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HRKLfvrETKKRHqppJOUGcPm5Thl8LCTv37ptHgjATCw=;
        b=bN4uLl311Hp3OsFquz9kbJJ2LR6wVRZ2mSI3cteP/v7Ho1RrSjDIlDwTZAbo84mQoW
         vABMOKbkRo1wz09xiTi/Oen1Gqu0eA7EKsa05lNttOCmEW+DYreVihhBFg6ml2VU+DTl
         CH/UdFwbbrilHeNExKw3YA91uAzwE3qXmfNvNm4uaOiyVjTsyD3tM8XB+CRrF7sqjZrh
         sYGOkv6eI3sxtZepNNfDG4CIp+juQa0LAP7oKDKv4Nn/PpUF3RnuKzD7Php0pJyo5vVm
         pZEleWMkkIxD6RTt/t+/seQ6eiRd1eM19+WcaORH5MvpzM4OpKdUUd1kVfYvSkx/Q4TY
         WVNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679592922;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HRKLfvrETKKRHqppJOUGcPm5Thl8LCTv37ptHgjATCw=;
        b=SHI7DqKWMlNj2Ijdb2d5vRbvsk6UHcyvihgGpuV6J4qDnnFBu2Hp22MbPbLKN9Yznk
         oUQs+kVH5y89ZVaAE2YuFYLIQfVvUxnhkiZzDAU2yBvm6bwkcNaJOL1pKmt8wojQGHuU
         DPibAvEryHxXym/xI64mdEERF7nDz+Q395fjvYiRORGtu1RZNH3dAqAIN0JO+jIT1fzO
         sovcqRbLphJLrkWOTi1z+RGj/A5LKQGPpL7SJyJTD4HfIcFgNHwS6JaZAC3smTMza+rw
         1lCDQpkHndjlLYKiKdaR4s16uR1HxnLMUxja/Svjt3thrrowMmU8js/8wvKGoI3iS/bU
         Jvww==
X-Gm-Message-State: AO0yUKVzyVGzP83N11veZhg2lrjHqlo54k4HfxqLovJHRrm/mo5fMqP0
        q2KrNdPst1JWDbC725r5+XJs3PAJvse/2RL6AXI=
X-Google-Smtp-Source: AK7set8K/L1zB6jSQTc0sdzB8WzanW0af/plqKt56NPau/aklI+gV0w6LkAVFuVHJimGN7Llb88lbPiQ/xMJHXUBXwk=
X-Received: by 2002:a05:6402:278e:b0:501:dfd8:67c5 with SMTP id
 b14-20020a056402278e00b00501dfd867c5mr5060794ede.3.1679592922058; Thu, 23 Mar
 2023 10:35:22 -0700 (PDT)
MIME-Version: 1.0
References: <167940634187.2718137.10209374282891218398.stgit@firesoul>
 <167940643669.2718137.4624187727245854475.stgit@firesoul> <CAKH8qBuv-9TXAmi0oTbB0atC4f6jzFcFhAgQ3D89VX45vUU9hw@mail.gmail.com>
 <080640fc-5835-26f1-2b20-ff079bd59182@redhat.com> <CAADnVQKsxzLTZ2XoLbmKKLAeaSyvf3P+w8V143iZ4cEWWTEUfw@mail.gmail.com>
 <CAKH8qBuHaaqnV-_mb1Roao9ZDrEHm+1Cj77hPZSRgwxoqphvxQ@mail.gmail.com>
 <CAADnVQ+6FeQ97DZLco3OtbtXQvGUAY4nr5tM++6NEDr+u8m7GQ@mail.gmail.com>
 <CAKH8qBvzVASpUu3M=6ohDqJgJjoR33jQ-J44ESD9SdkvFoGAZg@mail.gmail.com>
 <CAADnVQLC7ma7SWPOcjXhsZ2N0OyVtBr7TzCoT-_Dn+zQ2DEyWg@mail.gmail.com>
 <CAKH8qBuqxxVM9fSB43cAvvTnaHkA-JNRy=gufCqYf5GNbRA-8g@mail.gmail.com> <d7ac4f80-b65c-5201-086e-3b2645cbe7fe@redhat.com>
In-Reply-To: <d7ac4f80-b65c-5201-086e-3b2645cbe7fe@redhat.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 23 Mar 2023 10:35:10 -0700
Message-ID: <CAADnVQ+Jc6G78gJOA758bkCt4sgiwaxgC7S0cr9J=XBPfMDUSg@mail.gmail.com>
Subject: Re: [PATCH bpf-next V2 3/6] selftests/bpf: xdp_hw_metadata RX hash
 return code info
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     Stanislav Fomichev <sdf@google.com>,
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
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 23, 2023 at 1:51=E2=80=AFAM Jesper Dangaard Brouer
<jbrouer@redhat.com> wrote:
>
>
> On 22/03/2023 20.33, Stanislav Fomichev wrote:
> > On Wed, Mar 22, 2023 at 12:30=E2=80=AFPM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> >>
> >> On Wed, Mar 22, 2023 at 12:23=E2=80=AFPM Stanislav Fomichev <sdf@googl=
e.com> wrote:
> >>>
> >>> On Wed, Mar 22, 2023 at 12:17=E2=80=AFPM Alexei Starovoitov
> >>> <alexei.starovoitov@gmail.com> wrote:
> >>>>
> >>>> On Wed, Mar 22, 2023 at 12:00=E2=80=AFPM Stanislav Fomichev <sdf@goo=
gle.com> wrote:
> >>>>>
> >>>>> On Wed, Mar 22, 2023 at 9:07=E2=80=AFAM Alexei Starovoitov
> >>>>> <alexei.starovoitov@gmail.com> wrote:
> >>>>>>
> >>>>>> On Wed, Mar 22, 2023 at 9:05=E2=80=AFAM Jesper Dangaard Brouer
> >>>>>> <jbrouer@redhat.com> wrote:
> >>>>>>>
> >>>>>>>
> >>>>>>>
> >>>>>>> On 21/03/2023 19.47, Stanislav Fomichev wrote:
> >>>>>>>> On Tue, Mar 21, 2023 at 6:47=E2=80=AFAM Jesper Dangaard Brouer
> >>>>>>>> <brouer@redhat.com> wrote:
> >>>>>>>>>
> >>>>>>>>> When driver developers add XDP-hints kfuncs for RX hash it is
> >>>>>>>>> practical to print the return code in bpf_printk trace pipe log=
.
> >>>>>>>>>
> >>>>>>>>> Print hash value as a hex value, both AF_XDP userspace and bpf_=
prog,
> >>>>>>>>> as this makes it easier to spot poor quality hashes.
> >>>>>>>>>
> >>>>>>>>> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> >>>>>>>>> ---
> >>>>>>>>>    .../testing/selftests/bpf/progs/xdp_hw_metadata.c  |    9 ++=
++++---
> >>>>>>>>>    tools/testing/selftests/bpf/xdp_hw_metadata.c      |    5 ++=
++-
> >>>>>>>>>    2 files changed, 10 insertions(+), 4 deletions(-)
> >>>>>>>>>
> >>>>>>>>> diff --git a/tools/testing/selftests/bpf/progs/xdp_hw_metadata.=
c b/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
> >>>>>>>>> index 40c17adbf483..ce07010e4d48 100644
> >>>>>>>>> --- a/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
> >>>>>>>>> +++ b/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
> >>>>>>>>> @@ -77,10 +77,13 @@ int rx(struct xdp_md *ctx)
> >>>>>>>>>                   meta->rx_timestamp =3D 0; /* Used by AF_XDP a=
s not avail signal */
> >>>>>>>>>           }
> >>>>>>>>>
> >>>>>>>>> -       if (!bpf_xdp_metadata_rx_hash(ctx, &meta->rx_hash))
> >>>>>>>>> -               bpf_printk("populated rx_hash with %u", meta->r=
x_hash);
> >>>>>>>>> -       else
> >>>>>>>>> +       ret =3D bpf_xdp_metadata_rx_hash(ctx, &meta->rx_hash);
> >>>>>>>>> +       if (ret >=3D 0) {
> >>>>>>>>> +               bpf_printk("populated rx_hash with 0x%08X", met=
a->rx_hash);
> >>>>>>>>> +       } else {
> >>>>>>>>> +               bpf_printk("rx_hash not-avail errno:%d", ret);
> >>>>>>>>>                   meta->rx_hash =3D 0; /* Used by AF_XDP as not=
 avail signal */
> >>>>>>>>> +       }
> >>>>>>>>>
> >>>>>>>>>           return bpf_redirect_map(&xsk, ctx->rx_queue_index, XD=
P_PASS);
> >>>>>>>>>    }
> >>>>>>>>> diff --git a/tools/testing/selftests/bpf/xdp_hw_metadata.c b/to=
ols/testing/selftests/bpf/xdp_hw_metadata.c
> >>>>>>>>> index 400bfe19abfe..f3ec07ccdc95 100644
> >>>>>>>>> --- a/tools/testing/selftests/bpf/xdp_hw_metadata.c
> >>>>>>>>> +++ b/tools/testing/selftests/bpf/xdp_hw_metadata.c
> >>>>>>>>> @@ -3,6 +3,9 @@
> >>>>>>>>>    /* Reference program for verifying XDP metadata on real HW. =
Functional test
> >>>>>>>>>     * only, doesn't test the performance.
> >>>>>>>>>     *
> >>>>>>>>> + * BPF-prog bpf_printk info outout can be access via
> >>>>>>>>> + * /sys/kernel/debug/tracing/trace_pipe
> >>>>>>>>
> >>>>>>>> s/outout/output/
> >>>>>>>>
> >>>>>>>
> >>>>>>> Fixed in V3
> >>>>>>>
> >>>>>>>> But let's maybe drop it? If you want to make it more usable, let=
's
> >>>>>>>> have a separate patch to enable tracing and periodically dump it=
 to
> >>>>>>>> the console instead (as previously discussed).
> >>>>>>>
> >>>>>>> Cat'ing /sys/kernel/debug/tracing/trace_pipe work for me regardle=
ss of
> >>>>>>> setting in
> >>>>>>> /sys/kernel/debug/tracing/events/bpf_trace/bpf_trace_printk/enabl=
e
> >>>>>>>
> >>>>>>> We likely need a followup patch that adds a BPF config switch tha=
t can
> >>>>>>> disable bpf_printk calls, because this adds overhead and thus aff=
ects
> >>>>>>> the timestamps.
> >>>>>>
> >>>>>> No. This is by design.
> >>>>>> Do not use bpf_printk* in production.
>
> I fully agree do not use bpf_printk in *production*.
>
> >>>>>
> >>>>> But that's not for the production? xdp_hw_metadata is a small tool =
to
> >>>>> verify that the metadata being dumped is correct (during the
> >>>>> development).
> >>>>> We have a proper (less verbose) selftest in
> >>>>> {progs,prog_tests}/xdp_metadata.c (over veth).
> >>>>> This xdp_hw_metadata was supposed to be used for running it against
> >>>>> the real hardware, so having as much debugging at hand as possible
> >>>>> seems helpful? (at least it was helpful to me when playing with mlx=
4)
>
> My experience when developing these kfuncs for igc (real hardware), this
> "tool" xdp_hw_metadata was super helpful, because it was very verbose
> (and I was juggling reading chip registers BE/LE and see patch1 a buggy
> implementation for RX-hash).
>
> As I wrote in cover-letter, I recommend other driver developers to do
> the same, because it really help speed up the development. In theory
> xdp_hw_metadata doesn't belong in selftests directory and IMHO it should
> have been placed in samples/bpf/, but given the relationship with real
> selftest {progs,prog_tests}/xdp_metadata.c I think it makes sense to
> keep here.
>
>
> >>>>
> >>>> The only use of bpf_printk is for debugging of bpf progs themselves.
> >>>> It should not be used in any tool.
> >>>
> >>> Hmm, good point. I guess it also means we won't have to mess with
> >>> enabling/dumping ftrace (and don't need this comment about cat'ing th=
e
> >>> file).
> >>> Jesper, maybe we can instead pass the status of those
> >>> bpf_xdp_metadata_xxx kfuncs via 'struct xdp_meta'? And dump this info
> >>> from the userspace if needed.
> >>
> >> There are so many other ways for bpf prog to communicate with user spa=
ce.
> >> Use ringbuf, perf_event buffer, global vars, maps, etc.
> >> trace_pipe is debug only because it's global and will conflict with
> >> all other debug sessions.
>
> I want to highlight above paragraph: It is very true for production
> code. (Anyone Googling this pay attention to above paragraph).
>
> >
> > =F0=9F=91=8D makes sense, ty! hopefully we won't have to add a separate=
 channel
> > for those and can (ab)use the metadata area.
> >
>
> Proposed solution: How about default disabling the bpf_printk's via a
> macro define, and then driver developer can manually reenable them
> easily via a single define, to enable a debugging mode.
>
> I was only watching /sys/kernel/debug/tracing/trace_pipe when I was
> debugging a driver issue.  Thus, an extra step of modifying a single
> define in BPF seems easier, than instrumenting my driver with printk.

It's certainly fine to have commented out bpf_printk in selftests
and sample code.
But the patch does:
+       if (ret >=3D 0) {
+               bpf_printk("populated rx_hash with 0x%08X", meta->rx_hash);
+       } else {
+               bpf_printk("rx_hash not-avail errno:%d", ret);
                meta->rx_hash =3D 0; /* Used by AF_XDP as not avail signal =
*/
+       }

It feels that printk is the only thing that provides the signal to the user=
.
Doing s/ret >=3D 0/true/ won't make any difference to selftest and
to the consumer and that's my main concern with such selftest/samples.
