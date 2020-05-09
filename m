Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88D361CC4BC
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 23:35:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727976AbgEIVfv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 17:35:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726120AbgEIVfv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 17:35:51 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96A2BC061A0C
        for <netdev@vger.kernel.org>; Sat,  9 May 2020 14:35:49 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id s10so5506166iog.7
        for <netdev@vger.kernel.org>; Sat, 09 May 2020 14:35:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dnZOzhYaJ7+BVZJtGx7Uxzrnen0kznvStbg/C26EQkk=;
        b=eI5GpzGdzu5Q67V2A2tUPYCDh3lWpkKYgs+J/7SzR/SSpciksH+wFHCdHgaKF7734A
         Ioqj069+arMzgmHp0i/+2piwGk0JzlmYbBNGkX5o0SvVOn0TgXgc/orohf7APnDByNNj
         QlxP6zAyo9qNbVcwtpOWKPTuNuUPUJovtcmM3Q5W/ugk1GmHWst2vjmqGkCRN+EOc+qM
         MsShuHdN9r7PDdxIL1y7/ITe28puCBC5W87Dx7ted32SsIE5omZo6HfaWR/5WJrqRVSz
         sKW5N9075pU5Whxvv67/LFebBwEispUk3awidNDLvC7EQ/HmD/3YDLaBXZXvV7fLtuyC
         /JEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dnZOzhYaJ7+BVZJtGx7Uxzrnen0kznvStbg/C26EQkk=;
        b=dnnAABs6YdNef2v9eRVceDD2Ep5TXhEhqSoiq/J4Q0n1x6AL+3DcgdYL0wbfYAK2ah
         VCUiCs/9/5WQEJ1mpaZ76Gi8YYbwxm265hLYIBd6BoXsKQ+WIK0dkC6XvIk2iZZaHQS8
         qW+KuNsG35y3psfVRSAtwUc2LviAGzJ4WhCIF2TPDAlGchW+uTmdbTtTt9xOuXnNzE67
         ytyJLlwYnB63Mt1uG1A2UE+1/nbH8WdEqIUNablZVI1rkQQeQnzRy9CtynbAZxoqDYhT
         fgrn4NKyHZUMfC1IlUPUJgBqzSq7+ZcGo0/Jrjga+xyceac5HUj0mQTsEZ9jNbLZ7nsu
         sPzQ==
X-Gm-Message-State: AGi0PuY+f2YuDdfRXKWxeHdYO+4+nw9Tu5dTlfjc8kMDAknClDN7cXVZ
        0bZHWLbljIWi/XqSLkShPOUYNQlWm9k+tquZ+FmOnQ==
X-Google-Smtp-Source: APiQypLu1hpm9Xp8uh07vgM4mtCkkyWr8uJDhsFMkC8Kz2FBXGd4pIzJKOkMqNK/WbQNuijLNgmPvXp6mv1+hyAD2KY=
X-Received: by 2002:a6b:f911:: with SMTP id j17mr8556734iog.139.1589060148585;
 Sat, 09 May 2020 14:35:48 -0700 (PDT)
MIME-Version: 1.0
References: <20200508234223.118254-1-zenczykowski@gmail.com>
 <20200509191536.GA370521@splinter> <a4fefa7c-8e8a-6975-aa06-b71ba1885f7b@gmail.com>
In-Reply-To: <a4fefa7c-8e8a-6975-aa06-b71ba1885f7b@gmail.com>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date:   Sat, 9 May 2020 14:35:36 -0700
Message-ID: <CANP3RGfr0ziZN9Jg175DD4OULhYtB2g2xFncCqeCnQA9vAYpdA@mail.gmail.com>
Subject: Re: [PATCH] net-icmp: make icmp{,v6} (ping) sockets available to all
 by default
To:     David Ahern <dsahern@gmail.com>
Cc:     Ido Schimmel <idosch@idosch.org>,
        "David S . Miller" <davem@davemloft.net>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Do we have some sort of beginner's introduction to Linux VRF somewhere?
What they are? How to use them?

Currently the concept simply doesn't fit into my mental model of networking...

We've actually talked about maybe possibly using VRF's in Android (for
our multi network support)...
but no-one on our team has the faintest idea about how they work...
(and there's rumours that they don't work with ipv6 link local)
