Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60479E9C62
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 14:34:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726513AbfJ3NeF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 09:34:05 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:38675 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726209AbfJ3NeF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 09:34:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572442443;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/yfV7mAwap9xE4doXKmlY5Fg862APAqsO952Ql5bPWU=;
        b=QVjpFGeBr25F9Iepfbe68rq2LYwxhfvkuiQqPqvqB6UyAqa9NpeabTG2ku3KB7YvL8Qknj
        gE4GYEgWLEdrEvVEz4sEM+0Gv3gFuxQipJDUpnRp/zvabiblh7tQDrNMxl7rlskMzqrk2i
        xU9COovxqnlLNKUz31kyKj/AmLV/fV8=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-103-CQF6LimVMPysxktcOUm0Lw-1; Wed, 30 Oct 2019 09:34:02 -0400
Received: by mail-lj1-f198.google.com with SMTP id i18so632275ljg.14
        for <netdev@vger.kernel.org>; Wed, 30 Oct 2019 06:34:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=/yfV7mAwap9xE4doXKmlY5Fg862APAqsO952Ql5bPWU=;
        b=R+2YkydKUNEc5d0GmDzZOKJRE27hVSW1w283XkVURZGKtVHW6uarhGzbK5nxhjuF12
         EPjvqPYcSz+PwaFxuBA259U8AZTrhBnjRH40oU5eugj3xtic1ypbw9cFok1fsmhIeXqd
         6yb9Uy5wsCdMz6OFhikNitJ8QE+yJhkda//0WglC4DONRTqOw0xcU6on/DAdWSzTp258
         uqk7dXdzdn8KI7t69IW3K7YmgXuGbQS22Edewx2bB+CSDOHF6Njcq8asLTEmtN1asoQw
         3aWqE60ldo7GkCOCTrESbf9N75Kc3w4j9E5aAiLYnLVpQOMwVMKr5/ucfJiDqjv6g8j9
         oF8w==
X-Gm-Message-State: APjAAAWQsGesePZdeZK6F4dukQPm3x530XRXdvM9x0CYvtnZtyCXJQiP
        JuHkdrwMlEAVVgxesBwdIzERR2AQeCTNFs8umfsIi0dPnF8JSbEz+f9wTFXXNSKZ9iJXt8pea8w
        XdKyiMsXVknXIcF8V
X-Received: by 2002:a2e:481:: with SMTP id a1mr6840676ljf.209.1572442440576;
        Wed, 30 Oct 2019 06:34:00 -0700 (PDT)
X-Google-Smtp-Source: APXvYqx04gjfhdWvERCCRcdDRxQA/3nUSdUoktgDKW4u9jhkQF+xVo46F0PDD71b3/NGSY0G2uRiyQ==
X-Received: by 2002:a2e:481:: with SMTP id a1mr6840663ljf.209.1572442440351;
        Wed, 30 Oct 2019 06:34:00 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id d3sm37748lfm.83.2019.10.30.06.33.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Oct 2019 06:33:59 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 507E31818B3; Wed, 30 Oct 2019 14:33:58 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Magnus Karlsson <magnus.karlsson@intel.com>,
        magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com
Cc:     bpf@vger.kernel.org, degeneloy@gmail.com, john.fastabend@gmail.com
Subject: Re: [PATCH bpf-next v3] libbpf: fix compatibility for kernels without need_wakeup
In-Reply-To: <1571995035-21889-1-git-send-email-magnus.karlsson@intel.com>
References: <1571995035-21889-1-git-send-email-magnus.karlsson@intel.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 30 Oct 2019 14:33:58 +0100
Message-ID: <87tv7qpdbt.fsf@toke.dk>
MIME-Version: 1.0
X-MC-Unique: CQF6LimVMPysxktcOUm0Lw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Magnus Karlsson <magnus.karlsson@intel.com> writes:

