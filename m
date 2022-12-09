Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C099F648A0A
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 22:28:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbiLIV2q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 16:28:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229936AbiLIV2h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 16:28:37 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15C567674
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 13:27:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670621256;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MulgF9UUs9jMR6H4jqfRpgOzsyxZo5LhZhFrfEJR8p4=;
        b=Dxow90uCrh14qE9zxTfo84hnIa4gN9+x2UcUji5aaJD/y0ApaxA25+9OXc2FK7zB/lFnLZ
        ychYqdE/VtafEIijhajVo2/b1k6cxM7KjEniQtWsdbZ0rRQ+Ik5c0Iu/HQxy+2VGV5WxjP
        cDRtoueZ2UQBRikvb3FaqLHyk6fXnmU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-185-1SstYVzLPwWvBXtfOqQScg-1; Fri, 09 Dec 2022 16:27:35 -0500
X-MC-Unique: 1SstYVzLPwWvBXtfOqQScg-1
Received: by mail-wm1-f70.google.com with SMTP id ay19-20020a05600c1e1300b003cf758f1617so430159wmb.5
        for <netdev@vger.kernel.org>; Fri, 09 Dec 2022 13:27:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MulgF9UUs9jMR6H4jqfRpgOzsyxZo5LhZhFrfEJR8p4=;
        b=x9LLgsKfif++KZNA7MBjBjLbntzVVDzvcdiPLzDeyLwcvBR+OQnQZHPlnClA6P/2oW
         CfRH56J12bKjUXoH6eHTBvBzMF967MbeY0NMc2su0qQSxX4KCqDJ4Ua37H88ZwFqSl0j
         y1EQ3RTK6tWOlZ83hmlZsVRfMCK/kn/1IAa19dromMN3CV7Cj0Qua5UwFM2pRzBi17Iv
         AaAioKJht4CSZpoKfBwrhSPZjLfpiRzN+Vsm2Nhy2oZkQlfP6tomoe6quUR1yF54hGvT
         YL2w3WJeYIb7OZNxkBtQp8l6reFGWOY+LFgQ73jyGR0bD3rDLeiTnpWuL+fUXXydLSGq
         CW4g==
X-Gm-Message-State: ANoB5pkpmUtCiPdOGMsB9wFR/o3/0O8GhRrhdinY8dZKheEnJd8t6c8W
        PeBZqo2XLLSCTdtTOYGIjsNd49/pirTBdKSzNTX5NG4ouVhgnwqnxLOAmevUodVlyTUpAbo1kXk
        L2ACdXOYF26r0scwa
X-Received: by 2002:a05:600c:539a:b0:3c6:e63e:23d4 with SMTP id hg26-20020a05600c539a00b003c6e63e23d4mr6466890wmb.3.1670621253950;
        Fri, 09 Dec 2022 13:27:33 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6xNFABph4LhGMMu/EX7YDPFbp+wFisO7otIv3SSAxNb5VuzampejScUI/oN2FDddks6KIk+w==
X-Received: by 2002:a05:600c:539a:b0:3c6:e63e:23d4 with SMTP id hg26-20020a05600c539a00b003c6e63e23d4mr6466881wmb.3.1670621253736;
        Fri, 09 Dec 2022 13:27:33 -0800 (PST)
Received: from pc-4.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id z5-20020adff1c5000000b002258235bda3sm2248814wro.61.2022.12.09.13.27.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Dec 2022 13:27:33 -0800 (PST)
Date:   Fri, 9 Dec 2022 22:27:30 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Benjamin Coddington <bcodding@redhat.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Philipp Reisner <philipp.reisner@linbit.com>,
        Lars Ellenberg <lars.ellenberg@linbit.com>,
        Christoph =?iso-8859-1?Q?B=F6hmwalder?= 
        <christoph.boehmwalder@linbit.com>, Jens Axboe <axboe@kernel.dk>,
        Josef Bacik <josef@toxicpanda.com>,
        Keith Busch <kbusch@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>,
        Mike Christie <michael.christie@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Valentina Manea <valentina.manea.m@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        Steve French <sfrench@samba.org>,
        Christine Caulfield <ccaulfie@redhat.com>,
        David Teigland <teigland@redhat.com>,
        Mark Fasheh <mark@fasheh.com>,
        Joel Becker <jlbec@evilplan.org>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Xiubo Li <xiubli@redhat.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Jeff Layton <jlayton@kernel.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net v2 2/3] Treewide: Stop corrupting socket's task_frag
Message-ID: <20221209212730.GA10554@pc-4.home>
References: <cover.1670609077.git.bcodding@redhat.com>
 <f907fca960f6f7393f3393330941621721efb2cc.1670609077.git.bcodding@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f907fca960f6f7393f3393330941621721efb2cc.1670609077.git.bcodding@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 09, 2022 at 01:19:24PM -0500, Benjamin Coddington wrote:
> Since moving to memalloc_nofs_save/restore, SUNRPC has stopped setting the
> GFP_NOIO flag on sk_allocation which the networking system uses to decide
> when it is safe to use current->task_frag.  The results of this are
> unexpected corruption in task_frag when SUNRPC is involved in memory
> reclaim.
> 
> The corruption can be seen in crashes, but the root cause is often
> difficult to ascertain as a crashing machine's stack trace will have no
> evidence of being near NFS or SUNRPC code.  I believe this problem to
> be much more pervasive than reports to the community may indicate.
> 
> Fix this by having kernel users of sockets that may corrupt task_frag due
> to reclaim set sk_use_task_frag = false.  Preemptively correcting this
> situation for users that still set sk_allocation allows them to convert to
> memalloc_nofs_save/restore without the same unexpected corruptions that are
> sure to follow, unlikely to show up in testing, and difficult to bisect.

Reviewed-by: Guillaume Nault <gnault@redhat.com>

