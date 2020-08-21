Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39A6224E1D9
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 22:07:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbgHUUHK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 16:07:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725801AbgHUUHJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 16:07:09 -0400
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27060C061573;
        Fri, 21 Aug 2020 13:07:09 -0700 (PDT)
Received: by mail-qk1-x72a.google.com with SMTP id p25so2476494qkp.2;
        Fri, 21 Aug 2020 13:07:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/H8qllaBl7DvCB5chhhsKMOAdwJTij5vEFUx78aFoUs=;
        b=rOIV6Pq5roz+puOb0ywKNBInjRb6mDoOV4rlPMppSnR4aPCcH9Zik0NJCQAvEeXLnn
         RiR64GUs1T35QGLrVC0UaOxKmn6YkzDjLziykdcN5LIRxGZUaf8PPGTRdAtRZYxVNUQ7
         fG8t6+Ps5FBtuIz5m4WzL8SfXB/ygB7Gah9oMvopdbAlVDeJZWbD5ImLwKR2hEABBpoT
         Mv6V+xclg86ntCdlbsVnAnEZHQc4zpA5h0LmYZETnD5mijc3/Lh05yOCBP/VVikJ6HcD
         h3ao4KkGz45+I/Xsud6uHE300Io7XaTf0N237LiiFkUY5gtvGZ9u0W5VXfGk8kWsR6ZV
         7Pyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/H8qllaBl7DvCB5chhhsKMOAdwJTij5vEFUx78aFoUs=;
        b=mTTCausQi2vK26sT2kqWa1kj1auLQDKlMO6QmlU3J8Vy21q185nAQYkXT6mQSAjRqT
         I+ZgWlmWQozWWZcCZ9+yoMWO7wGKsyd6p8/qTHkBbVRJs7n+H1aRSovejK3dtPStjsnv
         PZJJ9aavKatucMT1pFoGavLVbGDhQifMpoGCfaJ4pLy4CLX0JbFp62FgFSwQV6EjsZm6
         anoXLriQzUnSiNmkfGsfUteShJfjahkdtllULpZky8s/oHiIW4/wMIgjW6cVY4Um5caK
         K+LDWI1bB5ZH7vySpSoL7u4zhm3Z80Yo2wmRbvt1nHh6pauslmO420x6am7Vl/MFjQee
         ZD4Q==
X-Gm-Message-State: AOAM530DDGR4YeACjsF2FJKaeLmrqHbM72Hx5m65qXL+PwNl8cnUqJ5R
        2bHW0j920079+9NVFAlWIAs=
X-Google-Smtp-Source: ABdhPJxuVicpRWYmfEU/Z8B/wJ4BDMVE4SGZZRXa2olmw3TLvF6R+eJW02ueEh6KmTXRCQcvS3vLaA==
X-Received: by 2002:a37:9b91:: with SMTP id d139mr4011202qke.377.1598040427922;
        Fri, 21 Aug 2020 13:07:07 -0700 (PDT)
Received: from localhost.localdomain ([168.181.48.246])
        by smtp.gmail.com with ESMTPSA id k1sm2621289qkf.12.2020.08.21.13.07.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2020 13:07:07 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id E9F2DC35FC; Fri, 21 Aug 2020 17:07:04 -0300 (-03)
Date:   Fri, 21 Aug 2020 17:07:04 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        davem@davemloft.net, Eric Dumazet <edumazet@google.com>,
        Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCHv2 net] sctp: not disable bh in the whole
 sctp_get_port_local()
Message-ID: <20200821200704.GM3399@localhost.localdomain>
References: <08a14c2f087153c18c67965cc37ed2ac22da18ed.1597993178.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <08a14c2f087153c18c67965cc37ed2ac22da18ed.1597993178.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 21, 2020 at 02:59:38PM +0800, Xin Long wrote:
> With disabling bh in the whole sctp_get_port_local(), when
> snum == 0 and too many ports have been used, the do-while
> loop will take the cpu for a long time and cause cpu stuck:
> 
>   [ ] watchdog: BUG: soft lockup - CPU#11 stuck for 22s!
>   [ ] RIP: 0010:native_queued_spin_lock_slowpath+0x4de/0x940
>   [ ] Call Trace:
>   [ ]  _raw_spin_lock+0xc1/0xd0
>   [ ]  sctp_get_port_local+0x527/0x650 [sctp]
>   [ ]  sctp_do_bind+0x208/0x5e0 [sctp]
>   [ ]  sctp_autobind+0x165/0x1e0 [sctp]
>   [ ]  sctp_connect_new_asoc+0x355/0x480 [sctp]
>   [ ]  __sctp_connect+0x360/0xb10 [sctp]
> 
> There's no need to disable bh in the whole function of
> sctp_get_port_local. So fix this cpu stuck by removing
> local_bh_disable() called at the beginning, and using
> spin_lock_bh() instead.
> 
> The same thing was actually done for inet_csk_get_port() in
> Commit ea8add2b1903 ("tcp/dccp: better use of ephemeral
> ports in bind()").
> 
> Thanks to Marcelo for pointing the buggy code out.
> 
> v1->v2:
>   - use cond_resched() to yield cpu to other tasks if needed,
>     as Eric noticed.

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
