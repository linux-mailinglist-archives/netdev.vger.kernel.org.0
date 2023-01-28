Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76FB067F9B4
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 17:57:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231444AbjA1Q5V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 11:57:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229867AbjA1Q5U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 11:57:20 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84929252BF
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 08:57:18 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id x7so4098954edr.0
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 08:57:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=diag.uniroma1.it; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=tt8Ha/RSXw0RfPBUqnD7ihG/77QJ3kclrfnxQeGKaOg=;
        b=vdySnnQpnG7PamHqJRpJHTk2/+pkWDwtlaaTwo/4ftut1SPbh2wsoeOBfyqSe97XJr
         mBy/7KQLHn305eIbrv15wtIC3jt677R6UlSH0zZLLGg/AOXKk5sofUt21qCLjX8Xqvpz
         ZRdX45XYwjwfNRYgk0ChwEm0M4J3VJXcUuOjg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tt8Ha/RSXw0RfPBUqnD7ihG/77QJ3kclrfnxQeGKaOg=;
        b=a8YToQoExTlhb8sMyIlBnukwT7qG0m13aeCj4xVA2BivrBoQmShEWQvjKkr1BOl7Fl
         KQ4SbyJJvVsfpBMB3aXh3FNb6b47BmMqOSAcg2sv6OEdl7bcPqUqbcIZXQ3WTUpYqb6w
         3aUhAmlKNsoBQaunJxq322DfFAZGZobCMcRHdWQnN2x4O+0qdaWRIqX0dWIDx0qDi/BR
         paNp0i2EjzWlGxPS90Dwyx+lVlfG/AyVzEXZYBzBgPUK0yYc/LKB+kBEOHbiP297s9Ot
         9NLS/CCsG9HDH+j14ns4ez9HTYCQL5bn4YalyMNETIqq0jYkXpDKNMErT1EJhSFzTHg5
         B3pA==
X-Gm-Message-State: AO0yUKUDouQWGGLt28PRZEzt9JjHp4i9bT23Y8zhtFNyPXhq5RBNdITq
        LHpzp+iJ15MBZleS9HJsC4uL1+nBhFxFwOeAu3fJYA==
X-Google-Smtp-Source: AK7set8gwJjmXGZ7qEK5w/UZ8ko/Bw99HYHzRiyxR2URnKVNJoJLwhG2Y0TJ+hLyQwxjUH1ZmX3ZHnlhwaLOabgBZQ8=
X-Received: by 2002:a05:6402:552:b0:4a0:8fde:99b4 with SMTP id
 i18-20020a056402055200b004a08fde99b4mr3865536edx.32.1674925037155; Sat, 28
 Jan 2023 08:57:17 -0800 (PST)
MIME-Version: 1.0
References: <20230128-list-entry-null-check-tls-v1-1-525bbfe6f0d0@diag.uniroma1.it>
 <Y9VP6Hw7jH0VelUX@corigine.com>
In-Reply-To: <Y9VP6Hw7jH0VelUX@corigine.com>
From:   Pietro Borrello <borrello@diag.uniroma1.it>
Date:   Sat, 28 Jan 2023 17:57:06 +0100
Message-ID: <CAEih1qX-XG=-OxMcNyWm9NuYG+_=oFHkTPD3s-Q7EPKPAS3+zw@mail.gmail.com>
Subject: Re: [PATCH net-next] net/tls: tls_is_tx_ready() checked list_entry
To:     Simon Horman <simon.horman@corigine.com>
Cc:     Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Vakul Garg <vakul.garg@nxp.com>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>, Jakob Koschel <jkl820.git@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 28 Jan 2023 at 17:40, Simon Horman <simon.horman@corigine.com> wrote:
>
> Hi Pietro,
>
> I agree this is correct.
>
> However, given that the code has been around for a while,
> I feel it's relevant to ask if tx_list can ever be NULL.
> If not, perhaps it's better to remove the error path entirely.

Hi Simon,
Thank you for your fast reply.
The point is exactly that tx_list will never be NULL, as the list head will
always be present.
So the error, as is, will never be detected, resulting in type confusion.
We found this with static analysis, so we have no way to say for sure that
the list can never be empty on edge cases.
As this is a type confusion, the errors are often sneaky and go undetected.

As an example, the following bug we previously reported resulted in a type
confusion on net code that went undetected for more than 20 years.
Link: https://lore.kernel.org/all/9fcd182f1099f86c6661f3717f63712ddd1c676c.1674496737.git.marcelo.leitner@gmail.com/
In that case, we were able to create a PoC to demonstrate the issue where we
leveraged the type confusion to bypass KASLR.

In the end, this is the maintainer's call, but I would keep the check and
correctly issue a list_first_entry_or_null() so that the check will work
as intended as the added overhead is just a pointer comparison which
would likely justify the cost of a more solid code.
Otherwise, I can also submit a patch that entirely removes the check.
Let me know what you prefer.

Best regards,
Pietro
