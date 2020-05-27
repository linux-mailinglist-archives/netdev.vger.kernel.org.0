Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48E681E469F
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 16:58:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389415AbgE0O6w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 10:58:52 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:25303 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389370AbgE0O6w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 10:58:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590591530;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oOJzplfdUs80yqt9VUaWRM4RvV+QRJBfXqks54YBI7w=;
        b=Mz80ZJTS9gj3RK8CVwsOggWmbRDodiyNurJsRt397BYUgmSiqF4f2ub3gKTGc1fpkyC3sO
        pfFNbnrbo/x5gC5p1PfbQSeQO/ULbDFNtAr0xsxGfLPiA2Kf9jnsUWbvaKNiqOTQD1uY7c
        FsRMe+1I1niJquLladS1OJYk/hYW8gk=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-312-1k-6aFlqNQGze-i350JZsw-1; Wed, 27 May 2020 10:58:49 -0400
X-MC-Unique: 1k-6aFlqNQGze-i350JZsw-1
Received: by mail-ed1-f70.google.com with SMTP id dh6so2377626edb.1
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 07:58:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=oOJzplfdUs80yqt9VUaWRM4RvV+QRJBfXqks54YBI7w=;
        b=s3WR9/s66K42KSnBcfK4ELO7L/DMoBpk92WMpedtipSkvb6cAPzyTXTLpwSsVwYNpP
         ONt4GemSP6CIy3Rkzf0QuyhKqoMpXmiLI6jFJy0nmAJcdyzpHglfcCeRE1A831D216DN
         zvS+iCTZvZOItbpW1SDywiDE8MDDxb5ojTgt6UdkJTeRAaQ2uSJCC3cZo2iwCgYMYM2D
         QLRQ25IxKeP4VfapXEQdwkrtAC9DkJNJ3zo7hm2QI7OEUw6+1/xq+cRUKr68RGlq9qgt
         ZQ3+LFeQm1Z7I2nHZnKQ2lC43WQMWug0v5jCdXnIJhBP9CbNW3y0pZPnqQnWsBJ8h2rG
         bD7A==
X-Gm-Message-State: AOAM532KYo8NJ4BIBLT9HQGGQjOl0UArI/kBDgM0sqgiBfC5M6mfLrTU
        xuEdd5izi3Zndme6dv9nvYbRCCgep9cCJT+fVDVX59uQZI7BdLt2S0TWQv7uNkCEBwZumJnijjk
        SqPt9I6z2CaxVj6Iy
X-Received: by 2002:a17:906:5681:: with SMTP id am1mr6749556ejc.376.1590591527941;
        Wed, 27 May 2020 07:58:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzG5UYWpsTFgAiNGnMzQoJHspBov2zdwzCRX4K6oH6NgMWtpOCkTFqsIIbvqbZldtxP0dh2Dg==
X-Received: by 2002:a17:906:5681:: with SMTP id am1mr6749540ejc.376.1590591527746;
        Wed, 27 May 2020 07:58:47 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id q12sm100114ejt.106.2020.05.27.07.58.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2020 07:58:47 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id B4F241804EB; Wed, 27 May 2020 16:58:46 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     David Ahern <dsahern@gmail.com>, David Ahern <dsahern@kernel.org>,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, brouer@redhat.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com
Subject: Re: [PATCH bpf-next 2/5] bpf: Add support to attach bpf program to a devmap entry
In-Reply-To: <39fc3e35-49c6-3d47-e3fc-809f41998362@gmail.com>
References: <20200527010905.48135-1-dsahern@kernel.org> <20200527010905.48135-3-dsahern@kernel.org> <875zch3de6.fsf@toke.dk> <39fc3e35-49c6-3d47-e3fc-809f41998362@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 27 May 2020 16:58:46 +0200
Message-ID: <87r1v51l21.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Ahern <dsahern@gmail.com> writes:

> On 5/27/20 4:01 AM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Did you give any special consideration to where the hook should be? I'm
>> asking because my immediate thought was that it should be on flush
>> (i.e., in bq_xmit_all()), but now that I see this I'm so sure anymore.
>> What were your thoughts around this?
>
> I chose this spot for many reasons:
>
> 1. dev_map_enqueue has the bpf_dtab_netdev structure which holds the prog=
ram
>
> 2. programs take xdp_buff, and dev_map_enqueue still has the xdp_buff
> with the rx information; no need to convert from buff to frame losing rx
> data, enqueue, back to buff to run program, back to frame to hand off to
> the driver.
>
> 3. no sense enqueuing if the device program drops the frame.

Right, makes sense; thank you for explaining :)

-Toke

