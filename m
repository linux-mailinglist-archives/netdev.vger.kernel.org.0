Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EE25D49E7
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 23:31:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728958AbfJKVa6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 17:30:58 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:38220 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727197AbfJKVa6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 17:30:58 -0400
Received: by mail-pf1-f195.google.com with SMTP id h195so6812392pfe.5
        for <netdev@vger.kernel.org>; Fri, 11 Oct 2019 14:30:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ck44Sagmm+Poik3/fC+1Kwb8pbbyBDj/Smy2bAJymqM=;
        b=PTBZsVW4VPRHLXN4i+vJx/+sRJ5rmQThSxsjUsv31VYkpKILqkWsOYQXFAjTSS6lbI
         9WzRyre9mqMBlHy4ImOr1MhPuD1G1bXBzObvJ2rS6Pj94MTF7d5m3663DeGNH346Tafg
         5HLQzoiSN4H40ll8AGmzaXz9m47h2XMCYXv5FXMJeMxLhFNBA6ZHGYXVKyxA7ltNQ7b6
         9XPK8dDqFXzdFq3vbZfD2FQKsYvDFqBwtaDk5ZPExhtIC/3rPsXjEx8tJAIzkvHlsa1Q
         poAfNlEJD4t6mmTEPzHXtvnBVp2EwXqxvjxYpkXZT4llQCfcrmwzJEATC9mo7X/ICDny
         5pcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ck44Sagmm+Poik3/fC+1Kwb8pbbyBDj/Smy2bAJymqM=;
        b=nkcMTvERE4LWqjGldS0ZIS2GMB0JBV+CZOTziacySUps+KdadAnJgFeA+bGfscBi1I
         ML+Ebhi19o8vn7OFJ1B2/6PST1NKWOxMx7bI48GgAr8TQ4lXvrbVuBuY5qWtG6SJa8X4
         6dv5mvx6aWWgSB4ggqnRH43aK+hFMVp1fcOVQcuu+jQsltdZ18INNET0ir+5mFIZ0Uvi
         2QxKpk11KCj8YqiPJU4AzLXqDLC3a+CCwP+GByayWcBs8Qyzi3A5pOeDPNULGc20E+n7
         RA+37L4YWx/o3fevxaza1fcx5WYbz7dlrzOxmx3X4mkTfsX4pS30KDYiEPrMBU/DeA+X
         4qUg==
X-Gm-Message-State: APjAAAUqQOFp+wDyWZNsgeiGgi4h4W9lqxvAoHSurYlGajEMZFt0fokv
        dX1ThSYfmqQySU8dm0Hi2Jm/Sw==
X-Google-Smtp-Source: APXvYqyU92ryvT9MsM3L8Ajpyt7VBlmNIMVuNGSfjSRYuoRDeL+X5qSrYyuypStksCub2RuWutpJTg==
X-Received: by 2002:a63:4181:: with SMTP id o123mr1335343pga.301.1570829455957;
        Fri, 11 Oct 2019 14:30:55 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id q15sm9683265pgl.12.2019.10.11.14.30.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Oct 2019 14:30:55 -0700 (PDT)
Date:   Fri, 11 Oct 2019 14:30:54 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Cc:     Martin Lau <kafai@fb.com>, Stanislav Fomichev <sdf@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>
Subject: Re: [PATCH bpf-next 3/3] bpftool: print the comm of the process that
 loaded the program
Message-ID: <20191011213054.GJ2096@mini-arch>
References: <20191011162124.52982-1-sdf@google.com>
 <20191011162124.52982-3-sdf@google.com>
 <20191011201910.ynztujumh7dlluez@kafai-mbp.dhcp.thefacebook.com>
 <20191011203716.GI2096@mini-arch>
 <37176EA5-3E3E-4405-9823-5D7153998DF2@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37176EA5-3E3E-4405-9823-5D7153998DF2@kernel.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/11, Arnaldo Carvalho de Melo wrote:
> On October 11, 2019 5:37:16 PM GMT-03:00, Stanislav Fomichev <sdf@fomichev.me> wrote:
> >On 10/11, Martin Lau wrote:
> >> On Fri, Oct 11, 2019 at 09:21:24AM -0700, Stanislav Fomichev wrote:
> >> > Example with loop1.o (loaded via 
> >
> >> What will be in "comm" for the python bcc script?
> >I guess it will be "python". But at least you get a signal that it's
> >not some other system daemon :-)
> 
> Perhaps bcc could use prctl to change its comm before calling sys_bpf and set the script name?
Good idea! prctl does indeed call set_task_comm to change the task comm.

> - Arnaldo
> 
> Sent from smartphone
> 
> >
> >> > 
> >> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> >> > ---
> >> >  tools/bpf/bpftool/prog.c | 4 +++-
> >> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >> > 
> >> > diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
> >> > index 27da96a797ab..400771a942d7 100644
> >> > --- a/tools/bpf/bpftool/prog.c
> >> > +++ b/tools/bpf/bpftool/prog.c
> >> > @@ -296,7 +296,9 @@ static void print_prog_plain(struct
> >bpf_prog_info *info, int fd)
> >> >  		print_boot_time(info->load_time, buf, sizeof(buf));
> >> >  
> >> >  		/* Piggy back on load_time, since 0 uid is a valid one */
> >> > -		printf("\tloaded_at %s  uid %u\n", buf, info->created_by_uid);
> >> > +		printf("\tloaded_at %s  uid %u  comm %s\n", buf,
> >> > +		       info->created_by_uid,
> >> > +		       info->created_by_comm);
> >> >  	}
> >> >  
> >> >  	printf("\txlated %uB", info->xlated_prog_len);
> >> > -- 
> >> > 2.23.0.700.g56cf767bdb-goog
> >> > 
> 
