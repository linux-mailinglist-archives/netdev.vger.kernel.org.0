Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33AAAEE0EF
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 14:24:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728828AbfKDNYY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 08:24:24 -0500
Received: from mail-qt1-f170.google.com ([209.85.160.170]:34718 "EHLO
        mail-qt1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728561AbfKDNYY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 08:24:24 -0500
Received: by mail-qt1-f170.google.com with SMTP id h2so10596376qto.1
        for <netdev@vger.kernel.org>; Mon, 04 Nov 2019 05:24:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=GgsqFBRrN+/IYZ70OsRWA/MYgyrkRI6Z3W13UzpGY0c=;
        b=B/MliOfCW6tJZW6jaleGK3E4ARsxtauJ8uJMoHQ82gRl5vrGrJAUg/YV5hu+VSfjKy
         zpJaqQCp4g3EOYGf4VQzQfb+Vqr9JoNZ/YBUYD8uaoPDzBWsPJVdGGDHGQCODP7sNryZ
         tkBPHAGVQZKx394+cmz6l9fEg7EeF36vFftpBex46wYWFgdcD1PCB3tXn9YoJg71j97R
         bfHavUZ36QttTE/KjTd6dtRa0+M4JIgEiz/vZ0/STEjBJFFsBLG05uIYRb+p7T5/OG/x
         wE7meq2SsZZMM7y8s9MMnwzgz5nsezdtf2xcL6xnH2OYBDzy8Vqv1sxa/GU6YAmvXj3j
         VgpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=GgsqFBRrN+/IYZ70OsRWA/MYgyrkRI6Z3W13UzpGY0c=;
        b=T6iCaQIiyIObW2xIB7DO3C/eUwYoZ6zMURcltUAmCKcTanu4RuWqeCWjMpaYJZ/A5p
         y7Gh1265eKFDzmZue6dg0u/fjPcA0PJZ2lRJ+GloywfVGGfEluMxJR08tCpEivojjtaI
         H4Ff988+43KAUG5MQCkFYjhShqZNjaHeQCjwE39QJv4mRJaMv4tLSclwKJDs79NqbHhC
         konutmtIUkhg5za+8EQeFgO65P3vj2vyLcYn+QULVtIbJUW9vjvQHwXQWrwSVqKUIf5f
         kBKsJf5nvQBFWhfRZ46JtKPNHoB1rzxLH70YfMRqk12weYo6kk2IA1Zc7fcoUtCBz2Np
         Q4Dw==
X-Gm-Message-State: APjAAAWJLIzNiC4BmozopWQ7J2oatV0h5qgjaib9ZfJSol3/Q2NOLcy+
        z6ACgizxSBTolJgnb4lwp2wvQTkB6sDw2pVZeO/F1JhYfCVfDw==
X-Google-Smtp-Source: APXvYqxfRoh2alAeuEf2Yyu0z//oXn8TkWLKPCft/P/BgiMXijejsozwOlEROZwrlf4l/FS+1eMfbSFm3zPg4CKgLmg=
X-Received: by 2002:ac8:2a42:: with SMTP id l2mr10778777qtl.64.1572873863015;
 Mon, 04 Nov 2019 05:24:23 -0800 (PST)
MIME-Version: 1.0
From:   Levente <leventelist@gmail.com>
Date:   Mon, 4 Nov 2019 14:24:12 +0100
Message-ID: <CACwWb3Bv7-PJ5rYQZWJJOxzH63E69WGwz8bppNoH_EbBJ1F99Q@mail.gmail.com>
Subject: No unrecognized Next Header type encountered message sent
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear all,


I am trying to validate the Linux kernel's IPv6 stack against the
specification. So far we encountered the following issue:

The tester sends a packet with unassigned next header (143):


Frame 365: 71 bytes on wire (568 bits), 71 bytes captured (568 bits)
on interface 0
Ethernet II, Src: HewlettP_6c:9d:88 (00:23:7d:6c:9d:88), Dst:
RohdeSch_1d:9c:46 (00:90:b8:1d:9c:46)
    Destination: RohdeSch_1d:9c:46 (00:90:b8:1d:9c:46)
    Source: HewlettP_6c:9d:88 (00:23:7d:6c:9d:88)
    Type: IPv6 (0x86dd)
Internet Protocol Version 6, Src: fcb1:cafe::2, Dst: fcb1:cafe::1
    0110 .... = Version: 6
    .... 0000 0000 .... .... .... .... .... = Traffic Class: 0x00
(DSCP: CS0, ECN: Not-ECT)
    .... .... .... 0000 0000 0000 0000 0000 = Flow Label: 0x00000
    Payload Length: 17
    Next Header: Destination Options for IPv6 (60)
    Hop Limit: 255
    Source: fcb1:cafe::2
    Destination: fcb1:cafe::1
    Destination Options for IPv6
        Next Header: Unassigned (143)
        Length: 0
        [Length: 8 bytes]
        PadN
Data (9 bytes)
    Data: 800070e80000000000
    [Length: 9]


The pass criteria is to receive the 'Parameter Problem Message'  ICMP
message with Code 1 as described in RFC2463 section 3.4 as follows:

3.4 Parameter Problem Message

       0                   1                   2                   3
       0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
      +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
      |     Type      |     Code      |          Checksum             |
      +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
      |                            Pointer                            |
      +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
      |                    As much of invoking packet                 |
      +               as will fit without the ICMPv6 packet           +
      |               exceeding the minimum IPv6 MTU [IPv6]           |

   IPv6 Fields:

   Destination Address

                  Copied from the Source Address field of the invoking
                  packet.

   ICMPv6 Fields:

   Type           4

   Code           0 - erroneous header field encountered

                  1 - unrecognized Next Header type encountered


According the RFC it shall send the "unrecognized Next Header type
encountered" code.


Is there any way to turn this error message on? I'm using Linux
4.19.0-6-amd64, on an up to date Debian stable.


Thank you very much for your help.


Levente
