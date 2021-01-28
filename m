Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67D3E306B74
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 04:13:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231243AbhA1DMI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 22:12:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231172AbhA1DME (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 22:12:04 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB412C061574
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 19:11:23 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id ox12so5686189ejb.2
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 19:11:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iSXKHuqX16ALxzUoSy/hBtq1QhqZ3GJweBZG7loB3G4=;
        b=kGmnXGgqYkp6VxUfTdwYurUEw8gwbCnlaOXKe+f602ViPNE9frXaD3Vk6SPzwUoJKQ
         nc0ARdrgO7T04++G/dBevaZZpB+XZjOEA2XtdaMq1gAnh6kxQ0zbIlWSfphUke4VQKvJ
         x6EYEM7JAAeyUAGsnzLyPS3HfrGVrAawgDM4VnHfAfk7xHJddzRUiZKEnDL+4J50qNdg
         gd5QzlMb4ACbq+N/fQx1r1acd54tV+QzxXgIb5B3XdyX4ubDPXU2prYeYvj+PMsrXaP/
         KeKAOsYBlN0ELTesdf4YU8kuP9Jwkk5zz9Py06bCM4J5S5ghObqQ2v0ZB6sCf9x3Tcvq
         ngSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iSXKHuqX16ALxzUoSy/hBtq1QhqZ3GJweBZG7loB3G4=;
        b=Pnh4guq1AkQDy5M9WgEvxS9wEG3TLnCdWyt0D0sgJxt8rSfh3RspuA7nIuZ6bcT0P2
         mRAdpFovqdDafQH1Gk463PnIEOVypV8dBC/cxGSUmxeiqXkPQ08kPUAQM7b56RY9+f++
         z0tZE3DQOl0euFiK8X0VELpHYjtnpnq6ro2d6ScyHCjdVuSzInfNKGS1RfjruL0eNKN2
         GwmIFlPekTPYC0Y/3veb2b+076M0unlVwLVPT9I1vtP+Dfi3dmATqUgrzVlMnygsgH0u
         4OprWuTg6NkOLB2loj04iB9hsZCW3CoBHWeYjBamRIsT0p/uhy2751dsmZFqtMwzMwPH
         7wlw==
X-Gm-Message-State: AOAM5335FUdDJoEYynmJIFSgdqcHO+bmoGaumOCiNI7ehghfHL74F+UB
        /CZopxUEp5pXck3fvI7YyrpVPS0/Js90+KthOHVE97Bi3CM=
X-Google-Smtp-Source: ABdhPJw310+0P5juiR6mpZMHiBwcRRa8Xm5g+TTvr51ny8cnScKgBEKkFqEhD7dTIJ4UmdCmvukOPKBmaP8+hz1pRX8=
X-Received: by 2002:a17:906:3b16:: with SMTP id g22mr8881916ejf.504.1611803482656;
 Wed, 27 Jan 2021 19:11:22 -0800 (PST)
MIME-Version: 1.0
References: <20210126141248.GA27281@optiplex> <CA+FuTSez-w-Y6LfXxEcqbB5QucPRfCEFmCd5a4LtOGcyOjGOug@mail.gmail.com>
 <CA+FuTSd_=nL7sycEYKSUbGVoC56V3Wyc=zLMo+mQ9mjC4i8_gw@mail.gmail.com>
 <CAF=yD-Ja=kzq4KaraUd_dV7Z2joR009VLjhkpu8DK2DSUX-n9Q@mail.gmail.com> <CAF=yD-+qFQHqLaYjq4x=rGjNZf_K9FSQiV-7Toqi3np+Cbq_vA@mail.gmail.com>
In-Reply-To: <CAF=yD-+qFQHqLaYjq4x=rGjNZf_K9FSQiV-7Toqi3np+Cbq_vA@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 27 Jan 2021 22:10:46 -0500
Message-ID: <CAF=yD-JuHy8yf88RR_=K+r_3SwhwzqRtHrK08-WF4BkwMNk-LQ@mail.gmail.com>
Subject: Re: UDP implementation and the MSG_MORE flag
To:     oliver.graute@gmail.com
Cc:     Network Development <netdev@vger.kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Paolo Abeni <pabeni@redhat.com>, sagi@lightbitslabs.com,
        Christoph Hellwig <hch@lst.de>, sagi@grimberg.me,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 27, 2021 at 9:53 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Tue, Jan 26, 2021 at 10:25 PM Willem de Bruijn
> <willemdebruijn.kernel@gmail.com> wrote:
> >
> > On Tue, Jan 26, 2021 at 5:00 PM Willem de Bruijn
> > <willemdebruijn.kernel@gmail.com> wrote:
> > >
> > > On Tue, Jan 26, 2021 at 4:54 PM Willem de Bruijn
> > > <willemdebruijn.kernel@gmail.com> wrote:
> > > >
> > > > On Tue, Jan 26, 2021 at 9:58 AM Oliver Graute <oliver.graute@gmail.com> wrote:
> > > > >
> > > > > Hello,
> > > > >
> > > > > we observe some unexpected behavior in the UDP implementation of the
> > > > > linux kernel.
> > > > >
> > > > > Some UDP packets send via the loopback interface are dropped in the
> > > > > kernel on the receive side when using sendto with the MSG_MORE flag.
> > > > > Every drop increases the InCsumErrors in /proc/self/net/snmp. Some
> > > > > example code to reproduce it is appended below.
> > > > >
> > > > > In the code we tracked it down to this code section. ( Even a little
> > > > > further but its unclear to me wy the csum() is wrong in the bad case)
> > > > >
> > > > > udpv6_recvmsg()
> > > > > ...
> > > > > if (checksum_valid || udp_skb_csum_unnecessary(skb)) {
> > > > >                 if (udp_skb_is_linear(skb))
> > > > >                         err = copy_linear_skb(skb, copied, off, &msg->msg_iter);
> > > > >                 else
> > > > >                         err = skb_copy_datagram_msg(skb, off, msg, copied);
> > > > >         } else {
> > > > >                 err = skb_copy_and_csum_datagram_msg(skb, off, msg);
> > > > >                 if (err == -EINVAL) {
> > > > >                         goto csum_copy_err;
> > > > >                 }
> > > > >         }
> > > > > ...
> > > > >
> > > >
> > > > Thanks for the report with a full reproducer.
> > > >
> > > > I don't have a full answer yet, but can reproduce this easily.
> > > >
> > > > The third program, without MSG_MORE, builds an skb with
> > > > CHECKSUM_PARTIAL in __ip_append_data. When looped to the receive path
> > > > that ip_summed means no additional validation is needed. As encoded in
> > > > skb_csum_unnecessary.
> > > >
> > > > The first and second programs are essentially the same, bar for a
> > > > slight difference in length. In both cases packet length is very short
> > > > compared to the loopback device MTU. Because of MSG_MORE, these
> > > > packets have CHECKSUM_NONE.
> > > >
> > > > On receive in
> > > >
> > > >   __udp4_lib_rcv()
> > > >     udp4_csum_init()
> > > >       err = skb_checksum_init_zero_check()
> > > >
> > > > The second program validates and sets ip_summed = CHECKSUM_COMPLETE
> > > > and csum_valid = 1.
> > > > The first does not, though err == 0.
> > > >
> > > > This appears to succeed consistently for packets <= 68B of payload,
> > > > fail consistently otherwise. It is not clear to me yet what causes
> > > > this distinction.
> > >
> > > This is from
> > >
> > > "
> > > /* For small packets <= CHECKSUM_BREAK perform checksum complete directly
> > >  * in checksum_init.
> > >  */
> > > #define CHECKSUM_BREAK 76
> > > "
> > >
> > > So the small packet gets checksummed immediately in
> > > __skb_checksum_validate_complete, but the larger one does not.
> > >
> > > Question is why the copy_and_checksum you pointed to seems to fail checksum.
> >
> > Manually calling __skb_checksum_complete(skb) in
> > skb_copy_and_csum_datagram_msg succeeds, so it is the
> > skb_copy_and_csum_datagram that returns an incorrect csum.
> >
> > Bisection shows that this is a regression in 5.0, between
> >
> > 65d69e2505bb datagram: introduce skb_copy_and_hash_datagram_iter helper (fail)
> > d05f443554b3 iov_iter: introduce hash_and_copy_to_iter helper
> > 950fcaecd5cc datagram: consolidate datagram copy to iter helpers
> > cb002d074dab iov_iter: pass void csum pointer to csum_and_copy_to_iter (pass)
> >
> > That's a significant amount of code change. I'll take a closer look,
> > but checkpointing state for now..
>
> Key difference is the csum_block_add when handling frags, and the
> removal of temporary csum2.
>
> In the reproducer, there is one 13B csum_and_copy_to_iter from
> skb->data + offset, followed by a 73B csum_and_copy_to_iter from the
> first frag. So the second one passes pos 13 to csum_block_add.
>
> The original implementation of skb_copy_and_csum_datagram similarly
> fails the test, if we fail to account for the position
>
> -                       *csump = csum_block_add(*csump, csum2, pos);
> +                       *csump = csum_block_add(*csump, csum2, 0);

One possible approach:

diff --git a/net/core/datagram.c b/net/core/datagram.c
index 81809fa735a7..56bd0c32fa65 100644
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -721,8 +721,10 @@ static int skb_copy_and_csum_datagram(const
struct sk_buff *skb, int offset,
                                      struct iov_iter *to, int len,
                                      __wsum *csump)
 {
+       struct csum_iter csdata = { .csump = csump };
+
        return __skb_datagram_iter(skb, offset, to, len, true,
-                       csum_and_copy_to_iter, csump);
+                       csum_and_copy_to_iter, &csdata);
 }
