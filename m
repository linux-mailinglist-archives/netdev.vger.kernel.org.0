Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 164A02A36CE
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 23:54:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725993AbgKBWyt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 17:54:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:57758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725940AbgKBWyt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 17:54:49 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 33B8A20786;
        Mon,  2 Nov 2020 22:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604357688;
        bh=3rPNv3tweACEerZlH7qePNfQB72W6JIlqdUQEZAtz+k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ErX3h4pRsvT/GRay17JR/7/1aeDtq5vYxn2LkRiHz6rYQECdXusz7+ecxH2zEaCbc
         bs4HfO2UTfhHCSUB0qEQ/yzeIFmV6sg5xXk5YVJA/SBpJpm9JX5+stm2we2DL7KoYk
         YhigXpmuKF6ahrMro1UPsFVS3Dn+7llRhVa9EbCo=
Date:   Mon, 2 Nov 2020 14:54:47 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Shuah Khan <shuah@kernel.org>, linux-doc@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH net-next v2 0/3] net: introduce rps_default_mask
Message-ID: <20201102145447.0074f272@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <cover.1604055792.git.pabeni@redhat.com>
References: <cover.1604055792.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 30 Oct 2020 12:16:00 +0100 Paolo Abeni wrote:
> Real-time setups try hard to ensure proper isolation between time
> critical applications and e.g. network processing performed by the
> network stack in softirq and RPS is used to move the softirq 
> activity away from the isolated core.
> 
> If the network configuration is dynamic, with netns and devices
> routinely created at run-time, enforcing the correct RPS setting
> on each newly created device allowing to transient bad configuration
> became complex.
> 
> These series try to address the above, introducing a new
> sysctl knob: rps_default_mask. The new sysctl entry allows
> configuring a systemwide RPS mask, to be enforced since receive 
> queue creation time without any fourther per device configuration
> required.
> 
> Additionally, a simple self-test is introduced to check the 
> rps_default_mask behavior.

RPS is disabled by default, the processing is going to happen wherever
the IRQ is mapped, and one would hope that the IRQ is not mapped to the
core where the critical processing runs.

Would you mind elaborating further on the use case?
