Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E08C146F3D
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 18:10:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728925AbgAWRKg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 12:10:36 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:38688 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726792AbgAWRKf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 12:10:35 -0500
Received: by mail-pf1-f196.google.com with SMTP id x185so1827376pfc.5;
        Thu, 23 Jan 2020 09:10:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=dwJyEOh0uaEFN8hvYa0cHHjOAWxYFsxMT7IvzzrReQI=;
        b=Q+0rToUtIGpg7FyoIxscNn0/RvwL4rrUkiWJ2n9IN6HO9n6C92QHkv3PBUv041aJYu
         mhN6B7xMAbD4MEjZ1KErr52A1355A4yLo/jrh+8OMVJFVMi9N0uLTD/xzth/Z5XXNuiH
         pj+n1GxZR1N3JjT3luH+GnzF2OUyJBJmFx5VrQKzi9Ku6ijV1k5R+Y/ABzn0msWOLa+S
         AQacTj99pd98x2EEzNLKNNTDAMGCRkI+Gv35q69dZGeHCyFII22FwqTtXv7huPFQjZyg
         jdx/c+WMlH/0fkCS9kzBPsMPYl9tBQWnKxG6GkXVV0lrMwCKApfi2RA6gkvJfIEXwxRF
         Q0wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=dwJyEOh0uaEFN8hvYa0cHHjOAWxYFsxMT7IvzzrReQI=;
        b=IfVfTarMOEKIxuHAZY9w7aVD0yPfbQRXh7wbNXIWR4UCgHDCLG+nsSwovf1gkNNQpE
         qelNpfBlzJNHSHVW4ktpWtlmJiuiotJk9Za783xvE5QGFPNOQB8OXa9D0UQEIjoRN/Z+
         wrcKvDbjYA8AfCU0vheiJPtsLom+8OLGzdUT7Ebyd20EUoVtnCfTvh8DuUJ3Bm6B7584
         Ge1LYWB8//bvmEGbV11hlU0A1qVoU+XD1KMoFZjljzoJpQUCZ+44nTLYr/p+gsajvFZG
         RWkRVKmQ3zfcehcqvd1ZgaeqBMm2LGpA8wrovtJLyaW5dQSjZrx4lTaeYoJ+m+JXBHE5
         fR/A==
X-Gm-Message-State: APjAAAUHe+WnyxfkUhrSUOCybaVW5m2+WcxWTOSu6NHc4/lng2h7cwQV
        VfwX4E/km9YO4nT+nS0V7sE=
X-Google-Smtp-Source: APXvYqzsPgVtLCqC7XrdMEUUv9WDoR31GK4BL6XC9b4+BRA3q1+quhAdIpoKGpQQi5I2/2vFliqsPg==
X-Received: by 2002:a63:780d:: with SMTP id t13mr4718336pgc.82.1579799434594;
        Thu, 23 Jan 2020 09:10:34 -0800 (PST)
Received: from workstation-portable ([103.211.17.138])
        by smtp.gmail.com with ESMTPSA id bo19sm3405156pjb.25.2020.01.23.09.10.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jan 2020 09:10:34 -0800 (PST)
Date:   Thu, 23 Jan 2020 22:40:25 +0530
From:   Amol Grover <frextrite@gmail.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Joel Fernandes <joel@joelfernandes.org>,
        Madhuparna Bhowmik <madhuparnabhowmik04@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>
Subject: Re: [PATCH] bpf: devmap: Pass lockdep expression to RCU lists
Message-ID: <20200123171025.GB4484@workstation-portable>
References: <20200123120437.26506-1-frextrite@gmail.com>
 <20200123143725.036140e7@carbon>
 <87a76e9tn8.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87a76e9tn8.fsf@toke.dk>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 23, 2020 at 02:42:03PM +0100, Toke Høiland-Jørgensen wrote:
> Jesper Dangaard Brouer <brouer@redhat.com> writes:
> 
> > On Thu, 23 Jan 2020 17:34:38 +0530
> > Amol Grover <frextrite@gmail.com> wrote:
> >
> >> head is traversed using hlist_for_each_entry_rcu outside an
> >> RCU read-side critical section but under the protection
> >> of dtab->index_lock.
> >
> > We do hold the lock in update and delete cases, but not in the lookup
> > cases.  Is it then still okay to add the lockdep_is_held() annotation?
> 
> I concluded 'yes' from the comment on hlist_for_each_entry_rcu():
> 
> The lockdep condition gets passed to this:
> 
> #define __list_check_rcu(dummy, cond, extra...)				\
> 	({								\
> 	check_arg_count_one(extra);					\
> 	RCU_LOCKDEP_WARN(!cond && !rcu_read_lock_any_held(),		\
> 			 "RCU-list traversed in non-reader section!");	\
> 	 })
> 
> 
> so that seems fine :)
> 

Yes, adding a lockdep expression will be okay. This is because an
implicit check is done to check if list_for_each_entry_rcu() is
traversed under RCU read-side critical section. In case the traversal is
outside RCU read-side critical section, the lockdep expression makes
sure the traversal is done under the mentioned lock.

Thanks
Amol

> -Toke
> 
