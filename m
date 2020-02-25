Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 006D816B933
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 06:41:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726425AbgBYFlb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 00:41:31 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:40182 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725788AbgBYFlb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 00:41:31 -0500
Received: by mail-pj1-f65.google.com with SMTP id 12so781647pjb.5;
        Mon, 24 Feb 2020 21:41:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=gLVzYUKvFkdnFdGrFfL5ckRC9d9XLzszDBemhFoCXos=;
        b=s5Ja+WQrx0bCQ7dZ7FgKMjgQo/QP0DD95K3BOk4egXtL/UeLMvIy2jpS7tx5TsAVVJ
         aHy/bGrbvj78nC86Nyt+E/I2nmXjh4DHDl/eHROqVjMsC2D2+vG/CH2waM2Fh4cONghZ
         WdiDspcvDT5PQ0nKNyZnXgoZqB9xy6lYI3HNWKQzA0EOqtOTEoSForwxNvq6DJ/5JqbR
         E1vsmiWXl54bGwymCrXGFoeX08Y+n0ASpt4lt11VLWRp9R9aH9v61HIqSXmjQQZrgesg
         Wg5TuHJUcbIh9it/L4yqZVa7sIklAWBBpV8N04jOhzSejJlj2dzAOoC3qGZqNXr9hh6V
         tv9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=gLVzYUKvFkdnFdGrFfL5ckRC9d9XLzszDBemhFoCXos=;
        b=hSGyrk/ST4/fR6fjhWqB3HV/aSt6nebXASj+e4MsrmLcMYfi4I8WYlwHQ9r4Tjph44
         Sxws8R9r5dk9KUA2bNJqK8ELOw1ye277huc12PvyoUMsBTrV95EUPNC3Yc1QGzjthnSS
         qmIJfoEbCsU/ZaYC72b5wmH8Ow3/s8sFHxnwxfvJ69F6J4utZ+UTY6siVztXS8rWmvcc
         FB3fSCy5uvIwli3dQvX4aX7wQcMOccCIJLToZgNWI/OYJHb+moc/4PBiTYWrkbnI6Vk8
         0cvU3IQKI4/DHY+7f7B2cetJ77lSWlgybssPgem97I1Vrk1GgJLJZh/GAsSg0yz+PDYD
         pvEQ==
X-Gm-Message-State: APjAAAV9FLWpnrfbOXrSccnGNiykQhOjLOeVga6x4V20Auq4XoAIqWnj
        2W/W0zlrx+eUcU0ameMVY8g=
X-Google-Smtp-Source: APXvYqyLQD/uoznzJK80E87XPvvlBxI2esMHs4Lc0c2FiNFhE1JCzQiQ97R/mITRAGLVI0hBkdP8jg==
X-Received: by 2002:a17:902:b417:: with SMTP id x23mr2630326plr.9.1582609290508;
        Mon, 24 Feb 2020 21:41:30 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:400::5:3b30])
        by smtp.gmail.com with ESMTPSA id t11sm1382841pjo.21.2020.02.24.21.41.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Feb 2020 21:41:29 -0800 (PST)
Date:   Mon, 24 Feb 2020 21:41:27 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Kees Cook <keescook@chromium.org>
Cc:     Casey Schaufler <casey@schaufler-ca.com>,
        KP Singh <kpsingh@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Security Module list 
        <linux-security-module@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        James Morris <jmorris@namei.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next v4 3/8] bpf: lsm: provide attachment points for
 BPF LSM programs
Message-ID: <20200225054125.dttrc3fvllzu4mx5@ast-mbp>
References: <20200220175250.10795-1-kpsingh@chromium.org>
 <20200220175250.10795-4-kpsingh@chromium.org>
 <0ef26943-9619-3736-4452-fec536a8d169@schaufler-ca.com>
 <202002211946.A23A987@keescook>
 <20200223220833.wdhonzvven7payaw@ast-mbp>
 <c5c67ece-e5c1-9e8f-3a2b-60d8d002c894@schaufler-ca.com>
 <20200224171305.GA21886@chromium.org>
 <00c216e1-bcfd-b7b1-5444-2a2dfa69190b@schaufler-ca.com>
 <202002241136.C4F9F7DFF@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202002241136.C4F9F7DFF@keescook>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 24, 2020 at 01:41:19PM -0800, Kees Cook wrote:
> 
> But the LSM subsystem doesn't want special cases (Casey has worked very
> hard to generalize everything there for stacking). It is really hard to
> accept adding a new special case when there are still special cases yet
> to be worked out even in the LSM code itself[2].
> [2] Casey's work to generalize the LSM interfaces continues and it quite
> complex:
> https://lore.kernel.org/linux-security-module/20200214234203.7086-1-casey@schaufler-ca.com/

I think the key mistake we made is that we classified KRSI as LSM.
LSM stacking, lsmblobs that the above set is trying to do are not necessary for KRSI.
I don't see anything in LSM infra that KRSI can reuse.
The only thing BPF needs is a function to attach to.
It can be a nop function or any other.
security_*() functions are interesting from that angle only.
Hence I propose to reconsider what I was suggesting earlier.
No changes to secruity/ directory.
Attach to security_*() funcs via bpf trampoline.
The key observation vs what I was saying earlier is KRSI and LSM are wrong names.
I think "security" is also loaded word that should be avoided.
I'm proposing to rename BPF_PROG_TYPE_LSM into BPF_PROG_TYPE_OVERRIDE_RETURN.

> So, unless James is going to take this over Casey's objections, the path
> forward I see here is:
> 
> - land a "slow" KRSI (i.e. one that hooks every hook with a stub).
> - optimize calling for all LSMs

I'm very much surprised how 'slow' KRSI is an option at all.
'slow' KRSI means that CONFIG_SECURITY_KRSI=y adds indirect calls to nop
functions for every place in the kernel that calls security_*().
This is not an acceptable overhead. Even w/o retpoline
this is not something datacenter servers can use.

Another option is to do this:
diff --git a/include/linux/security.h b/include/linux/security.h
index 64b19f050343..7887ce636fb1 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -240,7 +240,7 @@ static inline const char *kernel_load_data_id_str(enum kernel_load_data_id id)
        return kernel_load_data_str[id];
 }

-#ifdef CONFIG_SECURITY
+#if defined(CONFIG_SECURITY) || defined(CONFIG_BPF_OVERRIDE_RETURN)

Single line change to security.h and new file kernel/bpf/override_security.c
that will look like:
int security_binder_set_context_mgr(struct task_struct *mgr)
{
        return 0;
}

int security_binder_transaction(struct task_struct *from,
                                struct task_struct *to)
{
        return 0;
}
Essentially it will provide BPF side with a set of nop functions.
CONFIG_SECURITY is off. It may seem as a downside that it will force a choice
on kernel users. Either they build the kernel with CONFIG_SECURITY and their
choice of LSMs or build the kernel with CONFIG_BPF_OVERRIDE_RETURN and use
BPF_PROG_TYPE_OVERRIDE_RETURN programs to enforce any kind of policy. I think
it's a pro not a con.
