Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2A643A200
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 22:39:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727575AbfFHUjg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 16:39:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:33058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727324AbfFHUjg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 8 Jun 2019 16:39:36 -0400
Received: from oasis.local.home (unknown [12.156.218.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E2992208E3;
        Sat,  8 Jun 2019 20:39:34 +0000 (UTC)
Date:   Sat, 8 Jun 2019 16:39:33 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Song Liu <songliubraving@fb.com>
Cc:     Matt Mullins <mmullins@fb.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>, Andrew Hall <hall@fb.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Martin Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH bpf] bpf: preallocate a perf_sample_data per event fd
Message-ID: <20190608163933.50033e9f@oasis.local.home>
In-Reply-To: <C9035893-C2C6-4051-BF19-9AC931D475ED@fb.com>
References: <20190530225549.23014-1-mmullins@fb.com>
        <E5BC8108-4E9A-416C-B12C-945091E31B0A@fb.com>
        <e0adcdedab52521111c2aa157eca276ae838fdb8.camel@fb.com>
        <C9035893-C2C6-4051-BF19-9AC931D475ED@fb.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 31 May 2019 05:26:30 +0000
Song Liu <songliubraving@fb.com> wrote:

> We can also do something like
> 
>    ee = kzalloc(sizeof(struct bpf_event_entry) + sizeof(struct perf_sample_data));
>    ee->sd = (void *)ee + sizeof(struct bpf_event_entry);

Or perhaps:

	ee->sd = (struct perf_sample_data *)(ee + 1);

-- Steve
