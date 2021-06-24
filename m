Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7B433B3267
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 17:17:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232222AbhFXPTX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 11:19:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232357AbhFXPTT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 11:19:19 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6073AC061574
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 08:16:59 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id hq39so10117564ejc.5
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 08:16:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=riotgames.com; s=riotgames;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=22Y42jbPpmoIkLk/IuRR1ccQuv0bmYkqo5PtAHbSdH4=;
        b=P3TR7/0JAw5ltnrWXbgbwGgKDb7xESJQnbzm52rLFHQjluUFSiXwTyqxlOoJIOUto9
         KsONtCEmqsd8vRIbOu/6XQoRCpN5Psy0c2AlET8uDUXuRHb8QMJ5YLqehPr9LsH4qQP2
         6sMyF7zT0bGsSg1QOpdiIAz8lQ3Gknco+VM00=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=22Y42jbPpmoIkLk/IuRR1ccQuv0bmYkqo5PtAHbSdH4=;
        b=VR8Xpjb9aaONIfM6ste/QBNq8l64qi6AQ9ckzmlc0Jy8rofMVKJIX2y9uTKGzfzuTr
         7UnZ5NGrJOiWIh59CFZ9lNOdbfy1wsEogMmW4trbPiFJOPXkDtUAY5H/vwViqJXGOjfO
         1RztsqDbGjQ+IMV+OnNGY18UiXoKjQIyxM227JSmZeZb1ye1gueDrha7r3OY7+i1dtr3
         TfJ+XYPLvvAFzQr8qnmZpxRFpVCw0auUVERQATCidzA1TGPsJIMKhb9Wd73arumZovhH
         ef2Br1F0e/IQXDzEiPWE0iAu0IVNILvpXwizlvjxFODQCebhrHAwsEhrriNL6HneFSt3
         Hg6w==
X-Gm-Message-State: AOAM532wGKrg7TR540UK9IlmxVrVAiJT0qozxcfenKs+Syb81AyEnrjP
        rI6TqRhl5DE72r9r1fJVSYeBkJz2e6ddRi0L7lvTUQ==
X-Google-Smtp-Source: ABdhPJxeiQZYYynTSeIrS2wCBkIK9QDAkD/Kt5eh4syfFc1Nui5REYA/ZueyOvBuvrAXrZuoqdBAqSOJR9RhpTOSMrY=
X-Received: by 2002:a17:907:c87:: with SMTP id gi7mr5824600ejc.452.1624547817912;
 Thu, 24 Jun 2021 08:16:57 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1623674025.git.lorenzo@kernel.org> <863f4934d251f44ad85a6be08b3737fac74f9b5a.1623674025.git.lorenzo@kernel.org>
 <60d2744ee12c2_1342e208f7@john-XPS-13-9370.notmuch> <4F52EE5B-1A3F-46CE-9A39-98475CA6B684@redhat.com>
 <60d495a914773_2e84a2082d@john-XPS-13-9370.notmuch>
In-Reply-To: <60d495a914773_2e84a2082d@john-XPS-13-9370.notmuch>
From:   Zvi Effron <zeffron@riotgames.com>
Date:   Thu, 24 Jun 2021 08:16:46 -0700
Message-ID: <CAC1LvL0_DhsStjzHhRY_JrCVeBW0J6M2CDJ6qT77Do-deXq8Zg@mail.gmail.com>
Subject: Re: [PATCH v9 bpf-next 08/14] bpf: add multi-buff support to the
 bpf_xdp_adjust_tail() API
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Eelco Chaudron <echaudro@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        bpf <bpf@vger.kernel.org>, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, shayagr@amazon.com,
        sameehj@amazon.com, dsahern@kernel.org,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        jasowang@redhat.com, alexander.duyck@gmail.com, saeed@kernel.org,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        tirthendu.sarkar@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 24, 2021 at 7:24 AM John Fastabend <john.fastabend@gmail.com> w=
