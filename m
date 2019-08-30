Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C91B5A3A53
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 17:27:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727904AbfH3P1o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 11:27:44 -0400
Received: from mail-yw1-f67.google.com ([209.85.161.67]:42603 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727603AbfH3P1n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 11:27:43 -0400
Received: by mail-yw1-f67.google.com with SMTP id i207so2495653ywc.9
        for <netdev@vger.kernel.org>; Fri, 30 Aug 2019 08:27:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=py3wzmvA2fXnWA6NYMuSRRdOzMHAf5Vz3HJDxCC3S14=;
        b=IoG87O3EihlCke4VVYvjaU5KoL+++xfvJLdXO/onsxkv7R4+MaMuWZKKpQudMXzOyE
         Nic/XojmbEL1PU26wL7xizmL7P1PlOV8uxch1W5BXVaqS/ZKyg4UAqneMlkCIG37W1H+
         KmMvExI/ZeCYlfq+vWNc/CMYoAwmiXII50DiyYaZ+MnQ75dRQWsaK86pCedHOJQKOFNU
         bWeNDlaKEnRwlBYDqvE5VpizfeiQHhC2VkYhrzOoFGMZk0d93DyVD1gPGntRe6G4k4z5
         Vk2lxVM1rDppPaTtFhlFLadfFWfarOJWjX2amT5xjSOTh/FW604NZeBlee+eMjKQww0M
         7z+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=py3wzmvA2fXnWA6NYMuSRRdOzMHAf5Vz3HJDxCC3S14=;
        b=A2nIadT5KMqgQtmWYI6CnSYT+d5A6AbC3flKYhXZo/K+oejNHLoLp222JeU3w6CqhN
         JvPvghSNWM8uXFjo4XhmZCjG8Sk8hurbB+wJ/LF1ym0KRhooCiQN01d8/5rPJRoEQuJ2
         kAGHlVya69Lql69P9zf/7bho1j5Sdo5eVCkLuwk0zYNXgVa9eOdoZUY3dCC+FLwIX7SO
         NK6Dmc6v4xVfcDNpD6B2DL2gP9QPwpZifejEfm1+MBBJFpJ79MljLF01Hdb4oh+qejHC
         a3NfucIcsJyG7b92eGTCKBL9OJ49i9I/Qs/DvpWZ1xcx0gVbF50Q51ONzbNRlHqJlhgF
         iN4A==
X-Gm-Message-State: APjAAAUYgOiAkCdhhnh7t/Ku2D6gKW6xIqDU+qRpZrANnoCUUyb6WeeP
        U6P7pQr0p5Cn6UWCRTfNUyn4RMv9B0yYvzvlmOLCNi6AUQ==
X-Google-Smtp-Source: APXvYqxv1//HUhhNOJ6PSt8Am6E7It3GSddQG1XgWyD9MwN5GMJiw2DgK/Ry8+NdeqdNI1kMdwAon2YnVlN2OuqjTv0=
X-Received: by 2002:a0d:d596:: with SMTP id x144mr11073492ywd.69.1567178862817;
 Fri, 30 Aug 2019 08:27:42 -0700 (PDT)
MIME-Version: 1.0
References: <20190828204243.16666-1-danieltimlee@gmail.com>
 <20190828204243.16666-2-danieltimlee@gmail.com> <20190830152758.41b38c24@carbon>
In-Reply-To: <20190830152758.41b38c24@carbon>
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
Date:   Sat, 31 Aug 2019 00:27:25 +0900
Message-ID: <CAEKGpzh1ZyEZsKpjtQU6O3rH_1RP3cXU6A6hdMTHoDMMg1m+Ow@mail.gmail.com>
Subject: Re: [PATCH 2/3] samples: pktgen: add helper functions for IP(v4/v6)
 CIDR parsing
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 30, 2019 at 10:28 PM Jesper Dangaard Brouer
<brouer@redhat.com> wrote:
>
> On Thu, 29 Aug 2019 05:42:42 +0900
> "Daniel T. Lee" <danieltimlee@gmail.com> wrote:
>
> > This commit adds CIDR parsing and IP validate helper function to parse
> > single IP or range of IP with CIDR. (e.g. 198.18.0.0/15)
> >
> > Helpers will be used in prior to set target address in samples/pktgen.
> >
> > Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> > ---
> >  samples/pktgen/functions.sh | 134 ++++++++++++++++++++++++++++++++++++
> >  1 file changed, 134 insertions(+)
> >
> > diff --git a/samples/pktgen/functions.sh b/samples/pktgen/functions.sh
> > index 4af4046d71be..eb1c52e25018 100644
> > --- a/samples/pktgen/functions.sh
> > +++ b/samples/pktgen/functions.sh
> > @@ -163,6 +163,140 @@ function get_node_cpus()
> >       echo $node_cpu_list
> >  }
> >
> > +# Extend shrunken IPv6 address.
> > +# fe80::42:bcff:fe84:e10a => fe80:0:0:0:42:bcff:fe84:e10a
> > +function extend_addr6()
> > +{
> > +    local addr=$1
> > +    local sep=:
> > +    local sep2=::
> > +    local sep_cnt=$(tr -cd $sep <<< $1 | wc -c)
> > +    local shrink
> > +
> > +    # separator count : should be between 2, 7.
> > +    if [[ $sep_cnt -lt 2 || $sep_cnt -gt 7 ]]; then
> > +        err 5 "Invalid IP6 address sep: $1"
> > +    fi
> > +
> > +    # if shrink '::' occurs multiple, it's malformed.
> > +    shrink=( $(egrep -o "$sep{2,}" <<< $addr) )
> > +    if [[ ${#shrink[@]} -ne 0 ]]; then
> > +        if [[ ${#shrink[@]} -gt 1 || ( ${shrink[0]} != $sep2 ) ]]; then
> > +            err 5 "Invalid IP$IP6 address shr: $1"
> > +        fi
> > +    fi
> > +
> > +    # add 0 at begin & end, and extend addr by adding :0
> > +    [[ ${addr:0:1} == $sep ]] && addr=0${addr}
> > +    [[ ${addr: -1} == $sep ]] && addr=${addr}0
> > +    echo "${addr/$sep2/$(printf ':0%.s' $(seq $[8-sep_cnt])):}"
> > +}
> > +
> > +
> > +# Given a single IP(v4/v6) address, whether it is valid.
> > +function validate_addr()
> > +{
> > +    # check function is called with (funcname)6
> > +    [[ ${FUNCNAME[1]: -1} == 6 ]] && local IP6=6
> > +    local len=$[ IP6 ? 8 : 4 ]
> > +    local max=$[ 2**(len*2)-1 ]
> > +    local addr
> > +    local sep
> > +
> > +    # set separator for each IP(v4/v6)
> > +    [[ $IP6 ]] && sep=: || sep=.
> > +    IFS=$sep read -a addr <<< $1
> > +
> > +    # array length
> > +    if [[ ${#addr[@]} != $len ]]; then
> > +        err 5 "Invalid IP$IP6 address: $1"
> > +    fi
> > +
> > +    # check each digit between 0, $max
> > +    for digit in "${addr[@]}"; do
> > +        [[ $IP6 ]] && digit=$[ 16#$digit ]
> > +        if [[ $digit -lt 0 || $digit -gt $max ]]; then
> > +            err 5 "Invalid IP$IP6 address: $1"
> > +        fi
> > +    done
> > +
> > +    return 0
> > +}
> > +
> > +function validate_addr6() { validate_addr $@ ; }
> > +
> > +# Given a single IP(v4/v6) or CIDR, return minimum and maximum IP addr.
> > +function parse_addr()
>
> I must say that I'm impressed by your bash-shell skills, BUT below
> function does look too complicated for doing this... I were expecting
> that you would use the regular & (AND) operation to do the prefix
> masking.
>
>

Thank you very much for your compliment!

I'll switch to a more intuitive code as soon as possible.
(It might take some time to send next version of patch,
but i'll try to send it asap.)

And also, thank you for taking your time for the review.

> > +{
> > +    # check function is called with (funcname)6
> > +    [[ ${FUNCNAME[1]: -1} == 6 ]] && local IP6=6
> > +    local bitlen=$[ IP6 ? 128 : 32 ]
> > +
> > +    local addr=$1
> > +    local net
> > +    local prefix
> > +    local min_ip
> > +    local max_ip
> > +
> > +    IFS='/' read net prefix <<< $addr
> > +    [[ $IP6 ]] && net=$(extend_addr6 $net)
> > +    validate_addr$IP6 $net
> > +
> > +    if [[ $prefix -gt $bitlen ]]; then
> > +        err 5 "Invalid prefix: $prefix"
> > +    elif [[ -z $prefix ]]; then
> > +        min_ip=$net
> > +        max_ip=$net
> > +    else
> > +        # defining array for converting Decimal 2 Binary
> > +        # 00000000 00000001 00000010 00000011 00000100 ...
> > +        local d2b='{0..1}{0..1}{0..1}{0..1}{0..1}{0..1}{0..1}{0..1}'
> > +        [[ $IP6 ]] && d2b+=$d2b
> > +        eval local D2B=($d2b)
> > +
> > +        local shift=$[ bitlen-prefix ]
> > +        local ip_bit
> > +        local ip
> > +        local sep
> > +
> > +        # set separator for each IP(v4/v6)
> > +        [[ $IP6 ]] && sep=: || sep=.
> > +        IFS=$sep read -ra ip <<< $net
> > +
> > +        # build full size bit
> > +        for digit in "${ip[@]}"; do
> > +            [[ $IP6 ]] && digit=$[ 16#$digit ]
> > +            ip_bit+=${D2B[$digit]}
> > +        done
> > +
> > +        # fill 0 or 1 by $shift
> > +        base_bit=${ip_bit::$prefix}
> > +        min_bit="$base_bit$(printf '0%.s' $(seq $shift))"
> > +        max_bit="$base_bit$(printf '1%.s' $(seq $shift))"
> > +
> > +        bit2addr() {
> > +            local step=$[ IP6 ? 16 : 8 ]
> > +            local max=$[ bitlen-step ]
> > +            local result
> > +            local fmt
> > +            [[ $IP6 ]] && fmt='%X' || fmt='%d'
> > +
> > +            for i in $(seq 0 $step $max); do
> > +                result+=$(printf $fmt $[ 2#${1:$i:$step} ])
> > +                [[ $i != $max ]] && result+=$sep
> > +            done
> > +            echo $result
> > +        }
> > +
> > +        min_ip=$(bit2addr $min_bit)
> > +        max_ip=$(bit2addr $max_bit)
> > +    fi
> > +
> > +    echo $min_ip $max_ip
> > +}
> > +
> > +function parse_addr6() { parse_addr $@ ; }
> > +
> >  # Given a single or range of port(s), return minimum and maximum port number.
> >  function parse_ports()
> >  {
>
>
>
> --
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
