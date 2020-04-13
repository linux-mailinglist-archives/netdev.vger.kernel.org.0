Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C6311A6C4A
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 21:02:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387786AbgDMTCo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 15:02:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1733140AbgDMTCm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Apr 2020 15:02:42 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFF46C0A3BDC;
        Mon, 13 Apr 2020 12:02:42 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id y3so10584847qky.8;
        Mon, 13 Apr 2020 12:02:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nKVN6Wfqaa6m2oeBx7nAKBR/MduP5kyAtIIqdYhvSik=;
        b=myYK8+qvccmR/zWaZdWI+FjTUBaZuJPDjxHZ+U3zz98W1RymAkPCkAnoQu7cTanLaW
         pADFbIsMJZwNsH10q1E2ghzy5Wybac9hc80exBSDWYY4zwWCSPlKuUdyCUelnF3Km/Ky
         CMeuj5gdAcIC6ChJgpD/yJ6fTBLC54WwLewmgetXd+PMMUH4tbK/MsQBwWiLLp9SCWFb
         2L+sYVBHhoDtUEF5zKTIYfb0Hz1d5brlqFBAS7xM8/Y6QHsig9OAxtnLOq/lSjBh7EaY
         XggMecQBv69bkxJSYfoQJd+3cJWIAjw7DAqFUwvCoqJWEvv8651OvDUfpauBCBPJo3Oe
         PKlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=nKVN6Wfqaa6m2oeBx7nAKBR/MduP5kyAtIIqdYhvSik=;
        b=AKHXB66XX8W/R3FnUYAyLy3JPXyDrov9zIfc0TrT69YbuHvPtiyodymmXery18kkP/
         EoNji74Qx6vBSJzSHs1QQnBToH1Na1fcd/ykUG7xt5caak7XPheuDbQpuVrPnC48MZCx
         8794unTDLnMHGSdnhdyMqvi1h6Bndovu9Rv/GOE/CjVZ6wXeNBBkjzlJYJRVhhH6qX9l
         FrmxKnmBX9gsk7Io4bX5yACUsjcXLCe39xcr7MzuLKQTSzwL43+sOJWlGa5kdEF+TtbM
         o1lpzhxMxm6q0zB7GpERJ6mMxbdCxj/iMps/vcAUyQHxGZb631rpeUJ442f4MlEX9CFh
         anzQ==
X-Gm-Message-State: AGi0Pub6EInsO21vgY8QQ4ujMF5HumtotLBYne4jX+oF9v5QHQy5R8YM
        OmsNQzdfTIyOZgX5uVWmSBM=
X-Google-Smtp-Source: APiQypI0lS1vfVmGCGinyYmhdcruYl03cvTvRa2nBmc3wJ+UhrMuP+fBPLT0Ki+d6+w5fDNkGnWB7A==
X-Received: by 2002:a05:620a:4f2:: with SMTP id b18mr17523871qkh.433.1586804561764;
        Mon, 13 Apr 2020 12:02:41 -0700 (PDT)
Received: from localhost ([199.96.181.106])
        by smtp.gmail.com with ESMTPSA id a196sm8256558qkc.108.2020.04.13.12.02.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2020 12:02:40 -0700 (PDT)
Date:   Mon, 13 Apr 2020 15:02:39 -0400
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
Message-ID: <20200413190239.GG60335@mtj.duckdns.org>
References: <20200408152151.5780-1-christian.brauner@ubuntu.com>
 <20200408152151.5780-6-christian.brauner@ubuntu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200408152151.5780-6-christian.brauner@ubuntu.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Wed, Apr 08, 2020 at 05:21:48PM +0200, Christian Brauner wrote:
> The initial namespace is special in many ways. One feature it always has
> had is that it propagates all its devices into all non-initial
> namespaces. This is e.g. true for all device classes under /sys/class/

Maybe I'm missing your point but I've always thought of it the other way
around. Some namespaces make all objects visible in init_ns so that all
non-init namespaces are subset of the init one, which sometimes requires
creating aliases. Other namespaces don't do that. At least in my experience,
the former is a lot easier to administer.

The current namespace support in kernfs behaves the way it does because the
only namespace it supports is netns, but if we're expanding it, I think it
might be better to default to init_ns is superset of all others model and make
netns opt for the disjointing behavior.

Thanks.

-- 
tejun
