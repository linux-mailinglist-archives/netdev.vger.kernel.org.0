Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1388F21AD34
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 05:02:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726965AbgGJDCv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 23:02:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:44330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726560AbgGJDCr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jul 2020 23:02:47 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2511420720;
        Fri, 10 Jul 2020 03:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594350167;
        bh=za7gs0gUCtrltuTNaJu4iuxF+c3YqBuGIO0t8dbss/U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=z/B1H3VNVqtIErn0TKiyVm6arQmW3EUP/JRJVyxYeFLTzE/25w7UQXc7Qr0CRk7Gb
         rPvM1132yYd1LmPlpMMq8SHuNxS1RvHLgw/h0fyy/5e56FTqatisC6KXaO+cSaSk9Z
         bZ2Ggw0XtUxPipD7AZmhyqAyMzD1fjkltz1zdDCY=
Date:   Thu, 9 Jul 2020 20:02:45 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tom Herbert <tom@herbertland.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Michael Chan <michael.chan@broadcom.com>,
        edwin.peer@broadcom.com, emil.s.tantilov@intel.com,
        alexander.h.duyck@linux.intel.com,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Michal Kubecek <mkubecek@suse.cz>
Subject: Re: [PATCH net-next v2 00/10] udp_tunnel: add NIC RX port offload
 infrastructure
Message-ID: <20200709200245.6644aa56@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CALx6S34JePNX62=rPq5aTW6W_tpPwSeseGcq13iAaJ9Y53QTiQ@mail.gmail.com>
References: <20200709011814.4003186-1-kuba@kernel.org>
        <CALx6S34JePNX62=rPq5aTW6W_tpPwSeseGcq13iAaJ9Y53QTiQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 9 Jul 2020 19:33:11 -0700 Tom Herbert wrote:
> The patch set looks good for its purpose, but, sorry, I can't resist
> another round of complaining about vendors that continue to develop
> protocol specific offloads instead of moving to protocol agnostic
> generic offloads.

I agree with all your points. I hope that the improvements in visibility
into NIC capabilities and state will not encourage vendors to provide
more protocol specific offloads. 

Out-of-tree drivers for the last few generations of HW already have 
the capability to query or configure the RSS over inner fields, so 
that would just catch upstream up with the existing hacks.

I hope that building more opinionated logic as an explicit device driver
interface, rather than expecting drivers to peer directly into the state
of the stack will also help us shape the offloads. (Perhaps we would
have caught that folks are using the UDP ports for TX parsing if we
started this way.) Whether my work is misguided or I'm going about it
in a wrong way.. hard for me to tell :S

Oh, and I don't currently work for a vendor, perhaps that'd help you
trust my intentions here ;)