> When the need_wakeup flag was added to AF_XDP, the format of the
> XDP_MMAP_OFFSETS getsockopt was extended. Code was added to the
> kernel to take care of compatibility issues arrising from running
> applications using any of the two formats. However, libbpf was
> not extended to take care of the case when the application/libbpf
> uses the new format but the kernel only supports the old
> format. This patch adds support in libbpf for parsing the old
> format, before the need_wakeup flag was added, and emulating a
> set of static need_wakeup flags that will always work for the
> application.

Hi Magnus

While you're looking at backwards compatibility issues with xsk: libbpf
currently fails to compile on a system that has old kernel headers
installed (this is with kernel-headers 5.3):

$ echo "#include <bpf/xsk.h>" | gcc -x c -=20
In file included from <stdin>:1:
/usr/include/bpf/xsk.h: In function =E2=80=98xsk_ring_prod__needs_wakeup=E2=
=80=99:
/usr/include/bpf/xsk.h:82:21: error: =E2=80=98XDP_RING_NEED_WAKEUP=E2=80=99=
 undeclared (first use in this function)
   82 |  return *r->flags & XDP_RING_NEED_WAKEUP;
      |                     ^~~~~~~~~~~~~~~~~~~~
/usr/include/bpf/xsk.h:82:21: note: each undeclared identifier is reported =
only once for each function it appears in
/usr/include/bpf/xsk.h: In function =E2=80=98xsk_umem__extract_addr=E2=80=
=99:
/usr/include/bpf/xsk.h:173:16: error: =E2=80=98XSK_UNALIGNED_BUF_ADDR_MASK=
=E2=80=99 undeclared (first use in this function)
  173 |  return addr & XSK_UNALIGNED_BUF_ADDR_MASK;
      |                ^~~~~~~~~~~~~~~~~~~~~~~~~~~
/usr/include/bpf/xsk.h: In function =E2=80=98xsk_umem__extract_offset=E2=80=
=99:
/usr/include/bpf/xsk.h:178:17: error: =E2=80=98XSK_UNALIGNED_BUF_OFFSET_SHI=
FT=E2=80=99 undeclared (first use in this function)
  178 |  return addr >> XSK_UNALIGNED_BUF_OFFSET_SHIFT;
      |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



How would you prefer to handle this? A patch like the one below will fix
the compile errors, but I'm not sure it makes sense semantically?

-Toke

diff --git a/tools/lib/bpf/xsk.h b/tools/lib/bpf/xsk.h
index 584f6820a639..954d66e85208 100644
--- a/tools/lib/bpf/xsk.h
+++ b/tools/lib/bpf/xsk.h
@@ -79,7 +79,11 @@ xsk_ring_cons__rx_desc(const struct xsk_ring_cons *rx, _=
_u32 idx)
=20
 static inline int xsk_ring_prod__needs_wakeup(const struct xsk_ring_prod *=
r)
 {
+#ifdef XDP_RING_NEED_WAKEUP
        return *r->flags & XDP_RING_NEED_WAKEUP;
+#else
+       return 0;
+#endif
 }
=20
 static inline __u32 xsk_prod_nb_free(struct xsk_ring_prod *r, __u32 nb)
@@ -170,12 +174,20 @@ static inline void *xsk_umem__get_data(void *umem_are=
a, __u64 addr)
=20
 static inline __u64 xsk_umem__extract_addr(__u64 addr)
 {
+#ifdef XSK_UNALIGNED_BUF_ADDR_MASK
        return addr & XSK_UNALIGNED_BUF_ADDR_MASK;
+#else
+       return addr;
+#endif
 }
=20
 static inline __u64 xsk_umem__extract_offset(__u64 addr)
 {
+#ifdef XSK_UNALIGNED_BUF_OFFSET_SHIFT
        return addr >> XSK_UNALIGNED_BUF_OFFSET_SHIFT;
+#else
+       return 0;
+#endif
 }
=20
 static inline __u64 xsk_umem__add_offset_to_addr(__u64 addr)

