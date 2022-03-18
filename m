Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06A254DD533
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 08:27:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233030AbiCRH2O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 03:28:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232969AbiCRH2N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 03:28:13 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 838C470047;
        Fri, 18 Mar 2022 00:26:55 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id j15so1216958eje.9;
        Fri, 18 Mar 2022 00:26:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=itc+KLZwa6VwF+6eEaFGhtCck5gzdg+KvVatJJSA2NE=;
        b=pRr6K+cLN8i9DbwlGKWlNdwKkasDt5xJz94SYgHN1tf4ECvVu39Rgj1EZ5aXLV0v31
         GcqV+nOqDcuK/5MN5bpDsfo0QgK4hJdCpFGKGgvrfJ/7a3r1G+/s6p1Na6qCi8M5SPCK
         ARhHsOEDp9R2jZ2jEWXt/W8abMrzZZi2KdeniD3OZ9gwQEWB1612BxDr+TOrQsI0y2GY
         i9f3Z3CN3vUFJ653LORtyeuM6MlUpuYrK2n3cIQhvjGi7ujmzWMnfCNxnaw7G3CsGNCm
         GDBOxaBO5aqi1we3s7rtZhTJCW99fQmKhhtjH8jWnuKfp3owZw02NJY7K/GUU0MFG3CY
         EKfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=itc+KLZwa6VwF+6eEaFGhtCck5gzdg+KvVatJJSA2NE=;
        b=bG5UysrtziHt+tZ+jSUcqx+moJfoIZDdcig4PTviVZ1zOn4Lrreb1pmkoEjvnfkPmm
         HWJHVBCBHlXCCeUIaJaqexvA5gb50m4+vxZ0X48rtP/VzFrJykVMrNYWabe6Oh2xjCVI
         iPy6ekuYauy3wf6/kFNa+uWyQ8EXptrkcg/VsETdfyywAnqKNhHTG0Gdrfz2xWyRyzgm
         THdmEsiHy3+bYP2Qa+8MWGjXlpUpfoIUiEkowAkmHps4KZlCA7jvier/C6CxPk4qCL1K
         jEJT7/+94yj/3V0uVTKHYZX2nhShAqsTJDMGKvbAlcd844cJk4vBrz10ic+xVROASQnn
         i2wA==
X-Gm-Message-State: AOAM5337NkeC4axlETfPuTD08DiKWkjLBtIG7GfvCIl3qHIJAR4PBfv8
        F4rJLMIg/aWBfDNmhcc6xv2MU6rBgrDz6Ta8uPrp7gx0Ms0=
X-Google-Smtp-Source: ABdhPJxs5dqG2EJqVRPNNQKwxXPQlimEhSvGucWSC8STBvnUhjWMQvC9aGGN/4gOyUdMgtQlCL7NDMOpqfZ1fPOfY4g=
X-Received: by 2002:a17:906:8555:b0:6df:8b7b:49a3 with SMTP id
 h21-20020a170906855500b006df8b7b49a3mr7420841ejy.704.1647588414013; Fri, 18
 Mar 2022 00:26:54 -0700 (PDT)
MIME-Version: 1.0
References: <20220316063148.700769-1-imagedong@tencent.com>
 <20220316063148.700769-4-imagedong@tencent.com> <20220316201853.0734280f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <4315b50e-9077-cc4b-010b-b38a2fbb7168@kernel.org> <20220316210534.06b6cfe0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <f787c35b-0984-ecaf-ad97-c7580fcdbbad@kernel.org> <CADxym3YM9FMFrTirxWQF7aDOpoEGq5bC4-xm2p0mF8shP+Q0Hw@mail.gmail.com>
 <a4032cff-0d48-2690-3c1f-a2ec6c54ffb4@kernel.org>
In-Reply-To: <a4032cff-0d48-2690-3c1f-a2ec6c54ffb4@kernel.org>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Fri, 18 Mar 2022 15:26:42 +0800
Message-ID: <CADxym3bGVebdCTCXxg3xEcPwdfSQADLyPbLTJnPnwn+phqGp3A@mail.gmail.com>
Subject: Re: [PATCH net-next v3 3/3] net: icmp: add reasons of the skb drops
 to icmp protocol
To:     David Ahern <dsahern@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, xeb@mail.ru,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Menglong Dong <imagedong@tencent.com>,
        Eric Dumazet <edumazet@google.com>, Martin Lau <kafai@fb.com>,
        Talal Ahmad <talalahmad@google.com>,
        Kees Cook <keescook@chromium.org>,
        Alexander Lobakin <alobakin@pm.me>,
        Hao Peng <flyingpeng@tencent.com>,
        Mengen Sun <mengensun@tencent.com>, dongli.zhang@oracle.com,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Biao Jiang <benbjiang@tencent.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 18, 2022 at 12:10 PM David Ahern <dsahern@kernel.org> wrote:
>
> On 3/17/22 7:37 PM, Menglong Dong wrote:
> > On Thu, Mar 17, 2022 at 10:48 PM David Ahern <dsahern@kernel.org> wrote:
> >>
> >> On 3/16/22 10:05 PM, Jakub Kicinski wrote:
> >>> On Wed, 16 Mar 2022 21:35:47 -0600 David Ahern wrote:
> >>>> On 3/16/22 9:18 PM, Jakub Kicinski wrote:
> >>>>>
> >>>>> I guess this set raises the follow up question to Dave if adding
> >>>>> drop reasons to places with MIB exception stats means improving
> >>>>> the granularity or one MIB stat == one reason?
> >>>>
> >>>> There are a few examples where multiple MIB stats are bumped on a drop,
> >>>> but the reason code should always be set based on first failure. Did you
> >>>> mean something else with your question?
> >>>
> >>> I meant whether we want to differentiate between TYPE, and BROADCAST or
> >>> whatever other possible invalid protocol cases we can get here or just
> >>> dump them all into a single protocol error code.
> >>
> >> I think a single one is a good starting point.
> >
> > Ok, I'll try my best to make a V4 base this way...Is there any inspiration?
> >
> > Such as we make SKB_DROP_REASON_PTYPE_ABSENT to
> > SKB_DROP_REASON_L2_PROTO, which means the L2 protocol is not
> > supported or invalied.
>
> not following. PTYPE is a Linux name. That means nothing to a user.
>
> I am not sure where you want to use L2_PROTO.

Yeah, PTYPE seems not suitable. I mean that replace SKB_DROP_REASON_PTYPE_ABSENT
that is used in __netif_receive_skb_core() with L3_PROTO, which means no L3
protocol handler (or other device handler) is not found for the
packet. This seems more
friendly and not code based.

>
> >
> > And use SKB_DROP_REASON_L4_PROTO for the L4 protocol problem,
> > such as GRE version not supported, ICMP type not supported, etc.

Is this L4_PROTO followed by anyone?

Thanks!
Menglong Dong

> >
> > Sounds nice, isn't it?
>
