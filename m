Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04C78ADE27
	for <lists+netdev@lfdr.de>; Mon,  9 Sep 2019 19:45:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391414AbfIIRp3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 13:45:29 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:34694 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729123AbfIIRp2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Sep 2019 13:45:28 -0400
Received: by mail-qt1-f196.google.com with SMTP id j1so4429622qth.1;
        Mon, 09 Sep 2019 10:45:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=zSTggXbkZ+/T6XFogNndSLt8tl5tOyyc2sM8sc5c4uM=;
        b=kjsHtu09FjH165H2drSV6tUDP6K+HFXrlcIktljGAm2P0Y+BFNSauADOp8+DWv5wsD
         p3ypt5L5ATyopDV7L6H+udQdB8dOmQNG/ndy7hEsC1FPjLP758/za8qwon7gsENd+iIR
         e6G4ZuyyEe3a6b49dRdPCACzqkyQg2lDOncyuTM+zj1weQ8uOVzErDa9qRaoMZ3Z15FX
         SOWIanXtvMh6a2ik+aVPiPZsWkE6DO7m22v75pkARWRwAM8ZkMBOsaPkCCkGsXbNKajC
         M46w40S3Jh+dHozfHSElIJKWZCRUGar8fxgzbak5J7IZzOd2zeNEsM0+jVYsg6mwkKrl
         xU9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=zSTggXbkZ+/T6XFogNndSLt8tl5tOyyc2sM8sc5c4uM=;
        b=NtiefmMAS+uoSED6Tt1rw653hNUsWwQXrSfjrPxUjedoZvIdrpE+reX1wIM8dOnu3k
         kuCHJ0WEf6YAvYHl079HzHrQT5+NbHOYcjxUowX83q0MXpgl1/H8DnVmDQXP4nFoVoHw
         5HnXKneruhmeuksVWNxonxxd6OQW8n0TgnE6vo8vKCqri+Pd+DyIl/ckN+XUnPe7WG5h
         7J0hhGqa2bEY5Te00ht4syeE1IhpSMFclQi7USHJGimcjTz40L8trgOW9JOFwW6tyg/l
         Sot/Od2VWGNmhfV7HeWqpe1iIcLXR1+gQaITO5PHEhBYkLYZnA13AgL/Fcnwxku+tiRJ
         9dcQ==
X-Gm-Message-State: APjAAAWMG5bg4XxCa4yKDPYKBrcbdfCjljLgCtwv4yVmWNKwJuSmP6Tz
        2FOGbMe6ZEEpKUktImtAzRQ=
X-Google-Smtp-Source: APXvYqznxJn4ABbbc/lJIMFWIiZT2tGQ90fh1bUNKAk6VCvoM0fJr0MzVUh9af9D5fY7XVztukNVxQ==
X-Received: by 2002:ac8:51d2:: with SMTP id d18mr25327621qtn.377.1568051127065;
        Mon, 09 Sep 2019 10:45:27 -0700 (PDT)
Received: from frodo.byteswizards.com ([190.162.109.190])
        by smtp.gmail.com with ESMTPSA id 62sm6920477qki.130.2019.09.09.10.45.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Sep 2019 10:45:25 -0700 (PDT)
Date:   Mon, 9 Sep 2019 14:45:22 -0300
From:   Carlos Antonio Neira Bustos <cneirabustos@gmail.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next v10 2/4] bpf: new helper to obtain namespace
 data from current task New bpf helper bpf_get_current_pidns_info.
Message-ID: <20190909174522.GA17882@frodo.byteswizards.com>
References: <20190906150952.23066-1-cneirabustos@gmail.com>
 <20190906150952.23066-3-cneirabustos@gmail.com>
 <20190906152435.GW1131@ZenIV.linux.org.uk>
 <20190906154647.GA19707@ZenIV.linux.org.uk>
 <20190906160020.GX1131@ZenIV.linux.org.uk>
 <c0e67fc7-be66-c4c6-6aad-316cbba18757@fb.com>
 <20190907001056.GA1131@ZenIV.linux.org.uk>
 <7d196a64-cf36-c2d5-7328-154aaeb929eb@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7d196a64-cf36-c2d5-7328-154aaeb929eb@fb.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks a lot, Al Viro and Yonghong for taking the time to review this patch and
provide technical insights needed on this one.
But how do we move this forward? 
Al Viro's review is clear that this will not work and we should strip the name 
resolution code (thanks for your detailed analysis).
As there is currently only one instance of the nsfs device on the system,  
I think we could leave out the retrieval of the pidns device number and address it
when the situation changes.
What do you think?


