Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DEE0118FF1
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 19:43:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727704AbfLJSnq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 13:43:46 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:33288 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727568AbfLJSnq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 13:43:46 -0500
Received: by mail-wm1-f66.google.com with SMTP id d139so1831576wmd.0
        for <netdev@vger.kernel.org>; Tue, 10 Dec 2019 10:43:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=/T5WjX6H/ErjoxiBfZBOaK9N8M3Emjx06kbzRJKScRU=;
        b=u61jC3dd5btuU1LTirGEHKGHO/sJAFpAvEbzr+r1IhSxUBB5d0YLbmzQBXxIGwpBqC
         dyShA8AuIfIsoS6Gt89TdqqcNVg4/oxz9xEbe43RzdYkG00ZvC74qekSPQ4p4RVpYWS0
         erL4Shrlk+eanoB++nsy6IlIDey4C0c5fJYz8A18wCVW3s4aZgx/X+UsPX+XKO1MLNU6
         5jWbrMHbQk61z+gM/h8jjPZ08CyI4F4iTrqWSz7cOkoagX2DbAFgXX6PXs7sJrQBTJ1h
         Fdv4BNBKcV42OHJJQe1DoQTwprZLJkMe9B2qIF5lFvN1pws65xCHBUq3ao8/2bwpghuw
         bXwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=/T5WjX6H/ErjoxiBfZBOaK9N8M3Emjx06kbzRJKScRU=;
        b=tGEOuilqZL8lbka534g7kevi9BTq/LdTCMHHlpIYS3MsBXthSGRpUhyX0p6aDzExYV
         mLWzKQZL3rz6Xaen9khSQVDNcAIqCA2/B7/i+GOJs/WmsmRGrvPTCq3aJL966GmGvgpy
         dxze040auEvDFjV/ffFImRlOlEN+yUzQylA0m5zfZa8+m8Qlnngq/iRG86B6pIdvWovY
         KLZAHeex39BEoP5+/fTPyqb9DU/nt65ieAc23vhVMqk2UmJSVO/z2BZHKhVN7NXA5eQk
         jEELMa+PNeb1m1QX90Ve5aXKvGt5zim44WfdM6LfhU6gQBfsCaPQYQ55qIsBOHtLM6Qh
         5bKA==
X-Gm-Message-State: APjAAAVA75LwFAOulhqcBnPRiH6OdfyVOyN7/zeqjW73r4Eiyw9uqNDD
        dp4kh5MtxP6ZMnQTghaizzVtHQ==
X-Google-Smtp-Source: APXvYqxvMexfjRMDF/ZdvhMlXOWa9ckksgWIQ7Dd4HvHvuiFS9+JslyuWH/yANwKzxTom9TBT9/iKw==
X-Received: by 2002:a7b:c95a:: with SMTP id i26mr6749458wml.67.1576003424871;
        Tue, 10 Dec 2019 10:43:44 -0800 (PST)
Received: from localhost (ip-94-113-220-172.net.upcbroadband.cz. [94.113.220.172])
        by smtp.gmail.com with ESMTPSA id o4sm4121296wrx.25.2019.12.10.10.43.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2019 10:43:44 -0800 (PST)
Date:   Tue, 10 Dec 2019 19:43:43 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Michal Kubecek <mkubecek@suse.cz>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 1/5] rtnetlink: provide permanent hardware
 address in RTM_NEWLINK
Message-ID: <20191210184343.GB7075@nanopsycho>
References: <cover.1575982069.git.mkubecek@suse.cz>
 <7c28b1aa87436515de39e04206db36f6f374dc2f.1575982069.git.mkubecek@suse.cz>
 <20191210095105.1f0008f5@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191210095105.1f0008f5@cakuba.netronome.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Dec 10, 2019 at 06:51:05PM CET, jakub.kicinski@netronome.com wrote:
>On Tue, 10 Dec 2019 14:07:53 +0100 (CET), Michal Kubecek wrote:
>> @@ -1822,6 +1826,7 @@ static const struct nla_policy ifla_policy[IFLA_MAX+1] = {
>>  	[IFLA_PROP_LIST]	= { .type = NLA_NESTED },
>>  	[IFLA_ALT_IFNAME]	= { .type = NLA_STRING,
>>  				    .len = ALTIFNAMSIZ - 1 },
>> +	[IFLA_PERM_ADDRESS]	= { .type = NLA_REJECT },
>>  };
>>  
>>  static const struct nla_policy ifla_info_policy[IFLA_INFO_MAX+1] = {
>
>Jiri, I just noticed ifla_policy didn't get strict_start_type set when
>ALT_IFNAME was added, should we add it in net? 🤔

Hmm, I guess that is a good idea.
