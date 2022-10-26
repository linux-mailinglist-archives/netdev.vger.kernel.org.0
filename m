Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 070B660EC9E
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 01:31:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233917AbiJZXbS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 19:31:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233826AbiJZXbR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 19:31:17 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C93F6C974
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 16:31:14 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id r18so16548227pgr.12
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 16:31:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=uTiXMEJ/CoY33sLKioTuUer5OYA6lSASj5Z7HOYEvCU=;
        b=TOuwrDc0bbdix70NhE1jKBzdwfVRAzTyQxtqVBPa5MjSN3paOlzKdWiUm3alKS1AER
         GJuCFhCCGyBSB8FRaoN33yIBrnTdeQBOlwE6/cnyaBtoJ0WEs2N7SyR03AxvtmkQSDJF
         6YH8IhvHf3aJ+V+x5xOQjrOfyofdMYu+nJpfM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uTiXMEJ/CoY33sLKioTuUer5OYA6lSASj5Z7HOYEvCU=;
        b=j4DCkeVdcoJBtsfgh1h2T2rOO6Rnh6IpeWdtNsyFUws6Khu+3jG8O+zy8XdBHtwlqC
         QGaaMrRr240tvnm2eQQll1KAu0I3oYiETzL55rD8nOddJUFNX7v23yRm1+GB6I9ckqMo
         KaV75Wl++sXJuzSj0PZq0azNZEX3aa99vzY1yHmm9Y6urohH8ipRuiP2td+GUmSePKCc
         zqoDAKMrn6Ou0y/5p2TNZL77hsYczU913EyO6XiQFkcKs6UpRVegcu0xLiH95/P4EjCE
         P9fNBDmcWShSRigaAlLwFpdEP62GG0FIWiNMInCjpkTEWiSBhleaFW9rBd9HrWgAqdRb
         qk/A==
X-Gm-Message-State: ACrzQf1+hpP6ZYjM9q86KnCJUIRicVdxLi1rSO4jtLPb1ASqauvIIzus
        RIr0vEUuuCaQcGfvMvGNUIErmA==
X-Google-Smtp-Source: AMsMyM6vUS8k1RZW8rkiZJ/NtfbRT4JleOwKZRGiZoKyUq7elbWpv7uakSgQFP+Ri49oMPf/cyWaWw==
X-Received: by 2002:a63:5b5c:0:b0:461:8ba9:457e with SMTP id l28-20020a635b5c000000b004618ba9457emr40053088pgm.218.1666827074080;
        Wed, 26 Oct 2022 16:31:14 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id k15-20020a170902760f00b001785a72d285sm3445937pll.48.2022.10.26.16.31.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Oct 2022 16:31:13 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Kees Cook <keescook@chromium.org>,
        David Howells <dhowells@redhat.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Russ Weight <russell.h.weight@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Steve French <sfrench@samba.org>, Paulo Alcantara <pc@cjr.nz>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Shyam Prasad N <sprasad@microsoft.com>,
        Tom Talpey <tom@talpey.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Jeff Layton <jlayton@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-nfs@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: [PATCH] cred: Do not default to init_cred in prepare_kernel_cred()
Date:   Wed, 26 Oct 2022 16:31:11 -0700
Message-Id: <20221026232943.never.775-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=7754; h=from:subject:message-id; bh=F4siOobAlkuq3vezhEE05wQ9UmMUALp3i2I2789BOdA=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBjWcM+V/jGXvCdTmkC/+MaJu/23cacFAOA4bsmrw+9 tYo1k2iJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCY1nDPgAKCRCJcvTf3G3AJuRND/ 4+bzoCJCTyzFdDCx6K9xror4+DURVGRLcw2WN6OrzqgY0x4JDkjxt8NJVq1Kn7+2xI1YMgKvN60xlN AZ+iiQNDji7xT6i72/meJLeccjXUbc8oESTEUsSfVksoPzG2mWDBndu7ysJ0dEpuiyzJkOxyWWly/V cWlSxN5yj9A3qqBoS9lCmT2CZbjQ8J2NTvo07H4vXHaniOcNFwyDQWTqJO2xBe+H2OgPxOGDCMphc9 f/dvg0aOvj58P8PvVOmSK68yN2I7jC8KY8OUQhU69SNADTpkcqQEX3fZHIBfhgpHsqEAWElvVxw1uz ZQmFfMwSJWUZhKkP4MUeSVzQfA87auPZwC2pKAdiyKt9qTvVhspNQT4v0FdLZJiBKEbkTtSBICRxdo 1e8MRF9EmCimdBuKzmSa8EI5UTtcU+qvW5jtX0LHJIZFf7stmWh5DChTIPlx66Tp0valgWi4lDrtvl HZNz2zVfxkc6OVdGijlHFBRSipuQyQsTqIw8oInMBl6IORzlu8MAbDCpR/ZXKseWMv6W2YpDy9MW2E lRiiCRzUQ5HFnZNp1oARy59W6BAwE1cHQkqgphJdCKsNowlVLvg5MJliUli6YGMPNqjVfXwqMPRLD/ J0fNFuBOkRbsE5nnE9MVDabfkwWWK3RJpoWBiYLyeIZDeokSu8kaOhx7mgsA==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A common exploit pattern for ROP attacks is to abuse prepare_kernel_cred()
in order to construct escalated privileges[1]. Instead of providing a
short-hand argument (NULL) to the "daemon" argument to indicate using
init_cred as the base cred, require that "daemon" is always set to
an actual task. Replace all existing callers that were passing NULL
with &init_task.

