Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 442303EA9F9
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 20:12:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237495AbhHLSNS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 14:13:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbhHLSNR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 14:13:17 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18E1BC061756
        for <netdev@vger.kernel.org>; Thu, 12 Aug 2021 11:12:52 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id u13so11813461lje.5
        for <netdev@vger.kernel.org>; Thu, 12 Aug 2021 11:12:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3IBmrG9EcDzssiR9dY8YvqnK3/P6vQnXnwNHy7NXG/k=;
        b=PlfAVLvuNc6jHEPbPFgM44WkQ88pFCwSTly6DaMvO6LslArYLa2GXaxCOLdDQCvoRR
         oqnnON+xFf8WVTINtLj9fl2ez+E2jHjru57cMVZdicymTW/pXF+lzSr80TmaP2xi3Ldc
         GJBLnMqM/hBw5kmRFdzgG92f+EoOQ/f6StlfQ2pQyA1nai6B+kiKBmDO9D6qBGBuOU+5
         8OZNsWirzY7N6CQ1UJjW1kJypmfPITQkJU6BS9/p0KHNF7pr9OsP/V8mKGHblbJVWFk+
         9TPQGuZiKzKkBYVreW4RHw8Q3j1RJngjJsRVtC6H3c1PFl5n8QLPpmm6oZdStlh7dp8f
         U3kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3IBmrG9EcDzssiR9dY8YvqnK3/P6vQnXnwNHy7NXG/k=;
        b=gcRJWRuGx7vVstYkV5cEHtn+xCM3V5y4kYq5yJ6uVTE2U9HKtUe7X5daYocNwyDsii
         KUIOUwoJ7t1x5ilQFpMTGSe05wEv4xsZIRDWX1VdgNOCGlNlzzjbE6kDpzR2m1a0ofQS
         QdHqGL2HC3Y/ielSsaIFa7GsgVlx8lW+Hm+UWA0aFkfu/4wAj0elliY014pC9SeTXpPK
         gBLSW78OxxD2fHy70KxOrl+m5VKZX8ajN2aM+Cd58MfCpOH2OtKMhj51/+c2HaQc50FB
         iOgKDSpC2+sTgPCJt8kDGwHNaMT/yxVVoPhDEjfhLRKZlLY1/iS+fRnaxfMyVGhmd141
         W5EA==
X-Gm-Message-State: AOAM530g7PCcXqlEYQ0A1lTbx1FdYLI7056KHInOvJhDXaBRy5ntl1iN
        mUvyTUra2x5NLLEg9nFDSzme4M4nNSprR37vFkT2FA==
X-Google-Smtp-Source: ABdhPJwNIbPyauYgPanl0IavUisSfmfdQnkFz6j64zcXJ2xb6P6xRGL05iZxUjPfhmk91DMZ52lczsPQKghAqZCCCrU=
X-Received: by 2002:a2e:b0d1:: with SMTP id g17mr3914413ljl.153.1628791969964;
 Thu, 12 Aug 2021 11:12:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210809172207.3890697-1-richardsonnick@google.com>
 <20210809172207.3890697-2-richardsonnick@google.com> <20210809140505.30388445@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210809140505.30388445@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Nick Richardson <richardsonnick@google.com>
Date:   Thu, 12 Aug 2021 14:12:38 -0400
Message-ID: <CAGr-3gkzarg=1sqYJ+T-grcGFA_sfR8aWNp0i38rUUHZWns94A@mail.gmail.com>
Subject: Re: [PATCH 1/3] pktgen: Parse internet mix (imix) input
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, nrrichar@ncsu.edu,
        Arun Kalyanasundaram <arunkaly@google.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Yejune Deng <yejune.deng@gmail.com>,
        Di Zhu <zhudi21@huawei.com>, Ye Bin <yebin10@huawei.com>,
        Leesoo Ahn <dev@ooseel.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Philip Romanov <promanov@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey Jakub, thanks for the quick response!

> > +
> > +             len = num_arg(&buffer[i], max_digits, &size);
> > +             if (len < 0)
> > +                     return len;
> > +             i += len;
> > +             if (get_user(c, &buffer[i]))
> > +                     return -EFAULT;
> > +             /* Check for comma between size_i and weight_i */
> > +             if (c != ',')
> > +                     return -EINVAL;
> > +             i++;
> > +
> > +             if (size < 14 + 20 + 8)
> > +                     size = 14 + 20 + 8;
>
> Why overwrite instead of rejecting?

I overwrite here to keep behavior similar to when pkt_size is set directly.
When the pkt_size command is used the size value is overwritten to the
minimum packet size (14 + 8 + 20).
See the pkt_size section in pktgen_if_write().

