Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA60E1AD9E1
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 11:28:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730240AbgDQJ2i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 05:28:38 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:55228 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729987AbgDQJ2i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 05:28:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587115716;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J1X8U8ZB1R6tqDj8MWMf2NJWrKFiBMIEUzsmtwhZRms=;
        b=Wyukzd2AVOLJTA4fwdmRAgKRUJg3WGtz8fQlrKBlJirubag1Hyye2/blbnGp28OuZvWz05
        ge/esi2b61Gr3Klqrgs5dFC0MUgZf2ViQ5NOEsxXYlBjycez93LEWtRVATWPRHgDQ1NC4c
        GvjCDpZq/j+lYP6Wf+/6GyIWmBfTkWM=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-284-u9oStknXO360JFu_46eSoQ-1; Fri, 17 Apr 2020 05:28:32 -0400
X-MC-Unique: u9oStknXO360JFu_46eSoQ-1
Received: by mail-lf1-f72.google.com with SMTP id t22so598183lfe.14
        for <netdev@vger.kernel.org>; Fri, 17 Apr 2020 02:28:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=J1X8U8ZB1R6tqDj8MWMf2NJWrKFiBMIEUzsmtwhZRms=;
        b=TowEEYn3XFuGfOdYgxyWsmHJr4li1oc4pWpl5xVXmvUQF4RbrMFLDZ216ZFCBiXjUT
         krnepMQTqr47L1URrc0psJ+7dpbPA+laRwRMSWGqK6RBGNl6zch+ec5QwsTRV77KQJd2
         i41V8jyTjOEAxA8+xiiZDAtr26sH7GkmO9wOCxsUATUMfoqsQJzuyyrAeSbHRnIi1I2i
         0NGsSRSdj1CqvAx/FJV9iB4rjAqrXhctfV/Rc8QGIeWP1PP1Q4zZlX7F3E8dYJa8xq8F
         MAsKr6WPm4UX1lWLYiYTAlGJBin0ThqC77OvODr3vUQmYt7wTVDUa81qks71Yv/M53DK
         v7YQ==
X-Gm-Message-State: AGi0PuYXob8DoFWyvC8hXGVbgWvzgAnPhfX/Hzfrzl1SlAJPV3E+QZGA
        ceAAjiVg29ezd38m/U35q++T+QfDkCeqgip1n1xXJ1og5cn0UpFCvfe8orrciSRwdSHF90TNu6R
        MoD28EqrLSrwLPbsc
X-Received: by 2002:a2e:351a:: with SMTP id z26mr1509997ljz.162.1587115710506;
        Fri, 17 Apr 2020 02:28:30 -0700 (PDT)
X-Google-Smtp-Source: APiQypKH7gZsDY2rVP9JmwVyznQXuVF88NzEv/g9/DVnGUf/ZN7mMQ+piMMx2gjq0RYxDFpQ+xJV9g==
X-Received: by 2002:a2e:351a:: with SMTP id z26mr1509972ljz.162.1587115710264;
        Fri, 17 Apr 2020 02:28:30 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id p13sm1312765ljg.103.2020.04.17.02.28.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Apr 2020 02:28:29 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id E2D4B181587; Fri, 17 Apr 2020 11:28:26 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     David Ahern <dsahern@gmail.com>, David Ahern <dsahern@kernel.org>,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        brouer@redhat.com, toshiaki.makita1@gmail.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com
Subject: Re: [PATCH RFC-v5 bpf-next 00/12] Add support for XDP in egress path
In-Reply-To: <8dc7e153-e455-ff6c-7013-edb7cb62b818@gmail.com>
References: <20200413171801.54406-1-dsahern@kernel.org> <87pnc7lees.fsf@toke.dk> <8dc7e153-e455-ff6c-7013-edb7cb62b818@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 17 Apr 2020 11:28:26 +0200
Message-ID: <874ktilav9.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Ahern <dsahern@gmail.com> writes:

> On 4/16/20 7:59 AM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>>=20
>> I like the choice of hook points. It is interesting that it implies that
>> there will not be not a separate "XDP generic" hook on egress. And it's
>> certainly a benefit to not have to change all the drivers. So that's
>> good :)
>>=20
>> I also think it'll be possible to get the information we want (such as
>> TXQ fill level) at the places you put the hooks. For the skb case
>> through struct netdev_queue and BQL, and for REDIRECT presumably with
>> Magnus' queue abstraction once that lands. So overall I think we're
>> getting there :)
>>=20
>> I'll add a few more comments for each patch...
>>=20
>
> thanks for reviewing.
>
> FYI, somehow I left out a refactoring patch when generating patches to
> send out. Basically moves existing tb[IFLA_XDP] handling to a helper
> that can be reused for tb[IFLA_XDP_EGRESS]
>
> https://github.com/dsahern/linux/commit/71011b5cf6f8c1bca28a6afe5a92be591=
52a8219

Ah yes, makes sense. I skipped over the netlink patches fairly quickly,
so didn't notice this was missing. I guess this also answers the
question "what about netlink policy for the new nested attribute", right? :)

-Toke

