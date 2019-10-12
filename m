Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E72BBD510C
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 18:33:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729236AbfJLQdN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Oct 2019 12:33:13 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:43919 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727423AbfJLQdN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Oct 2019 12:33:13 -0400
Received: by mail-wr1-f65.google.com with SMTP id j18so15019308wrq.10
        for <netdev@vger.kernel.org>; Sat, 12 Oct 2019 09:33:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=WK0aZtBfkjzF2vB8/5+pzziZzjABmbX2uXNAi/6qqVY=;
        b=lU/QjJsd0iMUxgEz3IhsP8HaMvgoGdR4I/B6oB9obychkcm1NXhuKGhvEAUnEXPXQK
         KVisFsqiRvr6/mNpVqZxlMkZJxxNPijRUFARXQlQIztCL7oEgpVVOPwW2GqsWaLRyLv7
         Yq1wBpnSSsmQ5JVxw7sE0Ya5BbVBxmNT+f70ZVTq5kHPEb8ky+dwAPutUHbRNiKaleXu
         2YpYP2Z7SfF9VABD19W/sDZQcSEceF7OPiZxAHrTkZbFc5DyzBzKIB8VNmv8d3DaSZIz
         wmii5ceGd719vgr7vM3DawcdFYCbeLLkcNAieHPrxO6U1+8CSW+79ioVlh5QXEgVbm8k
         Qpeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=WK0aZtBfkjzF2vB8/5+pzziZzjABmbX2uXNAi/6qqVY=;
        b=PysiqIBmDI4tP7UGWYdzhIzObH1gly6T+fBGUDQ8ATT4dNF4VpE9lz+Ln6JffMSAhr
         FNjFQQliZKpMHQNWoUUuft1Bu2naQKt1UvL6Hlg2ccd2WE0G3Z9/CTV3v0W/UO8Z5RIu
         xw5iVGIuMaRMzYR2Ln/PLK8TkFL7H3oXih8hqL80VO+v2JQfjpQ8Clqd2m5HFFDVNaLG
         AB4R8yYsrkiwvx32fX168GxR/US1u+zIbygOuK6re8W4C7xF6Z42pRprVAae3FL4TPOM
         bJ0kazrXz+Z0LM/6zyRZ44V+Oc8j8xZyy/IeQCxmpbxuKsd+0XQq3dHdSjnwgPtRxGt9
         aFvQ==
X-Gm-Message-State: APjAAAWb9p2u5/Ee5yMuosNIItTq1bNAErSMIRaV64GlbczC4M5EGr9l
        ql7DN8IGPg9XMq6BuzwWIxfikw==
X-Google-Smtp-Source: APXvYqx0gE9jjfI4wMYpx2TWxq6U428URJZdGf7D1iK2MfrVuLbFKwv4kZ5uQ3X6jHg3QLv4d4rKag==
X-Received: by 2002:adf:f18a:: with SMTP id h10mr17622633wro.145.1570897990815;
        Sat, 12 Oct 2019 09:33:10 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id l18sm14362413wrc.18.2019.10.12.09.33.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Oct 2019 09:33:10 -0700 (PDT)
Date:   Sat, 12 Oct 2019 18:33:09 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v7 14/17] ethtool: set link settings with
 LINKINFO_SET request
Message-ID: <20191012163309.GA2219@nanopsycho>
References: <cover.1570654310.git.mkubecek@suse.cz>
 <aef31ba798d1cfa2ae92d333ad1547f4b528ffa8.1570654310.git.mkubecek@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aef31ba798d1cfa2ae92d333ad1547f4b528ffa8.1570654310.git.mkubecek@suse.cz>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Oct 09, 2019 at 10:59:43PM CEST, mkubecek@suse.cz wrote:

[...]

>+static const struct nla_policy linkinfo_hdr_policy[ETHTOOL_A_HEADER_MAX + 1] = {
>+	[ETHTOOL_A_HEADER_UNSPEC]		= { .type = NLA_REJECT },
>+	[ETHTOOL_A_HEADER_DEV_INDEX]		= { .type = NLA_U32 },
>+	[ETHTOOL_A_HEADER_DEV_NAME]		= { .type = NLA_NUL_STRING,
>+						    .len = IFNAMSIZ - 1 },

Please make ETHTOOL_A_HEADER_DEV_NAME accept alternative names as well.
Just s/IFNAMSIZ/ALTIFNAMSIZ should be enough.

>+	[ETHTOOL_A_HEADER_GFLAGS]		= { .type = NLA_U32 },
>+	[ETHTOOL_A_HEADER_RFLAGS]		= { .type = NLA_REJECT },
>+};

[...]