Future attacks will need to have sufficiently powerful read/write
primitives to have found an appropriately privileged task and written it
to the ROP stack as an argument to succeed, which is similarly difficult
to the prior effort needed to escalate privileges before struct cred
existed: locate the current cred and overwrite the uid member.

This has the added benefit of meaning that prepare_kernel_cred() can no
longer exceed the privileges of the init task, which may have changed from
the original init_cred (e.g. dropping capabilities from the bounding set).

[1] https://google.com/search?q=commit_creds(prepare_kernel_cred(0))

Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Russ Weight <russell.h.weight@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Steve French <sfrench@samba.org>
Cc: Paulo Alcantara <pc@cjr.nz>
Cc: Ronnie Sahlberg <lsahlber@redhat.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
Cc: Anna Schumaker <anna@kernel.org>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: "Michal Koutný" <mkoutny@suse.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Cc: linux-nfs@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/base/firmware_loader/main.c    |  2 +-
 fs/cifs/cifs_spnego.c                  |  2 +-
 fs/cifs/cifsacl.c                      |  2 +-
 fs/ksmbd/smb_common.c                  |  2 +-
 fs/nfs/flexfilelayout/flexfilelayout.c |  4 ++--
 fs/nfs/nfs4idmap.c                     |  2 +-
 fs/nfsd/nfs4callback.c                 |  2 +-
 kernel/cred.c                          | 15 +++++++--------
 net/dns_resolver/dns_key.c             |  2 +-
 9 files changed, 16 insertions(+), 17 deletions(-)

