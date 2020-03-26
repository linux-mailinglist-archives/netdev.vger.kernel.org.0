Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F1021935F5
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 03:31:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727740AbgCZCa6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 22:30:58 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50592 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727690AbgCZCa6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 22:30:58 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 327E415B2D569;
        Wed, 25 Mar 2020 19:30:57 -0700 (PDT)
Date:   Wed, 25 Mar 2020 19:30:56 -0700 (PDT)
Message-Id: <20200325.193056.1153970692429454819.davem@davemloft.net>
To:     longman@redhat.com
Cc:     dhowells@redhat.com, jarkko.sakkinen@linux.intel.com,
        jmorris@namei.org, serge@hallyn.com, zohar@linux.ibm.com,
        kuba@kernel.org, keyrings@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-integrity@vger.kernel.org, netdev@vger.kernel.org,
        linux-afs@lists.infradead.org, sumit.garg@linaro.org,
        jsnitsel@redhat.com, roberto.sassu@huawei.com, ebiggers@google.com,
        crecklin@redhat.com
Subject: Re: [PATCH v8 0/2] KEYS: Read keys to internal buffer & then copy
 to userspace
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200322011125.24327-1-longman@redhat.com>
References: <20200322011125.24327-1-longman@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 25 Mar 2020 19:30:58 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Waiman Long <longman@redhat.com>
Date: Sat, 21 Mar 2020 21:11:23 -0400

> The current security key read methods are called with the key semaphore
> held.  The methods then copy out the key data to userspace which is
> subjected to page fault and may acquire the mmap semaphore. That can
> result in circular lock dependency and hence a chance to get into
> deadlock.
> 
> To avoid such a deadlock, an internal buffer is now allocated for getting
> out the necessary data first. After releasing the key semaphore, the
> key data are then copied out to userspace sidestepping the circular
> lock dependency.
> 
> The keyutils test suite was run and the test passed with these patchset
> applied without any falure.

Who will integrate these changes?
