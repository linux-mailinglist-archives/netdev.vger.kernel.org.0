Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00D2B4BA3A5
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 15:52:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242181AbiBQOu4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 09:50:56 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242126AbiBQOut (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 09:50:49 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 192CB29E957;
        Thu, 17 Feb 2022 06:50:34 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id u18so10074738edt.6;
        Thu, 17 Feb 2022 06:50:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8I41jwLvAiCSwd4V/781omnso87v01pI1AY+lB5wImk=;
        b=Iupq1Tbr6TrNZdw13BJ6EY0qW3jW8QcWqrMnVX0DfbwV9HN8X6F1VFaQ/Vt4JiwKuI
         PKHeDAsE5jQo2oYFRH3qKrMg7Y7K10m0OisK4CQxgccvztoWVvEOVDbmSPyb1raXFLY6
         o5nxC5aZSnG5edIofcjlhWKe4xkKLff54dudYJjGhfUtiRMhvaGqVm1r7MGHEDAXKahY
         1G7DcLlAh6UPp9o/BEWcfQFzwTlY37PC9K7Ys9nIHgd5QmoP2TMvEHAReyoA4+aHzG4q
         Y5jTggvJqH2wT2nDtKj7XpD5BO7aSbyi7sWvheo/WNRORQls+Wg9QAN+r091a++WqKJr
         GsTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8I41jwLvAiCSwd4V/781omnso87v01pI1AY+lB5wImk=;
        b=ErvFcyuwCsaPWx3bnJD7oYy3GjZztkdKVGXba/4EFvyj3cVqGax/FTJ4UoorsFQrsQ
         jLBTOcqnDDs2wfsUxoH7yKOHV/MZkoa8iduo/OLH1MmXtmbTxFOdzXUwC2DDLMW+5H71
         0GwUvGy0NtWhVhQd5/xzVGXwy7uwO9D98WCTEGVMYMk1FAdrGFZ2ZNdsENK2ZOmnv22E
         1twA4uPtXa+QtchCxVLAlyAYF7EJtGqKBQdpfkG1RdmFoP1uaONP0zt2/pLzAFUOh15u
         7AQtsMCT9ONv5Db2zq11PUG/0v1mAZf1cZpn7/8iney9aXwYxwuokcQugTu1uThGTQw+
         WMAA==
X-Gm-Message-State: AOAM5311NsIe0WE6YovXlMRa7Wv17gEvvscPAg6iNqv78H8F/1KY8tyU
        ULJauEKV57mxfgEUEIuGRRNeI7JvJ6QPHg==
X-Google-Smtp-Source: ABdhPJxHWUoGbeHOtiGY24KhCoWJUu2GzbvuQ9rdb+BqJdqLvOi+M7qBX+pMk1LL7YH8WekmXc7HTw==
X-Received: by 2002:a05:6402:168e:b0:410:d2a4:b0dd with SMTP id a14-20020a056402168e00b00410d2a4b0ddmr2908446edv.403.1645109432560;
        Thu, 17 Feb 2022 06:50:32 -0800 (PST)
Received: from debianHome.localdomain (dynamic-077-001-066-240.77.1.pool.telefonica.de. [77.1.66.240])
        by smtp.gmail.com with ESMTPSA id c11sm3580270edx.42.2022.02.17.06.50.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Feb 2022 06:50:32 -0800 (PST)
From:   =?UTF-8?q?Christian=20G=C3=B6ttsche?= <cgzones@googlemail.com>
To:     selinux@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Stefan Haberland <sth@linux.ibm.com>,
        Jan Hoeppner <hoeppner@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Serge Hallyn <serge@hallyn.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Julia Lawall <Julia.Lawall@inria.fr>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Pavel Skripkin <paskripkin@gmail.com>,
        Du Cheng <ducheng2@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Alexey Gladkov <legion@kernel.org>,
        David Hildenbrand <david@redhat.com>,
        Rolf Eike Beer <eb@emlix.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>,
        Peter Collingbourne <pcc@google.com>,
        Colin Cross <ccross@google.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Xiaofeng Cao <cxfcosmos@gmail.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ziyang Xuan <william.xuanziyang@huawei.com>,
        Alexander Aring <aahringo@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Alistair Delva <adelva@google.com>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org, bpf@vger.kernel.org
Subject: [RFC PATCH 2/2] capability: use new capable_or functionality
Date:   Thu, 17 Feb 2022 15:49:54 +0100
Message-Id: <20220217145003.78982-1-cgzones@googlemail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the new added capable_or macro in appropriate cases, where a task
is required to have any of two capabilities.

Reorder CAP_SYS_ADMIN last.

TODO: split into subsystem patches.

Fixes: 94c4b4fd25e6 ("block: Check ADMIN before NICE for IOPRIO_CLASS_RT")

Signed-off-by: Christian Göttsche <cgzones@googlemail.com>
---
 block/ioprio.c                                   | 9 +--------
 drivers/media/common/saa7146/saa7146_video.c     | 2 +-
 drivers/media/pci/bt8xx/bttv-driver.c            | 3 +--
 drivers/media/pci/saa7134/saa7134-video.c        | 3 +--
 drivers/media/platform/fsl-viu.c                 | 2 +-
 drivers/media/test-drivers/vivid/vivid-vid-cap.c | 2 +-
 drivers/net/caif/caif_serial.c                   | 2 +-
 drivers/s390/block/dasd_eckd.c                   | 2 +-
 fs/pipe.c                                        | 2 +-
 include/linux/capability.h                       | 4 ++--
 kernel/bpf/syscall.c                             | 2 +-
 kernel/fork.c                                    | 2 +-
 kernel/sys.c                                     | 2 +-
 net/caif/caif_socket.c                           | 2 +-
 net/unix/scm.c                                   | 2 +-
 15 files changed, 16 insertions(+), 25 deletions(-)

diff --git a/block/ioprio.c b/block/ioprio.c
index 2fe068fcaad5..52d5da286323 100644
--- a/block/ioprio.c
+++ b/block/ioprio.c
@@ -37,14 +37,7 @@ int ioprio_check_cap(int ioprio)
 
 	switch (class) {
 		case IOPRIO_CLASS_RT:
-			/*
-			 * Originally this only checked for CAP_SYS_ADMIN,
-			 * which was implicitly allowed for pid 0 by security
-			 * modules such as SELinux. Make sure we check
-			 * CAP_SYS_ADMIN first to avoid a denial/avc for
-			 * possibly missing CAP_SYS_NICE permission.
-			 */
-			if (!capable(CAP_SYS_ADMIN) && !capable(CAP_SYS_NICE))
+			if (!capable_or(CAP_SYS_NICE, CAP_SYS_ADMIN))
 				return -EPERM;
 			fallthrough;
 			/* rt has prio field too */
diff --git a/drivers/media/common/saa7146/saa7146_video.c b/drivers/media/common/saa7146/saa7146_video.c
index 66215d9106a4..5eabc2e77cc2 100644
--- a/drivers/media/common/saa7146/saa7146_video.c
+++ b/drivers/media/common/saa7146/saa7146_video.c
@@ -470,7 +470,7 @@ static int vidioc_s_fbuf(struct file *file, void *fh, const struct v4l2_framebuf
 
 	DEB_EE("VIDIOC_S_FBUF\n");
 
-	if (!capable(CAP_SYS_ADMIN) && !capable(CAP_SYS_RAWIO))
+	if (!capable_or(CAP_SYS_RAWIO, CAP_SYS_ADMIN))
 		return -EPERM;
 
 	/* check args */
diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
index 8cc9bec43688..c2437ff07246 100644
--- a/drivers/media/pci/bt8xx/bttv-driver.c
+++ b/drivers/media/pci/bt8xx/bttv-driver.c
@@ -2569,8 +2569,7 @@ static int bttv_s_fbuf(struct file *file, void *f,
 	const struct bttv_format *fmt;
 	int retval;
 
-	if (!capable(CAP_SYS_ADMIN) &&
-		!capable(CAP_SYS_RAWIO))
+	if (!capable_or(CAP_SYS_RAWIO, CAP_SYS_ADMIN))
 		return -EPERM;
 
 	/* check args */
diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index 374c8e1087de..356b77c16f87 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -1803,8 +1803,7 @@ static int saa7134_s_fbuf(struct file *file, void *f,
 	struct saa7134_dev *dev = video_drvdata(file);
 	struct saa7134_format *fmt;
 
-	if (!capable(CAP_SYS_ADMIN) &&
-	   !capable(CAP_SYS_RAWIO))
+	if (!capable_or(CAP_SYS_RAWIO, CAP_SYS_ADMIN))
 		return -EPERM;
 
 	/* check args */
diff --git a/drivers/media/platform/fsl-viu.c b/drivers/media/platform/fsl-viu.c
index a4bfa70b49b2..925c34c2b1b3 100644
--- a/drivers/media/platform/fsl-viu.c
+++ b/drivers/media/platform/fsl-viu.c
@@ -803,7 +803,7 @@ static int vidioc_s_fbuf(struct file *file, void *priv, const struct v4l2_frameb
 	const struct v4l2_framebuffer *fb = arg;
 	struct viu_fmt *fmt;
 
-	if (!capable(CAP_SYS_ADMIN) && !capable(CAP_SYS_RAWIO))
+	if (!capable_or(CAP_SYS_RAWIO, CAP_SYS_ADMIN))
 		return -EPERM;
 
 	/* check args */
diff --git a/drivers/media/test-drivers/vivid/vivid-vid-cap.c b/drivers/media/test-drivers/vivid/vivid-vid-cap.c
index b9caa4b26209..a0cfcf6c22c4 100644
--- a/drivers/media/test-drivers/vivid/vivid-vid-cap.c
+++ b/drivers/media/test-drivers/vivid/vivid-vid-cap.c
@@ -1253,7 +1253,7 @@ int vivid_vid_cap_s_fbuf(struct file *file, void *fh,
 	if (dev->multiplanar)
 		return -ENOTTY;
 
-	if (!capable(CAP_SYS_ADMIN) && !capable(CAP_SYS_RAWIO))
+	if (!capable_or(CAP_SYS_RAWIO, CAP_SYS_ADMIN))
 		return -EPERM;
 
 	if (dev->overlay_cap_owner)
diff --git a/drivers/net/caif/caif_serial.c b/drivers/net/caif/caif_serial.c
index 2a7af611d43a..245c30c469c2 100644
--- a/drivers/net/caif/caif_serial.c
+++ b/drivers/net/caif/caif_serial.c
@@ -326,7 +326,7 @@ static int ldisc_open(struct tty_struct *tty)
 	/* No write no play */
 	if (tty->ops->write == NULL)
 		return -EOPNOTSUPP;
-	if (!capable(CAP_SYS_ADMIN) && !capable(CAP_SYS_TTY_CONFIG))
+	if (!capable_or(CAP_SYS_TTY_CONFIG, CAP_SYS_ADMIN))
 		return -EPERM;
 
 	/* release devices to avoid name collision */
diff --git a/drivers/s390/block/dasd_eckd.c b/drivers/s390/block/dasd_eckd.c
index 8410a25a65c1..9b5d22dd3e7b 100644
--- a/drivers/s390/block/dasd_eckd.c
+++ b/drivers/s390/block/dasd_eckd.c
@@ -5319,7 +5319,7 @@ static int dasd_symm_io(struct dasd_device *device, void __user *argp)
 	char psf0, psf1;
 	int rc;
 
-	if (!capable(CAP_SYS_ADMIN) && !capable(CAP_SYS_RAWIO))
+	if (!capable_or(CAP_SYS_RAWIO, CAP_SYS_ADMIN))
 		return -EACCES;
 	psf0 = psf1 = 0;
 
diff --git a/fs/pipe.c b/fs/pipe.c
index cc28623a67b6..47dc9b59b7a5 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -775,7 +775,7 @@ bool too_many_pipe_buffers_hard(unsigned long user_bufs)
 
 bool pipe_is_unprivileged_user(void)
 {
-	return !capable(CAP_SYS_RESOURCE) && !capable(CAP_SYS_ADMIN);
+	return !capable_or(CAP_SYS_RESOURCE, CAP_SYS_ADMIN);
 }
 
 struct pipe_inode_info *alloc_pipe_info(void)
diff --git a/include/linux/capability.h b/include/linux/capability.h
index 5c55687a9a05..5ed55b73cb62 100644
--- a/include/linux/capability.h
+++ b/include/linux/capability.h
@@ -262,12 +262,12 @@ extern bool file_ns_capable(const struct file *file, struct user_namespace *ns,
 extern bool ptracer_capable(struct task_struct *tsk, struct user_namespace *ns);
 static inline bool perfmon_capable(void)
 {
-	return capable(CAP_PERFMON) || capable(CAP_SYS_ADMIN);
+	return capable_or(CAP_PERFMON, CAP_SYS_ADMIN);
 }
 
 static inline bool bpf_capable(void)
 {
-	return capable(CAP_BPF) || capable(CAP_SYS_ADMIN);
+	return capable_or(CAP_BPF, CAP_SYS_ADMIN);
 }
 
 static inline bool checkpoint_restore_ns_capable(struct user_namespace *ns)
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index fa4505f9b611..108dd09f978a 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2243,7 +2243,7 @@ static int bpf_prog_load(union bpf_attr *attr, bpfptr_t uattr)
 	    !bpf_capable())
 		return -EPERM;
 
-	if (is_net_admin_prog_type(type) && !capable(CAP_NET_ADMIN) && !capable(CAP_SYS_ADMIN))
+	if (is_net_admin_prog_type(type) && !capable_or(CAP_NET_ADMIN, CAP_SYS_ADMIN))
 		return -EPERM;
 	if (is_perfmon_prog_type(type) && !perfmon_capable())
 		return -EPERM;
diff --git a/kernel/fork.c b/kernel/fork.c
index d75a528f7b21..067702f2eb15 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2024,7 +2024,7 @@ static __latent_entropy struct task_struct *copy_process(
 	retval = -EAGAIN;
 	if (is_ucounts_overlimit(task_ucounts(p), UCOUNT_RLIMIT_NPROC, rlimit(RLIMIT_NPROC))) {
 		if (p->real_cred->user != INIT_USER &&
-		    !capable(CAP_SYS_RESOURCE) && !capable(CAP_SYS_ADMIN))
+		    !capable_or(CAP_SYS_RESOURCE, CAP_SYS_ADMIN))
 			goto bad_fork_free;
 	}
 	current->flags &= ~PF_NPROC_EXCEEDED;
diff --git a/kernel/sys.c b/kernel/sys.c
index ecc4cf019242..9df6c5e77620 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -481,7 +481,7 @@ static int set_user(struct cred *new)
 	 */
 	if (is_ucounts_overlimit(new->ucounts, UCOUNT_RLIMIT_NPROC, rlimit(RLIMIT_NPROC)) &&
 			new_user != INIT_USER &&
-			!capable(CAP_SYS_RESOURCE) && !capable(CAP_SYS_ADMIN))
+			!capable_or(CAP_SYS_RESOURCE, CAP_SYS_ADMIN))
 		current->flags |= PF_NPROC_EXCEEDED;
 	else
 		current->flags &= ~PF_NPROC_EXCEEDED;
diff --git a/net/caif/caif_socket.c b/net/caif/caif_socket.c
index 2b8892d502f7..60498148126c 100644
--- a/net/caif/caif_socket.c
+++ b/net/caif/caif_socket.c
@@ -1036,7 +1036,7 @@ static int caif_create(struct net *net, struct socket *sock, int protocol,
 		.usersize = sizeof_field(struct caifsock, conn_req.param)
 	};
 
-	if (!capable(CAP_SYS_ADMIN) && !capable(CAP_NET_ADMIN))
+	if (!capable_or(CAP_NET_ADMIN, CAP_SYS_ADMIN))
 		return -EPERM;
 	/*
 	 * The sock->type specifies the socket type to use.
diff --git a/net/unix/scm.c b/net/unix/scm.c
index aa27a02478dc..821be80e6c85 100644
--- a/net/unix/scm.c
+++ b/net/unix/scm.c
@@ -99,7 +99,7 @@ static inline bool too_many_unix_fds(struct task_struct *p)
 	struct user_struct *user = current_user();
 
 	if (unlikely(user->unix_inflight > task_rlimit(p, RLIMIT_NOFILE)))
-		return !capable(CAP_SYS_RESOURCE) && !capable(CAP_SYS_ADMIN);
+		return !capable_or(CAP_SYS_RESOURCE, CAP_SYS_ADMIN);
 	return false;
 }
 
-- 
2.35.1

