Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AFA51A2ED2
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 07:39:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726574AbgDIFjb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 01:39:31 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:43024 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726052AbgDIFja (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Apr 2020 01:39:30 -0400
Received: by mail-io1-f66.google.com with SMTP id u2so2630760iop.10;
        Wed, 08 Apr 2020 22:39:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ljGAHp2OjKbTOFHe8vnoaVTTxVxXbioqrcoMST1/WOo=;
        b=HkG56GMfGJ4oOadqcLZ8K9Ajjq83Iyh59fq801QTD4zro/RN9oEeQEvooFasxrfuGz
         BzKmFHaUGhXK5R2MqHGJXcMU0QKgkBTY9bk+Dr4xm1NO0WnnQDZcuNwAPvu7wGpOCMmk
         t2K7/u5Y6+3RA8y1RUgDhYz8BgvFB3eBZtM1sNjmiGhfoL7OGG6x33RmyDZqQkx4dXek
         IIwzbjuPUQU9harCVey752sogp8rmD+CdeW8CIUUtNyxJh4PdV7nhEDY21FTP4E5vBpX
         mkrasJc8tvc6IXNJGIeutXFt6PI1hokvM0Kb4dfs4HpUBUSwID2C+0VsV/m895xuZkyj
         Ub4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ljGAHp2OjKbTOFHe8vnoaVTTxVxXbioqrcoMST1/WOo=;
        b=UjHuUOQPsMnVOw9k7TCYcsoQPfhJFSviIjZO9p0GYqkwYZKP3vXURcSvzbl6cYS0aC
         hawMtXw5Uh/yqNMZaucNU+J/QcyKhHOhBO667EWjL/iMRuRUx/6p3yX+atVYoGn2MUeN
         zVhie+NVB9NxIbGcR7OwuIYRia2LqYPdBAxnORoSW9V4PK9FE9ZkDaNgz6H7SHm6GUIY
         SbuG9TUtK4AxBF5DuX3Gaueovq8hCNhqag/lrukKXz9a/c/hrsXvinUL1+GCZHkR4a8C
         4/UgcMdnXUJwzmkqy7KM5RdN+c4+F/ADX/HyLS8mSBTixCX7jqDGGSyXCDC+3akvDKbO
         51XA==
X-Gm-Message-State: AGi0PuahwDRDpvxeukGixeVhGF4lNay2Ykvb+DZYWgizQ1xYQGAy+QUY
        6gSqNjSJHtG4X4x4tJ/C9pxzhZKfsQeUnbiIz2o=
X-Google-Smtp-Source: APiQypIL7SeYio2ZFuNp5g6MDFQufig71I9V1q4nfq+9nWJ+P9gSXGZQgEVwLHyPBwzlz+ajo1kFs5NqvWoLGRKwBuA=
X-Received: by 2002:a05:6638:186:: with SMTP id a6mr1070872jaq.36.1586410769722;
 Wed, 08 Apr 2020 22:39:29 -0700 (PDT)
MIME-Version: 1.0
References: <20200408152151.5780-1-christian.brauner@ubuntu.com> <20200408152151.5780-3-christian.brauner@ubuntu.com>
In-Reply-To: <20200408152151.5780-3-christian.brauner@ubuntu.com>
From:   David Rheinsberg <david.rheinsberg@gmail.com>
Date:   Thu, 9 Apr 2020 07:39:18 +0200
Message-ID: <CADyDSO54-GuSUJrciSD2jbSShCYDpXCp53cr+D7u0ZQT141uTA@mail.gmail.com>
Subject: Re: [PATCH 2/8] loopfs: implement loopfs
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        lkml <linux-kernel@vger.kernel.org>, linux-block@vger.kernel.org,
        linux-api@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Serge Hallyn <serge@hallyn.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>, Tejun Heo <tj@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Saravana Kannan <saravanak@google.com>,
        Jan Kara <jack@suse.cz>, David Howells <dhowells@redhat.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        Tom Gundersen <teg@jklm.no>,
        Christian Kellner <ckellner@redhat.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        =?UTF-8?Q?St=C3=A9phane_Graber?= <stgraber@ubuntu.com>,
        linux-doc@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi

On Wed, Apr 8, 2020 at 5:27 PM Christian Brauner
<christian.brauner@ubuntu.com> wrote:
>
> This implements loopfs, a loop device filesystem. It takes inspiration
> from the binderfs filesystem I implemented about two years ago and with
> which we had overally good experiences so far. Parts of it are also
> based on [3] but it's mostly a new, imho cleaner approach.
>
> One of the use-cases for loopfs is to allow to dynamically allocate loop
> devices in sandboxed workloads without exposing /dev or
> /dev/loop-control to the workload in question and without having to
> implement a complex and also racy protocol to send around file
> descriptors for loop devices. With loopfs each mount is a new instance,
> i.e. loop devices created in one loopfs instance are independent of any
> loop devices created in another loopfs instance. This allows
> sufficiently privileged tools to have their own private stash of loop
> device instances.
>
> In addition, the loopfs filesystem can be mounted by user namespace root
> and is thus suitable for use in containers. Combined with syscall
> interception this makes it possible to securely delegate mounting of
> images on loop devices, i.e. when a users calls mount -o loop <image>
> <mountpoint> it will be possible to completely setup the loop device
> (enabled in later patches) and the mount syscall to actually perform the
> mount will be handled through syscall interception and be performed by a
> sufficiently privileged process. Syscall interception is already
> supported through a new seccomp feature we implemented in [1] and
> extended in [2] and is actively used in production workloads. The
> additional loopfs work will be used there and in various other workloads
> too.
>
> The number of loop devices available to a loopfs instance can be limited
> by setting the "max" mount option to a positive integer. This e.g.
> allows sufficiently privileged processes to dynamically enforce a limit
> on the number of devices. This limit is dynamic in contrast to the
> max_loop module option in that a sufficiently privileged process can
> update it with a simple remount operation.
>
> The loopfs filesystem is placed under a new config option and special
> care has been taken to not introduce any new code when users do not
> select this config option.
>
> Note that in __loop_clr_fd() we now need not just check whether bdev is
> valid but also whether bdev->bd_disk is valid. This wasn't necessary
> before because in order to call LOOP_CLR_FD the loop device would need
> to be open and thus bdev->bd_disk was guaranteed to be allocated. For
> loopfs loop devices we allow callers to simply unlink them just as we do
> for binderfs binder devices and we do also need to account for the case
> where a loopfs superblock is shutdown while backing files might still be
> associated with some loop devices. In such cases no bd_disk device will
> be attached to bdev. This is not in itself noteworthy it's more about
> documenting the "why" of the added bdev->bd_disk check for posterity.
>
> [1]: 6a21cc50f0c7 ("seccomp: add a return code to trap to userspace")
> [2]: fb3c5386b382 ("seccomp: add SECCOMP_USER_NOTIF_FLAG_CONTINUE")
> [3]: https://lore.kernel.org/lkml/1401227936-15698-1-git-send-email-seth.forshee@canonical.com
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Seth Forshee <seth.forshee@canonical.com>
> Cc: Tom Gundersen <teg@jklm.no>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Christian Kellner <ckellner@redhat.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: David Rheinsberg <david.rheinsberg@gmail.com>
> Cc: Dmitry Vyukov <dvyukov@google.com>
> Cc: "Rafael J. Wysocki" <rafael@kernel.org>
> Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
> ---
>  MAINTAINERS                   |   5 +
>  drivers/block/Kconfig         |   4 +
>  drivers/block/Makefile        |   1 +
>  drivers/block/loop.c          | 151 +++++++++---
>  drivers/block/loop.h          |   8 +-
>  drivers/block/loopfs/Makefile |   3 +
>  drivers/block/loopfs/loopfs.c | 429 ++++++++++++++++++++++++++++++++++
>  drivers/block/loopfs/loopfs.h |  35 +++
>  include/uapi/linux/magic.h    |   1 +
>  9 files changed, 600 insertions(+), 37 deletions(-)
>  create mode 100644 drivers/block/loopfs/Makefile
>  create mode 100644 drivers/block/loopfs/loopfs.c
>  create mode 100644 drivers/block/loopfs/loopfs.h
>
[...]
> diff --git a/drivers/block/loopfs/loopfs.c b/drivers/block/loopfs/loopfs.c
> new file mode 100644
> index 000000000000..ac46aa337008
> --- /dev/null
> +++ b/drivers/block/loopfs/loopfs.c
> @@ -0,0 +1,429 @@
[...]
> +/**
> + * loopfs_loop_device_create - allocate inode from super block of a loopfs mount
> + * @lo:                loop device for which we are creating a new device entry
> + * @ref_inode: inode from wich the super block will be taken
> + * @device_nr:  device number of the associated disk device
> + *
> + * This function creates a new device node for @lo.
> + * Minor numbers are limited and tracked globally. The
> + * function will stash a struct loop_device for the specific loop
> + * device in i_private of the inode.
> + * It will go on to allocate a new inode from the super block of the
> + * filesystem mount, stash a struct loop_device in its i_private field
> + * and attach a dentry to that inode.
> + *
> + * Return: 0 on success, negative errno on failure
> + */
> +int loopfs_loop_device_create(struct loop_device *lo, struct inode *ref_inode,
> +                             dev_t device_nr)
> +{
> +       char name[DISK_NAME_LEN];
> +       struct super_block *sb;
> +       struct loopfs_info *info;
> +       struct dentry *root, *dentry;
> +       struct inode *inode;
> +
> +       sb = loopfs_i_sb(ref_inode);
> +       if (!sb)
> +               return 0;
> +
> +       if (MAJOR(device_nr) != LOOP_MAJOR)
> +               return -EINVAL;
> +
> +       info = LOOPFS_SB(sb);
> +       if ((info->device_count + 1) > info->mount_opts.max)
> +               return -ENOSPC;

Can you elaborate what the use-case for this limit is?

With loopfs in place, any process can create its own user_ns, mount
their private loopfs and create as many loop-devices as they want.
Hence, this limit does not serve as an effective global
resource-control. Secondly, anyone with access to `loop-control` can
now create loop instances until this limit is hit, thus causing anyone
else to be unable to create more. This effectively prevents you from
sharing a loopfs between non-trusting parties. I am unsure where that
limit would actually be used?

Thanks
David

> +
> +       if (snprintf(name, sizeof(name), "loop%d", lo->lo_number) >= sizeof(name))
> +               return -EINVAL;
> +
> +       inode = new_inode(sb);
> +       if (!inode)
> +               return -ENOMEM;
> +
> +       /*
> +        * The i_fop field will be set to the correct fops by the device layer
> +        * when the loop device in this loopfs instance is opened.
> +        */
> +       inode->i_ino = MINOR(device_nr) + INODE_OFFSET;
> +       inode->i_mtime = inode->i_atime = inode->i_ctime = current_time(inode);
> +       inode->i_uid = info->root_uid;
> +       inode->i_gid = info->root_gid;
> +       init_special_inode(inode, S_IFBLK | 0600, device_nr);
> +
> +       root = sb->s_root;
> +       inode_lock(d_inode(root));
> +       /* look it up */
> +       dentry = lookup_one_len(name, root, strlen(name));
> +       if (IS_ERR(dentry)) {
> +               inode_unlock(d_inode(root));
> +               iput(inode);
> +               return PTR_ERR(dentry);
> +       }
> +
> +       if (d_really_is_positive(dentry)) {
> +               /* already exists */
> +               dput(dentry);
> +               inode_unlock(d_inode(root));
> +               iput(inode);
> +               return -EEXIST;
> +       }
> +
> +       d_instantiate(dentry, inode);
> +       fsnotify_create(d_inode(root), dentry);
> +       inode_unlock(d_inode(root));
> +
> +       inode->i_private = lo;
> +       lo->lo_loopfs_i = inode;
> +       info->device_count++;
> +
> +       return 0;
> +}
[...]
