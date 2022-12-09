Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB32D648A0D
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 22:29:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229821AbiLIV31 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 16:29:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbiLIV30 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 16:29:26 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20CD279CBF
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 13:28:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670621304;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NDsEC4ElJaS4x5qdnv5HGOKl+eNNfVfWSQWMXLrqrQo=;
        b=G8DfiZozUfjy2djH3gFnRoCEibwL/fk0lS4rQcc05/P+mmECJwh6XEFLsrd5lAQKwXKV56
        LZL63HGi4m0FtUMuuSHhdHHHLlx+oJ0Y7gq7M56+KeWbr3VuY82+2ysqdE4hXVeiF7doJD
        lcPoAj66YBVt/VL1Aqrx8zYjs3aF+Nk=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-428-dJz3bYyONxq3y0jKO1q1Gg-1; Fri, 09 Dec 2022 16:28:23 -0500
X-MC-Unique: dJz3bYyONxq3y0jKO1q1Gg-1
Received: by mail-wm1-f70.google.com with SMTP id x10-20020a05600c420a00b003cfa33f2e7cso472332wmh.2
        for <netdev@vger.kernel.org>; Fri, 09 Dec 2022 13:28:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NDsEC4ElJaS4x5qdnv5HGOKl+eNNfVfWSQWMXLrqrQo=;
        b=Ub+0zcbrMS95ZWjUPcerclPjr/rb4h3j5iPnK3qHnTglipNXjAA42mTnL/5Y0Mbw97
         XEZPXO2CeCQZu859Tv/DLXpBlAD5IXPCWDXDtXo49auCCRGo66JKtg1uhtU4hgRynBL4
         qNNG8sLIKForz38KGtik1z735PHvcVad9OdrCL/Nz0QqbFrMUHTFB+NGmJ2vbTssV9Xp
         /G0afOoMP0hPTFGJu24b9TNMOZHd3k+DDJXEhswKJu3XN0zlB8Hr7E+CPNtzKoagSjEf
         vMxvuevmIDvXaxcF6mfL95bcAm2B9crPPg8cVt1jclc9t979F2lhrFuXkB5tofOg7XoO
         C9eA==
X-Gm-Message-State: ANoB5pnoz04pdZ8unHWAra6pdj9brqGxGchbaSUKQMROHo7Lr0IBjmcG
        IqWeSb3DfCBFtGbvETrnTvEFrPGXbjyaV3o3nVM6MBSlGNENHL/HHMRI7SxJoLmrQbU0fAerwqQ
        IODSn+TdvoGwVFvgI
X-Received: by 2002:a05:600c:3c92:b0:3cf:a851:d2f2 with SMTP id bg18-20020a05600c3c9200b003cfa851d2f2mr6243189wmb.21.1670621301979;
        Fri, 09 Dec 2022 13:28:21 -0800 (PST)
X-Google-Smtp-Source: AA0mqf634kfY3jodFjtsksLVF5PO21yg86beAx/78gx1j0M8kuBjr26MyXBMRAYSfq/vA8j30HXWfg==
X-Received: by 2002:a05:600c:3c92:b0:3cf:a851:d2f2 with SMTP id bg18-20020a05600c3c9200b003cfa851d2f2mr6243167wmb.21.1670621301799;
        Fri, 09 Dec 2022 13:28:21 -0800 (PST)
Received: from pc-4.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id k21-20020a05600c1c9500b003c6cd82596esm785470wms.43.2022.12.09.13.28.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Dec 2022 13:28:21 -0800 (PST)
Date:   Fri, 9 Dec 2022 22:28:18 +0100
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
Subject: Re: [PATCH net v2 3/3] net: simplify sk_page_frag
Message-ID: <20221209212818.GB10554@pc-4.home>
References: <cover.1670609077.git.bcodding@redhat.com>
 <392d4a3cf4948af266d0cb02934d17c599787a56.1670609077.git.bcodding@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <392d4a3cf4948af266d0cb02934d17c599787a56.1670609077.git.bcodding@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 09, 2022 at 01:19:25PM -0500, Benjamin Coddington wrote:
> Now that in-kernel socket users that may recurse during reclaim have benn
> converted to sk_use_task_frag = false, we can have sk_page_frag() simply
> check that value.

Reviewed-by: Guillaume Nault <gnault@redhat.com>

