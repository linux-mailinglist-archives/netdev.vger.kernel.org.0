Return-Path: <netdev+bounces-1512-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0EA936FE0D7
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 16:55:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C7009281528
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 14:55:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 971D516406;
	Wed, 10 May 2023 14:55:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86E5014A93
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 14:55:54 +0000 (UTC)
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AEB22108
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 07:55:51 -0700 (PDT)
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com [209.85.128.197])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id F233F3F32E
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 14:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1683730549;
	bh=REcjCSTFLW6DxVGPSke0wQC0F9pbu2fUgTklQWt5AuI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type;
	b=fmZ2wIuGSHsU7PDNHnHnmKrmLcbM6T+MeUK+3KcttiBcAzDs5l+HIGD3g8y4y6Uv8
	 MBhgdVWG5HVd7I6OKs2pjTURFG5IIgye/TRtjRO7JCbyV26Olpjr6jlDSMeDRKAc8Q
	 HJXPcHkZ4VbpyimBEXUBsf7Eyr+r+rUK9pf9ljQ5aSpTVN0EwBUaKWQQjOHXti0uSX
	 so9j+v1o5TduuysxpuAOaMbZajY8QflHAoAnVDO5e4R3C9qgRwRpBl5zDvqpIzEEKS
	 1grOw5Oh+LWVqukfwb6LY9n4Z0vlymg3UOTT2TENUFF389cgrnS0LHe3j6uPeo6HQc
	 i1RCjputSPwpw==
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-560ee0df572so8579537b3.0
        for <netdev@vger.kernel.org>; Wed, 10 May 2023 07:55:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683730549; x=1686322549;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=REcjCSTFLW6DxVGPSke0wQC0F9pbu2fUgTklQWt5AuI=;
        b=BVZZeYqvVAE3RRimZ2rE7pmHg6f8WLwN5T5KGfcKYWfhYfwMuYABhuAj/pnQJPYOLK
         X81Z5u7RByxgF9RpyrsuAABANGSkccvmBP856jfrHt7F8wQN+I/vOFwyp8n8P9ppq+Ie
         CB7ZwaxvYMxsDlX79qkt1itJGbdhzuFDwIENO9dgSkMgK1Qipk8GZQefrhm37+N+0d/y
         DZpkpeqt1qs/w/tS3c7EW0dotUe+wQ9oTag3iIxxKAA83i8LYArjXdeLjDXhXdTWgQo4
         lHgc+0TTWhj91wPzWvuhKNE8lxOg8mzcszjmHIkeyZs29wO4XBXkHMOK6JbyOZ4gHpGS
         10hQ==
X-Gm-Message-State: AC+VfDwyAJSDfBiXW+DWsB46nJnYaO43K/J7R8rRYMj9POSkfqLJZ4rI
	lWsbVTZOCDrOfckxYuWet+n3kiqQXXu7d34TFtvsJYbY4cTZMKkdLTvXDxX+EGvBZFzS2M7bDFG
	mNMHOIXpk/dytXguQCWYVqAS1xdYvEnLyyhYGnmriBz15EmdEgA==
X-Received: by 2002:a81:83c7:0:b0:559:f029:992d with SMTP id t190-20020a8183c7000000b00559f029992dmr19067710ywf.24.1683730548828;
        Wed, 10 May 2023 07:55:48 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4Hnxj29587wz4D/QOv5wYbNoK5zIRdPowtRAgz0Cdi165hPAX1WVSJsBubNrvNcm9fx26AIHNjd27vMKw8uio=
X-Received: by 2002:a81:83c7:0:b0:559:f029:992d with SMTP id
 t190-20020a8183c7000000b00559f029992dmr19067692ywf.24.1683730548592; Wed, 10
 May 2023 07:55:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230510131527.1244929-1-aleksandr.mikhalitsyn@canonical.com> <ZFusunmfAaQVmBE2@t14s.localdomain>
In-Reply-To: <ZFusunmfAaQVmBE2@t14s.localdomain>
From: Aleksandr Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Date: Wed, 10 May 2023 16:55:37 +0200
Message-ID: <CAEivzxdfZaLD40cBKo7aqiwspwBeqeULR+RAv6jJ_wo-zV6UpQ@mail.gmail.com>
Subject: Re: [PATCH net-next] sctp: add bpf_bypass_getsockopt proto callback
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: nhorman@tuxdriver.com, davem@davemloft.net, 
	Daniel Borkmann <daniel@iogearbox.net>, Christian Brauner <brauner@kernel.org>, 
	Stanislav Fomichev <sdf@google.com>, Xin Long <lucien.xin@gmail.com>, linux-sctp@vger.kernel.org, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 10, 2023 at 4:39=E2=80=AFPM Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
>
> On Wed, May 10, 2023 at 03:15:27PM +0200, Alexander Mikhalitsyn wrote:
> > Add bpf_bypass_getsockopt proto callback and filter out
> > SCTP_SOCKOPT_PEELOFF and SCTP_SOCKOPT_PEELOFF_FLAGS socket options
> > from running eBPF hook on them.
> >
> > These options do fd_install(), and if BPF_CGROUP_RUN_PROG_GETSOCKOPT
> > hook returns an error after success of the original handler
> > sctp_getsockopt(...), userspace will receive an error from getsockopt
> > syscall and will be not aware that fd was successfully installed into f=
dtable.
> >
> > This patch was born as a result of discussion around a new SCM_PIDFD in=
terface:
> > https://lore.kernel.org/all/20230413133355.350571-3-aleksandr.mikhalits=
yn@canonical.com/
>
> I read some of the emails in there but I don't get why the fd leak is
> special here. I mean, I get that it leaks, but masking the error
> return like this can lead to several other problems in the application
> as well.
>
> For example, SCTP_SOCKOPT_CONNECTX3 will trigger a connect(). If it
> failed, and the hook returns success, the user app will at least log a
> wrong "connection successful".
>
> If the hook can't be responsible for cleaning up before returning a
> different value, then maybe we want to extend the list of sockopts in
> here. AFAICT these would be the 3 most critical sockopts.
>

Dear Marcelo,

Thanks for pointing this out. Initially this problem was discovered by
Christian Brauner and for SO_PEERPIDFD (a new SOL_SOCKET option that
we want to add),
after this I decided to check if we do fd_install in any other socket
options in the kernel and found that we have 2 cases in SCTP. It was
an accidental finding. :)

So, this patch isn't specific to fd_install things and probably we
should filter out bpf hook from being called for other socket options
as well.

So, I need to filter out SCTP_SOCKOPT_CONNECTX3 and
SCTP_SOCKOPT_PEELOFF* for SCTP, right?

Kind regards,
Alex

