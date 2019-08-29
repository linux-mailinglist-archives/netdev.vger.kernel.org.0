Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 125A1A2686
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 20:53:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728162AbfH2Sxn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 14:53:43 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:46722 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727798AbfH2Sxm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 14:53:42 -0400
Received: by mail-ed1-f66.google.com with SMTP id z51so5120764edz.13
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 11:53:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=8DrLJYkJSDE8yNy0hRWD87xXnqGiLOj6Q5kMDIVILTo=;
        b=m3NGDl7hjD+pzGgurTlgTCSL/BEaKxEELRGKgiRlKZ/FPBlvDKeFYDy8pUB5aMUjop
         R1imImwALYyWHL+UzB2n1ZoevwjUcrNiarQjRCaR9mAVrZg5kPskOWCqxJJ5XvEEJER+
         5YYooJ1a4H0TCpLtIceMxZP+jLsGSZhQzGg7w73h1dIkYdnQTuEVVk4J3IMmUrIke3E9
         55Fn5mGoyrv6vB7KyAZRbUjhs7Iu/oQEfflYsxmjmCG/xutlzUMglCQi4oGyBisLuWEj
         mAzlM0ZDkHP6gwkHxv5TARcTE1TrIkbJiWshIBdpA7PyOtHjrB7uIrkgKallm9m3k6HW
         3uHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=8DrLJYkJSDE8yNy0hRWD87xXnqGiLOj6Q5kMDIVILTo=;
        b=SqfmHuydAqSTY8zCm61kpcunXizheziHHZjSboEUlCBUxOChlksrGsfZk2XytzvEjh
         1YWSQzqN8cwmVBusfJm6xcCkkXLjFFWMh30KhLSL15cXCBA+hNvyapWJk0jC20WpA3gI
         ebpSCg59to0yrJaXnRPYCUPeVtm7EXs34sOoebaiTD5tJOiUEIwN9BD+piAwWDC3rS2Y
         gyq1nx/s7jusBkbkahRezk8zLc9h/LUMZi3AcUUkVWMtzzupUUAPTYtVCux6pjMEo39B
         +z2Y8ZjUL4JHZn02LtNreEPQG8fHBD6/FXr4YEyWLTCtm/dnnRDUBO5pAxxTT1C9Ho43
         A1sg==
X-Gm-Message-State: APjAAAX8DrKGrTZzjXAfdM+LF1yAvZUd9VHoEf9nyuaPUEmUSCFrofy9
        e6uftWI06lldk9gm+MkkuBZj5w==
X-Google-Smtp-Source: APXvYqxEU5dPHwogKs7meFTghoVkRShv2YncuB/Wrey1TYBX0MK6m3BZ6WFZ1VoroG6wLOe39AwyuA==
X-Received: by 2002:a50:8ec9:: with SMTP id x9mr11413207edx.89.1567104821374;
        Thu, 29 Aug 2019 11:53:41 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id s22sm590615eds.67.2019.08.29.11.53.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2019 11:53:41 -0700 (PDT)
Date:   Thu, 29 Aug 2019 11:53:15 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Hillf Danton <hdanton@sina.com>,
        syzbot <syzbot+7a6ee4d0078eac6bf782@syzkaller.appspotmail.com>,
        aviadye@mellanox.com, borisp@mellanox.com, daniel@iogearbox.net,
        davejwatson@fb.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: general protection fault in tls_sk_proto_close (2)
Message-ID: <20190829115315.5686c18f@cakuba.netronome.com>
In-Reply-To: <5d681e0011c7b_6b462ad11252c5c084@john-XPS-13-9370.notmuch>
References: <000000000000c3c461059127a1c4@google.com>
        <20190829035200.3340-1-hdanton@sina.com>
        <20190829094343.0248c61c@cakuba.netronome.com>
        <5d681e0011c7b_6b462ad11252c5c084@john-XPS-13-9370.notmuch>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 29 Aug 2019 11:48:32 -0700, John Fastabend wrote:
> Jakub Kicinski wrote:
> > On Thu, 29 Aug 2019 11:52:00 +0800, Hillf Danton wrote:  
> > > Alternatively work is done if sock is closed again. Anyway ctx is reset
> > > under sock's callback lock in write mode.
> > > 
> > > --- a/net/tls/tls_main.c
> > > +++ b/net/tls/tls_main.c
> > > @@ -295,6 +295,8 @@ static void tls_sk_proto_close(struct so
> > >  	long timeo = sock_sndtimeo(sk, 0);
> > >  	bool free_ctx;
> > >  
> > > +	if (!ctx)
> > > +		return;
> > >  	if (ctx->tx_conf == TLS_SW)
> > >  		tls_sw_cancel_work_tx(ctx);  
> > 
> > That's no bueno, the real socket's close will never get called.  
> 
> Seems when we refactored BPF side we dropped the check for ULP on one
> path so I'll add that back now. It would be nice and seems we are
> getting closer now that tls side is a bit more dynamic if the ordering
> didn't matter.

We'd probably need some more generic way of communicating the changes
in sk_proto stack, e.g. by moving the update into one of sk_proto
callbacks? but yes.

> diff --git a/net/core/sock_map.c b/net/core/sock_map.c
> index 1330a7442e5b..30d11558740e 100644
> --- a/net/core/sock_map.c
> +++ b/net/core/sock_map.c
> @@ -666,6 +666,8 @@ static int sock_hash_update_common(struct bpf_map *map, void *key,
>         WARN_ON_ONCE(!rcu_read_lock_held());
>         if (unlikely(flags > BPF_EXIST))
>                 return -EINVAL;
> +       if (unlikely(icsk->icsk_ulp_data))
> +               return -EINVAL;
> 
>         link = sk_psock_init_link();
>         if (!link)

Thanks! That looks good, if you feel like submitting officially feel
free to add my Reviewed-by!
