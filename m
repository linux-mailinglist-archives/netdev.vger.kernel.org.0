Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D57F129026
	for <lists+netdev@lfdr.de>; Sun, 22 Dec 2019 23:12:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbfLVWLH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Dec 2019 17:11:07 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:58938 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726162AbfLVWLH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Dec 2019 17:11:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1577052666;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PFVWmZ8q0WlDUcde63ZrjajdtCWPLza3bpRWUYiUYZI=;
        b=dFmYVoo9KHUvPeq4aGcoKLESEO4G1QSBTXheYdmitl4ij+XKmiAQXBiKMpqP9/8ddjX9iX
        JfnfVv3kJDP4dQPqgRFZROh3nsYTM0UR1JLmR1YSAbHo6sSbZtg2Bq4oscKTJWmfVpqVxw
        dxvTY5gPWlL4zwE71uJpz6fZ/Cfy920=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-321-YfvuDUG9P9OEC7ROH-08ag-1; Sun, 22 Dec 2019 17:11:04 -0500
X-MC-Unique: YfvuDUG9P9OEC7ROH-08ag-1
Received: by mail-wr1-f70.google.com with SMTP id h30so3304726wrh.5
        for <netdev@vger.kernel.org>; Sun, 22 Dec 2019 14:11:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PFVWmZ8q0WlDUcde63ZrjajdtCWPLza3bpRWUYiUYZI=;
        b=olfph+2iIZb5PQMhdngBiGuZgAx+C2uFL06RIIyayv+pslQkvDC5RoUv8hoIlb51mJ
         vITYA5LEQvH6ibgTFyagxs/MZVc5VHT2+VWpRnz+6lUQYGoWsFb8FNrFZZPLxYzKSx5U
         E8R/AgddSYWpWBzUX2VYDblZ6oGiOIRKdAPH20Nb+RwLV4TAyaW18OEx8vFVQZirL1jr
         3ZwVR4zXWh9Xhs9t/ww6jvOkm4Ym9xO/OtvD+2ya/RoiWEJjatRr+EtCsvvVcuW7d62s
         uQ6rvKt8ru+x1XqHhXzDboXo3EY1os+llLiLUkPAQSgXUqetM9JQhUX/YjQ0JP2Ear6Y
         ozrA==
X-Gm-Message-State: APjAAAUIJF264pZ3PIMx/Xz7xskHVXBL2sgsfv94sAQENQNJXtOqCEXG
        omMHJJ7VrIgsBT61JC9x93VT5qq0bpeYzbbBL/+J5iQiH9XooCQIIJ0cpNDVAK5S1zEpWbR2OvH
        rMh1sTM7MbtVtsusv
X-Received: by 2002:a5d:46c1:: with SMTP id g1mr26200435wrs.200.1577052663351;
        Sun, 22 Dec 2019 14:11:03 -0800 (PST)
X-Google-Smtp-Source: APXvYqy5Pg0Spcr2/G+rJyvBy/KWiEO0/FWFnujOPlp5TZcX/2aeCUPbr9QrYxWUhmTPpyC3zPo7fA==
X-Received: by 2002:a5d:46c1:: with SMTP id g1mr26200427wrs.200.1577052663179;
        Sun, 22 Dec 2019 14:11:03 -0800 (PST)
Received: from linux.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id f1sm18420250wro.85.2019.12.22.14.11.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Dec 2019 14:11:01 -0800 (PST)
Date:   Sun, 22 Dec 2019 23:10:59 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, Julian Anastasov <ja@ssi.bg>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        Pablo Neira <pablo@netfilter.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Alexey Kodanev <alexey.kodanev@oracle.com>
Subject: Re: [PATCHv5 net 0/8] disable neigh update for tunnels during pmtu
 update
Message-ID: <20191222221059.GA3668@linux.home>
References: <20191220032525.26909-1-liuhangbin@gmail.com>
 <20191222025116.2897-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191222025116.2897-1-liuhangbin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 22, 2019 at 10:51:08AM +0800, Hangbin Liu wrote:
> When we setup a pair of gretap, ping each other and create neighbour cache.
> Then delete and recreate one side. We will never be able to ping6 to the new
> created gretap.
> 
> The reason is when we ping6 remote via gretap, we will call like
> 
> gre_tap_xmit()
>  - ip_tunnel_xmit()
>    - tnl_update_pmtu()
>      - skb_dst_update_pmtu()
>        - ip6_rt_update_pmtu()
>          - __ip6_rt_update_pmtu()
>            - dst_confirm_neigh()
>              - ip6_confirm_neigh()
>                - __ipv6_confirm_neigh()
>                  - n->confirmed = now
> 
> As the confirmed time updated, in neigh_timer_handler() the check for
> NUD_DELAY confirm time will pass and the neigh state will back to
> NUD_REACHABLE. So the old/wrong mac address will be used again.
> 
> If we do not update the confirmed time, the neigh state will go to
> neigh->nud_state = NUD_PROBE; then go to NUD_FAILED and re-create the
> neigh later, which is what IPv4 does.
> 
> We couldn't remove the ip6_confirm_neigh() directly as we still need it
> for TCP flows. To fix it, we have to pass a bool parameter to
> dst_ops.update_pmtu() and only disable neighbor update for tunnels.
> 
No more objection from me (and you already have my Reviewed-by tag).
Thanks for your work Hangbin.

