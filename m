Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07DD521A6EB
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 20:27:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727796AbgGIS1d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 14:27:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726265AbgGIS0x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 14:26:53 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A86CAC08C5DC
        for <netdev@vger.kernel.org>; Thu,  9 Jul 2020 11:26:53 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id z3so1352087pfn.12
        for <netdev@vger.kernel.org>; Thu, 09 Jul 2020 11:26:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JrMTIMXp8JCVs/UG6kwzV643qisCcMSwknnEo4LkN2s=;
        b=L8wvdwHte5JVfRo/XP6SiecvNSKuxO96e3Iw4DgEORXlBX29wHcKcTekzMu5ehRLxC
         PIZpkxQVThGY9I3o0Km+Zf3dqPVcYYFtmIF38pEP/OnDYBtw9U/C/nd8IeDdy4CeBbvR
         knaPAcSaS1ZiArDzFLG+JuglPL174w7ZWohI8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JrMTIMXp8JCVs/UG6kwzV643qisCcMSwknnEo4LkN2s=;
        b=epuoHBrn7Uhu+Uq7l+qVsDH9cKv95L2PZMfRqEFTXJGop10nhYHiqJDefX5SXvhTjM
         nZZS1sF1oTJjK1o6gX1UJ8hu+z3ftbhSFwhuZXIMOGJcguIlZRiU4taxjUZqsfpanDEh
         Oss2oZNCTg7/OC0HAbzNbuPP6NR0hTAfLpMnU/Om5cmTzVFbRDIRKAHGl/moP1NNWN8y
         PiK4ovB4d8ZnLClJ0b4hLtoqze7vUcPCp0HYiV+RXzGep/VcM48yk8sWVfZ93aZlbx92
         mL0+E6bjr0efWzZJr+O7DQYhWsvun97EmEuWFjOzookpQONQaDoTLYHndYH5rWBkcovB
         soMA==
X-Gm-Message-State: AOAM531LIvjgaveFblKHINXEYHLFzpK0epsq+E71V0dzFMy5QMnhPJPJ
        rGHglQvvpLbMFCAcKXpI/YbXSg==
X-Google-Smtp-Source: ABdhPJx65UJ0x1t95RO9v7FuFc02woWGGDxWRTXPyPbUQ6AMj/WGTj8FXr741XZhs+0+z7kyxYCdSA==
X-Received: by 2002:a63:1f11:: with SMTP id f17mr53506078pgf.217.1594319213298;
        Thu, 09 Jul 2020 11:26:53 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id l191sm3238744pfd.149.2020.07.09.11.26.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2020 11:26:51 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     linux-kernel@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        Sargun Dhillon <sargun@sargun.me>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Christian Brauner <christian@brauner.io>,
        Tycho Andersen <tycho@tycho.ws>,
        David Laight <David.Laight@ACULAB.COM>,
        Christoph Hellwig <hch@lst.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Aleksa Sarai <cyphar@cyphar.com>,
        Matt Denton <mpdenton@google.com>,
        Jann Horn <jannh@google.com>, Chris Palmer <palmer@google.com>,
        Robert Sesek <rsesek@google.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Will Drewry <wad@chromium.org>, Shuah Khan <shuah@kernel.org>,
        netdev@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH v7 6/9] pidfd: Replace open-coded receive_fd()
Date:   Thu,  9 Jul 2020 11:26:39 -0700
Message-Id: <20200709182642.1773477-7-keescook@chromium.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200709182642.1773477-1-keescook@chromium.org>
References: <20200709182642.1773477-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace the open-coded version of receive_fd() with a call to the
new helper.

Thanks to Vamshi K Sthambamkadi <vamshi.k.sthambamkadi@gmail.com> for
catching a missed fput() in an earlier version of this patch.

Reviewed-by: Sargun Dhillon <sargun@sargun.me>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 kernel/pid.c | 15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

diff --git a/kernel/pid.c b/kernel/pid.c
index 85ed00abdc7c..da5aea5f04fa 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -636,19 +636,8 @@ static int pidfd_getfd(struct pid *pid, int fd)
 	if (IS_ERR(file))
 		return PTR_ERR(file);
 
-	ret = security_file_receive(file);
-	if (ret) {
-		fput(file);
-		return ret;
-	}
-
-	ret = get_unused_fd_flags(O_CLOEXEC);
-	if (ret < 0) {
-		fput(file);
-	} else {
-		fd_install(ret, file);
-		__receive_sock(file);
-	}
+	ret = receive_fd(file, O_CLOEXEC);
+	fput(file);
 
 	return ret;
 }
-- 
2.25.1

