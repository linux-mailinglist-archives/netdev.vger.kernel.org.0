Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 026A41FB53C
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 16:58:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729363AbgFPO6U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 10:58:20 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:44919 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727804AbgFPO6T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 10:58:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592319497;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=snYCuz3SPwPXhU8W/sQb8yTInhvn8BCyLV/bC9dRuXI=;
        b=OQaaa3q8g/dI3XibqqirAx4hDN0jtjTAfS2rW/lL6crmX2zoi2xCG51yg9Rbup1p45EKpF
        dZ50+Wx9KCJeeLRegLHJUFQr2nLm6V3c4ND4T0pLEQvucCUutUfP9/qpbC+0KhIrCBD8ii
        cQXlsCPDL0uMxsqBg8xLG1uGPYyAuro=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-142-_sIelAAjP8avOGjBtdBazg-1; Tue, 16 Jun 2020 10:58:15 -0400
X-MC-Unique: _sIelAAjP8avOGjBtdBazg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CF8A88CFF2D;
        Tue, 16 Jun 2020 14:58:13 +0000 (UTC)
Received: from new-host-5 (unknown [10.40.194.190])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5C4C15D9D7;
        Tue, 16 Jun 2020 14:58:12 +0000 (UTC)
Message-ID: <e9d84cd05ffb221d6a27fac2c7ea0d7d2bb212e5.camel@redhat.com>
Subject: Re: [PATCH net v2 2/2] net/sched: act_gate: fix configuration of
 the periodic timer
From:   Davide Caratti <dcaratti@redhat.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Po Liu <Po.Liu@nxp.com>, Cong Wang <xiyou.wangcong@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
In-Reply-To: <CA+h21hpL+7tuEX7_NCNo7NdgZ1OYqjQ03=DHuZ3aOOKh6Z4tsw@mail.gmail.com>
References: <cover.1592247564.git.dcaratti@redhat.com>
         <4a4a840333d6ba06042b9faf7e181048d5dc2433.1592247564.git.dcaratti@redhat.com>
         <CA+h21ho1x1-N+HyFXcy+pqdWcQioFWgRs0C+1h+kn6w8zHVUwQ@mail.gmail.com>
         <fd20899c60d96695060ecb782421133829f09bc2.camel@redhat.com>
         <CA+h21hrCScMMA9cm0fhF+eLRWda403pX=t3PKRoBhkE8rrR-rw@mail.gmail.com>
         <429bc64106ac69c8291f4466ddbaa2b48b8e16c4.camel@redhat.com>
         <CA+h21hpL+7tuEX7_NCNo7NdgZ1OYqjQ03=DHuZ3aOOKh6Z4tsw@mail.gmail.com>
Organization: red hat
Content-Type: text/plain; charset="UTF-8"
Date:   Tue, 16 Jun 2020 16:58:11 +0200
MIME-Version: 1.0
User-Agent: Evolution 3.36.1 (3.36.1-1.fc32) 
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2020-06-16 at 17:23 +0300, Vladimir Oltean wrote:
> > (but again, this would be a fix for 'entries' - not for 'hitimer', so I
> > plan to work on it as a separate patch, that fits better 'net-next' rather
> > than 'net').
> 
> Targeting net-next would mean that the net tree would still keep
> appending to p->entries upon action replacement, instead of just
> replacing p->entries?

well, this is the original act_gate behavior (and the bug is discovered
today, in this thread). But if users can't wait for the proper fix (and
equally important, for the tdc test file), I can think of sending the
patch directly for 'net'.

-- 
davide

