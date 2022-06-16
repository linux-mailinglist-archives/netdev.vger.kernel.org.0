Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C080C54E777
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 18:41:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235861AbiFPQlb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 12:41:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236039AbiFPQl0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 12:41:26 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C23E30578
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 09:41:20 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id u2so1314214iln.2
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 09:41:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=dTPMQR0mHE9evkO00QhR9CR5/21SYg0vv8s/EM7WqgI=;
        b=UtemJAUXqUPg5ShVWaXe4fvrufyjI7vlZozMITBSqGOGuCYZGv33E56lncaD7UaN+o
         4uV6pfr3s4K7xUy498alTg7lOqgVTsDA5V+wu2i2WfZOJyN+lbEA4qzQnTNJJLUWGMCx
         yublkKZFvcbOZE6MKnFdFP2jgFflMgw0ICxsIPhMnBf5wTOCIQLWNpztB7wnNeHa7ivH
         JBIaDCYsNXOkYs8rL6Y46W+olMKfe3vIJoZFHD7rIJCo4EOogpP3kMHTk3LAo2HdkplO
         TKsPudE2ogInV38V/WAyQiURS0sFavN42jkcGRO61tSZLyoZqKI6l2IrfQQoecCF6y++
         GP2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=dTPMQR0mHE9evkO00QhR9CR5/21SYg0vv8s/EM7WqgI=;
        b=o6Nayv/BCXAPcbva4nvlHh3lp1sJPAomtFgu0ADdY+U/dq5kNUjTyYi9RRBr7poygQ
         nCOow7L2Xeqv/eNARbNrrIVFX9Yboq7bogSNPBGeyNGobHsJLHssya8wUeZoOWB6qabl
         e/nvIUboTu79Dq+aA6jCVeUniTkgwc8pLsp3AvFbl7fNbatKLet8oHrJyUsmSdQ6xRUm
         h1KEt2ReU366aj9+lbITnV3B86lXXKNgE+V+5u2djIXqxZzaw7XMxHF/QjA1NqyUZcoJ
         1mK57Qg5XKxy3Npc3RSZvBnJQtmhvicBMb8OXuWXri7K/oNP8P9uIPfZ0X3G1KHsBd9L
         EMiw==
X-Gm-Message-State: AJIora+Ol9Gx6YtRpfAPUXwxh6+Q8ntmorVuNiwm5ia2GM6D/eHeTWBW
        DOM0gxtecN5f/7BOhZ5Y6e66oF5IZuh2870CsT5jeA==
X-Google-Smtp-Source: AGRyM1uxMgdiqs53mA6i4TSrN1IdTKIZKiwTZZcSLyj7Cr5mPOGk7F3bj/rEO9KPnqK0z0Z3INMyDZW470qfIjkdHz4=
X-Received: by 2002:a05:6e02:1607:b0:2d1:e622:3f0a with SMTP id
 t7-20020a056e02160700b002d1e6223f0amr3268345ilu.287.1655397679683; Thu, 16
 Jun 2022 09:41:19 -0700 (PDT)
MIME-Version: 1.0
References: <CAHo-Ooy+8O16k0oyMGHaAcmLm_Pfo=Ju4moTc95kRp2Z6itBcg@mail.gmail.com>
 <CANP3RGed9Vbu=8HfLyNs9zwA=biqgyew=+2tVxC6BAx2ktzNxA@mail.gmail.com>
 <CAADnVQKBqjowbGsSuc2g8yP9MBANhsroB+dhJep93cnx_EmNow@mail.gmail.com>
 <CANP3RGcZ4NULOwe+nwxfxsDPSXAUo50hWyN9Sb5b_d=kfDg=qg@mail.gmail.com>
 <YqodE5lxUCt6ojIw@google.com> <YqpAYcvM9DakTjWL@google.com>
 <YqpB+7pDwyOk20Cp@google.com> <YqpDcD6vkZZfWH4L@google.com>
 <CANP3RGcBCeMeCfpY3__4X_OHx6PB6bXtRjwLdYi-LRiegicVXQ@mail.gmail.com> <CAKH8qBv=+QVBqHd=9rAWe3d5d47dSkppYc1JbS+WgQs8XgB+Yg@mail.gmail.com>
In-Reply-To: <CAKH8qBv=+QVBqHd=9rAWe3d5d47dSkppYc1JbS+WgQs8XgB+Yg@mail.gmail.com>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Date:   Thu, 16 Jun 2022 09:41:04 -0700
Message-ID: <CANP3RGc-9VkZkBK-N3y39F0Y+cLsPSLsQGvuR2QKAeQsWEoq9w@mail.gmail.com>
Subject: Re: Curious bpf regression in 5.18 already fixed in stable 5.18.3
To:     Stanislav Fomichev <sdf@google.com>
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
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 16, 2022 at 8:57 AM Stanislav Fomichev <sdf@google.com> wrote:
> On Wed, Jun 15, 2022 at 6:36 PM Maciej =C5=BBenczykowski <maze@google.com=
> wrote:
> > I'm guessing this means the regression only affects 64-bit archs,
> > where long =3D void* is 8 bytes > u32 of 4 bytes, but not 32-bit ones,
> > where long =3D u32 =3D 4 bytes
> >
> > Unfortunately my dev machine's 32-bit build capability has somehow
> > regressed again and I can't check this.
>
> Seems so, yes. But I'm actually not sure whether we should at all
> treat it as a regression. There is a question of whether that EPERM is
> UAPI or not. That's why we most likely haven't caught it in the
> selftests; most of the time we only check that syscall has returned -1
> and don't pay attention to the particular errno.

EFAULT seems like a terrible error to return no matter what, it has a very =
clear
'memory read/write access violation' semantic (ie. if you'd done from
userspace you'd get a SIGSEGV)

I'm actually surprised to learn you return EFAULT on positive number...
It should rather be some unique error code or EINVAL or something.

I know someone will argue that (most/all) system calls can return EFAULT...
But that's not actually true.  From a userspace developer the expectation i=
s
they will not return EFAULT if you pass in memory you know is good.

#include <sys/utsname.h>
int main() {
  struct utsname uts;
  uname(&uts);
}

The above cannot EFAULT in spite of it being documented as the only
error uname can report,
because obviously the uts structure on the stack is valid memory.

Maybe ENOSYS would at least make it obvious something is very weird.
