Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A079233B00
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 23:50:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730587AbgG3Vuc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 17:50:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730552AbgG3Vub (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 17:50:31 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88B32C061574
        for <netdev@vger.kernel.org>; Thu, 30 Jul 2020 14:50:31 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id s189so22569284iod.2
        for <netdev@vger.kernel.org>; Thu, 30 Jul 2020 14:50:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=VpMH3i99yNG3+6gOmx+rNk+hjy8LJDF50RCmZMzxako=;
        b=ERjJm2fePleYiSDnmtnBnLtTPFywodmsLUf6BLs7DRW6dgqkxOWxz6XG9mZmQ9T8Tu
         I4Q86arpnq487R4xfkyL7TSYm01QpoeAwJ5F1mIaJS8X/XIig9NzlfjvzxG28RHkkvNi
         AAEB46Js9Gz+WnwCeNsVZIc25vvGqAU5KRG2XK0z+fAt5uLtRz0xYimvkKXQ0u0MtpRg
         DcjW4ZKKbgC62xgerdJ92GdfH15cqYJEqYqMeNcWBuRXI5NeaNcG2jo7wh+oXrwxnNIj
         2GnwLQvmB1jpeP7PJv/9pHUaDqeZNZxMT+ugR7bS2lMiaq9TVF64oNXMnTOMm4WgjzAM
         s2Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=VpMH3i99yNG3+6gOmx+rNk+hjy8LJDF50RCmZMzxako=;
        b=mqOscfWUDM1GEgxDPjPxlIQ4oF0S5qqDYDxVhpYoSj02SIU5YIvFEOR78sM3IHToEy
         UEb+vzsoA76xl+87lUAeCWR3pTLokdK2X+QCuKloFL8AP8rFsSfUpNYuXiP0PqP8oSoQ
         2v0YnDYGxX5FKnPbEb+aVEIEjpNcK87xCwNCQ9YDvZASPdX+YFOhXLzsnA0MYq7/IS2E
         EzWCVp04AWw/GzLrteIOTxf6LijULm2//lTe9kLlH8rUmdMKr2U+UntwP97KEZ26yl69
         gZDrkHjVkYMXtU1I1gWQLwLAiH5mXIsaTQPzyPMYk0Ah6G60m/d++CjE0xqIviesQ56d
         zeow==
X-Gm-Message-State: AOAM530o1kFOQd5QTj6//xxttkPc/ANovf6HJ/qzD/6TYlrBV09nCpWn
        aEmpUYqK6i7BBTA85dduuNqNG9s5PXOfildncCCNkK16
X-Google-Smtp-Source: ABdhPJz2M4t231GcSDDdCCSGMinAMWrBMRwgzOKIDdEuyQWIFiZi6aqqI/7Wrq+IQVgoKPjXRcW+jYWppn0IHRrwpPo=
X-Received: by 2002:a5e:c311:: with SMTP id a17mr660469iok.12.1596145830900;
 Thu, 30 Jul 2020 14:50:30 -0700 (PDT)
MIME-Version: 1.0
References: <1596019270-7437-1-git-send-email-wenxu@ucloud.cn>
 <CAM_iQpX89EE+zAc_hR9f=mw1bew5cMVMp1sC7i_fryUjegshnA@mail.gmail.com> <12ad0f21-a689-b889-237a-6441c3d0a194@ucloud.cn>
In-Reply-To: <12ad0f21-a689-b889-237a-6441c3d0a194@ucloud.cn>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 30 Jul 2020 14:50:19 -0700
Message-ID: <CAM_iQpXHu=6+c0HkutK5Bb5DoxM8fbas1Z6r6EC+tEXMGdudGw@mail.gmail.com>
Subject: Re: [PATCH net] net/sched: act_ct: fix miss set mru for ovs after
 defrag in act_ct
To:     wenxu <wenxu@ucloud.cn>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 30, 2020 at 1:53 AM wenxu <wenxu@ucloud.cn> wrote:
>
>
> On 7/30/2020 2:03 PM, Cong Wang wrote:
> > On Wed, Jul 29, 2020 at 3:41 AM <wenxu@ucloud.cn> wrote:
> >> diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
> >> index c510b03..45401d5 100644
> >> --- a/include/net/sch_generic.h
> >> +++ b/include/net/sch_generic.h
> >> @@ -384,6 +384,7 @@ struct qdisc_skb_cb {
> >>         };
> >>  #define QDISC_CB_PRIV_LEN 20
> >>         unsigned char           data[QDISC_CB_PRIV_LEN];
> >> +       u16                     mru;
> >>  };
> > Hmm, can you put it in the anonymous struct before 'data'?
> >
> > We validate this cb size and data size like blow:
> >
> > static inline void qdisc_cb_private_validate(const struct sk_buff *skb,=
 int sz)
