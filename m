Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2DBC13156E
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 16:51:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726784AbgAFPvj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 10:51:39 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:50570 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726454AbgAFPvi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jan 2020 10:51:38 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.3)
        (envelope-from <johannes@sipsolutions.net>)
        id 1ioUf9-000FuE-A9; Mon, 06 Jan 2020 16:51:27 +0100
Message-ID: <8f17a0bca11604d9818326b01267186bd91236c9.camel@sipsolutions.net>
Subject: Re: [PATCH] iwlwifi: remove object duplication in Makefile
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Masahiro Yamada <masahiroy@kernel.org>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        linux-wireless@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Date:   Mon, 06 Jan 2020 16:51:25 +0100
In-Reply-To: <20200106075439.20926-1-masahiroy@kernel.org> (sfid-20200106_090403_620011_D178F66E)
References: <20200106075439.20926-1-masahiroy@kernel.org>
         (sfid-20200106_090403_620011_D178F66E)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-01-06 at 16:54 +0900, Masahiro Yamada wrote:
> The objects in $(iwlwifi-objs) $(iwlwifi-y) $(iwlwifi-m) are linked to
> iwlwifi.ko .
> 
> This line adds $(iwlwifi-m) to iwlwifi-objs, so the objects from
> $(iwlwifi-m) are listed twice as the dependency of the module.

Are you sure? We have

obj-$(CONFIG_IWLWIFI)   += iwlwifi.o

and then "iwlwifi-y += ...", but I was under the impression that
iwlwifi.o didn't really pick up iwlwifi-m automatically, that's not
something that you'd normally do, normally -m only makes sense to build
a module using "obj-m", just here we do it for the mvm sub level
stuff...

johannes

