Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 054AD3A5E0B
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 10:02:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232574AbhFNIEo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 04:04:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232520AbhFNIEn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 04:04:43 -0400
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6940CC061574;
        Mon, 14 Jun 2021 01:02:24 -0700 (PDT)
Received: by mail-qt1-x82d.google.com with SMTP id t9so7890215qtw.7;
        Mon, 14 Jun 2021 01:02:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5B0viqEhviHz4xJ4SJR75K+gNeZzk0JoWPTewMDqmdU=;
        b=qZSBUoK8NZB7ff1MQhry0qaKQs71uqKhUiR8p+hrfpEFYmCdMS0/xsjgN8eHe9ZGVw
         3uO5xHhbakpaf4PqzibUvGAyO0dLzPLzmr+d08S2gfG71IGS7fICMNmLJ89yGOjo9t2q
         dVGHPSFrESeP+mh7UjUDCo4i//mFAgKFIHKKsCnONas4jikICE1RuzX6nHQzuw7/Z7ti
         1ho/c+eHe8dwZJXzMDhs6tB2AsojKXIIYFBOUz57tgd6qQ+ZljQ2ap8HhIfnx47Mnmei
         itRJXd7HB0LFyIIXB8NpvEkf48Z9TaF2kvmgMX9688yAmvLsAC7wSCLofqfe9xR88Ssn
         khEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5B0viqEhviHz4xJ4SJR75K+gNeZzk0JoWPTewMDqmdU=;
        b=KiwPNSSki5zeN0heFPS+uCzzsC22sMxzeuOlXl+zv6HHTYdFCGVf4GhBIKl+bwmmbB
         pwbzLTi+p7to+COgcY/vn+7kMjuWoNYNzoQZY9u6rrdwUxCwr5ec9W6BteXEyhJQbF/D
         7mdZ56AbjMaj4HKUsiM9QoHXvk7GKQhZC8Cp4IG0MQX+/ojX/DEpBusFR6Zc+BMn5K/p
         FpxtBN3ekgfhfpR33M3d55PVQT4pubkVYVLuTUabybGU1o7dD2AdqKhEmrAu4G4vYVC1
         8GAEjNOCezILW3GfKzpkqEnaViTpqrJGW/ZRx6CSx80tFqHPP4zxbrubR4SZTESam82l
         FOgA==
X-Gm-Message-State: AOAM533UMiq7QbUr63lHfREbwV+iudtHDOjuuvTEKqV1YLHkesM3ZPP0
        /N/MBcIBJnYL5//PO5hzvZRXbQua02Snidl0xg==
X-Google-Smtp-Source: ABdhPJzW0Si2eVk94q8A7Xm+OWZD0JsjvhUuUia930MCwU6/EDm5BVwDvuX9lIECtmKxnCQM6RVBxE5jaC+KwAIBdh0=
X-Received: by 2002:ac8:5883:: with SMTP id t3mr7298111qta.127.1623657743525;
 Mon, 14 Jun 2021 01:02:23 -0700 (PDT)
MIME-Version: 1.0
References: <20210609135537.1460244-1-joamaki@gmail.com> <20210609135537.1460244-2-joamaki@gmail.com>
 <21398.1623281349@famine>
In-Reply-To: <21398.1623281349@famine>
From:   Jussi Maki <joamaki@gmail.com>
Date:   Mon, 14 Jun 2021 10:02:12 +0200
Message-ID: <CAHn8xcnkY8C37CxDM-ZSm5GrEdasN+gQJ5LQbQTrvposj8XRBg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/3] net: bonding: Add XDP support to the bonding driver
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     bpf <bpf@vger.kernel.org>, netdev@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andy Gospodarek <andy@greyhouse.net>, vfalico@gmail.com,
        andrii@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 10, 2021 at 1:29 AM Jay Vosburgh <jay.vosburgh@canonical.com> wrote:
>         The design adds logic around a bpf_bond_redirect_enabled_key
> static key in the BPF core functions dev_map_enqueue_multi,
> dev_map_redirect_multi and bpf_prog_run_xdp.  Is this something that is
> correctly implemented as a special case just for bonding (i.e., it will
> never ever have to be extended), or is it possible that other
> upper/lower type software devices will have similar XDP functionality
> added in the future, e.g., bridge, VLAN, etc?

Good point. For example the "team" driver would basically need pretty
much the same implementation. For that just using non-bond naming
would be enough. I don't think there's much of a cost for doing a more
generic mechanism, e.g. xdp "upper intercept" hook in netdev_ops, so
I'll try that out. At the very least I'll change the naming.

