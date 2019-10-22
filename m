Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 892FEE071F
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 17:15:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732196AbfJVPPj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 11:15:39 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:48894 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731441AbfJVPPj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 11:15:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571757337;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CjSNJbMFJ28Qf5ED+IVqMaXpqaTZ/oEFXr17jaYsGd8=;
        b=QbEl3NGUKoCe23jyxyeb77BjpocbuKb0WPda7uVpO9MbzRqAfoGZ+ZSoabkSNrqINTykDE
        HvRYPwSqdoATWn6olHHpLjXpUjg3juHSBvmsFXcOMAgtb6EI0H3m3Ohr+RLvHNz6M2xHAM
        QvsINx8gUPDjKGtT3RIE3Db7ooCV47c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-27-AJW8v2LLOg2ySZJUGn1crA-1; Tue, 22 Oct 2019 11:15:32 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7EFCD1800DD0;
        Tue, 22 Oct 2019 15:15:27 +0000 (UTC)
Received: from localhost.localdomain (ovpn-121-180.rdu2.redhat.com [10.10.121.180])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6C3B51001DF0;
        Tue, 22 Oct 2019 15:15:26 +0000 (UTC)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 68199C0AAD; Tue, 22 Oct 2019 12:15:24 -0300 (-03)
Date:   Tue, 22 Oct 2019 12:15:24 -0300
From:   Marcelo Ricardo Leitner <mleitner@redhat.com>
To:     Vlad Buslov <vladbu@mellanox.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, dcaratti@redhat.com
Subject: Re: [PATCH net-next 00/13] Control action percpu counters allocation
 by netlink flag
Message-ID: <20191022151524.GZ4321@localhost.localdomain>
References: <20191022141804.27639-1-vladbu@mellanox.com>
MIME-Version: 1.0
In-Reply-To: <20191022141804.27639-1-vladbu@mellanox.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: AJW8v2LLOg2ySZJUGn1crA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 22, 2019 at 05:17:51PM +0300, Vlad Buslov wrote:
> - Extend actions that are used for hardware offloads with optional
>   netlink 32bit flags field. Add TCA_ACT_FLAGS_FAST_INIT action flag and
>   update affected actions to not allocate percpu counters when the flag
>   is set.

I just went over all the patches and they mostly make sense to me. So
far the only point I'm uncertain of is the naming of the flag,
"fast_init".  That is not clear on what it does and can be overloaded
with other stuff later and we probably don't want that.

Say, for example, we want percpu counters but to disable allocating
the stats for hw, to make the counter in 28169abadb08 ("net/sched: Add
hardware specific counters to TC actions") optional.

So what about:
TCA_ACT_FLAGS_NO_PERCPU_STATS
TCA_ACT_FLAGS_NO_HW_STATS (this one to be done on a subsequent patchset, ye=
s)
?

  Marcelo

