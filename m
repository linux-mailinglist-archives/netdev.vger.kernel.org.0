Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D09F51762BC
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 19:30:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727520AbgCBSat (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 13:30:49 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:39751 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727268AbgCBSas (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 13:30:48 -0500
Received: by mail-pj1-f68.google.com with SMTP id o5so138005pjs.4
        for <netdev@vger.kernel.org>; Mon, 02 Mar 2020 10:30:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Z7//QmbkwzNgGnou8lHzSVEj2ekjhGlSMqF0xFdwdLo=;
        b=tfA+aryZYJBzGkAfyr43qtZbv9DfOinABuHbsXqrWb5QheTbHH6lrT9J0ztrMeFViX
         M8TBKGYiS9uKFlxls7LtIkZzNfvYO22dqyZahlC1F2nhjyKIpxhgHYxvPdxHWThor6lC
         CFoOkM67Ylr0FsC3HJem8Uztff2zGPKc3bYubAzU/1M/YFNUtGzEj+Mj4505dYehnlCV
         mDqk7Mv7r5LjloINR3fW17BZGrVkIqnIuLXVwJy1lEceQIdDKFs8HtVm4cQsO30BG76A
         Qlg3P85k/+JnZTN0CpSLnm4YwCTurzziZna3cgo6SZob/A4NWuMwd8SmGjB72UUNtjlo
         sWtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Z7//QmbkwzNgGnou8lHzSVEj2ekjhGlSMqF0xFdwdLo=;
        b=YQ9w/423ErEMWjHvC0KA/lwVpIKYqyf7RWL6hXSrdinuzWLr6ydajFLoFeBjRdBGzh
         fkKD69quCXJOAHreywLrXDC1XgcBagtkLy13fM1w7LyFrNMbjjEZO3VMRnMMYBc/t0FD
         Sz8jpS5I8UP1Sshj1Aogx+q3hsImdAIAjIMKBS3q6AV0qGtJt6x1o8HBEZOQekNRy+u4
         njQwQlGvXDHHzWNAGnh/umGnEVadn47+wsBgU6WzALfBFtH3tuLudXZyqAcQxzLf88FX
         yrMd4pLNn5+C1zKbyFyyASJbkG5SNnhHSOfxtV2JGCAjWgsoQKN6lhiK1RbJI8UWEMaU
         0znQ==
X-Gm-Message-State: ANhLgQ1EerWTwlc9EJ4es8RM14K3E4nh2ZUxfkSS9DkqLYxvH30yvWBU
        cJS7gpLd+pdKjBDdUEX/694=
X-Google-Smtp-Source: ADFU+vu89R7F+P2BJF4zPrDXGls7PhQfbnzqSkRcDYT9c1P7MfpHTxXUXB4m0mE+bybTkTcROoGM/w==
X-Received: by 2002:a17:90a:252a:: with SMTP id j39mr216874pje.117.1583173846124;
        Mon, 02 Mar 2020 10:30:46 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:500::7:1db6])
        by smtp.gmail.com with ESMTPSA id k5sm136826pju.29.2020.03.02.10.30.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 02 Mar 2020 10:30:45 -0800 (PST)
Date:   Mon, 2 Mar 2020 10:30:41 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        brouer@redhat.com, toke@redhat.com, mst@redhat.com,
        toshiaki.makita1@gmail.com, daniel@iogearbox.net,
        john.fastabend@gmail.com, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com, David Ahern <dahern@digitalocean.com>
Subject: Re: [PATCH RFC v4 bpf-next 09/11] tun: Support xdp in the Tx path
 for xdp_frames
Message-ID: <20200302183040.tgnrg6tkblrjwsqj@ast-mbp>
References: <20200227032013.12385-1-dsahern@kernel.org>
 <20200227032013.12385-10-dsahern@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200227032013.12385-10-dsahern@kernel.org>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 26, 2020 at 08:20:11PM -0700, David Ahern wrote:
> +
> +		act = bpf_prog_run_xdp(xdp_prog, &xdp);
> +		switch (act) {
> +		case XDP_TX:    /* for Tx path, XDP_TX == XDP_PASS */
> +			act = XDP_PASS;
> +			break;
> +		case XDP_PASS:
> +			break;
> +		case XDP_REDIRECT:
> +			/* fall through */
> +		default:
> +			bpf_warn_invalid_xdp_action(act);
> +			/* fall through */
> +		case XDP_ABORTED:
> +			trace_xdp_exception(tun->dev, xdp_prog, act);
> +			/* fall through */
> +		case XDP_DROP:
> +			break;
> +		}

patch 8 has very similar switch. Can you share the code?

I'm worried that XDP_TX is a silent alias to XDP_PASS.
What were the reasons to go with this approach?
imo it's less error prone and extensible to warn on XDP_TX.
Which will mean that both XDP_TX and XDP_REDICT are not supported for egress atm.

Patches 8 and 9 cover tun only. I'd like to see egress hook to be implemented
in at least one physical NIC. Pick any hw. Something that handles real frames.
Adding this hook to virtual NIC is easy, but it doesn't demonstrate design
trade-offs one would need to think through by adding egress hook to physical
nic. That's why I think it's mandatory to have it as part of the patch set.

Patch 11 exposes egress to samples/bpf. It's nice, but without selftests it's
no go. All new features must be exercised as part of selftests/bpf.

re: patch 3. I agree with Toke and Jesper that union in uapi is unnecessary.
Just drop it. xdp_md is a virtual data structure. It's not allocated anywhere.
There is no need to save non-existent memory.
