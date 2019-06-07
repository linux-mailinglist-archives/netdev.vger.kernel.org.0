Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04193391B1
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 18:13:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729965AbfFGQNM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 12:13:12 -0400
Received: from mail-pg1-f169.google.com ([209.85.215.169]:37757 "EHLO
        mail-pg1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729127AbfFGQNM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 12:13:12 -0400
Received: by mail-pg1-f169.google.com with SMTP id 20so1415563pgr.4;
        Fri, 07 Jun 2019 09:13:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+v/nyTrfUwKDiO60H6P7yrcb/AvGQ5TkB/DzgjrK9rk=;
        b=ikYMHwpeMcyQt1k0NxYmY6v+CxikGuE+R1vUmmNbxcRy3tpwp60Z+t9SRyrc1oVY2u
         rxSp/s9anWeYnx/yIErCPueV3dJWuJobVtQfce9FguRrJpvFCT4Eah90Yh2W4oGQVRgR
         +07qXwLfYSuod0nvYdcEKD/rKD6VgcDXdKkypIarOLjimDkycc2HrP3JXOCnAZKt9zi4
         8k8siRg0CQ2d8IQJ2supqLtUyhqXMSWDxF7OdIbEptL2xlsjrVXgLcR4/kEUQ/knTRGn
         WnF3AM0NdMDkRtcM8m/r6bXXN7vPTCsZZZh7h97Hq9xmjqfTbR7fLDFKYAEzz2I6Q/8j
         loUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+v/nyTrfUwKDiO60H6P7yrcb/AvGQ5TkB/DzgjrK9rk=;
        b=QCMJAUU+6fgL3hMMKPkYTCVMK1hi5VYsNXu6xm/HtmlYCXO0DHvGu5GEcGXrqlx0+U
         aYjtHoztqYHCFR36R/s8TQJIRS8xnwXfHtb+8+uq99EbbmcDeSIGIiICcx8TVrjxroRD
         kdBm8vwBugNCLvK/rwM/Q6SZXbyPfwMVtOSO+fFBfdvKdhhk9Dl+p3J6NP0bJz3QNmeb
         Ar8e5tek99WSNXrFTrl8kkYW6WM1Dl11MIFVWu0zXarMf4nx60CRvxN2fu++eNV0MphL
         TbrHh+JC+RPeLaICX1nXAexMnQyLjCU+FhnxTESm4TUPXWAzz47qmYsRD7dAgGHepKab
         c9Kw==
X-Gm-Message-State: APjAAAWU/TIj7eCW41xhm2xbExslwKyi2+7D9WvaBbD+e3wp5dW1JojH
        l4Z5JnTCtiXHdJasPYXymS8=
X-Google-Smtp-Source: APXvYqzQJ4jN+znFbh4NisIXmXtjlcm9RNiNM2+fTJLWxplzZ9amcx9SPe20QkrjChZPygPGF60fdw==
X-Received: by 2002:a63:e603:: with SMTP id g3mr3628545pgh.167.1559923991556;
        Fri, 07 Jun 2019 09:13:11 -0700 (PDT)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id e5sm7214119pjj.2.2019.06.07.09.13.10
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 07 Jun 2019 09:13:10 -0700 (PDT)
Subject: Re: inet: frags: Turn fqdir->dead into an int for old Alphas
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        "Paul E. McKenney" <paulmck@linux.ibm.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Fengguang Wu <fengguang.wu@intel.com>, LKP <lkp@01.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrea Parri <andrea.parri@amarulasolutions.com>,
        Luc Maranget <luc.maranget@inria.fr>,
        Jade Alglave <j.alglave@ucl.ac.uk>
References: <20190603200301.GM28207@linux.ibm.com>
 <Pine.LNX.4.44L0.1906041026570.1731-100000@iolanthe.rowland.org>
 <CAHk-=wgGnCw==uY8radrB+Tg_CEmzOtwzyjfMkuh7JmqFh+jzQ@mail.gmail.com>
 <20190607140949.tzwyprrhmqdx33iu@gondor.apana.org.au>
 <da5eedfe-92f9-6c50-b9e7-68886047dd25@gmail.com>
 <20190607153226.gzt4yeq5c5i6bpqd@gondor.apana.org.au>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <f8908fc1-102e-c02f-6574-56cf053d791e@gmail.com>
Date:   Fri, 7 Jun 2019 09:13:09 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190607153226.gzt4yeq5c5i6bpqd@gondor.apana.org.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/7/19 8:32 AM, Herbert Xu wrote:
> On Fri, Jun 07, 2019 at 08:26:12AM -0700, Eric Dumazet wrote:
>>
>> There is common knowledge among us programmers that bit fields
>> (or bool) sharing a common 'word' need to be protected
>> with a common lock.
>>
>> Converting all bit fields to plain int/long would be quite a waste of memory.
>>
>> In this case, fqdir_exit() is called right before the whole
>> struct fqdir is dismantled, and the only cpu that could possibly
>> change the thing is ourself, and we are going to start an RCU grace period.
>>
>> Note that first cache line in 'struct fqdir' is read-only.
>> Only ->dead field is flipped to one at exit time.
>>
>> Your patch would send a strong signal to programmers to not even try using
>> bit fields.
>>
>> Do we really want that ?
> 
> If this were a bitfield then I'd think it would be safer because
> anybody adding a new bitfield is unlikely to try modifying both
> fields without locking or atomic ops.
> 
> However, because this is a boolean, I can certainly see someone
> else coming along and adding another bool right next to it and
> expecting writes them to still be atomic.
> 
> As it stands, my patch has zero impact on memory usage because
> it's simply using existing padding.  Should this become an issue
> in future, we can always revisit this and use a more appropriate
> method of addressing it.
> 
> But the point is to alert future developers that this field is
> not an ordinary boolean.

Okay, but you added a quite redundant comment.

/* We can't use boolean because this needs atomic writes. */

Should we add a similar comment in front of all bit-fields,
or could we factorize this in a proper Documentation perhaps ?

Can we just add a proper bit-field and not the comment ?

unsigned int dead:1;

This way, next programmer can just apply normal rules to add a new bit.

Thanks !

