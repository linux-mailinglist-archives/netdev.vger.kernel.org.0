Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8CCE3B6991
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 22:14:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236572AbhF1URM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 16:17:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232014AbhF1URL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 16:17:11 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D289C061574;
        Mon, 28 Jun 2021 13:14:44 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id o11so18888068ejd.4;
        Mon, 28 Jun 2021 13:14:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zdPs58wcAuPAnNalGg5J4lyyztWTzk7zaRQZ5k0nKeI=;
        b=UkpM7K61kor99zTc/7KZs9Sr9xJWWNL+cHTSHNbmGYibhcUtWx6/CmZxbQhrBk/F9U
         c+l0W95A1kOGdwb7o9I3ciAWTpYaUVvjuLqgk3dyLe7/v4iyns0qI2sD8MtUQuQyP3p4
         G0FHgxjVzZFvuzsYTaHaUlc5UdquE12/SDv3Fs4gW6oao+8Of8KcQGMPQPsYQdi5yBvY
         m5bpuIdlb2KVhVTYVqZN+yYgAcQqFoGWE5Hpd9yXGHnOqFXWjNoaTGi2fQkHCYzZhCjl
         oeczLfPoJXEl1FtJeRTVKNZJlNBc554h2qQlTNLWXcn6nPz3fPDRwJYR8vYBGqWVQUek
         lErw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zdPs58wcAuPAnNalGg5J4lyyztWTzk7zaRQZ5k0nKeI=;
        b=AxhWzqX+HEgW+WWq83QREURPiz+HOACTeB/k3pktGTAcfdZpVDaQjDH8FuE04xdtpx
         vdjUcPJV9Is429yjD9K1BJekgEXLRwO8OgKjgqO6Y00cUb47MBh3H78rKqYxvEfo+YP9
         WPxJywOA0ev+wQUdi1K4cdahe9u1quJ7DWfiprvS4W6/rEGP9oDHryEKedmKC/f3CmuS
         ybfC1fZPp4u7erscuvZVgdkWat37wXeEppRbqHk3QH7H5SGq6DB+oF+uA5BqHJy07/MB
         vh4w60W9bnPVOjAwCcwT/xHilqCd1mrxSCdocmO1CR0/w0BoBgdiYucTBXc1E/GJACdl
         0TWA==
X-Gm-Message-State: AOAM530zMYouHGchTGBz7VgMnT5CUGuA9r/4ZSYa6+WQCgvjY5VK+UDE
        PVyR2CTcjmSwF3Krpi7vafGkJbYvtJb6MUnyGjY=
X-Google-Smtp-Source: ABdhPJx1mkhEM+RWmaAl8527gWYv1j9Y0Qe0LxpHrFe6mm7dOgUgvq3OZq4HnwYsFMhSf00Le1njz4I2Vmg9F6Zrz94=
X-Received: by 2002:a17:906:dbe1:: with SMTP id yd1mr26542431ejb.114.1624911282417;
 Mon, 28 Jun 2021 13:14:42 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1623674025.git.lorenzo@kernel.org> <1316f3ef2763ff4c02244fb726c61568c972514c.1623674025.git.lorenzo@kernel.org>
In-Reply-To: <1316f3ef2763ff4c02244fb726c61568c972514c.1623674025.git.lorenzo@kernel.org>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Mon, 28 Jun 2021 13:14:31 -0700
Message-ID: <CAKgT0Ue7TsgwbQF+mfeDB-18Q-R29YZWe=y6Kgeg0xxbwds=vw@mail.gmail.com>
Subject: Re: [PATCH v9 bpf-next 02/14] xdp: introduce flags field in xdp_buff/xdp_frame
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf <bpf@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
        lorenzo.bianconi@redhat.com, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, shayagr@amazon.com,
        "Jubran, Samih" <sameehj@amazon.com>,
        John Fastabend <john.fastabend@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Saeed Mahameed <saeed@kernel.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Tirthendu <tirthendu.sarkar@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 14, 2021 at 5:50 AM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>
> Introduce flags field in xdp_frame/xdp_buffer data structure
> to define additional buffer features. At the moment the only
> supported buffer feature is multi-buffer bit (mb). Multi-buffer bit
> is used to specify if this is a linear buffer (mb = 0) or a multi-buffer
> frame (mb = 1). In the latter case the shared_info area at the end of
> the first buffer will be properly initialized to link together
> subsequent buffers.
>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

Instead of passing this between buffers and frames I wonder if this
wouldn't be better to place in something like the xdp_mem_info
structure since this is something that would be specific to how the
device is handling memory anyway. You could probably split the type
field into a 16b type and a 16b flags field. Then add your bit where 0
is linear/legacy and 1 is scatter-gather/multi-buffer.
