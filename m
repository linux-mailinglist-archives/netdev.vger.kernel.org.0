Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E71FA41B7F3
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 22:04:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242590AbhI1UGC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 16:06:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242568AbhI1UGA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 16:06:00 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4CF2C06161C
        for <netdev@vger.kernel.org>; Tue, 28 Sep 2021 13:04:20 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id g41so1057384lfv.1
        for <netdev@vger.kernel.org>; Tue, 28 Sep 2021 13:04:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1/zLs3RNFvv9qAcMwG4i3AnfJwDfnbKcjNPWVWHR4go=;
        b=CNhMLUj2HhGwUt7+zVIQXK0CGvgnqCvs0mF//amZs6bDElpmIjg218lvuwoWXB2ffQ
         SE8XgfIg9jjYhiASPaZZuiYSeMtYPuk7mAGd8BGkKCp919pd6XiZcTGmtHFvmExUnOc0
         LkbwoQJpNIsUt6dEy0G9cKedLq10vOWjKLkQCRzla6fC0DTR+Pk0/QWMLT0TSNd30TL9
         M/jIIjF4v9hxuIvyZIhaf5ivL9i0RiWPVlRK4y6Vd4YUTjEkKoGsSi7RN/uAefFgorT1
         8XpnghNax1eRwKr6Rv/eDJJFSS2am6IHVhtnndS+iePmqo2VM9o+W9WhfWQ+gLUXCBhS
         /wVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1/zLs3RNFvv9qAcMwG4i3AnfJwDfnbKcjNPWVWHR4go=;
        b=U/I/kHwiAUHn92pEZdGo48ucEl2Awxo0Y8Y/HAxi+RgU7JI0I5Tc/kEvBIOXWlsruT
         cNW0Qd/IcAroVfZcrcNymXkQmJCKi0LnzZ5HP/79kCFb65FktAvoe9LTHSq25BiC8lME
         5b4846j0hm+Y4/bEex9q2vPEpSPjIg9FQIPEU9ta+bjT88s23O8Qm0dsrtQK84Iz7Vk0
         b/7TxkIjC0cSFaaIdAtf3+Pz6w3eJORnVIuKmtFaPMh0bVG7iRI/dNpXBY8K0J/8Po+k
         K4vorh1+A4St98KmAHVsEzSyNmU0PDPcXdkCOrCFwN0/Agx+64woeUF7o9R+adblVji0
         WDrg==
X-Gm-Message-State: AOAM531Kgla+j8AvRsp8/vxpSDzP/rfCIeCQcJhChDOzXpG5AB58KVtr
        t2PSGnth38jOTyQgl0DqfpU5rfa40fcNS5Pp8+ptFg==
X-Google-Smtp-Source: ABdhPJy1t1eMFdnGEBlFY+4EYTRyRoO33zd6518w2esTRsO8Zu+7PcBsk2AtcTehXNF+rtnXj5xtoeqCtw3q3Bd0TuU=
X-Received: by 2002:a2e:a406:: with SMTP id p6mr1947929ljn.258.1632859458487;
 Tue, 28 Sep 2021 13:04:18 -0700 (PDT)
MIME-Version: 1.0
References: <20210723231957.1113800-1-bcf@google.com> <CAK8P3a1aGA+xqpUPOfGVtt3ch8bvDd75OP=xphN_FrUiuyuX+w@mail.gmail.com>
 <CANH7hM7_brYnVu_x7=+vY34SGQNbc7GUGQmAqpYwXGgVP0RH6Q@mail.gmail.com>
 <20210927162128.4686b57d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CANH7hM4Y2gt9PW_1oZbMQfvT6Bih9U-Ckt7d-w4fKkLp2R-rKA@mail.gmail.com> <CAK8P3a1P9ZGBCub2s62OjrUa1Hwk66zHHESEj06MPY8qwjK7Ag@mail.gmail.com>
In-Reply-To: <CAK8P3a1P9ZGBCub2s62OjrUa1Hwk66zHHESEj06MPY8qwjK7Ag@mail.gmail.com>
From:   Bailey Forrest <bcf@google.com>
Date:   Tue, 28 Sep 2021 13:04:07 -0700
Message-ID: <CANH7hM65PdbPfk44Dp0UG=A5sambfnHGsJsW+Mnr1n4J5nc96A@mail.gmail.com>
Subject: Re: [PATCH net] gve: DQO: Suppress unused var warnings
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 28, 2021 at 7:15 AM Arnd Bergmann <arnd@kernel.org> wrote:
>
> On Tue, Sep 28, 2021 at 2:00 AM Bailey Forrest <bcf@google.com> wrote:
> > On Mon, Sep 27, 2021 at 4:21 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > > On Mon, 27 Sep 2021 13:21:30 -0700 Bailey Forrest wrote:
> > >
> > > Looks like fixing this on the wrong end, dma_unmap_len_set()
> > > and friends should always evaluate their arguments.
> >
> > That makes sense.
> >
> > Arnd, if you want to fix this inside of the dma_* macros, the
> > following diff resolves the errors reported for this driver:
>
> > diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
> > index dca2b1355bb1..f51eee0f678e 100644
> > --- a/include/linux/dma-mapping.h
> > +++ b/include/linux/dma-mapping.h
> > @@ -590,10 +590,21 @@ static inline int dma_mmap_wc(struct device *dev,
> >  #else
> >  #define DEFINE_DMA_UNMAP_ADDR(ADDR_NAME)
> >  #define DEFINE_DMA_UNMAP_LEN(LEN_NAME)
> > -#define dma_unmap_addr(PTR, ADDR_NAME)           (0)
> > -#define dma_unmap_addr_set(PTR, ADDR_NAME, VAL)  do { } while (0)
> > -#define dma_unmap_len(PTR, LEN_NAME)             (0)
> > -#define dma_unmap_len_set(PTR, LEN_NAME, VAL)    do { } while (0)
> > +
> > +#define dma_unmap_addr(PTR, ADDR_NAME) ({ (void)PTR; 0; })
> > +
> > +#define dma_unmap_addr_set(PTR, ADDR_NAME, VAL) do { \
>
> Unfortunately, this breaks every other driver using these macros, as the
> point of them is that the unmap-address is not actually defined
> and not taking up space in data structure. Referencing it by name
> is a compile-time bug.

My patch works with a small modification:

```
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index dca2b1355bb1..04ca5467562e 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -590,10 +590,10 @@ static inline int dma_mmap_wc(struct device *dev,
 #else
 #define DEFINE_DMA_UNMAP_ADDR(ADDR_NAME)
 #define DEFINE_DMA_UNMAP_LEN(LEN_NAME)
-#define dma_unmap_addr(PTR, ADDR_NAME)           (0)
-#define dma_unmap_addr_set(PTR, ADDR_NAME, VAL)  do { } while (0)
-#define dma_unmap_len(PTR, LEN_NAME)             (0)
-#define dma_unmap_len_set(PTR, LEN_NAME, VAL)    do { } while (0)
+#define dma_unmap_addr(PTR, ADDR_NAME) ({ (void)PTR; 0; })
+#define dma_unmap_addr_set(PTR, ADDR_NAME, VAL) do { (void)PTR; } while (0)
+#define dma_unmap_len(PTR, LEN_NAME) ({ (void)PTR; 0; })
+#define dma_unmap_len_set(PTR, LEN_NAME, VAL) do { (void)PTR; } while (0)
 #endif

 #endif /* _LINUX_DMA_MAPPING_H */
```


To me, this is still the preferred solution. However, your latest
patch looked fine to me.
