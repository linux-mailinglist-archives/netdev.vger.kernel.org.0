Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEAC8214039
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 22:16:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726502AbgGCUQc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 16:16:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726147AbgGCUQb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jul 2020 16:16:31 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA13DC061794
        for <netdev@vger.kernel.org>; Fri,  3 Jul 2020 13:16:31 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id a11so19942378ilk.0
        for <netdev@vger.kernel.org>; Fri, 03 Jul 2020 13:16:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-transfer-encoding;
        bh=vSkAi5uW/KdoEVuuahqoDhfz418sY3smPqYtLrhlpNE=;
        b=Ilc3Jvz42ijwqqK+rkc9cXcu3iy6y1GhdMnlD4YG2U1ucdAnCbDyv80vjcEB43rR+k
         phm1ZWZ3GZKWvP+sP9xRVvecpT7RWpIXQ0gOdzGRfOGI5JMJ8cHIq65SeQc+opTpciOO
         4WtKa1tWoBIxP+dHVAbGJ2fszNOlYqcZAJ8//bkUlY9KJ7Uy8gIhuewymgueMZv6Xi3k
         ffHUEawQjPNaIpjJlxALArX70q+eBnfjiuG0S667GnxZwlB/+AWmuOgPj9uecrlNOqc0
         AaXm7BqyUt3sU0Gn58DmTxn1oQoCIjA72+B3pS15WZYuXClCrH1adjVz24bBa5Py4TjG
         gBEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:references:date:in-reply-to
         :message-id:user-agent:mime-version:content-transfer-encoding;
        bh=vSkAi5uW/KdoEVuuahqoDhfz418sY3smPqYtLrhlpNE=;
        b=YRWqDlixwkrkb3tDwL6lO8cowL7ZOviFF8eBNan8NzLyLhYhFFwn2XVofwaqyM6cdc
         lQQE+zdfR4Fuqm14A2ftO9sNSOAOOVkRls9IEO/mFyRaqfKHNZh7D8EFUkCootAMfoDy
         ktG5A7RdoiGnoRCMClOoa+eReZXyYLanqxcmmBy7PxzAlcU4OrhCll/WFIuwSaQUwE77
         JdvU33YxDAAPs+P1+VJbp5k+wSYRYFSwUiOQjqYc7K6OHI0FzSD/j94v9Kzafp8X1Tl3
         J5gZAgwdv14NBTSgRS9GInil/UGSZOEMrqbrMUEagE2YtGK/22orKxwxzVXf9Vcz/33G
         KuiQ==
X-Gm-Message-State: AOAM5321IlSgMhS5qCTNCD3WUsjkB1sHyO+iknjtSaqFu/WLsE1UqcFZ
        9jRBT5PV8NmBn1oBxL6To3kMow==
X-Google-Smtp-Source: ABdhPJywXGBX2FCiru00pDq5eOC4ovaPhHtffqUJ669uhhro61miUkt1/g5Qq8HSmVSDEUvVlEPkfQ==
X-Received: by 2002:a92:dc0f:: with SMTP id t15mr17295282iln.218.1593807391142;
        Fri, 03 Jul 2020 13:16:31 -0700 (PDT)
Received: from sevai ([74.127.202.217])
        by smtp.gmail.com with ESMTPSA id s5sm3870830ilo.24.2020.07.03.13.16.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 Jul 2020 13:16:30 -0700 (PDT)
From:   Roman Mashak <mrv@mojatatu.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        cake@lists.bufferbloat.net, Davide Caratti <dcaratti@redhat.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Ilya Ponetayev <i.ponetaev@ndmsystems.com>
Subject: Re: [PATCH net v2] sched: consistently handle layer3 header accesses in the presence of VLANs
References: <20200703152239.471624-1-toke@redhat.com>
Date:   Fri, 03 Jul 2020 16:16:15 -0400
In-Reply-To: <20200703152239.471624-1-toke@redhat.com> ("Toke
        \=\?utf-8\?Q\?H\=C3\=B8iland-J\=C3\=B8rgensen\=22's\?\= message of "Fri, 3 Jul 2020
 17:22:39 +0200")
Message-ID: <85sge82w34.fsf@mojatatu.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> writes:


[...]

> +/* A getter for the SKB protocol field which will handle VLAN tags consi=
stently
> + * whether VLAN acceleration is enabled or not.
> + */
> +static inline __be16 skb_protocol(const struct sk_buff *skb, bool skip_v=
lan)
> +{
> +	unsigned int offset =3D skb_mac_offset(skb) + sizeof(struct ethhdr);
> +	__be16 proto =3D skb->protocol;
> +	struct vlan_hdr vhdr, *vh;

Nit: you could move vhdr and *vh definitions inside the while loop,
because of their inner scope use.

> +
> +	if (!skip_vlan)
> +		/* VLAN acceleration strips the VLAN header from the skb and
> +		 * moves it to skb->vlan_proto
> +		 */
> +		return skb_vlan_tag_present(skb) ? skb->vlan_proto : proto;
> +
> +	while (eth_type_vlan(proto)) {
> +		vh =3D skb_header_pointer(skb, offset, sizeof(vhdr), &vhdr);
> +		if (!vh)
> +			break;
> +
> +		proto =3D vh->h_vlan_encapsulated_proto;
> +		offset +=3D sizeof(vhdr);
> +	}

[...]

