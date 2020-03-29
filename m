Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA880196E53
	for <lists+netdev@lfdr.de>; Sun, 29 Mar 2020 18:12:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728350AbgC2QMh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Mar 2020 12:12:37 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:49010 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728209AbgC2QMg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Mar 2020 12:12:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:
        Subject:Sender:Reply-To:Cc:Content-ID:Content-Description;
        bh=3aGUFTlDFLNPEPyNqpXzRGp9fSJaJ2O8HpjtLH83Bzc=; b=toUsYu1doW4nFxIJJE0wkgehpy
        8+pWXT6yv3an/sQQQiVMJwupq1G8M6yulZNNRncItGo1QciGQ+sPJqNj1MEoKE7qGcZ9ZnjqWjp3q
        5uUS1IPd05dr2ID4F5Aqsoq/DbioJ8xsTjSM01ZmjsQWqgDesaxqv6mGB9pe2NGBSGlFTNS7rcszR
        7hSNi5Xdju2IC0d6shFHKh8ChqYXxCSG3sTQ5satEZ0Df05HGtPptespIxivYUJGXpXsGmI7ZYeAC
        +j1xYIr0jJY1aqNYZ9SM1VclC5a5aM0LzuHhux68gAPMbOjikBxS8iXd4SHDWM1+ECgnSh1Pfbo0q
        J/S3YhJA==;
Received: from [2601:1c0:6280:3f0::19c2]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jIaY4-0000MB-5D; Sun, 29 Mar 2020 16:12:32 +0000
Subject: Re: mmotm 2020-03-28-22-17 uploaded (staging/octeon/)
To:     akpm@linux-foundation.org, broonie@kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-next@vger.kernel.org, mhocko@suse.cz,
        mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
References: <20200329051805.kfaUSHrn4%akpm@linux-foundation.org>
From:   Randy Dunlap <rdunlap@infradead.org>
X-Enigmail-Draft-Status: N11100
Message-ID: <873495e9-d254-cb66-7a83-2517505a2b9b@infradead.org>
Date:   Sun, 29 Mar 2020 09:12:31 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200329051805.kfaUSHrn4%akpm@linux-foundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/28/20 10:18 PM, akpm@linux-foundation.org wrote:
> The mm-of-the-moment snapshot 2020-03-28-22-17 has been uploaded to
> 
>    http://www.ozlabs.org/~akpm/mmotm/
> 
> mmotm-readme.txt says
> 
> README for mm-of-the-moment:
> 
> http://www.ozlabs.org/~akpm/mmotm/
> 
> This is a snapshot of my -mm patch queue.  Uploaded at random hopefully
> more than once a week.
> 
> You will need quilt to apply these patches to the latest Linus release (5.x
> or 5.x-rcY).  The series file is in broken-out.tar.gz and is duplicated in
> http://ozlabs.org/~akpm/mmotm/series


on i386 or x86_64:

../drivers/staging/octeon/ethernet-tx.c: In function ‘cvm_oct_xmit’:
../drivers/staging/octeon/ethernet-tx.c:358:2: error: implicit declaration of function ‘skb_reset_tc’; did you mean ‘skb_reserve’? [-Werror=implicit-function-declaration]
  skb_reset_tc(skb);
  ^~~~~~~~~~~~

It looks like this inline function has been removed from
<net/sch_generic.h>.


Looks like it should be this change:

-	skb_reset_tc(skb);
+	skb_reset_redirect(skb);


-- 
~Randy
Reported-by: Randy Dunlap <rdunlap@infradead.org>
