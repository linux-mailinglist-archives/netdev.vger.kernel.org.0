Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C800283F2C
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 20:59:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729255AbgJES7O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 14:59:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727247AbgJES7O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 14:59:14 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59AB9C0613CE
        for <netdev@vger.kernel.org>; Mon,  5 Oct 2020 11:59:14 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kPVhT-00HNVd-F9; Mon, 05 Oct 2020 20:59:07 +0200
Message-ID: <1dc47668cc015c5a1bff10072e64e55a3436cbb7.camel@sipsolutions.net>
Subject: Re: [PATCH net-next 6/6] ethtool: specify which header flags are
 supported per command
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, kernel-team@fb.com, jiri@resnulli.us,
        andrew@lunn.ch, mkubecek@suse.cz
Date:   Mon, 05 Oct 2020 20:58:57 +0200
In-Reply-To: <20201005155753.2333882-7-kuba@kernel.org>
References: <20201005155753.2333882-1-kuba@kernel.org>
         <20201005155753.2333882-7-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-10-05 at 08:57 -0700, Jakub Kicinski wrote:
> 
> @@ -47,19 +61,16 @@ int ethnl_parse_header_dev_get(struct ethnl_req_info *req_info,
>  		NL_SET_ERR_MSG(extack, "request header missing");
>  		return -EINVAL;
>  	}
> +	/* Use most permissive header policy here, ops should specify their
> +	 * actual header policy via NLA_POLICY_NESTED(), and the real
> +	 * validation will happen in genetlink code.
> +	 */
>  	ret = nla_parse_nested(tb, ETHTOOL_A_HEADER_MAX, header,
> -			       ethnl_header_policy, extack);
> +			       ethnl_header_policy_stats, extack);

Would it make sense to just remove the validation here? It's already
done, so it just costs extra cycles and can't really fail, and if there
are more diverse policies in the future this might also very quickly get
out of hand?

johannes


