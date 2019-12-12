Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0EC311D22D
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 17:25:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729895AbfLLQZQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 11:25:16 -0500
Received: from www62.your-server.de ([213.133.104.62]:58954 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729762AbfLLQZQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 11:25:16 -0500
Received: from [194.230.159.122] (helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1ifRH7-0007Wx-UN; Thu, 12 Dec 2019 17:25:14 +0100
Date:   Thu, 12 Dec 2019 17:25:13 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Andrii Nakryiko <andriin@fb.com>,
        Song Liu <songliubraving@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, oss-drivers@netronome.com
Subject: Re: [oss-drivers] [PATCH AUTOSEL 5.4 326/350] bpf: Switch bpf_map
 ref counter to atomic64_t so bpf_map_inc() never fails
Message-ID: <20191212162513.GB1264@localhost.localdomain>
References: <20191210210735.9077-1-sashal@kernel.org>
 <20191210210735.9077-287-sashal@kernel.org>
 <20191210132834.157d5fc5@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191210132834.157d5fc5@cakuba.netronome.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25661/Thu Dec 12 10:47:42 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 10, 2019 at 01:28:34PM -0800, Jakub Kicinski wrote:
> On Tue, 10 Dec 2019 16:07:11 -0500, Sasha Levin wrote:
> > From: Andrii Nakryiko <andriin@fb.com>
> > 
> > [ Upstream commit 1e0bd5a091e5d9e0f1d5b0e6329b87bb1792f784 ]
> > 
> > 92117d8443bc ("bpf: fix refcnt overflow") turned refcounting of bpf_map into
> > potentially failing operation, when refcount reaches BPF_MAX_REFCNT limit
> > (32k). Due to using 32-bit counter, it's possible in practice to overflow
> > refcounter and make it wrap around to 0, causing erroneous map free, while
> > there are still references to it, causing use-after-free problems.
> 
> I don't think this is a bug fix, the second sentence here is written
> in a quite confusing way, but there is no bug.
> 
> Could you drop? I don't think it's worth the backporting pain since it
> changes bpf_map_inc().

Agree, this is not a bug fix and should not go to stable. (Also agree that
the changelog is super confusing here and should have been done differently
to avoid exactly where we are here. I think I pointed that out in the
original patch, but seems this slipped through the cracks :/)

Thanks,
Daniel
