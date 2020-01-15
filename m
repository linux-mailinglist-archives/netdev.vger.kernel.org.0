Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0744813C6E6
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 16:04:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729212AbgAOPEc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 10:04:32 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:38577 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729011AbgAOPEc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 10:04:32 -0500
Received: by mail-wm1-f68.google.com with SMTP id u2so200942wmc.3;
        Wed, 15 Jan 2020 07:04:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=xQvK3Khfh8ssHY6UKXAmXLE4MXakJFMEfTNk2HuT3e8=;
        b=WGZFfxHNGxkn3qKiGXNyQWIkmR6gZtBOh5T54Ma6DLnAgmyCGoTkrObkQbpbFZqMlO
         eSfMJg5THDN1axPJZo0QLmYOVFL+9TQ8SVTwzrq9pk6guLbN8wqAi6f6UUvitygc79Uc
         0asMaM5hCAG9Ei7rLJ0AGJTO4M1OvvpNbe7+d5iJHdOQWz/5Hamim+9DcLrDRFD7iXSP
         lJB2SvafIqMd7nJuDHW0VqJQPK6PkytVDkbhuFh9JofDC9Zj5nq6fq+U3JfdMQzC4kDi
         gDQhAzaOFkXaTQBsq4v7l9sdWA5/+svsLZd8FKdxvtashccRiMYZlDjgmyeGTmAqSngR
         27Ag==
X-Gm-Message-State: APjAAAU7OxYUn+YDvFqMamo+fti/c3MbPHgVE12IHE7i3KxDHm7S9r4j
        jRWZ08J5I0pWwGng9XlVJ8I=
X-Google-Smtp-Source: APXvYqy279tPnlZqttod0cBi9Mva6wkZHlFzeLjXHeZe9tBQL0b+hXbPpd8U2Ldc2U+oX97PYuyAOw==
X-Received: by 2002:a1c:2187:: with SMTP id h129mr244143wmh.44.1579100669759;
        Wed, 15 Jan 2020 07:04:29 -0800 (PST)
Received: from debian (41.142.6.51.dyn.plus.net. [51.6.142.41])
        by smtp.gmail.com with ESMTPSA id b137sm133936wme.26.2020.01.15.07.04.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jan 2020 07:04:28 -0800 (PST)
Date:   Wed, 15 Jan 2020 15:04:26 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     Madhuparna Bhowmik <madhuparnabhowmik04@gmail.com>
Cc:     Wei Liu <wei.liu@kernel.org>, paul@xen.org, davem@davemloft.net,
        xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Joel Fernandes <joel@joelfernandes.org>,
        Amol Grover <frextrite@gmail.com>,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: Re: [PATCH] net: xen-netbank: hash.c: Use built-in RCU list checking
Message-ID: <20200115150426.svapzpux2tbbgvmn@debian>
References: <20200115124129.5684-1-madhuparnabhowmik04@gmail.com>
 <20200115135631.edr2nrfkycppxcku@debian>
 <CAF65HP0q_KcrUP_50JxZL1xNc47=detHvdOzjBmuiqUtB3AwfA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF65HP0q_KcrUP_50JxZL1xNc47=detHvdOzjBmuiqUtB3AwfA@mail.gmail.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 15, 2020 at 07:36:38PM +0530, Madhuparna Bhowmik wrote:
[...]
> 
> > The surrounding code makes it pretty clear that the lock is already held
> > by the time list_for_each_entry_rcu is called, yet the checking involved
> > in lockdep_is_held is not trivial, so I'm afraid I don't consider this a
> > strict improvement over the existing code.
> >
> > Actually,  we want to make CONFIG_PROVE_LIST_RCU enabled by default.

I think you meant CONFIG_PROVE_RCU_LIST.

> And if the cond argument is not passed when the usage of
> list_for_each_entry_rcu()
> is outside of rcu_read_lock(), it will lead to a false positive.
> Therefore, I think this patch is required.

Fair enough.

Wei.