> > {
> >         struct qdisc_skb_cb *qcb;
> >
> >         BUILD_BUG_ON(sizeof(skb->cb) < offsetof(struct qdisc_skb_cb,
> > data) + sz);
> >         BUILD_BUG_ON(sizeof(qcb->data) < sz);
> > }
> >
> > It _kinda_ expects ->data at the end.
>
> It seems the data offsetof data should be align with szieof(u64)?
>
> If I  modify it as following
>
> @@ -383,6 +383,9 @@ struct qdisc_skb_cb {
>                 unsigned int            pkt_len;
>                 u16                     slave_dev_queue_mapping;
>                 u16                     tc_classid;
> +               u16                     mru;
>         };
>  #define QDISC_CB_PRIV_LEN 20
>         unsigned char           data[QDISC_CB_PRIV_LEN];
>
> compile fail:
>
> net/core/filter.c:7625:3: note: in expansion of macro =E2=80=98BUILD_BUG_=
ON=E2=80=99
>    BUILD_BUG_ON((offsetof(struct sk_buff, cb) +
>
> inn the file:  net/core/filter.c
>
> case offsetof(struct __sk_buff, cb[0]) ...
>
>              offsetofend(struct __sk_buff, cb[4]) - 1:
>                 BUILD_BUG_ON(sizeof_field(struct qdisc_skb_cb, data) < 20=
);
>                 BUILD_BUG_ON((offsetof(struct sk_buff, cb) +
>                               offsetof(struct qdisc_skb_cb, data)) %
>                              sizeof(__u64));
>
>
> If I  modify it as following
>
> @@ -383,6 +383,9 @@ struct qdisc_skb_cb {
>                 unsigned int            pkt_len;
>                 u16                     slave_dev_queue_mapping;
>                 u16                     tc_classid;
> +               u16                     mru;
> +               u16                     _pad1;
> +               u32                     _pad2;
>         };
>  #define QDISC_CB_PRIV_LEN 20
>         unsigned char           data[QDISC_CB_PRIV_LEN];
>
>
> compile fail:
>
> ./include/linux/filter.h:633:2: note: in expansion of macro =E2=80=98BUIL=
D_BUG_ON=E2=80=99
>   BUILD_BUG_ON(sizeof(*cb) > sizeof_field(struct sk_buff, cb));
>
>
> static inline void bpf_compute_data_pointers(struct sk_buff *skb)
> {
>         struct bpf_skb_data_end *cb =3D (struct bpf_skb_data_end *)skb->c=
b;
>
>         BUILD_BUG_ON(sizeof(*cb) > sizeof_field(struct sk_buff, cb));
>         cb->data_meta =3D skb->data - skb_metadata_len(skb);
>         cb->data_end  =3D skb->data + skb_headlen(skb);
> }
>
>
> It seems no space for new value add before 'data'?

Hmm, I didn't know bpf has such restrictions on qdisc_skb_cb.
It seems impossible to add a new field before data, if you keep it
after data, can you adjust qdisc_cb_private_validate() too, like below?

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index c510b03b9751..68235489a5d4 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -463,7 +463,7 @@ static inline void qdisc_cb_private_validate(const
struct sk_buff *skb, int sz)
 {
        struct qdisc_skb_cb *qcb;

-       BUILD_BUG_ON(sizeof(skb->cb) < offsetof(struct qdisc_skb_cb,
data) + sz);
+       BUILD_BUG_ON(sizeof(skb->cb) < sizeof(*qcb));
        BUILD_BUG_ON(sizeof(qcb->data) < sz);
 }

Thanks.
