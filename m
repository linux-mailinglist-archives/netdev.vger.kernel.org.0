Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 096F261FAA
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 15:42:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731353AbfGHNmN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 09:42:13 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:41582 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731309AbfGHNmN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 09:42:13 -0400
Received: by mail-qt1-f194.google.com with SMTP id d17so16613968qtj.8
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 06:42:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=aktISE9FNKl+9E0cCMN9ZoByrRQIkB6waCq6B1EqK3o=;
        b=CxAB4nKX/+BggqIX1Ekd9sH/yIK2lob63tWtVmJWT4dDzJkVpffPduma/AdFolek59
         XFBpuCXp3VxFx2wE1f5XygAfaQS8lT/8oHCTgyTATGrliUU1m73q8dc2QqeARbfcdwm1
         knDgIa9wquefO3igO75zCxYTiPWH5sRZfQPxC7vIriv2vYzkIZOV4RT2ulHgfG5yXo+r
         SnSypCRcudbY+fXFkZo0tfOOvgdBg61Nm1GA6r1Ux/8Nzm25B3t9W6fcSHDOrtivZCLb
         Rf2YQe2JQs+ovc8AQaEgeEkjwzjXrAJpjLwNQ6v/zBhF0mNtDaCq12RbJxxhBZRrVx/O
         FkqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=aktISE9FNKl+9E0cCMN9ZoByrRQIkB6waCq6B1EqK3o=;
        b=GkaBw8KtarPeZ+hlS41bmOvFbIyEjWMxQUzoRwk7avvMZ8rW3tSYOLAUf2C0ngd6LZ
         lrYcK29Fu6D5UPge3bGtarpIAosVDpBjiuTkrUi7dV/424lzvt7Ss6ujEVuG6LrAEeJs
         p1OFqhfRnHu0tQfIZngQbmiVj6g3tk3erJXp1OtCBW/jPoNLjY7tTyySZHKDY5T7cJwX
         x+AjOzgpCmJrFKJzIbiSSPSwcpZhroG/UzSOEGp2/qG9sfvbS9pvPuD0F2UMuhKIKNjm
         /3Qaah7IlHNy3U4KQSgtjGLs80gB+HqevSxcl8ztmWBLhQQ1iXxITTI5s/1zEkSE+2S5
         WYZg==
X-Gm-Message-State: APjAAAWwAmGlycGv3wYFjAbGQMuHj2nXHiEPWjS0/ZeI0bHEIjvbk8eJ
        u+J+qruH9IIvcIUmiwEQ0BQ=
X-Google-Smtp-Source: APXvYqzfjUMyDQhMa/qEFiS9CXu6eHQC2JKqCO+1nXLuu8QtFF/8NtU+YFomradNbr/v9Q/9lVJsng==
X-Received: by 2002:ac8:7219:: with SMTP id a25mr14277841qtp.234.1562593332280;
        Mon, 08 Jul 2019 06:42:12 -0700 (PDT)
Received: from localhost.localdomain ([177.220.172.139])
        by smtp.gmail.com with ESMTPSA id v7sm3710259qte.86.2019.07.08.06.42.11
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 08 Jul 2019 06:42:11 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id EFD49C0A68; Mon,  8 Jul 2019 10:42:08 -0300 (-03)
Date:   Mon, 8 Jul 2019 10:42:08 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Paul Blakey <paulb@mellanox.com>
Cc:     Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        Yossi Kuperman <yossiku@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>, netdev@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Aaron Conole <aconole@redhat.com>,
        Zhike Wang <wangzhike@jd.com>,
        Rony Efraim <ronye@mellanox.com>, nst-kernel@redhat.com,
        John Hurley <john.hurley@netronome.com>,
        Simon Horman <simon.horman@netronome.com>,
        Justin Pettit <jpettit@ovn.org>
Subject: Re: [PATCH net-next v5 1/4] net/sched: Introduce action ct
Message-ID: <20190708134208.GD3390@localhost.localdomain>
References: <1562575880-30891-1-git-send-email-paulb@mellanox.com>
 <1562575880-30891-2-git-send-email-paulb@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1562575880-30891-2-git-send-email-paulb@mellanox.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 08, 2019 at 11:51:17AM +0300, Paul Blakey wrote:
..
> +static int tcf_ct_handle_fragments(struct net *net, struct sk_buff *skb,
> +				   u8 family, u16 zone)
> +{
> +	enum ip_conntrack_info ctinfo;
> +	struct nf_conn *ct;
> +	int err = 0;
> +	bool frag;
> +
> +	/* Previously seen (loopback)? Ignore. */
> +	ct = nf_ct_get(skb, &ctinfo);
> +	if ((ct && !nf_ct_is_template(ct)) || ctinfo == IP_CT_UNTRACKED)
> +		return 0;
> +
> +	if (family == NFPROTO_IPV4)
> +		err = tcf_ct_ipv4_is_fragment(skb, &frag);
> +	else
> +		err = tcf_ct_ipv6_is_fragment(skb, &frag);
> +	if (err || !frag)
> +		return err;
> +
> +	skb_get(skb);
> +
> +	if (family == NFPROTO_IPV4) {
> +		enum ip_defrag_users user = IP_DEFRAG_CONNTRACK_IN + zone;
> +
> +		memset(IPCB(skb), 0, sizeof(struct inet_skb_parm));
> +		local_bh_disable();
> +		err = ip_defrag(net, skb, user);
> +		local_bh_enable();
> +		if (err && err != -EINPROGRESS)
> +			goto out_free;
> +	} else { /* NFPROTO_IPV6 */
> +		enum ip6_defrag_users user = IP6_DEFRAG_CONNTRACK_IN + zone;
> +
> +		memset(IP6CB(skb), 0, sizeof(struct inet6_skb_parm));
> +		err = nf_ct_frag6_gather(net, skb, user);

This doesn't build without IPv6 enabled.
ERROR: "nf_ct_frag6_gather" [net/sched/act_ct.ko] undefined!

We need to (copy and pasted):

@@ -179,7 +179,9 @@ static int tcf_ct_handle_fragments(struct net *net, struct sk_buff *skb,
                local_bh_enable();
                if (err && err != -EINPROGRESS)
                        goto out_free;
-       } else { /* NFPROTO_IPV6 */
+       }
+#if IS_ENABLED(IPV6)
+       else { /* NFPROTO_IPV6 */
                enum ip6_defrag_users user = IP6_DEFRAG_CONNTRACK_IN + zone;

                memset(IP6CB(skb), 0, sizeof(struct inet6_skb_parm));
@@ -187,6 +189,7 @@ static int tcf_ct_handle_fragments(struct net *net, struct sk_buff *skb,
                if (err && err != -EINPROGRESS)
                        goto out_free;
        }
+#endif

        skb_clear_hash(skb);
        skb->ignore_df = 1;

> +		if (err && err != -EINPROGRESS)
> +			goto out_free;
> +	}
> +
> +	skb_clear_hash(skb);
> +	skb->ignore_df = 1;
> +	return err;
> +
> +out_free:
> +	kfree_skb(skb);
> +	return err;
> +}
