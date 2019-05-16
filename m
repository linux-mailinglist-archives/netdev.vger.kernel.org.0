Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72F7B20D77
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 18:54:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727229AbfEPQyy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 12:54:54 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:46297 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726342AbfEPQyy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 May 2019 12:54:54 -0400
Received: by mail-qk1-f196.google.com with SMTP id a132so2644534qkb.13
        for <netdev@vger.kernel.org>; Thu, 16 May 2019 09:54:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=RSXji2gu6PTmCCcGE3ApJyZXicrhpNir4c6ptrlMBZw=;
        b=w8X3UASCEUM3vJvJ4NqGiATkR0s8WmNbhjJJSUDD4HQ5v2XUQijD5IJAoCIwFIhnIj
         yNJkhZYd7EOu7n7SoaVlYcXwxxjQKwyi/SFjLgKx66liMvMlrocYvplC/NEHCFvtfN1k
         Lhu4GdtukplsBg9cVyo/2p/lF/duxEKZhUOyrWibtP6yVb/v7XY3D179ye4XGcdRUpvw
         VBtXRW73769UYS9SMc3eo16qzfMNhEBSNnpV/FNMxkacKLujZ4mbEiM4GLZfmWc/0mh6
         8V2onWzspsxdE4pGSB/44M+XrNRnL3RHDWgg+m1CIMruHaQFLlgAPhErMXplm+cg6ZnC
         pT+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=RSXji2gu6PTmCCcGE3ApJyZXicrhpNir4c6ptrlMBZw=;
        b=C4IDwFtX6UV32gBBygNrnSUvUbcBpUZH/NJ7gm5Rg1XQ9HFWF+rSaOW8zWk/lz5r4l
         cHtUGSuHRIatw+a5fsko/NEVvBijYnwdesP4KlnqwzsYaMA1YnG3k3gyll8IBxe+HQ5W
         mHzEAh6RU0HV2Sh/pk0jRjF3vH5kHit84JVqincKwtNUbW9CH3uYvOrIbRGtuhQnCDnW
         I6VSgJ7iflFkgomzg6lYW2vhEG2sIhyJFAf/MKuaV/KyNn/JXlCqOLhjFSycXB2fu8Sg
         ec4mWD8Jp0GPqgWoAnCEORTomjbweP35o+hrvT2sF6fXhE3C126Wl1NitICEZoeHleqa
         M+5A==
X-Gm-Message-State: APjAAAUNlBxLZmwkZAgz8OvRyq0WSvARqAIDGsTHQjinRhTjlLptXwIo
        s6/8P57RJfcExqKmft5AxZHgmA==
X-Google-Smtp-Source: APXvYqzFFPIoAoCXHLuAi3qkHjprBS7BtRM/qvWx3GdjcQWNy0cAs5xxZ7wEPTSo5KalHZN4PMzVWQ==
X-Received: by 2002:a05:620a:144c:: with SMTP id i12mr12814987qkl.243.1558025693089;
        Thu, 16 May 2019 09:54:53 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id 91sm2696400qte.38.2019.05.16.09.54.51
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 16 May 2019 09:54:52 -0700 (PDT)
Date:   Thu, 16 May 2019 09:54:26 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Krzesimir Nowak <krzesimir@kinvolk.io>
Cc:     bpf@vger.kernel.org,
        Iago =?UTF-8?B?TMOzcGV6?= Galeiras <iago@kinvolk.io>,
        "Alban Crequy (Kinvolk)" <alban@kinvolk.io>,
        Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrey Ignatov <rdna@fb.com>, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ogerlitz@mellanox.com
Subject: Re: [PATCH bpf v1 2/3] selftests/bpf: Print a message when tester
 could not run a program
Message-ID: <20190516095426.2e0d838f@cakuba.netronome.com>
In-Reply-To: <CAGGp+cEFxzbH-8vnSAK3sZkM-u3WN4HGnkYvhFwBp85yVtD7Xg@mail.gmail.com>
References: <20190515134731.12611-1-krzesimir@kinvolk.io>
        <20190515134731.12611-3-krzesimir@kinvolk.io>
        <20190515144537.57f559e7@cakuba.netronome.com>
        <CAGGp+cGN+YYVjJee5ba84HstSrHGurBvwmKmzNsFRvb344Df3A@mail.gmail.com>
        <20190516085035.3cdb0ae6@cakuba.netronome.com>
        <CAGGp+cEFxzbH-8vnSAK3sZkM-u3WN4HGnkYvhFwBp85yVtD7Xg@mail.gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 May 2019 18:21:32 +0200, Krzesimir Nowak wrote:
> On Thu, May 16, 2019 at 5:51 PM Jakub Kicinski wrote:
> > On Thu, 16 May 2019 11:29:39 +0200, Krzesimir Nowak wrote:  
> > > > > diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
> > > > > index ccd896b98cac..bf0da03f593b 100644
> > > > > --- a/tools/testing/selftests/bpf/test_verifier.c
> > > > > +++ b/tools/testing/selftests/bpf/test_verifier.c
> > > > > @@ -825,11 +825,20 @@ static int do_prog_test_run(int fd_prog, bool unpriv, uint32_t expected_val,
> > > > >                               tmp, &size_tmp, &retval, NULL);
> > > > >       if (unpriv)
> > > > >               set_admin(false);
> > > > > -     if (err && errno != 524/*ENOTSUPP*/ && errno != EPERM) {
> > > > > -             printf("Unexpected bpf_prog_test_run error ");
> > > > > -             return err;
> > > > > +     if (err) {
> > > > > +             switch (errno) {
> > > > > +             case 524/*ENOTSUPP*/:
> > > > > +                     printf("Did not run the program (not supported) ");
> > > > > +                     return 0;
> > > > > +             case EPERM:
> > > > > +                     printf("Did not run the program (no permission) ");
> > > > > +                     return 0;  
> > > >
> > > > Perhaps use strerror(errno)?  
> > >
> > > As I said in the commit message, I open-coded those messages because
> > > strerror for ENOTSUPP returns "Unknown error 524".  
> >
> > Ah, sorry, missed that.  I wonder if that's something worth addressing
> > in libc, since the BPF subsystem uses ENOTSUPP a lot.  
> 
> The "not supported" errno situation seems to be a mess. There is an
> ENOTSUP define in libc. ENOTSUP is usually defined to be EOPNOTSUPP
> (taken from kernel), which in turn seems to have a different value
> (95) than kernel's ENOTSUPP (524). Adding ENOTSUPP (with two Ps) to
> libc would only add to the confusion. So it's kind of meh and I guess
> people just moved on with workarounds.

Yes, ENOTSUP is never used in the kernel, but it's a mess.

This commit a while ago said ENOTSUPP is from NFS:

commit 423b3aecf29085a52530d4f9167c56a84b081042
Author: Or Gerlitz <ogerlitz@mellanox.com>
Date:   Thu Feb 23 12:02:41 2017 +0200

    net/mlx4: Change ENOTSUPP to EOPNOTSUPP
    
    As ENOTSUPP is specific to NFS, change the return error value to
    EOPNOTSUPP in various places in the mlx4 driver.
    
    Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
    Suggested-by: Yotam Gigi <yotamg@mellanox.com>
    Reviewed-by: Matan Barak <matanb@mellanox.com>
    Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

But it's spreading throughout the kernel like a wildfire, I counted 1364
in my tree :/  Some are in tools/, but still.  My understanding was that
system calls should never return values above 512, but I'm probably
wrong about that.

Given the popularity, and the fact its an ABI at this point, we
probably have no choice but to add it to libc, but to be clear IMO it's
not a blocker for your patches.
