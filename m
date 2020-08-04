Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED5723B19D
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 02:19:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728523AbgHDATy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 20:19:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728391AbgHDATx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 20:19:53 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E728C061756
        for <netdev@vger.kernel.org>; Mon,  3 Aug 2020 17:19:53 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id a5so25183434ioa.13
        for <netdev@vger.kernel.org>; Mon, 03 Aug 2020 17:19:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1MAfLwcjEl3HCVfdRl5a9bQOUBDcD2FKaaueE7yh9yQ=;
        b=kbjHVxJxuWu9n8yQZtc1W94k/wJXVr8+U33LC97VNMsgq+PxPqKnzOZ09TJrABAX8k
         k83Qr7hcZYcolyJthdRbXaa6irVQTyZgxpgd5AmbvrPWjBTfVBB3Ug/aPRW5UPICE+uy
         vsU9kNGd0kwS0Fn34Mjj4SvuXGKM7vQjPjZiv/OqdJj2uySplXbAMBhgwYL6EuK2yVJz
         6MelYNDbU4BSuuSYOeqmsoO4gmoyRJrP18Fe1A1n+cQotkBpdZFWeC06SEHSTC+UdTJi
         R+uNIiCjwAXF6WfVcYHnqoIcAXGtCwPdm+SJhiAi4QXTj7ByDwf+boWEJ6XfXZeA9ulx
         9s0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1MAfLwcjEl3HCVfdRl5a9bQOUBDcD2FKaaueE7yh9yQ=;
        b=YlVs5t3B7WFvyzv7C9X/AxJG/9iGQ5/I7H2y1YZp/uYuCYvViaJyUJjUjubbBQkcj8
         VV0UuJp1cVaajt8NhdPKuUen6MH/88zbcxe9123oRmaXWcNUggQnMW3TdRkT7yNiSeop
         jeWeCcT2ZvlVrlKHhlxXCjbXxlhz15ps1XJH29DnjKhCXBNpaJVvhn+Bf3Hi8bwRyr+r
         Qzdx72rMgzJ7GKq06vM/MlA0WNC5XEVb2XzeFI7EdumijYCt1pTqIUdAkdqP00Xa0RKT
         cGxP2JVqrbsuyYZl3M95GclQX6R2NuRTr66V5oib3fUODgEputsmqBujYfjbeLHFA0IM
         PkUg==
X-Gm-Message-State: AOAM530fB2Aw6dZ8xu3dIuu3DKfwX1oS/+JJeBrhg00uHbUsjKQGVTGY
        SkRu5XdvFx0RwjWBY0pvnbHadpqLfLfJVGpMh30W8A==
X-Google-Smtp-Source: ABdhPJz6KqTEOfBJlbHG/WuWvSFCA7j2sgJ68+1Nyxmougr/dNn9kGHmdnnIx5pIsCPhR60+nDzWWH8r8ZMiBoTsTaw=
X-Received: by 2002:a5d:8143:: with SMTP id f3mr2446365ioo.157.1596500392304;
 Mon, 03 Aug 2020 17:19:52 -0700 (PDT)
MIME-Version: 1.0
References: <20200803231013.2681560-1-kafai@fb.com> <20200803231019.2681772-1-kafai@fb.com>
In-Reply-To: <20200803231019.2681772-1-kafai@fb.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 3 Aug 2020 17:19:40 -0700
Message-ID: <CANn89iKuF78oM9aCo4rQBu5p6oD7y=vArmpFMHjQGudb=t0g7w@mail.gmail.com>
Subject: Re: [RFC PATCH v4 bpf-next 01/12] tcp: Use a struct to represent a saved_syn
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        kernel-team <kernel-team@fb.com>,
        Lawrence Brakmo <brakmo@fb.com>,
        Neal Cardwell <ncardwell@google.com>,
        netdev <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 3, 2020 at 4:10 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> The TCP_SAVE_SYN has both the network header and tcp header.
> The total length of the saved syn packet is currently stored in
> the first 4 bytes (u32) of an array and the actual packet data is
> stored after that.
>
> A later patch will add a bpf helper that allows to get the tcp header
> alone from the saved syn without the network header.  It will be more
> convenient to have a direct offset to a specific header instead of
> re-parsing it.  This requires to separately store the network hdrlen.
> The total header length (i.e. network + tcp) is still needed for the
> current usage in getsockopt.  Although this total length can be obtained
> by looking into the tcphdr and then get the (th->doff << 2), this patch
> chooses to directly store the tcp hdrlen in the second four bytes of
> this newly created "struct saved_syn".  By using a new struct, it can
> give a readable name to each individual header length.
>
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> ---

Reviewed-by: Eric Dumazet <edumazet@google.com>
