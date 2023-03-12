Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B94396B62A9
	for <lists+netdev@lfdr.de>; Sun, 12 Mar 2023 02:16:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbjCLBP4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 20:15:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjCLBP4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 20:15:56 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3979146095;
        Sat, 11 Mar 2023 17:15:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=q8g9Gc36WzGAlDORfOWLxxh6+LZLJYqvrVSU3hH/Q7w=; b=pf9cnmmmzaS8uGwru4wAJAdKrl
        NXmkbww4qPUjIyqmSv1oBXsC7IL3TtIpembrZMX9DFMC8cC6r/zZaPCo+csuMgP+9XGOKeua1F/be
        Ip36C9FcTeNIsfd1M+ensjvLBkx3g54HkwXPEBAy8j4mctgBn+F/9Ct0ak/DrlDJLkRkVB2nqS4X3
        LuJmcqt16oKkLQW2XbhXC25AHTIlfA5kVPcFjJaYRgR9kzV/2CRdBS5SpwGTeSfwDCmbVR8+X3+Fa
        qT6igwW8IlBkUoGQs/E5HFV8I8oECWwqIMhsvxhCsGq7qKVLKaP1pLHP5/VQVCN590UYpH0dBsfzr
        Wcfyxzhw==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pbAJL-001d8C-WB; Sun, 12 Mar 2023 01:15:43 +0000
Date:   Sat, 11 Mar 2023 17:15:43 -0800
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Chuck Lever III <chuck.lever@oracle.com>
Cc:     Jeff Layton <jlayton@kernel.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        coverity-bot <keescook@chromium.org>,
        "yzaikin@google.com" <yzaikin@google.com>,
        "j.granados@samsung.com" <j.granados@samsung.com>,
        "patches@lists.linux.dev" <patches@lists.linux.dev>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/5] sunrpc: simplify two-level sysctl registration
 for tsvcrdma_parm_table
Message-ID: <ZA0nvzJuWYPNLR/c@bombadil.infradead.org>
References: <20230311233944.354858-1-mcgrof@kernel.org>
 <20230311233944.354858-2-mcgrof@kernel.org>
 <724097B6-49DD-437E-9273-5BE40C22C3ED@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <724097B6-49DD-437E-9273-5BE40C22C3ED@oracle.com>
Sender: Luis Chamberlain <mcgrof@infradead.org>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 12, 2023 at 01:06:26AM +0000, Chuck Lever III wrote:
> 
> 
> > On Mar 11, 2023, at 6:39 PM, Luis Chamberlain <mcgrof@kernel.org> wrote:
> > 
> > There is no need to declare two tables to just create directories,
> > this can be easily be done with a prefix path with register_sysctl().
> > 
> > Simplify this registration.
> > 
> > Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> 
> I can take this one, but I'm wondering what "tsvcrdma_parm_table"
> is (see the short description).

Heh sorry                                     tsvcrdma_parm_table was
supposed to be                                 svcrdma_parm_table.

Sorry for the typo.

Can you fix or wuold you like me to resend?

  Luis
