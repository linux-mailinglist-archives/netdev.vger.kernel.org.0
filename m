Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BF8232100C
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 05:43:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230122AbhBVEkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Feb 2021 23:40:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230044AbhBVEkN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Feb 2021 23:40:13 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 147C4C06178A
        for <netdev@vger.kernel.org>; Sun, 21 Feb 2021 20:39:33 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id s11so20162770edd.5
        for <netdev@vger.kernel.org>; Sun, 21 Feb 2021 20:39:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PEfLr9v7mkkyKr1v58VHkVAf639sWFPd887af6ClSZ4=;
        b=QxWFrk2c987a9PEYuexAYjEkXga+lTSErWT4axOlyVKgs/iHr+Jv/3r1LtvvAMDsC/
         XD9qUCnlJ5cjvZZ90S9D5/AtrC/bG5CzB4KC2Swo3BK3XTam7rFnvtYWK1Z+6ImXjraV
         gFaqhe3VWkN8k/1OXYf7+1GD3wdH3lTUF6fC43KFzkYznBBEGAz5aZWv/DDd6bp+yI8u
         yJQ/opFWELGEhztQE/+QrJLAYNM3hsl2hXCcqBR9NOPzPr7jerbTmWeYIiIR2r7yYEex
         dEid0cpaMjFRRMeUzfoexBgL4elS+4uKwatjf7Nm8Ll4x7aI/zjtZBkOkcr5/SjEToBc
         YTIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PEfLr9v7mkkyKr1v58VHkVAf639sWFPd887af6ClSZ4=;
        b=kjaFf4hugj55BGwrJNdMdxxwQEzhLnPXt6mXHioZLmBRscz4kEa/I7QY6eVJWgXstZ
         5vzuJwdUGQxewPqqQUxFH9zuzKOu2fPeddA6dxL3oF7CDl6GUNmQzsoVYmC/kwg+6RvK
         TR92U6URn8FY3xD/0f03fdnVt/wcYTkYv18eD3PnxrwkxYXVk8QldBOqDWLypazJjk35
         7DndU0pZh0s9NOhTZcnfR5VjtgwgJ7Dw7FNJG4VO8sNNGQ3PZM16psKVmmEDqaI5ZOTB
         nAgeceT+U6TFniTjF90q3lzqv2Dt6O0hf/ovF+SKBYtImUIjclkmoDfT16FM2uQ2r9aF
         /Ppg==
X-Gm-Message-State: AOAM533pz56xTOwpXx8SjxMGENc7dWIgccbToPOkGJxFvY/jtbmqWjwq
        OLmsgFdrSILYj6wmgY3XFiqIR1Jzfvs=
X-Google-Smtp-Source: ABdhPJwhUfDETZ/AE28dsBJS8RCpyzXOsChWs2BHJ4Xbp4tfg0BSr+dFjaPscfwydrt4dbtO/7LkSw==
X-Received: by 2002:aa7:ca09:: with SMTP id y9mr4364597eds.342.1613968771680;
        Sun, 21 Feb 2021 20:39:31 -0800 (PST)
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com. [209.85.128.51])
        by smtp.gmail.com with ESMTPSA id cz28sm2707056edb.22.2021.02.21.20.39.30
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Feb 2021 20:39:31 -0800 (PST)
Received: by mail-wm1-f51.google.com with SMTP id l13so3585053wmg.5
        for <netdev@vger.kernel.org>; Sun, 21 Feb 2021 20:39:30 -0800 (PST)
X-Received: by 2002:a1c:32c4:: with SMTP id y187mr18460033wmy.120.1613968770618;
 Sun, 21 Feb 2021 20:39:30 -0800 (PST)
MIME-Version: 1.0
References: <cover.1613583620.git.andreas.a.roeseler@gmail.com> <a0c1d3cd75accdf9cad0b32efa0fc1dae2d3d8ed.1613583620.git.andreas.a.roeseler@gmail.com>
In-Reply-To: <a0c1d3cd75accdf9cad0b32efa0fc1dae2d3d8ed.1613583620.git.andreas.a.roeseler@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sun, 21 Feb 2021 23:38:52 -0500
X-Gmail-Original-Message-ID: <CA+FuTScB1BAAqDCSu9ijKBcAOhvV4eDo6tO7V-VMdYMdiQ1A-g@mail.gmail.com>
Message-ID: <CA+FuTScB1BAAqDCSu9ijKBcAOhvV4eDo6tO7V-VMdYMdiQ1A-g@mail.gmail.com>
Subject: Re: [PATCH V3 net-next 1/5] icmp: add support for RFC 8335 PROBE
To:     Andreas Roeseler <andreas.a.roeseler@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        dsahern@kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 17, 2021 at 1:10 PM Andreas Roeseler
<andreas.a.roeseler@gmail.com> wrote:
>
> Add definitions for PROBE ICMP types and codes.
>
> Add AFI definitions for IP and IPV6 as specified by IANA
>
> Add a struct to represent the additional header when probing by IP
> address (ctype == 3) for use in parsing incoming PROBE messages.
>
> Add a struct to represent the entire Interface Identification Object
> (IIO) section of an incoming PROBE packet
>
> Signed-off-by: Andreas Roeseler <andreas.a.roeseler@gmail.com>
> ---
> Changes since v1:
>  - Add AFI_IP and AFI_IP6 definitions
>
> Changes since v2:
> Suggested by Willem de Brujin <willemdebrujin.kernel@gmail.com>
>  - Add prefix for PROBE specific defined variables
>  - Create struct icmp_ext_echo_iio for parsing incoming packet
> ---
>  include/uapi/linux/icmp.h | 40 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 40 insertions(+)
>
> diff --git a/include/uapi/linux/icmp.h b/include/uapi/linux/icmp.h
> index fb169a50895e..166ca77561de 100644
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
> +#define EXT_ECHO_CTYPE_NAME    1
> +#define EXT_ECHO_CTYPE_INDEX   2
> +#define EXT_ECHO_CTYPE_ADDR    3
> +#define EXT_ECHO_AFI_IP                1       /* Address Family Identifier for IPV4 */
> +#define EXT_ECHO_AFI_IP6       2       /* Address Family Identifier for IPV6 */
>
>  struct icmphdr {
>    __u8         type;
> @@ -118,4 +135,27 @@ struct icmp_extobj_hdr {
>         __u8            class_type;
>  };
>
> +/* RFC 8335: 2.1 Header for C-type 3 payload */
> +struct icmp_ext_echo_ctype3_hdr {
> +       __u16           afi;
> +       __u8            addrlen;
> +       __u8            reserved;
> +};
> +
> +/* RFC 8335: Interface Identification Object */
> +struct icmp_ext_echo_iio {
> +       struct icmp_extobj_hdr  extobj_hdr;
> +       union {
> +               __u32   ifIndex;

please no camelcase.

> +               char name;

why single char?

> +               struct {
> +                       struct icmp_ext_echo_ctype3_hdr ctype3_hdr;
> +                       union {
> +                               __be32          ipv4_addr;

perhaps struct in_addr

> +                               struct in6_addr ipv6_addr;
> +                       } ip_addr;
> +               } addr;
> +       } ident;
> +};
> +
>  #endif /* _UAPI_LINUX_ICMP_H */
> --
> 2.25.1
>
