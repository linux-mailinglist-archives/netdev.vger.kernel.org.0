Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7905054EC64
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 23:22:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231809AbiFPVWL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 17:22:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiFPVWK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 17:22:10 -0400
Received: from mail-ua1-x92b.google.com (mail-ua1-x92b.google.com [IPv6:2607:f8b0:4864:20::92b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33EFE60DAD
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 14:22:08 -0700 (PDT)
Received: by mail-ua1-x92b.google.com with SMTP id p3so885356uam.12
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 14:22:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=XVQd/SgXZLRuRmMIGN/DMK4EEnq4Mpa7NViaJPiOT1U=;
        b=UrPYn+Zvrx68XxDJ0EyOE9WCHRU7uXnPfmzCJm2a2x+4yxxCAQwrcMvN7L94uAKbIn
         LMAetiuCxHKURRz1S7VbVcISmX34CccvvUiqjHcD9ZgGPVwt+GNJbkuMCIGUdtfishRg
         od6VxHCphVkRnM+Piy7pn+hdGtsvvsJyyaYv8kdydmChI5GKpLVshfksdU2yOWT1ZVr1
         rZAGZU7oseeI0nY7wOiUvsnlyH/2OLOxcflfsoUOZg/mIBUqIJrHpfnG1xTre+9lDw2Z
         M5eEdt0OF7tLJPlpZSPnbOSIR3KVYRIWyT9et2t8J4lqJrVmj3OTbeJCqLqjzpT8QAJG
         z/OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=XVQd/SgXZLRuRmMIGN/DMK4EEnq4Mpa7NViaJPiOT1U=;
        b=Odv3lApW+Y4W8vVfl2QZRBtSCPXpjVPmy1vBo7uwVzSQYOXXzGxuWIwAtK9+gxqQsv
         quOywG2/aABDuslfqmmiQazPo0xyDFRP19DV+FVkH9tD1WfdvEXVI3uFqWCG+RQqKeTQ
         oPXKO0UedeE3YgUwHBb9LhzjBQN6FkzkuaAFtVZdeeosrS34RBogEt66dBGU6a4TX/1F
         +m+fKa+Mpgn8rZQrAfiOngk6kl6wEugNQz38VH4kNxgPqkJTmTa03mOt3gkZhNFTKzxk
         BZXCS7s9EqFbIdpO8+6jRvuTX6tZC6GECukq9yte2vnxNfe36kwppTfycUKlEnhk7qmK
         iOTA==
X-Gm-Message-State: AJIora9SBjCbpW4VL2EQ07X3dVKPdxH9qXBlCHeR+ufKFg8UDfBHZEQm
        noSwwwhIXf4JykMnR/VlVVVnNIWCtruMFyPj7RC/Qg==
X-Google-Smtp-Source: AGRyM1vqZPN9CRFMWXr2JMGAHgPTKRyf6AVgLpPkKZyrabFXkklVhBz0brkzb4tSoUSkz3SuLHRzzORrJuuY1eKsDP0=
X-Received: by 2002:ab0:4983:0:b0:369:186d:b91d with SMTP id
 e3-20020ab04983000000b00369186db91dmr2981436uad.116.1655414527202; Thu, 16
 Jun 2022 14:22:07 -0700 (PDT)
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
From:   YiFei Zhu <zhuyifei@google.com>
Date:   Thu, 16 Jun 2022 14:21:56 -0700
Message-ID: <CAA-VZPmPQGT76skZjwQ5OE9uR1=pwXXNErxJPwrEnKMVxec=8Q@mail.gmail.com>
Subject: Re: Curious bpf regression in 5.18 already fixed in stable 5.18.3
To:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Cc:     Stanislav Fomichev <sdf@google.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Linux NetDev <netdev@vger.kernel.org>,
        BPF Mailing List <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Sasha Levin <sashal@kernel.org>,
        Carlos Llamas <cmllamas@google.com>
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

I chose EFAULT because the original code of getsockopt hook returns
-EFAULT if the retval is set to a number that isn't zero or the
original value. i.e., in c4dcfdd406aa^, there was:

  /* BPF programs only allowed to set retval to 0, not some
   * arbitrary value.
   */
  if (ctx.retval !=3D 0 && ctx.retval !=3D retval) {
          ret =3D -EFAULT;
          goto out;
  }

I understood that as the convention that if a BPF program does
something illegal at runtime, return -EFAULT.

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
