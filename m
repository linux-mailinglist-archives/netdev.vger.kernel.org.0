Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29F3B1A6D58
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 22:37:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388435AbgDMUhW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 16:37:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388425AbgDMUhU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Apr 2020 16:37:20 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2594C0A3BDC;
        Mon, 13 Apr 2020 13:37:19 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id c63so10985726qke.2;
        Mon, 13 Apr 2020 13:37:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=po4Tg7l56X8JxsrIEn5K0LIpr3zSAdM72o29rNOLQgI=;
        b=Hp3t8cqWgCww90WpjPKr38jrO+Iv/5BhpGdDiqycmqPAjfiEHYcvd5UP+Hru8q4vYK
         5ENEFzBOozslgB+SOVFMh506HJmYv83+HUK+pGlakZZEK29BukuaKwWLLZipZk0y8uix
         pYRMSO7TkhPysMN4UP1Jkb+L77SeMC6kL/zgYNREylPfk1ftXsiNnNgb+rdGlgxbvlM6
         kO5HsmQUrQMRcI1Ve9/sNhKx/YLTy2NcPMpfGAyCWuPZSOqJCA2GWCi7+YeEAkHWi/0V
         2N07GpCpeAWwbhCSJ/dFViu+7wUIRA/lhNYLKz9V5YtIHRWvkCEWHop7qMBqctVBzA4l
         1VpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=po4Tg7l56X8JxsrIEn5K0LIpr3zSAdM72o29rNOLQgI=;
        b=NrkM1f94XVv8k5HuM02oxy+YAa/qvhs3xno86lpA73a0i+ebgD+oJmbXtejJ694ipu
         ZwZBVd1XHQMcBlWOOyW2DhqopH6cF97mjm/LFkfN5lFx8z/COBnlWonEIg9CmF4Ydjgl
         DlReYuQZYbKi4xA4hmx7ZPcTWg+cXYjh0oWKQEObL+yPgYR8ugsmxKjrh7PfHg2IZ9AC
         HyRsqPcFueZyL67lhvfZPuxT1ho2WEqm/g00dDlzVMib6Y5n7QlfRPkCG1g0yWlAreax
         jr7l+bdWZVZVuluzv2AlN6pMJuURnWP+Ue7accFWDuLLFbFZ6pdE2KGL5jjAkClQ2IGi
         Mhhg==
X-Gm-Message-State: AGi0PuYqvbFvCS0BUrbZQBWOZMASg5hC5YsXmR87dvQF/GJ750xzBAfg
        ccXi+KgHkrslDoo8qL2ePuk=
X-Google-Smtp-Source: APiQypI1sBRWAvVsFGeAvZvDZ/uuO4AZV3fNnGoE4m3RLFGj+2KNntBYYyQ3Pbxs5eyriUzcF+avwA==
X-Received: by 2002:ae9:e606:: with SMTP id z6mr7159623qkf.320.1586810238863;
        Mon, 13 Apr 2020 13:37:18 -0700 (PDT)
Received: from localhost ([199.96.181.106])
        by smtp.gmail.com with ESMTPSA id b13sm5959814qka.20.2020.04.13.13.37.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2020 13:37:17 -0700 (PDT)
Date:   Mon, 13 Apr 2020 16:37:16 -0400
From:   Tejun Heo <tj@kernel.org>
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-api@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Serge Hallyn <serge@hallyn.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Saravana Kannan <saravanak@google.com>,
        Jan Kara <jack@suse.cz>, David Howells <dhowells@redhat.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        David Rheinsberg <david.rheinsberg@gmail.com>,
        Tom Gundersen <teg@jklm.no>,
        Christian Kellner <ckellner@redhat.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        =?iso-8859-1?Q?St=E9phane?= Graber <stgraber@ubuntu.com>,
        linux-doc@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 5/8] kernfs: let objects opt-in to propagating from the
 initial namespace
Message-ID: <20200413203716.GK60335@mtj.duckdns.org>
References: <20200408152151.5780-1-christian.brauner@ubuntu.com>
 <20200408152151.5780-6-christian.brauner@ubuntu.com>
 <20200413190239.GG60335@mtj.duckdns.org>
 <20200413193950.tokh5m7wsyrous3c@wittgenstein>
 <20200413194550.GJ60335@mtj.duckdns.org>
 <20200413195915.yo2l657nmtkwripb@wittgenstein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200413195915.yo2l657nmtkwripb@wittgenstein>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Mon, Apr 13, 2020 at 09:59:15PM +0200, Christian Brauner wrote:
> Right, pid namespaces deal with a single random identifier about which
> userspace makes no assumptions other than that it's a positive number so
> generating aliases is fine. In addition pid namespaces are nicely

I don't see any fundamental differences between pids and device numbers. One
of the reasons pid namespace does aliasing instead of just showing subsets is
because applications can have expectations on what the specific numbers should
be - e.g. for checkpoint-restarting.

> hierarchical. I fear that we might introduce unneeded complexity if we
> go this way and start generating aliases for devices that userspace

It adds complexity for sure but the other side of the scale is losing
visiblity into what devices are on the system, which can become really nasty
in practice, so I do think it can probably justify some additional complexity
especially if it's something which can be used by different devices. Even just
for block, if we end up expanding ns support to regular block devices for some
reason, it's kinda dreadful to think a situation where all devices can't be
discovered at the system level.

> already knows about and has expectations of. We also still face some of
> the other problems I mentioned.
> I do think that what you say might make sense to explore in more detail
> for a new device class (or type under a given class) that userspace does
> not yet know about and were we don't regress anything.

I don't quite follow why adding namespace support would break existing users.
Wouldn't namespace usage be opt-in?

Thanks.

-- 
tejun
