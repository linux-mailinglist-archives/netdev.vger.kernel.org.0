Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25AB25F726E
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 03:04:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232424AbiJGBE1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 21:04:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232416AbiJGBE0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 21:04:26 -0400
Received: from nautica.notk.org (nautica.notk.org [91.121.71.147])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 135CBF1922
        for <netdev@vger.kernel.org>; Thu,  6 Oct 2022 18:04:22 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 5A0BEC01F; Fri,  7 Oct 2022 03:04:21 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1665104661; bh=4PhS/IKoUSCkA//t1LO+OGOn20FJ5HQYa77RDrFnZt4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DX4D7gFB4+BZ5auNM60Wp1xXfO3H5+48oW2IfjDNpIrZMzSxvlEleu6wiagpLcNMv
         VD7Py7ID0himh4R035uLgH18ogbEPPFHcO6GhuhOhtGnEifIx54Zq4R/pS3L4nEQPG
         JEzy+LjWmZoyxJYt8ZLdkhYN5eoCe7gyZFTrFRzwUHNgGW31oaYAPIC3HhTFO1aWGK
         3yThiWnLNjTS9wo2be3EIDhD0mnoO5NiPSomD9QAQN9zSz0LwWzy1oxeb/M4Duwxky
         QpnRbA2MMN7zJIy6jfufWqCfrupucHqcv7ahGur4dTR1TQoV3K5tUZC4xul44D7TGe
         tJPNmk14r1JoQ==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 2508EC009;
        Fri,  7 Oct 2022 03:04:17 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1665104660; bh=4PhS/IKoUSCkA//t1LO+OGOn20FJ5HQYa77RDrFnZt4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=f5yrEMPQ1LsgZt3FGvDTkpir5X/hIkSrWBuoHK5KQuBfHzPmK+EQEbwBWOwLcB+Fv
         ctim+uzeDxzv/L6cDI4Mk4ngNnxLsksTZ8O9BZ6SVAPuxTghiEzCdKZYYpq8oBbw8c
         DHELzEYof2Hi2F4u2jZX1WnNFESXyZE500BI2P8cUWKjXbny3/6Qxx7d3X/3teYAut
         1BkAH5BACYB1ELVvhnaBYPrdrrlA9Wqf/ozfxDcC06O5B58CveUZ8IKNIvLn43G+1p
         neSMNosFrl+TXPLxn8z6NLY478yact8LtEwAdseDXWwdrKqtp09/XkK/2odbAvQIWa
         knTHAyD2GFVXA==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id cb2fb44a;
        Fri, 7 Oct 2022 01:04:15 +0000 (UTC)
Date:   Fri, 7 Oct 2022 10:03:59 +0900
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Christian Schoenebeck <linux_oss@crudebyte.com>
Cc:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        syzbot <syzbot+8b41a1365f1106fd0f33@syzkaller.appspotmail.com>,
        v9fs-developer@lists.sourceforge.net,
        syzkaller-bugs@googlegroups.com, netdev@vger.kernel.org
Subject: Re: [PATCH] 9p/trans_fd: always use O_NONBLOCK read/write
Message-ID: <Yz96//Gf4tCteJLm@codewreck.org>
References: <00000000000039af4d05915a9f56@google.com>
 <000000000000c1d3ca0593128b24@google.com>
 <345de429-a88b-7097-d177-adecf9fed342@I-love.SAKURA.ne.jp>
 <4870107.4IDB3aycit@silver>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4870107.4IDB3aycit@silver>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christian Schoenebeck wrote on Thu, Oct 06, 2022 at 04:55:23PM +0200:
> > diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
> > index e758978b44be..9870597da583 100644
> > --- a/net/9p/trans_fd.c
> > +++ b/net/9p/trans_fd.c
> > @@ -821,11 +821,13 @@ static int p9_fd_open(struct p9_client *client, int
> > rfd, int wfd) goto out_free_ts;
> >  	if (!(ts->rd->f_mode & FMODE_READ))
> >  		goto out_put_rd;
> > +	ts->rd->f_flags |= O_NONBLOCK;
> 
> ... I think this deserves a short comment like:
> 
>     /* prevent hung task with pipes */

Good point, I've sneaked in this comment:
    /* prevent workers from hanging on IO when fd is a pipe */

https://github.com/martinetd/linux/commit/ef575281b21e9a34dfae544a187c6aac2ae424a9


> Reviewed-by: Christian Schoenebeck <linux_oss@crudebyte.com>

Thank you!

--
Dominique
