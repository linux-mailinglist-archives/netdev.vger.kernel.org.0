Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D4936EEAFD
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 01:30:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236468AbjDYXaf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 19:30:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231391AbjDYXae (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 19:30:34 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83DA4C156;
        Tue, 25 Apr 2023 16:30:32 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id d2e1a72fcca58-63b5465fb99so5348291b3a.1;
        Tue, 25 Apr 2023 16:30:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682465432; x=1685057432;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5RfZ8RVW96CnZSnLPllki9oYfv4BEcxnSUlFKYRwQXQ=;
        b=HBZhB5Pr+baxkN4KvfeOVnht6oYi4lYBsoyZTtXcyoQ3zJ7Ttsb2Iq5I90h983cpKj
         0whpEIArc8Y0d9qx4cx2k49Su4k0xoaOIgNolgcA1mSX9AIg7f1gvn6kYGmHqchJnND3
         E4OSfGTw2GSFuOrtqMkPzD7cN2CkCRiRN4Iv5FXbXSqTodNJNSb5EikZd4O2EqoiTDkA
         T7kez73STABeWE5VDgZPXZ0x30rYAeh5MutQYDOX20W+fIl8OewyweT8mZ9njvxrVmQt
         PJFS4I5VRvAHcwCkdbbU4oO/qORe6N8XPv9FTl2fefRGbknPJN20K0VMEZtizluevRTM
         I6MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682465432; x=1685057432;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5RfZ8RVW96CnZSnLPllki9oYfv4BEcxnSUlFKYRwQXQ=;
        b=AgMQSiNmv+4zqoeKBsyR5iKo9MXl+1A7DsyMdFP/a/UiANYBo81zndLVpX7vYFOYm+
         tfWqwFyQxzys8+QjJQnO5nGzpO8uEo1JVJ+WedRBUN4MqnpSKPzIxT+6AyjHOKPDtuOw
         HeR0GkAUb3UhPkq2vQsIRNQyZZqdLW8Y35wuqWt1xOPjRWzhnTIKhrK/BUg4qzUYmGJw
         hU3jppHPwHL/LRwCRmO57Zf9t4L8kbj0P1O6KpNKIhpGvLA2qCC7HqXYZKQIpjz0SoVC
         7NBcxcte9m/DAaFUPDe2qvNEKT1mzuD/ALPmXZWst4M2gPIx/AVwNDeAPe53S9k2NxZT
         QsXw==
X-Gm-Message-State: AAQBX9evx+JPV3+HqIp3hbz8wPqfBTcvt2R+SivtnsY7BHcKSQdy/BfT
        PfpM4i2NnkMXw15vBp53Jj4=
X-Google-Smtp-Source: AKy350YBdJX5mH2MZXB4lJU8kHJHun1b9ZDPyuxnDLY9ewHVcAuM0DPP0GxDqkjGq7J1xfM/R828Uw==
X-Received: by 2002:a05:6a00:2d20:b0:634:7ba3:d142 with SMTP id fa32-20020a056a002d2000b006347ba3d142mr27631275pfb.10.1682465431903;
        Tue, 25 Apr 2023 16:30:31 -0700 (PDT)
Received: from dhcp-172-26-102-232.dhcp.thefacebook.com ([2620:10d:c090:400::5:f9d6])
        by smtp.gmail.com with ESMTPSA id a11-20020a634d0b000000b004e28be19d1csm8332541pgb.32.2023.04.25.16.30.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Apr 2023 16:30:31 -0700 (PDT)
Date:   Tue, 25 Apr 2023 16:30:27 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        netdev@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        linux-mm@kvack.org, Mel Gorman <mgorman@techsingularity.net>,
        lorenzo@kernel.org,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        linyunsheng@huawei.com, bpf@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, willy@infradead.org
Subject: Re: [PATCH RFC net-next/mm V1 2/3] page_pool: Use static_key for
 shutdown phase
Message-ID: <20230425233027.w3olphld4nkcdvry@dhcp-172-26-102-232.dhcp.thefacebook.com>
References: <168244288038.1741095.1092368365531131826.stgit@firesoul>
 <168244294384.1741095.6037010854411310099.stgit@firesoul>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168244294384.1741095.6037010854411310099.stgit@firesoul>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 25, 2023 at 07:15:43PM +0200, Jesper Dangaard Brouer wrote:
> Performance is very important for page pool (PP). This add the use of
> static_key APIs for regaining a single instruction, which makes the
> new PP shutdown scheme zero impact.
> 
> We are uncertain if this is 100% correct, because static_key APIs uses
> a mutex lock and it is uncertain if all contexts that can return pages
> can support this. We could spawn a workqueue (like we just removed) to
> workaround this issue.

With debug atomic sleep the issue should be trivial to see.
iirc the callers of xdp_flush_frame_bulk() need to do it under rcu_read_lock equivalent,
which is not sleepable and mutex-es should warn.
