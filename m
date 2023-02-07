Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BE7968D245
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 10:12:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbjBGJMH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 04:12:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbjBGJMF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 04:12:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D53BCEC6F;
        Tue,  7 Feb 2023 01:12:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7243E6122F;
        Tue,  7 Feb 2023 09:12:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 764D7C433EF;
        Tue,  7 Feb 2023 09:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675761122;
        bh=eAPLvNMCJdn91h0tSbaai3TvxEt0wFO9or8uUoYg2k0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eQYRyL7pvTzqmu6BWY6Xanfj8XuBST4nsdcMOjyXCyDAxTNgVUMtmoy3H3aGAPV+5
         nUjHlC2H4hQa06p1/184r92ku10eCw9tMSprZeAL0ryORinLATYDjBEhouf0LMo95/
         1QhlmDXYef3Sl9NoLeRIxr4NySVm20m+hL2rj4/w=
Date:   Tue, 7 Feb 2023 10:12:00 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jaewan Kim <jaewan@google.com>
Cc:     johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, kernel-team@android.com, adelva@google.com
Subject: Re: [PATCH v7 1/4] mac80211_hwsim: add PMSR capability support
Message-ID: <Y+IV4OYhrhyhhrBz@kroah.com>
References: <20230207085400.2232544-1-jaewan@google.com>
 <20230207085400.2232544-2-jaewan@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230207085400.2232544-2-jaewan@google.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 07, 2023 at 08:53:57AM +0000, Jaewan Kim wrote:
> @@ -5053,6 +5097,74 @@ static bool hwsim_known_ciphers(const u32 *ciphers, int n_ciphers)
>  	return true;
>  }
>  
> +static int parse_ftm_capa(const struct nlattr *ftm_capa, struct cfg80211_pmsr_capabilities *out,
> +			  struct genl_info *info)
> +{
> +	struct nlattr *tb[NL80211_PMSR_FTM_CAPA_ATTR_MAX + 1];
> +	int ret = nla_parse_nested(tb, NL80211_PMSR_FTM_CAPA_ATTR_MAX,
> +				   ftm_capa, hwsim_ftm_capa_policy, NULL);
> +	if (ret) {
> +		NL_SET_ERR_MSG_ATTR(info->extack, ftm_capa, "malformed FTM capability");
> +		return -EINVAL;
> +	}

Another minor nit, you should have a blank line after the variable list
and before any real logic, right?

You do that in other places in this patch too.

thanks,

greg k-h