diff --git a/drivers/base/firmware_loader/main.c b/drivers/base/firmware_loader/main.c
index 7c3590fd97c2..017c4cdb219e 100644
--- a/drivers/base/firmware_loader/main.c
+++ b/drivers/base/firmware_loader/main.c
@@ -821,7 +821,7 @@ _request_firmware(const struct firmware **firmware_p, const char *name,
 	 * called by a driver when serving an unrelated request from userland, we use
 	 * the kernel credentials to read the file.
 	 */
-	kern_cred = prepare_kernel_cred(NULL);
+	kern_cred = prepare_kernel_cred(&init_task);
 	if (!kern_cred) {
 		ret = -ENOMEM;
 		goto out;
diff --git a/fs/cifs/cifs_spnego.c b/fs/cifs/cifs_spnego.c
index 342717bf1dc2..6f3285f1dfee 100644
--- a/fs/cifs/cifs_spnego.c
+++ b/fs/cifs/cifs_spnego.c
@@ -189,7 +189,7 @@ init_cifs_spnego(void)
 	 * spnego upcalls.
 	 */
 
-	cred = prepare_kernel_cred(NULL);
+	cred = prepare_kernel_cred(&init_task);
 	if (!cred)
 		return -ENOMEM;
 
diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
index fa480d62f313..574de2b225ae 100644
--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -465,7 +465,7 @@ init_cifs_idmap(void)
 	 * this is used to prevent malicious redirections from being installed
 	 * with add_key().
 	 */
-	cred = prepare_kernel_cred(NULL);
+	cred = prepare_kernel_cred(&init_task);
 	if (!cred)
 		return -ENOMEM;
 
diff --git a/fs/ksmbd/smb_common.c b/fs/ksmbd/smb_common.c
index d96da872d70a..2a4fbbd55b91 100644
--- a/fs/ksmbd/smb_common.c
+++ b/fs/ksmbd/smb_common.c
@@ -623,7 +623,7 @@ int ksmbd_override_fsids(struct ksmbd_work *work)
 	if (share->force_gid != KSMBD_SHARE_INVALID_GID)
 		gid = share->force_gid;
 
-	cred = prepare_kernel_cred(NULL);
+	cred = prepare_kernel_cred(&init_task);
 	if (!cred)
 		return -ENOMEM;
 
diff --git a/fs/nfs/flexfilelayout/flexfilelayout.c b/fs/nfs/flexfilelayout/flexfilelayout.c
index 1ec79ccf89ad..7deb3cd76abe 100644
--- a/fs/nfs/flexfilelayout/flexfilelayout.c
+++ b/fs/nfs/flexfilelayout/flexfilelayout.c
@@ -493,10 +493,10 @@ ff_layout_alloc_lseg(struct pnfs_layout_hdr *lh,
 		gid = make_kgid(&init_user_ns, id);
 
 		if (gfp_flags & __GFP_FS)
-			kcred = prepare_kernel_cred(NULL);
+			kcred = prepare_kernel_cred(&init_task);
 		else {
 			unsigned int nofs_flags = memalloc_nofs_save();
-			kcred = prepare_kernel_cred(NULL);
+			kcred = prepare_kernel_cred(&init_task);
 			memalloc_nofs_restore(nofs_flags);
 		}
 		rc = -ENOMEM;
diff --git a/fs/nfs/nfs4idmap.c b/fs/nfs/nfs4idmap.c
index e3fdd2f45b01..25a7c771cfd8 100644
--- a/fs/nfs/nfs4idmap.c
+++ b/fs/nfs/nfs4idmap.c
@@ -203,7 +203,7 @@ int nfs_idmap_init(void)
 	printk(KERN_NOTICE "NFS: Registering the %s key type\n",
 		key_type_id_resolver.name);
 
-	cred = prepare_kernel_cred(NULL);
+	cred = prepare_kernel_cred(&init_task);
 	if (!cred)
 		return -ENOMEM;
 
diff --git a/fs/nfsd/nfs4callback.c b/fs/nfsd/nfs4callback.c
index f0e69edf5f0f..4a9e8d17e56a 100644
--- a/fs/nfsd/nfs4callback.c
+++ b/fs/nfsd/nfs4callback.c
@@ -870,7 +870,7 @@ static const struct cred *get_backchannel_cred(struct nfs4_client *clp, struct r
 	} else {
 		struct cred *kcred;
 
-		kcred = prepare_kernel_cred(NULL);
+		kcred = prepare_kernel_cred(&init_task);
 		if (!kcred)
 			return NULL;
 
diff --git a/kernel/cred.c b/kernel/cred.c
index e10c15f51c1f..811ad654abd1 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -701,9 +701,9 @@ void __init cred_init(void)
  * override a task's own credentials so that work can be done on behalf of that
  * task that requires a different subjective context.
  *
- * @daemon is used to provide a base for the security record, but can be NULL.
- * If @daemon is supplied, then the security data will be derived from that;
- * otherwise they'll be set to 0 and no groups, full capabilities and no keys.
+ * @daemon is used to provide a base cred, with the security data derived from
+ * that; if this is "&init_task", they'll be set to 0, no groups, full
+ * capabilities, and no keys.
  *
  * The caller may change these controls afterwards if desired.
  *
@@ -714,17 +714,16 @@ struct cred *prepare_kernel_cred(struct task_struct *daemon)
 	const struct cred *old;
 	struct cred *new;
 
+	if (WARN_ON_ONCE(!daemon))
+		return NULL;
+
 	new = kmem_cache_alloc(cred_jar, GFP_KERNEL);
 	if (!new)
 		return NULL;
 
 	kdebug("prepare_kernel_cred() alloc %p", new);
 
-	if (daemon)
-		old = get_task_cred(daemon);
-	else
-		old = get_cred(&init_cred);
-
+	old = get_task_cred(daemon);
 	validate_creds(old);
 
 	*new = *old;
diff --git a/net/dns_resolver/dns_key.c b/net/dns_resolver/dns_key.c
index 3aced951d5ab..01e54b46ae0b 100644
--- a/net/dns_resolver/dns_key.c
+++ b/net/dns_resolver/dns_key.c
@@ -337,7 +337,7 @@ static int __init init_dns_resolver(void)
 	 * this is used to prevent malicious redirections from being installed
 	 * with add_key().
 	 */
-	cred = prepare_kernel_cred(NULL);
+	cred = prepare_kernel_cred(&init_task);
 	if (!cred)
 		return -ENOMEM;
 
-- 
2.34.1