rote:
>
> Eelco Chaudron wrote:
> >
> >
> > On 23 Jun 2021, at 1:37, John Fastabend wrote:
> >
> > > Lorenzo Bianconi wrote:
> > >> From: Eelco Chaudron <echaudro@redhat.com>
> > >>
> > >> This change adds support for tail growing and shrinking for XDP mult=
i-buff.
> > >>
> > >
> > > It would be nice if the commit message gave us some details on how th=
e
> > > growing/shrinking works in the multi-buff support.
> >
> > Will add this to the next rev.
> >
> > >> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
> > >> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > >> ---
> > >>  include/net/xdp.h |  7 ++++++
> > >>  net/core/filter.c | 62 ++++++++++++++++++++++++++++++++++++++++++++=
+++
> > >>  net/core/xdp.c    |  5 ++--
> > >>  3 files changed, 72 insertions(+), 2 deletions(-)
> > >>
> > >> diff --git a/include/net/xdp.h b/include/net/xdp.h
> > >> index 935a6f83115f..3525801c6ed5 100644
> > >> --- a/include/net/xdp.h
> > >> +++ b/include/net/xdp.h
> > >> @@ -132,6 +132,11 @@ xdp_get_shared_info_from_buff(struct xdp_buff *=
xdp)
> > >>    return (struct skb_shared_info *)xdp_data_hard_end(xdp);
> > >>  }
> > >>
> > >> +static inline unsigned int xdp_get_frag_tailroom(const skb_frag_t *=
frag)
> > >> +{
> > >> +  return PAGE_SIZE - skb_frag_size(frag) - skb_frag_off(frag);
> > >> +}
> > >> +
> > >>  struct xdp_frame {
> > >>    void *data;
> > >>    u16 len;
> > >> @@ -259,6 +264,8 @@ struct xdp_frame *xdp_convert_buff_to_frame(stru=
ct xdp_buff *xdp)
> > >>    return xdp_frame;
> > >>  }
> > >>
> > >> +void __xdp_return(void *data, struct xdp_mem_info *mem, bool napi_d=
irect,
> > >> +            struct xdp_buff *xdp);
> > >>  void xdp_return_frame(struct xdp_frame *xdpf);
> > >>  void xdp_return_frame_rx_napi(struct xdp_frame *xdpf);
> > >>  void xdp_return_buff(struct xdp_buff *xdp);
> > >> diff --git a/net/core/filter.c b/net/core/filter.c
> > >> index caa88955562e..05f574a3d690 100644
> > >> --- a/net/core/filter.c
> > >> +++ b/net/core/filter.c
> > >> @@ -3859,11 +3859,73 @@ static const struct bpf_func_proto bpf_xdp_a=
djust_head_proto =3D {
> > >>    .arg2_type      =3D ARG_ANYTHING,
> > >>  };
> > >>
> > >> +static int bpf_xdp_mb_adjust_tail(struct xdp_buff *xdp, int offset)
> > >> +{
> > >> +  struct skb_shared_info *sinfo;
> > >> +
> > >> +  if (unlikely(!xdp_buff_is_mb(xdp)))
> > >> +          return -EINVAL;
> > >> +
> > >> +  sinfo =3D xdp_get_shared_info_from_buff(xdp);
> > >> +  if (offset >=3D 0) {
> > >> +          skb_frag_t *frag =3D &sinfo->frags[sinfo->nr_frags - 1];
> > >> +          int size;
> > >> +
> > >> +          if (unlikely(offset > xdp_get_frag_tailroom(frag)))
> > >> +                  return -EINVAL;
> > >> +
> > >> +          size =3D skb_frag_size(frag);
> > >> +          memset(skb_frag_address(frag) + size, 0, offset);
> > >> +          skb_frag_size_set(frag, size + offset);
> > >> +          sinfo->data_len +=3D offset;
> > >
> > > Can you add some comment on how this works? So today I call
> > > bpf_xdp_adjust_tail() to add some trailer to my packet.
> > > This looks like it adds tailroom to the last frag? But, then
> > > how do I insert my trailer? I don't think we can without the
> > > extra multi-buffer access support right.
> >
> > You are right, we need some kind of multi-buffer access helpers.
> >
> > > Also data_end will be unchanged yet it will return 0 so my
> > > current programs will likely be a bit confused by this.
> >
> > Guess this is the tricky part, applications need to be multi-buffer awa=
re. If current applications rely on bpf_xdp_adjust_tail(+) to determine max=
imum frame length this approach might not work. In this case, we might need=
 an additional helper to do tail expansion with multi buffer support.
> >
> > But then the question arrives how would mb unaware application behave i=
n general when an mb packet is supplied?? It would definitely not determine=
 the correct packet length.
>
> Right that was my conclusion as well. Existing programs might
> have subtle side effects if they start running on multibuffer
> drivers as is. I don't have any good ideas though on how
> to handle this.
>

Would it be possible to detect multibuffer awareness of a program at load
(or attach) time, perhaps by looking for the use of the new multibuffer
helpers? That might make it possible to reject a non-multibuffer aware
program on multibuffer drivers (or maybe even put the driver into a
non-multibuffer mode at attach time), or at the very least issue a
warning?

> >
> > >> +  } else {
> >
>
>
