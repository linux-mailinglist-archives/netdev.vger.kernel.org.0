Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A63B33D04BC
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 00:41:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231239AbhGTWAo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 18:00:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229909AbhGTWA3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 18:00:29 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3648CC061574
        for <netdev@vger.kernel.org>; Tue, 20 Jul 2021 15:41:06 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id p14-20020a17090ad30eb02901731c776526so2849621pju.4
        for <netdev@vger.kernel.org>; Tue, 20 Jul 2021 15:41:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=q8ihxUcEiji5P4ZUEbiGoS1ejU8s0r5S2bgdmVxmVr4=;
        b=kq+N+1dXB5WxhR7BT4GdPfsRtGzqsUlEUetY/S6IML3buPvX8EEFewNZm4wdPM25X9
         gHWxI+6XbJ51ynRq1tJmuDpiMBMNoa4LwTfnX6a2x/erUENCUjLeWpXTUeY9Abho/FkW
         DzWHd+rlO5RFAAimjitvtbtw/l1lHZZtdAP2Ny06lBNdgsKfYUJ/NH5J6kbp/fRUbpAH
         /oq6UWK0BIBRxVO3fc0rZVQPZkyDIicStjoKSzwPSJ79AJg9DL4RpjwGYVsiV/RP3J9/
         ujxPiwx2GrkO+3AirdTA2SDZ4wdDuoyS4nfkhT6RvgHfvZc/npE6tdEJc0s/igaxuwEY
         ljFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=q8ihxUcEiji5P4ZUEbiGoS1ejU8s0r5S2bgdmVxmVr4=;
        b=DDfADZn3jwv5kTLedEKa3bMKt2prh9qpk/H0FMSaDQqfdNkKrANZToSMAoNbmPTB8f
         BvfKZl8rIIFADGXOKj3o4THPe35j360hWmsClYTvgLwkdT8j/x9Dw0eucCnrW6RXghSm
         JI0AfPsUESBmmUVFZemIYmAtKVW2c7yE1OpYsakMDrS7piEJR55IwrYFu4qmkSQVYOgS
         W0QWYap/Phg1Vb2e691jfqwTPO3ZN3YfL9CaiUH9VWuKbYqayeVdRs5q/R4HU2953i2v
         R5MnKWhxr3xT6H2KPB5KhzcC8EWEh5FbPP/humyq3kTqXjz7Vrfd6GW5ayvS5m3BbAnj
         4Pgg==
X-Gm-Message-State: AOAM533V9MdmafN3QDjVW36f5UOslTFWrDNmu0R9Pad8TNXlw9TDYYA/
        peV9JID3w/LEfx5Zh5zisxZWGw==
X-Google-Smtp-Source: ABdhPJwcPYP8rjRKR1t24KUbIyawsl5OfWU92+2Z73/D2FlReH79E/mOEU16co4x+tLIyP4hU/Pl5g==
X-Received: by 2002:a17:90b:184:: with SMTP id t4mr646636pjs.161.1626820865587;
        Tue, 20 Jul 2021 15:41:05 -0700 (PDT)
Received: from hermes.local (204-195-33-123.wavecable.com. [204.195.33.123])
        by smtp.gmail.com with ESMTPSA id p3sm1901598pfw.171.2021.07.20.15.41.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jul 2021 15:41:05 -0700 (PDT)
Date:   Tue, 20 Jul 2021 15:41:01 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     "Jason Vas Dias" <jason.vas.dias@gmail.com>
Cc:     linux-kernel@vger.kernel.org, linux-8086@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: /proc/net/{udp,tcp}{,6} : ip address format : RFC : need for
 /proc/net/{udp,tcp}{,6}{{n,h},{le,be}} ?
Message-ID: <20210720154101.11df3494@hermes.local>
In-Reply-To: <hhlf60vmj6.fsf@jvdspc.jvds.net>
References: <hhlf60vmj6.fsf@jvdspc.jvds.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 20 Jul 2021 19:59:57 +0100
"Jason Vas Dias" <jason.vas.dias@gmail.com> wrote:

> RE:
> On 20/07/2021, Randy Dunlap <rdunlap@infradead.org> wrote:
> > On 7/20/21 2:14 AM, Jason Vas Dias wrote:
> > ... 
> > Hi,
> > I suggest sending your email to  ndetdev@vger.kernel.org
> > g'day.  
> >>> (he meant netdev@)  
> 
> Good day -
> 
>  I noticed that /proc/net/{udp,tcp} files (bash expansion) - the IPv4
>  socket tables - contain IPv4 addresses in hex format like:
> 
>    0100007F:0035
> 
>   (Little-Endian IPv4 address 127.0.0.1 , Big Endian port 53)
> 
>  I would have printed / expected the IPv4 address to be printed EITHER
>  like:
>    7F000001:0035  (Both Big-Endian)
>  OR
>    0100007F:3500  (Both Little-Endian)
>  .
>
>  It is rather idiosyncratic that Linux chooses
>  to print Little-Endian IPv4 addresses, but not
>  Little-Endian Ports , and where the other numbers
>  eg. (rx:tx) , (tr:tm/when) in those files are all
>  Big-Endian.  
> 
>  Perhaps a later version of Linux could either
>  A) Print ALL IP addresses and Ports and numbers in network
>     (Big Endian) byte order, or as IP dotted-quad+port strings
>     ; OR:
>  B) Provide /proc/net/{udp,tcp}{,6}{n,be,h,le,ip} files
>     ( use shell : $ echo ^^
>       to expand
>     ) -
>     which print IPv4 addresses & Ports in formats indicated by suffix :
>      n: network: always Big Endian
>      h: host: native either Little-Endian (LE) or Big Endian (BE)
>      be: BE - alias for 'n'
>      le: LE - alias for 'h' on LE platforms, else LE
>      ip: as dotted-decimal-quad+':'decimal-port strings, with numbers in BE.
>      ; OR:
>  C) Provide /proc/net/{udp,tcp}{,6}bin memory mappable binary socket
>     table files
>     .

/proc is part of the guaranteed stable ABI in Linux. the format of those
files can not change like that, it would break several applications.

And adding new to /proc is actively discouraged since we have better
interfaces like netlink or sysfs.



>  Should I raise a bug on this ?

No

>  Rather than currently letting users discover this fact
>  by mis-converting IP addresses / ports initially as I did at first.
> 
>  Just a thought / request for comments.
> 
>  One would definitely want to inform the netstat + lsof + glibc
>  developers before choosing option A .

Netstat is actually part of iputils and is mostly deprecated in
favor of iproute2 ss command.

>  Option B allows users to choose which endianess to use (for ALL numbers)
>  by only adding new files, not changing existing ones.
> 
>  Option C would obviate the need to choose an endianess file by
>  just providing one new memory-mappable binary representation
>  of the sockets table, of size an even multiple of the page-size,
>  but whose reported size would be (sizeof(some_linux_ip_socket_table_struct_t) *
>  n_sockets_in_table). It could be provided alongside option B.
> 
>  I think options B and / or C would be nice to have - I might implement an
>  extension to the procfs code that prints these socket tables to
>  do this, maybe enabled by a new experimental 
>  '+rational-ip-socket-tables' boot option -
>  then at least it would be clear how the numbers in those files are
>  meant to be read / converted.
> 
> All the best,
> Jason

So, yes what you say makes sense but that was not how the early
prehistoric (2.4 or earlier) versions of Linux decided to output addresses
and it can never change.
