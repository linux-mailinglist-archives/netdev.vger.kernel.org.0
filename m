Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B30B108152
	for <lists+netdev@lfdr.de>; Sun, 24 Nov 2019 02:01:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726803AbfKXBAx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 20:00:53 -0500
Received: from mail-pj1-f43.google.com ([209.85.216.43]:46437 "EHLO
        mail-pj1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726676AbfKXBAx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 20:00:53 -0500
Received: by mail-pj1-f43.google.com with SMTP id a16so4785886pjs.13
        for <netdev@vger.kernel.org>; Sat, 23 Nov 2019 17:00:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=CWFcM0DMaoDSh9/woX6th0rz2HiBMlq+l8GiYByy2nY=;
        b=kkjy/U5mAL6s4LBYMGmGuiS4bWkjCs9fUcrb6+FVUnklc0w8yKlF8ulT+ugmvtybvZ
         31eo5jX1WpqI9u26K6RFy2ayvFmk6hoNoSydtlKL45rCMlKcGe948XGUZx3PQXdI1hPd
         GPNIx91j5SHkUHGRZ6HkjhKkDJJ9a+akVLYc6bif8e4DhoDsqoc9wST7/Tg5U7gAYkiT
         lf0fXRk2u2cjZztEPtiSvq777aqrGTVGIh69EhYzCclFGD2TksmLUfJ8tjSG0xBEaTl2
         t1rQwZhT9eUPQ4dMB7PPr686iljuCdTZaNIxhRfflhqgVCr3oVRlluzCG9ZBzxYH83Ty
         KGTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=CWFcM0DMaoDSh9/woX6th0rz2HiBMlq+l8GiYByy2nY=;
        b=pIv1nt07sfG+vSD19E2EUekjkjMJZPbNWTDDJV7s7bSlk4rFxE8DIBLWSQGgpKT8Ye
         IeWSQd3xIJ6lw+W74Nc7Ouv+FwxADD+3IQ4T7Vi75/U4BOQruROyVG8/oOnNhmVQapIS
         eDsHSBf16ipwRG9PivrxW+5fXJe0HC0dyhWGLGWE/6oyP7kCt1gLXclNcyqHuZrDPRHB
         TaGuNeqy1hGqF7sSmzIjmLJAWzugIEao9Mxzt6U4iBqeZDZFThjNN9K/trSYABe8X0Y0
         xUCXQYMnP/ySssHLusY5yvSHUShhNjpV5GGLBXvUVkjlATud4XQF5uc2XhmhlaoUJJg8
         fehQ==
X-Gm-Message-State: APjAAAU4kmnPnbmnrKhfCZgK0YmOAH2TJZDqDDnq5MQBPWUARiEEim7T
        u64XkedQLq15wNr/TF5NKtnqDg==
X-Google-Smtp-Source: APXvYqziDD+/pfQELr9/e7pRW74TaiCEGvy8fnlDn2EMdPo8FMnHGgKttFI/LGYgyTGQeHNZ8ui6CA==
X-Received: by 2002:a17:902:9344:: with SMTP id g4mr22458574plp.16.1574557252300;
        Sat, 23 Nov 2019 17:00:52 -0800 (PST)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id o16sm3259469pjp.23.2019.11.23.17.00.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Nov 2019 17:00:52 -0800 (PST)
Date:   Sat, 23 Nov 2019 17:00:46 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        David Ahern <dsahern@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH V2 net-next 3/6] net/mlxfw: Improve FSM err message
 reporting and return codes
Message-ID: <20191123170046.7733a023@cakuba.netronome.com>
In-Reply-To: <20191122224126.24847-4-saeedm@mellanox.com>
References: <20191122224126.24847-1-saeedm@mellanox.com>
        <20191122224126.24847-4-saeedm@mellanox.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 22 Nov 2019 22:41:50 +0000, Saeed Mahameed wrote:
> +	NL_SET_ERR_MSG_MOD(extack, MLXFW_ERR_PRFX "%s",
> +			   mlxfw_fsm_state_err_str[fsm_state_err]);

Things like this also require a word of comment, because the intention
of wrapping all extact strings into the macro IIRC was to mark them for
possible translation. 

IDK if we still care about that (IMHO we should), we probably need at
least a new macro for cases like this so the strings in the error table
are marked for extraction for translators as well, no?
