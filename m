Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B934F60B63B
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 20:51:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232813AbiJXSvN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 14:51:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232783AbiJXSuo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 14:50:44 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF056481EE
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 10:31:21 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id u2so5533824ilv.6
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 10:31:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W2Q1uYN8Rm6FcSy3035Mz7Vh+RosplwMYx7sBjd+ess=;
        b=NFv2jWkhdB9WHBOGYKX/JSJYIwoNNJGvxlFNij0Zvmuf4W4mBUB05VWXNrjWsF47nJ
         y0Kzq+TBhthE7lFCKiJcvrd+T2U5lqYOhf+Dz6RC8nGwiwcrr1uoeDyMuKp62KMrYMag
         vxN2HmZAbFAICbNvh4D9NRlkk6SBx1nKLfwWy/1d1m2vmeZW9uk65M+Aa209epBVBsw9
         34ajffHIyLlwF/+cP4vmy2qGc5Ir3+Lu4nOk1VKBv9RmJtVnzbOD8sULIfN/6nKYHHet
         nBdMliDNG1hLYhci8tvuaay4ZgMyRW65hHmu+G4Z+v+F9A1AarfnforTJN6A1Y8fcbp3
         OaJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W2Q1uYN8Rm6FcSy3035Mz7Vh+RosplwMYx7sBjd+ess=;
        b=ce792vDUbJ0guP3mXHJU+E0GaGK5In3Vy43t1HOTknslC4MkPYHL9sEH4PLg5Zi2k7
         3fcFL2y37yoTb3C1qPgd7VuyCMvb25wTo5FCgz97OeLl9LirssacyS7Hcdr+VctPxpNY
         ld90FjNncLu1HgMmq3I6Y0QjCcMgeyYuAL0VE1TMT2Vdp808vSBTQ4hqmdoTb8ZxA7R3
         MrBFjzOcnxjJBxv9wZXGwhNDixGV8mihqF9M6f0d6Zhf/tYIOnaSgZIn3/Z1yICeterU
         ikbOGI/9/mhPq+zbLMCf/lEzPpMPBbvIMYf0xXawZtfEEa1wzPV34iXj54LIEivC6Cei
         oqOA==
X-Gm-Message-State: ACrzQf1y0ECVpFzqmRL0Q8/miwWFiNK+UMzV1nwuhbIZlAynFj6lI7H8
        3RzhTYAlVycAH5IvMGDstfnY4xJ0vYTLL06c4v6qlzpnMLM=
X-Google-Smtp-Source: AMsMyM6C4qQwoOnS4EyFff0ghQtd8QN5RyFBxdENAh838VoZrn/MM/Wx9/MGBG6Mm+Sxt6ioCgbR+lewPuxl24Gcv6M=
X-Received: by 2002:a05:6602:2a48:b0:6bc:e1c7:797b with SMTP id
 k8-20020a0566022a4800b006bce1c7797bmr21180555iov.131.1666631597614; Mon, 24
 Oct 2022 10:13:17 -0700 (PDT)
MIME-Version: 1.0
References: <20221015092448.117563-1-shaozhengchao@huawei.com>
 <CAKH8qBugSdWHP7mtNxrnLLR+56u_0OCx3xQOkJSV-+RUvDAeNg@mail.gmail.com>
 <d830980c-4a38-5537-b594-bc5fb86b0acd@huawei.com> <CAKH8qBtyfS0Otpugn7_ZiG5APA_WTKOVAe1wsFfyaxF-03X=5w@mail.gmail.com>
 <87f67a8c-2fb2-9478-adbb-f55c7a7c94f9@huawei.com> <CAKH8qBsOMxVaemF0Oy=vE1V0vKO8ORUcVGB5YANS3HdKOhVjjw@mail.gmail.com>
 <7ddbf8f4-2b03-223f-4601-add0f7208855@huawei.com>
In-Reply-To: <7ddbf8f4-2b03-223f-4601-add0f7208855@huawei.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Mon, 24 Oct 2022 10:13:06 -0700
Message-ID: <CAKH8qBuKVuRKd+fFiXKTiSpoB8ue4YPw1gM+pkGFKAdgNOcpTg@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: fix issue that packet only contains l2 is dropped
To:     shaozhengchao <shaozhengchao@huawei.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, haoluo@google.com,
        jolsa@kernel.org, oss@lmb.io, weiyongjun1@huawei.com,
        yuehaibing@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 22, 2022 at 4:36 AM shaozhengchao <shaozhengchao@huawei.com> wr=
