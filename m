Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CDAB882E5
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 20:49:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726457AbfHISty (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 14:49:54 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:39961 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726255AbfHISty (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 14:49:54 -0400
Received: by mail-qk1-f193.google.com with SMTP id s145so72448550qke.7
        for <netdev@vger.kernel.org>; Fri, 09 Aug 2019 11:49:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=iUrDa9xlr1kdUn5ds5c7q1n0Pup2wmUdnH/OoSu2uKo=;
        b=h+oY5UCGi8UQ5xo9sPVpPth93VzBmsp6/77GH/G1l1vCW2SoXowNN4iWtsrHrBheLj
         gCT6eHpk7AyT89EhcXKPCnZvLJN1W31U+Q4SRFpRI6rBrkrdxAIRmKPc5QkTh1VBdmSo
         l8dRTbXpwec3QBv/lLQZ2/1oL9seTVEw8j7MBTEMMnffpAM06ol5Aff0TltJcGbSOjsf
         OpQ9dGoAQvtsWqf/b2Y92bIrrSWH+Xot2IPmx7/Jvk+jkGAp7IrWcWoD7Whqgq9fi06O
         DVqr9MTc1cuLzW5mlDkYBDccA9JML5EYlweOfFzNOju+ogcnLnMnKY/P91YIZT3DNWJu
         68cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=iUrDa9xlr1kdUn5ds5c7q1n0Pup2wmUdnH/OoSu2uKo=;
        b=KSYyByV8HGchq86ZdzdKGEUJYZLVHnYlPHtgCySwOWJbt1wF1RohHiTEAvKCltVUQD
         uGgeQqlL2DUvbzy4TiTkBKqU4GlORAfyAXdq6pQJJtDMyxgRQePRuAIXALCf2PdeOVEz
         7DiKQxst4iyUr7trrhZmbRSgLWMwGbF1kza1GIKtZwY2KaOsBDRIOAja+Hk2LQF50YcH
         YEiM1ZrqgOHcN1yOZu3KvvSPcQTHl/lVNmfMfrNpVkw99CY7t/NtzwY4AJa1GYUqle7h
         xtwLtH8hOq6JXwcPCUuooEeT1n28m7+0JNK4nmU1j+wOSrzsGzHK5+3OoR9apjU97jyb
         Zt4A==
X-Gm-Message-State: APjAAAW/ZdkCdzicz0m/DKOyTC8w1ncdvWXT+OUEWHaPep5rqLQzwnm1
        nrzrwzyiiPlzbfjwnW18Gj718g==
X-Google-Smtp-Source: APXvYqy7+qlNm8AOJaeUG8YCO+F3ewGW2pRO/5ABNXUbC0uMsIV+m06C7+DVownk+CUD07MPRcaE0w==
X-Received: by 2002:a37:805:: with SMTP id 5mr8474162qki.351.1565376593525;
        Fri, 09 Aug 2019 11:49:53 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id j22sm40673261qtp.0.2019.08.09.11.49.52
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 09 Aug 2019 11:49:53 -0700 (PDT)
Date:   Fri, 9 Aug 2019 11:49:50 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Ying Xue <ying.xue@windriver.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <jon.maloy@ericsson.com>, <hdanton@sina.com>,
        <tipc-discussion@lists.sourceforge.net>,
        <syzkaller-bugs@googlegroups.com>
Subject: Re: [PATCH 3/3] tipc: fix issue of calling smp_processor_id() in
 preemptible
Message-ID: <20190809114950.179b565e@cakuba.netronome.com>
In-Reply-To: <1565335017-21302-4-git-send-email-ying.xue@windriver.com>
References: <1565335017-21302-1-git-send-email-ying.xue@windriver.com>
        <1565335017-21302-4-git-send-email-ying.xue@windriver.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 9 Aug 2019 15:16:57 +0800, Ying Xue wrote:
> Fixes: e9c1a793210f ("tipc: add dst_cache support for udp media")
> syzbot+1a68504d96cd17b33a05@syzkaller.appspotmail.com
 ^
Reported-by: missing here?

> Signed-off-by: Hillf Danton <hdanton@sina.com>
> Signed-off-by: Ying Xue <ying.xue@windriver.com>

