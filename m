Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2451952F060
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 18:17:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347161AbiETQRC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 12:17:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351493AbiETQQ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 12:16:58 -0400
Received: from mail-qv1-xf2f.google.com (mail-qv1-xf2f.google.com [IPv6:2607:f8b0:4864:20::f2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA12B62CE5;
        Fri, 20 May 2022 09:16:56 -0700 (PDT)
Received: by mail-qv1-xf2f.google.com with SMTP id eq14so7003543qvb.4;
        Fri, 20 May 2022 09:16:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=U7HeFxj4WnYH3AjHDHXKG6yFASLPkhr9f5axG85lyYc=;
        b=d5+jm62R2PlQfp1toFKLNdt75Xyq3pHXO3jJmkmOhYyji4H0+cOGa3FeB/wVcxMaea
         +dvyRu2/BLdqYMUhLQ6YYy3P31TF7vKfXfA1ozItBPNwYZ7bvpWT81NNdfFNYCjP2sKq
         hGUemzB5ZVJMhvwB2M/k7NcVnBWMBlF57IkTkSn4Qb+6OIz+40w/HqOS+GV851ME3/Jo
         RJyHecRXdM35cL9kpfRZhxmfbNAtyt2D6YyCxSfOTWtlLylM/OiWy1Pd1zl6/RQiy1bK
         UySJCE3iAGq2I42GMa2cAhc07fqeYze20g69cP53DVRAph0Of+8CulCEbxLb4SPQDoTF
         q2rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=U7HeFxj4WnYH3AjHDHXKG6yFASLPkhr9f5axG85lyYc=;
        b=GHNgkg8LQ6i5BeuFCC56LQnmsBBKaBrTq0abrI7qNM8T+x5aRtHPw+p98S9tvBTC4b
         Jvi7EHkRVKy64YSvKC8+yWAClGzxyNyJ42KDlW1fDuBRIC6UePrSZsanLk/iacpdeQgP
         BmVWSvBKpuhawXrXKsL1teCrGVl6FgFQACGJIRJ71hebOp5RQ45U1FRoOek9msWVwcho
         cIW8NpqeKixh8iuWUPSQZUJzuYSmtQePv2fJ5e59NrqzUHc3qtQU3O0YqBJ7pDVrwQyp
         IelVqkr/wR0VMjfm4AeADVj2amlHqPVgGrldn7yVJryQjcE+8lkegOirwQtKEl2Xq0tD
         WUwA==
X-Gm-Message-State: AOAM530MnSgU3+JvNKc0ed6U05DXSXdAIdj9KxOM4+kDYXKVIzugHCSk
        GwHXR1/sLdiFAtQwDMMog8qc4Xk2ilXh
X-Google-Smtp-Source: ABdhPJxP7DgnQ+TjLydG6xJ4s/QJd9oLUT2vWP/vUmTHGbYBOhaJLYg8/6wWW/t5ObKJ8sU4KsRogg==
X-Received: by 2002:a05:6214:d8d:b0:461:dc09:d4a6 with SMTP id e13-20020a0562140d8d00b00461dc09d4a6mr8770481qve.119.1653063415324;
        Fri, 20 May 2022 09:16:55 -0700 (PDT)
Received: from moria.home.lan (c-73-219-103-14.hsd1.vt.comcast.net. [73.219.103.14])
        by smtp.gmail.com with ESMTPSA id y1-20020a379601000000b006a323e60e29sm3138084qkd.135.2022.05.20.09.16.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 May 2022 09:16:54 -0700 (PDT)
Date:   Fri, 20 May 2022 12:16:52 -0400
From:   Kent Overstreet <kent.overstreet@gmail.com>
To:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org, netdev@vger.kernel.org
Cc:     mcgrof@kernel.org, tytso@mit.edu
Subject: RFC: Ioctl v2
Message-ID: <20220520161652.rmhqlvwvfrvskg4w@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

At LSF we had our annual talk about all the ways ioctls suck. It got me thinking
about a proposal for a simple lightweight replacement.

Problems with ioctls:

* There's no namespacing, and ioctl numbers clash

Ioctl numbers clashing isn't a _huge_ issue in practice because you'll only have
so many chunks of code handling ioctls for the same FD (VFS, filesystem or
driver) and because ioctl struct size is also dispatched on, but it is pretty
gross - there's nothing preventing different drivers from picking the same ioctl
numbers. And since we've got one byte for the "namespace" and another byte for
the ioctl number, and according to my grep 7k different ioctls, betcha this
happens somewhere - I think Luis had an example at LSF.

Where the lack of real namespacing bites us more is when ioctls get promoted
from filesystem or driver on up. Ted had a good example of an ext2 ioctl getting
promoted to the VFS when it really shouldn't have, because it was exposing ext2
specific data structures.

But because this is as simple as changing a #define EXT2_IOC to #define FS_IOC,
it's really easy to do without adequate review - you don't have to change the
ioctl number and break userspace, so why would you?

Introducing real namespacing would mean that promoting an ioctl to the VFS level
would really have to be a new ioctl, and it'll get people to think more about
what the new ioctl would be.

* The calling convention sucks

With ioctls, you have to define a struct for your parameters, and struct members
might be used for inputs, or outputs, or both.

The problem is, these structs really need to be fully portable the same way
structs defined for on disk formats have to be, and we've got no way of checking
for this. This is a real minefield: if you need to pass a pointer type, you
can't pass a pointer because sizeof(void *) is different (and kernel space might
be 64 bit, with userspace 32 bit or 64 bit) - and you can't pass a ulong either,
it has to be a u64.

The whole "define a struct for your parameters" was a hack and a bad idea.
Ioctls are just function calls - they're driver-private syscalls - and they
should work like function calls.

IOCTL v2 proposal:

* Namespacing

To solve the namespacing issue, I want to steal an approach I've seen from
OpenGL, where extensions are namespaced: an extension will be referenced by name
where the name is vendor.foo, and when an extension becomes standard it gets a
new name (arb.foo instead of nvidia.foo, I think? it's been awhile).

To do this we'll need to define ioctls by name, not by hardcoded number, and
likewise userspace will have to call ioctls by name, not by number. To avoid a
string lookup on every ioctl call, I propose a new syscall

int sys_get_ioctl_nr(char *name)

And then userspace will just call this once for every ioctl it uses, either at
program startup or lazily when an ioctl is first called. This can all be nicely
hidden in a little wrapper library.

We'll want to randomize ioctl numbers in kernel space, to ensure userspace
_can't_ hard code them.

Also, another thing that came up at LSF was introspection, it's hard for
strace() et al to handle ioctls. Implementing this name -> nr mapping will give
us a registry of ioctls supported on a given kernel which we can make available
in /proc; and while we're at it, why not include the prototype too?

* Better calling convention

ioctls are just private syscalls. Syscalls look like normal function calls, why
can't ioctls?  Some ioctls do complicated things that require defining structs
with all the tricky layout rules that we kernel devs have all had beaten into
our brains - but most probably would not, if we could do normal-looking function
calls.

Well, syscalls do require arch specific code to handle calling conventions, and
we don't want that. What I propose doing is having the underlying syscall be

#define IOCTL_MAXARGS	8

struct ioctl_args {
	__u64	args[IOCTL_MAXARGS];
};

int sys_ioctl_v2(int fd, int ioctl_nr, struct ioctl_args __user *args)

Userspace won't call this directly. Userspace will call normal looking
functions, like:

int bcachefs_ioctl_disk_add(int fd, unsigned flags, char __user *disk_path);

Which will be a wrapper that casts the function arguments to u64s (or s64s for
signed integers, so that we don't have surprises when kernel space and user
space disagree about sizeof(long)) and then does the actual syscall.

------------------

I want to circulate this and get some comments and feedback, and if no one
raises any serious objections - I'd love to get collaborators to work on this
with me. Flame away!
