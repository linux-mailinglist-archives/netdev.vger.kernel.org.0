Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25FD73FD004
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 01:43:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240481AbhHaXon (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 19:44:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231511AbhHaXom (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 19:44:42 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E27E7C061575;
        Tue, 31 Aug 2021 16:43:46 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id b200so1643976iof.13;
        Tue, 31 Aug 2021 16:43:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=0jFGmJARHkZZke9LwBj38mex/WGtRhwPsUDczZDhiE8=;
        b=uZSjHWsmP8t1T9IgreB32thQwUgKKl6Ljtr6T6rDhyTTwAzL9lWIhoKJByJ2G27mmI
         4cERl5WxTY7B93rROCghFgfAuxtiSPYCZ5eVvAn39U+S7sPjg05Spe+DI+64j9SqmPn6
         8UfgR3TaemLitSk6xHuN2bITgiPllG589Tif1ahGDsdRXISfo+y6ewJARt0cJXZYNrCg
         7hiiPxKDe+rhnOtOwjjpPba1snPsvOB1PS+7Lzs9JG1y+n0HRdgGqCfrl+q/I5qZEvD6
         zGgPjOOrAWmLXETlT88lCZ4cEB0ZWwceqBJWLjYvN8SjjXxfX5Ez/x9fKG/uHj5OnojP
         NG6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=0jFGmJARHkZZke9LwBj38mex/WGtRhwPsUDczZDhiE8=;
        b=eK7JgQZxPCNx98Lja107yWSNmuD3YofoCpEwLO4gTKd6I2hP7hyqn373vZRAm7co+Z
         rlIp7w75t1wObtxfQ5neXgdsEigICw/ZsHpeYUehjaA48nQY+d5JGP9J7qpcnds5CRjG
         zEtlOhDX6ZEQqWhP1wsgdJ81ReK8D25a1MOlvitA1vtBjso72Lct67pKLa2WC6NALHGX
         /NYUKNhrLp7NggbuU10NjxePmpWg1jkKCIRb67r0M6YSEmQoDLSNOuuhkCyZcyJqx2ni
         VbPAclLBwxPZUTvnB5O7wYLQ6w7VnPHHfyzPUqUdf4xdEEAx7JmAT8+DJqDxw5U3wUSG
         sgCA==
X-Gm-Message-State: AOAM532t+HvcAWr3tAgfV5Amy2ypYFWzusNlkxpoWFNwXMtZYAcatXlB
        vmkNJofjWohTsS3dicp7MmeGxetSOjs=
X-Google-Smtp-Source: ABdhPJx4jl11RG2f4+BHU2x02mXq17sWmEdJFxIr9RuBKHWrz1ZHO4KYO9sUUx1b03Nk8KsD9jHrgg==
X-Received: by 2002:a02:ba1a:: with SMTP id z26mr5090451jan.98.1630453426248;
        Tue, 31 Aug 2021 16:43:46 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id b3sm11137931ilh.14.2021.08.31.16.43.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Aug 2021 16:43:45 -0700 (PDT)
Date:   Tue, 31 Aug 2021 16:43:39 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Message-ID: <612ebeab58c20_6b87208f2@john-XPS-13-9370.notmuch>
In-Reply-To: <e164977aea87996c2677ff26bafed8109b4ffa53.1629473233.git.lorenzo@kernel.org>
References: <cover.1629473233.git.lorenzo@kernel.org>
 <e164977aea87996c2677ff26bafed8109b4ffa53.1629473233.git.lorenzo@kernel.org>
Subject: RE: [PATCH v12 bpf-next 07/18] xdp: add multi-buff support to
 xdp_return_{buff/frame}
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenzo Bianconi wrote:
> Take into account if the received xdp_buff/xdp_frame is non-linear
> recycling/returning the frame memory to the allocator or into
> xdp_frame_bulk.
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---

Acked-by: John Fastabend <john.fastabend@gmail.com>
