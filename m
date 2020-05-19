Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59A961D9943
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 16:18:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729160AbgESOSF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 10:18:05 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:38743 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729089AbgESOSE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 10:18:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589897884;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FNB/aoMyF4TGVvRymSR3/vRA73Z6PL62rY+8MIyJp3Y=;
        b=TfagJx6mo95w5pyteohNt4KRUMnS2+LIFcNqIiK2eisYXV1KdY/K/4YNJLmIHof6Jjxv+O
        bfMxYVHnaSxfcFwcgkYdAo7F18RinUiGS0GKtNxwzP6FYAnBIf99f3TAJLC8aC12KRPJOm
        bQorUInhd0BqbUdHl/mNS+JUuBI3Va0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-17-159IX1CAOkG4oJ0ZYsciJw-1; Tue, 19 May 2020 10:18:00 -0400
X-MC-Unique: 159IX1CAOkG4oJ0ZYsciJw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D10E939342;
        Tue, 19 May 2020 14:17:58 +0000 (UTC)
Received: from oldenburg2.str.redhat.com (ovpn-113-18.ams2.redhat.com [10.36.113.18])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C3C85707DF;
        Tue, 19 May 2020 14:17:56 +0000 (UTC)
From:   Florian Weimer <fweimer@redhat.com>
To:     David Howells <dhowells@redhat.com>
Cc:     linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org,
        linux-afs@lists.infradead.org, ceph-devel@vger.kernel.org,
        keyrings@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dns: Apply a default TTL to records obtained from getaddrinfo()
References: <158981176590.872823.11683683537698750702.stgit@warthog.procyon.org.uk>
Date:   Tue, 19 May 2020 16:17:55 +0200
In-Reply-To: <158981176590.872823.11683683537698750702.stgit@warthog.procyon.org.uk>
        (David Howells's message of "Mon, 18 May 2020 15:22:45 +0100")
Message-ID: <87blmkgga4.fsf@oldenburg2.str.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

* David Howells:

> Fix this to apply a default TTL of 10mins in the event that we haven't got
> one.  This can be configured in /etc/keyutils/key.dns_resolver.conf by
> adding the line:
>
> 	default_ttl: <number-of-seconds>
>
> to the file.

If the name resolution is not needed continuously, but only for the
connection attempt, I suggest to use a much shorter TTL, like five
seconds or so.

I'm worried that if the implied TTL is too long, some system
administrators will have to figure out how to invalidate the DNS cache.

Thanks,
Florian

