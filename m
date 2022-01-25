Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 460C549BA2D
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 18:23:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231483AbiAYRTc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 12:19:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1587358AbiAYRQ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 12:16:58 -0500
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3D63C06173E
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 09:16:53 -0800 (PST)
Received: by mail-il1-x12f.google.com with SMTP id o10so17469322ilh.0
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 09:16:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=OvtoZY8rjAUMpTNVypj1LdOJ0BidyV+g6T3ehFl6l8M=;
        b=GaOPDxHL8+y7MGp8vV3b1+rfel6r6vyc7eurDWAGm4XFK8mLek+fBFZgcWUeQfy4jE
         7RY3P4EuLNLFF7LhWODCj/Z2uw/mgARIjsagi44FDVRVzmExv1O8aJBmDGdwGL7XJs5V
         gi5/UfbIgk7E2y9coWnhyiJjzSoZIe0RrRvjgj2icVp5hIKcNbrpfX4ncun2XubXoob8
         1mwcHw6kOe3gQ+kAmjE8HLX2yaR2oP1U8qOlpxyASkWU7Nlyx7wXZ+JnYUQWzrUoyxTz
         uimH6C2GEGX0S5xGnW4RtGMLz5y0/81rrxRuEtLEGdWXUxQOeMDEAxdI/Of3+lRkMcMO
         iVBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=OvtoZY8rjAUMpTNVypj1LdOJ0BidyV+g6T3ehFl6l8M=;
        b=F4Avg4JQ8hq8FZv1dOFSGwo7r351aNLXPW03UcIMc0j8bP0ZhdqhxmOqZSliGqc/dO
         TqHD97YHdu3wSaKyAkYu5vzH2Kauy2VX3vzyqKXrKIWJGyfNJwUmBm7QguW0mUT987DX
         Y8RAX0ioaSHPaq8T9oqSdtFg9bJDIc3h/Het5vhwnoPmznUqImH40UQCfxTg7wDBIAPO
         9vIhqqL4tfDI4qiIYMgFUCq1ETB1GUNyWmlZ/I00JbFhWmWmafDq/EmEFflHMSU+Mp5C
         CDU2BxQJ0xpuSctu2e3Aferg3ZwjWCyzA5opUr18QnFwhUK/yx23rHuBQb1AirP3XLf/
         5dYQ==
X-Gm-Message-State: AOAM531b+uVdwWq4Iz7meQ1uSwcZ8PeT+pf9STn/YMiEJ5XfPyOHcWXd
        6kq2XEYlfLww6QEMZAuomq7w0NGauUM=
X-Google-Smtp-Source: ABdhPJxGZH8bcK2lY/fcGcKiBcGtmwvdASxeRs9J9TKiKoz2p2qkIIawtDqYEaR4RJjE2z6WImU5sQ==
X-Received: by 2002:a92:3308:: with SMTP id a8mr12152364ilf.184.1643131013065;
        Tue, 25 Jan 2022 09:16:53 -0800 (PST)
Received: from ?IPV6:2601:282:800:dc80:d07:f7f3:9067:77bf? ([2601:282:800:dc80:d07:f7f3:9067:77bf])
        by smtp.googlemail.com with ESMTPSA id q14sm3235604ilo.63.2022.01.25.09.16.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Jan 2022 09:16:52 -0800 (PST)
Message-ID: <6a53c204-9bc1-7fe9-07bc-6f3b7a006bce@gmail.com>
Date:   Tue, 25 Jan 2022 10:16:51 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.0
Subject: Re: [PATCH net-next] net: Adjust sk_gso_max_size once when set
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>
Cc:     netdev <netdev@vger.kernel.org>
References: <20220125024511.27480-1-dsahern@kernel.org>
 <CANn89i+b0phX3zfX7rwCHLzEYR6Y9JGXxRYa92M8PE9kbtg8Mg@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <CANn89i+b0phX3zfX7rwCHLzEYR6Y9JGXxRYa92M8PE9kbtg8Mg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/25/22 9:46 AM, Eric Dumazet wrote:
> On Mon, Jan 24, 2022 at 6:45 PM David Ahern <dsahern@kernel.org> wrote:
>>
>> sk_gso_max_size is set based on the dst dev. Both users of it
>> adjust the value by the same offset - (MAX_TCP_HEADER + 1). Rather
>> than compute the same adjusted value on each call do the adjustment
>> once when set.
>>
>> Signed-off-by: David Ahern <dsahern@kernel.org>
>> Cc: Eric Dumazet <edumazet@google.com>
> 
> 
> SGTM, thanks.
> 
> Reviewed-by: Eric Dumazet <edumazet@google.com>

The git history does not explain why MAX_TCP_HEADER is used to lower
sk_gso_max_size. Do you recall the history on it?
