Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08768598DF5
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 22:27:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345952AbiHRUYu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 16:24:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345876AbiHRUYc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 16:24:32 -0400
Received: from nautica.notk.org (nautica.notk.org [91.121.71.147])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45DDCC59E9;
        Thu, 18 Aug 2022 13:24:00 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id E5566C009; Thu, 18 Aug 2022 22:23:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1660854238; bh=1Tbcrkjzqu+U9fYEHZpYca8y0rlNA7S/6WYu0SQ5PL0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CoqPCdsX34ll437ZR4AZlWknaHCgIRvT6TuiZH7aNfz1ueC/PFJftUtodRYCmKjrM
         HjnQG10YMVGOIYfg+Tt/3YOHr8nUPlC6Jxdj0HMtZRHhSG0g7n62ZCubQX3FNICPFK
         fLsFo0borMkdZQnUn5mGPQtw3Ckg9ishyL+V94kyYER5T6oeQaMYXN979LJTZP6vxW
         xQcG8/DRQuPNZQwfbCUGS33SKvIPv6Hsvik5vvPS25j3mgTsX2OjXeVrRdKPD3Xe32
         YeNG09j1jG6mC2nAocFCX8oRZs46PIh76lsg6xqwBuX4ntGD06Qka1wwvWW/D6PKOo
         dQJX/2IPjSJoA==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 7F6B5C009;
        Thu, 18 Aug 2022 22:23:54 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1660854237; bh=1Tbcrkjzqu+U9fYEHZpYca8y0rlNA7S/6WYu0SQ5PL0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Yc6kHpT+mdVSDXXWK6LOqWQMIuNNMuqZD7uYESmavV1M2unRxBiQ+AtfW5m8nPbQJ
         ou1sBnlmeZ/0ktxsURgpTIjkxuBUF6nJGFfw5P2Mzel+wGFChZvx50RhWRK6zBe47e
         z6ENUiYryqbdIpi62Z6qnnZ/9TNiuoxtntL2d3H6YhA0uDxXX6hoUh/t5C550o/w++
         NRpwizirLPfcPV6zaZ63vAV0iExhazstGWa8FMpTjBigjReRRWCskUxZkGYmILcG1D
         9SGbA1XYMJjI1wMuSlEd7OynKwiNNKuKycM0gi+7tzIt7tZwujFsp491q+EW1RtM2q
         2n05u8LtLsXmQ==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id 66245e06;
        Thu, 18 Aug 2022 20:23:51 +0000 (UTC)
Date:   Fri, 19 Aug 2022 05:23:36 +0900
From:   asmadeus@codewreck.org
To:     Christian Schoenebeck <linux_oss@crudebyte.com>
Cc:     syzbot <syzbot+de52531662ebb8823b26@syzkaller.appspotmail.com>,
        davem@davemloft.net, edumazet@google.com, ericvh@gmail.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org, lucho@ionkov.net,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com,
        v9fs-developer@lists.sourceforge.net
Subject: Re: [syzbot] KASAN: use-after-free Read in p9_req_put
Message-ID: <Yv6fyMxHq1CI5iZf@codewreck.org>
References: <0000000000001c3efc05e6693f06@google.com>
 <YvyD053bdbGE9xoo@codewreck.org>
 <2207113.SgyDDyVIbp@silver>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2207113.SgyDDyVIbp@silver>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christian Schoenebeck wrote on Thu, Aug 18, 2022 at 05:12:17PM +0200:
> > @@ -997,12 +997,8 @@ struct p9_client *p9_client_create(const char
> > *dev_name, char *options)
> > 
> >  	return clnt;
> > 
> > -close_trans:
> > -	clnt->trans_mod->close(clnt);
> > -put_trans:
> > -	v9fs_put_trans(clnt->trans_mod);
> > -free_client:
> > -	kfree(clnt);
> > +out:
> > +	p9_client_destroy(clnt);
> >  	return ERR_PTR(err);
> >  }
> >  EXPORT_SYMBOL(p9_client_create);
> 
> Looks like a nice reduction to me!
> 
> As p9_client_destroy() is doing a bit more than current code, I would probably 
> additionally do s/kmalloc/kzmalloc/ at the start of the function, which would 
> add more safety & reduction.

Good point, I checked the variables p9_client_destroy cares about get
initialized but kzalloc is safer, let's switch that as well.
> > diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
> > index e758978b44be..60fcc6b30b46 100644
> > --- a/net/9p/trans_fd.c
> > +++ b/net/9p/trans_fd.c
> > @@ -205,6 +205,8 @@ static void p9_conn_cancel(struct p9_conn *m, int err)
> >  		list_move(&req->req_list, &cancel_list);
> >  	}
> > 
> > +	spin_unlock(&m->client->lock);
> > +
> >  	list_for_each_entry_safe(req, rtmp, &cancel_list, req_list) {
> >  		p9_debug(P9_DEBUG_ERROR, "call back req %p\n", req);
> >  		list_del(&req->req_list);
> > @@ -212,7 +214,6 @@ static void p9_conn_cancel(struct p9_conn *m, int err)
> >  			req->t_err = err;
> >  		p9_client_cb(m->client, req, REQ_STATUS_ERROR);
> >  	}
> > -	spin_unlock(&m->client->lock);
> >  }
> 
> Are you sure that would resolve that (other) syzbot report? I just had a 
> glimpse at it yet, but I don't see this list iteration portion being involved 
> in the backtrace provided by the report, is it?

It won't fix the inconsistent locking ones, but should take care of
http://lkml.kernel.org/r/000000000000cad57405e5b5dbb7@google.com

ffff888026be2c18 (&clnt->lock){+.+.}-{2:2}, at: p9_conn_cancel+0xaa/0x970 net/9p/trans_fd.c:192
holding the lock in that function, calling
p9_client_cb itself calling p9_req_put and locking again when refcount
hits 0.

And that one has a reproducer, so syzbot will confirm if it helps when I
get around to pushing it (probably this weekend) :)

--
Dominique
