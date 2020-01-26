Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26A251498CD
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 05:54:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729248AbgAZEyw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jan 2020 23:54:52 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:33121 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729014AbgAZEyw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jan 2020 23:54:52 -0500
Received: by mail-qk1-f195.google.com with SMTP id h23so6464748qkh.0
        for <netdev@vger.kernel.org>; Sat, 25 Jan 2020 20:54:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=vy+QkTpv1IIiY0QT5I1UGyf9JmQemC9if+XxfGRJLqk=;
        b=hApVMWFvXM1ycWnt4zB7mhpJgvWSy3a5eABBdw/yn8gkgeEmMnCtAJ/KWHP197g4CF
         lqpaUpKewbjHEGYFzqjgANuY49nFAE3OcNXebepaD5hulPv2pge+uEXtRUkTVIWq3ZyU
         XtNX7UIY2zD/rumsTUcqVuykmQM07Lk6CfFjwzx1EzcVL9DHs+EFv/sfyL0dSWoOzOxx
         Z3O26u8DDOtKXoR4JQlDHkF07si/qNtVotxsuVt5nHNXOal3hVvTWtRXwzzRrQ2SNLCy
         Y4oOQ+U+561vZAV9dSWxmDll4G606N8yfgdT7HhAyfhnmigAikooVVLl0ahbOGi1GKt+
         W0bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=vy+QkTpv1IIiY0QT5I1UGyf9JmQemC9if+XxfGRJLqk=;
        b=AoE/95OvGu1mspmNHIFXlrgpbzoDw5fKicNQ/hsDsEyNwbwj0Qv2cqICMk0SB3nP1A
         OZi9Bpr3KFESEHde5L+56uXwnXgMYc29VPgMpcG9RCyNSs8go4bLJGr8mdJc3H3M9Dm1
         LcdtmQlsTh6Pkv466WpDfNuO78KQwrOEnNAkMW9iT4Flf4b4h71/C+8pjyn/giWQfK9C
         DWC3fM7bWePyHnzoZrxv7lEU8i0ASH7Uj1Pg1niBoW+0QgAU28GzxWdyLSkleUk9mtKW
         PjWSve4aaNkoB0LnQ9lOuThFcFm/wgU0ryxDuUyD1dvsqhQ/uFzAST4C2erysT4YqbJF
         96QA==
X-Gm-Message-State: APjAAAVvch3H8aoG7fRDpLc4cEVvr6t4GFd0wAN+oHnZT3EtwPXVhCOw
        85GLkS1b88+/Pr8ikcSHAjk=
X-Google-Smtp-Source: APXvYqwP9yFe0iuxWQQH7EtbrjzgU1WXI4cq57EGOQlEzo++2E/2KG1xDlJDsOzyAtyAB5/NyTNr3Q==
X-Received: by 2002:ae9:e211:: with SMTP id c17mr10945661qkc.133.1580014490803;
        Sat, 25 Jan 2020 20:54:50 -0800 (PST)
Received: from ast-mbp ([2620:10d:c091:480::a64e])
        by smtp.gmail.com with ESMTPSA id 13sm6612338qke.85.2020.01.25.20.54.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 25 Jan 2020 20:54:50 -0800 (PST)
Date:   Sat, 25 Jan 2020 20:54:45 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        davem@davemloft.net, jbrouer@redhat.com, mst@redhat.com,
        toshiaki.makita1@gmail.com, daniel@iogearbox.net,
        john.fastabend@gmail.com, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        David Ahern <dahern@digitalocean.com>
Subject: Re: [PATCH bpf-next 03/12] net: Add IFLA_XDP_EGRESS for XDP programs
 in the egress path
Message-ID: <20200126045443.f47dzxdglazzchfm@ast-mbp>
References: <20200123014210.38412-1-dsahern@kernel.org>
 <20200123014210.38412-4-dsahern@kernel.org>
 <87tv4m9zio.fsf@toke.dk>
 <335b624a-655a-c0c6-ca27-102e6dac790b@gmail.com>
 <20200124072128.4fcb4bd1@cakuba>
 <87o8usg92d.fsf@toke.dk>
 <1d84d8be-6812-d63a-97ca-ebc68cc266b9@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1d84d8be-6812-d63a-97ca-ebc68cc266b9@gmail.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 25, 2020 at 06:43:36PM -0700, David Ahern wrote:
> 
> That said, Martin's comment throws a wrench in the goal: if the existing
> code does not enforce expected_attach_type then that option can not be
> used in which case I guess I have to go with a new program type
> (BPF_PROG_TYPE_XDP_EGRESS) which takes a new context (xdp_egress_md),
> has different return codes, etc.

This is acceptable risk. We did such thing in the past. The chances of
user space breakage are extremely low.
