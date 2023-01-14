Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B948F66AD0B
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 18:24:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230318AbjANRYx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Jan 2023 12:24:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230260AbjANRYw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Jan 2023 12:24:52 -0500
Received: from mail-yw1-x1135.google.com (mail-yw1-x1135.google.com [IPv6:2607:f8b0:4864:20::1135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3868B83CD
        for <netdev@vger.kernel.org>; Sat, 14 Jan 2023 09:24:51 -0800 (PST)
Received: by mail-yw1-x1135.google.com with SMTP id 00721157ae682-4e4a6af2d99so7479187b3.4
        for <netdev@vger.kernel.org>; Sat, 14 Jan 2023 09:24:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=P00O6nH/OPilJepkfeM0nS4sFlqxV3kvFSBK1AWj60Y=;
        b=EV0GuMGr3usAop2xO05uxX9zEM72W1bEU4YNaAlQl+KZYIEroxwzKJExS3bZ0mzl/H
         pt4lJCipWdD7hjV+sA74XHyYxbB/Y76zUDm52ph2ONjOKyPSFyxMxL0MdQqbLQJyu4Q5
         DHTbubk9wUx4TKQqBEkuhKKkAoCV4fi7IwJ4Gxf7EqZ9FE2bl6JXet/4nvwmP8BYGh/n
         xJSI9HWH2Y1MhgWccrXCt4L5m02YIQXiwbEjVUtzTIZsoXttNY7pUvTLU7xT5Wv70lzk
         w1GvztkLyzB9pUL000qa+brHCx5dizqakVKVWqRFGREgH2suYcGNnYtfQYhjvwPhIE2j
         ERZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=P00O6nH/OPilJepkfeM0nS4sFlqxV3kvFSBK1AWj60Y=;
        b=Du7PeeLAMdIOqjVpJRrJp6P9wSl5AkGeOElnPDXrGeR5okQN0aOowYAZug12gKpuNZ
         lELxsMyAokqnwbeeLV+gGswDUBhTNpAkU54Lbl8hRIrAl+KB8qnDUegEC1VnuXBscgCl
         GINDPZfGXii7gXuFFcvZZJvl/dGvFjGTUey3+EhlBIRp+YaqbfL/VVW798LPob2JPHQp
         bWD3YxXEUhQ390pZhSPmpDbYDKZONA4FQnSeaQwJexyatBIpLA0CtbwB/J+OXf8kOaN2
         jyZDYobVIDH+Ay6cIUSPVBftxTnQeLJmApcpI67dM51ioFvdQ46373Fqb2ATWvGkVrdr
         4LCQ==
X-Gm-Message-State: AFqh2krPtUK4bznyzOukYr/9FZ7OlM2Yqwn38ApxYrKFDxTAooiYmD3R
        FHVKrx0ExkzZhydPLgScxsk+3YeYdcsihsJW3ec=
X-Google-Smtp-Source: AMrXdXt/BK5pHSW/VevtQ90Ea4HjDoBj5UjLmIDaEOchh047hSK++s5Z2GudTq1uT9e0PEXw19RRgXYb59I0/6y1PUQ=
X-Received: by 2002:a05:690c:78a:b0:3c7:ef88:b857 with SMTP id
 bw10-20020a05690c078a00b003c7ef88b857mr3060615ywb.253.1673717090271; Sat, 14
 Jan 2023 09:24:50 -0800 (PST)
MIME-Version: 1.0
References: <cover.1673483994.git.lucien.xin@gmail.com> <f29babd921a1842b7f953c56175cf2cd2abe7bc8.1673483994.git.lucien.xin@gmail.com>
 <20230113213307.17c32270@kernel.org>
In-Reply-To: <20230113213307.17c32270@kernel.org>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Sat, 14 Jan 2023 12:23:32 -0500
Message-ID: <CADvbK_fh_PymvEP3Qm-0kNY1Ne0SshH==agE5+M1DCkiSTGujw@mail.gmail.com>
Subject: Re: [PATCHv2 net 1/2] ipv6: prevent only DAD and RS sending for IFF_NO_ADDRCONF
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 14, 2023 at 12:33 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 11 Jan 2023 19:41:56 -0500 Xin Long wrote:
> > So instead of preventing all the ipv6 addrconf, it makes more sense to
> > only prevent DAD and RS sending for the slave ports: Firstly, check
> > IFF_NO_ADDRCONF in addrconf_dad_completed() to prevent RS as it did in
> > commit b52e1cce31ca ("ipv6: Don't send rs packets to the interface of
> > ARPHRD_TUNNEL"), and then also check IFF_NO_ADDRCONF where IFA_F_NODAD
> > is checked to prevent DAD.
>
> Maybe it's because I'm not an ipv6 expert but it feels to me like we're
> getting into intricate / hacky territory. IIUC all addresses on legs of
> bond/team will silently get nodad behavior? Isn't that risky for a fix?
Understand.
I was actually thinking this would be less risky than completely disabling
ipv6 addrconf for IFF_NO_ADDRCONF.

>
> Could we instead revert 0aa64df30b38 and take this via net-next?
Fair enough.
I will send a revert of 0aa64df30b38.
Let's take a step back and think about doing it via net-next.

>
> Alternatively - could the team user space just tell the kernel what
> behavior it wants? Instead of always putting the flag up, like we did
> in 0aa64df30b3, do it only when the user space opts in?
Like when knowing nsna_ping link watch is used, but it is loaded after
the port is added in libteam, and yet the kernel has no idea what link
watch is used in userspace.
Jiri?

Thanks.
