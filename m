Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73D0696E8F
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 02:52:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726504AbfHUAwH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 20:52:07 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:57518 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726254AbfHUAwG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 20:52:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=7ST56NLHFk7kx3NuulqDge7h0nv1X4cFjUtNinWanqk=; b=AMUEvxxVQDDqt00Mc71BqoR59
        ZkB2QReDJGmUINOr/0HUuTxW9HArlO2/BqGfWR9FIMpsO/dlxUFk9KqNRiAvzEYVwCUZOOCIvKkV3
        Z87j0rTrot2sNrEFM1/9a1IFFUAdhBf2A5xD6Jvk3FRrp5Ttne88vZOxbjrWBbLTQpC1ERbezrdPO
        gxQRFGGb2TOqihSjefSkbyGrXdFHoAX4XvTWX7s2V5uhNIjqJroK8MzIR4lo2xChR00MQSw4vNSkR
        +X6chRJUJS5OSxFbHbMkQfPinujJfHCpZDvKUNj4CRt5vFjxnqc8s4v8c37wLAyYaKYyty9SFrfuH
        gyuSXB2oA==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i0Er8-0004B2-1G; Wed, 21 Aug 2019 00:52:06 +0000
Date:   Tue, 20 Aug 2019 17:52:05 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH 23/38] cls_api: Convert tcf_net to XArray
Message-ID: <20190821005205.GB18776@bombadil.infradead.org>
References: <20190820223259.22348-1-willy@infradead.org>
 <20190820223259.22348-24-willy@infradead.org>
 <20190820.165728.2062957580528299761.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190820.165728.2062957580528299761.davem@davemloft.net>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 20, 2019 at 04:57:28PM -0700, David Miller wrote:
> > From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> > 
> > This module doesn't use the allocating functionality; convert it to a
> > plain XArray instead of an allocating one.  I've left struct tcf_net
> > in place in case more objects are added to it in future, although
> > it now only contains an XArray.  We don't need to call xa_destroy()
> > if the array is empty, so I've removed the contents of tcf_net_exit()
> > -- if it can be called with entries still in place, then it shoud call
> > xa_destroy() instead.
> > 
> > Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> 
> I don't know if the net exit can be invoked with entires still in place,
> however if the tcf_net_exit() function is made empty it should be removed
> along with the assignment to the per-netns ops.

Thanks!  I wasn't sure what the rule was for these ops.  I'll fix that up.
