Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E71C76E72D3
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 08:04:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231200AbjDSGE3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 02:04:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230153AbjDSGE2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 02:04:28 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C53A59F5
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 23:04:25 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id d9443c01a7336-1a8097c1ccfso11337085ad.1
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 23:04:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681884265; x=1684476265;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=B+H8RhBMogthpmuBbJDww8ooKV/3ijSjF1pDJsm3P10=;
        b=qHnrSRerkvfZ77SZv7yKoiEsxXD5Uehxu1DQJpSa1Js2YpSZVC/t+ggZKLcXUg5sYU
         9I3ER9YaZEKdqNK1iKcg+bPcSbdKTvQgp77trL7rb8fa++giOgFSa0400LJnMTz4OV0j
         85u5iAWvAuzEF0Pt8X7E6tfzdKD2rvRRRmxk6oocKwN8QlDUOaNIy5fd5/s76Tlw+hVP
         bPCaeuIeA8hVR6kYMLyl6Er2TfC1omicxoVSOpXrUtlh3uaw1U3Xh0DEdqnaUZQ7PXCY
         Vo4C6USMuFoxntfvEHiaMDY6PG0qpb7PnTk1EavqXoqBivKfi81cRqYSUYlur3falubH
         AYyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681884265; x=1684476265;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B+H8RhBMogthpmuBbJDww8ooKV/3ijSjF1pDJsm3P10=;
        b=IDk2qYyPqqaQNC1CmTQvqrIkxUDttAAG8riAeQRauyp7ywTWhRSgG70RRzGTLN4bNU
         kvJKEJ+CbrrCa4jMJodSGB3LPOiO8CZmLoJFlTY342VDksuPaqxG3ltc+8N+hpK22B4k
         8c3PZZQo8vrwblkK9zoa/pRUNzZYibBN4iCGRIR6e3vxFuVUVi7ilIw5bznh043uREAr
         3WeGe9QDcxNdky9pzbUvEHyBJiEVjWE1DpLuURne4BjTbNCwXwRBnpKicTC1vkNElJhP
         ydRUoMJWHUT1no10UktQQsDsX5MkYyYDZE7RXtCgWMnfGIDz8VHyW7UIyXDz1JeU8hki
         mYdA==
X-Gm-Message-State: AAQBX9eGGB8y3ZV1n771TYLLyQ4pL3cEKfqo6ki25cTZTlwx1XL3avbZ
        nBcvFijY0FaiEBr1Bnrdf6c=
X-Google-Smtp-Source: AKy350aKzzvX8Q2el2OGBqCAT+kWhawXe7Oxw5pK2ZNcdU5PWKcBVFr+ANEzQtBVzy4t4JheSTseyQ==
X-Received: by 2002:a17:902:e5c1:b0:19f:a694:6d3c with SMTP id u1-20020a170902e5c100b0019fa6946d3cmr5476218plf.55.1681884264950;
        Tue, 18 Apr 2023 23:04:24 -0700 (PDT)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id bb7-20020a170902bc8700b001a686578b44sm10357425plb.110.2023.04.18.23.04.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 23:04:24 -0700 (PDT)
Date:   Wed, 19 Apr 2023 14:04:18 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Liang Li <liali@redhat.com>,
        Simon Horman <simon.horman@corigine.com>,
        Miroslav Lichvar <mlichvar@redhat.com>
Subject: Re: [PATCHv5 net-next] bonding: add software tx timestamping support
Message-ID: <ZD+EYi4zKj4qlj8z@Laptop-X1>
References: <20230418034841.2566262-1-liuhangbin@gmail.com>
 <20230418205023.414275ab@kernel.org>
 <ZD9pbffw3s1HVwvE@Laptop-X1>
 <20230418211746.2aa60760@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230418211746.2aa60760@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 18, 2023 at 09:17:46PM -0700, Jakub Kicinski wrote:
> On Wed, 19 Apr 2023 12:09:17 +0800 Hangbin Liu wrote:
> > > I'll apply Jay's ack from v4 since these are not substantial changes.
> > > Thanks!  
> > 
> > Sorry, not sure if I missed something. bond_ethtool_get_ts_info() could be
> > called without RTNL. And we have ASSERT_RTNL() in v4.
> 
> Are there any documented best practices on when to keep an ack?
> I'm not aware of such a doc, it's a bit of a gray zone.
> IMHO the changes here weren't big enough to drop Jay's tag.

I don't know either. Some times I also struggle on whether I should keep the
ack tag, then I drop the tag just in case the reviewer doesn't agree with my
change.

Anyway, thanks a lot for your patient review and comments.

Regards
Hangbin
