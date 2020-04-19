Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D0F51AF717
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 06:54:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726036AbgDSEyK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 00:54:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725763AbgDSEyJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Apr 2020 00:54:09 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 343CAC061A0C;
        Sat, 18 Apr 2020 21:54:09 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id i2so3446439ybk.2;
        Sat, 18 Apr 2020 21:54:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Gog0dknM05EMtGVHWyU1DT7VuRc7nYwUpeTOmS66nno=;
        b=nHn0HnEoktBrbfUcj+ZOPirGnQncKk4bHCrDStjtphOSF7bEr+pXuF9TflkLymQDwU
         JLP9cTNkEi4eDTTijxfx8Lzqan2IONHkpataQ73Xi23AZLZKRTtqioenP1GMzUTW89F6
         L/ZnDRYzmODT6t4cQAbj8orEcwDmfiOdLHrLOiLzFrB/RLeWqvOXv+FV/RM9nBV2mPoe
         H7pGMrAI06Td1kFo9HT9S+PVFkqmIzWCrLdPJ1b1wVJgARkHy9dtWLdi1kLUySdJwXgQ
         Umj4VWNaUTQPYwFkbjJStreNlh8SMLlUtVA8UogqzA5/CDHHUzIi7m7OLJah7i6spynI
         MxUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Gog0dknM05EMtGVHWyU1DT7VuRc7nYwUpeTOmS66nno=;
        b=pmO0GKLzeQCeMX+WO1ADP8AGlO5UZ87vALfJ4+9tEjXL9keJnjJbPsBYpOxUH/u+e2
         1bhY1XVcx8Dv4sOmvFcMVBxbDqUx9mQYtaFf/6z3reOptWKV6wp0aiE9XzP/UQO92CZg
         f5gznff4tG1umK2ETaVWkERJ8oB12RsIi3IQ+pkQ/y71QHHSwOwmX9X3UvbtNTkCBD5E
         0uKzYnFwyAbVg6uhB9eJXeQKimPaiyWMbWOvzhqOP2ZrAhL3bDjrWjkM/uWmZ40/8EXp
         ksalpqh8e+w63gkYdix8VdATtTG/UYLRRnS1nNP6wDYP1lsNvBi9g4uVVuF7HYf/ppdH
         ZvaQ==
X-Gm-Message-State: AGi0PuY75pTLjoU327C9OkLo5BptHF2bcfgLhDINaRp+SYaBE/pM2mjF
        DG+tdaWiJUKe5d4kJWxzPjEk9WYMXaTo24NNM/s=
X-Google-Smtp-Source: APiQypKexOfCMHJoNZ1DUDrRLe7fxIec4nFsf9towAfH9uHBxh8i1vwDgiNOHtLvi8jVmjXwsDfRpb2RLG/yU7rA8RU=
X-Received: by 2002:a25:cf12:: with SMTP id f18mr9682392ybg.167.1587272048258;
 Sat, 18 Apr 2020 21:54:08 -0700 (PDT)
MIME-Version: 1.0
References: <3865908.1586874010@warthog.procyon.org.uk> <CAH2r5mv5p=WJQu2SbTn53FeTsXyN6ke_CgEjVARQ3fX8QAtK_w@mail.gmail.com>
 <87a738aclu.fsf@oldenburg2.str.redhat.com>
In-Reply-To: <87a738aclu.fsf@oldenburg2.str.redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 18 Apr 2020 23:53:57 -0500
Message-ID: <CAH2r5mth8Jc0dfAOP+hXTp-hJBHoNT4M=J8Ypcq+BhP4a_Wc6Q@mail.gmail.com>
Subject: Re: What's a good default TTL for DNS keys in the kernel
To:     Florian Weimer <fweimer@redhat.com>
Cc:     David Howells <dhowells@redhat.com>,
        linux-nfs <linux-nfs@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>, linux-afs@lists.infradead.org,
        ceph-devel@vger.kernel.org, keyrings@vger.kernel.org,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

commit 28eb24ff75c5ac130eb326b3b4d0dcecfc0f427d
Author: Paulo Alcantara <paulo@paulo.ac>
Date:   Tue Nov 20 15:16:36 2018 -0200

    cifs: Always resolve hostname before reconnecting

    In case a hostname resolves to a different IP address (e.g. long
    running mounts), make sure to resolve it every time prior to calling
    generic_ip_connect() in reconnect.
...

(Note that this patch may have some minor dependencies on a few other
DFS related patches that were merged immediately before it.
08744015492f cifs: Add support for failover in cifs_reconnect_tcon()
a3a53b760379 cifs: Add support for failover in smb2_reconnect()
23324407143d cifs: Only free DFS target list if we actually got one
e511d31753e3 cifs: start DFS cache refresher in cifs_mount()
93d5cb517db3 cifs: Add support for failover in cifs_reconnect()
4a367dc04435 cifs: Add support for failover in cifs_mount()
1c780228e9d4 cifs: Make use of DFS cache to get new DFS referrals

On Sat, Apr 18, 2020 at 1:11 PM Florian Weimer <fweimer@redhat.com> wrote:
>
> * Steve French:
>
> >>> The question remains what the expected impact of TTL expiry is.  Will
> >>> the kernel just perform a new DNS query if it needs one?
> >
> > For SMB3/CIFS mounts, Paulo added support last year for automatic
> > reconnect if the IP address of the server changes.  It also is helpful
> > when DFS (global name space) addresses change.
>
> Do you have reference to the source code implementation?  Thanks.
>
> Florian
>


-- 
Thanks,

Steve
