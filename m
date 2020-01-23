Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A30E514695B
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 14:42:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727235AbgAWNmJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 08:42:09 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:35892 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726729AbgAWNmJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 08:42:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579786928;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4DPy+R5bPTq7tZWsMUKnzOUpzVwlGaLd1jlg2QWm2Yw=;
        b=fpC/8lyaF5Zco8iRmj2aiLJCfyEkWaScqQSctVJIInIu0USAtoGkQ8ifBMdd0byRKPJhwN
        wxwf6fK0yh4Pf133QCyyGatbwgCvH4nfsS2QQTwXtmv1McvNA5gOI/b/3JBMMgH9IrqGtb
        edfEvva2l5YRpfKLvsfAvNFFtnNlA7Y=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-199-vKRahZiKM8O8WniNlMpWiw-1; Thu, 23 Jan 2020 08:42:06 -0500
X-MC-Unique: vKRahZiKM8O8WniNlMpWiw-1
Received: by mail-lj1-f197.google.com with SMTP id t11so1085098ljo.13
        for <netdev@vger.kernel.org>; Thu, 23 Jan 2020 05:42:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=4DPy+R5bPTq7tZWsMUKnzOUpzVwlGaLd1jlg2QWm2Yw=;
        b=pnKkDn6Oitc1Q19znxVJUhUz9MOe/j4mitq8WaqxbI9SIU5mJwbSK2Y5js+88nUMNF
         DPutVHoz2Ohmpgb6Tdeebngj4pn9UT9mh176gddY+DMeA15R4Nq2+nSDnAY31DPuxiAp
         EDmF/FHg6I14KVnpLhX5Mv+W377sm/3r9MQmzlC8IVMkTlgRSOQay4KYVZp0nlr9/YaG
         nMalFBIAu+JVQuCcpOQVa1oWIn2GRPdjP0utTOBlMmSFHc1puD2ynh99rj1AySxgjOrc
         I/9bajOxsg/aYYJRuJToVyJqtTBBbfy0peAJANyb2ri+Q5pOxvNo8BvQGoK0HEddNlwO
         bPYg==
X-Gm-Message-State: APjAAAW+KuY88rZJvGYktaOipeqlALaEE9GqU6FLu30QIdsxSvoeJp3z
        9F/9RnlIX6lij7mMfzriy5fQcCsqvQy+Ll+xTwAOHHAIE6i4kOXmx+YOYTkpiPExKEOX1xJC2WT
        hfAAMfNqpzJW9mKK+
X-Received: by 2002:a19:f811:: with SMTP id a17mr4794428lff.182.1579786924712;
        Thu, 23 Jan 2020 05:42:04 -0800 (PST)
X-Google-Smtp-Source: APXvYqyTmGyH6Qd2cv+F2F7Drf9s7FCX03KscxdhXqeEkXE/A8+ijDXZ9rPq2Sq7zIK+6Vbk3ftI/Q==
X-Received: by 2002:a19:f811:: with SMTP id a17mr4794418lff.182.1579786924504;
        Thu, 23 Jan 2020 05:42:04 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([85.204.121.218])
        by smtp.gmail.com with ESMTPSA id w20sm1284895ljo.33.2020.01.23.05.42.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jan 2020 05:42:03 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 2E9961800FF; Thu, 23 Jan 2020 14:42:03 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Amol Grover <frextrite@gmail.com>
Cc:     brouer@redhat.com, Alexei Starovoitov <ast@kernel.org>,
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
In-Reply-To: <20200123143725.036140e7@carbon>
References: <20200123120437.26506-1-frextrite@gmail.com> <20200123143725.036140e7@carbon>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 23 Jan 2020 14:42:03 +0100
Message-ID: <87a76e9tn8.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jesper Dangaard Brouer <brouer@redhat.com> writes:

> On Thu, 23 Jan 2020 17:34:38 +0530
> Amol Grover <frextrite@gmail.com> wrote:
>
>> head is traversed using hlist_for_each_entry_rcu outside an
>> RCU read-side critical section but under the protection
>> of dtab->index_lock.
>
> We do hold the lock in update and delete cases, but not in the lookup
> cases.  Is it then still okay to add the lockdep_is_held() annotation?

I concluded 'yes' from the comment on hlist_for_each_entry_rcu():

The lockdep condition gets passed to this:

#define __list_check_rcu(dummy, cond, extra...)				\
	({								\
	check_arg_count_one(extra);					\
	RCU_LOCKDEP_WARN(!cond && !rcu_read_lock_any_held(),		\
			 "RCU-list traversed in non-reader section!");	\
	 })


so that seems fine :)

-Toke

