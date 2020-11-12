Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 123DD2B0AB6
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 17:49:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728850AbgKLQtl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 11:49:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60167 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728086AbgKLQtl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 11:49:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605199779;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=moUVwI3mBMRKNqyIYfV96wg0zeoNkjJRP9E2kuGbaF4=;
        b=AM8p8mfN5UcJqTZwcLBcjHgg5gIYfsAGBTkkxpWRnNGAx57LXG2SoGHtrQaoMzPwG8/ueT
        Igq+fzfGYfxuBdR8eAvvXn2KGnFaUv2OJFo2IhzDrKkdEV94P+k/21vz8tCLyVEtqUhYuU
        yDmpUd2LTB2RYPGrXM9VQqYfm1QAz0s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-525-MFdueepuOrK_Y7SPnRL59g-1; Thu, 12 Nov 2020 11:49:36 -0500
X-MC-Unique: MFdueepuOrK_Y7SPnRL59g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D37BF8C3308;
        Thu, 12 Nov 2020 16:49:34 +0000 (UTC)
Received: from ovpn-112-208.ams2.redhat.com (ovpn-112-208.ams2.redhat.com [10.36.112.208])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4B92C5D993;
        Thu, 12 Nov 2020 16:49:32 +0000 (UTC)
Message-ID: <3fd7c25aa80db27949f1f18ece6b77e615955360.camel@redhat.com>
Subject: Re: [PATCH net-next 00/13] mptcp: improve multiple xmit streams
 support
From:   Paolo Abeni <pabeni@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        mptcp@lists.01.org
Date:   Thu, 12 Nov 2020 17:49:30 +0100
In-Reply-To: <20201112074025.5b932eaa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <cover.1605175834.git.pabeni@redhat.com>
         <20201112074025.5b932eaa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-11-12 at 07:40 -0800, Jakub Kicinski wrote:
> On Thu, 12 Nov 2020 11:47:58 +0100 Paolo Abeni wrote:
> > This series improves MPTCP handling of multiple concurrent
> > xmit streams.
> > 
> > The to-be-transmitted data is enqueued to a subflow only when
> > the send window is open, keeping the subflows xmit queue shorter
> > and allowing for faster switch-over.
> > 
> > The above requires a more accurate msk socket state tracking
> > and some additional infrastructure to allow pushing the data
> > pending in the msk xmit queue as soon as the MPTCP's send window
> > opens (patches 6-10).
> > 
> > As a side effect, the MPTCP socket could enqueue data to subflows
> > after close() time - to completely spooling the data sitting in the 
> > msk xmit queue. Dealing with the requires some infrastructure and 
> > core TCP changes (patches 1-5)
> > 
> > Finally, patches 11-12 introduce a more accurate tracking of the other
> > end's receive window.
> > 
> > Overall this refactor the MPTCP xmit path, without introducing
> > new features - the new code is covered by the existing self-tests.
> 
> Hi Paolo!
> 
> Would you mind resending? Looks like patchwork got confused about patch
> 6 not belonging to the series.

Sure, no problem.

AFAICS, the headers look correct ?!? in 6/13:

Message-Id: <653b54ab33745d31c601ca0cd0754d181170838f.1605175834.git.pabeni@redhat.com>
In-Reply-To: <cover.1605175834.git.pabeni@redhat.com>

In 0/13:
Message-Id: <cover.1605175834.git.pabeni@redhat.com>

Cheers,

Paolo

