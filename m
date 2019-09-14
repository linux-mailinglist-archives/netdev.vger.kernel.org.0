Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFCDCB2BBE
	for <lists+netdev@lfdr.de>; Sat, 14 Sep 2019 17:05:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726190AbfINPCy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Sep 2019 11:02:54 -0400
Received: from mail-yw1-f48.google.com ([209.85.161.48]:44833 "EHLO
        mail-yw1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725860AbfINPCy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Sep 2019 11:02:54 -0400
Received: by mail-yw1-f48.google.com with SMTP id u187so11434084ywa.11
        for <netdev@vger.kernel.org>; Sat, 14 Sep 2019 08:02:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bVO3Mz3BgKZ1oTRoqSKLcYq8seLcqRma6r0qTpeF0U4=;
        b=l6KLMERm1tBfpI5FMsRnCEwEf0yc3n77Yd9pIRgkjDhqbJ7mM0nJuzvPC3vASOww14
         CNNjHng3nEaF+y4UKYtBqr8nRS2RsjN/+da081aSRPFIM2lCzVYj4/zg8WJTxaZEUjlt
         gsVyrYbFfDS4J86+zBtlfg/B2kDsPMOGuhwpby/3OG/IG6zCccQjeYRex9wddp+gioqQ
         fD4DLxhmtpzd1CiuIxUG5TGmSF7Ukdyo2AcOnZNiSZJKk1EA8x6jwLYF9DQTk6yXvNYC
         2l1XgZhGgpzWLRQLWRDNkuYEoTJwLxPKBo/YfxxzaX/r7tt7nCJ+LMhTfuK5qKDPkg0m
         kYrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bVO3Mz3BgKZ1oTRoqSKLcYq8seLcqRma6r0qTpeF0U4=;
        b=eq40wC22idl43LMQUC1/xN2ldLVhN5ZTG/Xeah7mWX1RAa/GX9SXGKo9TtHWMNThzD
         BKSFJm2dqg2p7YuFTXjSjyvkKDZGs+dqeE5ySFF20DdSlmU6YrtFkdbWPNioVOHFR0JB
         CdDDk9iZbsTyuXoS+Gy8HaE4j4dD847Hn+zGlQajo/zc+4kPlwjClIYR7ohYpEYJlFBH
         qlwiq/7LppqQlUzEoc+DQYvUFwC2JGUykfmhTbN096aD2EhkdrGPz1DLfAAgbzRwIogy
         dufdZChs0hcBqK0b2VbQ4Srb7V8xQgshR2ItgS0ZgUf0AT53nBOJytieYdEP+xTErmSO
         e6Eg==
X-Gm-Message-State: APjAAAXQHGMwE89tT0Bm3uz1Z9v1+U7hU9zzBq5wGbfByHlwFqMONiIE
        3B7o1ZMZvCkU+ekgFVVjFTdqX7GyhlENxk3hkA==
X-Google-Smtp-Source: APXvYqy8jnBm6RHkwD/7zutwcjNr8pKuyJbi4QKz8Y5Le1lt5HiIkR/7Mj/hEr+2ysVs9DdU27+hkLKBurspnoX7OQI=
X-Received: by 2002:a81:3b09:: with SMTP id i9mr37181458ywa.166.1568473373528;
 Sat, 14 Sep 2019 08:02:53 -0700 (PDT)
MIME-Version: 1.0
References: <20190911184807.21770-1-danieltimlee@gmail.com>
 <20190911184807.21770-2-danieltimlee@gmail.com> <20190913144305.4bf38c04@carbon>
In-Reply-To: <20190913144305.4bf38c04@carbon>
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
Date:   Sun, 15 Sep 2019 00:02:37 +0900
Message-ID: <CAEKGpzjgp2+XLd340MRPJ9FSHPusb13zjZafTvRrSuRy3kOgjw@mail.gmail.com>
Subject: Re: [v2 2/3] samples: pktgen: add helper functions for IP(v4/v6) CIDR parsing
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 13, 2019 at 9:43 PM Jesper Dangaard Brouer
<brouer@redhat.com> wrote:
>
> On Thu, 12 Sep 2019 03:48:06 +0900
> "Daniel T. Lee" <danieltimlee@gmail.com> wrote:
>
> > This commit adds CIDR parsing and IP validate helper function to parse
> > single IP or range of IP with CIDR. (e.g. 198.18.0.0/15)
> >
> > Helpers will be used in prior to set target address in samples/pktgen.
> >
> > Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> > ---
> >  samples/pktgen/functions.sh | 122 ++++++++++++++++++++++++++++++++++++
> >  1 file changed, 122 insertions(+)
> >
> > diff --git a/samples/pktgen/functions.sh b/samples/pktgen/functions.sh
> > index 4af4046d71be..8be5a6b6c097 100644
> [...]
>
> > +# Given a single IP(v4/v6) or CIDR, return minimum and maximum IP addr.
> > +function parse_addr()
> > +{
> > +    # check function is called with (funcname)6
> > +    [[ ${FUNCNAME[1]: -1} == 6 ]] && local IP6=6
> > +    local bitlen=$[ IP6 ? 128 : 32 ]
> > +    local octet=$[ IP6 ? 16 : 8 ]
> > +
> > +    local addr=$1
> > +    local net prefix
> > +    local min_ip max_ip
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
>
> I must say this is a rather cool shell/bash trick to use an array for
> converting decimal numbers into binary.
>

Thank you for the compliment and for the detailed review.

> > +
> > +        local shift=$[ bitlen-prefix ]
>
> Using a variable named 'shift' is slightly problematic for shell/bash
> code.  It works, but it is just confusing.
>
> > +        local min_mask max_mask
> > +        local min max
> > +        local ip_bit
> > +        local ip sep
> > +
> > +        # set separator for each IP(v4/v6)
> > +        [[ $IP6 ]] && sep=: || sep=.
> > +        IFS=$sep read -ra ip <<< $net
> > +
> > +        min_mask="$(printf '1%.s' $(seq $prefix))$(printf '0%.s' $(seq $shift))"
> > +        max_mask="$(printf '0%.s' $(seq $prefix))$(printf '1%.s' $(seq $shift))"
>
> Also a surprising shell trick to get binary numbers out of a prefix number.
>
> > +
> > +        # calculate min/max ip with &,| operator
> > +        for i in "${!ip[@]}"; do
> > +            digit=$[ IP6 ? 16#${ip[$i]} : ${ip[$i]} ]
> > +            ip_bit=${D2B[$digit]}
> > +
> > +            idx=$[ octet*i ]
> > +            min[$i]=$[ 2#$ip_bit & 2#${min_mask:$idx:$octet} ]
> > +            max[$i]=$[ 2#$ip_bit | 2#${max_mask:$idx:$octet} ]
> > +            [[ $IP6 ]] && { min[$i]=$(printf '%X' ${min[$i]});
> > +                            max[$i]=$(printf '%X' ${max[$i]}); }
> > +        done
> > +
> > +        min_ip=$(IFS=$sep; echo "${min[*]}")
> > +        max_ip=$(IFS=$sep; echo "${max[*]}")
> > +    fi
> > +
> > +    echo $min_ip $max_ip
> > +}
>
> If you just fix the variable name 'shift' to something else, then I'm
> happy with this patch.
>
> Again, I'm very impressed with your shell/bash skills, I were certainly
> challenged when reviewing this :-)
>

I'll change the variable name to 'remain'.

Once again, I really appreciate your time and effort for the review.
Thank you.

Best,
Daniel

> --
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
