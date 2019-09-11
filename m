Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29027AF515
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 06:32:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726018AbfIKEcd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 00:32:33 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:39332 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbfIKEcd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 00:32:33 -0400
Received: by mail-qt1-f193.google.com with SMTP id n7so23655738qtb.6;
        Tue, 10 Sep 2019 21:32:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=RZVyJMzDm7Ro/qZ7rmhXMemXLE9EwV5VPEs9TqdHIE0=;
        b=IbB/QfmOhXu/8xtENCZHwwHGbFLBciNjBF0Xbfs2Dt68HXndLzau3bx4j4L2+pUHXS
         nnymotPNgk8M9hZF1JXmX+EBTltkTQtbSgwNq+1an5m1Sez6l1xqJfsz1wzrHJC33/5l
         9xJ4FxD1Ozh0DhQSOJ3UMSdgf/c5lb6qwBmc/35Ms5B0tV/T1PbGUwkivECAgDWhwgi4
         yWL/i62vqMRymGvPajeJ7HOfZzFG2IkXeSssJyoXnOr2+DwIJgdlsnQbDE38niABuOUW
         zcyu1QY9GaT5+UAFcS4+1Zzu2yu1LuWW59WjANfpaHTSkp5KZqWgYzt1ebcq4jUCfPO+
         qXiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=RZVyJMzDm7Ro/qZ7rmhXMemXLE9EwV5VPEs9TqdHIE0=;
        b=PFm0zM/eZjO9aMKTTODFOIQ/cf+AVR7iDIw4mR5ct6YWxNrtG/3XEz4slt1JfHZDAh
         a9kQ7No4UlYyxuXi2onogW+GUsb9YXLMFin30O0DV9ulLU0r/ymB/LWp2mmle991xA9B
         1aShI/Bo8GgIzRlDZOUUKY/VDnRRnC7Q9IRlIIDQQKJxmJAL566F/7fkEVMp8fk1pqjC
         9crBK/nXW+qDwgrghh13Ia2ZylXqIF3qMwiguSItWgI8oFJBQhkS2wpwxcl23v0M8NK2
         tIWHygKLiUq2DKetP1DsOIecP0iM3p4j+YFYCubixDD+WK9XUj6OZENsNG5yu1HfhESl
         SbOA==
X-Gm-Message-State: APjAAAWe+Zpq0zy99yuslDpkeRy58aCtCweWFYaCykG0Gh0Jphg0psdB
        ZUmQBLJlyk98GDs8DkU/VXc=
X-Google-Smtp-Source: APXvYqz6ZPpy1ZDvUYSM9ZF32f0dn7w6OrvWGGekgQkXxClHdAld8GmSrZ7l1J36HI82jQ5icb+nag==
X-Received: by 2002:ac8:3a84:: with SMTP id x4mr30993849qte.334.1568176351188;
        Tue, 10 Sep 2019 21:32:31 -0700 (PDT)
Received: from frodo.byteswizards.com ([190.162.109.190])
        by smtp.gmail.com with ESMTPSA id m136sm7703396qke.78.2019.09.10.21.32.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Sep 2019 21:32:30 -0700 (PDT)
Date:   Wed, 11 Sep 2019 01:32:25 -0300
From:   Carlos Antonio Neira Bustos <cneirabustos@gmail.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next v10 2/4] bpf: new helper to obtain namespace
 data from current task New bpf helper bpf_get_current_pidns_info.
Message-ID: <20190911043225.GA22183@frodo.byteswizards.com>
References: <20190906150952.23066-1-cneirabustos@gmail.com>
 <20190906150952.23066-3-cneirabustos@gmail.com>
 <20190906152435.GW1131@ZenIV.linux.org.uk>
 <20190906154647.GA19707@ZenIV.linux.org.uk>
 <20190906160020.GX1131@ZenIV.linux.org.uk>
 <c0e67fc7-be66-c4c6-6aad-316cbba18757@fb.com>
 <20190907001056.GA1131@ZenIV.linux.org.uk>
 <7d196a64-cf36-c2d5-7328-154aaeb929eb@fb.com>
 <20190909174522.GA17882@frodo.byteswizards.com>
 <dadf3657-2648-14ef-35ee-e09efb2cdb3e@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <dadf3657-2648-14ef-35ee-e09efb2cdb3e@fb.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 10, 2019 at 10:35:09PM +0000, Yonghong Song wrote:
