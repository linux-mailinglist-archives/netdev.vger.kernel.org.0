Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5D3430BD0D
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 12:30:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231443AbhBBL2V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 06:28:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231194AbhBBL1Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 06:27:24 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D1BEC061573;
        Tue,  2 Feb 2021 03:26:44 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id 8so6962549plc.10;
        Tue, 02 Feb 2021 03:26:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=YQTLhZR3hDf/41Do9Wuvt9T1ewGnoc9cSUmCkbXo2v4=;
        b=QMbZAzTLylWpjRpuDOf7MOcTUsDSZ4g61Vu+tL8Vlb+zyCPrEPOw3Lr5G7vPtsZC06
         WGQC4t+KMz6odoGASegp3HmEMasvbRYGu0e1vsJixEIrDR93B6yqL3mTV6B35T+bxI96
         /230yhbqa5y5Y0XSLMcFU6oWnbRmgaSIbEZv+UWdkVbOILGXpwiYyIVhEamToGW4ZM+D
         rpecn+hjffYEB8pxDtd4MwWXH3VSpI5iIM498LV2lyHF5yN9a4ayg4lSwDwVZ4ayscFz
         x71JscBMiC6gZJpb1MCuDBDUbkQmyBgrk+AI0CBss/SnSJLR9QZCTUmJIp3IhkJtulhC
         +/0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=YQTLhZR3hDf/41Do9Wuvt9T1ewGnoc9cSUmCkbXo2v4=;
        b=kamWir1PqDzFg0oPiYt/HYO9LqGqNToMCnO8GgBi+Yilx+pqWdBOX8exjYElhNvism
         8PlL3DjyTbkKjZBxiY1xOds9Zsa/JE+tGZZhEXVUgjRkqJpLIix9fVzmwxL2gQ9s2xge
         mMD6vV0HHGmtUprb31PXiZ2d5qVjLCGyxfHzJAjmDetkSADQ/j6g8fX5SbCTY/x4Hmux
         BH6BMhBD26ddXmfVfZLn1t6QJ5PUY8I7f2gP+Sptjp1Db0fE20abCjPi+ECQcbsLlNYY
         Icec2Bu2REQ+0Q9NHkiMqZ/0Uzf4T6k6PmIMb1IMqzNYhS8om7GsT72vxuzYhiM1BMRR
         Uenw==
X-Gm-Message-State: AOAM531d5qinC4MjdvpTSpah/kRSv3BYwCeI1MzWMNlEK9EvIeDkad0o
        p/cAeB4myUqr3FFZeVz0iNSL5lSYvBiQCoabjYACt3294smsvw==
X-Google-Smtp-Source: ABdhPJwakZ1GnIoxdbhWs9AnFYxkfFUhHiGw0yRpMlAGmAPk6odqH0k51T9mGKOI0yhL1mZsfDwMb4mCvPVYIt/KU6g=
X-Received: by 2002:a17:902:7b89:b029:e1:1b46:bcec with SMTP id
 w9-20020a1709027b89b02900e11b46bcecmr21704504pll.5.1612265203527; Tue, 02 Feb
 2021 03:26:43 -0800 (PST)
MIME-Version: 1.0
References: <20201204102901.109709-1-marekx.majtyka@intel.com>
 <20201204102901.109709-2-marekx.majtyka@intel.com> <878sad933c.fsf@toke.dk>
 <20201204124618.GA23696@ranger.igk.intel.com> <048bd986-2e05-ee5b-2c03-cd8c473f6636@iogearbox.net>
 <20201207135433.41172202@carbon> <5fce960682c41_5a96208e4@john-XPS-13-9370.notmuch>
 <20201207230755.GB27205@ranger.igk.intel.com> <5fd068c75b92d_50ce20814@john-XPS-13-9370.notmuch>
 <20201209095454.GA36812@ranger.igk.intel.com> <20201209125223.49096d50@carbon>
 <e1573338-17c0-48f4-b4cd-28eeb7ce699a@gmail.com> <1e5e044c8382a68a8a547a1892b48fb21d53dbb9.camel@kernel.org>
 <cb6b6f50-7cf1-6519-a87a-6b0750c24029@gmail.com> <f4eb614ac91ee7623d13ea77ff3c005f678c512b.camel@kernel.org>
 <d5be0627-6a11-9c1f-8507-cc1a1421dade@gmail.com> <6f8c23d4ac60525830399754b4891c12943b63ac.camel@kernel.org>
 <CAAOQfrHN1-oHmbOksDv-BKWv4gDF2zHZ5dTew6R_QTh6s_1abg@mail.gmail.com> <87h7mvsr0e.fsf@toke.dk>
In-Reply-To: <87h7mvsr0e.fsf@toke.dk>
From:   Marek Majtyka <alardam@gmail.com>
Date:   Tue, 2 Feb 2021 12:26:32 +0100
Message-ID: <CAAOQfrHA+-BsikeQzXYcK_32BZMbm54x5p5YhAiBj==uaZvG1w@mail.gmail.com>
Subject: Re: [PATCH v2 bpf 1/5] net: ethtool: add xdp properties flag set
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Saeed Mahameed <saeed@kernel.org>, David Ahern <dsahern@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, hawk@kernel.org,
        bpf <bpf@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        jeffrey.t.kirsher@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks Toke,

In fact, I was waiting for a single confirmation, disagreement or
comment. I have it now. As there are no more comments, I am getting
down to work right away.

Marek




On Mon, Feb 1, 2021 at 5:16 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redha=
t.com> wrote:
>
> Marek Majtyka <alardam@gmail.com> writes:
>
> > I would like to thank you for your time, comments, nitpicking as well
> > as encouraging.
> >
> > One thing needs clarification I think, that is, that those flags
> > describe driver static feature sets - which are read-only. They have
> > nothing in common with driver runtime configuration change yet.
> > Runtime change of this state can be added but it needs a new variable
> > and it can be done later on if someone needs it.
> >
> > Obviously, it is not possible to make everybody happy, especially with
> > XDP_BASE flags set. To be honest, this XDP_BASE definition is a
> > syntactic sugar for me and I can live without it. We can either remove
> > it completely, from
> > which IMO we all and other developers will suffer later on, or maybe
> > we can agree on these two helper set of flags: XDP_BASE (TX, ABORTED,
> > PASS, DROP) and XDP_LIMITED_BASE(ABORTED,PASS_DROP).
> > What do you think?
> >
> > I am also going to add a new XDP_REDIRECT_TARGET flag and retrieving
> > XDP flags over rtnelink interface.
> >
> > I also think that for completeness, ethtool implementation should be
> > kept  together with rtnelink part in order to cover both ip and
> > ethtool tools. Do I have your approval or disagreement? Please let me
> > know.
>
> Hi Marek
>
> I just realised that it seems no one actually replied to your email. On
> my part at least that was because I didn't have any objections, so I'm
> hoping you didn't feel the lack of response was discouraging (and that
> you're still working on a revision of this series)? :)
>
> -Toke
>
