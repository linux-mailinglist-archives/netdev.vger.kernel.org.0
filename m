Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFABBD1C7E
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 01:10:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732529AbfJIXK1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 19:10:27 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:40534 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732157AbfJIXK1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 19:10:27 -0400
Received: by mail-qk1-f193.google.com with SMTP id y144so3838400qkb.7
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 16:10:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=NTimbsKgKVFDwuRCQXDTlqAXzNdTJ0Hr/Eiu/ueYeWQ=;
        b=j1N3WnyQePch5c3ATnoCW8Gc5+utVUM07IPkUm9U5i1N1JvfqxJFhHzkKW934vUUlP
         WkvTVLgvTE4vl+TZ523OqX2PD2BC162vDZeljPWx3plErfZrydgfhBIbUm4Si1O7JuQ8
         KFdNtHeSfIjs8hVYdCqBuC7z01mVYUvA2DLlo76GRCdf/CtgLkEnXA6Z0trETa6mPkHf
         qw+2ujEP6/yOZsntZfx9+c3uhSPh1prUi4yCGrwvmiRrE5zjnK9zpU8wB6QCwFRuoqmn
         0HkXxV68gwvc4Sb8Ap5qeAJpn5pEnFjJ6dNTOpqRIc3z4GHLSG68hnzwQN8ar5PGZY96
         8tXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=NTimbsKgKVFDwuRCQXDTlqAXzNdTJ0Hr/Eiu/ueYeWQ=;
        b=rFg/Zyn9B9Ko6JeDf4uKmgY44ice6aixyoLXnHSRdjLjoh2e/59t1A9RIPMHDHaR5Q
         i3WGzjw9DhCyy6uQxltMNQS3hJfxWEu4K/EglXm48DB4gfl3pNgKFB+x/UFqClPFK0LW
         Gvzx/Z2vBUpVnKnfHndBLvfDrsdEnwdK/Ho1CkHGnAnTIIwdHnsB6fE39GQbL84FZZzT
         kFc5gcaezJNzaU5SDyblr2aLVt/OF9OhV3Zi7airh82xtx5L07uv4wsiiddL6oSVtijn
         Gsj7g614N8BLXUy8ZraJdXLIXrvKpZngFj7b1OH2+16xp20UbcXvngmpmu854Eey6Hea
         yFfg==
X-Gm-Message-State: APjAAAUPjSFrN7ju5d9GS11tYqVjwwMkSLvh0HjUFnaRm+euzKVg7cjU
        IYzZyFqAjY36vaS1yjf0CCu/gQ==
X-Google-Smtp-Source: APXvYqxlFI2WcAzy9H2hDmeqvaySLV60xIVp+vEfJOOvBA+AepOhJJvAg79EbiCxLrXZdFhnQYnNxQ==
X-Received: by 2002:a37:6114:: with SMTP id v20mr6535756qkb.329.1570662626464;
        Wed, 09 Oct 2019 16:10:26 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id h29sm2161423qtb.46.2019.10.09.16.10.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2019 16:10:26 -0700 (PDT)
Date:   Wed, 9 Oct 2019 16:10:11 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Antonio Borneo <antonio.borneo@st.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: stmmac: fix disabling flexible PPS output
Message-ID: <20191009161011.117c7f77@cakuba.netronome.com>
In-Reply-To: <20191007154306.95827-4-antonio.borneo@st.com>
References: <20191007154306.95827-1-antonio.borneo@st.com>
        <20191007154306.95827-4-antonio.borneo@st.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 7 Oct 2019 17:43:05 +0200, Antonio Borneo wrote:
> Accordingly to Synopsys documentation [1] and [2], when bit PPSEN0
> in register MAC_PPS_CONTROL is set it selects the functionality
> command in the same register, otherwise selects the functionality
> control.
> Command functionality is required to either enable (command 0x2)
> and disable (command 0x5) the flexible PPS output, but the bit
> PPSEN0 is currently set only for enabling.
> 
> Set the bit PPSEN0 to properly disable flexible PPS output.
> 
> Tested on STM32MP15x, based on dwmac 4.10a.
> 
> [1] DWC Ethernet QoS Databook 4.10a October 2014
> [2] DWC Ethernet QoS Databook 5.00a September 2017
> 
> Signed-off-by: Antonio Borneo <antonio.borneo@st.com>
> Fixes: 9a8a02c9d46d ("net: stmmac: Add Flexible PPS support")

Applied to net, queued for stable.