Thanks a lot Yonghong.
I'll include this patch when submitting changes for version 11 of
this patch. 
> 
> Carlos,
> 
> Discussed with Eric today for what is the best way to get
> the device number for a namespace. The following patch seems
> a reasonable start although Eric would like to see
> how the helper is used in order to decide whether the
> interface looks right.
> 
> commit bb00fc36d5d263047a8bceb3e51e969d7fbce7db (HEAD -> fs2)
> Author: Yonghong Song <yhs@fb.com>
> Date:   Mon Sep 9 21:50:51 2019 -0700
> 
>      nsfs: add an interface function ns_get_inum_dev()
> 
>      This patch added an interface function
>      ns_get_inum_dev(). Given a ns_common structure,
>      the function returns the inode and device
>      numbers. The function will be used later
>      by a newly added bpf helper.
> 
>      Signed-off-by: Yonghong Song <yhs@fb.com>
> 
> diff --git a/fs/nsfs.c b/fs/nsfs.c
> index a0431642c6b5..a603c6fc3f54 100644
> --- a/fs/nsfs.c
> +++ b/fs/nsfs.c
> @@ -245,6 +245,14 @@ struct file *proc_ns_fget(int fd)
>          return ERR_PTR(-EINVAL);
>   }
> 
> +/* Get the device number for the current task pidns.
> + */
> +void ns_get_inum_dev(struct ns_common *ns, u32 *inum, dev_t *dev)
> +{
> +       *inum = ns->inum;
> +       *dev = nsfs_mnt->mnt_sb->s_dev;
> +}
> +
>   static int nsfs_show_path(struct seq_file *seq, struct dentry *dentry)
>   {
>          struct inode *inode = d_inode(dentry);
> diff --git a/include/linux/proc_ns.h b/include/linux/proc_ns.h
> index d31cb6215905..b8fc680cdf1a 100644
> --- a/include/linux/proc_ns.h
> +++ b/include/linux/proc_ns.h
> @@ -81,6 +81,7 @@ extern void *ns_get_path(struct path *path, struct 
> task_struct *task,
>   typedef struct ns_common *ns_get_path_helper_t(void *);
>   extern void *ns_get_path_cb(struct path *path, ns_get_path_helper_t 
> ns_get_cb,
>                              void *private_data);
> +extern void ns_get_inum_dev(struct ns_common *ns, u32 *inum, dev_t *dev);
> 
>   extern int ns_get_name(char *buf, size_t size, struct task_struct *task,
>                          const struct proc_ns_operations *ns_ops);
> 
> Could you put the above change and patch #1 and then have
> all your other patches? In your kernel change, please use
> interface function ns_get_inum_dev() to get pidns inode number
> and dev number.
> 
> On 9/9/19 6:45 PM, Carlos Antonio Neira Bustos wrote:
> > Thanks a lot, Al Viro and Yonghong for taking the time to review this patch and
> > provide technical insights needed on this one.
> > But how do we move this forward?
> > Al Viro's review is clear that this will not work and we should strip the name
> > resolution code (thanks for your detailed analysis).
> > As there is currently only one instance of the nsfs device on the system,
> > I think we could leave out the retrieval of the pidns device number and address it
> > when the situation changes.
> > What do you think?
> > 
> > 
> > On Sat, Sep 07, 2019 at 06:34:39AM +0000, Yonghong Song wrote:
> >>
> >>
> >> On 9/6/19 5:10 PM, Al Viro wrote:
> >>> On Fri, Sep 06, 2019 at 11:21:14PM +0000, Yonghong Song wrote:
> >>>
> >>>> -bash-4.4$ readlink /proc/self/ns/pid
> >>>> pid:[4026531836]
> >>>> -bash-4.4$ stat /proc/self/ns/pid
> >>>>      File: ‘/proc/self/ns/pid’ -> ‘pid:[4026531836]’
> >>>>      Size: 0               Blocks: 0          IO Block: 1024   symbolic link
> >>>> Device: 4h/4d   Inode: 344795989   Links: 1
> >>>> Access: (0777/lrwxrwxrwx)  Uid: (128203/     yhs)   Gid: (  100/   users)
> >>>> Context: user_u:base_r:base_t
> >>>> Access: 2019-09-06 16:06:09.431616380 -0700
> >>>> Modify: 2019-09-06 16:06:09.431616380 -0700
> >>>> Change: 2019-09-06 16:06:09.431616380 -0700
> >>>>     Birth: -
> >>>> -bash-4.4$
> >>>>
> >>>> Based on a discussion with Eric Biederman back in 2019 Linux
> >>>> Plumbers, Eric suggested that to uniquely identify a
> >>>> namespace, device id (major/minor) number should also
> >>>> be included. Although today's kernel implementation
> >>>> has the same device for all namespace pseudo files,
> >>>> but from uapi perspective, device id should be included.
> >>>>
> >>>> That is the reason why we try to get device id which holds
> >>>> pid namespace pseudo file.
> >>>>
> >>>> Do you have a better suggestion on how to get
> >>>> the device id for 'current' pid namespace? Or from design, we
> >>>> really should not care about device id at all?
> >>>
> >>> What the hell is "device id for pid namespace"?  This is the
> >>> first time I've heard about that mystery object, so it's
> >>> hard to tell where it could be found.
> >>>
> >>> I can tell you what device numbers are involved in the areas
> >>> you seem to be looking in.
> >>>
> >>> 1) there's whatever device number that gets assigned to
> >>> (this) procfs instance.  That, ironically, _is_ per-pidns, but
> >>> that of the procfs instance, not that of your process (and
> >>> those can be different).  That's what you get in ->st_dev
> >>> when doing lstat() of anything in /proc (assuming that
> >>> procfs is mounted there, in the first place).  NOTE:
> >>> that's lstat(2), not stat(2).  stat(1) uses lstat(2),
> >>> unless given -L (in which case it's stat(2) time).  The
> >>> difference:
> >>>
> >>> root@kvm1:~# stat /proc/self/ns/pid
> >>>     File: /proc/self/ns/pid -> pid:[4026531836]
> >>>     Size: 0               Blocks: 0          IO Block: 1024   symbolic link
> >>> Device: 4h/4d   Inode: 17396       Links: 1
> >>> Access: (0777/lrwxrwxrwx)  Uid: (    0/    root)   Gid: (    0/    root)
> >>> Access: 2019-09-06 19:43:11.871312319 -0400
> >>> Modify: 2019-09-06 19:43:11.871312319 -0400
> >>> Change: 2019-09-06 19:43:11.871312319 -0400
> >>>    Birth: -
> >>> root@kvm1:~# stat -L /proc/self/ns/pid
> >>>     File: /proc/self/ns/pid
> >>>     Size: 0               Blocks: 0          IO Block: 4096   regular empty file
> >>> Device: 3h/3d   Inode: 4026531836  Links: 1
> >>> Access: (0444/-r--r--r--)  Uid: (    0/    root)   Gid: (    0/    root)
> >>> Access: 2019-09-06 19:43:15.955313293 -0400
> >>> Modify: 2019-09-06 19:43:15.955313293 -0400
> >>> Change: 2019-09-06 19:43:15.955313293 -0400
> >>>    Birth: -
> >>>
> >>> The former is lstat, the latter - stat.
> >>>
> >>> 2) device number of the filesystem where the symlink target lives.
> >>> In this case, it's nsfs and there's only one instance on the entire
> >>> system.  _That_ would be obtained by looking at st_dev in stat(2) on
> >>> /proc/self/ns/pid (0:3 above).
> >>>
> >>> 3) device number *OF* the symlink.  That would be st_rdev in lstat(2).
> >>> There's none - it's a symlink, not a character or block device.  It's
> >>> always zero and always will be zero.
> >>>
> >>> 4) the same for the target; st_rdev in stat(2) results and again,
> >>> there's no such beast - it's neither character nor block device.
> >>>
> >>> Your code is looking at (3).  Please, reread any textbook on Unix
> >>> in the section that would cover stat(2) and discussion of the
> >>> difference between st_dev and st_rdev.
> >>>
> >>> I have no idea what Eric had been talking about - it's hard to
> >>> reconstruct by what you said so far.  Making nsfs per-userns,
> >>> perhaps?  But that makes no sense whatsoever, not that userns
> >>> ever had...  Cheap shots aside, I really can't guess what that's
> >>> about.  Sorry.
> >>
> >> Thanks for the detailed information. The device number we want
> >> is nsfs. Indeed, currently, there is only one instance
> >> on the entire system. But not exactly sure what is the possibility
> >> to have more than one nsfs device in the future. Maybe per-userns
> >> or any other criteria?
> >>
> >>>
> >>> In any case, pathname resolution is *NOT* for the situations where
> >>> you can't block.  Even if it's procfs (and from the same pidns as
> >>> the process) mounted there, there is no promise that the target
> >>> of /proc/self has already been looked up and not evicted from
> >>> memory since then.  And in case of cache miss pathwalk will
> >>> have to call ->lookup(), which requires locking the directory
> >>> (rw_sem, shared).  You can't do that in such context.
> >>>
> >>> And that doesn't even go into the possibility that process has
> >>> something very different mounted on /proc.
> >>>
> >>> Again, I don't know what it is that you want to get to, but
> >>> I would strongly recommend finding a way to get to that data
> >>> that would not involve going anywhere near pathname resolution.
> >>>
> >>> How would you expect the userland to work with that value,
> >>> whatever it might be?  If it's just a 32bit field that will
> >>> never be read, you might as well store there the same value
> >>> you store now (0, that is) in much cheaper and safer way ;-)
> >>
> >> Suppose inside pid namespace, user can pass the device number,
> >> say n1, (`stat -L /proc/self/ns/pid`) to bpf program (through map
> >> or JIT). At runtime, bpf program will try to get device number,
> >> say n2, for the 'current' process. If n1 is not the same as
> >> n2, that means they are not in the same namespace. 'current'
> >> is in the same pid namespace as the user iff
> >> n1 == n2 and also pidns id is the same for 'current' and
> >> the one with `lsns -t pid`.
> >>
> >> Are you aware of any way to get the pidns device number
> >> for 'current' without going through the pathname
> >> lookup?
> >>
