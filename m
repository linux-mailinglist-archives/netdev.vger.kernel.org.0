Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E884F4C0B46
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 05:48:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233044AbiBWEtO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 23:49:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231172AbiBWEtN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 23:49:13 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 478401277B
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 20:48:44 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id e140so45532153ybh.9
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 20:48:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ezkZQLw1rVr1GX7ZTil8Ns0U9+6O4LGASFHlroo1t4Y=;
        b=MsolJfGfbjaT6S7LRgE7ZzsRIz9GGywtZpGVHT0Sc/5mu1KHfOzctqwZOrTMrE5FWi
         NPzXFwRrbunEj2sHPxrLJzOzy6IvfPj48uS/bIlded9gO9zo1z3EA9QfLZpjC909Ww+T
         07/fhB2gURlLnnfkUIsU/KEiPjvhP4OZkJUCviKYi8cQudo5HWt8xKIH7oeJyIitnawr
         i1TwGwGswxuPpj2hI5n8pxaJS8Wxx3haLN7d50Acd+BKOWRmbseChdE5T+Ek7/yr62OV
         W30Qxj+mEPjyQal+HavtlGz/qNE2PdvDO2X0796JCUahm+zY7+Z0E2akoxppwg5mcgos
         2fqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ezkZQLw1rVr1GX7ZTil8Ns0U9+6O4LGASFHlroo1t4Y=;
        b=rReWTEa8RQJEgirvSqjjUSPCmgqRd0YW/iHiCIcHiIrxNKyeOgxYexcTYmdn8trSCt
         riDqJgZDWJIMolH8XnW5DYthoALDhcCPr1+NSlxP18YO4Am4N/ZWeNTeDtcZPoo6YVHL
         Vx84c0cabrD/iBi826YjaWjs8uy75c2NRXW2/btg221HmI/r/7iReuvP2uzd85TLS9MB
         r7SqyGVprZyJlWrAunAOrkF5FktasRu2J+G7R9NJQn7HqNbwUB7wruvcebNeYBl2zI22
         9YvbNOwJinOHEf0H5Oosty2ifOdiuH9v0JmAad9Lgaexm+aNLfnNaUssXCWZDkFXFDgk
         hdiA==
X-Gm-Message-State: AOAM5322wATtyVkeA0RdRw1tGgyqcw7iuX+vENwdHH+YJNCcaWwHvB1O
        4wOc49jUFKzv5n3P+5gifqoxMgLTlzitfHHdw8KeSEffHmBKHfD6
X-Google-Smtp-Source: ABdhPJwzZNjmWUlbqcLv5E9B/m8md/qRks+uVVSkU3xa/YCFfvXqlx7Ew0hq/hFG56atltbbAC3r7VmJBP1x7mcqtnc=
X-Received: by 2002:a5b:7c6:0:b0:60b:a0ce:19b with SMTP id t6-20020a5b07c6000000b0060ba0ce019bmr25959429ybq.407.1645591723059;
 Tue, 22 Feb 2022 20:48:43 -0800 (PST)
MIME-Version: 1.0
References: <20220222032113.4005821-1-eric.dumazet@gmail.com>
 <164558941044.26093.15086204600598443366.git-patchwork-notify@kernel.org> <20220222201518.37122ca8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220222201518.37122ca8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 22 Feb 2022 20:48:32 -0800
Message-ID: <CANn89iLYCkfKGQd==t8NrKmrH5sVbUVmCf=2bwmRHgrG1Jywvw@mail.gmail.com>
Subject: Re: [PATCH net-next 0/2] tcp: take care of another syzbot issue
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     patchwork-bot+netdevbpf@kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Marco Elver <elver@google.com>
Content-Type: text/plain; charset="UTF-8"
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

On Tue, Feb 22, 2022 at 8:15 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 23 Feb 2022 04:10:10 +0000 patchwork-bot+netdevbpf@kernel.org
> wrote:
> >   - [net-next,2/2] net: preserve skb_end_offset() in skb_unclone_keeptruesize()
> >     (no matching commit)
>
> I dropped the extra new lines around the body of
> skb_unclone_keeptruesize()

Thanks !
