Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB42A6C3D6B
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 23:09:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbjCUWJl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 18:09:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbjCUWJj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 18:09:39 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C56995615A;
        Tue, 21 Mar 2023 15:09:34 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id h12-20020a17090aea8c00b0023d1311fab3so17356609pjz.1;
        Tue, 21 Mar 2023 15:09:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679436574;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tsRbT/5MMXMxcAk8N+i/fTziq3kim6D0QWwbG9rtlf4=;
        b=XuqzquK88NROJPf3dyCxGUZu+xmfeuIkiGlo6ConrovDA11DGaRodJ3VsPB0TomfJl
         NcvP64iGJ94YmAIueBftdq/mcemcLh1NOhbEWjO3V+bwgo6GlFTwlM/Lu/hW4TEOzWid
         5bmXF5nUlZaHf8nUVnIdDxUb/cfbj+A+JFWObVj5tICmzQJWCe+DryrdYYB85Bn6kc1D
         VFNyXfpF4a09ac2U/ua1nnjgn+MRg0lXt4KCgM6qDcwti9TBlXrN1ncqr1+KmIlhS+zy
         XMZZda95UHkYZKp0k8540Wt148rDbsTmrlKaMJ/Eadq96bO8eFo2aZxIxpaQIJ37vq3Z
         A8Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679436574;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=tsRbT/5MMXMxcAk8N+i/fTziq3kim6D0QWwbG9rtlf4=;
        b=xKb06uo1JF5ZvhdAYEL6iGUwuMsKKq2IfNGM3Ty+xVKioDgl86EMYosNwwNPxy4LYe
         oTIyQIoaua5TWR2cVMqLm1ZmdABswYjCFHIPwvxJBUAhZ5WtmwDgziH8IK9Exs/wWOYF
         aW9ECdWmEvrqUlNcS+mJ3vE6+CQAIGQlQMpw4oMQjJQub8kBt2UmcT/WGHmtTud+1kH3
         mJi26j3i/kOzP97nfmfiL/5a1RIhH0iG8+1Km/THkw6Cnb1SK+ZP0dZA6UPfJtsE6O4l
         pXtQ/px97h+QBc/46irfNSf8phCoPwgmeeQNa9mmzisziLfke0JA1EbA3cPTSo8hUF1v
         bmtg==
X-Gm-Message-State: AO0yUKW00PZF8RNjjXoSX2N4SsGsvyTqaolKL6sH+O99TDd5tJbA81jG
        9ap02xKcIPhOtxl8XlZ6V6FF7g68buk=
X-Google-Smtp-Source: AK7set8lPP3NF9/KA+up+tavwh7XQ9NT1WxNxtAT8PICrk4eP9I7r1B2R7u83BU1TKQAj1TCWLaoSw==
X-Received: by 2002:a17:903:2312:b0:1a1:c7b2:e7c7 with SMTP id d18-20020a170903231200b001a1c7b2e7c7mr596907plh.49.1679436574130;
        Tue, 21 Mar 2023 15:09:34 -0700 (PDT)
Received: from localhost ([98.97.36.54])
        by smtp.gmail.com with ESMTPSA id io7-20020a17090312c700b001a1ca6dc38csm5333129plb.118.2023.03.21.15.09.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 15:09:33 -0700 (PDT)
Date:   Tue, 21 Mar 2023 15:09:32 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Eric Dumazet <edumazet@google.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     jakub@cloudflare.com, daniel@iogearbox.net, lmb@isovalent.com,
        cong.wang@bytedance.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@kernel.org, andrii@kernel.org,
        will@isovalent.com
Message-ID: <641a2b1c44846_80a24208b9@john.notmuch>
In-Reply-To: <CANn89iKFtrcbAtOZ9dppkm4AaqaQysh0r1suV9hQ5vg-zp3zZg@mail.gmail.com>
References: <20230321215212.525630-1-john.fastabend@gmail.com>
 <20230321215212.525630-6-john.fastabend@gmail.com>
 <CANn89iKFtrcbAtOZ9dppkm4AaqaQysh0r1suV9hQ5vg-zp3zZg@mail.gmail.com>
Subject: Re: [PATCH bpf 05/11] bpf: sockmap, TCP data stall on recv before
 accept
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
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

Eric Dumazet wrote:
> On Tue, Mar 21, 2023 at 2:52=E2=80=AFPM John Fastabend <john.fastabend@=
gmail.com> wrote:
> >
> > A common mechanism to put a TCP socket into the sockmap is to hook th=
e
> > BPF_SOCK_OPS_{ACTIVE_PASSIVE}_ESTABLISHED_CB event with a BPF program=

> > that can map the socket info to the correct BPF verdict parser. When
> > the user adds the socket to the map the psock is created and the new
> > ops are assigned to ensure the verdict program will 'see' the sk_buff=
s
> > as they arrive.
> >

[...]

> >         lock_sock(sk);
> > +
> > +       /* We may have received data on the sk_receive_queue pre-acce=
pt and
> > +        * then we can not use read_skb in this context because we ha=
ven't
> > +        * assigned a sk_socket yet so have no link to the ops. The w=
ork-around
> > +        * is to check the sk_receive_queue and in these cases read s=
kbs off
> > +        * queue again. The read_skb hook is not running at this poin=
t because
> > +        * of lock_sock so we avoid having multiple runners in read_s=
kb.
> > +        */
> > +       if (unlikely(!skb_queue_empty_lockless(&sk->sk_receive_queue)=
)) {
> =

> socket is locked here, please use skb_queue_empty() ?
> =

> We shall reserve skb_queue_empty_lockless() for lockless contexts.

Yep will do thanks.