...

> >@@ -3543,26 +3614,30 @@ static u32 bond_vlan_srcmac_hash(struct sk_buff *skb)
> > }
> >
> > /* Extract the appropriate headers based on bond's xmit policy */
> >-static bool bond_flow_dissect(struct bonding *bond, struct sk_buff *skb,
> >+static bool bond_flow_dissect(struct bonding *bond,
> >+                            struct sk_buff *skb,
> >+                            const void *data,
> >+                            __be16 l2_proto,
> >+                            int nhoff,
> >+                            int hlen,
> >                             struct flow_keys *fk)
>
>         Please compact the argument list down to fewer lines, in
> conformance with usual coding practice in the kernel.  The above style
> of formatting occurs multiple times in this patch, both in function
> declarations and function calls.

Thanks will do.

...

> >-/**
> >- * bond_xmit_hash - generate a hash value based on the xmit policy
> >- * @bond: bonding device
> >- * @skb: buffer to use for headers
> >- *
> >- * This function will extract the necessary headers from the skb buffer and use
> >- * them to generate a hash based on the xmit_policy set in the bonding device
> >+/* Generate hash based on xmit policy. If @skb is given it is used to linearize
> >+ * the data as required, but this function can be used without it.
>
>         Please don't remove kernel-doc formatting; add your new
> parameters to the documentation.

The comment and the function declaration were untouched (see further
below in patch).  I only introduced the common helper __bond_xmit_hash
used from bond_xmit_hash and bond_xmit_hash_xdp. Unfortunately the
generated diff was a bit confusing. I'll try and generate cleaner
diffs in the future.

> >  */
> >-u32 bond_xmit_hash(struct bonding *bond, struct sk_buff *skb)
> >+static u32 __bond_xmit_hash(struct bonding *bond,
> >+                          struct sk_buff *skb,
> >+                          const void *data,
> >+                          __be16 l2_proto,
> >+                          int mhoff,
> >+                          int nhoff,
> >+                          int hlen)
> > {
> >       struct flow_keys flow;
> >       u32 hash;
> >
> >-      if (bond->params.xmit_policy == BOND_XMIT_POLICY_ENCAP34 &&
> >-          skb->l4_hash)
> >-              return skb->hash;
> >-
> >       if (bond->params.xmit_policy == BOND_XMIT_POLICY_VLAN_SRCMAC)
> >-              return bond_vlan_srcmac_hash(skb);
> >+              return bond_vlan_srcmac_hash(skb, data, mhoff, hlen);
> >
> >       if (bond->params.xmit_policy == BOND_XMIT_POLICY_LAYER2 ||
> >-          !bond_flow_dissect(bond, skb, &flow))
> >-              return bond_eth_hash(skb);
> >+          !bond_flow_dissect(bond, skb, data, l2_proto, nhoff, hlen, &flow))
> >+              return bond_eth_hash(skb, data, mhoff, hlen);
> >
> >       if (bond->params.xmit_policy == BOND_XMIT_POLICY_LAYER23 ||
> >           bond->params.xmit_policy == BOND_XMIT_POLICY_ENCAP23) {
> >-              hash = bond_eth_hash(skb);
> >+              hash = bond_eth_hash(skb, data, mhoff, hlen);
> >       } else {
> >               if (flow.icmp.id)
> >                       memcpy(&hash, &flow.icmp, sizeof(hash));
> >@@ -3638,6 +3708,48 @@ u32 bond_xmit_hash(struct bonding *bond, struct sk_buff *skb)
> >       return bond_ip_hash(hash, &flow);
> > }
> >
> >+/**
> >+ * bond_xmit_hash_skb - generate a hash value based on the xmit policy
> >+ * @bond: bonding device
> >+ * @skb: buffer to use for headers
> >+ *
> >+ * This function will extract the necessary headers from the skb buffer and use
> >+ * them to generate a hash based on the xmit_policy set in the bonding device
> >+ */
> >+u32 bond_xmit_hash(struct bonding *bond, struct sk_buff *skb)
> >+{
> >+      if (bond->params.xmit_policy == BOND_XMIT_POLICY_ENCAP34 &&
> >+          skb->l4_hash)
> >+              return skb->hash;
> >+
> >+      return __bond_xmit_hash(bond, skb, skb->head, skb->protocol,
> >+                              skb->mac_header,
> >+                              skb->network_header,
> >+                              skb_headlen(skb));
> >+}
...
