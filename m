Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BD8D379014
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 16:07:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233486AbhEJOCz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 10:02:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343852AbhEJOAm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 10:00:42 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB4B6C0611CC;
        Mon, 10 May 2021 06:42:51 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id c13so202873pfv.4;
        Mon, 10 May 2021 06:42:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TQSO27EdiG8kvuLj7qwrLqg41AO2WlMnI3lBxBvcbXo=;
        b=q6PO7burX1NdBZ6LCj+nHgpLkjnqCHH89ZkdkHp33lNNMsel2G7DStUxmRpC5+6ULn
         IQ2mWjR7TJwfvnb754iv8KIDEY4Nh7zezaIYW9F4S0BZuFLGgjE82ppPtbQKgUStgon+
         tAMa4sR3cd/p1SP8erI1Ujsau8Houx7VL/uivOflBRanOU8OgMINrFd9KEsbCULuydNA
         rhDwrTFPre9cA65uH41f+IQLgY4lbcIg471OLSf8UoumCjoNm0PcVrFdvc/S4NvHfGy6
         SwiiulRdpW57J8kdl90nA8ImcRJ3JEz6fxHw+0HLWPALrxoqe2NypKRFfVehY91iJ72e
         iHig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TQSO27EdiG8kvuLj7qwrLqg41AO2WlMnI3lBxBvcbXo=;
        b=KEPR5KWsmsqH/hLJ3lFzjBn3/24LoEriK13swcoiRnXpzu4jIPWWtP3GCl2squ+nHc
         qOHjyokfBOfSu9ks1U7aKkzhTxhZ+FssLWqgKzJCgQYEJy3p+XklQOKAOf/OQTTVeeis
         wG+O7zl9bdOrHi0Kbz+g1BMxbJ2TtcUHpKVsvfUDDgJBNyJ64kb4vHYwvZ3oofveK4Nt
         wytNgA493GqK/q00E1bj9gme0vGng5wLOBd24hheRKGCpSRZsmoGma/zkcy88/nOnSvu
         Wf1yOOsFN33ylhrh6N5e114DYGSSQRRLu9FBX7E1K+7zqoEHj+zRKIeSKOBjwvwo7Xfd
         e1OQ==
X-Gm-Message-State: AOAM531/ebAxxcW09qYaOnBiZRVXErGxiaNS0mWIA/gKMJUIJzw5Zcw7
        q+v9JrC7gj5lXjB4LPxWlss=
X-Google-Smtp-Source: ABdhPJybTcHxXfjJ2tQaJKAVWNrUJTxAfw0ibMoA2eqw0dkNnWeuzC17ymaUnWLJrvgn3xUrohnUDg==
X-Received: by 2002:a62:80d2:0:b029:2b3:fca1:8829 with SMTP id j201-20020a6280d20000b02902b3fca18829mr11479734pfd.2.1620654171226;
        Mon, 10 May 2021 06:42:51 -0700 (PDT)
Received: from localhost.localdomain ([66.115.182.68])
        by smtp.gmail.com with ESMTPSA id h22sm11290537pfn.55.2021.05.10.06.42.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 06:42:50 -0700 (PDT)
From:   youling257 <youling257@gmail.com>
To:     adobriyan@gmail.com
Cc:     akpm@linux-foundation.org, linux-arch@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 2/2] proc: convert everything to "struct proc_ops"
Date:   Mon, 10 May 2021 21:42:38 +0800
Message-Id: <20210510134238.4905-1-youling257@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20191225172546.GB13378@avx2>
References: <20191225172546.GB13378@avx2>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, my xt_qtaguid module need convert to "struct proc_ops",
https://github.com/youling257/android-4.9/commit/a6e3cddcceb96eb3edeb0da0951399b75d4f8731
https://github.com/youling257/android-4.9/commit/9eb92f5bcdcbc5b54d7dfe4b3050c8b9b8a17999

static const struct proc_ops qtudev_proc_ops = {
	.proc_open = qtudev_open,
	.proc_release = qtudev_release,
};

static struct miscdevice qtu_device = {
	.minor = MISC_DYNAMIC_MINOR,
	.name = QTU_DEV_NAME,
	.fops = &qtudev_proc_ops,
	/* How sad it doesn't allow for defaults: .mode = S_IRUGO | S_IWUSR */
};

I have problem about ".fops = &qtudev_fops,", convert to ".fops = &qtudev_proc_ops," is right?

build error, can you help me?
  CALL    /root/1/scripts/atomic/check-atomics.sh
  CALL    /root/1/scripts/checksyscalls.sh
  CHK     include/generated/compile.h
  CC      net/netfilter/xt_qtaguid.o
/root/1/net/netfilter/xt_qtaguid.c:2895:10: error: initialization of ‘const struct file_operations *’ from incompatible pointer type ‘const struct proc_ops *’ [-Werror=incompatible-pointer-types]
 2895 |  .fops = &qtudev_proc_ops,
      |          ^
/root/1/net/netfilter/xt_qtaguid.c:2895:10: note: (near initialization for ‘qtu_device.fops’)
cc1: some warnings being treated as errors
