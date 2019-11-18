Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B5F210060F
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 14:03:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726646AbfKRNC6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 08:02:58 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:35251 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726490AbfKRNC6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 08:02:58 -0500
Received: by mail-wm1-f68.google.com with SMTP id 8so18758951wmo.0
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 05:02:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=/eygnYaJ/Qk6Ezupep4rjaSg2pLHyykPL949pIhmOCE=;
        b=1MHYO9yp4KPekbJw32u64aA5ZoIPeO+0kZpqv60pI1cJU6kSDZgYyv3SKkAly4t7l4
         LgnLY/QKT4lakJzNw7VPHhsju9XtA9XDeJowle+AZylMqoFeRBv4mQAf8u3uiJozIgOj
         cn+WS1xvYS5ttkw1aGk+QUt2/4/TqWIm0DO6bxYekCaDxaSsjIvRYheXdXBdw4MhBu7K
         pdRS0ZpfV3LnK89negypYKFI8SCupGVE0gQCALubwokv4eyXtvEafr/raM/CEzC39ZcF
         zkrDJP94U4RChEBZOcsxjS+GP3P4XeI2uZUei5EXalbdxPkQHgeDIsfT1cplTd2dpoqf
         h5Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=/eygnYaJ/Qk6Ezupep4rjaSg2pLHyykPL949pIhmOCE=;
        b=ckVJHHk9toVTMBDlFifYImI6l8SLtNS2ZzT2Ih8GNG63cNrzV+/FwbCYd1p0PRiqDL
         fx9TsL7b2g/Ta8HSyMy46Pxhqg+e/qEkpfQdUMvCIho62PD1bqjYCInjDXCEnkSmm727
         xxqnsvXKrupo2ZA361t9jxVsVWHM1lkqbc09VE0zOtQuO21lSnQriuiobp565HgxLrBe
         T91EJjypWs+nRa127eXscPcOn3W0mb993PnVY8hXlv8CuJM85gfmSbI/ZXGNrTEBlTO+
         rFZR1AJF1fIiQPtiCUwpeGnCfYpGs1CS0kXuw5HSAX1nFkeIzj9HPZCXnUIXJiqJrsE9
         9G4Q==
X-Gm-Message-State: APjAAAX2fLLYRkRXk/z6wQ5+wu6ixgeZPQwa7MniVPqzIJ9ycKZBZayF
        MTtV8JD9yFjt//Br0wzwiFTzSnu+zRbENA==
X-Google-Smtp-Source: APXvYqzBn7FiUIwkexcQfuGD5YhEWdCeaCh07kX4xfKY7vnW3XIeBHai38Q4UFkVWhAqA8xqT7dj0w==
X-Received: by 2002:a05:600c:21d9:: with SMTP id x25mr31072848wmj.50.1574082176216;
        Mon, 18 Nov 2019 05:02:56 -0800 (PST)
Received: from netronome.com ([2001:982:756:703:d63d:7eff:fe99:ac9d])
        by smtp.gmail.com with ESMTPSA id x7sm26702435wrg.63.2019.11.18.05.02.55
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 18 Nov 2019 05:02:55 -0800 (PST)
Date:   Mon, 18 Nov 2019 14:02:55 +0100
From:   Simon Horman <simon.horman@netronome.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Pieter Jansen van Vuuren 
        <pieter.jansenvanvuuren@netronome.com>
Subject: Re: [PATCH net] net: sched: ensure opts_len <= IP_TUNNEL_OPTS_MAX in
 act_tunnel_key
Message-ID: <20191118130253.hznw2vac6nh2z3ru@netronome.com>
References: <920e2171915c7d2ba4c7ea4315e049370002afbe.1574069974.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <920e2171915c7d2ba4c7ea4315e049370002afbe.1574069974.git.lucien.xin@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 18, 2019 at 05:39:34PM +0800, Xin Long wrote:
> info->options_len is 'u8' type, and when opts_len with a value >
> IP_TUNNEL_OPTS_MAX, 'info->options_len = opts_len' will cast int
> to u8 and set a wrong value to info->options_len.
> 
> Kernel crashed in my test when doing:
> 
>   # opts="0102:80:00800022"
>   # for i in {1..99}; do opts="$opts,0102:80:00800022"; done
>   # ip link add name geneve0 type geneve dstport 0 external
>   # tc qdisc add dev eth0 ingress
>   # tc filter add dev eth0 protocol ip parent ffff: \
>        flower indev eth0 ip_proto udp action tunnel_key \
>        set src_ip 10.0.99.192 dst_ip 10.0.99.193 \
>        dst_port 6081 id 11 geneve_opts $opts \
>        action mirred egress redirect dev geneve0
> 
> So we should do the similar check as cls_flower does, return error
> when opts_len > IP_TUNNEL_OPTS_MAX in tunnel_key_copy_opts().
> 
> Fixes: 0ed5269f9e41 ("net/sched: add tunnel option support to act_tunnel_key")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Reviewed-by: Simon Horman <simon.horman@netronome.com>