diff --git a/include/linux/uio.h b/include/linux/uio.h
index 72d88566694e..7ce4f403a03f 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -260,7 +260,12 @@ static inline void iov_iter_reexpand(struct
iov_iter *i, size_t count)
 {
        i->count = count;
 }
-size_t csum_and_copy_to_iter(const void *addr, size_t bytes, void
*csump, struct iov_iter *i);
+
+struct csum_iter {
+       void *csump;
+       int off;
+};
+size_t csum_and_copy_to_iter(const void *addr, size_t bytes, void
*csdata, struct iov_iter *i);
 size_t csum_and_copy_from_iter(void *addr, size_t bytes, __wsum
*csum, struct iov_iter *i);
 bool csum_and_copy_from_iter_full(void *addr, size_t bytes, __wsum
*csum, struct iov_iter *i);
 size_t hash_and_copy_to_iter(const void *addr, size_t bytes, void *hashp,
diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index a21e6a5792c5..2e6e24f7dfe1 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -1522,13 +1522,13 @@ bool csum_and_copy_from_iter_full(void *addr,
size_t bytes, __wsum *csum,
 }
 EXPORT_SYMBOL(csum_and_copy_from_iter_full);

-size_t csum_and_copy_to_iter(const void *addr, size_t bytes, void *csump,
+size_t csum_and_copy_to_iter(const void *addr, size_t bytes, void *_csdata,
                             struct iov_iter *i)
 {
+       struct csum_iter *csdata = _csdata;
        const char *from = addr;
-       __wsum *csum = csump;
+       __wsum *csum = csdata->csump;
        __wsum sum, next;
-       size_t off = 0;

        if (unlikely(iov_iter_is_pipe(i)))
                return csum_and_copy_to_pipe_iter(addr, bytes, csum, i);
@@ -1543,22 +1543,22 @@ size_t csum_and_copy_to_iter(const void *addr,
size_t bytes, void *csump,
                                             v.iov_base,
                                             v.iov_len);
                if (next) {
-                       sum = csum_block_add(sum, next, off);
-                       off += v.iov_len;
+                       sum = csum_block_add(sum, next, csdata->off);
+                       csdata->off += v.iov_len;
                }
                next ? 0 : v.iov_len;
        }), ({
                char *p = kmap_atomic(v.bv_page);
                sum = csum_and_memcpy(p + v.bv_offset,
                                      (from += v.bv_len) - v.bv_len,
-                                     v.bv_len, sum, off);
+                                     v.bv_len, sum, csdata->off);
                kunmap_atomic(p);
-               off += v.bv_len;
+               csdata->off += v.bv_len;
        }),({
                sum = csum_and_memcpy(v.iov_base,
                                     (from += v.iov_len) - v.iov_len,
-                                    v.iov_len, sum, off);
-               off += v.iov_len;
+                                    v.iov_len, sum, csdata->off);
+               csdata->off += v.iov_len;
        })
        )
        *csum = sum;
