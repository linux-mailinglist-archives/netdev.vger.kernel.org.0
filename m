Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A054625ABE
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 01:22:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726875AbfEUXWa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 19:22:30 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:43331 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725797AbfEUXWa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 19:22:30 -0400
Received: by mail-io1-f68.google.com with SMTP id v7so320936iob.10;
        Tue, 21 May 2019 16:22:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Q+TOxNvlX4OyviLA1RMMAnEUapjGz0Q82sfanM+skJc=;
        b=qFPZr7y8GrOhJHCOmJ3nl//kksO7Ebe0V5SvKXhxrHvLgqsYt0/PoHOll73otofgsW
         V7L5WBRmxFahltaw21GCDLJQH2mI++72GFrCmcGEIS8jIDmN5UHxxQyUZzfgggL/qr6M
         HJeVzUElcvBQcWkeaOlyrvh+sg8rsshA0vwOf4jpCEZRJ2UDLrl5WkKsHgSTxGrDdxAL
         KUKVAyRx+fg9QnE174rHa2USw6MWmBpZs0SfCx6r0oOExOHYuKT13z74YE6giP1h/00S
         TjmdwxYrmQGbQLwAbKee9Ic9LaPzlF3AKLKYItgRcXPiMvbD+l4z6pxETYvYkrUvIjHt
         N5kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q+TOxNvlX4OyviLA1RMMAnEUapjGz0Q82sfanM+skJc=;
        b=qLT7z8EGK/+RZOXMY0phQKRhg2q0Ubco6sInkcygzGnnYj69IuIDCFLoMz9ti8p1UA
         SpCbh68OW4flpn7ZIzvUvZKhnksG1TzEHbSBosFhI8XinHcZ+66yJCECZh8kvmt9UDAn
         TSNoK7z5D/CsDQZ+TFwQFULSYKL5Lj/OPBYhkJjGgqhb0P+vh/YqyaGYOM5dkMEZVShM
         UlsxlVdtjqa+LqgJp46oz34+5SWNKmhXPISLbmzwrnCnXWvc7FsvXyHAW3d0WZHgyClp
         UMf13XC7g3mI6RR5z2Vl934/lDAbYDZMAAXyVjc6uSUdw47wXbPTWGOn69yj9CV0C8mq
         Ef3g==
X-Gm-Message-State: APjAAAXHRaKhSj7xZGnTDet4tspsh1CBOYlw3xbW6Q4UEeSJ7QXPSQVG
        342WDfdg8hYqNkErNWeep6NEDNI1iuitkCorg5o=
X-Google-Smtp-Source: APXvYqxBxEvRd9YFi6LWWFlur28HCvHHngZH+09V593lwkjxHdf3uJ5kPx5QMVyC/invnOt9PlR8dZVq5a4PAm0/JQw=
X-Received: by 2002:a5e:db08:: with SMTP id q8mr29298563iop.64.1558480948862;
 Tue, 21 May 2019 16:22:28 -0700 (PDT)
MIME-Version: 1.0
References: <20190514163443.glfjva3ofqcy7lbg@csclub.uwaterloo.ca>
 <CAKgT0UdPDyCBsShQVwwE5C8fBKkMcfS6_S5m3T7JP-So9fzVgA@mail.gmail.com>
 <20190516183407.qswotwyjwtjqfdqm@csclub.uwaterloo.ca> <20190516183705.e4zflbli7oujlbek@csclub.uwaterloo.ca>
 <CAKgT0UfSa-dM2+7xntK9tB7Zw5N8nDd3U1n4OSK0gbWbkNSKJQ@mail.gmail.com>
 <CAKgT0Ucd0s_0F5_nwqXknRngwROyuecUt+4bYzWvp1-2cNSg7g@mail.gmail.com>
 <20190517172317.amopafirjfizlgej@csclub.uwaterloo.ca> <CAKgT0UdM28pSTCsaT=TWqmQwCO44NswS0PqFLAzgs9pmn41VeQ@mail.gmail.com>
 <20190521151537.xga4aiq3gjtiif4j@csclub.uwaterloo.ca> <CAKgT0UfpZ-ve3Hx26gDkb+YTDHvN3=MJ7NZd2NE7ewF5g=kHHw@mail.gmail.com>
 <20190521175456.zlkiiov5hry2l4q2@csclub.uwaterloo.ca>
In-Reply-To: <20190521175456.zlkiiov5hry2l4q2@csclub.uwaterloo.ca>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Tue, 21 May 2019 16:22:17 -0700
Message-ID: <CAKgT0UcR3q1maBmJz7xj_i+_oux_6FQxua9DOjXQSZzyq6FhkQ@mail.gmail.com>
Subject: Re: [Intel-wired-lan] i40e X722 RSS problem with NAT-Traversal IPsec packets
To:     Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        e1000-devel@lists.sourceforge.net
Content-Type: multipart/mixed; boundary="00000000000059aa6005896e1fad"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--00000000000059aa6005896e1fad
Content-Type: text/plain; charset="UTF-8"

