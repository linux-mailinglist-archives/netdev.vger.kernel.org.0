Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DA58127D1
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 08:35:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726150AbfECGfV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 02:35:21 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:33553 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725775AbfECGfV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 02:35:21 -0400
Received: by mail-oi1-f196.google.com with SMTP id l1so3674328oib.0;
        Thu, 02 May 2019 23:35:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BEAd59dVTBb7JX1e5IJJHVPVgNFvByWVyR7Ir5EuEkQ=;
        b=RlrR+OysHJuvDp8JmrpOZfuDMoF3d6jclawxzlaSQw2d//TFDlVbg1FB7PnOFg6VbP
         XoM8LIODUSCdZ6lQL+8rBWZx6LvtHW1KCjes0XxNRA/BIEffXv1v0jN5qmwhgOowDcIo
         SUVeREHtVaC0magZQV0Zj3BAw8cQ73uIjP9n6kmVTYrVIz0WXveISdKzhQQkps5mGM+7
         /fIPTqPfXyONnqJAZgngPetDLID1YTopnW9AJGv2UOmO5EeqGGlRYHXvdODOLbU4TsK8
         r4f9Xu8l+2mwjcAnrdtF2gtASVS2L9tuo2dLNZmX+GPfXN4nGI4Vtq8a3oAlUHkPItDu
         1oIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BEAd59dVTBb7JX1e5IJJHVPVgNFvByWVyR7Ir5EuEkQ=;
        b=l7HZTV9wEHh+QdD0GosnfTyFy2bwb3btY5o7pbNCh1L3X0vGwqsDWgmbOJw07MzBDf
         2ySQczP4K7HB3vLrgjuFVwKpO1aQSMjfVeFgsaL+sdjS7pE55Q7z9xuEW+cY7ooLMpU6
         Zq5wUEE6TScfVf1kbn0VkLBNu8CUdOFWoHH6Yv0rlFz/aMXnkiZOTijj38RoqFnk0bMp
         qebt4ePcZhfWuY195QhgOSMNXK7eCecpGQzLCRgJXScz3p2HerqfzKLEdecQXuu8RK8H
         4e79T5bdtznRDRZFzat88Mxg3frAt0/bGiIB+X9kEHP7gv7X7yPEf/Q+ieHNMCSVRI0l
         19jg==
X-Gm-Message-State: APjAAAWiIEXeb/gdm7cF3r4xzjZEetubaoT5EnBJuucLu4VpTnTbHaD2
        9NmEZsupHIoIFW8Pzg9iBAJYgt67HJ1rIARNQsA=
X-Google-Smtp-Source: APXvYqyw5yXGoS6JlTtrm5wFhnaLtXkwnt3rYw7U+j5pypLLZ5rTjdcnyp7DfZj/ZUm9qSzinudt8SHSfFDBpVmIDjI=
X-Received: by 2002:aca:4482:: with SMTP id r124mr5201355oia.39.1556865320017;
 Thu, 02 May 2019 23:35:20 -0700 (PDT)
MIME-Version: 1.0
References: <1556786363-28743-1-git-send-email-magnus.karlsson@intel.com>
 <1556786363-28743-5-git-send-email-magnus.karlsson@intel.com> <762e74a9-24d6-b6a6-da61-139056fda0e5@intel.com>
In-Reply-To: <762e74a9-24d6-b6a6-da61-139056fda0e5@intel.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Fri, 3 May 2019 08:35:08 +0200
Message-ID: <CAJ8uoz2iVinaXZZ18Z1G=+bw6Q-JCmvDPiVJd=6ykv-XKseNSg@mail.gmail.com>
Subject: Re: [RFC bpf-next 4/7] netdevice: introduce busy-poll setsockopt for AF_XDP
To:     "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        bpf@vger.kernel.org, bruce.richardson@intel.com,
        ciara.loftus@intel.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Ye Xiaolong <xiaolong.ye@intel.com>,
        "Zhang, Qi Z" <qi.z.zhang@intel.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        kevin.laatz@intel.com, ilias.apalodimas@linaro.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 3, 2019 at 2:26 AM Samudrala, Sridhar
<sridhar.samudrala@intel.com> wrote:
>
>
>
> On 5/2/2019 1:39 AM, Magnus Karlsson wrote:
> > This patch introduces a new setsockopt that enables busy-poll for XDP
> > sockets. It is called XDP_BUSY_POLL_BATCH_SIZE and takes batch size as
> > an argument. A value between 1 and NAPI_WEIGHT (64) will turn it on, 0
> > will turn it off and any other value will return an error. There is
> > also a corresponding getsockopt implementation.
>
> I think this socket option should also allow specifying a timeout value
> when using blocking poll() calls.
> OR can we use SO_BUSY_POLL to specify this timeout value?

I think you are correct in that we need to be able to specify the
timeout. The current approach of always having a timeout of zero was
optimized for the high throughput case. But Ilias and others often
talk about using AF_XDP for time sensitive networking, and in that
case spinning in the kernel (for a max period of the timeout) waiting
for a packet would provide better latency. And with a configurable
value, we could support both cases, so why not.

I will add the timeout value to the new setsockopt I introduced, so it
will take both a batch size and a timeout value. I will also call it
something else since it should not have batch_size in its name
anymore.

Thanks: Magnus

> >
> > Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> > ---
> >   include/uapi/linux/if_xdp.h | 1 +
> >   1 file changed, 1 insertion(+)
> >
> > diff --git a/include/uapi/linux/if_xdp.h b/include/uapi/linux/if_xdp.h
> > index caed8b1..be28a78 100644
> > --- a/include/uapi/linux/if_xdp.h
> > +++ b/include/uapi/linux/if_xdp.h
> > @@ -46,6 +46,7 @@ struct xdp_mmap_offsets {
> >   #define XDP_UMEM_FILL_RING          5
> >   #define XDP_UMEM_COMPLETION_RING    6
> >   #define XDP_STATISTICS                      7
> > +#define XDP_BUSY_POLL_BATCH_SIZE     8
> >
> >   struct xdp_umem_reg {
> >       __u64 addr; /* Start of packet data area */
> >
