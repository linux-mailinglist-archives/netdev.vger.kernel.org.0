Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F8191B5E27
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 16:45:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728711AbgDWOo5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 10:44:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726380AbgDWOo4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 10:44:56 -0400
Received: from mail-ua1-x942.google.com (mail-ua1-x942.google.com [IPv6:2607:f8b0:4864:20::942])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91625C08E934;
        Thu, 23 Apr 2020 07:44:56 -0700 (PDT)
Received: by mail-ua1-x942.google.com with SMTP id s5so5915170uad.4;
        Thu, 23 Apr 2020 07:44:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vRrZk0tMCkIyqKJPsSOMqLM7Os4mUPhCNEMI8A+fV4o=;
        b=p/Xo6uv3pGXc7/tfnw73VDQpGzeAmmlYOWfe7fHRThqXYFpYNc0wCoC37D+tW2q5BD
         nKdDGG5COpiNY0W6eYqSmCu+NTwbOneHyb1tjB61Hdu4L+GsmZFd3+B7M+baTXyy0BSW
         4gFpCMP9lmHqEn43d6mw32e8hhljZby34wc4NWeVPS7uVuG+ewMz9NfM0iVO31+lWzwY
         RXsODyftPPQeQMEIZK8ZZyiwJV1rJHRUMP+fc6hxBnMT+viskfDAli2zR/qJcGng32Sp
         3GdaTrwiDCobQzDcTlpuNt24yOByXqrvdpWwIa1unyXIZpOyPQy/0l6KY6D1xZl6xqpe
         uHkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vRrZk0tMCkIyqKJPsSOMqLM7Os4mUPhCNEMI8A+fV4o=;
        b=G087VjzHKzN6q9d6cGS5gHj0xkC+PFeJP3Y2dTe5HKyqbHB8qttQ4selIQyTE4/Kd5
         PyY88zBl8lPjME9sK8b55hmzb5qKwjCtvDXFpP26hc28XOT0GYx1peIcGKdhjuGGSeAu
         /up9SLpxqSKK9GDYNE1HGimdhE5seHh5VXlvADnteHkhXyE92HReLNRZVPOPnCo2Q46A
         gOhAe/L1ZSGslALOUuiOL5XienlKdgVl/6DJzsKWPb6cmeS8W9GKeQvz2tDcz3W/tUIj
         LjHzwiBJ8oDpD6fdpEremN0HqM2qv/fDfy6RiQQdphtClekm5llbwv0M8kqqMi4lvIQt
         XZ2A==
X-Gm-Message-State: AGi0PuZDdm4mdrfTYtyVL7MOvM6OUCz4mRIk+0kbBSQLW1svGLSKc+y3
        Bdq7XFmCPmBSag4CqWle3k7Pnt1EqSqRTlYFZH8=
X-Google-Smtp-Source: APiQypJeXeY5OHXw0LePpNn+qV5rq3IIj4LdT5dvebpK+c+OZngK20fa1ChT2y38Gt6+pQa6EKZerzI09fNit4KflGk=
X-Received: by 2002:a05:6102:2261:: with SMTP id v1mr3448482vsd.126.1587653095849;
 Thu, 23 Apr 2020 07:44:55 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1583927267.git.lukas@wunner.de> <14ab7e5af20124a34a50426fd570da7d3b0369ce.1583927267.git.lukas@wunner.de>
 <a57687ae-2da6-ca2a-1c84-e4332a5e4556@iogearbox.net> <20200313145526.ikovaalfuy7rnkdl@salvia>
 <1bd50836-33c4-da44-5771-654bfb0348cc@iogearbox.net> <20200315132836.cj36ape6rpw33iqb@salvia>
In-Reply-To: <20200315132836.cj36ape6rpw33iqb@salvia>
From:   Laura Garcia <nevola@gmail.com>
Date:   Thu, 23 Apr 2020 16:44:44 +0200
Message-ID: <CAF90-WgoteQXB9WQmeT1eOHA3GpPbwPCEvNzwKkN20WqpdHW-A@mail.gmail.com>
Subject: Re: [PATCH nf-next 3/3] netfilter: Introduce egress hook
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Lukas Wunner <lukas@wunner.de>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>, coreteam@netfilter.org,
        netdev@vger.kernel.org, Martin Mares <mj@ucw.cz>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Thomas Graf <tgraf@suug.ch>,
        Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 15, 2020 at 2:29 PM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
> Hello Daniel,
>
> On Sat, Mar 14, 2020 at 01:12:02AM +0100, Daniel Borkmann wrote:
> > On 3/13/20 3:55 PM, Pablo Neira Ayuso wrote:
> [...]
> > > We have plans to support for NAT64 and NAT46, this is the right spot
> > > to do this mangling. There is already support for the tunneling
> >
> > But why is existing local-out or post-routing hook _not_ sufficient for
> > NAT64 given it being IP based?
>
> Those hooks are not coming at the end of the IP processing. There is
> very relevant IP code after those hooks that cannot be bypassed such
> as fragmentation, tunneling and neighbour output. Such transformation
> needs to happen after the IP processing, exactly from where Lukas is
> proposing.
>
> [...]
> > > infrastructure in netfilter from ingress, this spot from egress will
> > > allow us to perform the tunneling from here. There is also no way to
> > > drop traffic generated by dhclient, this also allow for filtering such
> > > locally generated traffic. And many more.

Hi,

Any chance to continue with this approach? I'm afraid outbound
af_packets also could not be filtered without this hook.

Thanks.
