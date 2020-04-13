Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C20E1A6CCA
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 21:46:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388094AbgDMTp5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 15:45:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387774AbgDMTpz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Apr 2020 15:45:55 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CF74C0A3BDC;
        Mon, 13 Apr 2020 12:45:53 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id 20so2716469qkl.10;
        Mon, 13 Apr 2020 12:45:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IrXhXWaAEnW1zS8YBmlrEJRi6VkoqaKcma3kC1vC75U=;
        b=d6gU9i1pqfpTTP66ZTWC9+Puq97Irkyfk3eF7AsQ98UDbY8So2wK8O49LmuopT1ZMN
         DuU3BtLQQnKQPUTOQPsyvF5fnxeNoVQ3MLBDpaBGyqtLZuMStKherMqrKtj0AkmwmJ2O
         5HVHO6nQwc4ZBpzEoDRt+hxqK4igNOIp+hMUBXywJRNDiLbyF2W7PzxGErKc9l5noT1X
         DRuk+YwKylLS/dqDSzHSEWCy6FVZOvzox482Y3d/pJWeheAoJmzexwqlOD8WXUcYcul/
         zCYnwBSmKG4f3c/yYZlXF+hg7+hmC20mvIzzmhM5oqCLjdY7k3aloE574kZr6/nAp0as
         bWTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=IrXhXWaAEnW1zS8YBmlrEJRi6VkoqaKcma3kC1vC75U=;
        b=dazhS+UA0yecQUeEld13O2k+pXqGgNZZU3WNEyClk/25bQRgqlQwSkj4Jx9pttOOkN
         O/VKW062ZfJ2fkuNmwZm5RaZu/cSXjNR/GJ1bgSIDS+YUgcJ69g0/9g8RYMnQ+1vgrOm
         bczRAJgLCu+uNEfgADNKMBP3gEIwMhIOvh/w6T6DI/7FX7e6lvYbrQjyaziCDiN9Ryww
         kOefK+7io1pvq7/uyIPcWBtYEoosdYCa7o669rk71nevfVf4sw3OPCsZHGs/XLOjFOcM
         G4JSkZZnytMh1gMykiWQuPjZxvMBK5wvPGtSdPN8f9JNQ4RubX0kmbyOMmJNpKUwP8gX
         fyNQ==
X-Gm-Message-State: AGi0PuaWUe3g4SMFZwPitBfofXEzBKVJuS8DEDIK466LNWUF4SXnQXho
        RJbGR0/EBZZrMJR7h1fcB64=
X-Google-Smtp-Source: APiQypKda7J7nttjrucG8tDdKsXAJ7nRNc9FJ6Rsj7Z7JS+ZxlOgL06ar55/l6VH0NhZFppvEqpaAg==
X-Received: by 2002:a37:614a:: with SMTP id v71mr16019860qkb.326.1586807152639;
        Mon, 13 Apr 2020 12:45:52 -0700 (PDT)
Received: from localhost ([199.96.181.106])
        by smtp.gmail.com with ESMTPSA id h63sm8990252qkd.49.2020.04.13.12.45.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2020 12:45:51 -0700 (PDT)
Date:   Mon, 13 Apr 2020 15:45:50 -0400
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
Message-ID: <20200413194550.GJ60335@mtj.duckdns.org>
References: <20200408152151.5780-1-christian.brauner@ubuntu.com>
 <20200408152151.5780-6-christian.brauner@ubuntu.com>
 <20200413190239.GG60335@mtj.duckdns.org>
 <20200413193950.tokh5m7wsyrous3c@wittgenstein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200413193950.tokh5m7wsyrous3c@wittgenstein>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Mon, Apr 13, 2020 at 09:39:50PM +0200, Christian Brauner wrote:
> Another problem is that you might have two devices of the same class
> with the same name that belong to different namespaces and if you shown
> them all in the initial namespace you get clashes. This was one of the
> original reasons why network devices are only shown in the namespace
> they belong to but not in any other.

For example, pid namespace has the same issue but it doesn't solve the problem
by breaking up visibility at the root level - it makes everything visiable at
root but give per-ns aliases which are selectively visble depending on the
namespace. From administration POV, this is way easier and less error-prone to
deal with and I was hoping that we could head that way rather than netdev way
for new things.

Thanks.

-- 
tejun
