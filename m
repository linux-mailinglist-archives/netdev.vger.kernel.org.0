Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69E5B109F9F
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 14:54:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728010AbfKZNy2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 08:54:28 -0500
Received: from mail-pf1-f176.google.com ([209.85.210.176]:38937 "EHLO
        mail-pf1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727374AbfKZNy2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 08:54:28 -0500
Received: by mail-pf1-f176.google.com with SMTP id x28so9230037pfo.6;
        Tue, 26 Nov 2019 05:54:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+6y5ljhdOSEpbqDLsf7WOjQHYlWu0KOnTNgfdKfFZjM=;
        b=kU2gHuxUF6SZJBNCach5U8PnIYmJSzZd9R8HVCNwCEBVo7Qcyllx6sRO43guXWfR4D
         v8SmxuQM0xYoK7RgxjB0jkvNGZCXVcagtNpRGh+fKt6rvlz67geafk3RtpmngEWuQzgj
         gWxp1yKDha+ld8KIMa320nZxhw6BcVwOpXlzSiVdPX7LLNHxaIGUmkJomy1ISJFAat82
         Ce/zecMrbpCdN5Nj5gakkI2UzOEs4IOgu5sWKWZgIXwlttnAdpR2M+kdr9ptL+9qQvy9
         qw7+jHqx3DRK/ND/oHjWPe5pKagJ8JKzXIXM+MkTY7TqpRytSJv8IKZ1TjCpymJi3t+9
         f3pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+6y5ljhdOSEpbqDLsf7WOjQHYlWu0KOnTNgfdKfFZjM=;
        b=Hkd/IHgkYHCuU6/PBg0GxgVWab7mDGAUal0xcymuAqsvP8cCLhbc9eJVRRwlEE2cz0
         RhRpGNJkSj3qzhMQu2YjbilSy29jxCGOtFdddtDATYqlRBX4fFdVm692aGClxIkwwbp8
         djEioUaXZggadkbxZqxo1LdS7wNZ5pYJzp9Cytxg6CPHOe9iPqBbGus+fiinEO8ab6P0
         8F/tuSjt8XWAoNHYGYHR1rFyI+UTYx1hfpCMwowRa4Ejjr8JBieuNiqysL/8mxlw6uVD
         g3Vo6nUj34aDOTikZTPQZ9uq/5XE7p4lf4n/v0h56e4A5tmoeFFSfOEBHpXRltcwo2aT
         UQ5A==
X-Gm-Message-State: APjAAAX8xr9cxz62dtn/NaTZDuj9mTQO5O2cez9l0AofDDOVsONkEZkG
        UZ1RCoZVz8WVUpbF26OMXPY=
X-Google-Smtp-Source: APXvYqw34TPsTUE7JT5v2meXhZ9ChV9KIXsII3gjoonQhOCrfLFeqihISKTXSc0AiL/PHJ25/TflFA==
X-Received: by 2002:aa7:9d9c:: with SMTP id f28mr21912265pfq.20.1574776467580;
        Tue, 26 Nov 2019 05:54:27 -0800 (PST)
Received: from debian.net.fpt ([2405:4800:58f7:2f79:ce3b:4b9:a68f:959f])
        by smtp.gmail.com with ESMTPSA id v3sm13018499pfi.26.2019.11.26.05.54.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 05:54:26 -0800 (PST)
From:   Phong Tran <tranmanphong@gmail.com>
To:     davem@davemloft.net
Cc:     alexios.zavras@intel.com, allison@lohutok.net, benquike@gmail.com,
        gregkh@linuxfoundation.org, johan@kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, oneukum@suse.com, tglx@linutronix.de,
        tranmanphong@gmail.com
Subject: [Patch v2 0/2] Fix -Wcast-function-type usb net drivers
Date:   Tue, 26 Nov 2019 20:54:11 +0700
Message-Id: <20191126135413.19929-1-tranmanphong@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191125.110708.76766634808358006.davem@davemloft.net>
References: <20191125.110708.76766634808358006.davem@davemloft.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change log with v1:
 - Modify suffix of patch subject.
 - Did the checkpatch.pl (remove the space, add a blank line).

Phong Tran (2):
  net: hso: Fix -Wcast-function-type
  net: usbnet: Fix -Wcast-function-type

 drivers/net/usb/hso.c    | 5 +++--
 drivers/net/usb/usbnet.c | 9 ++++++++-
 2 files changed, 11 insertions(+), 3 deletions(-)

-- 
2.20.1