On Sat, Sep 07, 2019 at 06:34:39AM +0000, Yonghong Song wrote:
> 
> 
> On 9/6/19 5:10 PM, Al Viro wrote:
> > On Fri, Sep 06, 2019 at 11:21:14PM +0000, Yonghong Song wrote:
> > 
> >> -bash-4.4$ readlink /proc/self/ns/pid
> >> pid:[4026531836]
> >> -bash-4.4$ stat /proc/self/ns/pid
> >>     File: ‘/proc/self/ns/pid’ -> ‘pid:[4026531836]’
> >>     Size: 0               Blocks: 0          IO Block: 1024   symbolic link
> >> Device: 4h/4d   Inode: 344795989   Links: 1
> >> Access: (0777/lrwxrwxrwx)  Uid: (128203/     yhs)   Gid: (  100/   users)
> >> Context: user_u:base_r:base_t
> >> Access: 2019-09-06 16:06:09.431616380 -0700
> >> Modify: 2019-09-06 16:06:09.431616380 -0700
> >> Change: 2019-09-06 16:06:09.431616380 -0700
> >>    Birth: -
> >> -bash-4.4$
> >>
> >> Based on a discussion with Eric Biederman back in 2019 Linux
> >> Plumbers, Eric suggested that to uniquely identify a
> >> namespace, device id (major/minor) number should also
> >> be included. Although today's kernel implementation
> >> has the same device for all namespace pseudo files,
> >> but from uapi perspective, device id should be included.
> >>
> >> That is the reason why we try to get device id which holds
> >> pid namespace pseudo file.
> >>
> >> Do you have a better suggestion on how to get
> >> the device id for 'current' pid namespace? Or from design, we
> >> really should not care about device id at all?
> > 
> > What the hell is "device id for pid namespace"?  This is the
> > first time I've heard about that mystery object, so it's
> > hard to tell where it could be found.
> > 
> > I can tell you what device numbers are involved in the areas
> > you seem to be looking in.
> > 
> > 1) there's whatever device number that gets assigned to
> > (this) procfs instance.  That, ironically, _is_ per-pidns, but
> > that of the procfs instance, not that of your process (and
> > those can be different).  That's what you get in ->st_dev
> > when doing lstat() of anything in /proc (assuming that
> > procfs is mounted there, in the first place).  NOTE:
> > that's lstat(2), not stat(2).  stat(1) uses lstat(2),
> > unless given -L (in which case it's stat(2) time).  The
> > difference:
> > 
> > root@kvm1:~# stat /proc/self/ns/pid
> >    File: /proc/self/ns/pid -> pid:[4026531836]
> >    Size: 0               Blocks: 0          IO Block: 1024   symbolic link
> > Device: 4h/4d   Inode: 17396       Links: 1
> > Access: (0777/lrwxrwxrwx)  Uid: (    0/    root)   Gid: (    0/    root)
> > Access: 2019-09-06 19:43:11.871312319 -0400
> > Modify: 2019-09-06 19:43:11.871312319 -0400
> > Change: 2019-09-06 19:43:11.871312319 -0400
> >   Birth: -
> > root@kvm1:~# stat -L /proc/self/ns/pid
> >    File: /proc/self/ns/pid
> >    Size: 0               Blocks: 0          IO Block: 4096   regular empty file
> > Device: 3h/3d   Inode: 4026531836  Links: 1
> > Access: (0444/-r--r--r--)  Uid: (    0/    root)   Gid: (    0/    root)
> > Access: 2019-09-06 19:43:15.955313293 -0400
> > Modify: 2019-09-06 19:43:15.955313293 -0400
> > Change: 2019-09-06 19:43:15.955313293 -0400
> >   Birth: -
> > 
> > The former is lstat, the latter - stat.
> > 
> > 2) device number of the filesystem where the symlink target lives.
> > In this case, it's nsfs and there's only one instance on the entire
> > system.  _That_ would be obtained by looking at st_dev in stat(2) on
> > /proc/self/ns/pid (0:3 above).
> > 
> > 3) device number *OF* the symlink.  That would be st_rdev in lstat(2).
> > There's none - it's a symlink, not a character or block device.  It's
> > always zero and always will be zero.
> > 
> > 4) the same for the target; st_rdev in stat(2) results and again,
> > there's no such beast - it's neither character nor block device.
> > 
> > Your code is looking at (3).  Please, reread any textbook on Unix
> > in the section that would cover stat(2) and discussion of the
> > difference between st_dev and st_rdev.
> > 
> > I have no idea what Eric had been talking about - it's hard to
> > reconstruct by what you said so far.  Making nsfs per-userns,
> > perhaps?  But that makes no sense whatsoever, not that userns
> > ever had...  Cheap shots aside, I really can't guess what that's
> > about.  Sorry.
> 
> Thanks for the detailed information. The device number we want
> is nsfs. Indeed, currently, there is only one instance
> on the entire system. But not exactly sure what is the possibility
> to have more than one nsfs device in the future. Maybe per-userns
> or any other criteria?
> 
> > 
> > In any case, pathname resolution is *NOT* for the situations where
> > you can't block.  Even if it's procfs (and from the same pidns as
> > the process) mounted there, there is no promise that the target
> > of /proc/self has already been looked up and not evicted from
> > memory since then.  And in case of cache miss pathwalk will
> > have to call ->lookup(), which requires locking the directory
> > (rw_sem, shared).  You can't do that in such context.
> > 
> > And that doesn't even go into the possibility that process has
> > something very different mounted on /proc.
> > 
> > Again, I don't know what it is that you want to get to, but
> > I would strongly recommend finding a way to get to that data
> > that would not involve going anywhere near pathname resolution.
> > 
> > How would you expect the userland to work with that value,
> > whatever it might be?  If it's just a 32bit field that will
> > never be read, you might as well store there the same value
> > you store now (0, that is) in much cheaper and safer way ;-)
> 
> Suppose inside pid namespace, user can pass the device number,
> say n1, (`stat -L /proc/self/ns/pid`) to bpf program (through map
> or JIT). At runtime, bpf program will try to get device number,
> say n2, for the 'current' process. If n1 is not the same as
> n2, that means they are not in the same namespace. 'current'
> is in the same pid namespace as the user iff
> n1 == n2 and also pidns id is the same for 'current' and
> the one with `lsns -t pid`.
> 
> Are you aware of any way to get the pidns device number
> for 'current' without going through the pathname
> lookup?
> 
