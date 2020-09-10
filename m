Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BA142642A9
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 11:45:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730277AbgIJJpD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 05:45:03 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:29958 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728971AbgIJJo4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 05:44:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599731094;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aCy+XOEaRsEQY0LQO/vOTZfwSOMrqiVn05uKYSgtpvo=;
        b=iHJcvySfzhYsCXoPn/5141QU/+UV4kn88ljXmM9vHfi588WfvjY1ZVcsiBc8u64zYvDCsv
        rSt+O4NMON5iRmrHNbSGZMSxJLeinSOVI1Snxvp2vD7TQ+FXeEE87ssx9TgUEImaAgNojh
        j46LyWkBUCQY1zSZ7eoPu/82UfeCkfo=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-294-j0sJAw7cPT2DbuKmdOr_Bg-1; Thu, 10 Sep 2020 05:44:53 -0400
X-MC-Unique: j0sJAw7cPT2DbuKmdOr_Bg-1
Received: by mail-wr1-f69.google.com with SMTP id x15so2034637wrm.7
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 02:44:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=aCy+XOEaRsEQY0LQO/vOTZfwSOMrqiVn05uKYSgtpvo=;
        b=e/ag6jCmAYF5voQ+F8RuQldadsG6LqfnI8xlI+F5k0RVL0beu6izyuBkQXs92/B+rr
         Djg68MxCZbLMNY2lS8UZT0A5rzEgND18G4DbqfYuZG54bH819gevUpHvKVr/SIRBf2U/
         /tgqXAErOM1wKEX9zhz90lYV6hoytWs1OjwCvDO5MLhwcAouZFjXjr4J3PU7Ycs5p5IK
         rxtQz4AJxq0dwDcVMreqTmgVX6vR+CXoaNRen2I2tAHFJnOWU2fwiZa0DKW++1jTCYwt
         cvaErp2tU/EBzNev+tvdD9/Pxe4lUiavkxJUsJLWDBVu285W0uRsE2U5ZlJ8kJIOdYdD
         C1oA==
X-Gm-Message-State: AOAM532P+1ISv6SccMD5HsNsyyhjgPsRnuWl3XTBzATwHRvZrRgUBWcl
        +LhgyauVUnnxuFt/4cTt2z3fC1sN9TaWCFhIPwUsIahVh8GM1TLx1wZ0RFhAx5rdT01L8P2hiI+
        wi54YZts+vF2TZ5Ho
X-Received: by 2002:adf:c44d:: with SMTP id a13mr7883862wrg.11.1599731091872;
        Thu, 10 Sep 2020 02:44:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwfCeAoXe3tOPQILTBWWxMnePItSYSr/aajG3+6ac5qGnErTf+SK51jURDCq9LkJoZlD7FQcA==
X-Received: by 2002:adf:c44d:: with SMTP id a13mr7883838wrg.11.1599731091629;
        Thu, 10 Sep 2020 02:44:51 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id n21sm2870497wmi.21.2020.09.10.02.44.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2020 02:44:50 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 7D2D11829D4; Thu, 10 Sep 2020 11:44:50 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        David Ahern <dsahern@gmail.com>
Cc:     Hangbin Liu <liuhangbin@gmail.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Subject: Re: [PATCHv11 bpf-next 2/5] xdp: add a new helper for dev map
 multicast support
In-Reply-To: <CAADnVQ+CooPL7Zu4Y-AJZajb47QwNZJU_rH7A3GSbV8JgA4AcQ@mail.gmail.com>
References: <20200903102701.3913258-1-liuhangbin@gmail.com>
 <20200907082724.1721685-1-liuhangbin@gmail.com>
 <20200907082724.1721685-3-liuhangbin@gmail.com>
 <20200909215206.bg62lvbvkmdc5phf@ast-mbp.dhcp.thefacebook.com>
 <20200910023506.GT2531@dhcp-12-153.nay.redhat.com>
 <a1bcd5e8-89dd-0eca-f779-ac345b24661e@gmail.com>
 <CAADnVQ+CooPL7Zu4Y-AJZajb47QwNZJU_rH7A3GSbV8JgA4AcQ@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 10 Sep 2020 11:44:50 +0200
Message-ID: <87o8mearu5.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:

> On Wed, Sep 9, 2020 at 8:30 PM David Ahern <dsahern@gmail.com> wrote:
>> >
>> > I think the packets modification (edit dst mac, add vlan tag, etc) should be
>> > done on egress, which rely on David's XDP egress support.
>>
>> agreed. The DEVMAP used for redirect can have programs attached that
>> update the packet headers - assuming you want to update them.
>
> Then you folks have to submit them as one set.
> As-is the programmer cannot achieve correct behavior.

The ability to attach a program to devmaps is already there. See:

fbee97feed9b ("bpf: Add support to attach bpf program to a devmap entry")

But now that you mention it, it does appear that this series is skipping
the hook that will actually run such a program. Didn't realise that was
in the caller of bq_enqueue() and not inside bq_enqueue() itself...

Hangbin, you'll need to add the hook for dev_map_run_prog() before
bq_enqueue(); see the existing dev_map_enqueue() function.

-Toke

