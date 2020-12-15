Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72F2A2DB635
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 23:01:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727074AbgLOWA5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 17:00:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727704AbgLOWAn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 17:00:43 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E691C0613D3
        for <netdev@vger.kernel.org>; Tue, 15 Dec 2020 14:00:03 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id f9so15294481pfc.11
        for <netdev@vger.kernel.org>; Tue, 15 Dec 2020 14:00:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wN8IqP4SHd0Q6zwH3bW3XrKBkZ5AH1d0P0X8RoHifTw=;
        b=yO3qRGcjUHs8KiCQSnCHo9eVRa91fzl2+vW6kkJOJXjS5pjjZ5xSfbMVNkTYiWBDEB
         2yW8Yg4nmP8Axji1s7oH/WjxDdB2w/ZUSJVfH99t+Rd16FoZ8Wt0oZu08tBLB86y8yUc
         mbG5A2Lc6HHKmFLGIziBOgI8EB9sm/++3kMBqMottjOIVfOVUJyCL/2qh3Tvfu+AiZKq
         gxK2Z22U5oXnKxoBrbcMELpP63WCqdMVTLORZyOMmL33TrZbGfbQJWX+TWIXUElc+Mv5
         pATlGKl4CzuMDYuPzSyHzh6qNASVvrUf47ombgfikySDm8qGLz19+Lga3e+ZZzS14r4q
         E5IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wN8IqP4SHd0Q6zwH3bW3XrKBkZ5AH1d0P0X8RoHifTw=;
        b=j9tMzXJkLp/+v9onu0StE707CorThOjHy9/GL10CTkuteF/I0pFQ9oUYqKFF1WFa3g
         OKLijfJEY1dYmnfuKEk+URDGgfNr/4JIZ5GjVKO23NOko35pBdUEGvGrz9o0ZX+gnE+V
         zl7fdcABbh+6QDnob2zOTO2ITz45fz65/22pkl+Wb9g6nMT4N+p2NaPFolw10VwllZLr
         orjvt8qtIAhv5auQ7J/i7maNWaqGZiztEjktgdqboBwwEQjsJQkRyRYQKeSar1yQFjmw
         X7NIzQg6rJ7RAmwf4CPsBk+THuqIGHgJxzEFxR2XbreYmMUATl+Aj/IQA+riV7oRNtWr
         quuw==
X-Gm-Message-State: AOAM531yXp9aKmF5DEazEgsDU72TvpjO2zqK5KGzw/kniwZ8TgDcc6QT
        /0UE7wqQE/rL5cCfia4yvt2jJwa3TpmBAH/s
X-Google-Smtp-Source: ABdhPJzPM/MPitCH9+zT8nKW/PgR01GeeXOOHPNugeU9lhRUj0QzveKUPEb+ROzHgtJY6yY2s74Yvw==
X-Received: by 2002:a62:27c3:0:b029:196:63f6:cfac with SMTP id n186-20020a6227c30000b029019663f6cfacmr29897477pfn.75.1608069603237;
        Tue, 15 Dec 2020 14:00:03 -0800 (PST)
Received: from hermes.local (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id p21sm85461pfn.15.2020.12.15.14.00.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Dec 2020 14:00:02 -0800 (PST)
Date:   Tue, 15 Dec 2020 13:59:58 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Andrea Claudi <aclaudi@redhat.com>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com
Subject: Re: [PATCH iproute2] ss: mptcp: fix add_addr_accepted stat print
Message-ID: <20201215135958.7933ee4c@hermes.local>
In-Reply-To: <a4925e2d0fa0e07a14bbef3744594d299e619249.1605708791.git.aclaudi@redhat.com>
References: <a4925e2d0fa0e07a14bbef3744594d299e619249.1605708791.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Nov 2020 15:24:18 +0100
Andrea Claudi <aclaudi@redhat.com> wrote:

> add_addr_accepted value is not printed if add_addr_signal value is 0.
> Fix this properly looking for add_addr_accepted value, instead.
> 
> Fixes: 9c3be2c0eee01 ("ss: mptcp: add msk diag interface support")
> Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
> ---

Applied, this seems to have gotten lost somehow from patchwork.
