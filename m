Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D93DD442CBD
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 12:36:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231267AbhKBLjU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 07:39:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:49180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231219AbhKBLjT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Nov 2021 07:39:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9EEA460E0C;
        Tue,  2 Nov 2021 11:36:41 +0000 (UTC)
Date:   Tue, 2 Nov 2021 12:36:37 +0100
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Miklos Szeredi <miklos@szeredi.hu>
Cc:     Lorenz Bauer <lmb@cloudflare.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        network dev <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH bpf-next v3 2/4] libfs: support RENAME_EXCHANGE in
 simple_rename()
Message-ID: <20211102113637.qfystxmvzmr6yqhq@wittgenstein>
References: <20211028094724.59043-1-lmb@cloudflare.com>
 <20211028094724.59043-3-lmb@cloudflare.com>
 <CAJfpegvPrQBnYO3XNcCHODBBCXm6uH73zOWXs+sfn=3LQmMyww@mail.gmail.com>
 <7988de27-1718-60c1-ec03-9343d2cc460f@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <7988de27-1718-60c1-ec03-9343d2cc460f@iogearbox.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 02, 2021 at 11:11:02AM +0100, Daniel Borkmann wrote:
> On 11/2/21 10:25 AM, Miklos Szeredi wrote:
> > On Thu, 28 Oct 2021 at 11:48, Lorenz Bauer <lmb@cloudflare.com> wrote:
> > > 
> > > Allow atomic exchange via RENAME_EXCHANGE when using simple_rename.
> > > This affects binderfs, ramfs, hubetlbfs and bpffs.
> > 
> > Ramfs and hugetlbfs are generic enough; those seem safe.
> > 
> > Binderfs: I have no idea what this does; binderfs_rename() should

Fwiw, allows dynamic creation and removal of Android binder ipc
devices. Each mount is a separate instance and it's mountable inside
unprivileged containers. Since Android 12 default how binder devices are
managed. Also makes it possibe to run Android in unprivileged
containers.

> > probably error out on RENAME_EXCHANGE for now, or an explicit ack from
> > the maintainers.
> 
> Thanks for the review, Miklos! Adding Christian to Cc wrt binderfs ... full context
> for all patches: https://lore.kernel.org/bpf/20211028094724.59043-1-lmb@cloudflare.com/

Yep, I saw that. Seems good.

> probably error out on RENAME_EXCHANGE for now, or an explicit ack from
> the maintainers.

I don't think there is any issue in allowing binderfs to support this.
Binderfs files are always device nodes. Allowing them to be atomically
renamed shouldn't be a problem. So:

Acked-by: Christian Brauner <christian.brauner@ubuntu.com>

Christian
