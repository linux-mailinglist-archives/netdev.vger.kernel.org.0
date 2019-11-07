Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F691F2CCB
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 11:50:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388074AbfKGKuE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 05:50:04 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38690 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727707AbfKGKuD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 05:50:03 -0500
Received: by mail-wr1-f65.google.com with SMTP id j15so2463848wrw.5
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 02:50:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zgvLJhYOr+PdhygW9BBz/REoCc3gRB9wUu9h2ab8rY0=;
        b=b6S3ScA29oq0IB3lT5VcphEODUY/ebfUNu4RlOFdPT7vLVJpe4J1StpBrdFnCXH9ea
         ZKyUpfegipRPrrKjCbiePfPS9SRuCIztcM+Js1Y5i1orCnm9TbfoiZVxnaWL+mqIK4fe
         mOMPN8EDSn9K+Mios6OgdBElTQaj18OPudlDmmlEOKLmC/tlOAaHJvDQruEwAdJhcPqP
         eCa+HlxZ1vJ+JAB1ujaYcVUIFXG8jqPcAHaA3EgRwh/QYGHCa6U/jShrfBh6X+sV1yhR
         cqZPF5M8k+GEXiRiZR1Tg4+udWZg0/Yg+EEx9ZdBKtgRymrs7Qymir/2WuWX49JU2QPo
         L98A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zgvLJhYOr+PdhygW9BBz/REoCc3gRB9wUu9h2ab8rY0=;
        b=BL7wvwqB0WPSFqg1wsHz4KrJiJViWjU10uGE5SIXGamOC6kuXbncWEra8X1Xi8Gns1
         oSdS6g5zuOgrNVhXZ4c5yJxnBmLmi7reiPhCx6qJlkFkKSyNAe21/hiPp7+7XAjET9ze
         CGvwdPkYBmd0y8MYZzyzyvHG8aWphfDa1pMINf4QYe082O8NQdMsDmmpGcmSIVtGiD6Q
         5QUQp7tjBVBZ6a7gh0s2jar/ua1gs5etzImXdTJJSIrBdEdUSJp3YyWYzimlrTDldYnr
         OSISpTDsnlX/u2yhfR+Op5RJe5JoX3/PrZxfMp4BDXcV568GsjqhbDoWV6PQAXb94jkf
         3vXA==
X-Gm-Message-State: APjAAAU9ULSBqPCFR5N7ae4vsBtTsMT1j83p9KPbAURo2PKlVx3eiWbT
        x/FxBnh0eCojqB16zLf7wTMdAwVIq4suxQK54Yc=
X-Google-Smtp-Source: APXvYqyjODeoIHukGiT24dwBy+QOgMsaQg1DlfniVha41VJwbw1GvLffEJExJNv9v7FQHgg6R0j3jWpPooLLiIpKr4c=
X-Received: by 2002:adf:9dd0:: with SMTP id q16mr2151889wre.303.1573123801891;
 Thu, 07 Nov 2019 02:50:01 -0800 (PST)
MIME-Version: 1.0
References: <cover.1573030805.git.lucien.xin@gmail.com> <20191106.211459.329583246222911896.davem@davemloft.net>
In-Reply-To: <20191106.211459.329583246222911896.davem@davemloft.net>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Thu, 7 Nov 2019 18:50:15 +0800
Message-ID: <CADvbK_ePx7F62BR43UAFF5dmwHKJdkU6Tth06t5iirsH9_XgLg@mail.gmail.com>
Subject: Re: [PATCH net-next 0/5] lwtunnel: add ip and ip6 options setting and dumping
To:     David Miller <davem@davemloft.net>
Cc:     network dev <netdev@vger.kernel.org>,
        Simon Horman <simon.horman@netronome.com>,
        Jiri Benc <jbenc@redhat.com>, Thomas Graf <tgraf@suug.ch>,
        William Tu <u9012063@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 7, 2019 at 1:15 PM David Miller <davem@davemloft.net> wrote:
>
> From: Xin Long <lucien.xin@gmail.com>
> Date: Wed,  6 Nov 2019 17:01:02 +0800
>
> > With this patchset, users can configure options by ip route encap
> > for geneve, vxlan and ersapn lwtunnel, like:
> >
> >   # ip r a 1.1.1.0/24 encap ip id 1 geneve class 0 type 0 \
> >     data "1212121234567890" dst 10.1.0.2 dev geneve1
> >
> >   # ip r a 1.1.1.0/24 encap ip id 1 vxlan gbp 456 \
> >     dst 10.1.0.2 dev erspan1
> >
> >   # ip r a 1.1.1.0/24 encap ip id 1 erspan ver 1 idx 123 \
> >     dst 10.1.0.2 dev erspan1
> >
> > iproute side patch is attached on the reply of this mail.
> >
> > Thank Simon for good advice.
>
> Series applied, looks good.
>
> Can you comment about how this code is using the deprecated nla
> parsers for new options?
I didn't think too much, just used what it's using in cls_flower.c and
act_tunnel_key.c to parse GENEVE options.

Now think about it again, nla_parse_nested() should always be used on
new options, should I post a fix for it? since no code to access this
from userspace yet.
