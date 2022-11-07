Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1333261F364
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 13:34:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232311AbiKGMec (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 07:34:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232279AbiKGMe0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 07:34:26 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA4F0C752;
        Mon,  7 Nov 2022 04:34:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=XJWdfHds6cu0a4MTLgis3djdrD+COFTfF+Wy0zLW4R0=; b=lJDbHNVaBv7jiewOvtBkS6Pcdp
        Ka0h5e7/h6sRgeEM2NbmWjo5zwTDPfnEe4U5AAX126ujmtNDdketXBLXb4Ya8cji7qx2n7xmS6/Sl
        H0xAFNn1qZw1mjEvqJP0pXDRntAARB1ekl0ZBzYEDungU2oGxMQheLcualkzjUOPis2CGC5PGW0aO
        AlVO2WpmuLQ5tjVhL6tWFaJ1lDpO7WGaaq2zyPbJLxLt8rStoHw0lPswo3B0QIfAXJP0qv+B5sPCw
        WQeIYv+elK4FQKEy2nooNmpRROtPEoh+Oj4pCdvaFDNEm0KnGRpdk06PCJ0tRZqOmWxzcGtie5S02
        FWUf9EdQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35154)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1os1K1-0001u9-Tj; Mon, 07 Nov 2022 12:33:50 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1os1Jv-0003mj-7M; Mon, 07 Nov 2022 12:33:43 +0000
Date:   Mon, 7 Nov 2022 12:33:43 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Yang Jihong <yangjihong1@huawei.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, illusionist.neo@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, mykolal@fb.com, shuah@kernel.org,
        benjamin.tissoires@redhat.com, memxor@gmail.com,
        asavkov@redhat.com, delyank@fb.com, bpf@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH bpf v2 4/5] bpf: Add kernel function call support in
 32-bit ARM for EABI
Message-ID: <Y2j7J9mJxmKJ4ZpP@shell.armlinux.org.uk>
References: <20221107092032.178235-1-yangjihong1@huawei.com>
 <20221107092032.178235-5-yangjihong1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221107092032.178235-5-yangjihong1@huawei.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 07, 2022 at 05:20:31PM +0800, Yang Jihong wrote:
> +bool bpf_jit_supports_kfunc_call(void)
> +{
> +	return true;

It would be far cleaner to make this:

	return IS_ENABLED(CONFIG_AEABI);

So userspace knows that it isn't supported on OABI.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
