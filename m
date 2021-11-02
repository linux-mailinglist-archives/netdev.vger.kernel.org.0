Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABD724439C3
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 00:33:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230227AbhKBXgE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 19:36:04 -0400
Received: from todd.t-8ch.de ([159.69.126.157]:45095 "EHLO todd.t-8ch.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230054AbhKBXgD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Nov 2021 19:36:03 -0400
Date:   Tue, 2 Nov 2021 23:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=t-8ch.de; s=mail;
        t=1635896007; bh=EoDfytdV+LSXDNnXqYAA0Tk6wiOd883CujH+OC5GBas=;
        h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
        b=IquYBEBhTXBPDy7frCaGYIJqGtKLZuQ+tsWQKdUr1a2M98cA6+yiEWUhGjTILhtwG
         fOP8s56lQBrnbyH18VNfzjGTElO3YRWvBxaminNvTFmAo70QuiUpRz2o3Egeuexx16
         zX+WtIhN85oWC/FhoLy5BsJ9tIliaBHOrTtT6D7U=
From:   =?UTF-8?Q?Thomas_Wei=C3=9Fschuh_?= <thomas@t-8ch.de>
To:     Dominique Martinet <asmadeus@codewreck.org>
Cc:     =?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <778dfd93-ace5-4cab-9a08-21d279f18c1f@t-8ch.de>
In-Reply-To: <YYHHHy0qJGlpGEaQ@codewreck.org>
References: <20211017134611.4330-1-linux@weissschuh.net> <YYEYMt543Hg+Hxzy@codewreck.org> <922a4843-c7b0-4cdc-b2a6-33bf089766e4@t-8ch.de> <YYEmOcEf5fjDyM67@codewreck.org> <ddf6b6c9-1d9b-4378-b2ee-b7ac4a622010@t-8ch.de> <YYFSBKXNPyIIFo7J@codewreck.org> <3e8fcaff-6a2e-4546-87c9-a58146e02e88@t-8ch.de> <YYHHHy0qJGlpGEaQ@codewreck.org>
Subject: Re: [PATCH] net/9p: autoload transport modules
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Correlation-ID: <778dfd93-ace5-4cab-9a08-21d279f18c1f@t-8ch.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Nov 3, 2021 00:18:13 Dominique Martinet <asmadeus@codewreck.org>:

> Thomas Wei=C3=9Fschuh wrote on Tue, Nov 02, 2021 at 04:32:21PM +0100:
>>> with 9p/9pnet loaded,
>>> running "mount -t 9p -o trans=3Dvirtio tmp /mnt"
>>> request_module("9p-%s", "virtio") returns -2 (ENOENT)
>>
>> Can you retry without 9p/9pnet loaded and see if they are loaded by the =
mount
>> process?
>> The same autoloading functionality exists for filesystems using
>> request_module("fs-%s") in fs/filesystems.c
>> If that also doesn't work it would indicate an issue with the kernel set=
up in general.
>
> Right, that also didn't work, which matches modprobe not being called
> correctly
>
>
>>> Looking at the code it should be running "modprobe -q -- 9p-virtio"
>>> which finds the module just fine, hence my supposition usermodhelper is
>>> not setup correctly
>>>
>>> Do you happen to know what I need to do for it?
>>
>> What is the value of CONFIG_MODPROBE_PATH?
>> And the contents of /proc/sys/kernel/modprobe?
>
> aha, these two were indeed different from where my modprobe is so it is
> a setup problem -- I might have been a little rash with this initrd
> setup and modprobe ended up in /bin with path here in /sbin...
>
> Thanks for the pointer, I saw the code setup an environment with a
> full-blown PATH so didn't think of checking if this kind of setting
> existed!
> All looks in order then :)

Does it also work for the split out FD transports?
If so, I'll resend that patch in a proper form tomorrow.

Thomas
