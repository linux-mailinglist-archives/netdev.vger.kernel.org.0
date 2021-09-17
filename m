Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A756D40EF1C
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 04:09:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242640AbhIQCKb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 22:10:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:51284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242632AbhIQCKa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Sep 2021 22:10:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5FD6361108;
        Fri, 17 Sep 2021 02:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631844549;
        bh=JyQLgmYuWrWIWVvqDvKaOdjjtIjX7izw2/8TAJWk3kc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EdUkCULlgmj164JvBKkluhYvU5IKeQrkf+cdzFs8X81cg25/oTyWDkAqJpkDQX9gS
         MCkl9pmxa5YdDJ1uix1yyag+vjdBJ8kR48PSZBgQo9bc0wSq0K5yLssCf+wIhmkws7
         2kzLBIWCxvq8DoYxF4wCAKO2eXwwaz58Ew2LTcwzdEq8A95fYkShvxg6funsDcaiT+
         mbUPuUG3WTX0tmBUml7l+HaG3Sz4BH77UKyhB5uopK0+18xXnq1zavEgSyLMIUh5RN
         PSZ0dP1Tv9q+zNsORh0BIgZH58nLQlejJYEAdr//uITIPqw+wlVgUuNZ13ao8yFDnt
         SRKhNChiFA1bQ==
Date:   Thu, 16 Sep 2021 19:09:08 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Christian Schoenebeck <linux_oss@crudebyte.com>
Cc:     v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        Dominique Martinet <asmadeus@codewreck.org>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Greg Kurz <groug@kaod.org>, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 0/7] net/9p: remove msize limit in virtio transport
Message-ID: <20210916190908.19824be5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <cover.1631816768.git.linux_oss@crudebyte.com>
References: <cover.1631816768.git.linux_oss@crudebyte.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 Sep 2021 20:26:08 +0200 Christian Schoenebeck wrote:
> This is an initial draft for getting rid of the current 500k 'msize'
> limitation in the 9p virtio transport, which is currently a bottleneck for
> performance of Linux 9p mounts.
> 
> This is a follow-up of the following series and discussion:
> https://lore.kernel.org/all/28bb651ae0349a7d57e8ddc92c1bd5e62924a912.1630770829.git.linux_oss@crudebyte.com/T/#eb647d0c013616cee3eb8ba9d87da7d8b1f476f37
> 
> Known limitation: With this series applied I can run
> 
>   QEMU host <-> 9P virtio <-> Linux guest
> 
> with up to 3 MB msize. If I try to run it with 4 MB it seems to hit some
> limitation on QEMU side:
> 
>   qemu-system-x86_64: virtio: too many write descriptors in indirect table
> 
> I haven't looked into this issue yet.
> 
> Testing and feedback appreciated!

nit - please run ./scripts/kernel-doc -none on files you're changing.
There seems to be a handful of warnings like this added by the series:

net/9p/trans_virtio.c:155: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
