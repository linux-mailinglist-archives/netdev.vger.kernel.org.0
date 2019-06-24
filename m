Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04BC95049D
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 10:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728049AbfFXIdN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 04:33:13 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:44108 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726546AbfFXIdM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 04:33:12 -0400
Received: by mail-wr1-f67.google.com with SMTP id r16so12866465wrl.11
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 01:33:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=eRQ1lHt6qnRl7dfAEbaLnvsDRtOwZrd46033gaj1GM8=;
        b=Uefv9TKii9nudUZPcOh3ICtZnHlto0sKOEm7J7b8ZoT3+tG9VLznZdkZfD7qCImG87
         +gAjyh6tI3LrDvSaE+sK4bjun8H56kuClvJJu3OteOPY88p8Nlq/j2mf4I9nhluiuvyI
         8vLAafGHIe42vSJmt0DX2DvfgQ1d2tNJaY1RpDqzoFXNuUD9IDPOOLuurRp9u3F/Fwxr
         thqTW1VbqETuneAua/bMZAy8jPdyTFN6e+l3Asdz8gC1JY86rly2m75A8eIjCcB/h+zy
         cGjDqGcwyPD0eSG/8YA3ago8PnnYXsD7biXkdrmLpzOF87CmcpRBH/QzOd36giu76yRh
         nOcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eRQ1lHt6qnRl7dfAEbaLnvsDRtOwZrd46033gaj1GM8=;
        b=dKZ4uHdGOk06Iet+PG2PTp0+EKZcqU+21EoVgXDrXMzrRSFSLwmYvuJvlH0FHNTfEp
         1C0czB1k/wx1yjWHzp7MTz/9AKADbubVVLrQPxmpPZYkWFrQ7wtNXnC29X4KNUAb7QoQ
         V+iZfsRJ1oDz9GTIbrzuP4XMJogCX4rMrjt3gbwkDl/UGzA0nNuxCA/tKUEDEQLkKlYm
         OCdjQ0l3LV6ZMhynjN6+gcHsuppEOqBBJayeFmzDTDjn4myZh0INUIA3x4autHUGx66/
         211BgltPCpYGUQ/GF9+TeYofHeUrkClwWyy2mF14fvt3qKXCPcdPdwzrmW6lHMkeqScR
         8bzA==
X-Gm-Message-State: APjAAAVYqSPXfpC7SG3Mqv60IQ5rQmvnkcStahjPQC8mJufhYeZgfqD9
        holKXOIGKwG9b7m0Xe+DDiU=
X-Google-Smtp-Source: APXvYqxXBFygST+4pvMoHUThoL0ww/t5VL3TljqKmSNaex/H+dYPkzP5OMTg71UfA2kF8Kepbn5KWg==
X-Received: by 2002:adf:fc91:: with SMTP id g17mr18738598wrr.194.1561365190443;
        Mon, 24 Jun 2019 01:33:10 -0700 (PDT)
Received: from [192.168.8.147] (59.249.23.93.rev.sfr.net. [93.23.249.59])
        by smtp.gmail.com with ESMTPSA id h6sm7096477wre.82.2019.06.24.01.33.09
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Jun 2019 01:33:09 -0700 (PDT)
Subject: Re: [PATCH net] tipc: check msg->req data len in
 tipc_nl_compat_bearer_disable
To:     Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, Jon Maloy <jon.maloy@ericsson.com>,
        Ying Xue <ying.xue@windriver.com>,
        tipc-discussion@lists.sourceforge.net,
        syzkaller-bugs@googlegroups.com
References: <4fd888cb669434b00dce24ace4410524665be285.1561363146.git.lucien.xin@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <061d3bd2-46a2-04aa-a3f7-3091e6ff8523@gmail.com>
Date:   Mon, 24 Jun 2019 10:33:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <4fd888cb669434b00dce24ace4410524665be285.1561363146.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/24/19 12:59 AM, Xin Long wrote:
> This patch is to fix an uninit-value issue, reported by syzbot:
> 
>   BUG: KMSAN: uninit-value in memchr+0xce/0x110 lib/string.c:981
>   Call Trace:
>     __dump_stack lib/dump_stack.c:77 [inline]
>     dump_stack+0x191/0x1f0 lib/dump_stack.c:113
>     kmsan_report+0x130/0x2a0 mm/kmsan/kmsan.c:622
>     __msan_warning+0x75/0xe0 mm/kmsan/kmsan_instr.c:310
>     memchr+0xce/0x110 lib/string.c:981
>     string_is_valid net/tipc/netlink_compat.c:176 [inline]
>     tipc_nl_compat_bearer_disable+0x2a1/0x480 net/tipc/netlink_compat.c:449
>     __tipc_nl_compat_doit net/tipc/netlink_compat.c:327 [inline]
>     tipc_nl_compat_doit+0x3ac/0xb00 net/tipc/netlink_compat.c:360
>     tipc_nl_compat_handle net/tipc/netlink_compat.c:1178 [inline]
>     tipc_nl_compat_recv+0x1b1b/0x27b0 net/tipc/netlink_compat.c:1281
> 
> TLV_GET_DATA_LEN() may return a negtive int value, which will be
> used as size_t (becoming a big unsigned long) passed into memchr,
> cause this issue.
> 
> Similar to what it does in tipc_nl_compat_bearer_enable(), this
> fix is to return -EINVAL when TLV_GET_DATA_LEN() is negtive in
> tipc_nl_compat_bearer_disable(), as well as in
> tipc_nl_compat_link_stat_dump() and tipc_nl_compat_link_reset_stats().
> 
> Reported-by: syzbot+30eaa8bf392f7fafffaf@syzkaller.appspotmail.com
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Please add an appropriate Fixes: tag, thanks !

