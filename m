Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 048C766397E
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 07:49:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbjAJGtq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 01:49:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230252AbjAJGto (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 01:49:44 -0500
Received: from mail-oa1-x31.google.com (mail-oa1-x31.google.com [IPv6:2001:4860:4864:20::31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70E4037257
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 22:49:43 -0800 (PST)
Received: by mail-oa1-x31.google.com with SMTP id 586e51a60fabf-15085b8a2f7so11265044fac.2
        for <netdev@vger.kernel.org>; Mon, 09 Jan 2023 22:49:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=g8yVw/6Q1GYoJFHE+9yp2iddXry6lweiCjtZRhrMrVs=;
        b=afN3xzwfl2Zf8UGBdW8409+DeeF9a2Wwl430dtR3peP5LXuJUmURB4bW8xD6qCWfJe
         wC12rAs0nDODVEr86OlmoUml9kHRurEfLQd3Nz03U3WdHfDMKg3rcG4+73J+nS8n4Vh/
         6cks5Nn5qBH9ycJ+paW5h34zi9Fpkrj5MXgw8dTB+uZCcpMHVEwBCEZPO9/br6vRwmvc
         RGNJjavJBPP2BiHMWEyy6T+qliS4NniTv+e/pouEJN9L829M8H0h93nHSqQr7mphp7as
         8mSPI3SrOhEBoH63yulWZ4SR9R/6o/iNfYtY+78u1qwqyjNMa2vQFeOlnLpHxivE4Zm3
         J6Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g8yVw/6Q1GYoJFHE+9yp2iddXry6lweiCjtZRhrMrVs=;
        b=M3iDKw+AMVIig1p9sy2+3N+P/WEStoLGSU19fFvqgD1yBdtGSdYgOOljP1LjlutOnE
         E5GEC1E9ewR5q4X94qv9hLeEpZnlYdCtry7HmlvUhZ25JQmwXHSQWrjmPDJPrsNO+VD/
         Le2kX1QASM3CtNbVxEkh34iVJqfdIOtrSfbhbn6A1e/IQL7fdKHDcPAI1Gr2JS7O+mq0
         TGPMUgm9fZK1D4MfNPHGsQ5JP1tdFnvHfi/tkJz96QrFa9QOPEpXtcbZC/AYunh/N0Qn
         OGB9wBuPKTL9hZG3o5uOkl6zZ+VIpoekZ+jYqiF9IkZWT6R9y131OfEgraFfcwJpZ1vK
         g8sQ==
X-Gm-Message-State: AFqh2kqRPkAOuAs55te2NOP1NDnMPRb0lsG/FuupIoom7tgBSGEuRLUf
        o0d9QkR7HZl562UZFUl8wOwfooxtJ4w=
X-Google-Smtp-Source: AMrXdXsMDFXzmlcsK0zBidLuXEwXkl/horyBz/LUODb30kvLWyrMJyplr0kagLKPSHbB6omnxOBcJg==
X-Received: by 2002:a05:6870:7810:b0:15b:a3dc:d626 with SMTP id hb16-20020a056870781000b0015ba3dcd626mr1101827oab.58.1673333382753;
        Mon, 09 Jan 2023 22:49:42 -0800 (PST)
Received: from localhost ([2600:1700:65a0:ab60:d533:b3bd:1109:bf8c])
        by smtp.gmail.com with ESMTPSA id h4-20020a4aa284000000b004db65419011sm5217868ool.34.2023.01.09.22.49.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jan 2023 22:49:41 -0800 (PST)
Date:   Mon, 9 Jan 2023 22:49:41 -0800
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     netdev@vger.kernel.org, g.nault@alphalink.fr,
        Cong Wang <cong.wang@bytedance.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [Patch net 1/2] l2tp: convert l2tp_tunnel_list to idr
Message-ID: <Y70KhcGV5twckdxj@pop-os.localdomain>
References: <20230105191339.506839-1-xiyou.wangcong@gmail.com>
 <20230105191339.506839-2-xiyou.wangcong@gmail.com>
 <Y7nMo02WWWwoGmv0@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y7nMo02WWWwoGmv0@debian>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 07, 2023 at 08:48:51PM +0100, Guillaume Nault wrote:
> On Thu, Jan 05, 2023 at 11:13:38AM -0800, Cong Wang wrote:
> > +int l2tp_tunnel_create(struct net *net, int fd, int version, u32 tunnel_id,
> > +		       u32 peer_tunnel_id, struct l2tp_tunnel_cfg *cfg,
> > +		       struct l2tp_tunnel **tunnelp)
> >  {
> >  	struct l2tp_tunnel *tunnel = NULL;
> >  	int err;
> >  	enum l2tp_encap_type encap = L2TP_ENCAPTYPE_UDP;
> > +	struct l2tp_net *pn = l2tp_pernet(net);
> >  
> >  	if (cfg)
> >  		encap = cfg->encap;
> >  
> > +	spin_lock_bh(&pn->l2tp_tunnel_idr_lock);
> > +	err = idr_alloc_u32(&pn->l2tp_tunnel_idr, NULL, &tunnel_id, tunnel_id,
> > +			    GFP_ATOMIC);
> > +	if (err) {
> > +		spin_unlock_bh(&pn->l2tp_tunnel_idr_lock);
> > +		return err;
> > +	}
> > +	spin_unlock_bh(&pn->l2tp_tunnel_idr_lock);
> 
> Why reserving the tunnel_id in l2tp_tunnel_create()? This function is
> supposed to just allocate a structure and pre-initialise some fields.
> The only cleanup required upon error after this call is to kfree() the
> new structure. So I can't see any reason to guarantee the id will be
> accepted by the future l2tp_tunnel_register() call.
> 
> Looks like you could reserve the id at the beginning of
> l2tp_tunnel_register() instead. That'd avoid changing the API and thus
> the side effects on l2tp_{ppp,netlink}.c. Also we wouldn't need create
> l2tp_tunnel_remove().
> 

The idr_replace() is guaranteed to succeed in terms of ID allocation.
So either way could work, but I think you are right that the patch could
be smaller if we do it in l2tp_tunnel_register().

Thanks.
