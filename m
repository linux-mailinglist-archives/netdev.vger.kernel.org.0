Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B9E4BD1A7
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 20:14:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730598AbfIXSOi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 14:14:38 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:39428 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729196AbfIXSOi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Sep 2019 14:14:38 -0400
Received: by mail-qt1-f193.google.com with SMTP id n7so3286371qtb.6;
        Tue, 24 Sep 2019 11:14:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=RcUKsFSZkEdQBo12ekbBu60UBvh1CtoCu7znnaFFJ4M=;
        b=D+rPs3o9AfrpKdYtVdB51asXfqczByPAX38t1seHNBVkD4tlL/s6E/BDutvrweoDnY
         GhUPOAQCdbKE8T2SvHlTfWUst8gw1BlcyVu8p1Ct/rAl4cpIBHCx2IQUa1mDoVhVVAJK
         WkPaCMQEb235GpGLG0e8U/B/vklu+Sf0CilLVyeK0VX4BTGcezOuXLvTQu47Q2PJCmKB
         olUMLdgcuTS22/EQ9K+bgvSikuqcGp2VendnIDi4O930XUxSyqRI2kw3Gy16j4vxbXXu
         w8MrAtsbzEj6cNX4ZqbxyrDXSIk2kJYX4dqDVLWtEy/YMassBWQE5uZNLEqfYKXzTRK2
         ceMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=RcUKsFSZkEdQBo12ekbBu60UBvh1CtoCu7znnaFFJ4M=;
        b=IuCdrTT+kmsuOh3F1z0ts042uQ1pfLq739v84UOXASmJ4PNLpV9W+/rHLaEoCnzDzx
         lozCPMYgBREKxqoGfY9Sd8J72DOekQIg9Vd4Zgcb/uBOJpv6kRzqy1hKmfolUUb3r0Z7
         cn3HIV8MYWNyldNTUitz7526kwFyHowD1q+X7hsNTNgD7aMHfrj9xXaKWOXV31ZmqJ2Y
         7aJrEzV5aNA/yBdqQUx7uQFiiGSOTY5qAZQpLM2iCTp/NGMchkUReYDwx7L9HDrkmuh5
         Oucam2jgSHT6OBQhshvXfV1e5Udk7SEmPp8AOYBtUVILQIDi3yTsjJidvSHUsJRAPGN/
         aWaA==
X-Gm-Message-State: APjAAAWhaRWsDuMkZPnxwZLXnGULBa7PhDX5+I4BAYa/48jKU8XuxG0P
        yA9CrYw4AlcR9V/0T83WpGA=
X-Google-Smtp-Source: APXvYqxVvxrFt/nMAY2g7HJDXxiSDfMEo680754cFvkYDa3DqZQvdv7Vwbchac+RMzo3X/GZyE8ruQ==
X-Received: by 2002:ac8:75ce:: with SMTP id z14mr4374333qtq.295.1569348877162;
        Tue, 24 Sep 2019 11:14:37 -0700 (PDT)
Received: from frodo.byteswizards.com ([190.162.109.190])
        by smtp.gmail.com with ESMTPSA id c185sm1404656qkf.122.2019.09.24.11.14.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Sep 2019 11:14:36 -0700 (PDT)
Date:   Tue, 24 Sep 2019 15:14:32 -0300
From:   Carlos Antonio Neira Bustos <cneirabustos@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     netdev@vger.kernel.org, yhs@fb.com, ebiederm@xmission.com,
        brouer@redhat.com, bpf@vger.kernel.org
Subject: Re: [PATCH V11 0/4] BPF: New helper to obtain namespace data from
 current task
Message-ID: <20190924181432.GA9944@frodo.byteswizards.com>
References: <20190924152005.4659-1-cneirabustos@gmail.com>
 <20190924180117.GA5889@pc-63.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190924180117.GA5889@pc-63.home>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 24, 2019 at 08:01:17PM +0200, Daniel Borkmann wrote:
> On Tue, Sep 24, 2019 at 12:20:01PM -0300, Carlos Neira wrote:
> > Currently bpf_get_current_pid_tgid(), is used to do pid filtering in bcc's
> > scripts but this helper returns the pid as seen by the root namespace which is
> > fine when a bcc script is not executed inside a container.
> > When the process of interest is inside a container, pid filtering will not work
> > if bpf_get_current_pid_tgid() is used.
> > This helper addresses this limitation returning the pid as it's seen by the current
> > namespace where the script is executing.
> > 
> > In the future different pid_ns files may belong to different devices, according to the
> > discussion between Eric Biederman and Yonghong in 2017 Linux plumbers conference.
> > To address that situation the helper requires inum and dev_t from /proc/self/ns/pid.
> > This helper has the same use cases as bpf_get_current_pid_tgid() as it can be
> > used to do pid filtering even inside a container.
> > 
> > Signed-off-by: Carlos Neira <cneirabustos@gmail.com>
> > 
> > Carlos Neira (4):
> >   fs/nsfs.c: added ns_match
> >   bpf: added new helper bpf_get_ns_current_pid_tgid
> >   tools: Added bpf_get_ns_current_pid_tgid helper
> >   tools/testing/selftests/bpf: Add self-tests for new helper. self tests
> >     added for new helper
> 
> bpf-next is currently closed due to merge window. Please resubmit once back open, thanks.

Thanks, Daniel, I'll do so.

Bests.
