Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5CD4435038
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 18:34:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230265AbhJTQgj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 12:36:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230196AbhJTQgf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 12:36:35 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA768C06161C
        for <netdev@vger.kernel.org>; Wed, 20 Oct 2021 09:34:20 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id y67so25339544iof.10
        for <netdev@vger.kernel.org>; Wed, 20 Oct 2021 09:34:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sargun.me; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=JBFsFhPpdaw12nk3cu5dcMUG+Fs6Dz9V44jZGeZjmDo=;
        b=OqBB29lMojrufyh9kBCGnAFwOS8hjLJLfsf8n2Ba8h1f/5uZCOE05hS93+aJcabXGy
         BVhAj4obJMShIGQwkkess0Xzu/4lMON7/uG5EC8n2hgiJilyphS92iJtbKB6GxqMMVj0
         01b1sw68aEyHBh6l3BmLzPmgnWatWkddZtNqI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=JBFsFhPpdaw12nk3cu5dcMUG+Fs6Dz9V44jZGeZjmDo=;
        b=68Pwu4qYBGyI8q7fd4cQyvgiHg49wrMWtHoDjako6n9wqnU1JDDvOOAMR2Juppb9hY
         tdfKMu3plQwsEIN2tKehASKYXvSunLYyemDjqzhwvng3NF0HnUhG0mJDkoXLBRM78UI8
         BGA0b0kzJ/QFW8n129HYEWQJk+t6xXSeb7eJegkuqNpyY4EBIsUQNVatslg12S1nhi9g
         IynebX/bhbOxyBD7v5uHaJtGD+IueyCkKJBQaqU67pbhjWJWmsBrUST3s1S1fFV22/pW
         EAP2gzW0LpUxAxd815Hii62TFMVfn0ayxgm/lOaiNGXrjwmJbRw9Ngb5+AlVPJwU4SEG
         o27w==
X-Gm-Message-State: AOAM531EvaVBhq0O4smjVwg0NBDLKmZpfVgVU7cwXCBTXrwRdXGqbgBK
        1+GdArUOteR23z4mJi0OWDWLKQ==
X-Google-Smtp-Source: ABdhPJyKtILTXAT9ygIy/vzt9aKqlp949wGCIExiKDHGKGyBz1wFz0eZYaOdqjDC/+gzjVc178Y3Aw==
X-Received: by 2002:a05:6638:32a6:: with SMTP id f38mr241125jav.63.1634747660037;
        Wed, 20 Oct 2021 09:34:20 -0700 (PDT)
Received: from ircssh-2.c.rugged-nimbus-611.internal (80.60.198.104.bc.googleusercontent.com. [104.198.60.80])
        by smtp.gmail.com with ESMTPSA id m7sm1346936iov.30.2021.10.20.09.34.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 20 Oct 2021 09:34:19 -0700 (PDT)
Date:   Wed, 20 Oct 2021 16:34:18 +0000
From:   Sargun Dhillon <sargun@sargun.me>
To:     Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: Re: Retrieving the network namespace of a socket
Message-ID: <20211020163417.GA21040@ircssh-2.c.rugged-nimbus-611.internal>
References: <20211020095707.GA16295@ircssh-2.c.rugged-nimbus-611.internal>
 <CAHNKnsRFah6MRxECTLNwu+maN0o9jS9ENzSAiWS4v1247BqYdg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHNKnsRFah6MRxECTLNwu+maN0o9jS9ENzSAiWS4v1247BqYdg@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 20, 2021 at 05:03:56PM +0300, Sergey Ryazanov wrote:
> Hello Sargun,
> 
> On Wed, Oct 20, 2021 at 12:57 PM Sargun Dhillon <sargun@sargun.me> wrote:
> > I'm working on a problem where I need to determine which network namespace a
> > given socket is in. I can currently bruteforce this by using INET_DIAG, and
> > enumerating namespaces and working backwards.
> 
> Namespace is not a per-socket, but a per-process attribute. So each
> socket of a process belongs to the same namespace.
> 
> Could you elaborate what kind of problem you are trying to solve?
> Maybe there is a more simple solution. for it.
> 
> -- 
> Sergey

That's not entirely true. See the folowing code:

int main() {
	int fd1, fd2;
	fd1 = socket(AF_INET, SOCK_STREAM, 0);
	assert(fd1 >= 0);
	assert(unshare(CLONE_NEWNET) == 0);
	fd2 = socket(AF_INET, SOCK_STREAM, 0);
	assert(fd2 >= 0);
}

fd1 and fd2 have different sock_net.

The context for this is:
https://linuxplumbersconf.org/event/11/contributions/932/

We need to figure out, for a given socket, if it has reachability to a given IP.
