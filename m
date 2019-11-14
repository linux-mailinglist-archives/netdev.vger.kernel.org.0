Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEADDFD0A3
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 22:56:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727054AbfKNV4S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 16:56:18 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:34254 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726613AbfKNV4R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 16:56:17 -0500
Received: by mail-pg1-f193.google.com with SMTP id z188so4655389pgb.1
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 13:56:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=sGLset5Dnp8Ldm8ljmG59AeNAD0Jpi+RPkbtstLQToo=;
        b=qG2fgkAXhV91v3ExlWg7uppTTF2/e2gvx2fo5osYPEf+EqFCTbHVvZvJoCaC7kf4YT
         fZstmFWxEaCZ/kUkVxCUSBrIc+7a5uPQl6bVF14cjSKv7DibaZOZtP9ehvvw93FgIQZf
         IXbSRISRS83cZHrv5YLFXCkzIe9L02jjdDVGZGMCWn9mCV02JTbBJzMKcLa9DuSR1SUm
         qWxPCTAn8PtkuQp+gLEDk7/vwFIIEraZB3XJwc/Uu0QgH4YABH8n5OKtyF58nnyM2GIc
         ujz4P8/mWB9R1ArK8wMyF+HshkUZ2EImGfI/EGuan5eE/gEemdEjURg/6CuqV7zW4rh1
         6pKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=sGLset5Dnp8Ldm8ljmG59AeNAD0Jpi+RPkbtstLQToo=;
        b=APO/ewyxyLPyXVqqrJJWc8dWCBdbhVi3D2ZD4EQWaE5pSI9/0IYO3suM+GNwnXSs6P
         TKHTx8zkopSqNQbdalpb+7eFBH3p3aPGt8Y3YTNqMpBerHFuTBPV0+fqqPJg9Xb/2IXf
         LptdwqVSExSZ/1yYaxpuLnNWj86+uf3V1X0Sr3qmrOssua95zgxgFyguxhYIHargZ7I6
         86Mq4GUTh0KzoLh4/ty8RZ8i8Gevat32ECMhsHVLjp84ovm2LQNfhbEQ/kJMH65mMKzr
         ZoRzjMwTXLKkm1VhRm0ro86djm/X+SY3yik+SIClgbuwJNPHHjtL9AP1QSRVYOaEG9F4
         KNvA==
X-Gm-Message-State: APjAAAXBwz44kpEnMCMCWxohK1tgrzMX2Y3MxRCDp9zhNHf5WnhjlP6e
        8R8i7043aZl5QV5elEn4fF8=
X-Google-Smtp-Source: APXvYqwYCfYSl2mOqjGIno6mvWeGeprpOl98DoBh0A1RpxxfhIbRz/OpirnOEzAEYLABpaxGz9nCSQ==
X-Received: by 2002:a63:f852:: with SMTP id v18mr12224567pgj.71.1573768575963;
        Thu, 14 Nov 2019 13:56:15 -0800 (PST)
Received: from [172.20.189.1] ([2620:10d:c090:180::dd67])
        by smtp.gmail.com with ESMTPSA id h9sm8703390pjh.8.2019.11.14.13.56.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Nov 2019 13:56:15 -0800 (PST)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Jesper Dangaard Brouer" <brouer@redhat.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kernel-team@fb.com,
        ilias.apalodimas@linaro.org
Subject: Re: [net-next PATCH v2 2/2] page_pool: remove hold/release count from
 tracepoints
Date:   Thu, 14 Nov 2019 13:56:14 -0800
X-Mailer: MailMate (1.13r5655)
Message-ID: <9940A2D8-3B91-43D1-9381-C28C0151F4B7@gmail.com>
In-Reply-To: <20191114220715.1ac54ddf@carbon>
References: <20191114163715.4184099-1-jonathan.lemon@gmail.com>
 <20191114163715.4184099-3-jonathan.lemon@gmail.com>
 <20191114220715.1ac54ddf@carbon>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14 Nov 2019, at 13:07, Jesper Dangaard Brouer wrote:
> I will prefer that you do an atomic_inc_return, and send the cnt to the
> existing tracepoint.  I'm not dereferencing the pool in my tracepoint
> use-case, and as Alexei wrote, this would still be 'safe' (as in not
> crashing) for a tracepoint if someone do.

Okay, will make that change, and send out a revision.
-- 
Jonathan
