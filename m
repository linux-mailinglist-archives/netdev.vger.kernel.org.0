Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18CFC2B9D15
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 22:49:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726575AbgKSVp5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 16:45:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726159AbgKSVp5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 16:45:57 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E36B5C0613CF
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 13:45:56 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id b63so5766093pfg.12
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 13:45:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=adY2gOdI7eN0sjh6fiUAn08VuJZ2PFESMipzyNvraM0=;
        b=cPcb7kP+lNFejWMRmCmH3XD2T8RmhNrsi3uMb36tCmKnY7z8Q0PpPFDaQ/W+27wPQx
         vij9EWwDWZv2zkIw393CH7kYf/Xz51HXlUlAITfDCYJnxZcJfDDDo/jCiP+k+nqaA+IN
         1oVqYzk6fcB3f3cM1FOHdIX1JFQHwgo8hvXsYgdVR55xh42raQSebFU8cD7kf8yUEhqN
         ZnID3VvtCW/KFvHC7F+UYdBPRW3se9YS1MDty03aMvOHhXhz4DFYKqg1MmRAwOVFNFJ1
         jFk7Csx27ElSHItXEewF4Wm5k8O8dPr5RvFqPNCnmf5hDgMYIvwOu9dVQhpMuI/KKH14
         kMag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=adY2gOdI7eN0sjh6fiUAn08VuJZ2PFESMipzyNvraM0=;
        b=MG4tTpJ9mCWpp/Fbu+zWpDMrgkFulwn2mPzWXmqu2zk2XEL3ENHkyeTIhTwVa6AK0d
         q1sFHUKuFVvGqO+XPdJTY9R9EgRWcSDYfykoV98OIXffdVoYIMoudXVVLDF5urPFdRge
         h6aXXt89VKYuDfDPTimTnHQPsZTDTYsMvEbwodBl5PWPkQho+sPmK/8dWuoPWSFMxlJR
         3+RWka5bfmmT1wwp8kaWeIOm8vGBsFhBQE8Um3Eu33mSmltompkWk5bp5cuDaznCMJMw
         KLdbC0yc/JZ92KNTwkkmnkPsHQ7GB8wMvqXTBZIXl9zi0AxVkt4gNsaioLV7hY673nAW
         vaIA==
X-Gm-Message-State: AOAM530GYzThINLrkYG6YD2dxIa/KMirLmXlzrh81W//mYE4UbwCuYRK
        iB3CNklF4iVOUNfIvfm0haC1MiNyEr9VwwTBpxw=
X-Google-Smtp-Source: ABdhPJwI4DnPJsCo7aGNErL9ghQ5XCswi2tb7Z0B9Sn26Yg6GplyTEDF2sUy5JhGVXLTUhahrPTlPXXBv2hozDvBvyg=
X-Received: by 2002:aa7:84da:0:b029:197:911b:7103 with SMTP id
 x26-20020aa784da0000b0290197911b7103mr8292217pfn.10.1605822356425; Thu, 19
 Nov 2020 13:45:56 -0800 (PST)
MIME-Version: 1.0
References: <1605663468-14275-1-git-send-email-wenxu@ucloud.cn>
 <CAM_iQpVoFrZ9gFNFUsqtt=12OS_Cs+vpokgNCB0eQiBf=hD4dA@mail.gmail.com> <bf2b3221-2325-c913-be30-2db543e6e1e1@ucloud.cn>
In-Reply-To: <bf2b3221-2325-c913-be30-2db543e6e1e1@ucloud.cn>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 19 Nov 2020 13:45:45 -0800
Message-ID: <CAM_iQpVu7kke6jqGpoqbnKxJU3SdpQG2WBi-GJ18NrVyrc_W2A@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 3/3] net/sched: sch_frag: add generic packet
 fragment support.
To:     wenxu <wenxu@ucloud.cn>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 18, 2020 at 12:04 AM wenxu <wenxu@ucloud.cn> wrote:
>
>
> =E5=9C=A8 2020/11/18 15:00, Cong Wang =E5=86=99=E9=81=93:
> > On Tue, Nov 17, 2020 at 5:37 PM <wenxu@ucloud.cn> wrote:
> >> From: wenxu <wenxu@ucloud.cn>
> >>
> >> Currently kernel tc subsystem can do conntrack in cat_ct. But when sev=
eral
> >> fragment packets go through the act_ct, function tcf_ct_handle_fragmen=
ts
> >> will defrag the packets to a big one. But the last action will redirec=
t
> >> mirred to a device which maybe lead the reassembly big packet over the=
 mtu
> >> of target device.
> >>
> >> This patch add support for a xmit hook to mirred, that gets executed b=
efore
> >> xmiting the packet. Then, when act_ct gets loaded, it configs that hoo=
k.
> >> The frag xmit hook maybe reused by other modules.
> >>
> >> Signed-off-by: wenxu <wenxu@ucloud.cn>
> >> ---
> >> v2: make act_frag just buildin for tc core but not a module
> >>     return an error code from tcf_fragment
> >>     depends on INET for ip_do_fragment
> > Much better now.
> >
> >
> >> +#ifdef CONFIG_INET
> >> +               ret =3D ip_do_fragment(net, skb->sk, skb, sch_frag_xmi=
t);
> >> +#endif
> >
> > Doesn't the whole sch_frag need to be put under CONFIG_INET?
> > I don't think fragmentation could work without CONFIG_INET.
>
> I have already test with this. Without CONFIG_INET it is work.
>
> And only the ip_do_fragment depends on CONFIG_INET

Passing the compiler test is not what I meant. The whole ipv4/ directory
is under CONFIG_INET:

 obj-$(CONFIG_INET)              +=3D ipv4/

Without it, what code does the fragmentation? I suggest you to just put
the sch_frag in this way:

obj-$(CONFIG_INET)              +=3D sch_frag.o

(and remove the #ifdef CONFIG_INET within it.)

Thanks.
