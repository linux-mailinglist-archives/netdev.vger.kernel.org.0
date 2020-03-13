Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFF70184729
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 13:46:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbgCMMqu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 08:46:50 -0400
Received: from mail-qv1-f68.google.com ([209.85.219.68]:39381 "EHLO
        mail-qv1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726674AbgCMMqt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 08:46:49 -0400
Received: by mail-qv1-f68.google.com with SMTP id v38so429031qvf.6;
        Fri, 13 Mar 2020 05:46:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=u8D7lFxERdfnw28CcDzFujvHkimnGDuJQ4TBkFE/6E0=;
        b=cy86IgET7mWAcCLXFYy9unvWjFDV2wt5AzF6zuZ6glKJTzS/QUwGDgw2wCdCKXv1pd
         cTvr2SE+x6qBXWg6omqz98gqawyGW6LKujmy6OyCtgexLHtt+hz9r7MwZit8ogk/Xz2V
         3dh65+cSd65dgWnb+muYExZGGtUbT8gHKnhcDjsutj866Boup+i9u+nikZzLjUvGXwn5
         Ymt/quZEnuzhImVKymOXdXQC1zJ7tKXLt8fk8qioP/enLXn1sH5GBhPozRYN/GY/sc8w
         rtqpiCjnG03IW5JyHJxeb84yNq3lQgpauECsWr84oBKH73LUD//cEuFXrT0LhR4wgDe+
         hGBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=u8D7lFxERdfnw28CcDzFujvHkimnGDuJQ4TBkFE/6E0=;
        b=nfUuw6r0YP2vIsLsMTawac+O+5alLEQg9MG34Xum8urtAuJWRbQcWngD4yxDy+9dtY
         WEiVohB4mwlVRvkOog4zw5aKb5W2KAqwFgHbUOpteBt/w90IrJXnQtQ55avQWQPt8zNJ
         bIdhDU2W37mHD0yuZ3a8LcvBykQSfADBOPr0ROqcWcJdUpQCpH2OzePYuEJRerAfu8d7
         W/5Uw9EclEHwnH/EQdbBe/21OKRFbYsz2FwzPpH8HULDoKaYfaY/airieTcohH35hYcq
         iME6glXKcHEvJVfIKLmqX1BGLJoDfFTwu6DoPZa7RI0sBgSu02HPpTcvU+eqlniDJoOD
         uNUA==
X-Gm-Message-State: ANhLgQ2+1hAc9OY8Uh8YJvD2JQllSH9BX9mBqE5CAfsuyu77ZPy5Kitj
        7AOzd6qUvUYHICUM4XJU16o=
X-Google-Smtp-Source: ADFU+vv93u2I2VZ6Mq/zuFsCxxdGSsv7jeWOwcAVnFs2rbuPuCxw7KGn5CXqkXQb71QYSwusQalDLw==
X-Received: by 2002:a05:6214:10c2:: with SMTP id r2mr12341957qvs.83.1584103608676;
        Fri, 13 Mar 2020 05:46:48 -0700 (PDT)
Received: from bpf-dev (pc-184-104-160-190.cm.vtr.net. [190.160.104.184])
        by smtp.gmail.com with ESMTPSA id k66sm16956431qke.10.2020.03.13.05.46.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2020 05:46:48 -0700 (PDT)
Date:   Fri, 13 Mar 2020 09:46:43 -0300
From:   Carlos Antonio Neira Bustos <cneirabustos@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Yonghong Song <yhs@fb.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH v17 0/3] BPF: New helper to obtain namespace data from
 current task
Message-ID: <20200313124642.GA1309@bpf-dev>
References: <20200304204157.58695-1-cneirabustos@gmail.com>
 <CAADnVQL4GR2kOoiLE0aTorvYzTPWrOCV4yKMh1BasYTVHkKxcg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQL4GR2kOoiLE0aTorvYzTPWrOCV4yKMh1BasYTVHkKxcg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 12, 2020 at 05:45:09PM -0700, Alexei Starovoitov wrote:
> On Wed, Mar 4, 2020 at 12:42 PM Carlos Neira <cneirabustos@gmail.com> wrote:
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
> Applied. Thanks.
> There was one spurious trailing whitespace that I fixed in patch 3
> and missing .gitignore update for test_current_pid_tgid_new_ns.
> Could you please follow up with another patch to fold
> test_current_pid_tgid_new_ns into test_progs.
> I'd really like to consolidate all tests into single binary.

Thank you very much Alexei,
I'll start working on the follow up patch to add test_current_pid_tgid_new_ns into test_progs.

Bests
