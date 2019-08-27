Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 941DF9E6EF
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 13:42:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728612AbfH0LmY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 07:42:24 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:51923 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbfH0LmX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 07:42:23 -0400
Received: by mail-wm1-f68.google.com with SMTP id k1so2750622wmi.1
        for <netdev@vger.kernel.org>; Tue, 27 Aug 2019 04:42:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=U56vqCz8yBB+QMWAUKAhboBtvk3M+myjC31Q7qZhzyQ=;
        b=gWhyRQskTEZYkQaqlMkV+ZlkNIW00M04UJxeHHvI6czXravSdKRT9rmJEFwirIVeRe
         5vV4je32Ig/EymOcCBhO8uQA2XFSrKp55l8uJa0Fwd2We0BYtavbus3sgHXS4zQ9WCQ5
         W2f6m/rqiWctVPAQD24sSy/XwSZQvB0TKJFiUWB4mjJ8ITRs1GG6rnM27Tw1hQLZ7COh
         N+fMglOyt4sK7TRCfPCVLEgnRtkzzI9f32kgiZbWKuXjD6Qs1iFzaBKvlxvMhjsj8Z+Z
         JkDPB7VI6HAMtNRig4GK39NoBPd5h6lfZdU2qcAtzTidVBsxcsh6wxR2fbKEMTLUkQqP
         ICsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=U56vqCz8yBB+QMWAUKAhboBtvk3M+myjC31Q7qZhzyQ=;
        b=NUW1AgX4IhQdo8fK8KU0TRJgxUZMT7Vcx68D3Q3QMsufmaruecYl9zZHeLEdd58cJQ
         PYv1jHzEOlscnDjOtLz4JNb552DxC3HAJU62XHObqrHIkzoHB8pnf5PAYvNq8SoYDk66
         QgtMm3QYtcnqKXmWBXOplm+Tywdjm+1WcBVucIq/YLlTi0gbdHX6wQl0+H9cw5zZD4Gx
         CSfDZu4qHpZ9dG89iJMMv8+i8luvUu0eHp6pGjfhmCng1PdSPz3PcenW0x/QDVaUfIua
         VdStXezadNG06vrqUnXDiPJbzbuifTrZeIRDymvve5mBnUygTSpUalGi93USFrPcY/T4
         BEHQ==
X-Gm-Message-State: APjAAAULAU/Kf4YNieAhE3kBwIQK1l9j2tAfN/0mwg3z1w2/KApBpf5v
        JaSM1GSHM5IuuSQ8clfyc+k=
X-Google-Smtp-Source: APXvYqwrAxyMR6eVFk2K1G2bmmbQ4FSud7SozjpXbYa2UDixiGRY8kaQl1G1aFQA4BqvIML+vSTtSA==
X-Received: by 2002:a1c:eb06:: with SMTP id j6mr29194774wmh.76.1566906141386;
        Tue, 27 Aug 2019 04:42:21 -0700 (PDT)
Received: from pixies (bzq-82-81-225-244.cablep.bezeqint.net. [82.81.225.244])
        by smtp.gmail.com with ESMTPSA id r17sm38668282wrg.93.2019.08.27.04.42.19
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 27 Aug 2019 04:42:20 -0700 (PDT)
Date:   Tue, 27 Aug 2019 14:42:18 +0300
From:   Shmulik Ladkani <shmulik.ladkani@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Yonghong Song <yhs@fb.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        shmulik@metanetworks.com, eyal@metanetworks.com
Subject: Re: BUG_ON in skb_segment, after bpf_skb_change_proto was applied
Message-ID: <20190827144218.5b098eac@pixies>
In-Reply-To: <94cd6f4d-09d4-11c0-64f4-bdc544bb3dcb@gmail.com>
References: <20190826170724.25ff616f@pixies>
        <94cd6f4d-09d4-11c0-64f4-bdc544bb3dcb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 26 Aug 2019 19:47:40 +0200
Eric Dumazet <eric.dumazet@gmail.com> wrote:

> On 8/26/19 4:07 PM, Shmulik Ladkani wrote:
> >   - ipv4 forwarding to dummy1, where eBPF nat4-to-6 program is attached
> >     at TC Egress (calls 'bpf_skb_change_proto()'), then redirect to ingress
> >     on same device.
> >     NOTE: 'bpf_skb_proto_4_to_6()' mangles 'shinfo->gso_size'  
> 
> Doing this on an skb with a frag_list is doomed, in current gso_segment() state.
> 
> A rewrite  would be needed (I believe I did so at some point, but Herbert Xu fought hard against it)

Thanks Eric,

- If a rewrite is still considered out of the question, how can one use
  eBPF's bpf_skb_change_proto() safely without disabling GRO completely?
  - e.g. is there a way to force the GROed skbs to fit into a layout that is
    tolerated by skb_segment?
  - alternatively can eBPF layer somehow enforce segmentation of the
    original GROed skb before mangling the gso_size?

- Another thing that puzzles me is that we hit the BUG_ON rather rarely
  and cannot yet reproduce synthetically. If skb_segment's handling of
  skbs with a frag_list (that have gso_size mangled) is broken, I'd expect
  to hit this more often... Any ideas?

- Suppose going for a rewrite, care to elaborate what's exactly missing
  in skb_segment's logic?
  I must admit I do not fully understand all the different code flows in
  this function, it seems to support many different input skbs - any
  assistance is highly appreciated.

Shmulik
