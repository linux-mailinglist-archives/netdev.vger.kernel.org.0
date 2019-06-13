Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D9C34388A
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 17:06:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733280AbfFMPGl convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 13 Jun 2019 11:06:41 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:43999 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732411AbfFMOId (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 10:08:33 -0400
Received: by mail-ed1-f67.google.com with SMTP id w33so31403558edb.10
        for <netdev@vger.kernel.org>; Thu, 13 Jun 2019 07:08:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=hU4LOcF8hQZTBkqSKA/lb4P2azF5fL/EdCA7arVUqxo=;
        b=Ta/eRpaF9kIlEqkx+++9rfdE+zwbmZ59IT1k9hiDUO4UoErvqx1qTSFofrg9VVG1ay
         nJ6J1VU1/MKNtoPCr/dyqkUNrvY/9cVpaLZ22jUK9CeWGjYGBgdXjcoBMCRdKtTy2Lfl
         M1yqrYUi3p6WxzaztEes2uJOgr2swCga18B/jZ3vBPYHX61Oa5jUbJZySW+q0bMYqQIm
         irrBl3G0cxwWSzl12HpVeb2rgB3FXQH3z3+pYmMYCJ80G4/U4SzCF7qEZ+EXFXNpdnqc
         zpf1vPnzog+QrakSBuIPcVmSMuQwOyjfSZUrmjVdbN3pWjdykhIYXXbYS8MF2TNXUQDo
         uTIQ==
X-Gm-Message-State: APjAAAUXS7SKmiU1uqGsXkA1yu9UDweCzLvYW3S/G/3VTNXb58tFX8yn
        nPCNExBmGCnnK3UJVWPfX8CNaQ==
X-Google-Smtp-Source: APXvYqwZ5dOqG8hmXVrRxLMSr9IV6nwvMdT5hBOww6KG3ld1vpi8ZOvx6IbgOBffpWo0wyoDtO3cbQ==
X-Received: by 2002:a17:906:4694:: with SMTP id a20mr62809377ejr.67.1560434911978;
        Thu, 13 Jun 2019 07:08:31 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id w6sm9673ejz.25.2019.06.13.07.08.31
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 13 Jun 2019 07:08:31 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 822481804AF; Thu, 13 Jun 2019 16:08:30 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Paul Blakey <paulb@mellanox.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        Yossi Kuperman <yossiku@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Aaron Conole <aconole@redhat.com>,
        Zhike Wang <wangzhike@jd.com>,
        Rony Efraim <ronye@mellanox.com>,
        "nst-kernel\@redhat.com" <nst-kernel@redhat.com>,
        John Hurley <john.hurley@netronome.com>,
        Simon Horman <simon.horman@netronome.com>,
        Justin Pettit <jpettit@ovn.org>,
        Kevin Darbyshire-Bryant <kevin@darbyshire-bryant.me.uk>
Subject: Re: [PATCH net-next 1/3] net/sched: Introduce action ct
In-Reply-To: <4b2dfcb1-47b2-647f-a2d9-a6722f1af9b3@mellanox.com>
References: <1560259713-25603-1-git-send-email-paulb@mellanox.com> <1560259713-25603-2-git-send-email-paulb@mellanox.com> <87d0jkgr3r.fsf@toke.dk> <da87a939-9000-8371-672a-a949f834caea@mellanox.com> <877e9sgmp1.fsf@toke.dk> <20190611155350.GC3436@localhost.localdomain> <87pnnjg9ce.fsf@toke.dk> <4b2dfcb1-47b2-647f-a2d9-a6722f1af9b3@mellanox.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 13 Jun 2019 16:08:30 +0200
Message-ID: <87blz1efxd.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Paul Blakey <paulb@mellanox.com> writes:

> On 6/11/2019 11:23 PM, Toke Høiland-Jørgensen wrote:
>> Marcelo Ricardo Leitner <marcelo.leitner@gmail.com> writes:
>>
>>> On Tue, Jun 11, 2019 at 05:34:50PM +0200, Toke Høiland-Jørgensen wrote:
>>>> Paul Blakey <paulb@mellanox.com> writes:
>>>>
>>>>> On 6/11/2019 4:59 PM, Toke Høiland-Jørgensen wrote:
>>>>>> Paul Blakey <paulb@mellanox.com> writes:
>>>>>>
>>>>>>> Allow sending a packet to conntrack and set conntrack zone, mark,
>>>>>>> labels and nat parameters.
>>>>>> How is this different from the newly merged ctinfo action?
>>>>>>
>>>>>> -Toke
>>>>> Hi,
>>>>>
>>>>> ctinfo does one of two very specific things,
>>>>>
>>>>> 1) copies DSCP values that have been placed in the firewall conntrack
>>>>> mark back into the IPv4/v6 diffserv field
>>>>>
>>>>> 2) copies the firewall conntrack mark to the skb's mark field (like
>>>>> act_connmark)
>>>>>
>>>>> Originally ctinfo action was named conndscp (then conntrack, which is
>>>>> what our ct shorthand stands for).
>>>>>
>>>>> We also talked about merging both at some point, but they seem only
>>>>> coincidentally related.
>>>> Well, I'm predicting it will create some confusion to have them so
>>>> closely named... Not sure what the best way to fix that is, though...?
>>> I had suggested to let act_ct handle the above as well, as there is a
>>> big chunk of code on both that is pretty similar. There is quite some
>>> boilerplate for interfacing with conntrack which is duplicated.
>>> But it was considered that the end actions are unrelated, and ctinfo
>>> went ahead. (I'm still not convinced of that, btw)
>>>
>>> Other than this, which is not an option anymore, I don't see a way to
>>> avoid confusion here. Seems anything we pick now will be confusing
>>> because ctinfo is a generic name, and we also need one here.
>> Hmm, yeah, dunno if I have any better ideas for naming that would avoid
>> this. act_runct ? Meh...
>>
>> -Toke
>
>
> If it's fine with you guys, can we keep the name act_ct ? :)

Sure, let's just keep the colour of this particular bike shed :)

-Toke
