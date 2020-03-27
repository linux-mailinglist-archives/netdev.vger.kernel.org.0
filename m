Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2983A195039
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 06:02:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726233AbgC0FCU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 01:02:20 -0400
Received: from mail-pl1-f176.google.com ([209.85.214.176]:42193 "EHLO
        mail-pl1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725857AbgC0FCU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 01:02:20 -0400
Received: by mail-pl1-f176.google.com with SMTP id e1so3013095plt.9;
        Thu, 26 Mar 2020 22:02:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nZ1omxnMktxVk/WgGM1DGmrMKAiULbbyxCyGaWgk9gU=;
        b=I3uD4V5R8RlmrnRc+aZVOx/07VS3ixCqcAdPOZ3/IRKNEPncAUrMjXxyTqKKTk7VKz
         PtgevwM8d3O8EqWR971xOWztX1uZljme+Jh3PDCuTtjdaJxvNM2mQ8c+T8YLAJtjwmFp
         CUiiFtRAczvzAav5Tqrta71T1j+G7X4vObhhqi4wJ9S1jGugOMqKqRv8hGZDG1d+GehC
         mCzbfwgh3qpKFSZUtZFHExcEcL8FhA4/UsNwthFqIlOmUwNisgY4dtt+ACfKoZG86JTd
         WSxL01JrWml/rBIIpoAJqM49gnQwt5x68wTWeikVmDXtBoSJpqsGG9MN0WWcmAv7Ystp
         a9mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nZ1omxnMktxVk/WgGM1DGmrMKAiULbbyxCyGaWgk9gU=;
        b=CG2h9iakoUeuw8DEqGCRjnYJb2QHHSBR3zQux7gqmWG65dmgx2x11AnntpM41aBUOb
         KYD1Dj/LrwX4itO25h/96D4Jd3Be2aBV5QkrkpdwlAzIIWiqMWVbihJw02IdsmSiGAYj
         upje+8hBj1KvNfKQx3hTkHnYJEyTchjWNe7wBEKfc6YgkGj2U8S592trk4zwbQm/UyEp
         UxWswkQstivzWoRTVvgrGCiBshhYM1rE0ORFMthrAvhKaV2G7boLb6hl9K3SFGr51J2j
         gcHeuUdclYYq0inlYRe0Hr3jEDgTo/wADJXYnMNu+DtcaHKaVHtv47PLPVFKN6B6V0MJ
         uSpw==
X-Gm-Message-State: ANhLgQ1pC+9Iq53eLK2q3+0JrJtC0Z6ZPgzYh0TpD67aeaYXJZY9xVk9
        eD1K4HpoFleAZ2xt2H7qB/s=
X-Google-Smtp-Source: ADFU+vtjFu4xwOVZMqL5xiUK+NHMuVHCOeyiGEHfv7On3OqEhrP6z3+BYuy0ydN2Zky7xFKJxeBFwA==
X-Received: by 2002:a17:902:9048:: with SMTP id w8mr11331615plz.24.1585285338758;
        Thu, 26 Mar 2020 22:02:18 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:f1d9])
        by smtp.gmail.com with ESMTPSA id i197sm3076934pfe.137.2020.03.26.22.02.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2020 22:02:17 -0700 (PDT)
Date:   Thu, 26 Mar 2020 22:02:15 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Joe Stringer <joe@wand.net.nz>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, daniel@iogearbox.net,
        ast@kernel.org, eric.dumazet@gmail.com, lmb@cloudflare.com,
        kafai@fb.com
Subject: Re: [PATCHv3 bpf-next 0/5] Add bpf_sk_assign eBPF helper
Message-ID: <20200327050215.vpl62gfvjj7zljdf@ast-mbp>
References: <20200327042556.11560-1-joe@wand.net.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200327042556.11560-1-joe@wand.net.nz>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 26, 2020 at 09:25:51PM -0700, Joe Stringer wrote:
> Introduce a new helper that allows assigning a previously-found socket
> to the skb as the packet is received towards the stack, to cause the
> stack to guide the packet towards that socket subject to local routing
> configuration. The intention is to support TProxy use cases more
> directly from eBPF programs attached at TC ingress, to simplify and
> streamline Linux stack configuration in scale environments with Cilium.

Thanks for the quick respin.
It builds. And tests are passing for me.
The lack of acks and reviewed-by is a bit concerning for such important feature.

Folks, please be more generous with acks :)
so we can apply it with more confidence.
