Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7695240046A
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 19:57:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350355AbhICR6u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 13:58:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57718 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1349967AbhICR6t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 13:58:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630691868;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Twv1Frpa8K4MzmT8jpLTv8Z81z6nimrFuVhAjS15+48=;
        b=XXZ2hPUCXX8i2nl8rdcEof2rIRUU+CM5PVxgWrsePs689FMurB1a2549pYKJZd4bLHIeYo
        TCMZb4lqFNTOX0GD4Yb2yTpz9w5jXuQKujXhk4GVnUcYAnm+Wh5/J8mBqQxT1TltCVN21E
        ZWXJ8JP6zXWUOY09GTap9C19arRssI4=
Received: from mail-yb1-f199.google.com (mail-yb1-f199.google.com
 [209.85.219.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-439-XUFW9EjdNgGSIg5l-wZPpw-1; Fri, 03 Sep 2021 13:57:47 -0400
X-MC-Unique: XUFW9EjdNgGSIg5l-wZPpw-1
Received: by mail-yb1-f199.google.com with SMTP id k15-20020a25240f000000b0059efafc5a58so5469723ybk.11
        for <netdev@vger.kernel.org>; Fri, 03 Sep 2021 10:57:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Twv1Frpa8K4MzmT8jpLTv8Z81z6nimrFuVhAjS15+48=;
        b=aYZWsstyTFeAmjoj922mvecf6ErxeD/71FvuhYc+KWgnZakiP/ae6mcBylygiTxzY0
         9NsVFKtIe5NIAq1DFd8NtpAHrJsrTY4KBLNrpu6Z8DEnT9i9D1MGsI72X0L+S1lSfQ6j
         Id6tmShp4v07AROzxGWK1/iZwpkZWHnvIpPtrkThUKAXQkyKdbhznbYQ3K6rooGEYW31
         Qy1GFuBn87Yn11PiSY/riVkaZHGY7boaE9bd8Oiu8b9mOmgXZ/HO5k+hyIBPG+1kYjjj
         0VGBLFkh86JvxiCukp4XCleKlCRx6Ic6WBP3TgkeLZU5fgbRg07WIS8HV4BgqyY83E++
         mrpA==
X-Gm-Message-State: AOAM532esW6XNed0qWb2yYIWuYyKHFrRKWrdD7X0iPVvJC98Ld7V2k1y
        OhzYd9BGvP2KzQgSsT1IY5dOrLud0kwc2mfuMHJaI7IqDSQzy8zgMARtc8EPgqdcyVeH+rQ/Z1g
        QvT6cGkg3Rzcx+YwRgexRlMYqF4bN+QLg
X-Received: by 2002:a25:27c1:: with SMTP id n184mr368380ybn.496.1630691866942;
        Fri, 03 Sep 2021 10:57:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwnmvzaERUxcreGEzkqeG0FqvGW198r8CZnCmObJT/+i91Ku1HeyVDtgchE4FBRvysamLeDes030dILckwE19E=
X-Received: by 2002:a25:27c1:: with SMTP id n184mr368345ybn.496.1630691866589;
 Fri, 03 Sep 2021 10:57:46 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1629473233.git.lorenzo@kernel.org> <14b99bc75ce0f8d4968208fb0b420a054e45433e.1629473234.git.lorenzo@kernel.org>
 <612ecb262b05_6b87208c0@john-XPS-13-9370.notmuch>
In-Reply-To: <612ecb262b05_6b87208c0@john-XPS-13-9370.notmuch>
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Date:   Fri, 3 Sep 2021 19:57:35 +0200
Message-ID: <CAJ0CqmW+LuUvwiV_iuog60H1mkne5edgpWGt5Pyd9uMRaCA0BA@mail.gmail.com>
Subject: Re: [PATCH v12 bpf-next 17/18] net: xdp: introduce
 bpf_xdp_adjust_data helper
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>,
        BPF-dev-list <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Agroskin, Shay" <shayagr@amazon.com>,
        David Ahern <dsahern@kernel.org>,
        Jesper Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "Sarkar, Tirthendu" <tirthendu.sarkar@intel.com>,
        Toke Hoiland Jorgensen <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>
> Lorenzo Bianconi wrote:
> > For XDP frames split over multiple buffers, the xdp_md->data and
> > xdp_md->data_end pointers will point to the start and end of the first
> > fragment only. bpf_xdp_adjust_data can be used to access subsequent
> > fragments by moving the data pointers. To use, an XDP program can call
> > this helper with the byte offset of the packet payload that
> > it wants to access; the helper will move xdp_md->data and xdp_md ->data_end
> > so they point to the requested payload offset and to the end of the
> > fragment containing this byte offset, and return the byte offset of the
> > start of the fragment.
> > To move back to the beginning of the packet, simply call the
> > helper with an offset of '0'.
> > Note also that the helpers that modify the packet boundaries
> > (bpf_xdp_adjust_head(), bpf_xdp_adjust_tail() and
> > bpf_xdp_adjust_meta()) will fail if the pointers have been
> > moved; it is the responsibility of the BPF program to move them
> > back before using these helpers.
>
> I'm ok with this for a first iteration I guess with more work we
> can make the helpers use the updated pointers though.
>
> >
> > Suggested-by: John Fastabend <john.fastabend@gmail.com>
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
>
> Overall looks good couple small nits/questions below. Thanks!
>
> > ---
> >  include/net/xdp.h              |  8 +++++
> >  include/uapi/linux/bpf.h       | 32 ++++++++++++++++++
> >  net/bpf/test_run.c             |  8 +++++
> >  net/core/filter.c              | 62 +++++++++++++++++++++++++++++++++-
> >  tools/include/uapi/linux/bpf.h | 32 ++++++++++++++++++
> >  5 files changed, 141 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/net/xdp.h b/include/net/xdp.h
> > index cdaecf8d4d61..ce4764c7cd40 100644
> > --- a/include/net/xdp.h
> > +++ b/include/net/xdp.h
> > @@ -82,6 +82,11 @@ struct xdp_buff {
> >       struct xdp_txq_info *txq;
> >       u32 frame_sz; /* frame size to deduce data_hard_end/reserved tailroom*/
> >       u16 flags; /* supported values defined in xdp_flags */
> > +     /* xdp multi-buff metadata used for frags iteration */
> > +     struct {
> > +             u16 headroom;   /* frame headroom: data - data_hard_start */
> > +             u16 headlen;    /* first buffer length: data_end - data */
> > +     } mb;
> >  };
> >
> >  static __always_inline bool xdp_buff_is_mb(struct xdp_buff *xdp)
> > @@ -127,6 +132,9 @@ xdp_prepare_buff(struct xdp_buff *xdp, unsigned char *hard_start,
> >       xdp->data = data;
> >       xdp->data_end = data + data_len;
> >       xdp->data_meta = meta_valid ? data : data + 1;
> > +     /* mb metadata for frags iteration */
> > +     xdp->mb.headroom = headroom;
> > +     xdp->mb.headlen = data_len;
> >  }
> >
> >  /* Reserve memory area at end-of data area.
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index 9e2c3b12ea49..a7b5185a718a 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -4877,6 +4877,37 @@ union bpf_attr {
> >   *           Get the total size of a given xdp buff (linear and paged area)
> >   *   Return
> >   *           The total size of a given xdp buffer.
> > + *
> > + * long bpf_xdp_adjust_data(struct xdp_buff *xdp_md, u32 offset)
> > + *   Description
> > + *           For XDP frames split over multiple buffers, the
> > + *           *xdp_md*\ **->data** and*xdp_md *\ **->data_end** pointers
>                                        ^^^^
> missing space?

ack, right. I will fix it.

>
> > + *           will point to the start and end of the first fragment only.
> > + *           This helper can be used to access subsequent fragments by
> > + *           moving the data pointers. To use, an XDP program can call
> > + *           this helper with the byte offset of the packet payload that
> > + *           it wants to access; the helper will move *xdp_md*\ **->data**
> > + *           and *xdp_md *\ **->data_end** so they point to the requested
> > + *           payload offset and to the end of the fragment containing this
> > + *           byte offset, and return the byte offset of the start of the
> > + *           fragment.
> > + *           To move back to the beginning of the packet, simply call the
> > + *           helper with an offset of '0'.
> > + *           Note also that the helpers that modify the packet boundaries
> > + *           (*bpf_xdp_adjust_head()*, *bpf_xdp_adjust_tail()* and
> > + *           *bpf_xdp_adjust_meta()*) will fail if the pointers have been
> > + *           moved; it is the responsibility of the BPF program to move them
> > + *           back before using these helpers.
> > + *
> > + *           A call to this helper is susceptible to change the underlying
> > + *           packet buffer. Therefore, at load time, all checks on pointers
> > + *           previously done by the verifier are invalidated and must be
> > + *           performed again, if the helper is used in combination with
> > + *           direct packet access.
> > + *   Return
> > + *           offset between the beginning of the current fragment and
> > + *           original *xdp_md*\ **->data** on success, or a negative error
> > + *           in case of failure.
> >   */
> >  #define __BPF_FUNC_MAPPER(FN)                \
> >       FN(unspec),                     \
> > @@ -5055,6 +5086,7 @@ union bpf_attr {
> >       FN(get_func_ip),                \
> >       FN(get_attach_cookie),          \
> >       FN(xdp_get_buff_len),           \
> > +     FN(xdp_adjust_data),            \
> >       /* */
> >
> >  /* integer value in 'imm' field of BPF_CALL instruction selects which helper
> > diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
> > index 869dcf23a1ca..f09c2c8c0d6c 100644
> > --- a/net/bpf/test_run.c
> > +++ b/net/bpf/test_run.c
> > @@ -757,6 +757,8 @@ static int xdp_convert_md_to_buff(struct xdp_md *xdp_md, struct xdp_buff *xdp)
> >       }
> >
> >       xdp->data = xdp->data_meta + xdp_md->data;
> > +     xdp->mb.headroom = xdp->data - xdp->data_hard_start;
> > +     xdp->mb.headlen = xdp->data_end - xdp->data;
> >       return 0;
> >
> >  free_dev:
> > @@ -871,6 +873,12 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
> >       if (ret)
> >               goto out;
> >
> > +     /* data pointers need to be reset after frag iteration */
> > +     if (unlikely(xdp.data_hard_start + xdp.mb.headroom != xdp.data)) {
> > +             ret = -EFAULT;
> > +             goto out;
> > +     }
> > +
> >       size = xdp.data_end - xdp.data_meta + sinfo->xdp_frags_size;
> >       ret = bpf_test_finish(kattr, uattr, xdp.data_meta, sinfo, size,
> >                             retval, duration);
> > diff --git a/net/core/filter.c b/net/core/filter.c
> > index 2122c00c680f..ed2a6632adce 100644
> > --- a/net/core/filter.c
> > +++ b/net/core/filter.c
> > @@ -3827,6 +3827,10 @@ BPF_CALL_2(bpf_xdp_adjust_head, struct xdp_buff *, xdp, int, offset)
> >       void *data_start = xdp_frame_end + metalen;
> >       void *data = xdp->data + offset;
> >
> > +     /* data pointers need to be reset after frag iteration */
> > +     if (unlikely(xdp->data_hard_start + xdp->mb.headroom != xdp->data))
> > +             return -EINVAL;
>
> -EFAULT? It might be nice if error code is different from below
> for debugging?

ack, I will fix it in v13

>
> > +
> >       if (unlikely(data < data_start ||
> >                    data > xdp->data_end - ETH_HLEN))
> >               return -EINVAL;
> > @@ -3836,6 +3840,9 @@ BPF_CALL_2(bpf_xdp_adjust_head, struct xdp_buff *, xdp, int, offset)
> >                       xdp->data_meta, metalen);
> >       xdp->data_meta += offset;
> >       xdp->data = data;
> > +     /* update metada for multi-buff frag iteration */
> > +     xdp->mb.headroom = xdp->data - xdp->data_hard_start;
> > +     xdp->mb.headlen = xdp->data_end - xdp->data;
> >
> >       return 0;
> >  }
> > @@ -3910,6 +3917,10 @@ BPF_CALL_2(bpf_xdp_adjust_tail, struct xdp_buff *, xdp, int, offset)
> >       void *data_hard_end = xdp_data_hard_end(xdp); /* use xdp->frame_sz */
> >       void *data_end = xdp->data_end + offset;
> >
> > +     /* data pointer needs to be reset after frag iteration */
> > +     if (unlikely(xdp->data + xdp->mb.headlen != xdp->data_end))
> > +             return -EINVAL;
>
> EFAULT?

ack, I will fix it in v13

>
> > +
> >       if (unlikely(xdp_buff_is_mb(xdp)))
> >               return bpf_xdp_mb_adjust_tail(xdp, offset);
> >
> > @@ -3949,6 +3960,10 @@ BPF_CALL_2(bpf_xdp_adjust_meta, struct xdp_buff *, xdp, int, offset)
> >       void *meta = xdp->data_meta + offset;
> >       unsigned long metalen = xdp->data - meta;
> >
> > +     /* data pointer needs to be reset after frag iteration */
> > +     if (unlikely(xdp->data_hard_start + xdp->mb.headroom != xdp->data))
> > +             return -EINVAL;
>
> same comment.

ack, I will fix it in v13

>
> >       if (xdp_data_meta_unsupported(xdp))
> >               return -ENOTSUPP;
> >       if (unlikely(meta < xdp_frame_end ||
> > @@ -3970,6 +3985,48 @@ static const struct bpf_func_proto bpf_xdp_adjust_meta_proto = {
> >       .arg2_type      = ARG_ANYTHING,
> >  };
> >
> > +BPF_CALL_2(bpf_xdp_adjust_data, struct xdp_buff *, xdp, u32, offset)
> > +{
> > +     struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
> > +     u32 base_offset = xdp->mb.headlen;
> > +     int i;
> > +
> > +     if (!xdp_buff_is_mb(xdp) || offset > sinfo->xdp_frags_size)
> > +             return -EINVAL;
>
> Do we need to error this? If its not mb we can just return the same
> as offset==0?

ack, we can check do something like:

u32 max_offset = xdp->mb.headlen;

if (xdp_buff_is_mb(xdp))
   max_offset += sinfo->xdp_frags_size;

if (offset > max_offset)
   return -EINVAL;

what do you think?

Regards,
Lorenzo

>
> > +
> > +     if (offset < xdp->mb.headlen) {
> > +             /* linear area */
> > +             xdp->data = xdp->data_hard_start + xdp->mb.headroom + offset;
> > +             xdp->data_end = xdp->data_hard_start + xdp->mb.headroom +
> > +                             xdp->mb.headlen;
> > +             return 0;
> > +     }
> > +
> > +     for (i = 0; i < sinfo->nr_frags; i++) {
> > +             /* paged area */
> > +             skb_frag_t *frag = &sinfo->frags[i];
> > +             unsigned int size = skb_frag_size(frag);
> > +
> > +             if (offset < base_offset + size) {
> > +                     u8 *addr = skb_frag_address(frag);
> > +
> > +                     xdp->data = addr + offset - base_offset;
> > +                     xdp->data_end = addr + size;
> > +                     break;
> > +             }
> > +             base_offset += size;
> > +     }
> > +     return base_offset;
> > +}
>

