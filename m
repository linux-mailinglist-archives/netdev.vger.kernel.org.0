Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0003F30FD29
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 20:45:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238894AbhBDTnY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 14:43:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237467AbhBDTnV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 14:43:21 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FBE7C0613D6
        for <netdev@vger.kernel.org>; Thu,  4 Feb 2021 11:42:41 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id a9so7562988ejr.2
        for <netdev@vger.kernel.org>; Thu, 04 Feb 2021 11:42:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gIZcbDUIRQ1wWrBKGv6yLNksXY9tk2h31ecf9LELXq0=;
        b=aT3tUIiTtfOrwIujqD2MS0rctSX5Psujrb0J8F7OY9lVT5Hr350uKMV8BOs6OUgBRI
         HFPmgi3S3HcCJ3tK4JZaqXASWW8zflewKRveN0RI+7aGhO44eFnCITgaeDzCoBdFHA8J
         XxWHy+lJSOlUw8V3GJ2Q6MY64f3b5x3+gt8lIyXKWVrrYkxRK1MTtGuce7C47b0zZf7b
         8S6+TPhBu/C7uN+WC8DxAfPaJtAP/+L5PaASfE9P7Yz12LZUIezcqM1nZlHzGhpPE7cV
         EOJIhCyllhcS45lqliTOqsfGnQpiGArsZCltKit6E7Avwjr1foD0LQuo8kdg0Zncic78
         GsBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gIZcbDUIRQ1wWrBKGv6yLNksXY9tk2h31ecf9LELXq0=;
        b=IM88hAMcE6IAONytNZfKxH1Svo02XotumrQSw1qz2eFv66VJxkHSuVMu09Hnm2Krff
         iWxxdiR+UcDfPhHlUxhVkQnRzoRGTEuOZbdGgIram9j0vNcI9MSySYqtt2BIDBskqro8
         8o/RHVB4DvNiO3rTYmdPnxTUTU/LdR7Lo8/ueJkFx0loLuR0nV531P13qHom2dZtNHW6
         F61ohqD2xFGA1VxvN9BmmbQ+EuW1hcbRv69K/JB6LfHFgXc4UL3pwHHD0VNg1WAto0Fn
         GSQbsDLX46xZwADzrkzgPoYgWnzrHLgKdkwjaa2wy1zOTBzbKcDGzQglWP7SmEoQTn6H
         Ck5g==
X-Gm-Message-State: AOAM531CGDA4aP8ioDslfGQqLoE/+zkI40JY8rk7U2/GdZrnJDhJQb9c
        PmYu5HMmvEecZf9X6YnVHGDrManRk9VOXoKefpI=
X-Google-Smtp-Source: ABdhPJwq/nBbZmsUSp3wS0yJ3sZ13Z/AhUoOnjQ4rCIWH12ELkJk1hnStsA0PH+4FbBFNOXk92qOQ8Gx4likzP36kCM=
X-Received: by 2002:a17:906:4dc5:: with SMTP id f5mr666098ejw.11.1612467759922;
 Thu, 04 Feb 2021 11:42:39 -0800 (PST)
MIME-Version: 1.0
References: <cover.1612393368.git.andreas.a.roeseler@gmail.com> <2f3de06143c4191c53be4b96d98759afb5f09a5e.1612393368.git.andreas.a.roeseler@gmail.com>
In-Reply-To: <2f3de06143c4191c53be4b96d98759afb5f09a5e.1612393368.git.andreas.a.roeseler@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 4 Feb 2021 14:42:03 -0500
Message-ID: <CAF=yD-+1TP7NxNVsN7OS9339FBOwGRifH=+L6KFCR=MCcwR5=w@mail.gmail.com>
Subject: Re: [PATCH V2 net-next 1/5] icmp: add support for RFC 8335 PROBE
To:     Andreas Roeseler <andreas.a.roeseler@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 3, 2021 at 6:25 PM Andreas Roeseler
<andreas.a.roeseler@gmail.com> wrote:
>
> Add definitions for PROBE ICMP types and codes.
>
> Add AFI definitions for IP and IPV6 as specified by IANA
>
> Add a struct to represent the additional header when probing by IP
> address (ctype == 3) for use in parsing incoming PROBE messages.
>
> Signed-off-by: Andreas Roeseler <andreas.a.roeseler@gmail.com>
> ---
> Changes since v1:
>  - Add AFI_IP and AFI_IP6 definitions
> ---
>  include/uapi/linux/icmp.h | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
>
> diff --git a/include/uapi/linux/icmp.h b/include/uapi/linux/icmp.h
> index fb169a50895e..e70bfcc06247 100644
> --- a/include/uapi/linux/icmp.h
> +++ b/include/uapi/linux/icmp.h
> @@ -66,6 +66,23 @@
>  #define ICMP_EXC_TTL           0       /* TTL count exceeded           */
>  #define ICMP_EXC_FRAGTIME      1       /* Fragment Reass time exceeded */
>
> +/* Codes for EXT_ECHO (PROBE) */
> +#define ICMP_EXT_ECHO          42
> +#define ICMP_EXT_ECHOREPLY     43
> +#define ICMP_EXT_MAL_QUERY     1       /* Malformed Query */
> +#define ICMP_EXT_NO_IF         2       /* No such Interface */
> +#define ICMP_EXT_NO_TABLE_ENT  3       /* No such Table Entry */
> +#define ICMP_EXT_MULT_IFS      4       /* Multiple Interfaces Satisfy Query */
> +
> +/* constants for EXT_ECHO (PROBE) */
> +#define EXT_ECHOREPLY_ACTIVE   (1 << 2)/* position of active flag in reply */
> +#define EXT_ECHOREPLY_IPV4     (1 << 1)/* position of ipv4 flag in reply */
> +#define EXT_ECHOREPLY_IPV6     1       /* position of ipv6 flag in reply */
> +#define CTYPE_NAME             1
> +#define CTYPE_INDEX            2
> +#define CTYPE_ADDR             3

Please use a prefix. These definitions are too generic and may clash
with others. Same for the two below. Does all this need to be defined
UAPI?

> +#define AFI_IP                 1       /* Address Family Identifier for IPV4 */
> +#define AFI_IP6                        2       /* Address Family Identifier for IPV6 */
>
>  struct icmphdr {
>    __u8         type;
> @@ -118,4 +135,11 @@ struct icmp_extobj_hdr {
>         __u8            class_type;
>  };
>
> +/* RFC 8335: 2.1 Header for C-type 3 payload */
> +struct icmp_ext_ctype3_hdr {
> +       __u16           afi;
> +       __u8            addrlen;
> +       __u8            reserved;
> +};
> +
>  #endif /* _UAPI_LINUX_ICMP_H */
> --
> 2.25.1
>
