Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 966BA3AFBB4
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 06:21:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbhFVEYI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 00:24:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbhFVEYG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 00:24:06 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 876C7C061574
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 21:21:50 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id i10-20020a9d68ca0000b029045d4c970c96so1225377oto.6
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 21:21:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RrZhdtdQs7lrNqJGHnyxu6H+SaTa1O07i8QIw7lMRGY=;
        b=ISmMBxzvYRtv18vb0kaRLuOS/l9DROUb2Sjk+XO6EuFQWq4UXUTLI3H5Gabeqtjzs5
         t0yZjMpRxqFjfeQjd29tQB6piISR5EB9nxhfp1vdSb0SNJo6NSK53ZUi6gK81i11sQ3Z
         XaGEcpGupR0bFv//TjaYHLQV8a6u1eU2TYEa6JPeg29lq5juWJA1BbSnjfjJwwcdf5j+
         6o7wAZQbI5d7IrSBjW3KBg9EBMY7pscJZUWZnCTU72q8bBhd4IVcygp6aa2ZOKlr08eG
         LsvDFZ6BigdFIj0EAjjjoY3IUdO13bXzi5NZ6CkSdZa8gpQ5eOdt+WObR7x73cIZU1Uz
         JNbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RrZhdtdQs7lrNqJGHnyxu6H+SaTa1O07i8QIw7lMRGY=;
        b=BI/IEPlXkZnpojT6uC2AwLcrAMXRiFZP81bhF17ofTnaYbEDoieCSQJifGdqlONjm5
         RLxcnzahXHdRlDEvCr4lvIbVXyD5ief2l9ukSTQN9HH4IJeWNtEL9sujcpWQOSSh2nmZ
         0PaGnbBU+ILjGnxNJt/QcIWdFxLm7QB7muAb4mEJ+CoDFtyQd2m3ZT6S0DTeF6MSiRWj
         V219ig7MAqNf/bqjfGFKDwdsz188usqqOA2YY6nNACc/+v6xzR/jbTpkEUMQBL0d8J7i
         RGatwFU8eNmLtXyN1b/+dxDWLbWm3l0QsMkgS/JfK757/5eUTCx8s0p3pNhsXKscyIls
         aJ+g==
X-Gm-Message-State: AOAM533mn3SheIZzUURYkl1P62CM/2yuzii6VJvcWGb1RrngJQ87KxP6
        vNJDhTT/C4dHDUwuH+0sHY/bbM+asWY=
X-Google-Smtp-Source: ABdhPJz8Y5lspaK+jh8J6yQV9SHPmewtRMTrc9haqsTLc4hNArMt6RwgJJkamzh/e8VTiJ+m29dNhg==
X-Received: by 2002:a05:6830:1315:: with SMTP id p21mr1368446otq.64.1624335709859;
        Mon, 21 Jun 2021 21:21:49 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.38])
        by smtp.googlemail.com with ESMTPSA id c205sm4039663oib.20.2021.06.21.21.21.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Jun 2021 21:21:49 -0700 (PDT)
Subject: Re: [PATCH] net/ipv4: swap flow ports when validating source
To:     Miao Wang <shankerwangmiao@gmail.com>
Cc:     netdev@vger.kernel.org, Roopa Prabhu <roopa@cumulusnetworks.com>
References: <1B652E0A-2749-4B75-BC6D-2DAE2A4555A8@gmail.com>
 <a08932fe-789d-3b38-3d92-e00225a8cf9f@gmail.com>
 <69C9F0FE-055B-4B1E-8B4B-CE9006A798BE@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <c862966c-6a17-ba50-01d1-6c9227f6e29e@gmail.com>
Date:   Mon, 21 Jun 2021 22:21:48 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <69C9F0FE-055B-4B1E-8B4B-CE9006A798BE@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/21/21 8:39 PM, Miao Wang wrote:
> Thanks for your suggestion. I wonder if I also CC this to 
> stable?

nope. Fixes tag will take care of that.
