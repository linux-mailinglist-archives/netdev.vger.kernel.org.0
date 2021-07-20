Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BC653D0201
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 21:00:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232954AbhGTSTu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 14:19:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232933AbhGTSTa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 14:19:30 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F41A1C061762;
        Tue, 20 Jul 2021 12:00:00 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id y21-20020a7bc1950000b02902161fccabf1so2089050wmi.2;
        Tue, 20 Jul 2021 12:00:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:reply-to:date:message-id:mime-version;
        bh=/bUwXiZRYg8MgLgXV7pvJkWpCdM7Ja9GEUJxuUU6+iQ=;
        b=Z+g8IUwickDoq290gSRADSGBuDXm8WQjgbhj4IhP/VG2gpYFIQtDXNwOY4qnCHr+JV
         dxSSYe8cfLui6Hz7xNVbANVPSlL63QK+9KbCJYPjDeaWWVJk+Emi1HJic5UdGkSe74TO
         s2R+DD67Iog92jnIyXiIcVyEdDHiSA5rV3cbHmZegROjn0FlKgPo6k00K8BqwQEkY2nx
         iXKhEc53GQ9c2d2u6C7NSQz26B+OcPiqHGdTXkIrSRgnNt3GTGoF2k1ZD+U+wqbL53gf
         b92ftF/PLdkuqEcFMsDbvFO+an9VWcp+asMAYHf/QBF/sGT9rELiG/dWgRi6FZ6WfAHV
         wP1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:reply-to:date:message-id
         :mime-version;
        bh=/bUwXiZRYg8MgLgXV7pvJkWpCdM7Ja9GEUJxuUU6+iQ=;
        b=XPqrPHlu1LqTR9+vIv4Sw3OODfjGwZm3TlhVNeEw7ZCr24rlXQgoYe8QVuEiODF89B
         UaM3meCpsuCu3L7DwC4Dii/UcxkQAkVwuond9JftGx7tXcXGte4tJ2yVxwxswLJ9RNq5
         eYQrNBjh3POTSRr+gEvI89haBkJSpCiNR6UK6PxpZtwSLsSnAZO/oM/qHOVYRxhvIjsl
         KefWzdX9Ni3jKnfrpG1XcmWG/wvoCHhbBHYj3p4mqFtXwWEOmiUKhcuOp1We9+xU7wl4
         1+UiAuJVa0YGikdMmG3gUy0tYxKTFbWk+uMPzl+3ySXXnSu4/bsHJCLHQKRKjkEkDTkr
         PiVw==
X-Gm-Message-State: AOAM530/TbRBk+csK6DCiPuhG5utv8ubJH/nEArngQvHtEA0KnFLy04s
        A+njB45RRfEPqWMb2ivJ3pTiVdi2aGw=
X-Google-Smtp-Source: ABdhPJw2GTxGDYLtjIBkklMZU3/uKTVEFO9zsWiZ0xe2P+uOd4Ws3QmgxYYriREv66AUcfBKlXE/fQ==
X-Received: by 2002:a7b:cb91:: with SMTP id m17mr38375711wmi.159.1626807599541;
        Tue, 20 Jul 2021 11:59:59 -0700 (PDT)
Received: from jvdspc.jvds.net ([212.129.81.137])
        by smtp.gmail.com with ESMTPSA id w16sm10605081wru.58.2021.07.20.11.59.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jul 2021 11:59:58 -0700 (PDT)
Received: from jvdspc.jvds.net (localhost [127.0.0.1])
        by jvdspc.jvds.net (8.16.1/8.15.2) with ESMTPS id 16KIxv5H359196
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
        Tue, 20 Jul 2021 19:59:57 +0100
Received: (from jvd@localhost)
        by jvdspc.jvds.net (8.16.1/8.16.1/Submit) id 16KIxv4f359195;
        Tue, 20 Jul 2021 19:59:57 +0100
X-Authentication-Warning: jvdspc.jvds.net: jvd set sender to jason.vas.dias@gmail.com using -f
From:   "Jason Vas Dias" <jason.vas.dias@gmail.com>
To:     linux-kernel@vger.kernel.org, linux-8086@vger.kernel.org,
        netdev@vger.kernel.org
Subject: re: /proc/net/{udp,tcp}{,6} : ip address format : RFC : need for
 /proc/net/{udp,tcp}{,6}{{n,h},{le,be}} ?
Reply-To: "Jason Vas Dias" <jason.vas.dias@gmail.com>
Date:   Tue, 20 Jul 2021 19:59:57 +0100
Message-ID: <hhlf60vmj6.fsf@jvdspc.jvds.net>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


RE:
On 20/07/2021, Randy Dunlap <rdunlap@infradead.org> wrote:
> On 7/20/21 2:14 AM, Jason Vas Dias wrote:
> ... 
> Hi,
> I suggest sending your email to  ndetdev@vger.kernel.org
> g'day.
>>> (he meant netdev@)

Good day -

 I noticed that /proc/net/{udp,tcp} files (bash expansion) - the IPv4
 socket tables - contain IPv4 addresses in hex format like:

   0100007F:0035

  (Little-Endian IPv4 address 127.0.0.1 , Big Endian port 53)

 I would have printed / expected the IPv4 address to be printed EITHER
 like:
   7F000001:0035  (Both Big-Endian)
 OR
   0100007F:3500  (Both Little-Endian)
 .

 It is rather idiosyncratic that Linux chooses
 to print Little-Endian IPv4 addresses, but not
 Little-Endian Ports , and where the other numbers
 eg. (rx:tx) , (tr:tm/when) in those files are all
 Big-Endian.  

 Perhaps a later version of Linux could either
 A) Print ALL IP addresses and Ports and numbers in network
    (Big Endian) byte order, or as IP dotted-quad+port strings
    ; OR:
 B) Provide /proc/net/{udp,tcp}{,6}{n,be,h,le,ip} files
    ( use shell : $ echo ^^
      to expand
    ) -
    which print IPv4 addresses & Ports in formats indicated by suffix :
     n: network: always Big Endian
     h: host: native either Little-Endian (LE) or Big Endian (BE)
     be: BE - alias for 'n'
     le: LE - alias for 'h' on LE platforms, else LE
     ip: as dotted-decimal-quad+':'decimal-port strings, with numbers in BE.
     ; OR:
 C) Provide /proc/net/{udp,tcp}{,6}bin memory mappable binary socket
    table files
    .
 ?

 Should I raise a bug on this ?

 Rather than currently letting users discover this fact
 by mis-converting IP addresses / ports initially as I did at first.

 Just a thought / request for comments.

 One would definitely want to inform the netstat + lsof + glibc
 developers before choosing option A .

 Option B allows users to choose which endianess to use (for ALL numbers)
 by only adding new files, not changing existing ones.

 Option C would obviate the need to choose an endianess file by
 just providing one new memory-mappable binary representation
 of the sockets table, of size an even multiple of the page-size,
 but whose reported size would be (sizeof(some_linux_ip_socket_table_struct_t) *
 n_sockets_in_table). It could be provided alongside option B.

 I think options B and / or C would be nice to have - I might implement an
 extension to the procfs code that prints these socket tables to
 do this, maybe enabled by a new experimental 
 '+rational-ip-socket-tables' boot option -
 then at least it would be clear how the numbers in those files are
 meant to be read / converted.

All the best,
Jason






  
