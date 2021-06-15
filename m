Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3A863A7707
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 08:24:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229989AbhFOG06 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 02:26:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbhFOG04 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 02:26:56 -0400
Received: from canardo.mork.no (canardo.mork.no [IPv6:2001:4641::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79E35C061767
        for <netdev@vger.kernel.org>; Mon, 14 Jun 2021 23:24:52 -0700 (PDT)
Received: from miraculix.mork.no ([IPv6:2a01:799:c9e:6708:7fba:f3d4:906e:68a0])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id 15F6Oe6E021592
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Tue, 15 Jun 2021 08:24:40 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1623738280; bh=DVgq/n1Crmn/UYfbmIP90K2MOKwUX5XevoiyrSOUQb0=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=LAluiTF+QHQowPaqTkFacdZZ2HygmHYvT8ZaJBPgIIul7l/Gb9/3SLF9jfhcqlx3i
         8twIiQsEq8ydrUwpDq6sZ8UtvdA+3nz1LKfNSw2vsklGZy4RomlLQQvc7puxXw5k9O
         KxeGLCJ1su/ieU+h6D4Lb6s9/4/es1VgMIKQS2UA=
Received: from bjorn by miraculix.mork.no with local (Exim 4.94.2)
        (envelope-from <bjorn@mork.no>)
        id 1lt2V5-000Y6s-Pc; Tue, 15 Jun 2021 08:24:39 +0200
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Kristian Evensen <kristian.evensen@gmail.com>,
        netdev@vger.kernel.org, subashab@codeaurora.org
Subject: Re: [PATCH net] qmi_wwan: Clone the skb when in pass-through mode
Organization: m
References: <20210614141849.3587683-1-kristian.evensen@gmail.com>
        <8735tky064.fsf@miraculix.mork.no>
        <20210614130530.7a422f27@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Date:   Tue, 15 Jun 2021 08:24:39 +0200
In-Reply-To: <20210614130530.7a422f27@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        (Jakub Kicinski's message of "Mon, 14 Jun 2021 13:05:30 -0700")
Message-ID: <87pmwnwspk.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.102.4 at canardo
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:

> It does look pretty strange that qmimux_rx_fixup() copies out all
> packets and receives them, and then let's usbnet to process the
> multi-frame skb without even fulling off the qmimux_hdr. I'm probably
> missing something.. otherwise sth like FLAG_MULTI_PACKET may be in
> order?

Yes, maybe it is?  We'd have to call usbnet_skb_return() for the plain
IP frames then, but that might come out cleaner?


Bj=C3=B8rn
