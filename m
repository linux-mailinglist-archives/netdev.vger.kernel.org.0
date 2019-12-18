Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F151124C59
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 17:02:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727330AbfLRQC4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 11:02:56 -0500
Received: from mail-yb1-f194.google.com ([209.85.219.194]:34155 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727215AbfLRQC4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 11:02:56 -0500
Received: by mail-yb1-f194.google.com with SMTP id k17so948016ybp.1
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 08:02:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6D6TdVRo1MM64dzmAEULWMvfn0pTodE3YM74nb1fSmk=;
        b=DDWOXa0bPswFIhT7RxlTWWjhXDIfcwyASXuH3O8omu3NsgynvXx32/fvbKtLHA2XwZ
         OV/H3eqhA882gd+14ksz5h0Qh4S3LDg7mvavol1LYGRWtiBM06HHbDgAv8zyDf3REpo3
         ZUbQfRbooqW34hDkDKaNauWlrHkH2IBfZT4fVphOhBaKXe/vQKf7bUVvWh2g38dygZ2F
         C9WyBtNl9YfVucH9opYC0a6zTp4h3wh+HHgyRzfbbpWX6aPQhfw84Zjay+M35OqLmhm4
         jwAoY+9Juna4My6N7p8nUbt4SELWG91LVax97r6BPw1NP+oVYVa8YkaP3bGO7nvv+Rr8
         PbNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6D6TdVRo1MM64dzmAEULWMvfn0pTodE3YM74nb1fSmk=;
        b=m8RtDaYDTAn5HhMq7x9VPI6NDiYmJMyAbibWbpJhvXN+dNvkD4kNA+pbs0YDg2VoIN
         6MMtw9hr0/4De/x5ny2u12Lr5/eiiOF+MtgAH72b2HH7T1hDNsmRKtW1dA5l+g6cetjb
         A9Wh0ZaQryY98NiVQTyVQljA582Y+vzbJNdV26t4cR5/s8UO43tBRDlxRfJuzgHmZx/8
         j5Dj/I90xdJn2Z6lcq8QXk6iaHOc0k1nUrX7zKKr3AyzIMUogXGlnkKc+bHRhcitDqb2
         IC5pPUwamTp62d4CclnSOf0pN0KpKSUCS1R8tEWgI2bWzBHpRLB40BoyXe3EuNAcdeIz
         nHiQ==
X-Gm-Message-State: APjAAAVLiBdXf2i1bwrKIdkzR+wqhW0Va9O7YVClmQWcOnebI4vPMZ1E
        6Epo6o/H9gkSa2yCF86TlV6mudOB
X-Google-Smtp-Source: APXvYqynBBteVek4s2al4hJ+lhS6Y6D1oeunv0bi3NdLxjdh3BD41Yw5ZlFASjvbAalNRkkDCAt0Ew==
X-Received: by 2002:a25:c008:: with SMTP id c8mr2358928ybf.299.1576684974432;
        Wed, 18 Dec 2019 08:02:54 -0800 (PST)
Received: from mail-yw1-f54.google.com (mail-yw1-f54.google.com. [209.85.161.54])
        by smtp.gmail.com with ESMTPSA id p206sm1092096ywg.94.2019.12.18.08.02.53
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Dec 2019 08:02:54 -0800 (PST)
Received: by mail-yw1-f54.google.com with SMTP id l22so947411ywc.8
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 08:02:53 -0800 (PST)
X-Received: by 2002:a81:f89:: with SMTP id 131mr2650253ywp.269.1576684972920;
 Wed, 18 Dec 2019 08:02:52 -0800 (PST)
MIME-Version: 1.0
References: <20191218133458.14533-1-steffen.klassert@secunet.com> <20191218133458.14533-3-steffen.klassert@secunet.com>
In-Reply-To: <20191218133458.14533-3-steffen.klassert@secunet.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 18 Dec 2019 11:02:16 -0500
X-Gmail-Original-Message-ID: <CA+FuTSdoiz0HS393GC8gg8tqeEHzQgNDy08vEgRYXpRmKGK_pg@mail.gmail.com>
Message-ID: <CA+FuTSdoiz0HS393GC8gg8tqeEHzQgNDy08vEgRYXpRmKGK_pg@mail.gmail.com>
Subject: Re: [PATCH net-next 2/4] net: Add a netdev software feature set that
 defaults to off.
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 18, 2019 at 8:35 AM Steffen Klassert
<steffen.klassert@secunet.com> wrote:
>
> The previous patch added the NETIF_F_GRO_FRAGLIST feature.
> This is a software feature that should default to off.
> Current software features default to on, so add a new
> feature set that defaults to off.
>
> Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>

Reviewed-by: Willem de Bruijn <willemb@google.com>
