Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1A173943AD
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 15:58:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236242AbhE1N7k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 09:59:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:40240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236185AbhE1N7i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 May 2021 09:59:38 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DBD3B61184;
        Fri, 28 May 2021 13:58:01 +0000 (UTC)
Date:   Fri, 28 May 2021 09:58:00 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Ondrej Mosnacek <omosnace@redhat.com>
Cc:     linux-security-module@vger.kernel.org,
        James Morris <jmorris@namei.org>,
        Ingo Molnar <mingo@redhat.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        selinux@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-fsdevel@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH v2] lockdown,selinux: avoid bogus SELinux lockdown
 permission checks
Message-ID: <20210528095800.06b6547d@gandalf.local.home>
In-Reply-To: <20210517092006.803332-1-omosnace@redhat.com>
References: <20210517092006.803332-1-omosnace@redhat.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 17 May 2021 11:20:06 +0200
Ondrej Mosnacek <omosnace@redhat.com> wrote:

> diff --git a/fs/tracefs/inode.c b/fs/tracefs/inode.c
> index 1261e8b41edb..7edde3fc22f5 100644
> --- a/fs/tracefs/inode.c
> +++ b/fs/tracefs/inode.c
> @@ -396,7 +396,7 @@ struct dentry *tracefs_create_file(const char *name, umode_t mode,
>  	struct dentry *dentry;
>  	struct inode *inode;
>  
> -	if (security_locked_down(LOCKDOWN_TRACEFS))
> +	if (security_cred_locked_down(NULL, LOCKDOWN_TRACEFS))
>  		return NULL;
>  
>  	if (!(mode & S_IFMT))

Acked-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

-- Steve
