Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C538A11C3C3
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 04:01:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbfLLDBq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 22:01:46 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:35470 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726638AbfLLDBp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 22:01:45 -0500
Received: by mail-wr1-f65.google.com with SMTP id g17so1028717wro.2;
        Wed, 11 Dec 2019 19:01:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zLk62ztlgIJAvsjlJDdcf8Bf8DhVZYKsZxBJcGQt0b0=;
        b=SMw+DBEEqNnmWuPG8olNP+jO6Dxr3jBIuuYkTp/noXeKwZDYhXD7eeukh25kTRYo+1
         Ff+FFnOs0FILQc4rfav5BSPpQ8c8W7+ooYsKhTWRoq62cUZfC+cPbho0SoBcnEuYl5J9
         Z0KcDXtFAUrI7InF2jGnwtUsR6TPAoA6cEm0lRnn+cofn41lHhOmqPuOO/KLb4TVKcNn
         eMdjp54uZcIbcktKISgboIJ48Rr4DNp1iM2wzUDadRqHqr/HdQp1OYeIBzmB4fwHYGtL
         fUf0uV7NBDxbN+7Sg3mnDMPJ+UmoKKbzcB/8f15i/o0LD0aq8BL4tLNEyP+6eKEONBUR
         O0pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zLk62ztlgIJAvsjlJDdcf8Bf8DhVZYKsZxBJcGQt0b0=;
        b=g1altYg6Afw1JMonJVSFVChjOQgoVaLqblTv7mgcwNMJA7qaQ5PgSRyulUhqMhSQxN
         +VeK1+N+b0zMlI0rlpYhcMJAlNOv32ffRo/5HsrJBuZ4BItRleJaiZKV6pKilimnVYgU
         YAsvvX/r8jo5whUqdf8ytvJpY++ayyrpYC4Wm1Bf6cJtoalpQGOKDMc1b/lN35IJSoLU
         AMIrBs6NbXW3oPPn3hTbgFR6va1CUel261oDgITXrjIxVDj6egs8oq/NoWT9D5bNFIVR
         m1GZAuDHdaQlkj3ezItDkQWRnEWQnqzk+uGRoEP5fQ4F7dGULbS1JcNfNT6iN+Ei8lmT
         kIFg==
X-Gm-Message-State: APjAAAW1zDCoFidaoWdx1k7ZvIDHrmqHCaJwGMcYhshmHRp6vq11NfF6
        aHv0CbIogwCE7IfkQwKaaHdqc+J9i2/xcLvq6lPjLNSC
X-Google-Smtp-Source: APXvYqwB8jjyBy+3Jfi761+iN29O3hCLik++EAZkDC9IiuM/dzBpR5aJl6/EaDgiPUc34+w2KsctYhOuqPmJggW1EQk=
X-Received: by 2002:adf:cf12:: with SMTP id o18mr3364061wrj.361.1576119703162;
 Wed, 11 Dec 2019 19:01:43 -0800 (PST)
MIME-Version: 1.0
References: <cover.1575779993.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1575779993.git.lucien.xin@gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Thu, 12 Dec 2019 11:02:19 +0800
Message-ID: <CADvbK_e25HuWG98OYCWsmWMB6cyRDSM6SovNYKa8ySZyJPchkA@mail.gmail.com>
Subject: Re: [PATCH nf-next 0/7] netfilter: nft_tunnel: reinforce key opts support
To:     network dev <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org
Cc:     davem <davem@davemloft.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 8, 2019 at 12:41 PM Xin Long <lucien.xin@gmail.com> wrote:
>
> This patchset improves quite a few places to make vxlan/erspan
> opts in nft_tunnel work with userspace nftables/libnftnl, and
> also keep consistent with the support for vxlan/erspan opts in
> act_tunnel_key, cls_flower and ip_tunnel_core.
>
> Meanwhile, add support for geneve opts in nft_tunnel. One patch
> for nftables and one for libnftnl will be posted here for the
> testing. With them, nft_tunnel can be set and used by:
>
>   # nft add table ip filter
>   # nft add chain ip filter input { type filter hook input priority 0 \; }
>   # nft add tunnel filter vxlan_01 { type vxlan\; id 2\; \
>     ip saddr 192.168.1.1\; ip daddr 192.168.1.2\; \
>     sport 9000\; dport 9001\; dscp 1234\; ttl 64\; flags 1\; \
>     opts \"ffff\"\; }
>   # nft add tunnel filter erspan_01 { type erspan\; id 2\; \
>     ip saddr 192.168.1.1\; ip daddr 192.168.1.2\; \
>     sport 9000\; dport 9001\; dscp 1234\; ttl 64\; flags 1\; \
>     opts \"1:1:0:0\"\; }
>   # nft add tunnel filter erspan_02 { type erspan\; id 2\; \
>     ip saddr 192.168.1.1\; ip daddr 192.168.1.2\; \
>     sport 9000\; dport 9001\; dscp 1234\; ttl 64\; flags 1\; \
>     opts \"2:0:1:1\"\; }
>   # nft add tunnel filter geneve_01 { type geneve\; id 2\; \
>     ip saddr 192.168.1.1\; ip daddr 192.168.1.2\; \
>     sport 9000\; dport 9001\; dscp 1234\; ttl 64\; flags 1\; \
>     opts \"1:1:1212121234567890\"\; }
>   # nft add tunnel filter geneve_02 { type geneve\; id 2\; \
>     ip saddr 192.168.1.1\; ip daddr 192.168.1.2\; \
>     sport 9000\; dport 9001\; dscp 1234\; ttl 64\; flags 1\; \
>     opts \"1:1:34567890,2:2:12121212,3:3:1212121234567890\"\; }
>   # nft list tunnels table filter
>   # nft add rule filter input ip protocol udp tunnel name geneve_02
>   # nft add rule filter input meta l4proto udp tunnel id 2 drop
>   # nft add rule filter input meta l4proto udp tunnel path 0 drop
>   # nft list chain filter input -a

Hi, Pablo
as you commented on other patches, I will post v2 and
>
> Xin Long (7):
>   netfilter: nft_tunnel: parse ERSPAN_VERSION attr as u8
>   netfilter: nft_tunnel: parse VXLAN_GBP attr as u32 in nft_tunnel
drop these two patches
>   netfilter: nft_tunnel: no need to call htons() when dumping ports
move this one to nf.git
>   netfilter: nft_tunnel: also dump ERSPAN_VERSION
>   netfilter: nft_tunnel: also dump OPTS_ERSPAN/VXLAN
>   netfilter: nft_tunnel: add the missing nla_nest_cancel()
adjust these three for nf-next.git
>   netfilter: nft_tunnel: add support for geneve opts
will you also check this one before my posting v2?

Thanks.
