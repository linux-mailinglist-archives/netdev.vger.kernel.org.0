Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35EF539EFB3
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 09:36:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230331AbhFHHiZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 03:38:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229678AbhFHHiY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 03:38:24 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23918C061574;
        Tue,  8 Jun 2021 00:36:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Date:Message-ID:From:Cc:To;
        bh=SbRCszcM+0Us1EZPMrPmKxX/D+gZYBJAD3AMc854kic=; b=dErj90Fa5bYOeuVyaADbtDZXEx
        tLRqwllTrHcn62DFtOZiRigMuz5olTQhyCF3/krCH+Zq6p3ZyGp52Awxcd8VIzqa5KAJsAuYHCMI+
        bJH7kLjykVAwKZZkFKrRldU9CWJrRQtPa8+Djc5mzPXL6g4AH4fKjB2cCUBE4kCrNIuwMtbo1c41Z
        2IBGesUZkDILk77oumxBM/I0X+WpWsDEzlG4+W5VS5D7lodFygQU1UhaerEiGX0Q+kzcn2QbWq9W5
        CqnDpAGLKGvnO1HcNTR1en/UaF1uctFZ2D5pWZ0Sho8bN2wDxwIAFVMPJVIZa7zkLDIOGG0n2YaGr
        zK52Xx0lSr3PsX9dFqlY6lXCZUQJ/3dkMkZX0nlj2hNYfWwwWxkDmgctkL/ipdp32GQtCFGxOXmXu
        541qlpn0PjDvcgrg7bgCGMVllqrYzz94EsEZdnDox5xuqxnWmJCUJ9+aBeYyDfOmNjy1YWRfICgpa
        XZOlGON/7NfVJA5YvMe7inhV;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lqWHj-0000gt-Rt; Tue, 08 Jun 2021 07:36:27 +0000
To:     Steve French <smfrench@gmail.com>,
        =?UTF-8?Q?Aur=c3=a9lien_Aptel?= <aaptel@suse.com>
Cc:     Alexander Ahring Oder Aring <aahringo@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        linux-nfs <linux-nfs@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        Leif Sahlberg <lsahlber@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
References: <CAK-6q+hS29yoTF4tKq+Xt3G=_PPDi9vmFVwGPmutbsQyD2i=CA@mail.gmail.com>
 <87pmwxsjxm.fsf@suse.com>
 <CAH2r5msMBZ5AYQcfK=-xrOASzVC0SgoHdPnyqEPRcfd-tzUstw@mail.gmail.com>
From:   Stefan Metzmacher <metze@samba.org>
Subject: Re: quic in-kernel implementation?
Message-ID: <35352ef0-86ed-aaa5-4a49-b2b08dc3674d@samba.org>
Date:   Tue, 8 Jun 2021 09:36:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <CAH2r5msMBZ5AYQcfK=-xrOASzVC0SgoHdPnyqEPRcfd-tzUstw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 08.06.21 um 05:04 schrieb Steve French:
> On Mon, Jun 7, 2021 at 11:45 AM Aurélien Aptel <aaptel@suse.com> wrote:
>>
>> Alexander Ahring Oder Aring <aahringo@redhat.com> writes:
>>> as I notice there exists several quic user space implementations, is
>>> there any interest or process of doing an in-kernel implementation? I
>>> am asking because I would like to try out quic with an in-kernel
>>> application protocol like DLM. Besides DLM I've heard that the SMB
>>> community is also interested into such implementation.
>>
>> Yes SMB can work over QUIC. It would be nice if there was an in-kernel
>> implementation that cifs.ko could use. Many firewall block port 445
>> (SMB) despite the newer version of the protocol now having encryption,
>> signing, etc. Using QUIC (UDP port 443) would allow for more reliable
>> connectivity to cloud storage like azure.
>>
>> There are already multiple well-tested C QUIC implementation out there
>> (Microsoft one for example, has a lot of extra code annotation to allow
>> for deep static analysis) but I'm not sure how we would go about porting
>> it to linux.
>>
>> https://github.com/microsoft/msquic
> 
> Since the Windows implementation of SMB3.1.1 over QUIC appears stable
> (for quite a while now) and well tested, and even wireshark can now decode it, a
> possible sequence of steps has been discussed similar to the below:
> 
> 1) using a userspace port of QUIC (e.g. msquic since is one of the more tested
> ports, and apparently similar to what already works well for QUIC on Windows
> with SMB3.1.1) finish up the SMB3.1.1 kernel pieces needed for running over
> QUIC

Instead of using userspace upcalls directly, it would be great if we could hide
behind a fuse-like socket type, in order to keep the kernel changes in fs/cifs (and other parts)
tiny and just replace the socket(AF_INET) call, but continue to use a
stream socket (likely with a few QUIC specific getsockopt/setsockopt calls).

It would also allow userspace applications like Samba's smbclient and smbd
to use it that way too.

> 2) then switch focus to porting a smaller C userspace implementation of
> QUIC to Linux (probably not msquic since it is larger and doesn't
> follow kernel style)
> to kernel in fs/cifs  (since currently SMB3.1.1 is the only protocol
> that uses QUIC,
> and the Windows server target is quite stable and can be used to test against)> 3) use the userspace upcall example from step 1 for
> comparison/testing/debugging etc.
> since we know the userspace version is stable

With having the fuse-like socket before it should be trivial to switch
between the implementations.

> 4) Once SMB3.1.1 over QUIC is no longer experimental, remove, and
> we are convinced it (kernel QUIC port) works well with SMB3.1.1
> to servers which support QUIC, then move the quic code from fs/cifs to the /net
> tree

The 4th step would then finally allocate a stable PF_QUIC which would be
ABI stable.

metze
