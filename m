Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F02A13A2760
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 10:47:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbhFJItC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 04:49:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59907 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229770AbhFJItB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 04:49:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623314825;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9zSJ4Cz0GkyUckoB2hpt+KI040LkYH89elDBGT2GRlo=;
        b=hcuho6Q1gH/ZOpFf3w3lnUfe5XmZxHbDfsN8JXdi5DGKy5pLm6B41Qqhjc71JTstqSnmYP
        fv6o/RC6LZjPitYS1O/L/QTfwR3N+l9EmVcv5wwUcdlm1tlOHL8djDmLD46iKIKa/RlvA/
        am5kiXQhOzr7RYYavpC+2qBEGRfngIM=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-455-wxOVTdonNUqYXn5GhYI9GQ-1; Thu, 10 Jun 2021 04:47:03 -0400
X-MC-Unique: wxOVTdonNUqYXn5GhYI9GQ-1
Received: by mail-ej1-f71.google.com with SMTP id e11-20020a170906080bb02903f9c27ad9f5so8709090ejd.6
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 01:47:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=9zSJ4Cz0GkyUckoB2hpt+KI040LkYH89elDBGT2GRlo=;
        b=TlY7YbJmJ9c8dhBiJ5Qoecip3a2gzpezRxLNMQm3ohvmsNQIpDa4UlP8gNUpZxiXOR
         nXKMODKTD47zUbQ3U1pCuyOXfgKDRouqoArv5MqbQCJmuqUlZALUg8OAPApOvUcZ6GHl
         WSi5KkV4w3s745z3kk4m2wsk8jFkv/gxywiS5veof4k0r6wLgbgdP3EkOPwJE0zXpkYi
         5jpDCjBpZTSCWq4ym/7Z3Rjg7GsXpTpXHscTV5ehG0/wzzBZZu2Dl5pNqD0OodRY7SCz
         jOvWKfLzwsSABAqa7V2JySP4jrviRL+LEqkGlWtZc2Lt4Og5pceE0K3hZhSjFCKgr7pa
         qtmQ==
X-Gm-Message-State: AOAM530953kTgamxgG4/iWxmPXOMtUQNuYbmculpA+jJZ3fjQqAfPUit
        KHbMNTWhq+r/kkHFith5qescBnQKcHMXdd7qSP+MSlX208IO/khhUXP57/QL0TQTgqdLmDOPZpc
        fbke3eLFjlMPqpwDR
X-Received: by 2002:aa7:db94:: with SMTP id u20mr3556181edt.381.1623314822164;
        Thu, 10 Jun 2021 01:47:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwnnF4yowBK/HgD7Dfu8coBdUJY/ohwenLzxo3R+Sbyw8sVOVCUkVzrxltIVyfEShOjkCWqIw==
X-Received: by 2002:aa7:db94:: with SMTP id u20mr3556161edt.381.1623314821829;
        Thu, 10 Jun 2021 01:47:01 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id v23sm1021156eds.25.2021.06.10.01.47.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 01:47:01 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 99B731802AC; Thu, 10 Jun 2021 10:47:00 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     paulmck@kernel.org
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Michael Chan <michael.chan@broadcom.com>
Subject: Re: [PATCH bpf-next 06/17] bnxt: remove rcu_read_lock() around XDP
 program invocation
In-Reply-To: <20210609135834.GC4397@paulmck-ThinkPad-P17-Gen-1>
References: <20210609103326.278782-1-toke@redhat.com>
 <20210609103326.278782-7-toke@redhat.com>
 <20210609135834.GC4397@paulmck-ThinkPad-P17-Gen-1>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 10 Jun 2021 10:47:00 +0200
Message-ID: <87eedam7i3.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Paul E. McKenney" <paulmck@kernel.org> writes:

> On Wed, Jun 09, 2021 at 12:33:15PM +0200, Toke H=C3=B8iland-J=C3=B8rgense=
n wrote:
>> The bnxt driver has rcu_read_lock()/rcu_read_unlock() pairs around XDP
>> program invocations. However, the actual lifetime of the objects referred
>> by the XDP program invocation is longer, all the way through to the call=
 to
>> xdp_do_flush(), making the scope of the rcu_read_lock() too small. This
>> turns out to be harmless because it all happens in a single NAPI poll
>> cycle (and thus under local_bh_disable()), but it makes the rcu_read_loc=
k()
>> misleading.
>>=20
>> Rather than extend the scope of the rcu_read_lock(), just get rid of it
>> entirely. With the addition of RCU annotations to the XDP_REDIRECT map
>> types that take bh execution into account, lockdep even understands this=
 to
>> be safe, so there's really no reason to keep it around.
>
> And same for the rest of these removals.  Someone might be very happy
> to have that comment at some later date, and that someone just might
> be you.  ;-)

Bah, why do you have to go and make sensible suggestions like that? ;)

Will wait for Martin's review and add this in a v2. BTW, is it OK to
include your patch in the series like this, or should I rather request
that your tree be merged into bpf-next?

-Toke