On Tue, May 21, 2019 at 10:55 AM Lennart Sorensen
<lsorense@csclub.uwaterloo.ca> wrote:
>
> On Tue, May 21, 2019 at 09:51:33AM -0700, Alexander Duyck wrote:
> > I think we need to narrow this down a bit more. Let's try forcing the
> > lookup table all to one value and see if traffic is still going to
> > queue 0.
> >
> > Specifically what we need to is run the following command to try and
> > force all RSS traffic to queue 8, you can verify the result with
> > "ethtool -x":
> > ethtool -X <iface> weight 0 0 0 0 0 0 0 0 1
> >
> > If that works and the IPSec traffic goes to queue 8 then we are likely
> > looking at some sort of input issue, either in the parsing or the
> > population of things like the input mask that we can then debug
> > further.
> >
> > If traffic still goes to queue 0 then that tells us the output of the
> > RSS hash and lookup table are being ignored, this would imply either
> > some other filter is rerouting the traffic or is directing us to limit
> > the queue index to 0 bits.
>
> # ethtool -x eth2
> RX flow hash indirection table for eth2 with 12 RX ring(s):
>     0:      7     7     7     7     7     7     7     7
>     8:      7     7     7     7     7     7     7     7
>    16:      7     7     7     7     7     7     7     7
>    24:      7     7     7     7     7     7     7     7
>    32:      7     7     7     7     7     7     7     7
> ...
>   472:      7     7     7     7     7     7     7     7
>   480:      7     7     7     7     7     7     7     7
>   488:      7     7     7     7     7     7     7     7
>   496:      7     7     7     7     7     7     7     7
>   504:      7     7     7     7     7     7     7     7
> RSS hash key:
> 0b:1f:ae:ed:60:04:7d:e5:8a:2b:43:3f:1d:ee:6c:99:89:29:94:b0:25:db:c7:4b:fa:da:4d:3f:e8:cc:bc:00:ad:32:01:d6:1c:30:3f:f8:79:3e:f4:48:04:1f:51:d2:5a:39:f0:90
> root@ECA:~# ethtool --show-priv-flags eth2
> Private flags for eth2:
> MFP              : off
> LinkPolling      : off
> flow-director-atr: off
> veb-stats        : off
> hw-atr-eviction  : on
> legacy-rx        : off
>
> All ipsec packets are still hitting queue 0.
>
> Seems it is completely ignoring RSS for these packets.  That is
> impressively weird.
>
> --
> Len Sorensen

So we are either using 0 bits of the LUT or we are just not performing
hashing because this is somehow being parsed into a type that doesn't
support it.

I have attached 2 more patches we can test. The first enables hashing
on what are called "OAM" packets, The thing is we shouldn't be
identifying these packets as "OAM", Operations Administration &
Management, as normally it would have to be recognized as a tunnel
first and then have a specific flag set in either the GENEVE or
VXLAN-GPE header. The second patch will dump the contents of the
HREGION registers. They should all be 0, however I thought it best to
dump the contents and verify that since I know that these registers
can be used to change the traffic class of a given packet type and if
we are encountering that it might be moving it to an uninitialized TC
which would be using queue offset 0 with 0 bits of the LUT.

These last 2 patches would pretty much eliminate the entire RSS
subsystem. If we don't see HREGION values set and the OAM flags have
no effect I can only assume there is something going on with the
parser in the NIC since it isn't recognizing the packet type.

Thanks.

- Alex

--00000000000059aa6005896e1fad
Content-Type: text/x-patch; charset="US-ASCII"; name="i40e-enable-oam-flag-tunnel.patch"
Content-Disposition: attachment; 
	filename="i40e-enable-oam-flag-tunnel.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_jvydbsln1>
X-Attachment-Id: f_jvydbsln1

