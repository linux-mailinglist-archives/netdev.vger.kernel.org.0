Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1651E9BFEB
	for <lists+netdev@lfdr.de>; Sat, 24 Aug 2019 21:53:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727728AbfHXTw5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Aug 2019 15:52:57 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:45500 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727564AbfHXTw5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Aug 2019 15:52:57 -0400
Received: by mail-qk1-f193.google.com with SMTP id m2so11179968qki.12
        for <netdev@vger.kernel.org>; Sat, 24 Aug 2019 12:52:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=fgUV1RFBmFzKtJsv29mzNaWXPpAf80zoXUESA1QXwF0=;
        b=GCO764396//DTY/MQzjUh1hrC/6fH8jNh0lYGneA5KvajWZppqvxUz2KiYuEHm8vSq
         I3aIJa9A1Ir9QlU+jpbHAUE6onWzwzE8rRAsFS2YnOSrdzWawVpB0vnXkth4ezYjDALa
         Jl4UQe2u0utufjcVT5OM5TTZzQzv8XgqyQ4bjMwe2epEr0jj+TCsZ739TBM7OKN1rThC
         BNBvUr38TbknamEZib4XkX41nNaHXhZgm3NtlB1q8GbAcRsNOKMsenSBt/a6B5C5ugGy
         gmnCcF01U8HF/oHdZMMXDMImqECzHA+bqB2WJZfFkkGCq7AlTfomeYrCieUY8QRY7Pke
         DI5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=fgUV1RFBmFzKtJsv29mzNaWXPpAf80zoXUESA1QXwF0=;
        b=E28YlopB1u0+qUPxaMiZp0blB6ecHMVICfndrh2X064zjqAMXwyvw65l0WjwC5gFP6
         Mi2pweBXhwgtaAmNxVUuOBp92XhEqxkIm2Sljkf56hnib67Af1ES+l9++LsO+HePhArg
         64rC5NWjOsOmdNebFnRLd867I6QzqLgGsbVUARNLe8rmKm6yrewWBhSsWplTNVJsQv1S
         2Ogb/5rTqYOXK0iqr3uxtf/iw8jzOrh0JGVgJJqLQRlODsH4/wmzzMhPiPqz4+e4JU/R
         +L0YIb+9gGggM6qHKGw0/yJbhR7H67BPTzCGlz2oTaJkyNcHMpdhKIoDsgj1OZme38/q
         GlOg==
X-Gm-Message-State: APjAAAUeT0pnjug5+B19y4sNKyu8XrGEoCO7o+O8sjdjoWAEmFeCiOPY
        sB1HTQ62i2XsYfew2sEsvRvj6gfy
X-Google-Smtp-Source: APXvYqwELbOZLMdtlFHacEG8DAiDcif8Nmd0YP8gkNrmKqvjH2Q8oimZMVwBe0wZ0hubwI3+VWJQwA==
X-Received: by 2002:a37:96c7:: with SMTP id y190mr9841917qkd.111.1566676376256;
        Sat, 24 Aug 2019 12:52:56 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id w10sm3410652qts.37.2019.08.24.12.52.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Aug 2019 12:52:55 -0700 (PDT)
Date:   Sat, 24 Aug 2019 15:52:54 -0400
Message-ID: <20190824155254.GG32555@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Marek =?UTF-8?B?QmVow7pu?= <marek.behun@nic.cz>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Marek =?UTF-8?B?QmVow7pu?= <marek.behun@nic.cz>
Subject: Re: [PATCH net-next v2 4/9] net: dsa: mv88e6xxx: create
 chip->info->ops->serdes_get_lane method
In-Reply-To: <20190824154502.GD32555@t480s.localdomain>
References: <20190823212603.13456-1-marek.behun@nic.cz>
 <20190823212603.13456-5-marek.behun@nic.cz>
 <20190824154502.GD32555@t480s.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Also can you place the mv88e6xxx_serdes_get_lane() function as static inline
in the serdes.h header? So that it's obvious that it's a wrapper and not a
switch implementation.

Ho and you can skip the 'chip->info->ops->' from the commit subject line ;-)
