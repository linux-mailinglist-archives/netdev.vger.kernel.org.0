Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E6A3108176
	for <lists+netdev@lfdr.de>; Sun, 24 Nov 2019 03:29:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726784AbfKXC3Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 21:29:24 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:39799 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726719AbfKXC3Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 21:29:24 -0500
Received: by mail-pl1-f194.google.com with SMTP id o9so4878143plk.6
        for <netdev@vger.kernel.org>; Sat, 23 Nov 2019 18:29:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=Z427ifS8zi3jMt3XrCOQvXxcRatGs7IDCgrUzuGYHJQ=;
        b=gazJM87qAWV4O9wxPjX3+qahxNHFa33biZ1U34MQYIoDcglVNvnZqaqoSsO1KcLQut
         FWNv+bhGkTlokn38vikL0l4G3bvu8ws/01mo873Krc6kuhKuBU6HETulVT5nUP1lNKU0
         WigMxZp0MvjW1r9BaBiKSN7FiRTy6A0v5tSgPltnryC+kvIdNRXdx7GMzlXrdg9w6yO5
         0Pcdp0mnchApWGr54HLC2hqm3Kr7XrBCFudgprWIuhDonbW3mm+BuV6uH2HspFfHkJFq
         9WnW275k0JyGkXQ3RRcfbTF1GE7EWGZnqTvPdWfpre7l7dfBzl2q0RJY3SEPvQXj4TNi
         y1MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=Z427ifS8zi3jMt3XrCOQvXxcRatGs7IDCgrUzuGYHJQ=;
        b=uCxXtgl3iJ7ZD3aPf0qQJ/UkPI5dVOcDEnQcmhSACPM/wgN3dO9iaqzqS3v1F8n9qz
         GFu0PiIaFyozrM365ZQGqlFccJTtSptqCcRuIcdFJ8XulJhfGg2oGqhSoos6fJb7Oy8o
         72PL/3WnuYJsSQAlTp/Mz2eoS0uHRfwGJYe9JQi8OifH1wl307nwsocwjHchs8aJonYA
         m79RjbFV4rfUrso7GFYVrtBFy6BBuJhar0RrZjEz/VbN8j4Sw4FOMjgo+OO9cTBi+dtg
         57EF668SD0WupFaUs1wBVTwsnixuexb+1jMWhhefCoagvlyI2RViSbqC4BKrwOufd/WV
         AORA==
X-Gm-Message-State: APjAAAVTzBT2H7TUjPWLk1tUvk79Kr6zQ8hAWqT1D3yOjEFr1CYttiGs
        Xzfj9ua2Fah50+nARNjoJ2OBIQ==
X-Google-Smtp-Source: APXvYqxAkBmQnwImB2wAsFffuDklOL7cM1xcZZfwnEDeQPH017t4uzMJShkwgqypu83MyiBSiULqwA==
X-Received: by 2002:a17:90b:f0c:: with SMTP id br12mr29635156pjb.67.1574562563653;
        Sat, 23 Nov 2019 18:29:23 -0800 (PST)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id j20sm2903893pff.182.2019.11.23.18.29.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Nov 2019 18:29:23 -0800 (PST)
Date:   Sat, 23 Nov 2019 18:29:19 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        davem@davemloft.net,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH net] sctp: cache netns in sctp_ep_common
Message-ID: <20191123182919.310d5bf6@cakuba.netronome.com>
In-Reply-To: <f7ecea746b9238b1c996b51c41b5306e00a3d403.1574481409.git.lucien.xin@gmail.com>
References: <f7ecea746b9238b1c996b51c41b5306e00a3d403.1574481409.git.lucien.xin@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 23 Nov 2019 11:56:49 +0800, Xin Long wrote:
> This patch is to fix a data-race reported by syzbot:
> 
>   BUG: KCSAN: data-race in sctp_assoc_migrate / sctp_hash_obj

> It was caused by rhashtable access asoc->base.sk when sctp_assoc_migrate
> is changing its value. However, what rhashtable wants is netns from asoc
> base.sk, and for an asoc, its netns won't change once set. So we can
> simply fix it by caching netns since created.
> 
> Fixes: d6c0256a60e6 ("sctp: add the rhashtable apis for sctp global transport hashtable")
> Reported-by: syzbot+e3b35fe7918ff0ee474e@syzkaller.appspotmail.com
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied, thank you!
