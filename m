Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CB32202BC1
	for <lists+netdev@lfdr.de>; Sun, 21 Jun 2020 19:29:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730456AbgFURTZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jun 2020 13:19:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730450AbgFURTZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Jun 2020 13:19:25 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03412C061794
        for <netdev@vger.kernel.org>; Sun, 21 Jun 2020 10:19:24 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id a12so3423034ion.13
        for <netdev@vger.kernel.org>; Sun, 21 Jun 2020 10:19:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=P7wAbrq3hZ+mGT3yAcBV6RPoRN+dQ9yLt/dmA5YVnrU=;
        b=CMLbb1SISLL6pA00GXntFY6cCoqXcfJntRdxsHQ3qIjKLcTus0HvauuImIXH0MDy3u
         jxjtZG5jHXUZg0mCo3VXMLuMF2/nYd3L+1lAFXOUTHmlGN5t0e9HqIFFk9CAfyXu6LUE
         8/Q7glAH/rXIMNfXuLenBxLf8I3KzAtFNHTJrUF3twxdGMv/iy7bu39RA8Dm0hplSwO9
         vbXTYHzPn5VeSUOu/OYJf5vmyZn9m1H1RJnT4QBgmui6Ofd2GkXYJJmkOZE9VerYWn4c
         LPa2UoOx7PJLO6PWXJZixdxahpxXx+To7/sb8XpB8DAUm4yyEkifbtcnH9pHr/ol4Q1q
         z7AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=P7wAbrq3hZ+mGT3yAcBV6RPoRN+dQ9yLt/dmA5YVnrU=;
        b=PIad9BaZmKsJnQpPtex9sjkIddJrNhHN0x3dp7hn692Kxlvxf9+F4BbMw4LMQr1+F4
         R47p4YV+4xwW1JBfAEhl5t6lyuyOTyeRJX/qhnMcqdLqW5OTfBHyqEksIvGl5tU0l443
         pGBeYIDdrqhOarypIMf6AbgIWsrBrnLjV1JVgJUbud2wj4UpDnhlgC2RZ4k9/SfZItn6
         zGxyiI0t6WiF1E9sCD2DfqOW+XL7ilJ5BCRCXgrlLMAOH0H0ATu0k4V5+LR9hx/T9b8S
         L8fAjGOvKG5nLEOBSUTzqhZY2G//tFWxBTtKutDZPCWgwPfc6z+LwYBZGMxmxqHuMiIN
         s/8g==
X-Gm-Message-State: AOAM530mYU0voYm9aiwOGlgujJhSMorE/8r/WUuw4hAmtquWJyJM8Rta
        CF3RsyyV7bXo6/TC3eL06ow=
X-Google-Smtp-Source: ABdhPJxiiTqfhnELgm6A/6FCjIJvY3QBbq+zTvY7oh8zfGQJIUBM/hvq3YHv/Rhy7kgpl1RCJukvvg==
X-Received: by 2002:a6b:b344:: with SMTP id c65mr1109547iof.123.1592759964261;
        Sun, 21 Jun 2020 10:19:24 -0700 (PDT)
Received: from [10.254.22.15] ([138.68.32.133])
        by smtp.googlemail.com with ESMTPSA id h13sm6573875ile.18.2020.06.21.10.19.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Jun 2020 10:19:23 -0700 (PDT)
Subject: Re: missing retval check of call_netdevice_notifiers in
 dev_change_net_namespace
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        David Miller <davem@davemloft.net>,
        Petr Machata <petrm@mellanox.com>
Cc:     Netdev <netdev@vger.kernel.org>, Ido Schimmel <idosch@mellanox.com>
References: <CAHmME9rz0JQfEBfOKkopx6yBbK_gbKVy40rh82exy1d7BZDWGw@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <9d71991b-2339-f569-b8d3-620473e3c004@gmail.com>
Date:   Sun, 21 Jun 2020 10:19:21 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <CAHmME9rz0JQfEBfOKkopx6yBbK_gbKVy40rh82exy1d7BZDWGw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+Ido

On 6/21/20 1:58 AM, Jason A. Donenfeld wrote:
> 
> Finally, it could be the solution is that modules that use the netdev
> notifier never really rely too heavily upon getting notifications, and
> if they need something reliable, then they rearchitect their code to
> not need that. I could imagine this attitude holding sway here
> somehow, but it's also not very appealing from a code writing and
> refactoring perspective.
> 

The notifiers should be reliable and callers should handle the errors
when a notifier vetoes the change. Anything else leaves networking in an
unknown / inconsistent state.
