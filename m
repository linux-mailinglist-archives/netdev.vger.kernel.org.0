Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A3676AAB03
	for <lists+netdev@lfdr.de>; Sat,  4 Mar 2023 16:58:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229737AbjCDP6R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Mar 2023 10:58:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbjCDP6Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Mar 2023 10:58:16 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4AB4A257
        for <netdev@vger.kernel.org>; Sat,  4 Mar 2023 07:58:13 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id p3-20020a17090ad30300b0023a1cd5065fso5126777pju.0
        for <netdev@vger.kernel.org>; Sat, 04 Mar 2023 07:58:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112; t=1677945493;
        h=content-transfer-encoding:mime-version:message-id:subject:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xNgTrhHyu0jhnO18TFqB8uS8O+fx7Zuc6L7qhp5omZc=;
        b=b4kJmL+d5g8I8KH7v/0AwTkf7SXXlRzew7P5lg9b/hmhtAK4whyJ3xpHtdoGh69o9V
         PCdpEtzw6wnREOd6y9SgdEhwYmFsSUxBfc3Q6i9f9oi49WXPlB96BWW+rJSzQjeHdX7q
         uX8LrRLaDNnr4euQxSnCaUhc7tBalPWsecV4f5UW96rcEOlB3UA3trariiav+oPqihFT
         Oc9FoaSg6fle2yvQbIlEv/R6uYYmr3OHI/HhUXzY8Qqb8E9fXlxZwQ2aMRG7ZQf/59l1
         aXzCeU5I5FRpDbCZPKBHrDYPCJNWSXgCySSLVd23wlY2nF2R0+IYA0aw2WLb8CuLy+7H
         xw+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677945493;
        h=content-transfer-encoding:mime-version:message-id:subject:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xNgTrhHyu0jhnO18TFqB8uS8O+fx7Zuc6L7qhp5omZc=;
        b=XQ3riNNfLKCUWa0YZq32cSOIo155U8SeaemSSNahHHaHUU77ythlJ4FErFJOnA8G9x
         PqwLt29/HrW+AFqpMXHfsMxdX/0Vk/Qa5EfhNz2c0k8qhgvTr4GImFBDcDlO2hgT+MIn
         ZSQWFoXqV0pkTujRU07XBo5t8uIJ0RnIOKMY7aZ42m9I6EIma3K3OoamoXs0XiRvbhaN
         wesVWxuRV+/k+FSvbzpF6pXS13s5dNpgg9+78gc5krd/oSwN1kzrqDlI5E0KINroNPmr
         ZAFAZJUzWAHQzokCsOlC4sJuIQVX9CtYf9I2DpkbMU+xKduT4w7/PoTKwtKSiyG9Llce
         /aCw==
X-Gm-Message-State: AO0yUKXDq/bzKHiwMEzzd3MdEhzYEaXMBa6dnauLB8tkOKAZ7AgQuxbU
        lhfhONsxyT546ercAyX01j8OIWRkoq2eyrML8a7w4A==
X-Google-Smtp-Source: AK7set9LLpO8gu/lZDj7AzQUri/uzqPq5gBV0401H5c3ITAgBzPjnK85KWiTkbhcZIC/mPYxEJ3I5g==
X-Received: by 2002:a05:6a20:8f1b:b0:c6:b993:69a4 with SMTP id b27-20020a056a208f1b00b000c6b99369a4mr6447534pzk.23.1677945492896;
        Sat, 04 Mar 2023 07:58:12 -0800 (PST)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id z9-20020a63e109000000b004fbd91d9716sm3480299pgh.15.2023.03.04.07.58.12
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Mar 2023 07:58:12 -0800 (PST)
Date:   Sat, 4 Mar 2023 07:58:11 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: Fw: [Bug 217134] New: TCP performance regression on loopback
 interface
Message-ID: <20230304075811.4659e491@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Begin forwarded message:

Date: Sat, 04 Mar 2023 15:54:34 +0000
From: bugzilla-daemon@kernel.org
To: stephen@networkplumber.org
Subject: [Bug 217134] New: TCP performance regression on loopback interface


https://bugzilla.kernel.org/show_bug.cgi?id=3D217134

            Bug ID: 217134
           Summary: TCP performance regression on loopback interface
           Product: Networking
           Version: 2.5
    Kernel Version: 5.10-6.2
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
          Assignee: stephen@networkplumber.org
          Reporter: uint8ptr@proton.me
        Regression: No

Created attachment 303849
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D303849&action=3Dedit =
=20
Packet captures of the GDB communication on Linux 5.9 and 5.10

Somewhere between Linux 5.9-rc1 and Linux 5.10 LTS the TCP performance on t=
he
loopback interface slowed down to a crawl. This issue makes doing some
operations with gdb a lot slower than they should be, in particular when us=
ing
Python GDB extensions that require sending and receiving data to/from the G=
DB
server.

The bug affects all versions of the Linux kernel from 5.10 LTS up to 6.2.
Versions 5.4 LTS and 5.9-rc1 are not affected by this bug.

I attached two PCAP files that shows the problem.

The packet captures were obtained by connecting the mGBA (version 0.10.1) G=
DB
server and reading 8 bytes from the memory with the following commands:

```
(gdb) target remote localhost:2345
Remote debugging using localhost:2345
0x080008c6 in WaitForVBlank ()
(gdb) x/8bx 0x08000000
0x8000000:      0x7f    0x00    0x00    0xea    0x24    0xff    0xae    0x51
```

I made a table illustrating the performance difference for reading the first
byte. You can trace back the exact packets by referring to the first column=
 of
the tables.

---

Linux 5.9 packet capture summary

Seq |   | Timestamp | Payload
168 | > | 4.457569  | $m8000000,1#22
172 | < | 4.457689  | $7f#9d

Time delta: 0.00011s/110=CE=BCs

---

Linux 5.10 packet capture summary

Seq |   | Timestamp | Payload
164 | > | 3.583188  | $m8000000,1#22
168 | < | 3.623667  | $7f#9d

Time delta: 0.040479s/40ms

---

I already discussed extensively the issue with the emulator developer, and =
we
came to the conclusion that the packet is getting delayed by the OS at some
point. The issue is present on any version of the emulator that supports the
GDB server.

Additional information:

During the TCP communication, no new messages appeared by running the dmesg
command.

```
root # uname -a
Linux manjaro 6.1.12-1-MANJARO #1 SMP PREEMPT_DYNAMIC Tue Feb 14 21:59:10 U=
TC
2023 x86_64 GNU/Linux
root # lspci | grep "Network controller"
02:00.0 Network controller: Intel Corporation Wireless 8265 / 8275 (rev 78)
```

The non-affected Kernel version I used for testing can be downloaded here:
https://kacabenggala.uny.ac.id/manjaro/stable-staging/core/x86_64/linux59-5=
.9rc1.d0816.g9123e3a-1-x86_64.pkg.tar.zst

Steps to reproduce:

1. Start a game on any version of mGBA that supports the GDB server on Linux
5.10 LTS or newer
2. Go to mGBA > Tools > Start GDB server... > Start
3. Start arm-none-eabi-gdb and run the following commands
   - target remote localhost:2345
   - x/8bx 0x08000000

If you display more bytes on the second command, the issue is more noticeab=
le.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.
