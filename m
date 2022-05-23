Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14D9A531A08
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 22:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231245AbiEWTk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 15:40:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232222AbiEWTkG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 15:40:06 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F289D134E0A;
        Mon, 23 May 2022 12:32:35 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id f9so31006925ejc.0;
        Mon, 23 May 2022 12:32:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=QcfD7S9L5CIBMVb1EXolT17SGjXBlADQiPbIJB52IyA=;
        b=IwZ9LYtC/kjVD1M6tbz12irq8Bjctuz41W9HahQfPjerRw/YW3YxnYkgh9UWZ4Quen
         2yCj0v2J2VF1uay2M9DISR7FsEEe43CYFE3HuLSXeSIGCbEtOeq6/l3IuzmNXYjF+wu3
         5Dg6gdg82OWGoIL7OpG7167WELitd6HW6crfAFMQa3hnDybjdRzq4v8LGAOEblHD4DY1
         oi+DvdvcEHVTXsD46i6ySsJX7R4CpWE5AFAVhWhM64moe4CYrP4jBIZixN2KrdwW/w7q
         qi3l1J2QYt0w9IFJQzFk5PWq3VBvwb8AQ6RU3s5jj1vZGCgcS7qmmj9uYDCE+yJSuUc7
         CGcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=QcfD7S9L5CIBMVb1EXolT17SGjXBlADQiPbIJB52IyA=;
        b=XLl2y+s0IG4GqiUF2lQf7/ThQYTGqRDA3AzcQ1WPBw2ppPr5nXYLOsW3kWZ6NelNwk
         QpexuGEHVPi4aIcgVZbvPGXsrrvqaszhc3/GT7IoahegZKpWBuk98OKBQnmN3eQS81Ns
         qv93BTUQEMckRle+UC9tBs1/2ARwM/BIo6AMkoga+B5sLN2RCuNVXVBSkYA63vUsA96k
         sGVHgAvHR4jliYnz13iBlsGnPuFqPon4jUU8a87K0lh7aftvChqILi/IqEjFA3F9Oi/U
         DCSnMoTj6syeTdnqgrnQo/uID6tDAHX87b0KXopzhgaJsdxWjU8TWk+5KM1/pUjoePZs
         vrHQ==
X-Gm-Message-State: AOAM531WXhu/5qiNhqMj0dfGhwoCFHrD9/ER13F3atizs5ug0iqiR/aN
        fzmgrNPyeC47uGILoV65ZxBLbDWdwBjH7mbwoBQtAYJ0
X-Google-Smtp-Source: ABdhPJxw9pwIsMqu/OAc7dTwPG7AWqN/ejln4mauKeqThFydT2EbigOI3GDPgwg+CT5OJiUmtTZOWBBeFZJ/4rvgLMA=
X-Received: by 2002:a17:907:a427:b0:6fe:c73e:591c with SMTP id
 sg39-20020a170907a42700b006fec73e591cmr8651452ejc.676.1653334354327; Mon, 23
 May 2022 12:32:34 -0700 (PDT)
MIME-Version: 1.0
References: <20220521075736.1225397-1-zenczykowski@gmail.com>
In-Reply-To: <20220521075736.1225397-1-zenczykowski@gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 23 May 2022 12:32:22 -0700
Message-ID: <CAADnVQJcDvyeQ3y=uVDj-7JfqtxE+nJk+d5oVQrBhhQpicYk6A@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: print a little more info about maps via cat /sys/fs/bpf/pinned_name
To:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Cc:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        BPF Mailing List <bpf@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 21, 2022 at 12:57 AM Maciej =C5=BBenczykowski
<zenczykowski@gmail.com> wrote:
>
> From: Maciej =C5=BBenczykowski <maze@google.com>
>
> While this information can be fetched via bpftool,
> the cli tool itself isn't always available on more limited systems.
>
> From the information printed particularly the 'id' is useful since
> when combined with /proc/pid/fd/X and /proc/pid/fdinfo/X it allows
> tracking down which bpf maps a process has open (which can be
> useful for tracking down fd leaks).
>
> Signed-off-by: Maciej =C5=BBenczykowski <maze@google.com>
> ---
>  kernel/bpf/inode.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/kernel/bpf/inode.c b/kernel/bpf/inode.c
> index 4f841e16779e..784266e258fe 100644
> --- a/kernel/bpf/inode.c
> +++ b/kernel/bpf/inode.c
> @@ -257,6 +257,9 @@ static int map_seq_show(struct seq_file *m, void *v)
>         if (unlikely(v =3D=3D SEQ_START_TOKEN)) {
>                 seq_puts(m, "# WARNING!! The output is for debug purpose =
only\n");
>                 seq_puts(m, "# WARNING!! The output format will change\n"=
);
> +               seq_printf(m, "# type: %d, key_size: %d, value_size: %d, =
max_entries: %d, id: %d\n",
> +                          map->map_type, map->key_size, map->value_size,=
 map->max_entries,
> +                          map->id);

Maybe use cat /sys/fs/bpf/maps.debug instead?
It prints map id.
