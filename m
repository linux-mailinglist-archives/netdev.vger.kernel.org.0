Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56C253716BE
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 16:39:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbhECOkA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 May 2021 10:40:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229835AbhECOjx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 May 2021 10:39:53 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CA74C06174A
        for <netdev@vger.kernel.org>; Mon,  3 May 2021 07:38:59 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id fa21-20020a17090af0d5b0290157eb6b590fso2122398pjb.5
        for <netdev@vger.kernel.org>; Mon, 03 May 2021 07:38:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=vjb5OlJU5KO9wV7Kf98GvS3+OXOkFCW5y7GCkAscuH8=;
        b=DFb0hQLU+jysXjCeONQGeNykhyukdf4l6N00RX+2GhhMLhs+PF6J8Slo7qoi4XpffP
         DMkVtIgpgY1o9KuadUTmVuQuC2ihusI3YHT1OFQDBD1+hmxSHM/vdgPrBHTqY99wPltU
         mxZlV5lb9jNIAnftOx1X86Ca+mEN2ZP5sqCEABKitYlepMr1sUngthjWzv25HbAeHcgb
         aM8HE0Ku6/IqnPJ7he6b+tb0tgxEfTMuJEQcUd+aVnUwQT6c4Orr6h6535Swg+JBqQvg
         dfd3GmpBF5mwn7aSoOuZqirzS3rYytpVfct+JxHoa7RW9CwH6VBNDD/XoYfyHoUmpPKe
         8RMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=vjb5OlJU5KO9wV7Kf98GvS3+OXOkFCW5y7GCkAscuH8=;
        b=ByQbv1uZT/X0cijPh//Ld8m0WIQRl3swll3QXxXZfmCAq47JfcIW2cZyKbuO/5I1FP
         dB5M1WWQPkQt+c3VY6WfVB7a3P43EL+7rKV6SI1Ii8x+s3gvX8DIqXNeEs7782GVF1l0
         WInAyPJ4DPvywzpyoGWxOGLxELbyn7ckpTxn1DZf5ZG2f4gwlN8i1cwOvBKKSwo4zZdr
         gwEMx2NGN+o1GH0O1J7sk9ok1ZvpfY4XKOez3P/T9sfjbGJyP3+QT0lNT6PSff4JxROe
         vSBjdQDDcFxoaYib8PRnYTBbEB9VrJfYmhx4fmgs+Kwr7KWRdaMpFhbX8Q/EvBTAii0m
         DrlA==
X-Gm-Message-State: AOAM5325l79ZowjO/UmDLm5J91thsFLy/wYl56xVtTxCruMtCnOClxhY
        Fy1TPC14jr62r8kKHMEyoY5HHshH5s+FuA==
X-Google-Smtp-Source: ABdhPJxz+4VbE2PyHjNBQ3OPFxL3hIGbipn4qeQ2FCAKXuxKy2CtRPcQ9+w170P7bGTl+XmBLbDybg==
X-Received: by 2002:a17:902:a60f:b029:ee:cc8c:f891 with SMTP id u15-20020a170902a60fb02900eecc8cf891mr8259308plq.39.1620052738268;
        Mon, 03 May 2021 07:38:58 -0700 (PDT)
Received: from hermes.local (76-14-218-44.or.wavecable.com. [76.14.218.44])
        by smtp.gmail.com with ESMTPSA id n25sm9176616pff.154.2021.05.03.07.38.57
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 May 2021 07:38:57 -0700 (PDT)
Date:   Mon, 3 May 2021 07:38:49 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: Fw: [Bug 212921] New: ECMP not working for local sockets
Message-ID: <20210503073849.27f9b4c0@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Begin forwarded message:

Date: Sun, 02 May 2021 07:10:44 +0000
From: bugzilla-daemon@bugzilla.kernel.org
To: stephen@networkplumber.org
Subject: [Bug 212921] New: ECMP not working for local sockets


https://bugzilla.kernel.org/show_bug.cgi?id=212921

            Bug ID: 212921
           Summary: ECMP not working for local sockets
           Product: Networking
           Version: 2.5
    Kernel Version: 5.8.0-50-generic
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: IPV4
          Assignee: stephen@networkplumber.org
          Reporter: nitin.i.joy@gmail.com
        Regression: No

When you're creating local TCP sockets in a Linux machine, the connections to
the same destination IP are not load-balanced across multiple interfaces when
ECMP path is set. Even when net.ipv4.fib_multipath_hash_policy is set to L4
hash, multiple interfaces are never used for same destination. 

I tried working around the issue by setting two route table entries with same
metric using `ip route append` command. In this case, the connections get
load-balanced across multiple interfaces for 5-10 seconds, after which all
future connections will choose one of the interfaces. There is no configuration
that can disable this behavior. I tried disabling tcp_metrics_nosave

-- 
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.
