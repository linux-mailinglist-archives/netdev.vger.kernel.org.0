Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BD41293D9E
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 15:49:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407625AbgJTNtH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 09:49:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407599AbgJTNtH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 09:49:07 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D88A5C061755;
        Tue, 20 Oct 2020 06:49:06 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id l16so2255655ilt.13;
        Tue, 20 Oct 2020 06:49:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kEZikIhuP3ICGW+QYVSf/s/Nkdnnhq0yTrlrZjHMOZY=;
        b=lv9XAvpO7yYUY04EA03STItZ2yNCeV0e0vwRGNB0/8s5PpN160oel0z6UZkSa1kHWf
         IysvfHEuSxq0TaIUKrNIZVHBSx497jIE01BLQsjjAk7z2Zww5/gc+HYxV33fjEn/QP1t
         udc88i1Jg97JH/MkLyX5Q79GdFOXEzIg1+u+j7dzZ+gnotoBGrAfUjYNrfHvrOiAzFXV
         zABa9y5rHVepgWrkg9hVUTMCAhQ3T2dqzWe3LnF0zh5gZpMqI95U7Ir0op9T8GOq0HoK
         6Tbrqo0VMRvt2uRmNElJmY8B4wSes6WCFJl52nORFeQlfW36A9V1f4wP5p78n8lLJWIN
         ZlJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kEZikIhuP3ICGW+QYVSf/s/Nkdnnhq0yTrlrZjHMOZY=;
        b=uHciJ8Uc85pNDEstMLR3dY8QuNQr7CmSF6Lt/ugiE8/VAWPgalAzGGjx2/xlu6oDhz
         SGTMgZkkLI7Y0hDjxQ95B5RR9zX9IF1Pn04E9J84r42a7/BWjgwo8t0KGmlNdjuHSPwL
         MJaVLkd6pjIRQ3HLcxiOkKAwFLoyVeTvq8McGIozJSE2jy3nye6aRs10g1huRdrb7twh
         mGEHOD+SCPcmaDd+rBhVe3eKLY/LCpL3a4G3fVxB+ol8kc+84CJVd8IlH5Nv0p7C2l2v
         R967KHaqsG0tLwN9p6ofRPXCp8v/nNcw2/eewuPC2civdNlf6fsED1FwvgMEWRugiD6p
         x9Fw==
X-Gm-Message-State: AOAM530piqpXoXyN0oTIdQCItLnHafFSkxJQv74ULAAulClZ0ex+6Rrb
        vbeff4hSBAaWMmfq28KFCVvn8syqxhU=
X-Google-Smtp-Source: ABdhPJzqZuK9336eq/IzluqgquisojaUIrWT576Z9XoRE8M83rkudPL/Dcs5cj/jrnFG4zM1Nivq4A==
X-Received: by 2002:a92:9a8c:: with SMTP id c12mr2086223ill.186.1603201746110;
        Tue, 20 Oct 2020 06:49:06 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:9d8a:40ec:eef5:44b4])
        by smtp.googlemail.com with ESMTPSA id 18sm1750496ilg.3.2020.10.20.06.49.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Oct 2020 06:49:05 -0700 (PDT)
Subject: Re: [PATCH bpf v2 2/3] bpf_fib_lookup: optionally skip neighbour
 lookup
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
References: <160319106111.15822.18417665895694986295.stgit@toke.dk>
 <160319106331.15822.2945713836148003890.stgit@toke.dk>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <20784134-7f4c-c263-5d62-facbb2adb8a8@gmail.com>
Date:   Tue, 20 Oct 2020 07:49:01 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <160319106331.15822.2945713836148003890.stgit@toke.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/20/20 4:51 AM, Toke Høiland-Jørgensen wrote:
> From: Toke Høiland-Jørgensen <toke@redhat.com>
> 
> The bpf_fib_lookup() helper performs a neighbour lookup for the destination
> IP and returns BPF_FIB_LKUP_NO_NEIGH if this fails, with the expectation
> that the BPF program will deal with this condition, either by passing the
> packet up the stack, or by using bpf_redirect_neigh().
> 
> The neighbour lookup is done via a hash table (through ___neigh_lookup_noref()),
> which incurs some overhead. If the caller knows this is likely to fail
> anyway, it may want to skip that and go unconditionally to
> bpf_redirect_neigh(). For this use case, add a flag to bpf_fib_lookup()
> that will make it skip the neighbour lookup and instead always return
> BPF_FIB_LKUP_RET_NO_NEIGH (but still populate the gateway and target
> ifindex).
> 
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
> ---
>  include/uapi/linux/bpf.h       |   10 ++++++----
>  net/core/filter.c              |   16 ++++++++++++++--
>  tools/include/uapi/linux/bpf.h |   10 ++++++----
>  3 files changed, 26 insertions(+), 10 deletions(-)

Nack. Please don't.

As I mentioned in my reply to Daniel, I would prefer such logic be
pushed to the bpf programs. There is no reason for rare run time events
to warrant a new flag and new check in the existing FIB helpers. The bpf
programs can take the hit of the extra lookup.
