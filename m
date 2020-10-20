Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 320DC2941D4
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 20:03:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408910AbgJTSDp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 14:03:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:45312 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2408895AbgJTSDp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 14:03:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603217024;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R+hw9pDBfQhWZiRkExgEhd3YAIxYMlrpGhZNKTigtMU=;
        b=NK2AfPc6gMsNSAjtEXflnrr1MjWEbNmIwTalLoIQ6NZqYWdBrHiaArXIAbvGBcFDsMePk+
        ySG+22zjcaANUwqdJDpLFlkaJwxuU4fn0z7Ino1MgIrZy2DCGyvNDwn/w+f3cuPBkod+TI
        24bCl1rptWjBseJkdKlwRH8bkhb9jkU=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-270-n9ohXr4DNXKj8W7BhVVMLg-1; Tue, 20 Oct 2020 14:03:42 -0400
X-MC-Unique: n9ohXr4DNXKj8W7BhVVMLg-1
Received: by mail-ed1-f70.google.com with SMTP id a15so919047eda.15
        for <netdev@vger.kernel.org>; Tue, 20 Oct 2020 11:03:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=R+hw9pDBfQhWZiRkExgEhd3YAIxYMlrpGhZNKTigtMU=;
        b=odsoUqy4YVhXAKLO6kt2IPE/qy5yfKMzW/i5SxUi6PbH7cftXiwjAFKqL2/NqcXbt2
         FwNm1jCe4OKcWNts3cfAtLhAlMFMuhyHSRoWquQMsKM2QGeWasxeEyeBFCk8DWo1BxEb
         8WXsoyqsKJDOoIhd6SYc/fRuWQIK+dVE/b9hLhGFcyMI27XpBFtBB64yLaeITGTB93w2
         qA6QFbB+Nud5jtZufQXQNBDL3lxJoFiHow4M4OcowFYQNtajhMbTV8uFeu2mjFTK/4El
         8E72YZqkFXEDT4jX8azC+iT/H3yi5tPY4FiWub3nerz462LjNYrEnxVaOR9yYxWsqr7Y
         LCEw==
X-Gm-Message-State: AOAM530dupk9vInglrrOIvu8/BMRi+X8pu7yAIMW3bE5eZkA4Xer03xs
        Hs5uHmNcT7F+KPRV7fuIyqXx6YmQm3T86mv8M/hG5vuTNuVC10QbtBMM5yxhKrRSJJOLeACizkj
        JkaJisHs4h8p+9E1k
X-Received: by 2002:a17:906:fa99:: with SMTP id lt25mr4261353ejb.511.1603217020777;
        Tue, 20 Oct 2020 11:03:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwDRxB+C7L4z0vpks9Bnjcj86EiCKKVqBknhXESE72XqvM3lmkE694arfl/UYujTace3+5AUw==
X-Received: by 2002:a17:906:fa99:: with SMTP id lt25mr4261338ejb.511.1603217020544;
        Tue, 20 Oct 2020 11:03:40 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id r24sm3200856eds.67.2020.10.20.11.03.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2020 11:03:40 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 900321838FA; Tue, 20 Oct 2020 20:03:39 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH bpf v2 1/3] bpf_redirect_neigh: Support supplying the
 nexthop as a helper parameter
In-Reply-To: <20201020093405.59079473@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <160319106111.15822.18417665895694986295.stgit@toke.dk>
 <160319106221.15822.2629789706666194966.stgit@toke.dk>
 <20201020093405.59079473@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 20 Oct 2020 20:03:39 +0200
Message-ID: <87zh4g22ro.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:

> On Tue, 20 Oct 2020 12:51:02 +0200 Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> +struct bpf_nh_params {
>> +	u8 nh_family;
>> +	union {
>> +		__u32 ipv4_nh;
>> +		struct in6_addr ipv6_nh;
>> +	};
>> +};
>
> Folks, not directly related to this set, but there's a SRv6 patch going
> around which adds ifindex, otherwise nh can't be link local.
>
> I wonder if we want to consider this use case from the start (or the
> close approximation of start in this case ;)).

The ifindex is there, it's just in the function call signature instead
of the struct... Or did you mean something different?

-Toke

