Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AC32288EF7
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 18:33:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389814AbgJIQdW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 12:33:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:40166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388719AbgJIQdW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Oct 2020 12:33:22 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 846242227F;
        Fri,  9 Oct 2020 16:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602261202;
        bh=0TLGZSt+khC/pikpgWfug5G23YTSWoMW9MMxrN0CLl0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pLFIWi9kDQjZlh8dpgQ/IqjwyU57oe7XUb4tkl3brq+GcaYo6f0CzZyfTsBanOSar
         VqoZ7eocohiP0nZTYNDrxbm+DkxDtF4LahN4978V0xDyT0WdsM/pvvUHrbwjlmZjLE
         W9eCWeiys6kOdQfAhMsy91l6qkMpqSOs9rh6eCUg=
Date:   Fri, 9 Oct 2020 09:33:19 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        maze@google.com, lmb@cloudflare.com, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>, marek@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        eyal.birger@gmail.com
Subject: Re: [PATCH bpf-next V3 0/6] bpf: New approach for BPF MTU handling
Message-ID: <20201009093319.6140b322@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <160216609656.882446.16642490462568561112.stgit@firesoul>
References: <160216609656.882446.16642490462568561112.stgit@firesoul>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 08 Oct 2020 16:08:57 +0200 Jesper Dangaard Brouer wrote:
> V3: Drop enforcement of MTU in net-core, leave it to drivers

Sorry for being late to the discussion.

I absolutely disagree. We had cases in the past where HW would lock up
if it was sent a frame with bad geometry.

We will not be sprinkling validation checks across the drivers because
some reconfiguration path may occasionally yield a bad packet, or it's
hard to do something right with BPF.
