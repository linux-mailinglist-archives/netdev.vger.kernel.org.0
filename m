Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD456665160
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 02:54:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229651AbjAKByo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 20:54:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234508AbjAKByf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 20:54:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97A8CF5A4
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 17:54:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1A958B81A65
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 01:54:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C0A9C433EF;
        Wed, 11 Jan 2023 01:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673402071;
        bh=tuRVZHUybIiJvEE0lcJF7TV7SaKA28eXFVA462GfoUQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=i/yeTBWatkTYOaOQ6X4P6knSLRGr88c02niEa7gAa5iPedaxQqgEtb5e6AKlTkQTp
         ACaRuOgoTF4ScnVofrjqmTGU88UvaCYMKFucAmyL1k6RGCYjOGpNgn7EoN+pa0K/93
         W1+duU5VWdjxDeP0e818L0Im+tzdNbKUwLMKWVxiftb5uHfLoviLTbtUB8OeEnbzDi
         GQoesQI5xdRgy75iVpd/rE2rbdxUqxjIgWXyEw6kE1FjZeTJOIMoTHhQcpSct3dCQ0
         tIe2dLKtH+SydAUKVCtYMOXoOR/ro5aQTiBiywDduEkuchN2KwNMoy/cDf1LJFXIgf
         s5MH+Ww1dvY/A==
Date:   Tue, 10 Jan 2023 17:54:30 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sudheer Mogilappagari <sudheer.mogilappagari@intel.com>
Cc:     netdev@vger.kernel.org, mkubecek@suse.cz, andrew@lunn.ch,
        sridhar.samudrala@intel.com, anthony.l.nguyen@intel.com
Subject: Re: [PATCH ethtool-next v5 2/2] netlink: add netlink handler for
 get rss (-x)
Message-ID: <20230110175430.19b593ec@kernel.org>
In-Reply-To: <20230110045245.3571556-3-sudheer.mogilappagari@intel.com>
References: <20230110045245.3571556-1-sudheer.mogilappagari@intel.com>
        <20230110045245.3571556-3-sudheer.mogilappagari@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

LGTM! Couple of nit picks

On Mon,  9 Jan 2023 20:52:45 -0800 Sudheer Mogilappagari wrote:
> +	if (hfunc) {
> +		for (i = 0; i < get_count(hash_funcs); i++) {
> +			if (hfunc & (1 << i))
> +				print_string(PRINT_JSON, "rss-hash-function",
> +					     NULL, get_string(hash_funcs, i));

break?

> +		}
> +	}

> +	ret = nlsock_process_reply(nlctx->ethnl2_socket, get_channels_cb, args);
> +
> +	if (ret < 0)
> +		return MNL_CB_ERROR;

no empty lines between function call and the error check
