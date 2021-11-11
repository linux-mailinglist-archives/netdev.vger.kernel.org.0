Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8144044D717
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 14:19:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233103AbhKKNWP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 08:22:15 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:33638 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231380AbhKKNWN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 08:22:13 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 45D1621B3F;
        Thu, 11 Nov 2021 13:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1636636763; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SfKWIUU8vb7iJtjFhMgFoCcAJQ0+fk9FkYDz9TP+vJs=;
        b=nkwwNJqxbmhjHUsXEt7jZzx37xCR3/KovOs+98/kO/6cVqPMzA27P9zVgaZu6Xawx39i1c
        v6G92jOJrgikchMAYQ2jTYNA6JlVSHEOGdPBm9Ut8MIvWQbewhIw2/Gzc2far/sDaB4zLo
        7P9XcQTCCdoLRoGu+U5fe087MbjXpRI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1636636763;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SfKWIUU8vb7iJtjFhMgFoCcAJQ0+fk9FkYDz9TP+vJs=;
        b=Y4/9pgiP7Ncf6J+uBKb+GK/Wbw3UnoWCOharKFtXIcsBhs5Bn/IcZ9nKsCZfekPmkBg2Mi
        pOTAfz1VFOZEUSAQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 99CF913DB4;
        Thu, 11 Nov 2021 13:19:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id AMDXIFoYjWEAIAAAMHmgww
        (envelope-from <dkirjanov@suse.de>); Thu, 11 Nov 2021 13:19:22 +0000
Subject: Re: [PATCH] net: ieee802154: fix shift-out-of-bound in
 nl802154_new_interface
To:     Dongliang Mu <mudongliangabcd@gmail.com>,
        Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211111125118.1441463-1-mudongliangabcd@gmail.com>
From:   Denis Kirjanov <dkirjanov@suse.de>
Message-ID: <5a1969b0-f5ad-d5b4-0c66-14e65fdcd0dd@suse.de>
Date:   Thu, 11 Nov 2021 16:19:21 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211111125118.1441463-1-mudongliangabcd@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: ru
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



11/11/21 3:51 PM, Dongliang Mu пишет:
> In nl802154_new_interface, if type retrieved from info->attr is
> NL802154_IFTYPE_UNSPEC(-1), i.e., less than NL802154_IFTYPE_MAX,
> it will trigger a shift-out-of-bound bug in BIT(type).
> 
> Fix this by adding a condition to check if the variable type is
> larger than NL802154_IFTYPE_UNSPEC(-1).

Please add Fixes tag

> 
> Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
> ---
>   net/ieee802154/nl802154.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
> index 277124f206e0..cecf5ce0aa20 100644
> --- a/net/ieee802154/nl802154.c
> +++ b/net/ieee802154/nl802154.c
> @@ -915,7 +915,7 @@ static int nl802154_new_interface(struct sk_buff *skb, struct genl_info *info)
>   
>   	if (info->attrs[NL802154_ATTR_IFTYPE]) {
>   		type = nla_get_u32(info->attrs[NL802154_ATTR_IFTYPE]);
> -		if (type > NL802154_IFTYPE_MAX ||
> +		if (type <= NL802154_IFTYPE_UNSPEC || type > NL802154_IFTYPE_MAX ||
>   		    !(rdev->wpan_phy.supported.iftypes & BIT(type)))
>   			return -EINVAL;
>   	}
> 
