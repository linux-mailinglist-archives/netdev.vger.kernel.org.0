Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65BC454E8B7
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 19:40:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235203AbiFPRkD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 13:40:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbiFPRkB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 13:40:01 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2FB33ED1C
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 10:40:00 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id u37so2104250pfg.3
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 10:40:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=onP0sXsK4JvSncBfDCXl6EmwmLA/F+tO3xFCBOUoBPU=;
        b=hHRoHv1h0MnLBF4CoiKvHxvxx3aesx1lb/k9ECeCD41+KZVZLJkX0m2oPPFhptp4Qx
         Uup7Rdh0oMfP2/vTnr/YHB93/Fxe9Dshy6YNqffwewsWHuc/3aPbOwsGmsNv4G8Y1D4d
         y87ieqMEgxR+STb1frkZ7KK9yEQTt5+CZWL/ZlNWS9wCeyT32xI9f+Wl8L615ZUdBLmA
         Kw4WKioUlNBrfPMQFaTAGExxesg8m/MQZuE7l8Xdlx7lThBSendoXAOcLUhjNy+fStdI
         0i1NzbZwIQZFStpXG+WC4JbcX7sIgj9iGbLUNLU8fwpLngok+RN0s7TtRzWITj+tqYS6
         C1Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=onP0sXsK4JvSncBfDCXl6EmwmLA/F+tO3xFCBOUoBPU=;
        b=7M09HqD2f/6JZQKJITeuvla0k+yZ1ixVFiH3vD5TGDriLI5q4QfyqGY2GOfapvGufO
         zDJWO3lo26qx6hk70q3g5wvUfmPmnG9boOgiClojiCzzu+G1rTGQjelI14zyb+z92xVB
         Kfts3PtVutX03QATSEU+i2ezJBv0CfUPQxSBP9VPXJTWxcv0xz/fkzYQs6minLOjy/c2
         0RvuG/c2JhL5IX3Kk8DnpwUFscwTrjiKCOdjvvGS/M1Zw+qJmyOTE6uzvOHS1DdAmrO4
         oxFkIQ/N21dqsR8P6dCls0yRKQ0KPl0PvDZwNpjtANZ/F0SO8Qb8RejsnoiBEFltHzCE
         LWHA==
X-Gm-Message-State: AJIora9eT1qkcy5EiFRQwVX0IcQlykvDD6lKblt1Csi5T/GmqU53fbN7
        xTuCY72OUPIa6ahDgve9FrpfUOT5wC1PGKeKEDWApQ==
X-Google-Smtp-Source: AGRyM1vAQ3usZcQ7CXRyrWvjwIwFjZl+3XZFOs6Pva4izs1aLGwZZ0EIlXJwfp+u6lnNhCGjeZ5hAuejA2Q8598CSbQ=
X-Received: by 2002:a05:6a00:338e:b0:51b:c452:4210 with SMTP id
 cm14-20020a056a00338e00b0051bc4524210mr5679505pfb.69.1655401199992; Thu, 16
 Jun 2022 10:39:59 -0700 (PDT)
MIME-Version: 1.0
References: <CAHo-Ooy+8O16k0oyMGHaAcmLm_Pfo=Ju4moTc95kRp2Z6itBcg@mail.gmail.com>
 <CANP3RGed9Vbu=8HfLyNs9zwA=biqgyew=+2tVxC6BAx2ktzNxA@mail.gmail.com>
 <CAADnVQKBqjowbGsSuc2g8yP9MBANhsroB+dhJep93cnx_EmNow@mail.gmail.com>
 <CANP3RGcZ4NULOwe+nwxfxsDPSXAUo50hWyN9Sb5b_d=kfDg=qg@mail.gmail.com>
 <YqodE5lxUCt6ojIw@google.com> <YqpAYcvM9DakTjWL@google.com>
 <YqpB+7pDwyOk20Cp@google.com> <YqpDcD6vkZZfWH4L@google.com>
 <CANP3RGcBCeMeCfpY3__4X_OHx6PB6bXtRjwLdYi-LRiegicVXQ@mail.gmail.com>
 <CAKH8qBv=+QVBqHd=9rAWe3d5d47dSkppYc1JbS+WgQs8XgB+Yg@mail.gmail.com> <CANP3RGc-9VkZkBK-N3y39F0Y+cLsPSLsQGvuR2QKAeQsWEoq9w@mail.gmail.com>
In-Reply-To: <CANP3RGc-9VkZkBK-N3y39F0Y+cLsPSLsQGvuR2QKAeQsWEoq9w@mail.gmail.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Thu, 16 Jun 2022 10:39:49 -0700
Message-ID: <CAKH8qBsB+DGMUBRCa4j+cWuGVg2_GLTZU4G_iun7wJ1GddaNHw@mail.gmail.com>
Subject: Re: Curious bpf regression in 5.18 already fixed in stable 5.18.3
To:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Linux NetDev <netdev@vger.kernel.org>,
        BPF Mailing List <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Sasha Levin <sashal@kernel.org>,
        Carlos Llamas <cmllamas@google.com>,
        YiFei Zhu <zhuyifei@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 16, 2022 at 9:41 AM Maciej =C5=BBenczykowski <maze@google.com> =
wrote:
>
> On Thu, Jun 16, 2022 at 8:57 AM Stanislav Fomichev <sdf@google.com> wrote=
:
> > On Wed, Jun 15, 2022 at 6:36 PM Maciej =C5=BBenczykowski <maze@google.c=
om> wrote:
> > > I'm guessing this means the regression only affects 64-bit archs,
> > > where long =3D void* is 8 bytes > u32 of 4 bytes, but not 32-bit ones=
,
> > > where long =3D u32 =3D 4 bytes
> > >
> > > Unfortunately my dev machine's 32-bit build capability has somehow
> > > regressed again and I can't check this.
> >
> > Seems so, yes. But I'm actually not sure whether we should at all
> > treat it as a regression. There is a question of whether that EPERM is
> > UAPI or not. That's why we most likely haven't caught it in the
> > selftests; most of the time we only check that syscall has returned -1
> > and don't pay attention to the particular errno.
>
> EFAULT seems like a terrible error to return no matter what, it has a ver=
y clear
> 'memory read/write access violation' semantic (ie. if you'd done from
> userspace you'd get a SIGSEGV)
>
> I'm actually surprised to learn you return EFAULT on positive number...
> It should rather be some unique error code or EINVAL or something.
>
> I know someone will argue that (most/all) system calls can return EFAULT.=
..
> But that's not actually true.  From a userspace developer the expectation=
 is
> they will not return EFAULT if you pass in memory you know is good.
>
> #include <sys/utsname.h>
> int main() {
>   struct utsname uts;
>   uname(&uts);
> }
>
> The above cannot EFAULT in spite of it being documented as the only
> error uname can report,
> because obviously the uts structure on the stack is valid memory.
>
> Maybe ENOSYS would at least make it obvious something is very weird.

I'd like to see less of the applications poking into errno and making
some decisions based on that. IMO, the only time where it makes sense
is EINTR/EAGAIN vs the rest; the rest should be logged. Having errnos
hard-coded in the tests is fine to make sure that the condition you're
testing against has been triggered; but still treating them as UAPI
might be too much, idk.

We had to add bpf_set_retval() because some of our and third party
libraries would upgrade to v6/v4 sockets only when they receive some
specific errno, which doesn't make a lot of sense to me.
