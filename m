Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10B902224E1
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 16:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728455AbgGPOKE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 10:10:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727044AbgGPOKD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 10:10:03 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 424C4C061755
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 07:10:03 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id j10so4922154qtq.11
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 07:10:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4457RnLNJcPLsjYWaJwh5rhYWqg1UZ+xbz9duTTC7U0=;
        b=Dh497KqMbv4PehHU2s8NsZ9WG2YpATiOsl17lPd0nO9gfavq3UlKgdpVxGLcl8fgQk
         KrCCIQ49IJcvTdp+PVqTlK2kkyJEJ+OXbT+zUdbRzccRobsxqOCUbLokjr/8meorwLZC
         rMn062rsZHaBpIaXajYvckMMil4sF9S2AoALgAGbIS80CI4bCPkYb/FCc3Td//wFhMIH
         WLPfQib/NcO751cNgn0Qu0unthlweBrHy0VDJzNN+Skh6Hn6oaDDjjsm1sJCj2JbnXxe
         vn+1IZz9mv53e64HzLVYFyxVc5QnFAfe/cu0nl0PZeJRZ7BuSgo8JWsS1Ld5CQoYuCbu
         NAqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4457RnLNJcPLsjYWaJwh5rhYWqg1UZ+xbz9duTTC7U0=;
        b=DnGjQF9wBf+r3fLB2EUYU5xSJwYG4+/5IAfjOhaIjU8X8AapYiYEcTlE+Sfq6t1UQs
         kFyWAYT4hbVO+l1qoXwLndXhcsGc4hHO6t9EdGxqMUBy1i2ML+ThIKt8LeMYJT4QULdZ
         qqM1PPu739nuiNPEiu5WDeTx0nYEPzfFucgEgC/KD14u7JlgS/8xO0V9xwMEd5qGdAqy
         lW3GwyyIS9Ng4RGZFJM0XzvRUTw8zuvcYAnANObDUMopCtGG5nGk9OOn354ujU/WvVHn
         sziIY0zWiGpHOQ4TglVX0CL1KZLWovyxf6USJrpIYTXj5g3Eq1IjVMOE+TJB2OYPzBlK
         W0AA==
X-Gm-Message-State: AOAM5315N2PdWpU1Kx32bBvvkG5n2+8Ev+AJa1OXJzZ9Z+ARN1ThcbD2
        5HtoKc0K0679wxzbwcr2OVHOWkuI
X-Google-Smtp-Source: ABdhPJxS4Mo4HDyw+ELrnEEptJ3+014iKaVk+sqA+QHc7jA2V51kMIjuHPGTAbzTdMAcYm7X33qNVQ==
X-Received: by 2002:ac8:3fcb:: with SMTP id v11mr5440148qtk.348.1594908600580;
        Thu, 16 Jul 2020 07:10:00 -0700 (PDT)
Received: from mail-yb1-f176.google.com (mail-yb1-f176.google.com. [209.85.219.176])
        by smtp.gmail.com with ESMTPSA id b7sm6874771qkl.18.2020.07.16.07.09.59
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jul 2020 07:09:59 -0700 (PDT)
Received: by mail-yb1-f176.google.com with SMTP id g6so2894478ybo.11
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 07:09:59 -0700 (PDT)
X-Received: by 2002:a25:cc4e:: with SMTP id l75mr6919139ybf.165.1594908598533;
 Thu, 16 Jul 2020 07:09:58 -0700 (PDT)
MIME-Version: 1.0
References: <20200710132902.1957784-1-willemdebruijn.kernel@gmail.com>
In-Reply-To: <20200710132902.1957784-1-willemdebruijn.kernel@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 16 Jul 2020 10:09:20 -0400
X-Gmail-Original-Message-ID: <CA+FuTSdOHYF-7rcjuuSraJjnAhcToV+tTvvj=JGCN0v6HZu_Kw@mail.gmail.com>
Message-ID: <CA+FuTSdOHYF-7rcjuuSraJjnAhcToV+tTvvj=JGCN0v6HZu_Kw@mail.gmail.com>
Subject: Re: [PATCH net-next v2] icmp: support rfc 4884
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Tom Herbert <tom@herbertland.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 10, 2020 at 9:29 AM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> From: Willem de Bruijn <willemb@google.com>
>
> Add setsockopt SOL_IP/IP_RECVERR_4884 to return the offset to an
> extension struct if present.
>
> ICMP messages may include an extension structure after the original
> datagram. RFC 4884 standardized this behavior. It stores the offset
> in words to the extension header in u8 icmphdr.un.reserved[1].
>
> The field is valid only for ICMP types destination unreachable, time
> exceeded and parameter problem, if length is at least 128 bytes and
> entire packet does not exceed 576 bytes.
>
> Return the offset to the start of the extension struct when reading an
> ICMP error from the error queue, if it matches the above constraints.
>
> Do not return the raw u8 field. Return the offset from the start of
> the user buffer, in bytes. The kernel does not return the network and
> transport headers, so subtract those.
>
> Also validate the headers. Return the offset regardless of validation,
> as an invalid extension must still not be misinterpreted as part of
> the original datagram. Note that !invalid does not imply valid. If
> the extension version does not match, no validation can take place,
> for instance.
>
> For backward compatibility, make this optional, set by setsockopt
> SOL_IP/IP_RECVERR_RFC4884. For API example and feature test, see
> github.com/wdebruij/kerneltools/blob/master/tests/recv_icmp_v2.c
>
> For forward compatibility, reserve only setsockopt value 1, leaving
> other bits for additional icmp extensions.
>
> Changes
>   v1->v2:
>   - convert word offset to byte offset from start of user buffer
>     - return in ee_data as u8 may be insufficient
>   - define extension struct and object header structs
>   - return len only if constraints met
>   - if returning len, also validate
>
> Signed-off-by: Willem de Bruijn <willemb@google.com>

Tom, Eric, does this address your concerns from v1?

To summarize:

- cleaner api
    - only return offset if rfc 4884 constraints met
    - return as byte offset from start of user buffer, not raw packet off
    - define self-describing new union in sock_extended_err
    - define rfc 4884 extension struct and objects in uapi

- validate
    - verify checksum
    - verify object boundaries

Does not

- validate individual users from subsequent RFCs: a number of classes
and subtypes are defined in an IANA registry [1]. But unlike rfc 4884
those are at best proposed standards, some not updated since 2015. I
don't think those are mature enough to encode in the kernel ABI.

- truncate packet for socket matching: I think that should be a
separate (stable) commit if a real issue. Personally, I'm not
convinced yet that it is. The 128B original datagram + outer header
minimum offset concerns IPv4, where packet is at most 576B. For IPv6,
which has the extension header issue, the relevant rfc 4443 states
that that the length should be 1280. More importantly, it would take a
malicious/buggy sender to craft a packet with an extension header that
overlaps the headers. But it does not need to mess with the extension
header offset field to create such a payload to begin with.

[1] https://www.iana.org/assignments/icmp-parameters/icmp-parameters.xhtml#icmp-parameters-ext-classes
