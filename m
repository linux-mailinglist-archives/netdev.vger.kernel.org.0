Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CD6060FD3E
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 18:37:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236612AbiJ0Qho (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 12:37:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235779AbiJ0Qhn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 12:37:43 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4411017253D
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 09:37:41 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id o13so1333574ilc.7
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 09:37:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7LWEASsKgUP64ylwmptUWdmfupY1E/J0Cw3DTfsriXQ=;
        b=Q3GocbXjSAuAh60TyV0Ub1SyNnW9zTwO9PIPJVBoFQkEOvIF7hXneEM4bLaRL7eXd3
         P3f/HHObHy30UblpMmel9sUFaILJHBT8SWH3KPknoQnWxffkrxpDrV6rurTiCh+VgHkA
         OsL47TiPDqu3rry6V1bb5neDuAjVYEkRi8X126nUCYxv/3xHZbrNhadU3JKummzB2UAD
         j/PRkZpthGogxQxNJ8EKtSann/Dl0PdAlkSp/7JX17flR3aFAA9dSbGAcNo6nQTSE1Q+
         O3NSy/0Uhp5torvw7/6cE28hYsJuO4L/Kq4nHgAF1uMjq2BX3U46pOl8itmYTUKPceDG
         FPGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7LWEASsKgUP64ylwmptUWdmfupY1E/J0Cw3DTfsriXQ=;
        b=wGAdG66zejNLnD5A7qNHQ6ZEedatJcdQL3nNSm8CPKZmFULUrI15TnJ3pyP+PIcXyK
         7Xeylxygy9jj9Ih0I0tFwtODwoJTWtDuNyIhuYBgfLPfAwGhtEGd2pkm8mL9a2p1yCid
         D3lMn9hdOsnbq9VecNlZPJ6pfoQgPYPA5JJYq5AJVmlHudj2Da0orSLoyaCnPPOBbqoU
         xS00XxwboUd7SceGgY7rGrqTioipeaggw6ERzpYYQD7SmMCGFk16OB9d6aVRF+sxS3Ux
         2/ZeSjOd2YsLAA7uky1BYzsBWcV2y0gsF+TNYUDLoSzftujfnvVSceizpPOlIr8W1tyW
         LdpA==
X-Gm-Message-State: ACrzQf2Ykb1/n1+9+SvAdZRzDSJTxCQ3E3gesgzDq5kBzrVMQNJJZnyw
        5HKtvT4q/mjEKcoDnJbYZMK2aFNPY2RxFxKRIhZQUQ==
X-Google-Smtp-Source: AMsMyM4MPUzrHFOAqSSCaQJyrhFKA9jCif0uSF89aO/lId8sCn8ZNsltO+/qn3qDp+qqGgM1xCJ7Ae1omZAuR+rWNKw=
X-Received: by 2002:a05:6e02:1a41:b0:2fa:969d:fcd0 with SMTP id
 u1-20020a056e021a4100b002fa969dfcd0mr32110522ilv.6.1666888660954; Thu, 27 Oct
 2022 09:37:40 -0700 (PDT)
MIME-Version: 1.0
References: <20221015092448.117563-1-shaozhengchao@huawei.com>
 <CAKH8qBugSdWHP7mtNxrnLLR+56u_0OCx3xQOkJSV-+RUvDAeNg@mail.gmail.com>
 <d830980c-4a38-5537-b594-bc5fb86b0acd@huawei.com> <CAKH8qBtyfS0Otpugn7_ZiG5APA_WTKOVAe1wsFfyaxF-03X=5w@mail.gmail.com>
 <87f67a8c-2fb2-9478-adbb-f55c7a7c94f9@huawei.com> <CAKH8qBsOMxVaemF0Oy=vE1V0vKO8ORUcVGB5YANS3HdKOhVjjw@mail.gmail.com>
 <7ddbf8f4-2b03-223f-4601-add0f7208855@huawei.com> <CAKH8qBuKVuRKd+fFiXKTiSpoB8ue4YPw1gM+pkGFKAdgNOcpTg@mail.gmail.com>
 <20e9ea01-1261-6d03-34c9-9b842298487a@huawei.com>
In-Reply-To: <20e9ea01-1261-6d03-34c9-9b842298487a@huawei.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Thu, 27 Oct 2022 09:37:29 -0700
Message-ID: <CAKH8qBstDGb3Uf14J5K3VtgZOdHFT1c4u0uUG97NqgA4iZRo+Q@mail.gmail.com>
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
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 27, 2022 at 4:58 AM shaozhengchao <shaozhengchao@huawei.com> wr=
ote:
>
>
>
> On 2022/10/25 1:13, Stanislav Fomichev wrote:
> > On Sat, Oct 22, 2022 at 4:36 AM shaozhengchao <shaozhengchao@huawei.com=
> wrote:
> >>
> >>
> >>
> >> On 2022/10/22 2:16, Stanislav Fomichev wrote:
> >>> On Fri, Oct 21, 2022 at 12:25 AM shaozhengchao <shaozhengchao@huawei.=
com> wrote:
> >>>>
> >>>>
> >>>>
> >>>> On 2022/10/21 1:45, Stanislav Fomichev wrote:
> >>>>> On Wed, Oct 19, 2022 at 6:47 PM shaozhengchao <shaozhengchao@huawei=
.com> wrote:
> >>>>>>
> >>>>>>
> >>>>>>
> >>>>>> On 2022/10/18 0:36, Stanislav Fomichev wrote:
> >>>>>>> On Sat, Oct 15, 2022 at 2:16 AM Zhengchao Shao <shaozhengchao@hua=
wei.com> wrote:
> >>>>>>>>
> >>>>>>>> As [0] see, bpf_prog_test_run_skb() should allow user space to f=
orward
> >>>>>>>> 14-bytes packet via BPF_PROG_RUN instead of dropping packet dire=
ctly.
> >>>>>>>> So fix it.
> >>>>>>>>
> >>>>>>>> 0: https://github.com/cilium/ebpf/commit/a38fb6b5a46ab3b5639ea4d=
421232a10013596c0
> >>>>>>>>
> >>>>>>>> Fixes: fd1894224407 ("bpf: Don't redirect packets with invalid p=
kt_len")
> >>>>>>>> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> >>>>>>>> ---
> >>>>>>>>      net/bpf/test_run.c | 6 +++---
> >>>>>>>>      1 file changed, 3 insertions(+), 3 deletions(-)
> >>>>>>>>
> >>>>>>>> diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
> >>>>>>>> index 13d578ce2a09..aa1b49f19ca3 100644
> >>>>>>>> --- a/net/bpf/test_run.c
> >>>>>>>> +++ b/net/bpf/test_run.c
> >>>>>>>> @@ -979,9 +979,6 @@ static int convert___skb_to_skb(struct sk_bu=
ff *skb, struct __sk_buff *__skb)
> >>>>>>>>      {
> >>>>>>>>             struct qdisc_skb_cb *cb =3D (struct qdisc_skb_cb *)s=
kb->cb;
> >>>>>>>>
> >>>>>>>> -       if (!skb->len)
> >>>>>>>> -               return -EINVAL;
> >>>>>>>> -
> >>>>>>>>             if (!__skb)
> >>>>>>>>                     return 0;
> >>>>>>>>
> >>>>>>>> @@ -1102,6 +1099,9 @@ int bpf_prog_test_run_skb(struct bpf_prog =
*prog, const union bpf_attr *kattr,
> >>>>>>>>             if (IS_ERR(data))
> >>>>>>>>                     return PTR_ERR(data);
> >>>>>>>>
> >>>>>>>> +       if (size =3D=3D ETH_HLEN)
> >>>>>>>> +               is_l2 =3D true;
> >>>>>>>> +
> >>>>>>>
> >>>>>>> Don't think this will work? That is_l2 is there to expose proper =
l2/l3
> >>>>>>> skb for specific hooks; we can't suddenly start exposing l2 heade=
rs to
> >>>>>>> the hooks that don't expect it.
> >>>>>>> Does it make sense to start with a small reproducer that triggers=
 the
> >>>>>>> issue first? We can have a couple of cases for
> >>>>>>> len=3D0/ETH_HLEN-1/ETH_HLEN+1 and trigger them from the bpf progr=
am that
> >>>>>>> redirects to different devices (to trigger dev_is_mac_header_xmit=
).
> >>>>>>>
> >>>>>>>
> >>>>>> Hi Stanislav:
> >>>>>>            Thank you for your review. Is_l2 is the flag of a speci=
fic
> >>>>>> hook. Therefore, do you mean that if skb->len is equal to 0, just
> >>>>>> add the length back?
> >>>>>
> >>>>> Not sure I understand your question. All I'm saying is - you can't
> >>>>> flip that flag arbitrarily. This flag depends on the attach point t=
hat
> >>>>> you're running the prog against. Some attach points expect packets
> >>>>> with l2, some expect packets without l2.
> >>>>>
> >>>>> What about starting with a small reproducer? Does it make sense to
> >>>>> create a small selftest that adds net namespace + fq_codel +
> >>>>> bpf_prog_test run and do redirect ingress/egress with len
> >>>>> 0/1...tcphdr? Because I'm not sure I 100% understand whether it's o=
nly
> >>>>> len=3D0 that's problematic or some other combination as well?
> >>>>>
> >>>> yes, only skb->len =3D 0 will cause null-ptr-deref issue.
> >>>> The following is the process of triggering the problem:
> >>>> enqueue a skb:
> >>>> fq_codel_enqueue()
> >>>>           ...
> >>>>           idx =3D fq_codel_classify()        --->if idx !=3D 0
> >>>>           flow =3D &q->flows[idx];
> >>>>           flow_queue_add(flow, skb);       --->add skb to flow[idex]
> >>>>           q->backlogs[idx] +=3D qdisc_pkt_len(skb); --->backlogs =3D=
 0
> >>>>           ...
> >>>>           fq_codel_drop()                  --->set sch->limit =3D 0,=
 always
> >>>> drop packets
> >>>>                   ...
> >>>>                   idx =3D i                  --->becuase backlogs in=
 every
> >>>> flows is 0, so idx =3D 0
> >>>>                   ...
> >>>>                   flow =3D &q->flows[idx];   --->get idx=3D0 flow
> >>>>                   ...
> >>>>                   dequeue_head()
> >>>>                           skb =3D flow->head; --->flow->head =3D NUL=
L
> >>>>                           flow->head =3D skb->next; --->cause null-p=
tr-deref
> >>>> So, if skb->len !=3D0=EF=BC=8Cfq_codel_drop() could get the correct =
idx, and
> >>>> then skb!=3DNULL, it will be OK.
> >>>> Maybe, I will fix it in fq_codel.
> >>>
> >>> I think the consensus here is that the stack, in general, doesn't
> >>> expect the packets like this. So there are probably more broken thing=
s
> >>> besides fq_codel. Thus, it's better if we remove the ability to
> >>> generate them from the bpf side instead of fixing the individual user=
s
> >>> like fq_codel.
> >>>
> >>>> But, as I know, skb->len =3D 0 is just invalid packet. I prefer to a=
dd the
> >>>> length back, like bellow:
> >>>>           if (is_l2 || !skb->len)
> >>>>                   __skb_push(skb, hh_len);
> >>>> is it OK?
> >>>
> >>> Probably not?
> >>>
> >>> Looking at the original syzkaller report, prog_type is
> >>> BPF_PROG_TYPE_LWT_XMIT which does expect a packet without l2 header.
> >>> Can we do something like:
> >>>
> >>> if (!is_l2 && !skb->len) {
> >>>     // append some dummy byte to the skb ?
> >>> }
> >>>
> >>>
> >> I pad one byte, and test OK.
> >> if (!is_l2 && !skb->len)
> >>       __skb_push(skb, 1);
> >>
> >> Does it look OK to you?
> >
> > Nope, this will eat a byte out of the l2 header. We need to skb_put
> > and make sure we allocate enough to make that skb_put succeed.
> >
> > But stepping back a bit: it feels like it's all unnecessary? The only
> > valid use-case of this is probing for the BPF_PROG_TEST_RUN as cilium
> > does. This is mostly about testing, so fixing it in the users seems
> > fair? No real production code is expected to generate these zero-len
> > packets. Or are we concerned that this will leak into stable kernels?
> >
> > I feel like we are trying to add more complexity here for no apparent r=
eason.
> >
> I agree with you. users should make sure the correct skb len and
> configurations are passed into kernel. Incorrect configurations should
> be discarded to ensure kernel stability.
>
> Lorenz, Can you modify the user-mode test code?

Lorenz already fixed it for Cilium. I think the discussion here is
around other potential users out there.
Let's wait for them to appear if it is indeed a problem?
