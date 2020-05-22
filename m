Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22C0A1DECC1
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 18:04:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730325AbgEVQEH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 12:04:07 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:36060 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730114AbgEVQEG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 12:04:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590163445;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eUcg8KA+WvEJiGU6xhPTM4CgZRLA2ZtL27FV+gxfFGw=;
        b=J3xYEAXRnd/h0Yra5Q2uXhJ+sXC1zzT6tVX0EpLRT/qr62FGSkbSjQqHm/ml1MSpZMVBp5
        EVnm2d+zrY+lGXivs9tKXLEOkSJsbitpxeF7iB3a1+xPBToKAzHTyFVKS0jfPJQnWCYoTK
        MyjxQO+6AEuO5PSbLUMAeiyVoYJU+L4=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-422-6DJS2UjuP-aKiYCuXW5snQ-1; Fri, 22 May 2020 12:04:03 -0400
X-MC-Unique: 6DJS2UjuP-aKiYCuXW5snQ-1
Received: by mail-ej1-f70.google.com with SMTP id h6so4853856ejb.17
        for <netdev@vger.kernel.org>; Fri, 22 May 2020 09:04:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=eUcg8KA+WvEJiGU6xhPTM4CgZRLA2ZtL27FV+gxfFGw=;
        b=kkOOf+tKeM+ri4W0lid8h/j15Sfu76kHFbvmX5pwvr91uSaQCkTlDP692jqZ+cI+h6
         oJogSeKsSjSEDfD/VaPsby8WpkAi9UV2Hn2F1W8ueR5LeEj0KHdQfecyOIB+b6fnBTyA
         WiWhnk17/qz8ctBnV/MXTRZOszSwXHZU17rVn8cELAR5wHj8nq6MYneyviaLsMtSH97u
         Akrd8G+9yWPLtwUjYmzg0aW9ZtJGeLyKrWUgufxKOzlVbSryOyZUDcZiDQ91GmN6nljU
         1fFUOi+6cJeZWmeSe4eeU9uu7kPW1BJQsiUUttgxSAMgrDYgTuYJkHRZZ72NKd3Y2zEw
         nAXA==
X-Gm-Message-State: AOAM530k1zqaqJ/IqkeMRUhhFsHwzG6H/Xb2dQFgeH75o3apZtRZ00S4
        2zomtOOVQL6maljQ2CZWA80l206jweU9WfH5sFgYSeFsVOXcd7xcKsZFg9DBzf8ecyhtoEnM6tI
        +MgxVIm6D60l4S6hA
X-Received: by 2002:a05:6402:31ad:: with SMTP id dj13mr3617571edb.232.1590163442118;
        Fri, 22 May 2020 09:04:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyTvWqPx3XIsEW+J/hUWiVpACc3SRYpuvgCO2559B6mtbeMf5A0KIOhy7e8wh/SHoV9kzBMEQ==
X-Received: by 2002:a05:6402:31ad:: with SMTP id dj13mr3617551edb.232.1590163441966;
        Fri, 22 May 2020 09:04:01 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id g13sm6794100ejh.119.2020.05.22.09.04.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2020 09:04:01 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id E359518150E; Fri, 22 May 2020 18:04:00 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, brouer@redhat.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com, David Ahern <dsahern@kernel.org>
Subject: Re: [PATCH RFC bpf-next 3/4] xdp: Add xdp_txq_info to xdp_buff
In-Reply-To: <20200522010526.14649-4-dsahern@kernel.org>
References: <20200522010526.14649-1-dsahern@kernel.org> <20200522010526.14649-4-dsahern@kernel.org>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 22 May 2020 18:04:00 +0200
Message-ID: <87ftbsj6rz.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Ahern <dsahern@kernel.org> writes:

> Add xdp_txq_info as the Tx counterpart to xdp_rxq_info. At the
> moment only the device is added. Other fields (queue_index)
> can be added as use cases arise.
>
> From a UAPI perspective, add egress_ifindex to xdp context.
>
> Update the verifier to only allow accesses to egress_ifindex by
> XDP programs with BPF_XDP_DEVMAP expected attach type.
>
> Signed-off-by: David Ahern <dsahern@kernel.org>

Nit: seems a bit odd to order the patches like this, I'd have expected
this patch to go before #2.

-Toke

