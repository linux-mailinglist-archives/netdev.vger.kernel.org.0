Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5245F94A7
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 16:46:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727437AbfKLPqz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 10:46:55 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:38254 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727281AbfKLPqz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 10:46:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573573613;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TrgtIcC3Ha1/0dzS1VtlsAm2hMfZJyX2cxwGUaWtbv4=;
        b=hcZHg0bQI3w65Z1RWs89QVM5RE1/RsD5s8YE+YewhPMJgAUlgD8HTYg/l3/1MJQBJe2mtg
        moOkykmOAUht1JwA67xswg01sUEwyXaj5Osq+I8OM6U+wty7+tfZ+tmxNj2bfQ+tBFrO+r
        OK6o8pLDnhmGgZDiBPhJ9GL/PqXRsls=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-304-4LpcROQ4N1SS26n6UfmpeQ-1; Tue, 12 Nov 2019 10:46:50 -0500
Received: by mail-lf1-f70.google.com with SMTP id w24so3972554lfa.11
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 07:46:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=G/51mof5846DapZXCI9+0p5WNkNYG968g1sxSQhoVUs=;
        b=N5gvopUGHShRnHMo+hZXtrN8gdOM0Q0o8CslSXygJ5QCdoZZ9BcbG+VDHtvIesur7G
         Uz7I9qTl+d5CJ1ndLoYvBk1GHHYU6dYK253B20OQLv2jbgfgRDuLTe8Un0ktSzFN0zAX
         RkoY3Xi+BWZI+p1gFwle5AWrxauoHmKmuuewlz38bIhQmOCAZrViqoBiLZJU/e98Y8xn
         uzEtlnfk3FqfQwtFQTNpZPY9ZRmju6IIjteV6rCPhWmYuvzL4VLv330W0olmHHcp2kgU
         2qiETC+MSb16I5TNcSX2PVU5KZ65r31VdjKXfuxY6oePcBly4ZQ+PauY0ArXqbvnlh2A
         EbMw==
X-Gm-Message-State: APjAAAVoE6fv6w6jP/l98pcZTHYxMirDArIhIvHhmAkfLHISC0kwsImu
        38fXlRsReETAlBgCV0tiqJWKznrR3CeiCtCCu31MZA4P5i4fO3Zk1vf8HJborqhutrgwhvBVASB
        YNNdSqqybwViaks7AQv9zLdAzKgtA+EwT
X-Received: by 2002:a19:22c4:: with SMTP id i187mr18628823lfi.152.1573573609118;
        Tue, 12 Nov 2019 07:46:49 -0800 (PST)
X-Google-Smtp-Source: APXvYqy8cvj78v13ze7VWQQ9k0hBj9bv4b7ljCsH0R63d/xJPwwZz0STkGWa4+H+mvetYX5dsAWw3ABG8wArvd3JhJ4=
X-Received: by 2002:a19:22c4:: with SMTP id i187mr18628802lfi.152.1573573608866;
 Tue, 12 Nov 2019 07:46:48 -0800 (PST)
MIME-Version: 1.0
References: <20191112102518.4406-1-mcroce@redhat.com> <20191112150046.2aehmeoq7ri6duwo@netronome.com>
In-Reply-To: <20191112150046.2aehmeoq7ri6duwo@netronome.com>
From:   Matteo Croce <mcroce@redhat.com>
Date:   Tue, 12 Nov 2019 16:46:12 +0100
Message-ID: <CAGnkfhyt7wV-qDODQL1DtDoW0anoehVX7zoVk8y_C4WB0tMuUw@mail.gmail.com>
Subject: Re: [PATCH net-next] openvswitch: add TTL decrement action
To:     Simon Horman <simon.horman@netronome.com>
Cc:     netdev <netdev@vger.kernel.org>, dev@openvswitch.org,
        LKML <linux-kernel@vger.kernel.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>,
        Bindiya Kurle <bindiyakurle@gmail.com>
X-MC-Unique: 4LpcROQ4N1SS26n6UfmpeQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 12, 2019 at 4:00 PM Simon Horman <simon.horman@netronome.com> w=
rote:
>
> On Tue, Nov 12, 2019 at 11:25:18AM +0100, Matteo Croce wrote:
> > New action to decrement TTL instead of setting it to a fixed value.
> > This action will decrement the TTL and, in case of expired TTL, send th=
e
> > packet to userspace via output_userspace() to take care of it.
> >
> > Supports both IPv4 and IPv6 via the ttl and hop_limit fields, respectiv=
ely.
> >
>
> Usually OVS achieves this behaviour by matching on the TTL and
> setting it to the desired value, pre-calculated as TTL -1.
> With that in mind could you explain the motivation for this
> change?
>

Hi,

the problem is that OVS creates a flow for each ttl it see. I can let
vswitchd create 255 flows with like this:

$ for i in {2..255}; do ping 192.168.0.2 -t $i -c1 -w1 &>/dev/null & done
$ ovs-dpctl dump-flows |fgrep -c 'set(ipv4(ttl'
255


> > @@ -1174,6 +1174,43 @@ static int execute_check_pkt_len(struct datapath=
 *dp, struct sk_buff *skb,
> >                            nla_len(actions), last, clone_flow_key);
> >  }
> >
> > +static int execute_dec_ttl(struct sk_buff *skb, struct sw_flow_key *ke=
y)
> > +{
> > +     int err;
> > +
> > +     if (skb->protocol =3D=3D htons(ETH_P_IPV6)) {
> > +             struct ipv6hdr *nh =3D ipv6_hdr(skb);
> > +
> > +             err =3D skb_ensure_writable(skb, skb_network_offset(skb) =
+
> > +                                       sizeof(*nh));
> > +             if (unlikely(err))
> > +                     return err;
> > +
> > +             if (nh->hop_limit <=3D 1)
> > +                     return -EHOSTUNREACH;
> > +
> > +             key->ip.ttl =3D --nh->hop_limit;
> > +     } else {
> > +             struct iphdr *nh =3D ip_hdr(skb);
> > +             u8 old_ttl;
> > +
> > +             err =3D skb_ensure_writable(skb, skb_network_offset(skb) =
+
> > +                                       sizeof(*nh));
> > +             if (unlikely(err))
> > +                     return err;
> > +
> > +             if (nh->ttl <=3D 1)
> > +                     return -EHOSTUNREACH;
> > +
> > +             old_ttl =3D nh->ttl--;
> > +             csum_replace2(&nh->check, htons(old_ttl << 8),
> > +                           htons(nh->ttl << 8));
> > +             key->ip.ttl =3D nh->ttl;
> > +     }
>
> The above may send packets with TTL =3D 0, is that desired?
>

If TTL is 1 or 0, execute_dec_ttl() returns -EHOSTUNREACH, and the
caller will just send the packet to userspace and then free it.
I think this is enough, am I missing something?

Bye,
--=20
Matteo Croce
per aspera ad upstream

