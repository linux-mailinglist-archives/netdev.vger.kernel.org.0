Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57DE42166C4
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 08:50:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728289AbgGGGtg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 02:49:36 -0400
Received: from verein.lst.de ([213.95.11.211]:57382 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726540AbgGGGtf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Jul 2020 02:49:35 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 0629668B05; Tue,  7 Jul 2020 08:49:32 +0200 (CEST)
Date:   Tue, 7 Jul 2020 08:49:31 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Kees Cook <keescook@chromium.org>
Cc:     linux-kernel@vger.kernel.org, Sargun Dhillon <sargun@sargun.me>,
        Christian Brauner <christian@brauner.io>,
        Tycho Andersen <tycho@tycho.ws>,
        David Laight <David.Laight@ACULAB.COM>,
        Christoph Hellwig <hch@lst.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Aleksa Sarai <cyphar@cyphar.com>,
        Matt Denton <mpdenton@google.com>,
        Jann Horn <jannh@google.com>, Chris Palmer <palmer@google.com>,
        Robert Sesek <rsesek@google.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Will Drewry <wad@chromium.org>, Shuah Khan <shuah@kernel.org>,
        netdev@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v6 3/7] fs: Add receive_fd() wrapper for __receive_fd()
Message-ID: <20200707064931.GB23649@lst.de>
References: <20200706201720.3482959-1-keescook@chromium.org> <20200706201720.3482959-4-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200706201720.3482959-4-keescook@chromium.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 06, 2020 at 01:17:16PM -0700, Kees Cook wrote:
> For both pidfd and seccomp, the __user pointer is not used. Update
> __receive_fd() to make writing to ufd optional via a NULL check. However,
> for the receive_fd_user() wrapper, ufd is NULL checked so an -EFAULT
> can be returned to avoid changing the SCM_RIGHTS interface behavior. Add
> new wrapper receive_fd() for pidfd and seccomp that does not use the ufd
> argument. For the new helper, the allocated fd needs to be returned on
> success. Update the existing callers to handle it.

Oh here we go, I'll take the last comment back.