ote:
>
>
>
> On 2022/10/22 2:16, Stanislav Fomichev wrote:
> > On Fri, Oct 21, 2022 at 12:25 AM shaozhengchao <shaozhengchao@huawei.co=
m> wrote:
> >>
> >>
> >>
> >> On 2022/10/21 1:45, Stanislav Fomichev wrote:
> >>> On Wed, Oct 19, 2022 at 6:47 PM shaozhengchao <shaozhengchao@huawei.c=
om> wrote:
> >>>>
> >>>>
> >>>>
> >>>> On 2022/10/18 0:36, Stanislav Fomichev wrote:
> >>>>> On Sat, Oct 15, 2022 at 2:16 AM Zhengchao Shao <shaozhengchao@huawe=
i.com> wrote:
> >>>>>>
> >>>>>> As [0] see, bpf_prog_test_run_skb() should allow user space to for=
ward
> >>>>>> 14-bytes packet via BPF_PROG_RUN instead of dropping packet direct=
ly.
> >>>>>> So fix it.
> >>>>>>
> >>>>>> 0: https://github.com/cilium/ebpf/commit/a38fb6b5a46ab3b5639ea4d42=
1232a10013596c0
> >>>>>>
> >>>>>> Fixes: fd1894224407 ("bpf: Don't redirect packets with invalid pkt=
_len")
> >>>>>> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> >>>>>> ---
> >>>>>>     net/bpf/test_run.c | 6 +++---
> >>>>>>     1 file changed, 3 insertions(+), 3 deletions(-)
> >>>>>>
> >>>>>> diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
> >>>>>> index 13d578ce2a09..aa1b49f19ca3 100644
> >>>>>> --- a/net/bpf/test_run.c
> >>>>>> +++ b/net/bpf/test_run.c
> >>>>>> @@ -979,9 +979,6 @@ static int convert___skb_to_skb(struct sk_buff=
 *skb, struct __sk_buff *__skb)
> >>>>>>     {
> >>>>>>            struct qdisc_skb_cb *cb =3D (struct qdisc_skb_cb *)skb-=
>cb;
> >>>>>>
> >>>>>> -       if (!skb->len)
> >>>>>> -               return -EINVAL;
> >>>>>> -
> >>>>>>            if (!__skb)
> >>>>>>                    return 0;
> >>>>>>
> >>>>>> @@ -1102,6 +1099,9 @@ int bpf_prog_test_run_skb(struct bpf_prog *p=
rog, const union bpf_attr *kattr,
> >>>>>>            if (IS_ERR(data))
> >>>>>>                    return PTR_ERR(data);
> >>>>>>
> >>>>>> +       if (size =3D=3D ETH_HLEN)
> >>>>>> +               is_l2 =3D true;
> >>>>>> +
> >>>>>
> >>>>> Don't think this will work? That is_l2 is there to expose proper l2=
/l3
> >>>>> skb for specific hooks; we can't suddenly start exposing l2 headers=
 to
> >>>>> the hooks that don't expect it.
> >>>>> Does it make sense to start with a small reproducer that triggers t=
he
> >>>>> issue first? We can have a couple of cases for
> >>>>> len=3D0/ETH_HLEN-1/ETH_HLEN+1 and trigger them from the bpf program=
 that
> >>>>> redirects to different devices (to trigger dev_is_mac_header_xmit).
> >>>>>
> >>>>>
> >>>> Hi Stanislav:
> >>>>           Thank you for your review. Is_l2 is the flag of a specific
> >>>> hook. Therefore, do you mean that if skb->len is equal to 0, just
> >>>> add the length back?
> >>>
> >>> Not sure I understand your question. All I'm saying is - you can't
> >>> flip that flag arbitrarily. This flag depends on the attach point tha=
t
> >>> you're running the prog against. Some attach points expect packets
> >>> with l2, some expect packets without l2.
> >>>
> >>> What about starting with a small reproducer? Does it make sense to
> >>> create a small selftest that adds net namespace + fq_codel +
> >>> bpf_prog_test run and do redirect ingress/egress with len
> >>> 0/1...tcphdr? Because I'm not sure I 100% understand whether it's onl=
y
> >>> len=3D0 that's problematic or some other combination as well?
> >>>
> >> yes, only skb->len =3D 0 will cause null-ptr-deref issue.
> >> The following is the process of triggering the problem:
> >> enqueue a skb:
> >> fq_codel_enqueue()
> >>          ...
> >>          idx =3D fq_codel_classify()        --->if idx !=3D 0
> >>          flow =3D &q->flows[idx];
> >>          flow_queue_add(flow, skb);       --->add skb to flow[idex]
> >>          q->backlogs[idx] +=3D qdisc_pkt_len(skb); --->backlogs =3D 0
> >>          ...
> >>          fq_codel_drop()                  --->set sch->limit =3D 0, al=
ways
> >> drop packets
> >>                  ...
> >>                  idx =3D i                  --->becuase backlogs in ev=
ery
> >> flows is 0, so idx =3D 0
> >>                  ...
> >>                  flow =3D &q->flows[idx];   --->get idx=3D0 flow
> >>                  ...
> >>                  dequeue_head()
> >>                          skb =3D flow->head; --->flow->head =3D NULL
> >>                          flow->head =3D skb->next; --->cause null-ptr-=
deref
> >> So, if skb->len !=3D0=EF=BC=8Cfq_codel_drop() could get the correct id=
x, and
> >> then skb!=3DNULL, it will be OK.
> >> Maybe, I will fix it in fq_codel.
> >
> > I think the consensus here is that the stack, in general, doesn't
> > expect the packets like this. So there are probably more broken things
> > besides fq_codel. Thus, it's better if we remove the ability to
> > generate them from the bpf side instead of fixing the individual users
> > like fq_codel.
> >
> >> But, as I know, skb->len =3D 0 is just invalid packet. I prefer to add=
 the
> >> length back, like bellow:
> >>          if (is_l2 || !skb->len)
> >>                  __skb_push(skb, hh_len);
> >> is it OK?
> >
> > Probably not?
> >
> > Looking at the original syzkaller report, prog_type is
> > BPF_PROG_TYPE_LWT_XMIT which does expect a packet without l2 header.
> > Can we do something like:
> >
> > if (!is_l2 && !skb->len) {
> >    // append some dummy byte to the skb ?
> > }
> >
> >
> I pad one byte, and test OK.
> if (!is_l2 && !skb->len)
>      __skb_push(skb, 1);
>
> Does it look OK to you?

Nope, this will eat a byte out of the l2 header. We need to skb_put
and make sure we allocate enough to make that skb_put succeed.

But stepping back a bit: it feels like it's all unnecessary? The only
valid use-case of this is probing for the BPF_PROG_TEST_RUN as cilium
does. This is mostly about testing, so fixing it in the users seems
fair? No real production code is expected to generate these zero-len
packets. Or are we concerned that this will leak into stable kernels?

I feel like we are trying to add more complexity here for no apparent reaso=
n.
