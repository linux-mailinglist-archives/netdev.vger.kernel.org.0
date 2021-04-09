Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12705359115
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 02:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233095AbhDIA4g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 20:56:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232426AbhDIA4g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 20:56:36 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37EE2C061760;
        Thu,  8 Apr 2021 17:56:24 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id t14so3394483ilu.3;
        Thu, 08 Apr 2021 17:56:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=UEdsZX4xRKTXy7Uhxf5TSkdKwTjEEWUxQ3XylhoYirQ=;
        b=qkr1UC9iVxiC/F7eKOS/bwa6AAfT+Q3NXwb9FTbHB3CRanaZclRhekzYIBgEADA668
         82oWjx+UzO6vHE0iQaZBEUZPG451oJ3G9uHKFPpgD1pXaALQ6odKuOgSvB/R20f+x1Ce
         MkM1NmbSOWP/5b/8quKpwGS4P0oQQSUlP4cxNI+r8RbUy/VoGeFtthhuXzld14cScrO9
         IE2rk5cIretqc4wPeFxiqFVIMQFBoTMIM6nAxPeVW2e6Gtm+MLrsbJygbY5MIOh6RYML
         9QYAsd+/Hyz3Bf+XGH7w8MbgRjRNPTAvnxuS01a8Nud8RyvyqK3/qQ8yPe2wI7TFcsZe
         S34Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=UEdsZX4xRKTXy7Uhxf5TSkdKwTjEEWUxQ3XylhoYirQ=;
        b=l/isTb9JAq2E4RGBiJ9W8b3TZbrBdYrcMOhGNqqD4yJwG7pc0PkOkGtPtouuDZBXbp
         nNHgsHa+jqlTA7HVkJMv2PyGO8WcfmawL1Lk65+R8Zmlm4SV6zd7l2dKqogJpsHf9Ud+
         ZnRwaPUOb7cnHfYRz5dx3w8Sj4Fv6+jIQWtfFJnmHtf0P1DH9t89JxRnHtFF0EeFTofV
         wED7nbV7h4f+KLOSoidC4seKmkFXvzM61ajjjbNUCm6T+ww39h7UnaxfJPX9RoZOaPK4
         j+V9nwU3jUynnf9o9u8lwNt+l6BtUARWDUMmnxnDalNz68/RUkScZP5EC0zChoqOsrwX
         Si2g==
X-Gm-Message-State: AOAM533vH5cXghFHfAv848GhNVCYZl8fnJFB9RsAvBo9dkZ/6qmKctmT
        4OPeWka/BaWun2Qr1REESj8=
X-Google-Smtp-Source: ABdhPJxhyOwfkTTc+MdVlfsb5am4+JwHytngO8T/7QAGvKIiJ53g41x+hLH8AT8i0oFwja9vzF4ysg==
X-Received: by 2002:a05:6e02:174d:: with SMTP id y13mr8881673ill.83.1617929783623;
        Thu, 08 Apr 2021 17:56:23 -0700 (PDT)
Received: from localhost ([172.242.244.146])
        by smtp.gmail.com with ESMTPSA id v17sm429789ios.46.2021.04.08.17.56.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Apr 2021 17:56:23 -0700 (PDT)
Date:   Thu, 08 Apr 2021 17:56:15 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        sameehj@amazon.com, john.fastabend@gmail.com, dsahern@kernel.org,
        brouer@redhat.com, echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com
Message-ID: <606fa62f6fe99_c8b920884@john-XPS-13-9370.notmuch>
In-Reply-To: <cover.1617885385.git.lorenzo@kernel.org>
References: <cover.1617885385.git.lorenzo@kernel.org>
Subject: RE: [PATCH v8 bpf-next 00/14] mvneta: introduce XDP multi-buffer
 support
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenzo Bianconi wrote:
> This series introduce XDP multi-buffer support. The mvneta driver is
> the first to support these new "non-linear" xdp_{buff,frame}. Reviewers=

> please focus on how these new types of xdp_{buff,frame} packets
> traverse the different layers and the layout design. It is on purpose
> that BPF-helpers are kept simple, as we don't want to expose the
> internal layout to allow later changes.
> =

> For now, to keep the design simple and to maintain performance, the XDP=

> BPF-prog (still) only have access to the first-buffer. It is left for
> later (another patchset) to add payload access across multiple buffers.=

> This patchset should still allow for these future extensions. The goal
> is to lift the XDP MTU restriction that comes with XDP, but maintain
> same performance as before.
> =

> The main idea for the new multi-buffer layout is to reuse the same
> layout used for non-linear SKB. We introduced a "xdp_shared_info" data
> structure at the end of the first buffer to link together subsequent bu=
ffers.
> xdp_shared_info will alias skb_shared_info allowing to keep most of the=
 frags
> in the same cache-line (while with skb_shared_info only the first fragm=
ent will
> be placed in the first "shared_info" cache-line). Moreover we introduce=
d some
> xdp_shared_info helpers aligned to skb_frag* ones.
> Converting xdp_frame to SKB and deliver it to the network stack is show=
n in
> patch 07/14. Building the SKB, the xdp_shared_info structure will be co=
nverted
> in a skb_shared_info one.
> =

> A multi-buffer bit (mb) has been introduced in xdp_{buff,frame} structu=
re
> to notify the bpf/network layer if this is a xdp multi-buffer frame (mb=
 =3D 1)
> or not (mb =3D 0).
> The mb bit will be set by a xdp multi-buffer capable driver only for
> non-linear frames maintaining the capability to receive linear frames
> without any extra cost since the xdp_shared_info structure at the end
> of the first buffer will be initialized only if mb is set.
> =

> Typical use cases for this series are:
> - Jumbo-frames
> - Packet header split (please see Google=EF=BF=BD=EF=BF=BD=EF=BF=BDs us=
e-case @ NetDevConf 0x14, [0])
> - TSO
> =

> A new frame_length field has been introduce in XDP ctx in order to noti=
fy the
> eBPF layer about the total frame size (linear + paged parts).
> =

> bpf_xdp_adjust_tail and bpf_xdp_copy helpers have been modified to take=
 into
> account xdp multi-buff frames.

I just read the commit messages for v8 so far. But, I'm still wondering h=
ow
to handle use cases where we want to put extra bytes at the end of the
packet, or really anywhere in the general case. We can extend tail with a=
bove
is there anyway to then write into that extra space?

I think most use cases will only want headers so we can likely make it =

a callout to a helper. Could we add something like, xdp_get_bytes(start, =
end)
to pull in the bytes?

My dumb pseudoprogram being something like,

  trailer[16] =3D {0,1,2,3,4,5,6,7,8,9,a,b,c,d,e}
  trailer_size =3D 16;
  old_end =3D xdp->length;
  new_end =3D xdp->length + trailer_size;

  err =3D bpf_xdp_adjust_tail(xdp, trailer_size)
  if (err) return err;

  err =3D xdp_get_bytes(xdp, old_end, new_end);
  if (err) return err;

  memcpy(xdp->data, trailer, trailer_size);

Do you think that could work if we code up xdp_get_bytes()? Does the driv=
er
have enough context to adjust xdp to map to my get_bytes() call? I think
so but we should check.

> =

> More info about the main idea behind this approach can be found here [1=
][2].

Thanks for working on this!=
