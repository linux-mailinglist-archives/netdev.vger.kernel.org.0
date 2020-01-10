Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89155136E00
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 14:27:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728180AbgAJN1R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 08:27:17 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:34285 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727771AbgAJN1R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 08:27:17 -0500
Received: by mail-qt1-f194.google.com with SMTP id 5so1897683qtz.1;
        Fri, 10 Jan 2020 05:27:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=B/rW65qGftn0BWS9QP78JGOqNum2GP3GsMrU96ZV3+c=;
        b=OuSRU6wWa20WiqAHKpR2IKPxWSOfvvqv4wYK7dqyT89n7/Tnpq8U88tPrK550bAzza
         zbVq1VVn3sCSjdCFJ+uIbNljJgx3YRuUjMQkfa9Cwwm2FjoSPg6iAutvnVaqEGJszeP2
         +eSzpeMst8HqDVxDTGqTxVWFlQs9z0AuM88bgE+MSSjjIf/qo43NW6AFnnDtIY+IfIZK
         fGpmi2UNmNQICHAMfkDg1Dx8SKa+9s0S5ij1qy5nw+Q4kIC56f8HZAC4jJRZCmQ77MEn
         AQbO3IlC8l6oGwLioherY3oPqcEA2SgmCS41gIm9+mhYwNBEBWaCq5n+W5QISisZLytQ
         kjHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=B/rW65qGftn0BWS9QP78JGOqNum2GP3GsMrU96ZV3+c=;
        b=XfUaTV4mTDqsr6zlwy/caVgOefeh3cM3WeNBfwoxYZawQoJWDvebDJplV7+5aLlxcA
         pownc7JRPvrdNyvWMlsa0hHTbefyW+hrAYwoHcbCT6HijcBmvQ98g90vs64UrFyIByC+
         ELuBVikHsjXa2YyryOG14Sj/mklIy9nfV+a39AB1TZqY/jUOFgSTDygMyU+TbtaKe9Fy
         5QRsK7iEd0Vo4aZYj/+k4h2dSZGxdpHJu1jpQ55nEY16IBV9DLBhzcHNwS7fTohik9OQ
         y5uNADGdnUsyCTYdXXDasTfwiWWIPlJ03+2cofPSCJa8lyJEjCqOcBDlh/mwV9qRQmrV
         QuSA==
X-Gm-Message-State: APjAAAWqz11phLaVuCpsh22iPiVZiPr83mJgp9YtJP3k1bjfWgXeyjcf
        JXkO+KDZmxOOAsreKj9f/Bk=
X-Google-Smtp-Source: APXvYqwmyLjhNTI95RWHOcPM6ONklxTdyu+eJDEzs/J8OUQBUiTq242wn5RBvggrQGKmwIbk5uxqeQ==
X-Received: by 2002:ac8:d86:: with SMTP id s6mr2380931qti.237.1578662836182;
        Fri, 10 Jan 2020 05:27:16 -0800 (PST)
Received: from frodo.byteswizards.com (pc-184-104-160-190.cm.vtr.net. [190.160.104.184])
        by smtp.gmail.com with ESMTPSA id e3sm979710qtj.30.2020.01.10.05.27.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2020 05:27:15 -0800 (PST)
Date:   Fri, 10 Jan 2020 10:27:11 -0300
From:   Carlos Antonio Neira Bustos <cneirabustos@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Yonghong Song <yhs@fb.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        bpf <bpf@vger.kernel.org>, Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH v16 0/5] BPF: New helper to obtain namespace data from
 current task
Message-ID: <20200110132711.GA1772684@frodo.byteswizards.com>
References: <20191218173827.20584-1-cneirabustos@gmail.com>
 <CAADnVQKQLTLvND=249aR2tYm-SxcJ9BbVi-SQUwuoOpt01knZw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQKQLTLvND=249aR2tYm-SxcJ9BbVi-SQUwuoOpt01knZw@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 09, 2020 at 05:46:29PM -0800, Alexei Starovoitov wrote:
> On Wed, Dec 18, 2019 at 9:38 AM Carlos Neira <cneirabustos@gmail.com> wrote:
> >
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
> 
> I think the set looks like fine. Please respin against bpf-next
> carrying over Yonghong's ack and I'll apply it.
> Please squash patch 2 and 3 together.
> Updates to tools/uapi/bpf.h don't need to be separated anymore.
> Patch 5 can be squashed into them as well.
> Could you also improve selftest from patch 4 to test new helper
> both inside and outside of some container?
> With unshare(CLONE_NEWPID) or something.
> Do you have corresponding bcc change to show how it's going to be used?

Thanks Alexei,
I'll squash patches 2, 3, 5 together and improve the new helper test, regarding bcc
changes, I also need to work on that as the one I created a while ago now
is not valid https://github.com/iovisor/bcc/pull/1901/commits/a81b4352173cb82922d4d4bb965a39f781fd7693

Bests 