>
> > +             len = num_arg(&buffer[i], max_digits, &weight);
> > +             if (len < 0)
> > +                     return len;
> > +             if (weight <= 0)
> > +                     return -EINVAL;
> > +
> > +             pkt_dev->imix_entries[pkt_dev->n_imix_entries].size = size;
> > +             pkt_dev->imix_entries[pkt_dev->n_imix_entries].weight = weight;
> > +
> > +             i += len;
> > +             if (get_user(c, &buffer[i]))
> > +                     return -EFAULT;
>
> What if this is the last entry?

If this is the last entry then the line terminating character is read.
Similar code can be found in the get_labels() function in pktgen.c


On Mon, Aug 9, 2021 at 5:05 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon,  9 Aug 2021 17:22:02 +0000 Nicholas Richardson wrote:
> > From: Nick Richardson <richardsonnick@google.com>
> >
> > Adds "imix_weights" command for specifying internet mix distribution.
> >
> > The command is in this format:
> > "imix_weights size_1,weight_1 size_2,weight_2 ... size_n,weight_n"
> > where the probability that packet size_i is picked is:
> > weight_i / (weight_1 + weight_2 + .. + weight_n)
> >
> > The user may provide up to 20 imix entries (size_i,weight_i) in this
> > command.
> >
> > The user specified imix entries will be displayed in the "Params"
> > section of the interface output.
> >
> > Values for clone_skb > 0 is not supported in IMIX mode.
> >
> > Summary of changes:
> > Add flag for enabling internet mix mode.
> > Add command (imix_weights) for internet mix input.
> > Return -ENOTSUPP when clone_skb > 0 in IMIX mode.
> > Display imix_weights in Params.
> > Create data structures to store imix entries and distribution.
> >
> > Signed-off-by: Nick Richardson <richardsonnick@google.com>
> > ---
> >  net/core/pktgen.c | 95 +++++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 95 insertions(+)
> >
> > diff --git a/net/core/pktgen.c b/net/core/pktgen.c
> > index 7e258d255e90..83c83e1b5f28 100644
> > --- a/net/core/pktgen.c
> > +++ b/net/core/pktgen.c
> > @@ -175,6 +175,8 @@
> >  #define IP_NAME_SZ 32
> >  #define MAX_MPLS_LABELS 16 /* This is the max label stack depth */
> >  #define MPLS_STACK_BOTTOM htonl(0x00000100)
> > +/* Max number of internet mix entries that can be specified in imix_weights. */
> > +#define MAX_IMIX_ENTRIES 20
> >
> >  #define func_enter() pr_debug("entering %s\n", __func__);
> >
> > @@ -242,6 +244,12 @@ static char *pkt_flag_names[] = {
> >  #define VLAN_TAG_SIZE(x) ((x)->vlan_id == 0xffff ? 0 : 4)
> >  #define SVLAN_TAG_SIZE(x) ((x)->svlan_id == 0xffff ? 0 : 4)
> >
> > +struct imix_pkt {
> > +     __u64 size;
> > +     __u64 weight;
> > +     __u64 count_so_far;
>
> no need for the __ prefix outside of uAPI.
>
> > +};
> > +
> >  struct flow_state {
> >       __be32 cur_daddr;
> >       int count;
> > @@ -343,6 +351,10 @@ struct pktgen_dev {
> >       __u8 traffic_class;  /* ditto for the (former) Traffic Class in IPv6
> >                               (see RFC 3260, sec. 4) */
> >
> > +     /* IMIX */
> > +     unsigned int n_imix_entries;
> > +     struct imix_pkt imix_entries[MAX_IMIX_ENTRIES];
> > +
> >       /* MPLS */
> >       unsigned int nr_labels; /* Depth of stack, 0 = no MPLS */
> >       __be32 labels[MAX_MPLS_LABELS];
> > @@ -552,6 +564,16 @@ static int pktgen_if_show(struct seq_file *seq, void *v)
> >                  (unsigned long long)pkt_dev->count, pkt_dev->min_pkt_size,
> >                  pkt_dev->max_pkt_size);
> >
> > +     if (pkt_dev->n_imix_entries > 0) {
> > +             seq_printf(seq, "     imix_weights: ");
> > +             for (i = 0; i < pkt_dev->n_imix_entries; i++) {
> > +                     seq_printf(seq, "%llu,%llu ",
> > +                                pkt_dev->imix_entries[i].size,
> > +                                pkt_dev->imix_entries[i].weight);
> > +             }
> > +             seq_printf(seq, "\n");
>
> seq_puts()
>
> > +     }
> > +
> >       seq_printf(seq,
> >                  "     frags: %d  delay: %llu  clone_skb: %d  ifname: %s\n",
> >                  pkt_dev->nfrags, (unsigned long long) pkt_dev->delay,
> > @@ -792,6 +814,61 @@ static int strn_len(const char __user * user_buffer, unsigned int maxlen)
> >       return i;
> >  }
> >
> > +static ssize_t get_imix_entries(const char __user *buffer,
> > +                             struct pktgen_dev *pkt_dev)
> > +{
> > +     /* Parses imix entries from user buffer.
> > +      * The user buffer should consist of imix entries separated by spaces
> > +      * where each entry consists of size and weight delimited by commas.
> > +      * "size1,weight_1 size2,weight_2 ... size_n,weight_n" for example.
> > +      */
>
> This comments belongs before the function.
>
> > +     long len;
> > +     char c;
> > +     int i = 0;
> > +     const int max_digits = 10;
>
> Please order these lines longest to shortest (reverse xmas tree).
>
> > +     pkt_dev->n_imix_entries = 0;
> > +
> > +     do {
> > +             unsigned long size;
> > +             unsigned long weight;
>
> same
>
> > +
> > +             len = num_arg(&buffer[i], max_digits, &size);
> > +             if (len < 0)
> > +                     return len;
> > +             i += len;
> > +             if (get_user(c, &buffer[i]))
> > +                     return -EFAULT;
> > +             /* Check for comma between size_i and weight_i */
> > +             if (c != ',')
> > +                     return -EINVAL;
> > +             i++;
> > +
> > +             if (size < 14 + 20 + 8)
> > +                     size = 14 + 20 + 8;
>
> Why overwrite instead of rejecting?
>
> > +             len = num_arg(&buffer[i], max_digits, &weight);
> > +             if (len < 0)
> > +                     return len;
> > +             if (weight <= 0)
> > +                     return -EINVAL;
> > +
> > +             pkt_dev->imix_entries[pkt_dev->n_imix_entries].size = size;
> > +             pkt_dev->imix_entries[pkt_dev->n_imix_entries].weight = weight;
> > +
> > +             i += len;
> > +             if (get_user(c, &buffer[i]))
> > +                     return -EFAULT;
>
> What if this is the last entry?
>
> > +             i++;
> > +             pkt_dev->n_imix_entries++;
> > +
> > +             if (pkt_dev->n_imix_entries > MAX_IMIX_ENTRIES)
> > +                     return -E2BIG;
> > +     } while (c == ' ');
>
> empty line here
>
> > +     return i;
> > +}
> > +
> >  static ssize_t get_labels(const char __user *buffer, struct pktgen_dev *pkt_dev)
> >  {
> >       unsigned int n = 0;
> > @@ -960,6 +1037,18 @@ static ssize_t pktgen_if_write(struct file *file,
> >               return count;
> >       }
> >
> > +     if (!strcmp(name, "imix_weights")) {
> > +             if (pkt_dev->clone_skb > 0)
> > +                     return -ENOTSUPP;
>
> ENOTSUPP should not be returned to user space, please use a different
> one.
>
> > +             len = get_imix_entries(&user_buffer[i], pkt_dev);
> > +             if (len < 0)
> > +                     return len;
> > +
> > +             i += len;
> > +             return count;
> > +     }
> > +
> >       if (!strcmp(name, "debug")) {
> >               len = num_arg(&user_buffer[i], 10, &value);
> >               if (len < 0)
> > @@ -1082,10 +1171,16 @@ static ssize_t pktgen_if_write(struct file *file,
> >               len = num_arg(&user_buffer[i], 10, &value);
> >               if (len < 0)
> >                       return len;
> > +             /* clone_skb is not supported for netif_receive xmit_mode and
> > +              * IMIX mode.
> > +              */
> >               if ((value > 0) &&
> >                   ((pkt_dev->xmit_mode == M_NETIF_RECEIVE) ||
> >                    !(pkt_dev->odev->priv_flags & IFF_TX_SKB_SHARING)))
> >                       return -ENOTSUPP;
> > +             if (value > 0 && pkt_dev->n_imix_entries > 0)
> > +                     return -ENOTSUPP;
>
> ditto
>
> >               i += len;
> >               pkt_dev->clone_skb = value;
> >
>


-- 





Nick Richardson (he/him/his)

SWE Intern

1 (919) 410 3510

careers.google.com/students


|Learn more about our candidate privacy policy.|
