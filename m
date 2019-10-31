Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BCC4EB1B1
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 14:56:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727648AbfJaN4z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 09:56:55 -0400
Received: from mout.gmx.net ([212.227.17.21]:44913 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727567AbfJaN4y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 31 Oct 2019 09:56:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1572530198;
        bh=1eB0tnDg7p9fMqbMwcIbZVE0spFXCYkJlm2XDYJ3n80=;
        h=X-UI-Sender-Class:To:From:Subject:Cc:Date;
        b=ELxzZmQ2/TsgBp/PTYqQvfCTM2Jw2DEei8tPXmtx1zYt21F6fjnLhsb6cJ9PMcIxy
         Jw5Ki+pTsz0hiXs72xbWW+uG9odWfdnCHwke0O4zmo+eLvFxdL/RZyQyUjO4cY4Akr
         CyLnz2D2edw3XDtvD2D3h7zQFGzj00uxB95Q6+I4=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.1.162] ([37.4.249.112]) by mail.gmx.com (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1N5G9t-1i0uxf1qbd-011Bxd; Thu, 31
 Oct 2019 14:56:38 +0100
To:     Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
From:   Stefan Wahren <wahrenst@gmx.net>
Subject: rtlwifi: Memory leak in rtl92c_set_fw_rsvdpagepkt()
Cc:     colin.king@canonical.com, kvalo@codeaurora.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Message-ID: <989debc9-8602-0ce3-71a7-2bf783b2c22b@gmx.net>
Date:   Thu, 31 Oct 2019 14:56:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-Provags-ID: V03:K1:3nPeYzINqeklWw6e+6B8MzpTZEm7wf9QcxoNYa1V+LSGpYtgaex
 OttoTDReZFvDq6P+xKHsVGA7f9OTPOUTwUNhBG4nBDR5VBhuyNENXjKGdhlgBwjlANDEwgG
 GiyxW8vT3BWz/ZnyNoKGUWgKcRwVIjuqvQIRHwRvTS857UbwlhaihgHUvo0wGKh7KqL8gWh
 Z4i86mJhvkYU/CjXveZlA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:SRxjHm0ZT8I=:z8ds7SBU6lnbw4loGVvPRc
 l/UZYIdQxv0UQh33TU/9+LV58OUW2HihrY62nptYFAnpdQ6tBLxeMByTLjUSi4oRjL/57AxyG
 25pK89Fns4BoGXRthb8OONKah9G7c/WvM7rqH+1TjO9BfdlOcixRZFeOlrtSEdqRonU+KhR8I
 rrUUrPJXoRJ++iK3ExxASPsGyXtVwWQ1KMU1evEj5Q5uVnX7MAjzWmRMIBow+VbgH6c+QIvYa
 SaQ5Ypt5y9gNEYwwR98BBa5wqZ+KQ+iwXJSUjsinn39UHg/USxAiJqtcR+OH/L+zNqY0QCdb/
 Si0Bkj3OLcAkS3qyfx+MVO8TamPfl6FU+XN/PyUbMp1J6t5Cm8N5lueTYp4t8+kK/trucuPlT
 lvvo64IjRlfsnxZ3oPDSsCm76ti4YTp+h+N92ozCQ5ASkBoZNFHk0js4ppEbfF5b5cK2ic/5D
 nbf29OgysPjPpC1yRhezk/7xgOPeWPPbx6LV9DycQs7QneNsKgK4KlAhCTIMDrQCZ9psTa+bT
 S7Nk4DwVRDhKZwewie6wmML60w4hcC0jAotoGUCHhTNxENZ8QzrhEg1EU6O38n7pNkFFF/C0L
 MDI8Qx1mysxyBwdgJq3RUhJq/ZW7uq/Hu7TmYLleVLeiFZRlnjpjrYm5VSv8CAPTEuGZnyNOt
 wWPtr1tIVTf9sWfXNHzYqnSRN8jEFpKo4s0fS7OcODXo+OaxSNIIvMWiic3Bsa8/1CwaHKbI1
 c2mVnrD6Ht37kWArv1p432IkyuMuqUtJeTojleeQI7C4wkw8zB0AXc6ftVPhMPWrHKc0sp6Mr
 PzM9WIQoU0n+wvW+4/zxq6kbhe7/eCBo/g1O4zmXS0eYjKbDIpylhJMk6NPB732Xll09thTtB
 7FkMCJSmxOavLX4nedgOxhMQ29vC+z4NUofh3klSDJ2YIe7wHnAzsCYpYf5ku81JtBw+XgicB
 +oBi3HYU7SOKVu75c1bl3aUdlfF+FhN8O3aPwy+BZAeb0ALdx0OmXTiJFqzWlgSLpYUTmAv8k
 P4o9zuP5koVoGwMbthO1agFTWZVUf7Jc2aKQzHqLgWcP1VL9OCskdp7pxv6NK6qrA3dDhys2F
 O+tE6prePK7r9i6YdOyTfqEV+5PzlKnGs00AxvtoE9xtGNQbeAuytPjOoYXBg/UDAp23jH05z
 lcBhyO6+5i1pAEiH+8ksWB7NszeER/gnYxNGLqPuKoXIVf2fq2l5XnrRHKvWqW/28G+kjcCyu
 0ZE7sFUUNSbJ4POsJQ2waRuuTysx4M8uNd9gpP8VzQzvtDgqbcdBq2r3n1tQ=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

i tested the EDIMAX EW-7612 on Raspberry Pi 3B+ with Linux 5.4-rc5
(multi_v7_defconfig + rtlwifi + kmemleak) and noticed a single memory
leak during probe:

unreferenced object 0xec13ee40 (size 176):
=C2=A0 comm "kworker/u8:1", pid 36, jiffies 4294939321 (age 5580.790s)
=C2=A0 hex dump (first 32 bytes):
=C2=A0=C2=A0=C2=A0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00=C2=A0 .=
...............
=C2=A0=C2=A0=C2=A0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00=C2=A0 .=
...............
=C2=A0 backtrace:
=C2=A0=C2=A0=C2=A0 [<fc1bbb3e>] __netdev_alloc_skb+0x9c/0x164
=C2=A0=C2=A0=C2=A0 [<863dfa6e>] rtl92c_set_fw_rsvdpagepkt+0x254/0x340 [rtl=
8192c_common]
=C2=A0=C2=A0=C2=A0 [<9572be0d>] rtl92cu_set_hw_reg+0xf48/0xfa4 [rtl8192cu]
=C2=A0=C2=A0=C2=A0 [<116df4d8>] rtl_op_bss_info_changed+0x234/0x96c [rtlwi=
fi]
=C2=A0=C2=A0=C2=A0 [<8933575f>] ieee80211_bss_info_change_notify+0xb8/0x26=
4 [mac80211]
=C2=A0=C2=A0=C2=A0 [<d4061e86>] ieee80211_assoc_success+0x934/0x1798 [mac8=
0211]
=C2=A0=C2=A0=C2=A0 [<e55adb56>] ieee80211_rx_mgmt_assoc_resp+0x174/0x314 [=
mac80211]
=C2=A0=C2=A0=C2=A0 [<5974629e>] ieee80211_sta_rx_queued_mgmt+0x3f4/0x7f0 [=
mac80211]
=C2=A0=C2=A0=C2=A0 [<d91091c6>] ieee80211_iface_work+0x208/0x318 [mac80211=
]
=C2=A0=C2=A0=C2=A0 [<ac5fcae4>] process_one_work+0x22c/0x564
=C2=A0=C2=A0=C2=A0 [<f5e6d3b6>] worker_thread+0x44/0x5d8
=C2=A0=C2=A0=C2=A0 [<82c7b073>] kthread+0x150/0x154
=C2=A0=C2=A0=C2=A0 [<b43e1b7d>] ret_from_fork+0x14/0x2c
=C2=A0=C2=A0=C2=A0 [<794dff30>] 0x0

It looks like the allocated skd is never freed.

Would be nice to get this fixed.

Regards
Stefan

