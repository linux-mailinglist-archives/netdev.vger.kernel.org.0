Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 338BE15A9A8
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 14:05:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727600AbgBLNFX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 08:05:23 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:25322 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726728AbgBLNFX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Feb 2020 08:05:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581512722;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/XD0MHQK5ZuJMwMqcwKOLpQ1jPM8Al3qW0s4LcNAgmg=;
        b=jCCxIZB+LvKuYZ3/m+vP6CszVn/ISVGOEvWCgCKhWV3uwWBw8a8ayZUwWPAFDxpPBKlnNr
        I3G8+I4WV6N5MZsUzFaS238h8z/MvxzJUvtYJZYh1jLIQe7oaWgTiUsF9TWM/HnMc64qgx
        2/p5f/pmmU5thQHiIAZx5hoezTTc8+o=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-113-hccEnSElNUuosi3ewasudA-1; Wed, 12 Feb 2020 08:05:20 -0500
X-MC-Unique: hccEnSElNUuosi3ewasudA-1
Received: by mail-lj1-f197.google.com with SMTP id v1so744971lja.21
        for <netdev@vger.kernel.org>; Wed, 12 Feb 2020 05:05:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=/XD0MHQK5ZuJMwMqcwKOLpQ1jPM8Al3qW0s4LcNAgmg=;
        b=Fz3BOQz+6fJxfRpRrjrwofALeWhzHmaEyvopeUD+sAtgBspvsqD4p4wtPoO0+QJWQE
         upNugTIedWMSuAoEVkav7hDlia+LwXKajI0b/OLDqn4cA/voSVT4Ejjpflh01+mX0rvK
         gkcZOmHitTWdafqPvogs4VngJP2JvMrALda3WpP7E37z0bhzGYrPsCebMN3cMMUAt5v4
         ynJkhxDEq0zSYw+4S5aEnpth1RIE9i62wt3zPL16cYN9tq5S2NwfwXJ1WCaneMnyh3rf
         U19nJyqKP2I/v2sFynN8typrHlUgE050NYttRUpHcZTNe1dJNRSUcAFnHy+tKOJxgbTj
         jkuA==
X-Gm-Message-State: APjAAAXTteX1mYAJfqQtcUFy5eEN+qCIJu/ReeLvrO+YJLQ+mGjKEtUc
        Tk3Yv8ViC79jvrr3oEBvk5VCxFIAEesGq8VbGO0LI5J8Zjtrdk3CcqtgkzFZCCL3PYjuqjWUL3p
        DuWo5hmmS33GmbByQ
X-Received: by 2002:a19:4f46:: with SMTP id a6mr6617547lfk.143.1581512719299;
        Wed, 12 Feb 2020 05:05:19 -0800 (PST)
X-Google-Smtp-Source: APXvYqxEmYbs1kpH4LtWXeOOm0UGQZP4l0SeP5rAJoLcOaLK6Rn3gHLo/Dl6HD3JuR8fFbbymXRJDw==
X-Received: by 2002:a19:4f46:: with SMTP id a6mr6617529lfk.143.1581512719049;
        Wed, 12 Feb 2020 05:05:19 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id s15sm235031ljs.58.2020.02.12.05.05.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Feb 2020 05:05:15 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id ADE9A180365; Wed, 12 Feb 2020 14:05:13 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Eelco Chaudron <echaudro@redhat.com>, bpf@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, kafai@fb.com, songliubraving@fb.com,
        yhs@fb.com, andriin@fb.com
Subject: Re: [PATCH bpf-next] libbpf: Add support for dynamic program attach target
In-Reply-To: <158151067149.71757.2222114135650741733.stgit@xdp-tutorial>
References: <158151067149.71757.2222114135650741733.stgit@xdp-tutorial>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 12 Feb 2020 14:05:13 +0100
Message-ID: <874kvwhs6u.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eelco Chaudron <echaudro@redhat.com> writes:

> Currently when you want to attach a trace program to a bpf program
> the section name needs to match the tracepoint/function semantics.
>
> However the addition of the bpf_program__set_attach_target() API
> allows you to specify the tracepoint/function dynamically.
>
> The call flow would look something like this:
>
>   xdp_fd = bpf_prog_get_fd_by_id(id);
>   trace_obj = bpf_object__open_file("func.o", NULL);
>   prog = bpf_object__find_program_by_title(trace_obj,
>                                            "fentry/myfunc");
>   bpf_program__set_attach_target(prog, xdp_fd,
>                                  "fentry/xdpfilt_blk_all");

I think it would be better to have the attach type as a separate arg
instead of encoding it in the function name. I.e., rather:

   bpf_program__set_attach_target(prog, xdp_fd,
                                  "xdpfilt_blk_all", BPF_TRACE_FENTRY);

-Toke

