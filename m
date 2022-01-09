Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE14D488973
	for <lists+netdev@lfdr.de>; Sun,  9 Jan 2022 14:00:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235554AbiAINAn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 08:00:43 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:42178 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231394AbiAINAm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 08:00:42 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 816D6B80C0A;
        Sun,  9 Jan 2022 13:00:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF5BFC36AEB;
        Sun,  9 Jan 2022 13:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641733240;
        bh=WtX0uHMrTl6GQCiIyE80DYzIRiuSy/mJPnIzH5+0T7g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2a03L2/+ZxRA+eL8HRnqm9eJPyfYoyV3/rU6rjiaB28Z6ZIKqynBXUlggwgudWMIJ
         UxR4jDtERguJiV7KcO16Xmn0A8Qr7J+oSezdcBilH+9n8FOK4FLgEHpkCStPEwmch5
         KB464ZLrUOxxV1c4QrkF6NsXN1fju8RfU6RJIOqo=
Date:   Sun, 9 Jan 2022 14:00:37 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     aayush.a.agarwal@oracle.com
Cc:     stable@vger.kernel.org, Hangyu Hua <hbh25y@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Remi Denis-Courmont <courmisch@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [External] : Re: [PATCH 4.14] phonet: refcount leak in
 pep_sock_accep
Message-ID: <Ydrcdfc/ZUn2jCay@kroah.com>
References: <20220107105332.61347-1-aayush.a.agarwal@oracle.com>
 <Ydgi0qF/7GwoCh96@kroah.com>
 <baa2a339-2917-fc6b-6cc5-c4174c20f533@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <baa2a339-2917-fc6b-6cc5-c4174c20f533@oracle.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 07, 2022 at 10:24:53PM +0530, aayush.a.agarwal@oracle.com wrote:
> 
> On 07/01/22 4:54 pm, Greg KH wrote:
> > On Fri, Jan 07, 2022 at 02:53:32AM -0800, Aayush Agarwal wrote:
> > > From: Hangyu Hua <hbh25y@gmail.com>
> > > 
> > > commit bcd0f9335332 ("phonet: refcount leak in pep_sock_accep")
> > > upstream.
> > > 
> > > sock_hold(sk) is invoked in pep_sock_accept(), but __sock_put(sk) is not
> > > invoked in subsequent failure branches(pep_accept_conn() != 0).
> > > 
> > > Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
> > > Link: https://urldefense.com/v3/__https://lore.kernel.org/r/20211209082839.33985-1-hbh25y@gmail.com__;!!ACWV5N9M2RV99hQ!Znc0Oy9gtZZ18UDMwcZiYrfjj4GUibhEq5WJZ44m6azDWCC1hrZpkFh9AmGOqqS94cqz-A$
> > > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > > Signed-off-by: Aayush Agarwal <aayush.a.agarwal@oracle.com>
> > > ---
> > >   net/phonet/pep.c | 1 +
> > >   1 file changed, 1 insertion(+)
> > What about releases 5.15.y, 5.10.y, 5.4.y, and 4.19.y?  Is this also
> > relevant for those trees?
> > 
> > thanks,
> > 
> > greg k-h
> 
> It's relevant for all currently supported stable releases: 4.4.y, 4.9.y,
> 4.14.y, 4.19.y, 5.4.y, 5.10.y, 5.15.y . I missed adding the tag "Cc:
> stable@viger.kernel.org #4.4+". Should I send the patch again?

No need, I've queued it up everywhere now, thanks!

greg k-h