aTQwZTogRW5hYmxlIE9BTSBmbGFnIHR1bm5lbCBoYXNoaW5nCgpGcm9tOiBBbGV4YW5kZXIgRHV5
Y2sgPGFsZXhhbmRlci5oLmR1eWNrQGxpbnV4LmludGVsLmNvbT4KCkFkZCBzdXBwb3J0IGZvciBo
YXNoaW5nIHBhY2tldCB0eXBlcyAyNiBhbmQgMjcgb24gWDcyMiBhZGFwdGVycy4gVGhlCmRlZmF1
bHQgaW5wdXQgc2V0IGlzIHN1cHBvc2VkIHRvIGJlIHNvdXJjZSBvdXRlciBVRFAgYW5kIFZOSS4g
Rm9yIG5vdyBhbGwgSQpjYXJlIGFib3V0IGlzIGVuYWJsaW5nIGhhc2hpbmcgb24gdGhpcyB0byBz
ZWUgaWYgd2UgY2FuIGdldCBFU1AgdHJhZmZpYyB0bwpub3QgaGl0IHF1ZXVlIDAgZm9yIGV2ZXJ5
dGhpbmcuCi0tLQogZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaTQwZS9pNDBlX3R4cnguaCB8
ICAgIDMgKystCiAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0p
CgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaTQwZS9pNDBlX3R4cngu
aCBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2k0MGUvaTQwZV90eHJ4LmgKaW5kZXggMTAw
ZTkyZDI5ODJmLi5hZDNlMTZlOGNkN2EgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0
L2ludGVsL2k0MGUvaTQwZV90eHJ4LmgKKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwv
aTQwZS9pNDBlX3R4cnguaApAQCAtOTUsNyArOTUsOCBAQCBlbnVtIGk0MGVfZHluX2lkeF90IHsK
IAlCSVRfVUxMKEk0MEVfRklMVEVSX1BDVFlQRV9OT05GX01VTFRJQ0FTVF9JUFY0X1VEUCkgfCBc
CiAJQklUX1VMTChJNDBFX0ZJTFRFUl9QQ1RZUEVfTk9ORl9JUFY2X1RDUF9TWU5fTk9fQUNLKSB8
IFwKIAlCSVRfVUxMKEk0MEVfRklMVEVSX1BDVFlQRV9OT05GX1VOSUNBU1RfSVBWNl9VRFApIHwg
XAotCUJJVF9VTEwoSTQwRV9GSUxURVJfUENUWVBFX05PTkZfTVVMVElDQVNUX0lQVjZfVURQKSkK
KwlCSVRfVUxMKEk0MEVfRklMVEVSX1BDVFlQRV9OT05GX01VTFRJQ0FTVF9JUFY2X1VEUCkgfCBc
CisJQklUX1VMTCgyNikgfCBCSVRfVUxMKDI3KSkgLyogQWRkZWQgYml0cyBmb3IgdHVubmVsIE9B
TSAqLwogCiAjZGVmaW5lIGk0MGVfcGZfZ2V0X2RlZmF1bHRfcnNzX2hlbmEocGYpIFwKIAkoKChw
ZiktPmh3X2ZlYXR1cmVzICYgSTQwRV9IV19NVUxUSVBMRV9UQ1BfVURQX1JTU19QQ1RZUEUpID8g
XAo=
--00000000000059aa6005896e1fad
Content-Type: text/x-patch; charset="US-ASCII"; name="i40e-dump-extra-hregion.patch"
Content-Disposition: attachment; filename="i40e-dump-extra-hregion.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_jvydbslb0>
X-Attachment-Id: f_jvydbslb0

aTQwZTogRHVtcCBIUkVHSU9OIGVudHJpZXMKCkZyb206IEFsZXhhbmRlciBEdXljayA8YWxleGFu
ZGVyLmguZHV5Y2tAbGludXguaW50ZWwuY29tPgoKCi0tLQogZHJpdmVycy9uZXQvZXRoZXJuZXQv
aW50ZWwvaTQwZS9pNDBlX21haW4uYyB8ICAgIDggKysrKysrKysKIDEgZmlsZSBjaGFuZ2VkLCA4
IGluc2VydGlvbnMoKykKCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9p
NDBlL2k0MGVfbWFpbi5jIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaTQwZS9pNDBlX21h
aW4uYwppbmRleCAzMjA1NjJiMzk2ODYuLjM3MGY2NmRmNGU0ZiAxMDA2NDQKLS0tIGEvZHJpdmVy
cy9uZXQvZXRoZXJuZXQvaW50ZWwvaTQwZS9pNDBlX21haW4uYworKysgYi9kcml2ZXJzL25ldC9l
dGhlcm5ldC9pbnRlbC9pNDBlL2k0MGVfbWFpbi5jCkBAIC0xMTA5NCw2ICsxMTA5NCwxNCBAQCBz
dGF0aWMgaW50IGk0MGVfcGZfY29uZmlnX3JzcyhzdHJ1Y3QgaTQwZV9wZiAqcGYpCiAJdTY0IGhl
bmE7CiAJaW50IHJldDsKIAorCS8qIFRoZXNlIHNob3VsZCBhbGwgYmUgMCwgZHVtcCB0aGVtIHRv
IHZlcmlmeSB0aGV5IGFyZSAqLworCWZvciAocmV0ID0gODsgcmV0LS07KSB7CisJCXJlZ192YWwg
PSBpNDBlX3JlYWRfcnhfY3RsKGh3LCBJNDBFX1BGUUZfSFJFR0lPTihyZXQpKTsKKworCQlkZXZf
aW5mbygmcGYtPnBkZXYtPmRldiwKKwkJCSAiUEZRRl9IUkVHSU9OWyVkXTogMHglMDh4XG4iLCBy
ZXQsIHJlZ192YWwpOworCX0KKwogCS8qIEJ5IGRlZmF1bHQgd2UgZW5hYmxlIFRDUC9VRFAgd2l0
aCBJUHY0L0lQdjYgcHR5cGVzICovCiAJaGVuYSA9ICh1NjQpaTQwZV9yZWFkX3J4X2N0bChodywg
STQwRV9QRlFGX0hFTkEoMCkpIHwKIAkJKCh1NjQpaTQwZV9yZWFkX3J4X2N0bChodywgSTQwRV9Q
RlFGX0hFTkEoMSkpIDw8IDMyKTsK
--00000000000059aa6005896e1fad--
