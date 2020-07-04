Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F4A621433A
	for <lists+netdev@lfdr.de>; Sat,  4 Jul 2020 05:24:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727042AbgGDDYr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 23:24:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726501AbgGDDYr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jul 2020 23:24:47 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20471C061794;
        Fri,  3 Jul 2020 20:24:47 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id j12so14654425pfn.10;
        Fri, 03 Jul 2020 20:24:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5mjtDkLPbbWqz1WxWI3jz9F4TwIMnJE4lHWgCmjcrT8=;
        b=nwHd6oTzcZMCVUpmO+3djqT5VfjpG88BpEeYSXy1zd+7ldo5YYdTRXoKWuZQpwNiwb
         DHh+v4V4JT15uxorZFJ+matMI4Lmo3Aqn407PtlLvx5rPQsawEo7lYwcZ8Fkxy286yKC
         RBjqOYDMqj+1UaA6FhsTrPs0i7wfIJ8uG/8MuoNhNkIITYdAl1URdgCPrNxvY7oY4a7c
         nvP4g9nAS13K6RjtoDXHfUmsxdU0wmseyyXGhdmmCg8G334gq0y/kJi8kN/nP1grbKQN
         enHw9qM6WZBM/+z4H1NUNHUjNakAkThkvsIeW69F/mtJx67Y2oLb6ar+2H1SsIo3Z2kw
         6mNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5mjtDkLPbbWqz1WxWI3jz9F4TwIMnJE4lHWgCmjcrT8=;
        b=pxsDxBqyy0FEEXTv9ZRikHOVm0dLBjyEo/kjgIiqGI+/HchwD9Wfd7zGpfOuR/uKam
         1u0USfpiJ/gkOhxYZ7fApZXFH1nBK78ZiVAYLekozlI5bOjyW9jrMHJRtJC4wIveqp1J
         3fCga+R/ouzhXPnD08YXDSTiOvPyuazFDqZXx9WHevoT3HB/3nP2Utfmjji2w5xYRrWo
         Afc7KXPgGeOmgdsqKjsxqxd/Uq+XaaismHHp0rj1hMaIXlxZd+UBoXSqj7Ni3B7fF8A4
         0pS+hUJUF7UHyqQMQVD9yZVLgcYVjfPibSAFuO2PjNt7TS+Sq1so79zvOjmhg3j1d+kc
         ZSDQ==
X-Gm-Message-State: AOAM531eihjiF3n+cEVF9Igwqviftxz5Tl2OvCh3t4BXb1yF+6RljwY1
        cG448uXF3nhn34AHAb4ZLSM=
X-Google-Smtp-Source: ABdhPJyxeU4S+oHmZU8ojh+tfKt8pancEU7IwdoBsEHkLyX0q/GWjEylWDF1ceooCk04EEgYVlhsQQ==
X-Received: by 2002:a63:4144:: with SMTP id o65mr31231619pga.8.1593833086574;
        Fri, 03 Jul 2020 20:24:46 -0700 (PDT)
Received: from [192.168.1.18] (i223-218-245-204.s42.a013.ap.plala.or.jp. [223.218.245.204])
        by smtp.googlemail.com with ESMTPSA id l22sm11744906pjq.20.2020.07.03.20.24.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Jul 2020 20:24:45 -0700 (PDT)
Subject: Re: [PATCH net v3] sched: consistently handle layer3 header accesses
 in the presence of VLANs
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        cake@lists.bufferbloat.net, Davide Caratti <dcaratti@redhat.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Roman Mashak <mrv@mojatatu.com>,
        Lawrence Brakmo <brakmo@fb.com>,
        Ilya Ponetayev <i.ponetaev@ndmsystems.com>
References: <20200703202643.12919-1-toke@redhat.com>
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
Message-ID: <ada37763-16cd-7b51-f9ce-41e8d313bf96@gmail.com>
Date:   Sat, 4 Jul 2020 12:24:41 +0900
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200703202643.12919-1-toke@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/07/04 5:26, Toke Høiland-Jørgensen wrote:
...
> +/* A getter for the SKB protocol field which will handle VLAN tags consistently
> + * whether VLAN acceleration is enabled or not.
> + */
> +static inline __be16 skb_protocol(const struct sk_buff *skb, bool skip_vlan)
> +{
> +	unsigned int offset = skb_mac_offset(skb) + sizeof(struct ethhdr);
> +	__be16 proto = skb->protocol;
> +
> +	if (!skip_vlan)
> +		/* VLAN acceleration strips the VLAN header from the skb and
> +		 * moves it to skb->vlan_proto
> +		 */
> +		return skb_vlan_tag_present(skb) ? skb->vlan_proto : proto;
> +
> +	while (eth_type_vlan(proto)) {
> +		struct vlan_hdr vhdr, *vh;
> +
> +		vh = skb_header_pointer(skb, offset, sizeof(vhdr), &vhdr);
> +		if (!vh)
> +			break;
> +
> +		proto = vh->h_vlan_encapsulated_proto;
> +		offset += sizeof(vhdr);
> +	}

Why don't you use __vlan_get_protocol() here? It looks quite similar.
Is there any problem with using that?

Toshiaki Makita
