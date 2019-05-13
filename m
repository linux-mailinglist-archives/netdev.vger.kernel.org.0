Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DC661BF9B
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 00:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726537AbfEMWrl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 18:47:41 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:46058 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726520AbfEMWrl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 18:47:41 -0400
Received: by mail-ed1-f65.google.com with SMTP id g57so19836530edc.12;
        Mon, 13 May 2019 15:47:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=szhI2tkLhHIPKm2AgDfSb++Af0fTHrUe2vEjt/AY3rA=;
        b=Utxd8aUVRkjcIalW/EnrcUwFk1uKzQ0HZeQsyf6zbYxyK8gqJvoH025AcBhjtzeNfN
         s7eAi0KCE5SDHxpApQj5BXYGYu/4mtUhZCkMm0LlwVLXp+6sc9M8E24LvZY4nrxPnWyM
         0RDpJVFp4HR3Sz0/iQ9aBUBb8wpzVrL0iQSKdEtFC0ga7V08BJ0qhrcnpxdUoizOyFqh
         OSlHSKAo+wuSQqxfbfOcQIVFlcqJqtwBr7bhQZzuBrc0X0w+V6bkorMcmh3jNhQBZqtq
         0TpNIByOhKtV8WbEVp+TXb1Opgkw/+Z8OxR7+YC0JLPfsgJAX09MK0YgUSFEStP6PBF4
         P85A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=szhI2tkLhHIPKm2AgDfSb++Af0fTHrUe2vEjt/AY3rA=;
        b=quWYnWvbmjd2nprLWDUQ5bmww3eLjb45SG0+exngHw3Na5sTuGM9XRV8kbnUKILlB+
         I7LcKXrQMjwE46d342/7qDRs5bMUEDXzpwQ3w6MKmaTZqi+gcK5jPGTKmgwtA2N0Rj6K
         IG1wzGCJpzHjpCObTm3Bo8UEeqgAtoH0DC2gjJNFNhVxKiy7APO5l92gG7Qs8L0aUqte
         EE8psY5lHN9xlg7kt/OSPntwAacL0fqmFoxnPw6fM8wabgnR6HK3/BXKoc3yQ/k+HFny
         x61+hCnn597Dd6Rk09JVG9t7SvZh6hMncAXLZXtLU8795tgYDAhmjTl+/pjp7CBe9jRg
         HPmA==
X-Gm-Message-State: APjAAAXm1fP+w0uUKKxBuwa3T34MjJT04PSBoapoUouW9/3B/XfgLYcS
        Fw4mXWwvkdaXY+SUcFM1ZSALjedhZ6hiHs4VFbY=
X-Google-Smtp-Source: APXvYqxm26nd76lIxZwy5yApMXh29h1ogF/ADRekcw6oamaZfEuyA2hh6fHHEEpp0urSO7UU8bcVNDIcus1uYb5peKs=
X-Received: by 2002:a50:f5d0:: with SMTP id x16mr31502626edm.287.1557787659208;
 Mon, 13 May 2019 15:47:39 -0700 (PDT)
MIME-Version: 1.0
References: <20190513185402.220122-1-sdf@google.com> <CAF=yD-LO6o=uZ-aT-J9uPiBcO4f2Zc9uyGZ+f7M7mPtRSB44gA@mail.gmail.com>
 <20190513210239.GC24057@mini-arch> <CAF=yD-JKbzuoF_q7gPRjMNCBexn4pxgQ6pTeQSRfPXmwWk5dzg@mail.gmail.com>
In-Reply-To: <CAF=yD-JKbzuoF_q7gPRjMNCBexn4pxgQ6pTeQSRfPXmwWk5dzg@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 13 May 2019 18:47:03 -0400
Message-ID: <CAF=yD-Lg16ETT09=fRd2FTx2FJoGZ9K0s-JHrhv-9OMTqE+5BQ@mail.gmail.com>
Subject: Re: [PATCH bpf 1/2] flow_dissector: support FLOW_DISSECTOR_KEY_ETH_ADDRS
 with BPF
To:     Stanislav Fomichev <sdf@fomichev.me>
Cc:     Stanislav Fomichev <sdf@google.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, David Miller <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Willem de Bruijn <willemb@google.com>,
        Petar Penkov <ppenkov@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 13, 2019 at 5:21 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Mon, May 13, 2019 at 5:02 PM Stanislav Fomichev <sdf@fomichev.me> wrote:
> >
> > On 05/13, Willem de Bruijn wrote:
> > > On Mon, May 13, 2019 at 3:53 PM Stanislav Fomichev <sdf@google.com> wrote:
> > > >
> > > > If we have a flow dissector BPF program attached to the namespace,
> > > > FLOW_DISSECTOR_KEY_ETH_ADDRS won't trigger because we exit early.
> > >
> > > I suppose that this is true for a variety of keys? For instance, also
> > > FLOW_DISSECTOR_KEY_IPV4_ADDRS.
>
> > I though the intent was to support most of the basic stuff (eth/ip/tcp/udp)
> > without any esoteric protocols.
>
> Indeed. But this applies both to protocols and the feature set. Both
> are more limited.
>
> > Not sure about FLOW_DISSECTOR_KEY_IPV4_ADDRS,
> > looks like we support that (except FLOW_DISSECTOR_KEY_TIPC part).
>
> Ah, I chose a bad example then.
>
> > > We originally intended BPF flow dissection for all paths except
> > > tc_flower. As that catches all the vulnerable cases on the ingress
> > > path on the one hand and it is infeasible to support all the
> > > flower features, now and future. I think that is the real fix.
>
> > Sorry, didn't get what you meant by the real fix.
> > Don't care about tc_flower? Just support a minimal set of features
> > needed by selftests?
>
> I do mean exclude BPF flow dissector (only) for tc_flower, as we
> cannot guarantee that the BPF program can fully implement the
> requested feature.

Though, the user inserting the BPF flow dissector is the same as the
user inserting the flower program, the (per netns) admin. So arguably
is aware of the constraints incurred by BPF flow dissection. And else
can still detect when a feature is not supported from the (lack of)
output, as in this case of Ethernet address. I don't think we want to
mix BPF and non-BPF flow dissection though. That subverts the safety
argument of switching to BPF for flow dissection.
